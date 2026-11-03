-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:20
-- Luau version 6, Types version 3
-- Time taken: 0.001729 seconds

local module_upvr = {
	getPlayerHumanoid = function(arg1) -- Line 15, Named "getPlayerHumanoid"
		local Character = arg1.Character
		if not Character then
			return nil
		end
		return Character:FindFirstChildOfClass("Humanoid")
	end;
}
function module_upvr.getAlivePlayerHumanoid(arg1) -- Line 29
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getPlayerHumanoid_result1_2 = module_upvr.getPlayerHumanoid(arg1)
	if not any_getPlayerHumanoid_result1_2 or any_getPlayerHumanoid_result1_2.Health <= 0 then
		return nil
	end
	return any_getPlayerHumanoid_result1_2
end
function module_upvr.getAlivePlayerRootPart(arg1) -- Line 44
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getPlayerHumanoid_result1 = module_upvr.getPlayerHumanoid(arg1)
	if not any_getPlayerHumanoid_result1 or any_getPlayerHumanoid_result1.Health <= 0 then
		return nil
	end
	return any_getPlayerHumanoid_result1.RootPart
end
function module_upvr.getPlayerRootPart(arg1) -- Line 58
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getPlayerHumanoid_result1_4 = module_upvr.getPlayerHumanoid(arg1)
	if not any_getPlayerHumanoid_result1_4 then
		return nil
	end
	return any_getPlayerHumanoid_result1_4.RootPart
end
function module_upvr.unequipTools(arg1) -- Line 81
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_getPlayerHumanoid_result1_3 = module_upvr.getPlayerHumanoid(arg1)
	if any_getPlayerHumanoid_result1_3 then
		any_getPlayerHumanoid_result1_3:UnequipTools()
	end
end
local Players_upvr = game:GetService("Players")
function module_upvr.getPlayerFromCharacter(arg1) -- Line 109
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	local var8 = arg1
	local var9
	while not var9 do
		if var8.Parent then
			var9 = Players_upvr:GetPlayerFromCharacter(var8.Parent)
		else
			return nil
		end
	end
	return var9
end
return module_upvr