-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local t1 = {
    "PumpkinBoss",
    "ScrambleBoss"
}
local t2 = {
    Hit = "BatHit",
    Explosion = "Boom",
    CannonFire = "Boom",
    Slam = "HeavyLand",
    Swipe = "Swoosh",
    Land = "HeavyLand",
    Spin = "Swoosh"
}
local v1 = CameraShaker.new()
local v2
local t3 = {}

CameraShakerDriver.Start(v1, Enum.RenderPriority.Last.Value)

local t4 = {
    Orange = Color3.fromRGB(255, 140, 30),
    Red = Color3.fromRGB(255, 50, 50),
    Green = Color3.fromRGB(110, 230, 60),
    Purple = Color3.fromRGB(150, 60, 255),
    StyleColors = table.freeze({
        Default = Color3.fromRGB(255, 50, 50),
        Brute = Color3.fromRGB(255, 50, 50),
        Charge = Color3.fromRGB(255, 50, 50),
        King = Color3.fromRGB(90, 255, 80),
        Goo = Color3.fromRGB(140, 200, 40),
        Fire = Color3.fromRGB(255, 120, 20),
        Bomb = Color3.fromRGB(255, 90, 20),
        Shadow = Color3.fromRGB(255, 50, 50),
        Energy = Color3.fromRGB(190, 110, 255),
        Vine = Color3.fromRGB(90, 255, 80)
    })
}

function t4.StyleColor(p1) -- line: 68
    -- upvalues: t4 (copy)
    return t4.StyleColors[p1 or "Default"] or t4.StyleColors.Default
end

function t4.Debris() -- line: 72
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("Transient") or Workspace
end

function t4.Part(p2) -- line: 76
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Material = Enum.Material.Neon

    for v3, v4 in p2 do
        Part[v3] = v4
    end

    return Part
end

function t4.Flat(p3) -- line: 93
    return (Vector3.new(p3.X, 0, p3.Z))
end

function t4.Shake(p4, p5, p6) -- line: 97
    -- upvalues: v1 (copy)
    v1:ShakeOnce(p4, p5 or 12, 0.05, p6 or 0.8)
end

function t4.ShakeFrom(p7, p8, p9) -- line: 101
    -- upvalues: Workspace (copy), t4 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    local v6 = math.clamp(1 - (CurrentCamera.CFrame.Position - p7).Magnitude / p9, 0, 1)

    if v6 > 0.05 then
        t4.Shake(p8 * v6, 14, 0.9)
    end
end

