-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    MULT = 3,
    KINDS = {
        Fat = {
            name = "Fat Potion",
            square = "rbxassetid://74288875248840",
            color = Color3.fromRGB(255, 50, 150),
            ink = {
                Color3.fromRGB(255, 190, 230),
                Color3.fromRGB(235, 40, 150),
                Color3.fromRGB(70, 0, 40)
            }
        },
        Bag = {
            name = "Bag Potion",
            square = "rbxassetid://103768238462744",
            color = Color3.fromRGB(40, 140, 255),
            ink = {
                Color3.fromRGB(205, 235, 255),
                Color3.fromRGB(40, 140, 255),
                Color3.fromRGB(0, 30, 80)
            }
        },
        Body = {
            name = "Body Potion",
            color = Color3.fromRGB(30, 215, 185)
        },
        Mutation = {
            name = "Mutation Potion",
            color = Color3.fromRGB(175, 80, 255)
        },
        Catch = {
            name = "Double Catch Potion",
            color = Color3.fromRGB(60, 215, 80)
        },
        XP = {
            name = "XP Potion",
            color = Color3.fromRGB(255, 200, 40)
        },
        Slow = {
            name = "Slow Potion",
            color = Color3.fromRGB(110, 210, 255)
        },
        Size = {
            name = "Size Hormones",
            color = Color3.fromRGB(225, 30, 90)
        },
        MegaSize = {
            name = "Mega Hormones",
            color = Color3.fromRGB(225, 30, 90)
        },
        Rainbow = {
            name = "Rainbow Rush",
            color = Color3.fromRGB(255, 90, 200)
        },
        Electric = {
            name = "Electric Rush",
            color = Color3.fromRGB(30, 100, 255)
        },
        Shadow = {
            name = "Shadow Rush",
            color = Color3.fromRGB(130, 60, 200)
        },
        Molten = {
            name = "Molten Rush",
            color = Color3.fromRGB(255, 100, 0)
        },
        Radioactive = {
            name = "Radioactive Rush",
            color = Color3.fromRGB(120, 255, 40)
        }
    },
    TIMED = {
        "Fat",
        "Bag",
        "Mutation",
        "Catch",
        "XP",
        "Slow",
        "Size",
        "MegaSize",
        "Rainbow",
        "Electric",
        "Shadow",
        "Molten",
        "Radioactive"
    },
    RUSH = { "Rainbow", "Electric", "Shadow", "Molten", "Radioactive" },
    ORDER = {
        "T1",
        "T2",
        "T3",
        "T4",
        "B1",
        "B2",
        "B3",
        "Body",
        "Mutation",
        "Catch",
        "XP",
        "Slow",
        "Size",
        "MegaSize",
        "Rainbow",
        "Electric",
        "Shadow",
        "Molten",
        "Radioactive"
    },
    TIERS = {
        T1 = {
            kind = "Fat",
            tier = 1,
            minutes = 5,
            icon = "rbxassetid://109553208697188"
        },
        T2 = {
            kind = "Fat",
            tier = 2,
            minutes = 10,
            icon = "rbxassetid://73655192710522"
        },
        T3 = {
            kind = "Fat",
            tier = 3,
            minutes = 30,
            icon = "rbxassetid://80867338413666"
        },
        T4 = {
            kind = "Fat",
            tier = 4,
            minutes = 60,
            icon = "rbxassetid://120932403916428"
        },
        B1 = {
            kind = "Bag",
            tier = 1,
            minutes = 3,
            bag = 10,
            icon = "rbxassetid://107099780031365"
        },
        B2 = {
            kind = "Bag",
            tier = 2,
            minutes = 3,
            bag = 20,
            icon = "rbxassetid://129683548217546"
        },
        B3 = {
            kind = "Bag",
            tier = 3,
            minutes = 3,
            bag = 30,
            icon = "rbxassetid://119177698598892"
        },
        Body = {
            kind = "Body",
            tier = 1,
            title = "BODY SWAP",
            icon = "rbxassetid://98834051215140"
        },
        Mutation = {
            kind = "Mutation",
            tier = 1,
            minutes = 5,
            luck = 2,
            title = "X2 MUTATION",
            icon = "rbxassetid://90451480008881"
        },
        Catch = {
            kind = "Catch",
            tier = 1,
            minutes = 5,
            double = 0.25,
            title = "+25% DOUBLE CATCH",
            icon = "rbxassetid://110227192828627"
        },
        XP = {
            kind = "XP",
            tier = 1,
            minutes = 5,
            xp = 2,
            title = "X2 XP",
            icon = "rbxassetid://87470385300518"
        },
        Slow = {
            kind = "Slow",
            tier = 1,
            minutes = 5,
            needle = 0.75,
            title = "SLOW NEEDLE",
            icon = "rbxassetid://101338271927414"
        },
        Size = {
            kind = "Size",
            tier = 1,
            minutes = 5,
            size = 1.05,
            title = "+5% SIZE",
            icon = "rbxassetid://87905733933265"
        },
        MegaSize = {
            kind = "MegaSize",
            tier = 1,
            minutes = 5,
            size = 1.1,
            title = "+10% SIZE",
            name = "Mega Hormones",
            icon = "rbxassetid://87905733933265"
        },
        Rainbow = {
            kind = "Rainbow",
            tier = 1,
            minutes = 5,
            mutation = "Rainbow",
            mul = 5,
            title = "X5 RAINBOW",
            icon = "rbxassetid://133831492872054"
        },
        Electric = {
            kind = "Electric",
            tier = 1,
            minutes = 5,
            mutation = "Electric",
            mul = 5,
            title = "X5 ELECTRIC",
            icon = "rbxassetid://129388322087866"
        },
        Shadow = {
            kind = "Shadow",
            tier = 1,
            minutes = 5,
            mutation = "Shadow",
            mul = 5,
            title = "X5 SHADOW",
            icon = "rbxassetid://132930880585368"
        },
        Molten = {
            kind = "Molten",
            tier = 1,
            minutes = 5,
            mutation = "Molten",
            mul = 5,
            title = "X5 MOLTEN",
            icon = "rbxassetid://77466496826873"
        },
        Radioactive = {
            kind = "Radioactive",
            tier = 1,
            minutes = 5,
            mutation = "Radioactive",
            mul = 5,
            title = "X5 RADIOACTIVE",
            icon = "rbxassetid://72481098695189"
        }
    }
}

