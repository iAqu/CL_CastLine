local function read(path)
	local file = assert(io.open(path, "r"))
	local content = file:read("*a")
	file:close()
	return content
end

local service = read("src/ServerScriptService/Services/DigItemService.lua")
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")

assert(service:find("local MODEL_SPACING_PADDING = 2", 1, true), "Large item spacing needs a 2-stud safety margin")
assert(service:find("local MAX_MODEL_CLEARANCE_RADIUS = 20", 1, true), "Each model clearance radius must be capped at 20 studs")
assert(service:find("local function getHorizontalClearanceRadius", 1, true), "Generated items need a horizontal clearance radius")
assert(service:find("ItemStatUtil.ScaleModel(model, item, item.MaxWeight", 1, true), "Rarity sites must scale candidates to maximum weight before spacing is calculated")
assert(service:find("clearanceRadius = math.max(clearanceRadius, getHorizontalClearanceRadius(model))", 1, true), "Spacing must use the largest scaled candidate")
assert(
	service:find("math.clamp(clearanceRadius, MIN_SPACING * 0.5, MAX_MODEL_CLEARANCE_RADIUS)", 1, true),
	"Calculated model clearance radius must remain between the base radius and its 20-stud cap"
)
assert(service:find("math.max(\n\t\t\t\t\tMIN_SPACING,", 1, true), "Spacing must retain the 12-stud baseline")
assert(
	service:find("rolled.clearanceRadius + otherPoint.clearanceRadius + MODEL_SPACING_PADDING", 1, true),
	"Spacing must include both model radii and the safety margin"
)
assert(
	service:find('typeof(otherPoint.surfacePosition) ~= "Vector3"', 1, true),
	"Malformed generated points must not abort an entire zone refresh"
)
assert(
	service:find("clearanceRadius = rolled.clearanceRadius", 1, true),
	"Placed points must retain their own clearance radius for later spacing checks"
)
assert(service:find("model:Destroy()", 1, true), "Temporary sizing models must be cleaned up")
assert(service:find('Reason = "AlreadyDigging"', 1, true), "Duplicate dig requests must be rejected")
assert(
	not service:find('_endReservation(previous, previousReservation, "Replaced", true)', 1, true),
	"Duplicate dig requests must not replace the active reservation"
)

assert(controller:find("local nearestPromptSite: DigSite? = nil", 1, true), "Dig prompts need a selected-site state")
assert(controller:find("local DIG_SITE_REFRESH_INTERVAL = 0.1", 1, true), "Dig site scans must be capped at 10Hz")
assert(controller:find("local function refreshDigSiteState", 1, true), "Dig prompts need a combined site refresh path")
assert(controller:find("and site.isInitialized", 1, true), "Uninitialized personal sites must not become selectable")
assert(controller:find("site.anchor.Position", 1, true), "Nearest prompt selection must use the dig anchor")
assert(controller:find('GetAttribute("ItemInstanceId")', 1, true), "Equal-distance prompts need a stable tie-breaker")
assert(controller:find("local function refreshNearestDigPrompt", 1, true), "Dig prompts need a shared refresh path")
assert(controller:find("previousNearest.prompt.Enabled = false", 1, true), "Changing nearest dig sites must disable only the old prompt")
assert(controller:find("nearest.prompt.Enabled = true", 1, true), "Changing nearest dig sites must enable the new prompt")
assert(controller:find("offset.X * offset.X + offset.Y * offset.Y + offset.Z * offset.Z", 1, true), "Nearest prompt selection must compare squared distance")
assert(controller:find("digSiteRefreshElapsed >= DIG_SITE_REFRESH_INTERVAL", 1, true), "Dig site scans must be throttled by the refresh interval")
assert(not controller:find("ProximityPromptExclusivity.AlwaysShow", 1, true), "Dig prompts must not force all prompts visible")
assert(
	controller:find("if nearestPromptSite ~= site then", 1, true),
	"Prompt triggers must reject stale non-nearest sites"
)

print("DigItemSpacingAndPromptSelection.test.lua passed")
