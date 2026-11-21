local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end
local config = loadSource("src/ReplicatedStorage/Modules/EventFishConfig.lua")
for _, start in { 0, 3600, 86400, 1794412800 } do
	assert(start % 900 == 0)
	local window = config.GetWindow(start)
	assert(window.StartsAt == start and window.EndsAt == start + 15 and window.NextStartsAt == start + 900)
	assert(config.GetWindow(start + 899.99).SlotId == window.SlotId)
	assert(config.GetWindow(start + 900).SlotId == window.SlotId + 1)
end
assert(config.FormatCountdown(15) == "0:15" and config.FormatCountdown(885) == "14:45")
assert(config.FormatCountdown(0.01) == "0:01" and config.FormatCountdown(-1) == "0:00")

local workspace, storage = {}, {}
local function instance(class)
	assert(class == "Folder")
	local attributes = {}
	return {
		attributes = attributes,
		SetAttribute = function(_, key, value) attributes[key] = value end,
	}
end
local now, picks, warningCount, studio = 0, 0, 0, true
workspace.GetServerTimeNow = function() return now end
local fishes = {
	A = { FishID = "A", Model = "A", Rarity = "Event" },
	B = { FishID = "B", Model = "B", Rarity = "Event" },
	Missing = { FishID = "Missing", Model = "Missing", Rarity = "Event" },
	Normal = { FishID = "Normal", Model = "Normal", Rarity = "Secret" },
}
local unavailable = false
local services = {
	Workspace = workspace,
	RunService = { IsStudio = function() return studio end },
	ReplicatedFirst = { Data = { FishesData = fishes } },
	ReplicatedStorage = storage,
}
storage.Modules = { EventFishConfig = config, FishingAssets = { GetFish = function(name)
	return not unavailable and name ~= "Missing"
end } }
storage.Packages = { Knit = { CreateService = function(value) return value end } }
local service = loadSource("src/ServerScriptService/Services/EventFishService.lua", {
	game = { GetService = function(_, name) return services[name] end },
	require = function(module) return module end,
	Random = { new = function() return { NextInteger = function(_, low, high)
		assert(low == 1 and high == 2, "Only valid Event models enter the uniform pool")
		picks += 1
		return if picks % 2 == 1 then 1 else 2
	end } end },
	Instance = { new = instance },
	warn = function() warningCount += 1 end,
})
service:KnitInit()
local fish, initial = service:GetActiveFish()
assert(fish == fishes.A and picks == 1 and initial.FishId == "A")
assert(initial.StartsAt == 0 and initial.EndsAt == 15 and initial.SlotId == 0)
local revision = service._StateFolder.attributes.Revision
now = 14.999
assert(service:GetActiveFish() == fishes.A and picks == 1)
assert(service._StateFolder.attributes.Revision == revision, "Countdown ticks do not republish an identical snapshot")
now = 15
assert(service:GetActiveFish() == nil)
assert(initial.Phase == "Active" and initial.EndsAt == 15, "Publishing Waiting must leave the old snapshot intact")
assert(service._Snapshot.Phase == "Waiting" and service._Snapshot.NextStartsAt == 900)
now = 900
assert(service:GetActiveFish() == fishes.B and picks == 2)
now = 2705
assert(service:GetActiveFish() == fishes.A and picks == 3, "Delayed wake-up skips obsolete windows")
service._SlotId = nil
now = 3601
assert(service:GetActiveFish() == fishes.B and picks == 4, "Booting mid-window immediately selects one species")
service._SlotId = nil
now = 4600
assert(not service:GetActiveFish() and picks == 4, "Booting between windows must wait for the UTC boundary")
unavailable, now = true, 5400
assert(not service:GetActiveFish() and warningCount == 1)
now = 5401
assert(not service:GetActiveFish() and warningCount == 1, "Empty pools warn once per window")
unavailable = false
assert(service:StartDebugEvent("A"))
local debugEnd = service._OverrideWindow.EndsAt
assert(debugEnd == now + 15)
assert(service:GetActiveFish() == fishes.A and service._Snapshot.SlotId < 0)
now = debugEnd
assert(service._OverrideWindow and not service:GetActiveFish(), "Debug expiry resumes the absolute schedule")
studio = false
assert(not service:StartDebugEvent("A") and service.Client.StartDebugEvent == nil)
assert(service:StartEvent("B") == fishes.B, "Authorized server commands must also work outside Studio")
assert(service:GetActiveFish() == fishes.B and service.Client.StartEvent == nil)
local _, first = service:GetActiveFish()
now += 5
assert(service:StartEvent("A") == fishes.A)
local _, second = service:GetActiveFish(now)
assert(second.EndsAt == now + 15 and second.EndsAt == first.EndsAt + 5
	and second.SlotId ~= first.SlotId and first.FishId == "B" and second.FishId == "A",
	"Starting again publishes a fresh window without mutating the previous one")
now = second.EndsAt
local expiredFish, expiredSnapshot = service:GetActiveFish(now)
assert(expiredFish == nil and expiredSnapshot == nil and service._Snapshot.NextStartsAt == 6300,
	"A manual event must return to the UTC schedule")
