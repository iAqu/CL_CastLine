-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local EmitOnce = require(ReplicatedStorage.UserGenerated.VFX.EmitOnce)
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local RacePowerUps = require(ReplicatedStorage.Data.RacePowerUps)

require(ReplicatedStorage.Shared.Modules.RaceTrackPath)

local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Assets, Attributes, Tuning = RacePowerUps.Assets, RacePowerUps.Attributes, RacePowerUps.Tuning
local v1 = Color3.fromRGB(60, 215, 255)
local v2 = Color3.fromRGB(255, 255, 255)
local t1 = {
    0.05, 0.11, 0.17
}
local t2 = {
    0.1, 0.35, 0.6
}
local v3 = Color3.fromRGB(255, 190, 90)
local v4 = CFrame.new(0, -10000, 0)
local t3 = {}
local v5 = Random.new()
local t4 = {}

local function now() -- line: 53
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function characterOf(p1) -- line: 57
    if p1 == nil then
        return nil
    end

    if p1:IsA("Player") then
        return p1.Character
    end

    return if p1:IsA("Model") and p1.Parent ~= nil then p1 else nil
end

local function rootOf(p2) -- line: 67
    local v6 = if p2 == nil then nil
        elseif p2:IsA("Player") then p2.Character
        elseif p2:IsA("Model") and p2.Parent ~= nil then p2
        else nil
    local HumanoidRootPart = if v6 == nil then nil else v6:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

