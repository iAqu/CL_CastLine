-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local combineProducers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").combineProducers
local sharedSlices = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices").sharedSlices
local currentWindowSlice = RuntimeLib.import(script, script.Parent, "slices", "current-window").currentWindowSlice
local onScreenFeedbackSlice = RuntimeLib.import(script, script.Parent, "slices", "on-screen-feedback").onScreenFeedbackSlice
local freeRewardsUiSlice = RuntimeLib.import(script, script.Parent, "slices", "free-rewards-ui").freeRewardsUiSlice
local communityRewardsUiSlice = RuntimeLib.import(script, script.Parent, "slices", "community-rewards-ui").communityRewardsUiSlice
local tutorialSlice = RuntimeLib.import(script, script.Parent, "slices", "tutorial").tutorialSlice
local trashModeSlice = RuntimeLib.import(script, script.Parent, "slices", "trash-mode").trashModeSlice
local giftUiSlice = RuntimeLib.import(script, script.Parent, "slices", "gift-ui").giftUiSlice
local storeGiftUiSlice = RuntimeLib.import(script, script.Parent, "slices", "store-gift-ui").storeGiftUiSlice
local letterUiSlice = RuntimeLib.import(script, script.Parent, "slices", "letter-ui").letterUiSlice
local storePurchaseSlice = RuntimeLib.import(script, script.Parent, "slices", "store-purchase").storePurchaseSlice
local localCharacterAppearanceSlice = RuntimeLib.import(script, script.Parent, "slices", "local-character-appearance").localCharacterAppearanceSlice
local fishingAreaSlice = RuntimeLib.import(script, script.Parent, "slices", "fishing-area-ui").fishingAreaSlice
local otherPlayerCastsSlice = RuntimeLib.import(script, script.Parent, "slices", "other-player-casts").otherPlayerCastsSlice
local castCutsceneSlice = RuntimeLib.import(script, script.Parent, "slices", "cast-cutscene").castCutsceneSlice
local nibbleActiveFishSlice = RuntimeLib.import(script, script.Parent, "slices", "nibble-active-fish").nibbleActiveFishSlice
local nearBaseUiSlice = RuntimeLib.import(script, script.Parent, "slices", "near-base-ui").nearBaseUiSlice
local aquariumFishHoverSlice = RuntimeLib.import(script, script.Parent, "slices", "aquarium-fish-hover").aquariumFishHoverSlice
local serverRestartSlice = RuntimeLib.import(script, script.Parent, "slices", "server-restart").serverRestartSlice
local frostwyrmAnnouncementSlice = RuntimeLib.import(script, script.Parent, "slices", "frostwyrm-announcement").frostwyrmAnnouncementSlice
local pinataBossDeathAnnouncementSlice = RuntimeLib.import(script, script.Parent, "slices", "pinata-boss-death-announcement").pinataBossDeathAnnouncementSlice
local pinataBossRewardSlice = RuntimeLib.import(script, script.Parent, "slices", "pinata-boss-reward").pinataBossRewardSlice
local pinataBossDamagePopupsSlice = RuntimeLib.import(script, script.Parent, "slices", "pinata-boss-damage-popups").pinataBossDamagePopupsSlice
local rglRewardSlice = RuntimeLib.import(script, script.Parent, "slices", "rgl-reward").rglRewardSlice
local celebrationRewardSlice = RuntimeLib.import(script, script.Parent, "slices", "celebration-reward").celebrationRewardSlice
local minigameRewardSlice = RuntimeLib.import(script, script.Parent, "slices", "minigame-reward").minigameRewardSlice
local shardRewardSlice = RuntimeLib.import(script, script.Parent, "slices", "shard-reward").shardRewardSlice
local v1 = table.clone(sharedSlices)

setmetatable(v1, nil)
v1.currentWindow = currentWindowSlice
v1.onScreenFeedback = onScreenFeedbackSlice
v1.freeRewardsUi = freeRewardsUiSlice
v1.communityRewardsUi = communityRewardsUiSlice
v1.tutorial = tutorialSlice
v1.trashMode = trashModeSlice
v1.giftUi = giftUiSlice
v1.storeGiftUi = storeGiftUiSlice
v1.letterUi = letterUiSlice
v1.storePurchase = storePurchaseSlice
v1.localCharacterAppearance = localCharacterAppearanceSlice
v1.fishingArea = fishingAreaSlice
v1.otherPlayerCasts = otherPlayerCastsSlice
v1.castCutscene = castCutsceneSlice
v1.nibbleActiveFish = nibbleActiveFishSlice
v1.nearBaseUi = nearBaseUiSlice
v1.aquariumFishHover = aquariumFishHoverSlice
v1.serverRestart = serverRestartSlice
v1.frostwyrmAnnouncement = frostwyrmAnnouncementSlice
v1.pinataBossDeathAnnouncement = pinataBossDeathAnnouncementSlice
v1.pinataBossReward = pinataBossRewardSlice
v1.pinataBossDamagePopups = pinataBossDamagePopupsSlice
v1.rglReward = rglRewardSlice
v1.celebrationReward = celebrationRewardSlice
v1.minigameReward = minigameRewardSlice
v1.shardReward = shardRewardSlice

return {
    clientSlices = v1,
    clientProducer = combineProducers(v1)
}
