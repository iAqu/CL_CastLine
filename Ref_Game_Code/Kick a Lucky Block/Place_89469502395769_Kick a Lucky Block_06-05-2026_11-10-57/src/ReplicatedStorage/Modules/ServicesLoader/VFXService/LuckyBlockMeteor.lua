-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
game:GetService("RunService")
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local CameraShakeController = require(ReplicatedStorage.Modules.ControllerLoader.CameraShakeController)
local CraterAtPosition = require(ReplicatedStorage.Modules.ServicesLoader.VFXService.CraterAtPosition)
require(ReplicatedStorage.Shared.Packages.Trove)
local Meteor = ReplicatedStorage.Objects.VFX.Meteor
local CurrentCamera = workspace.CurrentCamera
local v1 = CFrame.new(1595.485, 869.497, 896.886)
return function(p1, p2) --[[ Line: 21 | Upvalues: Meteor (copy), SoundService (copy), v1 (copy), TweenService (copy), MessagesService (copy), CurrentCamera (copy), CameraShakeController (copy), CraterAtPosition (copy) ]]
	local v12 = Meteor:Clone()
	local v2 = SoundService.Effects.Fall:Clone()
	local v3 = SoundService.Effects["big explosion short"]:Clone()
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.Transparency = 1
	Part.CanCollide = false
	Part.Parent = workspace.Debris
	Part.CFrame = p2
	v3.Parent = Part
	local Root = v12:WaitForChild("Root")
	v2.Parent = Root
	v2.Volume = 2
	v2.RollOffMaxDistance = 2000
	Root.CFrame = v1
	Root.Anchored = true
	v12.Parent = workspace.Debris
	v2:Play()
	local v4 = p1 - workspace:GetServerTimeNow()
	local v5 = TweenService:Create(v12.Root, TweenInfo.new(v4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
		CFrame = p2 * CFrame.new(0, Root.Size.Y / 2, 0)
	})
	v5:Play()
	task.delay(v4 / 2, function() --[[ Line: 48 | Upvalues: MessagesService (ref) ]]
		MessagesService:PlayMessage("what is that sound?", "Dev", "adamdguy")
	end)
	v5.Completed:Once(function() --[[ Line: 52 | Upvalues: MessagesService (ref), CurrentCamera (ref), p2 (copy), CameraShakeController (ref), v2 (copy), v3 (copy), Part (copy), v12 (copy), CraterAtPosition (ref) ]]
		task.delay(1.31, function() --[[ Line: 53 | Upvalues: MessagesService (ref) ]]
			MessagesService:PlayMessage("WHAT???", "Dev", "mikidguy")
		end)
		task.delay(2, function() --[[ Line: 57 | Upvalues: MessagesService (ref) ]]
			MessagesService:PlayMessage("\240\159\152\179", "Dev", "shondguy")
		end)
		if (CurrentCamera.CFrame.Position - p2.Position).Magnitude < 50 then
			CameraShakeController.ScreenShake:ShakeOnce(5, 10, 0, 1.5)
		end
		v2:Stop()
		v3:Play()
		v3.Ended:Once(function() --[[ Line: 67 | Upvalues: Part (ref) ]]
			Part:Destroy()
		end)
		v12:Destroy()
		CraterAtPosition(p2.Position, 5, false, 2, 3)
		CraterAtPosition(p2.Position, 7.5, true, 2, 2)
		CraterAtPosition(p2.Position, 10, true, 2, 1)
	end)
end