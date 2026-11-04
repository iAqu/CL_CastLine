-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:02
-- Luau version 6, Types version 3
-- Time taken: 0.002228 seconds

local module_upvr_2 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent
local scroll1_upvr = Parent.scroll.scroll1
local Scroll1_upvr = scroll1_upvr.Scroll1
local var8 = 1
for _, v in pairs(Scroll1_upvr:GetChildren()) do
	if v:IsA("Frame") then
		v.Name = var8
		v.LayoutOrder = var8
		table.insert({}, v)
	end
end
local any_GetCfgByName_result1_upvr = require(ReplicatedStorage.Tool.CfgFind).GetCfgByName("coacheventhatchConf")
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
local var15_upvw
local TweenService_upvr = game:GetService("TweenService")
local TweenInfo_new_result1_upvr = TweenInfo.new(5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, false, 0)
local PlaySoundModule_upvr = require(ReplicatedStorage.Tool.PlaySoundModule)
local function rot_upvr(arg1, arg2, arg3) -- Line 50, Named "rot"
	--[[ Upvalues[7]:
		[1]: any_GetCfgByName_result1_upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
		[3]: GradientsMgr_upvr (readonly)
		[4]: var15_upvw (read and write)
		[5]: TweenService_upvr (readonly)
		[6]: TweenInfo_new_result1_upvr (readonly)
		[7]: PlaySoundModule_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 24 start (CF ANALYSIS FAILED)
	local var26
	for _, v_2 in pairs(any_GetCfgByName_result1_upvr) do
		local tonumber_result1 = tonumber(v_2.Weight)
		if tonumber_result1 and 0 < tonumber_result1 then
		end
	end
	local _, _, _ = pairs(arg1)
	-- KONSTANTERROR: [0] 1. Error Block 24 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [26] 20. Error Block 7 start (CF ANALYSIS FAILED)
	local _, _, _ = pairs(any_GetCfgByName_result1_upvr)
	-- KONSTANTERROR: [26] 20. Error Block 7 end (CF ANALYSIS FAILED)
end
local Arrow1_upvr = Parent.Arrow1
local tbl_upvr = {}
function module_upvr_2.updateUi(arg1, arg2) -- Line 123
	--[[ Upvalues[6]:
		[1]: scroll1_upvr (readonly)
		[2]: Arrow1_upvr (readonly)
		[3]: rot_upvr (readonly)
		[4]: tbl_upvr (readonly)
		[5]: Scroll1_upvr (readonly)
		[6]: module_upvr_2 (readonly)
	]]
	scroll1_upvr.Visible = false
	Arrow1_upvr.Visible = false
	Arrow1_upvr.Visible = true
	scroll1_upvr.Visible = true
	for _, v_3 in pairs(arg2.result) do
		rot_upvr(tbl_upvr, Scroll1_upvr, v_3)
	end
	delay(6, function() -- Line 138
		--[[ Upvalues[2]:
			[1]: module_upvr_2 (copied, readonly)
			[2]: arg2 (readonly)
		]]
		module_upvr_2:closeUi()
		if arg2 and arg2.func then
			arg2.func()
		end
	end)
end
function module_upvr_2.openUi(arg1) -- Line 146
end
local module_upvr = require(ReplicatedStorage:WaitForChild("Tool", math.huge):WaitForChild("UIanima", math.huge))
function module_upvr_2.closeUi(arg1) -- Line 150
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.PopBack(script.Parent)
end
return module_upvr_2