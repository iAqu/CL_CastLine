-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {}
local t2 = {}
local v1
local v2 = Random.new()

local function step() -- line: 35
    -- upvalues: t2 (copy), v1 (ref), v2 (copy)
    for v3, v4 in pairs(t2) do
        local core = v4.core

        if core.Parent then
            local CFrame = core.CFrame
            local Magnitude = (CFrame.Position - v4.prev.Position).Magnitude

            if not (Magnitude > 400) then
                for _, v5 in ipairs(v4.items) do
                    v5.acc += Magnitude

                    local v7 = math.floor(v5.acc / v5.spacing)

                    if v7 > 0 then
                        if v7 > 24 then
                            v7 = 24
                            v5.acc = 0
                        else
                            v5.acc -= v7 * v5.spacing
                        end

                        for i = 1, v7 do
                            local v8 = v4.prev:Lerp(CFrame, i / v7)
                            local v9 = v5.spread > 0
                            local v10 = if v9 then v2:NextNumber(-v5.spread / 2, v5.spread / 2) else nil
                            local v11 = if not v9 or not v10 then 0 else v10

                            v5.att.WorldPosition = v8:PointToWorldSpace(v5.base + Vector3.new(0, v11, 0))
                            v5.e:Emit(1)
                        end

                        v5.att.Position = v5.base
                    end
                end
            end

            v4.prev = CFrame
            continue
        end

        t2[v3] = nil
    end

    if next(t2) == nil and v1 then
        v1:Disconnect()
        v1 = nil
    end
end

function t1.SetFlight(p1, p2) -- line: 75
    -- upvalues: RunService (copy), t2 (copy), v1 (ref), step (copy)
    if not p1 then
        return
    end

    local t3 = {}
    local n1 = 0

    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:GetAttribute("FlightFx") then
            if descendant:GetAttribute("PathEmit") then
                descendant.Enabled = false

                if p2 and descendant.Rate > 0 and descendant.Parent:IsA("Attachment") then
                    local Parent = descendant.Parent

                    t3[#t3 + 1] = {
                        acc = 0,
                        e = descendant,
                        att = Parent,
                        base = Parent.Position,
                        spread = Parent:GetAttribute("Spread") or 0,
                        spacing = 60 / descendant.Rate
                    }
                    n1 += descendant.Rate
                end
            else
                descendant.Enabled = p2

                if p2 and descendant:IsA("ParticleEmitter") and descendant.Rate > 0 then
                    descendant:Emit((math.clamp(math.round(descendant.Rate * 0.3), 1, 8)))
                end
            end
        end
    end

    local v14

    if not p2 or #t3 == 0 then
        t2[p1] = nil

        return
    else
        local v16 = n1 * 200 / 60

        v14 = v16 > 300 and v16 / 300 or 1
    end

    for _, v17 in ipairs(t3) do
        v17.spacing = math.max(0.6, v17.spacing * v14)
    end

    local PrimaryPart = p1.PrimaryPart

    if PrimaryPart then
        for _, v19 in ipairs(t3) do
            v19.e:Emit(1)
        end

        t2[p1] = {
            core = PrimaryPart,
            prev = PrimaryPart.CFrame,
            items = t3
        }
        v1 = v1 or RunService.Heartbeat:Connect(step)
    end
end

return t1
