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

---@class SetSendDelayPacket
---@field SendDelay integer
local SetSendDelayPacket = {}

ffi.cdef[[
    typedef struct SetSendDelayPacket {
        u32 SendDelay;
    } SetSendDelayPacket;
]]
