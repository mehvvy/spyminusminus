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
---@field ZoneId integer
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
---@field ZoneInEntitiesRequired integer
---@field MenuConfigFlags integer
---@field ChatFilterFlags0 integer
---@field ChatFilterFlags1 integer
---@field Unknown100 integer
local ZoneInPacket = {}

ffi.cdef[[
    typedef struct ZoneInPacket {
        u8 unimplemented0[0x30];
        u32 ZoneId; // 0x30
        u8 unimplemented5[0x40 - 0x34];
        u16 ZoneInEventFileId; // 0x40
        u8 unimplemented1[0x62 - 0x42];
        u16 ZoneInEventZoneId; // 0x62
        u16 ZoneInEventId; // 0x64
        u16 ZoneInEventFlags0; // 0x66
        u16 Weather; // 0x68
        u16 PrevWeather; // 0x6a
        u32 VanaMinute; // 0x6c
        u32 PrevVanaMinute; // 0x70
        u16 TransitionLength; // 0x74
        u16 PrevTransitionLength; // 0x76
        u8 unimplemented2[0x9E - 0x78];
        u16 SubZoneId; // 0x9e
        u8 unimplemented3[0xAC - 0xA0];
        u16 ZoneInEntitiesRequired; // 0xac
        u8 unimplemented4[0xF4 - 0xAE];
        u32 MenuConfigFlags; // 0xf4
        u32 ChatFilterFlags0; // 0xf8
        u32 ChatFilterFlags1; // 0xfc
        u32 Unknown100; // 0x100 (for debug only? ROM requirements?)
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
