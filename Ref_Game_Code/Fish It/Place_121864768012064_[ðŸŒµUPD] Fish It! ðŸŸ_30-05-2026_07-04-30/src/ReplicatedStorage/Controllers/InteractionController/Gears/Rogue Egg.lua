-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteFunction("ActivateEggMachineEgg")
return function(p1, p2) --[[ Line: 9 | Upvalues: v1 (copy), TextNotificationController (copy) ]]
	if not p2 then
		return
	end
	local v12 = v1:InvokeServer(p2.UUID)
	if v12 and v12.Success then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = v12.Message or "Egg started incubating.",
			TextColor = {
				R = 255,
				G = 241,
				B = 170
			}
		})
		return
	end
	local t = {
		Type = "Text"
	}
	t.Text = if v12 then v12.Message or "Unable to activate egg." else "Unable to activate egg."
	t.TextColor = {
		R = 255,
		G = 120,
		B = 120
	}
	TextNotificationController:DeliverNotification(t)
end