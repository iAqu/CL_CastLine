local RarityConfig = {}

export type Rarity = {
	Name: string,
	Index: number,
	Gradient: ColorSequence,
	Color: Color3,
	Luck: number,
}

local function rarity(name: string, colors: { string }, luck: number): Rarity
	local points = {}
	for index, hex in ipairs(colors) do
		table.insert(points, ColorSequenceKeypoint.new((index - 1) / (#colors - 1), Color3.fromHex(hex)))
	end
	local midpoint = if #points == 3 then points[2].Value else points[1].Value:Lerp(points[2].Value, 0.5)
	return {
		Name = name,
		Index = 0,
		Gradient = ColorSequence.new(points),
		Color = midpoint,
		Luck = luck,
	}
end

-- ThrowFood palette; Secret is lifted to dark silver for the existing dark text strokes.
RarityConfig.List = {
	rarity("Common", { "D7D7DE", "9696A0" }, 1),
	rarity("Uncommon", { "96FF78", "32B432" }, 1.6),
	rarity("Rare", { "78BEFF", "1E5AE6" }, 2.6),
	rarity("Epic", { "D782FF", "7828DC" }, 4.2),
	rarity("Legendary", { "FFD25A", "FF7800" }, 7),
	rarity("Mythic", { "FF6E96", "C8003C" }, 12),
	rarity("Secret", { "AEB5C6", "515969" }, 20),
	rarity("Divine", { "FFFAC8", "FFD700" }, 32),
	rarity("Celestial", { "78F5FF", "BE82FF", "FF96DC" }, 52),
	rarity("Eternal", { "FFEBFF", "BE46FF", "3C0096" }, 84),
	rarity("Cosmic", { "78FFFA", "3C5AFF", "14005A" }, 136),
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
