local ffi = require('ffi')

---@class xiffi
local xiffi = {}

-- todo - replace the event classes with https://github.com/atom0s/XiEvents
ffi.cdef[[
typedef unsigned char   undefined;

typedef unsigned int    ImageBaseOffset32;
typedef unsigned char    bool8;
typedef unsigned char    byte;
typedef unsigned int    dword;

typedef char    sbyte;
typedef unsigned char    uchar;
typedef unsigned int    uint;
typedef unsigned int    uint3;
typedef unsigned long    ulong;
typedef unsigned long long    ulonglong;
typedef unsigned char    undefined1;
typedef unsigned short    undefined2;
typedef unsigned int    undefined3;
typedef unsigned int    undefined4;
typedef unsigned long long    undefined5;
typedef unsigned long long    undefined6;
typedef unsigned long long    undefined8;
typedef unsigned short    ushort;
typedef short    wchar_t;
typedef unsigned short    word;
typedef struct AutoClass1 AutoClass1, *PAutoClass1;

typedef struct EventInstance EventInstance, *PEventInstance;

typedef struct EventLocalWorkZone EventLocalWorkZone, *PEventLocalWorkZone;

typedef struct VEC4 VEC4, *PVEC4;

struct VEC4 {
    float x;
    float y;
    float z;
    float w;
};

struct EventInstance {
    word Priority;
    word PC;
    struct VEC4 Position;
    short field3_0x14;
    byte EventIndex;
    byte State;
    float TimeCounter;
    dword CallerNPCId;
};

struct XiEvent {
    word NPCIndex0;
    word NPCIndex1;
    dword NPCId0;
    dword NPCId1;
    undefined field4_0xc;
    undefined field5_0xd;
    undefined field6_0xe;
    undefined field7_0xf;
    word * EventEntry;
    undefined field9_0x14;
    undefined field10_0x15;
    undefined field11_0x16;
    undefined field12_0x17;
    undefined field13_0x18;
    undefined field14_0x19;
    undefined field15_0x1a;
    undefined field16_0x1b;
    int * Constants;
    byte * bytecode;
    struct EventInstance EventInstance[16];
    short PriorityOverride;
    word PCOverride;
    undefined field22_0x228;
    undefined field23_0x229;
    undefined field24_0x22a;
    undefined field25_0x22b;
    undefined field26_0x22c;
    undefined field27_0x22d;
    undefined field28_0x22e;
    undefined field29_0x22f;
    undefined field30_0x230;
    undefined field31_0x231;
    undefined field32_0x232;
    undefined field33_0x233;
    undefined field34_0x234;
    undefined field35_0x235;
    undefined field36_0x236;
    undefined field37_0x237;
    undefined field38_0x238;
    undefined field39_0x239;
    byte EntryOverride;
    undefined field41_0x23b;
    undefined field42_0x23c;
    undefined field43_0x23d;
    undefined field44_0x23e;
    undefined field45_0x23f;
    dword EnityIdOverride;
    word callStackIndex;
    word callStack[8];
    word pc;
    word stackIndex;
    bool8 halted;
    bool8 InEvent;
    struct EventLocalWorkZone * OrigLocalWorkZone;
    struct EventLocalWorkZone * LocalWorkZone;
    int LWZReferenceCount;
};

struct EventLocalWorkZone {
    dword Memory[80];
    struct VEC4 Position;
    struct VEC4 Rotation;
    byte field3_0x160;
    byte field4_0x161;
    bool8 field5_0x162;
    undefined field6_0x163;
    ushort SpeakerIndex;
    undefined field8_0x166;
    undefined field9_0x167;
    float MovementSpeed;
    float AnimationSpeed;
    undefined field12_0x170;
    undefined field13_0x171;
    undefined field14_0x172;
    undefined field15_0x173;
    undefined field16_0x174;
    undefined field17_0x175;
    undefined field18_0x176;
    undefined field19_0x177;
    undefined field20_0x178;
    undefined field21_0x179;
    undefined field22_0x17a;
    undefined field23_0x17b;
    undefined field24_0x17c;
    undefined field25_0x17d;
    undefined field26_0x17e;
    undefined field27_0x17f;
    dword WaitingForInstanceEntry;
    dword InstanceId;
};

struct PlaceholderModelType {
    byte tmp0[0x754];
    float ModelSize[4];
    byte tmp1[0x878 - 0x764];
    byte Cib[0x26];
    byte tmp2[0xc0c - 0x878 - 0x26];
};

]]

---@class XiEvent
---@field pc integer
---@field bytecode table

---@class PlaceholderModelType
---@field ModelSize number[4]
---@field Cib integer[38]

--- Cast away the ffi.cdata* type
---@param ptr integer
---@return any
local function cast(ct, ptr)
    return ffi.cast(ct, ptr)
end

---@param ptr integer
---@return XiEvent
xiffi.toXiEvent = function (ptr)
    return cast('struct XiEvent*', ptr)
end

---@param ptr integer
---@return PlaceholderModelType
xiffi.toPlaceholderModelType = function (ptr)
    return cast('struct PlaceholderModelType*', ptr)
end

--- Entity

require('xiffi.entity')

---@param ptr integer
---@return EntityUpdatePacket
xiffi.toEntityUpdatePacket = function (ptr)
    return cast('EntityUpdatePacket*', ptr)
end

---@param ptr integer
---@return PositionPacket
xiffi.toPositionPacket = function (ptr)
    return cast('PositionPacket*', ptr)
end

--- Event

require('xiffi.event')

---@param ptr integer
---@return EventPacket
xiffi.toEventPacket = function (ptr)
    return cast('EventPacket*', ptr)
end

---@param ptr integer
---@return EventStringPacket
xiffi.toEventStringPacket = function (ptr)
    return cast('EventStringPacket*', ptr)
end

---@param ptr integer
---@return EventParamPacket
xiffi.toEventParamPacket = function (ptr)
    return cast('EventParamPacket*', ptr)
end

---@param ptr integer
---@return EventUpdatePacket
xiffi.toEventUpdatePacket = function (ptr)
    return cast('EventUpdatePacket*', ptr)
end

---@param ptr integer
---@return EventUpdateStringPacket
xiffi.toEventUpdateStringPacket = function (ptr)
    return cast('EventUpdateStringPacket*', ptr)
end

---@param ptr integer
---@return ReleasePacket
xiffi.toReleasePacket = function (ptr)
    return cast('ReleasePacket*', ptr)
end

--- System

require('xiffi.system')

---@param ptr integer
---@return SetSendDelayPacket
xiffi.toSetSendDelayPacket = function (ptr)
    return cast('SetSendDelayPacket*', ptr)
end

--- Zone

require('xiffi.zone')

---@param ptr integer
---@return ZoneInPacket
xiffi.toZoneInPacket = function (ptr)
    return cast('ZoneInPacket*', ptr)
end

---@param ptr integer
---@return WeatherPacket
xiffi.toWeatherPacket = function (ptr)
    return cast('WeatherPacket*', ptr)
end

return xiffi
