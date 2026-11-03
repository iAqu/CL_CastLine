-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local spr = require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Packages.Trove)
local Spring = require(ReplicatedStorage.AceworksUtils.Spring)
require(ReplicatedStorage.Modules.CameraShaker)
local CurrentCamera = workspace.CurrentCamera
return function(p1, p2, p3) --[[ animate | Line: 29 | Upvalues: Players (copy), CurrentCamera (copy), Spring (copy), RunService (copy), spr (copy), UserInputService (copy) ]]
	local v1 = Players.LocalPlayer:GetMouse()
	local v2 = math.random(0, 1000)
	local v3 = p1.CFrame
	local Y = p1.CFrame.Position.Y
	local FieldOfView = CurrentCamera.FieldOfView
	local v4 = 0
	local v5 = 0
	local function shakeCamera(p1) --[[ shakeCamera | Line: 42 | Upvalues: CurrentCamera (ref) ]]
		local v1 = CurrentCamera
		v1.CFrame = v1.CFrame * p1
	end
	local t = {
		catch = Spring.new(2, 0.5, Vector3.new(0, 0, 0)),
		noiseMultiplier = Spring.new(0.5, 1, 0),
		noise = Spring.new(1, 0.5, 0),
		progress = Spring.new(0.75, 0.3, Vector3.new(0, 0, 0))
	}
	t.catch:addVelocity(Vector3.new(0, -10, 0))
	p3:Add(RunService.Heartbeat:Connect(function(p12) --[[ Line: 75 | Upvalues: p2 (copy), p1 (copy), v4 (ref), v3 (copy), Y (copy), t (copy), v2 (copy) ]]
		local v1 = p2()
		if not v1 or (not p1 or p1.Parent == nil) then
			return
		end
		v4 = math.max(0, v4 - p12 * 1)
		local v42 = Vector3.new(v3.Position.X, Y, v3.Position.Z)
		local v6 = Vector3.new(v1.Position.X, Y, v1.Position.Z)
		if not t.progress then
			return
		end
		t.progress:setTarget((v42 - v6).Unit * math.map(v4, 0, 1, 2.75, -2.75))
		t.noiseMultiplier:setTarget(math.sin(time() * 1) * 1)
		t.noise:setTarget(math.noise(time() * 0.8 + v2) * 8 * t.noiseMultiplier:getPosition())
		for v8, v9 in t do
			v9:update(p12)
		end
		local v10 = CFrame.new(t.noise:getPosition(), 0, 0)
		local v11 = t.progress:getPosition()
		local v12 = t.catch:getPosition()
		p1.CFrame = CFrame.lookAt(v42, v6) * v10 + v11 + v12
	end))
	local function screenInteraction() --[[ screenInteraction | Line: 105 | Upvalues: v4 (ref), v5 (ref), spr (ref), CurrentCamera (ref), FieldOfView (copy) ]]
		v4 = math.min(1, v4 + 0.14285714285714285)
		local v2 = os.clock()
		if not (v2 - v5 > 0.06) then
			return
		end
		v5 = v2
		spr.stop(CurrentCamera)
		spr.target(CurrentCamera, 1, 4, {
			FieldOfView = FieldOfView + 5
		})
		task.wait(0.1)
		spr.stop(CurrentCamera)
		spr.target(CurrentCamera, 1, 6, {
			FieldOfView = FieldOfView
		})
	end
	p3:Add(UserInputService.TouchTapInWorld:Connect(screenInteraction))
	p3:Add(v1.Button1Down:Connect(screenInteraction))
	p3:Add(function() --[[ Line: 130 | Upvalues: spr (ref), CurrentCamera (ref) ]]
		spr.stop(CurrentCamera)
	end)
end