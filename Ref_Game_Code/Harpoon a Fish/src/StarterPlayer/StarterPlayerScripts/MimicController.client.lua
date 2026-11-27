-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local VFXBurst = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("VFXBurst"))
local GrowthDisplay = require(ReplicatedStorage.Modules:WaitForChild("GrowthDisplay"))
local MimicConfig = require(ReplicatedStorage.Modules:WaitForChild("MimicConfig"))
local FeedBurst = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("FeedBurst")
local GrowBurst = ReplicatedStorage.VFX:WaitForChild("GrowBurst")
local Mimics = workspace:WaitForChild("Mimics")
local _ = {
    SPEED = 17.5,
    MARGIN = 4,
    HEIGHT = 0.35,
    RANGE = 500
}
local v1 = CFrame.Angles(-1.5707963267948966, 0, 0)
local t1 = {
    REF = 30,
    SOUND = "rbxassetid://129840040992692"
}
local _ = {
    REF = 12,
    MIN = 0.5,
    MAX = 40,
    SOUND = "rbxassetid://2789427964"
}

local function playSound(p1, p2) -- line: 32
    -- upvalues: Debris (copy)
    local Sound = Instance.new("Sound")

    Sound.SoundId = p1
    Sound.Parent = p2
    Sound:Play()
    Debris:AddItem(Sound, 10)
end

local function bodyLength(p3) -- line: 39
    local ExtentsSize = p3:GetExtentsSize()

    return (math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1))
end

local function feedBurst(p4) -- line: 43
    -- upvalues: Debris (copy), VFXBurst (copy), FeedBurst (copy)
    local PrimaryPart = p4.PrimaryPart

    if not PrimaryPart then
        return
    end

    local Play = VFXBurst.Play
    local v2 = CFrame.new(PrimaryPart.Position)
    local ExtentsSize = p4:GetExtentsSize()

    Play(FeedBurst, v2, math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1) / 30)

    local Sound = Instance.new("Sound")

    Sound.SoundId = "rbxassetid://129840040992692"
    Sound.Parent = PrimaryPart
    Sound:Play()
    Debris:AddItem(Sound, 10)
end

local function growBurst(p5) -- line: 49
    -- upvalues: Debris (copy), VFXBurst (copy), GrowthDisplay (copy), GrowBurst (copy)
    local PrimaryPart = p5.PrimaryPart

    if not PrimaryPart then
        return
    end

    local v3 = p5:GetAttribute("Stage") or 1
    local v4 = GrowthDisplay.gradients[v3] or ColorSequence.new(GrowthDisplay.colors[v3] or Color3.new(1, 1, 1))
    local Play = VFXBurst.Play
    local v5 = CFrame.new(PrimaryPart.Position)
    local ExtentsSize = p5:GetExtentsSize()

    Play(GrowBurst, v5, math.clamp(math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1) / 12, 0.5, 40), v4)

    if p5:GetAttribute("PenOwner") ~= game:GetService("Players").LocalPlayer.UserId then
        return
    end

    local Sound = Instance.new("Sound")

    Sound.SoundId = "rbxassetid://2789427964"
    Sound.Parent = PrimaryPart
    Sound:Play()
    Debris:AddItem(Sound, 10)
end

local t2 = {}

local function add(p6) -- line: 60
    -- upvalues: Debris (copy), VFXBurst (copy), FeedBurst (copy), t1 (copy), growBurst (copy), t2 (copy)
    t2[p6] = true
    p6:GetAttributeChangedSignal("FedN"):Connect(function() -- line: 62
        -- upvalues: p6 (copy), Debris (copy), VFXBurst (copy), FeedBurst (copy), t1 (copy)
        local PrimaryPart = p6.PrimaryPart

        if not PrimaryPart then
            return
        end

        local Play = VFXBurst.Play
        local v7 = CFrame.new(PrimaryPart.Position)
        local ExtentsSize = p6:GetExtentsSize()

        Play(FeedBurst, v7, math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1) / t1.REF)

        local SOUND = t1.SOUND
        local Sound = Instance.new("Sound")

        Sound.SoundId = SOUND
        Sound.Parent = PrimaryPart
        Sound:Play()
        Debris:AddItem(Sound, 10)
    end)
    p6:GetAttributeChangedSignal("GrownN"):Connect(function() -- line: 63
        -- upvalues: p6 (copy), growBurst (copy)
        growBurst(p6)
    end)
end

for _, child in ipairs(Mimics:GetChildren()) do
    add(child)
end

Mimics.ChildAdded:Connect(add)
Mimics.ChildRemoved:Connect(function(p7) -- line: 67
    -- upvalues: t2 (copy)
    t2[p7] = nil
end)
RunService.RenderStepped:Connect(function() -- line: 69
    -- upvalues: MimicConfig (copy), v1 (copy), t2 (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()
    local CFramePosition = workspace.CurrentCamera.CFrame.Position

    for v8 in pairs(t2) do
        local PrimaryPart = v8.PrimaryPart
        local WaterCF = v8:GetAttribute("WaterCF")
        local WaterHalf = v8:GetAttribute("WaterHalf")

        if PrimaryPart and typeof(WaterCF) == "CFrame" and typeof(WaterHalf) == "Vector3" and (WaterCF.Position - CFramePosition).Magnitude < 500 then
            local v9 = 4 * (v8:GetAttribute("Size") or 1) * MimicConfig.SCALE
            local v11 = math.max(1, WaterHalf.X - v9)
            local v13 = math.max(0.5, (WaterHalf.Y - v9) * 0.35)
            local v15 = math.max(1, WaterHalf.Z - v9)
            local v16 = (v8:GetAttribute("BagId") or 0) % 97
            local v17 = ServerTimeNow * 17.5 / math.max(v11, v15) + v16
            local v23 = Vector3.new(math.sin(v17) * v11, math.sin(v17 * 0.7 + v16) * v13, math.sin(v17 * 0.5 + v16 * 2) * v15)
            local v29 = Vector3.new(math.cos(v17) * v11, math.cos(v17 * 0.7 + v16) * 0.7 * v13, math.cos(v17 * 0.5 + v16 * 2) * 0.5 * v15)
            local v30 = WaterCF:PointToWorldSpace(v23)
            local v31 = WaterCF:VectorToWorldSpace(v29)

            if v31.Magnitude > 0.001 then
                PrimaryPart.CFrame = CFrame.lookAt(v30, v30 + v31.Unit) * v1
            end
        end
    end
end)
