export type CodeConfig = {
    CodeId: string,
    Type: string,
    ItemId: string,
    Limited: number,
    Count: number,
    RarityIndex: number,
    info: number,
}

local CodesData: {[string]: CodeConfig} = {
    DIG = {
        CodeId = "DIG",
        Type = "Potion",
        ItemId = "Potion_DoubleWins",
        Limited = -1,
        Count = 1,
        RarityIndex = 0,
        info = 1,
    },
    BUILD = {
        CodeId = "BUILD",
        Type = "Potion",
        ItemId = "Potion_Golden",
        Limited = -1,
        Count = 1,
        RarityIndex = 0,
        info = 1,
    },
}
return CodesData
