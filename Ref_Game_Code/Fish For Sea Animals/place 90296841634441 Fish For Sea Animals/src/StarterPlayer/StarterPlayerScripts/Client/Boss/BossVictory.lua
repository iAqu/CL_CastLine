-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Economy = require(ReplicatedStorage.Shared.Economy)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local BossSkin = require(script.Parent.BossSkin)
local BossAnimalRoll = require(script.Parent.BossAnimalRoll)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(255, 225, 90)
local v2 = Color3.fromRGB(120, 255, 90)
local v3 = Color3.fromRGB(200, 210, 230)
local v4 = Color3.new(1, 1, 1)
local v5 = Color3.fromRGB(255, 170, 70)
local t2 = {
    Color3.fromRGB(255, 90, 90),
    Color3.fromRGB(255, 210, 60),
    Color3.fromRGB(90, 220, 255),
    Color3.fromRGB(120, 255, 120),
    Color3.fromRGB(255, 120, 230)
}
local ScreenGui
local n1 = 0

local function close() -- line: 36
    -- upvalues: ScreenGui (ref), n1 (ref)
    n1 += 1
    ScreenGui.Enabled = false

    for _, child in ScreenGui:GetChildren() do
        child:Destroy()
    end
end

local function land(p1, p2) -- line: 45
    -- upvalues: UIUtil (copy)
    UIUtil.centre(p1)

    local v6 = p1:FindFirstChild("Pop") or Instance.new("UIScale")

    v6.Name = "Pop"
    v6.Scale = p2 or 0.2
    v6.Parent = p1
    p1.Visible = true
    UIUtil.tween(v6, 0.38, {
        Scale = 1
    }, Enum.EasingStyle.Back)
end

local function confetti(p3) -- line: 55
    -- upvalues: UIUtil (copy), Kit (copy), t2 (copy), ScreenGui (ref)
    local AbsoluteSize = ScreenGui.AbsoluteSize

    for _ = 1, p3 do
        local v7 = Kit.frame(ScreenGui, {
            ZIndex = 60,
            BackgroundColor3 = t2[math.random(1, #t2)],
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(math.random() * AbsoluteSize.X, -20 - math.random() * 120),
            Size = UDim2.fromOffset(math.random(10, 18), math.random(6, 10)),
            Rotation = math.random(0, 360)
        })
        local v8 = 2 + math.random() * 1.5

        UIUtil.tween(v7, v8, {
            Position = UDim2.fromOffset(v7.Position.X.Offset + math.random(-150, 150), AbsoluteSize.Y + 40),
            Rotation = v7.Rotation + math.random(-720, 720)
        }, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        task.delay(v8, function() -- line: 71
            -- upvalues: v7 (copy)
            v7:Destroy()
        end)
    end
end

local function rays(p4, p5, p6) -- line: 78
    -- upvalues: RunService (copy), Kit (copy), v1 (copy)
    local v9 = Kit.frame(p4, {
        Name = "Rays",
        BackgroundTransparency = 1,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, p5),
        Size = UDim2.fromOffset(p6, p6)
    })

    for i = 0, 11 do
        local v10 = Kit.frame(v9, {
            BackgroundTransparency = 0.55,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0, 34, 1, 0),
            Rotation = i * 15,
            BackgroundColor3 = v1
        })
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.42, 0.2),
            NumberSequenceKeypoint.new(0.58, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Parent = v10
    end

    local connection

    connection = RunService.RenderStepped:Connect(function(p7) -- line: 88
        -- upvalues: v9 (copy), connection (ref)
        if v9.Parent then
            v9.Rotation += p7 * 14
        else
            connection:Disconnect()
        end
    end)

    return v9
end

local function line(p8, p9, p10, p11, p12) -- line: 99
    -- upvalues: Kit (copy)
    local v12 = Kit.text(p8, p9, {
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, p11),
        Size = UDim2.new(1, 0, 0, p12),
        TextColor3 = p10,
        StrokeThickness = math.max(3, p12 / 12)
    })

    v12.Visible = false

    return v12
end

