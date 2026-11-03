-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)
require(ReplicatedStorage.Modules.Util.TableUtil)
require(ReplicatedStorage.Types.Modifiers)
local v1 = Loader.LoadChildren(script)
if RunService:IsServer() then
	local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
	local function getVariantFromId(p1) --[[ getVariantFromId | Line: 62 | Upvalues: v1 (copy) ]]
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
	local v6 = TableUtil.Count(v1)
	if v2 ~= v6 then
		for i = 1, math.max(v6, v2) do
			local v7 = nil
			for v8, v9 in v1 do
				if v9.Data.Id == i then
					v7 = v9
					break
				end
			end
			if v7 == nil then
				task.spawn(error, (("[VARIANTS] ENTRY MISSING FROM %* @ ID: %*"):format(script.Name, i)))
			end
		end
	end
	local t = {}
	for v10, v11 in v1 do
		if t[v11.Data.Id] then
			task.spawn(error, (("[VARIANTS] DUPLICATE ENTRY FOUND: %* - %*"):format(v10, v11.Data.Name)))
		end
		t[v11.Data.Id] = true
	end
	table.clear(t)
end
return v1