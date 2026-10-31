export type HareDailyRewardConfig = {
    RewardID: string,
    Type: string,
    ItemId: string,
    Count: number,
    Name: string,
    IconId: number,
}

local HareDailyRewardsData: {[string]: HareDailyRewardConfig} = {
    Hare_Daily_Reward_1 = {
        RewardID = "Hare_Daily_Reward_1",
        Type = "Wins",
        ItemId = "nil",
        Count = 5000,
        Name = "5K Cash",
        IconId = 0,
    },
    Hare_Daily_Reward_2 = {
        RewardID = "Hare_Daily_Reward_2",
        Type = "Potion",
        ItemId = "Potion_Golden",
        Count = 1,
        Name = "Golden Potion",
        IconId = 16804887485,
    },
    Hare_Daily_Reward_3 = {
        RewardID = "Hare_Daily_Reward_3",
        Type = "Diamond",
        ItemId = "nil",
        Count = 200,
        Name = "x200",
        IconId = 100914672496224,
    },
    Hare_Daily_Reward_4 = {
        RewardID = "Hare_Daily_Reward_4",
        Type = "Potion",
        ItemId = "Potion_SuperLucky",
        Count = 1,
        Name = "Super Luck",
        IconId = 16804887708,
    },
    Hare_Daily_Reward_5 = {
        RewardID = "Hare_Daily_Reward_5",
        Type = "Potion",
        ItemId = "Potion_Rainbow",
        Count = 1,
        Name = "Rainbow Potion",
        IconId = 16804887776,
    },
    Hare_Daily_Reward_6 = {
        RewardID = "Hare_Daily_Reward_6",
        Type = "Diamond",
        ItemId = "nil",
        Count = 500,
        Name = "x500",
        IconId = 100914672496224,
    },
    Hare_Daily_Reward_7 = {
        RewardID = "Hare_Daily_Reward_7",
        Type = "Diamond",
        ItemId = "nil",
        Count = 1000,
        Name = "x1000",
        IconId = 100914672496224,
    },
}
return HareDailyRewardsData
