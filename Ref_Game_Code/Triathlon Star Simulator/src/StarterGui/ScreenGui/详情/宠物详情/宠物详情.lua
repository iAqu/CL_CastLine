-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:19
-- Luau version 6, Types version 3
-- Time taken: 0.001564 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent_upvr = script.Parent
local Right = script.Parent.Right
local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
local OnlyID_upvr = Parent_upvr.OnlyID
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local ZhName_upvr = Right["名字"].ZhName
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
local xydStr_upvr = Right.xydStr
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local TrainAdd_upvr = Right["训练加成"].TrainAdd
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
local Exist_upvr = Right.Exist
function module_upvr.ShowByData(arg1, arg2) -- Line 30
	--[[ Upvalues[12]:
		[1]: GetData_upvr (readonly)
		[2]: OnlyID_upvr (readonly)
		[3]: Parent_upvr (readonly)
		[4]: TranslationHelper_upvr (readonly)
		[5]: ZhName_upvr (readonly)
		[6]: GradientsMgr_upvr (readonly)
		[7]: xydStr_upvr (readonly)
		[8]: EnumMgr_upvr (readonly)
		[9]: TrainAdd_upvr (readonly)
		[10]: MathMgr_upvr (readonly)
		[11]: RemoteFunction_upvr (readonly)
		[12]: Exist_upvr (readonly)
	]]
	local any_getDataAndCfg_result1_upvr, any_getDataAndCfg_result2 = GetData_upvr.getDataAndCfg(arg1[1])
	if not any_getDataAndCfg_result1_upvr or not any_getDataAndCfg_result2 then
	else
		OnlyID_upvr.Value = arg1[1]
		Parent_upvr.Size = UDim2.new(0, arg2.AbsoluteSize.X, 0, arg2.AbsoluteSize.Y)
		TranslationHelper_upvr.SetText(ZhName_upvr, any_getDataAndCfg_result2.ZhName)
		GradientsMgr_upvr.AddGradientColor(any_getDataAndCfg_result2.xyd, xydStr_upvr)
		TranslationHelper_upvr.SetText(xydStr_upvr, EnumMgr_upvr.RareName[any_getDataAndCfg_result2.xyd])
		TrainAdd_upvr.Text = 'x'..MathMgr_upvr.GetPercentStr(any_getDataAndCfg_result2.TrainRate * 100)
		spawn(function() -- Line 45
			--[[ Upvalues[5]:
				[1]: RemoteFunction_upvr (copied, readonly)
				[2]: any_getDataAndCfg_result1_upvr (readonly)
				[3]: MathMgr_upvr (copied, readonly)
				[4]: TranslationHelper_upvr (copied, readonly)
				[5]: Exist_upvr (copied, readonly)
			]]
			local any_InvokeServer_result1 = RemoteFunction_upvr:InvokeServer("获取已经存在的宠物数", any_getDataAndCfg_result1_upvr.id)
			if any_InvokeServer_result1 and tonumber(any_InvokeServer_result1) then
				TranslationHelper_upvr.SetText(Exist_upvr, "已存在宠物", {MathMgr_upvr.getNumStr(tonumber(any_InvokeServer_result1))})
			end
		end)
	end
end
function module_upvr.HoldShow(arg1, arg2) -- Line 54
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.ShowByData(arg1, arg2)
end
return module_upvr