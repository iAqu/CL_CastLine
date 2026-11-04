-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:18
-- Luau version 6, Types version 3
-- Time taken: 0.002543 seconds

local module = {}
local ServerUtil_upvr = require(game.ReplicatedStorage.ServerUtil)
function module.RigPlayer(arg1, arg2) -- Line 5
	--[[ Upvalues[1]:
		[1]: ServerUtil_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local Humanoid = arg2:WaitForChild("Humanoid")
	Humanoid:SetAttribute("RiggedUser", true)
	Instance.new("Folder", arg2).Name = "ColliderFolder"
	Humanoid.BreakJointsOnDeath = false
	local pairs_result1, pairs_result2, pairs_result3 = pairs(arg2:GetDescendants())
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [242] 159. Error Block 15 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [242] 159. Error Block 15 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [42] 32. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [242.13]
	-- KONSTANTERROR: [42] 32. Error Block 2 end (CF ANALYSIS FAILED)
end
return module