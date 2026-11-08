-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local Kit = require(script.Parent.Kit)
local ScrambleBossVFX = ReplicatedStorage.Assets.Particles:WaitForChild("ScrambleBossVFX")
local t1 = {
    Slam = { "MechBoss", "Slam" },
    ToxicOrb = { "MechBoss", "ToxicOrb", "ToxicOrb" },
    ToxicSplat = { "MechBoss", "ToxicOrb", "ToxicOrbSplat" },
    ToxicPuddle = { "MechBoss", "ToxicPuddle" },
    SpiderLane = { "MechBoss", "SpiderRush", "SpiderRushIndicator" },
    SpiderSlashes = { "MechBoss", "SpiderRush", "SpiderRushSlashes" },
    BossSwipe = { "MechBoss", "BossSwipe" },
    LaserPillar = { "MechBoss", "LaserPillar" },
    LaserBeam = { "MechBoss", "LaserBeam" },
    LaserSweep = { "MechBoss", "LaserSweep" },
    DroneSummon = { "MechBoss", "DroneSummon" },
    CrocTarget = { "Croc", "Target" },
    CrocLeap = { "Croc", "LeapIn" },
    CrocBite = { "Croc", "BiteIndicator" },
    CrocTail = { "Croc", "TailSwipe" },
    BallTrail = { "BallTrail" },
    LightningSurge = { "LightningSurge", "Lightning Surge" }
}
local n1 = 0.016666666666666666
local t2 = {}

function t2.Template(p1) -- line: 61
    -- upvalues: ScrambleBossVFX (copy), t1 (copy)
    local v1 = ScrambleBossVFX

    for _, v2 in t1[p1] or {} do
        v1 = v1 and v1:FindFirstChild(v2)
    end

    return v1
end

function t2.Frame(p2, p3, p4) -- line: 70
    -- upvalues: t2 (copy)
    local v3 = t2.Template(p2)
    local v4 = if not (v3 and v3:IsA("BasePart")) then CFrame.identity else v3.CFrame.Rotation

    return (if not (p4 and p4.Magnitude > 0.001) then CFrame.new(p3) else CFrame.lookAt(p3, p3 + p4.Unit)) * v4
end

function t2.Scale(p5, p6) -- line: 82
    -- upvalues: VFX (copy)
    if p6 == 1 then
        return
    end

    if p5:IsA("BasePart") then
        p5.Size *= p6
    end

    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            VFX.Rescale(descendant, p6)
        elseif descendant:IsA("Beam") then
            descendant.Width0 *= p6
            descendant.Width1 *= p6
            descendant.CurveSize0 *= p6
            descendant.CurveSize1 *= p6

            if descendant.TextureMode ~= Enum.TextureMode.Stretch then
                descendant.TextureLength *= p6
            end
        elseif descendant:IsA("Attachment") then
            descendant.Position *= p6
        elseif descendant:IsA("PointLight") or descendant:IsA("SpotLight") then
            descendant.Range = math.min(descendant.Range * p6, 60)
        end
    end
end

function t2.Sample(p7) -- line: 110
    -- upvalues: n1 (ref)
    n1 += (math.min(p7, 0.25) - n1) * 0.1
end

local function keepVisible(p8) -- line: 114
    -- upvalues: n1 (ref)
    local v7 = n1 * 4

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local Lifetime = descendant.Lifetime

            if Lifetime.Max < v7 then
                local v8 = v7 / math.max(Lifetime.Max, 0.001)

                descendant.Lifetime = NumberRange.new(Lifetime.Min * v8, v7)
            end
        end
    end
end

local function settleSeconds(p9) -- line: 127
    local n2 = 0

    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            n2 = math.max(n2, descendant.Lifetime.Max / math.max(descendant.TimeScale, 0.01))
        elseif descendant:IsA("Trail") then
            n2 = math.max(n2, descendant.Lifetime)
        end
    end

    return n2 + 0.4
end

