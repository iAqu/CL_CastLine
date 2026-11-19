local PlotWorkspaceUtil = require(script.Parent.PlotWorkspaceUtil)
local RodShopZone = require(script.Parent.RodShopZone)

local SERVER_HORIZONTAL_MARGIN = 10
local SERVER_VERTICAL_TOLERANCE = 12

local SellShopZone = {
	Contains = RodShopZone.Contains,
	ExitMargin = RodShopZone.ExitMargin,
}

function SellShopZone.GetOwnedAnchor(player: Player): BasePart?
	local slotId = player:GetAttribute("PlotSlotId")
	local plot = if typeof(slotId) == "number" then PlotWorkspaceUtil.getPlotBySlot(slotId) else nil
	local anchor = plot and plot:FindFirstChild("SellShopAnchor")
	return if plot
			and plot:GetAttribute("OwnerUserId") == player.UserId
			and anchor
			and anchor:IsA("BasePart")
		then anchor
		else nil
end

function SellShopZone.CanSell(player: Player, serverTolerance: boolean?): boolean
	local anchor = SellShopZone.GetOwnedAnchor(player)
	if not anchor then
		return false
	end
	if not serverTolerance then
		return SellShopZone.Contains(anchor, player.Character, SellShopZone.ExitMargin)
	end
	-- Requests can arrive after the character has moved or jumped. The server
	-- checks a generous nearby area; the client keeps the precise UI boundary.
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not (root and root:IsA("BasePart") and humanoid and humanoid.Health > 0) then
		return false
	end
	local offset = root.Position - anchor.Position
	local radius = math.max(anchor.Size.Y, anchor.Size.Z) / 2 + SERVER_HORIZONTAL_MARGIN
	return offset.X * offset.X + offset.Z * offset.Z <= radius * radius
		and math.abs(offset.Y) <= SERVER_VERTICAL_TOLERANCE
end

return SellShopZone
