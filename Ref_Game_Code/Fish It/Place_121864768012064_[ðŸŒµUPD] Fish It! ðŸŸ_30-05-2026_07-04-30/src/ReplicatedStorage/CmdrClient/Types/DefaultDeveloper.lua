-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
return function(p1) --[[ Line: 7 | Upvalues: Players (copy), UserPriority (copy) ]]
	p1:RegisterHook("BeforeRun", function(p1) --[[ Line: 8 | Upvalues: Players (ref), UserPriority (ref) ]]
		if p1.Group ~= "DefaultDeveloper" then
			return
		end
		local v1 = Players:GetPlayerByUserId(p1.Executor.UserId)
		if not v1 then
			return "Error locating player"
		end
		if UserPriority:GetPriorityLevel(v1) < 5 then
			return "You don\'t have permission to run this command"
		end
	end)
end