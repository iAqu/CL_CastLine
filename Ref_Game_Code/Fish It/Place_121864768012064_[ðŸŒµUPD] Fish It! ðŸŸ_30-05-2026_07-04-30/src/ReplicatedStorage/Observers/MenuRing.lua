-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local function errorMessage(p1) --[[ errorMessage | Line: 14 | Upvalues: v1 (ref), ReplicatedStorage (copy) ]]
	if not v1 then
		v1 = require(ReplicatedStorage.Controllers.TextNotificationController)
	end
	v1:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		}
	})
end
Observers.observeTag("MenuRing", function(p1) --[[ Line: 26 | Upvalues: Players (copy), Replion (copy), errorMessage (copy), GuiControl (copy) ]]
	p1:GetAttribute("IgnoreLock")
	local v1 = p1:GetAttribute("Context")
	local v2 = p1:GetAttribute("Gui")
	if v2 then
		local v3 = 0
		local v4 = p1.Touched:Connect(function(p12) --[[ Line: 35 | Upvalues: Players (ref), Replion (ref), p1 (copy), errorMessage (ref), v3 (ref), GuiControl (ref), v2 (copy), v1 (copy) ]]
			local v12 = Players:GetPlayerFromCharacter(p12.Parent)
			if not v12 then
				return
			end
			if v12 ~= Players.LocalPlayer then
				return
			end
			if not Replion.Client:GetReplion("Data") then
				return
			end
			local v22 = p1:GetAttribute("RequiredLevel")
			if v22 then
				local v32 = Replion.Client:GetReplion("Data")
				if not v32 then
					return
				end
				if v32:GetExpect("Level") < v22 then
					errorMessage((("You must be Lvl %*!"):format(v22)))
					return
				end
			end
			if workspace:GetServerTimeNow() < v3 then
				return
			end
			if GuiControl:IsOpen(v2) then
				return
			end
			v3 = workspace:GetServerTimeNow() + 1
			GuiControl:Open(v2, nil, v1)
		end)
		return function() --[[ Line: 75 | Upvalues: v4 (copy), GuiControl (ref), v2 (copy) ]]
			v4:Disconnect()
			if not GuiControl:IsOpen(v2) then
				return
			end
			GuiControl:Close()
		end
	end
end)
return {}