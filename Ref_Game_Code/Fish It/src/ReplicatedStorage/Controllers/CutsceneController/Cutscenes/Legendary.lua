-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("TweenService")
game:GetService("RunService")
local v1 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Cutscenes")[script.Name]
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Shared.ItemUtility)
local SebasUtil = require(ReplicatedStorage.Modules.SebasUtil)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Controllers.VFXController)
local CameraShaker = require(ReplicatedStorage.Modules.CameraShaker)
require(ReplicatedStorage.Modules.CameraShaker.CameraShakeInstance)
local CurrentCamera = workspace.CurrentCamera
local VFX = workspace:WaitForChild("VFX")
local t = {}
t.__index = t
Random.new(os.clock())
local function camShake(p1) --[[ camShake | Line: 33 | Upvalues: CurrentCamera (copy) ]]
	local v1 = CurrentCamera
	v1.CFrame = v1.CFrame * p1
end
local v2 = CameraShaker.new(Enum.RenderPriority.Last.Value, camShake)
v2:Start()
function t.new(p1, p2) --[[ new | Line: 40 | Upvalues: t (copy), Trove (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = Trove.new()
	v2.Destroyed = false
	v2.Properties = {}
	return v2
end
function t.Play(p1, p2, p3, p4, p5) --[[ Play | Line: 52 | Upvalues: Soundbook (copy), v1 (copy), VFX (copy), SebasUtil (copy) ]]
	task.spawn(function() --[[ Line: 54 | Upvalues: Soundbook (ref), p5 (copy), p1 (copy), v1 (ref), VFX (ref), p3 (copy), SebasUtil (ref) ]]
		local v12 = Soundbook.Sounds["Cutscene - Legendary"]:Play()
		local v2
		if not p5 then
			v12.Volume = v12.Volume / 2
		end
		v2 = p1.Cleaner:Clone(v1.Particles)
		v2.Parent = VFX
		v2.Position = p3
		SebasUtil:EmitAll(v2)
		task.wait(1)
		p1:Destroy()
	end)
end
function t.Destroy(p1) --[[ Destroy | Line: 71 | Upvalues: v2 (copy), CurrentCamera (copy) ]]
	if p1.Destroyed then
		return
	end
	v2:StopSustained()
	if p1._camDisabled then
		p1.Destroyed = true
		p1.Cleaner:Destroy()
		return
	end
	CurrentCamera.CameraType = Enum.CameraType.Custom
	p1.Destroyed = true
	p1.Cleaner:Destroy()
end
return t