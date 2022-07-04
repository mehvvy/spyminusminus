---@class parsers
local parsers = {}

---@param s string
---@param maxLength integer
---@return string
local function extractString(s, maxLength)
    local name = ''
    local l = 0
    while s[l] > 0 and l < maxLength do
        name = name .. string.format('%c', s[l])
        l = l + 1
    end

    return name
end

---@param p EventPacket
parsers.eventPacket = function (row, p)
    printf('%s: T:%03X EID:%8d EIDX:%4d\n', row.created_at, row.type, p.EntityId, p.EntityIndex)
    printf('                     EV:%5d ZO:%4d EZ:%4d F0:%04X F1:%04X\n', p.EventId, p.ZoneId, p.EventZoneId, p.Flags0, p.Flags1)
end

---@param p EventStringPacket
parsers.eventStringPacket = function (row, p)
    printf('%s: T:%03X EID:%8d EIDX:%4d\n', row.created_at, row.type, p.EntityId, p.EntityIndex)
    printf('                     EV:%5d ZO:%4d EZ:%4d F0:%04X F1:%04X\n', p.EventId, p.ZoneId, p.ZoneId, p.Flags0, 0)
    printf('                     S0:%s\n', extractString(p.Strings[0], 16))
    printf('                     S1:%s\n', extractString(p.Strings[1], 16))
    printf('                     S2:%s\n', extractString(p.Strings[2], 16))
    printf('                     S3:%s\n', extractString(p.Strings[3], 16))

    if bit.band(p.Flags0, 0x0008) ~= 0 then
        printf('                     P0:%08X P1:%08X P2:%08X P3:%08X\n', p.Params[0], p.Params[1], p.Params[2], p.Params[3])
        printf('                     P4:%08X P5:%08X P6:%08X P7:%08X\n', p.Params[4], p.Params[5], p.Params[6], p.Params[7])
    end
end

---@param p EventParamPacket
parsers.eventParamPacket = function (row, p)
    printf('%s: T:%03X EID:%8d EIDX:%4d\n', row.created_at, row.type, p.EntityId, p.EntityIndex)
    printf('                     EV:%5d ZO:%4d EZ:%4d F0:%04X F1:%04X\n', p.EventId, p.ZoneId, p.EventZoneId, p.Flags0, p.Flags1)
    printf('                     P0:%08X P1:%08X P2:%08X P3:%08X\n', p.Params[0], p.Params[1], p.Params[2], p.Params[3])
    printf('                     P4:%08X P5:%08X P6:%08X P7:%08X\n', p.Params[4], p.Params[5], p.Params[6], p.Params[7])
end

---@param p ReleasePacket
parsers.releasePacket = function (row, p)
    printf('%s: T:%03X TYPE:%02X EV:%5d\n', row.created_at, row.type, p.Type, p.EventId)
end

---@param p EventUpdatePacket
parsers.eventUpdatePacket = function (row, p)
    printf('%s: T:%03X\n', row.created_at, row.type)
    printf('                     P0:%08X P1:%08X P2:%08X P3:%08X\n', p.Params[0], p.Params[1], p.Params[2], p.Params[3])
    printf('                     P4:%08X P5:%08X P6:%08X P7:%08X\n', p.Params[4], p.Params[5], p.Params[6], p.Params[7])
end

---@param p EventUpdateStringPacket
parsers.eventUpdateStringPacket = function (row, p)
    printf('%s: T:%03X\n', row.created_at, row.type)
    printf('                     S1:%s\n', extractString(p.Strings[0], 16))
    printf('                     S1:%s\n', extractString(p.Strings[1], 16))
    printf('                     S2:%s\n', extractString(p.Strings[2], 16))
    printf('                     S3:%s\n', extractString(p.Strings[3], 16))
end

return parsers
