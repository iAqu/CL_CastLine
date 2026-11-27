-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SettingChange = Remotes:WaitForChild("SettingChange")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Panel = PlayerGui:WaitForChild("SettingsGui"):WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Main = Panel:WaitForChild("Main")
local Close = Main:WaitForChild("Close")
local Rows = Main:WaitForChild("Rows")
local Button = PlayerGui:WaitForChild("MenuButtons"):WaitForChild("SmallRow"):WaitForChild("SettingsSlot"):WaitForChild("Button")

local function fitCanvas() -- line: 64
    -- upvalues: Scale (copy), Rows (copy)
    local Scale2 = Scale.Scale > 0 and Scale.Scale or 1

    Rows.CanvasSize = UDim2.fromOffset(0, (math.floor(Rows.AbsoluteSize.Y / Scale2 * (Rows:GetAttribute("CanvasWindows") or 1) + 0.5)))
end

Rows:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitCanvas)

local Scale2 = Scale.Scale > 0 and Scale.Scale or 1

Rows.CanvasSize = UDim2.fromOffset(0, (math.floor(Rows.AbsoluteSize.Y / Scale2 * (Rows:GetAttribute("CanvasWindows") or 1) + 0.5)))

local v3 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local t1 = {
    SCALE = 1.06,
    IN = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    OUT = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}
local t2 = {
    SCALE = 1.12,
    UP = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SETTLE = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}
local SoundService = game:GetService("SoundService")
local v4 = Random.new()

local function sfx(p1) -- line: 76
    -- upvalues: SoundService (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v5 = HarpoonSFX and HarpoonSFX:FindFirstChild(p1)

    if v5 then
        v5:Play()
    end
end

local t3 = {
    OtherAquariums = "SetOtherAquariums",
    Music = "SetMusic",
    Sfx = "SetSfx",
    Sensitivity = "SetSensitivity",
    AimAssist = "SetAimAssist",
    ReduceFx = "SetReduceFx",
    OfferPopups = "SetOfferPopups",
    GlobalMessages = "SetGlobalMessages",
    AquariumSounds = "SetAquariumSounds",
    HudSize = "SetHudSize"
}
local t4 = {
    OtherAquariums = true,
    Music = 0.5,
    Sfx = 0.5,
    Sensitivity = 1,
    AimAssist = 1,
    ReduceFx = false,
    OfferPopups = true,
    GlobalMessages = true,
    AquariumSounds = true,
    HudSize = "Normal"
}

local function get(p2) -- line: 85
    -- upvalues: LocalPlayer (copy), t3 (copy), t4 (copy)
    local Attribute = LocalPlayer:GetAttribute(t3[p2])

    if type(Attribute) == type(t4[p2]) then
        return Attribute
    end

    return t4[p2]
end

local function set(p3, p4) -- line: 90
    -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy)
    LocalPlayer:SetAttribute(t3[p3], p4)
    SettingChange:FireServer(p3, p4)
end

