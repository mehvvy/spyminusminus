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
    self.SubZoneId = nil
end

function script:endsession()
end

function script:process(row, p)
    if row.kind == 4 then
        if row.type == 0x00A then
            ---@cast p ZoneInPacket
            self.ZoneId = p.ZoneId
            self.SubZoneId = p.SubZoneId

            return true
        end

        if row.type == 0x03B then
            ---@cast p Message3BPacket
            printf("3B: Z:%3d SZ:%3d E:%10d I:%4d M:%5d S:%d\n", self.ZoneId or 0, self.SubZoneId or 0, p.EntityId, p.EntityIndex, p.MessageId, p.ShowName and 1 or 0)
            if self.ZoneId ~= nil then
                self.out[#self.out + 1] = {
                    z = self.ZoneId,
                    sz = self.SubZoneId,
                    e = p.EntityId,
                    ei = p.EntityIndex,
                    m = p.MessageId,
                    s = p.ShowName,
                }
            end
        end
    end

    return false
end

return script
