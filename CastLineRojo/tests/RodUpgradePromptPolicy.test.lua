local Policy = require("../src/ReplicatedStorage/Modules/RodUpgradePromptPolicy")
local rods = {
	a = { LayoutOrder = 1, Price = 0, Model = "a" },
	b = { LayoutOrder = 2, Price = 100, Model = "b" },
	c = { LayoutOrder = 3, Price = 2000, Model = "c" },
	d = { LayoutOrder = 4, Price = 30000, Model = "d" },
}
local function setup(available)
	return Policy.new(rods, available or function() return true end, 0), {
		ready = true, rodReady = true, blocked = false, longBusy = false, shopOpen = false, paused = false,
		owned = { a = true }, balance = 100,
	}
end

local p, c = setup()
assert(p:Candidate(c.owned, 99) == nil, "Skip an unaffordable rod")
assert(p:Candidate(c.owned, 100) == "b", "First paid rod must participate")
assert(p:Candidate(c.owned, 2000) == "c", "Can recommend a skipped tier")
assert(p:Candidate({ a = true, c = true }, 100) == nil, "Highest owned, not equipped, defines progression")
assert(p:Candidate({ a = true, c = true }, 30000) == "d", "Find the next affordable rod")
p.seen.c = true
assert(p:Candidate(c.owned, 2000) == nil, "Do not backfill a lower unseen rod")
assert(p:Candidate(c.owned, 100) == "b", "The new highest affordable candidate can change when cash falls")
local missing = setup(function(model)
	return model ~= "d"
end)
assert(missing:Candidate({ a = true }, 30000) == "c", "Missing models cannot be offered")

p, c = setup()
assert(p:Update(5.99, c) == nil, "Wait for the startup cooldown")
c.ready = false
assert(p:Update(6, c) == nil, "Wait for player readiness")
c.ready, c.blocked = true, true
assert(p:Update(7, c) == nil, "Wait when a blocking UI is open")
c.blocked = false
local event, id = p:Update(8, c)
assert(event == "Show" and id == "b" and p.active.remaining == 7, "Start the rod reminder with seven seconds")
c.balance = 30000
p:Update(9, c)
assert(p.active.id == "b", "A visible rod target is stable when cash changes")
c.balance = 0
c.paused = true
p:Update(12, c)
assert(p.active.remaining == 6, "Hover/gamepad focus pauses the countdown")
c.paused = false
assert(p:Update(18, c) == "Close" and p.active == nil and p.seen.b, "A timed-out rod is marked seen")
assert(p.notBefore == 19.5, "Pause between reminders")
c.balance = 100
assert(p:Update(20, c) == nil, "Timeout does not repeat the same rod")

p, c = setup()
p:Update(6, c)
c.blocked = true
local closeEvent, reason = p:Update(7, c)
assert(closeEvent == "Close" and reason == "Interrupted" and not p.seen.b, "An early interruption clears seen state")
c.blocked = false
assert(p:Update(8.49, c) == nil, "The close cooldown applies after interruption")
assert(p:Update(8.5, c) == "Show", "Early interruption restores eligibility after the close cooldown")
c.blocked = true
p:Update(10.5, c)
assert(p.seen.b, "Interruption at two seconds does not restore eligibility")

for _, closeReason in ipairs({ "Close", "Action", "Timeout", "Done" }) do
	p, c = setup()
	p:Update(6, c)
	p:Close(6.1, closeReason)
	assert(p.seen.b and p.notBefore == 7.6, "Manual/action close retains the per-session seen record")
end

p, c = setup()
c.longBusy, c.blocked = true, true
p:Update(5, c)
c.longBusy, c.blocked = false, false
p:Update(6, c)
assert(p.notBefore == 11 and p:Update(10.99, c) == nil, "Wait for the long-busy cooldown")
assert(p:Update(11, c) == "Show", "Fishing/hatching end defers five seconds")
c.longBusy, c.blocked = true, true
p:Update(11.5, c)
c.shopOpen = true
p:Update(12, c)
c.longBusy, c.blocked, c.shopOpen = false, false, false
p:Update(13, c)
assert(p.notBefore == 18, "Overlapping cooldowns keep the latest deadline")
assert(p:Update(17.99, c) == nil and p:Update(18, c) == "Show", "Show after all cooldowns expire")

p, c = setup()
c.shopOpen, c.blocked = true, true
p:Update(10, c)
c.shopOpen, c.blocked = false, false
p:Update(11, c)
assert(p:Update(11.99, c) == nil and p:Update(12, c) == "Show", "Shop closing defers one second")
c.owned.c = true
local done, doneReason = p:Update(12.1, c)
assert(done == "Close" and doneReason == "Done", "Buying the target or higher closes the prompt")

p, c = setup()
p:Update(6, c)
p:Close(7, "Close")
c.ready = false
p:Update(20, c)
c.ready = true
assert(p:Update(21, c) == nil and p.seen.b, "Character respawn does not reset session history")

local Progress = require("../src/ReplicatedStorage/Modules/TrainingProgress")
local training = {
	Training_101 = { TrainingID = "Training_101", LayoutOrder = 1, Price = 0 },
	Training_102 = { TrainingID = "Training_102", LayoutOrder = 2, Price = 100 },
	Training_103 = { TrainingID = "Training_103", LayoutOrder = 3, Price = 250 },
}
local function equip(context, trainingId)
	context.trainingId = trainingId
	context.barbell = Progress.GetNextEquipment(training, trainingId)
end

p, c = setup()
equip(c, "Training_101")
c.balance = 99
assert(p:Update(6, c) == nil, "An unaffordable barbell is skipped")
c.balance = 100
local show, item = p:Update(7, c)
assert(show == "Show" and item == "b" and p.active.kind == "Rod", "The rod wins when both are eligible")
assert(p:Update(8, c) == nil and p.active.kind == "Rod", "Only one prompt is active")
p:Close(8, "Close")
show, item = p:Update(9.5, c)
assert(
	show == "Show" and item == "Training_102" and p.active.kind == "Barbell" and p.active.remaining == 7,
	"Show the next barbell after the rod is dismissed"
)
c.paused = true
p:Update(10.5, c)
assert(p.active.remaining == 7, "Barbell focus pauses the shared countdown")
equip(c, "Training_102")
done, doneReason = p:Update(11, c)
assert(done == "Close" and doneReason == "Done", "An equipment change closes the stale recommendation")
c.rodReady = false
c.balance = 250
show, item = p:Update(12.5, c)
assert(show == "Show" and item == "Training_103", "Barbell reminders can run without a ready rod shop")
equip(c, "Training_103")
assert(p:Update(13, c) == "Close", "Close the reminder when training reaches max")
assert(p:Update(20, c) == nil, "Max training equipment has no recommendation")

p, c = setup()
equip(c, "Training_101")
c.rodReady = false
assert(p:Update(6, c) == "Show", "Show when cash reaches the exact price")
c.balance = 99
local interrupted, interruptionReason = p:Update(7, c)
assert(interrupted == "Close" and interruptionReason == "Interrupted", "Close when the barbell is no longer affordable")
c.balance = 100
assert(p:Update(8.5, c) == "Show", "A brief interruption lets the barbell reappear")
p:Close(9, "Close")
assert(p:Update(12, c) == nil, "Dismissing an item consumes that item's session reminder")
