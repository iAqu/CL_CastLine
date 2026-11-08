-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local Kit = require(script.Parent.Kit)
local t1 = {}
local t2 = {
    PhaseOne = "Phase1VFX",
    PhaseTwo = "Phase2VFX",
    FireParticles = 1.5,
    FireDensity = 2
}

function t2.Library() -- line: 70
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")

    return HalloweenDimension and HalloweenDimension:FindFirstChild("PumpkinBoss")
end

function t2.PhaseOf(p1) -- line: 77
    -- upvalues: PumpkinBossState (copy)
    if p1:GetAttribute(PumpkinBossState.Attributes.Boss) == "King" then
        return "Phase2VFX"
    end

    return "Phase1VFX"
end

function t2.Template(p2, p3) -- line: 81
    -- upvalues: t1 (copy), t2 (copy)
    local v1 = t2.Library()
    local v2 = v1 and v1:FindFirstChild(p2)

    for _, v3 in p3 do
        v2 = v2 and v2:FindFirstChild(v3)
    end

    if v2 and v2:IsA("BasePart") then
        return v2
    end

    local v4 = ("%*/%*"):format(p2, (table.concat(p3, "/")))

    if not t1[v4] then
        t1[v4] = true
        warn((("[PumpkinBoss] VFX %* is missing"):format(v4)))
    end

    return nil
end

local function settle(p4) -- line: 99
    p4.Anchored = true
    p4.CanCollide = false
    p4.CanQuery = false
    p4.CanTouch = false
    p4.CastShadow = false
    p4.Massless = true
    p4.Transparency = 1
end

function t2.Place(p5, p6, p7, p8) -- line: 111
    -- upvalues: VFX (copy), Kit (copy)
    p7 = p7 or 1
    p8 = p8 or p7

    local clone = p5:Clone()
    local CFrame = clone.CFrame

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v7 = CFrame:ToObjectSpace(descendant.CFrame)

            descendant.Size *= p7
            descendant.CFrame = p6 * (v7.Rotation + v7.Position * p7)
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
            descendant.Massless = true
            descendant.Transparency = 1
        elseif descendant:IsA("ParticleEmitter") then
            if p8 ~= 1 then
                VFX.Rescale(descendant, p8)
            end
        elseif p7 ~= 1 then
            if descendant:IsA("Beam") then
                descendant.Width0 *= p7
                descendant.Width1 *= p7
                descendant.CurveSize0 *= p7
                descendant.CurveSize1 *= p7
            elseif descendant:IsA("Attachment") then
                descendant.Position *= p7
            end
        end
    end

    clone.Size *= p7
    clone.CFrame = p6
    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.CastShadow = false
    clone.Massless = true
    clone.Transparency = 1
    clone.Parent = Kit.Debris()

    return clone
end

local function emitters(p9) -- line: 145
    local t3 = {}

    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t3, descendant)
        end
    end

    return t3
end

local function lifetimeOf(p10) -- line: 155
    return p10.Lifetime.Max / math.max(p10.TimeScale, 0.01)
end

function t2.Settle(p11) -- line: 160
    local n1 = 0

    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            n1 = math.max(n1, descendant.Lifetime.Max / math.max(descendant.TimeScale, 0.01))
        elseif descendant:IsA("Trail") then
            n1 = math.max(n1, descendant.Lifetime)
        end
    end

    return n1 + 0.3
end

local function burst(p12) -- line: 172
    if not (p12.Count > 0) then
        return
    end

    p12.Emitter:Emit((math.max(math.round(p12.Count), 1)))
end

