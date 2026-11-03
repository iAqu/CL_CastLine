-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Miscellaneous = {
		ShowHeader = true,
		Order = 150,
		Options = {
			["Luck Modifiers"] = {
				Description = "OFF or ON: Passes/Potions/Server Luck",
				Icon = "rbxassetid://101739550540739",
				Type = "boolean",
				Path = { "Settings", "Luck Modifiers" }
			},
			["Friend Luck"] = {
				Description = "OFF or ON: Friend Luck",
				Icon = "rbxassetid://101739550540739",
				Type = "boolean",
				Path = { "Settings", "Friend Luck" }
			}
		}
	},
	Gameplay = {
		ShowHeader = true,
		Order = 100,
		Options = {
			Music = {
				Description = "Toggles Music",
				Icon = "rbxassetid://130991985273957",
				Type = "boolean",
				Path = { "Settings", "Music" }
			},
			Ambience = {
				Description = "Toggles Ambience",
				Icon = "rbxassetid://140519232156199",
				Type = "boolean",
				Path = { "Settings", "Ambience" }
			},
			["Disable Shadows"] = {
				Description = "Reduces game lag",
				Icon = "rbxassetid://128015283847150",
				Type = "boolean",
				Path = { "Settings", "Disable Shadows" }
			},
			["Global Notifications"] = {
				Description = "Announce when players catch rare fish",
				Icon = "rbxassetid://77048007523028",
				Type = "boolean",
				Path = { "Settings", "Global Notifications" }
			},
			["Server Notifications"] = {
				Description = "Announce when players catch fish",
				Icon = "rbxassetid://77048007523028",
				Type = "boolean",
				Path = { "Settings", "Server Notifications" }
			},
			["Mobile Auto Run"] = {
				Description = "Toggle auto running",
				Icon = "rbxassetid://83206005633160",
				Type = "boolean",
				Path = { "Settings", "Mobile Auto Run" }
			},
			["Receive Trades"] = {
				Description = "Allow players to trade you",
				Icon = "rbxassetid://120083696589185",
				Type = "boolean",
				Path = { "Settings", "Receive Trades" }
			},
			["Self Rod VFX"] = {
				Description = "Toggle your rod VFX",
				Icon = "rbxassetid://74783824795525",
				Type = "boolean",
				Path = { "Settings", "Self Rod VFX" }
			},
			["Receive Emote Sync Requests"] = {
				Description = "Allow players to send sync emote requests",
				Icon = "rbxassetid://120083696589185",
				Type = "boolean",
				Path = { "Settings", "Receive Emote Sync Requests" }
			},
			["Others Rod VFX"] = {
				Description = "Toggle other players rod VFX",
				Icon = "rbxassetid://74783824795525",
				Type = "boolean",
				Path = { "Settings", "Others Rod VFX" }
			},
			["Hide Player Fish"] = {
				Description = "Toggle other player\'s held fish",
				Icon = "rbxassetid://74783824795525",
				Type = "boolean",
				Path = { "Settings", "Hide Player Fish" }
			},
			["Show VIP Halo"] = {
				Description = "Toggle your vip Halo",
				Icon = "rbxassetid://74783824795525",
				Type = "boolean",
				Path = { "Settings", "Show VIP Halo" },
				ServerAction = function(p1, p2) --[[ ServerAction | Line: 150 ]]
					p1:SetAttribute("ShowVIPHalo", p2)
				end,
				ShowCondition = {
					Condition = function(p1) --[[ Condition | Line: 155 ]]
						local v1 = p1:GetAttribute("VIP")
						if v1 then
							return v1
						else
							return true
						end
					end,
					CheckConnection = function(p1, p2) --[[ CheckConnection | Line: 159 ]]
						return p1:GetAttributeChangedSignal("VIP"):Connect(function() --[[ Line: 160 | Upvalues: p1 (copy), p2 (copy) ]]
							print("VIP changed")
							if not p1:GetAttribute("VIP") then
								return
							end
							p2()
						end)
					end
				}
			}
		}
	}
}