-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    ArenaName = "PumpkinArena",
    MemberAttribute = "InPumpkinArena",
    CannonFolder = "Cannons",
    MinionFolder = "Minions",
    VineFolder = "Vines",
    MinionAnims = table.freeze({
        Idle = 88399787339165,
        Walk = 102905279892441
    }),
    ExitTag = "PumpkinBossExit",
    ReturnTag = "PumpkinBossReturn",
    Phases = table.freeze({
        Waiting = "Waiting",
        BruteIntro = "BruteIntro",
        Brute = "Brute",
        BruteDown = "BruteDown",
        KingIntro = "KingIntro",
        King = "King",
        Shield = "Shield",
        Stunned = "Stunned",
        Defeated = "Defeated"
    }),
    Attributes = table.freeze({
        Phase = "Phase",
        Boss = "Boss",
        BossName = "BossName",
        Health = "Health",
        MaxHealth = "MaxHealth",
        SpawnsAt = "SpawnsAt",
        EndsAt = "EndsAt",
        SkipCutscenes = "SkipCutscenes",
        FloorY = "FloorY",
        Center = "Center",
        ShieldActive = "ShieldActive",
        ShieldHealth = "ShieldHealth",
        ShieldMax = "ShieldMax",
        StunEnds = "StunEnds",
        Scene = "Scene",
        SceneAt = "SceneAt",
        SceneEnds = "SceneEnds"
    }),
    DefeatedUntilAttribute = "PumpkinKingDefeatedUntil",
    ModelAttributes = table.freeze({
        Anim = "Anim",
        AnimAt = "AnimAt",
        Decaying = "Decaying",
        Stunned = "Stunned"
    }),
    TrapAttributes = table.freeze({
        Trapped = "IsTrapped",
        TrapEnds = "PumpkinTrapEnds",
        TrapUserId = "PumpkinTrapUserId"
    }),
    CannonAttributes = table.freeze({
        OwnerUserId = "OwnerUserId",
        Ready = "Ready",
        CannonId = "CannonId",
        Base = "CannonBase",
        Hinge = "CannonHinge",
        Barrel = "CannonBarrel"
    }),
    CannonAim = table.freeze({
        MaxPitch = 1.0471975511965976,
        MinDistance = 12,
        TurnRate = 3.141592653589793,
        PitchRate = 2.0943951023931953
    }),
    Fx = table.freeze({
        Callout = "Callout",
        Scene = "Scene",
        BossHit = "BossHit",
        BossSpawn = "BossSpawn",
        Stomp = "Stomp",
        Swipe = "Swipe",
        Charge = "Charge",
        BruteDown = "BruteDown",
        BruteHead = "BruteHead",
        KingRise = "KingRise",
        ShadowDash = "ShadowDash",
        VineTrap = "VineTrap",
        VineHit = "VineHit",
        VineBreak = "VineBreak",
        MinionSpawn = "MinionSpawn",
        MinionHit = "MinionHit",
        MinionPop = "MinionPop",
        MinionBoom = "MinionBoom",
        MinionArm = "MinionArm",
        ShieldUp = "ShieldUp",
        ShieldHit = "ShieldHit",
        ShieldBreak = "ShieldBreak",
        RootHit = "RootHit",
        RootBreak = "RootBreak",
        CannonShot = "CannonShot",
        CannonImpact = "CannonImpact",
        Stun = "Stun",
        Defeated = "Defeated",
        Currency = "Currency"
    }),
    SceneSeconds = table.freeze({
        AdminIntro = 51,
        BruteRise = 17.2,
        BruteDecay = 0.6,
        KingEmerge = 0,
        ShieldUp = 2,
        ShieldBreak = 2,
        KingDefeat = 4,
        AdminOutro = 18.4,
        AdminOutro2 = 27.4
    }),
    Callouts = table.freeze({
        BruteBegin = "",
        BruteRoots = "",
        BruteDash = "",
        BruteBombs = "",
        BruteFalls = "",
        KingStart = "",
        KingRoots = "",
        KingBarrage = "",
        KingSummon = "",
        KingDash = "",
        ShieldUp = "",
        ShieldDown = "",
        TimeUp = "TIME'S UP!",
        SceneBruteRise = "",
        SceneBruteDecay = "",
        SceneKingEmerge = "",
        SceneShieldUp = "",
        SceneShieldBreak = "",
        SceneKingDefeat = ""
    }),
    Clips = table.freeze({
        Brute = table.freeze({
            Idle = table.freeze({
                Id = 75442270908318,
                Length = 10
            }),
            Walk = table.freeze({
                Id = 120204162676218,
                Length = 3.2
            }),
            Death = table.freeze({
                Id = 127252928509264,
                Length = 4.667
            }),
            LeftSwipe = table.freeze({
                Id = 97068697457453,
                Length = 4.4
            }),
            RightSwipe = table.freeze({
                Id = 100968401290711,
                Length = 4.4
            }),
            Charge = table.freeze({
                Id = 79468673225508,
                Length = 7.233
            }),
            RootSummon = table.freeze({
                Id = 119974702599805,
                Length = 4.8
            }),
            Slam = table.freeze({
                Id = 117792582730583,
                Length = 4.9
            }),
            Throw = table.freeze({
                Id = 94916143697941,
                Length = 3.667
            })
        }),
        King = table.freeze({
            Idle = table.freeze({
                Id = 133032796882176,
                Length = 12
            }),
            Death = table.freeze({
                Id = 102873057827511,
                Length = 4.6
            }),
            Walk = table.freeze({
                Id = 96596796653355,
                Length = 3
            }),
            SummonMinions = table.freeze({
                Id = 112177597531265,
                Length = 5
            }),
            SummonVines = table.freeze({
                Id = 127715894828384,
                Length = 4.5
            }),
            Barrage = table.freeze({
                Id = 81018978118733,
                Length = 3.667
            }),
            ShadowDash = table.freeze({
                Id = 105710255538920,
                Length = 2.6
            }),
            ShieldCast = table.freeze({
                Id = 79759495045913,
                Length = 4.617
            }),
            ShieldBreak = table.freeze({
                Id = 90740255794265,
                Length = 2.4
            }),
            Stunned = table.freeze({
                Id = 101846677332327,
                Length = 3.6
            })
        })
    })
}
local t2 = {
    Idle = {
        Clip = "Idle",
        Loop = true
    },
    Walk = {
        Clip = "Walk",
        Loop = true
    },
    Rise = {
        Clip = "Idle"
    },
    SwipeLeft = {
        Clip = "LeftSwipe",
        Speed = 1,
        Windup = 2.25
    },
    SwipeRight = {
        Clip = "RightSwipe",
        Speed = 1,
        Windup = 2.25
    },
    Stomp = {
        Clip = "Slam",
        Speed = 1.15,
        Windup = 1.35
    },
    Slam = {
        Clip = "Slam",
        Speed = 0.65,
        Windup = 1.4
    },
    Summon = {
        Clip = "RootSummon",
        Speed = 1
    },
    Throw = {
        Clip = "Throw",
        Speed = 1,
        Windup = 1.2
    },
    Charge = {
        Clip = "Charge",
        Speed = 1,
        Windup = 1.2
    },
    ChargeEnd = {
        Clip = "Charge",
        From = 5,
        Speed = 1
    },
    Kneel = {
        Clip = "Death",
        Hold = true
    }
}
local t3 = {
    Idle = {
        Clip = "Idle",
        Loop = true
    },
    Rise = {
        Clip = "Idle",
        Loop = true
    },
    Walk = {
        Clip = "Walk",
        Loop = true
    },
    SummonMinions = {
        Clip = "SummonMinions",
        Speed = 1
    },
    SummonVines = {
        Clip = "SummonVines",
        Speed = 1
    },
    Barrage = {
        Clip = "Barrage",
        Speed = 1
    },
    ShadowDash = {
        Clip = "ShadowDash",
        Speed = 1,
        Windup = 0.65
    },
    Shield = {
        Clip = "ShieldCast",
        Speed = 1
    },
    ShieldBreak = {
        Clip = "ShieldBreak",
        Speed = 1
    },
    Stunned = {
        Clip = "Stunned",
        Loop = true
    },
    Defeat = {
        Clip = "Death",
        Hold = true
    }
}
local t4 = {
    Brute = table.freeze(t2),
    King = table.freeze(t3)
}

