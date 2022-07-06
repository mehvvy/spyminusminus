local ffi = require('ffi')

ffi.cdef[[
    typedef int8_t s8;
    typedef int16_t s16;
    typedef int32_t s32;

    typedef uint8_t u8;
    typedef uint16_t u16;
    typedef uint32_t u32;

    typedef uint8_t undefined;
    typedef uint16_t undefined2;
    typedef uint32_t undefined4;
]]

---@class ZoneInPacket
---@field ZoneInEventFileId integer
---@field ZoneInEventZoneId integer
---@field ZoneInEventId integer
---@field ZoneInEventFlags0 integer
---@field Weather integer
---@field PrevWeather integer
---@field VanaMinute integer
---@field PrevVanaMinute integer
---@field TransitionLength integer
---@field PrevTransitionLength integer
---@field SubZoneId integer
local ZoneInPacket = {}

ffi.cdef[[
    typedef struct ZoneInPacket {
        u8 unimplemented0[0x40];
        u16 ZoneInEventFileId;
        u8 unimplemented1[0x20];
        u16 ZoneInEventZoneId;
        u16 ZoneInEventId;
        u16 ZoneInEventFlags0;
        u16 Weather;
        u16 PrevWeather;
        u32 VanaMinute;
        u32 PrevVanaMinute;
        u16 TransitionLength;
        u16 PrevTransitionLength;
        u8 unimplemented2[0x9E - 0x78];
        u16 SubZoneId;
    } ZoneInPacket;
]]

---@class WeatherPacket
---@field VanaMinute integer
---@field Weather integer
---@field TransitionLength integer
local WeatherPacket = {}

ffi.cdef[[
    typedef struct WeatherPacket {
        u32 Header;
        u32 VanaMinute;
        u16 Weather;
        u16 TransitionLength;
    } WeatherPacket;
]]
