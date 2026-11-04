-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:58
-- Luau version 6, Types version 3
-- Time taken: 0.028443 seconds

-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CfgFind_upvr_2 = require(ReplicatedStorage.Tool.CfgFind)
local MathMgr_upvr_2 = require(ReplicatedStorage.Tool.MathMgr)
local AddListen_2 = require(ReplicatedStorage.Tool.AddListen)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local EnumMgr_upvr_2 = require(ReplicatedStorage.Tool.EnumMgr)
local TranslationHelper_upvr_2 = require(ReplicatedStorage.Tool.TranslationHelper)
local TimeTransfer_upvr_2 = require(ReplicatedStorage.Tool.TimeTransfer)
local GradientsMgr = require(ReplicatedStorage.Tool.GradientsMgr)
local GetData_2 = require(ReplicatedStorage.Tool.GetData)
local DinosaurEvent = ReplicatedStorage["游戏全局配置"].DinosaurEvent
local any_GetCfgByName_result1_upvr_6 = CfgFind_upvr_2.GetCfgByName("coacheventhatchConf")
local any_GetCfgByName_result1_upvr_5 = CfgFind_upvr_2.GetCfgByName("coacheventtaskConf")
local any_GetCfgByName_result1_upvr_4 = CfgFind_upvr_2.GetCfgByName("coacheventshopConf")
local LocalPlayer_upvr = game.Players.LocalPlayer
local any_WaitBagNumberValue_result1_upvr_2 = GetData_2.WaitBagNumberValue(LocalPlayer_upvr, EnumMgr_upvr_2.ItemID.DinosaurHatch)
local RemoteEvent_upvr_2 = ReplicatedStorage.Msg.RemoteEvent
local Parent_upvr_2 = script.Parent
local Panels_upvr_2 = Parent_upvr_2.Panels
local TagList_upvr = Parent_upvr_2.TagList
local Online_2 = Panels_upvr_2.Online
local SpinBtn_2 = Online_2.SpinBtn
local RollFrame = Online_2.RollFrame
local RollTemp = RollFrame.RollTemp
local TaskScroll_upvr_2 = Panels_upvr_2.Task.TaskScroll
local TaskTemp = TaskScroll_upvr_2.TaskTemp
local ShopScroll_upvr = Panels_upvr_2.Shop.ShopScroll
local ShopScrollFrame_upvr = ShopScroll_upvr.ShopScrollFrame
local ShopTemp = ShopScrollFrame_upvr.ShopTemp
local Token_upvr_2 = Parent_upvr_2.Token
local CoachShow_2 = Parent_upvr_2.CoachShow
local Tips_upvr = Parent_upvr_2.Tips
RollTemp.Visible = false
TaskTemp.Visible = false
ShopTemp.Visible = false
local CurPanel_upvr = Parent_upvr_2.CurPanel
local IsTips_upvr = Parent_upvr_2.IsTips
CurPanel_upvr.Value = "Online"
IsTips_upvr.Value = false
local _, pairs_result2_13, pairs_result3_8 = pairs(TagList_upvr:GetChildren())
local var301
for _, v_upvr in var301, pairs_result2_13, pairs_result3_8 do
	if v_upvr:IsA("Frame") then
		local DelRedPoint_upvr_2 = ReplicatedStorage.ServerMsg.DelRedPoint
		AddListen_2.AddMouseCLick(v_upvr.Button, function() -- Line 90
			--[[ Upvalues[4]:
				[1]: v_upvr (readonly)
				[2]: DelRedPoint_upvr_2 (readonly)
				[3]: CurPanel_upvr (readonly)
				[4]: ShopScroll_upvr (readonly)
			]]
			if v_upvr.Name == "Task" then
				DelRedPoint_upvr_2:FireServer("教练活动任务红点")
			end
			CurPanel_upvr.Value = v_upvr.Name
			if v_upvr.Name == "Shop" then
				ShopScroll_upvr.CanvasPosition = Vector2.new(0, 0)
			end
		end, v_upvr.Frame)
	end
