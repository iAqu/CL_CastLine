-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButterflyFlags = require(ReplicatedStorage.Shared.Flags.ButterflyFlags)
local v1 = NumberRange.new(4, 12)
local v2 = NumberRange.new(30, 90)
local v3 = NumberRange.new(0.6, 1.15)
local self = setmetatable({}, {
    __mode = "k"
})
local t3 = {
    Order = { "Green", "Blue", "Purple", "Golden" },
    Tiers = {
        Green = {
            Id = "Green",
            DisplayName = "Emerald Butterfly",
            Rarity = "Common",
            Order = 1,
            Speed = 1,
            Wander = 0.25,
            Dodge = 0.2,
            FlapSpeed = 13,
            Scale = 2,
            Trail = false,
            Icon = "rbxassetid://107744695034799",
            CatchSound = "rbxassetid://77279854130030",
            Next = "Blue",
            Color = Color3.fromRGB(72, 214, 96),
            StrokeColor = Color3.fromRGB(12, 64, 24)
        },
        Blue = {
            Id = "Blue",
            DisplayName = "Sapphire Butterfly",
            Rarity = "Rare",
            Order = 2,
            Speed = 1.35,
            Wander = 0.4,
            Dodge = 0.35,
            FlapSpeed = 15,
            Scale = 2.1,
            Trail = false,
            Icon = "rbxassetid://89995151383384",
            CatchSound = "rbxassetid://99355023738967",
            Next = "Purple",
            Color = Color3.fromRGB(64, 140, 255),
            StrokeColor = Color3.fromRGB(10, 30, 90)
        },
        Purple = {
            Id = "Purple",
            DisplayName = "Amethyst Butterfly",
            Rarity = "Epic",
            Order = 3,
            Speed = 1.8,
            Wander = 0.6,
            Dodge = 0.5,
            FlapSpeed = 17,
            Scale = 2.25,
            Trail = true,
            Icon = "rbxassetid://121235713836098",
            CatchSound = "rbxassetid://119143297007735",
            Next = "Golden",
            Color = Color3.fromRGB(176, 84, 255),
            StrokeColor = Color3.fromRGB(50, 12, 90)
        },
        Golden = {
            Id = "Golden",
            DisplayName = "Radiant Butterfly",
            Rarity = "Legendary",
            Order = 4,
            Speed = 2.4,
            Wander = 0.85,
            Dodge = 0.65,
            FlapSpeed = 19,
            Scale = 2.6,
            Trail = true,
            Icon = "rbxassetid://98126365702697",
            CatchSound = "rbxassetid://98682676857672",
            Next = nil,
            Color = Color3.fromRGB(255, 200, 50),
            StrokeColor = Color3.fromRGB(110, 60, 0)
        }
    },
    Sounds = table.freeze({
        Swing = "rbxassetid://125101827399863",
        Escape = "rbxassetid://114385851460875",
        BloomStart = "rbxassetid://115559600750711",
        GoldenAnnounce = "rbxassetid://100474069377714",
        Ambience = "rbxassetid://91881816112074",
        Craft = "rbxassetid://103410108378357",
        Deny = "rbxassetid://84524242151355",
        Snag = "rbxassetid://110195370309564"
    }),
    Animations = table.freeze({
        Fly = "rbxassetid://116985467947373",
        Glide = "rbxassetid://113268708128253",
        Struggle = "rbxassetid://88700929559177"
    }),
    TierAnimations = table.freeze({
        Green = table.freeze({
            Fly = "rbxassetid://74344390381394",
            Glide = "rbxassetid://71567350079179",
            Struggle = "rbxassetid://74344390381394"
        }),
        Blue = table.freeze({
            Fly = "rbxassetid://84976279698060",
            Glide = "rbxassetid://90226558554634",
            Struggle = "rbxassetid://84976279698060"
        }),
        Purple = table.freeze({
            Fly = "rbxassetid://80602328062595",
            Glide = "rbxassetid://132894038596670",
            Struggle = "rbxassetid://80602328062595"
        }),
        Golden = table.freeze({
            Fly = "rbxassetid://91142398877798",
            Glide = "rbxassetid://71795342824977",
            Struggle = "rbxassetid://91142398877798"
        })
    }),
    Icons = table.freeze({
        Net = "rbxassetid://131116540264095",
        Essence = "rbxassetid://114750647204247"
    }),
    EssenceName = "Enchanted Essence",
    NetToolName = "Butterfly Net",
    NetItemType = "ButterflyNet",
    EventName = "ButterflyBloom",
    EndsAtAttribute = "ButterflyBloomEndsAt",
    FlightHeight = 4.5,
    SpawnDropHeight = 16,
    SpawnSeconds = 1.4,
    EscapeSeconds = 1.35,
    SnagSeconds = 0.1,
    DodgeSeconds = 0.45,
    EscapeLift = 7
}

