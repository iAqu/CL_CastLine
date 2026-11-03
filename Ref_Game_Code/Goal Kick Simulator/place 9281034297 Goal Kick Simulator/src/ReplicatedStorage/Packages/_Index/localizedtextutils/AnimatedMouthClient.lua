-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:22
-- Luau version 6, Types version 3
-- Time taken: 0.001682 seconds

local var1_upvr = require(script.Parent.loader).load(script)("BaseObject")
local tbl_upvr = {
	a = "rbxassetid://176217393";
	b = "rbxassetid://176217905";
	c = "rbxassetid://176217403";
	d = "rbxassetid://176217403";
	e = "rbxassetid://176217403";
	f = "rbxassetid://176217449";
	g = "rbxassetid://176217403";
	h = "rbxassetid://176217393";
	i = "rbxassetid://176217431";
	j = "rbxassetid://176217403";
	k = "rbxassetid://176217403";
	l = "rbxassetid://176217878";
	m = "rbxassetid://176217905";
	n = "rbxassetid://176217403";
	o = "rbxassetid://176217891";
	p = "rbxassetid://176217403";
	q = "rbxassetid://176217431";
	r = "rbxassetid://176217891";
	s = "rbxassetid://176217403";
	t = "rbxassetid://176217403";
	u = "rbxassetid://176217891";
	v = "rbxassetid://176217449";
	w = "rbxassetid://176217891";
	x = "rbxassetid://176217393";
	y = "rbxassetid://176217403";
	z = "rbxassetid://176217403";
	[' '] = "rbxassetid://176217905";
	[','] = "rbxassetid://176217905";
	['.'] = "rbxassetid://176217905";
	['!'] = "rbxassetid://176217905";
	['?'] = "rbxassetid://176217905";
}
local setmetatable_result1_2_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_2_upvr.ClassName = "AnimatedMouth"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1) -- Line 52
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_upvr.new(arg1), setmetatable_result1_2_upvr)
	setmetatable_result1._maid:GiveTask(setmetatable_result1._obj)
	setmetatable_result1:Close()
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.Close(arg1) -- Line 61
	arg1._obj.Texture = "rbxassetid://176217905"
end
function setmetatable_result1_2_upvr.EnumerateTextStep(arg1, arg2, arg3, arg4, arg5) -- Line 65
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local _ = arg5
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [32] 28. Error Block 7 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [32] 28. Error Block 7 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [4] 5. Error Block 11 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [32.8]
	if nil then
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [32.11]
		if nil then
			-- KONSTANTWARNING: GOTO [32] #28
		end
	else
	end
	-- KONSTANTERROR: [4] 5. Error Block 11 end (CF ANALYSIS FAILED)
end
function setmetatable_result1_2_upvr.Enumerate(arg1, arg2) -- Line 87
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var6
	if type(arg2) ~= "string" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad character")
	var6 = tbl_upvr
	local var7 = var6[arg2:lower()]
	if not var7 then
		var6 = false
		return var6
	end
	var6 = arg1._obj
	var6.Texture = var7
	var6 = true
	return var6
end
return setmetatable_result1_2_upvr