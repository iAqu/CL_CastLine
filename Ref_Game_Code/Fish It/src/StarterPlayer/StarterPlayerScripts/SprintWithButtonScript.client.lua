-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
game:GetService("ContextActionService")
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = v1:WaitForChild("Humanoid")
local Net = require(ReplicatedStorage.Packages.Net)
local CharacterWalkSpeed = StarterPlayer.CharacterWalkSpeed
local v2 = Net:RemoteEvent("ChangeSprintState")
local v3 = false
local MobileUI = Players.LocalPlayer.PlayerGui:WaitForChild("MobileUI")
local MobileSprint = MobileUI:WaitForChild("MobileSprint")
local LeftShift = Enum.KeyCode.LeftShift
local DPadDown = Enum.KeyCode.DPadDown
local t = { "Settings", "Mobile Auto Run" }
local function onCharacterAdded(p1) --[[ onCharacterAdded | Line: 40 | Upvalues: Humanoid (ref), v1 (ref) ]]
	Humanoid = p1:WaitForChild("Humanoid")
	v1 = p1
end
local function handleAction(p1, p2) --[[ handleAction | Line: 50 | Upvalues: LocalPlayer (copy), Humanoid (ref), v2 (copy) ]]
	if LocalPlayer:GetAttribute("Underwater") then
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
	v2:FireServer(p2 == Enum.UserInputState.Begin)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
local function updateSprinting() --[[ updateSprinting | Line: 79 | Upvalues: v3 (ref), handleAction (copy) ]]
	v3 = not v3
	handleAction("SprintAction", v3 and Enum.UserInputState.End or Enum.UserInputState.Begin)
end
game:GetService("UserInputService").InputBegan:Connect(function(p1, p2) --[[ Line: 86 | Upvalues: LeftShift (copy), DPadDown (copy), v3 (ref), handleAction (copy) ]]
	if p1.KeyCode ~= LeftShift and p1.KeyCode ~= DPadDown then
		return
	end
	v3 = not v3
	handleAction("SprintAction", v3 and Enum.UserInputState.End or Enum.UserInputState.Begin)
end)
local Replion = require(ReplicatedStorage.Packages.Replion)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local function IsDeviceMobile() --[[ IsDeviceMobile | Line: 100 | Upvalues: UserInputService (copy), CurrentCamera (copy) ]]
	return (UserInputService.TouchEnabled or (CurrentCamera.ViewportSize.Y <= 500 or UserInputService:GetLastInputType() == Enum.UserInputType.Touch)) and true or false
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 109 | Upvalues: LocalPlayer (copy), UserInputService (copy), CurrentCamera (copy), t (copy), handleAction (copy), TextNotificationController (copy), MobileUI (copy), MobileSprint (copy), v3 (ref), Humanoid (ref) ]]
	if LocalPlayer:GetAttribute("Loading") then
		LocalPlayer:GetAttributeChangedSignal("Loading"):Wait()
	end
	local function refreshMobileSprinting() --[[ refreshMobileSprinting | Line: 116 | Upvalues: UserInputService (ref), CurrentCamera (ref), p1 (copy), t (ref), handleAction (ref) ]]
		local v1 = (UserInputService.TouchEnabled or (CurrentCamera.ViewportSize.Y <= 500 or UserInputService:GetLastInputType() == Enum.UserInputType.Touch)) and true or false
		if not (v1 and p1:GetExpect(t)) then
			return
		end
		handleAction("SprintAction", Enum.UserInputState.Begin)
	end
	local v1 = p1:OnChange(t, function(p1) --[[ Line: 124 | Upvalues: UserInputService (ref), CurrentCamera (ref), TextNotificationController (ref), handleAction (ref) ]]
		if not UserInputService.TouchEnabled and (not (CurrentCamera.ViewportSize.Y <= 500) and UserInputService:GetLastInputType() ~= Enum.UserInputType.Touch) then
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
	task.spawn(function() --[[ Line: 144 | Upvalues: UserInputService (ref), CurrentCamera (ref), MobileUI (ref) ]]
		while true do
			MobileUI.Enabled = (UserInputService.TouchEnabled or (CurrentCamera.ViewportSize.Y <= 500 or UserInputService:GetLastInputType() == Enum.UserInputType.Touch)) and true or false
			task.wait(2)
		end
	end)
	MobileSprint.Activated:Connect(function() --[[ Line: 159 | Upvalues: v3 (ref), handleAction (ref) ]]
		v3 = not v3
		handleAction("SprintAction", v3 and Enum.UserInputState.End or Enum.UserInputState.Begin)
	end)
	local v2 = LocalPlayer:GetAttributeChangedSignal("Underwater"):Connect(function() --[[ Line: 164 | Upvalues: LocalPlayer (ref), handleAction (ref), UserInputService (ref), CurrentCamera (ref), p1 (copy), t (ref) ]]
		if LocalPlayer:GetAttribute("Underwater") then
			handleAction("SprintAction", Enum.UserInputState.End)
			return
		end
		local v1 = (UserInputService.TouchEnabled or (CurrentCamera.ViewportSize.Y <= 500 or UserInputService:GetLastInputType() == Enum.UserInputType.Touch)) and true or false
		if not (v1 and p1:GetExpect(t)) then
			return
		end
		handleAction("SprintAction", Enum.UserInputState.Begin)
	end)
	local v32 = if UserInputService.TouchEnabled or (CurrentCamera.ViewportSize.Y <= 500 or UserInputService:GetLastInputType() == Enum.UserInputType.Touch) then true else false
	if v32 and p1:GetExpect(t) then
		handleAction("SprintAction", Enum.UserInputState.Begin)
	end
	Humanoid.Died:Once(function() --[[ Line: 177 | Upvalues: v1 (copy), v2 (copy) ]]
		v1:Disconnect()
		v2:Disconnect()
	end)
end)