local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local dropVFXUtil = read("src/ReplicatedStorage/Modules/DropVFXUtil.lua")
local itemsData = read("src/ReplicatedFirst/Data/ItemsData.lua")
local moundEffect = read("src/ReplicatedStorage/Modules/DigMoundEffect.lua")
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")
local digItemService = read("src/ServerScriptService/Services/DigItemService.lua")

assert(
	dropVFXUtil:find('local template = rarityBeam and rarityBeam:FindFirstChild("DropVFX")', 1, true),
	"Drop VFX must clone ReplicatedStorage.VFX.RarityBeam.DropVFX"
)
assert(
	itemsData:find("IsRareReward: number", 1, true)
		and controller:find("local function shouldPlayDropVFX", 1, true)
		and controller:find("item.IsRareReward == 1", 1, true),
	"Drop VFX eligibility must come from ItemsData.IsRareReward"
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
assert(
	controller:find("if shouldPlayDropVFX(site, result) then", 1, true)
		and controller:find("session.dropVFX = DropVFXUtil.Play(revealedModel, rarity)", 1, true)
		and controller:find("session.dropVFX:Destroy()", 1, true),
	"DigController must create Drop VFX on reveal and clean it after the showcase"
)
assert(
	digItemService:find("IsRareReward = roll.item.IsRareReward == 1", 1, true)
		and controller:find("resolvedIsRareReward: boolean", 1, true)
		and controller:find('if typeof(isRareReward) == "boolean" then', 1, true)
		and controller:find("site.resolvedIsRareReward = isRareReward", 1, true),
	"Initial dig-site snapshots must expose only the rare-reward eligibility flag"
)
assert(
	controller:find('getSiteRarity(site) == "Secret" and site.resolvedIsRareReward', 1, true)
		and controller:find("DropVFXUtil.PlayAtPosition(mound.groundPosition, horizontalSize, mound.rarity)", 1, true),
	"Only Secret rare rewards must create a static Drop VFX at the initial pit"
)
assert(
	dropVFXUtil:find("function DropVFXUtil.PlayAtPosition", 1, true)
		and dropVFXUtil:find("SetVisible: (self: DropVFXSession, visible: boolean) -> ()", 1, true)
		and dropVFXUtil:find('descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight")', 1, true)
		and controller:find("site.idleDropVFX:SetVisible(isVisible)", 1, true),
	"Static Drop VFX must scale at the pit and follow tide visibility"
)
assert(
	controller:find("site.idleDropVFX:Destroy()", 1, true)
		and controller:find("session.dropVFX = DropVFXUtil.Play(revealedModel, rarity)", 1, true),
	"The initial Drop VFX must be destroyed before the existing reveal VFX begins"
)
assert(
	moundEffect:find("RarityBeamUtil.Create", 1, true)
		and controller:find("updateSiteBeamVisibility", 1, true),
	"Idle pit light effects must coexist with the separate item reveal Drop VFX"
)

print("DropVFXPresentation.test.lua passed")
