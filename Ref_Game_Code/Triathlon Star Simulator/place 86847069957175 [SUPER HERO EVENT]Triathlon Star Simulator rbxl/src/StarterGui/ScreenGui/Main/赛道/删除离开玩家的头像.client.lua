-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:55
-- Luau version 6, Types version 3
-- Time taken: 0.000699 seconds

local _____________upvr = script.Parent["玩家头像"]
local FindPlayerByID_upvr = require(game:GetService("ReplicatedStorage").Tool.FindPlayerByID)
local Debris_upvr = game:GetService("Debris")
while wait(2) do
	(function() -- Line 5, Named "delLeavePlrIcon"
		--[[ Upvalues[3]:
			[1]: _____________upvr (readonly)
			[2]: FindPlayerByID_upvr (readonly)
			[3]: Debris_upvr (readonly)
		]]
		for _, v in pairs(_____________upvr:GetChildren()) do
			if not FindPlayerByID_upvr.getPlayerByID(tonumber(v.Name)) then
				Debris_upvr:AddItem(v, 0)
			end
		end
	end)()
end