-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:57
-- Luau version 6, Types version 3
-- Time taken: 0.000481 seconds

for _, v in pairs(script.Parent:GetChildren()) do
	if v:IsA("Frame") then
		if v.Name == "UIAnima" or v.Name == "详情" or v.Name == "Main" then
			v.Visible = true
		else
			v.Visible = false
		end
	end
end