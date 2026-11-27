-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local GameConfig = require(Shared.GameConfig)
local Zones = require(Shared.Data.Zones)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local fromRGB = Color3.fromRGB
local t1 = {}

t1.__index = t1

function t1.new() -- line: 16
    -- upvalues: UIKit (copy), HUD (copy), fromRGB (copy), t1 (copy)
    local self = setmetatable({}, t1)
    local v2 = UIKit.frame(HUD.Gui, {
        Name = "Goal",
        Transparency = 0.2,
        Corner = 18,
        Stroke = 4,
        Size = UDim2.fromOffset(400, 100),
        Position = UDim2.new(1, -18, 0, 70),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(14, 18, 34)
    })

    UIKit.text(v2, {
        Name = "Title",
        Text = "GOAL",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.fromOffset(14, 6),
        XAlign = Enum.TextXAlignment.Left,
        Color = fromRGB(255, 221, 40)
    })
    self.Text = UIKit.text(v2, {
        Name = "Text",
        Text = "",
        TextSize = 28,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -24, 0, 32),
        Position = UDim2.fromOffset(14, 28),
        XAlign = Enum.TextXAlignment.Left
    })
    self.Text.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 28
    UITextSizeConstraint.Parent = self.Text

    local v3 = UIKit.frame(v2, {
        Name = "Track",
        Corner = 13,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -28, 0, 26),
        Position = UDim2.new(0, 14, 1, -10),
        AnchorPoint = Vector2.new(0, 1),
        Color = fromRGB(30, 34, 54)
    })

    self.Fill = UIKit.frame(v3, {
        Name = "Fill",
        Corner = 13,
        ZIndex = 3,
        Size = UDim2.fromScale(0, 1),
        Color = fromRGB(120, 220, 255),
        Color2 = fromRGB(40, 130, 230)
    })
    self.Count = UIKit.text(v3, {
        Name = "Count",
        Text = "",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 4
    })
    self.Panel = v2
    self.LastKey = nil
    self.Hidden = nil
    HUD.AddGroup("Goal", v2, Vector2.new(520, 0))

    return self
end

function t1.NextZone(_, p2) -- line: 35
    -- upvalues: GameConfig (copy), Zones (copy)
    local v4 = GameConfig.distanceForPower(p2)

    for v5, v6 in ipairs(Zones.List) do
        if v4 < v6.startDistance then
            return v6, v5, (math.ceil((GameConfig.powerForDistance(v6.startDistance))))
        end
    end

    return nil
end

function t1:Update() -- line: 45
    -- upvalues: NumberFormat (copy), UIKit (copy), DataClient (copy)
    if not DataClient.IsReady() then
        self.Panel.Visible = false

        return
    end

    local v8 = self.Hidden and self.Hidden() or false

    self.Panel.Visible = not v8

    if not v8 then
        local v9 = DataClient.Get("CastPower") or 0
        local v10, _, v11 = self:NextZone(v9)
        local v12

        if v10 then
            self.Text.Text = ("Reach %s %s"):format(v10.icon or "", v10.name)
            self.Count.Text = ("%s / %s Cast Power"):format(NumberFormat.abbr((math.floor(v9))), NumberFormat.abbr(v11))
            self.Fill.Size = UDim2.fromScale(math.clamp(v9 / math.max(v11, 1), 0, 1), 1)
            v12 = v10.id
        else
            self.Text.Text = "Every zone reached! Try a Rebirth"
            self.Count.Text = "MAX"
            v12 = "max"
            self.Fill.Size = UDim2.fromScale(1, 1)
        end

        if self.LastKey and self.LastKey ~= v12 then
            UIKit.pop(self.Panel, 1.15)
            UIKit.sound("ZoneChange", 1.2)
        end

        self.LastKey = v12
    end
end

function t1.Start(p4) -- line: 76
    -- upvalues: RunService (copy), DataClient (copy)
    p4:Update()
    DataClient.Observe("CastPower", function() -- line: 78
        -- upvalues: p4 (copy)
        p4:Update()
    end)

    local n1 = 0

    RunService.Heartbeat:Connect(function(p5) -- line: 82
        -- upvalues: p4 (copy), n1 (ref)
        n1 += p5

        if n1 >= 0.5 then
            n1 = 0
            p4:Update()
        end
    end)

    return p4
end

return t1
