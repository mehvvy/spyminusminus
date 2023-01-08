local argparse = require('argparse')
local sqlite3 = require('lsqlite3')
local json = require('cjson')

local xiffi = require('xiffi/xiffi')

local parsers = require('spymm/parsers')

local iParsers = {
    [0x00A] = parsers.zoneInPacket,

    [0x00E] = parsers.entityUpdatePacket,

    [0x032] = parsers.eventPacket,
    [0x033] = parsers.eventStringPacket,
    [0x034] = parsers.eventParamPacket,

    [0x03B] = nil,

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

    [0x03B] = xiffi.toMessage3BPacket,

    [0x052] = xiffi.toReleasePacket,

    [0x057] = xiffi.toWeatherPacket,

    [0x05B] = xiffi.toPositionPacket,
    [0x05C] = xiffi.toEventUpdatePacket,
    [0x05D] = xiffi.toEventUpdateStringPacket,

    [0x065] = xiffi.toPositionPacket,
}

local oPacketTypes = {
    [0x05B] = xiffi.toEventFinishPacket,
}

local function printf(fmt, ...)
    io.write(string.format(fmt, ...))
end

local parser = argparse('spymm', 'Packet extractor')
parser:argument('script', 'Packet script')
parser:argument('output', 'Script output')
parser:argument('database', 'Packet database'):args('+')

local args = parser:parse()

-- as a safety measure, check thgat the output filename ends in ".json"
if not args.output:find('[.]json', -5) then
    error('Output file extension is .not ".json"')
end

---@param filename string
---@return PacketFilter?, string?
local function fromfile(filename)
    local env = {
        bit = bit,

        printf = printf,

        ipairs = ipairs,
        pairs = pairs,

        tonumber = tonumber,
        tostring = tostring,
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
        local pret, fret = pcall(script.start, script)
        if not pret then
            error(fret)
        end
        return pret and fret
    end
    return true
end

---@param script PacketFilter
---@return table|nil
local function finish(script)
    if script.finish then
        local pret, fret = pcall(script.finish, script)
        if not pret then
            error(fret)
        end
        if pret then
            return fret
        end
    end
    return nil
end

---@param script PacketFilter
local function beginsession(script)
    if script.beginsession then
        local pret, fret = pcall(script.beginsession, script)
        if not pret then
            error(fret)
        end
        return pret and fret
    end
    return true
end

---@param script PacketFilter
local function endsession(script)
    if script.endsession then
        local pret, fret = pcall(script.endsession, script)
        if not pret then
            error(fret)
        end
        return pret and fret
    end
    return true
end

---@param script PacketFilter
---@return boolean
local function process(script, row, p)
    local pret, fret = pcall(script.process, script, row, p)
    if not pret then
        error(fret)
    end
    return pret and fret
end

local script, err = fromfile(args.script)
if not script then
    error(err)
end

start(script)

for i, database in ipairs(args.database) do
    printf('Loading "%s" (%d of %d)...\n', database, i, #args.database)
    local ret, db, _errCode, errMsg = pcall(function ()
        return sqlite3.open(database, sqlite3.OPEN_READONLY)
    end)

    if not (ret and db) then
        printf('%s: unable to open "%s": %s\n', arg[0], database, db or errMsg)
    else
        printf('Parsing "%s"...\n', database)

        beginsession(script)

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
                process(script, row, p)
    --[[
                    if row.kind == 4 then
                        f = iParsers[row.type]
                    elseif row.kind == 5 then
                        f = oParsers[row.type]
                    end

                    if f ~= nil then
                        f(row, p)
                    end
    ]]
            end
        end

        endsession(script)

        db:close()
    end
end

local out = finish(script)
if out then
    local f = io.open(args.output, "wt")
    if not f then
        error('Unable to open output file for writing')
    end

    f:write(json.encode(out))
    f:close()
end
