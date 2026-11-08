-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local v1 = table.freeze({
    Whale = "blue Whale pad",
    Lion = "orange Lion pad"
})
local v2 = table.freeze({
    Whale = "blue",
    Lion = "orange"
})

local function nameOf(p1) -- line: 9
    -- upvalues: Assets (copy)
    local v3 = if type(p1) == "string" then Assets.Directory[p1] else nil

    if not (v3 and v3.DisplayName) then
        return "pet"
    end

    return v3.DisplayName
end

local function recipeOf(p2) -- line: 14
    return if type(p2) == "table" then p2.Enchanted else nil
end

return table.freeze({
    Id = "Enchanted",
    RarityLocked = false,
    Sequence = "EnchantedPond",
    HideHud = true,
    Tiers = table.freeze({ "Enchanted" }),
    Sides = table.freeze({ "Whale", "Lion" }),
    Pads = table.freeze({
        Whale = "WhalePad",
        Lion = "LionPad"
    }),
    Colors = table.freeze({
        Whale = Color3.fromRGB(70, 182, 255),
        Lion = Color3.fromRGB(255, 164, 46)
    }),
    Placement = table.freeze({
        Players = 2,
        Reach = 16,
        Slots = table.freeze({
            WhalePad = "Whale",
            WhalePad2 = "Whale",
            LionPad = "Lion",
            LionPad2 = "Lion"
        }),
        Seats = table.freeze({
            table.freeze({ "WhalePad", "LionPad2" }),
            table.freeze({ "WhalePad2", "LionPad" })
        }),
        Sizes = table.freeze({
            Whale = 13,
            Lion = 8
        }),
        Hover = table.freeze({
            Whale = 6.5,
            Lion = 0
        }),
        StatusHeights = table.freeze({
            Whale = 19,
            Lion = 12
        })
    }),
    Billboard = table.freeze({
        Template = "FusionShrineBillboard_Enchanted",
        Mode = "Sides",
        PerSide = true,
        Columns = table.freeze({
            Whale = "WhaleColumn",
            Lion = "LionColumn"
        }),
        Styles = table.freeze({
            READY = "LionColumn",
            MISSING = "WhaleColumn"
        })
    }),
    PadVfx = table.freeze({
        DiscDiameter = 9.8,
        OrbRadius = 5.2,
        OrbSize = 0.55,
        FieldSize = 84,
        ArcCurve = 26,
        ArcWidth = 0,
        StatusHeight = 7.5,
        HintHeight = 15.5
    }),
    Copy = table.freeze({
        Mismatch = "Both pets must belong to the Enchanted Fusion.",
        Hold = function(p3, p4) -- Hold | line: 65
            -- upvalues: Assets (copy), v1 (copy)
            local Enchanted = if type(p4) == "table" then p4.Enchanted else nil
            local v4 = Enchanted and Enchanted[p3]
            local v5 = if type(v4) == "string" then Assets.Directory[v4] else nil

            return (("Hold a %* on the %*."):format(if not (v5 and v5.DisplayName) then "pet" else v5.DisplayName, v1[p3]))
        end,
        Stand = function(p5) -- Stand | line: 69
            -- upvalues: v1 (copy)
            return (("Stand on the %* holding your pet."):format(v1[p5]))
        end,
        WrongPad = function(p6) -- WrongPad | line: 72
            -- upvalues: v1 (copy)
            return (("Move to the %*."):format(v1[p6]))
        end,
        Ready = function(p7, p8) -- Ready | line: 75
            -- upvalues: Assets (copy), v1 (copy)
            local v6 = p7[1]
            local v7 = p8[v6]
            local v8 = if type(v7) == "string" then Assets.Directory[v7] else nil

            return (("Partner needs a %* on the %*. Both pets will be used up."):format(if not (v8 and v8.DisplayName) then "pet" else v8.DisplayName, v1[v6]))
        end,
        Done = function() -- Done | line: 79
            return "Enchanted Fusion already done. Once per account."
        end,
        Place = function(p9, p10) -- Place | line: 83
            -- upvalues: Assets (copy)
            local Enchanted = if type(p10) == "table" then p10.Enchanted else nil
            local v9 = Enchanted and Enchanted[p9]
            local v10 = if type(v9) == "string" then Assets.Directory[v9] else nil

            return (("Place %*"):format(if not (v10 and v10.DisplayName) then "pet" else v10.DisplayName))
        end,
        PlaceOn = function(p11) -- PlaceOn | line: 87
            -- upvalues: v2 (copy)
            return (("Wrong pad, try %*"):format(v2[p11]))
        end,
        Placed = function() -- Placed | line: 90
            return "Wait for a partner!"
        end,
        AlreadyPlaced = function(_, p13, p14) -- AlreadyPlaced | line: 93
            -- upvalues: Assets (copy)
            local Enchanted = if type(p13) == "table" then p13.Enchanted else nil

            if not p14 then
                return "This is your partner's pad"
            end

            local v11 = Enchanted and Enchanted[p14]
            local v12 = if type(v11) == "string" then Assets.Directory[v11] else nil

            return (("This is your partner's pad, place your %*"):format(if not (v12 and v12.DisplayName) then "pet" else v12.DisplayName))
        end,
        HoldToPlace = function(p15, p16) -- HoldToPlace | line: 100
            -- upvalues: Assets (copy)
            local Enchanted = if type(p16) == "table" then p16.Enchanted else nil
            local v13 = Enchanted and Enchanted[p15]
            local v14 = if type(v13) == "string" then Assets.Directory[v13] else nil

            return (("Hold a %*"):format(if not (v14 and v14.DisplayName) then "pet" else v14.DisplayName))
        end,
        Info = function(p17) -- Info | line: 104
            -- upvalues: Assets (copy)
            local v15 = (if type(p17) == "table" then p17.Enchanted else nil) or {}
            local Whale = v15.Whale
            local v16 = if type(Whale) == "string" then Assets.Directory[Whale] else nil
            local v17 = if not (v16 and v16.DisplayName) then "pet" else v16.DisplayName
            local Lion = v15.Lion
            local v18 = if type(Lion) == "string" then Assets.Directory[Lion] else nil

            return (("2 players, each brings a %* for a blue pad and a %* for an orange pad. Once per account."):format(v17, if not (v18 and v18.DisplayName) then "pet" else v18.DisplayName))
        end
    })
})
