local ffi = require('ffi')

--- 00E: Entity Update

---@class EntityUpdatePacket
---@field EntityId integer
---@field EntityIndex integer
---@field UpdateFlags01 boolean
---@field UpdateFlags02 boolean
---@field UpdateFlags04 boolean
---@field UpdateFlags08 boolean
---@field UpdateFlags10 boolean
---@field UpdateFlags20 boolean
---@field UpdateFlags40 boolean
---@field UpdateFlags80 boolean
---@field Rotation integer
---@field PosX number
---@field PosY number
---@field PosZ number
---@field Flags0 integer
---@field _18_0 integer
---@field _18_13 integer
---@field _18_14 integer
---@field _18_15 integer
---@field RequiredEntity boolean
---@field CursorEntityIndex integer
---@field Flags1 integer
---@field MovementSpeed integer
---@field AnimationSpeed integer
---@field HPP integer
---@field ServerStatus integer
---@field Flags2 integer
---@field _20_0 integer
---@field _20_1 integer
---@field _20_2 integer
---@field _20_3 integer
---@field _20_4 integer
---@field _20_5 integer
---@field _20_8 integer
---@field ModelSize integer
---@field _20_11 integer
---@field _20_12 integer
---@field _20_13 integer
---@field _20_14 integer
---@field _20_15 integer
---@field _20_16 integer
---@field _20_17 integer
---@field _20_18 integer
---@field _20_19 integer
---@field _20_20 integer
---@field _20_21 integer
---@field _20_24 integer
---@field _20_27 integer
---@field _20_28 integer
---@field _20_29 integer
---@field _20_30 integer
---@field _20_31 integer
---@field Flags3 integer
---@field _24_0 integer
---@field TargetRadius integer
---@field _24_16 integer
---@field _24_20 integer
---@field _24_24 integer
---@field _24_25 integer
---@field _24_26 integer
---@field _24_27 integer
---@field _24_28 integer
---@field _24_29 integer
---@field _24_30 integer
---@field _24_31 integer
---@field Flags4 integer
---@field _28_0 integer
---@field _28_1 integer
---@field _28_2 integer
---@field _28_3 integer
---@field _28_4 integer
---@field _28_5 integer
---@field _28_6 integer
---@field _28_7 integer
---@field _28_8 integer
---@field _28_16 integer
---@field _28_18 integer
---@field _28_19 integer
---@field _28_20 integer
---@field _28_21 integer
---@field _28_22 integer
---@field _28_23 integer
---@field _28_24 integer
---@field _28_25 integer
---@field _28_26 integer
---@field _28_27 integer
---@field _28_28 integer
---@field _28_29 integer
---@field _28_30 integer
---@field _28_31 integer
---@field ClaimEntityId integer
---@field EntityType integer
---@field _30_3 integer
---@field ModelId integer
---@field Face integer
---@field Race integer
---@field HeadModelId integer
---@field BodyModelId integer
---@field HandsModelId integer
---@field LegsModelId integer
---@field FeetModelId integer
---@field MainModelId integer
---@field SubModelId integer
---@field RangedModelId integer
---@field FourCC integer
---@field SeqModelId integer
---@field SeqStart integer
---@field SeqLength integer
---@field _3E integer
---@field Name0 integer[]
---@field Name1 integer[]
local EntityUpdatePacket = {}

