local eventvm = {}

---@param xie XiEvent
---@param pc integer
---@return string
local function getVar16AsFloat(xie, pc)
    local a = bit.bor(bit.rshift(xie.bytecode[pc + 1], 8), xie.bytecode[pc + 0])
    return string.format('%04X', a)
end

local function decodeEnd(xie)
    return 'END'
end

---@param xie XiEvent
---@return string
local function decodeWait(xie)
    local f = getVar16AsFloat(xie, xie.pc + 1)
    return string.format('WAIT %s', f)
end

---@param xie XiEvent
---@return string
local function decodeFinishEvent(xie)
    return 'FINISHEVENT'
end

---@param xie XiEvent
---@return string
local function decodeWaitForInput(xie)
    return 'WAITFORINPUT'
end

---@param xie XiEvent
---@return string
local function decodeWaitForPrompt(xie)
    return 'WAITFORPROMPT'
end

---@param xie XiEvent
---@return string
local function decodeWait16(xie)
    return 'WAIT16'
end

---@param xie XiEvent
---@return string
local function decodeOpcode70(xie)
    return 'Opcode70'
end

local decoders = {
    [0x00] = decodeEnd,
    [0x1C] = decodeWait,
    [0x21] = decodeFinishEvent,
    [0x23] = decodeWaitForInput,
    [0x25] = decodeWaitForPrompt,
    [0x6F] = decodeWait16,
    [0x70] = decodeOpcode70,
}
---@param xie XiEvent
---@return string
eventvm.decode = function (xie)
    local op = xie.bytecode[xie.pc]

    local decoder = decoders[op]
    if decoder ~= nil then
        return decoder(xie)
    end

    return string.format('%02X', op)
end

return eventvm
