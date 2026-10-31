-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)
local AnimalPOV = require(ReplicatedStorage.Config.AnimalPOV)
local AnimalScale = require(ReplicatedStorage.Config.AnimalScale)
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local AreaUtil = require(ReplicatedStorage.Shared.AreaUtil)
local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local MutationsConfig = require(ReplicatedStorage.Config.MutationsConfig)
local AnimationLibrary = require(ReplicatedStorage.Shared.AnimationLibrary)
local FeetGrounding = require(ReplicatedStorage.Shared.FeetGrounding)

require(ReplicatedStorage.Shared.NumberFormat)

local Boosts = require(ReplicatedStorage.Shared.Boosts)
local Highlights = require(ReplicatedStorage.Shared.Highlights)
local POVTest = require(ReplicatedStorage.Shared.POVTest)
local Parent = script.Parent
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local CameraRig = require(Parent.CameraRig)
local ScreenFX = require(Parent.ScreenFX)
local RevealCard = require(Parent.RevealCard)
local MusicController = require(Parent.MusicController)
local LuckyCatch = require(Parent.LuckyCatch)
local t1 = {}
local _ = UITheme.Colors

local function waitForTap(p1, p2) -- line: 75
    -- upvalues: UserInputService (copy)
    local elapsed = os.clock()
    local v1 = false
    local connection = UserInputService.InputBegan:Connect(function(p3) -- line: 78
        -- upvalues: p2 (copy), elapsed (copy), v1 (ref)
        local UserInputType = p3.UserInputType

        if (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or UserInputType == Enum.UserInputType.Keyboard and (p3.KeyCode == Enum.KeyCode.Space or p3.KeyCode == Enum.KeyCode.Return) or UserInputType == Enum.UserInputType.Gamepad1 and p3.KeyCode == Enum.KeyCode.ButtonA) and os.clock() - elapsed >= (p2 or 0) then
            v1 = true
        end
    end)

    while not v1 and os.clock() - elapsed < p1 do
        task.wait()
    end

    connection:Disconnect()

    return v1
end

local function tapWatcher(p4) -- line: 92
    -- upvalues: UserInputService (copy)
    local v2 = false
    local connection = if p4 then UserInputService.InputBegan:Connect(function(p5) -- line: 96
        -- upvalues: v2 (ref)
        local UserInputType = p5.UserInputType

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or UserInputType == Enum.UserInputType.Keyboard and (p5.KeyCode == Enum.KeyCode.Space or p5.KeyCode == Enum.KeyCode.Return) or UserInputType == Enum.UserInputType.Gamepad1 and p5.KeyCode == Enum.KeyCode.ButtonA then
            v2 = true
        end
    end) else nil

    return function() -- line: 105
        -- upvalues: v2 (ref)
        return v2
    end, function() -- line: 105
        -- upvalues: connection (copy)
        if connection then
            connection:Disconnect()
        end
    end
end

