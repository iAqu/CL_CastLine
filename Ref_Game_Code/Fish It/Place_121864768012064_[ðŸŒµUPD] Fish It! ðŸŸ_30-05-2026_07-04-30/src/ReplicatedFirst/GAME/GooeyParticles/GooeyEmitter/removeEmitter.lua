-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script.Parent.Parent:WaitForChild("Utility"):WaitForChild("Types"))
local isEmpty = require(script.Parent.Parent:WaitForChild("Internal"):WaitForChild("Llama")).isEmpty
return function(p1, p2) --[[ removeEmitter | Line: 9 | Upvalues: isEmpty (copy) ]]
	return function(p12) --[[ Line: 10 | Upvalues: p1 (ref), isEmpty (ref), p2 (ref) ]]
		p1.props.Rate = 0
		task.spawn(function() --[[ Line: 13 | Upvalues: isEmpty (ref), p1 (ref), p2 (ref), p12 (copy) ]]
			repeat
				task.wait()
			until isEmpty(p1.particles) == true
			p2()
			p2 = nil
			p1 = nil
			if p12 == nil then
				return
			end
			p12()
		end)
	end
end