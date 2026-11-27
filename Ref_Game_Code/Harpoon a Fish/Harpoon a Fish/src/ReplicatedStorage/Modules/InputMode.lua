-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loc = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Loc"))
local TextService = game:GetService("TextService")
local BindableEvent = Instance.new("BindableEvent")
local t1 = {}

t1.Changed = BindableEvent.Event

local GuiService = game:GetService("GuiService")

local function v1() -- line: 41
    -- upvalues: GuiService (copy)
    return GuiService:IsTenFootInterface()
end

local ok, result = pcall(v1)
local v2 = ok and result == true

local function lastIsPad(p1) -- line: 43
    return p1 ~= nil and p1.Name:sub(1, 7) == "Gamepad"
end

local v3

local function isPad() -- line: 48
    -- upvalues: UserInputService (copy), v2 (copy), v3 (ref)
    if v3 == true or v3 == nil and v2 then
        return true
    end

    local function v4() -- line: 50
        -- upvalues: UserInputService (copy)
        return UserInputService.PreferredInput
    end

    local ok, result = pcall(v4)

    return ok and result == Enum.PreferredInput.Gamepad
end

local v5

if v3 ~= true and (v3 ~= nil or not v2) then
    local function v6() -- line: 50
        -- upvalues: UserInputService (copy)
        return UserInputService.PreferredInput
    end

    local ok, result = pcall(v6)

    v5 = ok

    if ok then
        v5 = result == Enum.PreferredInput.Gamepad
    end
else
    v5 = true
end

function t1.Pad() -- line: 54
    -- upvalues: v5 (ref)
    return v5
end

local function recheck() -- line: 55
    -- upvalues: UserInputService (copy), BindableEvent (copy), v2 (copy), v3 (ref), v5 (ref)
    local v7 = true

    if v3 ~= true and (v3 ~= nil or not v2) then
        local function v8() -- line: 50
            -- upvalues: UserInputService (copy)
            return UserInputService.PreferredInput
        end

        local ok, result = pcall(v8)

        v7 = ok and result == Enum.PreferredInput.Gamepad
    end

    if v7 ~= v5 then
        v5 = v7
        BindableEvent:Fire(v7)
    end
end

local function v9() -- line: 62
    -- upvalues: UserInputService (copy), recheck (copy)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(recheck)
end

pcall(v9)

local t2 = {
    Keyboard = true,
    MouseMovement = true,
    MouseButton1 = true,
    MouseButton2 = true,
    MouseButton3 = true,
    MouseWheel = true,
    Touch = true
}

UserInputService.LastInputTypeChanged:Connect(function(p2) -- line: 65
    -- upvalues: UserInputService (copy), BindableEvent (copy), v2 (copy), v3 (ref), v5 (ref), t2 (copy)
    if p2 ~= nil and p2.Name:sub(1, 7) == "Gamepad" then
        v3 = true
    else
        if not t2[p2.Name] then
            return
        end

        v3 = false
    end

    local v10 = true

    if v3 ~= true and (v3 ~= nil or not v2) then
        local function v11() -- line: 50
            -- upvalues: UserInputService (copy)
            return UserInputService.PreferredInput
        end

        local ok, result = pcall(v11)

        v10 = ok and result == Enum.PreferredInput.Gamepad
    end

    if v10 ~= v5 then
        v5 = v10
        BindableEvent:Fire(v10)
    end
end)
UserInputService.GamepadConnected:Connect(function() -- line: 72
    -- upvalues: BindableEvent (copy), v5 (ref)
    if v5 then
        BindableEvent:Fire(true)
    end
end)

local t3 = {}
local t4 = {
    hit = "UIClick",
    hook = "GameplayCollision",
    landed = "GameplayExplosion",
    splash = "GameplayCollision",
    light = "UIClick"
}

function t1.Rumble(p3) -- line: 76
    -- upvalues: v5 (ref), t3 (copy), t4 (copy)
    if not v5 then
        return
    end

    local v12 = t4[p3]

    if v12 then
        local v13 = t3[v12]
        local v14 = v13

        if not v13 then
            local function v15() -- line: 82
                -- upvalues: v12 (copy)
                local HapticEffect = Instance.new("HapticEffect")

                HapticEffect.Name = "PadRumble_" .. v12
                HapticEffect.Type = Enum.HapticEffectType[v12]
                HapticEffect.Parent = game:GetService("SoundService")

                return HapticEffect
            end

            local ok, result = pcall(v15)

            if not ok then
                return
            end

            v14 = result
            t3[v12] = result
        end

        local function v16() -- line: 93
            -- upvalues: v14 (ref)
            v14:Play()
        end

        pcall(v16)
    end
end

function t1.Icon(p4) -- line: 97
    -- upvalues: UserInputService (copy)
    local function v17() -- line: 98
        -- upvalues: p4 (copy), UserInputService (copy)
        return UserInputService:GetImageForKeyCode(p4)
    end

    local ok, result = pcall(v17)

    if not ok or not result then
        result = ""
    end

    return result
