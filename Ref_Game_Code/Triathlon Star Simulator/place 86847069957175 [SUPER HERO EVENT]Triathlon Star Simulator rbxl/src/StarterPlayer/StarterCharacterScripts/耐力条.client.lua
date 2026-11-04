-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:31:24
-- Luau version 6, Types version 3
-- Time taken: 0.002339 seconds

local Parent = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local clone_upvr = ReplicatedStorage.ModelRes["耐力条"]:Clone()
clone_upvr.Adornee = Parent:WaitForChild("HumanoidRootPart", math.huge)
clone_upvr.Parent = Parent
local LocalPlayer_upvr = game.Players.LocalPlayer
clone_upvr.DistanceLowerLimit = 100
local Frame = clone_upvr.Frame
local _______________ = Frame["圆形进度条"]
local Progress_upvr = _______________.Progress
local UIScale_upvr = Frame["耐力"].UIScale
require(ReplicatedStorage.Tool.TranslationHelper).SetText(Frame["耐力"]["耐力"], "耐力")
local CurStamina_upvr = LocalPlayer_upvr:WaitForChild("CurStamina", math.huge)
local Value_2_upvr = game.ReplicatedStorage["游戏全局配置"]["耐力相关"]["上限"].Value
local function _() -- Line 51, Named "refresh"
	--[[ Upvalues[3]:
		[1]: CurStamina_upvr (readonly)
		[2]: Value_2_upvr (readonly)
		[3]: Progress_upvr (readonly)
	]]
	Progress_upvr.Value = math.clamp(CurStamina_upvr.Value / Value_2_upvr, 0.05, 1)
end
local var14_upvw = 0
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local SoundModule_upvr = require(ReplicatedStorage.Tool.SoundModule)
local any_Create_result1_upvr = game:GetService("TweenService"):Create(UIScale_upvr, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
	Scale = 1.5;
})
AddListen.NumValueAdd(CurStamina_upvr, function() -- Line 61
	--[[ Upvalues[10]:
		[1]: CurStamina_upvr (readonly)
		[2]: Value_2_upvr (readonly)
		[3]: Progress_upvr (readonly)
		[4]: var14_upvw (read and write)
		[5]: TipsModule_upvr (readonly)
		[6]: LocalPlayer_upvr (readonly)
		[7]: SoundModule_upvr (readonly)
		[8]: UIScale_upvr (readonly)
		[9]: any_Create_result1_upvr (readonly)
		[10]: clone_upvr (readonly)
	]]
	Progress_upvr.Value = math.clamp(CurStamina_upvr.Value / Value_2_upvr, 0.05, 1)
	if CurStamina_upvr.Value <= 50 and 2 < os.time() - var14_upvw then
		var14_upvw = os.time()
		TipsModule_upvr.ErrorTips(LocalPlayer_upvr, "没有足够耐力了")
		SoundModule_upvr:PlaySoundLocal({
			SoundName = "音效-运动-耐力耗尽";
		})
	end
	if CurStamina_upvr.Value <= 0 then
		UIScale_upvr.Scale = 1
		any_Create_result1_upvr:Play()
	else
		any_Create_result1_upvr:Cancel()
		UIScale_upvr.Scale = 1
	end
	if CurStamina_upvr.Value < Value_2_upvr then
		clone_upvr.Enabled = true
	else
		clone_upvr.Enabled = false
	end
end)
local UIGradient_upvr_2 = _______________.Bar1.Frame.UIGradient
local UIGradient_upvr = _______________.Bar2.Frame.UIGradient
AddListen.NumValueAdd(Progress_upvr, function(arg1) -- Line 95
	--[[ Upvalues[3]:
		[1]: Progress_upvr (readonly)
		[2]: UIGradient_upvr_2 (readonly)
		[3]: UIGradient_upvr (readonly)
	]]
	local Value = Progress_upvr.Value
	local var23 = 360 * Value
	if var23 <= 0 then
		UIGradient_upvr_2.Parent.Parent.Visible = false
		UIGradient_upvr.Parent.Parent.Visible = false
	elseif var23 <= 180 then
		UIGradient_upvr_2.Parent.Parent.Visible = true
		UIGradient_upvr.Parent.Parent.Visible = false
		UIGradient_upvr_2.Rotation = 180 - var23
	else
		UIGradient_upvr_2.Parent.Parent.Visible = true
		UIGradient_upvr.Parent.Parent.Visible = true
		UIGradient_upvr_2.Rotation = 0
		UIGradient_upvr.Rotation = 360 - var23
	end
	if Value < 0.2 then
		local tbl_3 = {ColorSequenceKeypoint.new(0, Color3.fromHex("#ff0000")), ColorSequenceKeypoint.new(1, Color3.fromHex("#ff0000"))}
		UIGradient_upvr_2.Color = ColorSequence.new(tbl_3)
		UIGradient_upvr.Color = ColorSequence.new(tbl_3)
	else
		if Value < 0.5 then
			local tbl_2 = {ColorSequenceKeypoint.new(0, Color3.fromHex("#fff700")), ColorSequenceKeypoint.new(1, Color3.fromHex("#fff700"))}
			UIGradient_upvr_2.Color = ColorSequence.new(tbl_2)
			UIGradient_upvr.Color = ColorSequence.new(tbl_2)
			return
		end
		local tbl = {ColorSequenceKeypoint.new(0, Color3.fromHex("#1eff01")), ColorSequenceKeypoint.new(1, Color3.fromHex("#1eff01"))}
		UIGradient_upvr_2.Color = ColorSequence.new(tbl)
		UIGradient_upvr.Color = ColorSequence.new(tbl)
	end
end)