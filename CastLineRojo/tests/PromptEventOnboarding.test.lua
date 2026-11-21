local function loadSource(path, overrides)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(overrides or {}, { __index = getfenv() })))()
end

local loading = loadSource("src/ReplicatedFirst/LoadingAttributes.lua")
local onboarding = loadSource("src/ReplicatedStorage/Modules/FishingOnboarding.lua")
local gate = loadSource("src/ReplicatedStorage/Modules/EventPresentationGate.lua", {
	script = { Parent = { FishingOnboarding = onboarding } },
	require = function(value) return value end,
})
local flags, callbacks, deferred = {}, {}, {}
local player = { GetAttribute = function(_, flag) return flags[flag] end }
function player:GetAttributeChangedSignal(flag)
	return { Connect = function(_, callback)
		callbacks[flag] = callback
		return { Disconnect = function() callbacks[flag] = nil end }
	end }
end
local function set(flag, value)
	flags[flag] = value
	if callbacks[flag] then callbacks[flag]() end
end
local queries, prompts, interruptLookup = 0, 0, true
local social = {
	GetUpcomingExperienceEventsAsync = function()
		queries += 1
		return { { Id = 3, HasStarted = true }, { Id = 4 }, { Id = 5 } }
	end,
	GetEventRsvpStatusAsync = function(_, id)
		assert(id == 4, "Select the first upcoming event")
		if interruptLookup then
			interruptLookup = false
			set("FishingIntroActive", true)
		end
		return "NotGoing"
	end,
	PromptRsvpToEventAsync = function(_, id)
		assert(id == 4 and not gate.IsSuppressed(player), "Never prompt inside a tutorial")
		prompts += 1
	end,
}
local services = {
	Players = { LocalPlayer = player },
	ReplicatedFirst = { LoadingAttributes = loading },
	ReplicatedStorage = {
		Modules = { EventPresentationGate = gate },
		Packages = { Knit = { CreateController = function(controller) return controller end } },
	},
	SocialService = social,
}
local delay
local controller = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/PromptEventController.lua", {
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	Enum = { RsvpStatus = { Going = "Going" } },
	task = {
		delay = function(_, callback) delay = callback end,
		defer = function(callback) table.insert(deferred, callback) end,
	},
})

controller:KnitStart()
delay()
set(loading.PLAYER_DATA_LOADED, true)
set(loading.LOADING_SCREEN_DONE, true)
set(loading.INTRO_STARTUP_STATE, loading.INTRO_STATE.Prepared)
set("FishingIntroActive", true)
set(onboarding.StageAttribute, "PlaceFish")
set(loading.INTRO_STARTUP_STATE, loading.INTRO_STATE.Skipped)
set("FishingIntroActive", false)
set(onboarding.LessonActiveAttribute, true)
set(onboarding.StageAttribute, "Complete")
assert(#deferred == 0 and queries == 0, "Defer even the first lookup until the final return ends")
set(onboarding.LessonActiveAttribute, false)
assert(#deferred == 1, "Look up upcoming events after returning to free gameplay")
table.remove(deferred, 1)()
assert(queries == 1 and prompts == 0, "Recheck protection after RSVP lookup yields")
set("FishingIntroActive", false)
table.remove(deferred, 1)()
assert(queries == 2 and prompts == 1, "After returning, query the current events and prompt once")
set("FishingIntroActive", true)
set("FishingIntroActive", false)
assert(#deferred == 0 and prompts == 1, "Do not show a second native RSVP in this session")
