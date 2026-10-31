export type SeasonQuestConfig = {
    QuestId: string,
    Type: string,
    LayoutOrder: number,
    Description: string,
    RewardXp: number,
    RequirementValue: number,
    backup1: number,
}

-- 旧玩法（挖矿/孵蛋/合成）赛季任务已移除，待新玩法任务补充
local SeasonQuestsData: {[string]: SeasonQuestConfig} = {
}
return SeasonQuestsData
