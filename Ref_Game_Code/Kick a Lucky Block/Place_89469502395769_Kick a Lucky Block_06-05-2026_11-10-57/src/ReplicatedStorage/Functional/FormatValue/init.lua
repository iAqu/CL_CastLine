-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Suffixes = require(script.Suffixes)
local FormatInfNumber = require(ReplicatedStorage.Functional.FormatInfNumber)
return function(p1, p2) --[[ Line: 6 | Upvalues: Suffixes (copy), FormatInfNumber (copy) ]]
	assert(if typeof(p1) == "number" then true else false, "Passed argument ~= number.")
	local v5 = math.clamp(math.floor((math.log(p1, 1000))), 0, #Suffixes)
	if v5 == 0 then
		return tostring(p1)
	else
		local v6 = string.format("%.2f%s", p1 / 1000 ^ v5, Suffixes[v5])
		if p2 then
			v6 = FormatInfNumber(v6)
		end
		return v6
	end
end