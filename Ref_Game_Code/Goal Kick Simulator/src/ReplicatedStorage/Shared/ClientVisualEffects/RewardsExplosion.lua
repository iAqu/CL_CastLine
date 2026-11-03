-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:59
-- Luau version 6, Types version 3
-- Time taken: 0.000725 seconds

return function(arg1) -- Line 2
	return function(arg1_2) -- Line 3
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		local vector3 = Vector3.new(0, math.sin(math.pi * arg1_2) ^ 0.4 * 15, 0)
		for _, v in pairs(arg1) do
			v.Object:PivotTo(CFrame.new(v.Original:Lerp(v.Destination, arg1_2) + vector3))
		end
	end
end