local function makeToggle(p5, p6, p7, p8) -- line: 98
    -- upvalues: TweenService (copy), Rows (copy), v3 (copy), t1 (copy), t2 (copy), SoundService (copy), v4 (copy)
    local Toggle = Rows:WaitForChild(p5):WaitForChild("Toggle")
    local Knob = Toggle:WaitForChild("Knob")
    local Clip = Toggle:WaitForChild("Clip")
    local Fill = Clip:WaitForChild("Fill")
    local On = Clip:WaitForChild("On")
    local Off = Clip:WaitForChild("Off")
    local v8 = Toggle:GetAttribute("KnobOff") or 0.12
    local v9 = Toggle:GetAttribute("KnobOn") or 0.88
    local v10 = Toggle:GetAttribute("OnOffset") or 0.542
    local v11 = Toggle:GetAttribute("OffAt") or 0.662

    local function pose(p9) -- line: 104
        -- upvalues: Knob (copy), Fill (copy), On (copy), Off (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy)
        local v12 = v8 + (v9 - v8) * p9

        Knob.Position = UDim2.fromScale(v12, 0.5)
        Fill.Size = UDim2.fromScale(math.min(1, v12 + 0.2 * p9), 1)
        On.Position = UDim2.fromScale(v12 - v10, 0.5)
        Off.Position = UDim2.fromScale(v11 - (v9 - v8) * p9, 0.5)

        local v14 = math.clamp(p9, 0, 1)

        Off.TextTransparency = v14
        Off.UIStroke.Transparency = v14
    end

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Changed:Connect(pose)

    local v15

    local function show(p10, p11) -- line: 119
        -- upvalues: pose (copy), NumberValue (copy), v15 (ref), TweenService (copy), v3 (copy)
        if p10 == v15 then
            return
        end

        v15 = p10

        local v16 = if p10 then 1 else 0

        if p11 then
            TweenService:Create(NumberValue, v3, {
                Value = v16
            }):Play()
        else
            NumberValue.Value = v16
            pose(v16)
        end
    end

    local Hit = Toggle:WaitForChild("Hit")
    local Scale = Toggle:WaitForChild("Scale")
    local v17 = false

    Hit.MouseEnter:Connect(function() -- line: 135
        -- upvalues: Scale (copy), v17 (ref), TweenService (copy), t1 (copy), SoundService (copy), v4 (copy)
        v17 = true

        local v18 = ({ "Hover1", "Hover2", "Hover3" })[v4:NextInteger(1, 3)]
        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local v19 = HarpoonSFX and HarpoonSFX:FindFirstChild(v18)

        if v19 then
            v19:Play()
        end

        TweenService:Create(Scale, t1.IN, {
            Scale = t1.SCALE
        }):Play()
    end)
    Hit.MouseLeave:Connect(function() -- line: 140
        -- upvalues: Scale (copy), v17 (ref), TweenService (copy), t1 (copy)
        v17 = false
        TweenService:Create(Scale, t1.OUT, {
            Scale = 1
        }):Play()
    end)
    Hit.Activated:Connect(function() -- line: 144
        -- upvalues: p6 (copy), p7 (copy), p8 (copy), NumberValue (copy), v15 (ref), Scale (copy), v17 (ref), TweenService (copy), v3 (copy), t1 (copy), t2 (copy), SoundService (copy)
        if p7 and p7() then
            p8()

            return
        end

        local v20 = not v15
        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local TileSelect = HarpoonSFX and HarpoonSFX:FindFirstChild("TileSelect")

        if TileSelect then
            TileSelect:Play()
        end

        local tween = TweenService:Create(Scale, t2.UP, {
            Scale = t2.SCALE
        })

        tween.Completed:Once(function() -- line: 152
            -- upvalues: Scale (copy), v17 (ref), TweenService (copy), t1 (copy), t2 (copy)
            TweenService:Create(Scale, t2.SETTLE, {
                Scale = v17 and t1.SCALE or 1
            }):Play()
        end)
        tween:Play()

        if v20 ~= v15 then
            v15 = v20
            TweenService:Create(NumberValue, v3, {
                Value = v20 and 1 or 0
            }):Play()
        end

        p6(v20)
    end)

    return show
end

local v22 = makeToggle("Aquariums", function(p12) -- line: 161
    -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy)
    LocalPlayer:SetAttribute(t3.OtherAquariums, p12)
    SettingChange:FireServer("OtherAquariums", p12)
end)
local v23 = makeToggle("AquariumSounds", function(p13) -- line: 163
    -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy)
    LocalPlayer:SetAttribute(t3.AquariumSounds, p13)
    SettingChange:FireServer("AquariumSounds", p13)
end)
local v24 = makeToggle("ReduceFx", function(p14) -- line: 167
    -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy)
    LocalPlayer:SetAttribute(t3.ReduceFx, p14)
    SettingChange:FireServer("ReduceFx", p14)
end)
local t6 = {
    SAY = "Make any purchase to unlock!",
    FILL = ColorSequence.new(Color3.fromRGB(175, 175, 180), Color3.fromRGB(120, 120, 128)),
    KNOB = Color3.fromRGB(165, 165, 165)
}

local function offerLocked() -- line: 176
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("Buyer") ~= true
end

local v25 = makeToggle("OfferPopups", function(p15) -- line: 177
    -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy)
    LocalPlayer:SetAttribute(t3.OfferPopups, p15)
    SettingChange:FireServer("OfferPopups", p15)
end, offerLocked, function() -- line: 177
    -- upvalues: Modules (copy), t6 (copy)
    local Toast = require(Modules:WaitForChild("Toast"))

    Toast.Show(t6.SAY, "", nil, Toast.RED, "deny")