local function makeFillIn(p6, p7) -- line: 111
    local v3 = p7
    local v4

    if not p7 or p6:sub(-#p7) ~= p7 then
        v3 = ""
        v4 = p6
    else
        v4 = p6:sub(1, -#p7 - 1)
    end

    local t2 = {}
    local t3 = {}

    for i = 1, #v4 do
        local v5 = v4:sub(i, i)

        t2[i] = v5

        if v5:match("%w") then
            table.insert(t3, i)
        end
    end

    for i = #t3, 2, -1 do
        local v6 = math.random(1, i)
        local v7 = t3[v6]
        local v8 = t3[i]

        t3[i] = v7
        t3[v6] = v8
    end

    local n1 = -1
    local v9

    return function(p8) -- build | line: 129
        -- upvalues: v3 (ref), t2 (copy), t3 (copy), n1 (ref), v9 (ref)
        local v11 = math.floor(math.clamp(p8, 0, 1) * #t3 + 1E-06)

        if v11 == n1 then
            return v9, false
        end

        n1 = v11

        local t4 = {}

        for i = 1, v11 do
            t4[t3[i]] = true
        end

        local t5 = {}

        for v12, v13 in ipairs(t2) do
            if not v13:match("%w") or t4[v12] then
                t5[v12] = v13
            else
                t5[v12] = "_"
            end
        end

        v9 = table.concat(t5) .. v3

        return v9, true
    end, #t3
end

local function makeDust(p9, p10, p11, p12) -- line: 145
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Position = p9
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(p10 or Color3.new(1, 1, 1))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, p12 or 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new(0.1)
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.3)
    ParticleEmitter.Speed = NumberRange.new(8, 18)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p11 or 40)
    task.delay(2.5, function() -- line: 166
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function chooseApproach(p13, p14, p15) -- line: 175
    -- upvalues: AreasConfig (copy), AreaUtil (copy)
    local Area, FoodPosition = p13.Area, p13.FoodPosition
    local v14 = p14.Speed * p13.POVDuration + p15
    local SubAreas = AreasConfig.SubAreas
    local v15 = (Area.ZStart - Area.ZEnd) / SubAreas
    local v16 = AreaUtil.SubAreaForZ(Area.Index, FoodPosition.Z)
    local v17 = Area.ZStart - v15 * (v16 - 1)
    local v18 = v17 - v15
    local v19 = RaycastParams.new()

    v19.FilterType = Enum.RaycastFilterType.Exclude
    v19.FilterDescendantsInstances = {
        p13.Folder,
        p13.FoodPart
    }

    local v20 = math.random() * 3.141592653589793 * 2
    local n2 = 0
    local v21

    for i = 0, 15 do
        local v22 = v20 + i * 0.39269908169872414
        local v25 = Vector3.new(math.cos(v22), 0, (math.sin(v22)))
        local v26 = v14
        local v27 = -v25
        local X = v27.X
        local XMin, XMax = Area.XMin, Area.XMax
        local X2 = FoodPosition.X

        if not (math.abs(X) < 1E-04) then
            v26 = math.min(v26, (X > 0 and XMax - 3 - X2 or X2 - (XMin + 3)) / math.abs(X))
        end

        local Z = v27.Z
        local Z2 = FoodPosition.Z

        if not (math.abs(Z) < 1E-04) then
            v26 = math.min(v26, (Z > 0 and v17 - 3 - Z2 or Z2 - (v18 + 3)) / math.abs(Z))
        end

        local v30, v31

        if p15 + 4 < v26 then
            local v34 = FoodPosition + Vector3.new(0, if p14.Movement == "Fly" then 2 else math.min(p14.HeadHeight or 2, 4), 0)
            local v35 = workspace:Raycast(v34, v27 * v26, v19)

            if v35 then
                v26 = math.max(0, (v35.Position - v34).Magnitude - 2)
            end

            if n2 < v26 then
                v30 = v26

                if v14 <= v26 then
                    v21 = v25
                    n2 = v30
                    break
                end

                v31 = v25
            else
                v30 = n2
                v31 = v21
            end
        else
            v30 = n2
            v31 = v21
        end

        n2 = v30
        v21 = v31
    end

    if not v21 then
        v21 = Vector3.new(0, 0, -1)
        n2 = p15 + 6
    end

    local v37 = math.min(v14, n2)

    return v21, FoodPosition - v21 * v37, v37
end

local function runPOV(p16, p17, p18, p19, p20, _, p22) -- line: 231
    -- upvalues: TweenService (copy), AreasConfig (copy), MutationsConfig (copy), UIKit (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), tapWatcher (copy)
    local POVDuration, FoodPosition = p16.POVDuration, p16.FoodPosition
    local Movement = p17.Movement
    local v38 = AreasConfig.Get(p16.Result.AreaIndex)
    local v39 = MutationsConfig.Get(p16.Result.Mutation)

    ScreenFX.SetVignette(0.9, 0.01, Color3.new(0, 0, 0))
    ScreenFX.SetVignetteStyle(v39 and v39.Vignette or nil)

    local v40 = Movement == "Swim" and 0.18 or 0.08

    ScreenFX.SetTint(v38.Color, v40, 0.01)
    CameraRig.SetHandheld(1.2)

    local v42 = math.clamp(p17.Speed * 0.5, 0, 14) + 70

    CameraRig.SetBaseFOV(v42)

    local v43

    if Movement == "Swim" then
        v43 = Sounds.Loop("SwimLoop", {
            Volume = 0
        })

        if v43 then
            v43:SetVolume(0.35, 0.6)
        end
    elseif Movement == "Slither" then
        v43 = Sounds.Loop("SlitherLoop", {
            Volume = 0
        })

        if v43 then
            v43:SetVolume(0.25, 0.6)
        end
    elseif Movement == "Fly" then
        v43 = Sounds.Loop("WindLoop", {
            Volume = 0
        })

        if v43 then
            v43:SetVolume(0.25, 0.8)
        end
    end

    local v45 = Vector3.new(-p18.Z, 0, p18.X)
    local v46, v47

    if Movement == "Fly" then
        v46 = p17.Altitude or 10
        v47 = p22 or p17.HeadHeight or 2
    else
        local v48 = p17.HeadHeight or 2

        v46 = v48
        v47 = v48
    end

    local v49 = p17.StepLength or 2
    local v50 = p17.HopLength or 4
    local v51 = p17.FlapInterval or 0.5
    local v52 = v51 * 0.5
    local n3 = 0
    local v53 = math.random() * 100
    local v54 = math.random() * 100
    local elapsed = os.clock()
    local n4 = 0

    local function stepFeedback(p23) -- line: 279
        -- upvalues: p17 (copy), Sounds (copy), CameraRig (copy)
        Sounds.Play(p17.Sound or "Footstep", {
            Volume = (p17.StepVolume or 0.5) * p23,
            Pitch = (p17.StepPitch or 1) * (0.95 + math.random() * 0.1)
        })
        CameraRig.Shake((p17.Shake or 0.3) * 0.7 * p23, 0.28, 20)
    end

    local function travelled(p24) -- line: 284
        -- upvalues: POVDuration (copy)
        local v56 = math.clamp(p24 / POVDuration, 0, 1)

        if v56 < 0.86 then
            return v56
        end

        local v57 = (v56 - 0.86) / 0.14

        return (1 - (1 - v57) * (1 - v57)) * 0.14 + 0.86
    end

    local function v58(p25) -- line: 296
        -- upvalues: p17 (copy), p18 (copy), p19 (copy), p20 (copy), POVDuration (copy), FoodPosition (copy), Movement (copy), v42 (copy), v45 (copy), v46 (ref), v47 (ref), v49 (copy), v50 (copy), v51 (copy), n3 (ref), v53 (copy), v54 (copy), n4 (ref), stepFeedback (copy), TweenService (copy)
        local v60 = math.clamp(p25 / POVDuration, 0, 1)

        if not (v60 < 0.86) then
            local v61 = (v60 - 0.86) / 0.14

            v60 = (1 - (1 - v61) * (1 - v61)) * 0.14 + 0.86
        end

        n4 = v60

        local v62 = v60 * p20
        local v63 = p19 + p18 * v62
        local v65 = math.clamp((v60 - 0.55) / 0.45, 0, 1)
        local v66 = v46 + (v47 - v46) * TweenService:GetValue(v65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local v67, v68, v69

        if Movement == "Walk" then
            local v70 = v62 / v49 * 3.141592653589793
            local v71 = math.sin(v70)

            v67 = v71 * v71 * (p17.Bob or 0.25)
            v68 = math.sin(v70 * 0.5) * (p17.Bob or 0.25) * 0.5
            v69 = math.sin(v70 * 0.5) * 0.02
        else
            if Movement == "Hop" then
                local v74 = v62 / v50
                local v75 = v74 - math.floor(v74)
                local v77 = math.min(p17.HopHeight or 1.5, 1.6)
                local v79 = math.sin(v75 * 3.141592653589793)
                local v80 = v79 * v79 * v77
                local v82 = math.sin(v75 * 3.141592653589793 * 2) * -0.06
                local v83 = math.floor(v74)

                if n3 < v83 and v60 < 0.98 then
                    n3 = v83
                    stepFeedback(1)
                end

                return CFrame.lookAt(v63 + Vector3.new(0, v66 + v80, 0), FoodPosition + Vector3.new(0, 0.5, 0)) * CFrame.Angles(v82, 0, 0), v42
            end

            if Movement == "Fly" then
                v67 = math.sin(p25 / v51 * 3.141592653589793 * 2) * (p17.Bob or 1) * 0.5
                v69 = math.noise(p25 * 0.5, v53) * 0.15
                v68 = math.noise(p25 * 0.4, v54) * 1.5
            elseif Movement == "Swim" then
                v68 = math.sin(p25 * 1.3) * (p17.Sway or 0.5)
                v67 = math.sin(p25 * 0.9) * 0.35
                v69 = math.sin(p25 * 1.3) * 0.05
            elseif Movement == "Slither" then
                local v89 = p17.SwayFrequency or 1.2

                v68 = math.sin(p25 * v89 * 3.141592653589793 * 2) * (p17.Sway or 0.6)
                v67 = 0
                v69 = math.cos(p25 * v89 * 3.141592653589793 * 2) * 0.06
            else
                v67 = 0
                v68 = 0
                v69 = 0
            end
        end

        local v93 = v63 + Vector3.new(0, v66 + v67, 0) + v45 * v68
        local v94 = FoodPosition + Vector3.new(0, 0.4, 0)

        return CFrame.lookAt(v93, v94) * CFrame.Angles(0, 0, v69), v42
    end

    CameraRig.SetShot(v58)
    ScreenFX.FadeIn(0.45)

    local v95, v96 = tapWatcher(p16.CanSkip)
    local v97, v98

    if p16.CanSkip then
        v97 = v49
        v98 = UIKit.Text({
            Text = "tap to skip",
            ZIndex = 20,
            Stroke = 2,
            TextTransparency = 0.35,
            Parent = p16.Gui,
            Size = UDim2.fromScale(0.2, 0.04),
            Position = UDim2.fromScale(0.5, 0.93),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
    else
        v97 = v49
    end

    while true do
        local v99 = os.clock() - elapsed

        if POVDuration <= v99 or v95() then
            break
        end

        local v100 = n4 * p20
        local v101 = v97
        local v102 = v52

        if Movement == "Walk" then
            if v97 <= v100 and n4 < 0.985 then
                v101 = v97 + v49
                stepFeedback(1)
            end
        elseif Movement == "Fly" then
            if v52 <= v99 then
                v102 = v52 + v51
                stepFeedback(0.9)
            end
        elseif (Movement == "Swim" or Movement == "Slither") and v43 then
            v43:SetPitch(math.sin(v99 * 1.3) * 0.1 + 0.9)
        end

        v52 = v102
        task.wait()
        v97 = v101
    end

    v96()

    if v98 then
        v98:Destroy()
    end

    if v43 then
        v43:Stop(0.4)
    end

    CameraRig.SetBaseFOV(70)
end

local function lockIn(p26, p27, p28) -- line: 385
    -- upvalues: RarityConfig (copy), Boosts (copy), Highlights (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy)
    local v104 = RarityConfig.Get(p27.Rarity)

    if p26:LockIn({
        Name = p27.DisplayName,
        Mutation = p27.Mutation,
        Size = p27.Size,
        Rarity = p27.Rarity,
        IncomeText = Boosts.IncomeText(p27.Income, game:GetService("Players").LocalPlayer),
        IsNew = p27.IsNew,
        BadgeText = Highlights.Badge(p27.Highlight)
    }) then
        task.delay(0.1, function() -- line: 397
            -- upvalues: Sounds (copy)
            Sounds.Play("LevelUp", {
                Volume = 0.6,
                Pitch = 1.15
            })
        end)
    end

    Sounds.Play(p28 and "RareReveal" or "Reveal")

    if p28 then
        Sounds.Play("BassHit")
        ScreenFX.Flash(v104.Color, 0.55, 0.6)
        CameraRig.PunchFOV(12, 0.06, 0.6)
        CameraRig.Shake(0.9, 0.5, 16)
        ScreenFX.Ring(v104.Color, 0.8, 60)
        task.delay(0.15, function() -- line: 406
            -- upvalues: v104 (copy), ScreenFX (copy)
            ScreenFX.Ring(v104.Color, 0.9, 40)
        end)
    else
        ScreenFX.Flash(v104.Color, 0.25, 0.4)
        CameraRig.PunchFOV(6, 0.06, 0.4)
        CameraRig.Shake(0.4, 0.3, 18)
        ScreenFX.Ring(v104.Color, 0.6, 50)
    end

    ScreenFX.PulseVignette(0.75, 0.8, v104.Color)
    task.delay(0.8, function() -- line: 414
        -- upvalues: ScreenFX (copy)
        ScreenFX.SetVignette(0.35, 0.4, Color3.new(0, 0, 0))
    end)
end

function t1.Run(p29) -- line: 417
    -- upvalues: RunService (copy), ContentProvider (copy), GameConfig (copy), RarityConfig (copy), AnimalPOV (copy), AnimalScale (copy), AnimalUtil (copy), Mutations (copy), AnimationLibrary (copy), FeetGrounding (copy), POVTest (copy), UIKit (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), RevealCard (copy), MusicController (copy), LuckyCatch (copy), waitForTap (copy), tapWatcher (copy), makeFillIn (copy), makeDust (copy), chooseApproach (copy), runPOV (copy), lockIn (copy)
    local Result = p29.Result
    local v105 = Result.Size or 1
    local v106 = Mutations.ScalePOV(AnimalPOV.Get(Result.ModelName), v105)
    local v107 = RarityConfig.IndexOf(Result.Rarity)
    local Sequence, LuckyCatch2 = GameConfig.Sequence, GameConfig.LuckyCatch
    local v108 = type(Result.Lucky) == "table" and LuckyCatch.new(Result) or nil

    if v108 then
        p29.CanSkip = false
    end

    local IsNew = Result.IsNew

    if not IsNew then
        IsNew = Sequence.DramaticRarityIndex <= v107 or Result.Mutation ~= nil or v108 ~= nil
    end

    p29.POVDuration = v108 and Sequence.POVDuration or POVTest.Duration()

    local Y = p29.FoodPosition.Y
    local v109 = AnimalUtil.GetTemplate(Result.ModelName)
    local v110 = AnimalScale.Get(Result.ModelName).Scale or 1
    local v111 = v110 * v105
    local v112 = (v109 and AnimalUtil.GetSize(v109) or Vector3.new(3, 3, 3)) * v111
    local v113 = math.max(v112.Z, v112.X) / 2 + 1.6
    local v114, v115, v116 = chooseApproach(p29, v106, v113)
    local v120 = math.max(v116 - v113, (math.min(4, v106.Speed * p29.POVDuration)))
    local v121 = p29.FoodPosition - v114 * v113
    local v122 = AnimalUtil.Create(Result.ModelName)

    AnimalUtil.ApplyScale(v122)
    Mutations.ApplySize(v122, v105)

    local v123 = Result.Mutation and Mutations.GetTexture(Result.Mutation) or nil

    Mutations.Apply(v122, Result.Mutation, {
        Hidden = true
    })

    local v124 = AnimalPOV.GetHover(Result.ModelName) * v110
    local PrimaryPart = v122.PrimaryPart
    local t6 = {}

    for _, descendant in ipairs(v122:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1
            table.insert(t6, descendant)
        end
    end

    v122.Parent = p29.Folder

    local v125 = AnimalUtil.PlaceOnGround(v122, Vector3.new(v121.X, Y, v121.Z), v114, v124)

    AnimationLibrary.PlayAnimal(v122, "Idle", {
        FadeTime = 0
    })

    local v126 = false

    task.spawn(function() -- line: 470
        -- upvalues: v122 (copy), v123 (copy), PrimaryPart (copy), v126 (ref), ContentProvider (copy)
        local t7 = {
            PrimaryPart
        }

        if v123 then
            table.insert(t7, v123)
        end

        for _, descendant in ipairs(v122:GetDescendants()) do
            if descendant:IsA("SurfaceAppearance") then
                table.insert(t7, descendant)
            elseif descendant:IsA("BasePart") then
                table.insert(t7, descendant)
            elseif descendant:IsA("Texture") then
                table.insert(t7, descendant)
            end
        end

        local PreloadAsync = ContentProvider.PreloadAsync

        pcall(PreloadAsync, ContentProvider, t7)
        v126 = true
    end)

    local _, v127 = AnimalUtil.GetGrounding(v122)

    if v127 and v124 == 0 then
        local v128 = FeetGrounding.new(v122)

        if v128:HasFeet() then
            local connection

            connection = RunService.Heartbeat:Connect(function(p30) -- line: 485
                -- upvalues: v122 (copy), v125 (copy), v128 (copy), connection (ref)
                if v122.Parent then
                    v122:PivotTo(v125 - Vector3.new(0, v128:Update(p30), 0))
                else
                    connection:Disconnect()
                end
            end)
        end
    end

    local v130, v131 = AnimalUtil.GetBoundingBox(v122)
    local Position = v130.Position

    MusicController.Play("POV")

    if v108 then
        v108:StartPOV(Sequence.POVDuration)
    end

    runPOV(p29, v106, v114, v115, v120, Y, (math.max((v106.HeadHeight or 2) * v110, 1.5)))

    if v108 then
        v108:Hold()
    end

    MusicController.Play(nil, 0.3)
    ScreenFX.Cover(Color3.new(0, 0, 0))
    ScreenFX.SetTint(Color3.new(0, 0, 0), 0, 0.1)
    ScreenFX.SetVignette(0.45, 0.2, Color3.new(0, 0, 0))
    CameraRig.SetHandheld(0.5)

    local elapsed = os.clock()

    while not v126 and os.clock() - elapsed < 2 do
        task.wait()
    end

    for _, v133 in ipairs(t6) do
        v133.LocalTransparencyModifier = 0
    end

    Mutations.SetHidden(v122, false)
    AnimalUtil.SetOutline(v122, Color3.new(0, 0, 0))

    local v135 = Vector3.new(-v114.Z, 0, v114.X)

    if math.random() < 0.5 then
        v135 = -v135
    end

    local FoodPosition = p29.FoodPosition
    local v136 = FoodPosition + v135 * 2.6 + v114 * 1.2 + Vector3.new(0, 1.1, 0)

    local function v137(p31) -- line: 525
        -- upvalues: v135 (ref), FoodPosition (copy), v136 (copy)
        local v140 = v135 * math.sin(p31 * 0.6) * 0.15

        return CFrame.lookAt(v136 + v140, FoodPosition + Vector3.new(0, 0.3, 0)), 55
    end

    CameraRig.SetShot(v137)
    ScreenFX.FadeIn(0.25)
    Sounds.Play("CameraWhoosh", {
        Volume = 0.35,
        Pitch = 1.2
    })

    local v141 = RevealCard.new(p29.Gui, {
        Mutation = Result.Mutation,
        Size = Result.Size
    })
    local v142 = makeFillIn(string.upper(Result.DisplayName))

    v141:SetName(v142(0))

    local v143, v144 = tapWatcher(p29.CanSkip)

    task.wait(v108 and LuckyCatch2.Pause or 0.55)

    local RevealZoomDramatic = IsNew and Sequence.RevealZoomDramatic or Sequence.RevealZoomNormal

    if v108 then
        RevealZoomDramatic += LuckyCatch2.ExtraZoom * v108.Intensity
    end

    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v148 = math.min(1.0471975511965976, math.atan(math.max(ViewportSize.X / math.max(ViewportSize.Y, 1), 0.3) * 0.5773502691896257) * 2)
    local v149 = v131.Magnitude / 2 + 1.5
    local v151 = v149 / math.tan(v148 / 2) * 1.35
    local Unit = (v135 * 0.75 + v114 * 0.65).Unit
    local v152 = Position:Lerp(FoodPosition, 0.2)
    local v155 = v152 + Unit * v151 + Vector3.new(0, v151 * 0.22, 0)
    local v156 = v155
    local v157 = RaycastParams.new()

    v157.FilterType = Enum.RaycastFilterType.Exclude
    v157.FilterDescendantsInstances = {
        p29.Folder,
        p29.FoodPart
    }

    local v158 = v155 - v152
    local v159 = workspace:Raycast(v152, v158, v157)

    if v159 then
        local v162 = math.max((v159.Position - v152).Magnitude - 2, v149 * 1.2)
        local v163 = v152 + (Unit * 0.55 + Vector3.new(0, 0.85, 0)).Unit * v151

        v156 = if workspace:Raycast(v152, v163 - v152, v157) then v152 + v158.Unit * v162 else v163
    end

    local v165 = v152 - Vector3.new(0, v149 * 0.18, 0)

    local function v166(p32) -- line: 578
        -- upvalues: v152 (copy), v156 (ref), v165 (copy)
        local v168 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.sin(p32 * 0.25) * 0.1):VectorToWorldSpace(v156 - v152)

        return CFrame.lookAt(v152 + v168, v165), 60
    end

    if IsNew then
        Sounds.Play("Riser", {
            Start = math.max(0, 4 - RevealZoomDramatic - 0.2)
        })
    end

    CameraRig.BlendTo(v166, RevealZoomDramatic, IsNew and Enum.EasingStyle.Sine or Enum.EasingStyle.Quart)

    if v108 then
        v108:StartZoom(RevealZoomDramatic)
    end

    local elapsed2 = os.clock()

    while os.clock() - elapsed2 < RevealZoomDramatic and (not v143() or not p29.CanSkip) do
        local v170 = (os.clock() - elapsed2) / RevealZoomDramatic
        local v171, v172 = v142(v170)

        if v172 then
            v141:SetName(v171)
            Sounds.Play("LetterTick", {
                Volume = 0.22,
                Pitch = 1 + v170 * 0.5
            })
        end

        task.wait()
    end

    v144()

    if v143() and p29.CanSkip then
        CameraRig.SetShot(v166)
    end

    lockIn(v141, Result, IsNew)

    if v108 then
        v108:Land(Position, v131, p29.Folder)
    end

    if IsNew then
        makeDust(Position, RarityConfig.Get(Result.Rarity).Color, 70, (math.clamp(v131.Magnitude * 0.12, 0.8, 4)))
    end

    AnimalUtil.SetOutline(v122, RarityConfig.Get(Result.Rarity).Color)
    task.delay(1.2, function() -- line: 614
        -- upvalues: v122 (copy), AnimalUtil (copy)
        if v122.Parent then
            AnimalUtil.SetOutline(v122, Color3.new(0, 0, 0))
        end
    end)

    local v174, v175

    if p29.Owned or v107 <= Sequence.ShortRarityIndex then
        local ShowTimeShort = Sequence.ShowTimeShort

        if ShowTimeShort then
            v174 = ShowTimeShort
            v175 = true
        else
            v175 = false
        end
    else
        v175 = false
    end

    if not v175 then
        v174 = Sequence.ShowTimeNormal
    end

    if Result.IsNew then
        v174 = Sequence.ShowTimeNormal
    end

    local SkipAfterRevealDelay = Sequence.SkipAfterRevealDelay

    if v108 then
        v174 = Sequence.ShowTimeNormal + LuckyCatch2.ShowTimeBonus
        SkipAfterRevealDelay = LuckyCatch2.ContinueDelay
    end

    local v176 = UIKit.Text({
        Text = "tap to continue",
        ZIndex = 20,
        Stroke = 2,
        TextTransparency = 1,
        Parent = p29.Gui,
        Size = UDim2.fromScale(0.2, 0.035),
        Position = UDim2.fromScale(0.5, 0.975),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    task.delay(SkipAfterRevealDelay, function() -- line: 628
        -- upvalues: v176 (copy), UIKit (copy)
        UIKit.Tween(v176, {
            TextTransparency = 0.3
        }, 0.4)
    end)
    waitForTap(v174, SkipAfterRevealDelay)
    v176:Destroy()
    v141:Destroy()

    if v108 then
        v108:Finish()
    end

    return v122
end

return t1
