-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local FishingFlags = require(ReplicatedStorage.Shared.Flags.FishingFlags)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local t1 = {
    WaterTag = "FishingWater",
    FlightSeconds = 0.75,
    RodAttribute = GhostDogQuest.RodAttribute,
    Messages = table.freeze({
        Miss = "Cast into the water!",
        Nothing = "Nothing's biting...",
        Escaped = "It got away...",
        Hint = "Cast at the glowing ripples off the end of the pier!",
        Busy = "Hold on...",
        Closed = "Fishing is closed right now.",
        Dimension = "Fish inside the Halloween dimension!"
    })
}

function t1.ChargeAt(p1) -- line: 65
    -- upvalues: FishingFlags (copy)
    local v1 = FishingFlags.ChargeSeconds:Get()
    local v2 = math.max(p1, 0) / v1 % 2

    if not (v2 <= 1) then
        v2 = 2 - v2
    end

    return math.clamp(v2, 0, 1) ^ 1.4
end

function t1.IsPerfect(p2) -- line: 72
    -- upvalues: FishingFlags (copy)
    if FishingFlags.PerfectMin:Get() <= p2 then
        return p2 <= FishingFlags.PerfectMax:Get()
    end

    return false
end

function t1.LuckFor(p3) -- line: 76
    -- upvalues: FishingFlags (copy), t1 (copy)
    if t1.IsPerfect(p3) then
        return FishingFlags.PerfectLuck:Get()
    end

    return 1 + (FishingFlags.ChargeLuck:Get() - 1) * math.clamp(p3, 0, 1)
end

function t1.LuckText(p4) -- line: 83
    local v4 = math.floor(p4 * 10 + 0.5) / 10

    if v4 % 1 == 0 then
        return (("x%*"):format((string.format("%d", v4))))
    end

    return (("x%*"):format((string.format("%.1f", v4))))
end

function t1.DistanceFor(p5) -- line: 91
    -- upvalues: FishingFlags (copy)
    local v5 = FishingFlags.MinCastDistance:Get()

    return v5 + (math.max(FishingFlags.MaxCastDistance:Get(), v5) - v5) * math.clamp(p5, 0, 1)
end

function t1.IsRod(p6) -- line: 97
    -- upvalues: GhostDogQuest (copy)
    return p6 ~= nil and p6:IsA("Tool") and p6:GetAttribute(GhostDogQuest.RodAttribute) == true
end

function t1.EquippedRod(p7) -- line: 103
    -- upvalues: t1 (copy)
    if p7 == nil then
        return nil
    end

    for _, child in p7:GetChildren() do
        if t1.IsRod(child) then
            return child
        end
    end

    return nil
end

function t1.QuestMarkers() -- line: 115
    -- upvalues: Workspace (copy), GhostDogQuest (copy), HalloweenDimension (copy)
    local v7 = Workspace:FindFirstChild(HalloweenDimension.MapName)
    local v8 = v7 and v7:FindFirstChild(GhostDogQuest.FolderName)
    local v9 = v8 and v8:FindFirstChild(GhostDogQuest.MarkersName)

    return if v9 ~= nil and v9:IsA("Folder") then v9 else nil
end

function t1.QuestPoint(p8) -- line: 122
    -- upvalues: t1 (copy)
    local v10 = t1.QuestMarkers()
    local v11 = v10 and v10:FindFirstChild(p8)

    return if v11 ~= nil and v11:IsA("BasePart") then v11.Position else nil
end

function t1.FlatDistance(p9, p10) -- line: 128
    return Vector3.new(p9.X - p10.X, 0, p9.Z - p10.Z).Magnitude
end

function t1.NearQuestTarget(p11) -- line: 132
    -- upvalues: FishingFlags (copy), t1 (copy)
    local CastTarget = t1.QuestPoint("CastTarget")

    if CastTarget == nil or not (t1.FlatDistance(p11, CastTarget) <= FishingFlags.QuestRadius:Get()) then
        return false
    end

    return math.abs(p11.Y - CastTarget.Y) <= 24
end

function t1.IsWaterHit(p12) -- line: 139
    -- upvalues: CollectionService (copy)
    if p12.Material == Enum.Material.Water then
        return true
    end

    local Instance = p12.Instance

    if Instance:GetAttribute("TerrainRole") == "Basin" or Instance:GetAttribute("FishingWater") == true then
        return true
    end

    return (CollectionService:HasTag(Instance, "FishingWater"))
end

function t1.Probe(p13, p14) -- line: 149
    -- upvalues: Workspace (copy), t1 (copy)
    local v15 = table.clone(p14)
    local v16 = RaycastParams.new()

    v16.FilterType = Enum.RaycastFilterType.Exclude
    v16.IgnoreWater = false
    v16.FilterDescendantsInstances = v15

    local CastTarget = t1.QuestPoint("CastTarget")
    local v17 = CastTarget ~= nil and t1.NearQuestTarget(p13)
    local v18 = p13 + Vector3.new(0, 40, 0)
    local v19 = false

    for _ = 1, 16 do
        local v20 = Workspace:Raycast(v18, Vector3.new(0, -180, 0), v16)

        if v20 == nil then
            break
        end

        if t1.IsWaterHit(v20) then
            return {
                Water = true,
                Point = v20.Position
            }
        end

        local Instance = v20.Instance

        if not (Instance:IsA("BasePart") and Instance.Transparency >= 0.95) then
            if not Instance:IsA("BasePart") or Instance:IsA("Terrain") or not (v20.Position.Y > p13.Y + 3) then
                if not v17 or not CastTarget then
                    return {
                        Water = false,
                        Point = v20.Position
                    }
                end

                local v21 = math.max(v20.Position.Y, CastTarget.Y)

                return {
                    Water = true,
                    Point = Vector3.new(p13.X, v21, p13.Z)
                }
            end

            table.insert(v15, Instance)
            v19 = true
        else
            table.insert(v15, Instance)
        end

        v16.FilterDescendantsInstances = v15
    end

    if not v17 or not CastTarget then
        if v19 then
            return {
                Water = false,
                Point = p13
            }
        end

        return {
            Water = false,
            Point = p13 - Vector3.new(0, 40, 0)
        }
    end

    return {
        Water = true,
        Point = Vector3.new(p13.X, CastTarget.Y, p13.Z)
    }
end

function t1.Aim(p15, p16, p17) -- line: 199
    -- upvalues: t1 (copy)
    local v22 = Vector3.new(p16.X, 0, p16.Z)

    return p15 + (if v22.Magnitude > 0.01 then v22.Unit else Vector3.new(0, 0, -1)) * t1.DistanceFor(p17)
end

return table.freeze(t1)
