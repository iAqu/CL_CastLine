-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "common",
    "uncommon",
    "rare",
    "epic",
    "legendary",
    "mythic"
}
local t2 = {
    common = "Common",
    uncommon = "Uncommon",
    rare = "Rare",
    epic = "Epic",
    legendary = "Legendary",
    mythic = "Mythic",
    godly = "Godly",
    secret = "Secret",
    hacked = "Hacked",
    cosmic = "Cosmic",
    extinct = "Extinct",
    kaijuwu = "Kaijuwu",
    scifi = "Scifi",
    exclusive = "Exclusive"
}

return {
    upgradeRarity = function(p1) -- upgradeRarity | line: 21
        -- upvalues: t1 (copy)
        return t1[math.min((table.find(t1, p1) or 0) - 1 + 1, #t1 - 1) + 1]
    end,
    fishRarityTiers = t1,
    fishRarityFolderName = t2
}
