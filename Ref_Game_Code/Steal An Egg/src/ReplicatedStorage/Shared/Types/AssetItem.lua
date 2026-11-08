-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(script.Parent.Parent.Parent.Data.Assets)

local t = require(ReplicatedStorage.Packages.t)
local v1 = t.union(t.literal("Male"), t.literal("Female"))
local t1 = {}

t1.AssetItemData = t.interface({
    Category = t.string,
    Mutations = t.array(t.string),
    BaseMutation = t.optional(t.string),
    Scale = t.number,
    Gender = t.optional(v1),
    EyeColor = t.optional(t.string),
    ColorSeed = t.optional(t.number),
    ColorIndex = t.optional(t.number),
    IsFavorite = t.optional(t.boolean),
    GeneratedMoney = t.optional(t.number),
    LastTick = t.optional(t.number),
    PendingEggName = t.optional(t.string),
    Claimed = t.optional(t.boolean),
    LuckyBlockUnlockTimestamp = t.optional(t.number),
    LuckyBlockUnlockDuration = t.optional(t.number),
    LuckyBlockInstantUnlock = t.optional(t.boolean),
    InFuse = t.optional(t.boolean),
    Rideable = t.optional(t.boolean),
    SpecialLuckyBlockColumn = t.optional(t.number),
    SpecialLuckyBlockCapturedAt = t.optional(t.number),
    Personality = t.optional(t.string),
    HasBeenFirstPlaced = t.optional(t.boolean),
    IsStolenDNA = t.optional(t.boolean),
    CreatorTemporary = t.optional(t.boolean)
})
t1.AssetItemDataArray = t.array(t1.AssetItemData)
t1.SerializedAssetItemData = t.interface({
    Category = t.string,
    Mutations = t.array(t.string),
    BaseMutation = t.optional(t.string),
    Scale = t.number,
    Gender = t.optional(v1),
    EyeColor = t.optional(t.string),
    ColorSeed = t.optional(t.number),
    ColorIndex = t.optional(t.number),
    IsFavorite = t.optional(t.boolean),
    GeneratedMoney = t.optional(t.number),
    LastTick = t.optional(t.number),
    PendingEggName = t.optional(t.string),
    Claimed = t.optional(t.boolean),
    LuckyBlockUnlockTimestamp = t.optional(t.number),
    LuckyBlockUnlockDuration = t.optional(t.number),
    LuckyBlockInstantUnlock = t.optional(t.boolean),
    InFuse = t.optional(t.boolean),
    Rideable = t.optional(t.boolean),
    SpecialLuckyBlockColumn = t.optional(t.number),
    SpecialLuckyBlockCapturedAt = t.optional(t.number),
    Personality = t.optional(t.string),
    HasBeenFirstPlaced = t.optional(t.boolean),
    IsStolenDNA = t.optional(t.boolean),
    CreatorTemporary = t.optional(t.boolean)
})

return t1
