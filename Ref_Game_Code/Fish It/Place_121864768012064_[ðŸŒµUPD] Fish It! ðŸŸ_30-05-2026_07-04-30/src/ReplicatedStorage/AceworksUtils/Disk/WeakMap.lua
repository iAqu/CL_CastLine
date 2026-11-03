-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	__mode = "k"
}
return function(p1) --[[ WeakMap | Line: 3 | Upvalues: t (copy) ]]
	return setmetatable(if p1 then p1 else {}, t)
end