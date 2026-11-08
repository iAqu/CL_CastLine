-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.string)
local v2 = t.strict(t.optional(t.intersection(t.numberMin(1), t.numberMaxExclusive(1e999))))
local t1 = {
    SPEED = "Speed",
    EARNINGS = "Earnings",
    EGG_SIZE = "EggSize",
    EGG_SPAWN_LUCK = "EggSpawnLuck",
    MUTATION_LUCK = "MutationLuck",
    TREADMILL = "Treadmill",
    VIDEO_LUCK = "VideoLuck"
}
local t2 = {}

for _, v3 in t1 do
    t2[v3] = true
end

local function attributeFor(p1) -- line: 46
    -- upvalues: v1 (copy), t2 (copy)
    v1(p1)
    assert(t2[p1], (("there is no admin boost named \"%*\""):format(p1)))

    return "AdminBoost_" .. p1
end

function t1.ReadMultiplier(p2) -- line: 59
    -- upvalues: Workspace (copy), v1 (copy), t2 (copy)
    v1(p2)
    assert(t2[p2], (("there is no admin boost named \"%*\""):format(p2)))

    local Attribute = Workspace:GetAttribute("AdminBoost_" .. p2)

    if type(Attribute) ~= "number" or Attribute ~= Attribute then
        return 1
    end

    return (math.max(Attribute, 1))
end

function t1.Observe(p3) -- line: 68
    -- upvalues: Workspace (copy), v1 (copy), t2 (copy)
    v1(p3)
    assert(t2[p3], (("there is no admin boost named \"%*\""):format(p3)))

    return Workspace:GetAttributeChangedSignal("AdminBoost_" .. p3)
end

function t1.Assign(p4, p5) -- line: 74
    -- upvalues: RunService (copy), Workspace (copy), v1 (copy), v2 (copy), t2 (copy)
    assert(RunService:IsServer(), "admin boosts can only be assigned on the server")
    v2(p5)
    v1(p4)
    assert(t2[p4], (("there is no admin boost named \"%*\""):format(p4)))

    local v13 = "AdminBoost_" .. p4

    if p5 == nil or p5 <= 1 then
        Workspace:SetAttribute(v13, nil)
    else
        Workspace:SetAttribute(v13, p5)
    end
end

return table.freeze(t1)
