-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    LuckyBlockRewardDescriptor = t.interface({
        Category = t.string,
        Mutations = t.array(t.string),
        BaseMutation = t.optional(t.string),
        Scale = t.number
    })
}

t1.LuckyBlockOpenAnimationPayload = t.interface({
    ownerUserId = t.number,
    uid = t.string,
    blockCategory = t.string,
    reward = t1.LuckyBlockRewardDescriptor,
    dropTable = t.array(t.array(t.union(t.string, t.number))),
    pivot = t.CFrame,
    rollDuration = t.optional(t.number),
    skipRoll = t.optional(t.boolean)
})
t1.SpecialLuckyBlockCaptureAnimationPayload = t.interface({
    ownerUserId = t.number,
    spawnId = t.string,
    category = t.string,
    mutations = t.array(t.string),
    baseMutation = t.optional(t.string),
    scale = t.number,
    pivot = t.CFrame,
    cagePivot = t.optional(t.CFrame),
    cageScale = t.optional(t.number)
})
t1.SpecialLuckyBlockReadySignalPayload = t.interface({
    initialLoadComplete = t.boolean,
    screenReady = t.boolean,
    isReady = t.boolean,
    roundState = t.optional(t.string),
    spectating = t.optional(t.boolean),
    resultsOverlayOpen = t.optional(t.boolean),
    lobbyTutorialVisualState = t.optional(t.string)
})

return t1
