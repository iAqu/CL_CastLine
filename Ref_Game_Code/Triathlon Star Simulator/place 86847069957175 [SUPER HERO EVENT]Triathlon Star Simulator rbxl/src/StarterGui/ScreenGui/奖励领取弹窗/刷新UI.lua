-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:48
-- Luau version 6, Types version 3
-- Time taken: 0.002411 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent
local ______ = Parent.Frame["确认"]
require(ReplicatedStorage.Tool.AddListen).AddMouseCLick(______.Button, function() -- Line 24
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr:closeUi()
end, ______)
local ScrollingFrame_upvr = Parent.Frame.ScrollingFrame
local Debris_upvr = game:GetService("Debris")
local Temp_upvr = ScrollingFrame_upvr.Temp
local UIMgr_upvr = require(ReplicatedStorage.Tool.UIMgr)
local Tips_upvr = Parent.Frame.Tips
function module_upvr.updateUi(arg1, arg2) -- Line 42
	--[[ Upvalues[5]:
		[1]: ScrollingFrame_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: Temp_upvr (readonly)
		[4]: UIMgr_upvr (readonly)
		[5]: Tips_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local tbl = {}
	local _, pairs_result2, pairs_result3_2 = pairs(arg2.AwardID)
	local var39
	for i, v in var39, pairs_result2, pairs_result3_2 do
		if tbl[tostring(v)] then
			tbl[tostring(v)] += tonumber(arg2.Count[i])
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			tbl[tostring(v)] = tonumber(arg2.Count[i])
		end
	end
	var39 = pairs(ScrollingFrame_upvr:GetChildren())
	local pairs_result1_2, pairs_result2_3, pairs_result3 = pairs(ScrollingFrame_upvr:GetChildren())
	for _, v_2 in pairs_result1_2, pairs_result2_3, pairs_result3 do
		if v_2:IsA("Frame") then
			Debris_upvr:AddItem(v_2, 0)
		end
	end
	pairs_result1_2 = 0
	for i_3, v_3 in pairs(tbl) do
		local clone = Temp_upvr:Clone()
		clone.Parent = ScrollingFrame_upvr
		UIMgr_upvr.SetAward(clone, tonumber(i_3), v_3)
		pairs_result1_2 = pairs_result1_2 + ScrollingFrame_upvr.Size.Y.Offset + ScrollingFrame_upvr.UIListLayout.Padding.Offset
	end
	ScrollingFrame_upvr.CanvasSize = UDim2.new(0, pairs_result1_2, 0, 0)
	Tips_upvr.Text = arg2.Tips
end
local PlaySoundModule_upvr = require(ReplicatedStorage.Tool.PlaySoundModule)
function module_upvr.openUi(arg1) -- Line 86
	--[[ Upvalues[1]:
		[1]: PlaySoundModule_upvr (readonly)
	]]
	PlaySoundModule_upvr.playSound({
		SoundName = "音效-场景-点击-通用获得";
	})
end
local UIanima_upvr = require(ReplicatedStorage.Tool.UIanima)
function module_upvr.closeUi(arg1) -- Line 92
	--[[ Upvalues[1]:
		[1]: UIanima_upvr (readonly)
	]]
	UIanima_upvr.PopBack(script.Parent)
end
return module_upvr