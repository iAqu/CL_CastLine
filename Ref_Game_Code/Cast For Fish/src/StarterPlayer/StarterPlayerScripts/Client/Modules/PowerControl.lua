-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("UserInputService")

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameConfig = require(Shared.GameConfig)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local Pad = require(script.Parent.Pad)
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local Left = Enum.TextXAlignment.Left
local v1, v2, v3, v4, v5, v6, v7, TextButton, v8, v9, v10, v11, v12
local n1 = 1
local v13 = false
local t1 = {}

t1.Saves = 0

local function hex(p1) -- line: 33
    return string.format("#%02X%02X%02X", math.floor(p1.R * 255 + 0.5), math.floor(p1.G * 255 + 0.5), (math.floor(p1.B * 255 + 0.5)))
end

local function castPower() -- line: 37
    -- upvalues: GameConfig (copy), DataClient (copy)
    return DataClient.Get("CastPower") or GameConfig.START_CAST_POWER
end

local function powerAt(p2) -- line: 43
    -- upvalues: GameConfig (copy), DataClient (copy)
    local v19 = DataClient.Get("CastPower") or GameConfig.START_CAST_POWER

    if p2 >= 0.999 then
        return v19
    end

    local v20 = GameConfig.distanceForPower(1)
    local v21 = GameConfig.distanceForPower(v19)

    return (math.clamp(math.floor(GameConfig.powerForDistance(v20 + (v21 - v20) * p2) + 0.5), 1, v19))
end

local function positionFor(p3) -- line: 52
    -- upvalues: GameConfig (copy), DataClient (copy)
    local v24 = DataClient.Get("CastPower") or GameConfig.START_CAST_POWER

    if p3 <= 0 or v24 <= p3 then
        return 1
    end

    local v25 = GameConfig.distanceForPower(1)
    local v26 = GameConfig.distanceForPower(v24)

    return (math.clamp((GameConfig.distanceForPower(p3) - v25) / math.max(v26 - v25, 1E-06), 0, 1))
end

local function landsIn(p4) -- line: 63
    -- upvalues: GameConfig (copy), Roll (copy)
    local v30 = Roll.zoneAt(GameConfig.distanceForPower(p4 + GameConfig.METER_MIN))
    local v31 = Roll.zoneAt(GameConfig.distanceForPower(p4 + GameConfig.METER_MAX))
    local Color = v30.Color
    local v37 = ("<font color=\"%s\">%s</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v30.name))

    if v31 ~= v30 then
        local Color = v31.Color

        v37 ..= (" or <font color=\"%s\">%s</font>"):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), string.upper(v31.name))
    end

    return v37
end

local function show(p5) -- line: 73
    -- upvalues: GameConfig (copy), NumberFormat (copy), DataClient (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), landsIn (copy)
    n1 = math.clamp(p5, 0, 1)

    local v43 = n1
    local v44 = DataClient.Get("CastPower") or GameConfig.START_CAST_POWER

    if not (v43 >= 0.999) then
        local v45 = GameConfig.distanceForPower(1)
        local v46 = GameConfig.distanceForPower(v44)

        v44 = math.clamp(math.floor(GameConfig.powerForDistance(v45 + (v46 - v45) * v43) + 0.5), 1, v44)
    end

    local v49 = (DataClient.Get("CastPower") or GameConfig.START_CAST_POWER) <= v44
    local v50 = v5

    v50.Size = UDim2.fromScale(n1, 1)

    local v51 = v6

    v51.Position = UDim2.fromScale(n1, 0.5)

    local v52 = v2

    v52.Text = NumberFormat.abbr(v44)
    v3.Visible = v49

    local v53 = v4

    v53.Text = "Lands in: " .. landsIn(v44)
end

local t2 = {}

t2.__index = t2

function t2.new() -- line: 87
    -- upvalues: t2 (copy)
    return (setmetatable({
        Blocked = false,
        Next = 0
    }, t2))
end

