-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:16
-- Luau version 6, Types version 3
-- Time taken: 0.003421 seconds

local module = {}
local tbl_upvr = {
	["nil"] = true;
	string = true;
	boolean = true;
	number = true;
	UDim = true;
	UDim2 = true;
	BrickColor = true;
	Color3 = true;
	Vector2 = true;
	Vector3 = true;
	NumberSequence = true;
	ColorSequence = true;
	IntValue = true;
	NumberRange = true;
	Rect = true;
}
function module.isValidAttributeType(arg1) -- Line 42
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var3
	if tbl_upvr[arg1] ~= true then
		var3 = false
	else
		var3 = true
	end
	return var3
end
local var4_upvr = require(script.Parent.loader).load(script)("Maid")
local RunService_upvr = game:GetService("RunService")
function module.bindToBinder(arg1, arg2, arg3) -- Line 55
	--[[ Upvalues[2]:
		[1]: var4_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local syncAttribute = arg3
	assert(syncAttribute, "Bad binder")
	if typeof(arg1) ~= "Instance" then
		syncAttribute = false
	else
		syncAttribute = true
	end
	assert(syncAttribute, "Bad instance")
	if type(arg2) ~= "string" then
		syncAttribute = false
	else
		syncAttribute = true
	end
	assert(syncAttribute, "Bad attributeName")
	syncAttribute = var4_upvr
	local any_new_result1_upvr = syncAttribute.new()
	function syncAttribute() -- Line 62
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: RunService_upvr (copied, readonly)
			[4]: arg3 (readonly)
		]]
		if arg1:GetAttribute(arg2) then
			if RunService_upvr:IsClient() then
				arg3:BindClient(arg1)
			else
				arg3:Bind(arg1)
			end
		end
		if RunService_upvr:IsClient() then
			arg3:UnbindClient(arg1)
		else
			arg3:Unbind(arg1)
		end
	end
	any_new_result1_upvr:GiveTask(arg1:GetAttributeChangedSignal(arg2):Connect(syncAttribute))
	any_new_result1_upvr:GiveTask(arg3:ObserveInstance(arg1, function() -- Line 79, Named "syncBoundClass"
		--[[ Upvalues[3]:
			[1]: arg3 (readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		if arg3:Get(arg1) then
			arg1:SetAttribute(arg2, true)
		else
			arg1:SetAttribute(arg2, false)
		end
	end))
	if arg3:Get(arg1) or arg1:GetAttribute(arg2) then
		arg1:SetAttribute(arg2, true)
		if RunService_upvr:IsClient() then
			arg3:BindClient(arg1)
		else
			arg3:Bind(arg1)
		end
	else
		arg1:SetAttribute(arg2, false)
	end
	any_new_result1_upvr:GiveTask(function() -- Line 101
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
		arg1:SetAttribute(arg2, nil)
	end)
	return any_new_result1_upvr
end
function module.initAttribute(arg1, arg2, arg3) -- Line 120
	local var9
	if typeof(arg1) ~= "Instance" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad instance")
	if typeof(arg2) ~= "string" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad attributeName")
	local attribute_2 = arg1:GetAttribute(arg2)
	if attribute_2 == nil then
		var9 = arg1:SetAttribute
		var9(arg2, arg3)
		attribute_2 = arg3
	end
	return attribute_2
end
function module.getAttribute(arg1, arg2, arg3) -- Line 140
	local attribute = arg1:GetAttribute(arg2)
	if attribute == nil then
		return arg3
	end
	return attribute
end
function module.removeAllAttributes(arg1) -- Line 154
	local var16
	if typeof(arg1) ~= "Instance" then
		var16 = false
	else
		var16 = true
	end
	assert(var16, "Bad instance")
	var16 = arg1:GetAttributes()
	for i, _ in pairs(var16) do
		arg1:SetAttribute(i, nil)
	end
end
return module