local function countUp(p13, p14, p15, p16) -- line: 106
    -- upvalues: RunService (copy), UIUtil (copy)
    local elapsed = os.clock()
    local n2 = 0
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 110
        -- upvalues: p13 (copy), p14 (copy), p15 (copy), p16 (copy), elapsed (copy), n2 (ref), connection (ref), UIUtil (copy)
        if not p13.Parent then
            connection:Disconnect()

            return
        end

        local v14 = math.min((os.clock() - elapsed) / p15, 1)

        p13.Text = p16((math.floor(p14 * (1 - (1 - v14) ^ 3))))

        if v14 - n2 >= 0.08 and v14 < 1 then
            n2 = v14
            UIUtil.sound("Tick", 0.35, v14 * 0.8 + 0.9)
        end

        if v14 >= 1 then
            connection:Disconnect()
            UIUtil.sound("Cash", 0.8, 1.05)
            UIUtil.pop(p13, 1.25)
        end
    end)
end

function t1.show(p17) -- line: 130
    -- upvalues: RunService (copy), Config (copy), Economy (copy), Format (copy), UIUtil (copy), Kit (copy), Style (copy), BossSkin (copy), BossAnimalRoll (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), ScreenGui (ref), n1 (ref), close (copy), land (copy), confetti (copy), rays (copy), line (copy)
    n1 += 1
    ScreenGui.Enabled = false

    for _, child in ScreenGui:GetChildren() do
        child:Destroy()
    end

    n1 += 1

    local v17 = n1

    ScreenGui.Enabled = true

    local v18 = Kit.frame(ScreenGui, {
        Name = "Backdrop",
        BackgroundTransparency = 1,
        ZIndex = 0,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(5, 10, 25)
    })

    UIUtil.tween(v18, 0.4, {
        BackgroundTransparency = 0.12
    })

    local v19 = Kit.frame(ScreenGui, {
        Name = "Page",
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1100, 900)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v19

    local t4 = {}

    local function beat(p18, p19) -- line: 143
        -- upvalues: t4 (copy)
        table.insert(t4, {
            p18,
            p19
        })
    end

    local v20 = line(v19, "VICTORY!", v1, 0, 120)
    local v21 = line(v19, "YOU BEAT THE " .. (p17.BossName or BossSkin.name()) .. "!", v4, 0 + 122, 48)
    local v22 = 0 + 180

    table.insert(t4, {
        0.15,
        function() -- line: 150
            -- upvalues: v20 (copy), UIUtil (copy), Kit (copy), land (copy), confetti (copy)
            land(v20, 3)
            Kit.shake(v20, 12, 0.3)
            UIUtil.sound("Luck4", 1, 1)
            UIUtil.sound("LevelUp", 0.9, 1)
            confetti(70)
        end
    })
    table.insert(t4, {
        0.35,
        function() -- line: 157
            -- upvalues: v21 (copy), UIUtil (copy), land (copy)
            land(v21, 0.4)
            UIUtil.sound("Pop", 0.7, 1)
        end
    })

    local v23 = p17.Cash or 0
    local v24 = p17.Strength or 0
    local v25

    if v23 > 0 or v24 > 0 then
        local v26 = v22 + 120
        local v27 = rays(v19, v26, 560)

        v27.Visible = false

        local v28 = line(v19, "", v2, v26 - 92, 104)
        local v29 = line(v19, "", v5, v26 + 22, 80)

        v25 = v22 + 270
        table.insert(t4, {
            0.5,
            function() -- line: 171
                -- upvalues: v19 (copy), v26 (copy), v27 (copy), UIUtil (copy), Kit (copy), v1 (copy), land (copy)
                v27.Visible = true
                land(v27, 0.1)
                Kit.burst(v19, Vector2.new(550, v26), v1, 30, 340)
                Kit.ring(v19, Vector2.new(550, v26), v1, 640)
                UIUtil.sound("BossGotAnimal", 1, 1, 10)
            end
        })

        if v23 > 0 then
            table.insert(t4, {
                0.3,
                function() -- line: 179
                    -- upvalues: v23 (copy), v28 (copy), RunService (copy), Format (copy), UIUtil (copy), Kit (copy), land (copy)
                    land(v28, 2.2)
                    Kit.shake(v28, 10, 0.25)

                    local function v30(p20) -- line: 182
                        -- upvalues: Format (copy)
                        return (("💰 +%*"):format((Format.money(p20))))
                    end

                    local elapsed = os.clock()
                    local n3 = 0
                    local connection
                    local RenderStepped = RunService.RenderStepped
                    local n4 = 1.2

                    connection = RenderStepped:Connect(function() -- line: 110
                        -- upvalues: v30 (copy), elapsed (copy), n3 (ref), connection (ref), n4 (copy), v23 (copy), v28 (copy), UIUtil (copy)
                        if not v28.Parent then
                            connection:Disconnect()

                            return
                        end

                        local v32 = math.min((os.clock() - elapsed) / n4, 1)

                        v28.Text = v30((math.floor(v23 * (1 - (1 - v32) ^ 3))))

                        if v32 - n3 >= 0.08 and v32 < 1 then
                            n3 = v32
                            UIUtil.sound("Tick", 0.35, v32 * 0.8 + 0.9)
                        end

                        if v32 >= 1 then
                            connection:Disconnect()
                            UIUtil.sound("Cash", 0.8, 1.05)
                            UIUtil.pop(v28, 1.25)
                        end
                    end)
                end
            })
        end

        if v24 > 0 then
            table.insert(t4, {
                if v23 > 0 then 1.4 else 0.3,
                function() -- line: 188
                    -- upvalues: v19 (copy), v24 (copy), v26 (copy), v29 (copy), RunService (copy), Format (copy), UIUtil (copy), Kit (copy), v5 (copy), land (copy)
                    land(v29, 2.2)
                    Kit.shake(v29, 10, 0.25)
                    Kit.burst(v19, Vector2.new(550, v26 + 62), v5, 18, 260)
                    UIUtil.sound("LevelUp", 0.9, 1.1)

                    local function v35(p21) -- line: 193
                        -- upvalues: Format (copy)
                        return (("💪 +%* STRENGTH"):format((Format.short((math.floor(p21 + 0.5))))))
                    end

                    local elapsed = os.clock()
                    local n5 = 0
                    local connection
                    local RenderStepped = RunService.RenderStepped
                    local n6 = 0.8

                    connection = RenderStepped:Connect(function() -- line: 110
                        -- upvalues: v35 (copy), elapsed (copy), n5 (ref), connection (ref), n6 (copy), v24 (copy), v29 (copy), UIUtil (copy)
                        if not v29.Parent then
                            connection:Disconnect()

                            return
                        end

                        local v38 = math.min((os.clock() - elapsed) / n6, 1)

                        v29.Text = v35((math.floor(v24 * (1 - (1 - v38) ^ 3))))

                        if v38 - n5 >= 0.08 and v38 < 1 then
                            n5 = v38
                            UIUtil.sound("Tick", 0.35, v38 * 0.8 + 0.9)
                        end

                        if v38 >= 1 then
                            connection:Disconnect()
                            UIUtil.sound("Cash", 0.8, 1.05)
                            UIUtil.pop(v29, 1.25)
                        end
                    end)
                end
            })
        end
    else
        v25 = v22
    end

    local v41 = p17.Animal and BossAnimalRoll.build(v19, v25, p17.Animal)
    local v42 = v25

    if v41 then
        v42 = v25 + (BossAnimalRoll.HEIGHT + 10)
        table.insert(t4, {
            if v23 > 0 or v24 > 0 then 1.4 else 0.4,
            v41
        })
    end

    local t12 = {}
    local v43 = p17.RodTier and Config.Rods[p17.RodTier]

    if v43 and v23 > 0 then
        table.insert(t12, {
            ("🎣 Paid by your %*"):format(v43.Name),
            v3,
            34
        })
    end

    if (p17.Levels or 0) > 0 then
        table.insert(t12, {
            ("⬆ +%* LEVEL%*!"):format(p17.Levels, if p17.Levels == 1 then "" else "S"),
            Color3.fromRGB(110, 200, 255),
            46
        })
    end

    local t15 = {}
    local v46 = if type(p17.Potions) == "table" then p17.Potions else {}

    for _, v47 in v46 do
        table.insert(t15, if v47 == "Luck" then "🍀 2x Luck" elseif v47 == "Cash" then "💰 2x Cash" else ("🧪 2x %*"):format(v47))
    end

    if #t15 > 0 then
        table.insert(t12, {
            ("%* potion%*"):format(table.concat(t15, " + "), #t15 > 1 and "s" or ""),
            v3,
            36
        })
    end

    if p17.FinalBlow then
        local v50 = math.floor(Economy.Boss.FinalBlowBonus * 100)

        table.insert(t12, {
            if v50 > 0 then ("⚔ FINAL BLOW: +%*%% cash!"):format(v50) else "⚔ YOU LANDED THE FINAL BLOW!",
            v1,
            40
        })
    end

    if p17.NoHit then
        table.insert(t12, {
            ("💎 NO HITS TAKEN: +%*%% cash!"):format((math.floor(Economy.Boss.NoHitBonus * 100))),
            v1,
            40
        })
    end

    if (p17.Damage or 0) > 0 then
        table.insert(t12, {
            ("%*%% of the damage (%*)"):format(math.floor((p17.Share or 0) * 100 + 0.5), (Format.short(p17.Damage))),
            v3,
            32
        })
    end

    local v53 = v42 + 10

    for v54, v55 in t12 do
        local v56 = line(v19, v55[1], v55[2], v53, v55[3])

        v53 += v55[3] + 6
        table.insert(t4, {
            if v54 == 1 then 0.45 else 0.32,
            function() -- line: 235
                -- upvalues: v55 (copy), v56 (copy), v54 (copy), UIUtil (copy), land (copy)
                land(v56, 0.3)
                UIUtil.sound("Pop", 0.75, 0.9 + v54 * 0.12)

                if v55[4] then
                    v55[4](v56)
                end
            end
        })
    end

    local v57 = Kit.button(v19, "CONTINUE", Style.BUY, {
        Name = "Continue",
        ZIndex = 6,
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, v53 + 14),
        Size = UDim2.fromOffset(300, 78)
    }, close)

    v57.Label.ZIndex = 7
    table.insert(t4, {
        0.5,
        function() -- line: 245
            -- upvalues: v57 (copy), UIUtil (copy), land (copy)
            land(v57, 0.3)
            UIUtil.sound("Click", 0.6, 1.2)

            local Pop = v57:FindFirstChild("Pop")

            task.spawn(function() -- line: 250
                -- upvalues: Pop (copy), v57 (copy), UIUtil (copy)
                while v57.Parent and Pop do
                    UIUtil.tween(Pop, 0.5, {
                        Scale = 1.06
                    }, Enum.EasingStyle.Sine)
                    task.wait(0.5)
                    UIUtil.tween(Pop, 0.5, {
                        Scale = 1
                    }, Enum.EasingStyle.Sine)
                    task.wait(0.5)
                end
            end)
        end
    })

    local v58 = v53 + 100

    v19.Size = UDim2.fromOffset(1100, v58)

    local function fit() -- line: 263
        -- upvalues: UIScale (copy), v58 (copy), UIUtil (copy)
        if UIScale.Parent then
            UIScale.Scale = math.min(UIUtil.scale, workspace.CurrentCamera.ViewportSize.Y * 0.94 / v58)
        end
    end

    if UIScale.Parent then
        UIScale.Scale = math.min(UIUtil.scale, workspace.CurrentCamera.ViewportSize.Y * 0.94 / v58)
    end

    UIUtil.onScale(fit)
    task.spawn(function() -- line: 271
        -- upvalues: v17 (copy), t4 (copy), n1 (ref), confetti (copy)
        for _, v61 in t4 do
            task.wait(v61[1])

            if n1 ~= v17 then
                return
            end

            v61[2]()
        end

        task.wait(1)

        if n1 == v17 then
            confetti(40)
        end
    end)
    task.delay((v41 and 8 or 0) + 16, function() -- line: 284
        -- upvalues: v17 (copy), ScreenGui (ref), n1 (ref)
        if n1 ~= v17 then
            return
        end

        n1 += 1
        ScreenGui.Enabled = false

        for _, child in ScreenGui:GetChildren() do
            child:Destroy()
        end
    end)
end

function t1.isOpen() -- line: 291
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.init() -- line: 295
    -- upvalues: LocalPlayer (copy), ScreenGui (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BossVictory"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 30
    ScreenGui.Enabled = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

return t1
