---@class PacketFilter
local script = {}

---@param self PacketFilter
local function reduce(self)
    local out = self.out
    local new = {}

    for _, e in pairs(out) do
        if e.er > 0 or #e.e > 0 then

            local newe = {}
            for eid, _ in pairs(e.e) do
                newe[#newe + 1] = tonumber(eid)
            end

            e.e = newe

            new[#new + 1] = e
        end
    end
    return new
end

---@param self PacketFilter
local function newzone(self)
    if self.cur then
        self.out[#self.out + 1] = self.cur
        self.cur = nil
    end
end

function script:start()
    self.out = {}
end

function script:finish()
    self.out = reduce(self)
    return self.out
end

function script:beginsession()
    self.cur = nil
end

function script:endsession()
    newzone(self)
end

function script:process(row, p)
    if row.kind == 4 then
        if row.type == 0x00A then
            ---@cast p ZoneInPacket
            newzone(self)

            self.cur = {
                z = p.ZoneId,
                sz = p.SubZoneId,
                ev = p.ZoneInEventId,
                ez = p.ZoneInEventZoneId,
                ef = p.ZoneInEventFileId,
                er = p.ZoneInEntitiesRequired,
                e = {},
            }

            return true
        end

        if row.type == 0x00E then
            if self.cur then
                ---@cast p EntityUpdatePacket
                if p.UpdateFlags04 and p.RequiredEntity then
                    self.cur.e[tostring(p.EntityId)] = true
                    return true
                end
            end
        end
    end

    return false
end

return script