function t2.Emit(p13, p14) -- line: 181
    -- upvalues: Debris (copy), RunService (copy), emitters (copy)
    local t4 = {}
    local t5 = {}
    local n2 = 0

    for _, v10 in emitters(p13) do
        local EmitCount = v10:GetAttribute("EmitCount")

        v10.Enabled = false

        if not (v10.TimeScale <= 0) then
            local EmitDelay = v10:GetAttribute("EmitDelay")
            local EmitDuration = v10:GetAttribute("EmitDuration")
            local v11 = type(EmitDuration) == "number" and EmitDuration > 0
            local t6 = {
                LastEmitted = nil,
                Emitter = v10
            }

            t6.Delay = if type(EmitDelay) == "number" then math.max(EmitDelay, 0) else 0

            if type(EmitCount) ~= "number" then
                EmitCount = if v11 then 1 else v10.Rate
            end

            t6.Count = EmitCount
            t6.Duration = if not v11 then 0 else EmitDuration
            t6.Interval = 1 / math.max(v10.Rate, 0.001)

            if t6.Delay ~= 1e999 then
                n2 = math.max(n2, t6.Delay)
                table.insert(t4, t6)
                table.insert(t5, t6.Delay + v10.Lifetime.Max / math.max(v10.TimeScale, 0.01))
            end
        end
    end

    if p14 and p14 > 0 and n2 > 0 then
        local v13 = p14 / n2

        for v14, v15 in t4 do
            v15.Delay *= v13

            local v16 = p14 - v15.Delay

            if not (v16 <= 0.001) then
                local Emitter = v15.Emitter

                if n2 <= t5[v14] or v16 < Emitter.Lifetime.Max / math.max(Emitter.TimeScale, 0.01) then
                    local v17 = v16 * Emitter.TimeScale

                    Emitter.Lifetime = NumberRange.new(math.min(Emitter.Lifetime.Min, v17), v17)
                end
            end
        end
    end

    local n3 = 0

    for _, v19 in t4 do
        local v20 = v19.Delay + v19.Duration
        local Emitter = v19.Emitter

        n3 = math.max(n3, v20 + Emitter.Lifetime.Max / math.max(Emitter.TimeScale, 0.01))
    end

    local v22 = n3 + 0.3
    local n4 = 0

    for _, v23 in t4 do
        if v23.Delay <= 0 then
            if v23.Count > 0 then
                v23.Emitter:Emit((math.max(math.round(v23.Count), 1)))
            end

            v23.LastEmitted = 0
        end

        if v23.Delay > 0 or v23.Duration > 0 then
            n4 += 1
        end
    end

    if n4 == 0 then
        Debris:AddItem(p13, v22)

        return v22
    end

    local elapsed = os.clock()
    local connection

    connection = RunService.Heartbeat:Connect(function() -- line: 250
        -- upvalues: p13 (copy), t4 (copy), v22 (copy), elapsed (copy), connection (ref)
        local v25 = os.clock() - elapsed

        if v22 <= v25 or p13.Parent == nil then
            connection:Disconnect()
            p13:Destroy()
        else
            for _, v26 in t4 do
                local LastEmitted = v26.LastEmitted

                if LastEmitted ~= nil then
                    if v26.Duration > 0 and v25 <= v26.Delay + v26.Duration and v25 - LastEmitted >= v26.Interval then
                        if v26.Count > 0 then
                            v26.Emitter:Emit((math.max(math.round(v26.Count), 1)))
                        end

                        v26.LastEmitted = LastEmitted + v26.Interval
                    end
                elseif v26.Delay <= v25 then
                    if v26.Count > 0 then
                        v26.Emitter:Emit((math.max(math.round(v26.Count), 1)))
                    end

                    v26.LastEmitted = v26.Delay
                end
            end
        end
    end)

    return v22
end

function t2.Play(p15, p16, p17, p18, p19) -- line: 275
    -- upvalues: t2 (copy)
    local v29 = t2.Template(p15, p16)

    if v29 == nil then
        return false
    end

    t2.Emit(t2.Place(v29, p17, p18), p19)

    return true
end

function t2.Hold(p20) -- line: 285
    -- upvalues: Debris (copy), t2 (copy)
    local t7 = {}

    for _, descendant in p20:GetDescendants() do
        if descendant:IsA("BasePart") then
            t7[descendant] = p20.CFrame:ToObjectSpace(descendant.CFrame)
        end
    end

    local v30 = false

    return {
        Root = p20,
        Move = function(_, p22) -- Move | line: 297
            -- upvalues: p20 (copy), t7 (copy)
            p20.CFrame = p22

            for v31, v32 in t7 do
                v31.CFrame = p22 * v32
            end
        end,
        Stop = function(_) -- Stop | line: 304
            -- upvalues: p20 (copy), v30 (ref), Debris (copy), t2 (copy)
            if v30 then
                return
            end

            v30 = true

            for _, descendant in p20:GetDescendants() do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end

            Debris:AddItem(p20, t2.Settle(p20))
        end
    }
end

function t2.Strip(p24, p25, p26, p27) -- line: 328
    -- upvalues: Debris (copy), Kit (copy), t2 (copy), emitters (copy)
    p26 = p26 or 1
    p27 = p27 or {}

    local v35 = t2.Place(p24, p25, p26, p27.Particles or 1)
    local v36 = p27.Lift or p24.Position.Y * p26
    local v38 = math.max(v35.Size.X * v35.Size.Z, 0.001)
    local t8 = {}

    for _, v39 in emitters(v35) do
        t8[v39] = v39.Rate * (p27.Density or 1)
    end

    local v40 = false

    return {
        Root = v35,
        Span = function(_, p29, p30, p31) -- Span | line: 343
            -- upvalues: p25 (copy), v35 (copy), v38 (copy), t8 (copy), v40 (ref), v36 (copy), Kit (copy)
            if v40 then
                return
            end

            local v41 = Kit.Flat(p30 - p29)
            local Magnitude = v41.Magnitude
            local v42 = if Magnitude > 0.001 then v41.Unit else p25.XVector
            local v43 = (p29 + p30) / 2 + Vector3.new(0, v36, 0)

            v35.Size = Vector3.new(math.max(Magnitude, 0.05), v35.Size.Y, p31)
            v35.CFrame = CFrame.fromMatrix(v43, v42, (Vector3.new(0, 1, 0)))

            local v45 = Magnitude * p31 / v38

            for v46, v47 in t8 do
                v46.Rate = v47 * v45
            end
        end,
        Stop = function(_) -- Stop | line: 359
            -- upvalues: v35 (copy), t8 (copy), v40 (ref), Debris (copy)
            if v40 then
                return
            end

            v40 = true

            for v48 in t8 do
                v48.Enabled = false
            end

            Debris:AddItem(v35, 5)
        end
    }
end

return t2
