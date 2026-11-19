-- Runtime-only character lease: release the exact character we acquired.
local Lock = {}

function Lock.Acquire(character, frame)
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 or root.Anchored then
		return nil
	end
	local lease = {
		root = root,
		humanoid = humanoid,
		anchored = root.Anchored,
		walkSpeed = humanoid.WalkSpeed,
		autoRotate = humanoid.AutoRotate,
	}
	root.Anchored = true
	root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
	character:PivotTo(frame)
	humanoid.AutoRotate, humanoid.WalkSpeed, humanoid.Jump = false, 0, false
	humanoid:Move(Vector3.zero)
	return lease
end

function Lock.Release(lease)
	if not lease then
		return
	end
	if lease.root.Parent and lease.root.Anchored then
		lease.root.Anchored = lease.anchored
		lease.root.AssemblyLinearVelocity, lease.root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
	end
	if lease.humanoid.Parent then
		if lease.humanoid.WalkSpeed == 0 then
			lease.humanoid.WalkSpeed = lease.walkSpeed
		end
		if lease.humanoid.AutoRotate == false then
			lease.humanoid.AutoRotate = lease.autoRotate
		end
	end
end

return Lock
