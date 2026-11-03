-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local CurveUtil = require(ReplicatedStorage.Modules.Util.CurveUtil)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
local v1 = CFrame.new(-0.000305175781, -16.0215511, -7.21850586, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local t = {
	["Luck Pad"] = Color3.fromRGB(85, 255, 0),
	["SECRET Boost Pad"] = Color3.fromRGB(150, 83, 184),
	["FORGOTTEN Boost Pad"] = Color3.fromRGB(255, 215, 0)
}
local LocalPlayer = game:GetService("Players").LocalPlayer
local v2 = workspace:WaitForChild("Easter Live Event")
local v3 = Net:RemoteEvent("Easter_ThrowEgg")
Replion.Client:AwaitReplion("Events", function(p1) --[[ Line: 27 | Upvalues: v2 (copy), LocalPlayer (copy), Soundbook (copy), TweenUtil (copy) ]]
	p1:OnArrayInsert("Events", function(p1, p2) --[[ Line: 28 | Upvalues: v2 (ref), LocalPlayer (ref), Soundbook (ref), TweenUtil (ref) ]]
		if p2 ~= "Easter Event" then
			return
		end
		local Statue = v2:FindFirstChild("Statue")
		local v1 = LocalPlayer:GetAttribute("LocationName")
		if not Statue then
			warn("Content not loaded in...")
			return
		end
		if v1 and v1 == "Easter Island" then
			Statue.Egg.Transparency = 0
			Soundbook.Sounds["Easter Event Start"]:Play()
			TweenUtil.TweenModelCFrame(Statue, Statue:GetPivot() + Vector3.new(0, 50, 0), false, TweenInfo.new(5, Enum.EasingStyle.Linear))
		else
			warn("Not in range!")
		end
	end)
	p1:OnArrayRemove("Events", function(p1, p2) --[[ Line: 42 | Upvalues: v2 (ref), LocalPlayer (ref), TweenUtil (ref) ]]
		if p2 ~= "Easter Event" then
			return
		end
		local Statue = v2:FindFirstChild("Statue")
		local v1 = LocalPlayer:GetAttribute("LocationName")
		if not Statue then
			warn("Content not loaded in...")
			return
		end
		if v1 and v1 == "Easter Island" then
			TweenUtil.TweenModelCFrame(Statue, Statue:GetPivot() - Vector3.new(0, 50, 0), false, TweenInfo.new(5, Enum.EasingStyle.Linear))
		else
			warn("Not in range!")
		end
	end)
end)
v3.OnClientEvent:Connect(function(p1, p2) --[[ Line: 55 | Upvalues: v2 (copy), LocalPlayer (copy), CurveUtil (copy), v1 (copy), TweenService (copy), TweenUtil (copy), t (copy), Soundbook (copy) ]]
	local Statue = v2:FindFirstChild("Statue")
	local v12 = LocalPlayer:GetAttribute("LocationName")
	if not Statue then
		warn("Content not loaded in...")
		return
	end
	if not v12 or v12 ~= "Easter Island" then
		warn("Not in range!")
		return
	end
	local v22 = Statue.Egg:Clone()
	local Position = Statue:GetPivot().Position
	local v3 = CFrame.lookAt(Position, (Vector3.new(p1.X, Position.Y, p1.Z)))
	local v4 = CurveUtil.GetCurveBetween({
		numPoints = 25,
		start = (v3 * v1).Position,
		finish = p1 - Vector3.new(0, 15, 0),
		curveHeight = Statue.Egg.Position.Y + 100
	})
	local Position_2 = v22.Position
	local tbl = {}
	for k, v in pairs(v4) do
		local v6 = TweenService:Create(v22, TweenInfo.new(0.5 / (Position_2 - v.Position).Magnitude, Enum.EasingStyle.Linear), {
			CFrame = v
		})
		Position_2 = v.Position
		table.insert(tbl, k, v6)
	end
	TweenUtil.TweenModelCFrame(Statue, v3, false, TweenInfo.new(5, Enum.EasingStyle.Linear))
	task.wait(1.5)
	v22.Size = v22.Size * 0.98
	v22.Color = t[p2 or "Luck Pad"]
	v22.CanTouch = false
	v22.CanQuery = false
	v22.CanCollide = false
	v22.Material = Enum.Material.Neon
	v22.CFrame = Statue.Egg.CFrame
	v22.Parent = workspace.CurrentCamera
	TweenService:Create(Statue.Egg, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Transparency = 1
	}):Play()
	task.wait(0.2)
	for k, v in pairs(tbl) do
		v:Play()
		if k ~= #tbl then
			v.Completed:Wait()
		end
	end
	v22:Destroy()
	Soundbook.Sounds["RockWater Splash"]:Play()
end)
return {}