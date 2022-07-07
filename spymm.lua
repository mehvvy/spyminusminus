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

-- example filter for testing
local function filter(row, p)
    if row.kind == 4 then
        if row.type == 0x00A then
            return true
        end

        if row.type == 0x00E then
            ---@cast p EntityUpdatePacket
            if p.UpdateFlags04 and p.RequiredEntity then
                return true
            end
        end
    end

    return false
end

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

        if filter(row, p) then
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

db:close()
