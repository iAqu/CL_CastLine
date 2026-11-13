local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local itemBoundsUtil = read("src/ReplicatedStorage/Modules/ItemBoundsUtil.lua")
local itemToolUtil = read("src/ReplicatedStorage/Modules/ItemToolUtil.lua")
local plotFishController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlotFishController.lua")
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
	plotFishController:find("model.PrimaryPart.CFrame:ToObjectSpace(model:GetPivot())", 1, true),
	"Roaming fish must preserve the authored offset from the swimming body to the model pivot"
)
assert(
	plotFishController:find("model:PivotTo(pose * bodyToPivot)", 1, true),
	"Roaming fish must face the route tangent using the body-to-pivot offset"
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
	indexViewport:find("local FRONT_FACING_ROTATION = CFrame.Angles(0, math.pi, 0)", 1, true),
	"Index previews must define the shared front-facing correction"
)
assert(
	indexViewport:find("previewModel:PivotTo(MODEL_ROTATION * FRONT_FACING_ROTATION * authoredRotation)", 1, true),
	"Index previews must preserve authored rotation with the same correction as inventory previews"
)
assert(
	not purseBackpack:find("BackpackItemViewport", 1, true),
	"Backpack icon presentation must not create 3D previews"
)
assert(
	purseBackpack:find('GetPropertyChangedSignal("TextureId")', 1, true),
	"Backpack slots must refresh when their icon changes"
)

print("ItemPresentationOrientation.test.lua passed")