end)
local Toggle = Rows:WaitForChild("OfferPopups"):WaitForChild("Toggle")
local UIGradient = Toggle:WaitForChild("Clip"):WaitForChild("Fill"):WaitForChild("UIGradient")
local Knob = Toggle:WaitForChild("Knob")
local Checker = Toggle.Knob:WaitForChild("Checker")
local t7 = {
    fill = UIGradient.Color,
    knob = Knob.BackgroundColor3,
    checker = Checker.GroupTransparency
}

local function offerLook() -- line: 185
    -- upvalues: LocalPlayer (copy), t6 (copy), UIGradient (copy), Knob (copy), Checker (copy), t7 (copy)
    local v26 = LocalPlayer:GetAttribute("Buyer") ~= true

    UIGradient.Color = v26 and t6.FILL or t7.fill
    Knob.BackgroundColor3 = v26 and t6.KNOB or t7.knob
    Checker.GroupTransparency = if v26 then 1 else t7.checker
end

local v28 = makeToggle("GlobalMessages", function(p16) -- line: 192
    -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy)
    LocalPlayer:SetAttribute(t3.GlobalMessages, p16)
    SettingChange:FireServer("GlobalMessages", p16)
end)
local TelemetryReport = Remotes:WaitForChild("TelemetryReport")
local v29 = makeToggle("Potato", function(p17) -- line: 199
    -- upvalues: LocalPlayer (copy), TelemetryReport (copy)
    LocalPlayer:SetAttribute("PotatoChoice", p17 and "on" or "off")
    TelemetryReport:FireServer("potatoset", p17)
end)
local v30 = Color3.fromRGB(110, 225, 70)
local v31 = Color3.fromRGB(205, 208, 214)
local t8 = {}

for _, v32 in ipairs({ "Small", "Normal", "Large" }) do
    local v33 = Rows:WaitForChild("HudSize"):WaitForChild("Choices"):WaitForChild(v32)

    t8[v32] = v33
    ButtonHover.Attach(v33, {
        shine = false,
        highlight = true,
        highlightCorner = 0.135,
        highlightFade = 0.8,
        buttonScale = 1.04
    })
    v33.Activated:Connect(function() -- line: 211
        -- upvalues: ButtonHover (copy), SettingChange (copy), LocalPlayer (copy), SoundService (copy), t3 (copy), t4 (copy), v32 (copy), v33 (copy)
        ButtonHover.Press(v33)

        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local TileSelect = HarpoonSFX and HarpoonSFX:FindFirstChild("TileSelect")

        if TileSelect then
            TileSelect:Play()
        end

        local Attribute = LocalPlayer:GetAttribute(t3.HudSize)

        if type(Attribute) ~= type(t4.HudSize) then
            Attribute = t4.HudSize
        end

        if Attribute == v32 then
            return
        end

        LocalPlayer:SetAttribute(t3.HudSize, v32)
        SettingChange:FireServer("HudSize", v32)
    end)
end

local function showHudSize() -- line: 217
    -- upvalues: LocalPlayer (copy), t3 (copy), t4 (copy), v30 (copy), v31 (copy), t8 (copy)
    local Attribute = LocalPlayer:GetAttribute(t3.HudSize)

    if type(Attribute) ~= type(t4.HudSize) then
        Attribute = t4.HudSize
    end

    for v36, v37 in pairs(t8) do
        v37.ImageColor3 = v36 == Attribute and v30 or v31
    end
end

local t9 = {}
local t10 = {
    linear = {
        toValue = function(p18) -- toValue | line: 227
            return p18
        end,
        toT = function(p19) -- toT | line: 227
            return p19
        end
    },
    log = {
        toValue = function(p20) -- toValue | line: 229
            return 0.2 * 25 ^ p20
        end,
        toT = function(p21) -- toT | line: 230
            return math.log(math.clamp(p21, 0.2, 5) / 0.2) / 3.2188758248682006
        end
    }
}

local function showSlider(p22, p23) -- line: 233
    local v40 = math.clamp(p22.scale.toT(p23), 0, 1)

    p22.fill.Size = UDim2.fromScale(v40, 1)
    p22.knob.Position = UDim2.fromScale(v40, 0.5)

    local box, v41

    if p22.box and not p22.box:IsFocused() then
        box = p22.box
        v41 = if p22.pct then math.floor(p23 * 100 + 0.5) .. "%" or string.format("%.2f", p23) else string.format("%.2f", p23)
        box.Text = v41
    end
end

