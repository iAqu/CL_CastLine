-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local FormatInfNumber = require(ReplicatedStorage.Functional.FormatInfNumber)
local LocalPlayer = game:GetService("Players").LocalPlayer
return {
	Nodes = {
		default_open = {
			text = { "Sell me your brainrots!" },
			choices = {
				{
					id = "sell_all",
					text = "Sell all my brainrots"
				},
				{
					id = "sell_one",
					text = "Sell this brainrot"
				},
				{
					id = "get_value",
					text = "What\'s this brainrot\'s value?"
				},
				{
					id = "bye",
					text = "Bye"
				}
			}
		},
		sell_all = {
			text_trigger = function() --[[ text_trigger | Line: 61 | Upvalues: Network (copy), InfiniteMath (copy), FormatInfNumber (copy) ]]
				local v1 = Network.InvokeServer("B_SellAll")
				if v1 then
					return ("Sold for <font color = \"#75ff2b\">$%*</font>"):format((FormatInfNumber((InfiniteMath.new(v1)))))
				else
					return "Nothing to sell"
				end
			end
		},
		sell_one = {
			text_trigger = function() --[[ text_trigger | Line: 72 | Upvalues: Network (copy), InfiniteMath (copy), FormatInfNumber (copy) ]]
				local v1 = Network.InvokeServer("B_Sell")
				if v1 then
					return ("Sold for <font color = \"#75ff2b\">$%*</font>"):format((FormatInfNumber((InfiniteMath.new(v1)))))
				else
					return "Nothing to sell"
				end
			end
		},
		get_value = {
			text_trigger = function() --[[ text_trigger | Line: 83 | Upvalues: LocalPlayer (copy), Tags (copy), EntitiesData (copy) ]]
				task.wait(0.25)
				local v1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if v1 and v1:HasTag(Tags.EntityTool) then
					if v1:HasTag(Tags.EntityTool) then
						local v2 = EntitiesData.Brainrots[v1.Name] and EntitiesData.Brainrots[v1.Name].CPS
						if v2 then
							return ("This brainrot is worth <font color = \"#75ff2b\">$%*</font>!"):format(v2 * 10)
						else
							return "You aren\'t holding anything"
						end
					end
				else
					return "You aren\'t holding anything"
				end
			end
		},
		bye = {
			text = { "See ya!" }
		}
	},
	GetCorrectOpening = function(p1) --[[ GetCorrectOpening | Line: 108 ]]
		return "default_open"
	end
}