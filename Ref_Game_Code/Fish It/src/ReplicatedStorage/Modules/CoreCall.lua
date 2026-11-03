-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local StarterGui = game:GetService("StarterGui")
return function(p1, ...) --[[ Line: 5 | Upvalues: StarterGui (copy) ]]
	local count = 0
	while count < 10 do
		count = count + 1
		local v2, v3 = pcall(StarterGui[p1], StarterGui, ...)
		if v2 then
			return v3
		end
		if count == 10 then
			error("Error calling " .. p1 .. " even after 10 tries: " .. tostring(v3))
		end
		task.wait(1)
	end
	return nil
end