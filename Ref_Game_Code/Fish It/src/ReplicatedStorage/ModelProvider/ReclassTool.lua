-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ ReclassTool | Line: 2 ]]
	p1.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	p1.CanBeDropped = false
	p1.Name = p2
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Massless = true
		end
	end
	return p1
end