-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Types)

local Visuals = require(script.Parent.Visuals)
local ScrambledVisuals = require(script.Parent.ScrambledVisuals)
local t1 = {
    Silver = {
        Id = "Silver",
        Label = "Silver",
        EarningsScalar = 1.2,
        RollWeight = 6,
        IconAssetId = 108639493197858,
        Tint = Color3.fromRGB(192, 192, 192),
        Apply = function(_, p2, p3) -- Apply | line: 43
            -- upvalues: Visuals (copy)
            Visuals.ApplySilver(p2, p3)
        end,
        Clear = function(_, p5, p6) -- Clear | line: 46
            -- upvalues: Visuals (copy)
            Visuals.ClearSilver(p5, p6)
        end
    },
    Golden = {
        Id = "Golden",
        Label = "Golden",
        EarningsScalar = 2.5,
        RollWeight = 4,
        IconAssetId = 134818382291054,
        Tint = Color3.fromRGB(251, 255, 0),
        Apply = function(_, p8, p9) -- Apply | line: 58
            -- upvalues: Visuals (copy)
            Visuals.ApplyGolden(p8, p9)
        end,
        Clear = function(_, p11, p12) -- Clear | line: 61
            -- upvalues: Visuals (copy)
            Visuals.ClearGolden(p11, p12)
        end
    },
    Rainbow = {
        Id = "Rainbow",
        Label = "Rainbow",
        EarningsScalar = 3.5,
        RollWeight = 1,
        IconAssetId = 85288683002868,
        Tint = Color3.fromRGB(255, 0, 255),
        Apply = function(_, p14, p15) -- Apply | line: 73
            -- upvalues: Visuals (copy)
            Visuals.ApplyRainbow(p14, p15)
        end,
        Clear = function(_, p17, p18) -- Clear | line: 76
            -- upvalues: Visuals (copy)
            Visuals.ClearRainbow(p17, p18)
        end
    },
    Monstrous = {
        Id = "Monstrous",
        Label = "Parasite",
        EarningsScalar = 3,
        RollWeight = 0,
        EggModelName = "Monstrous Egg",
        EggDisplayName = "Parasite Egg",
        EggIcon = "rbxassetid://121553987798547",
        Tint = Color3.fromRGB(65, 21, 138),
        Apply = function(p19, p20, p21) -- Apply | line: 91
            -- upvalues: Visuals (copy)
            Visuals.ApplyBloom(p20, p21, "Monstrous", "Cleanup_Monstrous", p19.Tint, 0.5)
        end,
        Clear = function(_, p23, p24) -- Clear | line: 101
            -- upvalues: Visuals (copy)
            Visuals.ClearBloom(p23, p24, "Cleanup_Monstrous")
        end
    },
    Boss = {
        Id = "Boss",
        Label = "Fractured",
        EarningsScalar = 2.75,
        RollWeight = 0,
        EggDisplayName = "Boss Egg",
        EggIcon = "rbxassetid://112428238095917",
        Tint = Color3.fromRGB(8, 8, 8),
        Apply = function(_, p26, p27) -- Apply | line: 116
            -- upvalues: Visuals (copy)
            Visuals.ApplyBlack(p26, p27, "Boss", "Cleanup_Fractured")
        end,
        Clear = function(_, p29, p30) -- Clear | line: 119
            -- upvalues: Visuals (copy)
            Visuals.ClearBlack(p29, p30)
        end
    },
    Scrambled = {
        Id = "Scrambled",
        Label = "Scrambled",
        EarningsScalar = 2.75,
        RollWeight = 0,
        IconAssetId = 134710848063255,
        EggIcon = "rbxassetid://125721810079991",
        Tint = Color3.fromRGB(96, 220, 82),
        Apply = function(p31, p32, p33) -- Apply | line: 132
            -- upvalues: Visuals (copy), ScrambledVisuals (copy)
            Visuals.ApplyTint(p32, p31.Tint, 0.65)
            ScrambledVisuals.Apply(p32, p33)
        end,
        Clear = function(_, p35, _) -- Clear | line: 136
            -- upvalues: Visuals (copy), ScrambledVisuals (copy)
            Visuals.ClearTint(p35)
            ScrambledVisuals.Clear(p35)
        end
    },
    Enchanted = {
        Id = "Enchanted",
        Label = "Enchanted",
        EarningsScalar = 2.85,
        RollWeight = 0,
        IconAssetId = 73528861998418,
        Tint = Color3.fromRGB(0, 235, 255),
        Apply = function(p37, p38, p39) -- Apply | line: 149
            -- upvalues: Visuals (copy)
            Visuals.ApplyBloom(p38, p39, "Enchanted", "Cleanup_Enchanted", p37.Tint, 0.55, 0.1)
        end,
        Clear = function(_, p41, p42) -- Clear | line: 160
            -- upvalues: Visuals (copy)
            Visuals.ClearBloom(p41, p42, "Cleanup_Enchanted")
        end
    },
    Nitro = {
        Id = "Nitro",
        Label = "Nitro",
        EarningsScalar = 2.75,
        RollWeight = 0,
        IconAssetId = 134287739122547,
        Tint = Color3.fromRGB(255, 249, 83),
        Apply = function(p43, p44, p45) -- Apply | line: 173
            -- upvalues: Visuals (copy)
            local v1 = if p45 then math.clamp(math.max(p45.Size.X, p45.Size.Y, p45.Size.Z) / 21.4, 0.1, 1.5) else nil

            Visuals.ApplyBloom(p44, p45, "Nitro", "Cleanup_Nitro", p43.Tint, 0.55, v1)
        end,
        Clear = function(_, p47, p48) -- Clear | line: 179
            -- upvalues: Visuals (copy)
            Visuals.ClearBloom(p47, p48, "Cleanup_Nitro")
        end
    },
    Spectral = {
        Id = "Spectral",
        Label = "Spectral",
        EarningsScalar = 2.75,
        RollWeight = 0,
        IconAssetId = 108054256583165,
        Tint = Color3.fromRGB(38, 109, 83),
        Apply = function(p49, p50, p51) -- Apply | line: 191
            -- upvalues: Visuals (copy)
            local v3 = if p51 then math.clamp(math.max(p51.Size.X, p51.Size.Y, p51.Size.Z) / 78.6, 0.1, 1.5) else nil

            Visuals.ApplyBloom(p50, p51, "Spectral", "Cleanup_Spectral", p49.Tint, 0.65, v3)
        end,
        Clear = function(_, p53, p54) -- Clear | line: 197
            -- upvalues: Visuals (copy)
            Visuals.ClearBloom(p53, p54, "Cleanup_Spectral")
        end
    },
    Sakura = {
        Id = "Sakura",
        Label = "Bloom",
        EarningsScalar = 1.25,
        RollWeight = 0,
        IconAssetId = 71612969542341,
        Tint = Color3.fromRGB(255, 196, 222),
        Apply = function(p55, p56, p57) -- Apply | line: 209
            -- upvalues: Visuals (copy)
            Visuals.ApplyBloom(p56, p57, "Sakura", "Cleanup_Sakura", p55.Tint)
        end,
        Clear = function(_, p59, p60) -- Clear | line: 212
            -- upvalues: Visuals (copy)
            Visuals.ClearBloom(p59, p60, "Cleanup_Sakura")
        end
    },
    GreatBloom = {
        Id = "GreatBloom",
        Label = "Spirit Bloom",
        EarningsScalar = 2.5,
        RollWeight = 0,
        IconAssetId = 70859376044018,
        Tint = Color3.fromRGB(60, 255, 140),
        Apply = function(p61, p62, p63) -- Apply | line: 224
            -- upvalues: Visuals (copy)
            Visuals.ApplyBloom(p62, p63, "GreatBloom", "Cleanup_GreatBloom", p61.Tint)
        end,
        Clear = function(_, p65, p66) -- Clear | line: 227
            -- upvalues: Visuals (copy)
            Visuals.ClearBloom(p65, p66, "Cleanup_GreatBloom")
        end
    }
}

for _, v5 in t1 do
    table.freeze(v5)
end

return require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.Mutations", t1, {
    EarningsScalar = true,
    RollWeight = true
}, true, function(p67) -- line: 242
    local n1 = 0

    for _, v6 in p67 do
        n1 += v6.RollWeight
    end

    assert(n1 < 100)
end)
