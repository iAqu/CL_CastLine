-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "pick",
	Description = "Picks a value out of a comma-separated list.",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "integer",
			Name = "Index to pick",
			Description = "The index of the item you want to pick"
		},
		{
			Type = "string",
			Name = "CSV",
			Description = "The comma-separated list"
		}
	},
	Run = function(p1, p2, p3) --[[ Run | Line: 19 ]]
		return p3:split(",")[p2] or ""
	end
}