-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:45
-- Luau version 6, Types version 3
-- Time taken: 0.004495 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local TipsFrame_upvr = LocalPlayer:WaitForChild("PlayerGui", math.huge):WaitForChild("TipsGui", math.huge).TipsFrame
local _____________upvr = ReplicatedStorage.UI["文本提示"]
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
local PlaySoundModule_upvr = require(ReplicatedStorage.Tool.PlaySoundModule)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local ___________________upvr = ReplicatedStorage.UI["双行文本提示"]
local function _(arg1, arg2, arg3) -- Line 31, Named "showTip_double"
	--[[ Upvalues[3]:
		[1]: ___________________upvr (readonly)
		[2]: TipsFrame_upvr (readonly)
		[3]: UIanima_upvr (readonly)
	]]
	if not arg3 then
	end
	local clone_upvr = ___________________upvr:Clone()
	clone_upvr.Line1.Text = arg1
	clone_upvr.Line2.Text = arg2
	clone_upvr.Parent = TipsFrame_upvr
	delay(3, function() -- Line 42
		--[[ Upvalues[2]:
			[1]: UIanima_upvr (copied, readonly)
			[2]: clone_upvr (readonly)
		]]
		UIanima_upvr.TextDispear_Double(clone_upvr)
	end)
end
local _________________________upvr = ReplicatedStorage.UI["双行文本提示黑边"]
local function _(arg1, arg2, arg3) -- Line 48, Named "showTip_doubleBlack"
	--[[ Upvalues[3]:
		[1]: _________________________upvr (readonly)
		[2]: TipsFrame_upvr (readonly)
		[3]: UIanima_upvr (readonly)
	]]
	if not arg3 then
	end
	local clone_2_upvr = _________________________upvr:Clone()
	clone_2_upvr.Line1.Text = arg1
	clone_2_upvr.Line2.Text = arg2
	clone_2_upvr.Parent = TipsFrame_upvr
	delay(3, function() -- Line 59
		--[[ Upvalues[2]:
			[1]: UIanima_upvr (copied, readonly)
			[2]: clone_2_upvr (readonly)
		]]
		UIanima_upvr.TextDispear_Double(clone_2_upvr)
	end)
end
local function showTips_upvr(arg1, arg2, arg3, arg4) -- Line 65, Named "showTips"
	--[[ Upvalues[6]:
		[1]: TipsFrame_upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
		[3]: _____________upvr (readonly)
		[4]: EnumMgr_upvr (readonly)
		[5]: PlaySoundModule_upvr (readonly)
		[6]: UIanima_upvr (readonly)
	]]
	if arg1 == nil or arg1 == "" then
	else
		for _, v_2 in pairs(TipsFrame_upvr:GetChildren()) do
			local TextLabel_2 = v_2:FindFirstChild("TextLabel")
			if TextLabel_2 and TextLabel_2.Text == TranslationHelper_upvr.translateByKey(arg1, arg2) then return end
		end
		local clone = _____________upvr:Clone()
		clone.Parent = TipsFrame_upvr
		TranslationHelper_upvr.SetText(clone.TextLabel, arg1, arg2)
		if not arg3 then
			local Normal_2 = EnumMgr_upvr.TipTp.Normal
		end
		if Normal_2 == EnumMgr_upvr.TipTp.Normal then
			clone.TextLabel.TextColor3 = Color3.new(0.486275, 0.921569, 0.305882)
		elseif Normal_2 == EnumMgr_upvr.TipTp.Warn then
			clone.TextLabel.TextColor3 = Color3.new(1, 1, 0)
		elseif Normal_2 == EnumMgr_upvr.TipTp.Error then
			clone.TextLabel.TextColor3 = Color3.new(1, 0.223529, 0.227451)
			PlaySoundModule_upvr.playSound({
				SoundName = "音效-场景-点击-警告";
			})
		end
		UIanima_upvr.TextPop(clone)
		UIanima_upvr.TextDispear(clone)
	end
