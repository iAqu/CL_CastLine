-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local LightVsDarknessEventFlags = require(ReplicatedStorage.Shared.Flags.LightVsDarknessEventFlags)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Rings = ReplicatedStorage.Assets.Models:WaitForChild("Rings")
local GuardAreas = Workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("GuardAreas")
local v1
local t1 = {
    RARITIES = {
        {
            Id = "Normal",
            Weight = 53,
            Points = 10,
            Model = "NormalRing",
            Radius = 0,
            SpinSpeed = 2.4
        },
        {
            Id = "Charged",
            Weight = 30,
            Points = 50,
            Model = "ChargedRing",
            Radius = 0,
            SpinSpeed = 2
        },
        {
            Id = "Secret",
            Weight = 12,
            Points = 250,
            Model = "SecretRing",
            Radius = 0,
            SpinSpeed = 1.7
        },
        {
            Id = "Rainbow",
            Weight = 3,
            Points = 1000,
            Model = "RainbowRing",
            Radius = 0,
            SpinSpeed = 1.4
        }
    }
}
local n1 = 0
local n2 = 0

for _, v2 in t1.RARITIES do
    local v3 = Rings:FindFirstChild(v2.Model)

    assert(v3 and v3:IsA("BasePart"), (("Rings.%* must be a BasePart"):format(v2.Model)))
    v2.Radius = v3.Size.Y / 2
    n2 += v2.Weight
    n1 = n2
end

t1.MILESTONES = {
    {
        Frame = "Milestone1",
        Rings = 100,
        Reward = "SpeedBoost15"
    },
    {
        Frame = "Milestone2",
        Rings = 800,
        Reward = "TeamEgg",
        Mutation = "Silver",
        TeamEggCategories = {
            Light = "Jellyfish",
            Darkness = "Dark Gargoyle"
        }
    },
    {
        Frame = "Milestone3",
        Rings = 1500,
        Reward = "Egg",
        EggCategory = "Ringlord"
    }
}

for _, v7 in t1.MILESTONES do
    local EggCategory = v7.EggCategory

    assert(EggCategory == nil or Assets.Directory[EggCategory] ~= nil, (("unknown milestone egg %*"):format(EggCategory)))

    for _, v10 in v7.TeamEggCategories or {} do
        assert(Assets.Directory[v10] ~= nil, (("unknown milestone egg %*"):format(v10)))
    end

    local Mutation = v7.Mutation

    assert(Mutation == nil or Mutations.IsKnown(Mutation), (("unknown milestone mutation %*"):format(Mutation)))
end

function t1.MilestoneEggCategory(p1, p2) -- line: 110
    -- upvalues: t1 (copy)
    local v15 = t1.MILESTONES[p1]
    local TeamEggCategories = v15.TeamEggCategories

    if TeamEggCategories == nil then
        return v15.EggCategory
    end

    return if p2 ~= nil then TeamEggCategories[p2] else nil
end

function t1.MilestoneIcon(p3, p4) -- line: 120
    -- upvalues: Assets (copy), t1 (copy)
    if t1.MILESTONES[p3].Reward:match("SpeedBoost") then
        return "rbxassetid://78137530993637"
    end

    local v16 = t1.MilestoneEggCategory(p3, p4)

    if v16 == nil then
        return nil
    end

    local Egg = Assets.Directory[v16].Egg

    if Egg.Icon == "" then
        return Assets.BaseConfig.Egg.Icon
    end

    return Egg.Icon
end

function t1.MilestoneQuantity(p5) -- line: 135
    -- upvalues: LightVsDarknessEventFlags (copy), t1 (copy)
    if t1.MILESTONES[p5].Reward ~= "SpeedBoost" then
        return nil
    end

    local v19 = math.max(math.floor(LightVsDarknessEventFlags.MilestoneSpeedBoostSeconds:Get() / 60 + 0.5), 1)

    return (("%* %*"):format(v19, if v19 == 1 then "min" else "mins"))
end

function t1.MilestoneKey(p6) -- line: 145
    return (("Milestone%*"):format(p6))
end

function t1.MilestoneAttribute(p7) -- line: 149
    -- upvalues: t1 (copy)
    return (("Lvd%*"):format((t1.MilestoneKey(p7))))
end

function t1.Template(p8) -- line: 153
    -- upvalues: Rings (copy), t1 (copy)
    local v20 = Rings:FindFirstChild(t1.RARITIES[p8].Model)

    assert(v20 and v20:IsA("BasePart"), (("Ring template %* missing"):format(p8)))

    return v20
end

function t1.RollRarity(p9) -- line: 159
    -- upvalues: t1 (copy), n1 (ref)
    local v23 = p9:NextNumber(0, n1)

    for v24, v25 in t1.RARITIES do
        v23 -= v25.Weight

        if v23 <= 0 then
            return v24
        end
    end

    return #t1.RARITIES
end

function t1.Zones() -- line: 171
    -- upvalues: GuardAreaGeometry (copy), GuardAreas (copy), v1 (ref)
    local v26 = v1

    if v26 then
        return v26
    end

    local v27 = GuardAreaGeometry.ReadAreaBounds(GuardAreas)

    table.sort(v27, function(p10, p11) -- line: 177
        return p10.Bounds.Position.X < p11.Bounds.Position.X
    end)
    v1 = v27

    return v27
end

function t1.ZoneIndexAt(p12) -- line: 185
    -- upvalues: GuardAreaGeometry (copy), t1 (copy)
    local n3 = 1
    local n4 = 1e999

    for v28, v29 in (t1.Zones()) do
        if GuardAreaGeometry.IsWithinFootprint(v29.Bounds, p12) then
            return v28
        end

        local v31 = math.abs(v29.Bounds.Position.X - p12.X)

        if v31 < n4 then
            n4 = v31
            n3 = v28
        end
    end

    return n3
end

function t1.EncodeRings(p13) -- line: 202
    local v32 = buffer.create(#p13 * 13)
    local n5 = 0

    for _, v33 in p13 do
        buffer.writef32(v32, n5, v33.X)
        buffer.writef32(v32, n5 + 4, v33.Y)
        buffer.writef32(v32, n5 + 8, v33.Z)
        buffer.writeu8(v32, n5 + 12, v33.Rarity)
        n5 += 13
    end

    return v32
end

function t1.DecodeRings(p14) -- line: 215
    local t2 = {}

    for i = 1, buffer.len(p14) // 13 do
        local v37 = (i - 1) * 13

        t2[i] = {
            X = buffer.readf32(p14, v37),
            Y = buffer.readf32(p14, v37 + 4),
            Z = buffer.readf32(p14, v37 + 8),
            Rarity = buffer.readu8(p14, v37 + 12)
        }
    end

    return t2
end

return t1
