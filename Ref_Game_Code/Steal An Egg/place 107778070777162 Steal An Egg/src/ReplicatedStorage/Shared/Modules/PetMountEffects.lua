-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local EmitOnce = require(ReplicatedStorage.UserGenerated.VFX.EmitOnce)
local v1
local t1 = {}

local function findTemplate() -- line: 21
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local VFX = Assets and Assets:FindFirstChild("VFX")
    local MonsterParasite = VFX and VFX:FindFirstChild("MonsterParasite")

    return MonsterParasite and MonsterParasite:FindFirstChild("SwapPoof")
end

local function scaleSize(p1, p2) -- line: 28
    local t2 = {}

    for _, v2 in p1.Keypoints do
        table.insert(t2, NumberSequenceKeypoint.new(v2.Time, v2.Value * p2, v2.Envelope * p2))
    end

    return NumberSequence.new(t2)
end

local function playSound(p3, p4) -- line: 36
    -- upvalues: ReplicatedStorage (copy), v1 (ref)
    task.spawn(function() -- line: 37
        -- upvalues: p3 (copy), p4 (copy), ReplicatedStorage (copy), v1 (ref)
        local function v5() -- line: 38
            -- upvalues: p3 (copy), p4 (copy), ReplicatedStorage (copy), v1 (ref)
            if v1 == nil then
                v1 = require(ReplicatedStorage.Shared.Audio)
            end

            if p3.Parent then
                v1.Play("rbxassetid://102267539121951", p3, {
                    Volume = 0.5,
                    Looped = false,
                    MaxDistance = p4
                })
            end
        end

        pcall(v5)
    end)
end

function t1.Play(p5, p6, p7, p8) -- line: 48
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Debris (copy), EmitOnce (copy), v1 (ref), scaleSize (copy)
    if not RunService:IsClient() then
        return false
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera and not (p7 < (CurrentCamera.CFrame.Position - p5.Position).Magnitude) then
        local v6 = math.max(p6.X, p6.Y, p6.Z)
        local VFX, v7

        if v6 <= 0 then
            v7 = true
        elseif v6 ~= v6 or v6 == 1e999 then
            v7 = true
        else
            local Assets = ReplicatedStorage:FindFirstChild("Assets")

            VFX = Assets and Assets:FindFirstChild("VFX")
            v7 = false
        end

        if v7 then
            return false
        end

        local MonsterParasite = VFX and VFX:FindFirstChild("MonsterParasite")
        local SwapPoof = MonsterParasite and MonsterParasite:FindFirstChild("SwapPoof")

        if SwapPoof then
            local Part = Instance.new("Part")

            Part.Name = "PetMountPoof"
            Part.Size = Vector3.new(0.1, 0.1, 0.1)
            Part.Transparency = 1
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.CFrame = p5
            Part.Parent = workspace:FindFirstChild("Transient") or workspace
            Debris:AddItem(Part, 2)

            local function v9() -- line: 70
                -- upvalues: v6 (copy), SwapPoof (copy), Part (copy), EmitOnce (copy), scaleSize (copy)
                local Attachment = Instance.new("Attachment")

                Attachment.Parent = Part

                local v11 = math.clamp(v6 / 8.4, 0.7, 2.2)
                local n1 = 0

                for _, descendant in SwapPoof:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        local v12 = descendant:GetAttribute("EmitDelay") or 0

                        if not (descendant.TimeScale <= 0) and typeof(v12) == "number" and not (v12 < 0 or v12 + descendant.Lifetime.Max / descendant.TimeScale > 1.9) then
                            local clone = descendant:Clone()

                            clone.Enabled = false
                            clone.Size = scaleSize(clone.Size, v11)
                            clone.Speed = NumberRange.new(clone.Speed.Min * v11, clone.Speed.Max * v11)
                            clone.Acceleration *= v11
                            clone.ZOffset *= v11
                            clone.Parent = Attachment

                            if EmitOnce(clone) > 0 then
                                n1 += 1
                            end
                        end
                    end
                end

                return n1 > 0
            end

            local ok, result = pcall(v9)

            if ok and result then
                if p8 then
                    task.spawn(function() -- line: 37
                        -- upvalues: p7 (copy), Part (copy), ReplicatedStorage (copy), v1 (ref)
                        local function v13() -- line: 38
                            -- upvalues: p7 (copy), Part (copy), ReplicatedStorage (copy), v1 (ref)
                            if v1 == nil then
                                v1 = require(ReplicatedStorage.Shared.Audio)
                            end

                            if Part.Parent then
                                v1.Play("rbxassetid://102267539121951", Part, {
                                    Volume = 0.5,
                                    Looped = false,
                                    MaxDistance = p7
                                })
                            end
                        end

                        pcall(v13)
                    end)
                end

                return true
            end

            Part:Destroy()
        end
    end

    return false
end

return t1
