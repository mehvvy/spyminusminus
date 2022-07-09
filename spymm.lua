local argparse = require('argparse')
local sqlite3 = require('lsqlite3')

local xiffi = require('xiffi/xiffi')

local parsers = require('spymm/parsers')

local iParsers = {
    [0x00A] = parsers.zoneInPacket,

    [0x00E] = parsers.entityUpdatePacket,

    [0x032] = parsers.eventPacket,
    [0x033] = parsers.eventStringPacket,
    [0x034] = parsers.eventParamPacket,

    [0x052] = parsers.releasePacket,

    [0x057] = parsers.weatherPacket,

    [0x05B] = parsers.positionPacket,
    [0x05C] = parsers.eventUpdatePacket,
    [0x05D] = parsers.eventUpdateStringPacket,

    [0x065] =  parsers.positionPacket,
}

local oParsers = {

}

local iPacketTypes = {
    [0x00A] = xiffi.toZoneInPacket,

    [0x00E] = xiffi.toEntityUpdatePacket,

    [0x032] = xiffi.toEventPacket,
    [0x033] = xiffi.toEventStringPacket,
    [0x034] = xiffi.toEventParamPacket,

    [0x052] = xiffi.toReleasePacket,

    [0x057] = xiffi.toWeatherPacket,

    [0x05B] = xiffi.toPositionPacket,
    [0x05C] = xiffi.toEventUpdatePacket,
    [0x05D] = xiffi.toEventUpdateStringPacket,

    [0x065] = xiffi.toPositionPacket,
}

local oPacketTypes = {

}

local function printf(fmt, ...)
    io.write(string.format(fmt, ...))
end

local parser = argparse('spymm', 'Packet extractor')
parser:argument('database', 'Packet database')

local args = parser:parse()

local ret, db, _errCode, errMsg = pcall(function ()
    return sqlite3.open(args.database, sqlite3.OPEN_READONLY)
end)

if not (ret and db) then
    printf('%s: unable to open "%s": %s\n', arg[0], args.database, db or errMsg)
    return
end

---@param filename string
---@return PacketFilter?, string?
local function fromfile(filename)
    local env = {
    }

    local s, err = loadfile(filename, 't', env)

    if err then
        return nil, err
    end
    if not s then
        -- to satisy the typechecker
        return nil, 'failed to load'
    end

    local res, obj = pcall(s)
    if not res then
        return nil, obj
    end

    return obj
end

---@param script PacketFilter
local function start(script)
    if script.start then
        local pret, fret = pcall(script.start)
        return pret and fret
    end
    return true
end

---@param script PacketFilter
local function finish(script)
    if script.finish then
        local pret, fret = pcall(script.finish)
        return pret and fret
    end
    return true
end

---@param script PacketFilter
local function beginsession(script)
    if script.beginsession then
        local pret, fret = pcall(script.beginsession)
        return pret and fret
    end
    return true
end

---@param script PacketFilter
local function endsession(script)
    if script.endsession then
        local pret, fret = pcall(script.endsession)
        return pret and fret
    end
    return true
end

---@param script PacketFilter
---@return boolean
local function process(script, row, p)
    local pret, fret = pcall(script.process)
    return pret and fret
end

local testscripts = {}

local function loadtestscripts()
    local testfiles = {
        './spymm/scripts/test0.lua',
        './spymm/scripts/test1.lua',
        './spymm/scripts/test2.lua',
        './spymm/scripts/test3.lua',
        './spymm/scripts/test4.lua',
    }

    for _, filename in ipairs(testfiles) do
        local s, e = fromfile(filename)

        if not s then
            error(e)
        end

        testscripts[filename] = s
    end
end

local function testcall(fn, ...)
    local success = false -- true, just a placeholder until the actual json functionality is working.
    for _, s in pairs(testscripts) do
        if s[fn] then
            local pret, fret = pcall(s[fn], s, ...)
            if not pret then
                error(fret)
            end
            success = success or fret
        end
    end

    return success
end

loadtestscripts()

testcall('start')

testcall('beginsession')

for row in db:nrows('SELECT created_at, kind, type, data FROM entry WHERE kind IN (4,5) ORDER BY ticks') do
    local input = false
    local conv = nil

    if row.kind == 4 then
        -- server to client
        input = true
        conv = iPacketTypes[row.type]
    elseif row.kind == 5 then
        -- client to server
        conv = oPacketTypes[row.type]
    end

    if conv ~= nil then
        local p = conv(row.data)

        if testcall('process', row, p) then
            if row.kind == 4 then
                f = iParsers[row.type]
            elseif row.kind == 5 then
                f = oParsers[row.type]
            end

            if f ~= nil then
                f(row, p)
            end
        end
    end
end

testcall('endsession')

db:close()

testcall('finish')
