-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local RunHit = require(script.Parent.RunHit)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Target = HalloweenDimension.Ghosts.Target
local v1 = Color3.fromRGB(120, 255, 160)
local t1 = {
    ExposureCompensation = 0,
    ColorCorrection = {
        Saturation = -0.3,
        Contrast = 0.12,
        Brightness = 0.03,
        Enabled = true,
        TintColor = Color3.fromRGB(222, 204, 255)
    },
    Atmosphere = {
        Density = 0.5,
        Haze = 2.6,
        Glare = 0,
        Offset = 0,
        Color = Color3.fromRGB(96, 64, 128),
        Decay = Color3.fromRGB(52, 28, 70)
    }
}
local t2 = {}

t2.__index = t2

local function flatDistance(p1, p2) -- line: 86
    return Vector2.new(p1.X - p2.X, p1.Z - p2.Z).Magnitude
end

local function easeOut(p3) -- line: 90
    return 1 - (1 - p3) ^ 3
end

local function rootPart() -- line: 94
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function safeDistance(p4, p5) -- line: 100
    local v2 = p4.CFrame:PointToObjectSpace(p5)
    local v3 = p4.Size * 0.5
    local v5 = math.max(math.abs(v2.X) - v3.X, 0)
    local v7 = math.max(math.abs(v2.Z) - v3.Z, 0)

    return (math.sqrt(v5 * v5 + v7 * v7))
end

local function findGhost(p6) -- line: 108
    -- upvalues: LocalPlayer (copy), Target (copy)
    local Ghost = p6.Ghost

    if Ghost ~= nil and Ghost:GetAttribute(Target) == LocalPlayer.UserId then
        return Ghost
    end

    p6.Ghost = nil

    for _, child in p6.Ghosts:GetChildren() do
        if child:IsA("Model") and child:GetAttribute(Target) == LocalPlayer.UserId then
            p6.Ghost = child

            return child
        end
    end

    return nil
end

local function update(p7, p8) -- line: 123
    -- upvalues: LocalPlayer (copy), findGhost (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
        HumanoidRootPart = nil
    end

    if HumanoidRootPart == nil then
        return
    end

    local v9 = findGhost(p7)
    local v10 = 0

    if v9 ~= nil then
        local Position = v9:GetPivot().Position
        local Position2 = HumanoidRootPart.Position

        v10 = math.clamp(1 - Vector2.new(Position.X - Position2.X, Position.Z - Position2.Z).Magnitude / 90, 0, 1)
    end

    p7.Danger = p7.Danger + (v10 - p7.Danger) * math.min(p8 * 6, 1)

    local Danger2, Ui = p7.Danger, p7.Ui

    Ui.Vignette.ImageTransparency = 1 - Danger2 * 0.5

    local Distance = Ui.Distance
    local SafeZone = p7.SafeZone
    local Position = HumanoidRootPart.Position
    local v14 = SafeZone.CFrame:PointToObjectSpace(Position)
    local v15 = SafeZone.Size * 0.5
    local v17 = math.max(math.abs(v14.X) - v15.X, 0)
    local v19 = math.max(math.abs(v14.Z) - v15.Z, 0)

    Distance.Text = ("%* studs to safety"):format((math.floor((math.sqrt(v17 * v17 + v19 * v19)))))

    local Near = p7.Near

    if Near ~= nil then
        Near.Volume = (Danger2 * 0.88 + 0.12) * 0.75
    end
end

function t2.new(p9, p10, p11, p12) -- line: 150
    -- upvalues: RunService (copy), Audio (copy), HalloweenDimension (copy), LightingController (copy), RunHit (copy), Trove (copy), t1 (copy), t2 (copy), update (copy)
    local Zones = p9:FindFirstChild("Zones")
    local SafeZone = if Zones == nil then nil else Zones:FindFirstChild("SafeZone")
    local v22 = p9:FindFirstChild(HalloweenDimension.Ghosts.Folder)

    assert(SafeZone ~= nil and SafeZone:IsA("BasePart"), "Halloween map is missing Zones.SafeZone")
    assert(v22 ~= nil, (("Halloween map is missing %*"):format(HalloweenDimension.Ghosts.Folder)))

    local v26 = Trove.new()
    local v27 = v26:Extend()
    local t3 = {
        Ghost = nil,
        Near = nil,
        Danger = 0,
        Finished = false,
        SafeZone = SafeZone,
        Ghosts = v22,
        Ui = p10,
        Alert = p11,
        Beacon = p12,
        Trove = v26,
        Live = v27
    }

    p10.Chase.Visible = true

    if p12 ~= nil then
        p12.Enabled = true
    end

    LightingController.SetLayer("HalloweenGhostChase", t1, 170, 0.35)

    local ChaseParent = p10.Chase.Parent
    local RunHit2 = if ChaseParent == nil then nil else ChaseParent:FindFirstChild("RunHit")

    RunHit.Play(RunHit2, v27, p10.Chase)
    Audio.Play("rbxassetid://92254600060653", script, {
        Volume = 0.7
    })

    local v28 = Audio.Play("rbxassetid://113016224604939", script, {
        Looped = true,
        Volume = 0
    })

    if v28 ~= nil then
        t3.Near = v28
        v26:Add(v28)
    end

    v27:Connect(RunService.RenderStepped, function(p13) -- line: 188
        -- upvalues: t3 (copy), update (copy)
        update(t3, p13)
    end)
    update(t3, 0)

    return (setmetatable(t3, t2))
end

function t2.Finish(p14, p15) -- line: 196
    -- upvalues: RunService (copy), TweenService (copy), Audio (copy), LightingController (copy), v1 (copy)
    if p14.Finished then
        return
    end

    p14.Finished = true
    p14.Live:Destroy()

    local Ui = p14.Ui

    Ui.Chase.Visible = false

    if p14.Beacon ~= nil then
        p14.Beacon.Enabled = false
    end

    LightingController.ClearLayer("HalloweenGhostChase", 0.6)
    TweenService:Create(Ui.Vignette, TweenInfo.new(0.6), {
        ImageTransparency = 1
    }):Play()

    if p15 then
        p14.Alert("EGG SECURED!", v1, 2)
        Audio.Play("rbxassetid://115572591755603", script, {
            Volume = 0.6
        })
        Audio.Play("rbxassetid://71759553024274", script, {
            Volume = 0.45,
            PlaybackSpeed = 1.1
        })
    end

    local Near = p14.Near
    local v29 = if Near == nil then 0 else Near.Volume
    local elapsed = os.clock()

    p14.Trove:Connect(RunService.RenderStepped, function() -- line: 220
        -- upvalues: p14 (copy), Near (copy), elapsed (copy), v29 (copy)
        local v31 = math.clamp((os.clock() - elapsed) / 0.9, 0, 1)

        if Near ~= nil then
            Near.Volume = v29 * (1 - (1 - (1 - v31) ^ 3))
        end

        if v31 >= 1 then
            p14.Trove:Destroy()
        end
    end)
end

function t2.Destroy(p16) -- line: 231
    -- upvalues: LightingController (copy)
    p16.Finished = true
    p16.Trove:Destroy()
    LightingController.ClearLayer("HalloweenGhostChase", 0.6)
    p16.Ui.Chase.Visible = false
    p16.Ui.Vignette.ImageTransparency = 1

    if p16.Beacon ~= nil then
        p16.Beacon.Enabled = false
    end
end

return t2
