-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local Mushrooms = require(script.Parent.Mushrooms)
local v1 = Color3.fromRGB(130, 130, 125)
local self = setmetatable({}, {
    __mode = "k"
})
local t3 = {}

local function fade(p1) -- line: 40
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, p1),
        NumberSequenceKeypoint.new(1, 1)
    })
end

local function shrink(p2, p3) -- line: 47
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, p2),
        NumberSequenceKeypoint.new(1, p3)
    })
end

local function sporeEmitter(p4) -- line: 54
    -- upvalues: BanjoCricket (copy), fade (copy), shrink (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Spores"
    ParticleEmitter.Texture = BanjoCricket.Textures.Spore
    ParticleEmitter.Rate = 0
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.1)
    ParticleEmitter.Speed = NumberRange.new(5, 9)
    ParticleEmitter.SpreadAngle = Vector2.new(55, 55)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Drag = 3
    ParticleEmitter.Acceleration = Vector3.new(0, 2, 0)
    ParticleEmitter.Size = shrink(0.45, 0)
    ParticleEmitter.Transparency = fade(0)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.Parent = p4

    return ParticleEmitter
end

local function wiltEmitter(p5) -- line: 73
    -- upvalues: BanjoCricket (copy), v1 (copy), fade (copy), shrink (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Wilt"
    ParticleEmitter.Texture = BanjoCricket.Textures.Spore
    ParticleEmitter.Rate = 0
    ParticleEmitter.Color = ColorSequence.new(v1)
    ParticleEmitter.Lifetime = NumberRange.new(0.7, 1.1)
    ParticleEmitter.Speed = NumberRange.new(2, 4)
    ParticleEmitter.SpreadAngle = Vector2.new(80, 80)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Drag = 2
    ParticleEmitter.Acceleration = Vector3.new(0, -10, 0)
    ParticleEmitter.Size = shrink(0.35, 0.1)
    ParticleEmitter.Transparency = fade(0.2)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.Parent = p5

    return ParticleEmitter
end

local function noteEmitter(p6) -- line: 92
    -- upvalues: BanjoCricket (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Note"
    ParticleEmitter.Texture = BanjoCricket.Textures.Note
    ParticleEmitter.Rate = 0
    ParticleEmitter.Lifetime = NumberRange.new(1.2, 1.5)
    ParticleEmitter.Speed = NumberRange.new(3, 4)
    ParticleEmitter.SpreadAngle = Vector2.new(12, 12)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Drag = 1
    ParticleEmitter.Acceleration = Vector3.new(0, 1, 0)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 1.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.6, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.LightEmission = 0.4
    ParticleEmitter.Rotation = NumberRange.new(-15, 15)
    ParticleEmitter.RotSpeed = NumberRange.new(-20, 20)
    ParticleEmitter.Parent = p6

    return ParticleEmitter
end

local function topOf(p7) -- line: 120
    return p7.Position + Vector3.new(0, 1, 0) * p7.Size.Y / 2
end

local function emittersFor(p8) -- line: 126
    -- upvalues: Workspace (copy), self (copy), sporeEmitter (copy), wiltEmitter (copy), noteEmitter (copy)
    local v3 = self[p8]

    if v3 then
        v3.Attachment.WorldPosition = p8.Position + Vector3.new(0, 1, 0) * p8.Size.Y / 2

        return v3
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "BanjoCricketSpores"
    Attachment.Parent = Workspace.Terrain
    Attachment.WorldPosition = p8.Position + Vector3.new(0, 1, 0) * p8.Size.Y / 2
    p8.Destroying:Once(function() -- line: 136
        -- upvalues: Attachment (copy)
        Attachment:Destroy()
    end)

    local t4 = {
        Attachment = Attachment,
        Spores = sporeEmitter(Attachment),
        Wilt = wiltEmitter(Attachment),
        Note = noteEmitter(Attachment)
    }

    self[p8] = t4

    return t4
end

local function isVisible(p9) -- line: 149
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    return CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - p9).Magnitude <= 160
end

function t3.Puff(p10) -- line: 155
    -- upvalues: Workspace (copy), BanjoCricket (copy), Mushrooms (copy), emittersFor (copy)
    local v4 = Mushrooms.Anchor(p10)
    local v5 = BanjoCricket.Mushrooms[p10]

    if v4 == nil or v5 == nil then
        return
    end

    local Position = v4.Position
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - Position).Magnitude <= 160 then
        local v6 = emittersFor(v4)
        local v7 = ColorSequence.new(v5.Color)

        v6.Spores.Color = v7
        v6.Spores:Emit(14)
        v6.Note.Color = v7
        v6.Note:Emit(1)
    end
end

function t3.Wilt() -- line: 169
    -- upvalues: Workspace (copy), BanjoCricket (copy), Mushrooms (copy), emittersFor (copy)
    for v8 in BanjoCricket.Mushrooms do
        local v9 = Mushrooms.Anchor(v8)

        if v9 then
            local Position = v9.Position
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - Position).Magnitude <= 160 then
                emittersFor(v9).Wilt:Emit(10)
            end
        end
    end
end

function t3.Spiral() -- line: 179
    -- upvalues: RunService (copy), Workspace (copy), BanjoCricket (copy), Mushrooms (copy), sporeEmitter (copy)
    local t5 = {}
    local t6 = {}

    for v10, v11 in BanjoCricket.Mushrooms do
        local v12 = Mushrooms.Anchor(v10)

        if v12 then
            table.insert(t5, v12.Position + Vector3.new(0, 1, 0) * v12.Size.Y / 2)
            table.insert(t6, v11.Color)
        end
    end

    if #t5 < 2 then
        return
    end

    local v14 = t5[1]
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - v14).Magnitude <= 160 then
        local Part = Instance.new("Part")

        Part.Name = "BanjoCricketSpiral"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Transparency = 1
        Part.Size = Vector3.new(0.2, 0.2, 0.2)
        Part.CFrame = CFrame.new(t5[1])

        local Attachment = Instance.new("Attachment")

        Attachment.Parent = Part

        local v15 = sporeEmitter(Attachment)

        v15.Rate = 90
        v15.Speed = NumberRange.new(0.5, 1.5)
        v15.Lifetime = NumberRange.new(0.5, 0.8)
        Part.Parent = Workspace

        local elapsed = os.clock()
        local connection

        connection = RunService.PreRender:Connect(function() -- line: 210
            -- upvalues: t5 (copy), t6 (copy), Part (copy), v15 (copy), elapsed (copy), connection (ref)
            local v17 = math.min((os.clock() - elapsed) / 1.1, 1)
            local v18 = v17 * (#t5 - 1)
            local v21 = math.min(math.floor(v18) + 1, #t5 - 1)
            local v22 = v18 - (v21 - 1)
            local v23 = v17 * 5 * 3.141592653589793 * 2
            local v24 = t5[v21]:Lerp(t5[v21 + 1], v22)

            Part.CFrame = CFrame.new(v24 + Vector3.new(math.cos(v23) * 1.6, math.sin(v17 * 3.141592653589793) * 3, math.sin(v23) * 1.6))
            v15.Color = ColorSequence.new(t6[v21]:Lerp(t6[v21 + 1], v22))

            if not (v17 >= 1) then
                return
            end

            connection:Disconnect()
            v15.Enabled = false
            task.delay(1, function() -- line: 230
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end)
    end
end

return table.freeze(t3)
