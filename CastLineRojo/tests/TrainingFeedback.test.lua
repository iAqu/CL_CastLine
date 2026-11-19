local Feedback = assert(loadstring(assert(io.open("src/ReplicatedStorage/Modules/TrainingFeedback.lua")):read("*a")))()
local Levels = assert(loadstring(assert(io.open("src/ReplicatedFirst/Data/TrainingLevelsData.lua")):read("*a")))()
local function snapshot(revision, level, xp, active)
	return {
		revision = revision,
		level = level,
		xp = xp,
		maxCatchWeight = Levels[tostring(level)].MaxCatchWeight,
		active = active ~= false,
	}
end
local start = snapshot(1, 1, 0)
assert(Feedback.GetChanges(nil, start, Levels).xp == 0, "Initial state must not award visual XP")
assert(Feedback.GetChanges(start, snapshot(2, 1, 1), Levels).xp == 1, "Normal rep")
assert(Feedback.GetChanges(start, snapshot(2, 1, 2), Levels).xp == 2, "DoubleTrain rep")
assert(Feedback.GetChanges(start, start, Levels).xp == 0, "Duplicate snapshot")
assert(Feedback.GetChanges(start, snapshot(0, 1, 5), Levels).xp == 0, "Stale snapshot")
assert(Feedback.GetChanges(start, snapshot(2, 1, 0), Levels).xp == 0, "Equipment purchase alone")
local old = snapshot(1, 1, Levels["1"].XpToNextLevel - 1)
local change = Feedback.GetChanges(old, snapshot(2, 2, 1), Levels)
assert(change.xp == 2 and change.levels == 1 and change.weight == 10, "Level-up carries XP")
change = Feedback.GetChanges(old, snapshot(2, 3, 3), Levels)
assert(
	change.xp == 9 and change.levels == 2 and change.weight == 20,
	"One combined multi-level celebration"
)
assert(Feedback.GetChanges(snapshot(1, 1500, 0), snapshot(2, 1500, 0), Levels).xp == 0, "No fictitious XP at MAX")
change = Feedback.GetChanges(snapshot(1, 1499, Levels["1499"].XpToNextLevel - 1), snapshot(2, 1500, 0), Levels)
assert(change.xp == 1 and change.levels == 1, "Last level only shows applied XP")
assert(Feedback.GetChanges(start, snapshot(2, 1, 1, false), Levels).xp == 0, "Stop must not emit")
assert(
	Feedback.GetChanges(snapshot(1, 1, 1, false), snapshot(2, 1, 2), Levels).xp == 0,
	"Reentry establishes a fresh baseline"
)
assert(Feedback.GetChanges(snapshot(1, 3, 0), start, Levels).xp == 0, "Profile replacement must not replay rewards")
