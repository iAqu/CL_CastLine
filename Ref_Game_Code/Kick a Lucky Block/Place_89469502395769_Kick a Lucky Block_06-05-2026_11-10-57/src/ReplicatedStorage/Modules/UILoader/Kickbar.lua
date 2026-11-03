-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local WeatherService_Client = require(ReplicatedStorage.Modules.ServicesLoader.WeatherService_Client)
local CustomKick = require(ReplicatedStorage.Shared.Data.CustomKick)
local KickController = require(ReplicatedStorage.Modules.ControllerLoader.KickController)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
require(ReplicatedStorage.Shared.Data.WeatherData)
require(ReplicatedStorage.Shared.Packages.FSM)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local KickMinigame = PlayerGui:WaitForChild("KickMinigame")
local StadiumEvent = PlayerGui:WaitForChild("StadiumEvent")
local Gradients = script:WaitForChild("Gradients")
local t = {
	Cosmic = SoundService.Effects.Cosmic,
	Perfect = SoundService.Effects.Perfect,
	Excellent = SoundService.Effects.Excellent,
	Great = SoundService.Effects.Great,
	Good = SoundService.Effects.Good,
	Mid = SoundService.Effects.Mid,
	Bad = SoundService.Effects.Bad
}
local SwooshUp = SoundService.Effects.SwooshUp
local SwooshDown = SoundService.Effects.SwooshDown
local t2 = {}
local v1 = Trove.new()
local function GetActiveGui() --[[ GetActiveGui | Line: 50 | Upvalues: WeatherService_Client (copy), StadiumEvent (copy), KickMinigame (copy) ]]
	if WeatherService_Client.Events.Stadium and WeatherService_Client.Events.Stadium > workspace:GetServerTimeNow() then
		return StadiumEvent
	else
		return KickMinigame
	end
end
local function ApplyGradient(p1, p2) --[[ ApplyGradient | Line: 58 | Upvalues: Gradients (copy) ]]
	local UIGradient = p1:FindFirstChildOfClass("UIGradient")
	if UIGradient then
		UIGradient:Destroy()
	end
	local v1 = Gradients:FindFirstChild(p2)
	if v1 then
		v1:Clone().Parent = p1
	end
end
local t3 = {
	Default = {
		a = Color3.fromRGB(255, 236, 26),
		b = Color3.fromRGB(113, 239, 107)
	},
	Stadium = {
		a = Color3.fromRGB(124, 104, 191),
		b = Color3.fromRGB(199, 29, 255)
	}
}
function t2.Start(p1) --[[ Start | Line: 82 | Upvalues: WeatherService_Client (copy), StadiumEvent (copy), KickMinigame (copy), ClientProfile (copy), TweenService (copy), t3 (copy), v1 (copy), RunService (copy), KickController (copy), SwooshUp (copy) ]]
	if not p1.Started then
		p1.Started = true
		local v12 = if WeatherService_Client.Events.Stadium and WeatherService_Client.Events.Stadium > workspace:GetServerTimeNow() then StadiumEvent else KickMinigame
		local Message = v12.Message
		v12.Enabled = true
		if ClientProfile.Device == "Console" then
			local Charging = v12:FindFirstChild("Charging")
			if Charging then
				Charging.Text = "Press R2 to Kick"
			end
		end
		Message.Text = ""
		local MovingBar = v12.Bar.MovingBar
		MovingBar.AnchorPoint = Vector2.new(0, 1)
		MovingBar.Position = UDim2.fromScale(0, 1)
		local Bar = v12.Bar
		local UIScale = Bar:FindFirstChildOfClass("UIScale")
		if UIScale then
			UIScale:Destroy()
		end
		local UIScale_2 = Instance.new("UIScale")
		UIScale_2.Scale = 0
		UIScale_2.Parent = Bar
		TweenService:Create(UIScale_2, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = 1
		}):Play()
		local v2 = WeatherService_Client.Events.Stadium and t3.Stadium or t3.Default
		v1:Connect(RunService.PreRender, function() --[[ Line: 117 | Upvalues: KickController (ref), MovingBar (copy), v2 (copy), SwooshUp (ref) ]]
			local Scale = KickController.Scale
			MovingBar.Size = UDim2.fromScale(1, Scale)
			MovingBar.BackgroundColor3 = v2.a:Lerp(v2.b, Scale)
			if Scale >= 1 then
				SwooshUp:Play()
			end
		end)
	end
end
function t2.End(p1, p2) --[[ End | Line: 130 | Upvalues: KickController (copy), v1 (copy), WeatherService_Client (copy), StadiumEvent (copy), KickMinigame (copy), CustomKick (copy), Gradients (copy), t (copy), TweenService (copy) ]]
	if p1.Started then
		p1.Started = false
		v1:Clean()
		local v2 = if WeatherService_Client.Events.Stadium and WeatherService_Client.Events.Stadium > workspace:GetServerTimeNow() then StadiumEvent else KickMinigame
		local Message = v2.Message
		local v4 = CustomKick:GetKickFromScale(p2 or KickController.Scale)
		Message.Text = v4
		local UIGradient = Message:FindFirstChildOfClass("UIGradient")
		if UIGradient then
			UIGradient:Destroy()
		end
		local v5 = Gradients:FindFirstChild(v4)
		if v5 then
			v5:Clone().Parent = Message
		end
		local v6 = t[v4]
		if v6 then
			v6:Play()
		end
		local UIScale = Message:FindFirstChildOfClass("UIScale")
		if UIScale then
			UIScale:Destroy()
		end
		local UIScale_2 = Instance.new("UIScale", Message)
		UIScale_2.Scale = 0
		TweenService:Create(UIScale_2, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = 1
		}):Play()
		task.delay(1, function() --[[ Line: 158 | Upvalues: UIScale_2 (copy), v2 (copy), TweenService (ref), Message (copy) ]]
			if UIScale_2.Parent then
				local UIScale = v2.Bar:FindFirstChildOfClass("UIScale")
				if UIScale then
					local v1 = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
						Scale = 0
					})
					v1:Play()
					v1.Completed:Connect(function() --[[ Line: 167 | Upvalues: UIScale (copy) ]]
						if UIScale.Parent then
							UIScale:Destroy()
						end
					end)
				end
				local v22 = TweenService:Create(UIScale_2, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
					Scale = 0
				})
				v22:Play()
				v22.Completed:Wait()
				UIScale_2:Destroy()
				local UIGradient = Message:FindFirstChildOfClass("UIGradient")
				if UIGradient then
					UIGradient:Destroy()
				end
				v2.Enabled = false
			end
		end)
	end
end
return t2