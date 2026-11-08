-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetWanderArea = require(script.Parent.AssetWanderArea)

require(ReplicatedStorage.Data.Assets)

local Player = require(ReplicatedStorage.Shared.Player)
local t1 = {}

local function isolatedPointFromOwner(p1, p2, p3) -- line: 25
    -- upvalues: AssetWanderArea (copy)
    local v1, v2 = AssetWanderArea.HalfExtents(p1)
    local v3 = p1.CFrame:PointToObjectSpace(p3)
    local v4 = if v3.X >= 0 then p2:NextNumber(-v1, 0) else p2:NextNumber(0, v1)
    local v5 = if v3.Z >= 0 then p2:NextNumber(-v2, 0) else p2:NextNumber(0, v2)

    return (p1.CFrame * CFrame.new(v4, 0, v5)).Position
end

function t1.StepIdle(p4, p5, p6, p7, p8) -- line: 46
    local v7 = math.max(p5 - p4, 0)
    local v8 = p6 + p4
    local v9 = p7

    if p8 ~= nil and v7 > 0 then
        local v11 = math.clamp(v8 / 0.2, 0, 1)
        local v13 = math.clamp(v7 / 0.2, 0, 1)
        local v14 = p8.Amplitude * math.min(v11, v13)
        local v15 = v8 * p8.CyclesPerSecond * 3.141592653589793 * 2
        local v16 = math.sin(v15) * v14
        local v18 = math.sin(v15 * 1.37 + 1.0471975511965976) * v14

        v9 = p7 * CFrame.new(v16, 0, v18)
    end

    return v9, v7, v8, v7 <= 0
end

function t1.ChooseDestination(p9, p10, p11, p12) -- line: 69
    -- upvalues: AssetWanderArea (copy), isolatedPointFromOwner (copy)
    if p12 ~= nil and p10:NextNumber() < p11.IsolationPreference then
        return (isolatedPointFromOwner(p9, p10, p12))
    end

    if p12 == nil or not (p10:NextNumber() < p11.NearOwnerPreference) then
        return AssetWanderArea.RandomPoint(p9, p10)
    end

    return AssetWanderArea.ClampedPointToward(p9, p12)
end

function t1.RandomOwnerOffset(p13, p14, p15) -- line: 85
    local v19 = p14:NextNumber(0, 6.283185307179586)
    local v22 = Vector3.new(math.cos(v19) * p15, 0, math.sin(v19) * p15)

    return p13.CFrame:VectorToWorldSpace(v22)
end

function t1.RollChance(p16, p17) -- line: 96
    if p17 <= 0 then
        return false
    end

    if p17 >= 1 then
        return true
    end

    return p16:NextNumber() <= p17
end

function t1.RandomConfiguredText(p18, p19, p20, p21) -- line: 107
    assert(#p19 > 0, (("Personality %* requires at least one %* text"):format(p20, p21)))

    return p19[p18:NextInteger(1, #p19)]
end

function t1.OwnerRootPosition(p22) -- line: 117
    -- upvalues: Player (copy)
    local v25 = Player.FindPrimaryPart(p22)

    return if v25 ~= nil then v25.Position else nil
end

function t1.DistanceFromPlayerToAreaCenter(p23, p24) -- line: 122
    -- upvalues: t1 (copy)
    local v26 = t1.OwnerRootPosition(p23)

    return if v26 ~= nil then (v26 - p24.Position).Magnitude else nil
end

function t1.ShouldStartAmbientJump(p25, p26, p27, p28) -- line: 130
    if p26 <= 0 or p28 then
        return false
    end

    return 1 - math.exp(-p26 * p27) >= p25:NextNumber()
end

return t1
