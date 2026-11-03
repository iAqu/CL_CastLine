-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ReplicatedStorage")
local t = {
	Tag = ({
		Tag = ""
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 17 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t._init(p1) --[[ _init | Line: 27 ]]
	if not p1.Initialized then
		p1.Initialized = true
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 34 ]] end
return t