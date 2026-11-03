-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraShaker = require(ReplicatedStorage.Shared.Packages.CameraShaker)
local CurrentCamera = workspace.CurrentCamera
return {
	ScreenShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(p1) --[[ Line: 8 | Upvalues: CurrentCamera (copy) ]]
		local v1 = CurrentCamera
		v1.CFrame = v1.CFrame * p1
	end),
	_init = function(p1) --[[ _init | Line: 13 ]]
		p1.ScreenShake:Start()
	end
}