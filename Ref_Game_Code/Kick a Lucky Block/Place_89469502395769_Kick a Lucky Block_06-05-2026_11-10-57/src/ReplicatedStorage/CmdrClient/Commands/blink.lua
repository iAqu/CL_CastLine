-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "blink",
	Description = "Teleports you to where your mouse is hovering.",
	Group = "DefaultDebug",
	Aliases = { "b" },
	Args = {},
	ClientRun = function(p1) --[[ ClientRun | Line: 8 ]]
		local v1 = p1.Executor:GetMouse()
		local Character = p1.Executor.Character
		if Character then
			Character:MoveTo(v1.Hit.p)
			return "Blinked!"
		else
			return "You don\'t have a character."
		end
	end
}