-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:29
-- Luau version 6, Types version 3
-- Time taken: 0.018296 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local Parent_upvr = script.Parent
local LocalPlayer_upvr = game.Players.LocalPlayer
local ShowDetail_upvr = require(ReplicatedStorage.Tool.ShowDetail)
local RemoteFunction_upvr = ReplicatedStorage.Msg.RemoteFunction
local ScrollPet_upvr = Parent_upvr.Frame.BG.ScrollPet
local Template_upvr = ScrollPet_upvr.Template
Template_upvr.Visible = false
local EnumMgr_upvr = require(ReplicatedStorage.Tool.EnumMgr)
local InsMgr = require(ReplicatedStorage.Tool.InsMgr)
local GetData_upvr = require(ReplicatedStorage.Tool.GetData)
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local var20_upvw
local OtherUI_upvr = Parent_upvr.Frame.OtherUI
local _____________4_upvr = Parent_upvr.Frame["背包功能"]
local _______5 = _____________4_upvr["删除"]
local _______3 = _____________4_upvr["锁定"]
local _____________upvr = Parent_upvr.Frame["删除提示"]
_____________upvr.Visible = false
local ______ = _____________upvr["删除"]
local _______2 = _____________upvr["取消"]
local _______6 = _____________upvr["全选"]
local _____________2_upvr = Parent_upvr.Frame["锁定提示"]
_____________2_upvr.Visible = false
local _______7 = _____________2_upvr["取消"]
local ____________ = _____________2_upvr["全部解锁"]
local HeroState_upvr = Parent_upvr.HeroState
local tbl_upvw = {}
local ______________________upvr = Parent_upvr.Frame["当前选中的武器"]
local _____________upvr_2 = Parent_upvr.Frame["合成界面"]
local Button = _____________upvr_2["合成按钮"].Button
local ___________________upvr_2 = _____________upvr_2["当前选中装备"]
local __________________ = _____________upvr_2["当前展示装备"]
local __________upvr = _____________upvr_2["成功率"]
local OnlyID_upvr = ______________________upvr.OnlyID
local any_GetIns_result1_upvr = InsMgr.GetIns("当前选择的装备的星级", "NumberValue", script)
local any_GetIns_result1_upvr_2 = InsMgr.GetIns("当前选择的装备的ID", "NumberValue", script)
local ___________________upvr = Parent_upvr["当前背包标签"]
local _____________5_upvr = Parent_upvr["当前标签"]
local Button_2 = Parent_upvr.BG.Exit.Button
AddListen_upvr.AddMouseCLick(Button_2, function() -- Line 88
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Button_2.Parent, "音效-场景-点击-通用返回")
AddListen_upvr.AddMouseCLick(_______3.Button, function() -- Line 92
	--[[ Upvalues[1]:
		[1]: HeroState_upvr (readonly)
	]]
	HeroState_upvr.Value = 1
end, _______3)
AddListen_upvr.NumValueAdd(HeroState_upvr, function(arg1) -- Line 96
	--[[ Upvalues[5]:
		[1]: HeroState_upvr (readonly)
		[2]: _____________4_upvr (readonly)
		[3]: OtherUI_upvr (readonly)
		[4]: _____________upvr (readonly)
		[5]: _____________2_upvr (readonly)
	]]
	if HeroState_upvr.Value == 0 then
		_____________4_upvr.Visible = true
		OtherUI_upvr.Visible = true
		_____________upvr.Visible = false
		_____________2_upvr.Visible = false
	else
		if HeroState_upvr.Value == 1 then
			_____________upvr.Visible = false
			_____________4_upvr.Visible = false
			OtherUI_upvr.Visible = false
			_____________2_upvr.Visible = true
			return
		end
		if HeroState_upvr.Value == 2 then
			_____________upvr.Visible = true
			_____________4_upvr.Visible = false
			OtherUI_upvr.Visible = false
			_____________2_upvr.Visible = false
		end
	end
end)
local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
local function getDataAndCfg_upvr(arg1) -- Line 117, Named "getDataAndCfg"
	--[[ Upvalues[2]:
		[1]: LocalData_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1_9, pairs_result2_9, pairs_result3_5 = pairs(LocalData_upvr:GetLocalData().Bag)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [17] 13. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [17] 13. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [11] 9. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [17.8]
	-- KONSTANTERROR: [11] 9. Error Block 2 end (CF ANALYSIS FAILED)
end
local GradientsMgr_upvr = require(ReplicatedStorage.Tool.GradientsMgr)
local BG_upvr = ______________________upvr.BG
local Viewport_upvr = require(ReplicatedStorage.Tool.Viewport)
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local function UpdateNowWeaponUI_upvr() -- Line 136, Named "UpdateNowWeaponUI"
	--[[ Upvalues[12]:
		[1]: OnlyID_upvr (readonly)
		[2]: ScrollPet_upvr (readonly)
		[3]: ______________________upvr (readonly)
		[4]: getDataAndCfg_upvr (readonly)
		[5]: GradientsMgr_upvr (readonly)
		[6]: BG_upvr (readonly)
		[7]: TranslationHelper_upvr (readonly)
		[8]: Viewport_upvr (readonly)
		[9]: EnumMgr_upvr (readonly)
		[10]: MathMgr_upvr (readonly)
		[11]: GetData_upvr (readonly)
		[12]: LocalPlayer_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local Value = OnlyID_upvr.Value
	for _, v in pairs(ScrollPet_upvr:GetChildren()) do
		local onlyID_3 = v:FindFirstChild("onlyID")
		local Choose = v:FindFirstChild("Choose")
		if Choose then
			if onlyID_3 and onlyID_3.Value == Value then
				Choose.Visible = true
			else
				Choose.Visible = false
			end
		end
	end
	local Buttons = ______________________upvr.Buttons
	local itemName = ______________________upvr.itemName
	local _____________3 = ______________________upvr["合成等级"]
	local ViewportFrame = ______________________upvr.ViewportFrame
	local _______4 = ______________________upvr["属性"]
	local getDataAndCfg_upvr_result1, getDataAndCfg_upvr_result2 = getDataAndCfg_upvr(Value)
	local var78
	if getDataAndCfg_upvr_result1 and getDataAndCfg_upvr_result2 then
		var78 = true
		_______4.Visible = var78
		var78 = 1
		if getDataAndCfg_upvr_result1.lv then
			var78 = getDataAndCfg_upvr_result1.lv
		end
		local NEVER = _____________3:FindFirstChild(1)
		local var80
		if NEVER then
			if 1 > var78 then
				var80 = false
			else
				var80 = true
			end
			NEVER.Visible = var80
		end
		local NEVER_2 = _____________3:FindFirstChild(2)
		if NEVER_2 then
			if 2 > var78 then
			else
			end
			NEVER_2.Visible = true
		end
		local var82
		local NEVER_5 = _____________3:FindFirstChild(3)
		if NEVER_5 then
			if 3 > var78 then
			else
			end
			NEVER_5.Visible = true
		end
		GradientsMgr_upvr.setXydLabel(itemName, getDataAndCfg_upvr_result2.xyd)
		BG_upvr.Visible = true
		GradientsMgr_upvr.ChangeClolr(BG_upvr, getDataAndCfg_upvr_result2.xyd)
		TranslationHelper_upvr.SetText(itemName, getDataAndCfg_upvr_result2.ZhName)
		ViewportFrame.Visible = true
		Buttons.Visible = true
		Viewport_upvr.createViewPort(ViewportFrame, getDataAndCfg_upvr_result1.id)
		if getDataAndCfg_upvr_result2.ToolTp == EnumMgr_upvr.ToolTp.Run then
		end
		if getDataAndCfg_upvr_result2.ToolTp == EnumMgr_upvr.ToolTp.Ride then
		end
		if getDataAndCfg_upvr_result2.ToolTp == EnumMgr_upvr.ToolTp.Swim then
		end
		if 0 < getDataAndCfg_upvr_result2.Add then
			_______4['1'].Visible = true
			TranslationHelper_upvr.SetText(_______4['1'], "装备属性描述_训练倍率加成_".."游泳", {MathMgr_upvr.getNumStr(math.floor(GetData_upvr.GetStarAdd(getDataAndCfg_upvr_result2.Add, var78) * 100)).."%%"})
		else
			_______4['1'].Visible = false
		end
		if 0 < getDataAndCfg_upvr_result2.Less then
			_______4['2'].Visible = true
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			TranslationHelper_upvr.SetText(_______4['2'], "装备属性描述_耐力减少_".."游泳", {MathMgr_upvr.getNumStr(math.floor(GetData_upvr.GetStarAdd(getDataAndCfg_upvr_result2.Less, var78) * 100)).."%%"})
		else
			_______4['2'].Visible = false
		end
		if 0 < getDataAndCfg_upvr_result2.Speed then
			_______4['3'].Visible = true
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			TranslationHelper_upvr.SetText(_______4['3'], "装备属性描述_速度加成_".."游泳", {MathMgr_upvr.getNumStr(math.floor(GetData_upvr.GetStarAdd(getDataAndCfg_upvr_result2.Speed, var78) * 100)).."%%"})
		else
			_______4['3'].Visible = false
		end
		if 0 < getDataAndCfg_upvr_result2.Gold then
			_______4['4'].Visible = true
			TranslationHelper_upvr.SetText(_______4['4'], "装备属性描述_金币加成", {(MathMgr_upvr.getNumStr(GetData_upvr.GetStarAdd(getDataAndCfg_upvr_result2.Gold, var78)) * 100).."%%"})
		else
			_______4['4'].Visible = false
		end
		local any_GetIsToolUsing_result1 = GetData_upvr.GetIsToolUsing(LocalPlayer_upvr, Value)
		Buttons["装备"].Visible = not any_GetIsToolUsing_result1
		Buttons["卸载"].Visible = any_GetIsToolUsing_result1
	else
		local NEVER_6 = _____________3:FindFirstChild(1)
		if NEVER_6 then
			NEVER_6.Visible = false
		end
		local NEVER_3 = _____________3:FindFirstChild(2)
		if NEVER_3 then
			NEVER_3.Visible = false
		end
		local NEVER_4 = _____________3:FindFirstChild(3)
		if NEVER_4 then
			NEVER_4.Visible = false
		end
		BG_upvr.Visible = false
		_______4.Visible = false
		ViewportFrame.Visible = false
		itemName.Text = ""
		Buttons.Visible = false
	end
end
AddListen_upvr.NumValueAdd(OnlyID_upvr, UpdateNowWeaponUI_upvr)
local function cancleAllPetDel_upvr() -- Line 263, Named "cancleAllPetDel"
	--[[ Upvalues[2]:
		[1]: tbl_upvw (read and write)
		[2]: ScrollPet_upvr (readonly)
	]]
	tbl_upvw = {}
	for _, v_2 in pairs(ScrollPet_upvr:GetChildren()) do
		if v_2:IsA("Frame") then
			local Del_3 = v_2.Frame.Del
			if Del_3 then
				Del_3.Visible = false
			end
		end
	end
end
AddListen_upvr.AddMouseCLick(_______5.Button, function() -- Line 275
	--[[ Upvalues[2]:
		[1]: HeroState_upvr (readonly)
		[2]: cancleAllPetDel_upvr (readonly)
	]]
	HeroState_upvr.Value = 2
	cancleAllPetDel_upvr()
end, _______5)
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
AddListen_upvr.AddMouseCLick(______.Button, function() -- Line 281
	--[[ Upvalues[4]:
		[1]: RemoteFunction_upvr (readonly)
		[2]: tbl_upvw (read and write)
		[3]: cancleAllPetDel_upvr (readonly)
		[4]: showLocalUI_upvr (readonly)
	]]
	showLocalUI_upvr:Fire("警告弹窗", {
		Tips = {"装备删除确认"};
		func = function() -- Line 286, Named "func"
			--[[ Upvalues[3]:
				[1]: RemoteFunction_upvr (copied, readonly)
				[2]: tbl_upvw (copied, read and write)
				[3]: cancleAllPetDel_upvr (copied, readonly)
			]]
			RemoteFunction_upvr:InvokeServer("删除装备", tbl_upvw)
			cancleAllPetDel_upvr()
		end;
	}, true)
end, ______)
AddListen_upvr.AddMouseCLick(_______2.Button, function() -- Line 294
	--[[ Upvalues[2]:
		[1]: cancleAllPetDel_upvr (readonly)
		[2]: HeroState_upvr (readonly)
	]]
	cancleAllPetDel_upvr()
	HeroState_upvr.Value = 0
end, _______2)
AddListen_upvr.AddMouseCLick(_______6.Button, function() -- Line 299
	--[[ Upvalues[2]:
		[1]: tbl_upvw (read and write)
		[2]: ScrollPet_upvr (readonly)
	]]
	tbl_upvw = {}
	for _, v_3 in pairs(ScrollPet_upvr:GetChildren()) do
		if v_3:IsA("Frame") then
			if tonumber(v_3.Name) then
				local Lock = v_3.Frame.Lock
				local Using_2 = v_3.Frame.Using
				if Lock and Lock.Visible == false and Using_2 and Using_2.Visible == false then
					local onlyID = v_3:FindFirstChild("onlyID")
					if onlyID and onlyID.Value then
						table.insert(tbl_upvw, onlyID.Value)
						local Del_2 = v_3.Frame.Del
						if Del_2 then
							Del_2.Visible = true
						end
					end
				end
			end
		end
	end
end, _______6)
AddListen_upvr.AddMouseCLick(____________.Button, function() -- Line 320
	--[[ Upvalues[1]:
		[1]: RemoteFunction_upvr (readonly)
	]]
	RemoteFunction_upvr:InvokeServer("解锁全部装备")
end, ____________)
local function updateUIByData() -- Line 324
	--[[ Upvalues[1]:
		[1]: HeroState_upvr (readonly)
	]]
	HeroState_upvr.Value = 0
end
AddListen_upvr.AddMouseCLick(_______7.Button, updateUIByData, _______7)
local LockEvent_upvr = ReplicatedStorage.ServerMsg.LockEvent
local Debris_upvr = game:GetService("Debris")
local function updateTempList_upvr(arg1, arg2, arg3, arg4) -- Line 330, Named "updateTempList"
	--[[ Upvalues[11]:
		[1]: OnlyID_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
		[4]: AddListen_upvr (readonly)
		[5]: _____________5_upvr (readonly)
		[6]: ___________________upvr_2 (readonly)
		[7]: HeroState_upvr (readonly)
		[8]: tbl_upvw (read and write)
		[9]: LockEvent_upvr (readonly)
		[10]: UIMgr_upvr (readonly)
		[11]: Debris_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var202
	if OnlyID_upvr then
		var202 = OnlyID_upvr
		if var202.Value == 0 then
			local Tool_0 = LocalPlayer_upvr:FindFirstChild("Tool_0")
			if Tool_0 then
				var202 = Tool_0.Value
				if var202 ~= 0 then
					var202 = OnlyID_upvr
					var202.Value = Tool_0.Value
					-- KONSTANTWARNING: GOTO [54] #38
				end
			end
			var202 = LocalPlayer_upvr:FindFirstChild("Tool_1")
			if var202 and var202.Value ~= 0 then
				OnlyID_upvr.Value = var202.Value
			else
				local Tool_2 = LocalPlayer_upvr:FindFirstChild("Tool_2")
				if Tool_2 and Tool_2.Value ~= 0 then
					OnlyID_upvr.Value = Tool_2.Value
				end
			end
		end
	end
	var202 = pairs(arg1:GetChildren())
	local pairs_result1_7, pairs_result2_11, pairs_result3_7 = pairs(arg1:GetChildren())
	for _, v_4 in pairs_result1_7, pairs_result2_11, pairs_result3_7 do
		if v_4:IsA("Frame") and v_4.Name ~= arg3.Name then
			v_4.Visible = false
			table.insert({}, v_4)
		end
	end
	pairs_result1_7 = 0
	for i_5, v_5 in pairs(arg2) do
		if 1 <= v_5.count then
			local var211_upvw
			if CfgFind_upvr.FindCfgByID(v_5.id, v_5.tp) then
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				var211_upvw = ({})[i_5]
				if not var211_upvw then
					var211_upvw = arg3:Clone()
					var211_upvw.Parent = arg1
				end
				var211_upvw.Name = v_5.onlyID
				if not var211_upvw:FindFirstChild("onlyID") then
					local NumberValue_upvw = Instance.new("NumberValue", var211_upvw)
					NumberValue_upvw.Name = "onlyID"
					AddListen_upvr.AddMouseCLick(var211_upvw.Button, function() -- Line 386
						--[[ Upvalues[8]:
							[1]: NumberValue_upvw (read and write)
							[2]: _____________5_upvr (copied, readonly)
							[3]: ___________________upvr_2 (copied, readonly)
							[4]: HeroState_upvr (copied, readonly)
							[5]: var211_upvw (read and write)
							[6]: tbl_upvw (copied, read and write)
							[7]: LockEvent_upvr (copied, readonly)
							[8]: OnlyID_upvr (copied, readonly)
						]]
						-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
						-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
						-- KONSTANTERROR: [8] 6. Error Block 41 start (CF ANALYSIS FAILED)
						for i_6 = 1, 5 do
							local SOME = ___________________upvr_2:FindFirstChild(i_6)
							if SOME.Value == 0 then
								SOME.Value = NumberValue_upvw.Value
								return
							end
						end
						do
							return
						end
						-- KONSTANTERROR: [8] 6. Error Block 41 end (CF ANALYSIS FAILED)
					end, var211_upvw.Frame)
				end
				NumberValue_upvw.Value = v_5.onlyID
				UIMgr_upvr.SetToolUI(var211_upvw, v_5)
				local Count_2 = var211_upvw.Frame:FindFirstChild("Count")
				if v_5.count and 0 < v_5.count then
					if Count_2 then
						Count_2.Text = 'x'..v_5.count
						Count_2.Visible = true
					end
					var211_upvw.Visible = true
				else
					if Count_2 then
						Count_2.Visible = false
					end
					var211_upvw.Visible = false
				end
				pairs_result1_7 += 1
			end
		end
	end
	local UIGridLayout = arg1.UIGridLayout
	local _ = math.floor(arg1.Size.X.Offset / UIGridLayout.CellSize.X.Offset)
	if not arg4 then
		local const_number_2 = 0
	end
	local var220
	if 0 < const_number_2 then
		if var220 <= const_number_2 then
			var220 = const_number_2
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		for _, v_6 in pairs({}) do
			if v_6.Visible == false then
				Debris_upvr:AddItem(v_6)
			end
		end
	end
	arg1.CanvasSize = UDim2.new(0, 0, 0, (UIGridLayout.CellSize.Y.Offset + UIGridLayout.CellPadding.Y.Offset) * var220)
end
local function updateUIPet_upvr(arg1) -- Line 506, Named "updateUIPet"
	--[[ Upvalues[4]:
		[1]: EnumMgr_upvr (readonly)
		[2]: Parent_upvr (readonly)
		[3]: GetData_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
	]]
	local var231
	for _, v_7 in pairs(arg1.Bag) do
		if v_7.tp == EnumMgr_upvr.ItemType.Tool then
			var231 += 1
		end
	end
	local PetSize = Parent_upvr.Frame.HeroUI.Pet.RightBG.PetSize
	PetSize.AutoLocalize = false
	PetSize.Text = var231..'/'..GetData_upvr.GetBagSize_Tool(LocalPlayer_upvr)
end
function updateUIByData(arg1) -- Line 529
	--[[ Upvalues[13]:
		[1]: EnumMgr_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: ___________________upvr (readonly)
		[4]: _____________5_upvr (readonly)
		[5]: 1_upvr (readonly)
		[6]: any_GetIns_result1_upvr_2 (readonly)
		[7]: any_GetIns_result1_upvr (readonly)
		[8]: ___________________upvr_2 (readonly)
		[9]: updateTempList_upvr (readonly)
		[10]: ScrollPet_upvr (readonly)
		[11]: Template_upvr (readonly)
		[12]: updateUIPet_upvr (readonly)
		[13]: UpdateNowWeaponUI_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1, pairs_result2_4, pairs_result3_8 = pairs(arg1.Bag)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [121] 80. Error Block 25 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [121] 80. Error Block 25 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [9] 7. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [121.8]
	-- KONSTANTERROR: [9] 7. Error Block 2 end (CF ANALYSIS FAILED)
end
local 1_upvr = ___________________upvr_2:FindFirstChild('1')
local var233_upvr = updateUIByData
AddListen_upvr.NumValueAdd(_____________5_upvr, function(arg1) -- Line 586
	--[[ Upvalues[10]:
		[1]: ShowDetail_upvr (readonly)
		[2]: cancleAllPetDel_upvr (readonly)
		[3]: HeroState_upvr (readonly)
		[4]: ___________________upvr_2 (readonly)
		[5]: _____________4_upvr (readonly)
		[6]: ______________________upvr (readonly)
		[7]: _____________upvr_2 (readonly)
		[8]: OtherUI_upvr (readonly)
		[9]: var20_upvw (read and write)
		[10]: var233_upvr (readonly)
	]]
	ShowDetail_upvr.HideAllDetail()
	cancleAllPetDel_upvr()
	HeroState_upvr.Value = 0
	for _, v_8 in pairs(___________________upvr_2:GetChildren()) do
		v_8.Value = 0
	end
	if arg1 == 0 then
		_____________4_upvr.Visible = true
		______________________upvr.Visible = true
		_____________upvr_2.Visible = false
		OtherUI_upvr.Visible = true
	else
		_____________4_upvr.Visible = false
		______________________upvr.Visible = false
		_____________upvr_2.Visible = true
		OtherUI_upvr.Visible = false
	end
	if var20_upvw then
		var233_upvr(var20_upvw)
	end
end)
AddListen_upvr.NumValueAdd(___________________upvr, function() -- Line 617
	--[[ Upvalues[2]:
		[1]: var20_upvw (read and write)
		[2]: var233_upvr (readonly)
	]]
	if var20_upvw then
		var233_upvr(var20_upvw)
	end
end)
local DelRedPoint_upvr = ReplicatedStorage.ServerMsg.DelRedPoint
function module_upvr.updateUi(arg1, arg2) -- Line 623
	--[[ Upvalues[3]:
		[1]: DelRedPoint_upvr (readonly)
		[2]: var20_upvw (read and write)
		[3]: var233_upvr (readonly)
	]]
	DelRedPoint_upvr:FireServer("装备红点")
	var20_upvw = arg2
	var233_upvr(var20_upvw)
end
local RemoteEvent_upvr = ReplicatedStorage.Msg.RemoteEvent
function module_upvr.openUi(arg1) -- Line 632
	--[[ Upvalues[4]:
		[1]: RemoteEvent_upvr (readonly)
		[2]: UIMgr_upvr (readonly)
		[3]: ShowDetail_upvr (readonly)
		[4]: cancleAllPetDel_upvr (readonly)
	]]
	RemoteEvent_upvr:FireServer("请求刷新数据")
	UIMgr_upvr.SetMainUIVisible(false)
	ShowDetail_upvr.HideAllDetail()
	cancleAllPetDel_upvr()
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 640
	--[[ Upvalues[5]:
		[1]: UIMgr_upvr (readonly)
		[2]: ShowDetail_upvr (readonly)
		[3]: cancleAllPetDel_upvr (readonly)
		[4]: HeroState_upvr (readonly)
		[5]: UIanima_upvr (readonly)
	]]
	UIMgr_upvr.SetMainUIVisible(true)
	ShowDetail_upvr.HideAllDetail()
	cancleAllPetDel_upvr()
	HeroState_upvr.Value = 0
	UIanima_upvr.PopBack(script.Parent)
end
for _, v_9_upvr in pairs(___________________upvr_2:GetChildren()) do
	local SOME_upvr = __________________:FindFirstChild(v_9_upvr.Name)
	AddListen_upvr.NumValueAdd(v_9_upvr, function(arg1) -- Line 653
		--[[ Upvalues[11]:
			[1]: ___________________upvr_2 (readonly)
			[2]: TranslationHelper_upvr (readonly)
			[3]: __________upvr (readonly)
			[4]: v_9_upvr (readonly)
			[5]: any_GetIns_result1_upvr (readonly)
			[6]: any_GetIns_result1_upvr_2 (readonly)
			[7]: SOME_upvr (readonly)
			[8]: var20_upvw (read and write)
			[9]: var233_upvr (readonly)
			[10]: GetData_upvr (readonly)
			[11]: UIMgr_upvr (readonly)
		]]
		local var264
		for _, v_10 in pairs(___________________upvr_2:GetChildren()) do
			if v_10.Value ~= 0 then
				var264 += 1
			end
		end
		TranslationHelper_upvr.SetText(__________upvr, "升星成功率", {(var264 * 20).."%%"})
		if arg1 == 0 then
			if v_9_upvr.Name == '1' then
				any_GetIns_result1_upvr.Value = 0
				any_GetIns_result1_upvr_2.Value = 0
				for i_12, v_11 in pairs(___________________upvr_2:GetChildren()) do
					v_11.Value = 0
				end
			end
			SOME_upvr.Frame.Visible = false
			SOME_upvr.Empty.Visible = true
			if var20_upvw then
				var233_upvr(var20_upvw)
			end
		else
			local any_getDataAndCfg_result1, _ = GetData_upvr.getDataAndCfg(arg1)
			if any_getDataAndCfg_result1 then
				i_12 = v_9_upvr
				if i_12.Name == '1' then
					local var271 = 1
					i_12 = any_getDataAndCfg_result1.lv
					if i_12 then
						var271 = any_getDataAndCfg_result1.lv
					end
					i_12 = any_GetIns_result1_upvr
					i_12.Value = var271
					i_12 = any_GetIns_result1_upvr_2
					any_GetIns_result1_upvr_2.Value = any_getDataAndCfg_result1.id
				end
				SOME_upvr.Frame.Visible = true
				SOME_upvr.Empty.Visible = false
				UIMgr_upvr.SetToolUI(SOME_upvr.Frame, any_getDataAndCfg_result1)
			else
				if v_9_upvr.Name == '1' then
					any_GetIns_result1_upvr.Value = 0
					any_GetIns_result1_upvr_2.Value = 0
				end
				SOME_upvr.Frame.Visible = false
				SOME_upvr.Empty.Visible = true
			end
			if var20_upvw then
				var233_upvr(var20_upvw)
			end
		end
	end)
end
AddListen_upvr.AddMouseCLick(Button, function() -- Line 718
	--[[ Upvalues[2]:
		[1]: ___________________upvr_2 (readonly)
		[2]: RemoteFunction_upvr (readonly)
	]]
	for i_13 = 1, 5 do
		local SOME_2 = ___________________upvr_2:FindFirstChild(i_13)
		if SOME_2.Value ~= 0 then
			table.insert({}, SOME_2.Value)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	RemoteFunction_upvr:InvokeServer("合成装备", {})
	for _, v_12 in pairs(___________________upvr_2:GetChildren()) do
		v_12.Value = 0
	end
end, Button.Parent)
return module_upvr