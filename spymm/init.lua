---@class PacketFilter
local PacketFilter = {}

function PacketFilter:start()
end

---@return table|nil
function PacketFilter:finish()
end

function PacketFilter:beginsession()
end

function PacketFilter:endsession()
end

---@return boolean
function PacketFilter:process(row, p)
end
