-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    INTRO = 15,
    OUTRO = 9,
    LENGTH = 5400,
    HUNT = 1200,
    MIN_LENGTH = 360,
    MAX_LENGTH = 10800,
    BATTLE = {
        CRACK = 0,
        ARRIVE = 4.5,
        FACE = 9,
        VS = 9,
        BET_OPEN = 12.5,
        BET_CLOSE = 42,
        CLASH = 42,
        LANCES = 50,
        ORBS = 62,
        PILLAR = 72,
        STRUGGLE = 84,
        FINISH = 100,
        WIN = 107,
        ASCEND = 114,
        LEN = 130
    },
    BET_PRIZE = {
        lucky = 5,
        potion = "cosmic",
        seconds = 300
    },
    WATER_FROM = -14,
    WATER_TO = 66,
    CENTER = Vector3.new(0, 0, 225),
    FLOOD_MIN = Vector3.new(-345, 0, -2400),
    FLOOD_MAX = Vector3.new(345, 0, 520),
    PORTAL = Vector3.new(0, 250, 225),
    KHAOS_LENGTH = 80,
    KHAOS_Y = 46,
    PATH_START = 12.5,
    EGG_KEY = "CosmicEgg",
    DROPS = {
        {
            kind = "lucky",
            weight = 40,
            amount = 5
        },
        {
            kind = "potion",
            weight = 46
        },
        {
            kind = "egg",
            weight = 14,
            cap = 3
        }
    },
    DROP_GAP_ONE = 13,
    DROP_GAP_PER = 0.6,
    DROP_GAP_MIN = 6,
    DROP_LIFE = 70,
    MAX_DROPS = 12,
    PICKUP = 10,
    SINK = 5,
    DROP_BELOW = 16,
    GRAVITY = 72,
    ARENA = Vector3.new(0, 150, 210),
    RIFT = Vector3.new(0, 390, 40),
    SERAPHION_LENGTH = 74,
    GIANT_POS = Vector3.new(0, 205, 230),
    GIANT_SCALE = 4.2,
    BEAM_GAP = 7,
    BEAM_CHARGE = 1.3,
    BEAM_SWEEP = 3,
    BEAM_RADIUS = 9,
    TARGET_EVERY = 75,
    MUTATE_CHANCE = 0.00025,
    TOPIC = "CosmicFlood",
    SKY = {
        Ft = "rbxassetid://99331037931972",
        Bk = "rbxassetid://86330195047968",
        Lf = "rbxassetid://93596099087767",
        Rt = "rbxassetid://85611333108137",
        Up = "rbxassetid://112149141070065",
        Dn = "rbxassetid://92673259820437"
    }
}

function t1.KhaosAt(p1, p2) -- line: 113
    -- upvalues: t1 (copy)
    local v1 = if p2 % 2 == 0 then 1 else -1
    local v3 = if math.floor(p2 / 2) % 2 == 0 then 1 else -1
    local v7 = v1 * (math.sin(0.1208304866765305 * p1) * 200 + math.sin(0.2731819698773733 * p1 + 1.3) * 28)
    local v11 = t1.CENTER.Z + v3 * (math.sin(0.16981581911296179 * p1) * 150 + math.sin(0.3549822207446094 * p1 + 0.7) * 22)

    return (Vector3.new(v7, t1.KHAOS_Y + math.sin(0.36959913571644626 * p1) * 4 + math.sin(0.8607103160519981 * p1) * 2, v11))
end

function t1.KhaosCF(p3, p4) -- line: 123
    -- upvalues: t1 (copy)
    local v16 = t1.KhaosAt(p3, p4)
    local v17 = t1.KhaosAt(p3 + 0.35, p4)
    local v18 = t1.KhaosAt(p3 - 0.35, p4)
    local v19 = v17 - v18

    if v19.Magnitude < 0.001 then
        v19 = Vector3.new(0, 0, -1)
    end

    local Unit = v19.Unit
    local v21 = math.clamp((v17 - v16).Unit:Cross((v16 - v18).Unit).Y * 9, -0.55, 0.55)

    return CFrame.lookAt(v16, v16 + Unit) * CFrame.Angles(0, 0, v21)
