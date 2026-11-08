-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local BeanstalkEventFlags = require(ReplicatedStorage.Shared.Flags.BeanstalkEventFlags)
local BeanstalkGrowth = require(script.Parent.Parent.BeanstalkGrowth)
local EmitOnce = require(ReplicatedStorage.UserGenerated.VFX.EmitOnce)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Juice = require(script.Parent.Parent.Parent.ScrambleBoss.Juice)
local RailRide = require(script.Parent.Parent.RailRide)
local Trampoline = require(script.Parent.Parent.Trampoline)
local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Shake = require(ReplicatedStorage.Client.Shake)

require(ReplicatedStorage.Packages.Trove)

local UISystem = require(script.Parent.Parent.UISystem)
local LocalPlayer = Players.LocalPlayer
local Firefly = ReplicatedStorage.Assets.BeanstalkEventAssets.Firefly
local CollectFirefly = ReplicatedStorage.Assets.Sounds.BeanstalkEvent.CollectFirefly
local FireflyPickup, FireflyPopup = ReplicatedStorage.Assets.BeanstalkEventAssets.FireflyPickup, ReplicatedStorage.Assets.BeanstalkEventAssets.FireflyPopup
local Stage = BeanstalkEvent.Stage
local v1 = Color3.fromRGB(255, 253, 199)
local v2 = Color3.fromRGB(255, 214, 80)
local v3 = Color3.fromRGB(110, 62, 0)
local v4 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v6 = TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v7 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local Spider = ReplicatedStorage.AssetModels.Spider
local Idle, Walk = Assets.Directory.Spider.Animations.Idle, Assets.Directory.Spider.Animations.Walk
local v8 = Color3.fromRGB(255, 40, 40)
local v9 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local v10 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v11 = TweenInfo.new(0.2)
local v12 = Color3.fromRGB(235, 235, 235)
local v13 = Color3.fromRGB(255, 40, 40)
local v14 = Color3.fromRGB(120, 0, 0)
local v15 = Color3.fromRGB(255, 140, 140)
local v16 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local v17 = Random.new()
local CurrentCamera = Workspace.CurrentCamera
local tween = nil
local FieldOfView

local function floorTop(p1) -- line: 171
    return p1.Position.Y + p1.Size.Y * 0.5
end

local function clampToArea(p2, p3) -- line: 176
    -- upvalues: BeanstalkGrowth (copy)
    local v18 = BeanstalkGrowth.Axis(p2.Y)
    local v19 = (p2 - v18) * Vector3.new(1, 0, 1)
    local v20 = math.clamp(v19.Magnitude, 60, 105)
    local v21 = v18 + (if v19.Magnitude > 0.01 then v19.Unit else Vector3.new(1, 0, 0)) * v20
    local v22 = p3.Size * 0.5
    local v23 = p3.CFrame:PointToObjectSpace(v21)
    local v30 = Vector3.new(math.clamp(v23.X, -v22.X + 5, v22.X - 5), v23.Y, (math.clamp(v23.Z, -v22.Z + 5, v22.Z - 5)))

    return p3.CFrame:PointToWorldSpace(v30)
end

local function hoverSpot(p4, p5) -- line: 193
    -- upvalues: Workspace (copy), v17 (copy)
    local Floor = p4.Floor
    local v31 = Floor.Position.Y + Floor.Size.Y * 0.5
    local v34 = Workspace:Raycast(Vector3.new(p5.X, v31 + 60, p5.Z), Vector3.new(0, -120, 0), p4.Ground)
    local v35 = v34 == nil
    local v36 = if not v35 then math.abs(v34.Position.Y - v31) > 4 else nil

    return if not v35 and not v36 then Vector3.new(p5.X, v34.Position.Y + v17:NextNumber(3, 7), p5.Z) else nil
end

local function randomSpot(p6) -- line: 207
    -- upvalues: BeanstalkGrowth (copy), v17 (copy), clampToArea (copy), hoverSpot (copy)
    for _ = 1, 40 do
        local v39 = v17:NextNumber(0, 6.283185307179586)
        local v40 = v17:NextNumber(60, 105)
        local v45 = hoverSpot(p6, clampToArea(BeanstalkGrowth.Axis(0) + Vector3.new(math.cos(v39), 0, (math.sin(v39))) * v40, p6.Floor))

        if v45 ~= nil then
            return v45
        end
    end

    error((`No open ground for fireflies in {40} tries around the stalk`))
end

