-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.PlayerEvents)
local v1 = require(ReplicatedStorage.Packages.Loader).LoadChildren(script:WaitForChild("Modules"))
for v2, v3 in v1 do
	if v3.Init then
		v3:Init()
	end
end
for v4, v5 in v1 do
	if v5.Start then
		task.spawn(v5.Start, v5)
	end
end
script.Destroying:Once(function() --[[ Line: 23 | Upvalues: v1 (copy) ]]
	table.clear(v1)
end)