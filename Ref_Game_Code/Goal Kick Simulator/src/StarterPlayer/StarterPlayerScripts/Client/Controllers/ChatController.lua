-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:39
-- Luau version 6, Types version 3
-- Time taken: 0.000420 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
Util_upvr.Network.Events.SystemMessage = function(arg1) -- Line 4
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	if arg1.SoundId then
		arg1.SoundId = nil
		arg1.Volume = nil
	end
	Util_upvr.StarterGui:SetCore("ChatMakeSystemMessage", arg1)
end
return {}