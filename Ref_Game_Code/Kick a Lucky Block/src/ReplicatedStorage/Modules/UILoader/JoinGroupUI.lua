-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("SocialService")
game:GetService("MaterialService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local LikeFrame = (PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")).LikeFrame
local ClaimButton = LikeFrame.ClaimButton
local PlaceId = game.PlaceId
local t = {}
function OnClaimPressed() --[[ OnClaimPressed | Line: 28 | Upvalues: AvatarEditorService (copy), PlaceId (copy), Network (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 29 | Upvalues: AvatarEditorService (ref), PlaceId (ref) ]]
		return AvatarEditorService:GetFavoriteAsync(PlaceId, Enum.AvatarItemType.Asset)
	end)
	if v1 then
		if v2 then
			Network.FireServer("GroupClaim")
		else
			AvatarEditorService:PromptSetFavorite(PlaceId, Enum.AvatarItemType.Asset, true)
		end
	else
		AvatarEditorService:PromptAllowInventoryReadAccess()
	end
end
function OnClaimResponse(p1, p2) --[[ OnClaimResponse | Line: 46 | Upvalues: VFXService (copy), ClaimButton (copy), Network (copy) ]]
	if p1 then
		if not p2 then
			VFXService.PlayVFX("PlayConfetti")
		end
		ClaimButton.TextLabel.Text = "Claimed"
		ClaimButton.Active = false
	else
		local v1, v2 = pcall(function() --[[ Line: 54 ]]
			return game:GetService("GroupService"):PromptJoinAsync(1041977165)
		end)
		if v1 and v2 == Enum.GroupMembershipStatus.Joined then
			Network.FireServer("GroupClaim")
		else
			ClaimButton.TextLabel.Text = "Claim"
		end
	end
end
function t.OpenFrame(p1) --[[ OpenFrame | Line: 65 | Upvalues: LikeFrame (copy) ]]
	if not LikeFrame.Visible then
		LikeFrame.Visible = true
	end
end
function t._init() --[[ _init | Line: 71 | Upvalues: LikeFrame (copy), ClaimButton (copy), Network (copy) ]]
	LikeFrame.Top.Main.Close.Activated:Connect(function() --[[ Line: 73 | Upvalues: LikeFrame (ref) ]]
		LikeFrame.Visible = false
	end)
	ClaimButton.Activated:Connect(OnClaimPressed)
	Network.OnClientEvent("GroupClaimResponse"):Connect(OnClaimResponse)
	Network.FireServer("GroupClaimCheck")
end
return t