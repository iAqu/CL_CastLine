-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GUI = require(ReplicatedStorage.Client.GUI)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local t1 = {
    bound = "PressBound",
    glyph = "PressGlyph",
    silent = "MuteSounds",
    ownedScale = "PressScaleOwner"
}
local v1 = Vector2.new(0.5, 0.5)
local v2 = UDim2.fromScale(0, 0.08)
local v3 = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t2 = {
    intoSunk = 42,
    outOfSunk = 26,
    hover = 22
}
local t3 = {
    volume = 3.4,
    id = Constants.BUTTON_FX.BUTTON_MOUSE_DOWN_SOUND,
    pitch = NumberRange.new(0.93, 1.06)
}
local v4 = Random.new()
local n1 = 0
local t4 = {}
local t5 = {}
local connection

local function noop() -- line: 96
end

local function stepMotions(p1) -- line: 100
    -- upvalues: t5 (copy), connection (ref)
    for v5, v6 in t5 do
        if v5.Parent ~= nil then
            local v7 = v5.Scale - v6.target
            local v9 = math.exp(-v6.stiffness * p1)
            local v10 = (v6.velocity + v6.stiffness * v7) * p1
            local v11 = (v7 + v10) * v9

            v6.velocity = (v6.velocity - v6.stiffness * v10) * v9

            if math.abs(v11) < 5E-04 then
                if math.abs(v6.velocity) < 5E-04 then
                    v5.Scale = v6.target
                    t5[v5] = nil
                else
                    v5.Scale = v6.target + v11
                end
            else
                v5.Scale = v6.target + v11
            end
        else
            t5[v5] = nil
        end
    end

    if connection and next(t5) == nil then
        connection:Disconnect()
        connection = nil
    end
end

local function drive(p2, p3, p4) -- line: 127
    -- upvalues: RunService (copy), t5 (copy), connection (ref), stepMotions (copy)
    local v12 = t5[p2]

    if v12 then
        v12.target = p3
        v12.stiffness = p4
    else
        t5[p2] = {
            velocity = 0,
            target = p3,
            stiffness = p4
        }
    end

    if connection == nil then
        connection = RunService.PreRender:Connect(stepMotions)
    end
end

local function accepting(p5) -- line: 142
    return p5.host.Active and p5.input.GuiState ~= Enum.GuiState.NonInteractable
end

local function poseOf(p6) -- line: 146
    -- upvalues: PlatformController (copy)
    if not p6.host.Active or p6.input.GuiState == Enum.GuiState.NonInteractable then
        return "Rest"
    end

    local GuiState = p6.input.GuiState

    if p6.gamepadHeld or GuiState == Enum.GuiState.Press then
        return "Sunk"
    end

    if GuiState ~= Enum.GuiState.Hover or not PlatformController.IsDesktop() then
        return "Rest"
    end

    return "Raised"
end

local function scaleFor(p7, p8) -- line: 160
    if p8 == "Sunk" then
        return p7.sunkScale
    end

    if p8 == "Raised" then
        return p7.raisedScale
    end

    return 1
end

local function stiffnessFor(p9, p10) -- line: 167
    if p10 == "Sunk" then
        return 42
    end

    if p9 == "Sunk" then
        return 26
    end

    return 22
end

local function playPressCue(p11) -- line: 174
    -- upvalues: Audio (copy), t3 (copy), v4 (copy)
    Audio.Play(t3.id, script, {
        PlaybackSpeed = v4:NextNumber(t3.pitch.Min, t3.pitch.Max),
        Volume = p11
    })
end

local function placeGlyph(p12, p13) -- line: 181
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy)
    local glyph = p12.glyph

    if glyph ~= nil then
        TweenService:Create(glyph, v3, {
            Position = if p13 == "Sunk" then p12.glyphRest + v2 else p12.glyphRest
        }):Play()
    end
end

