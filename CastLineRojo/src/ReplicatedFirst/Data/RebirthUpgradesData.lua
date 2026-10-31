export type RebirthUpgradesConfig = {
    UpgradeID: string,
    DisplayName: string,
    Index: number,
    MaxLevel: number,
    Price: string,
    BoostValue: number,
    IconID: string,
}

local RebirthUpgradesData: {[string]: RebirthUpgradesConfig} = {
    Diamonds = {
        UpgradeID = "Diamonds",
        DisplayName = "+5 Gems",
        Index = 1,
        MaxLevel = 0,
        Price = "1",
        BoostValue = 5,
        IconID = "16384387047",
    },
}
return RebirthUpgradesData
