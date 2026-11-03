-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:37
-- Luau version 6, Types version 3
-- Time taken: 0.000421 seconds

local module = require(script.Parent:WaitForChild("Util"))
function CreateUnknownMessageLabel(arg1) -- Line 13
	print("No message creator for message: "..arg1.Message)
end
return {
	[module.KEY_MESSAGE_TYPE] = "UnknownMessage";
	[module.KEY_CREATOR_FUNCTION] = CreateUnknownMessageLabel;
}