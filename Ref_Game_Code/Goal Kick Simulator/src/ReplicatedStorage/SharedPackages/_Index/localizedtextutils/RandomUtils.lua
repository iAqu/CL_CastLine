-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:35
-- Luau version 6, Types version 3
-- Time taken: 0.003015 seconds

local module_2_upvr = {
	choice = function(arg1, arg2) -- Line 37, Named "choice"
		if #arg1 == 0 then
			return nil
		end
		if #arg1 == 1 then
			return arg1[1]
		end
		if arg2 then
			return arg1[arg2:NextInteger(1, #arg1)]
		end
		return arg1[math.random(1, #arg1)]
	end;
}
function module_2_upvr.shuffledCopy(arg1, arg2) -- Line 66
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local module = {}
	for i = 1, #arg1 do
		module[i] = arg1[i]
	end
	module_2_upvr.shuffle(module, arg2)
	return module
end
function module_2_upvr.shuffle(arg1, arg2) -- Line 94
	if arg2 then
		for i_2 = #arg1, 2, -1 do
			local any_NextInteger_result1 = arg2:NextInteger(1, i_2)
			arg1[i_2] = arg1[any_NextInteger_result1]
			arg1[any_NextInteger_result1] = arg1[i_2]
		end
	else
		for var6 = #arg1, 2, -1 do
			local randint_from_1 = math.random(var6)
			arg1[var6] = arg1[randint_from_1]
			arg1[randint_from_1] = arg1[var6]
		end
	end
end
function module_2_upvr.weightedChoice(arg1, arg2, arg3) -- Line 129
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var17
	if var17 == 0 then
		var17 = nil
		return var17
	end
	var17 = #arg1
	if var17 == 1 then
		var17 = arg1[1]
		return var17
	end
	var17 = 0
	for i_3 = 1, #arg1 do
		local var18
		if type(arg2[i_3]) ~= "number" then
			var18 = false
		else
			var18 = true
		end
		assert(var18, "Bad weights")
		var17 += arg2[i_3]
	end
	if arg3 then
	else
	end
	for i_4 = 1, #arg1 do
		if math.random() <= (0 + arg2[i_4]) / var17 then
			return arg1[i_4]
		end
	end
	warn("[RandomUtils.weightedChoice] - Failed to reach threshold! Algorithm is wrong!")
	return arg1[#arg1]
end
function module_2_upvr.gaussianRandom(arg1) -- Line 170
	local var19
	local var20
	if arg1 then
		var19 = (-math.pi*2) * arg1:NextNumber()
		var20 = arg1:NextNumber()
	else
		var19 = (-math.pi*2) * math.random()
		var20 = math.random()
	end
	return math.sqrt(math.log(1 - var20) * -2) * math.cos(var19)
end
function module_2_upvr.randomUnitVector3(arg1) -- Line 187
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return Vector3.new(module_2_upvr.gaussianRandom(arg1), module_2_upvr.gaussianRandom(arg1), module_2_upvr.gaussianRandom(arg1))
end
return module_2_upvr