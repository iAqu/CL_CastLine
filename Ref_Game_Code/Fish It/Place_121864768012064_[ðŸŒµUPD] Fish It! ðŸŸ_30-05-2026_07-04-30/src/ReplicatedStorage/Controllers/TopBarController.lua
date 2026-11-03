-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Icon = require(ReplicatedStorage.Packages.Icon)
local Observers = require(ReplicatedStorage.Packages.Observers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local MainlineQuestController = require(ReplicatedStorage.Controllers.MainlineQuestController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local Constants = require(ReplicatedStorage.Shared.Constants)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local Device = require(ReplicatedStorage.Modules.Device)
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Events = LocalPlayer.PlayerGui:WaitForChild("Events")
local Server = Events.Frame["Server Luck"].Server
local Friend = Events.Frame["Server Luck"].Friend
local t = {}
function t.PromptInvite(p1) --[[ PromptInvite | Line: 33 | Upvalues: t (copy), LocalPlayer (copy), SocialService (copy) ]]
	if t:_canSendGameInvite(LocalPlayer) then
		local v1 = t:GetInviteId()
		local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")
		ExperienceInviteOptions.InviteMessageId = v1
		ExperienceInviteOptions.PromptMessage = "Fish with your friends!"
		local _, _2 = pcall(function() --[[ Line: 49 | Upvalues: SocialService (ref), LocalPlayer (ref), ExperienceInviteOptions (copy) ]]
			return SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
		end)
	end
end
function t.Start(p1) --[[ Start | Line: 54 | Upvalues: UserPriority (copy), Device (copy), Friend (copy), Server (copy), Observers (copy), CurrentCamera (copy), GuiControl (copy), t (copy), LocalPlayer (copy), UserInputService (copy), Icon (copy), ReplicatedStorage (copy), MainlineQuestController (copy), Replion (copy), Constants (copy), TextNotificationController (copy) ]]
	local v1 = not UserPriority:IsTradePlaza()
	local function resizeMobileFrame() --[[ resizeMobileFrame | Line: 57 | Upvalues: Device (ref), Friend (ref), Server (ref) ]]
		local v1 = Device:IsMobile()
		Friend.UIListLayout.Padding = v1 and UDim.new(0, 4) or UDim.new(0, 6)
		Friend.UIPadding.PaddingLeft = v1 and UDim.new(0, 4) or UDim.new(0, 10)
		Friend.Size = v1 and UDim2.fromOffset(0, 18) or UDim2.fromOffset(0, 32)
		Server.UIListLayout.Padding = v1 and UDim.new(0, 2) or UDim.new(0, 6)
		Server.UIPadding.PaddingRight = v1 and UDim.new(0, 5) or UDim.new(0, 5)
		Server.UIPadding.PaddingLeft = v1 and UDim.new(0, 5) or UDim.new(0, 5)
		Server.Size = v1 and UDim2.fromOffset(0, 20) or UDim2.fromOffset(0, 30)
	end
	Observers.observeTag("InviteFriend", function(p1) --[[ Line: 70 | Upvalues: Device (ref), CurrentCamera (ref), GuiControl (ref), t (ref) ]]
		local function updateButton() --[[ updateButton | Line: 71 | Upvalues: Device (ref), p1 (copy) ]]
			p1.Visible = not Device:IsMobile()
		end
		CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateButton)
		p1.Visible = not Device:IsMobile()
		local v1 = GuiControl:Hook("Hold Button", p1)
		v1.Clicked:Connect(function() --[[ Line: 80 | Upvalues: t (ref) ]]
			t:PromptInvite()
		end)
		return function() --[[ Line: 84 | Upvalues: v1 (copy) ]]
			v1:Destroy()
		end
	end, { LocalPlayer:WaitForChild("PlayerGui") })
	UserInputService.InputChanged:Connect(resizeMobileFrame)
	CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeMobileFrame)
	UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(resizeMobileFrame)
	resizeMobileFrame()
	local v2 = Icon.new():setOrder(0):align("Right"):setImage("rbxassetid://14833962574"):setDropdown({})
	Icon.new():setOrder(1):setLabel("Update Log"):setImage("rbxassetid://80407800753323"):bindEvent("selected", function() --[[ Line: 104 | Upvalues: GuiControl (ref) ]]
		if GuiControl:IsOpen("!!! Update Log") then
			GuiControl:Close()
		else
			GuiControl:Open("!!! Update Log")
		end
	end):oneClick():joinDropdown(v2)
	Icon.new():setOrder(2):setLabel("Invite Friends"):setImage("rbxassetid://117398751659253"):setOrder(1):bindEvent("selected", function() --[[ Line: 119 | Upvalues: t (ref) ]]
		t:PromptInvite()
	end):oneClick():joinDropdown(v2)
	if UserPriority:GetPriorityLevel(LocalPlayer) >= 3 then
		Icon.new():setOrder(3):setLabel("Commands"):setImage("rbxassetid://79369749245020"):bindEvent("selected", function() --[[ Line: 131 | Upvalues: ReplicatedStorage (ref) ]]
			require(ReplicatedStorage:WaitForChild("CmdrClient")):Toggle()
		end):oneClick():joinDropdown(v2)
	end
	if v1 then
		Icon.new():setOrder(1):align("Right"):setLabel("Quests"):setImage("rbxassetid://18751598717"):bindEvent("selected", function() --[[ Line: 145 | Upvalues: MainlineQuestController (ref) ]]
			MainlineQuestController:Toggle()
		end):oneClick()
	else
		v2:setLabel("More")
	end
	if v1 then
		Icon.new():setOrder(4):setLabel("Aquariums"):bindEvent("selected", function() --[[ Line: 157 | Upvalues: Replion (ref), Constants (ref), TextNotificationController (ref), GuiControl (ref) ]]
			local v1 = Replion.Client:GetReplion("Data")
			if not v1 then
				return
			end
			if v1:GetExpect("Level") < Constants.AquariumLevel then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = ("Reach Level %* to unlock this!"):format(Constants.AquariumLevel),
					TextColor = {
						R = 255,
						G = 255,
						B = 0
					}
				})
				return
			end
			if GuiControl:IsOpen("Aquarium") then
				GuiControl:Close()
			else
				GuiControl:Open("Aquarium")
			end
		end):oneClick():joinDropdown(v2)
	end
	Icon.new():setOrder(5):setLabel("Server Browser"):setImage("rbxassetid://78949801402787"):bindEvent("selected", function() --[[ Line: 187 | Upvalues: GuiControl (ref) ]]
		if GuiControl:IsOpen("ServerBrowser") then
			GuiControl:Close()
		else
			GuiControl:Open("ServerBrowser")
		end
	end):oneClick():joinDropdown(v2)
end
function t.GetInviteId(p1) --[[ GetInviteId | Line: 260 | Upvalues: UserPriority (copy) ]]
	if UserPriority:IsValidTestSession() then
		return "f5ab550e-a7b9-0f42-afc4-22a36e62a9e7"
	else
		return "2736a76a-5eb2-f444-a142-5aaa051183ba"
	end
end
function t._canSendGameInvite(p1, p2) --[[ _canSendGameInvite | Line: 268 | Upvalues: SocialService (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 269 | Upvalues: SocialService (ref), p2 (copy) ]]
		return SocialService:CanSendGameInviteAsync(p2)
	end)
	return v1 and v2
end
return t