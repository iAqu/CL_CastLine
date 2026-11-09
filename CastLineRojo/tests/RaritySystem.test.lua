local createHarness = require("./helpers/RarityHarness")
local sources = {}
for _, name in ipairs({ "RarityConfig", "ItemRollUtil", "ItemStatUtil", "RarityRevealConfig", "GuiUtil", "DropVFXUtil" }) do
	local file = assert(io.open("src/ReplicatedStorage/Modules/" .. name .. ".lua", "r"))
	sources[name] = file:read("*a")
	file:close()
end

local function check(h)
	local Config = h.load("RarityConfig")
	local Roll = h.load("ItemRollUtil")
	local Stat = h.load("ItemStatUtil")
	local Reveal = h.load("RarityRevealConfig")
	local Gui = h.load("GuiUtil")
	local VFX = h.load("DropVFXUtil")
	local names = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret",
		"Divine", "Celestial", "Eternal", "Cosmic", "Exclusive" }
	local luck = { 1, 1.6, 2.6, 4.2, 7, 12, 20, 32, 52, 84, 136, 220 }
	local palettes = {
		{ "D7D7DE", "9696A0" }, { "96FF78", "32B432" }, { "78BEFF", "1E5AE6" },
		{ "D782FF", "7828DC" }, { "FFD25A", "FF7800" }, { "FF6E96", "C8003C" },
		{ "AEB5C6", "515969" }, { "FFFAC8", "FFD700" },
		{ "78F5FF", "BE82FF", "FF96DC" }, { "FFEBFF", "BE46FF", "3C0096" },
		{ "78FFFA", "3C5AFF", "14005A" }, { "FFDB89", "FF67B7", "8646FF" },
	}
	local function near(a, b) assert(math.abs(a - b) < 1e-6, tostring(a) .. " ~= " .. tostring(b)) end
	local function sameColor(a, b)
		near(a.R, b.R)
		near(a.G, b.G)
		near(a.B, b.B)
	end
	local function item(name, id)
		return { ItemID = id or name, Rarity = name, LayoutOrder = 1, RollChance = 1, Model = name,
			DefaultPrice = 100, DefaultWeight = 10, MinWeight = 1, MaxWeight = 50, SpecialLuckMult = 2 }
	end
	local random = { NextNumber = function(_, low, high) return low + (high - low) * 0.5 end }
	local available = function() return true end
	local label = h.newInstance("TextLabel")
	local model = { PrimaryPart = h.newInstance("Part"), GetBoundingBox = function()
		return {}, { X = 3, Y = 4, Z = 2 }
	end }
	local listed = Roll.GetRarities()
	assert(#listed == 12 and #Config.List == 12)
	for index, name in ipairs(names) do
		assert(listed[index] == name and Config.List[index].Name == name)
		assert(Config.Get(name).Index == index and Roll.GetRarityRank(name) == index)
		assert(Reveal.ResolveRarity(name) == name and Reveal.GetRank(name) == index)
		local points = Config.Get(name).Gradient.Keypoints
		assert(#points == #palettes[index])
		for pointIndex, hex in ipairs(palettes[index]) do
			near(points[pointIndex].Time, (pointIndex - 1) / (#points - 1))
			sameColor(points[pointIndex].Value, h.colors.fromHex(hex))
		end
		local midpoint = if #points == 3 then points[2].Value else points[1].Value:Lerp(points[2].Value, 0.5)
		sameColor(Config.Get(name).Color, midpoint)
		sameColor(Gui.GetRarityGradientColor(name), midpoint)
		-- The storage has no Gui or gradient templates: regular presentation must still work.
		Gui.SetRarityGradient(label, name)
		assert(#label:GetChildren() == 1)
		local gradient = label:GetChildren()[1]
		assert(gradient.Name == "UIGradient_" .. name and gradient.Enabled and gradient.Rotation == 0)
		assert(gradient.Color == Config.Get(name).Gradient)
		local light = assert(VFX.AttachRarityPointLight(model, name))
		sameColor(light.Color, midpoint)
		assert(light.Parent == model.PrimaryPart and light.Range == 4 and light.Brightness == 5)
		light:Destroy()
		local data = { [name] = item(name) }
		assert(Roll.RollRarity(data, { ["Chance_" .. name] = 1 }, "Zone_1", available, random) == name)
		assert(Roll.RollItemInRarity(data, name, "Zone_1", available, 0, random) == data[name])
		assert(Roll.RollRarity(data, {}, "Zone_1", available, random) == nil)
		assert(Roll.RollRarity({}, { ["Chance_" .. name] = 1 }, "Zone_1", available, random) == nil)
		near(Stat.CalculateLuck(data[name], 25, 3), luck[index] * 5 * 3 * 0.00045 * 2)
		assert(Stat.CalculatePrice(data[name], 20, 3, 2) == 1200)
		if index > 7 then
			for key, value in pairs(Reveal.GetStyle("Secret")) do assert(Reveal.GetStyle(name)[key] == value) end
		end
	end
	listed[1] = "mutated"
	assert(Roll.GetRarities()[1] == "Common", "Callers must not alter the shared ordering")
	assert(Config.Normalize("Mythical") == "Mythic" and Config.Normalize("Exclusive") == "Exclusive")
	assert(Config.Get("Mythical") == Config.Get("Mythic"))
	assert(Config.Get(nil).Name == "Common" and Reveal.ResolveRarity("unknown") == "Common")
	assert(Roll.GetRarityRank("Mythical") == 6 and Roll.GetRarityRank("Exclusive") == 12)
	assert(Reveal.GetStyle("Mythical") == Reveal.GetStyle("Mythic"))
	Gui.SetRarityGradient(label, "Mythical")
	assert(label:GetChildren()[1].Name == "UIGradient_Mythic")
	near(Stat.CalculateLuck(item("Mythical"), 25, 3), Stat.CalculateLuck(item("Mythic"), 25, 3))
	local legacy = { old = item("Mythical", "old"), new = item("Mythic", "new") }
	assert(#Roll.GetCandidates(legacy, "Mythic", "Zone_1", available) == 2)
	assert(#Roll.GetCandidates(legacy, "Mythical", "Zone_1", available) == 2)
	assert(Roll.RollRarity(legacy, { Chance_Mythical = 3 }, "Zone_1", available, random) == "Mythic")
	assert(Roll.RollRarity(legacy, { Chance_Mythic = 0, Chance_Mythical = 3 }, "Zone_1", available, random) == nil)
	assert(Roll.RollRarity(legacy, { Chance_Mythic = 3, Chance_Mythical = 0 }, "Zone_1", available, random) == "Mythic")
	-- Explicit new weight wins even when both fields are positive; they must not be added.
	local mixed = { common = item("Common"), mythic = item("Mythical") }
	local quarter = { NextNumber = function(_, low, high) return low + (high - low) * 0.25 end }
	assert(Roll.RollRarity(mixed, { Chance_Common = 1, Chance_Mythic = 1, Chance_Mythical = 100 },
		"Zone_1", available, quarter) == "Common")
	-- Missing, unrollable, unavailable and zone-limited candidates must not consume probability.
	local cosmic = item("Cosmic")
	cosmic.RollChance = 0
	assert(Roll.RollRarity({ cosmic }, { Chance_Cosmic = 1 }, "Zone_1", available, random) == nil)
	cosmic.RollChance = 1
	assert(Roll.RollRarity({ cosmic }, { Chance_Cosmic = 1 }, "Zone_1", function() return false end, random) == nil)
	cosmic.ZoneLimited = "Zone_2"
	assert(Roll.RollRarity({ cosmic }, { Chance_Cosmic = 1 }, "Zone_1", available, random) == nil)
	-- Special gradients keep their template properties and midpoint interpolation.
	local folder = h.newInstance("Folder")
	folder.Name, folder.Parent = "Gui", h.storage
	local gradients = h.newInstance("Folder")
	gradients.Name, gradients.Parent = "UIGradient", folder
	local template = h.newInstance("UIGradient")
	template.Name, template.Rotation, template.Enabled = "UIGradient_Exclusive", 20, false
	template.Color = h.sequence({ { Time = 0, Value = h.colors.new(1, 0, 0) },
		{ Time = 1, Value = h.colors.new(0, 0, 1) } })
	template.Parent = gradients
	Gui.SetRarityGradient(label, "Exclusive")
	assert(#label:GetChildren() == 1)
	local special = label:GetChildren()[1]
	assert(special ~= template and special.Enabled and special.Rotation == 20)
	assert(special.Color == template.Color and not template.Enabled)
	sameColor(Gui.GetRarityGradientColor("Exclusive"), h.colors.new(0.5, 0, 0.5))
	Gui.SetRarityGradient(label, nil)
	assert(#label:GetChildren() == 0)
	assert(Gui.GetRarityGradientColor(nil) == nil)
end

check(createHarness(sources))