end
var301 = ShopScroll_upvr.PayShop.Frame
for _, v_2_upvr in pairs(var301:GetChildren()) do
	if v_2_upvr:IsA("Frame") then
		local any_FindCfgByOnlyTag_result1 = CfgFind_upvr_2.FindCfgByOnlyTag(v_2_upvr.OnlyTag.Value)
		if any_FindCfgByOnlyTag_result1 then
			local Frame_2 = v_2_upvr.Frame
			Frame_2.Icon.Image = "rbxassetid://"..any_FindCfgByOnlyTag_result1.Icon
			GradientsMgr.AddGradientColor(any_FindCfgByOnlyTag_result1.ColorStr, Frame_2.BG)
			TranslationHelper_upvr_2.SetText(Frame_2.ZhName, any_FindCfgByOnlyTag_result1.ZhName)
			TranslationHelper_upvr_2.SetText_UnTrans(Frame_2.Count, 'x'..MathMgr_upvr_2.getNumStr(any_FindCfgByOnlyTag_result1.itemCount[1]))
			TranslationHelper_upvr_2.SetText_UnTrans(Frame_2.PriceBG.Price, MathMgr_upvr_2.getNumStr(any_FindCfgByOnlyTag_result1.price))
			local SystemBuyRoblox_upvr_2 = require(ReplicatedStorage.System.SystemBuyRoblox)
			AddListen_2.AddMouseCLick(v_2_upvr.Button, function() -- Line 121
				--[[ Upvalues[3]:
					[1]: SystemBuyRoblox_upvr_2 (readonly)
					[2]: LocalPlayer_upvr (readonly)
					[3]: v_2_upvr (readonly)
				]]
				SystemBuyRoblox_upvr_2.BuyRobloxByOnlyTag(LocalPlayer_upvr, v_2_upvr.OnlyTag.Value)
			end, v_2_upvr.Frame)
		end
	end
end
var301 = AddListen_2.AddMouseCLick
var301(Tips_upvr.Button, function() -- Line 129
	--[[ Upvalues[1]:
		[1]: IsTips_upvr (readonly)
	]]
	IsTips_upvr.Value = not IsTips_upvr.Value
end, Tips_upvr.Frame)
var301 = AddListen_2.NumValueAdd
var301(IsTips_upvr, function(arg1) -- Line 133
	--[[ Upvalues[1]:
		[1]: Tips_upvr (readonly)
	]]
	Tips_upvr.DesFrame.Visible = arg1
end)
var301 = spawn
local Value_upvr_5 = DinosaurEvent.EndTime.Value
local Value_upvr_2 = DinosaurEvent.StartTime.Value
local RemainValue_upvr = Parent_upvr_2.Remain.RemainValue
local RemainBar_upvr_2 = Parent_upvr_2.Remain.Frame.Frame.RemainBar
var301(function() -- Line 139
	--[[ Upvalues[6]:
		[1]: Value_upvr_5 (readonly)
		[2]: Value_upvr_2 (readonly)
		[3]: TranslationHelper_upvr_2 (readonly)
		[4]: RemainValue_upvr (readonly)
		[5]: TimeTransfer_upvr_2 (readonly)
		[6]: RemainBar_upvr_2 (readonly)
	]]
	while true do
		local UnixTimestamp_2 = DateTime.fromUnixTimestamp(workspace:GetServerTimeNow()).UnixTimestamp
		TranslationHelper_upvr_2.SetText_UnTrans(RemainValue_upvr, TimeTransfer_upvr_2.FormatTimeS(Value_upvr_5 - UnixTimestamp_2))
		RemainBar_upvr_2.Size = UDim2.new(math.clamp((UnixTimestamp_2 - Value_upvr_2) / (Value_upvr_5 - Value_upvr_2), 0, 1), 0, 1, 0)
		wait(1)
	end
end)
var301 = {}
var301[1] = "装备属性描述_训练倍率加成_游泳"
var301[2] = "装备属性描述_训练倍率加成_自行车"
var301[3] = "装备属性描述_训练倍率加成_跑步"
var301[4] = "装备属性描述_金币加成"
var301[5] = "装备属性描述_训练倍率加成_所有"
local any_FindCfgByID_result1_4 = CfgFind_upvr_2.FindCfgByID(Parent_upvr_2.ShowCoach.Value, EnumMgr_upvr_2.ItemType.Coach)
local Ability_2 = CoachShow_2.Ability
local Temp_2 = Ability_2.Temp
Temp_2.Visible = false
TranslationHelper_upvr_2.SetText(CoachShow_2.itemName, any_FindCfgByID_result1_4.ZhName)
for i_3, v_3 in pairs(any_FindCfgByID_result1_4.CoachBuffType) do
	local clone = Temp_2:Clone()
	clone.Parent = Ability_2
	clone.Visible = true
	clone.Name = v_3
	TranslationHelper_upvr_2.SetText(clone:FindFirstChild("Add"), var301[v_3], {any_FindCfgByID_result1_4.CoachBuffNumber[i_3].."%%"})
	local _