t1.Anims = table.freeze(t4)

function t1.Windup(p1, p2, p3) -- line: 249
    -- upvalues: t4 (copy)
    local v1 = t4[p1]
    local v2 = v1 and v1[p2]

    if v2 ~= nil and v2.Windup ~= nil then
        return v2.Windup / (v2.Speed or 1)
    end

    return p3
end

function t1.Duration(p4, p5, p6) -- line: 259
    -- upvalues: t1 (copy), t4 (copy)
    local v3 = t4[p4]
    local v4 = v3 and v3[p5]
    local v5 = t1.Clips[p4]
    local v6 = v4 and v5 and v5[v4.Clip]

    if v4 == nil or v6 == nil then
        return p6
    end

    return math.max(v6.Length - (v4.From or 0), 0) / (v4.Speed or 1)
end

t1.ProjectileGravity = 80

function t1.LaunchVelocity(p7, p8, p9) -- line: 273
    local v8 = math.max(p9, 0.05)

    return (p8 - p7) / v8 + Vector3.new(0, v8 * 40, 0)
end

function t1.Arc(p10, p11, p12) -- line: 278
    return p10 + p11 * p12 - Vector3.new(0, p12 * 40 * p12, 0)
end

function t1.ShotFlight(p13, p14) -- line: 284
    return (math.clamp((p14 - p13).Magnitude / 120, 0.6, 1.6))
end

function t1.ShotKey(p15, p16) -- line: 288
    return (("%*:%*"):format(p15, p16))
end

return table.freeze(t1)
