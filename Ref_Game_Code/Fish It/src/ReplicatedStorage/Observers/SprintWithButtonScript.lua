-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local LeftShift = Enum.KeyCode.LeftShift
local DPadDown = Enum.KeyCode.DPadDown
local t = { "Settings", "Mobile Auto Run" }
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 14 | Upvalues: ReplicatedStorage (copy), Observers (copy), Players (copy), t (copy), UserInputService (copy), LeftShift (copy), DPadDown (copy) ]]
	local Net = require(ReplicatedStorage.Packages.Net)
	local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
	local Device = require(ReplicatedStorage.Modules.Device)
	local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
	local v1 = Net:RemoteEvent("ChangeSprintState")
	local v2 = nil
	Observers.observeSpecificCharacter(Players.LocalPlayer, function(p12) --[[ Line: 26 | Upvalues: Players (ref), v1 (copy), Device (copy), p1 (copy), t (ref), v2 (ref), UserInputService (ref), LeftShift (ref), DPadDown (ref), TextNotificationController (copy) ]]
		local Humanoid = p12:WaitForChild("Humanoid")
		local v12 = false
		local function handleAction(p1, p2) --[[ handleAction | Line: 31 | Upvalues: Players (ref), Humanoid (copy), v1 (ref) ]]
			if Players.LocalPlayer:GetAttribute("Underwater") then
				p2 = false
			end
			if Humanoid:GetAttribute("WalkingSpeedLocked") then
				return
			end
			if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
				return
			end
			if p1 ~= "SprintAction" then
				return
			end
			v1:FireServer(p2 == Enum.UserInputState.Begin)
		end
		local function refreshMobileSprinting() --[[ refreshMobileSprinting | Line: 51 | Upvalues: Device (ref), p1 (ref), t (ref), handleAction (copy) ]]
			if not (Device:IsMobile() and p1:GetExpect(t)) then
				return
			end
			handleAction("SprintAction", Enum.UserInputState.Begin)
		end
		local function updateSprinting() --[[ updateSprinting | Line: 59 | Upvalues: v12 (ref), handleAction (copy) ]]
			v12 = not v12
			handleAction("SprintAction", if v12 then Enum.UserInputState.End else Enum.UserInputState.Begin)
		end
		v2 = function() --[[ Line: 66 | Upvalues: v12 (ref), handleAction (copy) ]]
			v12 = not v12
			handleAction("SprintAction", if v12 then Enum.UserInputState.End else Enum.UserInputState.Begin)
		end
		local v22 = UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 70 | Upvalues: LeftShift (ref), DPadDown (ref), v12 (ref), handleAction (copy) ]]
			if p1.KeyCode ~= LeftShift and p1.KeyCode ~= DPadDown then
				return
			end
			v12 = not v12
			handleAction("SprintAction", if v12 then Enum.UserInputState.End else Enum.UserInputState.Begin)
		end)
		local v3 = Players.LocalPlayer:GetAttributeChangedSignal("Underwater"):Connect(function() --[[ Line: 76 | Upvalues: Players (ref), handleAction (copy), Device (ref), p1 (ref), t (ref) ]]
			if Players.LocalPlayer:GetAttribute("Underwater") then
				handleAction("SprintAction", Enum.UserInputState.End)
				return
			end
			if not (Device:IsMobile() and p1:GetExpect(t)) then
				return
			end
			handleAction("SprintAction", Enum.UserInputState.Begin)
		end)
		local v4 = p1:OnChange(t, function(p1) --[[ Line: 85 | Upvalues: Device (ref), TextNotificationController (ref), handleAction (copy) ]]
			if not Device:IsMobile() then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "This can only be used on mobile!"
				})
				return
			end
			if p1 then
				handleAction("SprintAction", Enum.UserInputState.Begin)
			else
				handleAction("SprintAction", Enum.UserInputState.End)
			end
		end)
		local function initialUpdate() --[[ initialUpdate | Line: 103 | Upvalues: Device (ref), p1 (ref), t (ref), handleAction (copy), Players (ref) ]]
			if Device:IsMobile() and p1:GetExpect(t) then
				handleAction("SprintAction", Enum.UserInputState.Begin)
			end
			local MobileUI = Players.LocalPlayer.PlayerGui:WaitForChild("MobileUI", 10)
			if not MobileUI then
				return
			end
			local v1 = Device:IsMobile()
			MobileUI.Enabled = v1
			MobileUI.MobileSprint.Visible = v1
		end
		local v5 = Device:RegisterDeviceChanged(function(p12) --[[ Line: 114 | Upvalues: Device (ref), p1 (ref), t (ref), handleAction (copy) ]]
			if not (Device:IsMobile() and p1:GetExpect(t)) then
				return
			end
			handleAction("SprintAction", Enum.UserInputState.Begin)
		end)
		local v6 = Device:RegisterDeviceChanged(function() --[[ Line: 117 | Upvalues: Players (ref), Device (ref) ]]
			local MobileUI = Players.LocalPlayer.PlayerGui:WaitForChild("MobileUI", 10)
			if not MobileUI then
				return
			end
			local v1 = Device:IsMobile()
			MobileUI.Enabled = v1
			MobileUI.MobileSprint.Visible = v1
		end)
		task.spawn(initialUpdate)
		return function() --[[ Line: 128 | Upvalues: v2 (ref), v22 (copy), v3 (copy), v4 (copy), Device (ref), v5 (copy), v6 (copy) ]]
			v2 = nil
			v22:Disconnect()
			v3:Disconnect()
			v4:Disconnect()
			Device:Remove(v5)
			Device:Remove(v6)
		end
	end)
	local MobileUI = Players.LocalPlayer.PlayerGui:WaitForChild("MobileUI")
	if not MobileUI then
		return
	end
	GuiControl:Hook("Hold Button", MobileUI.MobileSprint).Clicked:Connect(function() --[[ Line: 147 | Upvalues: v2 (ref) ]]
		if not v2 then
			return
		end
		v2()
	end)
end)
return {}