local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")
local showcase = assert(
	controller:match("local function playShowcase%b()%s*(.-)\nend\n\nlocal function playFinishedDigSession"),
	"DigController must retain a dedicated final showcase function"
)
local pickup = assert(
	controller:match("local function playPickupFlyEffect%b()%s*(.-)\nend\n\nlocal function playFinishedDigSession"),
	"DigController must retain a dedicated pickup-fly step"
)

assert(
	controller:find("local function getHorizontalRotation(rotation: CFrame): CFrame", 1, true),
	"Final showcase must remove terrain pitch and roll while preserving horizontal heading"
)
assert(
	controller:find("Vector3.new(look.X, 0, look.Z)", 1, true),
	"Horizontal showcase rotation must project the source heading onto the world XZ plane"
)
assert(
	showcase:find("local showcaseUp = Vector3.yAxis", 1, true),
	"Final showcase movement and spin must use world up"
)
assert(
	showcase:find("model:PivotTo(startCFrame)", 1, true),
	"The model must become horizontal immediately when the final showcase starts"
)
assert(
	showcase:find("CFrame.fromAxisAngle(showcaseUp, yaw)", 1, true),
	"Final showcase spin must rotate around world up"
)
assert(
	controller:find("local SPIN_TURNS = 2", 1, true),
	"Final showcase must rotate two turns"
)
assert(
	controller:find("local FLOAT_DURATION = 2", 1, true),
	"Final showcase must remain visible one second longer"
)
assert(
	controller:find("site.titleGui.Enabled = false", controller:find("local function showDiggingHealthGui", 1, true), true),
	"Digging must hide the title while displaying the health bar"
)
assert(
	showcase:find("updateShowcaseTitleAnchor(titleAnchor, model)", 1, true),
	"Final showcase must update the title after each model transform"
)
assert(
	showcase:find("local boundsCFrame = model:GetBoundingBox()", 1, true),
	"Final showcase must measure the visible model bounds before animating it"
)
assert(
	showcase:find("local boundsToPivot = boundsCFrame:ToObjectSpace(model:GetPivot())", 1, true),
	"Final showcase must preserve the transform from the bounds center to the model pivot"
)
assert(
	showcase:find("* boundsToPivot", 1, true),
	"Final showcase must animate the bounds frame instead of rotating around the authored model pivot"
)
assert(
	controller:find("local SHOWCASE_MIN_GROUND_CLEARANCE = 5", 1, true),
	"Final showcase must keep its visible bounds at least five studs above ground"
)
assert(
	showcase:find("local targetBottom = groundPosition.Y + SHOWCASE_MIN_GROUND_CLEARANCE + FLOAT_AMPLITUDE", 1, true),
	"Final showcase must compensate for its downward float before setting its base height"
)
assert(
	showcase:find("local currentBottom = boundsCFrame.Position.Y - boundsSize.Y * 0.5", 1, true),
	"Final showcase height must be based on the upright bounding-box bottom"
)
assert(
	not showcase:find("silhouette.upVector", 1, true),
	"Final showcase must not inherit the terrain normal"
)
assert(
	not showcase:find("* silhouette.sourceRotation", 1, true),
	"Final showcase must not restore the terrain-aligned source rotation"
)
assert(
	pickup:find("local _, _, root = getCharacterParts()", 1, true),
	"Pickup flight must resolve the character root immediately before launch"
)
assert(
	pickup:find("return snapshot:Play(root)", 1, true),
	"Pickup flight must report whether the visual actually started"
)
assert(
	controller:find('NotificationClient.GreenNotify("Got " .. getReceivedItemDisplayName(site, result))', 1, true),
	"Successful pickup flight must announce the acquired item"
)
local finishDig = assert(controller:match("local function playFinishedDigSession.-\nend\n\nlocal function startDigSession"))
local pickupStart = assert(finishDig:find("local didStartPickupFly = playPickupFlyEffect(revealedModel)", 1, true))
local originalDestroy = assert(finishDig:find("revealedModel:Destroy()", 1, true))
assert(pickupStart < originalDestroy, "Pickup flight must start before the revealed model is cleaned up")

print("DigShowcaseHorizontalAlignment.test.lua passed")
