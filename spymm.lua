local argparse = require('argparse')
local sqlite3 = require('lsqlite3')

local xiffi = require('xiffi/xiffi')
local parsers = require('spymm/parsers')

local iParsers = {
    [0x00A] = function (row)
        local p = xiffi.toZoneInPacket(row.data)

        parsers.zoneInPacket(row, p)
    end,

    [0x00E] = function (row)
        local p = xiffi.toEntityUpdatePacket(row.data)

        parsers.entityUpdatePacket(row, p)
    end,

    [0x032] = function (row)
        local p = xiffi.toEventPacket(row.data)

        parsers.eventPacket(row, p)
    end,

    [0x033] = function (row)
        local p = xiffi.toEventStringPacket(row.data)

        parsers.eventStringPacket(row, p)
    end,

    [0x034] = function (row)
        local p = xiffi.toEventParamPacket(row.data)

        parsers.eventParamPacket(row, p)
    end,

    [0x052] = function (row)
        local p = xiffi.toReleasePacket(row.data)

        parsers.releasePacket(row, p)
    end,

    [0x057] = function (row)
        local p = xiffi.toWeatherPacket(row.data)

        parsers.weatherPacket(row, p)
    end,

    [0x05B] = function (row)
        local p = xiffi.toPositionPacket(row.data)

        parsers.positionPacket(row, p)
    end,

    [0x05C] = function (row)
        local p = xiffi.toEventUpdatePacket(row.data)

        parsers.eventUpdatePacket(row, p)
    end,

    [0x05D] = function (row)
        local p = xiffi.toEventUpdateStringPacket(row.data)

        parsers.eventUpdateStringPacket(row, p)
    end,

    [0x065] = function (row)
        local p = xiffi.toPositionPacket(row.data)

        parsers.positionPacket(row, p)
    end,
}

local oParsers = {

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

for row in db:nrows('SELECT created_at, kind, type, data FROM entry WHERE kind IN (4,5) ORDER BY ticks') do
    local f = nil

    if row.kind == 4 then
        f = iParsers[row.type]
    elseif row.kind == 5 then
        f = oParsers[row.type]
    end

    if f ~= nil then
        f(row)
    end
end

db:close()
