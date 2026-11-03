-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:27
-- Luau version 6, Types version 3
-- Time taken: 0.004207 seconds

local module_upvr = {
	info = function(...) -- Line 4, Named "info"
		local var10
		for _, v in pairs({...}) do
			if type(v) == "string" then
				var10 = var10..v
			else
				var10 = var10..(tostring(v) or "nil")
			end
		end
		return string.format("[%s:%s:%s] -> [%s:%s:%s] : %s", debug.info(3, 's') or ".?":match("%.([%a%d _-]*)$") or '?', debug.info(3, 'n') or '?', debug.info(3, 'l') or '?', debug.info(2, 's') or ".?":match("%.([%a%d _-]*)$") or '?', debug.info(2, 'n') or '?', debug.info(2, 'l') or '?', var10)
	end;
	printl = function(...) -- Line 27, Named "printl"
		print((debug.info(2, 'l') or '?')..':', unpack({...}))
	end;
}
local function outputContent_upvr(arg1, ...) -- Line 33, Named "outputContent"
	local func_source = debug.info(3, 's')
	if not func_source then
		func_source = {}
		func_source[1] = "Unidentified Script"
	end
	local string_split_result1 = string.split(func_source, '.')
	arg1('['..string_split_result1[#string_split_result1]..'/'..(debug.info(3, 'n') or "Unidentified Function").."](Ln. "..(debug.info(3, 'l') or '?')..')', ...)
end
function module_upvr.printcontext(...) -- Line 42
	--[[ Upvalues[1]:
		[1]: outputContent_upvr (readonly)
	]]
	outputContent_upvr(print, ...)
end
function module_upvr.warncontext(...) -- Line 45
	--[[ Upvalues[1]:
		[1]: outputContent_upvr (readonly)
	]]
	outputContent_upvr(warn, ...)
end
function module_upvr.pcall(...) -- Line 49
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local pcall_result1, pcall_result2 = pcall(...)
	if not pcall_result1 then
		module_upvr.warn(pcall_result2)
		return false
	end
	return pcall_result2
end
function module_upvr.Get() -- Line 55
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.print, module_upvr.warn
end
function module_upvr.Part(arg1, arg2, arg3, arg4) -- Line 59
	local Part_2_upvr = Instance.new("Part")
	Part_2_upvr.Transparency = 0.5
	local var17
	if not var17 then
		var17 = Color3.new(1, 0, 0)
	end
	Part_2_upvr.Color = var17
	Part_2_upvr.Size = arg2
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var17 = arg1
		return var17
	end
	if typeof(arg1) ~= "CFrame" or not INLINED() then
		var17 = CFrame.new(arg1)
	end
	Part_2_upvr.CFrame = var17
	var17 = false
	Part_2_upvr.CanCollide = var17
	var17 = true
	Part_2_upvr.Anchored = var17
	var17 = "DamagedPart"
	Part_2_upvr.Name = var17
	var17 = workspace.Ignore
	Part_2_upvr.Parent = var17
	var17 = task.defer
	var17(function() -- Line 70
		--[[ Upvalues[2]:
			[1]: arg4 (readonly)
			[2]: Part_2_upvr (readonly)
		]]
		task.wait(arg4 or 1)
		Part_2_upvr:Destroy()
	end)
	return Part_2_upvr
end
function module_upvr.Line(arg1, arg2, arg3, arg4, arg5) -- Line 78
	local var19 = arg3 or 0.1
	local Part_3_upvr = Instance.new("Part")
	Part_3_upvr.Transparency = 0.5
	local var21 = arg4
	if not var21 then
		var21 = Color3.new(1, 0, 0)
	end
	Part_3_upvr.Color = var21
	Part_3_upvr.Size = Vector3.new(var19, var19, (arg1 - arg2).Magnitude)
	Part_3_upvr.CFrame = CFrame.new((arg1 + arg2) / 2, arg2)
	Part_3_upvr.CanCollide = false
	Part_3_upvr.Anchored = true
	Part_3_upvr.Name = "DamagedPart"
	Part_3_upvr.Parent = workspace.Ignore
	task.defer(function() -- Line 90
		--[[ Upvalues[2]:
			[1]: arg5 (readonly)
			[2]: Part_3_upvr (readonly)
		]]
		task.wait(arg5 or 1)
		Part_3_upvr:Destroy()
	end)
	return Part_3_upvr
end
return module_upvr