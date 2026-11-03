-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:18
-- Luau version 6, Types version 3
-- Time taken: 0.001965 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_2_upvr = {
	ClassName = "TieSignalConnection";
}
module_2_upvr.__index = module_2_upvr
local any_load_result1_result1_upvr_3 = any_load_result1("Maid")
function module_2_upvr.new(arg1, arg2, arg3, arg4) -- Line 17
	--[[ Upvalues[2]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_2_upvr)
	assert(arg2 or arg3, "Folder or adornee required")
	setmetatable_result1._maid = any_load_result1_result1_upvr_3.new()
	setmetatable_result1._memberDefinition = assert(arg1, "No memberDefinition")
	setmetatable_result1._folder = arg2
	setmetatable_result1._adornee = arg3
	setmetatable_result1._callback = assert(arg4, "No callback")
	setmetatable_result1._connected = true
	setmetatable_result1._tieDefinition = setmetatable_result1._memberDefinition:GetTieDefinition()
	setmetatable_result1:_connect()
	return setmetatable_result1
end
function module_2_upvr.Disconnect(arg1) -- Line 37
	arg1:Destroy()
end
local any_load_result1_result1_upvr = any_load_result1("TieUtils")
function module_2_upvr._connect(arg1) -- Line 41
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	arg1._maid:GiveTask(arg1:_observeBindableEvent():Subscribe(function(arg1_2) -- Line 42
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		if arg1_2:IsDead() then
		else
			arg1_2:ToMaid():GiveTask(arg1_2:GetValue().Event:Connect(function(...) -- Line 50
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: any_load_result1_result1_upvr (copied, readonly)
				]]
				task.spawn(arg1._callback, any_load_result1_result1_upvr.decode(...))
			end))
		end
	end))
end
local any_load_result1_result1_upvr_2 = any_load_result1("TieInterfaceUtils")
function module_2_upvr._observeFolderBrio(arg1) -- Line 56
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return any_load_result1_result1_upvr_2.observeFolderBrio(arg1._tieDefinition, arg1._folder, arg1._adornee)
end
local any_load_result1_result1_upvr_4 = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr_5 = any_load_result1("RxInstanceUtils")
function module_2_upvr._observeBindableEvent(arg1) -- Line 60
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
		[2]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local module = {}
	local any_GetMemberName_result1_upvr = arg1._memberDefinition:GetMemberName()
	module[1] = any_load_result1_result1_upvr_4.switchMapBrio(function(arg1_3) -- Line 64
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_5 (copied, readonly)
			[2]: any_GetMemberName_result1_upvr (readonly)
		]]
		return any_load_result1_result1_upvr_5.observeLastNamedChildBrio(arg1_3, "BindableEvent", any_GetMemberName_result1_upvr)
	end)
	module[2] = any_load_result1_result1_upvr_4.onlyLastBrioSurvives()
	return arg1:_observeFolderBrio():Pipe(module)
end
function module_2_upvr.__index(arg1, arg2) -- Line 71
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	if arg2 == "_adornee" or arg2 == "_folder" then
		return rawget(arg1, arg2)
	end
	if arg2 == "IsConnected" then
		return arg1._connected
	end
	if module_2_upvr[arg2] then
		return module_2_upvr[arg2]
	end
	error("Bad index %q for TieSignalConnection":format(tostring(arg2)))
end
function module_2_upvr.Destroy(arg1) -- Line 83
	arg1._connected = false
	arg1._maid:DoCleaning()
end
return module_2_upvr