function t1.Get(p1) -- line: 71
    -- upvalues: t1 (copy)
    return t1.TIERS[p1]
end

function t1.Kind(p2) -- line: 75
    -- upvalues: t1 (copy)
    local v1 = t1.TIERS[p2]

    return v1 and t1.KINDS[v1.kind]
end

function t1.Title(p3, p4) -- line: 82
    -- upvalues: t1 (copy)
    local v2 = t1.TIERS[p3]

    if not v2 then
        return ""
    end

    if v2.title then
        local v3 = if p4 then p4.T(v2.title) else nil

        if not p4 or not v3 then
            v3 = v2.title
        end

        return v3
    end

    if v2.kind == "Bag" then
        local v4 = if p4 then p4.F("potion.bag_title", "+{n} BAG", {
            n = tostring(v2.bag)
        }) else nil

        if not p4 or not v4 then
            v4 = "+" .. v2.bag .. " BAG"
        end

        return v4
    end

    if not p4 then
        return "X" .. t1.MULT .. " FAT"
    end

    return p4.F("potion.title", "X{m} FAT", {
        m = tostring(t1.MULT)
    }) or "X" .. t1.MULT .. " FAT"
end

function t1.Length(p5) -- line: 93
    -- upvalues: t1 (copy)
    local v5 = t1.TIERS[p5]

    if v5 and v5.minutes then
        if not (v5.minutes >= 60) or v5.minutes % 60 ~= 0 then
            return v5.minutes .. " min"
        end

        local v6 = v5.minutes // 60

        if v6 == 1 then
            return "1 hour"
        end

        return v6 .. " hours"
    end

    return ""
end

function t1.LenKey(p6) -- line: 104
    -- upvalues: t1 (copy)
    local v7 = t1.TIERS[p6]

    return "potion.len_" .. (if not v7 or v7.kind ~= "Bag" then p6 else "B3")
end

return t1