end
GradientsMgr.AddGradientColor(any_FindCfgByID_result1_4.xyd, CoachShow_2.BG.BG, false)
GradientsMgr.AddGradientColor(any_FindCfgByID_result1_4.xyd, CoachShow_2.itemName, true)
var301 = 0
for _, v_4 in pairs(any_GetCfgByName_result1_upvr_6) do
	var301 += v_4.Weight
end
for i_5, v_5 in pairs(any_GetCfgByName_result1_upvr_6) do
	local clone_6 = RollTemp:Clone()
	clone_6.Visible = true
	clone_6.Name = i_5
	clone_6.LayoutOrder = i_5
	clone_6.Parent = RollFrame
	TranslationHelper_upvr_2.SetText_UnTrans(clone_6.Frame.Count, v_5.ItemNumber)
	clone_6.Frame.Icon.Image = "rbxassetid://"..v_5.Icon
	GradientsMgr.AddGradientColor(v_5.ColorStr, clone_6.Frame.BG.BG, false)
	TranslationHelper_upvr_2.SetText_UnTrans(clone_6.Frame.Rate, MathMgr_upvr_2.GetPercentStr(v_5.Weight / var301 * 100))
end
local NextRemain_upvr_2 = Online_2.NextRemain
local Value_upvr_4 = DinosaurEvent["抽取次数间隔"].Value
AddListen_2.NumValueAdd(LocalPlayer_upvr:WaitForChild("DinosaurEventOnline", math.huge), function(arg1) -- Line 206
	--[[ Upvalues[4]:
		[1]: TranslationHelper_upvr_2 (readonly)
		[2]: NextRemain_upvr_2 (readonly)
		[3]: TimeTransfer_upvr_2 (readonly)
		[4]: Value_upvr_4 (readonly)
	]]
	TranslationHelper_upvr_2.SetText(NextRemain_upvr_2, "下一个奖励倒计时", {"<stroke color='#000000' joins='miter' thickness='3'>", "</stroke>", "<font color='#ffffff'>", "</font>", "<font color='#fef102'>", "</font>", TimeTransfer_upvr_2.FormatTimeMS(Value_upvr_4 - arg1)})
end)
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
AddListen_2.AddMouseCLick(SpinBtn_2.Button, function() -- Line 219
	--[[ Upvalues[5]:
		[1]: any_WaitBagNumberValue_result1_upvr_2 (readonly)
		[2]: RemoteFunction_upvr (readonly)
		[3]: Parent_upvr_2 (readonly)
		[4]: any_GetCfgByName_result1_upvr_6 (readonly)
		[5]: showLocalUI_upvr (readonly)
	]]
	if any_WaitBagNumberValue_result1_upvr_2.Value <= 0 then
	else
		local any_InvokeServer_result1 = RemoteFunction_upvr:InvokeServer("领取教练活动在线奖励", 1)
		if any_InvokeServer_result1 and 0 < any_InvokeServer_result1 then
			Parent_upvr_2.Visible = false
			local tbl_8 = {
				result = {any_InvokeServer_result1};
			}
			local var345_upvr = any_GetCfgByName_result1_upvr_6[any_InvokeServer_result1]
			local function func() -- Line 231
				--[[ Upvalues[3]:
					[1]: showLocalUI_upvr (copied, readonly)
					[2]: var345_upvr (readonly)
					[3]: Parent_upvr_2 (copied, readonly)
				]]
				showLocalUI_upvr:Fire("奖励领取弹窗无文字", {
					AwardID = {var345_upvr.ItemID};
					Count = {var345_upvr.ItemNumber};
					func = function() -- Line 235, Named "func"
						--[[ Upvalues[1]:
							[1]: Parent_upvr_2 (copied, readonly)
						]]
						Parent_upvr_2.Visible = true
					end;
				})
			end
			tbl_8.func = func
			showLocalUI_upvr:Fire("抽取随机", tbl_8)
			return
		end
		var345_upvr = Parent_upvr_2
		var345_upvr.Visible = true
	end
end, SpinBtn_2.Frame)
local SpinValue_upvr = SpinBtn_2.Frame.SpinValue
AddListen_2.NumValueAdd(any_WaitBagNumberValue_result1_upvr_2, function(arg1) -- Line 264
	--[[ Upvalues[3]:
		[1]: TranslationHelper_upvr_2 (readonly)
		[2]: SpinValue_upvr (readonly)
		[3]: MathMgr_upvr_2 (readonly)
	]]
	TranslationHelper_upvr_2.SetText(SpinValue_upvr, "转盘剩余", {MathMgr_upvr_2.getNumStr(arg1)})
end)
for i_6, v_6 in pairs(any_GetCfgByName_result1_upvr_5) do
	local clone_5_upvr = TaskTemp:Clone()
	clone_5_upvr.Name = i_6
	clone_5_upvr.LayoutOrder = i_6
	clone_5_upvr.Visible = false
	clone_5_upvr:SetAttribute("TaskType", v_6.TaskType)
	clone_5_upvr:SetAttribute("TaskIndex", v_6.TaskIndex)
	clone_5_upvr.Parent = TaskScroll_upvr_2
	local var356 = CfgFind_upvr_2.GetCfgByName("seasontasktypeConf")[v_6.TaskType]
	if var356 then
		TranslationHelper_upvr_2.SetText(clone_5_upvr["任务名称"], var356.Task, {v_6.param})
		UIMgr_upvr.SetAward(clone_5_upvr["任务奖励"].Frame, v_6.ItemID, v_6.ItemCount)
		clone_5_upvr["任务奖励"].Frame.Icon.Image = "rbxassetid://81739690805880"
		if v_6.ItemID == EnumMgr_upvr_2.ItemID.DinosaurToken then
			clone_5_upvr["任务奖励"].Frame.Icon.Image = "rbxassetid://81739690805880"
		end
		AddListen_2.AddMouseCLick(clone_5_upvr["未完成"].Button, function() -- Line 289
			--[[ Upvalues[2]:
				[1]: clone_5_upvr (readonly)
				[2]: RemoteEvent_upvr_2 (readonly)
			]]
			RemoteEvent_upvr_2:FireServer("跳过教练活动任务", tonumber(clone_5_upvr.Name))
		end, clone_5_upvr["未完成"].Frame)
		AddListen_2.AddMouseCLick(clone_5_upvr["完成按钮"].Button, function() -- Line 294
			--[[ Upvalues[2]:
				[1]: clone_5_upvr (readonly)
				[2]: RemoteEvent_upvr_2 (readonly)
			]]
			RemoteEvent_upvr_2:FireServer("教练活动任务奖励", tonumber(clone_5_upvr.Name))
		end, clone_5_upvr["完成按钮"].Frame)
	end
