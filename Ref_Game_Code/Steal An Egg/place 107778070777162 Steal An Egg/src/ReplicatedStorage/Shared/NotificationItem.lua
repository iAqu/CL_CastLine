-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local Directory = require(ReplicatedStorage.Data.Currency).Directory
local Directory2 = require(ReplicatedStorage.Data.Gears).Directory
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local MonsterParasite2 = require(ReplicatedStorage.Shared.Types.MonsterParasite)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.string, function(p1) -- line: 68
    return #p1 > 0
end)
local v2 = t.intersection(t.integer, t.numberPositive)
local t1 = {
    Schema = t.union(t.strictInterface({
        Kind = t.literal("Currency"),
        Id = v1,
        Amount = v2
    }), t.strictInterface({
        Kind = t.literal("Gear"),
        Id = v1,
        Amount = v2
    }), t.strictInterface({
        Kind = t.literal("SpeedPower"),
        Amount = v2
    }), t.strictInterface({
        Kind = t.literal("TemporarySpeedBoost"),
        Amount = v2
    }), t.strictInterface({
        Kind = t.literal("MonsterChestReward"),
        Id = v1,
        Amount = v2
    }), t.strictInterface({
        Kind = t.literal("Egg"),
        Id = v1,
        Amount = v2,
        Mutation = t.optional(v1)
    }))
}
local t2 = {
    [MonsterParasite2.RewardIds.MonsterEgg] = "Prismatic"
}
local t3 = {
    [250000] = "rbxassetid://119640363267627",
    [1E+06] = "rbxassetid://119640363267627",
    [5E+06] = "rbxassetid://119640363267627"
}

local function currencyIcon(p2, p3) -- line: 123
    -- upvalues: t3 (copy)
    local v3 = p2.Icon or ""
    local n1 = 0

    for v4, v5 in pairs(t3) do
        if v4 <= p3 and n1 < v4 then
            n1 = v4
            v3 = v5
        end
    end

    return v3
end

function t1.Describe(p4) -- line: 135
    -- upvalues: Assets (copy), Directory (copy), Directory2 (copy), MonsterParasite (copy), Rarity (copy), TreadmillUtil (copy), t1 (copy), t2 (copy), currencyIcon (copy)
    assert(t1.Schema(p4), "invalid notification item")

    if p4.Kind == "Currency" then
        local v9 = assert(Directory[p4.Id], (("unknown currency notification id: %*"):format(p4.Id)))

        return {
            Name = v9.DisplayName or "",
            Description = v9.Desc or "",
            Icon = currencyIcon(v9, p4.Amount),
            Rarity = v9.Rarity or Rarity.Rarities.Rare
        }
    end

    if p4.Kind == "Gear" then
        local v12 = assert(Directory2[p4.Id], (("unknown gear notification id: %*"):format(p4.Id)))

        return {
            Name = v12.DisplayName or "",
            Description = v12.Description or "",
            Icon = v12.Icon or "",
            Rarity = Rarity.Rarities[v12.Rarity] or Rarity.Rarities.Common
        }
    end

    if p4.Kind == "Egg" then
        local v15 = assert(Assets.Directory[p4.Id], (("unknown egg notification id: %*"):format(p4.Id)))
        local v16 = v15.Egg.DisplayName or ""

        return {
            Description = "",
            Name = if p4.Mutation ~= nil then ("%* %*"):format(p4.Mutation, v16) else v16,
            Icon = if v15.Egg.Icon == "" then Assets.BaseConfig.Egg.Icon else v15.Egg.Icon,
            Rarity = v15.Rarity
        }
    end

    if p4.Kind == "TemporarySpeedBoost" then
        local v19 = math.max(math.floor(p4.Amount / 60 + 0.5), 1)

        return {
            Icon = "rbxassetid://78137530993637",
            Name = ("x%* Speed Boost"):format((TreadmillUtil.GetTemporarySpeedBoostMultiplier())),
            Description = ("%* MINUTES"):format(v19),
            Rarity = Rarity.Rarities.Rare
        }
    end

    if p4.Kind ~= "MonsterChestReward" then
        return {
            Name = "Speed Power",
            Description = "SPEED",
            Icon = "rbxassetid://78137530993637",
            Rarity = Rarity.Rarities.Rare
        }
    end

    local v20 = MonsterParasite.GetReward(p4.Id)
    local v21 = t2[p4.Id] or v20.Rarity

    return {
        Name = v20.DisplayName,
        Description = v20.DisplayNote or "",
        Icon = v20.Icon or "rbxassetid://78137530993637",
        Rarity = Rarity.Rarities[v21] or Rarity.Rarities.Common
    }
end

return t1
