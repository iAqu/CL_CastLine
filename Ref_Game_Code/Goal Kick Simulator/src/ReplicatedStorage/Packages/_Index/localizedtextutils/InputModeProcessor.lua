-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:12
-- Luau version 6, Types version 3
-- Time taken: 0.001145 seconds

local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = module_upvr
function module_upvr.new(arg1) -- Line 16
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._inputModes = {}
	if arg1 then
		for _, v in pairs(arg1) do
			setmetatable_result1:AddInputMode(v)
		end
	end
	return setmetatable_result1
end
function module_upvr.AddInputMode(arg1, arg2) -- Line 30
	table.insert(arg1._inputModes, arg2)
end
function module_upvr.GetStates(arg1) -- Line 38
	return arg1._inputModes
end
function module_upvr.Evaluate(arg1, arg2) -- Line 46
	for _, v_2 in pairs(arg1._inputModes) do
		v_2:Evaluate(arg2)
	end
end
return module_upvr