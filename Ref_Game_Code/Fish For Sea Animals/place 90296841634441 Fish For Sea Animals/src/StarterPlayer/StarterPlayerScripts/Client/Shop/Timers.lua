-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Products = require(ReplicatedStorage.Shared.Products)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Hud = require(script.Parent.Parent.UI.Hud)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}
local v1

local function tile(p1, p2, p3, p4, p5) -- line: 22
    -- upvalues: UIUtil (copy), Kit (copy), Style (copy), t2 (copy), v1 (ref)
    local v2 = t2[p1]

    if v2 then
        return v2
    end

    local v3 = Kit.frame(v1, {
        BackgroundTransparency = 1,
        Name = p1,
        Size = UDim2.fromOffset(72, 100),
        LayoutOrder = p5
    })
    local v4 = Kit.frame(v3, {
        Name = "Icon",
        BackgroundColor3 = p4,
        Size = UDim2.fromOffset(72, 72)
    })

    Kit.corner(v4, 16)
    Kit.stroke(v4, 4)
    Kit.shade(v4, 0.65)
    Style.icon(v4, p2).Size = UDim2.fromScale(0.8, 0.8)
    Kit.text(v4, p3, {
        Name = "Badge",
        Rotation = 10,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 6, 0, -8),
        Size = UDim2.fromOffset(44, 24),
        TextColor3 = Style.YELLOW
    }).ZIndex = 2
    Kit.text(v3, "", {
        Name = "Time",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.new(1, 16, 0, 24)
    })
    t2[p1] = v3
    UIUtil.pop(v4, 0.4)

    return v3
end

local function drop(p6) -- line: 62
    -- upvalues: t2 (copy)
    if t2[p6] then
        t2[p6]:Destroy()
        t2[p6] = nil
    end
end

local t3 = {
    Cash = Style.KELP,
    Strength = Style.CORAL,
    Luck = Style.MINT
}
local t6 = {
    {
        Name = "ServerLuck",
        Icon = Config.Icons.Luck,
        Color = Style.SEAFOAM,
        Now = function() -- Now | line: 76
            return (workspace:GetAttribute("ServerLuckUntil") or 0) - workspace:GetServerTimeNow(), workspace:GetAttribute("ServerLuckMult") or 2
        end
    },
    {
        Name = "StrengthBoost",
        Icon = Config.Icons.Strength,
        Color = Style.CORAL,
        Now = function() -- Now | line: 84
            -- upvalues: Products (copy), LocalPlayer (copy)
            return Products.strengthBoostNow(LocalPlayer)
        end
    }
}

local function refresh() -- line: 90
    -- upvalues: Products (copy), Style (copy), LocalPlayer (copy), t2 (copy), tile (copy), t3 (copy), t6 (copy)
    for v5, v6 in Products.PackPotions do
        local Attribute = LocalPlayer:GetAttribute("Potion_" .. v6.Stat)

        if Attribute then
            tile(v6.Stat, v6.Image, ("x%*"):format(Products.PotionMult), t3[v6.Stat], v5).Time.Text = Style.clock(Attribute)
        else
            local Stat = v6.Stat

            if t2[Stat] then
                t2[Stat]:Destroy()
                t2[Stat] = nil
            end
        end
    end

    for v7, v8 in t6 do
        local v9, v10 = v8.Now()

        if v9 > 0 then
            local v11 = ("x%*"):format(v10)
            local v12 = tile(v8.Name, v8.Icon, v11, v8.Color, 9 + v7)

            v12.Time.Text = Style.clock(v9)
            v12.Icon.Badge.Text = v11
        else
            local Name = v8.Name

            if t2[Name] then
                t2[Name]:Destroy()
                t2[Name] = nil
            end
        end
    end
end

function t1.init() -- line: 112
    -- upvalues: Hud (copy), Kit (copy), LocalPlayer (copy), v1 (ref), refresh (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "BoostTimers"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 2
    v1 = Kit.frame(ScreenGui, {
        Name = "Icons",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -18, 1, -18),
        Size = UDim2.fromOffset(500, 100)
    })

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v1

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.Padding = UDim.new(0, 12)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = v1
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    Hud.onVisibility(function(p7) -- line: 135
        -- upvalues: v1 (ref)
        v1.Visible = p7
    end)
    task.spawn(function() -- line: 138
        -- upvalues: refresh (copy)
        while true do
            refresh()
            task.wait(0.5)
        end
    end)
end

return t1
