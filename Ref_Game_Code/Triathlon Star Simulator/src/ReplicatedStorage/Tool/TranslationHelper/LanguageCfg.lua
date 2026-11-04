-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:17
-- Luau version 6, Types version 3
-- Time taken: 0.004287 seconds

local module_upvr = {}
local Language = require(script.Parent.Language)
local tbl_upvr = {}
module_upvr.LocalID = "en-us"
local RunService = game:GetService("RunService")
if RunService:IsClient() then
	local SOME = game:GetService("ReplicatedStorage")["游戏全局配置"]["翻译设置"]:FindFirstChild(game.Players.LocalPlayer.Name)
	local var18
	if SOME and RunService:IsStudio() then
		if SOME["强制中文"].Value == true then
			module_upvr.LocalID = "zh-cn"
			var18 = true
		end
		if SOME["强制英文"].Value == true then
			module_upvr.LocalID = "en-us"
			var18 = true
		end
	end
	if var18 == false then
		module_upvr.LocalID = game.Players.LocalPlayer.LocaleId
	end
end
for i, v in pairs(Language) do
	if i ~= "key" then
		for i_2, v_2 in pairs(v) do
			tbl_upvr[i_2] = {}
			for i_3, v_3 in pairs(v_2) do
				if i ~= "key" then
					({})[tostring(Language.key[i][i_3])] = v_3
				end
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			tbl_upvr[i_2] = {}
		end
	end
end
Language.key = nil
Language.LocalizationTableConf = nil
function module_upvr.FormatByKey(arg1, arg2) -- Line 63
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var92 = tbl_upvr[arg1]
	if not var92 then
		return "未本地化-"..arg1, true
	end
	if var92[module_upvr.LocalID] then
		if arg2 then
			local _ = 1
			for _, _ in pairs(arg2) do
				local var97
			end
			return var97, false
		end
		return var92[module_upvr.LocalID], false
	end
	if module_upvr.LocalID == "zh-tw" then
		local var98
		if var98 then
			if arg2 then
				var98 = ""
				for _, v_5 in pairs(arg2) do
					var98 = string.gsub(var92["zh-cn"], '{'..1..'}', v_5)
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					local var102
				end
				return var98, false
			end
			var98 = var92["zh-cn"]
			do
				return var98, false
			end
			local var103
		end
	end
	if arg2 then
		var103 = ""
		for _, v_6 in pairs(arg2) do
			var103 = string.gsub(var92["en-us"], '{'..1..'}', v_6)
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			local var107
		end
		return var103, true
	end
	return var92["en-us"], true
end
return module_upvr