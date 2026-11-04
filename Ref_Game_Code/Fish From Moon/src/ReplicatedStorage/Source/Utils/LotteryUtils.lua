--抽奖通用方法
local LotteryUtils = {}

--获取抽奖结果
function LotteryUtils.GetLuckyDrawIndex(probabilityList)
    local totalWeight = 0
    for _, v in ipairs(probabilityList) do
        totalWeight = totalWeight + v.weight
    end
    local randWeight = math.random(totalWeight)
    local rewardIndex = 0
    local totalWeightCount = 0
    for k, v in ipairs(probabilityList) do
        totalWeightCount = totalWeightCount + v.weight
        if totalWeightCount >= randWeight then
            rewardIndex = k
            break
        end
    end
    if rewardIndex == 0 then
        print("错误:抽奖结果不能为0")
    end
    return rewardIndex, randWeight
end

return LotteryUtils
