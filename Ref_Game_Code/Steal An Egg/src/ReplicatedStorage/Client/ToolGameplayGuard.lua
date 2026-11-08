-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Player = require(ReplicatedStorage.Shared.Player)
local PointInBox = require(ReplicatedStorage.Shared.Utils.PointInBox)
local v1 = Color3.fromRGB(255, 70, 70)
local RodAttribute = GhostDogQuest.RodAttribute
local SAFE_ZONE = Constants.TAGS_MAP.Gameplay.SAFE_ZONE
local Inside = HalloweenDimension.PlayerAttributes.Inside
local LocalPlayer = Players.LocalPlayer
local World = Workspace.World

assert(World:IsA("Folder"), "expected a Folder at Workspace.World")

local Areas = World.Areas

assert(Areas:IsA("Folder"), "expected a Folder at Workspace.World.Areas")

local SeparationLine = Areas.SeparationLine

assert(SeparationLine:IsA("BasePart"), "expected a BasePart at Workspace.World.Areas.SeparationLine")

local t1 = {}

local function footPosition(p1) -- line: 44
    -- upvalues: Player (copy)
    local v2 = Player.FindRootPart(p1)

    return if v2 ~= nil and v2:IsA("BasePart") then v2.Position else nil
end

local function isGear(p2) -- line: 51
    -- upvalues: RodAttribute (copy)
    if p2 ~= nil and p2:GetAttribute(RodAttribute) == true then
        return false
    end

    if p2 == nil then
        return true
    end

    return typeof(p2:GetAttribute("GearName")) == "string"
end

local function isObbying(p3) -- line: 58
    -- upvalues: Workspace (copy)
    if not Workspace:GetAttribute("Event_MonsterEvent") then
        return false
    end

    local Character = p3.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        return HumanoidRootPart.Position.Z > -268
    end

    return false
end

local function refuse() -- line: 72
    -- upvalues: Toast (copy), v1 (copy)
    Toast.Show({
        Text = "Cannot use items in the safe zone!",
        Seconds = 2,
        Unique = true,
        Color = v1
    })
end

function t1.IsInsideArena(p4) -- line: 81
    -- upvalues: GuardAreaGeometry (copy), Player (copy), Inside (copy), SeparationLine (copy)
    local v3 = Player.FindRootPart(p4)
    local Position = if v3 == nil or not v3:IsA("BasePart") then nil else v3.Position

    if Position == nil then
        return false
    end

    if p4:GetAttribute(Inside) == true then
        return true
    end

    return (GuardAreaGeometry.IsPastLine(SeparationLine, Position))
end

function t1.IsLocalInsideArena() -- line: 91
    -- upvalues: LocalPlayer (copy), t1 (copy)
    return t1.IsInsideArena(LocalPlayer)
end

function t1.IsInsideSafeZone(p5) -- line: 95
    -- upvalues: CollectionService (copy), Workspace (copy), Player (copy), PointInBox (copy), SAFE_ZONE (copy)
    local v4 = Player.FindRootPart(p5)
    local Position = if v4 == nil or not v4:IsA("BasePart") then nil else v4.Position
    local v5 = if Position == nil then {} else CollectionService:GetTagged(SAFE_ZONE)
    local n1 = 1

    repeat
        if not (n1 <= #v5) then
            return false
        end

        local v6 = v5[n1]

        n1 += 1
    until v6:IsA("BasePart") and v6:IsDescendantOf(Workspace) and PointInBox(v6.CFrame, v6.Size, Position)

    return true
end

function t1.AllowsLocalUse(p6) -- line: 114
    -- upvalues: Workspace (copy), Toast (copy), v1 (copy), RodAttribute (copy), LocalPlayer (copy), t1 (copy)
    if LocalPlayer:GetAttribute("InBossArena") or LocalPlayer:GetAttribute("InScrambleArena") or LocalPlayer:GetAttribute("InPumpkinArena") then
        return true
    end

    local v7 = not (p6 == nil or p6:GetAttribute(RodAttribute) ~= true and (p6 == nil or typeof(p6:GetAttribute("GearName")) == "string")) or t1.IsLocalInsideArena() and not t1.IsInsideSafeZone(LocalPlayer)

    if not v7 then
        Toast.Show({
            Text = "Cannot use items in the safe zone!",
            Seconds = 2,
            Unique = true,
            Color = v1
        })
    end

    if Workspace:GetAttribute("Event_MonsterEvent") then
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart and HumanoidRootPart.Position.Z > -268 then
            v7 = false
            Toast.Show({
                Text = "Cannot use items in the safe zone!",
                Seconds = 2,
                Unique = true,
                Color = v1
            })
        end
    end

    return v7
end

return t1