local function spawnFirefly(p7, p8, p9) -- line: 221
    -- upvalues: TweenService (copy), Firefly (copy), v7 (copy), v17 (copy), randomSpot (copy)
    local v46 = randomSpot(p9)
    local clone = p7:Clone(Firefly)

    clone:PivotTo(CFrame.new(v46))

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            local Transparency = descendant.Transparency

            descendant.Transparency = 1
            TweenService:Create(descendant, v7, {
                Transparency = Transparency
            }):Play()
        elseif descendant:IsA("Light") then
            local Brightness = descendant.Brightness

            descendant.Brightness = 0
            TweenService:Create(descendant, v7, {
                Brightness = Brightness
            }):Play()
        end
    end

    clone.Parent = p8

    return {
        FleeFrom = nil,
        FleeTo = nil,
        FleeStartedAt = 0,
        TiredUntil = 0,
        Model = clone,
        Rest = v46,
        Position = v46,
        Phase = v17:NextNumber(0, 6.283185307179586)
    }
end

local function beginFlee(p10, p11, p12) -- line: 250
    -- upvalues: v17 (copy), clampToArea (copy), hoverSpot (copy)
    local v47 = (p10.Position - p11) * Vector3.new(1, 0, 1)
    local v48 = if v47.Magnitude > 0.01 then v47.Unit else Vector3.new(1, 0, 0)
    local v49 = CFrame.Angles(0, v17:NextNumber(-0.6981317007977318, 0.6981317007977318), 0):VectorToWorldSpace(v48)
    local v50 = hoverSpot(p12, clampToArea(p10.Position + v49 * 20, p12.Floor))

    if v50 ~= nil then
        p10.FleeFrom = p10.Position
        p10.FleeTo = v50
        p10.FleeStartedAt = os.clock()
    else
        p10.TiredUntil = os.clock() + 0.3
    end
end

local function stepFirefly(p13, p14, p15, p16, p17) -- line: 267
    -- upvalues: beginFlee (copy)
    local elapsed = os.clock()
    local FleeTo = p13.FleeTo

    if FleeTo ~= nil then
        local v51 = FleeTo - p13.Position
        local v52 = p15 * 0.85 * p17

        if v51.Magnitude <= v52 or elapsed - p13.FleeStartedAt >= 1.6 then
            p13.FleeTo = nil
            p13.Rest = p13.Position
            p13.TiredUntil = elapsed + 1.5
        else
            p13.Position += v51.Unit * v52
        end
    elseif p13.TiredUntil <= elapsed and ((p13.Position - p14.Position) * Vector3.new(1, 0, 1)).Magnitude < 22 then
        beginFlee(p13, p14.Position, p16)
    end

    local v55 = Vector3.new(0, math.sin(elapsed * 0.6 * 2 * 3.141592653589793 + p13.Phase) * 0.8, 0)

    p13.Model:PivotTo(CFrame.new(p13.Position + v55))
end

local function flyIntoStalk(p18, p19) -- line: 297
    -- upvalues: TweenService (copy), BeanstalkGrowth (copy)
    local PrimaryPart = p18.PrimaryPart
    local Trail = PrimaryPart:FindFirstChild("Trail")

    Trail.Enabled = true

    local v56 = BeanstalkGrowth.Axis(PrimaryPart.Position.Y + 6)

    TweenService:Create(PrimaryPart, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        CFrame = CFrame.new(v56),
        Size = PrimaryPart.Size * 0.4
    }):Play()
    task.delay(1.2, p19)
    task.delay(1.2 + Trail.Lifetime, function() -- line: 313
        -- upvalues: p18 (copy)
        p18:Destroy()
    end)
end

local function reducedMotion() -- line: 318
    -- upvalues: GuiService (copy)
    return GuiService.ReducedMotionEnabled
end

local function impactFrame(p20, p21) -- line: 322
    -- upvalues: TweenService (copy), Flash (copy), v1 (copy), v2 (copy)
    p20.Brightness = p21 and 0.28 or 0.18
    p20.Contrast = p21 and 0.7 or 0.45
    p20.Saturation = -0.35
    p20.TintColor = v1:Lerp(v2, 0.35)
    TweenService:Create(p20, TweenInfo.new(p21 and 0.4 or 0.22, Enum.EasingStyle.Quad), {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.new(1, 1, 1)
    }):Play()
    Flash.Play({
        Attack = 0.02,
        Decay = p21 and 0.45 or 0.25,
        Tint = v2,
        Opacity = p21 and 0.4 or 0.22
    })
end

local function restoreFov() -- line: 340
    -- upvalues: CurrentCamera (copy), tween (ref), FieldOfView (ref)
    local tween2 = tween

    if tween2 == nil then
        return
    end

    tween = nil
    tween2:Cancel()

    if CurrentCamera and FieldOfView then
        CurrentCamera.FieldOfView = FieldOfView
    end

    FieldOfView = nil
end