end

function t1.DropGap(p5) -- line: 138
    -- upvalues: t1 (copy)
    return (math.max(t1.DROP_GAP_MIN, t1.DROP_GAP_ONE - t1.DROP_GAP_PER * math.max(0, p5 - 1)))
end

t1.DropsByKind = {}

for _, v24 in ipairs(t1.DROPS) do
    t1.DropsByKind[v24.kind] = v24
end

function t1.DropAt(p6, p7) -- line: 148
    -- upvalues: t1 (copy)
    local v27 = math.max(p6.gy, p6.y - t1.SINK * math.max(0, p7 - p6.t))

    return (Vector3.new(p6.x, v27, p6.z))
end

t1.EggAt = t1.DropAt

function t1.Plan(p8) -- line: 156
    -- upvalues: t1 (copy)
    if t1.LENGTH <= p8 then
        return t1.HUNT
    end

    return (math.clamp(math.floor(p8 * t1.HUNT / t1.LENGTH), 60, t1.HUNT))
end

function t1.Act(p9, p10) -- line: 164
    -- upvalues: t1 (copy)
    if p9 < t1.INTRO then
        return "intro"
    end

    if p9 < p10 then
        return "hunt"
    end

    if p9 < p10 + t1.BATTLE.LEN then
        return "battle"
    end

    return "cosmic"
end

local t2 = {
    { 0, 100, 100 },
    { 45, 100, 100 },
    { 45.4, 91, 92 },
    { 51.5, 91, 92 },
    { 52, 85, 92 },
    { 53.5, 85, 92 },
    { 54, 79, 92 },
    { 55.5, 79, 92 },
    { 56, 72, 92 },
    { 57.5, 72, 92 },
    { 58, 65, 92 },
    { 59.6, 65, 92 },
    { 60, 57, 92 },
    { 69.4, 57, 92 },
    { 69.8, 57, 84 },
    { 78, 57, 84 },
    { 79, 22, 84 },
    { 94, 24, 84 },
    { 99, 24, 42 },
    { 99.6, 24, 34 },
    { 103, 24, 34 },
    { 103.3, 24, 0 }
}

function t1.Health(p11) -- line: 183
    -- upvalues: t2 (copy)
    if p11 <= t2[1][1] then
        return 100, 100
    end

    for i = 2, #t2 do
        local v30 = t2[i - 1]
        local v31 = t2[i]

        if p11 <= v31[1] then
            local v34 = (p11 - v30[1]) / math.max(v31[1] - v30[1], 0.001)

            return v30[2] + (v31[2] - v30[2]) * v34, v30[3] + (v31[3] - v30[3]) * v34
        end
    end

    local v35 = t2[#t2]

    return v35[2], v35[3]
end

function t1.SweepHits(p12, p13, p14, p15) -- line: 200
    local v38 = math.max(1, (math.ceil((p13 - p12).Magnitude / 3)))
    local v39 = p14.Size.X / 2 + p15
    local v40 = p14.Size.Z / 2 + p15

    for i = 0, v38 do
        local v41 = p12:Lerp(p13, i / v38)
        local v42 = p14.CFrame:PointToObjectSpace((Vector3.new(v41.X, p14.Position.Y, v41.Z)))

        if math.abs(v42.X) <= v39 and math.abs(v42.Z) <= v40 then
            return true
        end
    end

    return false
end

function t1.InFlood(p16) -- line: 214
    -- upvalues: t1 (copy)
    if p16.X > t1.FLOOD_MIN.X and p16.X < t1.FLOOD_MAX.X and p16.Z > t1.FLOOD_MIN.Z then
        return p16.Z < t1.FLOOD_MAX.Z
    end

    return false
end

return t1
