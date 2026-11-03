-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:20
-- Luau version 6, Types version 3
-- Time taken: 0.001696 seconds

local tbl_upvr = {
	Assets = game.ReplicatedStorage:WaitForChild("Assets");
}
local any_IsServer_result1 = game:GetService("RunService"):IsServer()
if any_IsServer_result1 then
	any_IsServer_result1 = game.ServerStorage:WaitForChild("Assets")
end
tbl_upvr.ServerAssets = any_IsServer_result1
local module = {}
local function Get_upvr(arg1, ...) -- Line 9, Named "Get"
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local args_list = {...}
	local var5
	while 0 < #args_list do
		local popped = table.remove(args_list, 1)
		local SOME = var5:FindFirstChild(popped)
		if not SOME then
			return warn(string.format("Failed to find in:", var5:GetFullName(), popped, '['..table.concat({...}, ", ")..']'))
		end
		var5 = SOME
	end
	return var5
end
function module.Check(arg1, ...) -- Line 23
	--[[ Upvalues[1]:
		[1]: Get_upvr (readonly)
	]]
	local var9
	if Get_upvr("Assets", ...) == nil then
		var9 = false
	else
		var9 = true
	end
	return var9
end
function module.GetAssetWithoutCloning(arg1, ...) -- Line 27
	--[[ Upvalues[1]:
		[1]: Get_upvr (readonly)
	]]
	return Get_upvr("Assets", ...)
end
function module.GetServerAssetWithoutCloning(arg1, ...) -- Line 31
	--[[ Upvalues[1]:
		[1]: Get_upvr (readonly)
	]]
	return Get_upvr("Assets", ...)
end
function module.GetAsset(arg1, ...) -- Line 35
	--[[ Upvalues[1]:
		[1]: Get_upvr (readonly)
	]]
	local var11 = Get_upvr("Assets", ...)
	if var11 then
		var11 = Get_upvr("Assets", ...):Clone()
	end
	return var11
end
function module.GetServerAsset(arg1, ...) -- Line 40
	--[[ Upvalues[1]:
		[1]: Get_upvr (readonly)
	]]
	local var13 = Get_upvr("ServerAssets", ...)
	if var13 then
		var13 = Get_upvr("ServerAssets", ...):Clone()
	end
	return var13
end
return module