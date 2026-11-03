local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local config = read("src/ReplicatedStorage/Modules/RarityRevealConfig.lua")

local expected = {
	Common = {
		"minBeams = 2",
		"maxBeams = 3",
		"minHeight = 5",
		"maxHeight = 8",
		"minWidth = 1.2",
		"maxWidth = 1.8",
		"brightness = 0.60",
		"minSparkles = 24",
		"maxSparkles = 32",
		"sparkleBursts = 1",
		"soundPlaybackSpeed = 0.92",
	},
	Uncommon = {
		"minBeams = 3",
		"maxBeams = 5",
		"minHeight = 8",
		"maxHeight = 12",
		"minWidth = 1.5",
		"maxWidth = 2.3",
		"brightness = 0.68",
		"minSparkles = 30",
		"maxSparkles = 40",
		"sparkleBursts = 1",
		"soundPlaybackSpeed = 0.98",
	},
	Rare = {
		"minBeams = 4",
		"maxBeams = 6",
		"minHeight = 10",
		"maxHeight = 14",
		"minWidth = 1.7",
		"maxWidth = 2.6",
		"brightness = 0.75",
		"minSparkles = 38",
		"maxSparkles = 50",
		"sparkleBursts = 1",
		"soundPlaybackSpeed = 1.05",
	},
	Epic = {
		"minBeams = 5",
		"maxBeams = 7",
		"minHeight = 12",
		"maxHeight = 17",
		"minWidth = 2.0",
		"maxWidth = 3.0",
		"brightness = 0.81",
		"minSparkles = 48",
		"maxSparkles = 64",
		"sparkleBursts = 1",
		"soundPlaybackSpeed = 1.11",
	},
	Legendary = {
		"minBeams = 6",
		"maxBeams = 8",
		"minHeight = 14",
		"maxHeight = 20",
		"minWidth = 2.4",
		"maxWidth = 3.6",
		"brightness = 0.86",
		"minSparkles = 64",
		"maxSparkles = 80",
		"sparkleBursts = 2",
		"soundPlaybackSpeed = 1.17",
	},
	Mythical = {
		"minBeams = 7",
		"maxBeams = 9",
		"minHeight = 17",
		"maxHeight = 24",
		"minWidth = 2.8",
		"maxWidth = 4.2",
		"brightness = 0.90",
		"minSparkles = 80",
		"maxSparkles = 100",
		"sparkleBursts = 2",
		"soundPlaybackSpeed = 1.23",
	},
	Secret = {
		"minBeams = 8",
		"maxBeams = 11",
		"minHeight = 20",
		"maxHeight = 28",
		"minWidth = 3.4",
		"maxWidth = 5.0",
		"brightness = 0.94",
		"minSparkles = 105",
		"maxSparkles = 130",
		"sparkleBursts = 3",
		"soundPlaybackSpeed = 1.30",
	},
}

for rarity, fields in pairs(expected) do
	local blockStart = assert(config:find("\n\t" .. rarity .. " = {", 1, true), "Missing reveal style for " .. rarity)
	local blockEnd = assert(config:find("\n\t},", blockStart, true), "Unterminated reveal style for " .. rarity)
	local block = config:sub(blockStart, blockEnd)
	for _, field in ipairs(fields) do
		assert(block:find(field, 1, true), rarity .. " missing expected field " .. field)
	end
end

for _, unsupportedRarity in ipairs({ "Unique", "Supreme", "Exclusive" }) do
	assert(
		not config:find("\n\t" .. unsupportedRarity .. " = {", 1, true),
		"Reveal styles must only include the seven dig rarities"
	)
end

assert(config:find('then candidate else "Common"', 1, true), "Unknown rarities must resolve to Common")
assert(
	config:find("STYLES[RarityRevealConfig.ResolveRarity(rarity)]", 1, true),
	"Style lookup must use the safe rarity"
)
assert(
	config:find("math.clamp((maxAxis / 2) ^ 0.6, 0.8, 2.2)", 1, true),
	"Item size scale must use the planned clamped formula"
)

print("RarityRevealConfig.test.lua passed")