local _pairs = pairs
local t11 = {
    Music = { "Music", "linear", 0, 1 },
    SFX = { "Sfx", "linear", 0, 1 },
    Sensitivity = { "Sensitivity", "log", 0.2, 5 },
    AimAssist = {
        "AimAssist",
        "linear",
        0, 1,
        pct = true
    }
}

for v43, v44 in _pairs(t11) do
    local v45 = v44[1]
    local v46 = v44[2]
    local v47 = v44[3]
    local v48 = v44[4]
    local v49 = Rows:WaitForChild(v43)
    local Slider = v49:WaitForChild("Slider")
    local t13 = {
        input = nil,
        sentAt = 0,
        sent = nil,
        key = v45,
        track = Slider,
        fill = Slider:WaitForChild("Fill"),
        knob = Slider:WaitForChild("Knob"),
        scale = t10[v46],
        box = v49:FindFirstChild("Value"),
        pct = v44.pct
    }

    t9[#t9 + 1] = t13

    local function move(p24, p25) -- line: 254
        -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy), t4 (copy), showSlider (copy), v45 (copy), Slider (copy), t13 (copy)
        local X = Slider.AbsoluteSize.X
        local Attribute

        if X <= 0 then
            Attribute = LocalPlayer:GetAttribute(t3[v45])

            if type(Attribute) ~= type(t4[v45]) then
                Attribute = t4[v45]
            end
        else
            Attribute = t13.scale.toValue((math.clamp((p24 - Slider.AbsolutePosition.X) / X, 0, 1)))
        end

        showSlider(t13, Attribute)
        LocalPlayer:SetAttribute(t3[v45], Attribute)

        local elapsed = os.clock()

        if not (p25 or elapsed - t13.sentAt >= 0.15) then
            return
        end

        if t13.sent ~= Attribute then
            SettingChange:FireServer(v45, Attribute)
        end

        t13.sent = Attribute
        t13.sentAt = elapsed
    end

    local function begin(p26) -- line: 264
        -- upvalues: t13 (copy), move (copy)
        if t13.input or p26.UserInputType ~= Enum.UserInputType.MouseButton1 and p26.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        t13.input = p26
        move(p26.Position.X)
    end

    Slider.InputBegan:Connect(begin)
    t13.knob.InputBegan:Connect(begin)
    UserInputService.InputChanged:Connect(function(p27) -- line: 273
        -- upvalues: t13 (copy), move (copy)
        if t13.input and (p27 == t13.input or t13.input.UserInputType == Enum.UserInputType.MouseButton1 and p27.UserInputType == Enum.UserInputType.MouseMovement) then
            move(p27.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(p28) -- line: 279
        -- upvalues: SettingChange (copy), LocalPlayer (copy), t3 (copy), t4 (copy), showSlider (copy), v45 (copy), Slider (copy), t13 (copy)
        if p28 ~= t13.input then
            return
        end

        t13.input = nil

        local X = p28.Position.X
        local X2 = Slider.AbsoluteSize.X
        local Attribute

        if X2 <= 0 then
            Attribute = LocalPlayer:GetAttribute(t3[v45])

            if type(Attribute) ~= type(t4[v45]) then
                Attribute = t4[v45]
            end
        else
            Attribute = t13.scale.toValue((math.clamp((X - Slider.AbsolutePosition.X) / X2, 0, 1)))
        end

        showSlider(t13, Attribute)
        LocalPlayer:SetAttribute(t3[v45], Attribute)

        local elapsed = os.clock()

        if t13.sent ~= Attribute then
            SettingChange:FireServer(v45, Attribute)
        end

        t13.sent = Attribute
        t13.sentAt = elapsed
    end)
    Slider.Selectable = true
    Slider.NextSelectionLeft = Slider
    Slider.NextSelectionRight = Slider
    UserInputService.InputBegan:Connect(function(p29) -- line: 289
        -- upvalues: SettingChange (copy), LocalPlayer (copy), SoundService (copy), t3 (copy), t4 (copy), showSlider (copy), v45 (copy), Slider (copy), t13 (copy)
        if game:GetService("GuiService").SelectedObject ~= Slider then
            return
        end

        local v56 = if p29.KeyCode == Enum.KeyCode.DPadRight then 1 elseif p29.KeyCode == Enum.KeyCode.DPadLeft then -1 else 0

        if v56 ~= 0 then
            local toT = t13.scale.toT
            local Attribute = LocalPlayer:GetAttribute(t3[v45])

            if type(Attribute) ~= type(t4[v45]) then
                Attribute = t4[v45]
            end

            local v60 = math.clamp(toT(Attribute) + v56 * 0.05, 0, 1)
            local v62 = math.floor(t13.scale.toValue(v60) * 100 + 0.5) / 100

            LocalPlayer:SetAttribute(t3[v45], v62)
            SettingChange:FireServer(v45, v62)
            showSlider(t13, v62)

            local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
            local TileSelect = HarpoonSFX and HarpoonSFX:FindFirstChild("TileSelect")

            if TileSelect then
                TileSelect:Play()
            end
        end
    end)

    if t13.box then
        t13.box.FocusLost:Connect(function() -- line: 301
            -- upvalues: SettingChange (copy), LocalPlayer (copy), SoundService (copy), t3 (copy), t4 (copy), showSlider (copy), v45 (copy), v47 (copy), v48 (copy), t13 (copy)
            local v64 = tonumber((t13.box.Text:gsub("[^%d%.%-]", "")))

            if v64 and t13.pct then
                v64 /= 100
            end

            if v64 and v64 == v64 then
                local v66 = math.floor(math.clamp(v64, v47, v48) * 100 + 0.5) / 100

                LocalPlayer:SetAttribute(t3[v45], v66)
                SettingChange:FireServer(v45, v66)

                local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
                local TileSelect = HarpoonSFX and HarpoonSFX:FindFirstChild("TileSelect")

                if TileSelect then
                    TileSelect:Play()
                end
            end

            local Attribute = LocalPlayer:GetAttribute(t3[v45])

            if type(Attribute) ~= type(t4[v45]) then
                Attribute = t4[v45]
            end

            showSlider(t13, Attribute)
        end)
    end
end

local function refresh(p30) -- line: 316
    -- upvalues: LocalPlayer (copy), t3 (copy), t4 (copy), v22 (copy), v23 (copy), v24 (copy), t6 (copy), v25 (copy), UIGradient (copy), Knob (copy), Checker (copy), t7 (copy), v28 (copy), v29 (copy), v30 (copy), v31 (copy), t8 (copy), t9 (copy), showSlider (copy)
    local Attribute = LocalPlayer:GetAttribute(t3.OtherAquariums)

    if type(Attribute) ~= type(t4.OtherAquariums) then
        Attribute = t4.OtherAquariums
    end

    v22(Attribute, p30)

    local Attribute2 = LocalPlayer:GetAttribute(t3.AquariumSounds)

    if type(Attribute2) ~= type(t4.AquariumSounds) then
        Attribute2 = t4.AquariumSounds
    end

    v23(Attribute2, p30)

    local Attribute3 = LocalPlayer:GetAttribute(t3.ReduceFx)

    if type(Attribute3) ~= type(t4.ReduceFx) then
        Attribute3 = t4.ReduceFx
    end

    v24(Attribute3, p30)

    local Attribute4 = LocalPlayer:GetAttribute(t3.OfferPopups)

    if type(Attribute4) ~= type(t4.OfferPopups) then
        Attribute4 = t4.OfferPopups
    end

    v25(Attribute4 or LocalPlayer:GetAttribute("Buyer") ~= true, p30)

    local v73 = LocalPlayer:GetAttribute("Buyer") ~= true

    UIGradient.Color = v73 and t6.FILL or t7.fill
    Knob.BackgroundColor3 = v73 and t6.KNOB or t7.knob
    Checker.GroupTransparency = if v73 then 1 else t7.checker

    local Attribute5 = LocalPlayer:GetAttribute(t3.GlobalMessages)

    if type(Attribute5) ~= type(t4.GlobalMessages) then
        Attribute5 = t4.GlobalMessages
    end

    v28(Attribute5, p30)
    v29(LocalPlayer:GetAttribute("Potato") == true, p30)

    local Attribute6 = LocalPlayer:GetAttribute(t3.HudSize)

    if type(Attribute6) ~= type(t4.HudSize) then
        Attribute6 = t4.HudSize
    end

    for v77, v78 in pairs(t8) do
        v78.ImageColor3 = v77 == Attribute6 and v30 or v31
    end

    for _, v79 in ipairs(t9) do
        if not v79.input then
            local key = v79.key
            local Attribute = LocalPlayer:GetAttribute(t3[key])

            if type(Attribute) ~= type(t4[key]) then
                Attribute = t4[key]
            end

            showSlider(v79, Attribute)
        end
    end
end

for _, v82 in pairs(t3) do
    LocalPlayer:GetAttributeChangedSignal(v82):Connect(function() -- line: 330
        -- upvalues: refresh (copy)
        refresh(false)
    end)
end

LocalPlayer:GetAttributeChangedSignal("Potato"):Connect(function() -- line: 332
    -- upvalues: refresh (copy)
    refresh(false)
end)
LocalPlayer:GetAttributeChangedSignal("Buyer"):Connect(function() -- line: 333
    -- upvalues: refresh (copy)
    refresh(false)
end)
refresh(false)

local Toast = require(Modules:WaitForChild("Toast"))
local RewardScreen = require(Modules:WaitForChild("RewardScreen"))
local RewardCards = require(Modules:WaitForChild("RewardCards"))
local PurchaseFX = require(Modules:WaitForChild("PurchaseFX"))
local RedeemCode = Remotes:WaitForChild("RedeemCode")
local Codes = Rows:WaitForChild("Codes")
local Box = Codes:WaitForChild("Box")
local Loc = require(Modules:WaitForChild("Loc"))
local PlaceholderText = Box.PlaceholderText

local function hint() -- line: 348
    -- upvalues: Box (copy), Loc (copy), PlaceholderText (copy)
    Box.PlaceholderText = Loc.T(PlaceholderText)
end

Loc.Changed:Connect(hint)
Box.PlaceholderText = Loc.T(PlaceholderText)

local Submit = Codes:WaitForChild("Submit")
local UIStroke = Box:FindFirstChildOfClass("UIStroke")
local t14 = {
    SHAKE = 0.012,
    SHAKE_TIME = 0.05,
    FLASH_TIME = 0.45,
    WAIT_FADE = 0.4,
    GOOD = Color3.fromRGB(80, 230, 110),
    BAD = Color3.fromRGB(255, 80, 80)
}
local t15 = {
    invalid = "Invalid code!",
    used = "Code already redeemed!",
    expired = "That code has expired!",
    slow = "Slow down!",
    busy = "Try again in a moment!",
    empty = "Type a code first!"
}
local BoxPosition = Box.Position
local v83 = UIStroke and UIStroke.Color
local v84, v85

local function flash(p31) -- line: 372
    -- upvalues: TweenService (copy), UIStroke (copy), t14 (copy), v85 (ref), v83 (copy)
    if not UIStroke then
        return
    end

    if v85 then
        v85:Cancel()
    end

    UIStroke.Color = p31
    v85 = TweenService:Create(UIStroke, TweenInfo.new(t14.FLASH_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Color = v83
    })
    v85:Play()
end

local function refuse(p32) -- line: 379
    -- upvalues: TweenService (copy), Toast (copy), Box (copy), t14 (copy), t15 (copy), BoxPosition (copy), v84 (ref), flash (copy)
    if v84 then
        v84:Cancel()
    end

    Box.Position = BoxPosition
    v84 = TweenService:Create(Box, TweenInfo.new(t14.SHAKE_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true), {
        Position = BoxPosition + UDim2.fromScale(t14.SHAKE, 0)
    })
    v84.Completed:Once(function(p33) -- line: 384
        -- upvalues: Box (copy), BoxPosition (copy)
        if p33 == Enum.PlaybackState.Completed then
            Box.Position = BoxPosition
        end
    end)
    v84:Play()
    flash(t14.BAD)
    Toast.Show(t15[p32] or "Invalid code!", "", nil, Toast.RED, "deny")
end

local v86 = false

local function redeem() -- line: 392
    -- upvalues: ButtonHover (copy), RewardScreen (copy), RewardCards (copy), PurchaseFX (copy), RedeemCode (copy), Box (copy), Submit (copy), t14 (copy), flash (copy), refuse (copy), v86 (ref)
    if v86 then
        return
    end

    local Text = Box.Text

    if not Text:match("%S") then
        refuse("empty")

        return
    end

    v86 = true
    ButtonHover.Press(Submit)
    Submit.ImageTransparency = t14.WAIT_FADE
    task.spawn(function() -- line: 399
        -- upvalues: Text (copy), RewardScreen (copy), RewardCards (copy), PurchaseFX (copy), RedeemCode (copy), Box (copy), Submit (copy), t14 (copy), flash (copy), refuse (copy), v86 (ref)
        local function v87() -- line: 400
            -- upvalues: Text (copy), RedeemCode (copy)
            return RedeemCode:InvokeServer(Text)
        end

        local v88, v89, v90 = pcall(v87)

        Submit.ImageTransparency = 0
        v86 = false

        if not v88 then
            refuse("busy")

            return
        end

        if v89 ~= "ok" then
            refuse(v89)

            return
        end

        Box.Text = ""
        flash(t14.GOOD)
        PurchaseFX.Success()

        local t16 = {}
        local _ipairs = ipairs

        if type(v90) ~= "table" or not v90 then
            v90 = {}
        end

        for _, v91 in _ipairs(v90) do
            t16[#t16 + 1] = RewardCards.Card(v91)
        end

        if #t16 > 0 then
            RewardScreen.Show(t16, nil, "CODE REDEEMED!")
        end
    end)
end

ButtonHover.Attach(Submit, {
    shine = false,
    tile = 1,
    icon = Submit:FindFirstChild("Icon")
})
Submit.Activated:Connect(redeem)
Box.FocusLost:Connect(function(p34) -- line: 415
    -- upvalues: redeem (copy)
    if p34 then
        redeem()
    end
end)

local UpdateLog = require(script:WaitForChild("UpdateLog"))
local v92 = false
local v93 = false
local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local close, closeLog

local function logPanel() -- line: 429
    -- upvalues: PlayerGui (copy)
    local UpdateLogGui = PlayerGui:FindFirstChild("UpdateLogGui")

    return UpdateLogGui and UpdateLogGui:FindFirstChild("Panel")
end

local function padLog() -- line: 433
    -- upvalues: PlayerGui (copy), UpdateLog (copy), PadMenu (copy), closeLog (ref)
    local UpdateLogGui = PlayerGui:FindFirstChild("UpdateLogGui")
    local Panel = UpdateLogGui and UpdateLogGui:FindFirstChild("Panel")

    if not Panel then
        return
    end

    PadMenu.Open(Panel, function() -- line: 436
        -- upvalues: closeLog (ref)
        if closeLog then
            closeLog()
        end
    end, {
        first = UpdateLog.First,
        closeButton = Panel:FindFirstChild("Main") and Panel.Main:FindFirstChild("Close")
    })
end

local function open() -- line: 440
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), Close (copy), refresh (copy), UpdateLog (copy), v92 (ref), v93 (ref), PadMenu (copy), close (ref)
    if v93 or v92 or UpdateLog.IsOpen() then
        return
    end

    v93 = true
    v92 = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    PanelFocus.MakeWay(function() -- line: 444
        -- upvalues: UpdateLog (copy), v92 (ref)
        return v92 or UpdateLog.IsOpen()
    end)
    refresh(false)
    Scale.Scale = PanelFocus.FEEL.FROM
    Panel.Visible = true
    PanelFocus.Focus(true)

    local tween = TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 450
        -- upvalues: v93 (ref)
        v93 = false
    end)
    tween:Play()
    PadMenu.Open(Panel, function() -- line: 452
        -- upvalues: close (ref)
        if close then
            close()
        end
    end, {
        closeButton = Close
    })
