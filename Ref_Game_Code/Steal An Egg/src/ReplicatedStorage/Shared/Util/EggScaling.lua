-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventEggCategories = require(ReplicatedStorage.Shared.Util.EventEggCategories)
local t = require(ReplicatedStorage.Packages.t)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))

local function finiteVector3(p1) -- line: 15
    -- upvalues: v1 (copy)
    if typeof(p1) ~= "Vector3" then
        return false
    end

    return v1(p1.X) and v1(p1.Y) and v1(p1.Z)
end

local v2 = t.strict(v1)
local v3 = t.strict(finiteVector3)
local v4 = t.strict(t.optional(t.string))
local v5 = t.strict(t.instanceIsA("Model"))
local t1 = {}

function t1.ClampSaved(p2) -- line: 46
    -- upvalues: v2 (copy)
    v2(p2)

    return (math.clamp(p2, 0.002, 200))
end

function t1.FloorForCategory(p3, p4) -- line: 52
    -- upvalues: EventEggCategories (copy), v2 (copy), v4 (copy)
    v2(p3)
    v4(p4)

    if EventEggCategories.IsEventEgg(p4) then
        return p3 * 1
    end

    return p3 * 0.6
end

function t1.RawVisual(p5, p6) -- line: 63
    -- upvalues: v2 (copy)
    v2(p5)
    v2(p6)

    return p5 * math.max(p6, 0.002)
end

function t1.LiftToFloor(p7, p8, p9) -- line: 70
    -- upvalues: v2 (copy), t1 (copy)
    v2(p7)
    v2(p8)

    return (math.max(t1.FloorForCategory(p7, p9), p8))
end

function t1.PreGrowthVisual(p10, p11, p12) -- line: 77
    -- upvalues: t1 (copy)
    return (math.clamp(t1.RawVisual(p10, p11), t1.FloorForCategory(p10, p12), p10 * 8))
end

function t1.PlacedStart(p13, p14, p15) -- line: 89
    -- upvalues: t1 (copy)
    return t1.PreGrowthVisual(p13, p14, p15)
end

function t1.PlacedTarget(p16, p17, p18) -- line: 97
    -- upvalues: t1 (copy)
    local v10 = t1.RawVisual(p16, p17)
    local v11 = t1.FloorForCategory(p16, p18)

    if v10 < v11 then
        return v11
    end

    return v10 * 3
end

function t1.FitInside(p19, p20) -- line: 111
    -- upvalues: ModelBounds (copy), v3 (copy), v5 (copy), t1 (copy)
    v5(p19)
    v3(p20)

    local _, v12 = ModelBounds(p19)
    local v16 = math.min(p20.X / math.max(v12.X, 0.002), p20.Y / math.max(v12.Y, 0.002), p20.Z / math.max(v12.Z, 0.002)) * 0.92

    return t1.ClampSaved(p19:GetScale() * v16)
end

t1.MIN_EGG_SCALE = 0.8
t1.MAX_EGG_SCALE = 3
t1.MIN_ICON_SCALE = 0.5
t1.MAX_ICON_SCALE = 1.1

function t1.IconScaleFor(p21) -- line: 130
    if typeof(p21) ~= "number" or p21 ~= p21 or p21 <= 0 then
        return 1.1
    end

    return (math.clamp(p21, 0.8, 3) - 0.8) / 2.2 * 0.6000000000000001 + 0.5
end

function t1.FitIconToEgg(p22, p23) -- line: 146
    -- upvalues: t1 (copy)
    local v17 = t1.IconScaleFor(p23)

    p22.Size = UDim2.fromScale(v17, v17)
end

return t1
