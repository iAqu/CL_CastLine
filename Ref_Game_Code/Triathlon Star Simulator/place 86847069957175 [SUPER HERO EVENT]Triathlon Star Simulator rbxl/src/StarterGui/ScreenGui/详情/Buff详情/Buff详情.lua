-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:27:20
-- Luau version 6, Types version 3
-- Time taken: 0.000670 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent
local CfgFind_upvr = require(ReplicatedStorage.Tool.CfgFind)
local TranslationHelper_upvr = require(ReplicatedStorage.Tool.TranslationHelper)
local ZhName_upvr = Parent.ZhName
local Des_upvr = Parent.Des
function module.ShowByData(arg1, arg2) -- Line 25
	--[[ Upvalues[4]:
		[1]: CfgFind_upvr (readonly)
		[2]: TranslationHelper_upvr (readonly)
		[3]: ZhName_upvr (readonly)
		[4]: Des_upvr (readonly)
	]]
	local any_GetCfgByNameAndID_result1 = CfgFind_upvr.GetCfgByNameAndID("buffdataConf", arg1[1])
	if not any_GetCfgByNameAndID_result1 then
	else
		TranslationHelper_upvr.SetText(ZhName_upvr, any_GetCfgByNameAndID_result1.ZhName)
		TranslationHelper_upvr.SetText(Des_upvr, any_GetCfgByNameAndID_result1.des, {tostring(any_GetCfgByNameAndID_result1.addPower)})
	end
end
return module