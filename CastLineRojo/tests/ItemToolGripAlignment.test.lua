local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local itemToolUtil = read("src/ReplicatedStorage/Modules/ItemToolUtil.lua")

assert(
	itemToolUtil:find('local HELD_ITEM_REAR_GRIP_RATIO = 0.1', 1, true),
	"Carried items must reserve a 10% rear grip offset"
)
assert(
	itemToolUtil:find("local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)", 1, true),
	"Carried items must define the shared front-facing correction"
)
assert(
	itemToolUtil:find("ItemBoundsUtil.GetWorldAxisBounds(visual)", 1, true),
	"Carried item grip must use world-axis bounds instead of pivot-aligned OBB"
)
assert(
	itemToolUtil:find('-boundsSize.Y / 2', 1, true),
	"Carried item grip must align to the visual bottom"
)
assert(
	itemToolUtil:find('boundsSize.Z * HELD_ITEM_REAR_GRIP_RATIO', 1, true),
	"Carried item grip must include the proportional rear offset"
)
assert(
	itemToolUtil:find('handle.CFrame:ToObjectSpace(bottomRearPoint * FRONT_FACING_ROTATION)', 1, true),
	"The bottom anchor must turn the item front toward the camera before converting to Handle-local space"
)
assert(
	itemToolUtil:find('tool.Grip = getBottomRearGrip(visual, handle)', 1, true),
	"Every generated item Tool must apply the computed grip"
)
assert(
	itemToolUtil:find("local function attachVisualPartsToTool", 1, true),
	"Multi-part item visuals must be assembled directly under their Tool"
)
assert(
	itemToolUtil:find("part.Parent = tool", 1, true),
	"Every non-Handle visual part must become a direct Tool child"
)
assert(
	itemToolUtil:find('local weld = Instance.new("WeldConstraint")', 1, true)
		and itemToolUtil:find("weld.Part0 = handle", 1, true)
		and itemToolUtil:find("weld.Part1 = part", 1, true),
	"Every non-Handle visual part must be welded to Handle"
)
assert(
	itemToolUtil:find("visual:Destroy()", 1, true),
	"The temporary visual Model must not remain inside an equipped Tool"
)
assert(
	itemToolUtil:find("attachVisualPartsToTool(tool, visual, handle)", 1, true),
	"Every generated item Tool must flatten its visual parts after calculating its grip"
)

print("ItemToolGripAlignment.test.lua passed")
