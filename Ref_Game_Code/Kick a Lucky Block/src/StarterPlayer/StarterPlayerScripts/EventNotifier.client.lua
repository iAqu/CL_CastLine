-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TutorialServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.TutorialServiceClient)
local SocialService = game:GetService("SocialService")
local v1, v2 = pcall(function() --[[ Line: 11 | Upvalues: SocialService (copy) ]]
	return SocialService:GetExperienceEventAsync("4645576003077407370")
end)
if v1 and v2 and (v2.Status == Enum.ExperienceEventStatus.Active and not (v2.HasStarted or v2.HasEnded)) then
	local v3, v4 = pcall(function() --[[ Line: 23 | Upvalues: SocialService (copy) ]]
		return SocialService:GetEventRsvpStatusAsync("4645576003077407370")
	end)
	if v3 and v4 ~= Enum.RsvpStatus.Going then
		task.delay(60, function() --[[ Line: 35 | Upvalues: TutorialServiceClient (copy), SocialService (copy) ]]
			if TutorialServiceClient.InTutorial then
				TutorialServiceClient.Changed:Wait()
			end
			pcall(function() --[[ Line: 40 | Upvalues: SocialService (ref) ]]
				SocialService:PromptRsvpToEventAsync("4645576003077407370")
			end)
		end)
	end
end