local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local beamUtil = read("src/ReplicatedStorage/Modules/RarityBeamUtil.lua")
local moundEffect = read("src/ReplicatedStorage/Modules/DigMoundEffect.lua")
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")

assert(
	not moundEffect:find("Prefab_WallTreasureModel", 1, true),
	"Procedural dig mounds must not depend on the WallTreasure prefab"
)
assert(
	moundEffect:find('local water = areas and areas:FindFirstChild("Water")', 1, true)
		and moundEffect:find('table.insert(exclude, water)', 1, true),
	"Ground sampling must exclude the Workspace.Areas.Water model"
)
assert(
	moundEffect:find('center.Name = "CenterCylinder"', 1, true),
	"Procedural dig mounds need the legacy cylinder center"
)
assert(
	moundEffect:find("local rockCount = math.random(RANDOM_ROCK_COUNT_MIN, RANDOM_ROCK_COUNT_MAX)", 1, true),
	"Initial dirt-block count should retain the fixed legacy range"
)
assert(
	moundEffect:find("CENTER_BASE_DIAMETER * IDLE_PIT_SCALE", 1, true),
	"Initial cylinder should use the restored idle size"
)
assert(
	moundEffect:find("horizontalFootprint: Vector2?", 1, true)
		and moundEffect:find("INITIAL_FOOTPRINT_AREA_RATIO", 1, true),
	"Dig mound visuals must consume the player's actual item footprint"
)
assert(
	moundEffect:find("then horizontalFootprint.X * FOOTPRINT_DIAMETER_SCALE", 1, true)
		and moundEffect:find("then horizontalFootprint.Y * FOOTPRINT_DIAMETER_SCALE", 1, true),
	"Dig mound visuals must scale both horizontal axes from the personal item"
)
assert(
	moundEffect:find("if hasCustomFootprint then 0 else", 1, true),
	"Personal item footprints must not receive random size jitter"
)
assert(
	moundEffect:find("CENTER_TARGET_AREA_RATIO = 1.3", 1, true)
		and moundEffect:find("CENTER_TARGET_SCALE = math.sqrt(CENTER_TARGET_AREA_RATIO)", 1, true)
		and moundEffect:find("centerStartSize * Vector3.new(1, CENTER_TARGET_SCALE, CENTER_TARGET_SCALE)", 1, true),
	"Dig progress must enlarge the pit to 1.3x its initial horizontal area"
)
assert(
	controller:find("site.resolvedFootprint", 1, true)
		and controller:find("DigMoundEffect.Init", 1, true),
	"Client mound creation must use the personal resolved footprint"
)
assert(
	moundEffect:find("self.center.Size = self.centerStartSize:Lerp(self.centerTargetSize, eased)", 1, true),
	"Dig progress should expand the cylinder"
)
assert(
	moundEffect:find("rockOutwardDistance = ROCK_OUTWARD_DISTANCE * rockSizeScale", 1, true)
		and moundEffect:find("rockState.cframe.LookVector * self.rockOutwardDistance", 1, true),
	"Dig progress should scale dirt-block movement with the personal pit"
)
assert(
	not moundEffect:find("* rockSizeScale * sizeScale", 1, true),
	"Initial dirt blocks must not receive a second item-size multiplier"
)
assert(
	beamUtil:find("function RarityBeamUtil.Create", 1, true)
		and moundEffect:find("local beamRootRadii = Vector2.new(centerStartSize.Y * 0.5, centerStartSize.Z * 0.5)", 1, true)
		and moundEffect:find("RarityBeamUtil.Create(ground.position, folder, resolvedRarity, itemBounds, beamRootRadii)", 1, true)
		and moundEffect:find("self.beams:SetVisible(visible)", 1, true),
	"Procedural dig mounds must give persistent rarity beams their actual pit radii"
)

assert(
	beamUtil:find("local ROOT_EDGE_RATIO = 0.92", 1, true)
		and beamUtil:find("local radiusScale = ROOT_EDGE_RATIO * math.sqrt(math.random())", 1, true)
		and beamUtil:find("math.cos(angle) * rootRadii.X * radiusScale", 1, true)
		and beamUtil:find("math.sin(angle) * rootRadii.Y * radiusScale", 1, true)
		and not beamUtil:find("spreadRadius = sizeScale * 1.3", 1, true),
	"Beam roots must be sampled inside 92% of the actual pit ellipse, not from item bounds"
)

for _, radii in ipairs({
	{ x = 0.252, z = 0.252 },
	{ x = 1.009, z = 1.009 },
	{ x = 0.252, z = 2.018 },
}) do
	for _, angle in ipairs({ 0, math.pi / 4, math.pi / 2, math.pi, math.pi * 1.5 }) do
		for _, randomRadius in ipairs({ 0, 0.25, 0.5, 0.75, 1 }) do
			local radiusScale = 0.92 * math.sqrt(randomRadius)
			local x = math.cos(angle) * radii.x * radiusScale
			local z = math.sin(angle) * radii.z * radiusScale
			local normalizedDistance = (x / radii.x) ^ 2 + (z / radii.z) ^ 2
			assert(normalizedDistance <= 0.92 ^ 2 + 1e-9, "Beam root must remain inside the pit ellipse")
		end
	end
end
assert(
	controller:find("local function updateSiteBeamVisibility", 1, true)
		and controller:find("mound:SetBeamVisible(isVisible)", 1, true)
		and controller:find("updateSiteBeamVisibility(site, waterTop)", 1, true),
	"Pit light effects must follow tide coverage without being recreated"
)
assert(
	not moundEffect:find("StartDigging", 1, true) and not controller:find("mound:StartDigging", 1, true),
	"Procedural idle mounds should not require a delayed start hook"
)
assert(
	moundEffect:find('materialVariant = if result.Instance:IsA("BasePart") then result.Instance.MaterialVariant else ""', 1, true)
		and moundEffect:find('materialVariant = "",', 1, true),
	"Ground sampling must capture a BasePart MaterialVariant and safely fall back when unavailable"
)
assert(
	moundEffect:find("center.MaterialVariant = ground.materialVariant", 1, true)
		and moundEffect:find("rock.MaterialVariant = rockSample.materialVariant", 1, true),
	"Pit center and rim rocks must inherit their sampled MaterialVariant"
	)
assert(
	moundEffect:find("part.MaterialVariant = materialVariant", 1, true)
		and moundEffect:find("spawnDigDebris(scaledStrength, self.positionPart.Position, ground.material, ground.materialVariant, ground.color)", 1, true)
		and moundEffect:find("spawnSmallDigDebris(scaledStrength, self.positionPart.Position, ground.material, ground.materialVariant, ground.color)", 1, true),
	"Each dig hit should pass the ground MaterialVariant to both debris sizes"
)
assert(
	moundEffect:find("setLocalPlayerDebrisIgnore(false)", 1, true),
	"Mound cleanup must restore the local player collision group"
)

print("DigMoundProcedural.test.lua passed")
