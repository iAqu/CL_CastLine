-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local BeanstalkEventFlags = require(ReplicatedStorage.Shared.Flags.BeanstalkEventFlags)
local BeanstalkGrowth = require(script.Parent.Parent.BeanstalkGrowth)
local EmitOnce = require(ReplicatedStorage.UserGenerated.VFX.EmitOnce)
local Juice = require(script.Parent.Parent.Parent.ScrambleBoss.Juice)
local RailRide = require(script.Parent.Parent.RailRide)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trampoline = require(script.Parent.Parent.Trampoline)

require(ReplicatedStorage.Packages.Trove)

local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local UISystem = require(script.Parent.Parent.UISystem)
local LocalPlayer = Players.LocalPlayer
local Stage2 = ReplicatedStorage.Assets.BeanstalkEventAssets.Stage2
local LeafBowl, Cloud = Stage2.LeafBowl, Stage2.Cloud
local BeanstalkEvent2 = ReplicatedStorage.Assets.Sounds.BeanstalkEvent
local Stage = BeanstalkEvent.Stage
local v1 = CFrame.new(0, 0.5, -2.5)
local v2 = Color3.fromRGB(105, 108, 118)
local t1 = {
    {
        Clouds = 1,
        Scale = 1,
        Radius = 4,
        Period = 8,
        Storm = false
    },
    {
        Clouds = 3,
        Scale = 0.55,
        Radius = 4,
        Period = 10,
        Storm = false
    },
    {
        Clouds = 1,
        Scale = 1,
        Radius = 4,
        Period = 6.5,
        Storm = true
    }
}
local v3 = Color3.fromRGB(255, 240, 60)
local v4 = ReplicatedStorage.Assets.Sounds.LightVsDarknessSounds["Lightning Explosion"]
local RainCircle = Stage2.RainCircle
local v5 = TweenInfo.new(0.6)

local function emitAll(p1) -- line: 97
    -- upvalues: EmitOnce (copy)
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            EmitOnce(descendant)
        end
    end
end

local function flat(p2) -- line: 105
    return (Vector3.new(p2.X, 0, p2.Z))
end

local function groundDisc(p3, p4, p5) -- line: 110
    local Part = Instance.new("Part")

    Part.Name = p3
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(0.2, p4 * 2, p4 * 2)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = p5
    Part.Transparency = 1

    return Part
end

local function serverCount() -- line: 126
    -- upvalues: BeanstalkEvent (copy), LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

    if typeof(Attribute) == "number" then
        return Attribute
    end

    return 0
end

