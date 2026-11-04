-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:18
-- Luau version 6, Types version 3
-- Time taken: 0.003848 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local RebirthData_upvr = require(ReplicatedStorage.Tool.RebirthData)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
local Value_upvr = ReplicatedStorage["游戏全局配置"]["最大晋级等级"].Value
local LocalPlayer_upvr = game.Players.LocalPlayer
local rebirthCount_upvr = LocalPlayer_upvr:WaitForChild("rebirthCount", math.huge)
local Parent = script.Parent
local Frame = Parent.Frame
local RebirthBtn_upvr = Frame.RebirthBtn
local Need = Frame.Need
local Temp = Need.Temp
local tbl = {Temp}
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
local function addBarListen(arg1, arg2) -- Line 44
	--[[ Upvalues[10]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: TranslationHelper_upvr (readonly)
		[4]: GetData_upvr (readonly)
		[5]: LocalPlayer_upvr (readonly)
		[6]: rebirthCount_upvr (readonly)
		[7]: Value_upvr (readonly)
		[8]: MathMgr_upvr (readonly)
		[9]: RebirthData_upvr (readonly)
		[10]: AddListen_upvr (readonly)
	]]
	local any_FindCfgByID_result1 = CfgFind_upvr.FindCfgByID(arg2, EnumMgr_upvr.ItemType.Item)
	if any_FindCfgByID_result1 then
		TranslationHelper_upvr.SetText(arg1["肌肉名字"], any_FindCfgByID_result1.ZhName)
		arg1["肌肉名字"]["肌肉图片"].Image = "rbxassetid://"..any_FindCfgByID_result1.Icon
	end
	local any_WaitBagNumberValue_result1_upvr = GetData_upvr.WaitBagNumberValue(LocalPlayer_upvr, arg2)
	if any_WaitBagNumberValue_result1_upvr then
		local function updateTemp() -- Line 59
			--[[ Upvalues[9]:
				[1]: arg1 (readonly)
				[2]: rebirthCount_upvr (copied, readonly)
				[3]: Value_upvr (copied, readonly)
				[4]: TranslationHelper_upvr (copied, readonly)
				[5]: MathMgr_upvr (copied, readonly)
				[6]: any_WaitBagNumberValue_result1_upvr (readonly)
				[7]: RebirthData_upvr (copied, readonly)
				[8]: arg2 (readonly)
				[9]: EnumMgr_upvr (copied, readonly)
			]]
			local TotalStr = arg1.BarBg.TotalStr
			if Value_upvr <= rebirthCount_upvr.Value then
				arg1["已完成"].Visible = false
				arg1.BarBg.Visible = true
				arg1.BarBg.Bar.Visible = false
				TranslationHelper_upvr.SetText_UnTrans(TotalStr, "0%")
				TranslationHelper_upvr.SetText_UnTrans(arg1.TotalNeed, MathMgr_upvr.getNumStr(any_WaitBagNumberValue_result1_upvr.Value).."/???")
			else
				local any_GetRebirthCfg_result1_2 = RebirthData_upvr.GetRebirthCfg(rebirthCount_upvr.Value + 1)
				if any_GetRebirthCfg_result1_2 then
					arg1["已完成"].Visible = true
					local var27 = any_GetRebirthCfg_result1_2.need[arg2 - EnumMgr_upvr.ItemID.Attr_1 + 1]
					local clamped = math.clamp(any_WaitBagNumberValue_result1_upvr.Value / var27, 0, 1)
					arg1.BarBg.Bar.Size = UDim2.new(clamped, 0, 1, 0)
					if clamped <= 0.05 then
						arg1.BarBg.Bar.Visible = false
					else
						arg1.BarBg.Bar.Visible = true
					end
					if var27 <= any_WaitBagNumberValue_result1_upvr.Value then
						arg1["已完成"].Visible = true
						arg1.BarBg.Visible = false
						arg1.TotalNeed.Visible = false
					else
						arg1["已完成"].Visible = false
						arg1.BarBg.Visible = true
						arg1.TotalNeed.Visible = true
					end
					TranslationHelper_upvr.SetText_UnTrans(TotalStr, MathMgr_upvr.GetPercentStr(clamped * 100))
					TranslationHelper_upvr.SetText_UnTrans(arg1.TotalNeed, MathMgr_upvr.getNumStr(any_WaitBagNumberValue_result1_upvr.Value)..'/'..MathMgr_upvr.getNumStr(var27))
					return
				end
				arg1["已完成"].Visible = false
				arg1.BarBg.Bar.Visible = false
				TranslationHelper_upvr.SetText_UnTrans(TotalStr, "0%")
				TranslationHelper_upvr.SetText_UnTrans(arg1.TotalNeed, MathMgr_upvr.getNumStr(any_WaitBagNumberValue_result1_upvr.Value).."/???")
			end
		end
		AddListen_upvr.NumValueAdd(any_WaitBagNumberValue_result1_upvr, updateTemp)
		AddListen_upvr.NumValueAdd(rebirthCount_upvr, updateTemp)
	end
