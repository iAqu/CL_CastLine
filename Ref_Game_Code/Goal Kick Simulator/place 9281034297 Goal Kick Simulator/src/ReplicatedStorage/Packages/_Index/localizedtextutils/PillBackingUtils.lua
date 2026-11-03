-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:21
-- Luau version 6, Types version 3
-- Time taken: 0.001070 seconds

return {
	setBackgroundColor = function(arg1, arg2) -- Line 8, Named "setBackgroundColor"
		assert(arg1:IsA("Frame"))
		arg1.BackgroundColor3 = arg2
		for _, v in pairs(arg1:GetChildren()) do
			if v:IsA("ImageLabel") then
				v.ImageColor3 = arg2
			end
		end
	end;
	setTransparency = function(arg1, arg2) -- Line 18, Named "setTransparency"
		assert(arg1:IsA("Frame"))
		arg1.BackgroundTransparency = arg2
		for _, v_2 in pairs(arg1:GetChildren()) do
			if v_2:IsA("ImageLabel") then
				v_2.ImageTransparency = arg2
			end
		end
	end;
	setShadowTransparency = function(arg1, arg2) -- Line 28, Named "setShadowTransparency"
		arg1.ImageTransparency = arg2
		for _, v_3 in pairs(arg1:GetChildren()) do
			if v_3:IsA("ImageLabel") then
				v_3.ImageTransparency = arg2
			end
		end
	end;
}