-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(script.Parent.Types)

local RollWeighted = require(ReplicatedStorage.Shared.Utils.Numeric).RollWeighted
local v1 = table.freeze({
    Normal = "Normal",
    Lazy = "Lazy",
    Loyal = "Loyal",
    Energetic = "Energetic",
    InvertedModel = "InvertedModel",
    Shy = "Shy",
    Scared = "Scared",
    ExtremelyEnergetic = "ExtremelyEnergetic",
    UltraLoyal = "UltraLoyal",
    JumpCrazy = "JumpCrazy"
})
local t1 = {
    RollWeight = 12,
    _id = v1.Energetic,
    Movement = {
        WalkSpeedMin = 9,
        WalkSpeedMax = 20,
        IdleSecondsMin = 0.1,
        IdleSecondsMax = 0.75,
        NearOwnerPreference = 0.2,
        IsolationPreference = 0,
        CurvedWanderChance = 0.62,
        BurstChance = 0.42,
        FollowOwnerInPen = false,
        AmbientJumpRatePerSecond = 0,
        AmbientSpinJumpChance = 0
    },
    Greeting = {
        Chance = 1,
        FirstPlacementChance = 1,
        FirstPlacementNormalChance = 0,
        FirstPlacementNormalJumpCount = 4,
        ReturnOrbitChance = 0.6,
        ReturnNormalJumpCount = 3,
        RandomOrbitChance = 0.2,
        RandomOrbitIntervalSeconds = 45,
        DurationSeconds = 6,
        JumpChancePerSecond = 0.85,
        SpinJumpChance = 0.3,
        Texts = { "😊", "😄", "🥰" }
    },
    Affection = {
        Enabled = true,
        Chance = 0.125,
        IntervalSeconds = 5,
        DurationSeconds = 4.5,
        JumpCount = 5,
        Texts = {
            "😆",
            "😄",
            "😁",
            "😃",
            "🤪",
            "😝",
            "😜",
            "😋",
            "😹",
            "🙀",
            "😎"
        }
    }
}
local Greeting = t1.Greeting
local t2 = {
    Chance = Greeting.Chance,
    FirstPlacementChance = Greeting.FirstPlacementChance,
    FirstPlacementNormalChance = Greeting.FirstPlacementNormalChance,
    FirstPlacementNormalJumpCount = Greeting.FirstPlacementNormalJumpCount,
    ReturnOrbitChance = Greeting.ReturnOrbitChance,
    ReturnNormalJumpCount = Greeting.ReturnNormalJumpCount,
    RandomOrbitChance = Greeting.RandomOrbitChance,
    RandomOrbitIntervalSeconds = Greeting.RandomOrbitIntervalSeconds,
    DurationSeconds = Greeting.DurationSeconds,
    JumpChancePerSecond = Greeting.JumpChancePerSecond,
    SpinJumpChance = Greeting.SpinJumpChance,
    Texts = {
        "//ERRsORijwoR//",
        "0x?#!@NLL",
        "01011010???",
        "▓▒░???░▒▓",
        "M4M4.EXE???",
        "##!%$@//",
        "<???:'aWsFE>",
        "1010_=249_0101",
        "??//V//#"
    }
}
local t3 = {
    RollWeight = 1.5,
    _id = v1.InvertedModel,
    Movement = t1.Movement,
    Greeting = t2,
    Affection = t1.Affection
}
local t4 = {
    Normal = {
        RollWeight = 37,
        _id = v1.Normal,
        Movement = {
            WalkSpeedMin = 6.5,
            WalkSpeedMax = 12,
            IdleSecondsMin = 1.2,
            IdleSecondsMax = 3.2,
            NearOwnerPreference = 0.14,
            IsolationPreference = 0,
            CurvedWanderChance = 0.16,
            BurstChance = 0.035,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 0,
            FirstPlacementNormalChance = 1,
            FirstPlacementNormalJumpCount = 3,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 2,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 45,
            DurationSeconds = 6,
            JumpChancePerSecond = 0.8,
            SpinJumpChance = 0.08,
            Texts = { "😊", "😄", "🥰" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.16666666666666666,
            IntervalSeconds = 5,
            DurationSeconds = 4,
            JumpCount = 2,
            Texts = { "😊", "😄", "🙂", "☺️", "🥰", "😃", "😁", "🤗" }
        }
    },
    Lazy = {
        RollWeight = 15,
        _id = v1.Lazy,
        Movement = {
            WalkSpeedMin = 2.5,
            WalkSpeedMax = 3.75,
            IdleSecondsMin = 6,
            IdleSecondsMax = 15,
            NearOwnerPreference = 0.025,
            IsolationPreference = 0.08,
            CurvedWanderChance = 0.025,
            BurstChance = 0,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0
        },
        Greeting = {
            Chance = 0,
            FirstPlacementChance = 0,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 0,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 1,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 60,
            DurationSeconds = 3.5,
            JumpChancePerSecond = 0.08,
            SpinJumpChance = 0,
            Texts = { "😊", "😄", "🥰" }
        },
        Affection = {
            Enabled = false,
            Chance = 0,
            IntervalSeconds = 80,
            DurationSeconds = 0,
            JumpCount = 0,
            Texts = { "😴", "🥱", "😪", "😌", "😐", "😑", "😶", "🙃" }
        }
    },
    Loyal = {
        RollWeight = 10,
        _id = v1.Loyal,
        Movement = {
            WalkSpeedMin = 7.5,
            WalkSpeedMax = 10,
            IdleSecondsMin = 0.35,
            IdleSecondsMax = 1.25,
            NearOwnerPreference = 0.9,
            IsolationPreference = 0,
            CurvedWanderChance = 0.08,
            BurstChance = 0.055,
            FollowOwnerInPen = true,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 3,
            ReturnOrbitChance = 0.45,
            ReturnNormalJumpCount = 2,
            RandomOrbitChance = 0.08,
            RandomOrbitIntervalSeconds = 45,
            DurationSeconds = 6.5,
            JumpChancePerSecond = 0.55,
            SpinJumpChance = 0.06,
            Texts = { "Mama" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.002976190476190476,
            IntervalSeconds = 5,
            DurationSeconds = 5,
            JumpCount = 2,
            Texts = { "🥰", "😍", "😊", "☺️", "🤗", "😚" }
        }
    },
    Energetic = t1,
    InvertedModel = t3,
    Shy = {
        RollWeight = 10,
        _id = v1.Shy,
        Movement = {
            WalkSpeedMin = 3,
            WalkSpeedMax = 5,
            IdleSecondsMin = 5.5,
            IdleSecondsMax = 14,
            NearOwnerPreference = 0,
            IsolationPreference = 0.95,
            CurvedWanderChance = 0.035,
            BurstChance = 0,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0,
            Retreat = {
                TriggerDistance = 22,
                Chance = 0.85,
                MaxTravelDistance = 16
            }
        },
        Greeting = {
            Chance = 0,
            FirstPlacementChance = 0,
            FirstPlacementBubbleChance = 0,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 0,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 0,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 0,
            JumpChancePerSecond = 0,
            SpinJumpChance = 0,
            Texts = { "😊" }
        },
        Affection = {
            Enabled = false,
            Chance = 0,
            IntervalSeconds = 50,
            DurationSeconds = 0,
            JumpCount = 0,
            Texts = { "😊", "😄", "🥰" }
        }
    },
    Scared = {
        RollWeight = 5,
        _id = v1.Scared,
        Movement = {
            WalkSpeedMin = 20,
            WalkSpeedMax = 40,
            IdleSecondsMin = 0.8,
            IdleSecondsMax = 4,
            NearOwnerPreference = 0,
            IsolationPreference = 1,
            CurvedWanderChance = 0.03,
            BurstChance = 0,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 0,
            AmbientSpinJumpChance = 0,
            Retreat = {
                TriggerDistance = 20,
                Chance = 1
            },
            IdleTremble = {
                Amplitude = 0.1,
                CyclesPerSecond = 3
            }
        },
        Greeting = {
            Chance = 0,
            FirstPlacementChance = 0,
            FirstPlacementBubbleChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 0,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 0,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 0,
            JumpChancePerSecond = 0,
            SpinJumpChance = 0,
            Texts = { "Where is MAMA 😰?" }
        },
        Affection = {
            Enabled = false,
            Chance = 0,
            IntervalSeconds = 50,
            DurationSeconds = 0,
            JumpCount = 0,
            Texts = { "😨", "😰" }
        }
    },
    ExtremelyEnergetic = {
        RollWeight = 3.5,
        _id = v1.ExtremelyEnergetic,
        Movement = {
            WalkSpeedMin = 30,
            WalkSpeedMax = 70,
            IdleSecondsMin = 0.05,
            IdleSecondsMax = 0.2,
            NearOwnerPreference = 0.2,
            IsolationPreference = 0,
            CurvedWanderChance = 0.8,
            BurstChance = 0.7,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 3.5,
            AmbientSpinJumpChance = 0.35
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 5,
            ReturnOrbitChance = 0.75,
            ReturnNormalJumpCount = 5,
            RandomOrbitChance = 0.35,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 6,
            JumpChancePerSecond = 1.8,
            SpinJumpChance = 0.4,
            Texts = { "🤩", "🤪" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.1,
            IntervalSeconds = 5,
            DurationSeconds = 4.5,
            JumpCount = 7,
            Texts = { "🤩", "😆", "🤪" }
        }
    },
    UltraLoyal = {
        RollWeight = 2.5,
        _id = v1.UltraLoyal,
        Movement = {
            WalkSpeedMin = 10,
            WalkSpeedMax = 16,
            IdleSecondsMin = 0.1,
            IdleSecondsMax = 0.5,
            NearOwnerPreference = 0.98,
            IsolationPreference = 0,
            CurvedWanderChance = 0.12,
            BurstChance = 0.1,
            FollowOwnerInPen = true,
            AmbientJumpRatePerSecond = 0.35,
            AmbientSpinJumpChance = 0.1
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 1,
            FirstPlacementNormalChance = 0,
            FirstPlacementNormalJumpCount = 4,
            ReturnOrbitChance = 0.9,
            ReturnNormalJumpCount = 3,
            RandomOrbitChance = 0.9,
            RandomOrbitIntervalSeconds = 5,
            DurationSeconds = 6.5,
            JumpChancePerSecond = 0.8,
            SpinJumpChance = 0.1,
            Texts = { "Mama 🤗", "Mama 🥰" }
        },
        Affection = {
            Enabled = true,
            Chance = 0.15151515151515152,
            IntervalSeconds = 5,
            DurationSeconds = 5,
            JumpCount = 3,
            Texts = { "🥰", "🤗" }
        }
    },
    JumpCrazy = {
        RollWeight = 3.5,
        _id = v1.JumpCrazy,
        Movement = {
            WalkSpeedMin = 10,
            WalkSpeedMax = 18,
            IdleSecondsMin = 0.05,
            IdleSecondsMax = 0.3,
            NearOwnerPreference = 0.2,
            IsolationPreference = 0,
            CurvedWanderChance = 0.25,
            BurstChance = 0.1,
            FollowOwnerInPen = false,
            AmbientJumpRatePerSecond = 12,
            AmbientSpinJumpChance = 0.5
        },
        Greeting = {
            Chance = 1,
            FirstPlacementChance = 0,
            FirstPlacementNormalChance = 1,
            FirstPlacementNormalJumpCount = 8,
            ReturnOrbitChance = 0,
            ReturnNormalJumpCount = 7,
            RandomOrbitChance = 0,
            RandomOrbitIntervalSeconds = 30,
            DurationSeconds = 6,
            JumpChancePerSecond = 2,
            SpinJumpChance = 0.5,
            Texts = {
                "😆",
                "😄",
                "😁",
                "😃",
                "🤪",
                "😝",
                "😜",
                "😋",
                "😹",
                "🙀",
                "😎"
            }
        },
        Affection = {
            Enabled = true,
            Chance = 0.1,
            IntervalSeconds = 5,
            DurationSeconds = 4,
            JumpCount = 8,
            Texts = {
                "😆",
                "😄",
                "😁",
                "😃",
                "🤪",
                "😝",
                "😜",
                "😋",
                "😹",
                "🙀",
                "😎"
            }
        }
    }
}

local function freezeTable(p1) -- line: 479
    if p1 ~= nil and not table.isfrozen(p1) then
        table.freeze(p1)
    end
end

for _, v2 in t4 do
    local Retreat = v2.Movement.Retreat

    if Retreat ~= nil and not table.isfrozen(Retreat) then
        table.freeze(Retreat)
    end

    local IdleTremble = v2.Movement.IdleTremble

    if IdleTremble ~= nil and not table.isfrozen(IdleTremble) then
        table.freeze(IdleTremble)
    end

    local Movement = v2.Movement

    if Movement ~= nil and not table.isfrozen(Movement) then
        table.freeze(Movement)
    end

    local Texts = v2.Greeting.Texts

    if Texts ~= nil and not table.isfrozen(Texts) then
        table.freeze(Texts)
    end

    local Greeting = v2.Greeting

    if Greeting ~= nil and not table.isfrozen(Greeting) then
        table.freeze(Greeting)
    end

    local Texts2 = v2.Affection.Texts

    if Texts2 ~= nil and not table.isfrozen(Texts2) then
        table.freeze(Texts2)
    end

    local Affection = v2.Affection

    if Affection ~= nil and not table.isfrozen(Affection) then
        table.freeze(Affection)
    end

    if v2 ~= nil and not table.isfrozen(v2) then
        table.freeze(v2)
    end
end

if t4 ~= nil and not table.isfrozen(t4) then
    table.freeze(t4)
end

local v3 = table.freeze({
    {
        Personality = v1.Normal,
        Weight = t4[v1.Normal].RollWeight
    },
    {
        Personality = v1.Lazy,
        Weight = t4[v1.Lazy].RollWeight
    },
    {
        Personality = v1.Loyal,
        Weight = t4[v1.Loyal].RollWeight
    },
    {
        Personality = v1.Energetic,
        Weight = t4[v1.Energetic].RollWeight
    },
    {
        Personality = v1.InvertedModel,
        Weight = t4[v1.InvertedModel].RollWeight
    },
    {
        Personality = v1.Shy,
        Weight = t4[v1.Shy].RollWeight
    },
    {
        Personality = v1.Scared,
        Weight = t4[v1.Scared].RollWeight
    },
    {
        Personality = v1.ExtremelyEnergetic,
        Weight = t4[v1.ExtremelyEnergetic].RollWeight
    },
    {
        Personality = v1.UltraLoyal,
        Weight = t4[v1.UltraLoyal].RollWeight
    },
    {
        Personality = v1.JumpCrazy,
        Weight = t4[v1.JumpCrazy].RollWeight
    }
})
local v4 = table.freeze({
    {
        v1.Normal,
        t4[v1.Normal].RollWeight
    },
    {
        v1.Lazy,
        t4[v1.Lazy].RollWeight
    },
    {
        v1.Loyal,
        t4[v1.Loyal].RollWeight
    },
    {
        v1.Energetic,
        t4[v1.Energetic].RollWeight
    },
    {
        v1.InvertedModel,
        t4[v1.InvertedModel].RollWeight
    },
    {
        v1.Shy,
        t4[v1.Shy].RollWeight
    },
    {
        v1.Scared,
        t4[v1.Scared].RollWeight
    },
    {
        v1.ExtremelyEnergetic,
        t4[v1.ExtremelyEnergetic].RollWeight
    },
    {
        v1.UltraLoyal,
        t4[v1.UltraLoyal].RollWeight
    },
    {
        v1.JumpCrazy,
        t4[v1.JumpCrazy].RollWeight
    }
})

for _, v5 in v3 do
    if v5 ~= nil and not table.isfrozen(v5) then
        table.freeze(v5)
    end
end

for _, v6 in v4 do
    if v6 ~= nil and not table.isfrozen(v6) then
        table.freeze(v6)
    end
end

local t5 = {
    Personalities = v1,
    Configs = t4,
    RollTable = v3,
    IsPersonality = function(p2) -- IsPersonality | line: 549
        -- upvalues: t4 (copy)
        if typeof(p2) == "string" then
            return t4[p2] ~= nil
        end

        return false
    end,
    GetConfig = function(p3) -- GetConfig | line: 553
        -- upvalues: v1 (copy), t4 (copy)
        return t4[p3] or t4[v1.Normal]
    end
}

function t5.Roll(p4) -- line: 557
    -- upvalues: RollWeighted (copy), v4 (copy), t5 (copy)
    local v7 = RollWeighted(v4, p4)

    assert(typeof(v7) == "string" and t5.IsPersonality(v7), "Asset personality roll failed")

    return v7
end

function t5.CreateNewItemData(p5) -- line: 563
    -- upvalues: t5 (copy)
    local v9 = table.clone(p5)

    v9.Mutations = table.clone(p5.Mutations)

    if not t5.IsPersonality(v9.Personality) then
        v9.Personality = t5.Roll()
    end

    v9.HasBeenFirstPlaced = false

    return v9
end

function t5.ResetFirstPlacementForTransfer(p6) -- line: 573
    local v10 = table.clone(p6)

    v10.Mutations = table.clone(p6.Mutations)
    v10.HasBeenFirstPlaced = false

    return v10
end

return table.freeze(t5)
