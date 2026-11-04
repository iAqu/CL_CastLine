-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:26
-- Luau version 6, Types version 3
-- Time taken: 0.000717 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlaySoundModule_upvr = require(ReplicatedStorage.Tool.PlaySoundModule)
ReplicatedStorage.Tool.SoundModule.PlaySoundEvent.OnClientEvent:Connect(function(arg1) -- Line 13
	--[[ Upvalues[1]:
		[1]: PlaySoundModule_upvr (readonly)
	]]
	PlaySoundModule_upvr.playSound(arg1)
end)
ReplicatedStorage.Tool.SoundModule.StopSoundEvent.OnClientEvent:Connect(function(arg1) -- Line 17
	--[[ Upvalues[1]:
		[1]: PlaySoundModule_upvr (readonly)
	]]
	PlaySoundModule_upvr.stopSound(arg1)
end)
ReplicatedStorage.Tool.SoundModule.PlaySoundLocal.Event:Connect(function(arg1) -- Line 21
	--[[ Upvalues[1]:
		[1]: PlaySoundModule_upvr (readonly)
	]]
	PlaySoundModule_upvr.playSound(arg1)
end)
ReplicatedStorage.Tool.SoundModule.StopSoundLocal.Event:Connect(function(arg1) -- Line 25
	--[[ Upvalues[1]:
		[1]: PlaySoundModule_upvr (readonly)
	]]
	PlaySoundModule_upvr.stopSound(arg1)
end)