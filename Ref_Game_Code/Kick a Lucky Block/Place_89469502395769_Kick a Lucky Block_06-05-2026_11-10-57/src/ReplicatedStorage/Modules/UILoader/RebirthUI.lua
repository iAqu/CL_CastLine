-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local v1 = require("@game/ReplicatedStorage/Modules/ServicesLoader/RebirthServiceClient")
local v2 = require("@game/ReplicatedStorage/Modules/ServicesLoader/KickServiceClient")
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local FormatValue = require(ReplicatedStorage.Functional.FormatValue)
local v3 = require("@game/ReplicatedStorage/Shared/Data/RebirthData")
local v4 = PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")
local v5 = PlayerGui:FindFirstChild("HUD") or PlayerGui:WaitForChild("HUD")
local Rebirth = v4.Rebirth
local Info = v5.LeftPanel.Rebirth.Info
local t = {
	Requirement = 0,
	RequirementChanged = Signal.new(),
	IsMax = false
}
function ShowMax() --[[ ShowMax | Line: 45 | Upvalues: Rebirth (copy) ]]
	Rebirth.Progress.CanvasGroup.Bar.Size = UDim2.fromScale(1, 1)
	Rebirth.Progress.Title.Text = "MAX REBIRTH"
	Rebirth.SkipRebirth.Visible = false
	Rebirth.Rebirth.Visible = false
end
function UpdateRequirements(p1) --[[ UpdateRequirements | Line: 52 | Upvalues: t (copy), v3 (copy) ]]
	t.Requirement = v3:GetKickRequirement(p1 + 1)
	t.RequirementChanged:Fire()
end
function LoadRewards(p1) --[[ LoadRewards | Line: 57 | Upvalues: v3 (copy), Rebirth (copy) ]]
	local v1 = v3:GetMultiplierFromLevel(p1)
	local v2 = v3:GetMultiplierFromLevel(p1 + 1)
	Rebirth.RewardsFrame.RewardsLabels.Now.Text = ("x%* Cash"):format(v1)
	Rebirth.RewardsFrame.RewardsLabels.Next.Text = ("x%* Cash"):format(v2)
end
function OnRebirthChanged(p1) --[[ OnRebirthChanged | Line: 64 | Upvalues: Rebirth (copy), v3 (copy), t (copy) ]]
	Rebirth.RebirthLevel.Text = ("Rebirth %*"):format(p1)
	if v3.MAX_REBIRTH <= p1 then
		t.IsMax = true
		ShowMax()
	else
		UpdateRequirements(p1)
		LoadRewards(p1)
	end
end
function OnRequiredChanged() --[[ OnRequiredChanged | Line: 75 | Upvalues: t (copy), v2 (copy), Info (copy), Rebirth (copy), FormatValue (copy) ]]
	if not t.IsMax then
		local Level = v2.Level
		local Requirement = t.Requirement
		local v1 = math.clamp(Level / Requirement, 0, 1)
		Info.Visible = Requirement <= Level
		if Rebirth.Visible then
			Rebirth.Progress.CanvasGroup.Bar.Size = UDim2.fromScale(v1, 1)
			Rebirth.Progress.Title.Text = ("%s Kick Power"):format((("%*/%*"):format(FormatValue(Level, true), (FormatValue(Requirement, true)))))
		end
	end
end
function InitButtons() --[[ InitButtons | Line: 92 | Upvalues: Rebirth (copy), v2 (copy), t (copy), v1 (copy), VFXService (copy), MessagesService (copy) ]]
	Rebirth.Rebirth.Activated:Connect(function() --[[ Line: 93 | Upvalues: v2 (ref), t (ref), v1 (ref), VFXService (ref), MessagesService (ref) ]]
		if v2.Level >= t.Requirement then
			v1:RequestRebirth()
			VFXService.PlayVFX("PlayConfetti")
		else
			MessagesService:PlayMessage("Not Enough Kick Level!", "Error")
		end
	end)
	Rebirth.Top.Main.Close.Activated:Connect(function() --[[ Line: 105 | Upvalues: Rebirth (ref) ]]
		Rebirth.Visible = false
	end)
end
function HandleGamepad() --[[ HandleGamepad | Line: 110 | Upvalues: Trove (copy), UserInputService (copy), Rebirth (copy), GuiService (copy) ]]
	local v1 = Trove.new()
	v1:Connect(UserInputService.InputBegan, function(p1, p2) --[[ Line: 112 | Upvalues: Rebirth (ref) ]]
		if not p2 and p1.KeyCode == Enum.KeyCode.ButtonB then
			Rebirth.Visible = false
		end
	end)
	v1:Connect(Rebirth:GetPropertyChangedSignal("Visible"), function() --[[ Line: 118 | Upvalues: Rebirth (ref), v1 (copy) ]]
		if not Rebirth.Visible then
			v1:Clean()
		end
	end)
	v1:Add(function() --[[ Line: 123 | Upvalues: GuiService (ref) ]]
		GuiService.SelectedObject = nil
	end)
	GuiService.SelectedObject = Rebirth.Rebirth
end
function t.OpenFrame(p1) --[[ OpenFrame | Line: 130 | Upvalues: Rebirth (copy) ]]
	if not Rebirth.Visible then
		Rebirth.Visible = true
	end
end
function t._init() --[[ _init | Line: 137 | Upvalues: v1 (copy), t (copy), v2 (copy), Rebirth (copy), ClientProfile (copy) ]]
	InitButtons()
	OnRebirthChanged(v1.RebirthLevel)
	OnRequiredChanged()
	t.RequirementChanged:Connect(OnRequiredChanged)
	v2.LevelChanged:Connect(OnRequiredChanged)
	Rebirth:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 145 | Upvalues: Rebirth (ref), ClientProfile (ref) ]]
		if Rebirth.Visible then
			OnRequiredChanged()
			if ClientProfile.Device ~= ClientProfile.DeviceTypes.Console then
				return
			end
			HandleGamepad()
		end
	end)
	v1.RebirthChanged:Connect(OnRebirthChanged)
end
return t