-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage:WaitForChild("Shared").GameConfig)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local fromRGB = Color3.fromRGB
local t1 = {}

t1.__index = t1

function t1.new() -- line: 12
    -- upvalues: UIKit (copy), HUD (copy), fromRGB (copy), t1 (copy)
    local self = setmetatable({}, t1)
    local v2 = UIKit.frame(HUD.Gui, {
        Name = "LuckBar",
        Transparency = 0.2,
        Corner = 18,
        Stroke = 4,
        Size = UDim2.fromOffset(400, 64),
        Position = UDim2.new(1, -18, 0, 180),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(14, 18, 34)
    })

    UIKit.clover(v2, 44, {
        ZIndex = 3,
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    UIKit.text(v2, {
        Name = "Title",
        Text = "LUCK BAR",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.fromOffset(120, 26),
        Position = UDim2.fromOffset(62, 4),
        XAlign = Enum.TextXAlignment.Left,
        Color = fromRGB(140, 255, 140)
    })
    self.Bonus = UIKit.text(v2, {
        Name = "Bonus",
        Text = "",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -196, 0, 26),
        Position = UDim2.new(1, -14, 0, 4),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right,
        Color = fromRGB(255, 230, 120)
    })

    local v3 = UIKit.frame(v2, {
        Name = "Track",
        Corner = 10,
        Stroke = 3,
        ZIndex = 2,
        Size = UDim2.new(1, -76, 0, 20),
        Position = UDim2.new(0, 62, 1, -8),
        AnchorPoint = Vector2.new(0, 1),
        Color = fromRGB(30, 34, 54)
    })

    self.Fill = UIKit.frame(v3, {
        Name = "Fill",
        Corner = 10,
        ZIndex = 3,
        Size = UDim2.fromScale(0, 1),
        Color = fromRGB(160, 250, 90),
        Color2 = fromRGB(40, 180, 60)
    })
    self.Panel = v2
    self.Last = nil
    HUD.AddGroup("LuckBar", v2, Vector2.new(520, 0))

    return self
end

function t1:Set(p2) -- line: 26
    -- upvalues: GameConfig (copy), UIKit (copy)
    local v6 = math.clamp(math.floor(p2 or 0), 0, GameConfig.PITY_MAX_STACKS)
    local v7 = v6 / GameConfig.PITY_MAX_STACKS

    UIKit.tween(self.Fill, 0.35, {
        Size = UDim2.fromScale(v7, 1)
    })
    self.Bonus.Text = ("+%d%% luck"):format((math.floor(v6 * GameConfig.PITY_STEP * 100 + 0.5)))

    if self.Last ~= nil then
        if self.Last < v6 then
            UIKit.pop(self.Panel, 1.08)
        elseif v6 < self.Last then
            UIKit.pop(self.Panel, 0.9)
        end
    end

    self.Last = v6
end

function t1.Start(p3) -- line: 41
    -- upvalues: DataClient (copy)
    p3:Set(DataClient.Get("Pity") or 0)
    DataClient.Observe("Pity", function(p4) -- line: 43
        -- upvalues: p3 (copy)
        p3:Set(p4 or 0)
    end)

    return p3
end

return t1
