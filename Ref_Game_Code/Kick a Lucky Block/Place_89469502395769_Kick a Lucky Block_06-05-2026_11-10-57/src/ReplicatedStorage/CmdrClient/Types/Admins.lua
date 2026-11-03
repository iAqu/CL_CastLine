-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	[646338867] = true,
	[341835893] = true,
	[550065203] = true
}
return function(p1) --[[ Line: 7 | Upvalues: t (copy) ]]
	p1:RegisterHook("BeforeRun", function(p1) --[[ Line: 8 | Upvalues: t (ref) ]]
		if p1.Group == "DefaultAdmin" and not t[p1.Executor.UserId] then
			return "You don\'t have permission to use this command."
		end
	end)
end