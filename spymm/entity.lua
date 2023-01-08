---@class parsers
local parsers = {}

local EntityStateNames = {
    [ 0] = "N_IDLE",
    [ 1] = "B_IDLE",
    [ 2] = "N_DEAD",
    [ 3] = "B_DEAD",
    [ 4] = "EVT",
    [ 5] = "CHOCOBO",
    [ 6] = "FISHING",
    [ 7] = "POL",
    [ 8] = "D_OPEN",
    [ 9] = "D_CLOSE",
    [10] = "L1",
    [11] = "L2",
    [12] = "L3",
    [13] = "L4",
    [14] = "L5",
    [15] = "L6",
    [16] = "L7",
    [17] = "L8",
    [18] = "M1",
    [19] = "M2",
    [20] = "M3",
    [21] = "M4",
    [22] = "M5",
    [23] = "M6",
    [24] = "M7",
    [25] = "M8",
    [26] = "ES0",
    [27] = "ES1",
    [28] = "ES2",
    [29] = "ES3",
    [30] = "ES4",
    [31] = "ES5",
    [32] = "RLOG",
    [33] = "CAMP",
    [34] = "EFF0",
    [35] = "EFF1",
    [36] = "EFF2",
    [37] = "EFF3",
    [38] = "FISHING1",
    [39] = "FISHING2",
    [40] = "FISHING3",
    [41] = "FISHING4",
    [42] = "FISHING5",
    [43] = "FISHING6",
    [44] = "ITEMMAKE",
    [45] = "D_OPEN2",
    [46] = "D_CLOSE2",
    [47] = "SIT",
    [48] = "ICRYSTALL",
    [49] = "MANNEQUIN",
    [50] = "FISH_2",
    [51] = "FISHF",
    [52] = "FISHR",
    [53] = "FISHL",
    [54] = "GEOM0",
    [55] = "FURNITURE0",
    [56] = "FISH_3",
    [57] = "FISH_31",
    [58] = "FISH_32",
    [59] = "FISH_33",
    [60] = "FISH_34",
    [61] = "FISH_35",
    [62] = "FISH_36",
    [63] = "CHAIR00",
    [64] = "CHAIR01",
    [65] = "CHAIR02",
    [66] = "CHAIR03",
    [67] = "CHAIR04",
    [68] = "CHAIR05",
    [69] = "CHAIR06",
    [70] = "CHAIR07",
    [71] = "CHAIR08",
    [72] = "CHAIR09",
    [73] = "CHAIR10",
    [74] = "CHAIR11",
    [75] = "CHAIR12",
    [76] = "CHAIR13",
    [77] = "CHAIR14",
    [78] = "CHAIR15",
    [79] = "CHAIR16",
    [80] = "CHAIR17",
    [81] = "CHAIR18",
    [82] = "CHAIR19",
    [83] = "CHAIR20",
    [84] = "RANGE",
    [85] = "MOUNT",
}

local EntityStates = {
    N_IDLE = 0,
    B_IDLE = 1,
    N_DEAD = 2,
    B_DEAD = 3,
    EVT = 4,
    CHOCOBO = 5,
    FISHING = 6,
    POL = 7,
    D_OPEN = 8,
    D_CLOSE = 9,
    L1 = 10,
    L2 = 11,
    L3 = 12,
    L4 = 13,
    L5 = 14,
    L6 = 15,
    L7 = 16,
    L8 = 17,
    M1 = 18,
    M2 = 19,
    M3 = 20,
    M4 = 21,
    M5 = 22,
    M6 = 23,
    M7 = 24,
    M8 = 25,
    ES0 = 26,
    ES1 = 27,
    ES2 = 28,
    ES3 = 29,
    ES4 = 30,
    ES5 = 31,
    RLOG = 32,
    CAMP = 33,
    EFF0 = 34,
    EFF1 = 35,
    EFF2 = 36,
    EFF3 = 37,
    FISHING1 = 38,
    FISHING2 = 39,
    FISHING3 = 40,
    FISHING4 = 41,
    FISHING5 = 42,
    FISHING6 = 43,
    ITEMMAKE = 44,
    D_OPEN2 = 45,
    D_CLOSE2 = 46,
    SIT = 47,
    ICRYSTALL = 48,
    MANNEQUIN = 49,
    FISH_2 = 50,
    FISHF = 51,
    FISHR = 52,
    FISHL = 53,
    GEOM0 = 54,
    FURNITURE0 = 55,
    FISH_3 = 56,
    FISH_31 = 57,
    FISH_32 = 58,
    FISH_33 = 59,
    FISH_34 = 60,
    FISH_35 = 61,
    FISH_36 = 62,
    CHAIR00 = 63,
    CHAIR01 = 64,
    CHAIR02 = 65,
    CHAIR03 = 66,
    CHAIR04 = 67,
    CHAIR05 = 68,
    CHAIR06 = 69,
    CHAIR07 = 70,
    CHAIR08 = 71,
    CHAIR09 = 72,
    CHAIR10 = 73,
    CHAIR11 = 74,
    CHAIR12 = 75,
    CHAIR13 = 76,
    CHAIR14 = 77,
    CHAIR15 = 78,
    CHAIR16 = 79,
    CHAIR17 = 80,
    CHAIR18 = 81,
    CHAIR19 = 82,
    CHAIR20 = 83,
    RANGE = 84,
    MOUNT = 85,
}

