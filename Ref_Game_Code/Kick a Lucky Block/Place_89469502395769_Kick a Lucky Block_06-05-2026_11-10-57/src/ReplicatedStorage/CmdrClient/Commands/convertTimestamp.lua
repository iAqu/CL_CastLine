-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "convertTimestamp",
	Description = "Convert a timestamp to a human-readable format.",
	Group = "DefaultUtil",
	Aliases = { "date" },
	Args = {
		{
			Type = "number",
			Name = "timestamp",
			Description = "A numerical representation of a specific moment in time.",
			Optional = true
		}
	},
	ClientRun = function(p1, p2) --[[ ClientRun | Line: 14 ]]
		local v1 = if p2 then p2 else os.time()
		return ("%* %*"):format(os.date("%x", v1), (os.date("%X", v1)))
	end
}