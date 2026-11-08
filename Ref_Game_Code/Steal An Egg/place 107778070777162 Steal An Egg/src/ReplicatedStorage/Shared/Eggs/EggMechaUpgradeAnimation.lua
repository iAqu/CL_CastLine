-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Shake = require(ReplicatedStorage.Client.Shake)
local EggActionMovement = require(script.Parent.EggActionMovement)
local EggEnergyOrbField = require(script.Parent.EggEnergyOrbField)
local EggRenderer = require(script.Parent.EggRenderer)
local EmitTree = require(ReplicatedStorage.Shared.Utils.VFX).EmitTree
local Log = require(ReplicatedStorage.Packages.Log)
local PlayVFX = require(ReplicatedStorage.UserGenerated.VFX.PlayVFX)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local t = require(ReplicatedStorage.Packages.t)
local VisibleBounds = require(ReplicatedStorage.Shared.Utils.VisibleBounds)
local t1 = {
    "AssetAnimation",
    "Part"
}
local v1 = Color3.fromRGB(80, 190, 220)
local v2 = Log.new()
local v3 = Workspace:FindFirstChild("Transient") or Workspace
local v4 = Random.new()
local t2 = {}

local function applyShake(p1, p2, p3, p4) -- line: 76
    -- upvalues: EggActionMovement (copy), v4 (copy)
    EggActionMovement.SetPivot(p1, p2 * CFrame.new(v4:NextNumber(-1, 1) * 0.55 * p3, v4:NextNumber(-1, 1) * 0.55 * p3, v4:NextNumber(-1, 1) * 0.55 * p3) * CFrame.Angles(0, math.rad(p4), 0) * CFrame.Angles(math.rad(v4:NextNumber(-1, 1) * 24 * p3), 0, (math.rad(v4:NextNumber(-1, 1) * 24 * p3))))
end

local function playNamedSound(p5, p6) -- line: 99
    -- upvalues: ReplicatedStorage (copy), Audio (copy), v2 (copy)
    local Sounds = ReplicatedStorage.Assets:FindFirstChild("Sounds")
    local v9 = Sounds and Sounds:FindFirstChild(p5)

    if v9 ~= nil and v9:IsA("Sound") then
        Audio.Play(v9, p6)
    else
        v2:AtWarning():Log((("Missing ReplicatedStorage.Assets.Sounds.%*; sound skipped"):format(p5)))
    end
end

local function findParticleAsset(p7) -- line: 109
    -- upvalues: ReplicatedStorage (copy)
    local Particles = ReplicatedStorage.Assets:FindFirstChild("Particles")

    for _, v10 in p7 do
        if Particles == nil then
            return nil
        end

        Particles = Particles:FindFirstChild(v10)
    end

    return Particles
end

local function setEmittersEnabled(p8, p9) -- line: 120
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p9
        end
    end
end

local function createHostPart(p10, p11, p12) -- line: 128
    -- upvalues: Debris (copy), v3 (copy)
    local Part = Instance.new("Part")

    Part.Name = p10
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.1, 0.1, 0.1)
    Part.CFrame = p11
    Part.Parent = v3
    Debris:AddItem(Part, p12)

    return Part
end

local function attachToEgg(p13, p14) -- line: 144
    -- upvalues: VisibleBounds (copy)
    local PrimaryPart = p14.PrimaryPart

    if PrimaryPart == nil then
        return
    end

    local v11 = VisibleBounds(p14)

    p13.CFrame = PrimaryPart.CFrame:ToObjectSpace(CFrame.new(v11.Position))
    p13.Parent = PrimaryPart
end

local function createChargeParticles(p15) -- line: 155
    -- upvalues: VisibleBounds (copy), t1 (copy), v2 (copy), findParticleAsset (copy), setEmittersEnabled (copy)
    local v12 = findParticleAsset(t1)

    if v12 ~= nil then
        local Emit = v12:FindFirstChild("Emit")
        local Enable = v12:FindFirstChild("Enable")

        if Emit == nil or not Emit:IsA("Attachment") then
            v2:AtWarning():Log("Charge VFX is missing its Emit attachment")
        else
            if Enable ~= nil and Enable:IsA("Attachment") then
                local t3 = {
                    Emit = Emit:Clone(),
                    Enable = Enable:Clone()
                }
                local Emit2 = t3.Emit
                local PrimaryPart = p15.PrimaryPart

                if PrimaryPart ~= nil then
                    local v13 = VisibleBounds(p15)

                    Emit2.CFrame = PrimaryPart.CFrame:ToObjectSpace(CFrame.new(v13.Position))
                    Emit2.Parent = PrimaryPart
                end

                local Enable2 = t3.Enable
                local PrimaryPart2 = p15.PrimaryPart

                if PrimaryPart2 ~= nil then
                    local v14 = VisibleBounds(p15)

                    Enable2.CFrame = PrimaryPart2.CFrame:ToObjectSpace(CFrame.new(v14.Position))
                    Enable2.Parent = PrimaryPart2
                end

                setEmittersEnabled(t3.Enable, true)

                return t3
            end

            v2:AtWarning():Log("Charge VFX is missing its Enable attachment")
        end
    else
        v2:AtWarning():Log((("Missing ReplicatedStorage.Assets.Particles.%*; charge VFX skipped"):format((table.concat(t1, ".")))))
    end

    return nil