local function refresh(p14) -- line: 190
    -- upvalues: RunService (copy), Audio (copy), PlatformController (copy), t2 (copy), t3 (copy), v4 (copy), t5 (copy), connection (ref), stepMotions (copy), placeGlyph (copy)
    local pose = p14.pose
    local v14

    if p14.host.Active and p14.input.GuiState ~= Enum.GuiState.NonInteractable then
        local GuiState = p14.input.GuiState

        v14 = if p14.gamepadHeld or GuiState == Enum.GuiState.Press then "Sunk" elseif GuiState ~= Enum.GuiState.Hover or not PlatformController.IsDesktop() then "Rest" else "Raised"
    else
        v14 = "Rest"
    end

    if pose == v14 then
        return
    end

    p14.pose = v14

    if v14 == "Sunk" and p14.cueGain then
        local cueGain = p14.cueGain

        Audio.Play(t3.id, script, {
            PlaybackSpeed = v4:NextNumber(t3.pitch.Min, t3.pitch.Max),
            Volume = cueGain
        })
    end

    local scale = p14.scale
    local v15 = if v14 == "Sunk" then p14.sunkScale elseif v14 == "Raised" then p14.raisedScale else 1
    local v16 = if v14 == "Sunk" then t2.intoSunk elseif pose == "Sunk" then t2.outOfSunk else t2.hover
    local v17 = t5[scale]

    if v17 then
        v17.target = v15
        v17.stiffness = v16
    else
        t5[scale] = {
            velocity = 0,
            target = v15,
            stiffness = v16
        }
    end

    if connection == nil then
        connection = RunService.PreRender:Connect(stepMotions)
    end

    placeGlyph(p14, v14)
end

local function centerAnchor(p15) -- line: 207
    -- upvalues: v1 (copy)
    local AnchorPoint = p15.AnchorPoint

    if AnchorPoint == v1 then
        return
    end

    local Position, Size = p15.Position, p15.Size
    local v18 = v1 - AnchorPoint

    p15.AnchorPoint = v1

    local Parent = p15.Parent
    local v19 = p15:FindFirstChildWhichIsA("UIAspectRatioConstraint") ~= nil or p15:FindFirstChildWhichIsA("UISizeConstraint") ~= nil
    local AbsoluteSize = p15.AbsoluteSize
    local v20 = if Parent == nil or not Parent:IsA("GuiBase2d") then Vector2.zero else Parent.AbsoluteSize

    if v19 and AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 and v20.X > 0 and v20.Y > 0 then
        p15.Position = UDim2.new(Position.X.Scale + AbsoluteSize.X * v18.X / v20.X, Position.X.Offset, Position.Y.Scale + AbsoluteSize.Y * v18.Y / v20.Y, Position.Y.Offset)
    else
        p15.Position = UDim2.new(Position.X.Scale + Size.X.Scale * v18.X, Position.X.Offset + Size.X.Offset * v18.X, Position.Y.Scale + Size.Y.Scale * v18.Y, Position.Y.Offset + Size.Y.Offset * v18.Y)
    end
end

local function adoptScale(p16) -- line: 243
    local UIScale = p16:FindFirstChildOfClass("UIScale")

    if UIScale and UIScale:IsA("UIScale") then
        return UIScale
    end

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Name = "PressScale"
    UIScale2.Parent = p16

    return UIScale2
end

local function findGlyph(p17) -- line: 254
    local PressGlyph = p17:GetAttribute("PressGlyph")

    if type(PressGlyph) ~= "string" then
        return nil
    end

    local v21 = p17:FindFirstChild(PressGlyph)

    return if v21 and v21:IsA("GuiObject") then v21 else nil
end

local function mirrorActive(p18) -- line: 263
    local host, input = p18.host, p18.input

    if input ~= host then
        input.Active = host.Active
        input.Selectable = host.Active
    end
end

local function liveBinding(p19) -- line: 273
    -- upvalues: t4 (copy)
    local PressBound = p19:GetAttribute("PressBound")

    if type(PressBound) ~= "number" then
        return nil
    end

    local v22 = t4[PressBound]

    return if v22 and v22.host == p19 then v22 else nil
end

local function unbind(p20) -- line: 284
    -- upvalues: t4 (copy), t5 (copy)
    if t4[p20.serial] ~= p20 then
        return
    end

    t4[p20.serial] = nil

    for _, v23 in p20.links do
        v23:Disconnect()
    end

    table.clear(p20.links)

    local activation = p20.activation

    if activation then
        activation:Disconnect()
        p20.activation = nil
    end

    local host = p20.host

    if host:GetAttribute("PressBound") == p20.serial then
        host:SetAttribute("PressBound", nil)
    end

    t5[p20.scale] = nil

    if p20.scale.Parent then
        p20.scale.Scale = 1
    end

    local glyph = p20.glyph

    if glyph then
        glyph.Position = p20.glyphRest
    end

    if p20.ownsInput then
        p20.input:Destroy()
    end
end

