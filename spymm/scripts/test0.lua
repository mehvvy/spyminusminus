---@class PacketFilter
local script = {}

function script:start()
    self.out = {}
end

function script:finish()
    return self.out
end

function script:beginsession()
    self.ZoneId = nil
end

function script:process(row, p)
    if row.kind == 4 then
        if row.type == 0x00A then
            ---@cast p ZoneInPacket
            self.ZoneId = tostring(p.ZoneId)

            local out = self.out
            if not out[self.ZoneId] then
                out[self.ZoneId] = {
                    n = p.ZoneInEntitiesRequired,
                    e = {},
                }
            end
            return true
        end

        if row.type == 0x00E then
            if self.ZoneId then
                ---@cast p EntityUpdatePacket
                if p.UpdateFlags04 and p.RequiredEntity then
                    local out = self.out

                    if out[self.ZoneId] then
                        out[self.ZoneId].e[tostring(p.EntityId)] = true
                    end

                    return true
                end
            end
        end
    end

    return false
end

return script
