addon.name = 'SpyMinusMinus'
addon.author = 'Velyn'
addon.version = '0.1'
addon.desc = ''
addon.link = ''

require('common')

local chat = require('chat')

local imgui = require('imgui')

local eventvm = require('eventvm/eventvm')

local xiffi = require('xiffi/xiffi')

local globals = {
    visible = true,
    messages = {},
}

local function message(fmt, ...)
    print(chat.header(addon.name):append(chat.message(string.format(fmt, ...))))
end

local function parseSynthSuggestionPacket(e)
    table.insert(globals.messages, 'SynthSuggestion')
end

local function parseEventPacket(e)
    local p = xiffi.toEventPacket(e.data_modified_raw)
    table.insert(globals.messages, string.format('Event(%d, %d, %d, %d, %d, %04X, %04X)',
        p.EntityId,
        p.EntityIndex,
        p.ZoneId,
        p.EventId,
        p.EventZoneId,
        p.Flags0,
        p.Flags1
        ))
end

local function parseEventStringPacket(e)
    table.insert(globals.messages, 'EventString')
end

local function parseEventParamPacket(e)
    local p = xiffi.toEventParamPacket(e.data_modified_raw)
    table.insert(globals.messages, string.format('EventParam(%d, %d, %d, %d, %d, %04X, %04X, %08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)',
        p.EntityId,
        p.EntityIndex,
        p.ZoneId,
        p.EventId,
        p.EventZoneId,
        p.Flags0,
        p.Flags1,
        p.Params[0],
        p.Params[1],
        p.Params[2],
        p.Params[3],
        p.Params[4],
        p.Params[5],
        p.Params[6],
        p.Params[7]
        ))
end

local function parseReleasePacket(e)
    local p = xiffi.toReleasePacket(e.data_modified_raw)

    if p.Type == 2 then
        table.insert(globals.messages, string.format('Release(%d, %d)', p.Type, p.EventId))
    else
        table.insert(globals.messages, string.format('Release(%d)', p.Type))
    end
end

local function parseEventUpdatePacket(e)
    local p = xiffi.toEventUpdatePacket(e.data_modified_raw)
    table.insert(globals.messages, string.format('EventUpdate(%08X, %08X, %08X, %08X, %08X, %08X, %08X, %08X)',
        p.Params[0],
        p.Params[1],
        p.Params[2],
        p.Params[3],
        p.Params[4],
        p.Params[5],
        p.Params[6],
        p.Params[7]
        ))
end

local function parseEventUpdateStringPacket(e)
    local p = xiffi.toEventUpdateStringPacket(e.data_modified_raw)
    table.insert(globals.messages, string.format('EventUpdateString(%08X, %08X, %08X, %08X, %08X, %08X, %08X,',
        p.data[0][0], p.data[0][1], p.data[0][2], p.data[0][3],
        p.data[1][0], p.data[1][1], p.data[1][2], p.data[1][3]))
    table.insert(globals.messages, string.format('                  %08X, %08X, %08X, %08X, %08X, %08X, %08X)',
        p.data[2][0], p.data[2][1], p.data[2][2], p.data[2][3],
        p.data[3][0], p.data[3][1], p.data[3][2], p.data[3][3]))
end

local function parseCSPositionPacket(e)
    local p = xiffi.toPositionPacket(e.data_modified_raw)
    table.insert(globals.messages, string.format('CSPosition(%d, %d, %d, %f, %f, %f, %d, %d)',
        p.EntityId,
        p.EntityIndex,
        p.Mode,
        p.X,
        p.Y,
        p.Z,
        p.Rotation,
        p.Unknown0
        ))
end

local function parseInstanceEntryPacket(e)
    table.insert(globals.messages, 'InstanceEntry')
end

local function parseSpecialReleasePacket(e)
    table.insert(globals.messages, 'SpecialRelease')
end

local inParsers = {
    [0x031] = parseSynthSuggestionPacket,
    [0x032] = parseEventPacket,
    [0x033] = parseEventStringPacket,
    [0x034] = parseEventParamPacket,
    [0x052] = parseReleasePacket,
    [0x05C] = parseEventUpdatePacket,
    [0x05D] = parseEventUpdateStringPacket,
    [0x065] = parseCSPositionPacket,
    [0x0BF] = parseInstanceEntryPacket,
    [0x10E] = parseSpecialReleasePacket,
}

local outParsers = {

}

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args()
    if #args == 0 then
        return
    end
    if #args == 2 then
        if args[1] == '/spymm' then
            if args[2] == 'show' then
                message('Visible: ON')
                globals.visible = true
            elseif args[2] == 'hide' then
                message('Visible: OFF')
                globals.visible = false
            end
        end
    end
end)

ashita.events.register('packet_in', 'packet_in_cb', function (e)
    local parser = inParsers[e.id]
    if parser ~= nil then
        parser(e)
    end
end)

