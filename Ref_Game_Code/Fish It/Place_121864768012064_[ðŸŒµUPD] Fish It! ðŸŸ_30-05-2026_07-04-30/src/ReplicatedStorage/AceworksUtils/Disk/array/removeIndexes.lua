-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local removeSortedIndexes = require(script.Parent:WaitForChild("removeSortedIndexes"))
local sort = require(script.Parent:WaitForChild("sort"))
return function(p1, p2) --[[ removeIndexes | Line: 4 | Upvalues: sort (copy), removeSortedIndexes (copy) ]]
	if #p2 == 0 or #p1 == 0 then
		return p1
	else
		return removeSortedIndexes(p1, (sort(p2)))
	end
end