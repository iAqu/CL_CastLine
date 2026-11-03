-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:23
-- Luau version 6, Types version 3
-- Time taken: 0.000660 seconds

local module = require(script.Parent:WaitForChild("Util"))
function ProcessMessage(arg1, arg2, arg3) -- Line 8
	if string.sub(arg1, 1, 4):lower() == "/cls" or string.sub(arg1, 1, 6):lower() == "/clear" then
		local any_GetCurrentChannel_result1 = arg2:GetCurrentChannel()
		if any_GetCurrentChannel_result1 then
			any_GetCurrentChannel_result1:ClearMessageLog()
		end
		return true
	end
	return false
end
return {
	[module.KEY_COMMAND_PROCESSOR_TYPE] = module.COMPLETED_MESSAGE_PROCESSOR;
	[module.KEY_PROCESSOR_FUNCTION] = ProcessMessage;
}