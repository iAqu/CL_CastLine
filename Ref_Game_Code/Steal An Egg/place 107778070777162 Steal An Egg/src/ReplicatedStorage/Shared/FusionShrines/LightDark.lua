-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return table.freeze({
    Id = "LightDark",
    RarityLocked = true,
    Sequence = "Orbit",
    HideHud = false,
    Tiers = table.freeze({ "Divine", "Eternal" }),
    Sides = table.freeze({ "Light", "Dark" }),
    Pads = table.freeze({
        Light = "LightPad",
        Dark = "DarkPad"
    }),
    Colors = table.freeze({
        Light = Color3.fromRGB(255, 209, 74),
        Dark = Color3.fromRGB(198, 42, 32)
    }),
    Billboard = table.freeze({
        Template = "FusionShrineBillboard",
        Mode = "Tiers",
        Columns = table.freeze({
            Divine = "DivineColumn",
            Eternal = "EternalColumn"
        }),
        Styles = table.freeze({
            COMPLETED = "DivineColumn",
            AVAILABLE = "EternalColumn"
        })
    }),
    PadVfx = table.freeze({}),
    Copy = table.freeze({
        Mismatch = "Both pets must be Divine, or both Eternal.",
        Hold = function(p1) -- Hold | line: 22
            return (("Hold a %* Divine or Eternal pet."):format(p1))
        end,
        Stand = function(p2) -- Stand | line: 25
            return (("Stand on the %* pad with your pet."):format(p2))
        end,
        WrongPad = function(p3) -- WrongPad | line: 28
            return (("Move to the %* pad."):format(p3))
        end,
        Ready = function(p4, p5) -- Ready | line: 31
            local v1 = p4[1]

            return (("Partner needs %* on the %* pad. Both pets will be used up."):format(p5[v1], v1))
        end,
        Done = function(p6) -- Done | line: 35
            return (("%* Fusion already done. Once per account."):format(p6))
        end,
        Info = function() -- Info | line: 39
            return "2 players. Light + Dark pets, both Divine or both Eternal. Each fusion: once per account."
        end
    })
})