local function stage(p10, p11, p12, p13) -- line: 140
    -- upvalues: Kit (copy), t2 (copy)
    local v10 = t2.Template(p10)

    if v10 == nil then
        return nil
    end

    local clone = v10:Clone()

    if clone:IsA("BasePart") then
        clone.Anchored = true
        clone.CanCollide = false
        clone.CanQuery = false
        clone.CanTouch = false
        clone.CastShadow = false
        clone.Transparency = 1
        clone.CFrame = p11
    end

    t2.Scale(clone, p12 or 1)
    clone.Parent = p13 or Kit.Debris()

    return clone
end

local function authoredBeams(p14) -- line: 163
    local t3 = {}

    for _, descendant in p14:GetDescendants() do
        if descendant:IsA("Beam") then
            t3[descendant] = descendant.Transparency
        end
    end

    return t3
end

local function beamFade(p15, p16, p17, p18) -- line: 174
    -- upvalues: RunService (copy)
    local function apply(p19) -- line: 180
        -- upvalues: p16 (copy)
        for v11, v12 in p16 do
            local t4 = {}

            for v13, v14 in v12.Keypoints do
                t4[v13] = NumberSequenceKeypoint.new(v14.Time, 1 - (1 - v14.Value) * p19, v14.Envelope)
            end

            v11.Transparency = NumberSequence.new(t4)
        end
    end

    local elapsed = os.clock()

    apply(p18 and 0 or 1)

    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 197
        -- upvalues: p15 (copy), p16 (copy), p17 (copy), p18 (copy), apply (copy), elapsed (copy), connection (ref)
        local v16 = math.clamp((os.clock() - elapsed) / p17, 0, 1)
        local v17 = 1 - (1 - v16) ^ 2
        local apply2, v18, v19

        if p15.Parent ~= nil then
            if p15:GetAttribute("Fading") == p18 then
                apply2 = apply
                v18 = if p18 then v17 else 1 - v17
                v19 = false
            else
                v19 = true
            end
        else
            v19 = true
        end

        if not v19 then
            apply2(v18)

            if v16 >= 1 then
                if connection then
                    connection:Disconnect()
                end

                for v20, v21 in p16 do
                    if p18 then
                        v20.Transparency = v21
                    else
                        v20.Enabled = false
                    end
                end
            end
        elseif connection then
            connection:Disconnect()
        end
    end)
end

function t2.Burst(p20, p21, p22, p23, p24) -- line: 223
    -- upvalues: Debris (copy), VFX (copy), keepVisible (copy), settleSeconds (copy), stage (copy)
    local v22 = stage(p20, p21, p22, p24)

    if v22 == nil then
        return nil
    end

    for _, descendant in v22:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            if descendant.Enabled then
                descendant.Enabled = false

                if descendant:GetAttribute("EmitCount") == nil then
                    descendant:SetAttribute("EmitCount", descendant.Rate * (p23 or 0.25))
                end
            end
        elseif descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") then
            descendant.Enabled = false
        end
    end

    keepVisible(v22)
    Debris:AddItem(v22, math.max(VFX.EmitTree(v22, 0.5), (settleSeconds(v22))) + 0.4)

    return v22
end

function t2.Hold(p25, p26, p27, p28, p29) -- line: 257
    -- upvalues: Debris (copy), TweenService (copy), VFX (copy), settleSeconds (copy), stage (copy), authoredBeams (copy), beamFade (copy)
    local v25 = stage(p25, p26, p27, p28)

    if v25 == nil then
        return nil
    end

    local t5 = {}
    local t6 = {}

    for _, descendant in v25:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            if descendant.Enabled then
                table.insert(t5, descendant)
            elseif not p29 then
                VFX.EmitOne(descendant, 0.5)
            end
        elseif descendant:IsA("Light") then
            table.insert(t6, descendant)
        end
    end

    local v26 = authoredBeams(v25)

    v25:SetAttribute("Fading", true)
    beamFade(v25, v26, 0.12, true)

    local v27 = false

    return {
        Root = v25,
        Move = function(_, p31) -- Move | line: 290
            -- upvalues: v25 (copy)
            if v25:IsA("BasePart") then
                v25.CFrame = p31
            end
        end,
        Stop = function(_) -- Stop | line: 296
            -- upvalues: v25 (copy), t5 (copy), t6 (copy), v26 (copy), v27 (ref), Debris (copy), TweenService (copy), settleSeconds (copy), beamFade (copy)
            if v27 then
                return
            end

            v27 = true

            for _, v28 in t5 do
                v28.Enabled = false
            end

            for _, descendant in v25:GetDescendants() do
                if descendant:IsA("Trail") then
                    descendant.Enabled = false
                end
            end

            for _, v29 in t6 do
                TweenService:Create(v29, TweenInfo.new(0.22), {
                    Brightness = 0
                }):Play()
            end

            v25:SetAttribute("Fading", false)
            beamFade(v25, v26, 0.22, false)
            Debris:AddItem(v25, (settleSeconds(v25)))
        end
    }
