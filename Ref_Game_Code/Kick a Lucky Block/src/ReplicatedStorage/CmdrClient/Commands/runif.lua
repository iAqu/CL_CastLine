-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	startsWith = function(p1, p2) --[[ startsWith | Line: 2 ]]
		if p1:sub(1, #p2) == p2 then
			return p1:sub(#p2 + 1)
		end
	end
}
return {
	Name = "runif",
	Description = "Runs a given command string if a certain condition is met.",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "conditionFunction",
			Name = "Condition",
			Description = "The condition function"
		},
		{
			Type = "string",
			Name = "Argument",
			Description = "The argument to the condition function"
		},
		{
			Type = "string",
			Name = "Test against",
			Description = "The text to test against."
		},
		{
			Type = "string",
			Name = "Command",
			Description = "The command string to run if requirements are met. If omitted, return value from condition function is used.",
			Optional = true
		}
	},
	Run = function(p1, p2, p3, p4, p5) --[[ Run | Line: 38 | Upvalues: t (copy) ]]
		local v1 = t[p2]
		if v1 then
			local v2 = v1(p4, p3)
			if v2 then
				return p1.Dispatcher:EvaluateAndRun(p1.Cmdr.Util.RunEmbeddedCommands(p1.Dispatcher, p5 or v2))
			else
				return ""
			end
		else
			return ("Condition %q is not valid."):format(p2)
		end
	end
}