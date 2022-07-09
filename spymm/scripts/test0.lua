---@class PacketFilter
local script = {}

function script:process(row, p)
    if row.kind == 4 then
        if row.type == 0x00A then
            return true
        end

        if row.type == 0x00E then
            ---@cast p EntityUpdatePacket
            if p.UpdateFlags04 and p.RequiredEntity then
                return true
            end
        end
    end

    return false
end

return script
