local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local guiUtil = read("src/ReplicatedStorage/Modules/GuiUtil.lua")
local dropVFXUtil = read("src/ReplicatedStorage/Modules/DropVFXUtil.lua")
local moundEffect = read("src/ReplicatedStorage/Modules/DigMoundEffect.lua")
local digRevealEffectUtil = read("src/ReplicatedStorage/Modules/DigRevealEffectUtil.lua")
local silhouetteUtil = read("src/ReplicatedStorage/Modules/DigSilhouetteUtil.lua")
local digController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")

assert(
	guiUtil:find("function GuiUtil.GetRarityGradientColor", 1, true),
	"GuiUtil should expose a representative color for non-GUI rarity presentation"
)
assert(
	not guiUtil:find(":Evaluate(", 1, true),
	"ColorSequence has no Evaluate API; rarity midpoint colors must interpolate keypoints"
)
assert(
	guiUtil:find("previousKeypoint.Value:Lerp", 1, true),
	"The representative rarity color should interpolate the enclosing gradient keypoints"
)
assert(
	dropVFXUtil:find("GuiUtil.GetRarityGradientColor(rarity)", 1, true),
	"Drop VFX should use the representative rarity gradient color"
)
assert(
	dropVFXUtil:find("descendant.Color = colorSequence", 1, true),
	"Drop VFX beams and particles should receive the rarity ColorSequence"
)
assert(
	moundEffect:find("GuiUtil.GetRarityGradientColor(resolvedRarity)", 1, true)
		and moundEffect:find("sparkles.Color = ColorSequence.new(rarityColor)", 1, true),
	"Finish sparkles should use the representative rarity gradient color"
)
assert(
	silhouetteUtil:find("cc.TintColor = tint or Color3.new(1, 1, 1)", 1, true)
		and digController:find("GuiUtil.GetRarityGradientColor(rarity)", 1, true),
	"Reveal flashes should receive the representative rarity gradient color"
)
assert(
	digRevealEffectUtil:find("local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)", 1, true)
		and digRevealEffectUtil:find("color = getRarityColor(resolvedRarity)", 1, true),
	"Dig outlines should use the resolved rarity color, including Common fallback for unknown rarities"
)
assert(
	digRevealEffectUtil:find("transparency = 0,", 1, true),
	"Every dig rarity, including Common and Uncommon, should keep a visible outline"
)
assert(
	digRevealEffectUtil:find("alwaysOnTop = rank >= 5,", 1, true),
	"High-rarity dig outlines should retain their AlwaysOnTop behavior"
)

print("RarityGradientPresentation.test.lua passed")
