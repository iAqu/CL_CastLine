-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.new() --[[ new | Line: 4 | Upvalues: t (copy) ]]
	return setmetatable({
		Connections = {},
		Objects = {},
		Methods = {}
	}, t)
end
function t.Clone(p1, p2) --[[ Clone | Line: 14 ]]
	if typeof(p2) == "Instance" then
		local v1 = p2:Clone()
		p1:Add(v1)
		return v1
	else
		return error("Item given is not an instance.")
	end
end
function t.Clean(p1) --[[ Clean | Line: 24 ]]
	for i, v in ipairs(p1.Connections) do
		v:Disconnect()
	end
	for i, v in ipairs(p1.Methods) do
		v()
	end
	for i, v in ipairs(p1.Objects) do
		v:Destroy()
	end
end
function t.Add(p1, p2) --[[ Add | Line: 38 ]]
	if typeof(p2) == "RBXScriptConnection" then
		table.insert(p1.Connections, p2)
	elseif typeof(p2) == "function" then
		table.insert(p1.Methods, p2)
	elseif typeof(p2) == "Instance" then
		table.insert(p1.Objects, p2)
	else
		error("Item not compatible")
	end
end
return t