function t3.IsTier(p1) -- line: 212
    -- upvalues: t3 (copy)
    if typeof(p1) == "string" then
        return t3.Tiers[p1] ~= nil
    end

    return false
end

function t3.Get(p2) -- line: 216
    -- upvalues: t3 (copy)
    local v5 = t3.Tiers[p2]

    assert(v5, (("unknown butterfly tier %*"):format(p2)))

    return v5
end

function t3.CatchChance(p3) -- line: 222
    -- upvalues: ButterflyFlags (copy)
    if p3 == "Green" then
        return ButterflyFlags.GreenCatchChance:Get()
    end

    if p3 == "Blue" then
        return ButterflyFlags.BlueCatchChance:Get()
    end

    if p3 == "Purple" then
        return ButterflyFlags.PurpleCatchChance:Get()
    end

    return ButterflyFlags.GoldenCatchChance:Get()
end

function t3.SpawnWeight(p4) -- line: 233
    -- upvalues: ButterflyFlags (copy)
    if p4 == "Green" then
        return ButterflyFlags.GreenWeight:Get()
    end

    if p4 == "Blue" then
        return ButterflyFlags.BlueWeight:Get()
    end

    if p4 == "Purple" then
        return ButterflyFlags.PurpleWeight:Get()
    end

    return ButterflyFlags.GoldenWeight:Get()
end

function t3.TradeUpCost(p5) -- line: 244
    -- upvalues: ButterflyFlags (copy)
    if p5 == "Green" then
        return ButterflyFlags.GreenToBlueCost:Get()
    end

    if p5 == "Blue" then
        return ButterflyFlags.BlueToPurpleCost:Get()
    end

    if p5 == "Purple" then
        return ButterflyFlags.PurpleToGoldenCost:Get()
    end

    return nil
end

function t3.CruiseSpeed(p6) -- line: 255
    -- upvalues: ButterflyFlags (copy)
    if p6 == "Green" then
        return ButterflyFlags.GreenCruiseSpeed:Get()
    end

    if p6 == "Blue" then
        return ButterflyFlags.BlueCruiseSpeed:Get()
    end

    if p6 == "Purple" then
        return ButterflyFlags.PurpleCruiseSpeed:Get()
    end

    return ButterflyFlags.GoldenCruiseSpeed:Get()
end

function t3.EssenceRecipe() -- line: 266
    -- upvalues: ButterflyFlags (copy)
    return {
        Green = ButterflyFlags.EssenceGreen:Get(),
        Blue = ButterflyFlags.EssenceBlue:Get(),
        Purple = ButterflyFlags.EssencePurple:Get(),
        Golden = ButterflyFlags.EssenceGolden:Get()
    }
end

local function phase(p7, p8) -- line: 275
    return p7 * (p8 * 7919 + 104729) % 10007 / 10007 * 6.283185307179586
end

local function multiply32(p9, p10) -- line: 279
    local v7 = bit32.rshift(p9, 16)
    local v8 = bit32.band(p9, 65535)

    return (v7 * p10 % 65536 * 65536 + v8 * p10) % 4294967296
end

