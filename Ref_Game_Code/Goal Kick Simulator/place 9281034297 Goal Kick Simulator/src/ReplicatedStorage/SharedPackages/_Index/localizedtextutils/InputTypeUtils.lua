-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:52
-- Luau version 6, Types version 3
-- Time taken: 0.004263 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("SlottedTouchButtonUtils")
local module_upvr = {}
function module_upvr.isKnownInputType(arg1) -- Line 20
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local any_isTapInWorld_result1 = module_upvr.isTapInWorld(arg1)
	if not any_isTapInWorld_result1 then
		any_isTapInWorld_result1 = module_upvr.isRobloxTouchButton(arg1)
		if not any_isTapInWorld_result1 then
			any_isTapInWorld_result1 = module_upvr.isDrag(arg1)
			if not any_isTapInWorld_result1 then
				any_isTapInWorld_result1 = var1_result1_upvr.isSlottedTouchButton(arg1)
				if not any_isTapInWorld_result1 then
					any_isTapInWorld_result1 = false
					if typeof(arg1) == "EnumItem" then
						any_isTapInWorld_result1 = true
						if tostring(arg1.EnumType) ~= "UserInputType" then
							if tostring(arg1.EnumType) ~= "KeyCode" then
								any_isTapInWorld_result1 = false
							else
								any_isTapInWorld_result1 = true
							end
						end
					end
				end
			end
		end
	end
	return any_isTapInWorld_result1
end
function module_upvr.isTapInWorld(arg1) -- Line 35
	if arg1 ~= "Tap" then
	else
	end
	return true
end
function module_upvr.isDrag(arg1) -- Line 45
	if arg1 ~= "Drag" then
	else
	end
	return true
end
function module_upvr.isRobloxTouchButton(arg1) -- Line 54
	if arg1 ~= "TouchButton" then
	else
	end
	return true
end
function module_upvr.createTapInWorld() -- Line 62
	return "Tap"
end
function module_upvr.createRobloxTouchButton() -- Line 70
	return "TouchButton"
end
function module_upvr.getUniqueKeyForInputType(arg1) -- Line 82
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if var1_result1_upvr.isSlottedTouchButton(arg1) then
		return arg1.slotId
	end
	return arg1
end
local HttpService_upvr = game:GetService("HttpService")
local function convertValuesToJSONIfNeeded_upvr(arg1) -- Line 90, Named "convertValuesToJSONIfNeeded"
	--[[ Upvalues[1]:
		[1]: HttpService_upvr (readonly)
	]]
	for i, v in pairs(arg1) do
		if type(v) == "table" then
			({})[i] = HttpService_upvr:JSONEncode(v)
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i] = v
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
local any_load_result1_result1_upvr = any_load_result1("Set")
function module_upvr.areInputTypesListsEquivalent(arg1, arg2) -- Line 109
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: convertValuesToJSONIfNeeded_upvr (readonly)
	]]
	local any_difference_result1 = any_load_result1_result1_upvr.difference(any_load_result1_result1_upvr.fromTableValue(convertValuesToJSONIfNeeded_upvr(arg1)), any_load_result1_result1_upvr.fromTableValue(convertValuesToJSONIfNeeded_upvr(arg2)))
	if #any_load_result1_result1_upvr.toList(any_difference_result1) ~= 0 then
		any_difference_result1 = false
	else
		any_difference_result1 = true
	end
	return any_difference_result1
end
return module_upvr