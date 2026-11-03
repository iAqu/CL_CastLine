-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = Random.new()
local t = {
	BrainrotPool = {
		Common = {
			{
				Name = "Noobini Pizzanini",
				Chance = 20
			},
			{
				Name = "Lirili Larila",
				Chance = 20
			},
			{
				Name = "Tim Cheese",
				Chance = 15
			},
			{
				Name = "Talpa Di Fero",
				Chance = 15
			},
			{
				Name = "Svinina Bombardino",
				Chance = 10
			},
			{
				Name = "Pipi Kiwi",
				Chance = 10
			},
			{
				Name = "Fruli Frula",
				Chance = 5
			},
			{
				Name = "Trippi Troppi",
				Chance = 5
			}
		},
		Rare = {
			{
				Name = "Gangster Footera",
				Chance = 20
			},
			{
				Name = "Bobrito Bandito",
				Chance = 20
			},
			{
				Name = "Boneca Ambalabu",
				Chance = 15
			},
			{
				Name = "Ta Ta Ta Ta Sahur",
				Chance = 15
			},
			{
				Name = "Ballerina Cappuccina",
				Chance = 12
			},
			{
				Name = "Cappuccino Assassino",
				Chance = 10
			},
			{
				Name = "Brr Brr Patapim",
				Chance = 5
			},
			{
				Name = "Cacto Hipopotamo",
				Chance = 3
			}
		},
		Epic = {
			{
				Name = "Garamararam",
				Chance = 25
			},
			{
				Name = "Madung",
				Chance = 19
			},
			{
				Name = "Waterdino",
				Chance = 15
			},
			{
				Name = "Pesto Mortioni",
				Chance = 13
			},
			{
				Name = "Pannaburro",
				Chance = 10
			},
			{
				Name = "Orcalero",
				Chance = 9
			},
			{
				Name = "Mangolini Parrocini",
				Chance = 5
			},
			{
				Name = "John Pork",
				Chance = 3
			},
			{
				Name = "Gattatino Nyanino",
				Chance = 1
			}
		},
		Legendary = {
			{
				Name = "Gattatino Nyanino",
				Chance = 24
			},
			{
				Name = "Chimpanzini Bananini",
				Chance = 18
			},
			{
				Name = "Plan Red",
				Chance = 15
			},
			{
				Name = "Plan Blue",
				Chance = 13
			},
			{
				Name = "Capi Taco",
				Chance = 9
			},
			{
				Name = "Trulimero Trulicina",
				Chance = 8
			},
			{
				Name = "Bambini Crostini",
				Chance = 6
			},
			{
				Name = "Elefantucci Bananucci",
				Chance = 4
			},
			{
				Name = "Bananita Dolphinita",
				Chance = 2
			},
			{
				Name = "Salamino Pinguino",
				Chance = 1
			}
		},
		Mythic = {
			{
				Name = "Bananita Dolphinita",
				Chance = 20
			},
			{
				Name = "Salamino Pinguino",
				Chance = 18
			},
			{
				Name = "Penguino Cocosino",
				Chance = 15
			},
			{
				Name = "67",
				Chance = 13
			},
			{
				Name = "Burbaloni Luliloli",
				Chance = 10
			},
			{
				Name = "Chef Crabracadabra",
				Chance = 8
			},
			{
				Name = "Capybara Eggplant",
				Chance = 6
			},
			{
				Name = "Bangello",
				Chance = 4
			},
			{
				Name = "Elefanto Frigo",
				Chance = 3
			},
			{
				Name = "Rinooccio Verdini",
				Chance = 2
			},
			{
				Name = "Glorbo Fruttodrillo",
				Chance = 1
			}
		},
		Godly = {
			{
				Name = "Elefanto Frigo",
				Chance = 22
			},
			{
				Name = "Rinooccio Verdini",
				Chance = 18
			},
			{
				Name = "Glorbo Fruttodrillo",
				Chance = 15
			},
			{
				Name = "Udin Din Din Dun",
				Chance = 12
			},
			{
				Name = "Pandaccini Bananini",
				Chance = 10
			},
			{
				Name = "Octopusini Bluberini",
				Chance = 8
			},
			{
				Name = "Strawberelli Flamingelli",
				Chance = 6
			},
			{
				Name = "Sigma Boy",
				Chance = 4
			},
			{
				Name = "Frigo Camelo",
				Chance = 2
			},
			{
				Name = "Orangutini Ananasini",
				Chance = 1.5
			},
			{
				Name = "Rhino Toasterino",
				Chance = 1
			},
			{
				Name = "Bombardiro Crocodilo",
				Chance = 0.5
			}
		},
		Secret = {
			{
				Name = "Frigo Camelo",
				Chance = 19
			},
			{
				Name = "Orangutini Ananasini",
				Chance = 16
			},
			{
				Name = "Rhino Toasterino",
				Chance = 14
			},
			{
				Name = "Bombardiro Crocodilo",
				Chance = 12
			},
			{
				Name = "Bombini Gusini",
				Chance = 10
			},
			{
				Name = "Tuff Toucan",
				Chance = 9
			},
			{
				Name = "Fryuro",
				Chance = 7
			},
			{
				Name = "Burguro",
				Chance = 5
			},
			{
				Name = "Guest666",
				Chance = 3
			},
			{
				Name = "Zibra Zubra Zibralini",
				Chance = 2
			},
			{
				Name = "Cavallo Virtuso",
				Chance = 1.5
			},
			{
				Name = "Gorillo Watermelondrillo",
				Chance = 1
			},
			{
				Name = "Cocofanto Elefanto",
				Chance = 0.5
			}
		},
		Rainbow = {
			{
				Name = "Guest666",
				Chance = 18
			},
			{
				Name = "Zibra Zubra Zibralini",
				Chance = 15
			},
			{
				Name = "Cavallo Virtuso",
				Chance = 12
			},
			{
				Name = "Gorillo Watermelondrillo",
				Chance = 10
			},
			{
				Name = "Cocofanto Elefanto",
				Chance = 10
			},
			{
				Name = "Girafa Celeste",
				Chance = 9
			},
			{
				Name = "Tralalero Tralala",
				Chance = 8
			},
			{
				Name = "Tralalerita Tralala",
				Chance = 6
			},
			{
				Name = "Peant Jarro",
				Chance = 4
			},
			{
				Name = "Dipperi Chiperini",
				Chance = 3
			},
			{
				Name = "Rexosaurus",
				Chance = 2
			},
			{
				Name = "1x1x1x1",
				Chance = 1.5
			},
			{
				Name = "Matteo",
				Chance = 1
			},
			{
				Name = "Espresso Signora",
				Chance = 0.5
			}
		},
		Hacked = {
			{
				Name = "Dipperi Chiperini",
				Chance = 20
			},
			{
				Name = "Rexosaurus",
				Chance = 18
			},
			{
				Name = "1x1x1x1",
				Chance = 16
			},
			{
				Name = "Matteo",
				Chance = 12
			},
			{
				Name = "Espresso Signora",
				Chance = 10
			},
			{
				Name = "Alessio",
				Chance = 6
			},
			{
				Name = "Tripi Tropi Tropa Tripa",
				Chance = 4
			},
			{
				Name = "SWAG SODA",
				Chance = 4
			},
			{
				Name = "Stoppo Luminino",
				Chance = 3
			},
			{
				Name = "Torrtuginni Dragonfrutini",
				Chance = 2
			},
			{
				Name = "Tictac Sahur",
				Chance = 2
			},
			{
				Name = "Los Primos Blue",
				Chance = 1
			},
			{
				Name = "Cactus Pingu",
				Chance = 1
			},
			{
				Name = "La Vacca Saturno Saturnita",
				Chance = 0.5
			},
			{
				Name = "Agarrini La Palini",
				Chance = 0.5
			}
		},
		Demon = {
			{
				Name = "Torrtuginni Dragonfrutini",
				Chance = 21
			},
			{
				Name = "Tictac Sahur",
				Chance = 18
			},
			{
				Name = "Los Primos Blue",
				Chance = 16
			},
			{
				Name = "Cactus Pingu",
				Chance = 12
			},
			{
				Name = "La Vacca Saturno Saturnita",
				Chance = 10
			},
			{
				Name = "Agarrini La Palini",
				Chance = 6
			},
			{
				Name = "Karkerkar Kurkur",
				Chance = 4
			},
			{
				Name = "Blackhole Goat",
				Chance = 4
			},
			{
				Name = "Cappuccino Clownino",
				Chance = 3
			},
			{
				Name = "Compactoroni Diskaloni",
				Chance = 2
			},
			{
				Name = "Nuclearo Dinossauro",
				Chance = 2
			},
			{
				Name = "Chillin Chilli",
				Chance = 1
			},
			{
				Name = "Crazylone Pizaione",
				Chance = 0.4
			},
			{
				Name = "Corn Sahur",
				Chance = 0.3
			},
			{
				Name = "Meowl",
				Chance = 0.2
			},
			{
				Name = "Strawberry Elephant",
				Chance = 0.1
			}
		},
		Celestial = {
			{
				Name = "Blackhole Goat",
				Chance = 24
			},
			{
				Name = "Cappuccino Clownino",
				Chance = 22.5
			},
			{
				Name = "Compactoroni Diskaloni",
				Chance = 20.4
			},
			{
				Name = "Nuclearo Dinossauro",
				Chance = 14.03
			},
			{
				Name = "Chillin Chilli",
				Chance = 7.002
			},
			{
				Name = "Crazylone Pizaione",
				Chance = 4.0003
			},
			{
				Name = "Corn Sahur",
				Chance = 3.00005
			},
			{
				Name = "Meowl",
				Chance = 2.5
			},
			{
				Name = "Strawberry Elephant",
				Chance = 1.5
			},
			{
				Name = "Dragonfrutina Dolphinita",
				Chance = 0.7
			},
			{
				Name = "Guerriro Digitale",
				Chance = 0.3
			},
			{
				Name = "Chicleteira Bicicleteira",
				Chance = 0.05
			},
			{
				Name = "Pot Hotspot",
				Chance = 0.01
			},
			{
				Name = "Krupuk Pagi Pagi",
				Chance = 0.005
			},
			{
				Name = "Beluga Beluga",
				Chance = 0.001
			},
			{
				Name = "Tralaledon",
				Chance = 0.001
			},
			{
				Name = "Anpali Babel",
				Chance = 0.0005
			},
			{
				Name = "Mastodontico Telepiedone",
				Chance = 0.0001
			},
			{
				Name = "Ketupat Kepat",
				Chance = 0.00005
			}
		}
	},
	Index = {
		Common = {
			transform_func = function(p1) --[[ transform_func | Line: 578 ]]
				ClearRarityLabel(p1)
				p1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
			end
		},
		Rare = {
			transform_func = function(p1) --[[ transform_func | Line: 584 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				local UIStroke = p1:FindFirstChildOfClass("UIStroke")
				if UIStroke then
					UIStroke.Color = Color3.new()
				end
				ReplicatedStorage.Objects.UI.RarityGradients.rare:Clone().Parent = p1
			end
		},
		Legendary = {
			transform_func = function(p1) --[[ transform_func | Line: 596 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				local UIStroke = p1:FindFirstChildOfClass("UIStroke")
				if UIStroke then
					UIStroke.Color = Color3.new()
				end
				ReplicatedStorage.Objects.UI.RarityGradients.legendary:Clone().Parent = p1
			end
		},
		Epic = {
			transform_func = function(p1) --[[ transform_func | Line: 608 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				local UIStroke = p1:FindFirstChildOfClass("UIStroke")
				if UIStroke then
					UIStroke.Color = Color3.new()
				end
				ReplicatedStorage.Objects.UI.RarityGradients.epic:Clone().Parent = p1
			end
		},
		Mythic = {
			transform_func = function(p1) --[[ transform_func | Line: 620 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				local UIStroke = p1:FindFirstChildOfClass("UIStroke")
				if UIStroke then
					UIStroke.Color = Color3.new()
				end
				ReplicatedStorage.Objects.UI.RarityGradients.mythic:Clone().Parent = p1
			end
		},
		Godly = {
			transform_func = function(p1) --[[ transform_func | Line: 632 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				local UIStroke = p1:FindFirstChildOfClass("UIStroke")
				if UIStroke then
					UIStroke.Color = Color3.new()
				end
				ReplicatedStorage.Objects.UI.RarityGradients.godly:Clone().Parent = p1
			end
		},
		Secret = {
			transform_func = function(p1) --[[ transform_func | Line: 644 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				local UIStroke = p1:FindFirstChildOfClass("UIStroke")
				if UIStroke then
					UIStroke.Color = Color3.new(255/255, 255/255, 255/255)
				end
				local v1 = p1:Clone()
				v1.AnchorPoint = Vector2.new(0.5, 0.5)
				v1.Position = UDim2.fromScale(0.5, 0.5)
				v1.Size = UDim2.fromScale(1, 1)
				p1.TextColor3 = Color3.new()
				v1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
				v1:WaitForChild("UIStroke").Color = Color3.new()
				v1.Text = "Secret"
				ReplicatedStorage.Objects.UI.RarityGradients.secret:Clone().Parent = v1
				v1.Parent = p1
			end
		},
		Divine = {
			transform_func = function(p1) --[[ transform_func | Line: 666 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				local UIStroke = p1:FindFirstChildOfClass("UIStroke")
				if UIStroke then
					UIStroke.Color = Color3.fromRGB(255, 191, 28)
				end
				p1.TextColor3 = Color3.fromRGB(255, 236, 160)
				local v1 = p1:Clone()
				v1.AnchorPoint = Vector2.new(0.5, 0.5)
				v1.Position = UDim2.fromScale(0.5, 0.5)
				v1.Size = UDim2.fromScale(1, 1)
				v1.TextColor3 = Color3.fromRGB(255, 191, 28)
				v1:WaitForChild("UIStroke").Color = Color3.fromRGB(255, 236, 160)
				v1.Text = "Divine"
				ReplicatedStorage.Objects.UI.RarityGradients.divine:Clone().Parent = v1
				v1.Parent = p1
			end
		},
		OG = {
			transform_func = function(p1) --[[ transform_func | Line: 688 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				p1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
				ReplicatedStorage.Objects.UI.RarityGradients.og:Clone().Parent = p1
			end
		},
		Exclusive = {
			transform_func = function(p1) --[[ transform_func | Line: 696 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				p1.TextColor3 = Color3.new()
				local v1 = ReplicatedStorage.Objects.UI.RarityGradients.exclusive:Clone()
				local v2 = p1:FindFirstChildOfClass("UIStroke") or p1:WaitForChild("UIStroke")
				v2.Color = Color3.new(255/255, 255/255, 255/255)
				v1.Parent = v2
			end
		},
		Celestial = {
			transform_func = function(p1) --[[ transform_func | Line: 706 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				p1.TextColor3 = Color3.new()
				local v1 = ReplicatedStorage.Objects.UI.RarityGradients.Celestial:Clone()
				local v2 = p1:FindFirstChildOfClass("UIStroke") or p1:WaitForChild("UIStroke")
				v2.Color = Color3.new(255/255, 255/255, 255/255)
				v1.Parent = v2
			end
		},
		Rainbow = {
			transform_func = function(p1) --[[ transform_func | Line: 716 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				p1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
				ReplicatedStorage.Objects.UI.RarityGradients.rainbow:Clone().Parent = p1
			end
		},
		Hacked = {
			transform_func = function(p1) --[[ transform_func | Line: 724 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				p1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
				ReplicatedStorage.Objects.UI.RarityGradients.hacked:Clone().Parent = p1
			end
		},
		Demon = {
			transform_func = function(p1) --[[ transform_func | Line: 732 | Upvalues: ReplicatedStorage (copy) ]]
				ClearRarityLabel(p1)
				p1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
				ReplicatedStorage.Objects.UI.RarityGradients.demon:Clone().Parent = p1
			end
		}
	},
	StealProducts = {
		Common = 3571979107,
		Rare = 3571979521,
		Epic = 3572012898,
		Legendary = 3571979381,
		Mythic = 3571979417,
		Godly = 3571979315,
		Secret = 3571979578,
		Divine = 3571979235,
		Hacked = 3577645893,
		OG = 3571979476,
		Celestial = 3581487487
	}
}
function Sort() --[[ Sort | Line: 756 | Upvalues: t (copy) ]]
	for k, v in pairs(t.BrainrotPool) do
		table.sort(v, function(p1, p2) --[[ Line: 758 ]]
			return p1.Chance < p2.Chance
		end)
	end
end
Sort()
function ClearRarityLabel(p1) --[[ ClearRarityLabel | Line: 766 ]]
	if p1:FindFirstChildOfClass("UIGradient") then
		p1:FindFirstChildOfClass("UIGradient"):Destroy()
	end
	if p1:FindFirstChildOfClass("TextLabel") then
		p1:FindFirstChildOfClass("TextLabel"):Destroy()
	end
end
function t.GetBrainrotFromRarity(p1, p2, p3) --[[ GetBrainrotFromRarity | Line: 776 | Upvalues: t (copy), v1 (copy) ]]
	local v12 = p3 or 1
	if t.BrainrotPool[p2] then
		local v2 = v1:NextNumber(0, 100)
		local sum = 0
		for i, v in ipairs(t.BrainrotPool[p2]) do
			sum = sum + v.Chance * v12
			if v2 <= sum then
				return v.Name
			end
		end
		return t.BrainrotPool[p2][#t.BrainrotPool[p2]].Name
	else
		warn((("Pool %* doesn\'t exist"):format(p2)))
	end
end
local t2 = {
	{
		Rarity = "Common",
		Distance = 0
	},
	{
		Rarity = "Rare",
		Distance = 131
	},
	{
		Rarity = "Epic",
		Distance = 301
	},
	{
		Rarity = "Legendary",
		Distance = 541
	},
	{
		Rarity = "Mythic",
		Distance = 816
	},
	{
		Rarity = "Godly",
		Distance = 1136
	},
	{
		Rarity = "Secret",
		Distance = 1483
	},
	{
		Rarity = "Rainbow",
		Distance = 1862
	},
	{
		Rarity = "Hacked",
		Distance = 2297
	},
	{
		Rarity = "Demon",
		Distance = 2777
	},
	{
		Rarity = "Celestial",
		Distance = 3230
	}
}
function t.GetRarityByDistance(p1, p2) --[[ GetRarityByDistance | Line: 811 | Upvalues: t2 (copy) ]]
	local v1 = nil
	for i, v in ipairs(t2) do
		if not (v.Distance <= p2) then
			break
		end
		v1 = v.Rarity
	end
	return v1
end
t.Colors = {
	Common = Color3.new(0.794507, 0.794507, 0.794507),
	Rare = Color3.new(0.461067, 0.964065, 1),
	Legendary = Color3.new(1, 0.809094, 0.284092),
	Mythic = Color3.new(0.797253, 0, 0),
	Godly = Color3.new(0.87657, 0.326741, 1),
	Secret = Color3.new(0.546563, 0.546563, 0.546563),
	Rainbow = Color3.new(0.921569, 0.431373, 0.854902),
	Hacked = Color3.new(0.0156863, 0.317647, 0.0156863),
	Demon = Color3.new(0.282353, 0.0196078, 0.0235294),
	Celstial = Color3.new(0.92549, 1, 0.752941)
}
return t