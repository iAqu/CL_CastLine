-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Products = require(ReplicatedStorage.Shared.Products)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local HudIcon = require(script.Parent.Parent.Shop.HudIcon)
local Robux = require(script.Parent.Parent.Shop.Robux)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(120, 235, 90)
local v2 = false
local t1 = {}

function t1.on() -- line: 28
    -- upvalues: Robux (copy), v2 (ref)
    return Robux.owns("AutoClicker") and not v2
end

function t1.show(p1) -- line: 34
    -- upvalues: Config (copy), UIUtil (copy), Kit (copy), HudIcon (copy), Robux (copy), Style (copy), LocalPlayer (copy), t1 (copy), v1 (copy), v2 (ref)
    local v3 = Kit.frame(p1, {
        Name = "AutoClicker",
        BackgroundTransparency = 1,
        ZIndex = 20,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(140, 140)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v3
    UIScale.Scale = UIUtil.scale * UIUtil.smallScreenBoost(UIUtil.scale, 1.2)

    local v4, v5, v6, v7 = HudIcon.new(140, "AUTO CLICK")

    v4.ZIndex = 20
    v6.ZIndex = 20
    v5.ZIndex = 21
    v7.ZIndex = 22
    HudIcon.image(v5, Config.Icons.AutoClicker).ZIndex = 21
    v4.Parent = v3
    UIUtil.bindButton(v4, function() -- line: 55
        -- upvalues: UIUtil (copy), Robux (copy), t1 (copy), v2 (ref)
        if not Robux.owns("AutoClicker") then
            Robux.buy("AutoClicker")

            return
        end

        v2 = not v2
        UIUtil.sound("Click", 0.6, v2 and 0.8 or 1.2)
        t1.refresh()
    end)

    function t1.refresh() -- line: 65
        -- upvalues: v6 (copy), v7 (copy), Robux (copy), Style (copy), v1 (copy), v2 (ref)
        local AutoClicker = Robux.owns("AutoClicker")

        v7.Text = if not AutoClicker then "AUTO CLICK" elseif v2 then "AUTO: OFF" else "AUTO: ON"
        v6.ImageColor3 = if not AutoClicker then Color3.new(1, 1, 1) elseif v2 then Style.GREY else v1
    end

    local connection = LocalPlayer:GetAttributeChangedSignal("Pass_AutoClicker"):Connect(function() -- line: 71
        -- upvalues: v3 (copy), v6 (copy), v7 (copy), UIUtil (copy), Robux (copy), Style (copy), v1 (copy), v2 (ref)
        local AutoClicker = Robux.owns("AutoClicker")

        v7.Text = if not AutoClicker then "AUTO CLICK" elseif v2 then "AUTO: OFF" else "AUTO: ON"
        v6.ImageColor3 = if not AutoClicker then Color3.new(1, 1, 1) elseif v2 then Style.GREY else v1

        if Robux.owns("AutoClicker") then
            UIUtil.pop(v3, 1.3)
        end
    end)
    local AutoClicker = Robux.owns("AutoClicker")

    v7.Text = if not AutoClicker then "AUTO CLICK" elseif v2 then "AUTO: OFF" else "AUTO: ON"
    v6.ImageColor3 = if not AutoClicker then Color3.new(1, 1, 1) elseif v2 then Style.GREY else v1
    UIUtil.pop(v3, 0.6)

    return {
        covers = function(p2) -- covers | line: 81
            -- upvalues: v3 (copy)
            local AbsolutePosition, AbsoluteSize = v3.AbsolutePosition, v3.AbsoluteSize

            if p2.X >= AbsolutePosition.X and p2.X <= AbsolutePosition.X + AbsoluteSize.X and p2.Y >= AbsolutePosition.Y then
                return p2.Y <= AbsolutePosition.Y + AbsoluteSize.Y
            end

            return false
        end,
        destroy = function() -- destroy | line: 85
            -- upvalues: v3 (copy), connection (copy)
            connection:Disconnect()
            v3:Destroy()
        end
    }
end

function t1.refresh() -- line: 92
end

function t1.taps(p3, p4) -- line: 95
    -- upvalues: Products (copy)
    p3.owed = (p3.owed or 0) + p4 * Products.AutoClickerRate

    local v14 = math.floor(p3.owed)

    p3.owed -= v14

    return v14
end

return t1