end

function t2.Stamp(p33, p34, p35, p36) -- line: 321
    -- upvalues: Debris (copy), t2 (copy)
    local v30 = t2.Template(p33)

    if v30 == nil then
        return nil
    end

    local clone = v30:Clone()
    local t7 = {}

    if clone:IsA("Attachment") then
        table.insert(t7, clone)
    end

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("Attachment") and descendant.Parent == clone then
            table.insert(t7, descendant)
        end
    end

    for _, v31 in t7 do
        v31.Parent = p34

        for _, descendant in v31:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
                descendant.Lifetime = NumberRange.new(p35)

                if p36 then
                    descendant.LockedToPart = true
                end

                descendant:Emit(1)
            end
        end

        Debris:AddItem(v31, p35 + 0.4)
    end

    clone:Destroy()

    return t7[1]
end

function t2.Pulse(p37, p38) -- line: 357
    for _, descendant in p37:GetDescendants() do
        if descendant:IsA("ParticleEmitter") and not descendant.Enabled then
            descendant.Lifetime = NumberRange.new(p38)
            descendant:Emit(1)
        end
    end
end

function t2.Toggle(p39, p40) -- line: 366
    for _, descendant in p39:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            descendant.Enabled = p40
        end
    end
end

function t2.CrocScale(p41) -- line: 374
    -- upvalues: ScrambleBossVFX (copy)
    local Croc = p41:FindFirstChild("Croc")
    local Croc2 = ScrambleBossVFX:FindFirstChild("Croc")
    local ReferenceLength = Croc2 and Croc2:GetAttribute("ReferenceLength")

    if Croc == nil or not Croc:IsA("Model") or typeof(ReferenceLength) ~= "number" then
        return 1
    end

    local _, BoundingBox = Croc:GetBoundingBox()

    return math.max(BoundingBox.X, BoundingBox.Z) / ReferenceLength
end

function t2.Trail(p42, p43) -- line: 387
    -- upvalues: t2 (copy)
    local BallTrail = t2.Template("BallTrail")
    local t8 = {}
    local ReferenceWidth = BallTrail and BallTrail:GetAttribute("ReferenceWidth")

    if BallTrail == nil or typeof(ReferenceWidth) ~= "number" then
        return t8
    end

    local clone = BallTrail:Clone()

    t2.Scale(clone, p43 / ReferenceWidth)

    for _, child in clone:GetChildren() do
        if child:IsA("Attachment") then
            child.Parent = p42
            table.insert(t8, child)
        end
    end

    for _, child in clone:GetChildren() do
        if child:IsA("Trail") then
            child.Parent = p42
            table.insert(t8, child)
        end
    end

    clone:Destroy()

    return t8
end

function t2.Glitch(p44, p45, p46) -- line: 414
    -- upvalues: t2 (copy)
    local v32 = t2.Hold("DroneSummon", CFrame.new(p44), p45)

    if not v32 then
        return
    end

    task.delay(p46 or 0.45, function() -- line: 417
        -- upvalues: v32 (copy)
        v32:Stop()
    end)
end

function t2.Ground(p47, p48) -- line: 423
    return (Vector3.new(p47.X, p48 or p47.Y, p47.Z))
end

return t2
