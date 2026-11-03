-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GroupService = game:GetService("GroupService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = Net:RemoteEvent("VerifyGroupReward")
local v2 = nil
local Frame = Players.LocalPlayer.PlayerGui:WaitForChild("GroupRewards"):WaitForChild("Frame")
local t = {
	Start = function(p1) --[[ Start | Line: 28 | Upvalues: v2 (ref), Replion (copy), GuiControl (copy), Frame (copy), GroupService (copy), v1 (copy) ]]
		v2 = Replion.Client:WaitReplion("Data")
		GuiControl:Hook("Hold Button", Frame.Options.Yes).Clicked:Connect(function() --[[ Line: 32 | Upvalues: v2 (ref), GroupService (ref), GuiControl (ref), v1 (ref) ]]
			if v2:GetExpect("GroupReward") then
				return
			end
			local v12, v22 = pcall(function() --[[ Line: 37 | Upvalues: GroupService (ref) ]]
				return GroupService:PromptJoinAsync(35102746)
			end)
			if not v12 or v22 ~= Enum.GroupMembershipStatus.Joined and v22 ~= Enum.GroupMembershipStatus.AlreadyMember then
				v1:FireServer()
				return
			end
			GuiControl:Close()
			v1:FireServer()
		end)
		v2:OnChange("GroupReward", RefreshGroupReward)
		RefreshGroupReward(v2:GetExpect("GroupReward"))
	end
}
function RefreshGroupReward(p1) --[[ RefreshGroupReward | Line: 54 | Upvalues: Frame (copy) ]]
	Frame.Options.Yes.Label.Text = if p1 then "Claimed reward" else "Join group"
end
return t