-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:19
-- Luau version 6, Types version 3
-- Time taken: 0.004028 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local any_load_result1_result1_upvr_2 = any_load_result1("String")
local var1_result1_upvr = any_load_result1("PlayerGuiUtils")
local any_load_result1_result1_upvr = any_load_result1("Blend")
local module_upvr = {}
module_upvr.ClassName = module_upvr
function module_upvr.new(arg1) -- Line 43
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var7
	if type(arg1) ~= "table" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad orders")
	var7 = {}
	var7._order = arg1
	return setmetatable(var7, module_upvr)
end
function module_upvr.__index(arg1, arg2) -- Line 53
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("Bad index %q":format(tostring(arg2)), 2)
end
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 61
	error("Bad index %q":format(tostring(arg2)), 2)
end
function module_upvr.ObserveScreenGui(arg1, arg2) -- Line 70
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: var1_result1_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return arg1:_observeMockScreenGui(arg2)
	end
	return any_load_result1_result1_upvr.New("ScreenGui")({
		Name = any_load_result1_result1_upvr_2.toCamelCase(arg2);
		ResetOnSpawn = false;
		AutoLocalize = false;
		DisplayOrder = arg1:GetDisplayOrder(arg2);
		Parent = var1_result1_upvr.getPlayerGui();
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	})
end
local Players_upvr = game:GetService("Players")
function module_upvr.Get(arg1, arg2) -- Line 90
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: var1_result1_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() then
		return arg1:_mockScreenGui(arg2)
	end
	if not Players_upvr.LocalPlayer then
		error("[GenericScreenGuiProvider] - No localPlayer")
	end
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = any_load_result1_result1_upvr_2.toCamelCase(arg2)
	ScreenGui.ResetOnSpawn = false
	ScreenGui.AutoLocalize = false
	ScreenGui.DisplayOrder = arg1:GetDisplayOrder(arg2)
	ScreenGui.Parent = var1_result1_upvr.getPlayerGui()
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	return ScreenGui
end
function module_upvr.GetDisplayOrder(arg1, arg2) -- Line 116
	local var11
	if type(arg2) ~= "string" then
		var11 = false
	else
		var11 = true
	end
	assert(var11, "Bad orderName")
	var11 = arg1._order[arg2]
	assert(var11, "No DisplayOrder with orderName '%s'":format(tostring(arg2)))
	var11 = arg1._order
	return var11[arg2]
end
function module_upvr.SetupMockParent(arg1, arg2) -- Line 128
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	assert(not RunService_upvr:IsRunning(), "Bad target")
	assert(arg2, "Bad target")
	rawset(arg1, "_mockParent", arg2)
	return function() -- Line 134
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		if rawget(arg1, "_mockParent") == arg2 then
			rawset(arg1, "_mockParent", nil)
		end
	end
end
function module_upvr._mockScreenGui(arg1, arg2) -- Line 141
	local var13
	if type(arg2) ~= "string" then
		var13 = false
	else
		var13 = true
	end
	assert(var13, "Bad orderName")
	var13 = rawget(arg1, "_mockParent")
	assert(var13, "No _mockParent set")
	var13 = Instance.new("Frame")
	var13.Size = UDim2.new(1, 0, 1, 0)
	var13.BackgroundTransparency = 1
	var13.ZIndex = arg1:GetDisplayOrder(arg2)
	var13.Parent = rawget(arg1, "_mockParent")
	return var13
end
function module_upvr._observeMockScreenGui(arg1, arg2) -- Line 156
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var14
	if type(arg2) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad orderName")
	var14 = rawget(arg1, "_mockParent")
	assert(var14, "No _mockParent set")
	var14 = any_load_result1_result1_upvr.New("Frame")
	var14 = var14({
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundTransparency = 1;
		ZIndex = arg1:GetDisplayOrder(arg2);
		Parent = rawget(arg1, "_mockParent");
	})
	return var14
end
return module_upvr