local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local waterY = 10
local environment = setmetatable({
	script = { Parent = { FishingConfig = "config", WaterSurfaceUtil = "water" } },
	game = {
		GetService = function()
			return {}
		end,
	},
	require = function(name)
		if name == "config" then
			return config
		end
		if name == "water" then
			return {
				GetWaterSurfaceY = function()
					return waterY
				end,
			}
		end
		return {}
	end,
}, { __index = getfenv() })
local Bite = assert(load(read("src/ReplicatedStorage/Modules/FishingBiteSequence.lua"), "Bite", "t", environment))()
for _, withFish in ipairs({ false, true }) do
	for _, muted in ipairs({ false, true }) do
		local enabled, attempts, plays = not muted, 0, 0
		local sequence = setmetatable({
			owner = {
				fishAudio = {
					Play = function(_, name)
						assert(name == "FishFail")
						attempts += 1
						if enabled then
							plays += 1
						end
					end,
				},
			},
			reelFish = if withFish then {} else nil,
			reelMotion = { lifting = false, position = { Y = 1 } },
		}, Bite)
		local target = { Y = waterY }
		sequence:_updateReelSurface(1, target)
		assert(attempts == 0, "Sinking must not play failure audio even if the bait starts above water")
		sequence.reelMotion.lifting = true
		sequence.reelMotion.position.Y = -0.1
		sequence:_updateReelSurface(2, target)
		sequence.reelMotion.position.Y = 0
		sequence:_updateReelSurface(3, target)
		assert(attempts == 0, "Underwater lift and touching the surface must stay silent")
		sequence.reelMotion.position.Y = 0.01
		waterY += 0.02
		sequence:_updateReelSurface(4, target)
		assert(attempts == 0, "Crossing must use the current water height")
		sequence.reelMotion.position.Y = 0.03
		sequence:_updateReelSurface(5, target)
		assert(attempts == 1 and plays == (if muted then 0 else 1), "First crossing must consume the cue once")
		if withFish then
			assert(sequence.reelFish.startedAt == 5, "Fish escape and failure audio must start together")
		end
		enabled = true
		for _, height in ipairs({ -1, 0, 0.1, 5, 5 }) do
			sequence.reelMotion.position.Y = height
			sequence:_updateReelSurface(6, target)
		end
		assert(attempts == 1 and plays == (if muted then 0 else 1), "Bounce and unmuting must not replay failure audio")
		if withFish then
			assert(sequence.reelFish.startedAt == 5)
		end
		waterY = 10
	end
end
