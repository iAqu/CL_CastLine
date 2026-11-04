-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:19
-- Luau version 6, Types version 3
-- Time taken: 0.000852 seconds

local module_2 = {}
local PlaySoundEvent_upvr = script.PlaySoundEvent
function module_2.PlaySound(arg1, arg2, arg3) -- Line 13
	--[[ Upvalues[1]:
		[1]: PlaySoundEvent_upvr (readonly)
	]]
	PlaySoundEvent_upvr:FireClient(arg2, arg3)
end
local PlaySoundLocal_2_upvr = script.PlaySoundLocal
function module_2.PlaySoundLocal(arg1, arg2) -- Line 17
	--[[ Upvalues[1]:
		[1]: PlaySoundLocal_2_upvr (readonly)
	]]
	if not arg2.SoundName then
		local module = {}
		module.SoundName = arg2
		return PlaySoundLocal_2_upvr:Fire(module)
	end
	PlaySoundLocal_2_upvr:Fire(arg2)
end
local StopSoundEvent_upvr = script.StopSoundEvent
function module_2.StopSound(arg1, arg2, arg3) -- Line 30
	--[[ Upvalues[1]:
		[1]: StopSoundEvent_upvr (readonly)
	]]
	StopSoundEvent_upvr:FireClient(arg2, arg3)
end
local StopSoundLocal_2_upvr = script.StopSoundLocal
function module_2.StopSoundLocal(arg1, arg2) -- Line 36
	--[[ Upvalues[1]:
		[1]: StopSoundLocal_2_upvr (readonly)
	]]
	StopSoundLocal_2_upvr:Fire(arg2)
end
return module_2