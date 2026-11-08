-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local t1 = {}

function t1.Folder() -- line: 19
    -- upvalues: Workspace (copy)
    local RedLightGreenLightFx = Workspace:FindFirstChild("RedLightGreenLightFx")

    if RedLightGreenLightFx ~= nil and RedLightGreenLightFx:IsA("Folder") then
        return RedLightGreenLightFx
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "RedLightGreenLightFx"
    Folder.Parent = Workspace

    return Folder
end

function t1.Resolve(p1) -- line: 34
    -- upvalues: ReplicatedStorage (copy)
    local v1 = ReplicatedStorage.Assets

    for _, v2 in p1 do
        if v1 == nil then
            return nil
        end

        v1 = v1:FindFirstChild(v2)
    end

    return v1
end

function t1.Holder(p2, p3) -- line: 48
    -- upvalues: t1 (copy)
    local Part = Instance.new("Part")

    Part.Name = p3 or "Holder"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p2)
    Part.Parent = t1.Folder()

    return Part
end

function t1.Sound(p4, p5, p6, p7, p8) -- line: 65
    -- upvalues: Debris (copy), SoundService (copy), t1 (copy)
    local v3 = t1.Resolve(p4)
    local clone, TimeLength, v4, v5

    if v3 ~= nil then
        if v3:IsA("Sound") then
            clone = v3:Clone()
            TimeLength = clone.TimeLength
            clone.Volume *= p6 or 1
            v4 = p7 or clone.PlaybackSpeed
            v5 = false
        else
            v5 = true
        end
    else
        v5 = true
    end

    if v5 then
        return nil
    end

    clone.PlaybackSpeed = v4
    clone.Looped = false

    if typeof(p5) == "Vector3" then
        local Sound = t1.Holder(p5, "Sound")

        clone.RollOffMaxDistance = p8 or 900
        clone.Parent = Sound
        Debris:AddItem(Sound, math.max(TimeLength, 2) + 1)
    else
        if typeof(p5) == "Instance" then
            clone.RollOffMaxDistance = p8 or 900
            clone.Parent = p5
        else
            clone.Parent = SoundService
        end

        Debris:AddItem(clone, math.max(TimeLength, 2) + 1)
    end

    clone:Play()

    return clone
end

function t1.ScaleEmitter(p9, p10) -- line: 105
    local t2 = {}

    for _, v6 in p9.Size.Keypoints do
        table.insert(t2, NumberSequenceKeypoint.new(v6.Time, v6.Value * p10, v6.Envelope * p10))
    end

    p9.Size = NumberSequence.new(t2)
    p9.Speed = NumberRange.new(p9.Speed.Min * p10, p9.Speed.Max * p10)
    p9.Acceleration *= p10
end

function t1.Scale(p11, p12) -- line: 124
    -- upvalues: t1 (copy)
    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            t1.ScaleEmitter(descendant, p12)
        elseif descendant:IsA("Beam") then
            descendant.Width0 *= p12
            descendant.Width1 *= p12
        elseif descendant:IsA("PointLight") then
            descendant.Range = math.min(descendant.Range * p12, 60)
        end
    end
end

function t1.Burst(p13, p14) -- line: 137
    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDelay = descendant:GetAttribute("EmitDelay")

            if type(EmitCount) ~= "number" then
                EmitCount = 6
            end

            local v12 = math.max(math.round(EmitCount * (p14 or 1)), 1)

            descendant.Enabled = false

            if type(EmitDelay) == "number" and EmitDelay > 0 then
                task.delay(EmitDelay, function() -- line: 153
                    -- upvalues: descendant (copy), v12 (copy)
                    if descendant.Parent ~= nil then
                        descendant:Emit(v12)
                    end
                end)
            else
                descendant:Emit(v12)
            end
        end
    end
end

function t1.SetEmitting(p15, p16) -- line: 164
    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p16
        end
    end
end

function t1.Tint(p17, p18) -- line: 172
    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
            descendant.Color = p18
        end
    end
end

return table.freeze(t1)
