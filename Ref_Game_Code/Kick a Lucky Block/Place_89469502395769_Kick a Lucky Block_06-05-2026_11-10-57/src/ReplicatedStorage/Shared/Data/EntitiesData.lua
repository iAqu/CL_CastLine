-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local MutationData = require(ReplicatedStorage.Shared.Data.MutationData)
local t = {
	MAX_LEVEL = 75,
	MAX_SCALE_FACTOR = 3.5,
	LuckyBlocks = {
		Virus = {
			Rarity = "Exclusive",
			Image = "rbxassetid://115911858927646",
			Model = ReplicatedStorage.Objects.LuckyBlockModels.Virus,
			Pool = {
				{
					Name = "Ketchuru Matsuru",
					Chance = 0.1
				},
				{
					Name = "Los Nooo My Hotspotsitos",
					Chance = 0.6
				},
				{
					Name = "Bottellini",
					Chance = 3.3
				},
				{
					Name = "W or L",
					Chance = 22
				},
				{
					Name = "Bambu Sahur",
					Chance = 31
				},
				{
					Name = "Castlino Fortini",
					Chance = 43
				}
			},
			MutationChances = {
				{
					Name = "Virus",
					Chance = 100
				}
			}
		},
		Rainbow = {
			Rarity = "Exclusive",
			Image = "rbxassetid://70406848911981",
			Model = ReplicatedStorage.Objects.LuckyBlockModels.Rainbow,
			Pool = {
				{
					Name = "Ketupat Kepat",
					Chance = 0.05
				},
				{
					Name = "Chicleteira Bicicleteira",
					Chance = 0.5
				},
				{
					Name = "Los Nooo My Hotspotsitos",
					Chance = 1
				},
				{
					Name = "Bottellini",
					Chance = 3
				},
				{
					Name = "Bambu Sahur",
					Chance = 8
				},
				{
					Name = "Castlino Fortini",
					Chance = 36
				},
				{
					Name = "Bombini Gusini",
					Chance = 51.45
				}
			},
			MutationChances = {
				{
					Name = "Rainbow",
					Chance = 100
				}
			}
		},
		RandomBrainrot = {
			Rarity = "Random",
			Pool = {
				{
					Name = "Pipi Kiwi",
					Chance = 15
				},
				{
					Name = "Fruli Frula",
					Chance = 13
				},
				{
					Name = "Gangster Footera",
					Chance = 10
				},
				{
					Name = "Bobrito Bandito",
					Chance = 8
				},
				{
					Name = "Ta Ta Ta Ta Sahur",
					Chance = 7
				},
				{
					Name = "Cappuccino Assassino",
					Chance = 7
				},
				{
					Name = "Brr Brr Patapim",
					Chance = 6
				},
				{
					Name = "Garamararam",
					Chance = 5
				},
				{
					Name = "Orcalero",
					Chance = 4
				},
				{
					Name = "John Pork",
					Chance = 4
				},
				{
					Name = "Gattatino Nyanino",
					Chance = 3
				},
				{
					Name = "Elefantucci Bananucci",
					Chance = 3
				},
				{
					Name = "Bananita Dolphinita",
					Chance = 2
				},
				{
					Name = "Salamino Pinguino",
					Chance = 2
				},
				{
					Name = "67",
					Chance = 1.9
				},
				{
					Name = "Burbaloni Luliloli",
					Chance = 1.5
				},
				{
					Name = "Chef Crabracadabra",
					Chance = 1.5
				},
				{
					Name = "Glorbo Fruttodrillo",
					Chance = 1
				},
				{
					Name = "Octopusini Bluberini",
					Chance = 1
				},
				{
					Name = "Frigo Camelo",
					Chance = 0.8
				},
				{
					Name = "Bombardiro Crocodilo",
					Chance = 0.7
				},
				{
					Name = "Zibra Zubra Zibralini",
					Chance = 0.7
				},
				{
					Name = "Gorillo Watermelondrillo",
					Chance = 0.6
				},
				{
					Name = "Tralalero Tralala",
					Chance = 0.4
				},
				{
					Name = "Espresso Signora",
					Chance = 0.4
				},
				{
					Name = "La Vacca Saturno Saturnita",
					Chance = 0.3
				},
				{
					Name = "Karkerkar Kurkur",
					Chance = 0.1
				},
				{
					Name = "Meowl",
					Chance = 0.04
				},
				{
					Name = "Strawberry Elephant",
					Chance = 0.03
				},
				{
					Name = "Spaghetti Tualetti",
					Chance = 0.02
				},
				{
					Name = "Dragon Cannelloni",
					Chance = 0.01
				}
			}
		}
	},
	Brainrots = {
		["Noobini Pizzanini"] = {
			Rarity = "Common",
			Image = "rbxassetid://75319480830335",
			Model = ReplicatedStorage.Objects.Entities["Noobini Pizzanini"],
			CPS = InfiniteMath.new("2, 0")
		},
		["Lirili Larila"] = {
			Rarity = "Common",
			Image = "rbxassetid://131208566426643",
			Model = ReplicatedStorage.Objects.Entities["Lirili Larila"],
			CPS = InfiniteMath.new("3, 0")
		},
		["Tim Cheese"] = {
			Rarity = "Common",
			Image = "rbxassetid://94884429890773",
			Model = ReplicatedStorage.Objects.Entities["Tim Cheese"],
			CPS = InfiniteMath.new("3, 0")
		},
		["Talpa Di Fero"] = {
			Rarity = "Common",
			Image = "rbxassetid://136375656116165",
			Model = ReplicatedStorage.Objects.Entities["Talpa Di Fero"],
			CPS = InfiniteMath.new("4, 0")
		},
		["Svinina Bombardino"] = {
			Rarity = "Common",
			Image = "rbxassetid://121747010794034",
			Model = ReplicatedStorage.Objects.Entities["Svinina Bombardino"],
			CPS = InfiniteMath.new("5, 0")
		},
		["Pipi Kiwi"] = {
			Rarity = "Common",
			Image = "rbxassetid://136784236098465",
			Model = ReplicatedStorage.Objects.Entities["Pipi Kiwi"],
			CPS = InfiniteMath.new("6, 0")
		},
		["Fruli Frula"] = {
			Rarity = "Common",
			Image = "rbxassetid://103369432974198",
			Model = ReplicatedStorage.Objects.Entities["Fruli Frula"],
			CPS = InfiniteMath.new("7, 0")
		},
		["Trippi Troppi"] = {
			Rarity = "Common",
			Image = "rbxassetid://80449561472357",
			Model = ReplicatedStorage.Objects.Entities["Trippi Troppi"],
			CPS = InfiniteMath.new("7, 0")
		},
		["Gangster Footera"] = {
			Rarity = "Rare",
			Image = "rbxassetid://76405129033440",
			Model = ReplicatedStorage.Objects.Entities["Gangster Footera"],
			CPS = InfiniteMath.new("15, 0")
		},
		["Bobrito Bandito"] = {
			Rarity = "Rare",
			Image = "rbxassetid://110804993213767",
			Model = ReplicatedStorage.Objects.Entities["Bobrito Bandito"],
			CPS = InfiniteMath.new("17, 0")
		},
		["Boneca Ambalabu"] = {
			Rarity = "Rare",
			Image = "rbxassetid://77324388882472",
			Model = ReplicatedStorage.Objects.Entities["Boneca Ambalabu"],
			CPS = InfiniteMath.new("17, 0")
		},
		["Ta Ta Ta Ta Sahur"] = {
			Rarity = "Rare",
			Image = "rbxassetid://98419701365463",
			Model = ReplicatedStorage.Objects.Entities["Ta Ta Ta Ta Sahur"],
			CPS = InfiniteMath.new("18, 0")
		},
		["Ballerina Cappuccina"] = {
			Rarity = "Rare",
			Image = "rbxassetid://105039839327842",
			Model = ReplicatedStorage.Objects.Entities["Ballerina Cappuccina"],
			CPS = InfiniteMath.new("19, 0")
		},
		["Cappuccino Assassino"] = {
			Rarity = "Rare",
			Image = "rbxassetid://119377920801566",
			Model = ReplicatedStorage.Objects.Entities["Cappuccino Assassino"],
			CPS = InfiniteMath.new("22, 0")
		},
		["Brr Brr Patapim"] = {
			Rarity = "Rare",
			Image = "rbxassetid://139607625825642",
			Model = ReplicatedStorage.Objects.Entities["Brr Brr Patapim"],
			CPS = InfiniteMath.new("22, 0")
		},
		["Cacto Hipopotamo"] = {
			Rarity = "Rare",
			Image = "rbxassetid://91924062954297",
			Model = ReplicatedStorage.Objects.Entities["Cacto Hipopotamo"],
			CPS = InfiniteMath.new("26, 0")
		},
		Garamararam = {
			Rarity = "Epic",
			Image = "rbxassetid://133450997727408",
			Model = ReplicatedStorage.Objects.Entities.Garamararam,
			CPS = InfiniteMath.new("40, 0")
		},
		Madung = {
			Rarity = "Epic",
			Image = "rbxassetid://115598577342600",
			Model = ReplicatedStorage.Objects.Entities.Madung,
			CPS = InfiniteMath.new("44, 0")
		},
		Waterdino = {
			Rarity = "Epic",
			Image = "rbxassetid://83009235126369",
			Model = ReplicatedStorage.Objects.Entities.Waterdino,
			CPS = InfiniteMath.new("50, 0")
		},
		["Pesto Mortioni"] = {
			Rarity = "Epic",
			Image = "rbxassetid://112772711091734",
			Model = ReplicatedStorage.Objects.Entities["Pesto Mortioni"],
			CPS = InfiniteMath.new("52, 0")
		},
		Pannaburro = {
			Rarity = "Epic",
			Image = "rbxassetid://117635196178276",
			Model = ReplicatedStorage.Objects.Entities.Pannaburro,
			CPS = InfiniteMath.new("62, 0")
		},
		Orcalero = {
			Rarity = "Epic",
			Image = "rbxassetid://77313751040026",
			Model = ReplicatedStorage.Objects.Entities.Orcalero,
			CPS = InfiniteMath.new("64, 0")
		},
		["Mangolini Parrocini"] = {
			Rarity = "Epic",
			Image = "rbxassetid://70405039301652",
			Model = ReplicatedStorage.Objects.Entities["Mangolini Parrocini"],
			CPS = InfiniteMath.new("64, 0")
		},
		["John Pork"] = {
			Rarity = "Epic",
			Image = "rbxassetid://119948975277118",
			Model = ReplicatedStorage.Objects.Entities["John Pork"],
			CPS = InfiniteMath.new("72, 0")
		},
		["Gattatino Nyanino"] = {
			Rarity = "Epic",
			Image = "rbxassetid://132830873664550",
			Model = ReplicatedStorage.Objects.Entities["Gattatino Nyanino"],
			CPS = InfiniteMath.new("76, 0")
		},
		["Chimpanzini Bananini"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://78514135677429",
			Model = ReplicatedStorage.Objects.Entities["Chimpanzini Bananini"],
			CPS = InfiniteMath.new("100, 0")
		},
		["Plan Red"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://77022388889858",
			Model = ReplicatedStorage.Objects.Entities["Plan Red"],
			CPS = InfiniteMath.new("130, 0")
		},
		["Plan Blue"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://102179487513960",
			Model = ReplicatedStorage.Objects.Entities["Plan Blue"],
			CPS = InfiniteMath.new("140, 0")
		},
		["Capi Taco"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://93263414417208",
			Model = ReplicatedStorage.Objects.Entities["Capi Taco"],
			CPS = InfiniteMath.new("150, 0")
		},
		["Trulimero Trulicina"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://93571654733093",
			Model = ReplicatedStorage.Objects.Entities["Trulimero Trulicina"],
			CPS = InfiniteMath.new("160, 0")
		},
		["Bambini Crostini"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://108229222006863",
			Model = ReplicatedStorage.Objects.Entities["Bambini Crostini"],
			CPS = InfiniteMath.new("160, 0")
		},
		["Elefantucci Bananucci"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://82121449421529",
			Model = ReplicatedStorage.Objects.Entities["Elefantucci Bananucci"],
			CPS = InfiniteMath.new("170, 0")
		},
		["Bananita Dolphinita"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://139708491823898",
			Model = ReplicatedStorage.Objects.Entities["Bananita Dolphinita"],
			CPS = InfiniteMath.new("210, 0")
		},
		["Salamino Pinguino"] = {
			Rarity = "Legendary",
			Image = "rbxassetid://90960024810702",
			Model = ReplicatedStorage.Objects.Entities["Salamino Pinguino"],
			CPS = InfiniteMath.new("230, 0")
		},
		["Penguino Cocosino"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://122582825336000",
			Model = ReplicatedStorage.Objects.Entities["Penguino Cocosino"],
			CPS = InfiniteMath.new("450, 0")
		},
		["67"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://120965422656755",
			Model = ReplicatedStorage.Objects.Entities["67"],
			CPS = InfiniteMath.new("500, 0")
		},
		["Burbaloni Luliloli"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://97831196935215",
			Model = ReplicatedStorage.Objects.Entities["Burbaloni Luliloli"],
			CPS = InfiniteMath.new("550, 0")
		},
		["Chef Crabracadabra"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://128304336488191",
			Model = ReplicatedStorage.Objects.Entities["Chef Crabracadabra"],
			CPS = InfiniteMath.new("600, 0")
		},
		["Capybara Eggplant"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://82971116650305",
			Model = ReplicatedStorage.Objects.Entities["Capybara Eggplant"],
			CPS = InfiniteMath.new("650, 0")
		},
		Bangello = {
			Rarity = "Mythic",
			Image = "rbxassetid://133719663179972",
			Model = ReplicatedStorage.Objects.Entities.Bangello,
			CPS = InfiniteMath.new("725, 0")
		},
		["Elefanto Frigo"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://115266661443545",
			Model = ReplicatedStorage.Objects.Entities["Elefanto Frigo"],
			CPS = InfiniteMath.new("775, 0")
		},
		["Rinooccio Verdini"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://137234598789166",
			Model = ReplicatedStorage.Objects.Entities["Rinooccio Verdini"],
			CPS = InfiniteMath.new("880, 0")
		},
		["Glorbo Fruttodrillo"] = {
			Rarity = "Mythic",
			Image = "rbxassetid://110154384300629",
			Model = ReplicatedStorage.Objects.Entities["Glorbo Fruttodrillo"],
			CPS = InfiniteMath.new("920, 0")
		},
		["Udin Din Din Dun"] = {
			Rarity = "Godly",
			Image = "rbxassetid://129428342569147",
			Model = ReplicatedStorage.Objects.Entities["Udin Din Din Dun"],
			CPS = InfiniteMath.new("1850, 0")
		},
		["Pandaccini Bananini"] = {
			Rarity = "Godly",
			Image = "rbxassetid://87758270364290",
			Model = ReplicatedStorage.Objects.Entities["Pandaccini Bananini"],
			CPS = InfiniteMath.new("2000, 0")
		},
		["Octopusini Bluberini"] = {
			Rarity = "Godly",
			Image = "rbxassetid://131953444007514",
			Model = ReplicatedStorage.Objects.Entities["Octopusini Bluberini"],
			CPS = InfiniteMath.new("2150, 0")
		},
		["Strawberelli Flamingelli"] = {
			Rarity = "Godly",
			Image = "rbxassetid://114384521389647",
			Model = ReplicatedStorage.Objects.Entities["Strawberelli Flamingelli"],
			CPS = InfiniteMath.new("2300, 0")
		},
		["Sigma Boy"] = {
			Rarity = "Godly",
			Image = "rbxassetid://125522185470037",
			Model = ReplicatedStorage.Objects.Entities["Sigma Boy"],
			CPS = InfiniteMath.new("2450, 0")
		},
		["Frigo Camelo"] = {
			Rarity = "Godly",
			Image = "rbxassetid://113871185323223",
			Model = ReplicatedStorage.Objects.Entities["Frigo Camelo"],
			CPS = InfiniteMath.new("2600, 0")
		},
		["Orangutini Ananasini"] = {
			Rarity = "Godly",
			Image = "rbxassetid://98626083830553",
			Model = ReplicatedStorage.Objects.Entities["Orangutini Ananasini"],
			CPS = InfiniteMath.new("2700, 0")
		},
		["Rhino Toasterino"] = {
			Rarity = "Godly",
			Image = "rbxassetid://81688891171688",
			Model = ReplicatedStorage.Objects.Entities["Rhino Toasterino"],
			CPS = InfiniteMath.new("2950, 0")
		},
		["Bombardiro Crocodilo"] = {
			Rarity = "Godly",
			Image = "rbxassetid://80433611044755",
			Model = ReplicatedStorage.Objects.Entities["Bombardiro Crocodilo"],
			CPS = InfiniteMath.new("3100, 0")
		},
		["Bombini Gusini"] = {
			Rarity = "Secret",
			Image = "rbxassetid://127508471476203",
			Model = ReplicatedStorage.Objects.Entities["Bombini Gusini"],
			CPS = InfiniteMath.new("4750, 0")
		},
		["Tuff Toucan"] = {
			Rarity = "Secret",
			Image = "rbxassetid://106750871025072",
			Model = ReplicatedStorage.Objects.Entities["Tuff Toucan"],
			CPS = InfiniteMath.new("5300, 0")
		},
		Fryuro = {
			Rarity = "Secret",
			Image = "rbxassetid://87970702969272",
			Model = ReplicatedStorage.Objects.Entities.Fryuro,
			CPS = InfiniteMath.new("5850, 0")
		},
		Burguro = {
			Rarity = "Secret",
			Image = "rbxassetid://133542826151202",
			Model = ReplicatedStorage.Objects.Entities.Burguro,
			CPS = InfiniteMath.new("6250, 0")
		},
		Guest666 = {
			Rarity = "Secret",
			Image = "rbxassetid://103302387237057",
			Model = ReplicatedStorage.Objects.Entities.Guest666,
			CPS = InfiniteMath.new("7000, 0")
		},
		["Zibra Zubra Zibralini"] = {
			Rarity = "Secret",
			Image = "rbxassetid://93125744907787",
			Model = ReplicatedStorage.Objects.Entities["Zibra Zubra Zibralini"],
			CPS = InfiniteMath.new("7750, 0")
		},
		["Cavallo Virtuso"] = {
			Rarity = "Secret",
			Image = "rbxassetid://93740446873911",
			Model = ReplicatedStorage.Objects.Entities["Cavallo Virtuso"],
			CPS = InfiniteMath.new("8500, 0")
		},
		["Gorillo Watermelondrillo"] = {
			Rarity = "Secret",
			Image = "rbxassetid://81173491157809",
			Model = ReplicatedStorage.Objects.Entities["Gorillo Watermelondrillo"],
			CPS = InfiniteMath.new("9500, 0")
		},
		["Cocofanto Elefanto"] = {
			Rarity = "Secret",
			Image = "rbxassetid://119319269287860",
			Model = ReplicatedStorage.Objects.Entities["Cocofanto Elefanto"],
			CPS = InfiniteMath.new("10000, 0")
		},
		["Girafa Celeste"] = {
			Rarity = "Divine",
			Image = "rbxassetid://100744941229878",
			Model = ReplicatedStorage.Objects.Entities["Girafa Celeste"],
			CPS = InfiniteMath.new("16500, 0")
		},
		["Tralalero Tralala"] = {
			Rarity = "Divine",
			Image = "rbxassetid://122504665940183",
			Model = ReplicatedStorage.Objects.Entities["Tralalero Tralala"],
			CPS = InfiniteMath.new("17500, 0")
		},
		["Tralalerita Tralala"] = {
			Rarity = "Divine",
			Image = "rbxassetid://96020189567422",
			Model = ReplicatedStorage.Objects.Entities["Tralalerita Tralala"],
			CPS = InfiniteMath.new("18000, 0")
		},
		["Peant Jarro"] = {
			Rarity = "Divine",
			Image = "rbxassetid://75499207885541",
			Model = ReplicatedStorage.Objects.Entities["Peant Jarro"],
			CPS = InfiniteMath.new("19500, 0")
		},
		["Dipperi Chiperini"] = {
			Rarity = "Divine",
			Image = "rbxassetid://86335946089302",
			Model = ReplicatedStorage.Objects.Entities["Dipperi Chiperini"],
			CPS = InfiniteMath.new("20000, 0")
		},
		Rexosaurus = {
			Rarity = "Divine",
			Image = "rbxassetid://85087051819173",
			Model = ReplicatedStorage.Objects.Entities.Rexosaurus,
			CPS = InfiniteMath.new("22500, 0")
		},
		["1x1x1x1"] = {
			Rarity = "Divine",
			Image = "rbxassetid://127294829208444",
			Model = ReplicatedStorage.Objects.Entities["1x1x1x1"],
			CPS = InfiniteMath.new("23000, 0")
		},
		Matteo = {
			Rarity = "Divine",
			Image = "rbxassetid://94596505702479",
			Model = ReplicatedStorage.Objects.Entities.Matteo,
			CPS = InfiniteMath.new("25000, 0")
		},
		["Espresso Signora"] = {
			Rarity = "Divine",
			Image = "rbxassetid://109096303756869",
			Model = ReplicatedStorage.Objects.Entities["Espresso Signora"],
			CPS = InfiniteMath.new("27500, 0")
		},
		Alessio = {
			Rarity = "Hacked",
			Image = "rbxassetid://91086997984600",
			Model = ReplicatedStorage.Objects.Entities.Alessio,
			CPS = InfiniteMath.new("27500, 0")
		},
		["Tripi Tropi Tropa Tripa"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://116296196115993",
			Model = ReplicatedStorage.Objects.Entities["Tripi Tropi Tropa Tripa"],
			CPS = InfiniteMath.new("28000, 0")
		},
		["SWAG SODA"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://120108935941635",
			Model = ReplicatedStorage.Objects.Entities["SWAG SODA"],
			CPS = InfiniteMath.new("29000, 0")
		},
		["Stoppo Luminino"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://72251524505994",
			Model = ReplicatedStorage.Objects.Entities["Stoppo Luminino"],
			CPS = InfiniteMath.new("30000, 0")
		},
		["Torrtuginni Dragonfrutini"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://70697866232319",
			Model = ReplicatedStorage.Objects.Entities["Torrtuginni Dragonfrutini"],
			CPS = InfiniteMath.new("32000, 0")
		},
		["Tictac Sahur"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://123921983062254",
			Model = ReplicatedStorage.Objects.Entities["Tictac Sahur"],
			CPS = InfiniteMath.new("38000, 0")
		},
		["Los Primos Blue"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://110967828886077",
			Model = ReplicatedStorage.Objects.Entities["Los Primos Blue"],
			CPS = InfiniteMath.new("44500, 0")
		},
		["Cactus Pingu"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://103411619627632",
			Model = ReplicatedStorage.Objects.Entities["Cactus Pingu"],
			CPS = InfiniteMath.new("44500, 0")
		},
		["La Vacca Saturno Saturnita"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://93119742533311",
			Model = ReplicatedStorage.Objects.Entities["La Vacca Saturno Saturnita"],
			CPS = InfiniteMath.new("49500, 0")
		},
		["Agarrini La Palini"] = {
			Rarity = "Hacked",
			Image = "rbxassetid://99100981825168",
			Model = ReplicatedStorage.Objects.Entities["Agarrini La Palini"],
			CPS = InfiniteMath.new("53500, 0")
		},
		["Karkerkar Kurkur"] = {
			Rarity = "OG",
			Image = "rbxassetid://89348733379073",
			Model = ReplicatedStorage.Objects.Entities["Karkerkar Kurkur"],
			CPS = InfiniteMath.new("120000, 0")
		},
		["Blackhole Goat"] = {
			Rarity = "OG",
			Image = "rbxassetid://79276133074299",
			Model = ReplicatedStorage.Objects.Entities["Blackhole Goat"],
			CPS = InfiniteMath.new("125000, 0")
		},
		["Cappuccino Clownino"] = {
			Rarity = "OG",
			Image = "rbxassetid://81454628038027",
			Model = ReplicatedStorage.Objects.Entities["Cappuccino Clownino"],
			CPS = InfiniteMath.new("135000, 0")
		},
		["Compactoroni Diskaloni"] = {
			Rarity = "OG",
			Image = "rbxassetid://87977442598860",
			Model = ReplicatedStorage.Objects.Entities["Compactoroni Diskaloni"],
			CPS = InfiniteMath.new("135000, 0")
		},
		["Nuclearo Dinossauro"] = {
			Rarity = "OG",
			Image = "rbxassetid://101278278129268",
			Model = ReplicatedStorage.Objects.Entities["Nuclearo Dinossauro"],
			CPS = InfiniteMath.new("190000, 0")
		},
		["Chillin Chilli"] = {
			Rarity = "OG",
			Image = "rbxassetid://96622835615184",
			Model = ReplicatedStorage.Objects.Entities["Chillin Chilli"],
			CPS = InfiniteMath.new("220000, 0")
		},
		["Crazylone Pizaione"] = {
			Rarity = "OG",
			Image = "rbxassetid://70530192315271",
			Model = ReplicatedStorage.Objects.Entities["Crazylone Pizaione"],
			CPS = InfiniteMath.new("225000, 0")
		},
		["Corn Sahur"] = {
			Rarity = "OG",
			Image = "rbxassetid://80736745480866",
			Model = ReplicatedStorage.Objects.Entities["Corn Sahur"],
			CPS = InfiniteMath.new("225000, 0")
		},
		Meowl = {
			Rarity = "OG",
			Image = "rbxassetid://123257811507033",
			Model = ReplicatedStorage.Objects.Entities.Meowl,
			CPS = InfiniteMath.new("275000, 0")
		},
		["Strawberry Elephant"] = {
			Rarity = "OG",
			Image = "rbxassetid://139276568556211",
			Model = ReplicatedStorage.Objects.Entities["Strawberry Elephant"],
			CPS = InfiniteMath.new("420000, 0")
		},
		["Dragon Cannelloni"] = {
			Rarity = "Exclusive",
			Best = 2,
			Exclusive = true,
			Image = "rbxassetid://98819253605646",
			Model = ReplicatedStorage.Objects.Entities["Dragon Cannelloni"]
		},
		W = {
			Rarity = "Exclusive",
			Best = 0.75,
			Exclusive = true,
			Image = "rbxassetid://119378617331152",
			Model = ReplicatedStorage.Objects.Entities.W
		},
		["Spaghetti Tualetti"] = {
			Rarity = "Exclusive",
			Best = 1.5,
			Exclusive = true,
			Image = "rbxassetid://122209550117388",
			Model = ReplicatedStorage.Objects.Entities["Spaghetti Tualetti"]
		},
		["Esok Sekolah"] = {
			Rarity = "Exclusive",
			Best = 2.5,
			Exclusive = true,
			Image = "rbxassetid://134998120855911",
			Model = ReplicatedStorage.Objects.Entities["Esok Sekolah"]
		},
		["Dragonfrutina Dolphinita"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://75227072663667",
			Model = ReplicatedStorage.Objects.Entities["Dragonfrutina Dolphinita"],
			CPS = InfiniteMath.new("475000, 0")
		},
		["Guerriro Digitale"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://135723754991512",
			Model = ReplicatedStorage.Objects.Entities["Guerriro Digitale"],
			CPS = InfiniteMath.new("490000, 0")
		},
		["Chicleteira Bicicleteira"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://135748283315148",
			Model = ReplicatedStorage.Objects.Entities["Chicleteira Bicicleteira"],
			CPS = InfiniteMath.new("500000, 0")
		},
		["Pot Hotspot"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://122447804258070",
			Model = ReplicatedStorage.Objects.Entities["Pot Hotspot"],
			CPS = InfiniteMath.new("525000, 0")
		},
		["Krupuk Pagi Pagi"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://92163821312071",
			Model = ReplicatedStorage.Objects.Entities["Krupuk Pagi Pagi"],
			CPS = InfiniteMath.new("540000, 0")
		},
		["Beluga Beluga"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://83715370946953",
			Model = ReplicatedStorage.Objects.Entities["Beluga Beluga"],
			CPS = InfiniteMath.new("575000, 0")
		},
		Tralaledon = {
			Rarity = "Celestial",
			Image = "rbxassetid://84080914496805",
			Model = ReplicatedStorage.Objects.Entities.Tralaledon,
			CPS = InfiniteMath.new("625000, 0")
		},
		["Anpali Babel"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://119853900857283",
			Model = ReplicatedStorage.Objects.Entities["Anpali Babel"],
			CPS = InfiniteMath.new("750000, 0")
		},
		["Mastodontico Telepiedone"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://88270888447884",
			Model = ReplicatedStorage.Objects.Entities["Mastodontico Telepiedone"],
			CPS = InfiniteMath.new("850000, 0")
		},
		["Ketupat Kepat"] = {
			Rarity = "Celestial",
			Image = "rbxassetid://94483582151513",
			Model = ReplicatedStorage.Objects.Entities["Ketupat Kepat"],
			CPS = InfiniteMath.new("1000000, 0")
		},
		["Bambu Sahur"] = {
			Rarity = "Exclusive",
			Image = "rbxassetid://96855159940187",
			Model = ReplicatedStorage.Objects.Entities["Bambu Sahur"],
			CPS = InfiniteMath.new("12500, 0")
		},
		Bottellini = {
			Rarity = "Exclusive",
			Image = "rbxassetid://98493921875130",
			Model = ReplicatedStorage.Objects.Entities.Bottellini,
			CPS = InfiniteMath.new("75000, 0")
		},
		["Castlino Fortini"] = {
			Rarity = "Exclusive",
			Image = "rbxassetid://86632625079539",
			Model = ReplicatedStorage.Objects.Entities["Castlino Fortini"],
			CPS = InfiniteMath.new("5000, 0")
		},
		["Ketchuru Matsuru"] = {
			Rarity = "Exclusive",
			Image = "rbxassetid://115906134809606",
			Model = ReplicatedStorage.Objects.Entities["Ketchuru Matsuru"],
			CPS = InfiniteMath.new("800000, 0")
		},
		["Los Nooo My Hotspotsitos"] = {
			Rarity = "Exclusive",
			Image = "rbxassetid://92911424911254",
			Model = ReplicatedStorage.Objects.Entities["Los Nooo My Hotspotsitos"],
			CPS = InfiniteMath.new("200000, 0")
		},
		["W or L"] = {
			Rarity = "Exclusive",
			Image = "rbxassetid://113778680971441",
			Model = ReplicatedStorage.Objects.Entities["W or L"],
			CPS = InfiniteMath.new("15000, 0")
		}
	},
	Types = {
		Brainrot = {},
		LuckyBlock = {}
	},
	TradeLocked = { "Dragon Cannelloni", "Spaghetti Tualetti", "Esok Sekolah" }
}
for k in pairs(t.Brainrots) do
	t.Types.Brainrot[k] = true
