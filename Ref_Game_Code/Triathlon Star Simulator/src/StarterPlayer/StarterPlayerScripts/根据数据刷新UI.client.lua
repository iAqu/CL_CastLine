-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:29
-- Luau version 6, Types version 3
-- Time taken: 0.000528 seconds

local LocalData_upvr = require(game.StarterPlayer.StarterPlayerScripts.LocalData)
game:GetService("ReplicatedStorage").ServerMsg.UpdateLocalData.OnClientEvent:Connect(function(arg1, arg2) -- Line 7
	--[[ Upvalues[1]:
		[1]: LocalData_upvr (readonly)
	]]
	if not arg1 then
	else
		LocalData_upvr:UpdateLocalData(arg1, arg2)
		local refreshLocalUI = game:GetService("ReplicatedStorage").LocalMsg.refreshLocalUI
		refreshLocalUI:Fire("宠物", arg1)
		refreshLocalUI:Fire("装备", arg1)
		refreshLocalUI:Fire("教练活动", arg1)
	end
end)