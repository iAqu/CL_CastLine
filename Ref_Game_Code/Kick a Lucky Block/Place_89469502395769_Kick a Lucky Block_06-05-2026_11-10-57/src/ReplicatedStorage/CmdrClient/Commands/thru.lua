-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "thru",
	Description = "Teleports you through whatever your mouse is hovering over, placing you equidistantly from the wall.",
	Group = "DefaultDebug",
	Aliases = { "t", "through" },
	Args = {
		{
			Type = "number",
			Name = "Extra distance",
			Description = "Go through the wall an additional X studs.",
			Default = 0
		}
	},
	ClientRun = function(p1, p2) --[[ ClientRun | Line: 15 ]]
		local v1 = p1.Executor:GetMouse()
		local Character = p1.Executor.Character
		if Character and Character:FindFirstChild("HumanoidRootPart") then
			local Position = Character.HumanoidRootPart.Position
			local v2 = v1.Hit.p - Position
			Character:MoveTo(v2 * 2 + v2.unit * p2 + Position)
			return "Blinked!"
		else
			return "You don\'t have a character."
		end
	end
}