-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Economy = require(ReplicatedStorage.Shared.Economy)
local LiveOps = require(ReplicatedStorage.Shared.LiveOps)
local Format = require(ReplicatedStorage.Shared.Format)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local BossSeats = require(ReplicatedStorage.Shared.BossSeats)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local Viewport = require(script.Parent.Parent.UI.Viewport)
local BossVictory = require(script.Parent.BossVictory)
local BossSkin = require(script.Parent.BossSkin)
local LocalPlayer = Players.LocalPlayer

local function make(p1) -- line: 35
    -- upvalues: RunService (copy), UserInputService (copy), Config (copy), Economy (copy), LiveOps (copy), Format (copy), AnimalModel (copy), UIUtil (copy), Kit (copy), Style (copy), Viewport (copy), BossVictory (copy), LocalPlayer (copy)
    local t1 = {}
    local v1 = Color3.fromRGB(235, 50, 60)
    local v2 = Color3.fromRGB(255, 225, 90)
    local v3 = Color3.fromRGB(200, 210, 230)
    local v4 = Color3.new(1, 1, 1)
    local ScreenGui, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
    local t2 = {
        shown = 1,
        last = 1,
        holdUntil = 0
    }
    local v22

    local function v23() -- line: 48
    end

    local v24 = false
    local v25 = false
    local n1 = -100

    local function now() -- line: 53
        return workspace:GetServerTimeNow()
    end

    local function scaled(p2) -- line: 58
        -- upvalues: ScreenGui (ref), UIUtil (copy), Kit (copy)
        local v26 = Kit.frame(ScreenGui, p2)

        v26.BackgroundTransparency = 1

        local UIScale = Instance.new("UIScale")

        UIScale.Name = "BossScale"
        UIScale.Parent = v26
        UIUtil.onScale(function(p3) -- line: 64
            -- upvalues: UIScale (copy)
            UIScale.Scale = p3
        end)

        return v26
    end

    local function touch() -- line: 70
        -- upvalues: UserInputService (copy)
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end

    local function animalView(p4, p5, p6, p7) -- line: 75
        -- upvalues: v4 (copy), RunService (copy), AnimalModel (copy), Viewport (copy)
        local ViewportFrame = Instance.new("ViewportFrame")

        ViewportFrame.Name = "Animal"
        ViewportFrame.BackgroundTransparency = 1
        ViewportFrame.AnchorPoint = Vector2.new(0.5, 0)
        ViewportFrame.Position = UDim2.new(0.5, 0, 0, p6)
        ViewportFrame.Size = UDim2.fromOffset(p7 * 1.8, p7)
        ViewportFrame.Ambient = Color3.fromRGB(235, 235, 235)
        ViewportFrame.LightColor = v4
        ViewportFrame.LightDirection = Vector3.new(-0.5, -1, -0.6)
        ViewportFrame.Parent = p4

        local v27 = AnimalModel.clone(p5, 10)

        if v27 then
            v27:PivotTo(CFrame.new())
            Viewport.show(ViewportFrame, v27, 90, 0.75)

            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 94
                -- upvalues: ViewportFrame (copy), v27 (copy), connection (ref)
                if not ViewportFrame.Parent then
                    connection:Disconnect()
                else
                    v27:PivotTo(CFrame.Angles(0, math.sin(os.clock() * 0.8) * 0.6, 0))
                end
            end)
        end
    end

    function t1.announce(p8, p9) -- line: 105
        -- upvalues: v21 (ref), animalView (copy), Kit (copy)
        for _, child in v21:GetChildren() do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end

        local n2 = 0

        for v29, v30 in p8 do
            if v30.Animal then
                animalView(v21, v30.Animal, n2, v30[1])
                n2 += v30[1] + 6
            else
                Kit.text(v21, v30[1], {
                    Name = "Line" .. v29,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, n2),
                    Size = UDim2.new(1, 0, 0, v30[3]),
                    TextColor3 = v30[2],
                    StrokeThickness = math.max(3, v30[3] / 14)
                })
                n2 += v30[3] + 6
            end
        end

        v21.Visible = true

        local v34 = v21:GetAttribute("Shown") or 0

        v21:SetAttribute("Shown", v34 + 1)
        task.delay(p9, function() -- line: 131
            -- upvalues: v34 (copy), v21 (ref)
            if v21:GetAttribute("Shown") == v34 + 1 then
                v21.Visible = false
            end
        end)
    end

    function t1.hitFlash() -- line: 138
        -- upvalues: v20 (ref), UIUtil (copy)
        v20.BackgroundTransparency = 0.45
        UIUtil.tween(v20, 0.5, {
            BackgroundTransparency = 1
        })
    end

    function t1.enraged(p10) -- line: 143
        -- upvalues: v17 (ref), UIUtil (copy)
        v17.Text = p10 >= 3 and "FURIOUS!" or "ENRAGED!"
        v17.Visible = true
        UIUtil.pop(v17, 1.6)
    end

    function t1.showOut() -- line: 149
        -- upvalues: p1 (copy), t1 (copy), v1 (copy), v4 (copy), n1 (ref)
        n1 = os.clock()
        t1.announce({
            { "YOU DIED!", v1, 90 },
            {
                p1.short() .. " got you... your damage still counts",
                v4,
                40
            }
        }, 4)
    end

    function t1.showEnd(p11) -- line: 154
        -- upvalues: p1 (copy), t1 (copy), v1 (copy), v2 (copy), v3 (copy), v21 (ref), n1 (ref), Economy (copy), Format (copy), BossVictory (copy)
        if type(p11) ~= "table" then
            return
        end

        local v37 = n1 + 3 - os.clock()

        if v37 > 0 then
            task.delay(v37, t1.showEnd, p11)
            n1 = -100
        elseif not (p11.Won and (p11.Damage or 0) > 0) then
            local t4 = {
                if p11.Won then {
                    "YOU BEAT THE " .. p1.name() .. "!",
                    v2,
                    80
                } else { "IT GOT AWAY...", v1, 90 }
            }

            if (p11.Damage or 0) > 0 then
                table.insert(t4, {
                    ("%*%% of the damage · +%*"):format(math.floor((p11.Share or 0) * 100 + 0.5), (Format.money(p11.Cash or 0))),
                    Color3.fromRGB(120, 255, 90),
                    44
                })

                if p11.NoHit then
                    table.insert(t4, {
                        ("NO HITS TAKEN: +%*%% bonus!"):format((math.floor(Economy.Boss.NoHitBonus * 100))),
                        v2,
                        40
                    })
                end

                if p11.Potion then
                    table.insert(t4, {
                        "🍀 + a 2x Luck potion (in your inventory)",
                        v3,
                        36
                    })
                end
            else
                table.insert(t4, {
                    "Hook it and reel it next time to win a reward!",
                    v3,
                    40
                })
            end

            t1.announce(t4, 6.5)
        else
            v21.Visible = false
            BossVictory.show(p11)
        end
    end

    local function heartText(p12) -- line: 187
        -- upvalues: p1 (copy)
        return string.rep("❤️", (math.max(p12, 0))) .. string.rep("🖤", (math.max(p1.hearts - p12, 0)))
    end

    local function update(p13) -- line: 193
        -- upvalues: p1 (copy), v4 (copy), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), v19 (ref), v21 (ref), t2 (copy), v24 (ref), v25 (ref), Config (copy), Economy (copy), LiveOps (copy), Format (copy), UIUtil (copy), Kit (copy), Style (copy), BossVictory (copy), LocalPlayer (copy)
        local v42 = workspace:GetAttribute(p1.prefix .. "State") or ""
        local v43 = LocalPlayer:GetAttribute(p1.prefix .. "In") ~= nil
        local v44 = (LocalPlayer:GetAttribute("Tutorial") or 0) >= Config.TutorialDone and p1.offered() or LocalPlayer:GetAttribute(p1.prefix .. "Invite") == true
        local v45 = LocalPlayer:GetAttribute("BossIn") ~= nil or LocalPlayer:GetAttribute("SubBossIn") ~= nil
        local v46 = v44 and (v43 or not v45)
        local Attribute = workspace:GetAttribute(p1.prefix .. "NextAt")
        local v47 = LocalPlayer:GetAttribute(p1.prefix .. "Joined") == true

        if v42 ~= "Join" then
            v25 = false
        end

        local v49 = math.max(0, (workspace:GetAttribute(p1.prefix .. "StartAt") or workspace:GetServerTimeNow()) - workspace:GetServerTimeNow())
        local v50 = workspace:GetAttribute(p1.prefix .. "JoinCount") or 0
        local v51 = v42 == "Join" and not v47 and p1.seats <= v50
        local v52 = ("(%*/%*)"):format(v50, p1.seats)
        local v53 = v6
        local v54

        if v46 then
            local v56 = not v43

            v54 = v56 and (v42 == "" and Attribute ~= nil or v42 == "Join" and (v47 or v25 or v51))
        else
            v54 = v46
        end

        v53.Visible = v54

        if v6.Visible then
            local v57 = v6

            if v42 == "Join" then
                if v51 then
                    v57.Text = ("%* It's full %*! %* spawns in %*s"):format(p1.icon, v52, p1.title, (math.ceil(v49)))
                elseif v47 then
                    if workspace:GetAttribute(p1.prefix .. "Gathering") then
                        v57.Text = "✅ You're in! Waiting for everyone to finish fishing..."
                    else
                        v57.Text = ("✅ You're in! %* %* spawns in %*s"):format(v52, p1.title, (math.ceil(v49)))
                    end
                else
                    v57.Text = ("%* %* spawns in %*s"):format(p1.icon, p1.title, (math.ceil(v49)))
                end
            else
                v57.Text = ("%* %* spawns in %*"):format(p1.icon, p1.title, (Style.clock(Attribute - workspace:GetServerTimeNow())))
            end
        end

        v5.Visible = v6.Visible and v42 ~= "Join"

        if v5.Visible then
            local ServerTimeNow = workspace:GetServerTimeNow()
            local v59 = LiveOps.strengthLeft(ServerTimeNow)
            local v60 = if v59 > 0 then ("💪 2x STRENGTH! %* left"):format((Style.clock(v59))) else ("💪 2x Strength in %*"):format((Style.clock(LiveOps.strengthIn(ServerTimeNow))))

            v5.Text = v60

            local v61 = v5

            if v59 > 0 then
                v61.TextColor3 = Color3.fromRGB(255, 200, 80)
            else
                v61.TextColor3 = Color3.fromRGB(255, 225, 160)
            end
        end

        local Visible = v7.Visible
        local v62 = v7

        if v42 == "Join" then
            v62.Visible = v46 and not v43 and not v47 and not v25 and not v51 and v49 > 0
        else
            v62.Visible = false
        end

        if v7.Visible then
            if not Visible then
                UIUtil.pop(v7, 1.08)
            end

            v8.Text = ("%* %* SPAWNS IN %*s! %*"):format(p1.icon, string.upper(p1.title), math.ceil(v49), v52)

            local v66 = math.clamp(LocalPlayer:GetAttribute("RodTier") or 1, 1, #Config.Rods)
            local v69 = Format.short((math.max(1, (math.floor(Economy.Boss.ReelDamage * p1.power(v66) + 0.5)))))

            v9.Text = ("Your rod: %* · %* damage a reel"):format(Config.Rods[v66].Name, v69)
            v9.TextColor3 = Color3.fromRGB(120, 255, 90)

            local v74 = math.max(Config.bossCash(v66, true), (LocalPlayer:GetAttribute("Income") or 0) * Economy.Boss.MinIncomeSeconds)

            v10.Text = ("Beat it: about %* 💰"):format((Format.money(v74)))
        end

        local v76 = v11

        if v43 then
            if v42 == "" then
                v76.Visible = false
            else
                v76.Visible = not v24 and not BossVictory.isOpen()
            end
        else
            v76.Visible = v43
        end

        local v77 = v18

        if v43 then
            v43 = v42 == "Fight" and not v24
        end

        v77.Visible = v43
        v19.Visible = v18.Visible and LocalPlayer:GetAttribute(p1.prefix .. "In") == true

        if v11.Visible then
            local v79 = workspace:GetAttribute(p1.prefix .. "HP") or 0
            local v80 = workspace:GetAttribute(p1.prefix .. "MaxHP") or 1
            local v82 = math.clamp(v79 / v80, 0, 1)

            v13.Size = UDim2.fromScale(v82, 1)

            if v82 < t2.last - 1E-04 then
                local v84 = t2.last - v82

                t2.holdUntil = os.clock() + (v84 > 0.01 and 0.6 or 0.35)

                if v84 > 0.01 then
                    Kit.shake(v12, 8, 0.25)
                    Kit.flash(v12, v4, 0.6)
                end
            end

            t2.last = v82

            if os.clock() > t2.holdUntil then
                t2.shown = math.max(v82, t2.shown - p13 * 0.9)
            end

            t2.shown = math.max(t2.shown, v82)
            v14.Size = UDim2.fromScale(t2.shown, 1)
            v15.Text = ("%* / %*"):format(math.ceil(v79), (math.ceil(v80)))

            local v89 = v16

            if v42 == "Fight" then
                v89.Text = ("⏱ %*"):format((Style.clock((workspace:GetAttribute(p1.prefix .. "EndsAt") or workspace:GetServerTimeNow()) - workspace:GetServerTimeNow())))
            else
                v89.Text = ""
            end

            local v90 = (workspace:GetAttribute(p1.prefix .. "WeakUntil") or 0) > workspace:GetServerTimeNow()

            v17.Visible = v17.Visible and v42 == "Fight"

            if v90 then
                v16.Text ..= "   🎯 WEAK SPOT OPEN!"
            end
        else
            v17.Visible = false
        end

        if v18.Visible then
            local v93 = v18
            local v94 = LocalPlayer:GetAttribute(p1.prefix .. "Hearts") or 0

            v93.Text = string.rep("❤️", (math.max(v94, 0))) .. string.rep("🖤", (math.max(p1.hearts - v94, 0)))
        end

        local v97 = if v11.Visible then 136
            elseif v5.Visible then 80
            elseif v6.Visible then 46
            else 0

        v21.Position = UDim2.new(0.5, 0, 0, v97)
    end

    function t1.setHidden(p14) -- line: 287
        -- upvalues: v24 (ref)
        v24 = p14
    end

    function t1.init(p15) -- line: 291
        -- upvalues: p1 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), ScreenGui (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), v21 (ref), v22 (ref), v23 (ref), v25 (ref), scaled (copy), update (copy), RunService (copy), UserInputService (copy), Kit (copy), Style (copy), LocalPlayer (copy)
        v23 = p15
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = p1.guiName
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.DisplayOrder = 4
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        v20 = Kit.frame(ScreenGui, {
            Name = "HitFlash",
            BackgroundTransparency = 1,
            ZIndex = 1,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = v1
        })
        v20.Interactable = false
        v22 = scaled({
            Name = "TopColumn",
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 6),
            Size = UDim2.fromOffset(1100, 640)
        })
        v6 = Kit.text(v22, "", {
            Name = "Countdown",
            StrokeThickness = 3,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.fromOffset(520, 40),
            TextColor3 = v4
        })
        v6.Visible = false
        v5 = Kit.text(v22, "", {
            Name = "LiveOps",
            StrokeThickness = 3,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 42),
            Size = UDim2.fromOffset(700, 30),
            TextColor3 = v4
        })
        v5.Visible = false

        local v99 = scaled({
            Name = "JoinPopup",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(640, 330)
        })

        v7 = Style.card(v99, Style.NAVY, {
            Name = "JoinCard",
            Size = UDim2.fromScale(1, 1)
        })
        v8 = Kit.text(v7, "", {
            ZIndex = 3,
            StrokeThickness = 4,
            Position = UDim2.fromOffset(16, 14),
            Size = UDim2.new(1, -32, 0, 56),
            TextColor3 = v2
        })
        Kit.text(v7, "Join?", {
            ZIndex = 3,
            StrokeThickness = 4,
            Position = UDim2.fromOffset(16, 74),
            Size = UDim2.new(1, -32, 0, 50)
        })
        v9 = Kit.text(v7, "", {
            ZIndex = 3,
            StrokeThickness = 3,
            Position = UDim2.fromOffset(16, 132),
            Size = UDim2.new(1, -32, 0, 34)
        })
        v10 = Kit.text(v7, "", {
            ZIndex = 3,
            StrokeThickness = 3,
            Position = UDim2.fromOffset(16, 170),
            Size = UDim2.new(1, -32, 0, 34),
            TextColor3 = v3
        })

        for v100, v101 in {
                {
                    "YES",
                    Style.BUY
                },
                { "NO", v1 }
            } do
            Kit.button(v7, v101[1], v101[2], {
                ZIndex = 3,
                Name = v101[1],
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(v100 == 1 and 0.3 or 0.7, 0, 1, -18),
                Size = UDim2.fromOffset(220, 72)
            }, function() -- line: 326
                -- upvalues: v100 (copy), v23 (ref), v25 (ref)
                if v100 == 1 then
                    v23()
                else
                    v25 = true
                end
            end).Label.ZIndex = 4
        end

        v7.Visible = false
        v11 = Kit.frame(v22, {
            Name = "Top",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.fromOffset(700, 130)
        })

        local v105 = Kit.text(v11, p1.name(), {
            Name = "BossName",
            StrokeThickness = 4,
            Size = UDim2.new(1, 0, 0, 46),
            TextColor3 = Color3.fromRGB(150, 255, 170)
        })

        v11:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 341
            -- upvalues: v105 (copy), p1 (copy)
            v105.Text = p1.name()
        end)

        local v106 = Kit.frame(v11, {
            Name = "Health",
            Position = UDim2.fromOffset(0, 50),
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(40, 20, 24)
        })

        v12 = v106
        Kit.corner(v106, 10)
        Kit.stroke(v106, 4)
        v14 = Kit.frame(v106, {
            Name = "Chip",
            ZIndex = 1,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 240, 200)
        })
        Kit.corner(v14, 10)
        v13 = Kit.frame(v106, {
            Name = "Fill",
            ZIndex = 2,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = v1
        })
        Kit.corner(v13, 10)
        v15 = Kit.text(v106, "", {
            ZIndex = 3,
            StrokeThickness = 3,
            Size = UDim2.fromScale(1, 1)
        })
        v16 = Kit.text(v11, "", {
            StrokeThickness = 3,
            Position = UDim2.fromOffset(0, 88),
            Size = UDim2.new(1, 0, 0, 34),
            TextColor3 = v3
        })
        v17 = Kit.text(v11, "ENRAGED!", {
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(1, 12, 0, 67),
            Size = UDim2.fromOffset(200, 44),
            TextColor3 = v1
        })
        v17.Visible = false
        v11.Visible = false

        local v107 = scaled({
            Name = "Bottom",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -20),
            Size = UDim2.fromOffset(700, 110)
        })

        v18 = Kit.text(v107, "", {
            StrokeThickness = 0,
            Size = UDim2.new(1, 0, 0, 64)
        })
        v19 = Kit.text(v107, "", {
            StrokeThickness = 3,
            Position = UDim2.fromOffset(0, 68),
            Size = UDim2.new(1, 0, 0, 34),
            TextColor3 = v3
        })
        v19.Text = p1.controls(UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
        v18.Visible = false
        v19.Visible = false
        v21 = Kit.frame(v22, {
            Name = "Centre",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.fromOffset(1100, 500)
        })
        v21.Visible = false
        RunService.RenderStepped:Connect(update)
    end

    return t1
end

local v109 = make({
    prefix = "Boss",
    title = "Boss",
    icon = "🐉",
    guiName = "BossHud",
    name = BossSkin.name,
    short = function() -- short | line: 380
        -- upvalues: BossSkin (copy)
        if BossSkin.active() then
            return "The Hullbreaker"
        end

        return "The Loch Ness Monster"
    end,
    seats = BossSeats.COUNT,
    hearts = Economy.Boss.Hearts,
    power = Config.bossRodPower,
    offered = function() -- offered | line: 389
        -- upvalues: LocalPlayer (copy)
        return LocalPlayer:GetAttribute("World2Unlocked") ~= true
    end,
    controls = function(p16) -- controls | line: 392
        if p16 then
            return "Tap the water near it to cast · tap fast to reel · DODGE to roll · jump the waves!"
        end

        return "Click the water near it to cast · click fast to reel · Q / Shift to dodge · jump the waves!"
    end
})

v109.new = make

return v109
