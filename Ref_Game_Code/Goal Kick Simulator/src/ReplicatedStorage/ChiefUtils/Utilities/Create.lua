-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:26
-- Luau version 6, Types version 3
-- Time taken: 0.001209 seconds

local CollectionService_upvr = game:GetService("CollectionService")
return function(arg1, arg2, ...) -- Line 4, Named "Create"
	--[[ Upvalues[1]:
		[1]: CollectionService_upvr (readonly)
	]]
	assert(arg1, "No Value was given.")
	local var14 = arg2
	if not var14 then
		var14 = {}
	end
	local var15 = var14
	var14 = nil
	local var16 = var14
	if typeof(arg1) == "string" then
		var16 = Instance.new(arg1)
	elseif typeof(arg1) == "Instance" then
		var16 = arg1:Clone()
	end
	if var15._Tags then
		for _, v in pairs(var15._Tags) do
			CollectionService_upvr:AddTag(var16, v)
		end
		var15._Tags = nil
	end
	for i_2, v_2 in pairs(var15) do
		if i_2 ~= "Parent" then
			var16[i_2] = v_2
		end
	end
	local pairs_result1, pairs_result2, pairs_result3 = pairs({...})
	for _, v_3 in pairs_result1, pairs_result2, pairs_result3 do
		v_3.Parent = var16
	end
	pairs_result1 = var15.Parent
	local var27 = pairs_result1
	if not var27 then
		var27 = var16.Parent
	end
	var16.Parent = var27
	return var16
end