end

local function close2() -- line: 454
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), v92 (ref), v93 (ref), PadMenu (copy)
    if v93 or not v92 then
        return
    end

    v93 = true
    v92 = false
    PadMenu.Close(Panel)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    PanelFocus.Focus(false)

    local tween = TweenService:Create(Scale, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function() -- line: 461
        -- upvalues: PanelFocus (copy), Panel (copy), v93 (ref)
        Panel.Visible = false
        PanelFocus.GiveBack()
        task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 464
            -- upvalues: v93 (ref)
            v93 = false
        end)
    end)
    tween:Play()
end

close = close2
Button.Activated:Connect(open)
Close.Activated:Connect(close2)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})

local function closeLog2() -- line: 474
    -- upvalues: PanelFocus (copy), PlayerGui (copy), UpdateLog (copy), v93 (ref), PadMenu (copy)
    local UpdateLogGui = PlayerGui:FindFirstChild("UpdateLogGui")
    local Panel = UpdateLogGui and UpdateLogGui:FindFirstChild("Panel")

    if Panel then
        PadMenu.Close(Panel)
    end

    UpdateLog.Close()
    v93 = true
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    PanelFocus.Focus(false)
    task.delay(PanelFocus.FEEL.CLOSE_TIME, function() -- line: 481
        -- upvalues: PanelFocus (copy), v93 (ref)
        PanelFocus.GiveBack()
        task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 483
            -- upvalues: v93 (ref)
            v93 = false
        end)
    end)