end

local t5 = {
    PLATE_ALPHA = 0.25,
    EDGE_ALPHA = 0.75,
    PAD_L = 0.13,
    ICON = 0.74,
    ICON_GAP = 0.06,
    GAP = 0.16,
    TEXT = 0.56,
    PAD_R = 0.34,
    PLATE = Color3.fromRGB(12, 20, 34),
    EDGE = Color3.fromRGB(255, 255, 255),
    TEXT_STROKE = Color3.fromRGB(10, 12, 18),
    FONT = Font.new("rbxasset://fonts/families/FredokaOne.json")
}

function t1.Prompt(p5, p6) -- line: 114
    -- upvalues: Loc (copy), TextService (copy), t1 (copy), v5 (ref), t5 (copy)
    p6 = p6 or {}

    local Frame = Instance.new("Frame")

    Frame.Name = p6.name or "PadPrompt"
    Frame.AnchorPoint = p6.anchor or Vector2.new(0.5, 0.5)
    Frame.Position = p6.position or UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(1, p6.height or 0.06)
    Frame.BackgroundColor3 = t5.PLATE
    Frame.BackgroundTransparency = t5.PLATE_ALPHA
    Frame.BorderSizePixel = 0
    Frame.ZIndex = p6.zIndex or 20
    Frame.Visible = false

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t5.EDGE
    UIStroke.Transparency = t5.EDGE_ALPHA
    UIStroke.Thickness = 0.04
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Label"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0, 0.5)
    TextLabel.FontFace = t5.FONT
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.ZIndex = Frame.ZIndex + 1

    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.Color = t5.TEXT_STROKE
    UIStroke2.Thickness = 0.12
    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke2.Parent = TextLabel
    TextLabel.Parent = Frame
    Frame.Parent = p5

    local t6 = {}
    local v19 = false
    local keys = p6.keys
    local v20 = keys

    if not keys then
        v20 = { p6.key }
    end

    local v21 = p6.text or ""

    local function redraw() -- line: 159
        -- upvalues: Frame (copy), UIAspectRatioConstraint (copy), TextLabel (copy), t6 (copy), v19 (ref), v20 (ref), v21 (ref), Loc (copy), TextService (copy), t1 (copy), v5 (ref), t5 (copy)
        local v22 = Loc.T(v21)

        TextLabel.Text = v22

        local v23 = TextService:GetTextSize(v22, 100, Enum.Font.FredokaOne, Vector2.new(1E+05, 1000)).X / 100 * t5.TEXT
        local v25 = math.max(0, #v20)
        local v28 = t5.PAD_L + v25 * t5.ICON + math.max(0, v25 - 1) * t5.ICON_GAP + (v25 > 0 and t5.GAP or 0) + v23 + t5.PAD_R

        UIAspectRatioConstraint.AspectRatio = v28

        for i = 1, math.max(v25, #t6) do
            local v30 = t6[i]

            if i <= v25 then
                local ImageLabel

                if v30 then
                    ImageLabel = v30
                else
                    ImageLabel = Instance.new("ImageLabel")
                    ImageLabel.Name = "Icon" .. i
                    ImageLabel.BackgroundTransparency = 1
                    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
                    ImageLabel.ZIndex = Frame.ZIndex + 1
                    ImageLabel.Parent = Frame
                    t6[i] = ImageLabel
                end

                ImageLabel.Visible = true
                ImageLabel.Image = t1.Icon(v20[i])
                ImageLabel.Size = UDim2.fromScale(t5.ICON / v28, t5.ICON)
                ImageLabel.Position = UDim2.fromScale((t5.PAD_L + (i - 1) * (t5.ICON + t5.ICON_GAP)) / v28, 0.5)
            elseif v30 then
                v30.Visible = false
            end
        end

        local v33 = t5.PAD_L + v25 * t5.ICON + math.max(0, v25 - 1) * t5.ICON_GAP + (v25 > 0 and t5.GAP or 0)

        TextLabel.Position = UDim2.fromScale(v33 / v28, 0.5)
        TextLabel.Size = UDim2.fromScale((v23 + t5.PAD_R * 0.5) / v28, t5.TEXT)
        Frame.Visible = v19 and v5
    end

    local t7 = {
        gui = Frame
    }

    function t7.Set(p7, p8) -- line: 196
        -- upvalues: v20 (ref), v21 (ref), redraw (copy)
        if p7 then
            v21 = p7
        end

        if typeof(p8) == "EnumItem" then
            v20 = { p8 }
        elseif type(p8) == "table" then
            v20 = p8
        end

        redraw()
    end

    function t7.Show(p9) -- line: 201
        -- upvalues: Frame (copy), v19 (ref), v5 (ref)
        v19 = p9 == true
        Frame.Visible = v19 and v5
    end

    t1.Changed:Connect(redraw)
    Loc.Changed:Connect(redraw)
    redraw()

    return t7
end

return t1
