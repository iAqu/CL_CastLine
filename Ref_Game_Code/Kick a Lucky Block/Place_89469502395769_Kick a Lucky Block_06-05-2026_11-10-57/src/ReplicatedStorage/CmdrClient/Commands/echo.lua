-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "echo",
	Description = "Echoes your text back to you.",
	Group = "DefaultUtil",
	Aliases = { "=" },
	Args = {
		{
			Type = "string",
			Name = "Text",
			Description = "The text."
		}
	},
	Run = function(p1, p2) --[[ Run | Line: 14 ]]
		return p2
	end
}