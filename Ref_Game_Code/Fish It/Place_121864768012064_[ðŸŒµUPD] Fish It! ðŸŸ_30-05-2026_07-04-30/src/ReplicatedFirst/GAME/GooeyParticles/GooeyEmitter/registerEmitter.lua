-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local bindToRenderstep = require(script.Parent.Parent.Utility.bindToRenderstep)
local createEmitter = require(script.Parent.createEmitter)
local removeEmitter = require(script.Parent.removeEmitter)
require(script.Parent.Parent.Utility.Types)
local updateEmitter = require(script.Parent.updateEmitter)
return function(p1, p2) --[[ registerEmitter | Line: 9 | Upvalues: createEmitter (copy), bindToRenderstep (copy), updateEmitter (copy), removeEmitter (copy) ]]
	local v1 = createEmitter(p1, p2)
	v1.spawnNextParticleAt = os.clock() + 1 / p2.Rate
	return removeEmitter(v1, (bindToRenderstep(function(p1) --[[ Line: 13 | Upvalues: updateEmitter (ref), v1 (copy) ]]
		updateEmitter(v1, p1)
	end)))
end