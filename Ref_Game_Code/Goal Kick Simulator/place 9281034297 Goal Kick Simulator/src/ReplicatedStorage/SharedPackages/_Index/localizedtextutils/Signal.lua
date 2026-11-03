-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:55
-- Luau version 6, Types version 3
-- Time taken: 0.002277 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "Signal"
function module_upvr.isSignal(arg1) -- Line 46
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var2 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= module_upvr then
			var2 = false
		else
			var2 = true
		end
	end
	return var2
end
function module_upvr.new() -- Line 55
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable({}, module_upvr)
	setmetatable_result1_upvr._bindableEvent = Instance.new("BindableEvent")
	setmetatable_result1_upvr._argMap = {}
	setmetatable_result1_upvr._source = ""
	setmetatable_result1_upvr._bindableEvent.Event:Connect(function(arg1) -- Line 65
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr._argMap[arg1] = nil
		if not setmetatable_result1_upvr._bindableEvent and not next(setmetatable_result1_upvr._argMap) then
			setmetatable_result1_upvr._argMap = nil
		end
	end)
	return setmetatable_result1_upvr
end
local HttpService_upvr = game:GetService("HttpService")
function module_upvr.Fire(arg1, ...) -- Line 83
	--[[ Upvalues[1]:
		[1]: HttpService_upvr (readonly)
	]]
	if not arg1._bindableEvent then
		warn("Signal is already destroyed. %s":format(arg1._source))
	else
		local any_GenerateGUID_result1 = HttpService_upvr:GenerateGUID(false)
		arg1._argMap[any_GenerateGUID_result1] = table.pack(...)
		arg1._bindableEvent:Fire(any_GenerateGUID_result1)
	end
end
function module_upvr.Connect(arg1, arg2) -- Line 104
	if type(arg2) ~= "function" then
		error("connect(%s)":format(typeof(arg2)), 2)
	end
	return arg1._bindableEvent.Event:Connect(function(arg1_2) -- Line 109
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		local var8 = arg1._argMap[arg1_2]
		if var8 then
			arg2(table.unpack(var8, 1, var8.n))
		else
			error("Missing arg data, probably due to reentrance.")
		end
	end)
end
function module_upvr.Once(arg1, arg2) -- Line 127
	if type(arg2) ~= "function" then
		error("once(%s)":format(typeof(arg2)), 2)
	end
	return arg1._bindableEvent.Event:Once(function(arg1_3) -- Line 132
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		local var10 = arg1._argMap[arg1_3]
		if var10 then
			arg2(table.unpack(var10, 1, var10.n))
		else
			error("Missing arg data, probably due to reentrance.")
		end
	end)
end
function module_upvr.Wait(arg1) -- Line 147
	local var11 = arg1._argMap[arg1._bindableEvent.Event:Wait()]
	if var11 then
		return table.unpack(var11, 1, var11.n)
	end
	error("Missing arg data, probably due to reentrance.")
	return nil
end
function module_upvr.Destroy(arg1) -- Line 162
	if arg1._bindableEvent then
		arg1._bindableEvent:Destroy()
		arg1._bindableEvent = nil
	end
	setmetatable(arg1, nil)
end
return module_upvr