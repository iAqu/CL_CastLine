-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:39
-- Luau version 6, Types version 3
-- Time taken: 0.001699 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "InputMode"
local var2_upvr = require(script.Parent.loader).load(script)("Signal")
function module_upvr.new(arg1) -- Line 34
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._inputModeType = assert(arg1, "Bad inputModeType")
	setmetatable_result1._lastEnabled = 0
	setmetatable_result1.Name = setmetatable_result1._inputModeType.Name
	setmetatable_result1.Enabled = var2_upvr.new()
	return setmetatable_result1
end
function module_upvr.isInputMode(arg1) -- Line 52
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var4 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= module_upvr then
			var4 = false
		else
			var4 = true
		end
	end
	return var4
end
function module_upvr.GetLastEnabledTime(arg1) -- Line 60
	return arg1._lastEnabled
end
function module_upvr.GetKeys(arg1) -- Line 68
	return arg1._inputModeType:GetKeys()
end
function module_upvr.IsValid(arg1, arg2) -- Line 77
	assert(arg2, "Must send in inputType")
	return arg1._inputModeType:IsValid(arg2)
end
function module_upvr.Enable(arg1) -- Line 86
	arg1._lastEnabled = os.clock()
	arg1.Enabled:Fire()
end
function module_upvr.Evaluate(arg1, arg2) -- Line 95
	if arg1._inputModeType:IsValid(arg2.UserInputType) or arg1._inputModeType:IsValid(arg2.KeyCode) then
		arg1:Enable()
	end
end
function module_upvr.Destroy(arg1) -- Line 106
	arg1.Enabled:Destroy()
end
return module_upvr