-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Component = require(script.Parent.Component)
local v1 = Component:extend("PureComponent")
v1.extend = Component.extend
function v1.shouldUpdate(p1, p2, p3) --[[ shouldUpdate | Line: 15 ]]
	if p3 ~= p1.state then
		return true
	end
	if p2 == p1.props then
		return false
	end
	for k, v in pairs(p2) do
		if p1.props[k] ~= v then
			return true
		end
	end
	for k, v in pairs(p1.props) do
		if p2[k] ~= v then
			return true
		end
	end
	return false
end
return v1