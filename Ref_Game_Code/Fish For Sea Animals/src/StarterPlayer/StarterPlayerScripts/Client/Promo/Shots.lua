-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Hud = require(script.Parent.Parent.UI.Hud)
local Poses = require(script.Parent.Parent.Character.Poses)
local CastFlight = require(script.Parent.Parent.Fishing.CastFlight)
local Reveal = require(script.Parent.Parent.Fishing.Reveal)
local Effects = require(script.Parent.Parent.Fishing.Effects)
local Skip = require(script.Parent.Parent.Fishing.Skip)
local Stage = require(script.Parent.Stage)
local LocalPlayer = Players.LocalPlayer
local _ = {
    Id = "KrakenHatchling",
    Name = "Kraken",
    Rarity = "Secret",
    Weight = 48000,
    Income = 5E+06,
    Odds = 2.5E+09,
    Biome = 7,
    Hold = 9
}
local _ = {
    Distance = 2800,
    LuckMult = 3.6
}
local _ = {
    Time = 11,
    StartCash = 1250000,
    StartIncome = 20000,
    EndIncome = 2400000,
    Tick = 0.5
}
local t2 = {
    To = 7,
    Time = 15,
    Height = 7
}
local _ = {
    Title = "FISH FOR SEA ANIMALS",
    Time = 6
}
local v1 = Font.fromEnum(Enum.Font.Bangers)
local v2 = Color3.fromRGB(18, 18, 26)
local v3 = Color3.new(1, 1, 1)
local v4 = Random.new()
local CurrentCamera = workspace.CurrentCamera

