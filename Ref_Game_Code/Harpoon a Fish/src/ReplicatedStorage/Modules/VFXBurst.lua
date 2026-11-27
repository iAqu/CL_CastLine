-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local v1 = CFrame.new(0, -20000, 0)
local t2 = {}

local function scaleSeq(p1, p2) -- line: 30
    local t3 = {}

    for v2, v3 in ipairs(p1.Keypoints) do
        t3[v2] = NumberSequenceKeypoint.new(v3.Time, v3.Value * p2, v3.Envelope * p2)
    end

    return NumberSequence.new(t3)
end

function t1.Emitters(p3) -- line: 38
    local t4 = {}

    for _, descendant in ipairs(p3:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            t4[#t4 + 1] = descendant
        end
    end

    return t4
end

local function newEntry(p4) -- line: 48
    -- upvalues: v1 (copy)
    local clone = p4:Clone()

    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.Transparency = 1

    local t5 = {
        k = 1,
        color = nil,
        use = 0,
        fx = clone,
        own = {},
        ems = {},
        lights = {}
    }

    for _, descendant in ipairs(clone:GetDescendants()) do
        t5.own[descendant] = true

        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
            t5.ems[#t5.ems + 1] = {
                e = descendant,
                size = descendant.Size,
                speed = descendant.Speed,
                acc = descendant.Acceleration,
                color = descendant.Color,
                n = descendant:GetAttribute("EmitCount") or 0,
                delay = descendant:GetAttribute("EmitDelay") or 0
            }
        elseif descendant:IsA("Light") then
            t5.lights[#t5.lights + 1] = {
                l = descendant,
                on = descendant.Enabled
            }
        end
    end

    clone.CFrame = v1
    clone.Parent = workspace

    return t5
end

local function park(p5, p6, p7) -- line: 71
    -- upvalues: v1 (copy)
    if p6.use ~= p7 then
        return
    end

    local fx = p6.fx

    if fx.Parent then
        for _, v4 in ipairs(p6.ems) do
            v4.e:Clear()
        end

        for _, v5 in ipairs(p6.lights) do
            v5.l.Enabled = false
        end

        for _, descendant in ipairs(fx:GetDescendants()) do
            if not p6.own[descendant] and descendant.Parent then
                descendant:Destroy()
            end
        end

        fx.CFrame = v1

        if #p5.free < 4 then
            p5.free[#p5.free + 1] = p6
        else
            fx:Destroy()
        end
    end
end

function t1.Warm(p8, p9) -- line: 90
    -- upvalues: t2 (copy), newEntry (copy)
    local v6 = t2[p8]

    if not v6 then
        v6 = {
            free = {}
        }
        t2[p8] = v6
    end

    while true and #v6.free < math.min(p9 or 1, 4) do
        v6.free[#v6.free + 1] = newEntry(p8)
    end
end

function t1.Play(p10, p11, p12, p13) -- line: 99
    -- upvalues: t2 (copy), scaleSeq (copy), newEntry (copy), park (copy)
    p12 = p12 or 1

    local v10 = t2[p10]

    if not v10 then
        v10 = {
            free = {}
        }
        t2[p10] = v10
    end

    local v11 = table.remove(v10.free)

    while v11 and not v11.fx.Parent do
        v11 = table.remove(v10.free)
    end

    if not v11 then
        v11 = newEntry(p10)
    end

    v11.use += 1

    local use, fx = v11.use, v11.fx

    for _, v12 in ipairs(v11.lights) do
        v12.l.Enabled = v12.on
    end

    local v13 = v11.k ~= p12
    local v14 = v11.color ~= p13

    for _, v15 in ipairs(v11.ems) do
        local e = v15.e

        if v13 then
            if p12 == 1 then
                local size, speed, acc = v15.size, v15.speed, v15.acc

                e.Size = size
                e.Speed = speed
                e.Acceleration = acc
            else
                e.Size = scaleSeq(v15.size, p12)
                e.Speed = NumberRange.new(v15.speed.Min * p12, v15.speed.Max * p12)
                e.Acceleration = v15.acc * p12
            end
        end

        if v14 then
            e.Color = p13 or v15.color
        end
    end

    v11.k = p12
    v11.color = p13
    fx.CFrame = p11

    for _, v16 in ipairs(v11.ems) do
        if v16.n > 0 then
            if v16.delay > 0 then
                local e, n = v16.e, v16.n

                task.delay(v16.delay, function() -- line: 133
                    -- upvalues: v11 (ref), use (copy), fx (copy), e (copy), n (copy)
                    if v11.use == use and fx.Parent then
                        e:Emit(n)
                    end
                end)
            else
                v16.e:Emit(v16.n)
            end
        end
    end

    task.delay(6, park, v10, v11, use)

    return fx
end

return t1