local function fovPulse(p22) -- line: 353
    -- upvalues: GuiService (copy), TweenService (copy), v4 (copy), v5 (copy), v6 (copy), CurrentCamera (copy), tween (ref), FieldOfView (ref)
    if GuiService.ReducedMotionEnabled or CurrentCamera == nil then
        return
    end

    if tween ~= nil then
        tween:Cancel()
    else
        FieldOfView = CurrentCamera.FieldOfView
    end

    local v58 = FieldOfView or CurrentCamera.FieldOfView
    local tween2 = TweenService:Create(CurrentCamera, v4, {
        FieldOfView = v58 - (p22 and 12 or 7)
    })

    tween = tween2
    tween2:Play()
    tween2.Completed:Once(function(p23) -- line: 369
        -- upvalues: p22 (copy), tween2 (copy), v58 (copy), TweenService (copy), v5 (copy), v6 (copy), CurrentCamera (copy), tween (ref), FieldOfView (ref)
        if p23 == Enum.PlaybackState.Completed and tween == tween2 then
            local tween3 = TweenService:Create(CurrentCamera, if p22 then v6 else v5, {
                FieldOfView = v58
            })

            tween = tween3
            tween3:Play()
            tween3.Completed:Once(function() -- line: 378
                -- upvalues: tween3 (copy), tween (ref), FieldOfView (ref)
                if tween == tween3 then
                    tween = nil
                    FieldOfView = nil
                end
            end)
        end
    end)
end

local function hitFlash(p24) -- line: 387
    -- upvalues: Debris (copy), TweenService (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "HitFlash"
    Highlight.FillColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 0.1
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p24
    Highlight.Parent = p24
    TweenService:Create(Highlight, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
        FillTransparency = 1
    }):Play()
    Debris:AddItem(Highlight, 0.16999999999999998)
end

local function popup(p25, p26, p27) -- line: 402
    -- upvalues: Debris (copy), TweenService (copy), FireflyPopup (copy), v2 (copy), v3 (copy)
    local Part = Instance.new("Part")

    Part.Name = "FireflyPopup"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p26)
    Part.Parent = p25

    local clone = FireflyPopup:Clone()

    clone.Adornee = Part
    clone.Parent = Part

    local v60 = TweenInfo.new(0.36000000000000004, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.54)
    local v61 = clone:FindFirstChild("Label", true)

    if v61 and v61:IsA("TextLabel") then
        v61.Text = p27
        v61.TextColor3 = v2
        v61.TextTransparency = 0
        TweenService:Create(v61, v60, {
            TextTransparency = 1
        }):Play()

        local UIStroke = v61:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v3
            TweenService:Create(UIStroke, v60, {
                Transparency = 1
            }):Play()
        end
    end

    local UIScale = clone:FindFirstChildOfClass("UIScale")

    if UIScale then
        UIScale.Scale = 0.4
        TweenService:Create(UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    TweenService:Create(Part, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(p26 + Vector3.new(0, 3.5, 0))
    }):Play()
    Debris:AddItem(Part, 1)
end

local function catchJuice(p28, p29) -- line: 453
    -- upvalues: GuiService (copy), Shake (copy), impactFrame (copy), fovPulse (copy)
    impactFrame(p28, p29)
    fovPulse(p29)

    if GuiService.ReducedMotionEnabled then
        return
    end

    Shake.Play({
        Shape = "Fade",
        Seconds = p29 and 0.45 or 0.22,
        Magnitude = p29 and 0.9 or 0.35
    })
end

local function burstAt(p30, p31) -- line: 466
    -- upvalues: Debris (copy), EmitOnce (copy), FireflyPickup (copy)
    local clone = FireflyPickup:Clone()

    clone.Position = p31
    clone.Parent = p30

    local n1 = 0

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            n1 = math.max(n1, EmitOnce(descendant))
        end
    end

    Debris:AddItem(clone, n1)
end

local function flat(p32) -- line: 479
    return (Vector3.new(p32.X, 0, p32.Z))
end