return {
    Run = function(p6, p7, p8, p9) -- Run | line: 135
        -- upvalues: Debris (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), BeanstalkEvent (copy), BeanstalkEventFlags (copy), BeanstalkGrowth (copy), Juice (copy), RailRide (copy), Remotes (copy), Trampoline (copy), TutorialBeam (copy), UISystem (copy), LocalPlayer (copy), LeafBowl (copy), Cloud (copy), BeanstalkEvent2 (copy), Stage (copy), v1 (copy), v2 (copy), t1 (copy), v3 (copy), v4 (copy), RainCircle (copy), v5 (copy), emitAll (copy)
        local PourZone = p7.Sections.Stage2.PourZone
        local v8 = BeanstalkEventFlags.PoursRequired:Get()
        local v9 = p6:Add(Instance.new("Folder"))

        v9.Name = "BeanstalkWatering"
        v9.Parent = Workspace

        local v10 = p6:Add(Instance.new("Highlight"))

        v10.FillColor = Color3.fromRGB(70, 160, 255)
        v10.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        v10.Parent = v9

        local v11 = BeanstalkEvent.MapShift(p7.Beanstalk)
        local Stage2 = p7.Sections.Stage2
        local v12 = Stage2.Floor.Position.Y + Stage2.Floor.Size.Y * 0.5
        local v13 = v11 * Cloud:GetPivot()
        local v15 = Vector3.new(v13.X, v12 + 60, v13.Z)
        local Rotation = v13.Rotation
        local t3 = {}

        for _ = 1, t1[2].Clouds do
            local clone = p6:Clone(Cloud)

            clone:PivotTo(Rotation + v15)
            table.insert(t3, clone)
        end

        local v16 = p7.Sections.Stage2.structures["water collection bucket"]
        local v17, v18 = v16["collected water"], v16["bucket bottom"]
        local _CFrame, Transparency = v17.CFrame, v17.Transparency
        local v19 = _CFrame.Position.Y - (v18.Position.Y + v18.Size.Y * 0.5) - v17.Size.Y * 0.5

        local function showBucketWater(p10) -- line: 168
            -- upvalues: v17 (copy), _CFrame (copy), Transparency (copy), v19 (copy)
            v17.CFrame = _CFrame - Vector3.new(0, v19 * (1 - p10), 0)
            v17.Transparency = if p10 > 0 then Transparency else 1
        end

        local VFX = v16.VFX
        local _CFrame2 = VFX.CFrame

        p6:Add(function() -- line: 174
            -- upvalues: v17 (copy), _CFrame (copy), Transparency (copy), VFX (copy), _CFrame2 (copy)
            v17.CFrame = _CFrame
            v17.Transparency = Transparency
            VFX.CFrame = _CFrame2
        end)

        local function splashBucket() -- line: 180
            -- upvalues: v17 (copy), VFX (copy), emitAll (copy)
            VFX.CFrame = v17.CFrame
            emitAll(VFX)
        end

        local v22 = false

        local function onProgress() -- line: 186
            -- upvalues: p6 (copy), p7 (copy), p8 (copy), v8 (copy), v10 (copy), v17 (copy), _CFrame (copy), Transparency (copy), v19 (copy), v22 (ref), BeanstalkEvent (copy), BeanstalkEventFlags (copy), BeanstalkGrowth (copy), RailRide (copy), Trampoline (copy), UISystem (copy), LocalPlayer (copy), Stage (copy)
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = 0
            end

            local v23 = math.min(Attribute, v8)

            BeanstalkGrowth.SetWilted(1 - v23 / v8)

            local v24 = v23 / v8

            v17.CFrame = _CFrame - Vector3.new(0, v19 * (1 - v24), 0)
            v17.Transparency = if v24 > 0 then Transparency else 1

            if v23 < v8 then
                UISystem.SetProgress("WaterBeanstalk", v23, v8)
            elseif not v22 then
                v22 = true
                v10.Adornee = nil
                UISystem.SetTask("Bounce on the trampoline!")
                UISystem.SetPrompt(nil)
                RailRide.Shake(3)
                BeanstalkGrowth.GrowTo(BeanstalkGrowth.HeightFor(Stage.WhaleFlight), BeanstalkEventFlags.GrowSeconds:Get())
                Trampoline.Show(p6, p7.Sections.Stage2.Trampoline, p7.Sections.Stage3.SpawnLocation, p8)
            end
        end

        p6:Connect(LocalPlayer:GetAttributeChangedSignal(BeanstalkEvent.ProgressAttribute), onProgress)
        p6:Add(function() -- line: 207
            -- upvalues: UISystem (copy)
            UISystem.SetPrompt(nil)
        end)
        onProgress()

        if p9 then
            task.wait(BeanstalkEventFlags.LeafRespawnSeconds:Get())
        end

        local v27 = v11 * LeafBowl:GetPivot()
        local clone = p6:Clone(LeafBowl)

        clone:PivotTo(v27)

        local PrimaryPart = clone.PrimaryPart
        local Water = clone:FindFirstChild("Water")
        local Droplet = Water:FindFirstChild("Droplet")
        local Size = Water.Size
        local v28 = PrimaryPart.CFrame:ToObjectSpace(Water.CFrame)
        local Transparency2 = Water.Transparency

        clone.Parent = v9

        local v29 = false
        local n1 = 0
        local n2 = 0
        local v30 = false
        local v32 = math.max(Size.Y * n1, 0.05)

        Water.Size = Vector3.new(Size.X, v32, Size.Z)
        Water.CFrame = PrimaryPart.CFrame * v28 * CFrame.new(0, (v32 - Size.Y) * 0.5, 0)

        local v31 = if n1 > 0 then Transparency2 else 1

        Water.Transparency = v31

        local function pour() -- line: 241
            -- upvalues: p6 (copy), v10 (copy), splashBucket (copy), v22 (ref), n1 (ref), n2 (ref), v30 (ref), SoundService (copy), Remotes (copy), UISystem (copy), BeanstalkEvent2 (copy)
            v30 = true
            Remotes.BeanstalkEvent.AskPour:FireServer()
            SoundService:PlayLocalSound(BeanstalkEvent2.DepositRainwater)
            v10.Adornee = nil
            p6:Add(task.delay(0.4, splashBucket))

            local elapsed = os.clock()

            while os.clock() - elapsed < 0.8 do
                local v33 = (os.clock() - elapsed) / 0.8

                n2 = math.sin(v33 * 3.141592653589793)
                n1 = 1 - v33
                task.wait()
            end

            n2 = 0
            n1 = 0
            v30 = false

            if not v22 then
                UISystem.SetPrompt("Fill the leaf under the rain cloud")
            end
        end

        local v35 = RaycastParams.new()

        v35.FilterType = Enum.RaycastFilterType.Include
        v35.FilterDescendantsInstances = { Stage2 }
        v35.RespectCanCollide = true

        local function groundUnder(p11) -- line: 267
            -- upvalues: v15 (copy), v35 (copy), Workspace (copy)
            local v37 = Workspace:Raycast(Vector3.new(p11.X, v15.Y, p11.Z), Vector3.new(0, -300, 0), v35)

            return if v37 then v37.Position else nil
        end

        local function rainSpot(p12) -- line: 273
            -- upvalues: v12 (copy), v15 (copy), v35 (copy), Workspace (copy)
            local Position = p12:GetPivot().Position
            local v39 = Workspace:Raycast(Vector3.new(Position.X, v15.Y, Position.Z), Vector3.new(0, -300, 0), v35)
            local v40 = if v39 then v39.Position else nil

            if not v40 then
                v40 = Vector3.new(Position.X, v12, Position.Z)
            end

            return v40
        end

        local v41 = t1[1]
        local n3 = 0
        local n4 = (-1e999)
        local t4 = {}
        local t5 = {}
        local t6 = {}
        local t7 = {}
        local t8 = {}
        local t9 = {}
        local Color = Cloud:FindFirstChildWhichIsA("BasePart", true).Color

        for v42, v43 in t3 do
            t6[v42] = v15
            t7[v42] = 1

            local t10 = {}

            for _, descendant in v43:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    table.insert(t10, descendant)
                    t9[descendant] = descendant.Speed
                end
            end

            t8[v42] = t10
        end

        local function orbit(p13, p14) -- line: 302
            -- upvalues: v15 (copy), v41 (ref)
            local v44 = p14 * 2 * 3.141592653589793 / v41.Period

            if v41.Clouds == 1 then
                return v15 + Vector3.new(math.cos(v44) * 25, 0, math.sin(v44) * 18)
            end

            local v47 = (p13 - 1) * 2 * 3.141592653589793 / v41.Clouds
            local v50 = v15 + Vector3.new(math.cos(v47), 0, (math.sin(v47))) * 15
            local v51 = v47 + v44 * (if p13 % 2 == 0 then -1 else 1)

            return v50 + Vector3.new(math.cos(v51), 0, (math.sin(v51))) * 18
        end

        local function rainingIndex(p15) -- line: 314
            -- upvalues: v41 (ref)
            if v41.Clouds == 1 then
                return 1
            end

            return math.floor(p15 / 5) % v41.Clouds + 1
        end

        local t11 = {}

        for _ in t3 do
            local clone = p6:Clone(RainCircle)

            clone.Parent = v9
            table.insert(t11, clone)
        end

        local Transparency3 = RainCircle.Transparency

        local function placeRainCircles(p16, p17, p18) -- line: 327
            -- upvalues: v12 (copy), v15 (copy), t3 (copy), v35 (copy), v41 (ref), t11 (copy), Transparency3 (copy), Workspace (copy)
            local v56 = (math.sin(p16 * 2 * 3.141592653589793 / 1.2) * 0.5 + 0.5) * 0.2

            for v57, v58 in t11 do
                if p17 and v57 <= v41.Clouds then
                    if v57 == p18 then
                        v58.Transparency = Transparency3 - v56
                    else
                        v58.Transparency = Transparency3
                    end

                    local new = CFrame.new
                    local Position = t3[v57]:GetPivot().Position
                    local v60 = Workspace:Raycast(Vector3.new(Position.X, v15.Y, Position.Z), Vector3.new(0, -300, 0), v35)
                    local v61 = if v60 then v60.Position else nil

                    if not v61 then
                        v61 = Vector3.new(Position.X, v12, Position.Z)
                    end

                    v58.CFrame = new(v61 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                    continue
                end

                v58.Transparency = 1
            end
        end

        local function updateWeather(p19, p20) -- line: 343
            -- upvalues: v8 (copy), t3 (copy), v41 (ref), n3 (ref), n4 (ref), t4 (copy), t5 (copy), t6 (copy), t7 (copy), Color (copy), t11 (copy), TweenService (copy), BeanstalkEvent (copy), LocalPlayer (copy), v2 (copy), t1 (copy)
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = 0
            end

            local v65 = math.clamp(math.min(Attribute, v8 - 1) + 1, 1, #t1)

            if v65 == n3 then
                return
            end

            local v66 = if n3 == 0 then 1 else v41.Clouds

            n3 = v65
            v41 = t1[v65]

            for v67 in t3 do
                local v68 = v66 < v67

                t4[v67] = if v68 then t6[1] else t6[v67]
                t5[v67] = if v68 then t7[1] else t7[v67]
            end

            n4 = if p20 then (-1e999) else p19

            for _, v71 in t11 do
                v71.Size = Vector3.new(v71.Size.X, v41.Radius * 2, v41.Radius * 2)
            end

            local v74 = TweenInfo.new(if p20 then 0 else 1.5)
            local v75 = if v41.Storm then v2 else Color

            for _, v76 in t3 do
                for _, descendant in v76:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        TweenService:Create(descendant, v74, {
                            Color = v75
                        }):Play()
                    end
                end
            end
        end

        local function moveClouds(p21) -- line: 373
            -- upvalues: v9 (copy), Rotation (copy), t3 (copy), v41 (ref), n4 (ref), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), orbit (copy)
            local v78 = math.clamp((p21 - n4) / 1.5, 0, 1)
            local v79 = v78 * v78 * (3 - v78 * 2)

            for v80, v81 in t3 do
                local v82 = v80 <= v41.Clouds
                local v84 = orbit(if v82 then v80 else 1, p21)

                if v78 < 1 then
                    v84 = t4[v80]:Lerp(v84, v79)
                end

                t6[v80] = v84

                local v85

                if v82 or v78 < 1 then
                    local v86 = t5[v80] + (v41.Scale - t5[v80]) * v79

                    if math.abs(v86 - t7[v80]) > 0.001 then
                        v81:ScaleTo(v86)
                        t7[v80] = v86

                        for _, v88 in t8[v80] do
                            v88.Speed = t9[v88]
                        end
                    end

                    v81:PivotTo(Rotation + v84)
                    v85 = v9
                end

                if v81.Parent ~= v85 then
                    v81.Parent = v85
                end
            end

            return v78
        end

        local function setRain(p22) -- line: 403
            -- upvalues: t8 (copy)
            for v89, v90 in t8 do
                for _, v91 in v90 do
                    if v91.Enabled ~= (v89 == p22) then
                        v91.Enabled = v89 == p22
                    end
                end
            end
        end

        updateWeather(os.clock(), true)
        moveClouds(os.clock())

        local Part = Instance.new("Part")

        Part.Name = "LightningStrike"
        Part.Shape = Enum.PartType.Cylinder
        Part.Size = Vector3.new(0.2, 20, 20)
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.Color = v3
        Part.Transparency = 1

        local v92 = p6:Add(Part)
        local v93 = false
        local n5 = 0
        local n6 = 0

        local function fling(p23) -- line: 422
            -- upvalues: p8 (copy), Stage2 (copy), v15 (copy), v35 (copy), n6 (ref), Workspace (copy), Juice (copy)
            local v94 = p8.Root.Position - p23
            local v95 = Vector3.new(v94.X, 0, v94.Z)
            local v96 = if v95.Magnitude > 0.1 then v95.Unit else Vector3.new(1, 0, 0)
            local v97 = p8.Root.Position + v96 * 30
            local v99 = Workspace:Raycast(Vector3.new(v97.X, v15.Y, v97.Z), Vector3.new(0, -300, 0), v35)
            local v100 = (if v99 then v99.Position else nil) or Stage2.SpawnLocation.Position

            n6 = os.clock() + 1.6
            Juice.Throw(p8.Root, p8.Humanoid, v100 + Vector3.new(0, 3, 0), 1.6)
        end

        local function strike(p24, p25) -- line: 430
            -- upvalues: p8 (copy), v9 (copy), t3 (copy), n6 (ref), fling (copy), Debris (copy), SoundService (copy), RailRide (copy), v3 (copy), v4 (copy)
            SoundService:PlayLocalSound(v4)
            RailRide.Shake(3)

            local Position = t3[1]:GetPivot().Position
            local Part = Instance.new("Part")

            Part.Name = "LightningBolt"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Material = Enum.Material.Neon
            Part.Color = v3
            Part.Size = Vector3.new(1.2, 1.2, (Position - p24).Magnitude)
            Part.CFrame = CFrame.lookAt((Position + p24) * 0.5, p24)
            Part.Parent = v9
            Debris:AddItem(Part, 0.15)

            local v101 = p8.Root.Position - p24

            if not (n6 <= p25) then
                return
            end

            if Vector3.new(v101.X, 0, v101.Z).Magnitude <= 10 and v101.Y <= 12 then
                fling(p24)
            end
        end

        local function stepLightning(p26, p27) -- line: 455
            -- upvalues: v9 (copy), v12 (copy), v15 (copy), t3 (copy), v35 (copy), v92 (copy), v93 (ref), n5 (ref), strike (copy), Workspace (copy)
            if p27 then
                if not v93 then
                    v93 = true
                    n5 = p26
                    v92.Parent = v9
                end

                local Position = t3[1]:GetPivot().Position
                local v103 = Workspace:Raycast(Vector3.new(Position.X, v15.Y, Position.Z), Vector3.new(0, -300, 0), v35)
                local v104 = if v103 then v103.Position else nil

                if not v104 then
                    v104 = Vector3.new(Position.X, v12, Position.Z)
                end

                v92.CFrame = CFrame.new(v104 + Vector3.new(0, 0.3, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)

                local v105 = (p26 - n5) / 3

                v92.Transparency = 1 - math.min(v105, 1)

                if v105 >= 1 then
                    strike(v104, p26)
                    v93 = false
                end
            else
                v93 = false

                if v92.Parent ~= nil then
                    v92.Parent = nil
                end
            end
        end

        local Attach = TutorialBeam.Attach
        local v106, Heartbeat

        if v22 then
            v106 = Stage2.Trampoline
        elseif v29 then
            local v107, v108

            if not (n1 < 1) or v30 then
                v106 = Stage2.structures["drop-off pad"]
            else
                v108 = os.clock()

                if v41.Clouds == 1 then
                    v107 = 1
                else
                    Heartbeat = v108 / 5
                    v107 = math.floor(Heartbeat) % v41.Clouds + 1
                end

                v107 = t3[v107]:GetPivot().Position

                local X = v107.X
                local Y = v15.Y

                Heartbeat = v107.Z
                v108 = Vector3.new(X, Y, Heartbeat)
                X = Workspace:Raycast(v108, Vector3.new(0, -300, 0), v35)

                if X then
                    v106 = X.Position
                end

                if not v106 then
                    X = v107.X
                    Heartbeat = v107.Z
                    v106 = Vector3.new(X, v12, Heartbeat)
                end
            end
        else
            v106 = PrimaryPart
        end

        local v110 = Attach(v106)

        p6:Add(function() -- line: 491
            -- upvalues: v110 (copy), TutorialBeam (copy)
            TutorialBeam.Destroy(v110)
        end)

        if not v22 then
            UISystem.SetPrompt("Grab the leaf")
        end

        local n7 = (-1e999)
        local n8 = (-1e999)
        local v111 = false
        local clone2 = p6:Clone(BeanstalkEvent2.CollectingRainwater)

        clone2.Parent = SoundService
        p6:Connect(RunService.Heartbeat, function(p28) -- line: 504
            -- upvalues: p6 (copy), p8 (copy), PourZone (copy), v10 (copy), Stage2 (copy), v12 (copy), v15 (copy), t3 (copy), v16 (copy), v22 (ref), v27 (copy), clone (copy), PrimaryPart (copy), Water (copy), Droplet (copy), Size (copy), v28 (copy), Transparency2 (copy), v29 (ref), n1 (ref), n2 (ref), v30 (ref), pour (copy), v35 (copy), v41 (ref), placeRainCircles (copy), updateWeather (copy), moveClouds (copy), setRain (copy), n6 (ref), stepLightning (copy), v110 (copy), n7 (ref), n8 (ref), v111 (ref), clone2 (copy), TweenService (copy), Workspace (copy), BeanstalkEvent (copy), BeanstalkEventFlags (copy), TutorialBeam (copy), UISystem (copy), v1 (copy), v5 (copy), emitAll (copy)
            local elapsed = os.clock()

            updateWeather(elapsed, false)

            local v112 = moveClouds(elapsed) >= 1
            local v115 = t3[if v41.Clouds == 1 then 1 else math.floor(elapsed / 5) % v41.Clouds + 1]
            local v116 = if not v112 then nil elseif v41.Clouds == 1 then 1 else math.floor(elapsed / 5) % v41.Clouds + 1

            setRain(v116)
            placeRainCircles(elapsed, v112, if v41.Clouds == 1 then 1 else math.floor(elapsed / 5) % v41.Clouds + 1)
            stepLightning(elapsed, v41.Storm and v112 and not v22)

            local Retarget = TutorialBeam.Retarget
            local v120

            if v22 then
                v120 = Stage2.Trampoline
            elseif v29 then
                local t12, v121

                if not (n1 < 1) or v30 then
                    v120 = Stage2.structures["drop-off pad"]
                else
                    t12 = t3

                    local elapsed = os.clock()

                    v121 = if v41.Clouds == 1 then 1 else math.floor(elapsed / 5) % v41.Clouds + 1

                    local Position = t12[v121]:GetPivot().Position
                    local v125 = Workspace:Raycast(Vector3.new(Position.X, v15.Y, Position.Z), Vector3.new(0, -300, 0), v35)

                    if v125 then
                        v120 = v125.Position
                    end

                    if not v120 then
                        v120 = Vector3.new(Position.X, v12, Position.Z)
                    end
                end
            else
                v120 = PrimaryPart
            end

            Retarget(v110, v120)

            local v126 = not v22 and v29 and n1 < 1 and not v30
            local v127 = not (v126 and v41.Clouds > 1)

            if v110.beam.Enabled ~= v127 then
                v110.beam.Enabled = v127
            end

            local RootPosition = p8.Root.Position
            local Position = v115:GetPivot().Position

            if v112 then
                local v128 = RootPosition - Position

                v112 = Vector3.new(v128.X, 0, v128.Z).Magnitude <= v41.Radius and RootPosition.Y < Position.Y
            end

            local v129 = not v22 and v29 and not v30 and n1 < 1 and v112 and n6 <= elapsed

            if clone2.IsPlaying ~= v129 then
                if v129 then
                    clone2:Play()
                else
                    clone2:Stop()
                end
            end

            if v129 and elapsed - n8 >= 0.3 then
                n8 = elapsed
                emitAll(Droplet)
            end

            if v22 then
                if v29 then
                    clone:PivotTo(p8.Root.CFrame * v1 * CFrame.Angles(n2 * 1.3962634015954636, 0, 0))

                    local v131 = math.max(Size.Y * n1, 0.05)

                    Water.Size = Vector3.new(Size.X, v131, Size.Z)
                    Water.CFrame = PrimaryPart.CFrame * v28 * CFrame.new(0, (v131 - Size.Y) * 0.5, 0)
                    Water.Transparency = if n1 > 0 then Transparency2 else 1
                end

                if not v30 and not v111 then
                    v111 = true

                    for _, descendant in clone:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            TweenService:Create(descendant, v5, {
                                Transparency = 1
                            }):Play()
                        end
                    end
                end
            elseif v29 then
                clone:PivotTo(p8.Root.CFrame * v1 * CFrame.Angles(n2 * 1.3962634015954636, 0, 0))

                if v30 then
                    local v134 = math.max(Size.Y * n1, 0.05)

                    Water.Size = Vector3.new(Size.X, v134, Size.Z)
                    Water.CFrame = PrimaryPart.CFrame * v28 * CFrame.new(0, (v134 - Size.Y) * 0.5, 0)
                else
                    if n1 < 1 then
                        if v112 then
                            local v137 = n1

                            n1 = math.min(v137 + p28 / BeanstalkEventFlags.FillSeconds:Get(), 1)

                            if n1 >= 1 then
                                UISystem.SetPrompt("Return to the Beanstalk")
                                v10.Adornee = v16
                            end
                        end
                    elseif BeanstalkEvent.IsInsideBox(PourZone, RootPosition) and elapsed - n7 > BeanstalkEventFlags.MinPourIntervalSeconds:Get() then
                        n7 = elapsed
                        p6:Add(task.spawn(pour))
                    end

                    local v139 = math.max(Size.Y * n1, 0.05)

                    Water.Size = Vector3.new(Size.X, v139, Size.Z)
                    Water.CFrame = PrimaryPart.CFrame * v28 * CFrame.new(0, (v139 - Size.Y) * 0.5, 0)
                end

                Water.Transparency = if n1 > 0 then Transparency2 else 1
            elseif (RootPosition - v27.Position).Magnitude <= 7 then
                v29 = true
                UISystem.SetPrompt("Fill the leaf under the rain cloud")
            end
        end)
    end
}