local function findSound(p10) -- line: 113
    -- upvalues: ReplicatedStorage (copy), t1 (copy), t2 (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Sounds = Assets and Assets:FindFirstChild("Sounds")

    if Sounds ~= nil then
        for _, v7 in {
                p10,
                t2[p10]
            } do
            for _, v8 in t1 do
                local v9 = Sounds:FindFirstChild(v8)
                local v10 = v9 and v9:FindFirstChild(v7)

                if v10 and v10:IsA("Sound") then
                    return v10
                end
            end
        end
    end

    return nil
end

local function lifetimeOf(p11) -- line: 133
    local v11 = math.max(p11.PlaybackSpeed, 0.05)
    local Seconds = p11:GetAttribute("Seconds")
    local TimeLength = p11.TimeLength

    if type(Seconds) ~= "number" then
        Seconds = 0
    end

    return math.max(math.max(TimeLength, Seconds) / v11, 3) + 1
end

local function soundHost(p12, p13) -- line: 141
    -- upvalues: t4 (copy)
    local v13 = t4.Part({
        Name = "PumpkinSound",
        Transparency = 1,
        Size = Vector3.new(1, 1, 1),
        CFrame = CFrame.new(p12)
    })

    v13.Parent = p13

    return v13
end

function t4.Claim(p14, p15, p16) -- line: 153
    -- upvalues: t3 (copy)
    local elapsed = os.clock()
    local t5 = {}

    for _, v14 in t3[p14] or {} do
        if elapsed - v14 < p16 then
            table.insert(t5, v14)
        end
    end

    t3[p14] = t5

    if p15 <= #t5 then
        return false
    end

    table.insert(t5, elapsed)

    return true
end

function t4.Sound(p17, p18, p19, p20) -- line: 171
    -- upvalues: Debris (copy), SoundService (copy), t4 (copy), findSound (copy)
    local v15 = findSound(p17)

    if v15 == nil then
        return nil
    end

    local clone = v15:Clone()

    clone.Volume *= p19 or 1
    clone.PlaybackSpeed *= p20 or 1

    local v16 = math.max(clone.PlaybackSpeed, 0.05)
    local Seconds = clone:GetAttribute("Seconds")
    local TimeLength = clone.TimeLength

    if type(Seconds) ~= "number" then
        Seconds = 0
    end

    local v18 = math.max(math.max(TimeLength, Seconds) / v16, 3) + 1

    if typeof(p18) == "Vector3" then
        local v19 = t4.Debris()
        local v20 = t4.Part({
            Name = "PumpkinSound",
            Transparency = 1,
            Size = Vector3.new(1, 1, 1),
            CFrame = CFrame.new(p18)
        })

        v20.Parent = v19
        Debris:AddItem(v20, v18)
        clone.Parent = v20
    else
        if typeof(p18) == "Instance" then
            clone.Parent = p18
        else
            clone.Parent = SoundService
        end

        Debris:AddItem(clone, v18)
    end

    clone:Play()

    return clone
end

function t4.Loop(p21, p22, p23, p24) -- line: 198
    -- upvalues: TweenService (copy), t4 (copy), findSound (copy)
    local v21 = findSound(p21)

    if v21 == nil then
        return nil
    end

    local clone = v21:Clone()
    local v22 = clone.Volume * (p24 or 1)

    clone.Looped = true
    clone.Volume = 0

    local v23 = t4.Part({
        Name = "PumpkinSound",
        Transparency = 1,
        Size = Vector3.new(1, 1, 1),
        CFrame = CFrame.new(p22)
    })

    v23.Parent = p23
    clone.Parent = v23
    clone:Play()
    TweenService:Create(clone, TweenInfo.new(0.3), {
        Volume = v22
    }):Play()

    return clone
end

function t4.FadeOut(p25, p26) -- line: 215
    -- upvalues: TweenService (copy)
    local Parent = p25.Parent
    local v24 = Parent ~= nil and Parent:IsA("BasePart") and Parent.Name == "PumpkinSound"
    local tween = TweenService:Create(p25, TweenInfo.new(p26), {
        Volume = 0
    })

    tween.Completed:Once(function() -- line: 219
        -- upvalues: p25 (copy), Parent (copy), v24 (copy)
        if v24 then
            Parent:Destroy()
        else
            p25:Destroy()
        end
    end)
    tween:Play()
end

function t4.Poof(p27, p28) -- line: 229
    -- upvalues: Debris (copy), ReplicatedStorage (copy), v2 (ref), t4 (copy)
    local v25 = v2
    local v26

    if v25 ~= nil then
        v26 = v25
    else
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local Particles = Assets and Assets:FindFirstChild("Particles")
        local BigHitGroundAttach = Particles and Particles:FindFirstChild("BigHitGroundAttach")

        if BigHitGroundAttach == nil then
            return
        end

        v26 = t4.Part({
            Name = "PumpkinPoof",
            Transparency = 1,
            Size = Vector3.new(1, 1, 1)
        })

        local Attachment = Instance.new("Attachment")

        Attachment.Parent = v26

        for _, descendant in BigHitGroundAttach:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant:Clone().Parent = Attachment
            end
        end

        if BigHitGroundAttach:IsA("ParticleEmitter") then
            BigHitGroundAttach:Clone().Parent = Attachment
        end

        v2 = v26
    end

    p28 = p28 or 1

    local clone = v26:Clone()

    clone.CFrame = CFrame.new(p27)
    clone.Parent = t4.Debris()

    local n1 = 0

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false

            if p28 ~= 1 then
                local t6 = {}

                for _, v28 in descendant.Size.Keypoints do
                    table.insert(t6, NumberSequenceKeypoint.new(v28.Time, v28.Value * p28, v28.Envelope * p28))
                end

                descendant.Size = NumberSequence.new(t6)
                descendant.Speed = NumberRange.new(descendant.Speed.Min * p28, descendant.Speed.Max * p28)
            end

            local EmitCount = descendant:GetAttribute("EmitCount")

            if type(EmitCount) ~= "number" then
                EmitCount = 30
            end

            descendant:Emit(EmitCount)
            n1 = math.max(n1, descendant.Lifetime.Max)
        end
    end

    Debris:AddItem(clone, n1 + 0.5)
end

function t4.Burst(p29, p30, p31, p32) -- line: 287
    -- upvalues: Debris (copy), t4 (copy)
    local v31 = p32 or 0.45
    local v32 = t4.Part({
        Name = "PumpkinBurst",
        Transparency = 0.3,
        Size = Vector3.new(2, 2, 2),
        Shape = Enum.PartType.Ball,
        Color = p31,
        CFrame = CFrame.new(p29)
    })

    v32.Parent = t4.Debris()
    Debris:AddItem(v32, v31 + 0.1)

    local elapsed = os.clock()

    task.spawn(function() -- line: 301
        -- upvalues: p30 (copy), v31 (copy), v32 (copy), elapsed (copy)
        while v32.Parent do
            local v34 = math.clamp((os.clock() - elapsed) / v31, 0, 1)

            v32.Size = Vector3.new(1, 1, 1) * math.max(p30 * 2 * v34, 2)
            v32.Transparency = v34 * 0.7 + 0.3

            if v34 >= 1 then
                break
            end

            task.wait()
        end
    end)
end

return t4
