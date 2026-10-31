local RarityRevealConfig = {}

export type RevealStyle = {
	minBeams: number,
	maxBeams: number,
	minHeight: number,
	maxHeight: number,
	minWidth: number,
	maxWidth: number,
	brightness: number,
	minSparkles: number,
	maxSparkles: number,
	sparkleBursts: number,
	flashDuration: number,
	flashBrightness: number,
	soundPlaybackSpeed: number,
}

local STYLES: { [string]: RevealStyle } = {
	Common = {
		minBeams = 2,
		maxBeams = 3,
		minHeight = 5,
		maxHeight = 8,
		minWidth = 1.2,
		maxWidth = 1.8,
		brightness = 0.60,
		minSparkles = 24,
		maxSparkles = 32,
		sparkleBursts = 1,
		flashDuration = 0.10,
		flashBrightness = 0.22,
		soundPlaybackSpeed = 0.92,
	},
	Uncommon = {
		minBeams = 3,
		maxBeams = 5,
		minHeight = 8,
		maxHeight = 12,
		minWidth = 1.5,
		maxWidth = 2.3,
		brightness = 0.68,
		minSparkles = 30,
		maxSparkles = 40,
		sparkleBursts = 1,
		flashDuration = 0.11,
		flashBrightness = 0.26,
		soundPlaybackSpeed = 0.98,
	},
	Rare = {
		minBeams = 4,
		maxBeams = 6,
		minHeight = 10,
		maxHeight = 14,
		minWidth = 1.7,
		maxWidth = 2.6,
		brightness = 0.75,
		minSparkles = 38,
		maxSparkles = 50,
		sparkleBursts = 1,
		flashDuration = 0.12,
		flashBrightness = 0.32,
		soundPlaybackSpeed = 1.05,
	},
	Epic = {
		minBeams = 5,
		maxBeams = 7,
		minHeight = 12,
		maxHeight = 17,
		minWidth = 2.0,
		maxWidth = 3.0,
		brightness = 0.81,
		minSparkles = 48,
		maxSparkles = 64,
		sparkleBursts = 1,
		flashDuration = 0.14,
		flashBrightness = 0.38,
		soundPlaybackSpeed = 1.11,
	},
	Legendary = {
		minBeams = 6,
		maxBeams = 8,
		minHeight = 14,
		maxHeight = 20,
		minWidth = 2.4,
		maxWidth = 3.6,
		brightness = 0.86,
		minSparkles = 64,
		maxSparkles = 80,
		sparkleBursts = 2,
		flashDuration = 0.16,
		flashBrightness = 0.48,
		soundPlaybackSpeed = 1.17,
	},
	Mythical = {
		minBeams = 7,
		maxBeams = 9,
		minHeight = 17,
		maxHeight = 24,
		minWidth = 2.8,
		maxWidth = 4.2,
		brightness = 0.90,
		minSparkles = 80,
		maxSparkles = 100,
		sparkleBursts = 2,
		flashDuration = 0.18,
		flashBrightness = 0.60,
		soundPlaybackSpeed = 1.23,
	},
	Secret = {
		minBeams = 8,
		maxBeams = 11,
		minHeight = 20,
		maxHeight = 28,
		minWidth = 3.4,
		maxWidth = 5.0,
		brightness = 0.94,
		minSparkles = 105,
		maxSparkles = 130,
		sparkleBursts = 3,
		flashDuration = 0.22,
		flashBrightness = 0.75,
		soundPlaybackSpeed = 1.30,
	},
}

local RARITY_RANKS = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Epic = 4,
	Legendary = 5,
	Mythical = 6,
	Secret = 7,
}

function RarityRevealConfig.ResolveRarity(rarity: string?): string
	local candidate = rarity or ""
	return if STYLES[candidate] then candidate else "Common"
end

function RarityRevealConfig.GetStyle(rarity: string?): RevealStyle
	return STYLES[RarityRevealConfig.ResolveRarity(rarity)]
end

function RarityRevealConfig.GetRank(rarity: string?): number
	return RARITY_RANKS[RarityRevealConfig.ResolveRarity(rarity)] or RARITY_RANKS.Common
end

function RarityRevealConfig.GetSizeScale(bounds: Vector3?): number
	if not bounds then
		return 1
	end

	local maxAxis = math.max(bounds.X, bounds.Y, bounds.Z)
	if maxAxis <= 0 then
		return 1
	end

	return math.clamp((maxAxis / 2) ^ 0.6, 0.8, 2.2)
end

return RarityRevealConfig
