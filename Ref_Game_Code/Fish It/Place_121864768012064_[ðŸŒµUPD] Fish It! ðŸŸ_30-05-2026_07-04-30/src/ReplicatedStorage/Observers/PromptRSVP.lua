-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion"))
local Promise = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Promise"))
local Observers = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Observers"))
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local v1 = Promise.promisify(function(p1) --[[ Line: 10 | Upvalues: SocialService (copy) ]]
	return SocialService:GetEventRsvpStatusAsync((tostring(p1)))
end)
local v2 = Promise.promisify(function(p1) --[[ Line: 16 | Upvalues: SocialService (copy) ]]
	return SocialService:PromptRsvpToEventAsync((tostring(p1)))
end)
Observers.observeTag("PromptRSVP", function(p1) --[[ Line: 22 | Upvalues: Replion (copy), ReplicatedStorage (copy), UserPriority (copy), Promise (copy), v1 (copy), v2 (copy) ]]
	Replion.Client:WaitReplion("Data")
	local v12 = Replion.Client:WaitReplion("RemoteConfigs")
	require(ReplicatedStorage.Controllers.TextNotificationController)
	local v22 = if UserPriority:IsValidTestSession() then "Not active in test server" else "Follow Event!"
	local ProximityPrompt = Instance.new("ProximityPrompt")
	ProximityPrompt.ActionText = v22
	ProximityPrompt.ObjectText = ""
	ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
	ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadUp
	ProximityPrompt.RequiresLineOfSight = false
	ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
	ProximityPrompt.Parent = p1
	local function getEventId() --[[ getEventId | Line: 39 | Upvalues: v12 (copy), p1 (copy) ]]
		local v1 = v12:Get("EventId")
		if v1 and (string.len(v1) > 0 and v1 ~= "NONE") then
			return v1
		else
			return p1:GetAttribute("EventId")
		end
	end
	local function refreshPrompt(p12) --[[ refreshPrompt | Line: 48 | Upvalues: UserPriority (ref), v12 (copy), p1 (copy), Promise (ref), v1 (ref), ProximityPrompt (copy) ]]
		if UserPriority:IsValidTestSession() then
			return
		end
		if not p12 then
			local v13 = v12:Get("EventId")
			local v4, v5 = Promise.try(v1, if v13 and (string.len(v13) > 0 and v13 ~= "NONE") then v13 else p1:GetAttribute("EventId")):catch(warn):await()
			if v4 then
				p12 = v5
			end
		end
		ProximityPrompt.Enabled = not (p12 == Enum.RsvpStatus.Going)
	end
	local function sendUpdate() --[[ sendUpdate | Line: 67 | Upvalues: UserPriority (ref), v12 (copy), p1 (copy), Promise (ref), v2 (ref), refreshPrompt (copy) ]]
		if UserPriority:IsValidTestSession() then
			return
		end
		local v1 = v12:Get("EventId")
		Promise.try(v2, if v1 and (string.len(v1) > 0 and v1 ~= "NONE") then v1 else p1:GetAttribute("EventId")):andThen(refreshPrompt):catch(warn)
	end
	local v3 = ProximityPrompt.Triggered:Connect(function() --[[ Line: 78 | Upvalues: UserPriority (ref), v12 (copy), p1 (copy), Promise (ref), v2 (ref), refreshPrompt (copy) ]]
		if UserPriority:IsValidTestSession() then
			return
		end
		local v1 = v12:Get("EventId")
		Promise.try(v2, if v1 and (string.len(v1) > 0 and v1 ~= "NONE") then v1 else p1:GetAttribute("EventId")):andThen(refreshPrompt):catch(warn)
	end)
	local v4 = v12:OnChange("EventId", function() --[[ Line: 82 | Upvalues: refreshPrompt (copy) ]]
		refreshPrompt()
	end)
	refreshPrompt()
	return function() --[[ Line: 88 | Upvalues: v4 (copy), v3 (copy) ]]
		v4:Disconnect()
		v3:Disconnect()
	end
end)
return {}