-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local HudIcon = require(script.Parent.HudIcon)
local Robux = require(script.Parent.Robux)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {
    {
        Key = "VIP",
        Name = "VIP",
        Emoji = "👑"
    },
    {
        Key = "CashX2",
        Name = "2x CASH",
        Image = Config.Icons.Cash
    },
    {
        Key = "StrengthX2",
        Name = "2x TRAINING",
        Image = Config.Icons.Strength
    },
    {
        Key = "LuckX2",
        Name = "2x LUCK",
        Image = Config.Icons.Luck
    },
    {
        Key = "AutoClicker",
        Name = "AUTO CLICK",
        Image = Config.Icons.AutoClicker
    },
    {
        Key = "AutoTrain",
        Name = "AUTO TRAIN",
        Image = Config.Icons.AutoTrain
    }
}

local function unowned() -- line: 28
    -- upvalues: Robux (copy), t2 (copy)
    local t3 = {}

    for _, v1 in t2 do
        if not Robux.owns(v1.Key) then
            table.insert(t3, v1)
        end
    end

    return t3
end

function t1.new(p1) -- line: 40
    -- upvalues: UIUtil (copy), Kit (copy), HudIcon (copy), Robux (copy), LocalPlayer (copy), unowned (copy)
    local v2, v3, _, v4 = HudIcon.new(p1, "")

    v2.Name = "GamePasses"
    HudIcon.wiggle(v2, 2)

    local v5 = HudIcon.image(v3, "")
    local v6 = Kit.text(v3, "", {
        Name = "Emoji",
        ZIndex = 2,
        Size = UDim2.fromScale(1, 1)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Swap"
    UIScale.Parent = v3

    local v7

    local function show(p2) -- line: 51
        -- upvalues: v4 (copy), v5 (copy), v6 (copy), v7 (ref)
        v7 = p2
        v4.Text = p2.Name
        v5.Image = p2.Image or ""
        v5.Visible = p2.Image ~= nil
        v6.Text = p2.Emoji or ""
        v6.Visible = p2.Emoji ~= nil
    end

    UIUtil.bindButton(v2, function() -- line: 60
        -- upvalues: v7 (ref), Robux (copy)
        if v7 then
            Robux.buy(v7.Key)
        end
    end)

    local v8 = true

    v2.Destroying:Connect(function() -- line: 67
        -- upvalues: v8 (ref)
        v8 = false
    end)
    task.spawn(function() -- line: 70
        -- upvalues: v2 (copy), v4 (copy), v5 (copy), v6 (copy), UIScale (copy), v7 (ref), v8 (ref), UIUtil (copy), unowned (copy)
        local n1 = 0

        while v8 do
            local v9 = unowned()
            local v10, v11

            if #v9 > 0 then
                v10 = n1 % #v9 + 1
                v11 = v9[v10]
                n1 = v10

                if v11 ~= v7 then
                    if v7 and v2.Visible then
                        UIUtil.tween(UIScale, 0.14, {
                            Scale = 0
                        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                        task.wait(0.14)
                    end

                    v7 = v11
                    v4.Text = v11.Name
                    v5.Image = v11.Image or ""
                    v5.Visible = v11.Image ~= nil
                    v6.Text = v11.Emoji or ""
                    v6.Visible = v11.Emoji ~= nil
                    UIUtil.tween(UIScale, 0.3, {
                        Scale = 1
                    }, Enum.EasingStyle.Back)
                end
            end

            task.wait(2.6)
        end
    end)

    return v2, function() -- line: 90
        -- upvalues: LocalPlayer (copy), unowned (copy)
        if #unowned() > 0 then
            return LocalPlayer:GetAttribute("PacksBought") ~= nil
        end

        return false
    end
end

return t1
