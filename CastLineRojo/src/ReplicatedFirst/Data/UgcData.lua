export type UgcConfig = {
    UgcId: string,
    StartDate: number,
    Name: string,
    Count: number,
    ImageId: number,
    TasksCount: number,
    Task_1_Type: string,
    Task_1_Info: string,
    Task_1_ProgressMax: number,
    Task_2_Type: string,
    Task_2_Info: string,
    Task_2_ProgressMax: number,
    Task_3_Type: string,
    Task_3_Info: string,
    Task_3_ProgressMax: number,
}

local UgcData: {[string]: UgcConfig} = {
    UGC_BatWings = {
        UgcId = "UGC_BatWings",
        StartDate = 2023320,
        Name = "Little Bat Wings",
        Count = 500,
        ImageId = 15376446625,
        TasksCount = 3,
        Task_1_Type = "PlayTime",
        Task_1_Info = "Play the game for 12 hours",
        Task_1_ProgressMax = 43200,
        Task_2_Type = "Normal",
        Task_2_Info = "Opn 500 Eggs",
        Task_2_ProgressMax = 500,
        Task_3_Type = "Normal",
        Task_3_Info = "Defeat Zone-1 Boss",
        Task_3_ProgressMax = 1,
    },
}
return UgcData
