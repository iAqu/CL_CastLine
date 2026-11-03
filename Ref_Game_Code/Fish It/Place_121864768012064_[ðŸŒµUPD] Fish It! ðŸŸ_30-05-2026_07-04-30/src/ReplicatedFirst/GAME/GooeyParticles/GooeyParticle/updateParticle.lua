-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script.Parent.Parent.Utility.conditionalProperty)
local evaluateColorSequence = require(script.Parent.Parent.Utility.Sequences.evaluateColorSequence)
local evaluateNumberSequence = require(script.Parent.Parent.Utility.Sequences.evaluateNumberSequence)
require(script.Parent.Parent.Utility.Types)
return function(p1, p2, p3) --[[ updateParticle | Line: 9 | Upvalues: evaluateNumberSequence (copy), evaluateColorSequence (copy) ]]
	local v1 = (os.clock() - p1.spawnedAt) / p1.lifetime
	if v1 > 1 then
		p1.remove()
		p1.obj:Destroy()
		return
	end
	p1.velocity = p1.velocity + p2.Acceleration * p3 * 5
	p1.position = p1.position + p1.velocity * p3
	p1.obj.Position = UDim2.fromOffset(p1.position.X, p1.position.Y)
	local obj = p1.obj
	obj.Rotation = obj.Rotation + p1.rotation * p3
	if typeof(p2.Transparency) ~= "number" then
		p1.obj.ImageTransparency = evaluateNumberSequence(p2.Transparency, v1)
	end
	if typeof(p2.Color) ~= "Color3" then
		p1.obj.ImageColor3 = evaluateColorSequence(p2.Color, v1)
	end
	if typeof(p2.Size) == "number" then
		return
	end
	local v3 = evaluateNumberSequence(p2.Size, v1)
	p1.obj.Size = UDim2.fromOffset(v3, v3)
end