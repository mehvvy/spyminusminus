function printf(fmt, ...)
    io.write(string.format(fmt, ...))
end

local function mergeinto(src, dst)
    for k, v in pairs(src) do
        dst[k] = v
    end
end

local function merge(...)
    local t = {}

    for i = 1, select('#', ...) do
        local a = select(i, ...)
       mergeinto(a, t)
    end

    return t
end

local entity = require('spymm.entity')
local event = require('spymm.event')
local zone = require('spymm.zone')

---@class parsers
local parsers = merge(entity, event, zone)

return parsers
