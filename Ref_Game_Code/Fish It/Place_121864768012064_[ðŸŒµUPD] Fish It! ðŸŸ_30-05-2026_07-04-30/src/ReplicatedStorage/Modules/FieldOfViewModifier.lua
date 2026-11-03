-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local spr = require(ReplicatedStorage.Packages.spr)
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = 65
local CurrentCamera = workspace.CurrentCamera
local v2 = Signal.new()
local v3 = Signal.new()
local t = {}
local t2 = {
	Wait = function(p1) --[[ Wait | Line: 27 | Upvalues: spr (copy), CurrentCamera (copy), v3 (copy) ]]
		task.defer(function() --[[ Line: 28 | Upvalues: spr (ref), CurrentCamera (ref), v3 (ref) ]]
			spr.completed(CurrentCamera, function() --[[ Line: 29 | Upvalues: v3 (ref) ]]
				v3:Fire()
			end)
		end)
		v3:Wait()
	end,
	Add = function(p1, p2, p3, p4) --[[ Add | Line: 37 | Upvalues: t (copy), v2 (copy) ]]
		if not t[p2] then
			t[p2] = {
				Priority = p3,
				Value = p4
			}
			v2:Fire()
		end
	end,
	Remove = function(p1, p2) --[[ Remove | Line: 46 | Upvalues: t (copy), v2 (copy) ]]
		if t[p2] then
			t[p2] = nil
			v2:Fire()
		end
	end,
	Reset = function(p1) --[[ Reset | Line: 54 | Upvalues: t (copy), v2 (copy) ]]
		table.clear(t)
		v2:Fire()
	end
}
v2:Connect(function() --[[ Line: 59 | Upvalues: t (copy), v1 (ref), spr (copy), CurrentCamera (copy) ]]
	local sum = 65
	for v12, v2 in t do
		sum = sum + v2.Value
	end
	if sum == v1 then
		return
	end
	v1 = sum
	spr.stop(CurrentCamera)
	spr.target(CurrentCamera, 50, 450, {
		FieldOfView = sum
	})
end)
return t2