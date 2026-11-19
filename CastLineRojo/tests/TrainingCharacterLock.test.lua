local source = assert(io.open("src/ReplicatedStorage/Modules/TrainingCharacterLock.lua")):read("*a")
local zero = {}
local Lock = assert(
	load(source, "TrainingCharacterLock", "t", setmetatable({ Vector3 = { zero = zero } }, { __index = getfenv() }))
)()
local root = { Anchored = false, Parent = true }
local humanoid = { Health = 100, WalkSpeed = 23, AutoRotate = true, JumpPower = 55, JumpHeight = 8, Parent = true }
function humanoid:Move(value)
	self.move = value
end
local character = {}
function character:FindFirstChild()
	return root
end
function character:FindFirstChildOfClass()
	return humanoid
end
function character:PivotTo(frame)
	self.frame = frame
end
local frame = {}
local lease = assert(Lock.Acquire(character, frame))
assert(root.Anchored and humanoid.WalkSpeed == 0 and not humanoid.AutoRotate and character.frame == frame)
assert(humanoid.JumpPower == 55 and humanoid.JumpHeight == 8, "Touch jump must remain available")
assert(root.AssemblyLinearVelocity == zero and humanoid.move == zero)
Lock.Release(lease)
assert(not root.Anchored and humanoid.WalkSpeed == 23 and humanoid.AutoRotate)
lease = assert(Lock.Acquire(character, frame))
humanoid.WalkSpeed = 31
Lock.Release(lease)
assert(humanoid.WalkSpeed == 31, "Do not undo a newer movement owner")
root.Anchored = true
assert(Lock.Acquire(character, frame) == nil, "Do not take over an already fixed character")
root.Anchored = false
humanoid.Health = 0
assert(Lock.Acquire(character, frame) == nil)
Lock.Release(nil)
