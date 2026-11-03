-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script.Parent.Parent.Utility.Types)
local reconcileParticleProps = require(script.Parent.Parent.Utility.ParticleProps.reconcileParticleProps)
return function(p1, p2) --[[ createEmitter | Line: 7 | Upvalues: reconcileParticleProps (copy) ]]
	return {
		container = p1,
		particles = {},
		props = reconcileParticleProps(p2)
	}
end