-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local createParticle = require(script.Parent.Parent.GooeyParticle.createParticle)
require(script.Parent.Parent.Utility.Types)
local updateParticle = require(script.Parent.Parent.GooeyParticle.updateParticle)
return function(p1, p2) --[[ updateEmitter | Line: 8 | Upvalues: createParticle (copy), updateParticle (copy) ]]
	if p1.spawnNextParticleAt ~= nil and p1.props.Rate > 0 then
		local v1 = os.clock()
		if p1.spawnNextParticleAt <= v1 then
			createParticle(p1)
			p1.spawnNextParticleAt = v1 + 1 / p1.props.Rate
		end
	end
	for k, v in pairs(p1.particles) do
		updateParticle(v, p1.props, p2)
	end
end