local function overlaps(p6, p7) -- line: 91
    local AbsolutePosition, AbsoluteSize = p6.AbsolutePosition, p6.AbsoluteSize
    local AbsolutePosition2, AbsoluteSize2 = p7.AbsolutePosition, p7.AbsoluteSize

    if AbsolutePosition.X < AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.X < AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < AbsolutePosition2.Y + AbsoluteSize2.Y then
        return AbsolutePosition2.Y < AbsolutePosition.Y + AbsoluteSize.Y
    end

    return false
end

function t2.Check(p8, p9) -- line: 96
    local Held = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Held")

    Held = Held and Held.Enabled and Held:FindFirstChild("Panel")

    local v54 = false

    if Held and Held.Visible then
        for _, child in ipairs(Held:GetChildren()) do
            if child:IsA("GuiButton") and child.Visible then
                for _, v56 in ipairs(p9) do
                    local AbsolutePosition, AbsoluteSize = v56.AbsolutePosition, v56.AbsoluteSize
                    local AbsolutePosition2, AbsoluteSize2 = child.AbsolutePosition, child.AbsoluteSize

                    if AbsolutePosition.X < AbsolutePosition2.X + AbsoluteSize2.X and AbsolutePosition2.X < AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < AbsolutePosition2.Y + AbsoluteSize2.Y and AbsolutePosition2.Y < AbsolutePosition.Y + AbsoluteSize.Y then
                        v54 = true
                    end
                end
            end
        end
    end

    p8.Blocked = v54

    return v54
end

local v57 = t2.new()

local function refresh() -- line: 117
    -- upvalues: GameConfig (copy), NumberFormat (copy), DataClient (copy), v9 (ref), v10 (ref), v13 (ref), positionFor (copy), show (copy), v57 (copy)
    local v58 = DataClient.Get("CastLimit") or 0
    local v59 = v58 > 0 and v58 < (DataClient.Get("CastPower") or GameConfig.START_CAST_POWER)

    if not v13 then
        show((positionFor(v58)))
    end

    local v60 = v9

    v60.Visible = v59 and not v57.Blocked

    if v59 then
        local v61 = v10

        v61.Text = "Throwing " .. NumberFormat.abbr(v58)
    end
end

local function placeGear() -- line: 130
    -- upvalues: HUD (copy), TextButton (ref), v9 (ref)
    local PowerLabel = HUD.PowerLabel
    local v62 = PowerLabel.AbsoluteSize.Y / 100

    if not (v62 > 0) then
        return
    end

    local v63 = 124 + PowerLabel.TextBounds.X / v62 + 16
    local TextButton2 = TextButton

    TextButton2.Position = UDim2.new(0, v63, 0.5, 0)

    local v64 = v9

    v64.Position = UDim2.new(0, v63 + 72, 0.5, 0)
end

local v65

local function setOpen(p10) -- line: 144
    -- upvalues: HUD (copy), Pad (copy), t1 (copy), v1 (ref), v7 (ref), v65 (ref)
    v1.Visible = p10

    local PowerRow = HUD.PowerRow

    if p10 then
        local Y = workspace.CurrentCamera.ViewportSize.Y

        if PowerRow.AbsolutePosition.Y + PowerRow.AbsoluteSize.Y / 2 < Y / 2 then
            local v66 = v1

            v66.AnchorPoint = Vector2.new(0, 0)

            local v67 = v1

            v67.Position = UDim2.fromOffset(-4, PowerRow.Size.Y.Offset + 14)
        else
            local v68 = v1

            v68.AnchorPoint = Vector2.new(0, 1)

            local v69 = v1

            v69.Position = UDim2.fromOffset(-4, -14)
        end

        v65 = v65 or PowerRow.ZIndex
        PowerRow.ZIndex = 60
        Pad.PushBack("PowerPanel", function() -- line: 159
            -- upvalues: t1 (copy)
            t1.Open(false)
        end)
        Pad.Select(v7)
    else
        if v65 then
            PowerRow.ZIndex = v65
        end

        Pad.PopBack("PowerPanel")
        Pad.Deselect(v1)
    end
end

