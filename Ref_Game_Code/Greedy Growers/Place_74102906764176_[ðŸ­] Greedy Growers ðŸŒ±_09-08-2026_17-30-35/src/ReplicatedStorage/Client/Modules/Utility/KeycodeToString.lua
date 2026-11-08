-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMVBEVudW0HS2V5Q29kZQlMZWZ0U2hpZnQHTCBTaGlmdApSaWdodFNoaWZ0B1IgU2hpZnQLTGVmdENvbnRyb2wGTCBDdHJsDFJpZ2h0Q29udHJvbAZSIEN0cmwHTGVmdEFsdAVMIEFsdAhSaWdodEFsdAVSIEFsdANUYWIFU3BhY2UIU3BhY2ViYXITR2V0U3RyaW5nRm9yS2V5Q29kZQRnYW1lEFVzZXJJbnB1dFNlcnZpY2UKR2V0U2VydmljZQACBAEBAAAAQqQBAwACBADAmgADAAEAAABvAQQAggECAKQBBgAFBADAmgADAAEAAABvAQcAggECAKQBCQAIBADAmgADAAEAAABvAQoAggECAKQBDAALBADAmgADAAEAAABvAQ0AggECAKQBDwAOBADAmgADAAEAAABvARAAggECAKQBEgARBADAmgADAAEAAABvARMAggECAKQBFQAUBADAmgADAAEAAABvARQAggECAKQBFwAWBADAmgADAAEAAABvARgAggECAKQBCQAIBADAmgADAAEAAABvAQoAggECAKQBDAALBADAmgADAAEAAABvAQ0AggECAPsBAABSAwAAvAEBExkAAACfAQMAggEAABoDAQMCAwMEAgQAwAMEAwUEBQQAwAMGAwcECAQAwAMIAwkECwQAwAMKAwsEDgQAwAMMAw0EEQQAwAMOAw8EFAQAwAMQBBYEAMADEQMSAAMAARgAAAAAAQACAAAAAQACAAAAAQACAAAAAQACAAAAAQACAAAAAQACAAAAAQACAAAAAQACAAAAAQACAAAAAQACAAAAAAAEAAAAAAMAAAECAAqjAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCwAEEABIAAACCAQIABQMTBAAAAEADFAMVBgABAAEAARgAAAAAAAAAAgAAAQAAAAABI+qif1lwnMNy5KozkR4h11PytQsRLsh+

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")

return function(p1) --[[ Line: 3 | Upvalues: UserInputService (copy) ]]
	if p1 == Enum.KeyCode.LeftShift then
		return "L Shift"
	end

	if p1 == Enum.KeyCode.RightShift then
		return "R Shift"
	end

	if p1 == Enum.KeyCode.LeftControl then
		return "L Ctrl"
	end

	if p1 == Enum.KeyCode.RightControl then
		return "R Ctrl"
	end

	if p1 == Enum.KeyCode.LeftAlt then
		return "L Alt"
	end

	if p1 == Enum.KeyCode.RightAlt then
		return "R Alt"
	end

	if p1 == Enum.KeyCode.Tab then
		return "Tab"
	end

	if p1 == Enum.KeyCode.Space then
		return "Spacebar"
	end

	if p1 == Enum.KeyCode.LeftControl then
		return "L Ctrl"
	end

	if p1 == Enum.KeyCode.RightControl then
		return "R Ctrl"
	end

	return UserInputService:GetStringForKeyCode(p1)
end