-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {}
local v1 = OverlapParams.new()
v1.FilterType = Enum.RaycastFilterType.Include
local t2 = {
	Zone = "None",
	ZoneChanged = Signal.new()
}
function LoadZones() --[[ LoadZones | Line: 23 | Upvalues: t (copy) ]]
	local Areas = workspace:WaitForChild("Areas")
	for i, v in ipairs(Areas:GetChildren()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			v.CanQuery = true
			v.CanCollide = false
			table.insert(t, v)
		end
	end
	Areas.ChildAdded:Connect(function(p1) --[[ Line: 36 | Upvalues: t (ref) ]]
		if p1:IsA("BasePart") or p1:IsA("MeshPart") then
			p1.CanQuery = true
			p1.CanCollide = false
			if not table.find(t, p1) then
				table.insert(t, p1)
			end
		end
	end)
	Areas.ChildRemoved:Connect(function(p1) --[[ Line: 49 | Upvalues: t (ref) ]]
		local v1 = table.find(t, p1)
		if v1 then
			table.remove(t, v1)
		end
	end)
end
function UpdateParams(p1) --[[ UpdateParams | Line: 57 | Upvalues: v1 (copy) ]]
	if p1 then
		v1.FilterDescendantsInstances = { (p1:WaitForChild("HumanoidRootPart")) }
	end
end
function t2.UpdateZone(p1) --[[ UpdateZone | Line: 68 | Upvalues: t (copy), v1 (copy) ]]
	local v12 = nil
	for i, v in ipairs(t) do
		if #workspace:GetPartsInPart(v, v1) > 0 then
			v12 = v.Name
		else
			continue
		end
		break
	end
	if not v12 then
		v12 = "None"
	end
	if v12 ~= p1.Zone then
		p1.Zone = v12
		p1.ZoneChanged:Fire(v12)
	end
end
function t2._init(p1) --[[ _init | Line: 91 | Upvalues: LocalPlayer (copy) ]]
	LoadZones()
	UpdateParams(LocalPlayer.Character)
	LocalPlayer.CharacterAdded:Connect(UpdateParams)
end
return t2