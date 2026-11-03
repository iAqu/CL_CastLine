-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:35
-- Luau version 6, Types version 3
-- Time taken: 0.005499 seconds

local module_upvr = {
	findFirstAncestor = function(arg1, arg2) -- Line 18, Named "findFirstAncestor"
		local var2
		if type(arg1) ~= "table" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "Binder must be binder")
		if typeof(arg2) ~= "Instance" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "Child parameter must be instance")
		local Parent = arg2.Parent
		while Parent do
			var2 = arg1:Get(Parent)
			if var2 then
				return var2
			end
		end
		var2 = nil
		return var2
	end;
	findFirstChild = function(arg1, arg2) -- Line 41, Named "findFirstChild"
		local var8
		if type(arg1) ~= "table" then
			var8 = false
		else
			var8 = true
		end
		assert(var8, "Binder must be binder")
		if typeof(arg2) ~= "Instance" then
			var8 = false
		else
			var8 = true
		end
		assert(var8, "Parent parameter must be instance")
		var8 = arg2:GetChildren()
		for _, v in pairs(var8) do
			local any_Get_result1_4 = arg1:Get(v)
			if any_Get_result1_4 then
				return any_Get_result1_4
			end
		end
		return nil
	end;
	getChildren = function(arg1, arg2) -- Line 62, Named "getChildren"
		local var17
		if type(arg1) ~= "table" then
			var17 = false
		else
			var17 = true
		end
		assert(var17, "Binder must be binder")
		if typeof(arg2) ~= "Instance" then
			var17 = false
		else
			var17 = true
		end
		assert(var17, "Parent parameter must be instance")
		var17 = pairs(arg2:GetChildren())
		for _, v_2 in pairs(arg2:GetChildren()) do
			local any_Get_result1 = arg1:Get(v_2)
			if any_Get_result1 then
				table.insert({}, any_Get_result1)
			end
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return {}
	end;
	mapBinderListToTable = function(arg1) -- Line 86, Named "mapBinderListToTable"
		local var26
		if type(arg1) ~= "table" then
			var26 = false
		else
			var26 = true
		end
		assert(var26, "bindersList must be a table of binders")
		var26 = pairs(arg1)
		for _, v_3 in pairs(arg1) do
			({})[v_3:GetTag()] = v_3
			local var31
		end
		return var31
	end;
}
local CollectionService_upvr = game:GetService("CollectionService")
function module_upvr.getMappedFromList(arg1, arg2) -- Line 109
	--[[ Upvalues[1]:
		[1]: CollectionService_upvr (readonly)
	]]
	for _, v_4 in pairs(arg2) do
		for _, v_5 in pairs(CollectionService_upvr:GetTags(v_4)) do
			local var55 = arg1[v_5]
			if var55 then
				local any_Get_result1_7 = var55:Get(v_4)
				if any_Get_result1_7 then
					table.insert({}, any_Get_result1_7)
				end
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function module_upvr.getChildrenOfBinders(arg1, arg2) -- Line 134
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var57
	if type(arg1) ~= "table" then
		var57 = false
	else
		var57 = true
	end
	assert(var57, "bindersList must be a table of binders")
	if typeof(arg2) ~= "Instance" then
		var57 = false
	else
		var57 = true
	end
	assert(var57, "Parent parameter must be instance")
	var57 = module_upvr
	var57 = arg1
	var57 = module_upvr.getMappedFromList(var57.mapBinderListToTable(var57), arg2:GetChildren())
	return var57
end
function module_upvr.getLinkedChildren(arg1, arg2, arg3) -- Line 150
	local tbl_2 = {}
	for _, v_6 in pairs(arg3:GetChildren()) do
		if v_6.Name == arg2 and v_6:IsA("ObjectValue") and v_6.Value then
			local any_Get_result1_5 = arg1:Get(v_6.Value)
			if any_Get_result1_5 then
				if not tbl_2[any_Get_result1_5] then
					tbl_2[any_Get_result1_5] = true
					table.insert({}, any_Get_result1_5)
				else
					warn("[BinderUtils.getLinkedChildren] - Double linked children at %q":format(v_6:GetFullName()))
				end
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function module_upvr.getDescendants(arg1, arg2) -- Line 176
	local var76
	if type(arg1) ~= "table" then
		var76 = false
	else
		var76 = true
	end
	assert(var76, "Binder must be binder")
	if typeof(arg2) ~= "Instance" then
		var76 = false
	else
		var76 = true
	end
	assert(var76, "Parent parameter must be instance")
	var76 = pairs(arg2:GetDescendants())
	for _, v_7 in pairs(arg2:GetDescendants()) do
		local any_Get_result1_3 = arg1:Get(v_7)
		if any_Get_result1_3 then
			table.insert({}, any_Get_result1_3)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
return module_upvr