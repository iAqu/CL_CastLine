-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Configurations = require(script:WaitForChild("Configurations"))
local t = {}
Observers.observeTag("Maze", function(p1) --[[ Line: 20 | Upvalues: Players (copy), RunService (copy), t (copy) ]]
	local LocalPlayer = Players.LocalPlayer
	ReconfigureMaze(p1, GetMazeConfiguration())
	RunService.RenderStepped:Connect(function() --[[ Line: 25 ]]
		if not (os.time() < GetNextTimestamp()) then
			ReconfigureMaze(GetMazeConfiguration(), true)
		end
	end)
	p1.ChildAdded:Connect(function(p1) --[[ Line: 32 | Upvalues: t (ref) ]]
		p1.Position = Vector3.new(p1.Position.X, if t[p1.Name] then -291.908 else -333.908, p1.Position.Z)
	end)
end)
function GetCurrentTimestamp() --[[ GetCurrentTimestamp | Line: 40 ]]
	local v1 = os.time()
	return v1 - v1 % 7200
end
function GetNextTimestamp() --[[ GetNextTimestamp | Line: 45 ]]
	return GetCurrentTimestamp() + 7200
end
function GetMazeConfiguration() --[[ GetMazeConfiguration | Line: 49 | Upvalues: Configurations (copy) ]]
	return Random.new((GetCurrentTimestamp())):NextInteger(1, #Configurations)
end
function ReconfigureMaze(p1, p2, p3) --[[ ReconfigureMaze | Line: 56 | Upvalues: Configurations (copy), t (copy) ]]
	for i, v in ipairs(Configurations[p2]) do
		for i2, v2 in ipairs(v) do
			t[("Cell_%*_%*"):format(i - 1, i2 - 1)] = v2 == 1
		end
	end
	BuildWalls(p1, p3)
end
function BuildWalls(p1, p2) --[[ BuildWalls | Line: 70 | Upvalues: t (copy), TweenService (copy) ]]
	for v1, v2 in p1:GetChildren() do
		local v4 = Vector3.new(v2.Position.X, if t[v2.Name] then -291.908 else -333.908, v2.Position.Z)
		if p2 then
			TweenService:Create(v2, TweenInfo.new(1), {
				Position = v4
			}):Play()
			task.wait(0.1)
			continue
		end
		v2.Position = v4
	end
end
return {}