-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
game:GetService("TweenService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local ParticleEmitter = require(ReplicatedStorage.Modules.ParticleEmitter)
local Net = require(ReplicatedStorage.Packages.Net)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local LocalPlayer = Players.LocalPlayer
local v1 = Net:RemoteEvent("EasterEggTarget")
local function LaunchEgg(p1, p2, p3) --[[ LaunchEgg | Line: 21 | Upvalues: spr (copy), Trove (copy), RunService (copy), ParticleEmitter (copy), Soundbook (copy) ]]
	if p1 then
		local v1 = p1:Clone()
		v1.Anchored = true
		v1.CanCollide = false
		v1.CanQuery = false
		v1.CanTouch = false
		v1.Parent = workspace
		p1.Transparency = 1
		local Size = v1.Size
		spr.target(v1, 0.6, 4, {
			CFrame = v1.CFrame + Vector3.new(0, 15, 0)
		})
		task.wait(0.6)
		spr.stop(v1)
		task.wait()
		local Position = v1.Position
		local function GetTargetPos() --[[ GetTargetPos | Line: 57 | Upvalues: p2 (copy), p3 (copy) ]]
			local v1 = p2 and p2.Character
			local v2 = if v1 then v1:FindFirstChild("HumanoidRootPart") else v1
			return v2 and v2.Position + Vector3.new(0, 1, 0) or p3
		end
		local function GetControlPoint(p1) --[[ GetControlPoint | Line: 64 | Upvalues: Position (copy) ]]
			return (Position + p1) / 2 + Vector3.new(0, (Position - p1).Magnitude * 0.6, 0)
		end
		local v3 = Trove.new()
		local v4 = 0
		v3:Add(RunService.Heartbeat:Connect(function(p12) --[[ Line: 76 | Upvalues: v4 (ref), p2 (copy), p3 (copy), Position (copy), v1 (copy), v3 (copy), ParticleEmitter (ref), spr (ref), Soundbook (ref), p1 (copy) ]]
			v4 = v4 + p12
			local v2 = math.clamp(v4 / 3, 0, 1)
			local v32 = p2 and p2.Character
			local v42 = if v32 then v32:FindFirstChild("HumanoidRootPart") else v32
			local v5 = v42 and v42.Position + Vector3.new(0, 1, 0) or p3
			local v8 = (Position + v5) / 2 + Vector3.new(0, (Position - v5).Magnitude * 0.6, 0)
			local v9 = 1 - v2
			local v10 = v9 * v9 * Position + v9 * 2 * v2 * v8 + v2 * v2 * v5
			local v11 = v9 * 2 * (v8 - Position) + v2 * 2 * (v5 - v8)
			if v11.Magnitude > 0.01 then
				v1.CFrame = CFrame.lookAt(v10, v10 + v11.Unit)
			else
				v1.CFrame = CFrame.new(v10)
			end
			if not (v2 >= 1 or (v5 - v10).Magnitude < 2.5) then
				return
			end
			v3:Destroy()
			ParticleEmitter.emitParticlesAt("Egg Explosion VFX", v1.Position, workspace)
			spr.target(v1, 0.25, 4, {
				Size = Vector3.new(0, 0, 0)
			})
			Soundbook:RenderAt("EggExplosion", v1.Position)
			task.delay(0.35, function() --[[ Line: 121 | Upvalues: spr (ref), v1 (ref), p1 (ref) ]]
				spr.stop(v1)
				v1:Destroy()
				p1.Transparency = 0
			end)
		end))
	end
end
Observers.observeTag("EasterBasketRNG", function(p1) --[[ Line: 132 | Upvalues: Trove (copy), v1 (copy), LaunchEgg (copy) ]]
	local v12 = Trove.new()
	local Eggs = p1:WaitForChild("Eggs")
	Eggs:WaitForChild("Egg")
	if #Eggs:GetChildren() == 0 then
		return function() --[[ Line: 143 | Upvalues: v12 (copy) ]]
			v12:Destroy()
		end
	else
		v1.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 149 | Upvalues: Eggs (copy), LaunchEgg (ref) ]]
			if not (p2 and p1) then
				return
			end
			local v1 = Eggs:GetChildren()[p2]
			if v1 then
				LaunchEgg(v1, p1, p3)
			end
		end)
		return function() --[[ Line: 177 | Upvalues: v12 (copy) ]]
			v12:Destroy()
		end
	end
end)
return {}