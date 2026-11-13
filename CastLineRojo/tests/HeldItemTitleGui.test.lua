local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local itemToolUtil = read("src/ReplicatedStorage/Modules/ItemToolUtil.lua")
local heldItemVisualController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/HeldItemVisualController.lua")

assert(itemToolUtil:find('local StarterGui = game:GetService("StarterGui")', 1, true), "Held item titles must be created on the server")
assert(itemToolUtil:find('local HELD_ITEM_TITLE_NAME = "HeldItemTitle"', 1, true), "Held item titles need a stable name")
assert(itemToolUtil:find('local HELD_ITEM_TITLE_ANCHOR_NAME = "HeldItemTitleAnchor"', 1, true), "Held item titles need a stable anchor name")
assert(itemToolUtil:find('local function createHeldItemTitle', 1, true), "Item tools must build a held-item title")
assert(itemToolUtil:find('FishTitleUtil.Create(titleGui, item, instanceData.MutationId, owner, instanceData.Weight)', 1, true), "Replicated held titles must include the actual weight")
assert(itemToolUtil:find('Instance.new("Attachment")', 1, true), "Held item titles must use an attachment anchor")
assert(itemToolUtil:find('titleAnchor.Parent = handle', 1, true), "Held item title anchors must follow the Tool handle")
assert(itemToolUtil:find('titleAnchor.Position = Vector3.zero', 1, true), "Held title anchors must stay at the grip point")
assert(itemToolUtil:find('local function createHeldItemTitle(\n\tvisual: Model,', 1, true), "Held title placement must use the item visual bounds")
assert(itemToolUtil:find("ItemTitlePositionUtil.ApplyBottomOffset(title, visual)", 1, true), "Held titles need a correct initial bottom offset")
assert(itemToolUtil:find('title.Adornee = titleAnchor', 1, true), "Held item titles must adorn their anchor")
assert(itemToolUtil:find('title.Enabled = true', 1, true), "Held item titles must be enabled")
assert(itemToolUtil:find('createHeldItemTitle(visual, handle, item, instanceData, owner)', 1, true), "Every generated item Tool must create its title")

assert(heldItemVisualController:find("ItemToolUtil.IsItemTool(tool)", 1, true), "The local client must recognize equipped item Tools")
assert(heldItemVisualController:find("createLocalHeldItemTitle", 1, true), "The local client must create its own held-item title")
assert(heldItemVisualController:find("FishTitleUtil.Create(titleGui, item, mutationId, LOCAL_PLAYER, tool:GetAttribute(ItemToolUtil.WEIGHT_ATTRIBUTE))", 1, true), "Local held titles must include the actual weight")
assert(heldItemVisualController:find('LOCAL_TITLE_NAME = "LocalHeldItemTitle"', 1, true), "Local held-item titles need a stable name")
local localMount = heldItemVisualController:find("title.Parent = titleAnchor", 1, true)
local hideReplicated = heldItemVisualController:find("serverTitle.Enabled = false", 1, true)
assert(localMount and hideReplicated and localMount < hideReplicated, "Hide the replicated title once the local title is mounted")
assert(heldItemVisualController:find("getHeldTitleAdornee", 1, true), "Local held titles must resolve the character grip point")
assert(heldItemVisualController:find('FindFirstChild("RightGripAttachment")', 1, true), "R15 held titles must use RightGripAttachment")
assert(heldItemVisualController:find('FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")', 1, true), "Held titles must support R15 and R6 hands")
assert(heldItemVisualController:find("title.Adornee = heldTitleAdornee", 1, true), "Local held titles must attach to the character grip, not the item Handle")
assert(heldItemVisualController:find("Players:GetPlayers()", 1, true), "Held titles must track existing local and remote players")
assert(heldItemVisualController:find("Players.PlayerAdded:Connect(bindTitlePlayer)", 1, true), "Held titles must track newly joined players")
assert(heldItemVisualController:find("RunService.RenderStepped:Connect(updateTrackedItemTitles)", 1, true), "Held titles must update against moving world bounds")
assert(
	heldItemVisualController:find("ItemTitlePositionUtil.ApplyBottomOffset(localHeldItemTitle, tool)", 1, true)
		and heldItemVisualController:find("ItemTitlePositionUtil.ApplyBottomOffset(serverTitle, tool)", 1, true),
	"Local and replicated held titles must share bottom-relative positioning"
)
assert(heldItemVisualController:find("character.DescendantAdded:Connect", 1, true), "The local title must recover when the anchor replicates after the Tool")
assert(heldItemVisualController:find("descendant.Name == HELD_ITEM_TITLE_NAME", 1, true), "The local title must handle a late replicated title")

print("HeldItemTitleGui.test.lua passed")
