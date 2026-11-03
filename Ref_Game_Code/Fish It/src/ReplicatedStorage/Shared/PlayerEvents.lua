-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local t = {}
local t2 = {}
local t3 = {}
function RunCallback(p1) --[[ RunCallback | Line: 13 | Upvalues: Players (copy) ]]
	for i, v in ipairs(Players:GetPlayers()) do
		task.spawn(p1, v)
	end
end
function t3.PlayerAdded(p1, p2) --[[ PlayerAdded | Line: 19 | Upvalues: t (copy), t2 (copy) ]]
	table.insert(t, p2)
	RunCallback(p2)
	return {
		Disconnect = function(p1) --[[ Disconnect | Line: 24 | Upvalues: t2 (ref), p2 (copy) ]]
			local v1 = table.find(t2, p2)
			if not v1 then
				return
			end
			table.remove(t2, v1)
		end
	}
end
function t3.PlayerRemoving(p1, p2) --[[ PlayerRemoving | Line: 33 | Upvalues: t2 (copy) ]]
	local v1 = t2
	table.insert(v1, p2)
	return {
		Disconnect = function(p1) --[[ Disconnect | Line: 37 | Upvalues: t2 (ref), p2 (copy) ]]
			local v1 = table.find(t2, p2)
			if not v1 then
				return
			end
			table.remove(t2, v1)
		end
	}
end
Observers.observePlayer(function(p1) --[[ Line: 46 | Upvalues: t (copy), t2 (copy) ]]
	for i, v in ipairs(t) do
		task.spawn(v, p1)
	end
	return function() --[[ Line: 51 | Upvalues: t2 (ref), p1 (copy) ]]
		for i, v in ipairs(t2) do
			task.spawn(v, p1)
		end
	end
end)
return t3