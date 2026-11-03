-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local bindToRenderstep = require(script.Parent.Parent.Utility.bindToRenderstep)
local createParticle = require(script.Parent.Parent.GooeyParticle.createParticle)
local createEmitter = require(script.Parent.createEmitter)
local removeEmitter = require(script.Parent.removeEmitter)
require(script.Parent.Parent.Utility.Types)
local updateEmitter = require(script.Parent.updateEmitter)
return function(p1, p2, p3, p4) --[[ registerSingleEmitter | Line: 10 | Upvalues: createEmitter (copy), createParticle (copy), bindToRenderstep (copy), updateEmitter (copy), removeEmitter (copy) ]]
	local v1 = createEmitter(p1, p2)
	for i = 1, p3 do
		createParticle(v1)
	end
	removeEmitter(v1, (bindToRenderstep(function(p1) --[[ Line: 16 | Upvalues: updateEmitter (ref), v1 (copy) ]]
		updateEmitter(v1, p1)
	end)))(function() --[[ Line: 20 | Upvalues: p4 (copy) ]]
		p4()
	end)
end