-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradeVFX = ReplicatedStorage.Objects.VFX.UpgradeVFX
local EmitVFX = require(ReplicatedStorage.Modules.ServicesLoader.VFXService.EmitVFX)
return function(p1) --[[ Line: 10 | Upvalues: EmitVFX (copy), UpgradeVFX (copy) ]]
	if p1 and p1:FindFirstChild("Root") then
		EmitVFX(p1.Root, UpgradeVFX)
	end
end