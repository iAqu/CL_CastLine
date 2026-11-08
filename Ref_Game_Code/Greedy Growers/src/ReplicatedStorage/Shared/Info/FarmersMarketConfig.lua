-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local t = {
	CELLS_PER_ROW = 4,
	REFRESH_INTERVAL = 43200,
	BOARD_VERSION = 4
}
local t2 = { "COMMON", "RARE" }
local t3 = { "RARE", "EPIC" }
local t4 = { "LEGENDARY", "MYTHIC", "CELESTIAL", "SECRET", "DIVINE", "TRANSCENDENT", "ANCIENT" }

t.TOP_TIER_BONUS = 100
t.TOP_TIER_RARITIES = {
	TRANSCENDENT = true,
	ANCIENT = true
}
t.Rows = {
	{
		kind = "regular",
		difficulty = "easy",
		reward = 25,
		tiers = t2
	},
	{
		kind = "regular",
		difficulty = "medium",
		reward = 50,
		tiers = { "EPIC", "LEGENDARY" }
	},
	{
		kind = "regular",
		difficulty = "hard",
		reward = 75,
		topTierBonusOverride = 75,
		tiers = { "MYTHIC", "CELESTIAL", "SECRET", "DIVINE", "TRANSCENDENT", "ANCIENT" }
	},
	{
		kind = "mutated",
		difficulty = "easy",
		reward = 35,
		tiers = t2,
		mutations = { "Dewy", "Shocked", "Radioactive" }
	},
	{
		kind = "mutated",
		difficulty = "medium",
		reward = 65,
		tiers = t3,
		mutations = { "Dewy", "Shocked", "Radioactive", "Golden" }
	},
	{
		kind = "mutated",
		difficulty = "hard",
		reward = 100,
		tiers = t4,
		mutations = {
			"Dewy",
			"Shocked",
			"Radioactive",
			"Golden",
			"Cosmic",
			"Charged",
			"Infested",
			"Slimy",
			"Scaled"
		}
	},
	{
		kind = "huge",
		difficulty = "easy",
		sizeMin = 12,
		sizeMax = 18,
		reward = 35,
		tiers = t2
	},
	{
		kind = "huge",
		difficulty = "medium",
		sizeMin = 22,
		sizeMax = 28,
		reward = 65,
		tiers = t3
	},
	{
		kind = "huge",
		difficulty = "hard",
		sizeMin = 35,
		sizeMax = 50,
		reward = 100,
		tiers = t4
	}
}
function t.ApplyOverrides(p1) --[[ ApplyOverrides | Line: 39 | Upvalues: t (copy) ]]
	if type(p1) ~= "table" then
		return
	end

	for v1, v2 in p1 do
		local v3 = tonumber(v2)

		if v3 and not (v3 <= 0) then
			local v4, v5 = v1:match("^Row(%d+)(%a+)$")
			local v6 = if v4 then t.Rows[tonumber(v4)] else v4

			if v1 == "RefreshInterval" then
				t.REFRESH_INTERVAL = v3

				continue
			end

			if v6 then
				if v5 == "Reward" then
					v6.reward = v3

					continue
				end

				if v5 == "SizeMin" and v6.sizeMin then
					v6.sizeMin = v3

					continue
				end

				if v5 == "SizeMax" and v6.sizeMax then
					v6.sizeMax = v3
				end
			end
		end
	end
end

return t