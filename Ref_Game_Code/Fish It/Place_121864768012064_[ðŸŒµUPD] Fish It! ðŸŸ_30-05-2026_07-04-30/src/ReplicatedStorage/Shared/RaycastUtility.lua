-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
RunService:IsServer()
RunService:IsClient()
local Characters = workspace:WaitForChild("Characters")
local CosmeticFolder = workspace:WaitForChild("CosmeticFolder")
local Vehicles = workspace:WaitForChild("Vehicles")
local Locations = workspace:WaitForChild("Locations")
workspace:WaitForChild("Zones")
local t = {
	GetBoat = function(p1, p2) --[[ GetBoat | Line: 16 | Upvalues: Vehicles (copy) ]]
		for i, v in ipairs((Vehicles:GetChildren())) do
			if v:GetAttribute("OwnerId") == p2.UserId then
				return v
			end
		end
	end
}
function t.getFilteredTargets(p1, p2) --[[ getFilteredTargets | Line: 29 | Upvalues: CosmeticFolder (copy), Characters (copy), Locations (copy), Vehicles (copy), t (copy) ]]
	local t2 = { CosmeticFolder, Characters, Locations }
	local v1 = Vehicles:GetChildren()
	local v2 = t:GetBoat(p2)
	if v2 then
		for i, v in ipairs(v1) do
			if v ~= v2 then
				table.insert(t2, v)
			end
		end
	else
		for i, v in ipairs(v1) do
			table.insert(t2, v)
		end
	end
	return t2
end
return t