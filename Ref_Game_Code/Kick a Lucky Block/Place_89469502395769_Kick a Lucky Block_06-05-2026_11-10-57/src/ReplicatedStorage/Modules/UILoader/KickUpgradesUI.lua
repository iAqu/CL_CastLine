-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
require(ReplicatedStorage.Shared.Packages.Signal)
local KickUpgradePitch = require(ReplicatedStorage.Modules.ServicesLoader.VFXService.KickUpgradePitch)
local UI_Labels = require(ReplicatedStorage.Modules.UILoader.UI_Labels)
local RebirthServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.RebirthServiceClient)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local WeightsData = require(ReplicatedStorage.Shared.Data.WeightsData)
local Attributes = require(ReplicatedStorage.Shared.Data.Attributes)
local KickServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.KickServiceClient)
local WeightServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.WeightServiceClient)
local TimedUpgradesServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.TimedUpgradesServiceClient)
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local KickUpgrade = SoundService.Effects.KickUpgrade
local KickEarn = SoundService.Effects.KickEarn
local FormatValue = require(ReplicatedStorage.Functional.FormatValue)
local v1 = PlayerGui:FindFirstChild("KickUpgrades") or PlayerGui:WaitForChild("KickUpgrades")
local v2 = PlayerGui:FindFirstChild("HUD") or PlayerGui:WaitForChild("HUD")
local Pop = v1.Pop
local PopBonus_2 = v1.PopBonus
local Bonus = v1.Bonus
local KickLevel = v2.BottomLeft.KickLevel
local v3 = Trove.new()
local Level = KickServiceClient.Level
local v4 = Level
local v5 = false
local t = {
	[2] = {
		ImageID = "rbxassetid://138499790425912",
		Label = "x2"
	},
	[5] = {
		ImageID = "rbxassetid://72013015411562",
		Label = "x5"
	},
	[10] = {
		ImageID = "rbxassetid://107620781069184",
		Label = "x10"
	}
}
local v6 = nil
local t2 = {}
function OnLevelUpdate() --[[ OnLevelUpdate | Line: 80 | Upvalues: Level (ref), KickServiceClient (copy), v5 (ref), v4 (ref) ]]
	Level = KickServiceClient.Level
	if not v5 then
		v4 = Level
		DisplayRealLevel()
	end
end
function SpawnKickFrame(p1, p2, p3) --[[ SpawnKickFrame | Line: 89 | Upvalues: PopBonus_2 (copy), Pop (copy), KickUpgradePitch (copy), KickUpgrade (copy), FormatValue (copy), TweenService (copy), v1 (copy) ]]
	local v2 = (p2 and PopBonus_2 or Pop):Clone()
	KickUpgradePitch.Apply()
	KickUpgrade:Play()
	local TextLabel = v2.TextLabel
	local v4, v5, v6, v7, v8
	if p2 then
		local v3
		local v9 = ("+%* Bonus Kick"):format((FormatValue(p1, true)))
		if v9 then
			v3 = v9
		else
			v4 = ("+%* Kick"):format((FormatValue(p1, true)))
			v3 = v4
		end
		TextLabel.Text = v3
		v5 = Instance.new("UIScale", v2)
		v2.AnchorPoint = Vector2.new(0.5, 0.5)
		v2.Visible = true
		v5.Scale = 0
		if p3 then
			v2.Position = p3
		else
			v6 = (math.random() * 2 - 1) * 0.3
			v7 = (math.random() * 2 - 1) * 0.3
			v2.Position = UDim2.fromScale(0.5 + v6, 0.5 + v7)
		end
		v2.Rotation = math.random(-25, 25)
		v8 = TweenService:Create(v5, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = 1.1
		})
		v8:Play()
		v2.Parent = v1
		return v2, v5, v8.Completed
	end
	v4 = ("+%* Kick"):format((FormatValue(p1, true)))
	TextLabel.Text = v4
	v5 = Instance.new("UIScale", v2)
	v2.AnchorPoint = Vector2.new(0.5, 0.5)
	v2.Visible = true
	v5.Scale = 0
	if p3 then
		v2.Position = p3
	else
		v6 = (math.random() * 2 - 1) * 0.3
		v7 = (math.random() * 2 - 1) * 0.3
		v2.Position = UDim2.fromScale(0.5 + v6, 0.5 + v7)
	end
	v2.Rotation = math.random(-25, 25)
	v8 = TweenService:Create(v5, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1.1
	})
	v8:Play()
	v2.Parent = v1
	return v2, v5, v8.Completed
