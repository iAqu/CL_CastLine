-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Shared.Effects)
local XPUtility = require(ReplicatedStorage.Shared.XPUtility)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local XP = PlayerGui:WaitForChild("XP")
local Border = PlayerGui:WaitForChild("Border")
Border.CanvasGroup.GroupTransparency = 1
Border.Enabled = true
local Frame = XP.Frame
local Bar = Frame.Bar
local v2 = Trove.new()
local v3 = -1
local t = {
	Start = function(p1) --[[ Start | Line: 43 | Upvalues: v1 (ref), Client (copy), Soundbook (copy), UserInputService (copy) ]]
		v1 = Client:WaitReplion("Data")
		v1:OnChange("Level", OnLevelChanged)
		v1:OnChange("XP", OnXPChanged)
		OnLevelChanged(true)
		OnXPChanged(true)
		v1:OnArrayInsert("Passes", function() --[[ Line: 53 | Upvalues: Soundbook (ref) ]]
			Soundbook.Sounds.GamePassPurchase:Play()
		end)
		v1:OnArrayInsert("Passes", DoubleXPChanged)
		v1:OnArrayRemove("Passes", DoubleXPChanged)
		DoubleXPChanged()
		task.spawn(function() --[[ Line: 63 | Upvalues: UserInputService (ref) ]]
			UserInputService.InputChanged:Connect(InputChanged)
			workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(InputChanged)
			InputChanged()
		end)
	end
}
function InputChanged() --[[ InputChanged | Line: 71 ]] end
function OnXPChanged(p1) --[[ OnXPChanged | Line: 107 | Upvalues: v1 (ref), XPUtility (copy), spr (copy), Bar (copy) ]]
	local v12 = v1:GetExpect("Level")
	local v2 = v1:GetExpect("XP")
	local v3 = if v2 == 0 then 0 else math.clamp(v2 / XPUtility.GetNextLevelXP(v12), 0, 1)
	if p1 == true then
		spr.stop(Bar)
		Bar.Size = UDim2.fromScale(v3, 1)
		return
	end
	spr.stop(Bar)
	spr.target(Bar, 30, 80, {
		Size = UDim2.fromScale(v3, 1)
	})
	if not (v2 >= 1) then
		return
	end
	local v6 = Bar.Point:Clone()
	v6.Parent = Bar
	v6.BackgroundTransparency = 0.15
	spr.target(v6, 1, 2, {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 20, 1.5, 12)
	})
	task.delay(1, function() --[[ Line: 140 | Upvalues: spr (ref), v6 (copy) ]]
		spr.stop(v6)
		v6:Destroy()
	end)
end
function OnLevelChanged(p1) --[[ OnLevelChanged | Line: 148 | Upvalues: v1 (ref), v3 (ref), XP (copy), v2 (copy), Border (copy), Soundbook (copy), TweenService (copy), Frame (copy) ]]
	local v12 = v1:GetExpect("Level")
	v3 = v12
	if p1 == true then
		XP.Frame.LevelCount.Text = ("Lvl %*"):format(v12)
	else
		v2:Clean()
		Border.CanvasGroup.Size = UDim2.fromScale(1, 1)
		Border.CanvasGroup.UIGradient.Rotation = 0
		Border.CanvasGroup.GroupTransparency = 1
		Border.Enabled = true
		Soundbook.Sounds.LevelUp:Play()
		local v22 = TweenService:Create(Border.CanvasGroup, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
			GroupTransparency = 0
		})
		local v32 = TweenService:Create(Border.CanvasGroup.UIGradient, TweenInfo.new(10, Enum.EasingStyle.Linear), {
			Rotation = 1080
		})
		local v4 = TweenService:Create(Frame.LevelCount.UIScale, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
			Scale = 2
		})
		local v5 = TweenService:Create(Frame.LevelCount.UIScale, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
			Scale = 1
		})
		local v6 = TweenService:Create(Border.CanvasGroup, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
			GroupTransparency = 1,
			Size = UDim2.new(1, 120, 1, 120)
		})
		v2:Add(function() --[[ Line: 189 | Upvalues: v22 (copy), v32 (copy), v4 (copy), v5 (copy), v6 (copy) ]]
			v22:Destroy()
			v32:Destroy()
			v4:Destroy()
			v5:Destroy()
			v6:Destroy()
		end)
		v4:Play()
		v4.Completed:Once(function() --[[ Line: 201 | Upvalues: Frame (ref), v12 (copy), v5 (copy) ]]
			Frame.LevelCount.Text = ("Lvl %*"):format(v12)
			v5:Play()
		end)
		v22:Play()
		v32:Play()
		OnXPChanged(false)
		task.wait(3)
		v6:Play()
		v6.Completed:Wait()
		task.wait(2)
	end
end
function DoubleXPChanged() --[[ DoubleXPChanged | Line: 217 | Upvalues: GamePassUtility (copy), Frame (copy), LocalPlayer (copy) ]]
	local v1 = GamePassUtility:GetGamePassIdFromName("Double XP")
	if v1 then
		Frame.DoubleXP.Visible = GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, v1)
	else
		Frame.DoubleXP.Visible = false
	end
end
return t