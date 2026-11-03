-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:37
-- Luau version 6, Types version 3
-- Time taken: 0.000560 seconds

return function(arg1) -- Line 18, Named "getRotationInXZPlane"
	local _, _, _, _, _, any_GetComponents_result6, _, _, any_GetComponents_result9, _, _, any_GetComponents_result12 = arg1:GetComponents()
	local unit = Vector3.new(any_GetComponents_result6, 0, any_GetComponents_result12).unit
	if unit ~= unit then
		return arg1
	end
	local any_Cross_result1 = Vector3.new(0, 1, 0):Cross(unit)
	return CFrame.new(arg1.X, arg1.Y, arg1.Z, any_Cross_result1.X, Vector3.new(0, 1, 0).X, unit.X, any_Cross_result1.Y, Vector3.new(0, 1, 0).Y, unit.Y, any_Cross_result1.Z, Vector3.new(0, 1, 0).Z, unit.Z)
end