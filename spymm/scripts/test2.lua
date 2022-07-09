---@class PacketFilter
local script = {}

function script:process(row, p)
    if row.kind == 4 then
        if row.type == 0x00A then
            ---@cast p ZoneInPacket
            if p.ZoneInEventId ~= 0 then
                return true
            end
            return false
        end

        if row.type == 0x032 then
            return true
        end

        if row.type == 0x033 then
            return true
        end

        if row.type == 0x034 then
            return true
        end
    end

    return false
end

return script
