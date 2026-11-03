-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = require(ReplicatedStorage.Events)
return {
	GetEvent = function(p1, p2) --[[ GetEvent | Line: 15 | Upvalues: Events (copy) ]]
		return Events[p2]
	end,
	GetJobId = function(p1) --[[ GetJobId | Line: 19 | Upvalues: RunService (copy) ]]
		if RunService:IsStudio() then
			return "00000000-0000-0000-0000-000000000000"
		else
			return game.JobId
		end
	end
}