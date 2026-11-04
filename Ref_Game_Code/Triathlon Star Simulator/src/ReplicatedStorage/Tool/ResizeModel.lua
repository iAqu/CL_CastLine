-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:50
-- Luau version 6, Types version 3
-- Time taken: 0.000917 seconds

local module_upvr = {}
function module_upvr.Resize(arg1, arg2) -- Line 3
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	for _, v in next, arg1:children() do
		if v:IsA("BasePart") then
			local _, _, _, any_components_result4, any_components_result5, any_components_result6, any_components_result7, any_components_result8, any_components_result9, any_components_result10, any_components_result11, any_components_result12 = v.CFrame:components()
			v.Size *= arg2
			v.CFrame = CFrame.new(v.CFrame.p * arg2) * CFrame.new(0, 0, 0, any_components_result4, any_components_result5, any_components_result6, any_components_result7, any_components_result8, any_components_result9, any_components_result10, any_components_result11, any_components_result12)
		end
		if v:IsA("SpecialMesh") and v.MeshType == Enum.MeshType.FileMesh then
			v.Scale = Vector3.new(v.Scale.X * arg2, v.Scale.Y * arg2, v.Scale.Z * arg2)
		end
		module_upvr.Resize(v, arg2)
	end
end
return module_upvr