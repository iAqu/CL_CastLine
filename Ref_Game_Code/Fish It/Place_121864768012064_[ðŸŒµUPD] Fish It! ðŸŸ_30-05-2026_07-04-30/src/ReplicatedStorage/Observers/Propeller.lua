-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Shared.DrawSeatUtility)
require(ReplicatedStorage.Shared.ItemUtility)
local BoatsHandlingData = require(ReplicatedStorage.Shared.BoatsHandlingData)
require(ReplicatedStorage.Boats)
local t = {}
RunService.Heartbeat:Connect(function(p1) --[[ Line: 28 | Upvalues: t (copy) ]]
	for i, v in ipairs(t) do
		local Motor = v.Motor
		Motor.DesiredAngle = Motor.DesiredAngle + v.Speed * p1
	end
end)
local function Remove(p1) --[[ Remove | Line: 36 | Upvalues: t (copy) ]]
	for i, v in ipairs(t) do
		if v.UUID == p1 then
			table.remove(t, i)
			return
		end
	end
end
Observers.observeTag("Propeller", function(p1) --[[ Line: 45 | Upvalues: BoatsHandlingData (copy), HttpService (copy), t (copy), Remove (copy) ]]
	local v1 = p1.Parent
	if not v1 then
		return
	end
	local v2 = BoatsHandlingData[v1.Name]
	if not v2 then
		return
	end
	local Weld = p1:WaitForChild("Weld", 30)
	if Weld then
		local v3 = HttpService:GenerateGUID(false)
		table.insert(t, {
			UUID = v3,
			Motor = Weld,
			Speed = v2.Speed / 20
		})
		Weld.MaxVelocity = 1000
		return function() --[[ Line: 72 | Upvalues: Remove (ref), v3 (copy) ]]
			Remove(v3)
		end
	end
end, { workspace })
return {}