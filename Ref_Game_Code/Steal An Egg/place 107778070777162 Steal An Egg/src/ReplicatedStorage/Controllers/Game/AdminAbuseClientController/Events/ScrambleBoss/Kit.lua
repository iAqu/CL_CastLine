-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local ScrambleBoss = ReplicatedStorage.Assets.Sounds:WaitForChild("ScrambleBoss")
local v1 = Color3.fromRGB(80, 255, 60)
local v2 = CameraShaker.new()

CameraShakerDriver.Start(v2, Enum.RenderPriority.Last.Value)

local t1 = {
    Green = v1,
    Red = Color3.fromRGB(255, 50, 50)
}

function t1.Debris() -- line: 31
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("Transient") or Workspace
end

function t1.Anchor(p1, p2) -- line: 35
    -- upvalues: Debris (copy), t1 (copy)
    local Part = Instance.new("Part")

    Part.Name = "ScrambleFx"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)

    if typeof(p1) == "CFrame" then
        Part.CFrame = p1
    else
        Part.CFrame = CFrame.new(p1)
    end

    Part.Parent = t1.Debris()
    Debris:AddItem(Part, p2)

    return Part
end

function t1.Shake(p3, p4, p5) -- line: 52
    -- upvalues: v2 (copy)
    v2:ShakeOnce(p3, p4 or 12, 0.05, p5 or 0.8)
end

function t1.ShakeFrom(p6, p7, p8) -- line: 56
    -- upvalues: Workspace (copy), t1 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    local v4 = math.clamp(1 - (CurrentCamera.CFrame.Position - p6).Magnitude / p8, 0, 1)

    if v4 > 0.05 then
        t1.Shake(p7 * v4, 14, 0.9)
    end
end

function t1.Sound(p9, p10, p11, p12) -- line: 69
    -- upvalues: Debris (copy), SoundService (copy), ScrambleBoss (copy), t1 (copy)
    local v5 = ScrambleBoss:FindFirstChild(p9)

    if v5 == nil then
        return
    end

    local clone = v5:Clone()

    clone.Volume *= p11 or 1
    clone.PlaybackSpeed *= p12 or 1

    if typeof(p10) == "Vector3" then
        clone.Parent = t1.Anchor(p10, math.max(clone.TimeLength, 3) + 1)
    else
        if typeof(p10) == "Instance" then
            clone.Parent = p10
        else
            clone.Parent = SoundService
        end

        Debris:AddItem(clone, math.max(clone.TimeLength, 3) + 1)
    end

    clone:Play()
end

function t1.Loop(p13, p14) -- line: 93
    -- upvalues: ScrambleBoss (copy)
    local v6 = ScrambleBoss:FindFirstChild(p13)

    if v6 == nil then
        return nil, 0
    end

    local clone = v6:Clone()
    local Volume = clone.Volume

    clone.Looped = true
    clone.Volume = 0
    clone.Parent = p14
    clone:Play()

    return clone, Volume
end

function t1.Part(p15) -- line: 109
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Material = Enum.Material.Neon

    for v7, v8 in p15 do
        Part[v7] = v8
    end

    return Part
end

function t1.Flat(p16) -- line: 126
    return (Vector3.new(p16.X, 0, p16.Z))
end

return t1
