-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Fx = require(script.Parent.Fx)
local Giant = require(script.Parent.Giant)
local Player = require(ReplicatedStorage.Shared.Player)
local Shake = require(ReplicatedStorage.Client.Shake)
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 235)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 70, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 40))
})
local v2 = ColorSequence.new(Color3.fromRGB(60, 52, 52), Color3.fromRGB(25, 22, 22))
local t1 = {
    { "Particles", "ScrambleBossVFX", "MechBoss", "LaserBeam", "Beam" },
    { "Particles", "ScrambleBossVFX", "MechBoss", "LaserPillar", "Beam" }
}
local t2 = {
    "Particles",
    "ScrambleBossVFX",
    "Blast",
    "Blast",
    "Start"
}
local t3 = {
    "Particles",
    "ScrambleBossVFX",
    "Blast",
    "Blast",
    "End"
}
local t4 = {
    "Particles",
    "ScrambleBossVFX",
    "SmokePuff",
    "SmokeVFX"
}
local t5 = {
    "Particles",
    "ScrambleBossVFX",
    "MechBoss",
    "Slam"
}
local t6 = {}

local function copyEmitters(p1, p2, p3) -- line: 59
    -- upvalues: Fx (copy)
    local v3 = Fx.Resolve(p1)
    local t7 = {}

    if v3 ~= nil then
        for _, descendant in v3:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local clone = descendant:Clone()

                clone.Enabled = false
                Fx.ScaleEmitter(clone, p3)
                clone.Parent = p2
                table.insert(t7, clone)
            end
        end
    end

    return t7
end

local function copyBeams(p4, p5, p6) -- line: 85
    -- upvalues: Fx (copy), v1 (copy), t1 (copy)
    local t8 = {}

    for _, v4 in t1 do
        local v5 = Fx.Resolve(v4)

        if v5 ~= nil then
            for _, descendant in v5:GetDescendants() do
                if descendant:IsA("Beam") then
                    local clone = descendant:Clone()

                    clone.Attachment0 = p4
                    clone.Attachment1 = p5
                    clone.FaceCamera = true
                    clone.Color = v1
                    clone.LightEmission = 1
                    clone.Width0 = descendant.Width0 * 2.6
                    clone.Width1 = descendant.Width1 * 1.15
                    clone.Parent = p6
                    table.insert(t8, clone)
                end
            end
        end
    end

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = p4
    Beam.Attachment1 = p5
    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.Brightness = 4
    Beam.Color = ColorSequence.new(Color3.fromRGB(255, 235, 225))
    Beam.Transparency = NumberSequence.new(0.05)
    Beam.Width0 = 9
    Beam.Width1 = 2.4
    Beam.Segments = 1
    Beam.Parent = p6
    table.insert(t8, Beam)

    return t8
end

local function setEmitting(p7, p8) -- line: 130
    for _, v6 in p7 do
        v6.Enabled = p8
    end
end

local function reticle(p9, p10) -- line: 136
    -- upvalues: Debris (copy), TweenService (copy), Fx (copy)
    local Part = Instance.new("Part")

    Part.Name = "Reticle"
    Part.Shape = Enum.PartType.Cylinder
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.fromRGB(255, 40, 50)
    Part.Transparency = 0.35
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Size = Vector3.new(0.3, 22, 22)
    Part.CFrame = CFrame.new(p9) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = Fx.Folder()
    TweenService:Create(Part, TweenInfo.new(p10, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = Vector3.new(0.3, 6, 6),
        Transparency = 0.05
    }):Play()
    Debris:AddItem(Part, p10 + 0.05)

    return Part
end

