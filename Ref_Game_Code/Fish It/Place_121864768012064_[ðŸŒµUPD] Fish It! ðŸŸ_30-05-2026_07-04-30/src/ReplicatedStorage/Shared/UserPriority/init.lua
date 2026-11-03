-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuthorizedUserIds = require(ReplicatedStorage.Shared.AuthorizedUserIds)
local TradePlazaPlaceIds = require(script.TradePlazaPlaceIds)
local CommunityManagerUserIds = require(script.CommunityManagerUserIds)
local v1 = RunService:IsStudio()
local v2 = RunService:IsServer()
local v3 = RunService:IsClient()
local t = {
	IsTradePlaza = function(p1) --[[ IsTradePlaza | Line: 16 | Upvalues: v1 (copy), TradePlazaPlaceIds (copy) ]]
		if v1 and workspace:GetAttribute("DevTradePlaza") then
			return true
		else
			return table.find(TradePlazaPlaceIds, game.PlaceId) and true or false
		end
	end,
	IsValidTestSession = function(p1) --[[ IsValidTestSession | Line: 28 | Upvalues: v1 (copy) ]]
		return v1 or game.GameId == 6902403037
	end,
	IsPrivateServer = function(p1) --[[ IsPrivateServer | Line: 32 | Upvalues: v2 (copy), v3 (copy) ]]
		if v2 then
			return if game.PrivateServerOwnerId > 0 then string.len(game.PrivateServerId) > 0 else false
		else
			if not v3 then
				return false
			end
			local v22 = workspace:GetAttribute("PrivateServerOwnerId")
			local v32 = workspace:GetAttribute("PrivateServerId")
			if not (v22 and v32) then
				return false
			end
			return if v22 > 0 then string.len(v32) > 0 else false
		end
	end
}
function t.GetPriorityLevel(p1, p2) --[[ GetPriorityLevel | Line: 49 | Upvalues: AuthorizedUserIds (copy), t (copy), CommunityManagerUserIds (copy) ]]
	if table.find(AuthorizedUserIds, p2.UserId) then
		return 10
	end
	if t:IsValidTestSession() then
		if p2:GetAttribute("Dev") then
			return 10
		end
		if p2:GetAttribute("Tester") or p2:GetAttribute("Contributor") then
			return 5
		end
	end
	if table.find(CommunityManagerUserIds, p2.UserId) then
		return 5
	end
	local v2, v3 = pcall(function() --[[ Line: 70 | Upvalues: p2 (copy) ]]
		return p2:GetRankInGroupAsync(35102746)
	end)
	if not v2 then
		return 1
	end
	if v3 >= 253 then
		return 10
	end
	if v3 >= 250 then
		return 5
	end
	if v3 == 78 then
		return 4
	end
	if v3 == 4 then
		return 3
	else
		return 1
	end
end
return t