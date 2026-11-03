-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1) --[[ Line: 1 ]]
	if p1 >= 86400 then
		local v1 = math.floor(p1 / 86400)
		local v2 = math.floor(p1 % 86400 / 3600)
		return string.format("%02d:%02d:%02d", v1, v2, (math.floor(p1 % 3600 / 60)))
	elseif p1 >= 3600 then
		local v4 = math.floor(p1 / 3600)
		return string.format("%02d:%02d:%02d", v4, math.floor(p1 % 3600 / 60), p1 % 60)
	elseif p1 >= 60 then
		return string.format("%02d:%02d", math.floor(p1 / 60), p1 % 60)
	else
		return string.format("00:%02d", p1)
	end
end