function t4.Folder(p3) -- line: 73
    -- upvalues: Workspace (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "RacePowerUpFX"
    Folder.Parent = Workspace
    p3:Add(Folder)

    return Folder
end

function t4.Emit(p4, p5, p6, p7) -- line: 81
    -- upvalues: EmitOnce (copy), Assets (copy)
    local v7 = Assets.Effects:FindFirstChild(p5)

    if v7 == nil then
        return
    end

    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = p6

    local clone = v7:Clone()

    clone.Parent = Part
    Part.Parent = p4

    for _, child in clone:GetChildren() do
        if child:IsA("ParticleEmitter") then
            if p7 ~= nil and p7 ~= 1 then
                local t5 = {}

                for _, v8 in child.Size.Keypoints do
                    table.insert(t5, NumberSequenceKeypoint.new(v8.Time, v8.Value * p7, v8.Envelope * p7))
                end

                child.Size = NumberSequence.new(t5)
                child.Speed = NumberRange.new(child.Speed.Min * p7, child.Speed.Max * p7)
            end

            EmitOnce(child)
        end
    end

    task.delay(3, Part.Destroy, Part)
end

function t4.Sound(p8, p9, p10) -- line: 116
    -- upvalues: Workspace (copy), Assets (copy)
    local v11 = Assets.Sounds:FindFirstChild(p8)

    if v11 == nil then
        return nil
    end

    local clone = v11:Clone()

    if p10 ~= nil then
        clone.PlaybackSpeed *= p10
    end

    if typeof(p9) == "Instance" then
        clone.Parent = p9
    elseif typeof(p9) == "Vector3" then
        local Attachment = Instance.new("Attachment")

        Attachment.WorldPosition = p9
        Attachment.Parent = Workspace.Terrain
        clone.Parent = Attachment
        clone.Ended:Once(function() -- line: 132
            -- upvalues: Attachment (copy)
            Attachment:Destroy()
        end)
        task.delay(8, Attachment.Destroy, Attachment)
    else
        clone.Parent = Workspace.CurrentCamera
    end

    if not clone.Looped then
        clone.Ended:Once(function() -- line: 140
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
        task.delay(10, clone.Destroy, clone)
    end

    clone:Play()

    return clone
end

local function trailOn(p11, p12, p13, p14, p15) -- line: 149
    -- upvalues: Assets (copy)
    local v12 = p11:Add(Instance.new("Attachment"))
    local v13 = p11:Add(Instance.new("Attachment"))

    p15 = p15 or Vector3.new(0, 0, 0)
    v12.Position = p15 + Vector3.new(0, p14 / 2, 0)
    v13.Position = p15 - Vector3.new(0, p14 / 2, 0)
    v12.Parent = p12
    v13.Parent = p12

    local v17 = p11:Add(Assets.Effects[p13]:Clone())

    v17.Attachment0 = v12
    v17.Attachment1 = v13
    v17.Parent = p12

    return v17
end

local function spinFrame(p16, p17, p18) -- line: 164
    local v18 = Vector3.new(p17.X, 0, p17.Z)
    local v19 = if v18.Magnitude > 0.001 then v18.Unit else Vector3.new(0, 0, 1)

    return CFrame.lookAt(p16, p16 + v19) * CFrame.Angles(p18, 0, 0)
end

local function cuePart(p19, p20, p21, p22) -- line: 170
    -- upvalues: v3 (copy), v4 (copy)
    local v20 = p19:Add(Instance.new("Part"))

    v20.Anchored = true
    v20.CanCollide = false
    v20.CanQuery = false
    v20.CanTouch = false
    v20.CastShadow = false
    v20.Material = Enum.Material.Neon
    v20.Color = v3
    v20.Transparency = p21
    v20.Size = p20
    v20.CFrame = v4
    v20.Parent = p22

    return v20
end

local function pathFrame(p23, p24) -- line: 186
    -- upvalues: RacePowerUps (copy)
    local v21, v22 = RacePowerUps.PathAt(p23, p24)
    local v23 = RacePowerUps.PathAt(p23, p24 + 0.02)
    local v24 = v23 - v21

    if v22 or v24.Magnitude < 0.001 then
        return nil, v22
    end

    return CFrame.lookAt(v21, v23), false
end

local function popIn(p25, p26, p27) -- line: 196
    -- upvalues: RunService (copy), TweenService (copy)
    local elapsed = os.clock()
    local Scale = p25:GetScale()

    p25:ScaleTo(Scale * (p27 or 0.2))
    task.spawn(function() -- line: 200
        -- upvalues: p25 (copy), p26 (copy), p27 (copy), elapsed (copy), Scale (copy), RunService (copy), TweenService (copy)
        while p25.Parent ~= nil do
            local v26 = math.min((os.clock() - elapsed) / p26, 1)
            local Value = TweenService:GetValue(v26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            p25:ScaleTo((math.max(Scale * ((p27 or 0.2) + (1 - (p27 or 0.2)) * Value), 0.01)))

            if v26 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end
    end)
end

local function afterimage(p28, p29, p30) -- line: 213
    -- upvalues: TweenService (copy)
    local Model = Instance.new("Model")

    Model.Name = "Ghost"

    local t6 = {}

    for _, descendant in p29:GetDescendants() do
        if descendant:IsA("MeshPart") and descendant.Transparency < 1 then
            local clone = descendant:Clone()

            clone:ClearAllChildren()
            clone.Anchored = true
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CanTouch = false
            clone.CastShadow = false
            clone.Material = Enum.Material.Neon
            clone.Color = p30
            clone.Transparency = 0.55
            clone.Parent = Model
            table.insert(t6, clone)
        end
    end

    Model.Parent = p28

    local v28 = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for _, v29 in t6 do
        TweenService:Create(v29, v28, {
            Transparency = 1,
            Size = v29.Size * 1.12
        }):Play()
    end

    task.delay(0.37, Model.Destroy, Model)
end

local function watchRacer(p31, p32, p33) -- line: 241
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), MountRace (copy), Assets (copy), Attributes (copy), v1 (copy), v2 (copy), t3 (copy), v5 (copy), t4 (copy), trailOn (copy), popIn (copy), afterimage (copy)
    local v30 = p31:Extend()
    local v31
    local v32 = nil

    local function mountOf() -- line: 246
        -- upvalues: p33 (copy), MountRace (copy)
        local v33 = p33

        if p33 ~= nil then
            if p33:IsA("Player") then
                v33 = p33.Character
            elseif not p33:IsA("Model") or p33.Parent == nil then
                v33 = nil
            end
        end

        if v33 == nil then
            return nil
        end

        local RaceSkywhale = v33:FindFirstChild("RaceSkywhale")

        if RaceSkywhale ~= nil and RaceSkywhale:IsA("Model") then
            return RaceSkywhale
        end

        local v34 = v33:FindFirstChild(MountRace.MountName)

        return if v34 ~= nil and v34:IsA("Model") then v34 else nil
    end

    local function startShield(p34, p35) -- line: 259
        -- upvalues: p32 (copy), p33 (copy), RunService (copy), TweenService (copy), Workspace (copy), Assets (copy), v1 (copy), v2 (copy), t3 (copy), v5 (copy), t4 (copy)
        local v35 = p33

        if p33 ~= nil then
            if p33:IsA("Player") then
                v35 = p33.Character
            elseif not p33:IsA("Model") or p33.Parent == nil then
                v35 = nil
            end
        end

        local HumanoidRootPart = if v35 == nil then nil else v35:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart == nil then
            return
        end

        local clone = Assets.Models.Shield:Clone()
        local PrimaryPart = clone.PrimaryPart
        local Fill = clone:FindFirstChild("Fill")
        local Panels = clone:FindFirstChild("Panels")
        local PointLight = PrimaryPart:FindFirstChildOfClass("PointLight")
        local _CFrame, Size = PrimaryPart.CFrame, PrimaryPart.Size
        local v36 = if Fill == nil then Vector3.new(0, 0, 0) else Fill.Size
        local t7 = {}
        local t8 = {}
        local t9 = {}
        local t10 = {}

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(t7, descendant)
                table.insert(t8, _CFrame:ToObjectSpace(descendant.CFrame))
                table.insert(t9, descendant.CFrame)

                if Panels ~= nil and descendant.Parent == Panels then
                    local Unit = _CFrame:PointToObjectSpace(descendant.Position).Unit

                    descendant.Transparency = 1
                    table.insert(t10, {
                        Flash = 0,
                        Alpha = 1,
                        Color = 0,
                        Part = descendant,
                        Normal = Unit,
                        Delay = 0.08 + (Unit.Y + 1) / 2 * 0.45
                    })
                end
            end
        end

        clone.Parent = p32

        local elapsed = os.clock()
        local n1 = 0
        local n2 = 0
        local v37 = HumanoidRootPart.CFrame
        local v38 = false
        local Part = Instance.new("Part")

        Part.Shape = Enum.PartType.Ball
        Part.Material = Enum.Material.Neon
        Part.Color = Color3.fromRGB(110, 225, 255)
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Transparency = 0.45
        Part.Size = Size * 0.5
        Part.CFrame = HumanoidRootPart.CFrame
        Part.Parent = p32
        TweenService:Create(Part, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = Size * 1.45
        }):Play()
        task.delay(0.45, Part.Destroy, Part)
        t4.Sound("ShieldUp", HumanoidRootPart)
        t4.Sound("ShieldRing", HumanoidRootPart)

        local function hit(p36) -- line: 332
            -- upvalues: Size (copy), t10 (copy), n2 (ref), v37 (ref), v38 (ref), p32 (copy), TweenService (copy), v2 (copy), t4 (copy)
            local v40 = if p36 == nil then Vector3.new(-0, -0, -1, -0) else v37:PointToObjectSpace(p36)
            local v41 = if v40.Magnitude > 0.001 then v40.Unit else Vector3.new(-0, -0, -1, -0)

            for _, v42 in t10 do
                local v43 = v42.Normal:Dot(v41)

                v42.Flash = math.max(v42.Flash, (math.clamp((v43 - 0.72) / 0.22, 0, 1)))
            end

            n2 = 1
            v38 = false

            local v46 = Size.X / 2
            local v48 = v37
            local v47 = v48 * CFrame.new(v41 * v46)

            t4.Emit(p32, "Shatter", v47, 0.45)

            local Part = Instance.new("Part")

            Part.Shape = Enum.PartType.Ball
            Part.Material = Enum.Material.Neon
            Part.Color = v2
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 0.05
            Part.Size = Vector3.new(0.6, 0.6, 0.6)
            Part.CFrame = v47
            Part.Parent = p32
            TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = Vector3.new(4.2, 4.2, 4.2),
                Transparency = 1
            }):Play()
            task.delay(0.4, Part.Destroy, Part)
        end

        t3[p33] = hit
        p34:Add(function() -- line: 362
            -- upvalues: hit (copy), p33 (copy), t3 (copy)
            if t3[p33] == hit then
                t3[p33] = nil
            end
        end)
        p34:Connect(RunService.RenderStepped, function(p37) -- line: 368
            -- upvalues: p35 (copy), PrimaryPart (copy), Fill (copy), PointLight (copy), Size (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), elapsed (copy), n1 (ref), n2 (ref), v37 (ref), v38 (ref), v36 (copy), p33 (copy), TweenService (copy), Workspace (copy), v1 (copy), v2 (copy)
            local v50 = p33

            if p33 ~= nil then
                if p33:IsA("Player") then
                    v50 = p33.Character
                elseif not p33:IsA("Model") or p33.Parent == nil then
                    v50 = nil
                end
            end

            local HumanoidRootPart = if v50 == nil then nil else v50:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart = nil
            end

            if HumanoidRootPart == nil then
                return
            end

            n1 += p37 * 0.6

            local v52 = os.clock() - elapsed
            local v53 = p35 - Workspace:GetServerTimeNow()
            local v55 = 0.15 + 0.85 * TweenService:GetValue(math.min(v52 / 0.38, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local v56 = HumanoidRootPart.CFrame * CFrame.new(0, -0.6, 0) * CFrame.Angles(0, n1, 0)

            v37 = v56

            for v57, v58 in t8 do
                t9[v57] = v56 * (v58.Rotation + v58.Position * v55)
            end

            Workspace:BulkMoveTo(t7, t9, Enum.BulkMoveMode.FireCFrameChanged)

            if v52 < 0.43 then
                PrimaryPart.Size = Size * v55

                if Fill ~= nil then
                    Fill.Size = v36 * v55
                end
            end

            local v59 = v53 < 1.6

            if v38 and not v59 then
                return
            end

            local v61 = math.floor(os.clock() * (if v53 < 0.7 then 18 else 9))
            local v62 = v52 < 0.75 or v59
            local v64 = n2

            n2 = math.max(v64 - p37 * 3, 0)

            for v65, v66 in t10 do
                v66.Flash = math.max(v66.Flash - p37 * 1.5, 0)
                v62 = v62 or v66.Flash > 0

                local v69 = 1 - math.clamp((v52 - v66.Delay) / 0.12, 0, 1) * 0.85

                if v59 and (v65 * 7 + v61) % 3 == 0 then
                    v69 = 0.85
                end

                local v70 = v69 * (1 - v66.Flash)
                local v72 = math.floor(v66.Flash * 20 + 0.5) / 20

                if math.abs(v70 - v66.Alpha) > 0.01 then
                    v66.Alpha = v70
                    v66.Part.Transparency = v70
                end

                if v72 ~= v66.Color then
                    v66.Color = v72
                    v66.Part.Color = v1:Lerp(v2, v72)
                end
            end

            local v74 = v59 and v61 % 2 == 0

            if Fill ~= nil then
                Fill.Transparency = if v74 then 0.97 else 0.89 - n2 * 0.25
            end

            PrimaryPart.Transparency = v74 and 0.6 or 0

            if PointLight ~= nil then
                PointLight.Brightness = n2 * 3 + 1.4
            end

            v38 = not v62 and n2 <= 0
        end)
        p34:Add(function() -- line: 432
            -- upvalues: clone (copy), PrimaryPart (copy), Fill (copy), PointLight (copy), t10 (copy), p32 (copy), p33 (copy), TweenService (copy), v2 (copy), v5 (copy), t4 (copy)
            local v76 = p33

            if p33 ~= nil then
                if p33:IsA("Player") then
                    v76 = p33.Character
                elseif not p33:IsA("Model") or p33.Parent == nil then
                    v76 = nil
                end
            end

            local HumanoidRootPart = if v76 == nil then nil else v76:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart = nil
            end

            if HumanoidRootPart ~= nil then
                t4.Emit(p32, "Shatter", HumanoidRootPart.CFrame, 0.8)
                t4.Sound("ShieldBreak", HumanoidRootPart)
            end

            if clone.Parent == nil then
                return
            end

            local PrimaryPartPosition = PrimaryPart.Position
            local v77 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            for _, v78 in t10 do
                local Part = v78.Part
                local Unit = (Part.Position - PrimaryPartPosition).Unit
                local v79 = Part.CFrame * CFrame.Angles(v5:NextNumber(-1, 1), v5:NextNumber(-1, 1), v5:NextNumber(-1, 1)) + Unit * v5:NextNumber(2.5, 4.5)

                Part.Color = v2
                Part.Transparency = 0
                TweenService:Create(Part, v77, {
                    Transparency = 1,
                    CFrame = v79
                }):Play()
            end

            TweenService:Create(PrimaryPart, v77, {
                Transparency = 1,
                Size = PrimaryPart.Size * 1.2
            }):Play()

            if Fill ~= nil then
                TweenService:Create(Fill, v77, {
                    Transparency = 1,
                    Size = Fill.Size * 1.2
                }):Play()
            end

            if PointLight ~= nil then
                TweenService:Create(PointLight, v77, {
                    Brightness = 0
                }):Play()
            end

            task.delay(0.5, clone.Destroy, clone)
        end)
    end

    local function startSerum(p38) -- line: 464
        -- upvalues: p32 (copy), p33 (copy), mountOf (copy), RunService (copy), Assets (copy), t4 (copy), trailOn (copy), afterimage (copy)
        local v80 = p33

        if p33 ~= nil then
            if p33:IsA("Player") then
                v80 = p33.Character
            elseif not p33:IsA("Model") or p33.Parent == nil then
                v80 = nil
            end
        end

        local HumanoidRootPart = if v80 == nil then nil else v80:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart == nil then
            return
        end

        t4.Sound("Gulp", HumanoidRootPart)
        t4.Sound("SerumBurst", HumanoidRootPart)
        t4.Emit(p32, "Poof", HumanoidRootPart.CFrame, 0.7)

        local v81 = p33

        if p33 ~= nil then
            if p33:IsA("Player") then
                v81 = p33.Character
            elseif not p33:IsA("Model") or p33.Parent == nil then
                v81 = nil
            end
        end

        local v82 = mountOf()
        local Hitbox = if v82 == nil then nil else v82:FindFirstChild("Hitbox")

        if Hitbox ~= nil and Hitbox:IsA("BasePart") then
            trailOn(p38, Hitbox, "SerumTrail", 2.4, (Vector3.new(2.6, 0, 2.5)))
            trailOn(p38, Hitbox, "SerumTrail", 2.4, (Vector3.new(-2.6, 0, 2.5)))

            local v83 = p38:Add(Assets.Effects.Speed:Clone())

            v83.Position = Vector3.new(0, 0, 3)
            v83:FindFirstChildOfClass("ParticleEmitter").Color = ColorSequence.new(Color3.fromRGB(170, 255, 90))
            v83.Parent = Hitbox
        end

        local n3 = 0

        p38:Connect(RunService.Heartbeat, function() -- line: 485
            -- upvalues: v81 (ref), n3 (ref), p32 (copy), mountOf (copy), afterimage (copy)
            if os.clock() - n3 < 0.09 then
                return
            end

            n3 = os.clock()

            local v84 = mountOf()

            if v84 ~= nil and v81.Parent ~= nil then
                afterimage(p32, v84, Color3.fromRGB(120, 255, 110))
            end
        end)
    end

    local function startWhale(p39) -- line: 497
        -- upvalues: p32 (copy), p33 (copy), v30 (copy), RunService (copy), TweenService (copy), t4 (copy), trailOn (copy), popIn (copy)
        local v85 = p33

        if p33 ~= nil then
            if p33:IsA("Player") then
                v85 = p33.Character
            elseif not p33:IsA("Model") or p33.Parent == nil then
                v85 = nil
            end
        end

        local HumanoidRootPart = if v85 == nil then nil else v85:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart == nil then
            return
        end

        t4.Emit(p32, "Poof", HumanoidRootPart.CFrame, 1.6)
        t4.Sound("Pop", HumanoidRootPart)
        t4.Sound("WhaleSwoosh", HumanoidRootPart)

        local v86 = t4.Sound("WhaleLoop", HumanoidRootPart)

        if v86 ~= nil then
            p39:Add(v86)
        end

        local clone
        local v87 = CFrame.identity

        task.spawn(function() -- line: 511
            -- upvalues: p39 (copy), clone (ref), v87 (ref), p33 (copy), trailOn (copy), popIn (copy)
            local v88 = p33

            if p33 ~= nil then
                if p33:IsA("Player") then
                    v88 = p33.Character
                elseif not p33:IsA("Model") or p33.Parent == nil then
                    v88 = nil
                end
            end

            local v89 = if v88 == nil then nil else v88:WaitForChild("RaceSkywhale", 2)

            if v89 == nil or p39.Destroy == nil then
                return
            end

            local v90 = p33

            if p33 ~= nil then
                if p33:IsA("Player") then
                    v90 = p33.Character
                elseif not p33:IsA("Model") or p33.Parent == nil then
                    v90 = nil
                end
            end

            local HumanoidRootPart = if v90 == nil then nil else v90:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart = nil
            end

            if HumanoidRootPart ~= nil then
                v87 = HumanoidRootPart.CFrame:ToObjectSpace(v89:GetPivot())
            end

            local clone2 = v89:Clone()

            if clone2 ~= nil then
                for _, descendant in clone2:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true
                        descendant.CanCollide = false
                        descendant.CanQuery = false
                        descendant.CanTouch = false
                        descendant.CastShadow = false
                    elseif descendant:IsA("JointInstance") or descendant:IsA("Constraint") or descendant:IsA("Trail") or descendant:IsA("Sound") or descendant:IsA("ParticleEmitter") then
                        descendant:Destroy()
                    end
                end

                if p39.Destroy ~= nil then
                    clone = clone2

                    local HumanoidRootPart = v89:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                        trailOn(p39, HumanoidRootPart, "WhaleTrail", 2.6, (Vector3.new(0, 4.2, 14.5)))
                        trailOn(p39, HumanoidRootPart, "WhaleTrail", 1, (Vector3.new(6.2, 2.4, 3)))
                        trailOn(p39, HumanoidRootPart, "WhaleTrail", 1, (Vector3.new(-6.2, 2.4, 3)))
                        popIn(v89, 0.35, 0.3)
                    end
                else
                    clone2:Destroy()
                end
            end
        end)
        p39:Add(function() -- line: 555
            -- upvalues: clone (ref), v87 (ref), p32 (copy), p33 (copy), v30 (copy), RunService (copy), TweenService (copy), t4 (copy)
            local v91 = p33

            if p33 ~= nil then
                if p33:IsA("Player") then
                    v91 = p33.Character
                elseif not p33:IsA("Model") or p33.Parent == nil then
                    v91 = nil
                end
            end

            local HumanoidRootPart = if v91 == nil then nil else v91:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart = nil
            end

            if HumanoidRootPart == nil then
                return
            end

            t4.Emit(p32, "Poof", HumanoidRootPart.CFrame, 1.1)
            t4.Sound("Pop", HumanoidRootPart, 0.85)

            local clone2 = clone

            clone = nil

            if clone2 == nil then
                return
            end

            local Scale = clone2:GetScale()
            local t12 = {}

            for _, descendant in clone2:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Transparency < 1 then
                    table.insert(t12, descendant)
                end
            end

            local Extend = v30.Extend
            local ok, result = pcall(Extend, v30)

            if not ok or p32.Parent == nil then
                clone2:Destroy()
            else
                clone2:PivotTo(HumanoidRootPart.CFrame * v87)
                clone2.Parent = p32
                result:Add(clone2)

                local elapsed = os.clock()

                result:Connect(RunService.RenderStepped, function() -- line: 583
                    -- upvalues: clone2 (copy), Scale (copy), t12 (copy), elapsed (copy), v87 (ref), p33 (copy), TweenService (copy)
                    local Value = TweenService:GetValue(math.min((os.clock() - elapsed) / 0.34, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    local v94 = p33

                    if p33 ~= nil then
                        if p33:IsA("Player") then
                            v94 = p33.Character
                        elseif not p33:IsA("Model") or p33.Parent == nil then
                            v94 = nil
                        end
                    end

                    local HumanoidRootPart = if v94 == nil then nil else v94:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                        HumanoidRootPart = nil
                    end

                    clone2:ScaleTo((math.max(Scale * (1 - 0.8 * Value), 0.01)))

                    if HumanoidRootPart ~= nil then
                        clone2:PivotTo(HumanoidRootPart.CFrame * v87 * CFrame.new(0, 3 * Value, 0))
                    end

                    for _, v96 in t12 do
                        v96.Transparency = Value
                    end
                end)
                task.delay(0.34, result.Destroy, result)
            end
        end)
    end

    local function refreshEffect() -- line: 599
        -- upvalues: p33 (copy), v30 (copy), v31 (ref), startShield (copy), startSerum (copy), startWhale (copy), Workspace (copy), Attributes (copy)
        if v31 ~= nil then
            v31:Destroy()
            v31 = nil
        end

        local Attribute = p33:GetAttribute(Attributes.Effect)
        local Attribute2 = p33:GetAttribute(Attributes.EffectEndsAt)

        if type(Attribute) == "string" and type(Attribute2) == "number" and not (Attribute2 <= Workspace:GetServerTimeNow()) then
            local v97 = v30:Extend()

            v31 = v97

            if Attribute == "Shield" then
                startShield(v97, Attribute2)
            elseif Attribute == "Serum" then
                startSerum(v97)
            elseif Attribute == "Skywhale" then
                startWhale(v97)
            end
        end
    end

    local function refreshStun() -- line: 620
        -- upvalues: p33 (copy), v30 (copy), v32 (ref), Workspace (copy), Assets (copy), Attributes (copy), t4 (copy)
        if v32 ~= nil then
            v32:Destroy()
            v32 = nil
        end

        local Attribute = p33:GetAttribute(Attributes.StunEndsAt)
        local v98

        if type(Attribute) ~= "number" or Attribute <= Workspace:GetServerTimeNow() then
            return
        else
            v98 = p33

            if p33 ~= nil then
                if p33:IsA("Player") then
                    v98 = p33.Character
                elseif not p33:IsA("Model") or p33.Parent == nil then
                    v98 = nil
                end
            end
        end

        local Head = if v98 == nil then nil else v98:FindFirstChild("Head")
        local v100, v101

        if Head ~= nil then
            if Head:IsA("BasePart") then
                v100 = v30:Extend()
                v32 = v100

                local v102 = v100:Add(Assets.Effects.Dizzy:Clone())

                v102.Position = Vector3.new(0, 1.6, 0)
                v102.Parent = Head

                local v103 = t4.Sound("Dizzy", Head)

                if v103 ~= nil then
                    v100:Add(v103)
                end

                v101 = false
            else
                v101 = true
            end
        else
            v101 = true
        end

        if v101 then
            return
        end

        task.delay(Attribute - Workspace:GetServerTimeNow(), function() -- line: 643
            -- upvalues: v100 (ref), v32 (ref)
            if v32 == v100 then
                v100:Destroy()
                v32 = nil
            end
        end)
    end

    v30:Connect(p33:GetAttributeChangedSignal(Attributes.Effect), refreshEffect)
    v30:Connect(p33:GetAttributeChangedSignal(Attributes.StunEndsAt), refreshStun)
    refreshEffect()
    refreshStun()

    return v30
end

function t4.Run(p40, p41, p42) -- line: 658
    -- upvalues: Players (copy), RunService (copy), TweenService (copy), Workspace (copy), MountRaceFlags (copy), MountRace (copy), RacePowerUps (copy), Remotes (copy), LocalPlayer (copy), Assets (copy), Tuning (copy), t1 (copy), t2 (copy), v3 (copy), v4 (copy), t3 (copy), t4 (copy), trailOn (copy), popIn (copy), watchRacer (copy)
    local v104 = t4.Folder(p40)
    local v105 = RacePowerUps.Params(p41)
    local t13 = {}
    local t14 = {}
    local v106 = MountRace.HeatOf(Players.LocalPlayer)

    local function syncRacers() -- line: 665
        -- upvalues: p40 (copy), p41 (copy), v104 (copy), t14 (copy), v106 (copy), Players (copy), Workspace (copy), MountRace (copy), watchRacer (copy)
        local t15 = {}

        for _, player in Players:GetPlayers() do
            if player:GetAttribute(MountRace.PlayerAttributes.RaceId) == p41.Name and MountRace.HeatOf(player) == v106 then
                t15[player] = true
            end
        end

        local RaceBots = Workspace:FindFirstChild("RaceBots")

        if RaceBots ~= nil then
            for _, child in RaceBots:GetChildren() do
                if child:GetAttribute(MountRace.PlayerAttributes.RaceId) == p41.Name and MountRace.HeatOf(child) == v106 then
                    t15[child] = true
                end
            end
        end

        for v107 in t15 do
            if t14[v107] == nil then
                t14[v107] = watchRacer(p40, v104, v107)
            end
        end

        for v108, v109 in t14 do
            if not t15[v108] then
                v109:Destroy()
                t14[v108] = nil
            end
        end
    end

    local n4 = 0

    p40:Connect(RunService.Heartbeat, function() -- line: 699
        -- upvalues: syncRacers (copy), n4 (ref)
        if os.clock() - n4 > 0.5 then
            n4 = os.clock()
            syncRacers()
        end
    end)
    syncRacers()

    local function shot(p43, p44, p45, p46) -- line: 707
        -- upvalues: p40 (copy), v104 (copy), t13 (copy)
        local v110 = p40:Extend()

        if p45 ~= nil then
            v110:Add(p45)

            if p46 ~= nil then
                p45:PivotTo(p46)
            end

            p45.Parent = v104
        end

        local t16 = {
            Kind = p44,
            Model = p45,
            Trove = v110,
            Data = {}
        }

        t13[p43] = t16

        return t16
    end

    local function drop(p47) -- line: 721
        -- upvalues: t13 (copy)
        local v111 = t13[p47]

        if v111 ~= nil then
            t13[p47] = nil
            v111.Trove:Destroy()
        end

        return v111
    end

    local function onSpike(p48, _, p50, p51, p52) -- line: 730
        -- upvalues: v104 (copy), v105 (copy), shot (copy), RunService (copy), Workspace (copy), MountRaceFlags (copy), RacePowerUps (copy), Assets (copy), Tuning (copy), t1 (copy), t2 (copy), v3 (copy), v4 (copy), t4 (copy), trailOn (copy), popIn (copy)
        local v112 = RacePowerUps.SpikePath(p50, p51, MountRaceFlags.TopSpeed:Get() * Tuning.SpikeSpeed, v105)
        local clone = Assets.Models.Spike:Clone()

        clone:ScaleTo(clone:GetScale() * Tuning.SpikeScale)

        local v113 = shot(p48, "Spike", clone, CFrame.new(p50))
        local SpikeScale = Tuning.SpikeScale
        local v114 = v113.Trove:Add(Instance.new("Part"))

        v114.Anchored = true
        v114.CanCollide = false
        v114.CanQuery = false
        v114.CanTouch = false
        v114.CastShadow = false
        v114.Material = Enum.Material.Neon
        v114.Color = v3
        v114.Transparency = 1
        v114.Size = Vector3.new(0.2, 0.2, 0.2)
        v114.CFrame = v4
        v114.Parent = v104
        v114.CFrame = CFrame.new(p50)
        trailOn(v113.Trove, v114, "SpikeTrail", 3.4)

        local t17 = {}
        local t18 = {}

        for _, v115 in t2 do
            for i = -1, 1, 2 do
                local Trove = v113.Trove
                local v116 = Vector3.new(0.55, 0.12, 3.2) * SpikeScale
                local v117 = Trove:Add(Instance.new("Part"))

                v117.Anchored = true
                v117.CanCollide = false
                v117.CanQuery = false
                v117.CanTouch = false
                v117.CastShadow = false
                v117.Material = Enum.Material.Neon
                v117.Color = v3
                v117.Transparency = v115
                v117.Size = v116
                v117.CFrame = v4
                v117.Parent = v104
                table.insert(t17, v117)
                table.insert(t18, CFrame.new(i * 0.92 * SpikeScale, -1.55, -0.29 * SpikeScale) * CFrame.Angles(0, i * 0.6108652381980153, 0))
            end
        end

        popIn(clone, 0.18, 0.35)
        t4.Sound("Throw", p50)

        local n5 = 0
        local v119 = table.clone(t17)

        table.insert(v119, v114)

        local v120 = table.create(#v119, v4)

        v113.Trove:Connect(RunService.RenderStepped, function(p53) -- line: 757
            -- upvalues: p52 (copy), v112 (copy), clone (copy), t17 (copy), t18 (copy), n5 (ref), v119 (copy), v120 (copy), Workspace (copy), RacePowerUps (copy), t1 (copy), t2 (copy), v4 (copy)
            local v121 = Workspace:GetServerTimeNow() - p52
            local v122 = RacePowerUps.PathAt(v112, v121)
            local v123 = RacePowerUps.PathAt(v112, v121 + 0.05)

            n5 -= p53 * 18

            local v127 = v122 + Vector3.new(0, 1, 0) * (math.abs((math.sin(v121 * 14))) * 0.8)
            local v128 = v123 - v122
            local v129 = n5
            local v130 = Vector3.new(v128.X, 0, v128.Z)
            local v131 = if v130.Magnitude > 0.001 then v130.Unit else Vector3.new(0, 0, 1)

            clone:PivotTo(CFrame.lookAt(v127, v127 + v131) * CFrame.Angles(v129, 0, 0))

            local v133 = math.sin(v121 * 24) * 0.5 + 0.5

            for v134, v135 in t1 do
                local v136 = v121 + v135
                local v137, v138 = RacePowerUps.PathAt(v112, v136)
                local v139 = RacePowerUps.PathAt(v112, v136 + 0.02)
                local v140 = v139 - v137
                local v141 = if v138 or v140.Magnitude < 0.001 then nil else CFrame.lookAt(v137, v139)

                for i = 1, 2 do
                    local v142 = (v134 - 1) * 2 + i

                    v120[v142] = if v141 == nil then v4 else v141 * t18[v142]
                    t17[v142].Transparency = t2[v134] + v133 * 0.12
                end
            end

            local v144, v145 = RacePowerUps.PathAt(v112, v121)
            local v146 = RacePowerUps.PathAt(v112, v121 + 0.02)
            local v147 = v146 - v144
            local v148 = if v145 or v147.Magnitude < 0.001 then nil else CFrame.lookAt(v144, v146)
            local v149 = #v120

            if v148 == nil then
                v148 = CFrame.new(v122)
            end

            v120[v149] = v148
            Workspace:BulkMoveTo(v119, v120, Enum.BulkMoveMode.FireCFrameChanged)
        end)
    end

    local function onSpikeEnd(p54, p55, p56) -- line: 779
        -- upvalues: v104 (copy), t13 (copy), t4 (copy)
        local v150 = t13[p54]

        if v150 ~= nil then
            t13[p54] = nil
            v150.Trove:Destroy()
        end

        local v151

        if p56 then
            v151 = p56
        else
            local Model = if v150 then v150.Model else nil

            if v150 and Model then
                v151 = v150.Model:GetPivot().Position
            end
        end

        if v151 ~= nil then
            if p55 ~= nil then
                t4.Emit(v104, "Stars", CFrame.new(v151), 1.2)
                t4.Emit(v104, "Poof", CFrame.new(v151), 0.7)
                t4.Sound("PuffHit", v151)
                t4.Sound("Pop", v151, 1.3)
            else
                t4.Emit(v104, "Poof", CFrame.new(v151), 0.6)
                t4.Sound("Pop", v151, 1.5)
            end
        end
    end

    local function onPod(p57, _, p59, p60, p61) -- line: 796
        -- upvalues: p42 (copy), shot (copy), RunService (copy), Workspace (copy), MountRaceFlags (copy), Assets (copy), Tuning (copy), t4 (copy), trailOn (copy), popIn (copy)
        local clone = Assets.Models.Pod:Clone()
        local v152 = shot(p57, "Pod", clone, CFrame.new(p59))
        local PrimaryPart = clone.PrimaryPart

        trailOn(v152.Trove, PrimaryPart, "PodTrail", 2.2, (Vector3.new(0, 1.6, -2.8)))
        popIn(clone, 0.25, 0.3)
        t4.Sound("PodLaunch", p59)

        local v153 = t4.Sound("PodLoop", PrimaryPart)

        if v153 ~= nil then
            v152.Trove:Add(v153)
        end

        local Data = v152.Data

        Data.Position = p59
        Data.Progress = p60

        local v154 = MountRaceFlags.TopSpeed:Get() * Tuning.PodSpeed
        local n6 = 0

        v152.Trove:Connect(RunService.RenderStepped, function(p62) -- line: 812
            -- upvalues: p61 (copy), clone (copy), Data (copy), v154 (copy), n6 (ref), p42 (copy), Workspace (copy), Tuning (copy)
            local DataPosition, Target = Data.Position, Data.Target
            local v155

            if Target ~= nil then
                local v159 = if Target:IsA("Player") then Target.Character elseif Target:IsA("Model") and Target.Parent ~= nil then Target else nil
                local HumanoidRootPart = if v159 == nil then nil else v159:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                    HumanoidRootPart = nil
                end

                if HumanoidRootPart == nil then
                    return
                end

                v155 = HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)

                local v160 = v155 - DataPosition
                local v161 = v154 * 1.15 * p62

                if not (v160.Magnitude <= v161) then
                    v155 = DataPosition + v160.Unit * v161
                end
            else
                Data.Progress += v154 * p62

                local v156 = p42:FrameAt(Data.Progress)
                local v158 = math.clamp((Workspace:GetServerTimeNow() - p61) / 0.5, 0, 1)

                v155 = DataPosition:Lerp(v156.Position + v156.UpVector * Tuning.PodHeight, (math.max(v158, 0.25)))
            end

            n6 += p62

            local v162 = v155 - DataPosition

            Data.Position = v155

            if not (v162.Magnitude > 0.001) then
                return
            end

            clone:PivotTo(CFrame.lookAt(v155, v155 + v162) * CFrame.new(0, math.sin(n6 * 9) * 0.35, 0) * CFrame.Angles(0, 3.141592653589793, math.sin(n6 * 5) * 0.2))
        end)
    end

    local function onPodLock(p63, p64, p65) -- line: 845
        -- upvalues: v104 (copy), t13 (copy), RunService (copy), TweenService (copy), Assets (copy), t4 (copy)
        local v167 = t13[p63]

        if v167 == nil or p64 == nil then
            return
        end

        v167.Data.Target = p64
        v167.Data.Position = p65:Lerp(v167.Data.Position, 0.5)

        local v168 = if p64 == nil then nil
            elseif p64:IsA("Player") then p64.Character
            elseif p64:IsA("Model") and p64.Parent ~= nil then p64
            else nil
        local HumanoidRootPart = if v168 == nil then nil else v168:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart == nil then
            return
        end

        local v169 = v167.Trove:Add(Assets.Effects.Reticle:Clone())

        v169.Adornee = HumanoidRootPart
        v169.Parent = v104

        local Ring = v169:FindFirstChild("Ring")

        Ring.Size = UDim2.fromScale(2.4, 2.4)
        TweenService:Create(Ring, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 1)
        }):Play()
        v167.Trove:Connect(RunService.RenderStepped, function() -- line: 864
            -- upvalues: Ring (copy)
            Ring.Rotation = os.clock() * 220 % 360
        end)
        t4.Sound("PodLock", HumanoidRootPart)
    end

    local function onPodEnd(p66, p67, p68) -- line: 871
        -- upvalues: v104 (copy), t13 (copy), t4 (copy)
        local v170 = t13[p66]

        if v170 ~= nil then
            t13[p66] = nil
            v170.Trove:Destroy()
        end

        local v171 = p68 or (if v170 then v170.Data.Position else nil)

        if v171 == nil then
            return
        end

        t4.Emit(v104, "Boom", CFrame.new(v171), 1)
        t4.Sound("Explode", v171)

        if p67 ~= nil then
            t4.Emit(v104, "Stars", CFrame.new(v171), 1.3)
            t4.Sound("Laugh", v171)
        end
    end

    local function onDrilla(p69, p70, p71, _, _) -- line: 885
        -- upvalues: p42 (copy), v104 (copy), shot (copy), RunService (copy), Workspace (copy), MountRaceFlags (copy), Assets (copy), Tuning (copy), t4 (copy)
        local clone = Assets.Models.Drilla:Clone()
        local v172 = shot(p69, "Drilla", clone, p42:FrameAt(p71) * CFrame.new(0, -12, 0))
        local v173 = v172.Trove:Add(Instance.new("Part"))

        v173.Anchored = true
        v173.CanCollide = false
        v173.CanQuery = false
        v173.CanTouch = false
        v173.Transparency = 1
        v173.Size = Vector3.new(1, 1, 1)

        local clone2 = Assets.Effects.Rumble:Clone()

        clone2.Parent = v173

        for _, child in clone2:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child.Enabled = true
            end
        end

        v173.Parent = v104

        local v174 = t4.Sound("DrillaLoop", v173)

        if v174 ~= nil then
            v172.Trove:Add(v174)
        end

        local Sound = t4.Sound
        local v175 = if p70 == nil then nil
            elseif p70:IsA("Player") then p70.Character
            elseif p70:IsA("Model") and p70.Parent ~= nil then p70
            else nil
        local HumanoidRootPart = if v175 == nil then nil else v175:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        Sound("Roar", HumanoidRootPart, 1.2)

        local Data = v172.Data

        Data.Progress = p71

        local v176 = MountRaceFlags.TopSpeed:Get() * Tuning.DrillaSpeed
        local n7 = 0

        v172.Trove:Connect(RunService.RenderStepped, function(p74) -- line: 912
            -- upvalues: clone (copy), v173 (copy), Data (copy), v176 (copy), n7 (ref), p42 (copy), Workspace (copy)
            n7 += p74 * 20

            local v178

            if Data.Spot ~= nil then
                v178 = CFrame.new(Data.Spot) * p42:FrameAt(Data.Progress).Rotation
            else
                Data.Progress += v176 * p74
                v178 = p42:FrameAt(Data.Progress)
            end

            v173.CFrame = v178
            clone:PivotTo(v178 * CFrame.new(0, -3.6, 0) * CFrame.Angles(-1.2217304763960306, 0, 0) * CFrame.Angles(0, n7, 0))

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - v178.Position).Magnitude < 50 then
                Data.Near = true
            end
        end)
    end

    local function onDrillaWarn(p75, _, p77, p78) -- line: 932
        -- upvalues: v104 (copy), v105 (copy), t13 (copy), RunService (copy), TweenService (copy), Workspace (copy), Assets (copy), t4 (copy)
        local v179 = t13[p75]

        if v179 == nil then
            return
        end

        v179.Data.Spot = p77

        local v180 = v179.Trove:Add(Assets.Models.Warning:Clone())
        local v181 = Workspace:Raycast(p77 + Vector3.new(0, 3, 0), Vector3.new(-0, -10, -0, -0), v105)
        local v182 = if v181 == nil then Vector3.new(0, 1, 0) else v181.Normal

        v180:PivotTo((CFrame.fromMatrix(p77 + v182 * 0.15, v182, v182:Cross((Vector3.new(1, 0, 0))).Magnitude > 0.1 and v182:Cross((Vector3.new(1, 0, 0))).Unit or Vector3.new(0, 0, 1))))
        v180.Parent = v104

        local Disc = v180:FindFirstChild("Disc")
        local Edge = v180:FindFirstChild("Edge")
        local elapsed = os.clock()
        local v184 = math.max(p78 - Workspace:GetServerTimeNow(), 0.2)

        v179.Trove:Connect(RunService.RenderStepped, function() -- line: 952
            -- upvalues: Disc (copy), Edge (copy), elapsed (copy), v184 (copy), TweenService (copy)
            local v186 = math.clamp((os.clock() - elapsed) / v184, 0, 1)
            local v188 = 0.35 + 0.65 * TweenService:GetValue(math.min(v186 * 2.2, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            Disc.Size = Vector3.new(0.2, 18 * v188, 18 * v188)
            Edge.Size = Vector3.new(0.25, 18.6 * v188, 18.6 * v188)

            local v194 = math.floor(os.clock() * (v186 * 14 + 6)) % 2 == 0

            Disc.Transparency = v194 and 0.35 or 0.7
            Edge.Transparency = v194 and 0 or 0.5
        end)
        t4.Sound("DrillaWarn", p77)
        task.delay(v184 * 0.5, function() -- line: 964
            -- upvalues: p75 (copy), p77 (copy), v179 (copy), t13 (copy), t4 (copy)
            if t13[p75] == v179 then
                t4.Sound("DrillaWarn", p77, 1.2)
            end
        end)
    end

    local function onDrillaEnd(p79, p80, p81) -- line: 971
        -- upvalues: p40 (copy), v104 (copy), t13 (copy), RunService (copy), Assets (copy), t4 (copy)
        local v195 = t13[p79]

        if v195 ~= nil then
            t13[p79] = nil
            v195.Trove:Destroy()
        end

        if p81 == nil then
            return
        end

        t4.Emit(v104, "Dirt", CFrame.new(p81), 1.1)
        t4.Sound("DrillaBurst", p81)
        t4.Sound("Roar", p81)

        if p80 ~= nil then
            t4.Emit(v104, "Stars", CFrame.new(p81 + Vector3.new(0, 4, 0)), 1.3)
        end

        local clone = Assets.Models.Drilla:Clone()

        clone.Parent = v104

        local elapsed = os.clock()
        local n8 = 0
        local connection

        connection = RunService.RenderStepped:Connect(function(p82) -- line: 987
            -- upvalues: p81 (copy), clone (copy), elapsed (copy), n8 (ref), connection (ref), v104 (copy), t4 (copy)
            local v196 = os.clock() - elapsed

            n8 += p82 * 26

            local v198 = 26 * v196 - 48 * v196 * v196

            clone:PivotTo(CFrame.new(p81 + Vector3.new(0, 1, 0) * (v198 - 2)) * CFrame.Angles(-1.3962634015954636 + v196 * 2, 0, 0) * CFrame.Angles(0, n8, 0))

            if not (v196 > 0.62) then
                return
            end

            connection:Disconnect()
            t4.Emit(v104, "Dirt", CFrame.new(p81), 0.6)
            clone:Destroy()
        end)
        p40:Add(connection)
        p40:Add(clone)
    end

    local function onEgg(p83, p84, p85, _) -- line: 1006
        -- upvalues: p40 (copy), v104 (copy), t13 (copy), RunService (copy), Assets (copy), t4 (copy), popIn (copy)
        local clone = Assets.Models.Splat:Clone()
        local t19 = {
            Kind = "Egg",
            Model = nil,
            Trove = p40:Extend(),
            Data = {}
        }

        t13[p83] = t19
        t19.Data.Frame = p85

        local v199 = if p84 == nil then nil
            elseif p84:IsA("Player") then p84.Character
            elseif p84:IsA("Model") and p84.Parent ~= nil then p84
            else nil
        local HumanoidRootPart = if v199 == nil then nil else v199:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        local v200 = if HumanoidRootPart == nil then p85.Position + Vector3.new(0, 6, 0) else HumanoidRootPart.Position + Vector3.new(0, 2, 0)
        local v201 = t19.Trove:Add(Assets.Models.Egg:Clone())

        v201:PivotTo(CFrame.new(v200))
        v201.Parent = v104
        t4.Sound("EggDrop", v200)

        local elapsed = os.clock()
        local v202 = false

        t19.Trove:Connect(RunService.RenderStepped, function() -- line: 1018
            -- upvalues: p85 (copy), clone (copy), t19 (copy), v201 (copy), v200 (copy), elapsed (copy), v202 (ref), v104 (copy), t4 (copy), popIn (copy)
            local v204 = math.min((os.clock() - elapsed) / 0.32, 1)

            if v202 then
                local Yolk = clone:FindFirstChild("Yolk")

                if Yolk ~= nil then
                    local v206 = math.sin(os.clock() * 5 + p85.Position.X) * 0.08

                    Yolk.Size = Vector3.new((v206 + 1) * 3.6, (1 - v206) * 1.1, (v206 + 1) * 3.6) * clone:GetScale()
                end
            else
                local v212 = v200:Lerp(p85.Position, v204) + Vector3.new(0, 1, 0) * math.sin(v204 * 3.141592653589793) * 5

                v201:PivotTo(CFrame.new(v212) * CFrame.Angles(v204 * 7, v204 * 3, 0))

                if v204 >= 1 then
                    v202 = true
                    v201:Destroy()
                    clone:PivotTo(p85)
                    clone.Parent = v104
                    t19.Trove:Add(clone)
                    t19.Model = clone
                    popIn(clone, 0.4, 0.2)
                    t4.Emit(v104, "Splash", p85, 0.9)
                    t4.Sound("Crack", p85.Position)
                    t4.Sound("Splat", p85.Position)
                end
            end
        end)
    end

    local function onEggEnd(p87, p88, p89) -- line: 1046
        -- upvalues: v104 (copy), t13 (copy), t4 (copy)
        local v213 = t13[p87]

        if v213 ~= nil then
            t13[p87] = nil
            v213.Trove:Destroy()
        end

        local v214 = p89 or (if v213 then v213.Data.Frame.Position else nil)

        if v214 ~= nil then
            if p88 ~= nil then
                t4.Emit(v104, "Splash", CFrame.new(v214), 1.3)
                t4.Sound("Splat", v214, 0.9)
                t4.Sound("Slip", v214)
            else
                t4.Emit(v104, "Poof", CFrame.new(v214), 0.5)
            end
        end
    end

    local function onBox(p90, p91) -- line: 1061
        -- upvalues: v104 (copy), LocalPlayer (copy), t4 (copy)
        if p90 ~= LocalPlayer then
            local Pad = p91:FindFirstChild("Pad")

            if Pad ~= nil and Pad:IsA("BasePart") then
                t4.Emit(v104, "Shatter", Pad.CFrame, 0.7)
                t4.Sound("Pickup", Pad.Position)
            end
        end
    end

    local function onBlocked(p92, _, p94, p95) -- line: 1072
        -- upvalues: v104 (copy), t3 (copy), t4 (copy)
        local v215 = if p92 == nil then nil
            elseif p92:IsA("Player") then p92.Character
            elseif p92:IsA("Model") and p92.Parent ~= nil then p92
            else nil
        local HumanoidRootPart = if v215 == nil then nil else v215:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart == nil then
            return
        end

        local v216 = t3[p92]

        if p94 ~= "Shield" or v216 == nil then
            t4.Emit(v104, "Shatter", HumanoidRootPart.CFrame, 0.6)
        else
            local v217 = if typeof(p95) == "Vector3" then p95 else nil

            v216(v217)
        end

        t4.Sound("ShieldBlock", HumanoidRootPart)
    end

    local function onHit(p96, p97, _, _) -- line: 1086
        -- upvalues: v104 (copy), t4 (copy)
        local v219 = if p96 == nil then nil
            elseif p96:IsA("Player") then p96.Character
            elseif p96:IsA("Model") and p96.Parent ~= nil then p96
            else nil
        local HumanoidRootPart = if v219 == nil then nil else v219:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart ~= nil then
            t4.Emit(v104, "Stars", HumanoidRootPart.CFrame * CFrame.new(0, 2.5, 0), 1)

            if p97 == "Spike" then
                t4.Sound("PuffHit", HumanoidRootPart)
            end
        end
    end

    local function onUse(p100, p101) -- line: 1097
        -- upvalues: v104 (copy), t4 (copy)
        local v220 = if p100 == nil then nil
            elseif p100:IsA("Player") then p100.Character
            elseif p100:IsA("Model") and p100.Parent ~= nil then p100
            else nil
        local HumanoidRootPart = if v220 == nil then nil else v220:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart ~= nil and p101 == "Pod" then
            t4.Emit(v104, "Poof", HumanoidRootPart.CFrame * CFrame.new(0, 3, 0), 0.6)
        end
    end

    p40:Connect(Remotes.MountRace.PowerUpMoment.OnClientEvent, function(p102, ...) -- line: 1107
        -- upvalues: v104 (copy), t13 (copy), onSpike (copy), onSpikeEnd (copy), onPod (copy), onPodLock (copy), onPodEnd (copy), onDrilla (copy), onDrillaWarn (copy), onDrillaEnd (copy), onEgg (copy), onEggEnd (copy), onBox (copy), onBlocked (copy), onHit (copy), t4 (copy)
        if p102 == "Spike" then
            onSpike(...)
        elseif p102 == "SpikeEnd" then
            onSpikeEnd(...)
        elseif p102 == "Pod" then
            onPod(...)
        elseif p102 == "PodLock" then
            onPodLock(...)
        elseif p102 == "PodEnd" then
            onPodEnd(...)
        elseif p102 == "Drilla" then
            onDrilla(...)
        elseif p102 == "DrillaWarn" then
            onDrillaWarn(...)
        elseif p102 == "DrillaEnd" then
            onDrillaEnd(...)
        elseif p102 == "Egg" then
            onEgg(...)
        elseif p102 == "EggEnd" then
            onEggEnd(...)
        elseif p102 == "Box" then
            onBox(...)
        elseif p102 == "Blocked" then
            onBlocked(...)
        elseif p102 == "Hit" then
            onHit(...)
        elseif p102 == "Use" then
            local v221, v222 = ...

            if v221 ~= nil then
                if v221:IsA("Player") then
                    v221 = v221.Character
                elseif not v221:IsA("Model") or v221.Parent == nil then
                    v221 = nil
                end
            end

            local HumanoidRootPart = if v221 == nil then nil else v221:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart = nil
            end

            if HumanoidRootPart == nil then
                return
            end

            if v222 == "Pod" then
                t4.Emit(v104, "Poof", HumanoidRootPart.CFrame * CFrame.new(0, 3, 0), 0.6)
            end
        elseif p102 == "Clear" then
            local v223 = ...
            local v224 = t13[v223]

            if v224 ~= nil then
                t13[v223] = nil
                v224.Trove:Destroy()
            end
        elseif p102 == "BotSwap" then
            local v225 = ...

            if typeof(v225) ~= "Vector3" then
                return
            end

            t4.Emit(v104, "Poof", CFrame.new(v225), 1.6)
        end
    end)

    return v104
end

return t4