end
local function showTips_2key_upvr(arg1, arg2, arg3, arg4, arg5) -- Line 105, Named "showTips_2key"
	--[[ Upvalues[6]:
		[1]: TipsFrame_upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
		[3]: _____________upvr (readonly)
		[4]: EnumMgr_upvr (readonly)
		[5]: PlaySoundModule_upvr (readonly)
		[6]: UIanima_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 37 start (CF ANALYSIS FAILED)
	if arg1 == nil or arg1 == "" then return end
	for _, v in pairs(TipsFrame_upvr:GetChildren()) do
		local TextLabel = v:FindFirstChild("TextLabel")
		if TextLabel and TextLabel.Text == TranslationHelper_upvr.translateByKey(arg1, arg2) then return end
	end
	local clone_3 = _____________upvr:Clone()
	clone_3.Parent = TipsFrame_upvr
	if arg5 and arg5 ~= "" then
	end
	clone_3.TextLabel.Text = TranslationHelper_upvr.translateByKey(arg1, arg2)..TranslationHelper_upvr.translateByKey(arg5)
	if not arg3 then
		local Normal = EnumMgr_upvr.TipTp.Normal
	end
	if Normal == EnumMgr_upvr.TipTp.Normal then
		clone_3.TextLabel.TextColor3 = Color3.new(0.486275, 0.921569, 0.305882)
		-- KONSTANTWARNING: GOTO [126] #89
	end
	-- KONSTANTERROR: [0] 1. Error Block 37 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [83] 60. Error Block 33 start (CF ANALYSIS FAILED)
	if Normal == EnumMgr_upvr.TipTp.Warn then
		clone_3.TextLabel.TextColor3 = Color3.new(1, 1, 0)
	elseif Normal == EnumMgr_upvr.TipTp.Error then
		clone_3.TextLabel.TextColor3 = Color3.new(1, 0.223529, 0.227451)
		PlaySoundModule_upvr.playSound({
			SoundName = "音效-场景-点击-警告";
		})
	end
	-- KONSTANTERROR: [83] 60. Error Block 33 end (CF ANALYSIS FAILED)
end
ReplicatedStorage.LocalMsg.showTips.Event:Connect(function(arg1, arg2, arg3, arg4) -- Line 153
	--[[ Upvalues[1]:
		[1]: showTips_upvr (readonly)
	]]
	showTips_upvr(arg1, arg2, arg3, arg4)
end)
ReplicatedStorage.ServerMsg.showTips.OnClientEvent:Connect(function(arg1, arg2, arg3, arg4) -- Line 157
	--[[ Upvalues[1]:
		[1]: showTips_upvr (readonly)
	]]
	showTips_upvr(arg1, arg2, arg3, arg4)
end)
ReplicatedStorage.LocalMsg.showTips_2key.Event:Connect(function(arg1, arg2, arg3, arg4, arg5) -- Line 161
	--[[ Upvalues[1]:
		[1]: showTips_2key_upvr (readonly)
	]]
	showTips_2key_upvr(arg1, arg3, arg4, arg5, arg2)
end)
ReplicatedStorage.ServerMsg.showTips_2key.OnClientEvent:Connect(function(arg1, arg2, arg3, arg4, arg5) -- Line 165
	--[[ Upvalues[1]:
		[1]: showTips_2key_upvr (readonly)
	]]
	showTips_2key_upvr(arg1, arg3, arg4, arg5, arg2)
end)
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local ItemTipsFrame_upvr = LocalPlayer:WaitForChild("PlayerGui", math.huge):WaitForChild("TipsGui", math.huge).ItemTipsFrame
local const_number_upvw = 1
local Debris_upvr = game:GetService("Debris")
local ItemTips_upvr = ReplicatedStorage.UI.ItemTips
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local function showItemTips_upvr(arg1, arg2) -- Line 173, Named "showItemTips"
	--[[ Upvalues[7]:
		[1]: CfgFind_upvr (readonly)
		[2]: ItemTipsFrame_upvr (readonly)
		[3]: const_number_upvw (read and write)
		[4]: Debris_upvr (readonly)
		[5]: ItemTips_upvr (readonly)
		[6]: MathMgr_upvr (readonly)
		[7]: UIanima_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [121] 86. Error Block 26 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [124.4]
	local var48_upvr
	delay(5, function() -- Line 226
		--[[ Upvalues[2]:
			[1]: UIanima_upvr (copied, readonly)
			[2]: var48_upvr (readonly)
		]]
		UIanima_upvr.ItemTipsDispear(var48_upvr)
	end)
	-- KONSTANTERROR: [121] 86. Error Block 26 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [128] 92. Error Block 27 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [128] 92. Error Block 27 end (CF ANALYSIS FAILED)
end
ReplicatedStorage.LocalMsg.showItemTips.Event:Connect(function(arg1, arg2) -- Line 236
	--[[ Upvalues[1]:
		[1]: showItemTips_upvr (readonly)
	]]
	showItemTips_upvr(arg1, arg2)
end)
ReplicatedStorage.ServerMsg.showItemTips.OnClientEvent:Connect(function(arg1, arg2) -- Line 240
	--[[ Upvalues[1]:
		[1]: showItemTips_upvr (readonly)
	]]
	showItemTips_upvr(arg1, arg2)
end)