end

local function detachParticles(p16, p17) -- line: 186
    -- upvalues: Debris (copy), v3 (copy)
    local v15 = CFrame.new(p17)
    local Part = Instance.new("Part")

    Part.Name = "MechaUpgradeParticleKeeper"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.1, 0.1, 0.1)
    Part.CFrame = v15
    Part.Parent = v3
    Debris:AddItem(Part, 8)
    p16.Emit.CFrame = CFrame.new()
    p16.Emit.Parent = Part
    p16.Enable.CFrame = CFrame.new()
    p16.Enable.Parent = Part

    return Part
end

local function releaseParticles(p18) -- line: 196
    -- upvalues: Debris (copy), setEmittersEnabled (copy)
    setEmittersEnabled(p18.Enable, false)
    Debris:AddItem(p18.Emit, 8)
    Debris:AddItem(p18.Enable, 8)
end

local function emitImpactVfx(p19) -- line: 202
    -- upvalues: Debris (copy), PlayVFX (copy), TryCall (copy), v2 (copy), v3 (copy), findParticleAsset (copy)
    local v16 = findParticleAsset({ "HitGroundAttach" })

    if v16 ~= nil then
        local Part = Instance.new("Part")

        Part.Name = "MechaUpgradeImpactVFX"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Transparency = 1
        Part.Size = Vector3.new(0.1, 0.1, 0.1)
        Part.CFrame = p19
        Part.Parent = v3
        Debris:AddItem(Part, 10)

        local clone = v16:Clone()

        if not TryCall(PlayVFX, Part, p19, clone) then
            clone:Destroy()
        end
    else
        v2:AtWarning():Log("Missing ReplicatedStorage.Assets.Particles.HitGroundAttach; impact VFX skipped")
    end
end

