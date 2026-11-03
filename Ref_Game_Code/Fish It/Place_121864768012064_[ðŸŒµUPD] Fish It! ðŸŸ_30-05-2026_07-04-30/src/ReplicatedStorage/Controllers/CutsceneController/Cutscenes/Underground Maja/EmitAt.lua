-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
game:GetService("ReplicatedStorage")
local function emit(p1) --[[ emit | Line: 4 ]]
	if not p1 or typeof(p1) == "table" then
		return
	end
	if not (p1 and p1:IsA("ParticleEmitter")) then
		return
	end
	local v1 = p1:GetAttribute("EmitCount") or 1
	local v2 = p1:GetAttribute("EmitDelay")
	if v2 and (typeof(v2) == "number" and v2 > 0) then
		task.delay(v2, p1.Emit, p1, v1)
	else
		p1:Emit(v1)
	end
end
local function setVisible(p1, p2) --[[ setVisible | Line: 18 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2.Name ~= "String beams" and (v2.Name ~= "String Attachments" and (string.find(v2.Name, "Handle") == nil or v2.Parent:IsA("Accessory"))) and v2.Parent.Name ~= "Carrot RIG" then
			if v2:IsA("BasePart") and v2.Name ~= "HumanoidRootPart" then
				v2.Transparency = if p2 then 0 else 1
				continue
			end
			if v2:IsA("Decal") or v2:IsA("ImageLabel") then
				v2.Transparency = if p2 then 0 else 1
				continue
			end
			if v2:IsA("Beam") then
				v2.Enabled = p2
			end
		end
	end
end
return {}