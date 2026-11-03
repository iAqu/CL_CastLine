-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
return {
	Name = "bind",
	Description = "Binds a command string to a key or mouse input.",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "userInput ! bindableResource @ player",
			Name = "Input",
			Description = "The key or input type you\'d like to bind the command to."
		},
		{
			Type = "command",
			Name = "Command",
			Description = "The command you want to run on this input"
		},
		{
			Type = "string",
			Name = "Arguments",
			Description = "The arguments for the command",
			Default = ""
		}
	},
	ClientRun = function(p1, p2, p3, p4) --[[ ClientRun | Line: 27 | Upvalues: UserInputService (copy) ]]
		local v1 = p1:GetStore("CMDR_Binds")
		local v2 = p3 .. " " .. p4
		if v1[p2] then
			v1[p2]:Disconnect()
		end
		local v3 = p1:GetArgument(1).Type.Name
		if v3 == "userInput" then
			v1[p2] = UserInputService.InputBegan:Connect(function(p12, p22) --[[ Line: 39 | Upvalues: p2 (copy), p1 (copy), v2 (ref) ]]
				if not p22 and (p12.UserInputType == p2 or p12.KeyCode == p2) then
					p1:Reply(p1.Dispatcher:EvaluateAndRun(p1.Cmdr.Util.RunEmbeddedCommands(p1.Dispatcher, v2)))
				end
			end)
		else
			if v3 == "bindableResource" then
				return "Unimplemented..."
			end
			if v3 ~= "player" then
				return "Bound command to input."
			end
			v1[p2] = p2.Chatted:Connect(function(p12) --[[ Line: 51 | Upvalues: p1 (copy), v2 (ref), p2 (copy) ]]
				local v1 = p1.Cmdr.Util.RunEmbeddedCommands(p1.Dispatcher, p1.Cmdr.Util.SubstituteArgs(v2, { p12 }))
				p1:Reply(("%s $ %s : %s"):format(p2.Name, v1, p1.Dispatcher:EvaluateAndRun(v1)), Color3.fromRGB(244, 92, 66))
			end)
		end
		return "Bound command to input."
	end
}