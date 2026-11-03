-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService")
game:GetService("TweenService")
require(ReplicatedStorage.Shared.Packages.Trove)
TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
local v1 = nil
local v2 = 0
return function(p1) --[[ Line: 17 | Upvalues: ReplicatedStorage (copy), SoundService (copy), v1 (ref), v2 (ref) ]]
	local v12 = ReplicatedStorage.Objects.VFX.MoneyAttach:Clone()
	v12.Parent = p1
	local v22 = SoundService.Effects.CashRegister:Clone()
	v22.Parent = p1
	local PitchShiftSoundEffect = v22:WaitForChild("PitchShiftSoundEffect")
	if v1 and tick() - v1 > 1 then
		v2 = 0
	end
	PitchShiftSoundEffect.Octave = math.min(v2 * 0.033 + 1, 2)
	v1 = tick()
	v2 = v2 + 1
	(function() --[[ Emit | Line: 39 | Upvalues: v12 (copy) ]]
		for i, v in ipairs(v12:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v:Emit(v:GetAttribute("EmitCount") or 1)
			end
		end
	end)()
	v22:Play()
	game.Debris:AddItem(v12, 2)
	game.Debris:AddItem(v22, 1)
end