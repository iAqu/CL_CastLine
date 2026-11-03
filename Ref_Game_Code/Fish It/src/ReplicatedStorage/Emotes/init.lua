-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = require(ReplicatedStorage.Packages.Loader).LoadChildren(script)
if RunService:IsServer() then
	local t = {}
	for v2, v3 in v1 do
		if t[v3.Data.Id] then
			task.spawn(error, (("[EMOTES] DUPLICATE ENTRY FOUND: %* - %*"):format(v2, v3.Data.Name)))
		end
		t[v3.Data.Id] = true
	end
	table.clear(t)
end
return v1