local function save() -- line: 174
    -- upvalues: Remotes (copy), GameConfig (copy), DataClient (copy), t1 (copy), n1 (ref), v13 (ref), refresh (copy)
    v13 = false
    t1.Saves += 1

    local v70 = n1
    local v71 = DataClient.Get("CastPower") or GameConfig.START_CAST_POWER

    if not (v70 >= 0.999) then
        local v72 = GameConfig.distanceForPower(1)
        local v73 = GameConfig.distanceForPower(v71)

        v71 = math.clamp(math.floor(GameConfig.powerForDistance(v72 + (v73 - v72) * v70) + 0.5), 1, v71)
    end

    if (DataClient.Get("CastPower") or GameConfig.START_CAST_POWER) <= v71 then
        v71 = 0
    end

    if v71 == (DataClient.Get("CastLimit") or 0) then
        refresh()
    else
        local spawn = task.spawn
        local v76 = v71

        spawn(function() -- line: 183
            -- upvalues: v76 (copy), Remotes (copy), refresh (copy)
            local function v77() -- line: 184
                -- upvalues: v76 (copy), Remotes (copy)
                return Remotes.SetCastLimit:InvokeServer(v76)
            end

            local ok, result = pcall(v77)

            if not ok or not result then
                refresh()
            end
        end)
    end
end

function t1.Open(p11) -- line: 193
    -- upvalues: UIKit (copy), v1 (ref), refresh (copy), setOpen (copy)
    local v78 = if p11 == nil then not v1.Visible else p11

    setOpen(v78)

    if not v78 then
        return
    end

    refresh()
    UIKit.pop(v1, 0.7)
    UIKit.sound("WindowOpen")
end

