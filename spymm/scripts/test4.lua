---@class PacketFilter
local script = {}

function script:process(row, p)
    if row.kind == 4 then
        if row.type == 0x00E then
            ---@cast p EntityUpdatePacket
            if p.EntityType == 4 then
                return true
            end
        end
    end

    return false
end

return script
