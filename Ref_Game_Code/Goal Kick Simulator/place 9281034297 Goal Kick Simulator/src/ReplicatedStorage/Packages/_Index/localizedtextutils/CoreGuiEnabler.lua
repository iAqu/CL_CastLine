-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:24
-- Luau version 6, Types version 3
-- Time taken: 0.003715 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local StarterGui_upvr = game:GetService("StarterGui")
local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "CoreGuiEnabler"
local var1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr = any_load_result1("CharacterUtils")
local Players_upvr = game:GetService("Players")
local UserInputService_upvr = game:GetService("UserInputService")
function module_upvr.new() -- Line 31
	--[[ Upvalues[6]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: StarterGui_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: Players_upvr (readonly)
		[6]: UserInputService_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._maid = var1_result1_upvr.new()
	setmetatable_result1._states = {}
	setmetatable_result1:AddState(Enum.CoreGuiType.Backpack, function(arg1) -- Line 38
		--[[ Upvalues[3]:
			[1]: StarterGui_upvr (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: Players_upvr (copied, readonly)
		]]
		StarterGui_upvr:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, arg1)
		any_load_result1_result1_upvr.unequipTools(Players_upvr.LocalPlayer)
	end)
	for _, v_upvr in pairs(Enum.CoreGuiType:GetEnumItems()) do
		if not setmetatable_result1._states[v_upvr] then
			setmetatable_result1:AddState(v_upvr, function(arg1) -- Line 45
				--[[ Upvalues[2]:
					[1]: StarterGui_upvr (copied, readonly)
					[2]: v_upvr (readonly)
				]]
				StarterGui_upvr:SetCoreGuiEnabled(v_upvr, arg1)
			end)
		end
	end
	setmetatable_result1:_addStarterGuiState("TopbarEnabled")
	setmetatable_result1:_addStarterGuiState("BadgesNotificationsActive")
	setmetatable_result1:_addStarterGuiState("PointsNotificationsActive")
	setmetatable_result1:AddState("ModalEnabled", function(arg1) -- Line 55
		--[[ Upvalues[1]:
			[1]: UserInputService_upvr (copied, readonly)
		]]
		UserInputService_upvr.ModalEnabled = not arg1
	end)
	setmetatable_result1:AddState("MouseIconEnabled", function(arg1) -- Line 59
		--[[ Upvalues[1]:
			[1]: UserInputService_upvr (copied, readonly)
		]]
		UserInputService_upvr.MouseIconEnabled = arg1
	end)
	return setmetatable_result1
end
function module_upvr._addStarterGuiState(arg1, arg2) -- Line 66
	--[[ Upvalues[1]:
		[1]: StarterGui_upvr (readonly)
	]]
	local var18_upvr = arg2.."State"
	arg1[var18_upvr] = Instance.new("BoolValue")
	arg1[var18_upvr].Value = false
	arg1:AddState(arg2, function(arg1_2) -- Line 71
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: var18_upvr (readonly)
			[3]: StarterGui_upvr (copied, readonly)
			[4]: arg2 (readonly)
		]]
		arg1[var18_upvr].Value = arg1_2
		local pcall_result1, pcall_result2 = pcall(function() -- Line 73
			--[[ Upvalues[3]:
				[1]: StarterGui_upvr (copied, readonly)
				[2]: arg2 (copied, readonly)
				[3]: arg1_2 (readonly)
			]]
			StarterGui_upvr:SetCore(arg2, arg1_2)
		end)
		if not pcall_result1 then
			warn("Failed to set core", pcall_result2)
		end
	end)
end
function module_upvr.AddState(arg1, arg2, arg3) -- Line 87
	local var23_upvw
	if type(arg3) ~= "function" then
		var23_upvw = false
	else
		var23_upvw = true
	end
	assert(var23_upvw, "must have coreGuiStateChangeFunc as function")
	if arg1._states[arg2] ~= nil then
		var23_upvw = false
	else
		var23_upvw = true
	end
	assert(var23_upvw, "state already exists")
	local tbl_upvr = {}
	var23_upvw = true
	local function _() -- Line 94, Named "isEnabled"
		--[[ Upvalues[1]:
			[1]: tbl_upvr (readonly)
		]]
		local var25
		if next(tbl_upvr) ~= nil then
			var25 = false
		else
			var25 = true
		end
		return var25
	end
	arg1._states[arg2] = setmetatable({}, {
		__newindex = function(arg1_3, arg2_2, arg3_2) -- Line 99, Named "__newindex"
			--[[ Upvalues[3]:
				[1]: tbl_upvr (readonly)
				[2]: var23_upvw (read and write)
				[3]: arg3 (readonly)
			]]
			local rawset = rawset
			rawset(tbl_upvr, arg2_2, arg3_2)
			if next(tbl_upvr) ~= nil then
				rawset = false
			else
				rawset = true
			end
			if var23_upvw ~= rawset then
				var23_upvw = rawset
				arg3(rawset)
			end
		end;
	})
end
function module_upvr.Disable(arg1, arg2, arg3) -- Line 117
	if not arg1._states[arg3] then
		error("[CoreGuiEnabler] - State '%s' does not exist.":format(tostring(arg3)))
	end
	arg1._states[arg3][arg2] = true
	return function() -- Line 124
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
		]]
		arg1:Enable(arg2, arg3)
	end
end
function module_upvr.Enable(arg1, arg2, arg3) -- Line 134
	if not arg1._states[arg3] then
		error("[CoreGuiEnabler] - State '%s' does not exist.":format(tostring(arg3)))
	end
	arg1._states[arg3][arg2] = nil
end
return module_upvr.new()