function t1.Init() -- line: 203
    -- upvalues: RunService (copy), GameConfig (copy), UIKit (copy), DataClient (copy), HUD (copy), Pad (copy), t1 (copy), Colors (copy), fromRGB (copy), Left (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), TextButton (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), n1 (ref), v13 (ref), show (copy), v57 (copy), refresh (copy), placeGear (copy), v65 (ref), save (copy)
    local PowerRow = HUD.PowerRow

    TextButton = Instance.new("TextButton")
    TextButton.Name = "PowerGear"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromOffset(64, 64)
    TextButton.AnchorPoint = Vector2.new(0, 0.5)
    TextButton.ZIndex = 3
    TextButton.Parent = PowerRow
    v8 = UIKit.frame(TextButton, {
        Name = "Icon",
        Transparency = 1,
        ZIndex = 3,
        Size = UDim2.fromOffset(56, 56),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    UIKit.image(v8, "Gear", {
        ZIndex = 3,
        Size = UDim2.fromScale(1.12, 1.12),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    UIKit.bindPress(TextButton, function() -- line: 217
        -- upvalues: t1 (copy)
        t1.Open()
    end)
    v9 = UIKit.frame(PowerRow, {
        Name = "Limit",
        Corner = 22,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.fromOffset(250, 44),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = Colors.Orange,
        Color2 = Colors.OrangeDark
    })
    v10 = UIKit.text(v9, {
        Name = "Label",
        Text = "",
        TextSize = 26,
        Stroke = 3,
        ZIndex = 4
    })
    v9.Visible = false
    v1 = UIKit.frame(PowerRow, {
        Name = "PowerPanel",
        Corner = 26,
        Stroke = 6,
        ZIndex = 20,
        Size = UDim2.fromOffset(700, 262),
        Position = UDim2.fromOffset(-4, -14),
        AnchorPoint = Vector2.new(0, 1),
        Color = fromRGB(22, 22, 30)
    })
    v1.Visible = false
    v1.Active = true

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "TouchFix"
    UIScale.Parent = v1

    local function fitPanel() -- line: 234
        -- upvalues: UIScale (copy), HUD (copy)
        UIScale.Scale = if HUD.IsTouch() then 0.85 / (HUD.TOUCH_STAT_SCALE or 1) else 1
    end

    UIScale.Scale = if HUD.IsTouch() then 0.85 / (HUD.TOUCH_STAT_SCALE or 1) else 1
    HUD.TouchChanged:Connect(fitPanel)
    UIKit.icon(v1, "Power", {
        ZIndex = 21,
        Size = UDim2.fromOffset(64, 64),
        Position = UDim2.fromOffset(20, 12)
    })
    UIKit.text(v1, {
        Name = "Title",
        Text = "CAST POWER",
        TextSize = 36,
        Stroke = 5,
        ZIndex = 21,
        Size = UDim2.fromOffset(250, 44),
        Position = UDim2.fromOffset(92, 22),
        XAlign = Left
    })
    v2 = UIKit.text(v1, {
        Name = "Value",
        Text = "",
        TextSize = 38,
        Stroke = 5,
        ZIndex = 21,
        Size = UDim2.fromOffset(170, 44),
        Position = UDim2.fromOffset(336, 22),
        XAlign = Enum.TextXAlignment.Right,
        Color = Colors.Power,
        StrokeColor = Colors.PowerStroke
    })
    v3 = UIKit.text(v1, {
        Name = "Max",
        Text = "MAX",
        TextSize = 38,
        Stroke = 5,
        ZIndex = 21,
        Size = UDim2.fromOffset(100, 44),
        Position = UDim2.fromOffset(516, 22),
        XAlign = Left,
        Color = fromRGB(150, 250, 70),
        StrokeColor = Colors.CashStroke
    })
    v11 = UIKit.button(v1, {
        Name = "Close",
        Text = "X",
        Corner = 14,
        Stroke = 5,
        ZIndex = 22,
        Size = UDim2.fromOffset(56, 56),
        Position = UDim2.new(1, -16, 0, 14),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 243
            -- upvalues: t1 (copy)
            t1.Open(false)
        end
    })
    Pad.Icon(v11, Enum.KeyCode.ButtonB, {
        ZIndex = 23,
        Size = UDim2.fromOffset(34, 34),
        Position = UDim2.new(1, -4, 0, 4),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    v7 = UIKit.frame(v1, {
        Class = "TextButton",
        Name = "Track",
        Corner = 17,
        ZIndex = 21,
        Size = UDim2.new(1, -96, 0, 34),
        Position = UDim2.fromOffset(48, 100),
        Color = fromRGB(8, 8, 14)
    })
    v7.Text = ""
    v7.AutoButtonColor = false
    UIKit.stroke(v7, 5).ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v5 = UIKit.frame(v7, {
        Name = "Fill",
        Corner = 17,
        ZIndex = 22,
        Size = UDim2.fromScale(1, 1),
        Color = fromRGB(110, 190, 255),
        Color2 = fromRGB(40, 110, 240)
    })
    v6 = UIKit.frame(v7, {
        Name = "Knob",
        Corner = 32,
        Stroke = 6,
        ZIndex = 23,
        Size = UDim2.fromOffset(64, 64),
        Position = UDim2.fromScale(1, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.White
    })
    UIKit.frame(v6, {
        Name = "Dot",
        Corner = 13,
        ZIndex = 24,
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(40, 130, 240)
    })
    UIKit.text(v1, {
        Name = "Min",
        Text = "MIN",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 21,
        Size = UDim2.fromOffset(80, 22),
        Position = UDim2.fromOffset(48, 144),
        XAlign = Left,
        Color = Colors.Grey
    })
    UIKit.text(v1, {
        Name = "MaxEnd",
        Text = "MAX",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 21,
        Size = UDim2.fromOffset(80, 22),
        Position = UDim2.new(1, -48, 0, 144),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right,
        Color = Colors.Grey
    })
    v4 = UIKit.text(v1, {
        Name = "Lands",
        Text = "",
        TextSize = 34,
        Stroke = 5,
        ZIndex = 21,
        Size = UDim2.new(1, -60, 0, 44),
        Position = UDim2.fromOffset(30, 172),
        XAlign = Left
    })
    v4.RichText = true

    local v81 = UIKit.text(v1, {
        Name = "Hint",
        Text = "Turn it down to fish the nearer zones",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 21,
        Size = UDim2.new(1, -60, 0, 24),
        Position = UDim2.fromOffset(30, 222),
        XAlign = Left,
        Color = Colors.Grey
    })

    local function hintText() -- line: 261
        -- upvalues: v81 (copy), Pad (copy)
        v81.Text = Pad.Using() and "D-pad or stick: turn it down to fish the nearer zones" or "Turn it down to fish the nearer zones"
    end

    v81.Text = Pad.Using() and "D-pad or stick: turn it down to fish the nearer zones" or "Turn it down to fish the nearer zones"
    Pad.Changed:Connect(hintText)
    v12 = Pad.Slider(v7, {
        hit = Vector2.new(34, 26),
        get = function() -- get | line: 270
            -- upvalues: n1 (ref)
            return n1
        end,
        set = function(p12, p13) -- set | line: 273
            -- upvalues: v13 (ref), show (copy)
            v13 = true
            show(if p13 or not (p12 > 0.97) then p12 else 1)
        end,
        nudge = function(p14) -- nudge | line: 278
            -- upvalues: GameConfig (copy), UIKit (copy), DataClient (copy), n1 (ref), v13 (ref), show (copy)
            v13 = true

            local v83 = n1
            local v84 = DataClient.Get("CastPower") or GameConfig.START_CAST_POWER

            if not (v83 >= 0.999) then
                local v85 = GameConfig.distanceForPower(1)
                local v86 = GameConfig.distanceForPower(v84)

                v84 = math.clamp(math.floor(GameConfig.powerForDistance(v85 + (v86 - v85) * v83) + 0.5), 1, v84)
            end

            local v89 = n1

            for _ = 1, 50 do
                v89 = math.clamp(v89 + p14 * 0.01, 0, 1)

                local v91 = DataClient.Get("CastPower") or GameConfig.START_CAST_POWER

                if not (v89 >= 0.999) then
                    local v92 = GameConfig.distanceForPower(1)
                    local v93 = GameConfig.distanceForPower(v91)

                    v91 = math.clamp(math.floor(GameConfig.powerForDistance(v92 + (v93 - v92) * v89) + 0.5), 1, v91)
                end

                if v91 ~= v84 or v89 <= 0 or v89 >= 1 then
                    break
                end
            end

            show(v89)
            UIKit.sound("MeterTick", v89 * 0.5 + 0.9)
        end,
        grab = function() -- grab | line: 291
            -- upvalues: UIKit (copy), v6 (ref)
            UIKit.pop(v6, 1.2)
        end,
        done = function() -- done | line: 294
            -- upvalues: UIKit (copy), save (copy)
            UIKit.sound("Click")
            save()
        end
    })
    t1.Slider = v12
    DataClient.Observe("CastLimit", refresh)
    DataClient.Observe("CastPower", refresh)
    HUD.PowerLabel:GetPropertyChangedSignal("TextBounds"):Connect(placeGear)
    HUD.PowerLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeGear)
    placeGear()
    RunService.RenderStepped:Connect(function(p15) -- line: 307
        -- upvalues: GameConfig (copy), DataClient (copy), HUD (copy), Pad (copy), v1 (ref), TextButton (ref), v8 (ref), v9 (ref), v57 (copy), refresh (copy), v65 (ref)
        local elapsed = os.clock()

        if v57.Next <= elapsed then
            v57.Next = elapsed + 0.2

            local Blocked = v57.Blocked

            TextButton.Visible = true

            local v96 = DataClient.Get("CastLimit") or 0
            local t4 = if v96 > 0 and v96 < (DataClient.Get("CastPower") or GameConfig.START_CAST_POWER) then {
                TextButton,
                v9
            } else {
                TextButton
            }
            local v98 = v57:Check(t4)

            TextButton.Visible = not v98

            if v98 ~= Blocked then
                refresh()
            end
        end

        if v1.Visible then
            v8.Rotation = (v8.Rotation + p15 * 90) % 360

            if HUD.GetMode() == "cutscene" then
                v1.Visible = false

                local PowerRow = HUD.PowerRow

                if v65 then
                    PowerRow.ZIndex = v65
                end

                Pad.PopBack("PowerPanel")
                Pad.Deselect(v1)
            end
        end
    end)
end

return t1
