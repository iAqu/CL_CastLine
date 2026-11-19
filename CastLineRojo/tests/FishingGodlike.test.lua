local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local prefix = "src/ReplicatedStorage/Modules/"
local Config = assert(loadstring(read(prefix .. "FishingConfig.lua")))()
local warnings, preloads = 0, 0
local env = setmetatable({
	script = { Parent = { FishingConfig = Config } },
	require = function(value)
		return value
	end,
	game = {
		GetService = function()
			return {
				PreloadAsync = function(_, assets)
					assert(#assets >= 1)
					preloads += 1
				end,
			}
		end,
	},
	Enum = { AnimationPriority = { Action = "Action" } },
	task = {
		spawn = function(fn)
			fn()
			return { cancelled = false }
		end,
		cancel = function(thread)
			thread.cancelled = true
		end,
	},
	warn = function()
		warnings += 1
	end,
}, { __index = getfenv() })
local P = assert(load(read(prefix .. "FishingCastPresentation.lua"), "Presentation", "t", env))()
local function track(length)
	return {
		Length = length,
		plays = 0,
		stops = 0,
		destroys = 0,
		Play = function(self, _, _, speed)
			self.plays += 1
			self.speed = speed
		end,
		Stop = function(self)
			self.stops += 1
		end,
		Destroy = function(self)
			self.destroys += 1
		end,
	}
end
local normal, special = {}, {
	IsA = function(_, class)
		return class == "Animation"
	end,
}
local function prepare(length)
	local owner = { castClickedAt = 10 }
	local tracks = { normal = track(2.1666667), special = track(length) }
	P.Prepare(owner, {
		LoadAnimation = function(_, animation)
			return if animation == normal then tracks.normal else tracks.special
		end,
	}, normal, special)
	assert(tracks.normal.plays == 0 and tracks.special.plays == 0, "Preparation must not play either track")
	return owner, tracks
end
for _, progress in { 0, 0.5, 0.8, 0.95, 0.950001, 1 } do
	local owner, tracks = prepare(2.5166667)
	local rating = Config.GetCastRating(progress).Id
	P.Select(owner, rating)
	assert((owner.castProfile.Animation == "SpecialCastRod") == (progress > 0.95))
	assert(P.Ready(owner, 10.35))
	P.Play(owner)
	local selected = if progress > 0.95 then tracks.special else tracks.normal
	local other = if progress > 0.95 then tracks.normal else tracks.special
	assert(selected.plays == 1 and selected.speed == 1 and other.plays == 0 and other.stops == 1)
	local preload = owner.castPreloadTask
	P.Destroy(owner)
	P.Destroy(owner)
	assert(preload.cancelled and owner.castPreloadTask == nil, "Cancel preparation work on exit")
	assert(tracks.normal.destroys == 1 and tracks.special.destroys == 1, "Cleanup both loaded tracks once")
end
local owner, tracks = prepare(0)
P.Select(owner, "GODLIKE")
assert(not P.Ready(owner, 10.5), "Wait for the selected animation")
assert(P.Ready(owner, 18) and owner.specialFallback and owner.track == tracks.normal)
P.Play(owner)
assert(math.abs(tracks.normal.speed * 2.49 - 2.05) < 1e-9, "Fallback release pose must match the special timeline")
assert(tracks.special.plays == 0 and warnings == 1)
P.Destroy(owner)
owner, tracks = prepare(0)
P.Select(owner, "GODLIKE")
assert(P.Ready(owner, 18))
assert(warnings == 1, "Warn once across casts")
P.Destroy(owner)
assert(preloads == 8)

local new = require("./helpers/FishingHarness")
for _, progress in { 0.95, 0.950001, 1 } do
	local h = new()
	h.begin("NONE")
	local start = h.now
	local result = h.client:Cast(h.player, h.token, progress)
	assert(result.ok)
	local profile = Config.GetCastProfile(result.castRating)
	local earliest = start + profile.LeadTime + profile.ReleaseTime + 1 -- FishingHarness uses a one-second flight
	h.now = earliest - 0.001
	assert(
		not h.client:NextRound(h.player, h.token, 0).ok,
		"No bite before the selected animation releases and bait lands"
	)
	h.now = earliest + 0.001
	assert(h.client:NextRound(h.player, h.token, 0).ok, "No extra cinematic wait after landing")
end
