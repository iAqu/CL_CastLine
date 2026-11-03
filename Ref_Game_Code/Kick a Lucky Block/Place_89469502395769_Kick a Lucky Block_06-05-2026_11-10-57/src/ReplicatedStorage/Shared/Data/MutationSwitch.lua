-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
return {
	Void = function(p1) --[[ Line: 7 | Upvalues: SoundService (copy), VFXService (copy), ReplicatedStorage (copy) ]]
		SoundService.Effects.VoidSwitch:Play()
		VFXService.PlayVFX("EmitVFX", p1, ReplicatedStorage.Objects.VFX.AppearVFX.Void)
	end,
	Virus = function(p1) --[[ Line: 12 | Upvalues: SoundService (copy), VFXService (copy), ReplicatedStorage (copy) ]]
		SoundService.Effects.VirusSwitch:Play()
		VFXService.PlayVFX("EmitVFX", p1, ReplicatedStorage.Objects.VFX.AppearVFX.Virus)
	end
}