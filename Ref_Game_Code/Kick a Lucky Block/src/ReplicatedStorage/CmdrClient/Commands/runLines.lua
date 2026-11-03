-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "run-lines",
	Description = "Splits input by newlines and runs each line as its own command. This is used by the init-run command.",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "string",
			Name = "Script",
			Description = "The script to parse.",
			Default = ""
		}
	},
	ClientRun = function(p1, p2) --[[ ClientRun | Line: 15 ]]
		if #p2 ~= 0 then
			local v1 = p1.Dispatcher:Run("var", "INIT_PRINT_OUTPUT") ~= ""
			for i, v in ipairs((p2:gsub("\n+", "\n"):split("\n"))) do
				if v:sub(1, 1) ~= "#" then
					local v3 = p1.Dispatcher:EvaluateAndRun(v)
					if v1 then
						p1:Reply(v3)
					end
				end
			end
		end
		return ""
	end
}