local RarityConfig = {}

export type Rarity = {
	Name: string,
	Index: number,
	Luck: number,
}

local function rarity(name: string, luck: number): Rarity
	return {
		Name = name,
		Index = 0,
		Luck = luck,
	}
end

-- Gameplay metadata only. Studio gradient templates own all presentation colors.
RarityConfig.List = {
	rarity("Common", 1),
	rarity("Uncommon", 1.6),
	rarity("Rare", 2.6),
	rarity("Epic", 4.2),
	rarity("Legendary", 7),
	rarity("Mythic", 12),
	rarity("Secret", 20),
	rarity("Divine", 32),
	rarity("Celestial", 52),
	rarity("Eternal", 84),
	rarity("Cosmic", 136),
	rarity("Exclusive", 220),
	rarity("Event", 20),
}

RarityConfig.ByName = {} :: { [string]: Rarity }
for index, entry in ipairs(RarityConfig.List) do
	entry.Index = index
	RarityConfig.ByName[entry.Name] = entry
end

function RarityConfig.Normalize(name: string?): string
	return if name == "Mythical" then "Mythic" else name or ""
end

function RarityConfig.Get(name: string?): Rarity
	return RarityConfig.ByName[RarityConfig.Normalize(name)] or RarityConfig.List[1]
end

return RarityConfig
