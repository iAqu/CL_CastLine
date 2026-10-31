local PlayerThumbnailUtil = {}

function PlayerThumbnailUtil.GetHeadshot(userId: number, pixelSize: number): string
	if userId <= 0 then
		return ""
	end
	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=%d&h=%d"):format(userId, pixelSize, pixelSize)
end

return table.freeze(PlayerThumbnailUtil)
