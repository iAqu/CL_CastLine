-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local defaultParticleProps = require(script.Parent.defaultParticleProps)
local Llama = require(script.Parent.Parent.Parent:WaitForChild("Internal"):WaitForChild("Llama"))
require(script.Parent.Parent.Types)
return function(p1) --[[ reconcileParticleProps | Line: 7 | Upvalues: Llama (copy), defaultParticleProps (copy) ]]
	local v2 = Llama.Dictionary.copy(p1)
	for k, v in pairs(defaultParticleProps) do
		if v2[k] == nil then
			v2[k] = v
		end
	end
	return v2
end