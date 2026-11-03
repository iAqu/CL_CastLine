-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
return function(p1, p2, p3) --[[ Line: 5 | Upvalues: InfiniteMath (copy) ]]
	local v1 = p1:Reverse()
	local v2 = p2:Reverse()
	return InfiniteMath.new((math.lerp(v1, v2, (math.clamp(p3, 0, 1)))))
end