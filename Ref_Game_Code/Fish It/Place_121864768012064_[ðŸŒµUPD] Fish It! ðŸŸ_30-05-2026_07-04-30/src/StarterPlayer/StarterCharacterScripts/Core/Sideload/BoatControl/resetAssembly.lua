-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ resetAssembly | Line: 2 ]]
	local v1 = p1:FindFirstChildWhichIsA("LinearVelocity")
	if v1 then
		v1.VectorVelocity = Vector3.new(0, 0, 0)
	end
	local v2 = p1.Parent
	if not v2 then
		p1.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		p1.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		return
	end
	for i, v in ipairs(v2:GetDescendants()) do
		if v:IsA("BasePart") then
			v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end
end