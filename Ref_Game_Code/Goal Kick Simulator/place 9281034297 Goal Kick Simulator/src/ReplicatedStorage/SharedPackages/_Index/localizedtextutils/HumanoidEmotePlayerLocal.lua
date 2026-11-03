-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:23
-- Luau version 6, Types version 3
-- Time taken: 0.001716 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "HumanoidEmotePlayerLocal"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1) -- Line 15
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(arg1), setmetatable_result1_2_upvr)
	local _obj = setmetatable_result1._obj
	if _obj then
		_obj = setmetatable_result1._obj:IsA("Animator")
	end
	assert(_obj, "Bad animator")
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.StopCurrentAnimation(arg1) -- Line 23
	arg1._maid._current = nil
end
local any_load_result1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr_2 = any_load_result1("Promise")
function setmetatable_result1_2_upvr.PromisePlayAnimation(arg1, arg2, arg3) -- Line 27
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	arg1._maid._current = nil
	local any_new_result1_upvr = any_load_result1_result1_upvr.new()
	local any_LoadAnimation_result1_upvr = arg1._obj:LoadAnimation(arg2)
	any_LoadAnimation_result1_upvr.Name = arg2.Name.."Track"
	local any_new_result1_upvr_2 = any_load_result1_result1_upvr_2.new()
	any_new_result1_upvr:GiveTask(any_new_result1_upvr_2)
	any_new_result1_upvr:GiveTask(function() -- Line 38
		--[[ Upvalues[1]:
			[1]: any_LoadAnimation_result1_upvr (readonly)
		]]
		any_LoadAnimation_result1_upvr:Stop(0.1)
		delay(0.1, function() -- Line 40
			--[[ Upvalues[1]:
				[1]: any_LoadAnimation_result1_upvr (copied, readonly)
			]]
			any_LoadAnimation_result1_upvr:Destroy()
		end)
	end)
	any_new_result1_upvr:GiveTask(any_LoadAnimation_result1_upvr.Stopped:Connect(function() -- Line 44
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:Resolve()
	end))
	any_new_result1_upvr:GiveTask(any_LoadAnimation_result1_upvr.DidLoop:Connect(function() -- Line 47
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:Resolve()
	end))
	any_new_result1_upvr_2:Finally(function() -- Line 51
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		if arg1._maid._current == any_new_result1_upvr then
			arg1._maid._current = nil
		end
	end)
	delay(10, function() -- Line 57
		--[[ Upvalues[2]:
			[1]: any_new_result1_upvr_2 (readonly)
			[2]: arg2 (readonly)
		]]
		if any_new_result1_upvr_2:IsPending() then
			warn("[HumanoidEmotePlayerLocal] - Timed out playing emote %q":format(arg2.Name))
			any_new_result1_upvr_2:Reject()
		end
	end)
	arg1._maid._current = any_new_result1_upvr
	any_LoadAnimation_result1_upvr:Play(arg3)
	return any_new_result1_upvr_2
end
return setmetatable_result1_2_upvr