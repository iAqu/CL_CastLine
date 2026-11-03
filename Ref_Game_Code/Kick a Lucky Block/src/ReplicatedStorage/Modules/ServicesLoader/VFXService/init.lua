-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {}
local t2 = {}
function t.PlayVFX(p1, ...) --[[ PlayVFX | Line: 11 | Upvalues: t2 (copy) ]]
	if t2[p1] then
		task.spawn(t2[p1], ...)
	end
end
function t._init() --[[ _init | Line: 17 | Upvalues: t2 (copy), Network (copy), t (copy) ]]
	for v1, v2 in script:GetChildren() do
		if v2:IsA("ModuleScript") then
			t2[v2.Name] = require(v2)
		end
	end
	Network.OnClientEvent("VFX_UPD"):Connect(t.PlayVFX)
end
return t