local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local itemBoundsUtil = read("src/ReplicatedStorage/Modules/ItemBoundsUtil.lua")
local itemToolUtil = read("src/ReplicatedStorage/Modules/ItemToolUtil.lua")
local plotPedestalController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotPedestalController.lua")
local backpackViewport = read("src/ReplicatedStorage/Modules/BackpackItemViewport.lua")
local indexViewport = read("src/ReplicatedStorage/Modules/IndexItemViewport.lua")
local purseBackpack = read("src/StarterPlayer/StarterPlayerScripts/PurseBackpack.client.lua")


assert(
	itemBoundsUtil:find("function ItemBoundsUtil.GetWorldAxisBounds", 1, true),
	"Shared item bounds helper must expose world-axis AABB measurement"
)
assert(
	itemToolUtil:find("ItemBoundsUtil.GetWorldAxisBounds(visual)", 1, true),
	"Held item grip must measure world-axis bounds from the shared helper"
)
assert(
	plotPedestalController:find("ItemBoundsUtil.GetWorldAxisBounds(model)", 1, true),
	"Pedestal display height must measure world-axis bounds from the shared helper"
)
assert(
	plotPedestalController:find("local authoredRotation = model:GetPivot().Rotation", 1, true),
	"Pedestal displays must preserve the template authored rotation"
)
assert(
	plotPedestalController:find("model:PivotTo(mountCFrame * authoredRotation)", 1, true),
	"Pedestal displays must mount with the same authored rotation used by previews"
)

assert(
	itemToolUtil:find('ItemToolUtil.VISUAL_PIVOT_OFFSET_ATTRIBUTE = "ItemVisualPivotOffset"', 1, true),
	"Item tools must expose the authored visual pivot relative to their Handle"
)
assert(
	itemToolUtil:find("handle.CFrame:ToObjectSpace(visual:GetPivot())", 1, true),
	"Item tools must capture the authored Model pivot before detaching their Handle"
)
assert(
	backpackViewport:find("ItemToolUtil.VISUAL_PIVOT_OFFSET_ATTRIBUTE", 1, true),
	"Inventory previews must consume the authored visual pivot"
)
assert(
	backpackViewport:find("handle.PivotOffset = visualPivotOffset", 1, true),
	"Inventory previews must restore the authored visual pivot on their cloned Handle"
)
assert(
	backpackViewport:find("previewModel.PrimaryPart = handle", 1, true),
	"Inventory previews must use the restored authored pivot as the preview model pivot"
)
assert(
	backpackViewport:find("local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)", 1, true),
	"Inventory previews must define the shared front-facing correction"
)
assert(
	backpackViewport:find("previewModel:PivotTo(MODEL_ROTATION * FRONT_FACING_ROTATION * authoredRotation)", 1, true),
	"Inventory previews must preserve authored rotation before applying the presentation rotation"
)
assert(
	indexViewport:find("local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)", 1, true),
	"Index previews must define the shared front-facing correction"
)
assert(
	indexViewport:find("previewModel:PivotTo(MODEL_ROTATION * FRONT_FACING_ROTATION * authoredRotation)", 1, true),
	"Index previews must preserve authored rotation with the same correction as inventory previews"
)
assert(
	backpackViewport:find('tool:FindFirstChildWhichIsA("BasePart", true)', 1, true),
	"Inventory previews must wait for a replicated Tool visual before cloning it"
)
assert(
	purseBackpack:find("tool.DescendantAdded:Connect", 1, true),
	"Backpack slots must refresh when a Tool's visual arrives after the Tool itself"
)

print("ItemPresentationOrientation.test.lua passed")