local function knotValue(p11, p12, p13) -- line: 285
    local v9 = bit32.rshift(p12, 16)
    local v10 = bit32.band(p12, 65535)
    local v11 = (v9 * 2654435769 % 65536 * 65536 + v10 * 2654435769) % 4294967296
    local v12 = p13 % 4294967296
    local v13 = bit32.rshift(v12, 16)
    local v14 = bit32.band(v12, 65535)
    local v16 = bit32.bxor(p11, v11, (v13 * 2246822507 % 65536 * 65536 + v14 * 2246822507) % 4294967296)
    local v18 = bit32.bxor(v16, (bit32.rshift(v16, 16)))
    local v19 = bit32.rshift(v18, 16)
    local v20 = bit32.band(v18, 65535)
    local v21 = (v19 * 2146121005 % 65536 * 65536 + v20 * 2146121005) % 4294967296
    local v23 = bit32.bxor(v21, (bit32.rshift(v21, 15)))
    local v24 = bit32.rshift(v23, 16)
    local v25 = bit32.band(v23, 65535)
    local v26 = (v24 * 2221713035 % 65536 * 65536 + v25 * 2221713035) % 4294967296

    return bit32.bxor(v26, (bit32.rshift(v26, 16))) / 4294967295 * 2 - 1
end

local function unitValue(p14, p15, p16) -- line: 294
    -- upvalues: knotValue (copy)
    return (knotValue(p14, p15, p16) + 1) / 2
end

local function knotsAt(p17, p18, p19) -- line: 298
    -- upvalues: knotValue (copy)
    local Seed = p17.Seed
    local v28 = p17.Noise[p18]

    if v28 == nil then
        local t4 = {
            Knot = p19,
            A = knotValue(Seed, p18, p19 - 1),
            B = knotValue(Seed, p18, p19),
            C = knotValue(Seed, p18, p19 + 1),
            D = knotValue(Seed, p18, p19 + 2)
        }

        p17.Noise[p18] = t4

        return t4
    end

    if v28.Knot == p19 - 1 then
        v28.Knot = p19
        v28.A = v28.B
        v28.B = v28.C
        v28.C = v28.D
        v28.D = knotValue(Seed, p18, p19 + 2)
    elseif v28.Knot ~= p19 then
        v28.Knot = p19
        v28.A = knotValue(Seed, p18, p19 - 1)
        v28.B = knotValue(Seed, p18, p19)
        v28.C = knotValue(Seed, p18, p19 + 1)
        v28.D = knotValue(Seed, p18, p19 + 2)
    end

    return v28
end

local function noise(p20, p21, p22) -- line: 326
    -- upvalues: knotsAt (copy)
    local v29 = math.floor(p22)
    local v30 = p22 - v29
    local v31 = knotsAt(p20, p21, v29)
    local A, B, C, D = v31.A, v31.B, v31.C, v31.D

    return (B * 2 + (C - A) * v30 + (A * 2 - B * 5 + C * 4 - D) * v30 * v30 + ((B - C) * 3 + D - A) * v30 * v30 * v30) * 0.5
end

local function pick(p23, p24) -- line: 343
    return p23.Min + (p23.Max - p23.Min) * p24
end

local function reflect(p25, p26) -- line: 347
    local v32 = if p26 < p25 then p26 * 2 - p25 else p25

    if v32 < -p26 then
        v32 = p26 * -2 - v32
    end

    return (math.clamp(v32, -p26, p26))
end

local function edgeBias(p27) -- line: 357
    return math.sign(p27) * math.abs(p27) ^ 0.45
end

local function easeOut(p28) -- line: 361
    return 1 - (1 - p28) ^ 3
end

local function jinkSize(p29, p30) -- line: 365
    return math.min(math.max(p29.Radius, 1), 9) * (p30.Wander + 0.5)
end

local function buildRoute(p31) -- line: 369
    -- upvalues: t3 (copy), knotValue (copy)
    local v35 = t3.Get(p31.Tier)
    local v36 = math.max(p31.Radius, 1)
    local v38 = math.max(p31.Spread or v36, 1)
    local v40 = math.min(math.max(p31.Radius, 1), 9) * (v35.Wander + 0.5) * 0.25
    local v42 = math.max(v38 - v40, 1)
    local v44 = math.max(v36 - v40, 1)
    local Seed = p31.Seed

    return {
        Times = { 0 },
        X = { knotValue(Seed, 10, 0) * v42 },
        Z = { knotValue(Seed, 11, 0) * v44 },
        HalfX = v42,
        HalfZ = v44,
        Speed = math.max(t3.CruiseSpeed(p31.Tier), 1),
        Seed = Seed,
        Noise = {}
    }
