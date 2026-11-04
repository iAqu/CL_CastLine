-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:40
-- Luau version 6, Types version 3
-- Time taken: 0.000457 seconds

local AFKMOVE_upvr = game.ReplicatedStorage.ServerMsg.AFKMOVE
game:GetService("Players").LocalPlayer.Idled:Connect(function(arg1) -- Line 12, Named "onIdled"
	--[[ Upvalues[1]:
		[1]: AFKMOVE_upvr (readonly)
	]]
	if arg1 and 1080 < arg1 then
		AFKMOVE_upvr:FireServer()
	end
end)