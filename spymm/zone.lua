---@class parsers
local parsers = {}

---@param p ZoneInPacket
parsers.zoneInPacket = function (row, p)
    printf('%s: T:%03X\n', row.created_at, row.type)
    printf('                     SZ:%5d ER:%5d\n', p.SubZoneId, p.ZoneInEntitiesRequired)
    printf('                     EV:%5d ZO:%4d EZ:%4d F0:%04X F1:%04X\n', p.ZoneInEventId, p.ZoneInEventZoneId, p.ZoneInEventFileId, p.ZoneInEventFlags0, 0)
    printf('                     PV:%7d PW:%2d PT:%3d\n', p.PrevVanaMinute, p.PrevWeather, p.PrevTransitionLength)
    printf('                     CV:%7d CW:%2d CT:%3d\n', p.VanaMinute, p.Weather, p.TransitionLength)
end

---@param p WeatherPacket
parsers.weatherPacket = function (row, p)
    printf('%s: T:%03X\n', row.created_at, row.type)
    printf('                     CV:%7d CW:%2d CT:%3d\n', p.VanaMinute, p.Weather, p.TransitionLength)
end

return parsers