end

local Updates = Panel:WaitForChild("LeftTabs"):WaitForChild("Updates")

ButtonHover.Attach(Updates, {
    tile = 1,
    iconTilt = 20,
    highlight = true,
    highlightCorner = 0.135,
    highlightFade = 0.8,
    icon = Updates:WaitForChild("Icon")
})
Updates.Activated:Connect(function() -- line: 489
    -- upvalues: TweenService (copy), ButtonHover (copy), PanelFocus (copy), Panel (copy), Scale (copy), UpdateLog (copy), v92 (ref), v93 (ref), PadMenu (copy), padLog (copy), closeLog2 (copy), Updates (copy)
    ButtonHover.Press(Updates)

    if v93 or not v92 then
        return
    end

    v93 = true
    v92 = false

    local tween = TweenService:Create(Scale, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function(p35) -- line: 494
        -- upvalues: Panel (copy), v92 (ref), v93 (ref)
        if p35 == Enum.PlaybackState.Completed and not v92 then
            Panel.Visible = false
        end

        v93 = false
    end)
    tween:Play()
    PadMenu.Close(Panel)
    UpdateLog.Open(closeLog2)
    padLog()
end)
closeLog = closeLog2

local function onMyHarpoon() -- line: 507
    -- upvalues: LocalPlayer (copy)
    for _, child in ipairs(workspace:WaitForChild("Plots"):GetChildren()) do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            local Harpoon = child:FindFirstChild("Harpoon")

            return Harpoon ~= nil and Harpoon:GetAttribute("OccupantUserId") == LocalPlayer.UserId
        end
    end

    return false
