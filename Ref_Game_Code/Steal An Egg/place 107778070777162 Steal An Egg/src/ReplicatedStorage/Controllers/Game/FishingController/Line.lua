-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(120, 255, 175)
local t1 = {}

local function template() -- line: 20
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local GhostDogQuest = Assets and Assets:FindFirstChild("GhostDogQuest")
    local Bobber = GhostDogQuest and GhostDogQuest:FindFirstChild("Bobber")

    return if Bobber ~= nil and Bobber:IsA("Model") then Bobber else nil
end

function t1.Spawn(p1, p2) -- line: 27
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), v1 (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local GhostDogQuest = Assets and Assets:FindFirstChild("GhostDogQuest")
    local Bobber = GhostDogQuest and GhostDogQuest:FindFirstChild("Bobber")

    if Bobber == nil or not Bobber:IsA("Model") then
        Bobber = nil
    end

    if Bobber == nil then
        warn("[Fishing] ReplicatedStorage.Assets.GhostDogQuest.Bobber is missing")

        return nil
    end

    local clone = Bobber:Clone()

    clone.Name = "FishingBobber"

    local function v2() -- line: 35
        -- upvalues: clone (copy)
        clone:ScaleTo(1.1)
    end

    pcall(v2)
    clone:PivotTo(CFrame.new(p2))

    local v3 = clone:FindFirstChild("Line", true)

    if p1 and v3 and v3:IsA("Attachment") then
        local Beam = Instance.new("Beam")

        Beam.Name = "FishingLine"
        Beam.Attachment0 = p1
        Beam.Attachment1 = v3
        Beam.Width0 = 0.07
        Beam.Width1 = 0.07
        Beam.LightEmission = 1
        Beam.FaceCamera = true
        Beam.Segments = 16
        Beam.Color = ColorSequence.new(v1)
        Beam.Parent = clone
    end

    clone.Parent = Workspace

    return clone
end

function t1.Beam(p3) -- line: 57
    local FishingLine = p3:FindFirstChild("FishingLine")

    return if FishingLine ~= nil and FishingLine:IsA("Beam") then FishingLine else nil
end

function t1.Fly(p4, p5, p6, p7, p8) -- line: 62
    -- upvalues: t1 (copy)
    local v5 = math.clamp((p6 - p5).Magnitude * 0.32, 4, 14)
    local v6 = t1.Beam(p4)
    local elapsed = os.clock()

    while p8() and p4.Parent ~= nil do
        local v8 = math.min((os.clock() - elapsed) / p7, 1)
        local v9 = p5:Lerp(p6, v8)
        local v11 = math.sin(v8 * 3.141592653589793) * v5

        p4:PivotTo(CFrame.new(v9 + Vector3.new(0, v11 + v8 * -0.33, 0)))

        if v6 then
            v6.CurveSize0 = (1 - v8) * 3
        end

        if v8 >= 1 then
            break
        end

        task.wait()
    end
end

function t1.Float(p9, p10, p11, p12) -- line: 82
    -- upvalues: t1 (copy)
    local v14 = math.sin(p11 * 3.2) * 0.12

    p12 = p12 or 0
    p9:PivotTo(CFrame.new(p10 + Vector3.new(0, v14 + -0.33 - p12, 0)) * CFrame.Angles(math.sin(p11 * 2.1) * 0.08, 0, math.cos(p11 * 1.7) * 0.08))

    local v21 = t1.Beam(p9)

    if v21 then
        v21.CurveSize0 = 2.5 - math.min(p12, 1) * 2.5
    end
end

function t1.Thrash(p13, p14, p15) -- line: 95
    -- upvalues: t1 (copy)
    local v25 = Vector3.new((math.random() - 0.5) * 0.5 * p15, -0.35 - math.random() * 0.4 * p15, (math.random() - 0.5) * 0.5 * p15)

    p13:PivotTo(CFrame.new(p14 + Vector3.new(0, -0.33, 0) + v25) * CFrame.Angles((math.random() - 0.5) * 0.5, 0, (math.random() - 0.5) * 0.5))

    local v26 = t1.Beam(p13)

    if v26 then
        v26.CurveSize0 = 0
    end
end

function t1.Return(p16, p17, p18) -- line: 111
    -- upvalues: LocalPlayer (copy)
    local Position = p16:GetPivot().Position
    local elapsed = os.clock()

    while p16.Parent ~= nil do
        local v28 = math.min((os.clock() - elapsed) / p18, 1)
        local Character = LocalPlayer.Character
        local v32 = Position:Lerp(if p17 and p17.Parent ~= nil then p17.WorldPosition elseif Character then Character:GetPivot().Position else Position, v28 * v28) + Vector3.new(0, math.sin(v28 * 3.141592653589793) * 2, 0)

        p16:PivotTo(CFrame.new(v32))

        if v28 >= 1 then
            break
        end

        task.wait()
    end
end

return table.freeze(t1)