end
addBarListen(Temp, EnumMgr_upvr.ItemID.Attr_1)
for i = 1, 2 do
	local clone = Temp:Clone()
	clone.Parent = Need
	clone.LayoutOrder = i
	table.insert(tbl, clone)
	addBarListen(clone, EnumMgr_upvr.ItemID.Attr_1 + i)
end
local Exit = Parent.BG.Exit
AddListen_upvr.AddMouseCLick(Exit.Button, function() -- Line 151
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Exit, "音效-场景-点击-通用返回")
local TipsModule_upvr = require(ReplicatedStorage.Tool.TipsModule)
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
AddListen_upvr.AddMouseCLick(RebirthBtn_upvr.Button, function() -- Line 156
	--[[ Upvalues[5]:
		[1]: rebirthCount_upvr (readonly)
		[2]: Value_upvr (readonly)
		[3]: TipsModule_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
		[5]: RemoteFunction_upvr (readonly)
	]]
	if Value_upvr <= rebirthCount_upvr.Value then
		TipsModule_upvr.ErrorTips(LocalPlayer_upvr, "最大晋级等级")
	else
		RemoteFunction_upvr:InvokeServer("重生")
	end
end, RebirthBtn_upvr)
local ______0_upvr = Parent.Frame["称号0"]
local ______0_upvr_2 = Parent.Frame["加成0"]
local ______1_upvr = Parent.Frame["称号1"]
local ______1_upvr_2 = Parent.Frame["加成1"]
local _____________upvr = Frame["需要金币"]
local function refreshInfo_upvr() -- Line 171, Named "refreshInfo"
	--[[ Upvalues[12]:
		[1]: RebirthData_upvr (readonly)
		[2]: rebirthCount_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
		[4]: TranslationHelper_upvr (readonly)
		[5]: ______0_upvr (readonly)
		[6]: ______0_upvr_2 (readonly)
		[7]: MathMgr_upvr (readonly)
		[8]: Value_upvr (readonly)
		[9]: ______1_upvr (readonly)
		[10]: ______1_upvr_2 (readonly)
		[11]: _____________upvr (readonly)
		[12]: RebirthBtn_upvr (readonly)
	]]
	local var40 = RebirthData_upvr.GetRebirthAdd(LocalPlayer_upvr) - 1
	TranslationHelper_upvr.SetText(______0_upvr, RebirthData_upvr.GetRebirhTitle(rebirthCount_upvr.Value))
	if var40 <= 0 then
		TranslationHelper_upvr.SetText_UnTrans(______0_upvr_2, "+0%")
	else
		TranslationHelper_upvr.SetText_UnTrans(______0_upvr_2, '+'..MathMgr_upvr.GetPercentStr(var40 * 100))
	end
	local any_GetRebirthCfg_result1 = RebirthData_upvr.GetRebirthCfg(rebirthCount_upvr.Value + 1)
	if Value_upvr <= rebirthCount_upvr.Value then
		TranslationHelper_upvr.SetText_UnTrans(______1_upvr, "???")
		TranslationHelper_upvr.SetText_UnTrans(______1_upvr_2, "+???%")
	else
		if any_GetRebirthCfg_result1 then
			_____________upvr.Visible = true
			TranslationHelper_upvr.SetText_UnTrans(_____________upvr, MathMgr_upvr.getNumStr(any_GetRebirthCfg_result1.money))
			TranslationHelper_upvr.SetText(______1_upvr, any_GetRebirthCfg_result1.title)
			TranslationHelper_upvr.SetText_UnTrans(______1_upvr_2, '+'..MathMgr_upvr.GetPercentStr((any_GetRebirthCfg_result1.rate - 1) * 100))
			RebirthBtn_upvr.Visible = true
			return
		end
		_____________upvr.Visible = false
		RebirthBtn_upvr.Visible = false
		TranslationHelper_upvr.SetText_UnTrans(______1_upvr, "???")
		TranslationHelper_upvr.SetText_UnTrans(______1_upvr_2, "+???%")
	end
end
AddListen_upvr.NumValueAdd(rebirthCount_upvr, function(arg1) -- Line 214
	--[[ Upvalues[1]:
		[1]: refreshInfo_upvr (readonly)
	]]
	refreshInfo_upvr()
end)
function module_upvr.updateUi(arg1, arg2) -- Line 219
end
function module_upvr.openUi(arg1) -- Line 223
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
	ShowDetail_upvr.HideAllDetail()
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 228
	--[[ Upvalues[3]:
		[1]: UIMgr_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
		[3]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	ShowDetail_upvr.HideAllDetail()
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr