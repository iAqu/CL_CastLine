-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:26
-- Luau version 6, Types version 3
-- Time taken: 0.000384 seconds

return {
	overrideWithBlank = function(arg1) -- Line 8, Named "overrideWithBlank"
		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.Image = ""
		ImageLabel.Size = UDim2.new(0, 100, 0, 100)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Visible = true
		ImageLabel.Name = "SelectionImage"
		arg1.SelectionImageObject = ImageLabel
		return ImageLabel
	end;
}