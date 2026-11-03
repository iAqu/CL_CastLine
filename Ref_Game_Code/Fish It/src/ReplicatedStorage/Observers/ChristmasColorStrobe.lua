-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Thread = require(ReplicatedStorage.Packages.Thread)
local Client = require(ReplicatedStorage.Packages.Replion).Client
require(ReplicatedStorage.Modules.GuiControl)
local t = {}
Observers.observeTag("ChristmasColorStrobe", function(p1) --[[ Line: 17 | Upvalues: t (copy) ]]
	local t2 = {}
	local t3 = {}
	local function scanPart(p1) --[[ scanPart | Line: 21 | Upvalues: t3 (copy), t2 (copy) ]]
		if not p1:IsA("BasePart") then
			return
		end
		table.insert(t3, p1)
		if table.find(t2, p1.Color) ~= nil then
			return
		end
		table.insert(t2, p1.Color)
	end
	local v1 = p1.ChildAdded:Connect(scanPart)
	for i, v in ipairs(p1:GetChildren()) do
		if v:IsA("BasePart") then
			table.insert(t3, v)
			if table.find(t2, v.Color) == nil then
				table.insert(t2, v.Color)
			end
		end
	end
	local function f2() --[[ Line: 36 | Upvalues: t3 (copy), t2 (copy) ]]
		for i, v in ipairs(t3) do
			local v1 = table.clone(t2)
			local v2 = table.find(v1, v.Color)
			if v2 then
				table.remove(v1, v2)
			end
			local v3 = if #v1 > 0 then v1[math.random(1, #v1)] else BrickColor.Random().Color
			if v3 then
				v.Color = v3
			end
		end
	end
	local v3 = t
	table.insert(v3, f2)
	return function() --[[ Line: 62 | Upvalues: v1 (copy), t2 (copy), t3 (copy), t (ref), f2 (copy) ]]
		v1:Disconnect()
		table.clear(t2)
		table.clear(t3)
		local v12 = table.find(t, f2)
		if not v12 then
			return
		end
		table.remove(t, v12)
	end
end)
Thread:Execute(0.5, function() --[[ Line: 75 | Upvalues: t (copy) ]]
	for i, v in ipairs(t) do
		v()
	end
end)
return {}