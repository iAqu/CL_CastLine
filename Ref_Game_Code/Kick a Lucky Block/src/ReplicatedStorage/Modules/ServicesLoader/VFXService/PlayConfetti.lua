-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local CurrentCamera = workspace.CurrentCamera
return function() --[[ Line: 9 | Upvalues: ReplicatedStorage (copy), RunService (copy), CurrentCamera (copy), SoundService (copy) ]]
	local v1 = ReplicatedStorage.Objects.VFX.Confetti:Clone()
	local v2 = RunService.PreRender:Connect(function() --[[ Line: 14 | Upvalues: v1 (copy), CurrentCamera (ref) ]]
		if v1 then
			v1.CFrame = CurrentCamera.CFrame
		end
	end)
	for i, v in ipairs(v1:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end
	v1.Parent = workspace
	SoundService.Effects.Tudum:Play()
	game.Debris:AddItem(v1, 2)
	task.delay(2, function() --[[ Line: 32 | Upvalues: v2 (ref) ]]
		v2:Disconnect()
	end)
end