-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Client = require(ReplicatedStorage.Packages.Replion).Client
require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Thread)
require(ReplicatedStorage.Shared.SystemMessage)
require(ReplicatedStorage.Shared.AreaUtility)
require(ReplicatedStorage.Areas)
Client:WaitReplion("Area")
local v1 = Signal.new()
local FakeIslands = Instance.new("Folder")
FakeIslands.Name = "FakeIslands"
FakeIslands.Parent = workspace
workspace:WaitForChild("Islands")
workspace:WaitForChild("Characters")
workspace:WaitForChild("Vehicles")
workspace:WaitForChild("Locations")
local ReplicatedIslands = ReplicatedStorage:WaitForChild("ReplicatedIslands")
local t = {}
local t2 = {}
local t3 = {}
local t4 = {}
local CurrentCamera = workspace.CurrentCamera
return {
	Start = function(p1) --[[ Start | Line: 75 ]] end,
	IsPlayerInArea = function(p1, p2, p3) --[[ IsPlayerInArea | Line: 128 | Upvalues: Players (copy) ]]
		local Character = Players.LocalPlayer.Character
		if not Character then
			return false
		end
		local Position = Character:GetPivot().Position
		return if Position.X >= p2.X - p3.X and (Position.X <= p2.X + p3.X and (Position.Z >= p2.Z - p3.Z and (Position.Z <= p2.Z + p3.Z and Position.Y >= p2.Y - p3.Y))) then Position.Y <= p2.Y + p3.Y else false
	end,
	_insidePart = function(p1, p2, p3, p4) --[[ _insidePart | Line: 140 ]]
		local v1 = p2:PointToObjectSpace(p4)
		local v2 = p3 / 2
		return if math.abs(v1.X) <= v2.X then math.abs(v1.Z) <= v2.Z else false
	end,
	AreaAdded = function(p1, p2) --[[ AreaAdded | Line: 147 | Upvalues: HttpService (copy), t2 (copy), ReplicatedIslands (copy), t (copy), t4 (copy), t3 (copy), Signal (copy), v1 (copy), FakeIslands (copy) ]]
		local v12 = HttpService:GenerateGUID(false)
		t2[p2] = v12
		local v2 = ReplicatedIslands:WaitForChild(p2, 1)
		if not v2 then
			return
		end
		if v12 ~= t2[p2] then
			return
		end
		if not t[p2] then
			t[p2] = v2
		end
		t4[p2] = "Loading"
		t3[v12] = {}
		local v3 = t3[v12]
		local v4 = Signal.new()
		local v5 = false
		local v6 = v1:Connect(function(p1) --[[ Line: 174 | Upvalues: v12 (copy), v5 (ref), v4 (copy) ]]
			if p1 ~= v12 then
				return
			end
			v5 = true
			v4:Fire(false)
		end)
		task.spawn(function() --[[ Line: 181 | Upvalues: v2 (copy), v3 (copy), FakeIslands (ref), v5 (ref), v4 (copy) ]]
			for i, v in ipairs(v2:GetChildren()) do
				table.insert(v3, v)
				v.Parent = FakeIslands
				if i % 6 == 0 then
					task.wait(1 / 60)
				end
			end
			if v5 then
				return
			end
			v4:Fire(true)
		end)
		v4:Wait()
		for i, v in ipairs(v2:GetChildren()) do
			table.insert(v3, v)
			v.Parent = FakeIslands
		end
		v6:Disconnect()
		v4:Destroy()
		t4[p2] = "Done"
	end,
	AreaRemoved = function(p1, p2) --[[ AreaRemoved | Line: 213 | Upvalues: t4 (copy), t2 (copy), v1 (copy), t (copy), t3 (copy) ]]
		t4[p2] = "Dead"
		local v12 = t2[p2]
		if v12 then
			v1:Fire(v12)
		end
		local v2 = t[p2]
		local v3 = if v12 then t3[v12] else v12
		if v2 and v3 then
			for i, v in ipairs(v3) do
				if i % 6 == 0 then
					task.wait(1 / 60)
				end
				v.Parent = v2
			end
			t4[p2] = nil
		end
		print("Removed:", p2)
	end
}