end

local function popLog() -- line: 517
    -- upvalues: PanelFocus (copy), LocalPlayer (copy), PlayerGui (copy), UpdateLog (copy), v92 (ref), v93 (ref), padLog (copy), closeLog2 (copy), onMyHarpoon (copy)
    if LocalPlayer:GetAttribute("UpdatePopup") then
        LocalPlayer:SetAttribute("UpdatePopup", nil)
        task.spawn(function() -- line: 520
            -- upvalues: PanelFocus (copy), LocalPlayer (copy), PlayerGui (copy), UpdateLog (copy), v92 (ref), v93 (ref), padLog (copy), closeLog2 (copy), onMyHarpoon (copy)
            local elapsed = os.clock()

            while (PlayerGui:FindFirstChild("LoadingGui")
                or LocalPlayer:GetAttribute("PanelOpen")
                or LocalPlayer:GetAttribute("Cinematic")
                or LocalPlayer:GetAttribute("OfflinePending")
                or onMyHarpoon()
                or v93
                or v92) and os.clock() - elapsed < 1800 do
                task.wait(0.5)
            end

            if v93 or v92 or UpdateLog.IsOpen() or LocalPlayer:GetAttribute("PanelOpen") or onMyHarpoon() then
                return
            end

            v93 = true
            PanelFocus.MakeWay(function() -- line: 531
                -- upvalues: UpdateLog (copy), v92 (ref)
                return v92 or UpdateLog.IsOpen()
            end)
            PanelFocus.Focus(true)
            UpdateLog.Open(closeLog2)
            padLog()
            task.delay(PanelFocus.FEEL.OPEN_TIME, function() -- line: 535
                -- upvalues: v93 (ref)
                v93 = false
            end)
        end)
    end
end

LocalPlayer:GetAttributeChangedSignal("UpdatePopup"):Connect(popLog)
popLog()
Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 541
    -- upvalues: PanelFocus (copy), PlayerGui (copy), Panel (copy), UpdateLog (copy), v92 (ref), v93 (ref), PadMenu (copy)
    if UpdateLog.IsOpen() then
        local UpdateLogGui = PlayerGui:FindFirstChild("UpdateLogGui")
        local Panel = UpdateLogGui and UpdateLogGui:FindFirstChild("Panel")

        if Panel then
            PadMenu.Close(Panel)
        end

        UpdateLog.Close(true)
        v93 = false
        PanelFocus.Focus(false, true)
        PanelFocus.GiveBackRight()
    elseif v92 then
        v92 = false
        v93 = false
        PadMenu.Close(Panel)
        PanelFocus.Focus(false, true)
        Panel.Visible = false
        PanelFocus.GiveBackRight()
    end
end)
