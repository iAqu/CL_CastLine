-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))

return {
    sharedSlices = {
        aquariumSkins = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "aquarium-skins").aquariumSkinsSlice,
        playerData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data").playerDataSlice,
        serverLuck = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "server-luck").serverLuckSlice,
        shardChanceBuff = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "shard-chance-buff").shardChanceBuffSlice,
        serverIssues = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "server-issues").serverIssuesSlice,
        leaderboard = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "leaderboard").leaderboardSlice,
        countryLeaderboard = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "country-leaderboard").countryLeaderboardSlice,
        playerCountry = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-country").playerCountrySlice,
        giftRequests = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "gift-requests").giftRequestsSlice,
        currentWeathers = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-weather").currentWeathersSlice,
        weatherLastEnded = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "weather-last-ended").weatherLastEndedSlice,
        chatTags = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "chat-tags").chatTagsSlice,
        playerConfigSnapshot = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot").playerConfigSnapshotSlice,
        fishingState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state").fishingStateSlice,
        fishingHooks = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-hooks").fishingHooksSlice,
        exclusiveFishStock = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "exclusive-fish-stock").exclusiveFishStockSlice,
        deluluRig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "delulu-rig").deluluRigSlice,
        hoopTesting = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "hoop-testing").hoopTestingSlice,
        activeSpecialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "active-special-event").activeSpecialEventsSlice,
        currentTickets = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-tickets").currentTicketsSlice,
        pinataBoss = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss").pinataBossSlice,
        pinataBossScheduleOverride = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss-schedule-override").pinataBossScheduleOverrideSlice,
        ticketRainLocation = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "ticket-rain-location").ticketRainLocationSlice,
        hallOfFameLikes = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "hall-of-fame-likes").hallOfFameLikesSlice,
        communityLikes = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "community-likes").communityLikesSlice,
        luckyBlockDrop = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "lucky-block-drop").luckyBlockDropSlice
    }
}
