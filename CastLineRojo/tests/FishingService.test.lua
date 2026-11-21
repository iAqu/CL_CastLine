local new = require("./helpers/FishingHarness")
local h = new()
local roll = h.roll
local config = assert(loadstring(assert(io.open("src/ReplicatedStorage/Modules/FishingConfig.lua")):read("*a")))()
-- Preserve the optional legacy cap's growth-boundary regression tests.
local file = assert(io.open("src/ReplicatedStorage/Modules/FishingRoll.lua"))
local source = file:read("*a")
file:close()
config.RodWeightLimitEnabled = true
roll = assert(load(
	source,
	"roll",
	"t",
	setmetatable({
		script = { Parent = { FishingConfig = config, PetFeatureConfig = { Enabled = false } } },
		require = function(v)
			return v
		end,
	}, { __index = getfenv() })
))()
local function weightRoll(defaultWeight, maxWeight, values)
	local calls = 0
	local weight = roll.RollWeight(defaultWeight, maxWeight, {
		NextNumber = function()
			calls += 1
			return assert(values[calls], "Unexpected weight roll")
		end,
	})
	assert(calls == #values, "Expected each supplied weight roll to be used")
	return weight
end

assert(weightRoll(1, 10, { 0.2 }) == 1, "A failed first step keeps the base weight")
assert(weightRoll(1, 10, { 0.19 }) == 3.375, "Keep the first full step when the second would exceed the cap")
assert(weightRoll(1, 3.375, { 0.19 }) == 3.375, "Allow a rolled weight exactly at the cap")
assert(weightRoll(10, 10, {}) == 10, "Skip growth when the base weight is already at the cap")
assert(
	weightRoll(1, 1_000_000, { 0.19, 0.24, 0.29, 0.34, 0.39, 0.39, 0.4 }) == 1.5 ^ 18,
	"Increase the growth chance up to 40 percent"
)
local maxStepsWeight = weightRoll(1, 1e23, table.create(40, 0))
assert(math.abs(maxStepsWeight / 1.5 ^ 120 - 1) < 1e-12, "Stop growth after 40 successful steps")

h.ready = false
assert(h.client:Begin(h.player).code == "ProfileNotReady")
h.ready = true
local plot = h.plot
h.plot = nil
assert(not h.client:Begin(h.player).ok)
h.plot = plot
h.footZ = -1000
assert(not h.client:Begin(h.player).ok)
h.footZ = 0
h.begin()
assert(not h.client:Begin(h.player).ok)
assert(not h.client:SelectBait(h.player, "wrong", "NONE").ok)
assert(not h.client:SelectBait(h.player, h.token, "Bait_103").ok)
local getFish = h.assets.GetFish
h.assets.GetFish = function()
	return nil
end
assert(not h.client:SelectBait(h.player, h.token, "Bait_102").ok)
h.assets.GetFish = getFish
h.profile.Data.Wins = 4
assert(not h.client:SelectBait(h.player, h.token, "Bait_102").ok)
h.profile.Data.Wins = 100
assert(h.client:SelectBait(h.player, h.token, "Bait_102").ok)
assert(h.profile.Data.Wins == 100, "Only a successful grant consumes payment")
assert(not h.client:SelectBait(h.player, h.token, "Bait_102").ok)
assert(h.castAt(0.65).distance == 30)
assert(not h.client:NextRound(h.player, h.token, 0).ok, "No catch before landing")
h.now += 5
h.round = h.client:NextRound(h.player, h.token, 0)
local fishId = h.round.fishId
assert(h.round.ok and h.fishes[fishId].Rarity == "Common")
assert(not h.client:Hook(h.player, h.token, 1, h.now).ok, "No early hook")
assert(not h.client:NextRound(h.player, h.token, 1).ok, "No early next round")
h.failGrant = true
local initialCatch
h.onGrant = function(options)
	initialCatch = options
end
assert(not h.hook().ok and h.grants == 0 and h.profile.Data.Wins == 100)
assert(initialCatch.MutationId == "Golden")
h.now = h.round.retryAt + 0.1
h.sample = 0.99
h.round = h.client:NextRound(h.player, h.token, 1)
assert(h.round.fishId == fishId, "Escape cannot reroll species within a session")
h.failGrant = false
h.onGrant = function(options)
	assert(
		options.InstanceId == initialCatch.InstanceId and options.MutationId == initialCatch.MutationId,
		"Escape and grant failure preserve the catch and mutation within a session"
	)
	assert(not h.client:Hook(h.player, h.token, h.round.round, h.now).ok, "Reentrant hook cannot grant twice")
	assert(not h.client:Begin(h.player).ok, "An active claim still owns the fishing session")
end
assert(h.hook().ok and h.grants == 1 and h.profile.Data.Wins == 95)
assert(h.profile.Data.FishingProgress.Count == 1)
assert(not h.hook().ok and h.grants == 1)
h.onGrant = nil
h.cancel()
h.profile.Data.EquippedRodId = "Rod_103"
h.begin("NONE")
h.profile.Data.EquippedRodId = "Rod_101"
h.cast()
assert(h.fishes[h.round.fishId].Rarity == "Uncommon", "Session snapshots its rod")
assert(h.hook().ok and h.grants == 2)
h.cancel()
h.begin("NONE")
h.now += 100
assert(h.client:Cast(h.player, h.token, 1).ok, "Long preparation remains valid")
local secret = new()
secret.activeEvent = secret.fishes.Event
local endsAt = secret.now + 15
secret.eventWindow = { SlotId = 1, StartsAt = secret.now, EndsAt = endsAt }
local eventSession = secret.begin()
assert(eventSession.eventFish.FishId == secret.activeEvent.FishID)
assert(eventSession.eventFish.SlotId == 1 and eventSession.eventFish.EndsAt == endsAt)
secret.now = endsAt
assert(secret.client:SelectBait(secret.player, secret.token, "NONE").ok)
local eventRound = secret.cast()
assert(eventRound.fishId == secret.activeEvent.FishID, "A cast after expiry must use the event locked on entry")
secret.fishes.EventB = table.clone(secret.fishes.Event)
secret.fishes.EventB.FishID = "EventB"
secret.activeEvent = secret.fishes.EventB
secret.eventWindow = { SlotId = 2, StartsAt = secret.now, EndsAt = secret.now + 15 }
secret.now = eventRound.retryAt
secret.round = secret.client:NextRound(secret.player, secret.token, eventRound.round)
assert(secret.round.ok and secret.round.fishId == eventRound.fishId, "A replacement event must not change this cast")
local secretCatch = secret.hook()
assert(secretCatch.ok and secretCatch.catchId == eventRound.fishId and secret.profile.Data.FishingProgress.Count == 0)
secret.cancel()
assert(secret.begin().eventFish.FishId == "EventB", "The next entry may participate in the replacement event")
secret.cancel()
secret.now = secret.eventWindow.EndsAt
assert(not secret.begin("NONE").eventFish, "Event eligibility closes at the exact deadline")
secret.eventWindow = { SlotId = 3, StartsAt = secret.now, EndsAt = secret.now + 15 }
assert(secret.cast().fishId ~= "EventB", "An event starting after entry must not apply to the current cast")
assert(secret.hook().ok and secret.profile.Data.FishingProgress.Count == 1)

local join = new()
local slot = -7
join.activeEvent = join.fishes.Event
join.eventWindow = { SlotId = slot, StartsAt = join.now, EndsAt = join.now + 15 }
join.footZ = -1000
local character = join.player.Character
local rootPart = character:FindFirstChild("HumanoidRootPart")
local pivot, destination, landed = {}, {}, {}
local teleports = 0
character.GetPivot = function() return pivot end
character.PivotTo = function(_, target)
	assert(target == landed, "Teleport to the server's fishing spot, using the character pivot offset")
	teleports += 1
end
rootPart.CFrame = { ToObjectSpace = function(_, value)
	assert(value == pivot)
	return pivot
end }
setmetatable(destination, { __mul = function(_, offset)
	assert(offset == pivot)
	return landed
end })
join.fishingSpot.GetEntryRootCFrame = function(spot, root, humanoid)
	assert(spot == join.plot:FindFirstChild("FishingStartPart") and root == rootPart and humanoid == join.humanoid)
	return destination
end
assert(join.client:JoinEvent(join.player, slot + 1).code == "EventExpired")
join.plot.OwnerUserId = 123
assert(join.client:JoinEvent(join.player, slot).code == "MissingFishingSpot")
join.plot.OwnerUserId = join.player.UserId
join.player.IsTraining = true
assert(join.client:JoinEvent(join.player, slot).code == "FishingBusy")
join.player.IsTraining = nil
assert(teleports == 0, "Rejected joins must leave the player in place")
assert(join.client:Begin(join.player).code == "OutsideFishingSpot")
local joined = join.client:JoinEvent(join.player, slot)
assert(joined.ok and joined.eventFish.SlotId == slot and joined.baitQuotes.Bait_102)
assert(not join.client:JoinEvent(join.player, slot).ok and teleports == 1)
join.now = join.eventWindow.EndsAt
assert(join.client:SelectBait(join.player, joined.token, "NONE").ok)
join.client:Cancel(join.player, joined.token)
assert(join.client:JoinEvent(join.player, slot).code == "EventExpired" and teleports == 1)

-- A presentation failure after the profile commit must never duplicate payment or grants.
local broken = new()
broken.begin("Bait_102")
broken.cast()
broken.throwAfterCommit = true
assert(broken.hook().ok and broken.grants == 1)

local lesson = new()
local lessonData = lesson.profile.Data
local levels = assert(loadstring(assert(io.open("src/ReplicatedFirst/Data/TrainingLevelsData.lua")):read("*a")))()
local trainingProgress = assert(loadstring(assert(io.open("src/ReplicatedStorage/Modules/TrainingProgress.lua")):read("*a")))()
local finalCatchCap = levels["2"].MaxCatchWeight
lesson.maxCatchWeight = levels["3"].MaxCatchWeight
lessonData.Wins = 0
lessonData.FishingOnboarding = { Stage = "PlaceFish", FishUid = "FishingIntro_1" }
lesson.fishes.Fish_106.DefaultWeight = 10.8
lesson.activeEvent = lesson.fishes.Event
lesson.eventWindow = { SlotId = 1, StartsAt = lesson.now, EndsAt = lesson.now + 900 }
local firstEntry = lesson.begin("NONE")
assert(firstEntry.lesson == nil and firstEntry.baitQuotes.Bait_102, "Opening handoff leaves the fishing spot in normal play")
assert(lesson.cast().fishId == "Event", "Fishing during placement uses the normal catch path")
assert(lesson.hook().ok and not lesson.hook().ok)
assert(lessonData.FishingOnboarding.Stage == "PlaceFish")
assert(lessonData.FishingOnboarding.FishUid == "FishingIntro_1", "A normal catch does not replace the placement target")
assert(#lesson.equippedCatches == 0)
lesson.client:Cancel(lesson.player, lesson.token, true)
lesson.client:Cancel(lesson.player, lesson.token, true)
assert(#lesson.equippedCatches == 1 and lesson.equippedCatches[1] == lesson.lastOptions.InstanceId)
lessonData.FishingOnboarding.Stage = "FinalCatch"
lessonData.EquippedRodId = "Rod_102"
local secondEntry = lesson.begin()
assert(secondEntry.guideBaitId == "Bait_102" and secondEntry.baitQuotes.Bait_102.price == 100)
for index, baitId in ipairs(lesson.rods.Rod_102.BaitsSelect) do
	assert(secondEntry.baitQuotes[baitId].tier == index)
end
local tooExpensive = lesson.client:SelectBait(lesson.player, lesson.token, secondEntry.guideBaitId)
assert(not tooExpensive.ok and tooExpensive.message == "Not enough cash for Caterpillar. Select NONE to fish for free.")
lessonData.Wins = -1
local negativeBalance = lesson.client:SelectBait(lesson.player, lesson.token, "NONE")
assert(not negativeBalance.ok and negativeBalance.message == "Not enough cash")
lessonData.Wins = 0
local free = lesson.client:SelectBait(lesson.player, lesson.token, "NONE")
assert(free.ok and free.lesson == nil)
assert(lesson.cast().fishId == "Event" and lesson.hook().ok)
assert(lessonData.FishingOnboarding.Stage == "FinalCatch" and lessonData.Wins == 0)
lesson.cancel()
assert(#lesson.equippedCatches == 1, "A cancellation is not a successful return")
lessonData.Wins = 200
lesson.begin()
for _, baitId in ipairs({ "NONE", "Bait_104", "Bait_106", "Bait_108" }) do
	local rejected = lesson.client:SelectBait(lesson.player, lesson.token, baitId)
	assert(not rejected.ok and not rejected.needsPurchase and rejected.message == "Select Caterpillar.")
end
assert(lesson.client:SelectBait(lesson.player, lesson.token, secondEntry.guideBaitId).ok)
assert(lessonData.Wins == 200)
lesson.cancel()
assert(lessonData.Wins == 200 and lessonData.FishingOnboarding.Stage == "FinalCatch")
lesson.begin(secondEntry.guideBaitId)
local finalLessonRound = lesson.cast()
assert(finalLessonRound.fishId == "Fish_106" and finalLessonRound.maxCatchWeight == finalCatchCap,
	"The final lesson keeps the level 2 cap after training to level 3")
assert(finalLessonRound.weight == trainingProgress.CalculateFishWeight(lesson.fishes.Fish_106.DefaultWeight, finalCatchCap),
	"The final lesson calculates the catch weight with its cap")
lesson.failGrant = true
assert(not lesson.hook().ok and lessonData.Wins == 200)
lesson.failGrant = false
lessonData.Wins = 99
assert(not lesson.hook().ok and lessonData.Wins == 99 and lessonData.FishingOnboarding.Stage == "FinalCatch")
lessonData.Wins = 200
assert(finalLessonRound.mutationId == "Golden" and lesson.hook().ok)
assert(lessonData.FishingOnboarding.Stage == "Complete" and lessonData.Wins == 100 and lesson.grants == 3)
assert(lessonData.FishingProgress.Count == 1 and not lesson.hook().ok)
lesson.client:Cancel(lesson.player, lesson.token, true)
assert(#lesson.equippedCatches == 2 and lesson.equippedCatches[2] == lesson.lastOptions.InstanceId)

lesson.activeEvent = nil
assert(not lesson.begin("NONE").guideBaitId)
lesson.cast()
assert(lesson.hook().ok)
lesson.client:Cancel(lesson.player, lesson.token, true)
assert(#lesson.equippedCatches == 3, "Regular catches are also equipped after returning")

for _, baits in ipairs({ { "NONE", "Bait_102" }, { "Bait_102", "Bait_104" } }) do
	local returning = new()
	local cash = returning.profile.Data.Wins
	local oldToken = returning.begin(baits[1]).token
	local oldRound = returning.cast()
	local progress = returning.profile.Data.FishingProgress
	local rod = progress.Rods.Rod_101
	assert(rod.Pending == nil, "An active catch must not be written to the profile")
	returning.cancel()
	assert(progress.Count == 0 and progress.Rods.Rod_101.MissHigh == 0)
	assert(returning.profile.Data.Wins == cash and returning.grants == 0)
	if baits[1] == "NONE" then
		progress.Version = 1
		rod.Pending = { BaitId = "NONE", FishId = oldRound.fishId }
		returning.reload()
	end
	returning.sample = 0.99
	local reopened = returning.begin()
	assert(progress.Version == 2 and rod.Pending == nil)
	assert(reopened.token ~= oldToken and reopened.baitQuotes[baits[2]].available)
	assert(reopened.pendingBaitId == nil, "Returning must allow a new bait selection")
	assert(not returning.client:SelectBait(returning.player, oldToken, baits[2]).ok)
	assert(not returning.client:NextRound(returning.player, oldToken, oldRound.round).ok)
	assert(not returning.client:Hook(returning.player, oldToken, oldRound.round, returning.now).ok)
	returning.client:Cancel(returning.player, oldToken)
	assert(returning.client:SelectBait(returning.player, returning.token, baits[2]).ok)
	local freshRound = returning.cast()
	assert(freshRound.fishId ~= oldRound.fishId, "A new session must draw a fresh catch")
	assert(returning.hook().ok)
	assert(returning.profile.Data.Wins == cash - reopened.baitQuotes[baits[2]].price and returning.grants == 1)
	assert(not returning.hook().ok and progress.Count == 1)
end

local racing = new()
local cash = racing.profile.Data.Wins
racing.begin("Bait_102")
racing.cast()
local replacement
racing.onGrant = function()
	racing.cancel()
	replacement = racing.begin("NONE")
end
assert(not racing.hook().ok, "Exiting before the grant commits must cancel the old catch")
assert(replacement and racing.grants == 0 and racing.profile.Data.Wins == cash)
assert(racing.profile.Data.FishingProgress.Count == 0)
racing.onGrant = nil
racing.cast()
assert(racing.hook().ok and racing.grants == 1 and racing.profile.Data.Wins == cash)

local completed = new()
local startingCash = completed.profile.Data.Wins
local settledToken = completed.begin("Bait_102").token
local settledRound = completed.cast()
completed.afterGrant = function()
	completed.cancel()
	completed.begin("Bait_104")
end
assert(completed.hook().ok, "An exit after commit must preserve the completed catch")
assert(completed.grants == 1 and completed.profile.Data.Wins == startingCash - 5)
assert(completed.profile.Data.FishingProgress.Count == 1)
assert(not completed.client:Hook(completed.player, settledToken, settledRound.round, completed.now).ok)
assert(
	completed.castAt(1).ok,
	"Old claim completion must leave the new session intact"
)
assert(not broken.hook().ok and broken.grants == 1)
-- Death and replacement characters cannot use the old session.
local dead = new()
dead.begin("NONE")
dead.cast()
dead.humanoid.Health = 0
assert(not dead.hook().ok and dead.grants == 0)
dead.humanoid.Health = 100
dead.player.Character = {
	FindFirstChild = function()
		return nil
	end,
	FindFirstChildOfClass = function()
		return nil
	end,
}
assert(not dead.hook().ok and dead.grants == 0)
