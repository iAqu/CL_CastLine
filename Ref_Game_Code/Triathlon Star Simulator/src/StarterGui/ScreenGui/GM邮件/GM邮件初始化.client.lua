-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:20
-- Luau version 6, Types version 3
-- Time taken: 0.004776 seconds

local ReplicatedStorage = game.ReplicatedStorage
local ______Ui_upvr = ReplicatedStorage.UI["奖励Ui"]
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local EnumMgr = require(ReplicatedStorage.Tool.EnumMgr)
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local ScorllTemp = script.Parent.ScorllTemp
local tbl_2_upvr = {}
local tbl_upvw = {}
local tbl_upvw_2 = {}
local _____________upvr = script.Parent.Frame.Frame["奖励内容"]
local function updateAwardList_upvr() -- Line 41, Named "updateAwardList"
	--[[ Upvalues[5]:
		[1]: _____________upvr (readonly)
		[2]: tbl_upvw (read and write)
		[3]: tbl_upvw_2 (read and write)
		[4]: ______Ui_upvr (readonly)
		[5]: UIMgr_upvr (readonly)
	]]
	for _, v in pairs(_____________upvr:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	for i_2, v_2 in pairs(tbl_upvw) do
		local clone_2 = ______Ui_upvr:Clone()
		clone_2.Parent = _____________upvr
		UIMgr_upvr.SetAward(clone_2, v_2, tbl_upvw_2[i_2])
	end
end
local ____________ = script.Parent.Frame["背包系统"]
local ________________upvr = ____________["一次加多少"]
local ______ID_upvr = ____________["道具ID"]
local nowSelectID_upvr = ____________.nowSelectID
______ID_upvr.InputEnded:Connect(function(arg1) -- Line 70
	--[[ Upvalues[2]:
		[1]: ______ID_upvr (readonly)
		[2]: nowSelectID_upvr (readonly)
	]]
	if tonumber(______ID_upvr.Text) then
		nowSelectID_upvr.Value = ______ID_upvr.Text
	end
end)
AddListen.AddMouseCLick(____________["加"], function() -- Line 79
	--[[ Upvalues[5]:
		[1]: ________________upvr (readonly)
		[2]: nowSelectID_upvr (readonly)
		[3]: tbl_upvw (read and write)
		[4]: tbl_upvw_2 (read and write)
		[5]: updateAwardList_upvr (readonly)
	]]
	local tonumber_result1 = tonumber(________________upvr.Text)
	if not tonumber_result1 then
	else
		if nowSelectID_upvr.Value == 0 then return end
		for i_7, v_7 in pairs(tbl_upvw) do
			if v_7 == nowSelectID_upvr.Value then
				tbl_upvw_2[i_7] += tonumber_result1
				updateAwardList_upvr()
				return
			end
		end
		table.insert(tbl_upvw, nowSelectID_upvr.Value)
		table.insert(tbl_upvw_2, tonumber_result1)
		updateAwardList_upvr()
	end
end)
AddListen.AddMouseCLick(____________["减"], function() -- Line 100
	--[[ Upvalues[5]:
		[1]: ________________upvr (readonly)
		[2]: nowSelectID_upvr (readonly)
		[3]: tbl_upvw (read and write)
		[4]: tbl_upvw_2 (read and write)
		[5]: updateAwardList_upvr (readonly)
	]]
	local tonumber_result1_2 = tonumber(________________upvr.Text)
	if not tonumber_result1_2 then
	else
		if nowSelectID_upvr.Value == 0 then return end
		for i_8, v_8 in pairs(tbl_upvw) do
			if v_8 == nowSelectID_upvr.Value then
				tbl_upvw_2[i_8] -= tonumber_result1_2
				if tbl_upvw_2[i_8] <= 0 then
					table.remove(tbl_upvw, i_8)
					table.remove(tbl_upvw_2, i_8)
				end
				updateAwardList_upvr()
				return
			end
		end
	end
end)
updateAwardList_upvr()
local ______Ui_upvr_2 = ____________["奖励Ui"]
AddListen.NumValueAdd(nowSelectID_upvr, function() -- Line 127
	--[[ Upvalues[4]:
		[1]: UIMgr_upvr (readonly)
		[2]: ______Ui_upvr_2 (readonly)
		[3]: nowSelectID_upvr (readonly)
		[4]: ______ID_upvr (readonly)
	]]
	UIMgr_upvr.SetAward(______Ui_upvr_2, nowSelectID_upvr.Value, 1)
	______ID_upvr.Text = nowSelectID_upvr.Value
end)
for i_3_upvr, v_3 in pairs({EnumMgr.ItemType.Item, EnumMgr.ItemType.Tool, EnumMgr.ItemType.Hero, EnumMgr.ItemType.GamePass}) do
	local TextButton_2 = Instance.new("TextButton")
	TextButton_2.Parent = script.Parent.ScorllItem
	TextButton_2.Text = ({"Item", "Tool", "Hero", "GamePass"})[i_3_upvr]
	TextButton_2.TextScaled = true
	AddListen.AddMouseCLick(TextButton_2, function() -- Line 140
		--[[ Upvalues[2]:
			[1]: tbl_2_upvr (readonly)
			[2]: i_3_upvr (readonly)
		]]
		for _, v_4 in pairs(tbl_2_upvr) do
			v_4.Visible = false
		end
		tbl_2_upvr[i_3_upvr].Visible = true
	end)
	local clone = ScorllTemp:Clone()
	clone.Parent = script.Parent
	clone.Name = "Scroll"..v_3
	local var64
	if v_3 == var64 then
		var64 = true
		clone.Visible = var64
	end
	var64 = 0
	for i_5_upvr, _ in pairs(require(ReplicatedStorage.Tool.CfgFind).GetAllCfgByTp(v_3)) do
		local clone_3 = ______Ui_upvr:Clone()
		clone_3.Parent = clone
		clone_3:SetAttribute("ID", i_5_upvr)
		if v_3 == EnumMgr.ItemType.Item then
			clone_3.LayoutOrder = i_5_upvr
		else
			clone_3.LayoutOrder = 100000000 - i_5_upvr
		end
		local TextButton = Instance.new("TextButton", clone_3)
		TextButton.Text = ""
		TextButton.Transparency = 1
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		AddListen.AddMouseCLick(TextButton, function() -- Line 179
			--[[ Upvalues[2]:
				[1]: nowSelectID_upvr (readonly)
				[2]: i_5_upvr (readonly)
			]]
			nowSelectID_upvr.Value = i_5_upvr
		end)
		UIMgr_upvr.SetAward(clone_3, i_5_upvr, 1)
		var64 += 1
	end
	clone.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(var64 / 7) + 1) * 205)
	table.insert(tbl_2_upvr, clone)
