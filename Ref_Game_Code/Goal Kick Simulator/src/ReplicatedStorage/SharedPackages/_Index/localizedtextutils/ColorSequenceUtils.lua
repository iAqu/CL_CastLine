-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:24
-- Luau version 6, Types version 3
-- Time taken: 0.004099 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("Math")
function module.getColor(arg1, arg2) -- Line 21
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	local var5
	if typeof(arg1) ~= "ColorSequence" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad colorSequence")
	if type(arg2) ~= "number" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad t")
	local Keypoints = arg1.Keypoints
	var5 = Keypoints[1].Time
	if arg2 <= var5 then
		var5 = Keypoints[1].Value
		return var5
	end
	var5 = #Keypoints
	for i = 2, var5 do
		local var7 = Keypoints[i]
		if var7.Time >= arg2 then
			local var8 = Keypoints[i - 1]
			return var8.Value:Lerp(var7.Value, math.clamp(var2_upvr.map(arg2, var8.Time, var7.Time, 0, 1), 0, 1))
		end
	end
	var5 = Keypoints[#Keypoints].Value
	return var5
end
function module.stripe(arg1, arg2, arg3, arg4, arg5) -- Line 56
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	arg4 = math.clamp(arg4 or 0.5, 0, 1)
	local var17 = arg4
	if var17 <= 0.001 then
		return ColorSequence.new(arg2)
	end
	if 0.999 <= var17 then
		return ColorSequence.new(arg3)
	end
	local var18 = 1 / arg1
	local tbl = {}
	for i_2 = 0, arg1 - 1 do
		local var20 = (i_2 / arg1 + ((arg5 or 0) * var18 + var17 * var18 * 0.5) % var18) % 1
		table.insert(tbl, ColorSequenceKeypoint.new(var20, arg2))
		table.insert(tbl, ColorSequenceKeypoint.new((var20 + var18 * (1 - var17)) % 1, arg3))
		local _
	end
	table.sort(tbl, function(arg1_2, arg2_2) -- Line 81
		local var23
		if arg1_2.Time >= arg2_2.Time then
			var23 = false
		else
			var23 = true
		end
		return var23
	end)
	local module_2 = {}
	table.insert(module_2, tbl[1])
	for i_3 = 2, #tbl do
		local var25 = tbl[i_3 - 1]
		local var26 = tbl[i_3]
		if var25.Time < var26.Time - 0.001 then
			table.insert(module_2, ColorSequenceKeypoint.new(var26.Time - 0.001, var25.Value))
		end
		table.insert(module_2, var26)
	end
	local _1 = module_2[1]
	if 0.001 <= _1.Time then
		local var28
		if _1.Value == arg2 then
			var28 = arg3
		elseif _1.Value == arg3 then
			var28 = arg2
		else
			error("Bad comparison")
		end
		table.insert(module_2, 1, ColorSequenceKeypoint.new(_1.Time - 0.001, var28))
		table.insert(module_2, 1, ColorSequenceKeypoint.new(0, var28))
	else
		table.remove(module_2, 1)
		table.insert(module_2, 1, ColorSequenceKeypoint.new(0, _1.Value))
	end
	local var29 = module_2[#module_2]
	if var29.Time <= 0.999 then
		table.insert(module_2, ColorSequenceKeypoint.new(1, var29.Value))
	else
		table.remove(module_2)
		table.insert(module_2, ColorSequenceKeypoint.new(1, var29.Value))
	end
	return ColorSequence.new(module_2)
end
return module