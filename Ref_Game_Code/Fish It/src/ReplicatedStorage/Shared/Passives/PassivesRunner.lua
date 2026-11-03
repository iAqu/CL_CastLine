-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local Replion = require(ReplicatedStorage.Packages.Replion)
local Loader = require(ReplicatedStorage.Packages.Loader)
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Shared.Passives.PassivesTypes)
local v3 = Loader.LoadChildren(ReplicatedStorage.Passives)
local function getPassives(p1, p2) --[[ getPassives | Line: 15 | Upvalues: v3 (copy) ]]
	local t = {}
	for k, v in pairs(v3) do
		if v.Validate(p1, p2) then
			table.insert(t, k)
		end
	end
	return t
end
Observers.observeCharacter(function(p1, p2) --[[ Line: 27 | Upvalues: v1 (copy), Replion (copy), v2 (copy), v3 (copy), getPassives (copy) ]]
	local v12 = nil
	if v1 then
		v12 = Replion.Server:WaitReplionFor(p1, "Data")
	elseif v2 and p1 == game.Players.LocalPlayer then
		v12 = Replion.Client:WaitReplion("Data")
	end
	local t = {}
	local t2 = {}
	local t3 = {}
	local function removePassive(p1) --[[ removePassive | Line: 40 | Upvalues: t3 (copy), t2 (copy) ]]
		t3[p1] = nil
		local v1 = t2[p1]
		if not v1 then
			return
		end
		v1()
		t2[p1] = nil
	end
	local function addPassive(p12) --[[ addPassive | Line: 50 | Upvalues: v3 (ref), t3 (copy), p1 (copy), p2 (copy), v12 (ref), t2 (copy) ]]
		local v1 = v3[p12]
		if not v1 then
			t3[p12] = nil
			return
		end
		local v2 = v1.Callback(p1, p2, v12)
		if t3[p12] then
			t3[p12] = nil
			if v2 then
				t2[p12] = v2
			else
				t2[p12] = nil
			end
		else
			if not v2 then
				return
			end
			pcall(v2)
		end
	end
	local function onDataChange() --[[ onDataChange | Line: 74 | Upvalues: v12 (ref), getPassives (ref), p1 (copy), t2 (copy), t3 (copy), removePassive (copy), addPassive (copy) ]]
		if v12 and v12.Destroyed then
			return
		end
		local v1 = getPassives(p1, v12)
		local list = {}
		local list2 = {}
		for v2 in t2 do
			if table.find(v1, v2) == nil then
				table.insert(list, v2)
			end
		end
		for i, v in ipairs(v1) do
			if t2[v] == nil and not t3[v] then
				table.insert(list2, v)
			end
		end
		for i, v in ipairs(list) do
			pcall(removePassive, v)
		end
		for i, v in ipairs(list2) do
			t3[v] = true
			task.spawn(addPassive, v)
		end
	end
	table.insert(t, p1.AttributeChanged:Connect(onDataChange))
	onDataChange()
	return function() --[[ Line: 114 | Upvalues: t (copy), t2 (copy), removePassive (copy), t3 (copy) ]]
		for i, v in ipairs(t) do
			v:Disconnect()
		end
		for v1 in t2 do
			pcall(removePassive, v1)
		end
		table.clear(t3)
		table.clear(t)
	end
end)
return {}