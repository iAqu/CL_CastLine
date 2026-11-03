-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ ReclassFishProjectile | Line: 2 ]]
	local v1 = p1:Clone()
	local v2 = v1:GetChildren()
	local v3 = v1:GetPivot()
	local Model = Instance.new("Model")
	Model.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	Model.Name = v1.Name
	Model:SetAttribute("UseCosmeticBulletObject", true)
	Model:PivotTo(v3)
	Instance.new("Attachment").Parent = v1.Handle
	for i, v in ipairs(v2) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
		v.Parent = Model
	end
	Model.PrimaryPart = Model.Handle
	Model.PrimaryPart.Anchored = true
	v1:Destroy()
	Model.Parent = workspace.CosmeticFolder
	return Model
end