-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
return function() --[[ AfterStart | Line: 6 | Upvalues: ReplicatedStorage (copy), Players (copy) ]]
	for i, v in ipairs(ReplicatedStorage.Observers:GetChildren()) do
		if v:IsA("ModuleScript") then
			xpcall(function() --[[ Line: 15 | Upvalues: v (copy) ]]
				require(v)
			end, warn)
		end
	end
	task.spawn(function() --[[ Line: 20 | Upvalues: ReplicatedStorage (ref), Players (ref) ]]
		if require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UserPriority")):GetPriorityLevel(Players.LocalPlayer) < 3 then
			return
		end
		local CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"))
		if not CmdrClient then
			return
		end
		CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 })
	end)
	print("[CLIENT] \226\156\133 Successfully completed step: AfterStart")
end