-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
function loadModule(p1) --[[ loadModule | Line: 1 ]]
	local v1 = require(p1)
	if typeof(v1) == "table" and v1._init then
		v1:_init()
	end
end
return function() --[[ Line: 8 ]]
	local list = {}
	local list2 = {}
	for v1, v2 in script:GetDescendants() do
		if v2:IsA("ModuleScript") then
			if v2:HasTag("_Priority") then
				table.insert(list, v2)
			end
			table.insert(list2, v2)
		end
	end
	for i, v in ipairs(list) do
		loadModule(v)
	end
	for i, v in ipairs(list2) do
		loadModule(v)
	end
end