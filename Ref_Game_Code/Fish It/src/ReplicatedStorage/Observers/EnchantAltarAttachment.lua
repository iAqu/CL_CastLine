-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
require(ReplicatedStorage.Modules.GuiControl)
local EnchantingController = require(ReplicatedStorage.Controllers.EnchantingController)
Observers.observeTag("EnchantAltarAttachment", function(p1) --[[ Line: 14 | Upvalues: Players (copy), EnchantingController (copy) ]]
	if p1:IsA("Attachment") then
		local v1 = p1:GetAttribute("SpecialEnchant") or false
		local v2 = p1:GetAttribute("SecondEnchant") or false
		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.ObjectText = "The Altar"
		ProximityPrompt.ActionText = "Place Enchant Stone?"
		ProximityPrompt.ClickablePrompt = true
		ProximityPrompt.RequiresLineOfSight = false
		ProximityPrompt.MaxActivationDistance = 10
		ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadDown
		ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		ProximityPrompt.Parent = p1
		local v3 = ProximityPrompt.Triggered:Connect(function(p1) --[[ Line: 32 | Upvalues: Players (ref), EnchantingController (ref), v2 (copy), v1 (copy) ]]
			if Players.LocalPlayer == p1 then
				EnchantingController:Activate(v2, v1):catch(function(p1, p2) --[[ Line: 38 | Upvalues: EnchantingController (ref) ]]
					if not p2 then
						return
					end
					EnchantingController:_reportError(p1)
				end):await()
			end
		end)
		return function() --[[ Line: 48 | Upvalues: v3 (copy), ProximityPrompt (copy) ]]
			v3:Disconnect()
			ProximityPrompt:Destroy()
		end
	end
end)
return {}