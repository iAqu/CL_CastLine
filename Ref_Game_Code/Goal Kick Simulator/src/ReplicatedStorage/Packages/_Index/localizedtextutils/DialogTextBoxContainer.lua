-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:34
-- Luau version 6, Types version 3
-- Time taken: 0.001317 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("DialogPromptContainerBase")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "DialogTextBoxContainer"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2) -- Line 14
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(arg2), setmetatable_result1_2_upvr)
	setmetatable_result1._serviceBag = assert(arg1, "No serviceBag")
	return setmetatable_result1
end
local any_load_result1_result1_upvr = any_load_result1("DialogTextBoxPane")
function setmetatable_result1_2_upvr.BuildPrompt(arg1, arg2, arg3, arg4) -- Line 22
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var6
	if type(arg3) ~= "table" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad textBoxOptions")
	if typeof(arg4) ~= "Color3" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad accentColor")
	var6 = any_load_result1_result1_upvr
	var6 = arg1._serviceBag
	return var6.new(var6, arg3, arg1._dialogInput)
end
return setmetatable_result1_2_upvr