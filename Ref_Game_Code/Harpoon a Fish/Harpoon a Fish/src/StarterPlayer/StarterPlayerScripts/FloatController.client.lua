-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local t1 = {}

local function track(p1) -- line: 40
    -- upvalues: t1 (copy)
    if not t1[p1] and p1:IsA("Model") then
        t1[p1] = {
            rest = nil,
            phase = 0,
            parked = true,
            swings = {}
        }
    end
end

local function untrack(p2) -- line: 45
    -- upvalues: t1 (copy)
    local v1 = t1[p2]

    if v1 and v1.added then
        v1.added:Disconnect()
    end

    t1[p2] = nil
end

local function addSwing(p3, p4) -- line: 53
    if p3.rest and p4:IsA("BasePart") and typeof(p4:GetAttribute("SwingPivot")) == "Vector3" then
        for _, v2 in ipairs(p3.swings) do
            if v2.part == p4 then
                return
            end
        end

        local t2 = {}

        for _, child in ipairs(p4:GetChildren()) do
            if child:IsA("PointLight") then
                t2[#t2 + 1] = {
                    light = child,
                    base = child.Brightness
                }
            end
        end

        local v3 = p3.rest:ToObjectSpace(p4.CFrame)

        p3.swings[#p3.swings + 1] = {
            part = p4,
            rel = v3,
            hinge = v3 * p4:GetAttribute("SwingPivot"),
            gain = p4:GetAttribute("SwingGain") or 1.6,
            lag = p4:GetAttribute("SwingLag") or 0.35,
            lights = t2,
            seed = (p4.Position.X * 1.3 + p4.Position.Z * 0.7) % 6.283185307179586
        }
    end
end

for _, v4 in ipairs(CollectionService:GetTagged("FloatingPen")) do
    track(v4)
end

CollectionService:GetInstanceAddedSignal("FloatingPen"):Connect(track)
CollectionService:GetInstanceRemovedSignal("FloatingPen"):Connect(untrack)
RunService.RenderStepped:Connect(function() -- line: 69
    -- upvalues: t1 (copy), addSwing (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local CFramePosition = CurrentCamera.CFrame.Position
    local ServerTimeNow = workspace:GetServerTimeNow()

    for v5, v6 in pairs(t1) do
        if v5.Parent then
            local v7 = v5.PrimaryPart or v5:FindFirstChild("Root")

            if v7 then
                if not v6.rest then
                    v6.rest = v7.CFrame
                    v6.phase = (v7.Position.X * 0.37 + v7.Position.Z * 0.61) % 6.283185307179586

                    for _, descendant in ipairs(v5:GetDescendants()) do
                        addSwing(v6, descendant)
                    end

                    v6.added = v5.DescendantAdded:Connect(function(p5) -- line: 89
                        -- upvalues: v6 (copy), addSwing (copy)
                        addSwing(v6, p5)
                    end)
                end

                local v8 = v5:GetAttribute("FloatRange") or 450

                if v5:GetAttribute("Decorated") or v8 < (v6.rest.Position - CFramePosition).Magnitude then
                    if not v6.parked then
                        v5:PivotTo(v6.rest)

                        for _, v9 in ipairs(v6.swings) do
                            if v9.part.Parent then
                                v9.part.CFrame = v6.rest * v9.rel
                            end
                        end

                        v6.parked = true
                    end
                else
                    local v10 = v5:GetAttribute("BobAmplitude") or 0.55
                    local v11 = v5:GetAttribute("BobPeriod") or 6.5
                    local v13 = math.rad(v5:GetAttribute("TiltDegrees") or 1)
                    local v14 = 6.283185307179586 / v11
                    local v15 = v14 * ServerTimeNow + v6.phase
                    local v18 = v10 * (math.sin(v15) * 0.7 + math.sin(v15 * 1.71 + 1.3) * 0.3)
                    local v20 = v13 * math.sin(v15 * 0.83 + 0.7)
                    local v23 = v13 * 0.6 * math.sin(v15 * 1.13 + 2.1)
                    local v24 = v5:GetAttribute("HitDip") or 0
                    local v26 = math.rad(v5:GetAttribute("HitPitch") or 0)
                    local v28 = math.rad(v5:GetAttribute("HitRoll") or 0)
                    local HitPivot = v5:GetAttribute("HitPivot")
                    local v29 = CFrame.Angles(v26, 0, v28)

                    if typeof(HitPivot) == "Vector3" then
                        v29 = CFrame.new(HitPivot) * v29 * CFrame.new(-HitPivot)
                    end

                    local Carry = v5:GetAttribute("Carry")
                    local rest = v6.rest

                    if typeof(Carry) ~= "CFrame" or not Carry then
                        Carry = CFrame.identity
                    end

                    local v30 = rest * Carry * CFrame.new(0, v18 - v24, 0) * v29 * CFrame.Angles(v23, 0, v20)

                    v5:PivotTo(v30)

                    for _, v31 in ipairs(v6.swings) do
                        if v31.part.Parent then
                            local v32 = v15 - v14 * v31.lag
                            local v34 = v13 * math.sin(v32 * 0.83 + 0.7)
                            local v37 = v13 * 0.6 * math.sin(v32 * 1.13 + 2.1)
                            local v40 = v13 * 0.35 * math.sin(ServerTimeNow * 2.3 + v31.seed)
                            local v41 = math.clamp(v28, -0.4363323129985824, 0.4363323129985824)
                            local v42 = math.clamp(v26, -0.4363323129985824, 0.4363323129985824)

                            v31.part.CFrame = v30 * CFrame.new(v31.hinge) * CFrame.Angles(-v37 * v31.gain - v42, 0, -v34 * v31.gain - v41 + v40) * CFrame.new(-v31.hinge) * v31.rel

                            for _, v43 in ipairs(v31.lights) do
                                v43.light.Brightness = v43.base * (math.sin(ServerTimeNow * 17.3 + v31.seed) * 0.07 + 1 + math.sin(ServerTimeNow * 9.1 + 1.7) * 0.05)
                            end
                        end
                    end

                    v6.parked = false
                end
            end
        else
            if v6.added then
                v6.added:Disconnect()
            end

            t1[v5] = nil
        end
    end
end)
