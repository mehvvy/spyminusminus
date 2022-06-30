--[[
Type definitions for Ashita v4 globals.


Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]

---@class Entity
---@field TargetIndex integer
---@field ServerId integer
---@field Name string
---@field WarpPointer unknown
---@field EventPointer unknown
---@field StatusServer integer
---@field Status integer
---@field StatusEvent integer
---@field ModelSize number
---@field Unknown0022 number
local Entity = {}

---@class addon
---@field name string
---@field author string
---@field version string
---@field desc string
---@field link string
local addon = {}

---@type addon
_G.addon = nil

---@type fun(EntityIndex: number): Entity
_G.GetEntity = nil

---@type fun(): Entity
_G.GetPlayerEntity = nil
