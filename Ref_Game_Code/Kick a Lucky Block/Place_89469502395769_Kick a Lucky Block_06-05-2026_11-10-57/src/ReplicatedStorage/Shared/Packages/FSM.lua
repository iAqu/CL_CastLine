-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 4 | Upvalues: t (copy) ]]
	local t2 = {}
	for k in pairs(p1) do
		t2[k] = true
	end
	return setmetatable({
		State = "Nan",
		States = t2,
		Actions = p1
	}, t)
end
function t.GoToState(p1, p2) --[[ GoToState | Line: 19 ]]
	if p2 ~= p1.State and p1.States[p2] then
		local State = p1.State
		local v1 = p1.Actions[State] and p1.Actions[State].OnLeave
		if v1 then
			v1()
		end
		p1.State = p2
		local v2 = p1.Actions[p2] and p1.Actions[p2].OnEnter
		if v2 then
			v2()
		end
	end
end
return t