return {
    hook = function(p1) -- hook | line: 45
        -- upvalues: Canyon (copy), Poses (copy), CastFlight (copy), Reveal (copy), Effects (copy), Skip (copy), Stage (copy), v4 (copy)
        Stage.toDock()

        local v5 = Canyon.middle(7)
        local v6 = Effects.liquidAt(v5)
        local v7 = Canyon.surface(v5)
        local v10 = Vector3.new(v4:NextNumber(-10, 10), v7, -v5)
        local v11, v12, v13 = CastFlight.makeBobber()

        v13.Enabled = false
        CastFlight.moveBobber(v11, v12, v10)

        local t3 = {
            landing = v10,
            surfaceY = v7,
            liquid = v6,
            color = if v6 then v6.Color else Color3.fromRGB(80, 170, 230),
            bobber = v11,
            cap = v12,
            line = CastFlight.attachLine(Stage.lineStart(), v11.Line)
        }
        local t4 = {
            Id = "KrakenHatchling",
            Name = "Kraken",
            Rarity = "Secret",
            Weight = 48000,
            Income = 5E+06,
            Odds = 2.5E+09,
            Hold = 9,
            IsNew = true,
            Preview = true
        }

        Skip.start(p1, false)
        Stage.fadeIn(p1)
        Reveal.pov(t3, t4, p1)
        Reveal.show(t3, t4, p1)
        Poses.clear()
        Effects.fade(p1, true, 0.5)
    end,
    cast = function(p2) -- cast | line: 83
        -- upvalues: RunService (copy), Config (copy), UIUtil (copy), Poses (copy), CastFlight (copy), Effects (copy), Skip (copy), Stage (copy), v3 (copy), v4 (copy), CurrentCamera (copy)
        local v14 = Stage.toDock()
        local v15 = CFrame.lookAt(v14.Position + Vector3.new(4, 4.5, 10), v14.Position + Vector3.new(0, -8, -70))
        local v16 = CFrame.lookAt(v14.Position + Vector3.new(-4, 2.2, -11), v14.Position + Vector3.new(0, 1.4, 0))

        CurrentCamera.FieldOfView = 70
        CurrentCamera.CFrame = v15
        Effects.fade(p2, false, 0.5)
        task.wait(0.8)
        UIUtil.sound("GoodCast", 0.9)

        local v17 = UIUtil.sound("CastSwing", 0.9)

        if v17 then
            v17.Ended:Once(function() -- line: 95
                -- upvalues: UIUtil (copy)
                UIUtil.sound("CastLine", 0.6)
            end)
        end

        Poses.play("Cast")

        local elapsed = os.clock()

        while true do
            local v18 = os.clock() - elapsed

            if Poses.RELEASE <= v18 then
                break
            end

            local v20 = math.min(v18 / 0.4, 1)

            CurrentCamera.FieldOfView = 70 - v20 * 14
            CurrentCamera.CFrame = Effects.shake(v15:Lerp(v16, 1 - (1 - v20) ^ 3), 0.03 + 0.2 * (v18 / Poses.RELEASE) ^ 2 + math.max(0, 1 - v18 / 0.45) * 0.55)
            RunService.RenderStepped:Wait()
        end

        Effects.flash(p2, v3, 0.3, 0.55)

        local t5 = {
            Distance = 2800,
            Biome = Config.biomeAt(2800),
            Luck = Config.castLuck(2800) * 3.6,
            LandX = v4:NextNumber(-10, 10)
        }

        Skip.start(p2, false)

        local v24 = CastFlight.run(t5, Stage.lineStart(), p2)

        task.wait(0.3)
        Effects.fade(p2, true, 0.5)
        v24.bobber:Destroy()
        Poses.clear()
    end,
    plot = function(p3) -- plot | line: 129
        -- upvalues: RunService (copy), Remotes (copy), UIUtil (copy), Hud (copy), Effects (copy), Stage (copy), CurrentCamera (copy)
        Stage.leaveDock()

        local v25 = Stage.myPlot()
        local Floor = v25 and v25:FindFirstChild("Floor")

        if not Floor then
            return
        end

        Stage.home()
        Remotes.Admin:FireServer("PromoPlot")

        local HUD = UIUtil.gui("HUD")
        local Value = HUD.Stats.Money.Value

        HUD.Stats.Visible = true
        Hud.override("Money", 1250000)
        Hud.override("Income", 20000)
        Stage.setBoardIncome(20000)
        task.wait(0.8)

        local Position = Floor.Position
        local v26 = math.max(Floor.Size.X, Floor.Size.Z) * 0.55 + 14
        local v28 = math.atan2(if Position.X > 0 then -1 else 1, 0.9)

        local function view(p4) -- line: 152
            -- upvalues: Position (copy), v26 (copy), v28 (copy)
            local v29 = v28 + p4 * 0.9599310885968813
            local v33 = Position + Vector3.new(math.sin(v29) * v26, 26 - p4 * 8, math.cos(v29) * v26)

            return CFrame.lookAt(v33, Position + Vector3.new(0, 2, 0))
        end

        CurrentCamera.FieldOfView = 60

        local v34 = v28 + 0
        local v37 = Position + Vector3.new(math.sin(v34) * v26, 26, math.cos(v34) * v26)

        CurrentCamera.CFrame = CFrame.lookAt(v37, Position + Vector3.new(0, 2, 0))
        Stage.fadeIn(p3)

        local elapsed = os.clock()
        local n1 = 1250000
        local n2 = 0.5
        local n3 = 0

        while true do
            local v38 = os.clock() - elapsed
            local v40 = math.min(v38 / 11, 1)
            local v41 = v40 * v40 * (3 - v40 * 2)
            local v42 = v28 + v41 * 0.9599310885968813
            local v46 = Position + Vector3.new(math.sin(v42) * v26, 26 - v41 * 8, math.cos(v42) * v26)

            CurrentCamera.CFrame = CFrame.lookAt(v46, Position + Vector3.new(0, 2, 0))

            if n2 <= v38 then
                n2 += 0.5
                n3 += 1

                local v48 = 20000 * 120 ^ math.min(v40 / 0.7, 1)

                n1 += v48 * 0.5
                Hud.override("Money", n1)
                Hud.override("Income", v48)
                Stage.setBoardIncome(v48)
                UIUtil.pop(Value, 1.12)

                if n3 % 2 == 0 then
                    UIUtil.sound("Cash", 0.25, 1.1)
                end
            end

            if v40 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end

        Effects.fade(p3, true, 0.5)
    end,
    workout = function(p5) -- workout | line: 190
        -- upvalues: RunService (copy), UIUtil (copy), Effects (copy), Stage (copy), LocalPlayer (copy), CurrentCamera (copy)
        local v49 = Stage.myPlot()
        local LiftZone = v49 and v49:FindFirstChild("LiftZone")
        local Center = LiftZone and LiftZone:FindFirstChild("Center")
        local Character = LocalPlayer.Character

        if Center and Character then
            local HUD = UIUtil.gui("HUD")

            HUD.Stats.Visible = true
            Stage.standAt(Stage.top(Center), Center.CFrame.LookVector)

            local n4 = 0

            while not Character:GetAttribute("Lifting") and n4 < 3 do
                n4 += task.wait()
            end

            task.wait(0.4)
            HUD.LeftButtons.Visible = false

            local t6 = {}
            local BarbellUpgrade = v49:FindFirstChild("BarbellUpgrade")
            local v50 = if BarbellUpgrade then BarbellUpgrade:GetDescendants() else {}

            for _, v51 in v50 do
                if v51:IsA("BillboardGui") and v51.Enabled then
                    v51.Enabled = false
                    table.insert(t6, v51)
                end
            end

            local _, _, v52 = Stage.character()
            local v53 = v52.Position + Vector3.new(0, 1, 0)
            local v56 = math.atan2(-Center.CFrame.LookVector.X, -Center.CFrame.LookVector.Z)

            local function view(p6) -- line: 220
                -- upvalues: v53 (copy), v56 (copy)
                local v57 = v56 + 0.6108652381980153 - p6 * 1.2217304763960306
                local v58 = 15 - p6 * 4

                return CFrame.lookAt(v53 + Vector3.new(-math.sin(v57) * v58, 3.5 - p6 * 1, -math.cos(v57) * v58), v53 + Vector3.new(0, 0.3, 0))
            end

            CurrentCamera.FieldOfView = 60

            local v62 = v56 + 0.6108652381980153 - 0

            CurrentCamera.CFrame = CFrame.lookAt(v53 + Vector3.new(-math.sin(v62) * 15, 3.5, -math.cos(v62) * 15), v53 + Vector3.new(0, 0.3, 0))
            Stage.fadeIn(p5)

            local elapsed = os.clock()

            while true do
                local v66 = math.min((os.clock() - elapsed) / 9, 1)
                local v67 = v66 * v66 * (3 - v66 * 2)
                local v68 = v56 + 0.6108652381980153 - v67 * 1.2217304763960306
                local v69 = 15 - v67 * 4

                CurrentCamera.CFrame = CFrame.lookAt(v53 + Vector3.new(-math.sin(v68) * v69, 3.5 - v67 * 1, -math.cos(v68) * v69), v53 + Vector3.new(0, 0.3, 0))

                if v66 >= 1 then
                    break
                end

                RunService.RenderStepped:Wait()
            end

            Effects.fade(p5, true, 0.5)
            Stage.home()

            local n5 = 0

            while Character:GetAttribute("Lifting") and n5 < 2 do
                n5 += task.wait()
            end

            Stage.home()
            HUD.Stats.Visible = false

            for _, v73 in t6 do
                v73.Enabled = true
            end
        end
    end,
    biomes = function(p7) -- biomes | line: 252
        -- upvalues: RunService (copy), Config (copy), Canyon (copy), UIUtil (copy), CastFlight (copy), Effects (copy), Stage (copy), t2 (copy), v3 (copy), CurrentCamera (copy)
        local v74 = -Canyon.middle(7)
        local v75, v76, v77 = CastFlight.makeBobber()

        v77.Enabled = false

        local v78 = Stage.title(p7, {
            StrokeThickness = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.1),
            Size = UDim2.fromScale(0.7, 0.09)
        })

        local function surfaceAt(p8) -- line: 262
            -- upvalues: Canyon (copy)
            return Canyon.surface((math.max(-p8, 0)))
        end

        local function place(p9, p10) -- line: 265
            -- upvalues: v74 (copy)
            local v81 = 1 - (1 - math.min(p9 / 15, 1)) ^ 2.2

            return (Vector3.new(math.sin(p9 * 0.55) * 9, p10 + 7 + math.sin(p9 * 3) * 0.6, -4 + (v74 - -4) * v81))
        end

        local v88 = Canyon.surface(4)

        local function view(p11, p12) -- line: 272
            return CFrame.lookAt(p11 + Vector3.new(3, 4, 15), p11 + Vector3.new(0, -1.5, -12)) * CFrame.Angles(0, 0, math.sin(p12 * 0.9) * 0.06981317007977318)
        end

        local v92 = 1 - (1 - math.min(0 / t2.Time, 1)) ^ 2.2
        local v95 = Vector3.new(0, v88 + t2.Height + 0, -4 + (v74 - -4) * v92)

        CastFlight.moveBobber(v75, v76, v95)
        CurrentCamera.FieldOfView = 72
        CurrentCamera.CFrame = CFrame.lookAt(v95 + Vector3.new(3, 4, 15), v95 + Vector3.new(0, -1.5, -12)) * CFrame.Angles(0, 0, 0)
        v77.Lifetime = 0.15
        v77.Enabled = true

        local v96 = UIUtil.sound("BaitFlight", 0.12, 1, 18)

        if v96 then
            v96.Looped = true
        end

        Stage.fadeIn(p7)

        local elapsed = os.clock()
        local elapsed2 = elapsed
        local n6 = 0
        local v97

        while true do
            local elapsed3 = os.clock()
            local v98 = elapsed3 - elapsed
            local v99 = elapsed3 - elapsed2
            local v101 = 1 - (1 - math.min(v98 / t2.Time, 1)) ^ 2.2

            v97 = Vector3.new(math.sin(v98 * 0.55) * 9, v88 + t2.Height + math.sin(v98 * 3) * 0.6, -4 + (v74 - -4) * v101)

            local Z = v97.Z

            v88 += (Canyon.surface((math.max(-Z, 0))) - v88) * math.min(1, v99 * 2.5)
            CastFlight.moveBobber(v75, v76, v97)
            CurrentCamera.CFrame = CFrame.lookAt(v97 + Vector3.new(3, 4, 15), v97 + Vector3.new(0, -1.5, -12)) * CFrame.Angles(0, 0, math.sin(v98 * 0.9) * 0.06981317007977318)

            local v113 = Config.biomeAtStuds(-v97.Z)

            if v113 ~= n6 then
                n6 = v113

                local v114 = Config.Biomes[v113]

                v78.Text = ("%* %*"):format(v114.Icon, (string.upper(v114.Name)))
                v78.TextColor3 = v114.Color:Lerp(v3, 0.45)
                UIUtil.pop(v78, 1.6)

                if v113 > 1 then
                    UIUtil.sound("Click", 0.5, 0.8 + v113 * 0.06)
                end
            end

            if v98 >= 15 then
                break
            end

            elapsed2 = elapsed3
            RunService.RenderStepped:Wait()
        end

        local v115 = Effects.liquid(n6)
        local X, Z = v97.X, v97.Z
        local v118 = Vector3.new(X, Canyon.surface((math.max(-Z, 0))), v97.Z)
        local elapsed3 = os.clock()

        while os.clock() - elapsed3 < 0.45 do
            local v119 = (os.clock() - elapsed3) / 0.45

            CastFlight.moveBobber(v75, v76, v97:Lerp(v118, v119 * v119))
            RunService.RenderStepped:Wait()
        end

        CastFlight.moveBobber(v75, v76, v118)
        Effects.splash(v118, if v115 then v115.Color else Color3.fromRGB(80, 170, 230), 1.5)
        UIUtil.sound("Splash", 1)

        if v96 then
            v96:Destroy()
        end

        task.wait(1.2)
        Effects.fade(p7, true, 0.5)
        v75:Destroy()
        v78:Destroy()
    end,
    logo = function(p13) -- logo | line: 338
        -- upvalues: RunService (copy), UIUtil (copy), Effects (copy), Stage (copy), v1 (copy), v2 (copy), v3 (copy), CurrentCamera (copy)
        local v120 = CFrame.lookAt(Vector3.new(0, 70, 70), (Vector3.new(0, 0, -260)))
        local v121 = CFrame.lookAt(Vector3.new(0, 58, 25), (Vector3.new(0, 0, -300)))

        CurrentCamera.FieldOfView = 65
        CurrentCamera.CFrame = v120

        local v122 = Stage.title(p13, {
            Text = "FISH FOR SEA ANIMALS",
            StrokeThickness = 8,
            Visible = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.85, 0.22),
            FontFace = v1
        })

        v122.UIStroke.Color = v2

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Color = ColorSequence.new(Color3.fromRGB(120, 230, 255), Color3.fromRGB(40, 120, 255))
        UIGradient.Parent = v122
        Stage.fadeIn(p13)

        local elapsed = os.clock()
        local v123 = false

        while true do
            local v124 = os.clock() - elapsed
            local v126 = math.min(v124 / 6, 1)

            CurrentCamera.CFrame = v120:Lerp(v121, v126 * v126 * (3 - v126 * 2))

            if not v123 and v124 >= 0.8 then
                v122.Visible = true

                local UIScale = Instance.new("UIScale")

                UIScale.Scale = 2.2
                UIScale.Parent = v122
                UIUtil.tween(UIScale, 0.3, {
                    Scale = 1
                }, Enum.EasingStyle.Back)
                Effects.flash(p13, v3, 0.4, 0.4)
                UIUtil.sound("AnimeImpact", 0.9)
                v123 = true
                UIUtil.sound("Luck2", 0.6)
            end

            if v126 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end

        Effects.fade(p13, true, 0.5)
        v122:Destroy()
    end,
    tidy = function(p14) -- tidy | line: 385
        -- upvalues: Poses (copy), Reveal (copy), Skip (copy), Stage (copy)
        Skip.stop()
        Reveal.cleanup()

        for _, v127 in { "Bobber", "FishPOV", "Reveal" } do
            local v128 = workspace:FindFirstChild(v127)

            while v128 do
                v128:Destroy()
                v128 = workspace:FindFirstChild(v127)
            end
        end

        for _, v129 in {
                "CastInfo",
                "Banner",
                "Hooked",
                "Odds",
                "Continue",
                "LuckTitle",
                Stage.TITLE
            } do
            local v130 = p14:FindFirstChild(v129)

            if v130 then
                if v130.Name == Stage.TITLE then
                    v130:Destroy()
                else
                    v130.Visible = false
                end
            end
        end

        Poses.clear()
    end,
    finish = function() -- finish | line: 407
        -- upvalues: Remotes (copy), Hud (copy), Stage (copy), LocalPlayer (copy)
        Stage.leaveDock()
        Remotes.Admin:FireServer("PromoPlotEnd")

        local v131 = Stage.myPlot()
        local Animals = v131 and v131:FindFirstChild("Animals")
        local n7 = 0

        while Animals and Animals:FindFirstChild("Promo1") and n7 < 2 do
            n7 += task.wait()
        end

        for _, v132 in { "Money", "Income", "Strength" } do
            Hud.override(v132, nil)
        end

        Stage.setBoardIncome(LocalPlayer:GetAttribute("Income") or 0)
        Stage.home()
    end
}
