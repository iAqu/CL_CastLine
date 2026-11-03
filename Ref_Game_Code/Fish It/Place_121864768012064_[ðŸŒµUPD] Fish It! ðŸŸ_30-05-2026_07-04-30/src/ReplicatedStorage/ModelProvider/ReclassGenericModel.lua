-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Reclass | Line: 2 ]]
	local v1 = if p2 then p2 else p1.Name
	local v2 = p1:Clone()
	local Handle = v2:FindFirstChild("Handle")
	local v3 = v2:GetChildren()
	local v4 = v2:GetPivot()
	local Model = Instance.new("Model")
	Model.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	Model.Name = v1
	Model:SetAttribute("UseCosmeticBulletObject", true)
	Model:PivotTo(v4)
	if Handle then
		Instance.new("Attachment").Parent = Handle
	end
	for i, v in ipairs(v3) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
		v.Parent = Model
	end
	if not Handle then
		v2:Destroy()
		return Model
	end
	local Handle_2 = Model.Handle
	Handle_2.Anchored = true
	Model.PrimaryPart = Handle_2
	for i, v in ipairs(Model:GetDescendants()) do
		if v ~= Handle_2 and v:IsA("BasePart") then
			local WeldConstraint = Instance.new("WeldConstraint")
			WeldConstraint.Parent = Handle_2
			WeldConstraint.Part0 = Handle_2
			WeldConstraint.Part1 = v
			v.Anchored = false
		end
	end
	v2:Destroy()
	Model.Parent = workspace
	return Model
end