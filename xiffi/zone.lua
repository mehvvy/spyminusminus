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
---@field Weather integer
---@field PrevWeather integer
---@field VanaMinute integer
---@field PrevVanaMinute integer
---@field TransitionLength integer
---@field PrevTransitionLength integer
local ZoneInPacket = {}

ffi.cdef[[
    typedef struct ZoneInPacket {
        u8 unimplemented[0x68];
        u16 Weather;
        u16 PrevWeather;
        u32 VanaMinute;
        u32 PrevVanaMinute;
        u16 TransitionLength;
        u16 PrevTransitionLength;
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