ashita.events.register('packet_out', 'packet_out_cb', function (e)
    local parser = outParsers[e.id]
    if parser ~= nil then
        parser(e)
    end
end)

local ColorWhite = { 1.0,  1.0,  1.0, 1.0 }
local ColorNeonCarrot = { 1.0, 0.60, 0.20, 1.0 }

local function renderEventState()
    local flags = bit.bor(
        ImGuiWindowFlags_NoDecoration,
        ImGuiWindowFlags_AlwaysAutoResize,
        ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoFocusOnAppearing,
        ImGuiWindowFlags_NoNav)

    imgui.SetNextWindowBgAlpha(0.6)
    imgui.SetNextWindowSize({ -1, -1, }, ImGuiCond_Always)
    imgui.SetNextWindowSizeConstraints({ -1, -1, }, { FLT_MAX, FLT_MAX, })

    if imgui.Begin('EventState', true, flags) then
        imgui.TextColored(ColorNeonCarrot, 'Event State')
        imgui.Separator()

        for idx = 0, 0x8ff do
            local entity = GetEntity(idx)
            if entity ~= nil then
                local event = entity.EventPointer
                if event ~= 0 then
                    local xie = xiffi.toXiEvent(event)
                    local instruction = eventvm.decode(xie)
                    imgui.TextColored(ColorWhite, string.format('%24s(%10d): %04X: %s', entity.Name, entity.ServerId, xie.pc, instruction))
                end
            end
        end
    end
    imgui.End()
end

local function renderPacketLog()
    local flags = bit.bor(
        ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoFocusOnAppearing)

    imgui.SetNextWindowBgAlpha(0.6)
    imgui.SetNextWindowSize({960, 480});
    imgui.SetNextWindowSizeConstraints({ -1, -1, }, { FLT_MAX, FLT_MAX, })

    if imgui.Begin('PacketLog', true, flags) then
        imgui.TextColored(ColorNeonCarrot, 'Packet Log')
        imgui.Separator()

        imgui.SetNextWindowBgAlpha(0.6)

        imgui.BeginChild('PacketLogBox')
        for i, m in ipairs(globals.messages) do
            imgui.TextColored(ColorWhite, m)
        end
        imgui.EndChild()
    end
    imgui.End()
end

---@param e Entity
---@param title string
local function renderEntity(e, title)
    local flags = bit.bor(
        ImGuiWindowFlags_NoDecoration,
        ImGuiWindowFlags_AlwaysAutoResize,
        ImGuiWindowFlags_NoSavedSettings,
        ImGuiWindowFlags_NoFocusOnAppearing,
        ImGuiWindowFlags_NoNav)

    imgui.SetNextWindowBgAlpha(0.6)
    imgui.SetNextWindowSize({ -1, -1, }, ImGuiCond_Always)
    imgui.SetNextWindowSizeConstraints({ -1, -1, }, { FLT_MAX, FLT_MAX, })

    if imgui.Begin(title, true, flags) then
        imgui.TextColored(ColorNeonCarrot, title)
        imgui.Separator()

        imgui.TextColored(ColorWhite, string.format('%s', e.Name))
        imgui.TextColored(ColorWhite, string.format('%10d:%-4d', e.ServerId, e.TargetIndex))
        imgui.TextColored(ColorWhite, string.format('%d', e.StatusServer))
        imgui.TextColored(ColorWhite, string.format('%d', e.Status))
        imgui.TextColored(ColorWhite, string.format('%d', e.StatusEvent))
        imgui.TextColored(ColorWhite, string.format('%f', e.ModelSize))
        imgui.TextColored(ColorWhite, string.format('%f', e.Unknown0022))

        local Model = e.WarpPointer
        if Model ~= 0 then
            local m = xiffi.toPlaceholderModelType(Model)
            imgui.TextColored(ColorWhite, string.format('%f', m.ModelSize[0]))
            imgui.TextColored(ColorWhite, string.format('%f', m.ModelSize[1]))
            imgui.TextColored(ColorWhite, string.format('%f', m.ModelSize[2]))
            imgui.TextColored(ColorWhite, string.format('%f', m.ModelSize[3]))

            for i = 0, 35 do
                imgui.TextColored(ColorWhite, string.format('%2d: %3d', i, m.Cib[i]))
            end
        end
    end
    imgui.End()
end

ashita.events.register('d3d_present', 'present_cb', function ()

    if not globals.visible then
        return
    end

    renderEventState()
    renderPacketLog()

    local player = GetPlayerEntity()
    if player ~= nil then
        renderEntity(player, 'Local')
    end

    for x = 1, 0, -1 do
        local idx = AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(x)
        local target = GetEntity(idx)

        if target ~= nil then
            renderEntity(target, string.format('Target %d', x))
        end
    end
end)
