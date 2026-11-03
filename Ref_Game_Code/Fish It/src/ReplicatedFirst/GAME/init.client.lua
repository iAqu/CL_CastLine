-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
task.spawn(function() --[[ Line: 10 | Upvalues: ReplicatedStorage (copy), GuiService (copy) ]]
	local CoreCall = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CoreCall"))
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.Backpack, false)
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, false)
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, false)
	GuiService:SetGameplayPausedNotificationEnabled(false)
end)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = os.clock()
local v2 = 0
local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://113553177457255"
Sound.Volume = 0.3
local Sound_2 = Instance.new("Sound")
Sound.SoundId = "rbxassetid://133533168475345"
Sound.Volume = 0.1
local GooeyParticles = require(script:WaitForChild("GooeyParticles"))
local function GuiParticle(p1) --[[ GuiParticle | Line: 39 | Upvalues: GooeyParticles (copy) ]]
	local v1 = GooeyParticles.CreateEmitter(p1, UDim2.fromScale(0.5, 0.5), {
		Rate = 14,
		Image = "rbxassetid://660373145",
		Speed = 50,
		ZIndex = 1,
		Rotation = NumberRange.new(0, 180),
		Lifetime = NumberRange.new(1.1, 1.6),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 30), NumberSequenceKeypoint.new(1, 60) }),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1) }),
		Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0.490196, 0.811765, 1)), ColorSequenceKeypoint.new(1, Color3.new(0.733333, 0.913725, 1)) }),
		Spread = NumberRange.new(0, 360),
		Acceleration = Vector2.new(0, -50)
	})
	v1:SetEnabled(true)
	return v1
end
local function Run(p1) --[[ Run | Line: 74 | Upvalues: ReplicatedStorage (copy), GuiParticle (copy), RunService (copy), v2 (ref), TweenService (copy), Sound (copy), Sound_2 (copy) ]]
	local v1 = script:WaitForChild("Loading Screen")
	task.spawn(function() --[[ Line: 78 | Upvalues: ReplicatedStorage (ref), v1 (copy) ]]
		if require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UserPriority")):IsTradePlaza() then
			v1.Main.BackgroundColor3 = Color3.fromRGB(108, 184, 119)
			v1.Main.TradeLabel.Visible = true
		else
			v1.Main.BackgroundColor3 = Color3.fromRGB(79, 151, 193)
			v1.Main.TradeLabel.Visible = false
		end
	end)
	local t = {}
	local v22 = nil
	for i = 1, 3 do
		local v4 = v1.Padded.Dots:FindFirstChild((tostring(i)))
		if v4 then
			local UIScale = Instance.new("UIScale")
			UIScale.Parent = v4
			table.insert(t, {
				UIScale = UIScale,
				Frame = v4
			})
		end
	end
	local t2 = {}
	for j = 1, 2 do
		table.insert(t2, (GuiParticle((v1.Main.ParticleLayer:WaitForChild((tostring(j)))))))
	end
	task.defer(function() --[[ Line: 116 | Upvalues: RunService (ref), v2 (ref), t (copy) ]]
		local function oscillateValues(p1) --[[ oscillateValues | Line: 121 ]]
			return { math.sin(p1 + 0) * 0.35 + 0.85, math.sin(p1 + 1.0471975511965976) * 0.35 + 0.85, math.sin(p1 + math.rad(120)) * 0.35 + 0.85 }
		end
		RunService:BindToRenderStep("LoadingDots", Enum.RenderPriority.Camera.Value, function(p1) --[[ Line: 135 | Upvalues: v2 (ref), oscillateValues (copy), t (ref) ]]
			v2 = math.min(v2 + p1 / 10, 1)
			local v22 = oscillateValues(os.clock() * 8)
			local v3 = #v22
			for i = 1, v3 do
				t[v3 - (i - 1)].UIScale.Scale = v22[i]
			end
		end)
	end)
	task.defer(function() --[[ Line: 155 | Upvalues: v1 (copy), v22 (ref), TweenService (ref), p1 (copy) ]]
		v1.Main.Underlay.Below.Position = UDim2.new(0, 0, 1, -6)
		v22 = TweenService:Create(v1.Main.Underlay.Below, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
			Position = UDim2.new(0, 0, 1, 6)
		})
		v22:Play()
		v1.Parent = p1
	end)
	return function() --[[ Line: 166 | Upvalues: ReplicatedStorage (ref), t2 (copy), RunService (ref), Sound (ref), Sound_2 (ref), t (copy), v1 (copy), v22 (ref) ]]
		local spr = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("spr"))
		for k, v in pairs(t2) do
			task.spawn(function() --[[ Line: 170 | Upvalues: v (copy) ]]
				v:Destroy()
			end)
		end
		task.wait(0.5)
		RunService:UnbindFromRenderStep("LoadingDots")
		Sound:Stop()
		Sound_2:Play()
		for i, v in ipairs(t) do
			spr.target(v.Frame, 1, 3, {
				BackgroundTransparency = 1
			})
		end
		spr.target(v1.Main, 1, 3, {
			BackgroundTransparency = 1
		})
		spr.target(v1.Main.Fish, 1, 3, {
			ImageTransparency = 1
		})
		spr.target(v1.Main.Underlay.BG, 1, 3, {
			ImageTransparency = 1
		})
		spr.target(v1.Main.Underlay.Below, 1, 3, {
			ImageTransparency = 1
		})
		if not v22 then
			spr.completed(v1.Main.Underlay.Below, function() --[[ Line: 206 | Upvalues: v1 (ref) ]]
				v1:Destroy()
			end)
			return
		end
		v22:Destroy()
		spr.completed(v1.Main.Underlay.Below, function() --[[ Line: 206 | Upvalues: v1 (ref) ]]
			v1:Destroy()
		end)
	end
end
GuiService:SetGameplayPausedNotificationEnabled(false)
LocalPlayer:SetAttribute("Loading", true)
local v3 = Run(PlayerGui)
if not game:IsLoaded() then
	game.Loaded:Wait()
	v2 = math.min(v2 + 0.05, 1)
end
if not LocalPlayer.Character then
	LocalPlayer.CharacterAdded:Wait()
	v2 = math.min(v2 + 0.05, 1)
end
local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion")).Client:WaitReplion("Data")
local v5 = Net:RemoteEvent("ActivateExistingLuck")
require(script:WaitForChild("Runner")):Init()
Sound:Play()
local v6 = 4 + math.random() * 2
local v7
if not (os.clock() - v1 < v6) then
	v7 = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CoreCall"))
	v3()
	task.delay(2, function() --[[ Line: 256 | Upvalues: LocalPlayer (copy), v7 (copy), v5 (copy) ]]
		LocalPlayer:SetAttribute("Loading", false)
		v7("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, true)
		v7("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, true)
		v5:FireServer()
	end)
	v7("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, true)
	v7("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, true)
	GuiService:SetGameplayPausedNotificationEnabled(false)
	return
end
task.wait(v6 - (os.clock() - v1))
v7 = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CoreCall"))
v3()
task.delay(2, function() --[[ Line: 256 | Upvalues: LocalPlayer (copy), v7 (copy), v5 (copy) ]]
	LocalPlayer:SetAttribute("Loading", false)
	v7("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, true)
	v7("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, true)
	v5:FireServer()
end)
v7("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, true)
v7("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, true)
GuiService:SetGameplayPausedNotificationEnabled(false)