local function wire(p21) -- line: 317
    -- upvalues: GUI (copy), refresh (copy), unbind (copy)
    local host, input, links = p21.host, p21.input, p21.links

    table.insert(links, input:GetPropertyChangedSignal("GuiState"):Connect(function() -- line: 320
        -- upvalues: p21 (copy), refresh (copy)
        refresh(p21)
    end))
    table.insert(links, input.InputBegan:Connect(function(p22) -- line: 325
        -- upvalues: p21 (copy), refresh (copy)
        if p22.KeyCode == Enum.KeyCode.ButtonA then
            p21.gamepadHeld = true
            refresh(p21)
        end
    end))
    table.insert(links, input.InputEnded:Connect(function(p23) -- line: 331
        -- upvalues: p21 (copy), refresh (copy)
        if p23.KeyCode == Enum.KeyCode.ButtonA then
            p21.gamepadHeld = false
            refresh(p21)
        end
    end))
    table.insert(links, host:GetPropertyChangedSignal("Active"):Connect(function() -- line: 337
        -- upvalues: p21 (copy), refresh (copy)
        local host, input = p21.host, p21.input

        if input ~= host then
            input.Active = host.Active
            input.Selectable = host.Active
        end

        refresh(p21)
    end))
    table.insert(links, host.Destroying:Connect(function() -- line: 341
        -- upvalues: p21 (copy), unbind (copy)
        unbind(p21)
    end))

    local onActivate = p21.onActivate

    if onActivate then
        p21.activation = GUI.OnActivated(input, function() -- line: 347
            -- upvalues: p21 (copy), onActivate (copy)
            if p21.host.Active and p21.input.GuiState ~= Enum.GuiState.NonInteractable then
                onActivate()
            end
        end)
    end
end

local function bind(p24) -- line: 355
    -- upvalues: t1 (copy), t3 (copy), n1 (ref), t4 (copy), noop (copy), centerAnchor (copy), unbind (copy), wire (copy)
    local host = p24.host
    local Attribute = host:GetAttribute(t1.bound)
    local v29

    if type(Attribute) == "number" then
        v29 = t4[Attribute]

        if not v29 or v29.host ~= host then
            v29 = nil
        end
    end

    if v29 then
        return noop
    end

    centerAnchor(host)

    local UIScale = host:FindFirstChildOfClass("UIScale")

    if not (UIScale and UIScale:IsA("UIScale")) then
        UIScale = Instance.new("UIScale")
        UIScale.Name = "PressScale"
        UIScale.Parent = host
    end

    UIScale:SetAttribute("PressScaleOwner", true)

    local Attribute2 = host:GetAttribute(t1.glyph)
    local v30

    if type(Attribute2) == "string" then
        v30 = host:FindFirstChild(Attribute2)

        if not (v30 and v30:IsA("GuiObject")) then
            v30 = nil
        end
    end

    local v31 = p24.silent == true or host:GetAttribute("MuteSounds") == true

    n1 += 1

    local t6 = {
        pose = "Rest",
        gamepadHeld = false,
        activation = nil,
        serial = n1,
        host = host,
        input = p24.input,
        scale = UIScale,
        glyph = v30,
        glyphRest = if v30 then v30.Position else UDim2.new(),
        raisedScale = p24.peakScale or 1.07,
        sunkScale = p24.pressedScale or 0.94,
        cueGain = if v31 then nil else p24.cueGain or t3.volume,
        onActivate = p24.onActivate,
        ownsInput = p24.ownsInput == true,
        links = {}
    }

    t4[t6.serial] = t6
    host:SetAttribute("PressBound", t6.serial)

    local host2, input = t6.host, t6.input

    if input ~= host2 then
        input.Active = host2.Active
        input.Selectable = host2.Active
    end

    wire(t6)

    return function() -- line: 391
        -- upvalues: t6 (copy), unbind (copy)
        unbind(t6)
    end
end

return function(p25, p26, p27, p28) -- line: 396
    -- upvalues: bind (copy)
    if typeof(p25) == "table" then
        return (bind(p25))
    end

    assert(typeof(p25) == "Instance" and p25:IsA("GuiButton"), "ButtonFX needs a GuiButton")
    assert(p26 == nil or type(p26) == "number", "ButtonFX peak scale must be a number")
    assert(p27 == nil or type(p27) == "function", "ButtonFX activation handler must be a function")

    return (bind({
        host = p25,
        input = p25,
        peakScale = p26,
        onActivate = p27,
        silent = p28
    }))
end
