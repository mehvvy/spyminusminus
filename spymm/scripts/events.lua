---@class PacketFilter
local script = {}

function script:start()
    self.out = {}
end

function script:finish()
    return self.out
end

function script:beginsession()
end

function script:endsession()
end

function script:process(row, p)
    local v = nil

    if row.kind == 4 then
        if row.type == 0x00A then
            ---@cast p ZoneInPacket
            if p.ZoneInEventId > 0 then
                v = {
                    Name = 'incoming:ZoneInPacket',
                    ZoneId = p.ZoneId,
                    EventId = p.ZoneInEventId,
                    EventZoneId = p.ZoneInEventZoneId, -- ???
                    EventFileId = p.ZoneInEventFileId, -- ???
                    Flags0 = p.ZoneInEventFlags0,
                    ZoneInEntitiesRequired = p.ZoneInEntitiesRequired, -- not quest specific
                    -- Flags1 = p.Flags1, -- no flags1
                }
            end
        end
        if row.type == 0x032 then
            ---@cast p EventPacket
            v = {
                Name = 'incoming:EventPacket',
                EntityId = p.EntityId,
                EntityIndex = p.EntityIndex,
                ZoneId = p.ZoneId,
                EventId = p.EventId,
                EventZoneId = p.EventZoneId,
                Flags0 = p.Flags0,
                Flags1 = p.Flags1,
            }
        end

        if row.type == 0x033 then
            ---@cast p EventStringPacket
            if bit.band(p.Flags0, 0x08) then
                v = {
                    Name = 'incoming:EventStringPacket',
                    EntityId = p.EntityId,
                    EntityIndex = p.EntityIndex,
                    ZoneId = p.ZoneId,
                    EventId = p.EventId,
                    Flags0 = p.Flags0,
                    Strings = {
                        {
                            p.data[0][0],
                            p.data[0][1],
                            p.data[0][2],
                            p.data[0][3],
                        },
                        {
                            p.data[1][0],
                            p.data[1][1],
                            p.data[1][2],
                            p.data[1][3],
                        },
                        {
                            p.data[2][0],
                            p.data[2][1],
                            p.data[2][2],
                            p.data[2][3],
                        },
                        {
                            p.data[3][0],
                            p.data[3][1],
                            p.data[3][2],
                            p.data[3][3],
                        }
                    },
                    Params = {
                        p.Params[0],
                        p.Params[1],
                        p.Params[2],
                        p.Params[3],
                        p.Params[4],
                        p.Params[5],
                        p.Params[6],
                        p.Params[7],
                    }
                }
            else
                v = {
                    Name = 'incoming:EventStringPacket',
                    EntityId = p.EntityId,
                    EntityIndex = p.EntityIndex,
                    ZoneId = p.ZoneId,
                    EventId = p.EventId,
                    Flags0 = p.Flags0,
                    Strings = {
                        {
                            p.data[0][0],
                            p.data[0][1],
                            p.data[0][2],
                            p.data[0][3],
                        },
                        {
                            p.data[1][0],
                            p.data[1][1],
                            p.data[1][2],
                            p.data[1][3],
                        },
                        {
                            p.data[2][0],
                            p.data[2][1],
                            p.data[2][2],
                            p.data[2][3],
                        },
                        {
                            p.data[3][0],
                            p.data[3][1],
                            p.data[3][2],
                            p.data[3][3],
                        }
                    },
                }
            end
        end

        if row.type == 0x034 then
            ---@cast p EventParamPacket
            v = {
                Name = 'incoming:EventParamPacket',
                EntityId = p.EntityId,
                EntityIndex = p.EntityIndex,
                ZoneId = p.ZoneId,
                EventId = p.EventId,
                EventZoneId = p.EventZoneId,
                Flags0 = p.Flags0,
                Flags1 = p.Flags1,
                Params = {
                    p.Params[0],
                    p.Params[1],
                    p.Params[2],
                    p.Params[3],
                    p.Params[4],
                    p.Params[5],
                    p.Params[6],
                    p.Params[7],
                }
            }
        end

        if row.type == 0x052 then
            ---@cast p ReleasePacket
            v = {
                Name = 'incoming:ReleasePacket',
                Type = p.Type,
                EventId = p.EventId,
            }
        end

        if row.type == 0x05C then
            ---@cast p EventUpdatePacket
            v = {
                Name = 'incoming:EventUpdatePacket',
                Params = {
                    p.Params[0],
                    p.Params[1],
                    p.Params[2],
                    p.Params[3],
                    p.Params[4],
                    p.Params[5],
                    p.Params[6],
                    p.Params[7],
                }
            }
        end

        if row.type == 0x05D then
            ---@cast p EventUpdateStringPacket
            v = {
                Name = 'incoming:EventUpdateStringPacket',
                Strings = {
                    {
                        p.data[0][0],
                        p.data[0][1],
                        p.data[0][2],
                        p.data[0][3],
                    },
                    {
                        p.data[1][0],
                        p.data[1][1],
                        p.data[1][2],
                        p.data[1][3],
                    },
                    {
                        p.data[2][0],
                        p.data[2][1],
                        p.data[2][2],
                        p.data[2][3],
                    },
                    {
                        p.data[3][0],
                        p.data[3][1],
                        p.data[3][2],
                        p.data[3][3],
                    }
                },
            }
        end

        if row.type == 0x065 then
            ---@cast p PositionPacket
            v = {
                Name ='incoming:CSPositionPacket',
                X = p.X,
                Y = p.Y,
                Z = p.Z,
                EntityId = p.EntityId,
                EntityIndex = p.EntityIndex,
                Mode = p.Mode,
                Rotation = p.Rotation,
                Unknown0 = p.Unknown0,
            }
        end
    end

    if row.kind == 5 then
        if row.type == 0x05B then
            ---@cast p EventFinishPacket
            v = {
                Name = (p.IsUpdate ~= 0) and 'outgoing:EventUpdatePacket' or 'outgoing:EventFinishPacket',
                EntityId = p.EntityId,
                EntityIndex = p.EntityIndex,
                ZoneId = p.ZoneId,
                EventId = p.EventId,
                IsUpdate = p.IsUpdate,
                EventResult = p.EventResult,
            }
        end
    end

    if v ~= nil then
        self.out[#self.out + 1] = v
    end

    return false
end

return script
