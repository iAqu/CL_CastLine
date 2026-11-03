-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:53
-- Luau version 6, Types version 3
-- Time taken: 0.001109 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_3)
setmetatable_result1_upvr.ClassName = "RagdollableClient"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("RagdollBindersClient")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 24
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_3.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._serviceBag = assert(arg2, "No serviceBag")
	setmetatable_result1_upvr_2._ragdollBindersClient = setmetatable_result1_upvr_2._serviceBag:GetService(var1_result1_upvr)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._ragdollBindersClient.Ragdoll:ObserveInstance(setmetatable_result1_upvr_2._obj, function() -- Line 30
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_onRagdollChanged()
	end))
	setmetatable_result1_upvr_2:_onRagdollChanged()
	return setmetatable_result1_upvr_2
end
local var1_result1_upvr_2 = any_load_result1("RxRagdollUtils")
function setmetatable_result1_upvr._onRagdollChanged(arg1) -- Line 38
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if arg1._ragdollBindersClient.Ragdoll:Get(arg1._obj) then
		arg1._maid._ragdoll = var1_result1_upvr_2.runLocal(arg1._obj)
	else
		arg1._maid._ragdoll = nil
	end
end
return setmetatable_result1_upvr