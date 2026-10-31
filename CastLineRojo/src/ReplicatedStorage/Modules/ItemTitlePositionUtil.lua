local ItemTitlePositionUtil = {}

ItemTitlePositionUtil.TITLE_BOTTOM_OFFSET_Y = 6

local function getPartBottomY(part: BasePart): number
	local cframe = part.CFrame
	local halfSize = part.Size * 0.5
	local halfWorldY = math.abs(cframe.RightVector.Y) * halfSize.X
		+ math.abs(cframe.UpVector.Y) * halfSize.Y
		+ math.abs(cframe.LookVector.Y) * halfSize.Z
	return part.Position.Y - halfWorldY
end

local function getAdorneeWorldY(adornee: Instance?): number?
	if adornee and adornee:IsA("Attachment") then
		return adornee.WorldPosition.Y
	end
	if adornee and adornee:IsA("BasePart") then
		return adornee.Position.Y
	end
	return nil
end

function ItemTitlePositionUtil.GetWorldBottomY(root: Instance): number?
	local bottomY: number? = nil
	if root:IsA("BasePart") then
		bottomY = getPartBottomY(root)
	end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local partBottomY = getPartBottomY(descendant)
			bottomY = if bottomY then math.min(bottomY, partBottomY) else partBottomY
		end
	end
	return bottomY
end

function ItemTitlePositionUtil.ApplyBottomOffset(title: BillboardGui, root: Instance, extraOffsetY: number?): boolean
	local bottomY = ItemTitlePositionUtil.GetWorldBottomY(root)
	local adorneeWorldY = getAdorneeWorldY(title.Adornee or title.Parent)
	if not bottomY or not adorneeWorldY then
		return false
	end

	local offset = title.StudsOffsetWorldSpace
	title.StudsOffsetWorldSpace = Vector3.new(
		offset.X,
		bottomY + ItemTitlePositionUtil.TITLE_BOTTOM_OFFSET_Y + (extraOffsetY or 0) - adorneeWorldY,
		offset.Z
	)
	return true
end

return ItemTitlePositionUtil
