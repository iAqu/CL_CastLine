local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local GlobalLeaderboardController = Knit.CreateController {
    Name = "GlobalLeaderboardController",
}

type LeaderboardType = "Wins" | "Weight"

local LEADERBOARD_TYPES: {LeaderboardType} = {"Wins", "Weight"}

local function formatLeaderboardValue(leaderboardType: LeaderboardType, value: number): string
    if leaderboardType == "Wins" then
        return NumberUtil.FormatWinsAmount(value, 2)
    elseif leaderboardType == "Weight" then
        return WeightFormat.FormatKg(value / 10)
    end
    return NumberUtil.FormatNumberStartKWithDecimal(value, 2)
end

local function getBestValueLabel(leaderboardGui: Instance): TextLabel?
    local container = leaderboardGui:FindFirstChild("Frame") or leaderboardGui
    local bestLabel = container:FindFirstChild("BestLabel")
    local valueLabel = bestLabel and bestLabel:FindFirstChild("ValueLabel")
    return if valueLabel and valueLabel:IsA("TextLabel") then valueLabel else nil
end

function GlobalLeaderboardController:UpdateMyBest(leaderboardType: LeaderboardType, bestValue: number)
    if not bestValue then warn("bestValue is nil", leaderboardType) return end

    for _, leaderboard in Workspace.Leaderboards:GetChildren() do
        if not leaderboard:IsDescendantOf(workspace) then continue end
        if leaderboard:GetAttribute("Type") ~= leaderboardType then continue end

        local leaderboardGui = leaderboard:FindFirstChild("LeaderboardGui")
        if not leaderboardGui then warn("LeaderboardGui not found") continue end

        local bestValueLabel = getBestValueLabel(leaderboardGui)
        if not bestValueLabel then
            warn("LeaderboardGui is missing BestLabel.ValueLabel")
            continue
        end
        bestValueLabel.Text = formatLeaderboardValue(leaderboardType, bestValue)
    end
end

function GlobalLeaderboardController:KnitInit()
    local AreaController = Knit.GetController("AreaController")
    AreaController.LoadedNewWorldClientEvent:Connect(function(_worldIndex: number)
        local GlobalLeaderboardService = Knit.GetService("GlobalLeaderboardService")

        task.delay(5, function()
            for _, leaderboardType in ipairs(LEADERBOARD_TYPES) do
                GlobalLeaderboardService:GetMyBestData(leaderboardType):andThen(function(value: number)
                    self:UpdateMyBest(leaderboardType, value)
                end)
            end
        end)
    end)
end

function GlobalLeaderboardController:KnitStart()
    local GlobalLeaderboardService = Knit.GetService("GlobalLeaderboardService")

    GlobalLeaderboardService.UpdateMyBestData:Connect(function(leaderboardType: LeaderboardType, value: number)
        self:UpdateMyBest(leaderboardType, value)
    end)
end

return GlobalLeaderboardController
