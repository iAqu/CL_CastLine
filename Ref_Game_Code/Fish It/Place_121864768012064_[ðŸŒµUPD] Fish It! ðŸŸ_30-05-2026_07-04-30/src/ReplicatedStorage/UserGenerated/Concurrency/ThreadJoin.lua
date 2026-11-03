-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ ThreadJoin | Line: 20 ]]
	local v1 = os.clock()
	while coroutine.status(p1) ~= "dead" do
		if p2 ~= nil and p2 <= os.clock() - v1 then
			return false
		end
		task.wait()
	end
	return true
end