end

local function routeOf(p32) -- line: 389
    -- upvalues: self (copy), buildRoute (copy)
    local v46 = self[p32]

    if v46 == nil then
        v46 = buildRoute(p32)
        self[p32] = v46
    end

    return v46
end

local function extendRoute(p33, p34) -- line: 398
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), knotValue (copy)
    local Times, X, Z, Seed = p33.Times, p33.X, p33.Z, p33.Seed

    while #Times < p34 do
        local v47 = #Times
        local v48 = X[v47]
        local v49 = Z[v47]
        local v50 = (knotValue(Seed, 12, v47) + 1) / 2
        local v51 = (knotValue(Seed, 13, v47) + 1) / 2 * 6.283185307179586
        local v52 = (knotValue(Seed, 14, v47) + 1) / 2
        local v53 = (knotValue(Seed, 15, v47) + 1) / 2
        local v54 = v3.Min + (v3.Max - v3.Min) * v53
        local v55, v56

        if v50 < 0.62 then
            local v57 = if v50 < 0.12 then v1.Min + (v1.Max - v1.Min) * v52 else v2.Min + (v2.Max - v2.Min) * v52
            local v58 = v48 + math.cos(v51) * v57
            local HalfX = p33.HalfX

            if HalfX < v58 then
                v58 = HalfX * 2 - v58
            end

            if v58 < -HalfX then
                v58 = HalfX * -2 - v58
            end

            v55 = math.clamp(v58, -HalfX, HalfX)

            local v60 = v49 + math.sin(v51) * v57
            local HalfZ = p33.HalfZ

            if HalfZ < v60 then
                v60 = HalfZ * 2 - v60
            end

            if v60 < -HalfZ then
                v60 = HalfZ * -2 - v60
            end

            v56 = math.clamp(v60, -HalfZ, HalfZ)

            if v50 < 0.12 then
                v54 = 0.3
            end
        else
            local v62 = knotValue(Seed, 16, v47)

            v55 = math.sign(v62) * math.abs(v62) ^ 0.45 * p33.HalfX

            local v63 = knotValue(Seed, 17, v47)

            v56 = math.sign(v63) * math.abs(v63) ^ 0.45 * p33.HalfZ
        end

        local v66 = math.max(math.sqrt((v55 - v48) ^ 2 + (v56 - v49) ^ 2) / (p33.Speed * v54), 0.3)

        table.insert(Times, Times[v47] + v66)
        table.insert(X, v55)
        table.insert(Z, v56)
    end
end

local function slope(p35, p36, p37) -- line: 434
    if p37 == 1 then
        return (p36[2] - p36[1]) / (p35[2] - p35[1])
    end

    return (p36[p37 + 1] - p36[p37 - 1]) / (p35[p37 + 1] - p35[p37 - 1])
end

local function hermite(p38, p39, p40, p41, p42, p43, p44) -- line: 441
    local v68 = p41 * p39[p40] + p42 * (if p40 == 1 then (p39[2] - p39[1]) / (p38[2] - p38[1]) else (p39[p40 + 1] - p39[p40 - 1]) / (p38[p40 + 1] - p38[p40 - 1])) + p43 * p39[p40 + 1]
    local v69 = p40 + 1

    return v68 + p44 * (if v69 == 1 then (p39[2] - p39[1]) / (p38[2] - p38[1]) else (p39[v69 + 1] - p39[v69 - 1]) / (p38[v69 + 1] - p38[v69 - 1]))
end

