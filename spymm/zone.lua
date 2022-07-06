---@class parsers
local parsers = {}

---@param p ZoneInPacket
parsers.zoneInPacket = function (row, p)
    printf('%s: T:%03X\n', row.created_at, row.type)
    printf('                     PV:%7d PW:%2d PT:%3d\n', p.PrevVanaMinute, p.PrevWeather, p.PrevTransitionLength)
    printf('                     CV:%7d CW:%2d CT:%3d\n', p.VanaMinute, p.Weather, p.TransitionLength)
end

---@param p WeatherPacket
parsers.weatherPacket = function (row, p)
    printf('%s: T:%03X\n', row.created_at, row.type)
    printf('                     CV:%7d CW:%2d CT:%3d\n', p.VanaMinute, p.Weather, p.TransitionLength)
end

return parsers
