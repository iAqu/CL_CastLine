local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local dropVFXUtil = read("src/ReplicatedStorage/Modules/DropVFXUtil.lua")
local itemsData = read("src/ReplicatedFirst/Data/ItemsData.lua")

assert(
	dropVFXUtil:find('local template = rarityBeam and rarityBeam:FindFirstChild("DropVFX")', 1, true),
	"Drop VFX must clone ReplicatedStorage.VFX.RarityBeam.DropVFX"
)
assert(
	not dropVFXUtil:find("GetRank(resolvedRarity)", 1, true),
	"Drop VFX must not be gated by rarity rank"
)
assert(
	dropVFXUtil:find("return math.max(bounds.X, bounds.Z)", 1, true)
		and dropVFXUtil:find("effect:ScaleTo(horizontalSize / templateHorizontalSize)", 1, true)
		and dropVFXUtil:find("local effect = createEffect(itemHorizontalSize, resolvedRarity)", 1, true),
	"Drop VFX must use Model:ScaleTo with the item's horizontal bounds"
)
assert(
	dropVFXUtil:find("descendant:IsA(\"Beam\") or descendant:IsA(\"ParticleEmitter\")", 1, true)
		and dropVFXUtil:find("descendant.Color = colorSequence", 1, true),
	"Drop VFX beams and particles must share the rarity color"
)
assert(
	dropVFXUtil:find("function DropVFXUtil.AttachRarityPointLight", 1, true)
		and dropVFXUtil:find("return math.max(bounds.X, bounds.Y, bounds.Z)", 1, true)
		and dropVFXUtil:find("light.Brightness = 5", 1, true)
		and dropVFXUtil:find("light.Shadows = false", 1, true)
		and dropVFXUtil:find("light.Color = rarityColor", 1, true)
		and dropVFXUtil:find("DropVFXUtil.AttachRarityPointLight(effect, resolvedRarity, item)", 1, true),
	"Drop VFX must add a same-color point light with the item's largest bounds axis as range"
)
assert(
	dropVFXUtil:find("RunService.RenderStepped:Connect", 1, true)
		and dropVFXUtil:find("effect:PivotTo(CFrame.new(boundsCFrame.Position))", 1, true),
	"Drop VFX must independently follow the displayed item at its bounding-box center"
)

print("DropVFXPresentation.test.lua passed")