local function playChargeLift(p20, p21, p22, p23, p24, p25) -- line: 218
    -- upvalues: RunService (copy), TweenService (copy), applyShake (copy)
    local n1 = 0

    while true do
        if not (n1 < 5) then
            return true
        end

        local v17 = RunService.Heartbeat:Wait()

        n1 += v17

        if p20.Parent == nil then
            break
        end

        local v19 = math.min(n1 / 5, 1)
        local v21 = math.min(v19 / 0.62, 1)
        local v22 = p21:Lerp(p22, TweenService:GetValue(v21, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
        local Value = TweenService:GetValue(v21, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)

        p25.Spin += 216 * v17
        applyShake(p20, v22, Value, p25.Spin)
        p24:Step(v22.Position + p23, v19, v17)
    end

    return false
end

local function playShakeSettle(p26, p27, p28) -- line: 256
    -- upvalues: RunService (copy), TweenService (copy), EggActionMovement (copy), applyShake (copy)
    local Spin = p28.Spin
    local v24 = math.ceil(Spin / 360) * 360
    local n2 = 0

    while true do
        if n2 < 0.5 then
            n2 += RunService.Heartbeat:Wait()

            if p26.Parent == nil then
                break
            end

            local v26 = math.min(n2 / 0.5, 1)
            local Value = TweenService:GetValue(v26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            p28.Spin = Spin + (v24 - Spin) * Value
            applyShake(p26, p27, 1 - v26, p28.Spin)
            continue
        end

        EggActionMovement.SetPivot(p26, p27)

        return
    end
end

local function playDrop(p29, p30, p31, p32) -- line: 277
    -- upvalues: RunService (copy), TweenService (copy), EggActionMovement (copy)
    local n3 = 0
    local v27 = false

    while n3 < 0.26 do
        local v28 = RunService.Heartbeat:Wait()

        n3 += v28

        if p29.Parent == nil then
            return
        end

        if not v27 and n3 + v28 * 1 >= 0.26 then
            v27 = true
            p32()
        end

        local Value = TweenService:GetValue(math.min(n3 / 0.26, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.In)

        EggActionMovement.SetPivot(p29, p30:Lerp(p31, Value))
    end

    EggActionMovement.SetPivot(p29, p31)

    if not v27 then
        p32()
    end
end

local function triggerImpact(p33, p34) -- line: 306
    -- upvalues: Shake (copy), playNamedSound (copy), emitImpactVfx (copy)
    emitImpactVfx(p33)

    if p34 then
        Shake.Play({
            Seconds = 0.45,
            Magnitude = 1.6
        })
    end

    playNamedSound("MechaHatch", p33)
end

local function playSettle(p35, p36) -- line: 316
    -- upvalues: RunService (copy), TweenService (copy), EggActionMovement (copy)
    local Scale = p35:GetScale()
    local n4 = 0

    while n4 < 0.22 do
        n4 += RunService.Heartbeat:Wait()

        if p35.Parent == nil then
            return
        end

        local v31 = math.min(n4 / 0.22, 1)
        local v32 = (1 - v31) * (1 - v31)
        local v35 = math.abs((math.sin(6.283185307179586 * v31))) * 0.9 * v32

        EggActionMovement.SetPivot(p35, p36 * CFrame.new(0, v35, 0))
        p35:ScaleTo(Scale * (0.88 + 0.12 * TweenService:GetValue(v31, Enum.EasingStyle.Back, Enum.EasingDirection.Out)))
    end

    if p35.Parent ~= nil then
        p35:ScaleTo(Scale)
        EggActionMovement.SetPivot(p35, p36)
    end
end

function t2.Play(p37, p38, p39) -- line: 345
    -- upvalues: Debris (copy), Players (copy), Shake (copy), EggEnergyOrbField (copy), EggRenderer (copy), EmitTree (copy), t (copy), VisibleBounds (copy), v1 (copy), v2 (copy), v3 (copy), applyShake (copy), playNamedSound (copy), setEmittersEnabled (copy), createChargeParticles (copy), detachParticles (copy), emitImpactVfx (copy), playChargeLift (copy), playShakeSettle (copy), playDrop (copy), playSettle (copy)
    t.strict(t.number)(p37)
    t.strict(t.instanceIsA("Model"))(p38)
    t.strict(t.callback)(p39)
    EggRenderer.DisableCollisions(p38)

    local Pivot = p38:GetPivot()
    local v36 = Pivot * CFrame.new(0, 7, 0)
    local v37, v38 = VisibleBounds(p38)
    local v39 = v37.Position - Pivot.Position
    local v40 = CFrame.new(v37.Position - Vector3.new(0, 1, 0) * (v38.Y * 0.5))
    local v41 = p37 == Players.LocalPlayer.UserId

    playNamedSound("MechaShake", Pivot)

    local v42 = createChargeParticles(p38)
    local v43 = EggEnergyOrbField.new(v3, v1)
    local t4 = {
        Spin = 0
    }

    if playChargeLift(p38, Pivot, v36, v39, v43, t4) then
        v43:Absorb(v36.Position + v39, 0.6, function(p40) -- line: 366
            -- upvalues: p38 (copy), v36 (copy), t4 (copy), applyShake (copy)
            if p38.Parent ~= nil then
                t4.Spin += p40 * 216
                applyShake(p38, v36, 1, t4.Spin)
            end
        end)
    else
        v43:Destroy()
    end

    local v44 = if v42 == nil then nil else detachParticles(v42, v36.Position + v39)
    local v45 = p39()

    if v45 ~= nil then
        EggRenderer.DisableCollisions(v45)
        applyShake(v45, v36, 1, t4.Spin)

        if v42 ~= nil and v44 ~= nil then
            local Emit = v42.Emit
            local PrimaryPart = v45.PrimaryPart

            if PrimaryPart ~= nil then
                local v46 = VisibleBounds(v45)

                Emit.CFrame = PrimaryPart.CFrame:ToObjectSpace(CFrame.new(v46.Position))
                Emit.Parent = PrimaryPart
            end

            local Enable = v42.Enable
            local PrimaryPart2 = v45.PrimaryPart

            if PrimaryPart2 ~= nil then
                local v47 = VisibleBounds(v45)

                Enable.CFrame = PrimaryPart2.CFrame:ToObjectSpace(CFrame.new(v47.Position))
                Enable.Parent = PrimaryPart2
            end

            v44:Destroy()
            EmitTree(v42.Emit)
        end

        playShakeSettle(v45, v36, t4)
        playDrop(v45, v36, Pivot, function() -- line: 404
            -- upvalues: v40 (copy), v41 (copy), Shake (copy), playNamedSound (copy), emitImpactVfx (copy)
            emitImpactVfx(v40)

            if v41 then
                Shake.Play({
                    Seconds = 0.45,
                    Magnitude = 1.6
                })
            end

            playNamedSound("MechaHatch", v40)
        end)
        playSettle(v45, Pivot)
    else
        v2:AtWarning():Log("Mecha upgrade swap did not produce a replacement egg model")
    end

    if v42 == nil then
        return
    end

    setEmittersEnabled(v42.Enable, false)
    Debris:AddItem(v42.Emit, 8)
    Debris:AddItem(v42.Enable, 8)
end

return t2
