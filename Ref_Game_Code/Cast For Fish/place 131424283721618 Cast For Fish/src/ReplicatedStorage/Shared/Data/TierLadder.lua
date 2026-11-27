-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    Id = "Thanksgiving2026",
    Name = "Thanksgiving Pack",
    Npc = "Harvest Merchant",
    StartsAt = 1795496400,
    EndsAt = 1795928340,
    Shown = 5,
    Tiers = {
        {
            price = 49,
            id = 3735740167,
            legacyId = 3735339231,
            reward = {
                kind = "egg",
                key = "CosmicEgg",
                n = 1
            }
        },
        {
            reward = {
                kind = "cash",
                mins = 5,
                min = 1000
            }
        },
        {
            reward = {
                kind = "lucky",
                n = 1
            }
        },
        {
            reward = {
                kind = "potion",
                n = 1
            }
        },
        {
            price = 49,
            id = 3735740225,
            legacyId = 3735339308,
            reward = {
                kind = "lucky",
                n = 3
            }
        },
        {
            reward = {
                kind = "potion",
                buff = "luck",
                n = 2,
                seconds = 300
            }
        },
        {
            reward = {
                kind = "cash",
                mins = 5,
                min = 1000
            }
        },
        {
            price = 49,
            id = 3735740351,
            legacyId = 3735339536,
            reward = {
                kind = "fish",
                fish = "butterball_blowfish",
                v = 1,
                s = 1
            }
        },
        {
            reward = {
                kind = "potion",
                n = 1
            }
        },
        {
            highlight = "HALFWAY!",
            price = 129,
            id = 3735740466,
            legacyId = 3735339630,
            reward = {
                kind = "bait",
                bait = "feast_bait"
            }
        },
        {
            reward = {
                kind = "potion",
                buff = "luck",
                n = 1,
                seconds = 600
            }
        },
        {
            price = 129,
            id = 3735740510,
            legacyId = 3735339759,
            reward = {
                kind = "egg",
                key = "CosmicEgg",
                n = 3
            }
        },
        {
            reward = {
                kind = "cash",
                mins = 10,
                min = 2000
            }
        },
        {
            price = 129,
            id = 3735740592,
            legacyId = 3735339835,
            reward = {
                kind = "fish",
                fish = "pumpkin_pufferfish",
                v = 1,
                s = 1
            }
        },
        {
            reward = {
                kind = "potion",
                n = 2
            }
        },
        {
            price = 249,
            id = 3735740662,
            legacyId = 3735339908,
            reward = {
                kind = "rod",
                rod = "harvest_rod"
            }
        },
        {
            reward = {
                kind = "cash",
                mins = 10,
                min = 2000
            }
        },
        {
            price = 249,
            id = 3735740757,
            legacyId = 3735339983,
            reward = {
                kind = "fish",
                fish = "cran_bass",
                v = 1,
                s = 1
            }
        },
        {
            highlight = "LAST FREE!",
            reward = {
                kind = "potion",
                buff = "strength",
                n = 1,
                seconds = 600
            }
        },
        {
            price = 499,
            id = 3735740819,
            legacyId = 3735340056,
            grand = true,
            reward = {
                kind = "fish",
                fish = "golden_gobbler_marlin",
                v = 1,
                s = 1
            }
        }
    }
}

function t1.Now() -- line: 35
    -- upvalues: ReplicatedStorage (copy)
    return workspace:GetServerTimeNow() + (tonumber(ReplicatedStorage:GetAttribute("LadderClockOffset")) or 0)
end

function t1.Started(p1) -- line: 39
    -- upvalues: t1 (copy)
    return (p1 or t1.Now()) >= t1.StartsAt
end

function t1.Active(p2) -- line: 43
    -- upvalues: t1 (copy)
    p2 = p2 or t1.Now()

    if t1.StartsAt <= p2 then
        return p2 < t1.EndsAt
    end

    return false
end

function t1.IsPaid(p3) -- line: 48
    -- upvalues: t1 (copy)
    local v2 = t1.Tiers[p3]

    return v2 ~= nil and v2.price ~= nil
end

function t1.Price(p4) -- line: 53
    -- upvalues: t1 (copy)
    local v3 = t1.Tiers[p4]

    if not (v3 and v3.price) then
        return nil, nil
    end

    return v3.price, v3.id
end

function t1.FindProduct(p5) -- line: 61
    -- upvalues: t1 (copy)
    if type(p5) ~= "number" or p5 == 0 then
        return nil, nil
    end

    for v4, v5 in ipairs(t1.Tiers) do
        if v5.id == p5 or v5.legacyId == p5 then
            return v4, v5
        end
    end

    return nil, nil
end

function t1.Progress(p6) -- line: 73
    -- upvalues: t1 (copy)
    if type(p6) ~= "table" or p6.id ~= t1.Id then
        return 0
    end

    return (math.clamp(math.floor(tonumber(p6.tier) or 0), 0, #t1.Tiers))
end

function t1.Cash(p7, p8) -- line: 80
    return (math.max(p7.min or 0, (math.floor((p8 or 0) * 60 * (p7.mins or 0)))))
end

function t1.Clock(p9, p10) -- line: 84
    local v13 = math.max(0, (math.floor(p9)))
    local v14 = v13 // 86400
    local v15 = v13 % 86400 // 3600
    local v16 = v13 % 3600 // 60

    if p10 then
        if v14 > 0 then
            return string.format("%dd %02dh %02dm %02ds", v14, v15, v16, v13 % 60)
        end

        return string.format("%02dh %02dm %02ds", v15, v16, v13 % 60)
    end

    if v14 > 0 then
        return string.format("%dd %dh", v14, v15)
    end

    return string.format("%dh %02dm", v15, v16)
end

return t1
