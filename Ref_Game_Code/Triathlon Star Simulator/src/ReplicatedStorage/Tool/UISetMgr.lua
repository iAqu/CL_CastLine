-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:47
-- Luau version 6, Types version 3
-- Time taken: 0.000883 seconds

local module_upvr = {}
function module_upvr.UpdateUIStroke(arg1, arg2) -- Line 3
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var6
	if var6 then
		var6 = arg1:GetAttribute("NormalTickness")
		if not var6 then
			var6 = arg1.Thickness
			arg1:SetAttribute("NormalTickness", var6)
		end
		local var7 = arg2 * var6
		if var6 < var7 then
			arg1.Thickness = var6
		end
		if var7 < 1 then
			arg1.Thickness = 1
		end
	end
	for _, v in pairs(arg1:GetChildren()) do
		module_upvr.UpdateUIStroke(v, arg2)
	end
end
return module_upvr