-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game.ReplicatedStorage
local Trove = require(ReplicatedStorage.Packages.Trove)
local PlayerEvents = require(ReplicatedStorage.Shared.PlayerEvents)
local t = {}
local t2 = {}
local t3 = {}
function t3.LockPlayer(p1, p2, p3) --[[ LockPlayer | Line: 12 | Upvalues: t (copy), t2 (copy), t3 (copy) ]]
	local v1 = t[p2]
	if not v1 then
		return
	end
	if t2[p2][p3] then
		return
	end
	local v2 = v1:Extend()
	t2[p2][p3] = v2
	v2:Add(p2.CharacterAdded:Connect(function(p1) --[[ Line: 25 | Upvalues: t3 (ref) ]]
		task.wait(0)
		t3:_removeWalkSpeed(p1)
	end))
	local Character = p2.Character
	if not Character then
		return
	end
	t3:_removeWalkSpeed(Character)
end
function t3.UnlockPlayer(p1, p2, p3) --[[ UnlockPlayer | Line: 36 | Upvalues: t2 (copy), t3 (copy) ]]
	local v1 = t2[p2]
	if not v1 then
		return
	end
	local v2 = v1[p3]
	if not v2 then
		return
	end
	v2:Destroy()
	t2[p2][p3] = nil
	if next(t2[p2]) ~= nil then
		return
	end
	t3:_restoreWalkSpeed(p2)
end
function t3._removeWalkSpeed(p1, p2) --[[ _removeWalkSpeed | Line: 55 ]]
	p2:FindFirstChild("HumanoidRootPart")
	local v1 = p2:FindFirstChildWhichIsA("Humanoid")
	if not v1 then
		return
	end
	v1:SetAttribute("PreviousWalkingSpeed", v1.WalkSpeed)
	v1:SetAttribute("WalkingSpeedLocked", true)
	v1.WalkSpeed = 4
end
function t3._restoreWalkSpeed(p1, p2) --[[ _restoreWalkSpeed | Line: 71 ]]
	local Character = p2.Character
	if not Character then
		return
	end
	local v1 = Character:FindFirstChildWhichIsA("Humanoid")
	if not v1 then
		return
	end
	Character:FindFirstChild("HumanoidRootPart")
	local v2 = v1:GetAttribute("PreviousWalkingSpeed")
	if v2 then
		v1.WalkSpeed = v2
	end
	v1:SetAttribute("WalkingSpeedLocked", nil)
end
PlayerEvents:PlayerAdded(function(p1) --[[ Line: 97 | Upvalues: t (copy), Trove (copy), t2 (copy) ]]
	t[p1] = Trove.new()
	t2[p1] = {}
end)
PlayerEvents:PlayerRemoving(function(p1) --[[ Line: 102 | Upvalues: t2 (copy), t (copy) ]]
	local v1 = t2[p1]
	if v1 then
		for v2, v3 in v1 do
			v3:Destroy()
			t2[p1][v2] = nil
		end
		t2[p1] = nil
	end
	local v4 = t[p1]
	if not v4 then
		return
	end
	v4:Destroy()
	t[p1] = nil
end)
return t3