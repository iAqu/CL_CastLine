-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HapticService = game:GetService("HapticService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Poses = require(script.Parent.Parent.Character.Poses)
local CastFlight = require(script.Parent.CastFlight)
local Effects = require(script.Parent.Effects)
local ReelBar = require(script.Parent.ReelBar)
local ReelClick = require(script.Parent.ReelClick)
local Shadow = require(script.Parent.Shadow)
local OddsCounter = require(script.Parent.OddsCounter)
local LuckFX = require(script.Parent.LuckFX)
local AutoClick = require(script.Parent.AutoClick)
local t1 = {}
local v1 = Random.new()
local v2 = Color3.new(1, 1, 1)
local GREEN, RED, GOLD = ReelBar.GREEN, ReelBar.RED, ReelBar.GOLD
local t2 = {
    {
        3,
        v2
    },
    {
        10,
        GOLD
    },
    {
        20,
        Color3.fromRGB(255, 150, 50)
    },
    {
        30,
        Color3.fromRGB(255, 90, 200)
    }
}
local TooStrongRatio = Config.TooStrongRatio
local WIDTH = ReelBar.WIDTH
local cleanup
local v3 = false
local n1 = 0

local function rumble(p1, p2) -- line: 105
    -- upvalues: HapticService (copy), v3 (ref), n1 (ref)
    if not v3 then
        return
    end

    local SetMotor = HapticService.SetMotor
    local Gamepad1 = Enum.UserInputType.Gamepad1
    local Large = Enum.VibrationMotor.Large

    pcall(SetMotor, HapticService, Gamepad1, Large, p1)
    n1 = os.clock() + p2
end

local function stopRumble() -- line: 112
    -- upvalues: HapticService (copy), n1 (ref)
    if not (n1 > 0) then
        return
    end

    n1 = 0

    local SetMotor = HapticService.SetMotor
    local Gamepad1 = Enum.UserInputType.Gamepad1
    local Large = Enum.VibrationMotor.Large

    pcall(SetMotor, HapticService, Gamepad1, Large, 0)
end

function t1.run(p3, p4, p5) -- line: 122
    -- upvalues: HapticService (copy), RunService (copy), UserInputService (copy), Config (copy), Animals (copy), Canyon (copy), UIUtil (copy), Kit (copy), Poses (copy), CastFlight (copy), Effects (copy), ReelBar (copy), ReelClick (copy), Shadow (copy), OddsCounter (copy), LuckFX (copy), AutoClick (copy), v1 (copy), v2 (copy), GREEN (copy), RED (copy), GOLD (copy), t2 (copy), TooStrongRatio (copy), WIDTH (copy), cleanup (ref), v3 (ref), n1 (ref)
    local CurrentCamera = workspace.CurrentCamera
    local v4 = Animals.get(p4.Id)
    local v5 = Config.RarityByName[p4.Rarity or v4.Rarity]

    if type(p4.Fight) == "table" then
        v5 = p4.Fight
    else
        v5 = {
            Ratio = 1,
            Easy = true
        }
    end

    local v7 = v5.Easy == true
    local v6 = math.max(tonumber(v5.Ratio) or 1, 0.2)

    if v7 then
        v6 = math.min(v6, 0.7)
    end

    local v9 = math.sqrt(v6)
    local landing, color, bobber, cap = p3.landing, p3.color, p3.bobber, p3.cap
    local v10 = ReelBar.get(p5)

    v3 = UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil

    local v11 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local v12 = if v3 then "PRESS A TO HOOK IT!" elseif v11 then "TAP TO HOOK IT!" else "CLICK TO HOOK IT!"
    local v13 = if v3 then "MASH A!" elseif v11 then "TAP TAP TAP!" else "CLICK FAST!"

    p3.cover = p3.cover or Effects.waterCover()

    local v14 = Animals.displaySize(p4)
    local v16 = math.clamp((v14 / 6) ^ 0.6, 1, 18)
    local v15 = if not (v16 > 1) then CastFlight.fightSide(landing) elseif landing.Z + v16 * 14 > -Canyon.dockS(-landing.Z) - 3 then -1 else 1
    local v17 = Vector3.new(1.3, 1.9, 4.2) * Vector3.new(1, 1, v15)
    local v18 = 11 * v15
    local v19 = Vector3.new(5, 5.5, v18) * v16
    local v20 = (v16 - 1) * 1.2
    local v21 = Shadow.new(v4.Id, v14, v15, p4.Mutation, bobber)
    local v22 = OddsCounter.start(p5, p4.Odds or 1)
    local v23 = LuckFX.buildUp(p5)
    local n2 = 0

    p3.odds = v22
    ReelBar.reset(v10, 0.35, v4.Id, p4.Mutation)
    v10.root.Position = UDim2.fromScale(0.5, 1.3)
    v10.root.Visible = true
    UIUtil.tween(v10.root, 0.35, {
        Position = UDim2.fromScale(0.5, 0.88)
    }, Enum.EasingStyle.Back)

    local v24 = "hook"
    local n3 = 0.35
    local n4 = 0.35
    local n5 = 0
    local n6 = 0
    local n7 = 0
    local n8 = 0
    local t3 = {}
    local n9 = 0
    local n10 = 0
    local n11 = 0
    local n12 = 0
    local n13 = 0
    local n14 = 0
    local n15 = 0
    local v25
    local n16 = 0
    local elapsed = os.clock()
    local v26 = Effects.exclaim(bobber)

    Effects.splash(landing, color, 0.7)
    UIUtil.sound("Splash", 0.9, 1.35)
    UIUtil.sound("Bite", 0.45)

    local Large, v27

    if v3 then
        local SetMotor = HapticService.SetMotor

        v27 = Enum.UserInputType.Gamepad1
        Large = Enum.VibrationMotor.Large
        pcall(SetMotor, HapticService, v27, Large, 0.7)
        n1 = os.clock() + 0.2
    end

    local n17 = 0.35

    ReelBar.prompt(v10, v12, v2)
    v10.hand.Visible = true
    v10.warn.Visible = true
    UIUtil.pop(v10.warn, 2.5)

    local function win() -- line: 190
        -- upvalues: p5 (copy), color (copy), bobber (copy), v10 (copy), v22 (copy), n2 (ref), v24 (ref), n3 (ref), n11 (ref), n14 (ref), v25 (ref), n17 (ref), HapticService (copy), UIUtil (copy), Kit (copy), Effects (copy), ReelBar (copy), v2 (copy), GREEN (copy), GOLD (copy), WIDTH (copy), v3 (ref), n1 (ref)
        v24 = "won"
        n3 = 1
        n2 = 1
        v22.update(1)

        local elapsed = os.clock()

        n14 = elapsed
        n11 = elapsed + 0.16
        v10.prompt.Text = ""
        v10.combo.Visible = false
        v10.warn.Visible = false
        v10.hand.Visible = false
        v10.mine.BackgroundColor3 = GREEN

        local v28 = Vector2.new(WIDTH + 235, 125)

        Kit.flash(v10.fish, v2, 0.9)
        Kit.burst(v10.root, v28, GOLD, 18, 150)
        Kit.ring(v10.root, v28, v2, 280)
        UIUtil.pop(v10.fish, 1.45)
        Effects.flash(p5, v2, 0.4, 0.25)
        Effects.splash(bobber.Position, color, 1.1)
        UIUtil.sound("Splash", 1, 0.7)
        UIUtil.sound("GoodCast", 0.9, 1.1)
        UIUtil.sound("Pop", 0.6)

        if v3 then
            local SetMotor = HapticService.SetMotor
            local Gamepad1 = Enum.UserInputType.Gamepad1
            local Large = Enum.VibrationMotor.Large

            pcall(SetMotor, HapticService, Gamepad1, Large, 1)
            n1 = os.clock() + 0.3
        end

        n17 = 0.6
        ReelBar.caught(p5, true)

        if v25 then
            UIUtil.tween(v25, 0.3, {
                Volume = 0
            })
        end
    end

    local function lose() -- line: 223
        -- upvalues: p3 (copy), p5 (copy), v6 (ref), landing (copy), color (copy), v10 (copy), v22 (copy), v24 (ref), n3 (ref), n11 (ref), n15 (ref), v25 (ref), n17 (ref), HapticService (copy), UIUtil (copy), Kit (copy), Effects (copy), ReelBar (copy), LuckFX (copy), GREEN (copy), RED (copy), TooStrongRatio (copy), WIDTH (copy), v3 (ref), n1 (ref)
        v24 = "lost"
        n3 = 0

        local elapsed = os.clock()

        n15 = elapsed
        n11 = elapsed + 0.22
        v10.prompt.Text = ""
        v10.combo.Visible = false
        v10.warn.Visible = false
        v10.hand.Visible = false
        v10.mine.BackgroundColor3 = GREEN

        if p3.line then
            p3.line.Enabled = false
        end

        Kit.flash(v10.bar, RED, 0.9)
        Kit.shake(v10.fish, 14, 0.4)
        task.delay(0.45, function() -- line: 240
            -- upvalues: v10 (copy), UIUtil (copy), WIDTH (copy)
            UIUtil.tween(v10.fish, 0.5, {
                Rotation = 40,
                Position = UDim2.fromOffset(WIDTH + 420, 160)
            }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        end)
        Effects.flash(p5, RED, 0.35, 0.5)
        Effects.splash(landing, color, 1.2)
        UIUtil.sound("Whoosh", 0.8, 1.6)
        UIUtil.sound("Splash", 0.9, 0.6)
        task.delay(0.25, UIUtil.sound, "BooWomp", 0.6)

        if v3 then
            local SetMotor = HapticService.SetMotor
            local Gamepad1 = Enum.UserInputType.Gamepad1
            local Large = Enum.VibrationMotor.Large

            pcall(SetMotor, HapticService, Gamepad1, Large, 1)
            n1 = os.clock() + 0.35
        end

        n17 = 0.7

        if v25 then
            UIUtil.tween(v25, 0.2, {
                Volume = 0
            })
        end

        v22.reset()
        LuckFX.reset(p5)
        p3.odds = nil

        local v29 = v6 >= TooStrongRatio

        ReelBar.escaped(p5, v29 and "TOO STRONG!" or "IT GOT AWAY!", v29)
    end

    local function hook(p6) -- line: 261
        -- upvalues: p5 (copy), v6 (ref), landing (copy), color (copy), v10 (copy), v24 (ref), n3 (ref), n5 (ref), n11 (ref), n12 (ref), n13 (ref), v25 (ref), v26 (copy), n17 (ref), v13 (copy), HapticService (copy), UIUtil (copy), Kit (copy), Poses (copy), Effects (copy), ReelBar (copy), ReelClick (copy), v1 (copy), v2 (copy), GREEN (copy), RED (copy), GOLD (copy), WIDTH (copy), v3 (ref), n1 (ref)
        local elapsed = os.clock()

        v24 = "fight"
        n12 = elapsed
        ReelClick.reset()
        n13 = elapsed + v1:NextNumber(0.9, 1.4)
        n11 = elapsed + 0.09

        if v26 then
            v26:Destroy()
        end

        v10.warn.Visible = false

        local floatText = Kit.floatText
        local root = v10.root
        local v30 = Vector2.new((WIDTH + 300) / 2, 30)
        local v32 = if p6 then "PERFECT HOOK!" else "HOOKED!"
        local v31 = if p6 then GOLD else GREEN

        floatText(root, v30, v32, v31, 56)

        if v6 >= 2.6 then
            task.delay(0.35, function() -- line: 275
                -- upvalues: v10 (copy), v24 (ref), n17 (ref), HapticService (copy), UIUtil (copy), Kit (copy), RED (copy), WIDTH (copy), v3 (ref), n1 (ref)
                if v24 ~= "fight" then
                    return
                end

                Kit.floatText(v10.root, Vector2.new((WIDTH + 300) / 2, -20), "IT'S A STRONG ONE!", RED, 50)
                Kit.shake(v10.fish, 12, 0.5)
                UIUtil.sound("Whoosh", 0.6, 0.55)

                if v3 then
                    local SetMotor = HapticService.SetMotor
                    local Gamepad1 = Enum.UserInputType.Gamepad1
                    local Large = Enum.VibrationMotor.Large

                    pcall(SetMotor, HapticService, Gamepad1, Large, 0.8)
                    n1 = os.clock() + 0.3
                end

                n17 = 0.5
            end)
        end

        if p6 then
            n3 = 0.47
            UIUtil.sound("GoodCast", 0.8)
        end

        Effects.flash(p5, v2, 0.25, 0.55)
        Effects.splash(landing, color, 0.9)
        UIUtil.sound("Splash", 1, 0.8)

        if v3 then
            local SetMotor = HapticService.SetMotor
            local Gamepad1 = Enum.UserInputType.Gamepad1
            local Large = Enum.VibrationMotor.Large

            pcall(SetMotor, HapticService, Gamepad1, Large, 1)
            n1 = os.clock() + 0.18
        end

        n17 = 0.5
        n5 += 1.5
        ReelBar.prompt(v10, v13, v2)
        Poses.play("Reel")
        v25 = UIUtil.sound("Reel", 0.4, 0.8, 23)

        if v25 then
            v25.Looped = true
        end
    end

    local function tap() -- line: 303
        -- upvalues: v7 (copy), v9 (copy), color (copy), bobber (copy), v10 (copy), v24 (ref), n3 (ref), n4 (ref), n5 (ref), n6 (ref), n7 (ref), n8 (ref), t3 (copy), n9 (ref), n10 (ref), n12 (ref), n16 (ref), elapsed (copy), win (copy), hook (copy), HapticService (copy), UIUtil (copy), Kit (copy), Effects (copy), ReelClick (copy), v2 (copy), GREEN (copy), t2 (copy), WIDTH (copy), v3 (ref), n1 (ref)
        local elapsed2 = os.clock()

        if v24 == "hook" then
            hook(elapsed2 - elapsed <= 0.55)
            ReelClick.play()
        elseif v24 == "fight" then
            n6 = if elapsed2 - n7 <= 0.4 then n6 + 1 else 1
            n7 = elapsed2
            n8 += 1
            table.insert(t3, elapsed2)

            local v33 = if v7 then math.max(0, elapsed2 - n12 - 3.5) * 0.5 + 1 else 1
            local v36 = n3

            n3 = math.min(v36 + 0.075 / v9 * v33, 1)
            n5 += 1.6
            n9 = 1
            n10 = 1
            ReelClick.play()
            UIUtil.pop(v10.me, 1.15)
            Kit.burst(v10.bar, Vector2.new(n4 * WIDTH, 20), if math.random() < 0.5 then v2 else GREEN, 4, 55)

            if n6 >= 3 then
                local v37 = v2

                for _, v38 in t2 do
                    local v39 = n6

                    if v39 >= v38[1] then
                        v37 = v38[2]
                    end
                end

                v10.combo.Text = ("x%*"):format(n6)
                v10.combo.TextColor3 = v37
                v10.combo.Visible = true
                UIUtil.pop(v10.combo, 1.45)

                if n6 % 10 == 0 then
                    UIUtil.sound("GoodCast", 0.35, n6 / 100 + 1)
                    Kit.ring(v10.root, Vector2.new(65, 125), v37, 220)
                end
            end

            if n8 >= 5 then
                v10.hand.Visible = false
            end

            if v3 then
                local SetMotor = HapticService.SetMotor
                local Gamepad1 = Enum.UserInputType.Gamepad1
                local Large = Enum.VibrationMotor.Large

                pcall(SetMotor, HapticService, Gamepad1, Large, 0.25)
                n1 = os.clock() + 0.05
            end

            if elapsed2 - n16 > 0.12 then
                n16 = elapsed2
                Effects.ripple(bobber.Position, 3, color:Lerp(v2, 0.6))
            end

            if n3 >= 1 then
                win()
            end
        end
    end

    v27 = if v7 then nil else AutoClick.show(p5)

    local t4 = {}
    local connection = UserInputService.InputBegan:Connect(function(p7) -- line: 356
        -- upvalues: tap (copy), v27 (ref)
        local UserInputType = p7.UserInputType

        if v27 and (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and v27.covers(p7.Position) then
            return
        end

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p7.KeyCode == Enum.KeyCode.Space or p7.KeyCode == Enum.KeyCode.ButtonA or p7.KeyCode == Enum.KeyCode.ButtonR2 then
            tap()
        end
    end)
    local v40 = false

    local function cleanup2() -- line: 366
        -- upvalues: p3 (copy), p5 (copy), v10 (copy), v21 (copy), v22 (copy), v24 (ref), v25 (ref), v26 (copy), v27 (ref), connection (copy), v40 (ref), HapticService (copy), ReelBar (copy), ReelClick (copy), Shadow (copy), LuckFX (copy), GREEN (copy), cleanup (ref), n1 (ref)
        if v40 then
            return
        end

        v40 = true
        cleanup = nil
        connection:Disconnect()

        if v27 then
            v27.destroy()
        end

        if n1 > 0 then
            n1 = 0

            local SetMotor = HapticService.SetMotor
            local Gamepad1 = Enum.UserInputType.Gamepad1
            local Large = Enum.VibrationMotor.Large

            pcall(SetMotor, HapticService, Gamepad1, Large, 0)
        end

        ReelClick.stop()

        if v25 then
            v25:Destroy()
        end

        if v26 and v26.Parent then
            v26:Destroy()
        end

        v10.root.Visible = false
        v10.hand.Visible = false
        v10.mine.BackgroundColor3 = GREEN
        ReelBar.hideCaught(p5)
        Shadow.destroy(v21)

        if v24 == "won" then
            return
        end

        if p3.cover then
            p3.cover:Destroy()
            p3.cover = nil
        end

        v22.reset()
        LuckFX.reset(p5)
        p3.odds = nil
    end

    cleanup = cleanup2

    local _CFrame, FieldOfView = CurrentCamera.CFrame, CurrentCamera.FieldOfView
    local elapsed2 = os.clock()
    local n18 = 0.35
    local n19 = 0
    local n20 = 0
    local n21 = 0
    local v41 = false
    local n22 = 0
    local n23 = 0
    local elapsed3 = elapsed2

    while true do
        local elapsed4 = os.clock()
        local v42 = elapsed4 - elapsed3
        local v43 = math.min(v42, 0.1)
        local Gamepad1, Large, v44

        if n1 > 0 and n1 < elapsed4 and n1 > 0 then
            n1 = 0
            v44 = HapticService.SetMotor
            Gamepad1 = Enum.UserInputType.Gamepad1
            Large = Enum.VibrationMotor.Large
            pcall(v44, HapticService, Gamepad1, Large, 0)
        end

        local v45 = false

        if v24 == "won" and elapsed4 - n14 >= 0.8 then
            v45 = true
        elseif v24 == "lost" then
            local v46 = n15

            v45 = elapsed4 - v46 >= 2.6
        end

        if v45 then
            break
        end

        if v24 == "hook" and elapsed4 - elapsed >= 1.6 then
            hook(false)
        end

        if v27 and AutoClick.on() then
            if v24 ~= "hook" or not (elapsed4 - elapsed >= 0.2) then
                if v24 == "fight" and n11 <= elapsed4 then
                    Gamepad1 = AutoClick.taps(t4, v43)

                    for _ = 1, Gamepad1 do
                        if v24 == "fight" then
                            tap()
                        end
                    end
                end
            else
                tap()
            end
        end

        if n11 <= elapsed4 then
            local v48, v49, v50, v51, v52, v53, v55
            local v47 = n21
            local v54 = n20

            if v24 == "fight" then
                local v56 = elapsed4 - n12

                Gamepad1 = 1 - 0.65 * v56 / 8

                local v57 = math.max(0.35, Gamepad1)

                v50 = v9 * 0.125 * v57 * v43

                local v58 = n3 - v50

                n3 = v58

                local v59 = v41

                if v41 then
                elseif n13 - 0.4 <= elapsed4 then
                    v10.warn.Visible = true
                    UIUtil.pop(v10.warn, 2.2)
                    UIUtil.sound("Click", 0.5, 0.6)

                    if v3 then
                        Gamepad1 = HapticService.SetMotor
                        v53 = Enum.UserInputType.Gamepad1
                        v51 = Enum.VibrationMotor.Large
                        pcall(Gamepad1, HapticService, v53, v51, 0.3)
                        n1 = os.clock() + 0.1
                    end

                    v59 = true
                end

                if n13 <= elapsed4 then
                    v10.warn.Visible = false

                    local v60 = elapsed4 + 0.35 + v1:NextNumber(1, 1.6) / v9

                    n13 = v60
                    n5 -= 1.4
                    n17 = 0.55
                    Kit.flash(v10.bar, RED, 0.6)
                    Kit.shake(v10.fish, 9, 0.3)
                    Effects.splash(bobber.Position, color, 0.8)
                    UIUtil.sound("Splash", 0.8, 0.75)
                    UIUtil.sound("Whoosh", 0.5, 0.8)

                    if v3 then
                        Gamepad1 = HapticService.SetMotor
                        v53 = Enum.UserInputType.Gamepad1
                        v51 = Enum.VibrationMotor.Large
                        pcall(Gamepad1, HapticService, v53, v51, 0.9)
                        n1 = os.clock() + 0.25
                    end

                    v54 = v60
                    v47 = 0.25
                    v49 = false
                else
                    v49 = v59
                end

                if v47 > 0 then
                    v50 = v9 * 0.13 * v57 * v43 / 0.25
                    v48 = n3 - v50
                    n3 = v48
                    v47 -= v43
                else
                    v48 = v58
                end

                if v7 then
                    v48 = math.max(n3, 0.04)
                    n3 = v48
                elseif v56 < 1.5 then
                    v48 = math.max(n3, 0.1)
                    n3 = v48
                end

                v44 = not v7 and n3 < 0.2

                local v63 = n22

                if v44 then
                    v53 = elapsed4 * 18
                    v50 = math.sin(v53) * 0.5 + 0.5
                    v10.mine.BackgroundColor3 = GREEN:Lerp(RED, v50 * 0.5 + 0.4)

                    if elapsed4 - n22 > n3 * 1.2 + 0.22 then
                        v63 = elapsed4
                        UIUtil.sound("Tick", 0.45, 0.45)

                        if v3 then
                            Large = HapticService.SetMotor
                            v51 = Enum.UserInputType.Gamepad1
                            v52 = Enum.VibrationMotor.Large
                            pcall(Large, HapticService, v51, v52, 0.45)
                            n1 = os.clock() + 0.08
                        end

                        Kit.flash(v10.bar, RED, 0.35)
                    end
                else
                    v10.mine.BackgroundColor3 = GREEN
                end

                local v64 = if v7 then v56 >= 12 else nil

                if not v7 or not v64 then
                    if not v7 and (n3 <= 0 or v56 >= 18) then
                        lose()
                    elseif v44 then
                        ReelBar.prompt(v10, "IT'S GETTING AWAY!", RED)
                    elseif v47 > 0 or v49 then
                        ReelBar.prompt(v10, "HOLD ON!", RED)
                    elseif n3 > 0.8 then
                        ReelBar.prompt(v10, "ALMOST!", GOLD)
                    else
                        ReelBar.prompt(v10, v13, v2)
                    end
                else
                    win()
                end

                while t3[1] and elapsed4 - t3[1] > 1 do
                    table.remove(t3, 1)
                end

                v55 = v63

                if v25 then
                    v53 = #t3
                    v50 = math.min(v53, 10) * 0.06 + 0.8
                    v25.PlaybackSpeed = v50
                end
            else
                v55 = n22
                v48 = n18
                v49 = v41
            end

            n22 = v55
            v42 = (n3 - n4) * 220 * v43
            n5 += v42
            v44 = v43 * -16
            v42 = math.exp(v44)
            n5 *= v42
            v42 = n5 * v43
            n4 += v42
            v42 = math.clamp(n4, 0, 1)
            ReelBar.place(v10, v42, n9, elapsed4)
            v10.spark.Rotation = 45 + elapsed4 * (#t3 * 60 + 200)
            v10.me.Rotation = -n9 * 8
            v44 = if v49 or v47 > 0 then 2.5 else 1

            if v24 ~= "lost" then
                v50 = v10.fish
                v51 = elapsed4 * (v9 * 4 + 6)
                v50.Rotation = math.sin(v51) * (v9 * 2 + 4) * v44
                v10.mystery.Rotation = -v10.fish.Rotation * 0.5
            end

            local v66, Y

            if v10.hand.Visible then
                v50 = v10.hand
                Gamepad1 = UDim2.fromOffset
                Large = 150 + v42 * WIDTH
                Y = elapsed4 * 7
                v66 = math.sin(Y)
                v50.Position = Gamepad1(Large, 150 - math.abs(v66) * 14)
            end

            v44 = math.clamp((n4 - 0.35) / 0.65, 0, 1)

            if v24 == "fight" or v24 == "won" then
                local v68 = math.max(n2, v44)

                n2 = v68
                v18 = v68
                v42 = v23(Config.luckStage(v22.update(n2)))
            else
                v42 = 0
            end

            v50 = if not (v47 > 0) or v24 ~= "fight" then 0 else 1
            Gamepad1 = v9 * 0.12 + 0.25 + v50 * 0.5

            local Z

            if v24 == "hook" then
                v66 = elapsed4 * 40
                v51 = math.sin(v66) * 0.15
                Z = elapsed4 * 25
                v52 = math.sin(Z) * 0.12 + -0.3
                Large = landing + Vector3.new(v51, v52, 0)
            elseif v24 == "lost" then
                v53 = elapsed4 - n15
                Z = math.exp(-v53 * 2) * 0.15
                Y = Z * math.sin(v53 * 14)
                v66 = Y + math.sin(v53 * 2.5) * 0.06
                v50 = 0
                Large = landing + Vector3.new(0, v66, 0)
            else
                Y = elapsed4 * 11
                v51 = math.sin(Y) * Gamepad1 * 0.6
                v52 = math.sin(elapsed4 * 17) * 0.1 + -0.2 - v50 * 0.4 + n10 * 0.3
                v66 = math.cos(elapsed4 * 9) * Gamepad1 * 0.4 + n10 * 0.4 * v15
                Large = landing + Vector3.new(v51, v52, v66)
            end

            CastFlight.moveBobber(bobber, cap, Large)

            if v21 then
                local v71 = if v24 == "won" then elapsed4 - n14 elseif v24 == "lost" then elapsed4 - n15 else 0

                Shadow.update(v21, elapsed4, landing.Y, Large, v44, n10, v50, v24, v71)
            end

            if v24 == "fight" and elapsed4 - n23 > 0.45 then
                n23 = elapsed4
                Effects.ripple(Large, v9 + 2.5, color:Lerp(v2, 0.6))
            end

            if v24 ~= "lost" then
                v51 = v44 - n19
                Y = -v43 * 3
                n19 += v51 * (1 - math.exp(Y))
            end

            v53 = v17:Lerp(v19, n19)
            Large = v53 + Vector3.new(0, 0, (n9 * 0.5 - v50 * 0.8) * v15)

            if v24 == "lost" then
                v51 = (elapsed4 - n15) / 1.6
                v53 = math.min(v51, 1)
                Z = 4 * v15
                Large += Vector3.new(0, 2.5, Z) * (1 - (1 - v53) ^ 2)
            end

            v53 = landing + Large
            v51 = Canyon.clearView(Vector3.new(math.clamp(v53.X, -44, 44), v53.Y, v53.Z), landing)

            local v72 = -0.2 + (0.3 - v20 + (v14 * 0.2 + v20) * v44 ^ 1.5 + 0.2) * n19

            Large = CFrame.lookAt(v51, landing + Vector3.new(0, v72, 0)) * CFrame.Angles(0, 0, math.sin(elapsed4 * 1.3) * 0.03490658503988659)
            v51 = 1 - (1 - math.min((elapsed4 - elapsed2) / 0.45, 1)) ^ 3
            v52 = _CFrame:Lerp(Large, v51)
            CurrentCamera.CFrame = Effects.shake(v52, n17 + v42 + (if v24 == "fight" then v44 * 0.05 + 0.02 else 0))
            CurrentCamera.FieldOfView = FieldOfView + (n19 * 16 + 46 - n9 * 2 + v50 * 5 - FieldOfView) * v51
            Z = v43 * 6
            n9 = math.max(0, n9 - Z)
            Z = v43 * 8
            n10 = math.max(0, n10 - Z)
            Z = v43 * 1.6
            n17 = math.max(0, n17 - Z)
            n18 = v48
            n20 = v54
            n21 = v47
            v41 = v49
        end

        elapsed3 = elapsed4
        RunService.Heartbeat:Wait()
    end

    UIUtil.tween(v10.root, 0.22, {
        Position = UDim2.fromScale(0.5, 1.3)
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    ReelBar.caught(p5, false)
    task.wait(0.22)
    cleanup2()

    return v24 == "won"
end

function t1.cleanup() -- line: 596
    -- upvalues: cleanup (ref)
    if cleanup then
        cleanup()
    end
end

return t1
