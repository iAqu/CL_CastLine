-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Frames = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Frames")
return {
	Nodes = {
		default_open = {
			text = { "Check out the shop!" },
			trigger = function() --[[ trigger | Line: 13 | Upvalues: Frames (copy) ]]
				task.wait(0.3)
				Frames.Store.Visible = true
			end
		}
	},
	GetCorrectOpening = function(p1) --[[ GetCorrectOpening | Line: 20 ]]
		return "default_open"
	end
}