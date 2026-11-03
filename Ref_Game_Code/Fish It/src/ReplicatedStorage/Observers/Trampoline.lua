-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local function PlayerTouched(p1, p2) --[[ PlayerTouched | Line: 6 | Upvalues: Players (copy) ]]
	local function onTouched(p1_2) --[[ onTouched | Line: 7 | Upvalues: Players (ref), p2 (copy) ]]
		local v1 = p1_2.Parent
		if not v1 then
			return
		end
		local v2 = Players:GetPlayerFromCharacter(v1)
		if v2 then
			p2(v2, v2.Character)
		end
	end
	return p1.Touched:Connect(onTouched)
end
Observers.observeTag("Trampoline", function(p1) --[[ Line: 20 | Upvalues: Players (copy) ]]
	local function f1(p1, p2) --[[ Line: 21 ]]
		local PrimaryPart = p2.PrimaryPart
		if not PrimaryPart then
			return
		end
		local v1 = p2:FindFirstChildWhichIsA("Humanoid")
		if v1 then
			PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, (18 + v1.JumpPower) * 1.6, 0)
		end
	end
	local function onTouched(p1_2) --[[ onTouched | Line: 7 | Upvalues: Players (ref), f1 (copy) ]]
		local v1 = p1_2.Parent
		if not v1 then
			return
		end
		local v2 = Players:GetPlayerFromCharacter(v1)
		if v2 then
			f1(v2, v2.Character)
		end
	end
	local v2 = p1.Touched:Connect(onTouched)
	return function() --[[ Line: 35 | Upvalues: v2 (copy) ]]
		v2:Disconnect()
	end
end)
return {}