end
function FlyFrame(p1, p2) --[[ FlyFrame | Line: 122 | Upvalues: Pop (copy), KickLevel (copy), TweenService (copy) ]]
	local AbsoluteSize = Pop.Parent.AbsoluteSize
	local AbsolutePosition = Pop.Parent.AbsolutePosition
	local v1 = KickLevel.AbsolutePosition + KickLevel.AbsoluteSize * 0.5
	local v4 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v5 = TweenService:Create(p1, v4, {
		Rotation = 0,
		Position = UDim2.fromScale((v1.X - AbsolutePosition.X) / AbsoluteSize.X, (v1.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
	})
	local v6 = TweenService:Create(p2, v4, {
		Scale = 0.35
	})
	v5:Play()
	v6:Play()
	return v5.Completed
end
function IncrementLevel(p1) --[[ IncrementLevel | Line: 141 | Upvalues: v4 (ref) ]]
	v4 = v4 + (p1 or 1)
end
function DisplayLevel(p1) --[[ DisplayLevel | Line: 146 | Upvalues: KickLevel (copy), FormatValue (copy) ]]
	KickLevel.TextLabel.Text = ("%* Kick Power"):format((FormatValue(p1, true)))
end
function DisplayRealLevel() --[[ DisplayRealLevel | Line: 150 | Upvalues: KickLevel (copy), FormatValue (copy), Level (ref) ]]
	KickLevel.TextLabel.Text = ("%* Kick Power"):format((FormatValue(Level, true)))
end
function SpawnBonusButton(p1) --[[ SpawnBonusButton | Line: 154 | Upvalues: t (copy), v3 (copy), Bonus (copy), ClientProfile (copy), TweenService (copy), LocalPlayer (copy), Network (copy), VFXService (copy), SoundService (copy), UserInputService (copy) ]]
	if typeof(p1) == "number" and t[p1] then
		local v1 = v3:Clone(Bonus)
		v1.Image = t[p1].ImageID
		v1.Position = UDim2.fromScale(math.random() * 0.6 + 0.2, math.random() * 0.6 + 0.2)
		v1.Visible = true
		v1.Rotation = -20
		v1:WaitForChild("TextLabel").Text = t[p1].Label
		v1.Parent = Bonus.Parent
		if ClientProfile.Device == "Console" then
			v1.GamepadKey.Visible = true
		end
		local UIScale = Instance.new("UIScale")
		UIScale.Scale = 0
		UIScale.Parent = v1
		local v2 = TweenService:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Scale = 1
		})
		local v32 = TweenService:Create(v1, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Rotation = 5
		})
		v2:Play()
		v2.Completed:Once(function() --[[ Line: 183 | Upvalues: v1 (copy), v32 (copy) ]]
			v1:AddTag("Button")
			v32:Play()
		end)
		local Character = LocalPlayer.Character
		v3:Add(v1.Activated:Connect(function() --[[ Line: 190 | Upvalues: Network (ref), v1 (copy), p1 (copy), VFXService (ref), Character (copy), SoundService (ref) ]]
			Network.FireServer("TaviMishkal")
			v1:Destroy()
			local AbsolutePosition = v1.AbsolutePosition
			task.spawn(function() --[[ Line: 194 | Upvalues: AbsolutePosition (copy), p1 (ref) ]]
				PopBonus(UDim2.fromOffset(AbsolutePosition.X, AbsolutePosition.Y), p1)
			end)
			VFXService.PlayVFX("BonusVFX", Character)
			SoundService.Effects.RewardSound:Play()
		end))
		v3:Add(UserInputService.InputBegan:Connect(function(p12, p2) --[[ Line: 201 | Upvalues: v1 (copy), Network (ref), p1 (copy), VFXService (ref), Character (copy), SoundService (ref) ]]
			if not p2 and (v1.Parent and p12.KeyCode == Enum.KeyCode.ButtonB) then
				Network.FireServer("TaviMishkal")
				local AbsolutePosition = v1.AbsolutePosition
				v1:Destroy()
				task.spawn(function() --[[ Line: 212 | Upvalues: AbsolutePosition (copy), p1 (ref) ]]
					PopBonus(UDim2.fromOffset(AbsolutePosition.X, AbsolutePosition.Y), p1)
				end)
				VFXService.PlayVFX("BonusVFX", Character)
				SoundService.Effects.RewardSound:Play()
			end
		end))
	end