local function routeOffset(p45, p46) -- line: 456
    -- upvalues: extendRoute (copy)
    local Times = p45.Times
    local v70 = math.max(p46, 0)

    while true do
        if #Times < 3 then
            extendRoute(p45, #Times + 8)
            continue
        end

        if Times[#Times] <= v70 then
            extendRoute(p45, #Times + 8)
            continue
        end

        break
    end

    local v71 = 1
    local v72 = #Times

    while v72 - v71 > 1 do
        local v73 = (v71 + v72) // 2

        if Times[v73] <= v70 then
            v71 = v73
        else
            v72 = v73
        end
    end

    extendRoute(p45, v71 + 2)

    local v74 = Times[v71 + 1] - Times[v71]
    local v75 = (v70 - Times[v71]) / v74
    local v76 = v75 * v75
    local v77 = v76 * v75
    local v78 = v77 * 2 - v76 * 3 + 1
    local v79 = (v77 - v76 * 2 + v75) * v74
    local v80 = v77 * -2 + v76 * 3
    local v81 = (v77 - v76) * v74
    local X = p45.X
    local v82 = v78 * X[v71] + v79 * (if v71 == 1 then (X[2] - X[1]) / (Times[2] - Times[1]) else (X[v71 + 1] - X[v71 - 1]) / (Times[v71 + 1] - Times[v71 - 1])) + v80 * X[v71 + 1]
    local v83 = v71 + 1
    local v84 = v82 + v81 * (if v83 == 1 then (X[2] - X[1]) / (Times[2] - Times[1]) else (X[v83 + 1] - X[v83 - 1]) / (Times[v83 + 1] - Times[v83 - 1]))
    local Z = p45.Z
    local v85 = v78 * Z[v71] + v79 * (if v71 == 1 then (Z[2] - Z[1]) / (Times[2] - Times[1]) else (Z[v71 + 1] - Z[v71 - 1]) / (Times[v71 + 1] - Times[v71 - 1])) + v80 * Z[v71 + 1]
    local v86 = v71 + 1

    return v84, v85 + v81 * (if v86 == 1 then (Z[2] - Z[1]) / (Times[2] - Times[1]) else (Z[v86 + 1] - Z[v86 - 1]) / (Times[v86 + 1] - Times[v86 - 1]))
end

local function cruise(p47, p48) -- line: 485
    -- upvalues: self (copy), t3 (copy), noise (copy), buildRoute (copy), routeOffset (copy)
    local v87 = t3.Get(p47.Tier)
    local v88 = p48 - p47.Born
    local Seed = p47.Seed
    local Speed, Wander = v87.Speed, v87.Wander
    local v89 = math.max(p47.Radius, 1)
    local v91 = math.max(p47.Spread or v89, 1)
    local v93 = math.min(math.max(p47.Radius, 1), 9) * (v87.Wander + 0.5) * 0.5
    local v94 = v88 * 1.1 * Speed
    local v95 = self[p47]

    if v95 == nil then
        v95 = buildRoute(p47)
        self[p47] = v95
    end

    local v96, v97 = routeOffset(v95, v88)
    local v100 = v96 + noise(v95, 3, v94) * v93 + math.sin(v88 * 2.9 * Speed + Seed * 160162 % 10007 / 10007 * 6.283185307179586) * Wander * 1.6
    local v103 = v97 + noise(v95, 5, v94) * v93 + math.cos(v88 * 3.4 * Speed + Seed * 168081 % 10007 / 10007 * 6.283185307179586) * Wander * 1.6
    local v106 = noise(v95, 6, v88 / 2.5) * 1.3 + math.sin(v88 * 3.1 * Speed + Seed * 152243 % 10007 / 10007 * 6.283185307179586) * 0.35 * (1 + Wander)

    return p47.Anchor + Vector3.new(math.clamp(v100, -v91, v91), v106, (math.clamp(v103, -v89, v89)))
end

function t3.PositionAt(p49, p50) -- line: 509
    -- upvalues: t3 (copy), cruise (copy)
    local v111 = cruise(p49, p50)
    local v112 = p50 - p49.FleeAt

    if p49.FleeSeconds <= v112 or p49.FleeSeconds <= 0 then
        return v111
    end

    local v114 = math.clamp(v112 / p49.FleeSeconds, 0, 1)
    local v118 = math.sin(v114 * 3.141592653589793) * t3.EscapeLift * math.min(1, p49.FleeSeconds / t3.EscapeSeconds)

    return p49.FleeFrom:Lerp(v111, 1 - (1 - v114) ^ 3) + Vector3.new(0, v118, 0)
end

function t3.VelocityAt(p51, p52) -- line: 522
    -- upvalues: t3 (copy)
    return (t3.PositionAt(p51, p52 + 0.03333333333333333) - t3.PositionAt(p51, p52 - 0.03333333333333333)) / 0.06666666666666667
end

return table.freeze(t3)
