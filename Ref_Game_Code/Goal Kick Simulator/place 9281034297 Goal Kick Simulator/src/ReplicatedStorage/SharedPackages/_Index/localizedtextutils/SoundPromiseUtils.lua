-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:40
-- Luau version 6, Types version 3
-- Time taken: 0.001327 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
local any_load_result1_result1_upvr_2 = any_load_result1("Promise")
function module_upvr.promiseLoaded(arg1) -- Line 18
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	if arg1.IsLoaded then
		return any_load_result1_result1_upvr_2.resolved()
	end
	local any_new_result1_upvr = any_load_result1_result1_upvr_2.new()
	local any_Connect_result1_upvw = arg1.Loaded:Connect(function() -- Line 27
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		if arg1.IsLoaded then
			any_new_result1_upvr:Resolve()
		end
	end)
	any_new_result1_upvr:Finally(function() -- Line 33
		--[[ Upvalues[1]:
			[1]: any_Connect_result1_upvw (read and write)
		]]
		any_Connect_result1_upvw:Disconnect()
	end)
	return any_new_result1_upvr
end
local any_load_result1_result1_upvr = any_load_result1("PromiseUtils")
function module_upvr.promiseAllSoundsLoaded(arg1) -- Line 45
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local module = {}
	for _, v in pairs(arg1) do
		table.insert(module, module_upvr.promiseLoaded(v))
	end
	return any_load_result1_result1_upvr.all(module)
end
return module_upvr