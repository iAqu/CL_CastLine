-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:38
-- Luau version 6, Types version 3
-- Time taken: 0.001944 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local LanguageCfg_upvr = require(ReplicatedStorage.Tool.TranslationHelper.LanguageCfg)
local Log_upvr = require(ReplicatedStorage.Tool.Log)
local PlayerGui_upvr = LocalPlayer_upvr.PlayerGui
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
LocalPlayer_upvr:GetPropertyChangedSignal("LocaleId"):Connect(function() -- Line 16, Named "OnLocaleIdChanged"
	--[[ Upvalues[5]:
		[1]: LanguageCfg_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: Log_upvr (readonly)
		[4]: PlayerGui_upvr (readonly)
		[5]: TranslationHelper_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	if LanguageCfg_upvr.LocalID == LocalPlayer_upvr.LocaleId then
	else
		LanguageCfg_upvr.LocalID = LocalPlayer_upvr.LocaleId
		Log_upvr.warn("===============切换了本地语言:", LanguageCfg_upvr.LocalID)
		for _, v in pairs(PlayerGui_upvr:GetDescendants()) do
			local var34
			local function INLINED() -- Internal function, doesn't exist in bytecode
				var34 = "代码本地化"
				return v:HasTag(var34)
			end
			if v:HasTag("本地化") or INLINED() then
				var34 = "_key"
				local _maxIndex = v:GetAttribute("_maxIndex")
				var34 = nil
				if _maxIndex then
					var34 = {}
					for i_2 = 1, _maxIndex do
						var34[i_2] = v:GetAttribute("_arg"..i_2)
						local var36
					end
				end
				TranslationHelper_upvr.SetText(v, v:GetAttribute(var34), var36)
			end
		end
		for _, v_2 in pairs(workspace:GetDescendants()) do
			local var40
			local function INLINED_2() -- Internal function, doesn't exist in bytecode
				var40 = "代码本地化"
				return v_2:HasTag(var40)
			end
			if v_2:HasTag("本地化") or INLINED_2() then
				var40 = "_key"
				local _maxIndex_2 = v_2:GetAttribute("_maxIndex")
				var40 = nil
				if _maxIndex_2 then
					var40 = {}
					for i_4 = 1, _maxIndex_2 do
						var40[i_4] = v_2:GetAttribute("_arg"..i_4)
						local var42
					end
				end
				TranslationHelper_upvr.SetText(v_2, v_2:GetAttribute(var40), var42)
			end
		end
	end
end)