-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script.Parent:WaitForChild("type"))
return function(p1) --[[ fromArray | Line: 5 ]]
	local t = {}
	for v1, v2 in p1 do
		t[v2] = true
	end
	return t
end