local function scorch(p11, p12) -- line: 163
    -- upvalues: Debris (copy), TweenService (copy), Fx (copy)
    local Part = Instance.new("Part")
    local v7 = if p12 then 30 else 20

    Part.Name = "Scorch"
    Part.Shape = Enum.PartType.Cylinder
    Part.Material = Enum.Material.SmoothPlastic
    Part.Color = Color3.fromRGB(24, 18, 18)
    Part.Transparency = 0.2
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Size = Vector3.new(0.12, v7, v7)
    Part.CFrame = CFrame.new(p11 + Vector3.new(0, 0.08, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = Fx.Folder()

    local clone = Part:Clone()

    clone.Material = Enum.Material.Neon
    clone.Color = Color3.fromRGB(255, 90, 30)
    clone.Transparency = 0.1
    clone.Size = Vector3.new(0.14, v7 * 0.45, v7 * 0.45)
    clone.CFrame = Part.CFrame + Vector3.new(0, 0.02, 0)
    clone.Parent = Fx.Folder()
    TweenService:Create(clone, TweenInfo.new(1.4), {
        Transparency = 1
    }):Play()
    TweenService:Create(Part, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    }):Play()
    Debris:AddItem(clone, 1.5)
    Debris:AddItem(Part, 5.1)
end

local function groundUnder(p13, p14) -- line: 204
    -- upvalues: Workspace (copy)
    local v10 = RaycastParams.new()

    v10.FilterType = Enum.RaycastFilterType.Exclude
    v10.FilterDescendantsInstances = p14
    v10.RespectCanCollide = true

    local v11 = Workspace:Raycast(p13 + Vector3.new(0, 6, 0), Vector3.new(0, -60, 0), v10)

    if v11 == nil then
        return p13 - Vector3.new(0, 3, 0)
    end

    return v11.Position
end

local function impact(p15, p16, p17) -- line: 216
    -- upvalues: Debris (copy), Fx (copy), Shake (copy), t5 (copy), scorch (copy)
    local v12 = Fx.Resolve(t5)

    if v12 ~= nil then
        local clone = v12:Clone()

        if clone:IsA("BasePart") then
            clone.Anchored = true
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CanTouch = false
            clone.Transparency = 1
            clone.CFrame = CFrame.new(p15)
        end

        Fx.Scale(clone, p16 and 3.4 or 2.2)
        clone.Parent = Fx.Folder()
        Fx.Burst(clone)
        Debris:AddItem(clone, 4)
    end

    scorch(p15, p16)
    Fx.Sound({ "Sounds", "ImpactBoom" }, p15, 1.4, 1.05, 1600)
    Fx.Sound({ "Sounds", "ScrambleBoss", "Strike" }, p15, 1, 0.9, 900)

    if p16 then
        Fx.Sound({ "Sounds", "Explosion" }, p15, 1.1, 1.1, 1600)
    end

    Shake.Play({
        Shape = "Fade",
        Seconds = p17 and 1 or 0.75,
        Magnitude = if p17 then 4.5 elseif p16 then 3 else 2.2,
        Range = {
            Near = 30,
            Far = 320,
            Center = p15
        },
        Rumble = p17
    })
end

function t6.Fire(p18, p19, p20, p21, p22, p23) -- line: 258
    -- upvalues: Debris (copy), Players (copy), RunService (copy), Workspace (copy), Fx (copy), Giant (copy), Player (copy), v1 (copy), v2 (copy), t2 (copy), t3 (copy), t4 (copy), copyEmitters (copy), copyBeams (copy), reticle (copy), impact (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p19)
    local v13 = PlayerByUserId == Players.LocalPlayer
    local v14 = p21 - 0.14
    local v16 = math.max(v14 - Workspace:GetServerTimeNow(), 0.05)

    local function targetPosition() -- line: 271
        -- upvalues: p20 (copy), PlayerByUserId (copy), Player (copy)
        local v17 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)

        if v17 == nil then
            return p20
        end

        return v17.Position
    end

    Giant.SetEyes(p18, 2.4)

    local t10 = { Fx.Folder() }

    if PlayerByUserId ~= nil and PlayerByUserId.Character ~= nil then
        table.insert(t10, PlayerByUserId.Character)
    end

    local v18 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)
    local v19 = if v18 == nil then p20 else v18.Position
    local v20 = RaycastParams.new()

    v20.FilterType = Enum.RaycastFilterType.Exclude
    v20.FilterDescendantsInstances = t10
    v20.RespectCanCollide = true

    local v21 = Workspace:Raycast(v19 + Vector3.new(0, 6, 0), Vector3.new(0, -60, 0), v20)

    reticle((if v21 == nil then v19 - Vector3.new(0, 3, 0) else v21.Position) + Vector3.new(0, 0.2, 0), v16)

    local Sound = Fx.Sound
    local t11 = {
        "Sounds",
        "ScrambleBoss",
        "Charge"
    }
    local v23 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)

    Sound(t11, if v23 == nil then p20 else v23.Position, 1.2, 0.8, 700)

    if v13 then
        Fx.Sound({ "Sounds", "ScrambleBoss", "TargetLock" }, nil, 1.3)
    end

    local Holder = Fx.Holder
    local v24 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)
    local LaserEnd = Holder(if v24 == nil then p20 else v24.Position, "LaserEnd")
    local Attachment = Instance.new("Attachment")

    Attachment.Parent = LaserEnd

    local v25 = copyEmitters(t4, Attachment, 7)
    local v26 = copyEmitters(t3, Attachment, 1.6)

    for _, v27 in v25 do
        v27.Color = v2
        v27.LightEmission = 0
    end

    local t12 = {}
    local t13 = {}
    local t14 = {}

    for _, v28 in p18.Eyes do
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "LaserEye"
        Attachment.Parent = v28
        table.insert(t12, Attachment)

        for _, v29 in copyEmitters(t2, Attachment, 7) do
            v29.Color = v1
            table.insert(t13, v29)
        end
    end

    for _, v30 in t13 do
        v30.Enabled = true
    end

    local v31 = false
    local v32 = false
    local v33 = p21 + 0.38
    local connection

    local function cleanup() -- line: 328
        -- upvalues: p18 (copy), p23 (copy), LaserEnd (copy), v25 (copy), v26 (copy), t12 (copy), t13 (copy), t14 (copy), connection (ref), Debris (copy), RunService (copy), Giant (copy)
        if connection ~= nil then
            connection:Disconnect()
            connection = nil
        end

        for _, v34 in t13 do
            v34.Enabled = false
        end

        for _, v35 in v25 do
            v35.Enabled = false
        end

        for _, v36 in v26 do
            v36.Enabled = false
        end

        for _, v37 in t14 do
            local Width0, Width1 = v37.Width0, v37.Width1
            local elapsed = os.clock()

            task.spawn(function() -- line: 343
                -- upvalues: v37 (copy), Width0 (copy), Width1 (copy), elapsed (copy), RunService (copy)
                while v37.Parent ~= nil and os.clock() - elapsed < 0.3 do
                    local v38 = 1 - (os.clock() - elapsed) / 0.3

                    v37.Width0 = Width0 * v38
                    v37.Width1 = Width1 * v38
                    RunService.RenderStepped:Wait()
                end

                v37:Destroy()
            end)
        end

        for _, v39 in t12 do
            Debris:AddItem(v39, 3)
        end

        Debris:AddItem(LaserEnd, 4)
        Giant.SetEyes(p18, p23() and 0.75 or 0)
    end

    connection = RunService.RenderStepped:Connect(function() -- line: 364
        -- upvalues: p20 (copy), p21 (copy), p22 (copy), PlayerByUserId (copy), v14 (copy), LaserEnd (copy), v25 (copy), v26 (copy), t12 (copy), t14 (copy), v31 (ref), v32 (ref), v33 (copy), cleanup (copy), v13 (copy), Workspace (copy), Fx (copy), Player (copy), copyBeams (copy), impact (copy)
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v40 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)
        local v41 = if v40 == nil then p20 else v40.Position

        LaserEnd.CFrame = CFrame.new(v41)

        if v14 <= ServerTimeNow and not v31 then
            v31 = true

            for v42, v43 in t12 do
                local Attachment = Instance.new("Attachment")

                Attachment.Name = ("LaserTip%*"):format(v42)
                Attachment.Parent = LaserEnd
                Attachment.WorldPosition = v43.WorldPosition

                for _, v44 in copyBeams(v43, Attachment, LaserEnd) do
                    table.insert(t14, v44)
                end
            end

            Fx.Sound({ "Sounds", "ScrambleBoss", "LaserBeam" }, v41, 1.6, 1, 1400)

            if v13 then
                Fx.Sound({ "Sounds", "ScrambleBoss", "LaserBeam" }, nil, 0.7)
            end
        end

        if v31 then
            local v46 = math.clamp((ServerTimeNow - v14) / 0.14, 0, 1)

            for v47, v48 in t12 do
                local v49 = LaserEnd:FindFirstChild((("LaserTip%*"):format(v47)))

                if v49 ~= nil and v49:IsA("Attachment") then
                    v49.WorldPosition = v48.WorldPosition:Lerp(v41, v46)
                end
            end
        end

        if p21 <= ServerTimeNow and not v32 then
            v32 = true

            for _, v50 in v25 do
                v50.Enabled = true
            end

            for _, v51 in v26 do
                v51.Enabled = true
            end

            local t15 = {}

            if PlayerByUserId ~= nil and PlayerByUserId.Character ~= nil then
                table.insert(t15, PlayerByUserId.Character)
            end

            local v52 = RaycastParams.new()

            v52.FilterType = Enum.RaycastFilterType.Exclude
            v52.FilterDescendantsInstances = t15
            v52.RespectCanCollide = true

            local v53 = Workspace:Raycast(v41 + Vector3.new(0, 6, 0), Vector3.new(0, -60, 0), v52)

            impact(if v53 == nil then v41 - Vector3.new(0, 3, 0) else v53.Position, p22, v13)
        end

        if v33 <= ServerTimeNow then
            cleanup()
        end
    end)
end

return t6
