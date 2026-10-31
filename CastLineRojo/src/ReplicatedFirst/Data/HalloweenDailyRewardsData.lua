export type HalloweenDailyRewardConfig = {
    RewardID: string,
    Type: string,
    ItemId: string,
    Count: number,
    Name: string,
    IconId: number,
}

local HalloweenDailyRewardsData: {[string]: HalloweenDailyRewardConfig} = {
    Halloween_Daily_Reward_1 = {
        RewardID = "Halloween_Daily_Reward_1",
        Type = "Potion",
        ItemId = "Potion_Golden",
        Count = 1,
        Name = "Golden Potion",
        IconId = 16804887485,
    },
    Halloween_Daily_Reward_2 = {
        RewardID = "Halloween_Daily_Reward_2",
        Type = "Diamond",
        ItemId = "nil",
        Count = 2500,
        Name = "Diamonds",
        IconId = 78433339284465,
    },
    Halloween_Daily_Reward_3 = {
        RewardID = "Halloween_Daily_Reward_3",
        Type = "PotionPack",
        ItemId = "nil",
        Count = 1,
        Name = "Potion Pack",
        IconId = 16803051341,
    },
    Halloween_Daily_Reward_4 = {
        RewardID = "Halloween_Daily_Reward_4",
        Type = "Potion",
        ItemId = "Potion_SuperLucky",
        Count = 1,
        Name = "Super Luck",
        IconId = 16804887708,
    },
    Halloween_Daily_Reward_5 = {
        RewardID = "Halloween_Daily_Reward_5",
        Type = "PotionPack",
        ItemId = "nil",
        Count = 3,
        Name = "Potion Pack",
        IconId = 16803051341,
    },
    Halloween_Daily_Reward_6 = {
        RewardID = "Halloween_Daily_Reward_6",
        Type = "Potion",
        ItemId = "Potion_Rainbow",
        Count = 1,
        Name = "Rainbow Potion",
        IconId = 16804887776,
    },
    Halloween_Daily_Reward_7 = {
        RewardID = "Halloween_Daily_Reward_7",
        Type = "Diamond",
        ItemId = "nil",
        Count = 2000,
        Name = "x2000",
        IconId = 100914672496224,
    },
}
return HalloweenDailyRewardsData
