-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 1 ]]
	local v1 = if typeof(p1) == "CFrame" and p1 then p1 else CFrame.new(p1)
	local host = Instance.new("Part")
	host.Anchored = true
	host.CanCollide = false
	host.Transparency = 1
	host.Material = Enum.Material.SmoothPlastic
	host.CastShadow = false
	host.Size = Vector3.new()
	host.CFrame = v1
	host.Name = "host"
	local Attachment = Instance.new("Attachment")
	Attachment.Parent = host
	host.Parent = workspace
	return host, Attachment
end