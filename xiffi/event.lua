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

---@class EventPacket
---@field EntityId integer
---@field EntityIndex integer
---@field ZoneId integer
---@field EventId integer
---@field EventZoneId integer
---@field Flags0 integer
---@field Flags1 integer
local EventPacket = {}

ffi.cdef[[
    typedef struct EventPacket {
        u32 Header;
        u32 EntityId;
        u16 EntityIndex;
        u16 ZoneId;
        u16 EventId;
        u16 Flags0;
        u16 EventZoneId;
        u16 Flags1;
    } EventPacket;
]]

---@class EventStringPacket
---@field EntityId integer
---@field EntityIndex integer
---@field ZoneId integer
---@field EventId integer
---@field Flags0 integer
---@field Strings string[4]
---@field data table
---@field Params integer[8]
local EventStringPacket = {}

ffi.cdef[[
    typedef struct EventStringPacket {
        u32 Header;
        u32 EntityId;
        u16 EntityIndex;
        u16 ZoneId;
        u16 EventId;
        u16 Flags0;
        union {
            u8 Strings[4][16];
            u32 data[4][4];
        };
        u32 Params[8];
    } EventStringPacket;
]]

---@class EventParamPacket
---@field EntityId integer
---@field EntityIndex integer
---@field ZoneId integer
---@field EventId integer
---@field EventZoneId integer
---@field Flags0 integer
---@field Flags1 integer
---@field Params integer[8]
local EventParamPacket = {}

ffi.cdef[[
    typedef struct EventParamPacket {
        u32 Header;
        u32 EntityId;
        u32 Params[8];
        u16 EntityIndex;
        u16 ZoneId;
        u16 EventId;
        u16 Flags0;
        u16 EventZoneId;
        u16 Flags1;
    } EventParamPacket;
]]

---@class EventUpdatePacket
---@field Params integer[8]
local EventUpdatePacket = {}

ffi.cdef[[
    typedef struct EventUpdatePacket {
        u32 Header;
        u32 Params[8];
    } EventUpdatePacket;
]]

---@class EventUpdateStringPacket
---@field Strings string[4]
---@field data table
local EventUpdateStringPacket = {}

ffi.cdef[[
    typedef struct EventUpdateStringPacket {
        u32 Header;
        u8 unused[0x24];
        union {
            u8 Strings[4][16];
            u32 data[4][4];
        };
    } EventUpdateStringPacket;
]]

---@class ReleasePacket
---@field Type integer
---@field EventId integer
local ReleasePacket = {}

ffi.cdef[[
    typedef struct ReleasePacket {
        u32 Header;
        u32 Type : 8;
        u32 EventId : 24;
    } ReleasePacket;
]]

---@class Message3BPacket
---@field EntityId integer
---@field EntityIndex integer
---@field MessageId integer
---@field ShowName boolean
local Message3BPacket = {}

ffi.cdef[[
    typedef struct Message3BPacket {
        u32 Header;
        u32 EntityId;
        u16 EntityIndex;
        u16 MessageId : 15;
        bool ShowName : 1;
    } Message3BPacket;
]]

--- also see ZoneInPacket

---
--- Outgoing
---

-- 5B
---@class EventFinishPacket
---@field EntityId integer
---@field EntityIndex integer
---@field ZoneId integer
---@field EventId integer
---@field IsUpdate boolean
---@field EventResult integer
local EventFinishPacket = {}

ffi.cdef[[
    typedef struct EventFinishPacket {
        u32 Header;
        u32 EntityId;
        u32 EventResult;
        u16 EntityIndex;
        u16 IsUpdate;
        u16 ZoneId;
        u16 EventId;
    } EventFinishPacket;
]]
