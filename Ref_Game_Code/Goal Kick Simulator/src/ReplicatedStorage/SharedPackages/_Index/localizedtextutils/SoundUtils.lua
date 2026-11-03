-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:53
-- Luau version 6, Types version 3
-- Time taken: 0.003428 seconds

local SoundService_upvr = game:GetService("SoundService")
local RunService_upvr = game:GetService("RunService")
local module_upvr = {}
function module_upvr.playFromId(arg1) -- Line 34
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: RunService_upvr (readonly)
		[3]: SoundService_upvr (readonly)
	]]
	local var4
	if type(module_upvr.toRbxAssetId(arg1)) ~= "string" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad id")
	var4 = module_upvr
	var4 = arg1
	local any_createSoundFromId_result1 = var4.createSoundFromId(var4)
	var4 = RunService_upvr:IsClient()
	if var4 then
		var4 = SoundService_upvr:PlayLocalSound
		var4(any_createSoundFromId_result1)
	else
		var4 = any_createSoundFromId_result1:Play
		var4()
	end
	var4 = module_upvr.removeAfterTimeLength
	var4(any_createSoundFromId_result1)
	return any_createSoundFromId_result1
end
function module_upvr.createSoundFromId(arg1) -- Line 54
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_toRbxAssetId_result1 = module_upvr.toRbxAssetId(arg1)
	local var7
	if type(any_toRbxAssetId_result1) ~= "string" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad id")
	var7 = "Sound"
	local any = Instance.new(var7)
	var7 = "Sound_%s":format(any_toRbxAssetId_result1)
	any.Name = var7
	any.SoundId = any_toRbxAssetId_result1
	var7 = 0.25
	any.Volume = var7
	var7 = false
	any.Archivable = var7
	return any
end
function module_upvr.playFromIdInParent(arg1, arg2) -- Line 70
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: RunService_upvr (readonly)
		[3]: SoundService_upvr (readonly)
	]]
	local var9
	if typeof(arg2) ~= "Instance" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad parent")
	var9 = module_upvr
	var9 = arg1
	local any_createSoundFromId_result1_2 = var9.createSoundFromId(var9)
	any_createSoundFromId_result1_2.Parent = arg2
	var9 = RunService_upvr:IsRunning()
	if not var9 then
		var9 = SoundService_upvr:PlayLocalSound
		var9(any_createSoundFromId_result1_2)
	else
		var9 = any_createSoundFromId_result1_2:Play
		var9()
	end
	var9 = module_upvr.removeAfterTimeLength
	var9(any_createSoundFromId_result1_2)
	return any_createSoundFromId_result1_2
end
local var11_upvr = require(script.Parent.loader).load(script)("SoundPromiseUtils")
function module_upvr.removeAfterTimeLength(arg1) -- Line 92
	--[[ Upvalues[1]:
		[1]: var11_upvr (readonly)
	]]
	var11_upvr.promiseLoaded(arg1):Then(function() -- Line 94
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		task.delay(arg1.TimeLength + 0.05, function() -- Line 95
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1:Destroy()
		end)
	end, function() -- Line 98
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:Destroy()
	end)
end
function module_upvr.playTemplate(arg1, arg2) -- Line 114
	--[[ Upvalues[2]:
		[1]: SoundService_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local var15
	if type(arg1) ~= "table" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad templates")
	if type(arg2) ~= "string" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad templateName")
	local clone_2 = arg1:Clone(arg2)
	var15 = false
	clone_2.Archivable = var15
	var15 = SoundService_upvr:PlayLocalSound
	var15(clone_2)
	var15 = module_upvr.removeAfterTimeLength
	var15(clone_2)
	return clone_2
end
function module_upvr.toRbxAssetId(arg1) -- Line 133
	if type(arg1) == "number" then
		return "rbxassetid://%d":format(arg1)
	end
	return arg1
end
function module_upvr.playTemplateInParent(arg1, arg2, arg3) -- Line 153
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local clone = arg1:Clone(arg2)
	clone.Archivable = false
	clone.Parent = arg3
	clone:Play()
	module_upvr.removeAfterTimeLength(clone)
	return clone
end
return module_upvr