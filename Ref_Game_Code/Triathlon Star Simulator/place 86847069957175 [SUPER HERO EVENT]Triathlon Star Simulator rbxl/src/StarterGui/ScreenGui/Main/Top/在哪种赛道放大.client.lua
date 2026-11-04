-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:28:30
-- Luau version 6, Types version 3
-- Time taken: 0.000712 seconds

local _ = game:GetService("ReplicatedStorage")
local tbl_upvr = {script.Parent["游泳"], script.Parent["骑行"], script.Parent["跑步"]}
require(game.ReplicatedStorage.ServerUtil).AddListen.NumValueAdd(game.Players.LocalPlayer:WaitForChild("运动状态", math.huge), function(arg1) -- Line 17
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	for i, v in pairs(tbl_upvr) do
		if i == arg1 + 1 then
			v.UIScale.Scale = 1.2
		else
			v.UIScale.Scale = 1
		end
	end
end)