end
local function refreshTaskPanel_upvr(arg1) -- Line 301, Named "refreshTaskPanel"
	--[[ Upvalues[4]:
		[1]: TaskScroll_upvr_2 (readonly)
		[2]: any_GetCfgByName_result1_upvr_5 (readonly)
		[3]: TranslationHelper_upvr_2 (readonly)
		[4]: UIMgr_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 35 start (CF ANALYSIS FAILED)
	local DinosaurEvent_2 = arg1.DinosaurEvent
	if not DinosaurEvent_2 then return end
	local TaskRecord = DinosaurEvent_2.TaskRecord
	if not TaskRecord then return end
	if not DinosaurEvent_2.TaskClaim then return end
	for _, v_7 in pairs(TaskRecord) do
		({})[v_7.TaskID] = v_7
		local _
	end
	local pairs_result1_5, pairs_result2_6, pairs_result3_4 = pairs(TaskScroll_upvr_2:GetChildren())
	-- KONSTANTERROR: [0] 1. Error Block 35 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [165] 114. Error Block 27 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [165] 114. Error Block 27 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [32] 24. Error Block 10 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	-- KONSTANTERROR: [32] 24. Error Block 10 end (CF ANALYSIS FAILED)
end
for i_8, v_8 in pairs(any_GetCfgByName_result1_upvr_4) do
	local any_FindCfgByID_result1_3 = CfgFind_upvr_2.FindCfgByID(v_8.award[1])
	if any_FindCfgByID_result1_3 then
		ShopTemp:Clone().Visible = true
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		ShopTemp:Clone().Name = i_8
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		ShopTemp:Clone().LayoutOrder = i_8
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		ShopTemp:Clone().Parent = ShopScrollFrame_upvr
		if any_FindCfgByID_result1_3.tp == EnumMgr_upvr_2.ItemType.Aura then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			ShopTemp:Clone().Frame.Frame["光环"].Visible = true
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			GradientsMgr.ChangeClolr(ShopTemp:Clone().Frame.Frame["光环"], any_FindCfgByID_result1_3.xyd)
			local var377 = ""
			if any_FindCfgByID_result1_3.RewardType == EnumMgr_upvr_2.AuraAddType.PowerGainUp then
				var377 = "111346891121061"
			elseif any_FindCfgByID_result1_3.RewardType == EnumMgr_upvr_2.AuraAddType.StaminaGainUp then
				var377 = "18657640817"
			elseif any_FindCfgByID_result1_3.RewardType == EnumMgr_upvr_2.AuraAddType.ComptitionRewardUp then
				var377 = "18826879641"
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			ShopTemp:Clone().Frame.Frame["加成数值"].Visible = true
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			TranslationHelper_upvr_2.SetText_UnTrans(ShopTemp:Clone().Frame.Frame["加成数值"], '+'..(any_FindCfgByID_result1_3.RewardAdd / 100)..'%')
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			ShopTemp:Clone().Frame.Frame["加成数值"].Icon.Image = "rbxassetid://"..var377
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			ShopTemp:Clone().Frame.Frame["光环"].Visible = false
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			ShopTemp:Clone().Frame.Frame["加成数值"].Visible = false
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		UIMgr_upvr.SetAward(ShopTemp:Clone().Frame.Frame, v_8.award[1], v_8.awardCount[1])
		if any_FindCfgByID_result1_3.tp == EnumMgr_upvr_2.ItemType.Coach then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			local Icon_2 = ShopTemp:Clone().Frame.Frame.Icon
			Icon_2.Size = UDim2.new(1.1, 0, 1.1, 0)
			Icon_2.Position = UDim2.new(0.5, 0, 0.4, 0)
		end
		if v_8.award[1] == 8000016 then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			local Icon_3 = ShopTemp:Clone().Frame.Frame.Icon
			Icon_3.Size = UDim2.new(1.3, 0, 1.3, 0)
			Icon_3.Position = UDim2.new(0.5, 0, 0.3, 0)
		end
		if v_8.award[1] == EnumMgr_upvr_2.ItemID.MagicToken then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			ShopTemp:Clone().Frame.Frame.Icon.Image = "rbxassetid://88744356248828"
		elseif v_8.award[1] == EnumMgr_upvr_2.ItemID.EventToken then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			ShopTemp:Clone().Frame.Frame.Icon.Image = "rbxassetid://93634755591712"
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		TranslationHelper_upvr_2.SetText_UnTrans(ShopTemp:Clone().BuyBtn.Frame.Cost, MathMgr_upvr_2.getNumStr(v_8.costCount))
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		local clone_3_upvr = ShopTemp:Clone()
		local any_WaitBagNumberValue_result1_upvr_3 = GetData_2.WaitBagNumberValue(LocalPlayer_upvr, EnumMgr_upvr_2.ItemID.DinosaurToken)
		local TipsModule_upvr_2 = require(ReplicatedStorage.Tool.TipsModule)
		AddListen_2.AddMouseCLick(ShopTemp:Clone().BuyBtn.Button, function() -- Line 429
			--[[ Upvalues[9]:
				[1]: clone_3_upvr (readonly)
				[2]: any_GetCfgByName_result1_upvr_4 (readonly)
				[3]: any_WaitBagNumberValue_result1_upvr_3 (readonly)
				[4]: RemoteEvent_upvr_2 (readonly)
				[5]: CfgFind_upvr_2 (readonly)
				[6]: EnumMgr_upvr_2 (readonly)
				[7]: TranslationHelper_upvr_2 (readonly)
				[8]: TipsModule_upvr_2 (readonly)
				[9]: LocalPlayer_upvr (readonly)
			]]
			local tonumber_result1_3 = tonumber(clone_3_upvr.Name)
			if any_GetCfgByName_result1_upvr_4[tonumber_result1_3].costCount <= any_WaitBagNumberValue_result1_upvr_3.Value then
				RemoteEvent_upvr_2:FireServer("教练活动兑换", tonumber_result1_3)
			else
				TipsModule_upvr_2.ErrorTips(LocalPlayer_upvr, "物品数量不够", {TranslationHelper_upvr_2.translateByKey(CfgFind_upvr_2.FindCfgByID(EnumMgr_upvr_2.ItemID.DinosaurToken).ZhName)})
			end
		end, clone_3_upvr.BuyBtn.Frame)
	end
end
UIMgr_upvr.SetUIGridLayoutSize(ShopScrollFrame_upvr)
UIMgr_upvr.SetUIlistSize(ShopScroll_upvr)
local function refreshShopPanel_upvr(arg1) -- Line 447, Named "refreshShopPanel"
	--[[ Upvalues[2]:
		[1]: ShopScrollFrame_upvr (readonly)
		[2]: any_GetCfgByName_result1_upvr_4 (readonly)
	]]
	local DinosaurEvent_3 = arg1.DinosaurEvent
	if not DinosaurEvent_3 then
	else
		local ShopRecord = DinosaurEvent_3.ShopRecord
		if not ShopRecord then return end
		for _, v_11 in pairs(ShopScrollFrame_upvr:GetChildren()) do
			local tonumber_result1_2 = tonumber(v_11.Name)
			if tonumber_result1_2 then
				local var394 = any_GetCfgByName_result1_upvr_4[tonumber_result1_2]
				if 1 <= var394.stock and var394.stock <= ShopRecord[tonumber_result1_2] then
					v_11.BuyBtn.Visible = false
					v_11.Empty.Visible = true
				else
					v_11.BuyBtn.Visible = true
					v_11.Empty.Visible = false
				end
			end
		end
	end
end
AddListen_2.NumValueAdd(any_WaitBagNumberValue_result1_upvr_3, function(arg1) -- Line 477
	--[[ Upvalues[3]:
		[1]: TranslationHelper_upvr_2 (readonly)
		[2]: Token_upvr_2 (readonly)
		[3]: MathMgr_upvr_2 (readonly)
	]]
	TranslationHelper_upvr_2.SetText_UnTrans(Token_upvr_2.Label, MathMgr_upvr_2.getNumStr(arg1))
end)
local UIScale_upvr_2 = Parent_upvr_2.UIScale
AddListen_2.AddMouseCLick(Token_upvr_2.Add.Button, function() -- Line 482
	--[[ Upvalues[4]:
		[1]: CurPanel_upvr (readonly)
		[2]: ShopScroll_upvr (readonly)
		[3]: ShopScrollFrame_upvr (readonly)
		[4]: UIScale_upvr_2 (readonly)
	]]
	CurPanel_upvr.Value = "Shop"
	ShopScroll_upvr.CanvasPosition = Vector2.new(0, ShopScrollFrame_upvr.Size.Y.Offset * script.Parent.Parent.UIScale.Scale * UIScale_upvr_2.Scale)
end, Token_upvr_2.Add.Frame)
AddListen_2.NumValueAdd(CurPanel_upvr, function(arg1) -- Line 487
	--[[ Upvalues[3]:
		[1]: TagList_upvr (readonly)
		[2]: Panels_upvr_2 (readonly)
		[3]: DelRedPoint_upvr_2 (readonly)
	]]
	for _, v_9 in pairs(TagList_upvr:GetChildren()) do
		if v_9:IsA("Frame") then
			if v_9.Name == arg1 then
				v_9.Frame.Close.Visible = false
			else
				v_9.Frame.Close.Visible = true
			end
		end
	end
	for _, v_10 in pairs(Panels_upvr_2:GetChildren()) do
		if v_10.Name == arg1 then
			v_10.Visible = true
		else
			v_10.Visible = false
		end
	end
	if arg1 == "Task" then
		DelRedPoint_upvr_2:FireServer("教练活动任务红点")
	end
end)
AddListen_2.AddMouseCLick(Parent_upvr_2.BG.Exit.Button, function() -- Line 515
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Parent_upvr_2.BG.Exit.Frame)
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
function module_upvr.updateUi(arg1, arg2) -- Line 519
	--[[ Upvalues[3]:
		[1]: LocalData_upvr (readonly)
		[2]: refreshTaskPanel_upvr (readonly)
		[3]: refreshShopPanel_upvr (readonly)
	]]
	if arg2 == nil then
		local any_GetLocalData_result1 = LocalData_upvr:GetLocalData()
	end
	refreshTaskPanel_upvr(any_GetLocalData_result1)
	refreshShopPanel_upvr(any_GetLocalData_result1)
end
function module_upvr.openUi(arg1) -- Line 527
	--[[ Upvalues[1]:
		[1]: UIMgr_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(false)
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 531
	--[[ Upvalues[2]:
		[1]: UIMgr_upvr (readonly)
		[2]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr