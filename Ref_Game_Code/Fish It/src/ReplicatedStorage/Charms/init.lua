-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)
require(ReplicatedStorage.Types.Modifiers)
local v1 = Loader.LoadChildren(script)
if RunService:IsServer() then
	require(ReplicatedStorage.Modules.Util.TableUtil)
	local function getCharmFromId(p1) --[[ getCharmFromId | Line: 44 | Upvalues: v1 (copy) ]]
		for v12, v2 in v1 do
			if v2.Data.Id == p1 then
				return v2
			end
		end
	end
	local v2 = -1
	for v3, v4 in v1 do
		v2 = math.max(v2, v4.Data.Id)
	end
	local t = {}
	for v6, v7 in v1 do
		if t[v7.Data.Id] then
			task.spawn(error, (("[CHARMS] DUPLICATE ENTRY FOUND: %* - %*"):format(v6, v7.Data.Name)))
		end
		t[v7.Data.Id] = true
	end
	table.clear(t)
end
return v1