local function nearestAngle(p33, p34) -- line: 484
    return p33 + (p34 - p33 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function groundAt(p35, p36) -- line: 489
    -- upvalues: Workspace (copy)
    local Floor = p35.Floor
    local v62 = Floor.Position.Y + Floor.Size.Y * 0.5
    local v65 = Workspace:Raycast(Vector3.new(p36.X, v62 + 60, p36.Z), Vector3.new(0, -120, 0), p35.Ground)

    if v65 then
        return v65.Position
    end

    return (Vector3.new(p36.X, v62, p36.Z))
end

local function clampToFloor(p37, p38) -- line: 497
    -- upvalues: BeanstalkGrowth (copy)
    local v66 = BeanstalkGrowth.Axis(p37.Y)
    local v67 = p37 - v66
    local v68 = Vector3.new(v67.X, 0, v67.Z)
    local v69 = if v68.Magnitude < 50 then v66 + (if v68.Magnitude > 0.01 then v68.Unit else Vector3.new(1, 0, 0)) * 50 else p37
    local v70 = p38.Size * 0.5
    local v71 = p38.CFrame:PointToObjectSpace(v69)
    local v78 = Vector3.new(math.clamp(v71.X, -v70.X + 5, v70.X - 5), v71.Y, (math.clamp(v71.Z, -v70.Z + 5, v70.Z - 5)))

    return p38.CFrame:PointToWorldSpace(v78)
end

local function strikeMarker(p39) -- line: 514
    -- upvalues: TweenService (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy)
    local Part = Instance.new("Part")

    Part.Name = "SpiderStrike"
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(0.2, 40, 40)
    Part.CFrame = CFrame.new(p39 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = v13
    TweenService:Create(Part, v16, {
        Color = v14
    }):Play()

    local Highlight = Instance.new("Highlight")

    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillColor = v15
    Highlight.OutlineColor = v15
    Highlight.FillTransparency = 0.85
    Highlight.Adornee = Part
    Highlight.Parent = Part
    TweenService:Create(Highlight, v16, {
        FillTransparency = 0.35
    }):Play()

    return Part
end

local function serverCount() -- line: 539
    -- upvalues: BeanstalkEvent (copy), LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

    if typeof(Attribute) == "number" then
        return Attribute
    end

    return 0
end

return {
    Run = function(p40, p41, p42) -- Run | line: 548
        -- upvalues: Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), BeanstalkEvent (copy), BeanstalkEventFlags (copy), BeanstalkGrowth (copy), Juice (copy), RailRide (copy), Trampoline (copy), TutorialBeam (copy), Remotes (copy), UISystem (copy), LocalPlayer (copy), CollectFirefly (copy), Stage (copy), Spider (copy), Idle (copy), Walk (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v17 (copy), clampToArea (copy), hoverSpot (copy), randomSpot (copy), spawnFirefly (copy), stepFirefly (copy), flyIntoStalk (copy), restoreFov (copy), hitFlash (copy), popup (copy), catchJuice (copy), burstAt (copy), clampToFloor (copy), strikeMarker (copy)
        local v79 = RaycastParams.new()

        v79.FilterType = Enum.RaycastFilterType.Include
        v79.FilterDescendantsInstances = { p41.Sections.Stage1 }
        v79.RespectCanCollide = true

        local t5 = {
            Floor = p41.Sections.Stage1.Floor,
            Ground = v79
        }
        local v80 = BeanstalkEventFlags.FirefliesRequired:Get()
        local v81 = p40:Add(Instance.new("Folder"))

        v81.Name = "BeanstalkFireflies"
        v81.Parent = Workspace

        local t6 = {}
        local v82 = p40:Add(Instance.new("Highlight"))

        v82.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        v82.FillTransparency = 0.4
        v82.OutlineColor = Color3.fromRGB(255, 240, 120)
        v82.Parent = v81

        local v83 = p40:Add(Instance.new("ColorCorrectionEffect"))

        v83.Name = "FireflyImpact"
        v83.Parent = Lighting
        p40:Add(restoreFov)

        local n2 = (-1e999)
        local n3 = 0
        local v84 = false
        local v85 = true

        p40:Add(function() -- line: 573
            -- upvalues: v85 (ref)
            v85 = false
        end)

        local v86 = p40:Extend()
        local n4 = 0
        local t7 = {}
        local t8 = {}
        local n5 = 0

        local function fling(p43) -- line: 588
            -- upvalues: p42 (copy), t5 (copy), n5 (ref), Juice (copy), RailRide (copy), clampToArea (copy), hoverSpot (copy), randomSpot (copy)
            local v87 = p42.Root.Position - p43
            local v88 = Vector3.new(v87.X, 0, v87.Z)
            local v89 = if v88.Magnitude > 0.1 then v88.Unit else Vector3.new(1, 0, 0)
            local v90 = hoverSpot(t5, clampToArea(p42.Root.Position + v89 * 30, t5.Floor)) or randomSpot(t5)

            n5 = os.clock() + 1.5
            Juice.Throw(p42.Root, p42.Humanoid, v90, 1.5)
            RailRide.Shake(5)
        end

        local function strike(p44) -- line: 598
            -- upvalues: p42 (copy), n5 (ref), fling (copy)
            local v91 = p42.Root.Position - p44

            if not (os.clock() >= n5) then
                return
            end

            if Vector3.new(v91.X, 0, v91.Z).Magnitude <= 20 and v91.Y <= 12 then
                fling(p44)
            end
        end

        local function chooseSpot(p45) -- line: 610
            -- upvalues: t5 (copy), t6 (copy), t8 (copy), Workspace (copy), v17 (copy), randomSpot (copy)
            local v92 = #t6 >= 3
            local t9, v93

            if v92 then
                t9 = {}

                for _, v94 in t6 do
                    if v94 ~= p45 and not t8[v94] then
                        table.insert(t9, v94)
                    end
                end

                v93 = #t9 > 0
            end

            if not v92 or not v93 then
                local v95 = randomSpot(t5)
                local Floor = t5.Floor
                local v96 = Floor.Position.Y + Floor.Size.Y * 0.5
                local v99 = Workspace:Raycast(Vector3.new(v95.X, v96 + 60, v95.Z), Vector3.new(0, -120, 0), t5.Ground)

                return if v99 then v99.Position else Vector3.new(v95.X, v96, v95.Z), nil
            end

            local v101 = t9[v17:NextInteger(1, #t9)]
            local Position = v101.Position
            local Floor = t5.Floor
            local v102 = Floor.Position.Y + Floor.Size.Y * 0.5
            local v105 = Workspace:Raycast(Vector3.new(Position.X, v102 + 60, Position.Z), Vector3.new(0, -120, 0), t5.Ground)

            return if v105 then v105.Position else Vector3.new(Position.X, v102, Position.Z), v101
        end

        local function spawnSpider(p46) -- line: 628
            -- upvalues: p42 (copy), t5 (copy), v81 (copy), v86 (copy), t7 (copy), t8 (copy), n5 (ref), fling (copy), chooseSpot (copy), RunService (copy), TweenService (copy), Workspace (copy), RailRide (copy), Spider (copy), Idle (copy), Walk (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v17 (copy), clampToArea (copy), randomSpot (copy), clampToFloor (copy), strikeMarker (copy)
            local clone = v86:Clone(Spider)

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                end
            end

            clone.PrimaryPart.Anchored = true

            local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
            local v107 = (BoundingBox * CFrame.new(0, -BoundingBox2.Y * 0.5, 0)):ToObjectSpace(clone:GetPivot())
            local v108 = clone:GetPivot():ToObjectSpace(BoundingBox)
            local v109 = v86:Add(Instance.new("Part"))

            v109.Name = "SpiderSilk"
            v109.Size = Vector3.new(0.25, 1000, 0.25)
            v109.Color = v12
            v109.Material = Enum.Material.SmoothPlastic
            v109.Anchored = true
            v109.CanCollide = false
            v109.CanQuery = false
            v109.CanTouch = false
            v109.CastShadow = false

            local n6 = 0
            local v110
            local v111 = true

            local function pose(p47, p48) -- line: 658
                -- upvalues: clone (copy), v107 (copy), v108 (copy), v109 (copy), n6 (ref), v110 (ref), v111 (ref)
                local v112 = v110

                if v112 ~= nil and v111 then
                    local v113 = n6
                    local v114 = p47 - v112

                    n6 = v113 + Vector3.new(v114.X, 0, v114.Z).Magnitude * 0.15
                end

                v110 = p47

                local v115 = CFrame.new(p47) * CFrame.Angles(0, p48 + n6, 0) * v107

                clone:PivotTo(v115)

                if v111 then
                    v109.CFrame = CFrame.new((v115 * v108).Position + Vector3.new(0, 500, 0))
                end
            end

            local function glide(p49, p50, p51, p52, p53, p54, p55) -- line: 670
                -- upvalues: pose (copy), RunService (copy), TweenService (copy)
                local elapsed = os.clock()

                while true do
                    local v117 = math.min((os.clock() - elapsed) / p51, 1)
                    local Value = TweenService:GetValue(v117, p54, p55)

                    pose(p49:Lerp(p50, Value), p52 + (p53 - p52) * Value)

                    if v117 >= 1 then
                        break
                    end

                    RunService.Heartbeat:Wait()
                end
            end

            local v118 = randomSpot(t5)
            local Floor = t5.Floor
            local v119 = Floor.Position.Y + Floor.Size.Y * 0.5
            local v122 = Workspace:Raycast(Vector3.new(v118.X, v119 + 60, v118.Z), Vector3.new(0, -120, 0), t5.Ground)
            local v124 = (if v122 then v122.Position else Vector3.new(v118.X, v119, v118.Z)) + Vector3.new(0, 22, 0)
            local v125 = v124
            local v126 = v124 + Vector3.new(0, 120, 0)
            local v127 = v17:NextNumber(0, 6.283185307179586)
            local v128 = v127

            pose(v126, v127)
            clone.Parent = v81
            v109.Parent = v81

            local v129 = clone:FindFirstChildWhichIsA("Animator", true)
            local track = v129:LoadAnimation(Idle)

            track.Looped = true
            track:Play()

            local v130, Highlight, track2

            local function chase() -- line: 708
                -- upvalues: clone (copy), v109 (copy), v111 (ref), pose (copy), glide (copy), v125 (ref), v128 (ref), v129 (copy), track (copy), Highlight (ref), track2 (ref), p42 (copy), t5 (copy), n5 (ref), fling (copy), RunService (copy), TweenService (copy), Workspace (copy), RailRide (copy), Walk (copy), v8 (copy), v9 (copy), v10 (copy), clampToFloor (copy)
                v111 = false
                TweenService:Create(v109, v10, {
                    Transparency = 1
                }):Play()

                local v131 = v125
                local Floor = t5.Floor
                local v132 = Floor.Position.Y + Floor.Size.Y * 0.5
                local v135 = Workspace:Raycast(Vector3.new(v131.X, v132 + 60, v131.Z), Vector3.new(0, -120, 0), t5.Ground)
                local v136 = if v135 then v135.Position else Vector3.new(v131.X, v132, v131.Z)

                glide(v125, v136, 0.45, v128, v128, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                RailRide.Shake(2)

                local Highlight2 = Instance.new("Highlight")

                Highlight2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Highlight2.FillColor = v8
                Highlight2.OutlineColor = v8
                Highlight2.FillTransparency = 0.75
                Highlight2.Adornee = clone
                Highlight2.Parent = clone
                TweenService:Create(Highlight2, v9, {
                    FillTransparency = 0.2
                }):Play()
                Highlight = Highlight2

                local track3 = v129:LoadAnimation(Walk)

                track3.Looped = true
                track2 = track3
                track:Stop()
                track3:Play()

                local n7 = 0

                while true do
                    local v137 = RunService.Heartbeat:Wait()
                    local elapsed = os.clock()

                    if elapsed < n7 then
                        local v138 = v128

                        v128 = v138 + 6.283185307179586 * v137
                        pose(v136, v128)
                        continue
                    end

                    if not track3.IsPlaying then
                        track:Stop()
                        track3:Play()
                    end

                    local v139 = p42.Root.Position - v136
                    local v140 = Vector3.new(v139.X, 0, v139.Z)

                    if v140.Magnitude > 0.1 then
                        local v142 = math.min(30 * v137, v140.Magnitude)
                        local v143 = clampToFloor(v136 + v140.Unit * v142, t5.Floor)
                        local Floor = t5.Floor
                        local v144 = Floor.Position.Y + Floor.Size.Y * 0.5
                        local v147 = Workspace:Raycast(Vector3.new(v143.X, v144 + 60, v143.Z), Vector3.new(0, -120, 0), t5.Ground)

                        v136 = if v147 then v147.Position else Vector3.new(v143.X, v144, v143.Z)

                        local v149 = v128
                        local v152 = v149 + (math.atan2(-v140.X, -v140.Z) - v149 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                        local v153 = v128

                        v128 = v153 + (v152 - v128) * math.min(8 * v137, 1)
                    end

                    pose(v136, v128)

                    local v156 = p42.Root.Position - v136

                    if n5 <= elapsed and Vector3.new(v156.X, 0, v156.Z).Magnitude <= 6 and v156.Y <= 8 then
                        fling(v136)
                        n7 = elapsed + 3
                        track3:Stop()
                        track:Play()
                    end
                end
            end

            local v157 = v86:Add(task.spawn(function() -- line: 764
                -- upvalues: p46 (copy), glide (copy), v125 (ref), v126 (copy), v128 (ref), v130 (ref), chase (copy), p42 (copy), t5 (copy), v81 (copy), v86 (copy), t8 (copy), n5 (ref), fling (copy), chooseSpot (copy), Workspace (copy), v17 (copy), clampToArea (copy), strikeMarker (copy)
                glide(v126, v125, 1.5, v128, v128, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                if not p46 then
                    local v158

                    while true do
                        local v159, v160 = chooseSpot(v158)

                        if v160 ~= nil then
                            v158 = v160
                            t8[v160] = true
                        end

                        local v161 = v159 + Vector3.new(0, 22, 0)
                        local v162 = v161 - v125
                        local v163 = Vector3.new(v162.X, 0, v162.Z)
                        local v164

                        if v163.Magnitude > 0.1 then
                            local v165 = v128

                            v164 = v165 + (math.atan2(-v163.X, -v163.Z) - v165 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                        else
                            v164 = v128
                        end

                        local v169 = math.max(v163.Magnitude / 35, 0.2)

                        glide(v125, v161, v169, v128, v164, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        v128 = v164

                        local v170 = v86:Add((strikeMarker(v159)))

                        v170.Parent = v81
                        v130 = v170
                        task.wait(1)
                        glide(v161, v159, 0.15, v128, v128, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

                        local v171 = p42.Root.Position - v159

                        if os.clock() >= n5 and Vector3.new(v171.X, 0, v171.Z).Magnitude <= 20 and v171.Y <= 12 then
                            fling(v159)
                        end

                        glide(v159, v159, 0.5, v128, v128 + 12.566370614359172, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        v86:Remove(v170)
                        v130 = nil
                        glide(v159, v161, 0.6, v128, v128, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                        if v160 ~= nil then
                            t8[v160] = nil
                        end

                        local v172 = v17:NextNumber(1.25, 2.5)
                        local v173 = v17:NextNumber(0, 6.283185307179586)
                        local v177 = clampToArea(v159 + Vector3.new(math.cos(v173), 0, (math.sin(v173))) * 8 * v172, t5.Floor)
                        local Floor = t5.Floor
                        local v178 = Floor.Position.Y + Floor.Size.Y * 0.5
                        local v181 = Workspace:Raycast(Vector3.new(v177.X, v178 + 60, v177.Z), Vector3.new(0, -120, 0), t5.Ground)
                        local v183 = (if v181 then v181.Position else Vector3.new(v177.X, v178, v177.Z)) + Vector3.new(0, 22, 0)
                        local v184 = v183 - v161
                        local v185 = Vector3.new(v184.X, 0, v184.Z)
                        local v186

                        if v185.Magnitude > 0.1 then
                            local v187 = v128

                            v186 = v187 + (math.atan2(-v185.X, -v185.Z) - v187 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                        else
                            v186 = v128
                        end

                        glide(v161, v183, v172, v128, v186, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        v128 = v186
                        v125 = v183
                    end
                end

                chase()
            end))

            table.insert(t7, function() -- line: 819
                -- upvalues: clone (copy), v109 (copy), v110 (ref), v111 (ref), glide (copy), v125 (ref), v128 (ref), track (copy), v130 (ref), Highlight (ref), track2 (ref), v157 (copy), TweenService (copy), v11 (copy)
                task.cancel(v157)

                local v191 = v130

                if v191 ~= nil then
                    v191:Destroy()
                end

                local Highlight2 = Highlight

                if Highlight2 ~= nil then
                    Highlight2:Destroy()
                end

                local track3 = track2

                if track3 ~= nil then
                    track3:Stop()
                    track:Play()
                end

                v111 = true
                TweenService:Create(v109, v11, {
                    Transparency = 0
                }):Play()

                local v192 = v110 or v125

                glide(v192, v192 + Vector3.new(0, 300, 0), 1.5, v128, v128, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                clone:Destroy()
                v109:Destroy()
            end)
        end

        local function addSpiders() -- line: 844
            -- upvalues: v80 (copy), v84 (ref), n4 (ref), spawnSpider (copy), BeanstalkEvent (copy), LocalPlayer (copy)
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = 0
            end

            local v194 = math.floor(math.min(Attribute, v80) / 4)

            while not v84 and n4 < v194 do
                n4 += 1
                spawnSpider(n4 >= 4)
            end
        end

        local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

        if typeof(Attribute) ~= "number" then
            Attribute = 0
        end

        local v196 = math.min(Attribute, v80)
        local n8 = 0
        local v197 = v196

        BeanstalkGrowth.SetBaseGrowth(v196 / v80)

        local function refreshGrowth() -- line: 858
            -- upvalues: p40 (copy), p41 (copy), p42 (copy), v80 (copy), t6 (copy), v82 (copy), v84 (ref), t7 (copy), t8 (copy), v196 (copy), n8 (ref), v197 (ref), BeanstalkEvent (copy), BeanstalkEventFlags (copy), BeanstalkGrowth (copy), RailRide (copy), Trampoline (copy), TutorialBeam (copy), UISystem (copy), LocalPlayer (copy), Stage (copy)
            local v198 = v196 + n8
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = 0
            end

            local v199 = math.min(v198, Attribute, v80)

            if v197 < v199 then
                v197 = v199
                BeanstalkGrowth.SetBaseGrowth(v199 / v80, 1.2)
            end

            if v84 or v199 < v80 then
                return
            end

            v84 = true

            for _, v200 in t7 do
                p40:Add(task.spawn(v200))
            end

            table.clear(t7)
            table.clear(t8)

            for _, v201 in t6 do
                v201.Model:Destroy()
            end

            table.clear(t6)
            v82.Adornee = nil
            RailRide.Shake(3)
            BeanstalkGrowth.GrowTo(BeanstalkGrowth.HeightFor(Stage.Watering), BeanstalkEventFlags.GrowSeconds:Get())
            UISystem.SetTask("Bounce on the trampoline!")

            local Trampoline2 = p41.Sections.Stage1.Trampoline

            Trampoline.Show(p40, Trampoline2, p41.Sections.Stage2.SpawnLocation, p42)

            local v202 = TutorialBeam.Attach(Trampoline2)

            p40:Add(function() -- line: 889
                -- upvalues: v202 (copy), TutorialBeam (copy)
                TutorialBeam.Destroy(v202)
            end)
        end

        local function onArrived() -- line: 894
            -- upvalues: v85 (ref), n8 (ref), refreshGrowth (copy)
            if v85 then
                n8 += 1
                refreshGrowth()
            end
        end

        local function onProgress() -- line: 903
            -- upvalues: v80 (copy), v84 (ref), addSpiders (copy), refreshGrowth (copy), BeanstalkEvent (copy), UISystem (copy), LocalPlayer (copy)
            if not v84 then
                local SetProgress = UISystem.SetProgress
                local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

                if typeof(Attribute) ~= "number" then
                    Attribute = 0
                end

                SetProgress("CatchFireFlies", math.min(Attribute, v80), v80)
            end

            refreshGrowth()
            addSpiders()
        end

        local function topUp(p56) -- line: 913
            -- upvalues: p40 (copy), t5 (copy), v80 (copy), v81 (copy), t6 (copy), n2 (ref), n3 (ref), v84 (ref), BeanstalkEvent (copy), BeanstalkEventFlags (copy), LocalPlayer (copy), spawnFirefly (copy)
            if v84 or p56 - n3 < 1 or p56 - n2 < 1 then
                return
            end

            n3 = p56

            local v203 = BeanstalkEventFlags.MaxVisibleFireflies:Get()
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = 0
            end

            local v205 = math.min(v203, v80 - Attribute)

            while #t6 < v205 do
                table.insert(t6, (spawnFirefly(p40, v81, t5)))
            end
        end

        p40:Connect(LocalPlayer:GetAttributeChangedSignal(BeanstalkEvent.ProgressAttribute), onProgress)

        if not v84 then
            local SetProgress = UISystem.SetProgress
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = 0
            end

            SetProgress("CatchFireFlies", math.min(Attribute, v80), v80)
        end

        refreshGrowth()
        addSpiders()
        topUp(os.clock())
        p40:Connect(RunService.Heartbeat, function(p57) -- line: 935
            -- upvalues: p42 (copy), t5 (copy), v80 (copy), v81 (copy), t6 (copy), v82 (copy), v83 (copy), n2 (ref), v84 (ref), n5 (ref), onArrived (copy), topUp (copy), SoundService (copy), BeanstalkEvent (copy), Remotes (copy), LocalPlayer (copy), CollectFirefly (copy), stepFirefly (copy), flyIntoStalk (copy), hitFlash (copy), popup (copy), catchJuice (copy), burstAt (copy)
            if v84 then
                return
            end

            local elapsed = os.clock()
            local v207 = #t6
            local n9 = 1e999
            local v208

            for i = v207, 1, -1 do
                local v209 = t6[i]

                stepFirefly(v209, p42.Root, p42.Humanoid.WalkSpeed, t5, p57)

                local Magnitude = (v209.Position - p42.Root.Position).Magnitude

                if Magnitude <= 4 and elapsed - n2 >= 0.5 and n5 <= elapsed then
                    n2 = elapsed
                    table.remove(t6, i)

                    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.ProgressAttribute)

                    if typeof(Attribute) ~= "number" then
                        Attribute = 0
                    end

                    local v210 = Attribute + 1 >= v80

                    Remotes.BeanstalkEvent.AskCatchFirefly:FireServer()
                    catchJuice(v83, v210)
                    SoundService:PlayLocalSound(CollectFirefly)
                    burstAt(v81, v209.Position)
                    hitFlash(v209.Model)
                    popup(v81, v209.Position + Vector3.new(0, 1.2, 0), "+1 Firefly")
                    task.delay(v210 and 0.16 or 0.07, function() -- line: 960
                        -- upvalues: v209 (copy), onArrived (copy), flyIntoStalk (copy)
                        if v209.Model.Parent then
                            flyIntoStalk(v209.Model, onArrived)
                        end
                    end)
                elseif Magnitude < n9 then
                    n9 = Magnitude
                    v208 = v209
                end
            end

            v82.Adornee = if v208 then v208.Model else nil
            topUp(elapsed)
        end)
    end
}
