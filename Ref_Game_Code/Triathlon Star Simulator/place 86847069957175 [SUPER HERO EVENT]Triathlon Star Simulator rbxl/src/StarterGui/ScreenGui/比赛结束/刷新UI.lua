-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:56
-- Luau version 6, Types version 3
-- Time taken: 0.003807 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlaySoundModule_upvr = require(ReplicatedStorage.Tool.PlaySoundModule)
local Parent = script.Parent
local AddListen = require(ReplicatedStorage.Tool.AddListen)
local ______ = Parent.Frame.Window["确认"]
AddListen.AddMouseCLick(______.Button, function() -- Line 24
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, ______)
local Button = script.Parent.BG.Exit.Button
AddListen.AddMouseCLick(Button, function() -- Line 30
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, Button.Parent)
local ScrollingFrame_upvr = Parent.Frame.Window.ScrollingFrame
local Debris_upvr = game:GetService("Debris")
local Temp_upvr = ScrollingFrame_upvr.Temp
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local _____________upvr = Parent.Frame.Window["跑了多远"]
local MathMgr_upvr = require(ReplicatedStorage.Tool.MathMgr)
local any_GetRoadCfg_result1_upvr = require(ReplicatedStorage.Tool.CfgFind).GetRoadCfg()
local ________________upvr = Parent.Frame.Window["完成百分比"]
local __________upvr = Parent.Frame.Window["新记录"]
local __________upvr_2 = Parent.Frame.Window["好成绩"]
function module_upvr.updateUi(arg1, arg2) -- Line 64
	--[[ Upvalues[12]:
		[1]: ScrollingFrame_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: Temp_upvr (readonly)
		[4]: UIMgr_upvr (readonly)
		[5]: TranslationHelper_upvr (readonly)
		[6]: _____________upvr (readonly)
		[7]: MathMgr_upvr (readonly)
		[8]: any_GetRoadCfg_result1_upvr (readonly)
		[9]: ________________upvr (readonly)
		[10]: __________upvr (readonly)
		[11]: __________upvr_2 (readonly)
		[12]: PlaySoundModule_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local isNew = arg2.isNew
	local tbl = {}
	local _, pairs_result2_2, pairs_result3_2 = pairs(arg2.AwardID)
	local var50
	for i, v in var50, pairs_result2_2, pairs_result3_2 do
		if tbl[tostring(v)] then
			tbl[tostring(v)] += tonumber(arg2.Count[i])
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			tbl[tostring(v)] = tonumber(arg2.Count[i])
		end
	end
	var50 = pairs(ScrollingFrame_upvr:GetChildren())
	local pairs_result1, pairs_result2_3, pairs_result3_3 = pairs(ScrollingFrame_upvr:GetChildren())
	for _, v_2 in pairs_result1, pairs_result2_3, pairs_result3_3 do
		if v_2:IsA("Frame") and v_2.Name ~= "Temp" then
			Debris_upvr:AddItem(v_2, 0)
		end
	end
	pairs_result1 = 0
	for i_3, v_3 in pairs(tbl) do
		local floored = math.floor(v_3)
		local clone = Temp_upvr:Clone()
		clone.Name = i_3
		clone.Parent = ScrollingFrame_upvr
		clone.Visible = true
		UIMgr_upvr.SetAward(clone, tonumber(i_3), floored)
		pairs_result1 = pairs_result1 + ScrollingFrame_upvr.Size.Y.Offset + ScrollingFrame_upvr.UIListLayout.Padding.Offset
	end
	ScrollingFrame_upvr.CanvasSize = UDim2.new(0, pairs_result1, 0, 0)
	TranslationHelper_upvr.SetText(_____________upvr, "跑了多少米远", {MathMgr_upvr.getNumStr(arg2.Result)})
	local pairs_result1_2, pairs_result2, pairs_result3 = pairs(any_GetRoadCfg_result1_upvr)
	if floored.num * 100 < arg2.Result then
		-- KONSTANTWARNING: GOTO [158] #117
	end
	TranslationHelper_upvr.SetText(________________upvr, "跑了多少百分比远", {MathMgr_upvr.getNumStr(0 + floored.Pecent).."%%"})
	__________upvr.Visible = isNew
	__________upvr_2.Visible = not isNew
	if isNew then
		PlaySoundModule_upvr.playSound({
			SoundName = "音效-比赛-新里程碑";
		})
	end
end
local AutoMatch_upvr = game.Players.LocalPlayer:WaitForChild("Setting", math.huge):WaitForChild("AutoMatch", math.huge)
function module_upvr.openUi(arg1) -- Line 137
	--[[ Upvalues[3]:
		[1]: AutoMatch_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: PlaySoundModule_upvr (readonly)
	]]
	if AutoMatch_upvr.Value == 1 then
		delay(5, function() -- Line 140
			--[[ Upvalues[1]:
				[1]: module_upvr (copied, readonly)
			]]
			module_upvr:closeUi()
		end)
	end
	PlaySoundModule_upvr.playSound({
		SoundName = "音效-比赛-结算";
	})
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 150
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr