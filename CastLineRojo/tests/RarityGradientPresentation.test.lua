local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local guiUtil = read("src/ReplicatedStorage/Modules/GuiUtil.lua")
local dropVFXUtil = read("src/ReplicatedStorage/Modules/DropVFXUtil.lua")

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

print("RarityGradientPresentation.test.lua passed")
