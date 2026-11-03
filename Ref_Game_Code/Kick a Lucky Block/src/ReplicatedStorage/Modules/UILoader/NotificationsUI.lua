-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local Notifications = script:WaitForChild("Notifications")
Notifications.Parent = PlayerGui
local NotificationsHolder = Notifications.NotificationsHolder
local Template = script:WaitForChild("Template")
return {
	Create = function(p1, p2, p3) --[[ Create | Line: 17 | Upvalues: Template (copy), NotificationsHolder (copy) ]]
		local v1 = Template:Clone()
		v1:WaitForChild("ItemLabel").Text = p3
		v1:WaitForChild("ItemImage").Image = p2
		v1.Visible = true
		v1.Parent = NotificationsHolder
		return v1
	end
}