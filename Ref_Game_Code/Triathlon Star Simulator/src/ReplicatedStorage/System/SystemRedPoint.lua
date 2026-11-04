-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:31
-- Luau version 6, Types version 3
-- Time taken: 0.003782 seconds

local module_upvr = {}
local SystemSave_upvr = require(game:GetService("ReplicatedStorage").System.SystemSave)
module_upvr.RedData = {"每日任务红点", "每周任务红点", "背包红点", "宠物红点", "邮件红点", "签到红点", "在线奖励红点", "教练活动任务红点", "教练活动在线红点"}
local function _(arg1) -- Line 24, Named "GetRedData"
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	local any_GetStat_result1_3 = SystemSave_upvr.GetStat(arg1)
	if not any_GetStat_result1_3 then return end
	return any_GetStat_result1_3.RedPoint
end
local function _(arg1) -- Line 32, Named "getFolder"
	local RedPoint_4 = arg1:FindFirstChild("RedPoint")
	if not RedPoint_4 then
		RedPoint_4 = Instance.new("Folder", arg1)
		RedPoint_4.Name = "RedPoint"
	end
	return RedPoint_4
end
function module_upvr.setRedValue(arg1, arg2, arg3) -- Line 42
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	local RedPoint = arg1:FindFirstChild("RedPoint")
	if not RedPoint then
		RedPoint = Instance.new("Folder", arg1)
		RedPoint.Name = "RedPoint"
	end
	local var12 = RedPoint
	if var12 then
		local SOME_2 = var12:FindFirstChild(arg2)
		local var14
		if SOME_2 then
			SOME_2.Value = arg3
			local any_GetStat_result1_2 = SystemSave_upvr.GetStat(arg1)
			if not any_GetStat_result1_2 then
				var14 = nil
			else
				var14 = any_GetStat_result1_2.RedPoint
			end
			if not var14 then return end
			var14[arg2] = arg3
			SystemSave_upvr.ChangeStat(arg1, "RedPoint", var14, false)
		end
	end
end
function module_upvr.AddRedValue(arg1, arg2, arg3) -- Line 64
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	local RedPoint_3 = arg1:FindFirstChild("RedPoint")
	if not RedPoint_3 then
		RedPoint_3 = Instance.new("Folder", arg1)
		RedPoint_3.Name = "RedPoint"
	end
	local var17 = RedPoint_3
	if var17 then
		local SOME = var17:FindFirstChild(arg2)
		local var19
		if SOME then
			local var20 = 1
			if arg3 then
				var20 = arg3
			end
			var19 = SOME.Value + var20
			SOME.Value = var19
			local any_GetStat_result1_4 = SystemSave_upvr.GetStat(arg1)
			if not any_GetStat_result1_4 then
				var19 = nil
			else
				var19 = any_GetStat_result1_4.RedPoint
			end
			if not var19 then return end
			if var19[arg2] and tonumber(var19[arg2]) then
				var19[arg2] = tonumber(var19[arg2]) + var20
			else
				var19[arg2] = var20
			end
			SystemSave_upvr.ChangeStat(arg1, "RedPoint", var19, false)
		end
	end
end
function module_upvr.DelRedValue(arg1, arg2) -- Line 95
	--[[ Upvalues[1]:
		[1]: SystemSave_upvr (readonly)
	]]
	local RedPoint_6 = arg1:FindFirstChild("RedPoint")
	if not RedPoint_6 then
		RedPoint_6 = Instance.new("Folder", arg1)
		RedPoint_6.Name = "RedPoint"
	end
	local var23 = RedPoint_6
	if var23 then
		local SOME_3 = var23:FindFirstChild(arg2)
		if SOME_3 then
			local var25 = 0
			SOME_3.Value = var25
			local any_GetStat_result1_5 = SystemSave_upvr.GetStat(arg1)
			if not any_GetStat_result1_5 then
				var25 = nil
			else
				var25 = any_GetStat_result1_5.RedPoint
			end
			if not var25 then return end
			var25[arg2] = 0
			SystemSave_upvr.ChangeStat(arg1, "RedPoint", var25, false)
		end
	end
end
function module_upvr.updateRedPoint(arg1, arg2) -- Line 114
	local RedPoint_5 = arg1:FindFirstChild("RedPoint")
	if not RedPoint_5 then
		RedPoint_5 = Instance.new("Folder", arg1)
		RedPoint_5.Name = "RedPoint"
	end
end
function module_upvr.Init(arg1) -- Line 133
	--[[ Upvalues[2]:
		[1]: SystemSave_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local any_GetStat_result1_6 = SystemSave_upvr.GetStat(arg1)
	local var33
	if not any_GetStat_result1_6 then
		var33 = nil
	else
		var33 = any_GetStat_result1_6.RedPoint
	end
	if not var33 then
	else
		local RedPoint_2 = arg1:FindFirstChild("RedPoint")
		if not RedPoint_2 then
			RedPoint_2 = Instance.new("Folder", arg1)
			RedPoint_2.Name = "RedPoint"
		end
		for _, v in pairs(module_upvr.RedData) do
			local NumberValue = Instance.new("NumberValue", RedPoint_2)
			NumberValue.Name = tostring(v)
			if var33[tostring(v)] then
				NumberValue.Value = var33[tostring(v)]
			else
				NumberValue.Value = 0
			end
		end
		module_upvr.updateRedPoint(arg1, "商城红点")
	end
end
return module_upvr