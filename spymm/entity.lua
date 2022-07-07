---@class parsers
local parsers = {}

local EntityStateNames = {
    [0] = "N_IDLE",
    "B_IDLE",
    "N_DEAD",
    "B_DEAD",
    "EVT",
    "CHOCOBO",
    "FISHING",
    "POL",
    "D_OPEN",
    "D_CLOSE",
    "L1",
    "L2",
    "L3",
    "L4",
    "L5",
    "L6",
    "L7",
    "L8",
    "M1",
    "M2",
    "M3",
    "M4",
    "M5",
    "M6",
    "M7",
    "M8",
    "ES0",
    "ES1",
    "ES2",
    "ES3",
    "ES4",
    "ES5",
    "RLOG",
    "CAMP",
    "EFF0",
    "EFF1",
    "EFF2",
    "EFF3",
    "FISHING1",
    "FISHING2",
    "FISHING3",
    "FISHING4",
    "FISHING5",
    "FISHING6",
    "ITEMMAKE",
    "D_OPEN2",
    "D_CLOSE2",
    "SIT",
    "ICRYSTALL",
    "MANNEQUIN",
    "FISH_2",
    "FISHF",
    "FISHR",
    "FISHL",
    "GEOM0",
    "FURNITURE0",
    "FISH_3",
    "FISH_31",
    "FISH_32",
    "FISH_33",
    "FISH_34",
    "FISH_35",
    "FISH_36",
    "CHAIR00",
    "CHAIR01",
    "CHAIR02",
    "CHAIR03",
    "CHAIR04",
    "CHAIR05",
    "CHAIR06",
    "CHAIR07",
    "CHAIR08",
    "CHAIR09",
    "CHAIR10",
    "CHAIR11",
    "CHAIR12",
    "CHAIR13",
    "CHAIR14",
    "CHAIR15",
    "CHAIR16",
    "CHAIR17",
    "CHAIR18",
    "CHAIR19",
    "CHAIR20",
    "RANGE",
    "MOUNT",
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

    printf('                     CL:%8d 01:%d 02:%d 04:%d 08:%d 10:%d 20:%d 40:%d 80:%d\n',
        p.ClaimEntityId,
        p.UpdateFlags01 and 1 or 0, p.UpdateFlags02 and 1 or 0,
        p.UpdateFlags04 and 1 or 0, p.UpdateFlags08 and 1 or 0,
        p.UpdateFlags10 and 1 or 0, p.UpdateFlags20 and 1 or 0,
        p.UpdateFlags40 and 1 or 0, p.UpdateFlags80 and 1 or 0)

    if p.UpdateFlags01 then
        printf('           Update01: X:%5.5f Y:%5.5f Z:%5.5f R:%3d\n', p.PosX, p.PosY, p.PosZ, p.Rotation)
        printf('                     CE:%3d MS:%3d AS:%3d\n', p.CursorEntityIndex, p.MovementSpeed, p.AnimationSpeed)
        printf('                     1800:%4d 1813:%d 1814:%d 1815:%d\n', p._18_0, p._18_13, p._18_14, p._18_15)
    end

    if p.UpdateFlags02 then

    end

    if p.UpdateFlags04 then
        printf('           Update04: MS:%d TR:%3d HP:%3d ST:%s RQ:%d\n', p.ModelSize, p.TargetRadius, p.HPP, EntityStateNames[p.ServerStatus], p.RequiredEntity and 1 or 0)
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
