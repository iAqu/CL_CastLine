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
local function setAccessories(p1, p2) --[[ setAccessories | Line: 18 ]]
	for v1, v2 in p1:GetChildren() do
		if v2:IsA("Accessory") then
			for v3, v4 in v2:GetDescendants() do
				if v4:IsA("BasePart") or v4:IsA("Decal") then
					if not (p2 or v4:GetAttribute("OGTransparency")) then
						v4:SetAttribute("OGTransparency", v4.Transparency)
					end
					v4.Transparency = if p2 then v4:GetAttribute("OGTransparency") or 0 else 1
				end
			end
		end
	end
	if not (p2 or p1.Head:GetAttribute("TextureId")) then
		p1.Head:SetAttribute("TextureId", p1.Head.Mesh.TextureId)
	end
	p1.Head.face.Transparency = if p2 then 0 else 1
	p1.Head.Mesh.TextureId = if p2 then p1.Head:GetAttribute("TextureId") or "" else ""
	p1.Head.Transparency = if p2 then 0 else 1
end
return {
	[247] = function() --[[ Line: 43 | Upvalues: setAccessories (copy) ]]
		setAccessories(workspace.CutsceneStuff.Character, false)
	end,
	[622] = function() --[[ Line: 46 | Upvalues: setAccessories (copy) ]]
		setAccessories(workspace.CutsceneStuff.Character, true)
	end,
	[1117] = function() --[[ Line: 49 | Upvalues: setAccessories (copy) ]]
		setAccessories(workspace.CutsceneStuff.Character, false)
	end
}