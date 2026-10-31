local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerThumbnailUtil = require(ReplicatedStorage.Modules.PlayerThumbnailUtil)


local PlayerController = Knit.CreateController {
    Name = "PlayerController",
}

function PlayerController:GetPlayerThumbnail(player: Player): string
	return PlayerThumbnailUtil.GetHeadshot(player.UserId, 60)
end

function PlayerController:KnitInit()
end

function PlayerController:KnitStart()

end

return PlayerController
