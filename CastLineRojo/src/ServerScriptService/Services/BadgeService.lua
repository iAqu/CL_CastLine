local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local RobloxBadgeService = game:GetService("BadgeService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)

local BadgeService = Knit.CreateService {
    Name = "BadgeService",
    Client = {
    },
}

function BadgeService:HasBadge(player: Player, badgeId: number)
    local success, hasBadge = pcall(function()
        return RobloxBadgeService:UserHasBadgeAsync(player.UserId, badgeId)
    end)
    return hasBadge
end

function BadgeService:AwardBadge(player: Player, badgeId: number)

	if self:HasBadge(player, badgeId) then
		return
	end

	-- Fetch badge information
	local success, badgeInfo = pcall(function()
		return RobloxBadgeService:GetBadgeInfoAsync(badgeId)
	end)

	if success then
		-- Confirm that badge can be awarded
		if badgeInfo.IsEnabled then
			-- Award badge
			local awardSuccess, result = pcall(function()
				return RobloxBadgeService:AwardBadge(player.UserId, badgeId)
			end)

			if not awardSuccess then
				-- the AwardBadge function threw an error
				warn("Error while awarding badge:", result)
			elseif not result then
				-- the AwardBadge function did not award a badge
				warn("Failed to award badge.")
			end
		end
	else
		warn("Error while fetching badge info: " .. badgeInfo)
	end
end

function BadgeService:KnitInit()

    -- Players.PlayerAdded:Connect(function(player: Player)
    --     task.delay(5, function()
    --         if not self:HasBadge(player, Constants.BADGE_ID.WELCOME) then
    --             self:AwardBadge(player, Constants.BADGE_ID.WELCOME)
    --         end
    --     end)
    -- end)
end

function BadgeService:KnitStart()

end

return BadgeService