--[[
flag relevancy guide

byte o.    bit o.      length      update       name
18              0          13           1       ?
18             13           1           1       ?
18             14           1           1       ?
18             15           1           1       ?
18             16           1           4       RequiredEntity
18             17          15           1       CursorEntityIndex
1C              0           8           1       MovementSpeed?
1C              8           8           1       AnimationSpeed?
1C             16           8           4       HPP?
1C             24           8           4       ServerStatus
20              0           1           1,2,4   ?
20              1           1           1,2,4   ?
20              2           1           1,2,4   ?
20              3           1           ?       ? (unused?)
20              4           1           4       ?
20              5           3           4       ?
20              8           1           4       ?
20              9           2           4       ModelSize
20             11           1           4       ?
20             12           1           4       ?
20             13           1           4       ?
20             14           1           4       ?
20             15           1           4       ?
20             16           1           4       ?
20             17           1           4       ?
20             18           1           4       ?
20             19           1           4       ?
20             20           1           4       ?
20             21           3           ?       ? (unused?)
20             24           3           4       ?
20             27           1           ?       ? (unused?)
20             28           1           4       ?
20             29           1           4       ?
20             30           1           4       ?
20             31           1           4       ?
24              0           8           4       ?
24              8           8           4       TargetRadius
24             16           4           4       ?
24             20           4           ?       ? (unused?)
24             24           1           4       ?
24             25           1           4       ?
24             26           1           ?       ? (unused?)
24             27           1           4       ?
24             28           1           4       ?
24             29           1           4       ?
24             30           1           4       ?
24             31           1           4       ?
28              0           1           4       ?
28              1           1           ?       ? (unused?)
28              2           1           4       ?
28              3           1           4       ?
28              4           1           4       ?
28              5           1           4       ?
28              6           1           4       ?
28              7           1           4       ?
28              8           8           4       ?
28             16           2           4       ?
28             18           1           ?       ? (unused?)
28             19           1           4       ?
28             20           1           ?       ? (unused?)
28             21           1           4       ?
28             22           1           4       ?
28             23           1           ?       ? (unused?)
28             24           1           4       ?
28             25           1           4       ?
28             26           1           4       ?
28             27           1           4       ?
28             28           1           4       ?
28             29           1           4       ?
28             30           1           4       ?
28             31           1           4       ?
]]

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

    typedef struct EntityUpdatePacket {
        u32 Header;

        u32 EntityId;
        u16 EntityIndex;

        bool UpdateFlags01 : 1;
        bool UpdateFlags02 : 1;
        bool UpdateFlags04 : 1;
        bool UpdateFlags08 : 1;
        bool UpdateFlags10 : 1;
        bool UpdateFlags20 : 1;
        bool UpdateFlags40 : 1;
        bool UpdateFlags80 : 1;

        u8 Rotation;

        float PosX;
        float PosY;
        float PosZ;

        union {
            struct {
                u32 _18_0  : 13;
                u32 _18_13 : 1;
                u32 _18_14 : 1;
                u32 _18_15 : 1;
                bool RequiredEntity : 1; // Used by ZoneInPacket.ZoneInEntitiesRequired
                u32 CursorEntityIndex : 15;
            };
            u32 Flags0;
        };

        union {
            struct {
                u32 MovementSpeed : 8;
                u32 AnimationSpeed : 8;
                u32 HPP : 8;
                u32 ServerStatus : 8;
            };
            u32 Flags1;
        };

        union {
            struct {
                u32 _20_0 : 1;
                u32 _20_1 : 1;
                u32 _20_2 : 1;
                u32 _20_3 : 1;
                u32 _20_4 : 1;
                u32 _20_5 : 3;
                u32 _20_8 : 1;
                u32 ModelSize : 2;
                u32 _20_11: 1;
                u32 _20_12: 1;
                u32 _20_13: 1;
                u32 _20_14: 1;
                u32 _20_15: 1;
                u32 _20_16: 1;
                u32 _20_17: 1;
                u32 _20_18: 1;
                u32 _20_19: 1;
                u32 _20_20: 1;
                u32 _20_21: 3;
                u32 _20_24: 3;
                u32 _20_27: 1;
                u32 _20_28: 1;
                u32 _20_29: 1;
                u32 _20_30: 1;
                u32 _20_31: 1;
            };
            u32 Flags2;
        };

        union {
            struct {
                u32 _24_0 : 8;
                u32 TargetRadius : 8;
                u32 _24_16 : 4;
                u32 _24_20 : 4;
                u32 _24_24 : 1;
                u32 _24_25 : 1;
                u32 _24_26 : 1;
                u32 _24_27 : 1;
                u32 _24_28 : 1;
                u32 _24_29 : 1;
                u32 _24_30 : 1;
                u32 _24_31 : 1;
            };
            u32 Flags3;
        };

        union {
            struct {
               u32 _28_0 : 1;
               u32 _28_1 : 1;
               u32 _28_2 : 1;
               u32 _28_3 : 1;
               u32 _28_4 : 1;
               u32 _28_5 : 1;
               u32 _28_6 : 1;
               u32 _28_7 : 1;
               u32 _28_8 : 8;
               u32 _28_16 : 2;
               u32 _28_18 : 1;
               u32 _28_19 : 1;
               u32 _28_20 : 1;
               u32 _28_21 : 1;
               u32 _28_22 : 1;
               u32 _28_23 : 1;
               u32 _28_24 : 1;
               u32 _28_25 : 1;
               u32 _28_26 : 1;
               u32 _28_27 : 1;
               u32 _28_28 : 1;
               u32 _28_29 : 1;
               u32 _28_30 : 1;
               u32 _28_31 : 1;
            };
            u32 Flags4;
        };

        u32 ClaimEntityId;

        /* Entity Type / Appearance */

        /*
           work around padding and split the struct into two
           separate unions.
          */

        u16 EntityType : 3;
        u16 _30_3 : 13;

        union {
            /*
              Entity Types 0, 5 and 6
             */
            struct {
               u16 ModelId;
            };

            /*
              Entity Types 1 and 7
             */
            struct {
                u8 Face;
                u8 Race;
            };
        };

        union {

            struct {
                char Name0[];
            };

            /*
              Entity Types 1 and 7
             */
            struct {
                u16 HeadModelId;
                u16 BodyModelId;
                u16 HandsModelId;
                u16 LegsModelId;
                u16 FeetModelId;
                u16 MainModelId;
                u16 SubModelId;
                u16 RangedModelId;
                char Name1[];
            };

            /*
              Entity Types 2, 3, 4
             */
            struct {
                union {
                    u32 FourCC;
                    u32 SeqModelId;
                };

                u32 SeqStart;
                u16 SeqLength;
                u16 _3E;
            };
        };
    } EntityUpdatePacket;
]]

--- 5B: Position, 65: Cutscene Position

---@class PositionPacket
---@field EntityId integer
---@field EntityIndex integer
---@field Mode integer
---@field X number
---@field Y number
---@field Z number
---@field Rotation integer
---@field Unknown0 integer
local PositionPacket = {}

ffi.cdef[[

    typedef struct PositionPacket {
        u32 Header;
        float X;
        float Y;
        float Z;
        u32 EntityId;
        u16 EntityIndex;
        u8 Mode;
        u8 Rotation;
        undefined field11_0x18;
        undefined field12_0x19;
        undefined field13_0x1a;
        undefined field14_0x1b;
        u8 Unknown0;
        undefined field16_0x1d;
        undefined field17_0x1e;
        undefined field18_0x1f;
    } PositionPacket;
]]