end
function InitializeValues() --[[ InitializeValues | Line: 221 | Upvalues: Pop (copy), Bonus (copy), v4 (ref), Level (ref) ]]
	Pop.Visible = false
	Bonus.Visible = false
	OnLevelUpdate()
	v4 = Level
end
function InitializeConnections() --[[ InitializeConnections | Line: 228 | Upvalues: KickServiceClient (copy), RebirthServiceClient (copy), Level (ref), v4 (ref), Network (copy) ]]
	KickServiceClient.LevelChanged:Connect(OnLevelUpdate)
	RebirthServiceClient.RebirthChanged:Connect(function(p1) --[[ Line: 230 | Upvalues: Level (ref), v4 (ref) ]]
		if not p1 then
			Level = 0
			v4 = 0
			DisplayLevel(0)
		end
	end)
	Network.OnClientEvent("TaviMishkal"):Connect(SpawnBonusButton)
end
function PopBonus(p1, p2) --[[ PopBonus | Line: 241 | Upvalues: WeightServiceClient (copy), WeightsData (copy), LocalPlayer (copy), Attributes (copy), v4 (ref), v6 (ref), v5 (ref), Level (ref), UI_Labels (copy), KickLevel (copy), KickEarn (copy) ]]
	local v1 = WeightsData.Weights[WeightServiceClient.Equipped]
	local v3 = (v1 and v1.PPS or 1) * p2 and v3 * 2
	local v42 = v3 * GetMultiplier()
	IncrementLevel(v42)
	local v52 = v4
	if v6 and coroutine.status(v6) ~= "running" then
		task.cancel(v6)
	end
	v5 = true
	v6 = task.delay(2, function() --[[ Line: 264 | Upvalues: v5 (ref), v4 (ref), Level (ref) ]]
		v5 = false
		DisplayRealLevel()
		v4 = Level
	end)
	local v62, v7, v8 = SpawnKickFrame(v42, true, p1)
	v8:Wait()
	FlyFrame(v62, v7):Wait()
	DisplayLevel(v52)
	UI_Labels.Punch(KickLevel)
	KickEarn:Play()
	v62:Destroy()
end
function PopLabel() --[[ PopLabel | Line: 287 | Upvalues: WeightServiceClient (copy), WeightsData (copy), LocalPlayer (copy), Attributes (copy), v4 (ref), v6 (ref), v5 (ref), Level (ref), UI_Labels (copy), KickLevel (copy), KickEarn (copy) ]]
	local v1 = WeightsData.Weights[WeightServiceClient.Equipped]
	local v2 = if v1 then v1.PPS or 1 else 1
	if LocalPlayer:GetAttribute(Attributes.x2K) then
		v2 = v2 * 2
	end
	local v3 = v2 * GetMultiplier()
	IncrementLevel(v3)
	local v42 = v4
	if v6 and coroutine.status(v6) ~= "running" then
		task.cancel(v6)
	end
	v5 = true
	v6 = task.delay(2, function() --[[ Line: 310 | Upvalues: v5 (ref), v4 (ref), Level (ref) ]]
		v5 = false
		DisplayRealLevel()
		v4 = Level
	end)
	local v52, v62, v7 = SpawnKickFrame(v3)
	v7:Wait()
	FlyFrame(v52, v62):Wait()
	DisplayLevel(v42)
	UI_Labels.Punch(KickLevel)
	KickEarn:Play()
	v52:Destroy()
end
function GetMultiplier() --[[ GetMultiplier | Line: 333 | Upvalues: WeightServiceClient (copy), TimedUpgradesServiceClient (copy) ]]
	return 1 * (WeightServiceClient.Multipliers.Weight or 1) * TimedUpgradesServiceClient:GetMultiplierForType("weight_power")
end
function t2.Unequipped(p1) --[[ Unequipped | Line: 344 | Upvalues: v3 (copy) ]]
	v3:Clean()
end
function t2.Pop(p1, ...) --[[ Pop | Line: 348 ]]
	task.spawn(PopLabel, ...)
end
function t2._init(p1) --[[ _init | Line: 354 ]]
	InitializeValues()
	InitializeConnections()
end
return t2