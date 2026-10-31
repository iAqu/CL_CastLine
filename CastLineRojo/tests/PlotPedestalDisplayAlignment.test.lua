local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotPedestalController.lua")

assert(
	controller:find("ItemTitlePositionUtil.ApplyBottomOffset", 1, true),
	"Home item titles must use the shared world-bounds-bottom placement"
)
assert(
	controller:find("TITLE_HOME_HEIGHT_OFFSET = 2", 1, true),
	"Home item titles must apply a two-stud height correction"
)
assert(
	controller:find("ItemTitlePositionUtil.ApplyBottomOffset(title, model, TITLE_HOME_HEIGHT_OFFSET)", 1, true),
	"Home item title setup must pass the home height offset"
)

assert(
	controller:find('DISPLAY_BOUNDS_OFFSET_ATTRIBUTE = "DisplayBoundsOffset"', 1, true),
	"Pedestal displays must support an authored visible-bounds offset"
)
assert(
	controller:find('DISPLAY_BOUNDS_SIZE_ATTRIBUTE = "DisplayBoundsSize"', 1, true),
	"Pedestal displays must support an authored visible-bounds size"
)
assert(
	controller:find("return ItemBoundsUtil.GetWorldAxisBounds(model)", 1, true),
	"Models without authored display bounds must fall back to world-axis bounds"
)
assert(
	controller:find("local authoredRotation = model:GetPivot().Rotation", 1, true),
	"Pedestal displays must preserve the template authored rotation"
)
assert(
	controller:find("model:PivotTo(mountCFrame * authoredRotation)", 1, true),
	"Pedestal displays must mount with authored pitch and roll intact"
)
assert(
	controller:find("model:PivotTo(CFrame.new(pedestalCenter) * CFrame.Angles(0, yaw, 0) * authoredRotation)", 1, true),
	"Pedestal displays without a mount part must still preserve authored rotation"
)
assert(
	controller:find("local boundsToPivot = baseBoundsCFrame:ToObjectSpace(model:GetPivot())", 1, true),
	"Display setup must preserve the transform from the bounds center to the model pivot"
)
assert(
	controller:find("display.model:PivotTo(animatedBoundsCFrame * display.boundsToPivot)", 1, true),
	"Display animation must rotate the bounds frame rather than the model pivot"
)
assert(
	controller:find("(math.sin(elapsed * FLOAT_SPEED) + 1) * FLOAT_AMPLITUDE", 1, true),
	"Pedestal hover must never move below its aligned base height"
)
assert(
	not controller:find("display.model:PivotTo(display.baseCFrame", 1, true),
	"The old pivot-centered animation path must stay removed"
)
assert(
	controller:find("local DropVFXUtil = require(ReplicatedStorage.Modules.DropVFXUtil)", 1, true)
		and controller:find("if item.IsRareReward == 1 then", 1, true)
		and controller:find("DropVFXUtil.AttachRarityPointLight(model, item.Rarity)", 1, true),
	"Rare home pedestal displays must attach the shared rarity point light"
)
assert(
	controller:find("local PlotCashPoolUtil = require(ReplicatedStorage.Modules.PlotCashPoolUtil)", 1, true),
	"Home pedestal titles must share the production-rate normalization used by CashPool"
)
assert(
	controller:find('findLabel(title, "PriceLabel")', 1, true)
		and controller:find("priceLabel.Visible = false", 1, true),
	"Home pedestal titles must hide the sale price"
)
assert(
	controller:find('findLabel(title, "CpsLabel")', 1, true)
		and controller:find("MutationDataUtil.GetEarnCashRate(mutationId)", 1, true)
		and controller:find('NumberUtil.FormatItemPriceCompact(cpsPrice) .. "/s"', 1, true)
		and controller:find("cpsLabel.Visible = true", 1, true),
	"Home pedestal titles must show compact CpsPrice production per second"
)
assert(
	not controller:find('pedestal:GetAttribute("Price")', 1, true),
	"Home pedestal display must not read an unused sale price"
)
assert(controller:find("local DISPLAY_ANIMATION_DISTANCE = 160", 1, true), "Pedestal animation must be range limited")
assert(controller:find("local DISPLAY_ANIMATION_REFRESH_INTERVAL = 0.25", 1, true), "Pedestal animation candidates must refresh at 4Hz")
assert(controller:find("local function refreshAnimatedDisplays", 1, true), "Pedestal displays need a cached animation list")
assert(controller:find("for _, display in ipairs(animatedDisplays) do", 1, true), "RenderStepped must update only nearby displays")
assert(controller:find("animationRefreshElapsed >= DISPLAY_ANIMATION_REFRESH_INTERVAL", 1, true), "Nearby display cache must be throttled")
assert(
	controller:find("ItemTitlePositionUtil.ApplyBottomOffset(display.title, display.model, TITLE_HOME_HEIGHT_OFFSET)", 1, true),
	"Animated Home item titles must follow the current actual model bounds"
)

print("PlotPedestalDisplayAlignment.test.lua passed")
