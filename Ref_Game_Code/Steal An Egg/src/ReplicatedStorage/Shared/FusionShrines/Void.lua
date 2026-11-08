-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local v1 = table.freeze({
    Fish = "fish pedestal",
    Pumpkin = "pumpkin pedestal"
})

local function nameOf(p1) -- line: 8
    -- upvalues: Assets (copy)
    local v2 = if type(p1) == "string" then Assets.Directory[p1] else nil

    if not (v2 and v2.DisplayName) then
        return "pet"
    end

    return v2.DisplayName
end

local function recipeOf(p2) -- line: 13
    return if type(p2) == "table" then p2.Void else nil
end

return table.freeze({
    Id = "Void",
    RarityLocked = false,
    Sequence = "VoidRitual",
    HideHud = true,
    Tiers = table.freeze({ "Void" }),
    Sides = table.freeze({ "Fish", "Pumpkin" }),
    Pads = table.freeze({
        Fish = "FishPad",
        Pumpkin = "PumpkinPad"
    }),
    Colors = table.freeze({
        Fish = Color3.fromRGB(120, 230, 255),
        Pumpkin = Color3.fromRGB(176, 76, 255)
    }),
    Placement = table.freeze({
        Players = 2,
        Reach = 16,
        Slots = table.freeze({
            FishPad = "Fish",
            FishPad2 = "Fish",
            PumpkinPad = "Pumpkin",
            PumpkinPad2 = "Pumpkin"
        }),
        Seats = table.freeze({
            table.freeze({ "FishPad", "PumpkinPad" }),
            table.freeze({ "FishPad2", "PumpkinPad2" })
        }),
        Sizes = table.freeze({
            Fish = 6.5,
            Pumpkin = 6
        }),
        Hover = table.freeze({
            Fish = 0.6,
            Pumpkin = 0
        }),
        StatusHeights = table.freeze({
            Fish = 10.5,
            Pumpkin = 10.5
        })
    }),
    Billboard = table.freeze({
        Template = "FusionShrineBillboard_Void",
        Mode = "Sides",
        PerSide = true,
        Columns = table.freeze({
            Fish = "FishColumn",
            Pumpkin = "PumpkinColumn"
        }),
        Styles = table.freeze({
            READY = "PumpkinColumn",
            MISSING = "FishColumn"
        })
    }),
    PadVfx = table.freeze({
        DiscDiameter = 7,
        OrbRadius = 4.4,
        OrbSize = 0.45,
        OrbHeight = 1.6,
        FieldSize = 50,
        ArcCurve = 0,
        ArcWidth = 0,
        StatusHeight = 10.5,
        HintHeight = 14
    }),
    Copy = table.freeze({
        Mismatch = "Both pets must belong to the Void Fusion.",
        Hold = function(p3, p4) -- Hold | line: 65
            -- upvalues: Assets (copy), v1 (copy)
            local Void = if type(p4) == "table" then p4.Void else nil
            local v3 = Void and Void[p3]
            local v4 = if type(v3) == "string" then Assets.Directory[v3] else nil

            return (("Hold a %* at the %*."):format(if not (v4 and v4.DisplayName) then "pet" else v4.DisplayName, v1[p3]))
        end,
        Stand = function(p5) -- Stand | line: 69
            -- upvalues: v1 (copy)
            return (("Stand by the %* holding your pet."):format(v1[p5]))
        end,
        WrongPad = function(p6) -- WrongPad | line: 72
            -- upvalues: v1 (copy)
            return (("Use the %*."):format(v1[p6]))
        end,
        Ready = function(p7, p8) -- Ready | line: 75
            -- upvalues: Assets (copy), v1 (copy)
            local v5 = p7[1]
            local v6 = p8[v5]
            local v7 = if type(v6) == "string" then Assets.Directory[v6] else nil

            return (("Partner needs a %* on the %*. Both pets will be used up."):format(if not (v7 and v7.DisplayName) then "pet" else v7.DisplayName, v1[v5]))
        end,
        Done = function() -- Done | line: 79
            return "Void Fusion already done. Once per account."
        end,
        Place = function(p9, p10) -- Place | line: 83
            -- upvalues: Assets (copy)
            local Void = if type(p10) == "table" then p10.Void else nil
            local v8 = Void and Void[p9]
            local v9 = if type(v8) == "string" then Assets.Directory[v8] else nil

            return (("Place %*"):format(if not (v9 and v9.DisplayName) then "pet" else v9.DisplayName))
        end,
        PlaceOn = function(p11) -- PlaceOn | line: 87
            return (("Wrong pedestal, try the %* one"):format((string.lower(p11))))
        end,
        Placed = function() -- Placed | line: 90
            return "Wait for a partner!"
        end,
        AlreadyPlaced = function(_, p13, p14) -- AlreadyPlaced | line: 93
            -- upvalues: Assets (copy)
            local Void = if type(p13) == "table" then p13.Void else nil

            if not p14 then
                return "This is your partner's pedestal"
            end

            local v10 = Void and Void[p14]
            local v11 = if type(v10) == "string" then Assets.Directory[v10] else nil

            return (("This is your partner's pedestal, place your %*"):format(if not (v11 and v11.DisplayName) then "pet" else v11.DisplayName))
        end,
        HoldToPlace = function(p15, p16) -- HoldToPlace | line: 102
            -- upvalues: Assets (copy)
            local Void = if type(p16) == "table" then p16.Void else nil
            local v12 = Void and Void[p15]
            local v13 = if type(v12) == "string" then Assets.Directory[v12] else nil

            return (("Hold a %*"):format(if not (v13 and v13.DisplayName) then "pet" else v13.DisplayName))
        end,
        Unpaired = function(p17) -- Unpaired | line: 106
            -- upvalues: Assets (copy)
            local v14 = (if type(p17) == "table" then p17.Void else nil) or {}
            local Fish = v14.Fish
            local v15 = if type(Fish) == "string" then Assets.Directory[Fish] else nil
            local v16 = if not (v15 and v15.DisplayName) then "pet" else v15.DisplayName
            local Pumpkin = v14.Pumpkin
            local v17 = if type(Pumpkin) == "string" then Assets.Directory[Pumpkin] else nil

            return (("Each player needs a %* and a %*"):format(v16, if not (v17 and v17.DisplayName) then "pet" else v17.DisplayName))
        end,
        Info = function(p18) -- Info | line: 110
            -- upvalues: Assets (copy)
            local v18 = (if type(p18) == "table" then p18.Void else nil) or {}
            local Fish = v18.Fish
            local v19 = if type(Fish) == "string" then Assets.Directory[Fish] else nil
            local v20 = if not (v19 and v19.DisplayName) then "pet" else v19.DisplayName
            local Pumpkin = v18.Pumpkin
            local v21 = if type(Pumpkin) == "string" then Assets.Directory[Pumpkin] else nil

            return (("2 players, each brings a %* and a %*. Once per account."):format(v20, if not (v21 and v21.DisplayName) then "pet" else v21.DisplayName))
        end
    })
})
