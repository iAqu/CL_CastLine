-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "version",
	Description = "Shows the current version of Cmdr",
	Group = "DefaultDebug",
	Args = {},
	Run = function() --[[ Run | Line: 9 ]]
		return ("Cmdr Version %s"):format("v1.12.0")
	end
}