-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Products = require(script.Parent.Products)
local t1 = {
    DAY = 86400,
    Rewards = {
        {
            At = 5,
            Kind = "Cash",
            Minutes = 2,
            Min = 25
        },
        {
            At = 10,
            Kind = "Strength",
            Minutes = 3,
            Min = 10
        },
        {
            At = 15,
            Kind = "Potion",
            Stat = "Cash",
            Seconds = 120
        },
        {
            At = 20,
            Kind = "Cash",
            Minutes = 4,
            Min = 100
        },
        {
            At = 30,
            Kind = "Potion",
            Stat = "Strength",
            Seconds = 180
        },
        {
            At = 45,
            Kind = "Strength",
            Minutes = 8,
            Min = 100
        },
        {
            At = 60,
            Kind = "Cash",
            Minutes = 10,
            Min = 500
        },
        {
            At = 90,
            Kind = "Potion",
            Stat = "Cash",
            Seconds = 300
        }
    },
    amount = function(p1, p2, p3) -- amount | line: 25
        -- upvalues: Products (copy)
        if p1.Kind == "Cash" then
            return Products.scaled(p2, p1.Minutes, p1.Min)
        end

        if p1.Kind == "Strength" then
            return Products.scaled(p3, p1.Minutes, p1.Min)
        end

        return p1.Seconds
    end
}

function t1.day(p4) -- line: 35
    -- upvalues: t1 (copy)
    return p4 // t1.DAY
end

return t1