end
ScorllTemp:Destroy()
updateAwardList_upvr()
AddListen.AddMouseCLick(script.Parent.Frame["清空奖励"], function() -- Line 216
	--[[ Upvalues[3]:
		[1]: tbl_upvw (read and write)
		[2]: tbl_upvw_2 (read and write)
		[3]: updateAwardList_upvr (readonly)
	]]
	tbl_upvw = {}
	tbl_upvw_2 = {}
	updateAwardList_upvr()
end)
local Frame_upvr = script.Parent.Frame.Frame
local Log_upvr = require(ReplicatedStorage.Tool.Log)
local GM_______upvr = ReplicatedStorage["测试消息"]["GM邮件"]
AddListen.AddMouseCLick(script.Parent.Frame["发送邮件"], function() -- Line 229
	--[[ Upvalues[5]:
		[1]: tbl_upvw (read and write)
		[2]: tbl_upvw_2 (read and write)
		[3]: Frame_upvr (readonly)
		[4]: Log_upvr (readonly)
		[5]: GM_______upvr (readonly)
	]]
	local tbl_3 = {
		RewardID = tbl_upvw;
		RewardCount = tbl_upvw_2;
		UserID = nil;
		Des = "";
	}
	for _, v_6 in pairs(Frame_upvr:GetChildren()) do
		if v_6.Name == "玩家ID" then
			local TextBox = v_6.TextBox
			if TextBox.Text ~= "" and tonumber(TextBox.Text) then
				tbl_3.UserID = tonumber(TextBox.Text)
			end
		end
		if v_6.Name == "邮件内容" then
			local TextBox_2 = v_6.TextBox
			if TextBox_2.Text ~= "" and tostring(TextBox_2.Text) then
				tbl_3.Des = tostring(TextBox_2.Text)
			end
		end
	end
	if tbl_3.UserID == nil then
		Log_upvr.print("用户ID为空")
	else
		GM_______upvr:InvokeServer("发送邮件", tbl_3)
	end
end)