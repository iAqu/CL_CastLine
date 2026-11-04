-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:07
-- Luau version 6, Types version 3
-- Time taken: 0.001791 seconds

local Parent_upvr = script.Parent.Parent.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddListen_upvr = require(ReplicatedStorage.Tool.AddListen)
local Record_upvr = game:GetService("Players").LocalPlayer:WaitForChild("Record", math.huge)
local showLocalUI_upvr = ReplicatedStorage.LocalMsg.showLocalUI
AddListen_upvr.AddMouseCLick(Parent_upvr.Button, function() -- Line 16
	--[[ Upvalues[1]:
		[1]: showLocalUI_upvr (readonly)
	]]
	showLocalUI_upvr:Fire("章节礼包", nil, true)
end, Parent_upvr.Frame, "音效-场景-点击-通用点击")
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local function UpdateUI_upvr(arg1) -- Line 23, Named "UpdateUI"
	--[[ Upvalues[4]:
		[1]: Record_upvr (readonly)
		[2]: CfgFind_upvr (readonly)
		[3]: TranslationHelper_upvr (readonly)
		[4]: Parent_upvr (readonly)
	]]
	local SOME = Record_upvr:FindFirstChild("WorldPack"..arg1)
	if SOME and SOME.Value == 0 then
		local any_FindCfgByOnlyTag_result1_2 = CfgFind_upvr.FindCfgByOnlyTag("WorldPack"..arg1)
		if any_FindCfgByOnlyTag_result1_2 then
			TranslationHelper_upvr.SetText(Parent_upvr.Frame["章节礼包"], any_FindCfgByOnlyTag_result1_2.ZhName)
			if any_FindCfgByOnlyTag_result1_2.Icon then
				Parent_upvr.Frame.icon.Image = "rbxassetid://"..any_FindCfgByOnlyTag_result1_2.Icon
			end
		end
		Parent_upvr.Visible = true
	else
		Parent_upvr.Visible = false
	end
end
local tbl_upvr = {}
;(function(arg1) -- Line 54, Named "BindEvent"
	--[[ Upvalues[4]:
		[1]: tbl_upvr (readonly)
		[2]: Record_upvr (readonly)
		[3]: AddListen_upvr (readonly)
		[4]: UpdateUI_upvr (readonly)
	]]
	for i, _ in pairs(tbl_upvr) do
		tbl_upvr[i]:Disconnect()
		tbl_upvr[i] = nil
	end
	local SOME_2 = Record_upvr:FindFirstChild("WorldPack"..arg1)
	if SOME_2 then
		table.insert(tbl_upvr, AddListen_upvr.NumValueAdd(SOME_2, function(arg1_2) -- Line 64
			--[[ Upvalues[2]:
				[1]: UpdateUI_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			UpdateUI_upvr(arg1)
		end))
	end
end)(1)
UpdateUI_upvr(1)