end
for k in pairs(t.LuckyBlocks) do
	t.Types.LuckyBlock[k] = true
end
function t.GetTypeFromName(p1) --[[ GetTypeFromName | Line: 930 | Upvalues: t (copy) ]]
	if t.Types.Brainrot[p1] then
		return "Brainrot"
	elseif t.Types.LuckyBlock[p1] then
		return "LuckyBlock"
	end
end
function t.GetCostForUpgrade(p1, p2, p3) --[[ GetCostForUpgrade | Line: 938 | Upvalues: t (copy), MutationData (copy), InfiniteMath (copy) ]]
	local v1 = t.Brainrots[p1]
	if v1 then
		local v2 = v1.CPS or v1.BasePrice
		if p3 then
			v2 = v2 * if MutationData.Buffs[p3] then MutationData.Buffs[p3].Value or 1 else 1
		end
		return InfiniteMath.floor(v2 * 1.5 ^ (p2 - 1))
	end
end
t.CachedMultipliers = {}
function t.GetMultiplierPerLevel(p1) --[[ GetMultiplierPerLevel | Line: 954 | Upvalues: t (copy) ]]
	if not t.CachedMultipliers[p1] then
		t.CachedMultipliers[p1] = 1.25 ^ (p1 - 1)
	end
	return t.CachedMultipliers[p1]
end
return t