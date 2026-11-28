local new = require("./helpers/FishingHarness")
local entranceDuration = 2.4

local function cast(studio)
	local h = new(true)
	h.studio = studio
	h.begin("NONE")
	h.cast()
	return h
end

local function tap(h, sequence)
	return h.client:TapCatch(h.player, h.token, h.round.round, sequence)
end

local function watchEscape(h)
	local times = {}
	h.client.CatchEscaped:Connect(function(player, token, round)
		assert(player == h.player and token == h.token and round == h.round.round, "Escape event must identify the current player, session and round")
		table.insert(times, h.now)
	end)
	return times
end

local h = cast(true)
local round = h.round
local escaped = watchEscape(h)
assert(round.entrance == "Rise" and round.biteEndsAt == nil and round.retryAt == nil, "Deep fish should use the rise window")
assert(math.abs(round.biteAt - round.readyAt - entranceDuration) < 1e-8, "The rise should last 2.4 seconds")
assert(not h.presentation().bite.hookedAt, "Observers must hold the bait until the first accepted tap")
h.advance(round.biteAt - h.now - 0.1)
local early = tap(h, 1)
assert(early.progress == 0.5 and early.sequence == 0 and not early.hookedAt and h.grants == 0, "An early tap must leave the initial meter untouched")
h.advance(round.biteAt - h.now + 1.08)
assert(#escaped == 0, "Catch escaped before its deadline")
assert(not h.client:Hook(h.player, h.token, round.round, h.now).ok, "The legacy hook must leave the deep catch to TapCatch")
assert(not h.client:TapCatch(h.player, h.token, round.round + 1, 1).ok, "A tap for a different round must be rejected")
local firstTapAt = h.now
local firstTap = tap(h, 1)
assert(math.abs(firstTap.progress - 0.585) < 1e-8, "First tap adds to the decayed half meter")
assert(firstTap.hookedAt == firstTapAt and h.presentation().bite.hookedAt == firstTapAt, "Client and observer should receive the first tap time")
local lookup = h.client:GetHookResult(h.player, h.token, round.round)
assert(lookup.status == "Unknown" and lookup.hookedAt == firstTapAt and lookup.sequence == 1, "Hook lookup must recover the accepted first tap")
h.advance(0.04)
local repeated = tap(h, 2)
assert(math.abs(repeated.progress - 0.585) < 1e-8 and repeated.hookedAt == firstTapAt, "Rate-limited taps must preserve progress and the first tap time")
h.advance(0.04)
assert(math.abs(tap(h, 2).progress - 0.585) < 1e-8, "Duplicate sequence must leave progress unchanged")
h.advance(round.biteAt + 2 - h.now)
assert(#escaped == 0, "Accepted taps extend the scheduled deadline")
h.advance(0.71)
assert(#escaped == 1 and h.grants == 0, "An idle catch must escape with no grant")
local lostRound = h.presentation().bite
assert(lostRound.hookedAt == firstTapAt and lostRound.escapedAt and not lostRound.liftAt, "Observer must receive the escape without a lift")
assert(math.abs(lostRound.escapedAt - (round.biteAt + 2.7)) < 1e-8, "Escape must use the extended deadline")
local recovery = h.client:GetHookResult(h.player, h.token, round.round)
assert(recovery.status == "Rejected" and recovery.result.code == "CatchEscaped", "Lookup must recover the escaped result")
assert(tap(h, 4).catchResult == recovery.result, "Subsequent taps should receive the same escape result")
assert(not h.client:NextRound(h.player, h.token, round.round).ok, "An escape must end the cast")
h.client:Cancel(h.player, h.token, false, round.round)
local empty = h.presentation()
assert(empty.phase == "EmptyReel" and empty.bite == nil and not h.service:IsActive(h.player), "Cancel must publish the empty reel")
h.client:Cancel(h.player, h.token, false, round.round)
assert(h.presentation() == empty, "Duplicate cancellation must not restart the empty reel")
h.advance(1)
assert(h.presentation() == nil and #escaped == 1, "Empty reel must finish after a single escape")

local idle = cast(false)
local idleEvents = watchEscape(idle)
assert(idle.round.entrance == "Rise", "Production deep fish must use the rise window")
assert(math.abs(idle.round.biteAt - idle.round.readyAt - entranceDuration) < 1e-8, "Production rise should last 2.4 seconds")
idle.advance(idle.round.biteAt - idle.now + 1.999)
assert(#idleEvents == 0, "No-input escape must wait for the meter to drain")
idle.advance(0.002)
assert(#idleEvents == 1 and idle.grants == 0, "No input must result in one escape and no grant")
assert(not idle.presentation().bite.hookedAt, "No-input escape must not enter the orbit")
assert(math.abs(idle.presentation().bite.escapedAt - idle.round.biteAt - 2) < 1e-8, "No-input deadline should be two seconds from the bite")

local held = cast(false)
held.now = held.round.biteAt + 1
local heldTap = tap(held, 1)
assert(heldTap.progress == 0.625 and heldTap.hookedAt == held.now, "The first second must preserve 50% and allow a tap")
held.now += 0.45
assert(math.abs(tap(held, 2).progress - 0.75) < 1e-8, "An accepted tap should hold progress for 0.45 seconds")
held.now += 0.55
assert(math.abs(tap(held, 3).progress - 0.825) < 1e-8, "An accepted tap should decay after 0.45 seconds")

local boundary = cast(false)
local boundaryEvents = watchEscape(boundary)
boundary.now = boundary.round.biteAt + 2 -- Exact deadline before executing the scheduled callback.
assert(tap(boundary, 1).catchResult.code == "CatchEscaped" and boundary.grants == 0, "A tap at the exact deadline must lose the catch")
boundary.advance(0)
assert(#boundaryEvents == 1, "The deadline callback must not send another escape")

local success = cast(true)
local successEvents = watchEscape(success)
success.now = success.round.biteAt + 0.2
local successHookAt = success.now
for sequence = 1, 3 do
	local reply = tap(success, sequence)
	assert(reply.progress == 0.5 + sequence * 0.125 and reply.hookedAt == successHookAt, "Every accepted tap must add progress and preserve the first timestamp")
	assert(success.grants == 0, "An incomplete meter must not grant a fish")
	success.advance(0.13)
end
success.onGrant = function()
	success.advance(3) -- Simulate a slow grant crossing the old escape deadline.
	assert(#successEvents == 0, "Escape must not interrupt a grant")
	assert(tap(success, 5).pending, "A competing tap should wait for the active grant")
	assert(success.client:GetHookResult(success.player, success.token, success.round.round).status == "Pending", "Lookup should report the active grant as pending")
end
local finalTap = tap(success, 4)
local result = finalTap.catchResult
assert(result.ok and success.grants == 1, "Filling the meter must grant one catch")
assert(finalTap.hookedAt == successHookAt and success.presentation().bite.hookedAt == successHookAt, "The final grant must keep the same start of the struggle")
assert(tap(success, 6).catchResult == result and success.grants == 1, "A repeated final tap must reuse the result")
assert(success.client:GetHookResult(success.player, success.token, success.round.round).result == result, "Lookup must recover the successful result")
success.advance(0)
assert(success.presentation().phase == "Catch" and success.presentation().catchId == result.catchId, "Observer should receive the granted catch")

local canceled = cast(true)
local canceledEvents = watchEscape(canceled)
canceled.now = canceled.round.biteAt
assert(tap(canceled, 1).progress == 0.625, "First tap should raise the half meter to 62.5%")
canceled.cancel()
canceled.begin("NONE")
local replacement = canceled.presentation()
canceled.advance(62)
assert(canceled.presentation() == replacement and canceled.grants == 0 and #canceledEvents == 0, "An old timeout must leave the replacement cast untouched")
