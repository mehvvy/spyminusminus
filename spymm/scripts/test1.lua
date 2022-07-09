---@class PacketFilter
local script = {}

function script:process(row, p)
    if row.kind == 4 then
        if row.type == 0x00A then
            return true
        end

        if row.type == 0x057 then
            return true
        end
    end

    return false
end

return script
