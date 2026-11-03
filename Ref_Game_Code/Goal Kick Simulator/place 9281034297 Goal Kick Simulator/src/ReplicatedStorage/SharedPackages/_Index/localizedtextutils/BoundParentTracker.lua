-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:17
-- Luau version 6, Types version 3
-- Time taken: 0.002361 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "BoundParentTracker"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("ValueObject")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 15
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	local var6 = arg2
	if not var6 then
		var6 = error("No child")
	end
	setmetatable_result1_upvr_2._child = var6
	var6 = arg1
	local var7 = var6
	if not var7 then
		var7 = error("No binder")
	end
	setmetatable_result1_upvr_2._binder = var7
	setmetatable_result1_upvr_2.Class = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.Class)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._binder:GetClassRemovingSignal():Connect(function(arg1_2) -- Line 26
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if arg1_2 == setmetatable_result1_upvr_2.Class.Value then
			setmetatable_result1_upvr_2.Class.Value = nil
		end
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._child:GetPropertyChangedSignal("Parent"):Connect(function() -- Line 33
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2:_update()
	end))
	setmetatable_result1_upvr_2:_update()
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr._update(arg1) -- Line 41
	local Parent = arg1._child.Parent
	if not Parent then
		arg1.Class.Value = nil
	else
		arg1.Class.Value = arg1._binder:Get(Parent)
	end
end
return setmetatable_result1_upvr