---@param fourCC integer
---@return string
local function toFourCCStr(fourCC)
    return string.format('%c%c%c%c',
        bit.band(bit.rshift(fourCC, 0), 0xFF),
        bit.band(bit.rshift(fourCC, 8), 0xFF),
        bit.band(bit.rshift(fourCC, 16), 0xFF),
        bit.band(bit.rshift(fourCC, 24), 0xFF))
end

local function extractName(s)
    -- living dangerous version
    local l = 0

    if s[0] == 1 then
        -- for certain classes of entities, byte 0x34=1 is used for extended-length names
        l = l + 1
    end

    if s[l] < 0x21 then
        return ''
    end

    local name = ''
    while s[l] > 0 do
        name = name .. string.format('%c', s[l])
        l = l + 1
    end

    return name
end

---@param p EntityUpdatePacket
parsers.entityUpdatePacket = function (row, p)
    printf('%s: T:%03X EID:%8d EIDX:%4d L:%02X\n', row.created_at, row.type, p.EntityId, p.EntityIndex, string.len(row.data))

    if p.UpdateFlags08 or p.UpdateFlags40 then
        if p.EntityType == 0 or p.EntityType == 5 or p.EntityType == 6 then
            local Name = extractName(p.Name0)
            printf('                     Name: "%s"\n', Name)
        elseif p.EntityType == 1 or p.EntityType == 7 then
            local Name = extractName(p.Name1)
            printf('                     Name: "%s"\n', Name)
        else
            local Name = 'Unknown For This Type!'
            printf('                     Name: "%s"\n', Name)
        end
    end

    printf('                     01:%d 02:%d 04:%d 08:%d 10:%d 20:%d 40:%d 80:%d\n',
        p.UpdateFlags01 and 1 or 0, p.UpdateFlags02 and 1 or 0,
        p.UpdateFlags04 and 1 or 0, p.UpdateFlags08 and 1 or 0,
        p.UpdateFlags10 and 1 or 0, p.UpdateFlags20 and 1 or 0,
        p.UpdateFlags40 and 1 or 0, p.UpdateFlags80 and 1 or 0)

    if p.UpdateFlags01 then
        printf('           Update01: X:%5.5f Y:%5.5f Z:%5.5f R:%3d\n', p.PosX, p.PosY, p.PosZ, p.Rotation)
        printf('                     CE:%3d MS:%3d AS:%3d\n', p.CursorEntityIndex, p.MovementSpeed, p.AnimationSpeed)
        printf('                     1800:%4d 1813:%d 1814:%d 1815:%d\n', p._18_0, p._18_13, p._18_14, p._18_15)
        printf('                     2000:%d 2001:%d 2002:%d\n', p._20_0, p._20_1, p._20_2);
    end

    if p.UpdateFlags02 then
        printf('           Update02: CL:%8d\n', p.ClaimEntityId)
        if not p.UpdateFlags01 then
            printf('                   2000:%d 2001:%d 2002:%d\n', p._20_0, p._20_1, p._20_2);
        end
    end

    if p.UpdateFlags04 then
        printf('           Update04: MS:%d TR:%3d HP:%3d ST:%s RQ:%d\n', p.ModelSize, p.TargetRadius, p.HPP, EntityStateNames[p.ServerStatus], p.RequiredEntity and 1 or 0)
        if not p.UpdateFlags01 and not p.UpdateFlags02 then
            printf('                   2000:%d 2001:%d 2002:%d\n', p._20_0, p._20_1, p._20_2);
        end
    end

    if p.EntityType == 0 then
        printf('             Type %d: ModelId:%5d\n', p.EntityType, p.ModelId)
    end

    if p.EntityType == 1 or p.EntityType == 7 then
        printf('             Type %d: Face:%2d Race:%2d\n', p.EntityType, p.Face, p.Race)
        if p.UpdateFlags10 then
            printf('                     Head:%5d Body:%5d Hand:%5d Legs:%5d Feet:%5d Main:%5d Sub:%5d Rngd:%d/%5d\n',
                bit.band(p.HeadModelId, 0xfff),
                bit.band(p.BodyModelId, 0xfff),
                bit.band(p.HandsModelId, 0xfff),
                bit.band(p.LegsModelId, 0xfff),
                bit.band(p.FeetModelId, 0xfff),
                bit.band(p.MainModelId, 0xfff),
                bit.band(p.SubModelId, 0xfff),
                bit.rshift(p.RangedModelId, 12),
                bit.band(p.RangedModelId, 0xfff))
        end
    end

    if p.EntityType == 2 or p.EntityType == 3 then
        printf('             Type %d: ModelId:%5d FourCC:%s SeqStart:%10d SeqLength:%5d 3E:%02X\n',
            p.EntityType, p.ModelId, toFourCCStr(p.FourCC), p.SeqStart, p.SeqLength, p._3E)
    end

    if p.EntityType == 4 then
        printf('             Type %d: ModelId:%5d SeqModelId:%5d SeqStart:%10d SeqLength:%5d 3E:%02X\n',
            p.EntityType, p.ModelId, p.SeqModelId, p.SeqStart, p.SeqLength, p._3E)
    end

    if p.EntityType == 5 or p.EntityType == 6 then
        printf('             Type %d: ModelId:%5d\n', p.EntityType, p.ModelId)
    end
end

---@param p PositionPacket
parsers.positionPacket = function (row, p)
    printf('%s: T:%03X EID:%8d EIDX:%4d\n', row.created_at, row.type, p.EntityId, p.EntityIndex)
    printf('                     X:%5.5f Y:%5.5f Z:%5.5f R:%3d\n', p.X, p.Y, p.Z, p.Rotation)
    printf('                     M:%2d U0:%02X\n', p.Mode, p.Unknown0)
end

return parsers
