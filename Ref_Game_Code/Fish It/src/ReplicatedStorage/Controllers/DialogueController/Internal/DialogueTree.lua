-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
require(script.Parent.Types)
require(ReplicatedStorage.Types.QuestTypes)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Shared.UserPriority)
local Quests = require(ReplicatedStorage.Modules.Quests)
local Constants = require(ReplicatedStorage.Shared.Constants)
local AreaUtility = require(ReplicatedStorage.Shared.AreaUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
require(ReplicatedStorage.Controllers.PromptController)
local VolcanicCavernDoor = require(ReplicatedStorage.Observers.VolcanicCavernDoor)
local v1 = Replion.Client:WaitReplion("Data")
local function checkStatus(p1, p2) --[[ checkStatus | Line: 27 | Upvalues: Quests (copy), v1 (copy) ]]
	local v12 = Quests[p1][p2]
	if not v12 then
		return false, false, nil
	end
	local v3 = false
	local v4 = nil
	if table.find(v1:GetExpect("CompletedQuests"), p2) then
		return true, true, v4
	end
	local v5 = v1:Get({ "Quests", p1, p2 })
	if not v5 then
		return false, false, nil
	end
	for k, v in pairs(v5.Objectives) do
		local v7 = v12.Objectives[k]
		if v7 then
			v3 = v.Progress >= v7.Goal
			if not v3 then
				break
			end
		end
	end
	return true, v3, v5
end
local function getHMS(p1) --[[ getHMS | Line: 66 ]]
	local v1 = p1 % 86400
	math.floor(p1 / 86400)
	return math.floor(v1 / 3600), math.floor(v1 % 3600 / 60), math.floor(p1 % 60)
end
local function formatTime(p1) --[[ formatTime | Line: 77 ]]
	local v1 = p1 % 86400
	math.floor(p1 / 86400)
	return ("%dh %dm %ds"):format(math.floor(v1 / 3600), math.floor(v1 % 3600 / 60), (math.floor(p1 % 60)))
end
local tbl = {
	Outlaw = { function() --[[ Line: 86 | Upvalues: checkStatus (copy) ]]
			local v1, v2 = checkStatus("Mainline", "Charitable Donations")
			local t = {}
			local t3 = {
				Reply = "How can I help?",
				DialogueType = "QuestGiver"
			}
			t3.Response = if v2 then "You\'ve already done more than enough!" else "If you can fish up some supplies for us to give out, that\'d be very helpful"
			t[1] = {
				Reply = "Outlaws... THE bad guys?",
				Response = "Not at all! We \'tactically acquire\' supplies and give them back to the community!"
			}
			t[2] = t3
			if v1 and not v2 then
				table.insert(t, {
					Reply = "I have the supplies!",
					Response = "Awesome! This will help so many people!"
				})
			end
			return {
				IncludeExitDialogue = true,
				Dialogue = t
			}
		end },
	Sheriff = { function() --[[ Line: 118 | Upvalues: checkStatus (copy) ]]
			local v1, v2, _ = checkStatus("Mainline", "Troubled Waters")
			if v2 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "Show outlawed fish!",
							Response = "Thank you for bringing the bandits to justice! Here is your reward...",
							DialogueType = "QuestTurnIn"
						},
						{
							Reply = "Leave",
							Response = "",
							Void = true
						}
					}
				}
			end
			local t = {
				IncludeExitDialogue = true
			}
			local t2 = {}
			local t3 = {
				Reply = "Troubled Waters",
				DialogueType = "QuestGiver"
			}
			t3.Response = if v1 then "Catch the outlawed fish then return to me" else "Catch outlawed fish for a reward!"
			t2[1] = t3
			t2[2] = {
				Reply = "Leave",
				Response = "",
				Void = true
			}
			t.Dialogue = t2
			return t
		end },
	Blacksmith = { function() --[[ Line: 162 | Upvalues: v1 (copy) ]]
			local v12 = v1:Get({ "Statistics", "TridentLevel" }) or 1
			local v2 = v1:Get({ "Settings", "Trident Levels" }) and true or false
			return {
				IncludeExitDialogue = true,
				Dialogue = {
					{
						Result = false,
						Reply = ("%* Color Change"):format(if v2 then "Disable" else "Enable"),
						Response = if v2 then "Your Overlord\'s Trident will no longer change color when catching SECRET fish" else "Your Overlord\'s Trident will change color when catching a SECRET fish"
					},
					{
						Reply = "Reset Trident Color",
						Result = false,
						Response = if v12 == 1 then "Already reset your trident!" else "Reset trident color!"
					},
					{
						Reply = "Trident Status",
						Result = false,
						Response = ("Every time you catch a SECRET, your trident updates in color! SECRETS caught: %* / %*"):format(v12, 7)
					},
					{
						Reply = "Leave",
						Response = "",
						Void = true
					}
				}
			}
		end },
	Florist = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "When does this event end?",
					Result = true,
					Response = DateTime.fromUnixTimestamp(Constants.Flags.ValentineEndTime):FormatLocalTime("lll", "en-us")
				},
				{
					Reply = "View Shop",
					Response = "",
					Result = true
				},
				{
					Reply = "View Battlepass",
					Response = "",
					Result = true
				}
			}
		}
	},
	["Lava Dweller"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What are you?",
					Response = "\226\132\184 \204\163 \226\149\142\225\146\178\225\146\183  \226\149\142\225\147\173  ||\240\157\153\185\226\154\141\226\136\183  \226\136\180\240\157\153\185\226\136\183\225\147\173\226\132\184 \204\163   \225\146\183\227\131\170\225\146\183\225\146\178||",
					Result = true
				},
				{
					Reply = "When does this area open?",
					Response = "\226\149\142  \225\148\145\225\146\178  \202\150\226\154\141\226\136\183\227\131\170\226\149\142\227\131\170\226\138\163  \226\154\141!\194\161",
					Result = true
				},
				{
					Reply = "I don\'t understand",
					Response = "\225\147\173\226\154\141\225\147\181\226\141\145  \226\149\142\225\147\173  \226\132\184 \204\163 \226\141\145\225\146\183  \227\131\170\225\148\145\226\132\184 \204\163 \226\154\141\226\136\183\225\146\183  \240\157\153\185\226\142\147  \234\150\142\226\149\142\226\142\147\225\146\183",
					Result = true
				}
			}
		}
	},
	["Reactor Man"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Seismic activity",
					Response = "You should get out of here! Seismic readings are off the charts lately",
					Result = true
				}
			}
		}
	},
	["Hazmat Leader"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Hazmat Suit Quest",
					Response = "",
					Result = true
				},
				{
					Reply = "Why the suit?",
					Response = "It\'s a requirement to travel below the Volcano",
					Result = true
				}
			}
		}
	},
	["Lava Fisherman"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Any luck?",
					Response = "No not yet! I\'m overflowing with Magma Gobys!",
					Result = true
				}
			}
		}
	},
	["Scientist Samantha"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Scientist Lucille said you forgot this?",
					Response = "OML I totally did! Thank you so much!",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What\'re you even doing here?",
					Response = "Something odd seems to be going on with the island... do you think you could help me measure a few things?",
					Path = 3
				},
				{
					Reply = "Ok I have those measurements!",
					Response = function() --[[ Response | Line: 312 | Upvalues: v1 (copy), Quests (copy) ]]
						local v12 = v1:Get({ "Quests", "Mainline" })
						if if v12 and v12["Taking Measurements"] then v12["Taking Measurements"].Objectives[1].Progress >= Quests.Mainline["Taking Measurements"].Objectives[1].Goal else false then
							return "Those are very interesting readings... something odd is happening..."
						else
							return "What\'re you talking about?"
						end
					end
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Absolutely!",
					Response = "Sick! Basically just walk around the island and use that tool and report the findings to me",
					Result = true
				},
				{
					Reply = "No I can\'t right now.",
					Response = "Oh, well that sucks. Let me know if you change your mind."
				}
			}
		}
	},
	["Scientist Lucille"] = { function() --[[ Line: 344 | Upvalues: v1 (copy) ]]
			if v1:Find("CompletedQuests", "Sample Collection") ~= nil then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "What is this place??",
							Response = "Dunno... I just work here",
							Result = true
						},
						{
							Reply = "I have the samples you requested from Scientist Jameson",
							Response = "Awesome! Sam forgot this tool, could you take it to her in Crater Island?",
							Result = true
						}
					}
				}
			else
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "What is this place??",
							Response = "Dunno... I just work here"
						}
					}
				}
			end
		end },
	["Scientist Jameson"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Woah... what is this..?",
					Response = "Not important!! I need samples, please go collect them.",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Ok where can I find them?",
					Response = "They can be found around the island!"
				},
				{
					Reply = "I have your samples!",
					Response = "Could you please take those over to Lucy in the lab? Thanks!"
				}
			}
		}
	},
	Phil = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Who are you guys?",
					Response = "I\'m Phil and this is Bill, we are adventurers!",
					Result = true
				},
				{
					Reply = "Have y\'all heard anything interesting lately?",
					Response = "We have.",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Well... are you going to tell me???",
					Response = "Oh! I guess I could give you some information... but you have to help us first!",
					Path = 3
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Fine, what do you need?",
					Response = "Ask Bill, I\'m pretty clueless to be honest",
					Result = true
				},
				{
					Reply = "I\'d rather not, I\'ll figure it out myself.",
					Response = "Wow, that was rather rude dontcha think Bill?",
					Result = true
				}
			}
		}
	},
	Bill = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Who are you guys?",
					Response = "I\'m Bill and this is Phil, we are explorers!",
					Result = true
				},
				{
					Reply = "Phil said y\'all needed some help and in exchange you would tell me some rumors you heard?",
					Response = "A weird laboratory has popped up on the island, catch us a few fish from that area and we\'ll let you know what we know.",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Ok, I have the fish, now spill the beans!",
					Result = true,
					Response = function() --[[ Response | Line: 470 | Upvalues: v1 (copy), Quests (copy) ]]
						local v12 = v1:Get({ "Quests", "Mainline" })
						if if v12 and v12["A Rumor"] then v12["A Rumor"].Objectives[1].Progress >= Quests.Mainline["A Rumor"].Objectives[1].Goal else false then
							return "All I\'ve heard is they\'re bringing hazmat suits..."
						else
							return "Yeah right, come back once you\'ve finished!"
						end
					end
				}
			}
		}
	},
	["Dead Skeleton"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Deadman\'s Treasure",
					Response = "I lost some letters in Pirate Cove, find them and return them and I\'ll grant you my treasure.",
					Result = true
				},
				{
					Reply = "I have found all the letters!",
					Response = "YARRRRRR!",
					Result = true
				}
			}
		}
	},
	Hookie = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "Mysterious Maze",
					Response = "There is a maze on the other side of that pile of rubble!",
					Result = true
				},
				{
					Reply = "Hooke Bobber",
					Response = "The most precious Bobber pirates have ever known! Do my tasks and you too can own one",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = false,
			Dialogue = {
				{
					Reply = "Start Quest",
					Response = "Catch 5 fish with the Leviathan Rage mutation!",
					Result = true
				},
				{
					Reply = "I\'ll pass",
					Response = "",
					Result = true
				}
			}
		}
	},
	["Captain Jones"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "Who are you?",
					Response = "A lost Sea Captain fella. Unfortunately my quest has expired and I am looking for new waters to explore.",
					Result = true
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "1 Enraged Fish",
					Response = "I need a fish with Leviathan Rage on it",
					Result = true
				},
				{
					Reply = "The Dead Man\'s Compass",
					Response = "Legends say beneath the Trident lies the Compass...",
					Result = true
				},
				{
					Reply = "1 Cursed Kraken",
					Response = "I need you to bring me a SECRET Cursed Kraken",
					Result = true
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Start Quest",
					Response = "Return when you have completed all my tasks!",
					Result = true
				},
				{
					Reply = "Complete Quest!",
					Response = "",
					Result = true
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "[CURSED KRAKEN]",
					Response = "",
					Result = true
				},
				{
					Reply = "[ENRAGED FISH]",
					Response = "",
					Result = true
				}
			}
		}
	},
	Musician = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What instrument is that?",
					Response = "A Banjo!",
					Result = true
				}
			}
		}
	},
	Fishmonger = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What is a Fishmonger?",
					Response = "I prepare the freshest fish for my pirate crew",
					Result = true
				}
			}
		}
	},
	Archaeologist = { function() --[[ Line: 646 | Upvalues: AreaUtility (copy), v1 (copy) ]]
			if not AreaUtility:AreaUnlocked(v1, "Pirate Cove") then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "The Leviathan",
							Response = "It\'s a monsterous fish that can only be summoned with rare artifacts and a Leviathan\'s Scale",
							Result = true
						},
						{
							Reply = "View Progress",
							Response = "",
							Result = true
						}
					}
				}
			end
			local v12 = v1:Get({ "Quests", "Mainline", "Forgotten Scale" })
			local v2 = v12 ~= nil
			local v3 = if v12 == nil then false else v12.Claimed
			local v4 = if v3 and (v12 and v12.ClaimedAt) then math.max(86400 - (workspace:GetServerTimeNow() - v12.ClaimedAt), 0) else nil
			local v7
			if v4 then
				local v8 = v4 % 86400
				math.floor(v4 / 86400)
				v7 = ("Quest resets in: %*"):format((("%dh %dm %ds"):format(math.floor(v8 / 3600), math.floor(v8 % 3600 / 60), (math.floor(v4 % 60)))))
			else
				v7 = if v3 then "You completed the quest for today!" elseif v2 then "Catch the Artifacts on any island, as long as this quest is active!" else "Activated this quest now!"
			end
			return {
				IncludeExitDialogue = true,
				Dialogue = {
					{
						Reply = "The Leviathan",
						Response = "It\'s a monsterous fish that can only be summoned with rare artifacts and a Leviathan\'s Scale",
						Result = true
					},
					{
						Reply = "View Progress",
						Response = "You completed the Pirate Cove index! Come back daily to earn a Leviathan Scale",
						Result = true
					},
					{
						Reply = "Forgotten Scale Quest",
						Result = true,
						Response = v7
					}
				}
			}
		end },
	Carpenter = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What are you doing here?",
					Response = "The captain ordered me to clear the rubble blocking the cave",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = false,
			Dialogue = {
				{
					Reply = "I can help!",
					Response = "That\'s a relief! Find sticks of TNT around the Island to clear the way",
					Result = true
				},
				{
					Reply = "That sucks",
					Response = "",
					Result = true
				}
			}
		}
	},
	["Ghastly Pirate"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Crystalline Secrets Quest",
					Response = ""
				},
				{
					Reply = "[Exchange Items]",
					Response = "",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "[CURSED KRAKEN]",
					Response = ""
				}
			}
		}
	},
	["Diamond Researcher"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "Shiny Rocks?",
					Response = "Help me finish my research and I\'ll reward you greatly",
					Result = true
				},
				{
					Reply = "Diamond Researcher Quest",
					Response = ""
				},
				{
					Reply = "[Exchange Items]",
					Response = "",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "[GEMSTONE RUBY]",
					Response = ""
				},
				{
					Reply = "[LOCHNESS MONSTER]",
					Response = ""
				}
			}
		}
	},
	["Esoteric Gatekeeper"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "I would like to use the elevator.",
					Response = "Ok, that\'ll be 400 Coins.",
					Path = 2
				},
				{
					Reply = "Do you have any quests for me?",
					Response = "If you enchant a rod 5 times I\'ll give you something in exchange."
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Ok, here you are.",
					Response = "Preciate it"
				},
				{
					Reply = "That\'s too expensive!",
					Response = "Your loss"
				}
			}
		}
	},
	Ram = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Do you need any help?",
					Response = "Sam thinks he\'s the best fisherman... we\'ll show him up by catching some BIG fish!"
				}
			}
		}
	},
	Sam = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Are you the best fisherman around here?",
					Response = "Some might say that."
				},
				{
					Reply = "How can I get to the level you are at?",
					Response = "If you wanna get on my level, you\'re going to have to prove yourself."
				}
			}
		}
	},
	["Scuba Steve"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What\'s wrong??",
					Response = "I dropped some coins I scavenged earlier! Can you help me find them??",
					DialogueType = "QuestGiver"
				},
				{
					Reply = "I think I have found all the coins you were missing...",
					Response = "Really?! You\'re the best!",
					DialogueType = "QuestTurnIn"
				},
				{
					Reply = "Is there anything else I can help you with?",
					Response = "Well actually... I think I misplaced my boat keys in the Tropical Grove",
					DialogueType = "QuestGiver"
				},
				{
					Reply = "I have found your boat keys!",
					Response = "You are a livesaver! Took me forever to get my boating license!!",
					DialogueType = "QuestTurnIn"
				}
			}
		}
	},
	Astrid = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Jungle Fish",
					Response = "If you can find me some fish, I\'ll give you something in return!"
				}
			}
		}
	},
	["Forager Jen"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What\'re you doing out here?",
					Response = "I am out here foraging for mushrooms! And now you\'re gonna help me, look for cutie mushrooms on the ground!"
				},
				{
					Reply = "Are you looking for any fish?",
					Response = "Nothing specifically, just something... different..."
				},
				{
					Reply = "I have found all your mushrooms!",
					Response = "OMG thank you!! Here is your reward!"
				}
			}
		}
	},
	["Volcanic Fisherman"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Spicy Fish",
					Response = "I love spicy food, just like the fish in this area! Collect a few and I\'ll give you something special."
				}
			}
		}
	},
	["Frog Commander"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "RIBBIT",
					Response = "RIBBIT RIBBIT"
				},
				{
					Reply = "Frog Army Quest",
					Response = "Gather an army of frogs from the coasts of Fisherman Island!"
				}
			}
		}
	},
	["Crabby Guy"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Heavenly Fish Quest",
					Response = "Complete this quest for a reward!"
				}
			}
		}
	},
	["Capt Jack"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Lost ye treasure?",
					Response = "Aye I did, now you must bring them to me! Now get goin\' -- fortune favors the bold!"
				}
			}
		}
	},
	Narwhal = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Swimming Narwhals",
					Response = "Find me a Narwhal and something to eat to receive something awesome!"
				}
			}
		}
	},
	Hans = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "View Lantern Store",
					Response = "",
					Result = true
				},
				{
					Reply = "View Inventory",
					Response = "",
					Result = true
				}
			}
		}
	},
	Jordan = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "View Emote Store",
					Response = "",
					Result = true
				}
			}
		}
	},
	Chad = { function() --[[ Line: 1039 | Upvalues: Replion (copy), checkStatus (copy) ]]
			local v1 = false
			if Replion.Client:GetReplion("Data").Destroyed then
				v1 = true
			else
				local v2, v3 = checkStatus("Event", "Cave Explorer")
				if v2 or v3 then
					v1 = true
				end
			end
			if v1 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "What is this place?",
							Response = "Special area that is only open for 1h 30m!",
							Result = true
						},
						{
							Reply = "When does it open next?",
							Response = "Every 3 hours globally!",
							Result = true
						}
					}
				}
			else
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "What is this place?",
							Response = "Special area that is only open for 1h 30m!",
							Result = true
						},
						{
							Reply = "When does it open next?",
							Response = "Every 3 hours globally!",
							Result = true
						},
						{
							Reply = "[START QUEST]",
							Response = "",
							Result = true
						}
					}
				}
			end
		end },
	Leo = { function() --[[ Line: 1097 | Upvalues: v1 (copy), Constants (copy), checkStatus (copy) ]]
			if v1.Destroyed or (Constants.Flags.ChristmasEndTime or 0) < workspace:GetServerTimeNow() then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "Is this event active?",
							Response = "No",
							Result = true
						}
					}
				}
			end
			local v3, v4 = checkStatus("Event", "Save the Christmas Express")
			if v4 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "I found them all!",
							Response = "Thank you for saivng the day!",
							Result = true
						}
					}
				}
			end
			if v3 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "Still looking...",
							Response = "I hope you can fish up those wheels!",
							Result = true
						},
						{
							Reply = "Where could they be?",
							Response = "Try using your Fishing Radar",
							Result = true
						}
					}
				}
			else
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "What happened?",
							Response = "A handful of our train wheels went missing!",
							Result = true
						},
						{
							Reply = "Where are they?",
							Response = "I think they rolled into the water during maintenance",
							Result = true
						},
						{
							Reply = "[START QUEST]",
							Response = "Use your Fishing Radar to locate the spots!",
							Result = true
						}
					}
				}
			end
		end },
	Noob = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "SECRETS?",
					Response = "I prefer my Clownfish, no thanks!",
					Result = true
				}
			}
		}
	},
	Guest = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "<Observe>",
					Response = "Leave",
					Result = true
				}
			}
		}
	},
	Hank = { function() --[[ Line: 1247 | Upvalues: ItemUtility (copy), PlayerStatsUtility (copy), v1 (copy) ]]
			local v12 = ItemUtility.GetItemDataFromItemType("Gears", "Hank\'s Diary")
			local v2, v3, v4
			if v12 then
				local v5 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 1256 | Upvalues: v12 (copy) ]]
					return p1.Id == v12.Data.Id
				end, "Items")
				if v5 then
					if v1:GetExpect("EquippedId") == v5.UUID then
						v2 = "My notes! Take this Pickaxe as thanks. Equip it when crystals glow and extract Cave Crystals!"
						v3 = "DialogueType"
						v4 = "QuestTurnIn"
					else
						v2 = "Please hold my Diary in your hand"
						v3 = "Result"
						v4 = true
					end
				else
					v2 = "You have not found it yet!"
					v3 = "Result"
					v4 = true
				end
			else
				v2 = nil
				v3 = nil
				v4 = nil
			end
			return {
				IncludeExitDialogue = false,
				Dialogue = {
					{
						Reply = "What are those crystals?",
						Response = "Some of them glow every few hours, I\'ve heard they give a special mutation...",
						Result = true
					},
					{
						Reply = "Crystal Gathering Quest",
						Response = "If you can fish up my Sunken Diary, I\'ll give you my Pickaxe! It can extract glowing crystals!",
						DialogueType = "QuestGiver"
					},
					{
						Reply = "I found your Diary!",
						Response = v2,
						[v3] = v4
					},
					{
						Reply = "...",
						Response = "",
						Void = true
					}
				}
			}
		end },
	["D.M.C Meteorologist"] = { function() --[[ Line: 1308 | Upvalues: checkStatus (copy) ]]
			local v1, v2, v3 = checkStatus("Mainline", "Comet Samples")
			local t = {
				IncludeExitDialogue = true,
				Dialogue = {
					{
						Reply = "Comet Samples Quest",
						DialogueType = "QuestGiver",
						Response = if v2 then "Thank you for getting those samples!" elseif v1 then "Please return with samples from that Comet" else "If you\'re feeling brave, I need samples from that Comet"
					},
					{
						Reply = "Are you okay?",
						Response = "The observatory can be rebuilt. You cannot replicate a once-in-a-lifetime cosmic collision"
					},
					{
						Reply = "What is that rock?",
						Response = "That wasn\226\128\153t an ordinary rock, my friend"
					}
				}
			}
			local v5 = if v3 then v3.Objectives[1] else v3
			if v5 and v5.Progress >= 5 then
				table.insert(t.Dialogue, {
					Reply = "I\'ve returned!",
					Response = "Fantastic! Here is your reward",
					DialogueType = "QuestTurnIn"
				})
			end
			return t
		end },
	Dorian = { function() --[[ Line: 1352 | Upvalues: checkStatus (copy) ]]
			local _, v1 = checkStatus("Mainline", "Coral Quest")
			return {
				IncludeExitDialogue = true,
				Dialogue = {
					{
						Reply = "Coral Quest",
						Response = "If you can collect 30 Corals, I\'ll give you my Coral Lantern!",
						DialogueType = "QuestGiver"
					},
					{
						Reply = "I got the corals.",
						DialogueType = "QuestTurnIn",
						Response = if v1 then "Thank you so much! Here is your reward" else "You don\'t have all 30 Corals"
					}
				}
			}
		end },
	["Magma Fisherman"] = { function() --[[ Line: 1380 | Upvalues: checkStatus (copy), VolcanicCavernDoor (copy) ]]
			local v1, v2 = checkStatus("Mainline", "Kohana Gatekeeper")
			if v2 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "I did everything!",
							Response = "Thank you so much, here let me open the door!",
							Result = true,
							FinishedCallback = function() --[[ FinishedCallback | Line: 1391 | Upvalues: VolcanicCavernDoor (ref) ]]
								VolcanicCavernDoor.OpenGate:Fire()
							end
						}
					}
				}
			end
			if v1 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "Still working on it...",
							Response = "You got this!",
							Result = true
						}
					}
				}
			else
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "Whats this?",
							Response = "A giant door...",
							Result = true
						},
						{
							Reply = "How can I open the door?",
							Response = "You just need to catch some fishes and use some charms!",
							Result = true
						}
					}
				}
			end
		end },
	Clara = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "View Pets",
					Response = "",
					Result = true,
					Blocked = true
				},
				{
					Reply = "What are pets?",
					Response = "Pets are companions that provide additional support",
					Result = false
				},
				{
					Reply = "Do you have a favorite pet?",
					Response = "I have a pet frog and I love him!!",
					Result = false
				}
			}
		}
	},
	["Boat Expert"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Boats",
					Response = "",
					Result = true
				}
			}
		}
	},
	Navigator = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Boats",
					Response = "",
					Result = true
				}
			}
		}
	},
	McBoatson = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Boats",
					Response = "",
					Result = true
				}
			}
		}
	},
	Jeffery = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Boats",
					Response = "",
					Result = true
				}
			}
		}
	},
	Scott = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Boats",
					Response = "",
					Result = true
				}
			}
		}
	},
	Joe = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Fishing Rods",
					Response = "",
					Result = true
				},
				{
					Reply = "Where is the best Rod?",
					Response = "Hidden deep within the Ancient Jungle",
					Void = true
				}
			}
		}
	},
	Burt = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Fishing Rods",
					Response = "",
					Result = true
				}
			}
		}
	},
	["Alien Merchant"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Shop",
					Response = "",
					Result = true
				}
			}
		}
	},
	Jim = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "The Jungle?",
					Response = "Drive your boat in this direction to reach it!",
					Result = true
				}
			}
		}
	},
	Tim = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Fishing Rods",
					Response = "",
					Result = true
				}
			}
		}
	},
	Scientist = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Potions",
					Response = "",
					Result = true
				},
				{
					Reply = "Do you have any quests?",
					Response = "Well, I might have a few things you can do...",
					Path = 2
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Do you need any test subjects?",
					Response = "I could use a few fish for an upcoming experiment I want to perform."
				}
			}
		}
	},
	["Billy Bob"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Rod Skins",
					Response = "",
					Result = true
				}
			}
		}
	},
	Ron = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What is that to your left?",
					Response = "This is my trusty Megalofriend Skin",
					Result = true
				},
				{
					Reply = "[More Info]",
					Response = "",
					Path = 2
				},
				{
					Reply = "[Claim Reward]",
					Response = "",
					Result = true
				}
			}
		},
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "What level do I have to be?",
					Response = "Level 300",
					Result = true
				},
				{
					Reply = "What else is needed?",
					Response = "Be the ORIGINAL OWNER of 2 Megalodons",
					Result = true
				}
			}
		}
	},
	["Aura Kid"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Who are you?",
					Response = "An Indonesian legend",
					Result = true
				},
				{
					Reply = "[START QUEST]",
					Response = "",
					Result = true
				}
			}
		}
	},
	Seth = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Blocked = true,
					Reply = "View Baits",
					Response = "",
					Result = true
				}
			}
		}
	},
	["Silly Fisherman"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Any luck today?",
					Response = "Nothing but Clownfish...",
					Void = true
				},
				{
					Reply = "Do you know where the Lava Fisherman is?",
					Response = "I heard he was at Kohana Volcano",
					Void = true
				}
			}
		}
	},
	["Tour Guide"] = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Lets go on a tour!",
					Result = true,
					Response = function() --[[ Response | Line: 1842 | Upvalues: GuiControl (copy) ]]
						task.defer(function() --[[ Line: 1843 | Upvalues: GuiControl (ref) ]]
							GuiControl:Open("Aquarium", true, "tour_guide")
						end)
						return "Opening your Aquarium menu."
					end
				}
			}
		}
	},
	["Temple Guardian"] = {
		{
			IncludeExitDialogue = false,
			Dialogue = {
				{
					Blocked = true,
					Reply = "How do I use this Altar?",
					Response = "Sacrifice a SECRET fish for 1 Transcended Stone",
					Void = true
				},
				{
					Reply = "Transcended Stone?",
					Response = "Allows you to apply a second rod enchant",
					Void = true
				},
				{
					Reply = "[Proceed]",
					Response = "",
					Path = 2
				},
				{
					Reply = "[Exit]",
					Response = "",
					Void = true
				}
			}
		},
		{
			IncludeExitDialogue = false,
			Dialogue = {
				{
					Reply = "[Exit]",
					Response = "",
					Void = true
				},
				{
					Reply = "[Proceed]",
					Response = "",
					Path = 3
				}
			}
		},
		{
			IncludeExitDialogue = false,
			Dialogue = {
				{
					Reply = "[Exit]",
					Response = "",
					Void = true
				},
				{
					Reply = "DESTROY HELD SECRET FISH",
					Response = "",
					Result = true
				}
			}
		}
	},
	["Submarine Operator"] = { function() --[[ Line: 1920 | Upvalues: Replion (copy), ItemUtility (copy) ]]
			local v1 = Replion.Client:GetReplion("Data")
			local v2 = v1:Get({ "Inventory", "Items" })
			local v3 = v1:Get("SubmarineOperator") or false
			local Data = ItemUtility.GetItemDataFromItemType("Fish", "Cosmic Tailfish").Data
			local count = 0
			for v4, v5 in v2 do
				if v5.Id == Data.Id then
					count = count + 1
				end
			end
			if v3 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Reply = "[Use Submarine]",
							Response = "",
							Result = false
						},
						{
							Reply = "Leave",
							Response = "",
							Void = true
						}
					}
				}
			end
			if not v3 and count >= 20 then
				return {
					IncludeExitDialogue = true,
					Dialogue = {
						{
							Response = "Payment Accepted",
							Result = false,
							Reply = ("I need 20 %* to power the submarine descent"):format(Data.Name)
						},
						{
							Reply = "Leave",
							Response = "",
							Void = true
						}
					}
				}
			end
			return {
				IncludeExitDialogue = true,
				Dialogue = {
					{
						Result = false,
						Reply = ("I need 20 %* to power the submarine descent"):format(Data.Name),
						Response = ("You need x%* %*"):format(20 - count, Data.Name)
					},
					{
						Reply = "Leave",
						Response = "",
						Void = true
					}
				}
			}
		end },
	["Duck Boy"] = { function() --[[ Line: 1990 | Upvalues: checkStatus (copy) ]]
			local v1, v2, v3 = checkStatus("Mainline", "Duck Hunter")
			local t = {
				IncludeExitDialogue = true,
				Dialogue = {
					{
						Reply = "Duck Hunter",
						DialogueType = "QuestGiver",
						Response = if v2 then "Thank you for catching me those ducks!" elseif v1 then "Please return 10 Rubber Duckies to me" else "Fish Rubber Duckies for a special rod skin!"
					},
					{
						Reply = "Leave",
						Response = "",
						Void = true
					}
				}
			}
			local v5 = if v3 then v3.Objectives[1] else v3
			if v5 and v5.Progress >= 10 then
				table.insert(t.Dialogue, {
					Reply = "Turn in rubber ducks!",
					Response = "Good work! Here is your reward",
					DialogueType = "QuestTurnIn"
				})
			end
			return t
		end },
	["Pizza Man"] = { function() --[[ Line: 2026 | Upvalues: checkStatus (copy) ]]
			local v1, v2, v3 = checkStatus("Mainline", "Catch the Slices")
			local t = {
				IncludeExitDialogue = true,
				Dialogue = {
					{
						Reply = "Catch the Slices",
						DialogueType = "QuestGiver",
						Response = if v2 then "Thank you for catching me those slices of pizza!" elseif v1 then "Please return 8 slices of pizza to me" else "Fish slices of pizza for a special rod skin!"
					},
					{
						Reply = "Leave",
						Response = "",
						Void = true
					}
				}
			}
			local v5 = if v3 then v3.Objectives[2] else v3
			if v5 and v5.Progress >= 1 then
				table.insert(t.Dialogue, {
					Reply = "Turn in slices of pizza!",
					Response = "Good work! Here is your reward",
					DialogueType = "QuestTurnIn"
				})
			end
			return t
		end },
	Prospector = {
		{
			IncludeExitDialogue = true,
			Dialogue = {
				{
					Reply = "Know anything about the mine?",
					Response = "Collapsed. Miners found somethin\' strange down there... an old rod.",
					Void = true
				}
			}
		}
	}
}
for k, v in pairs(tbl) do
	for i, v2 in ipairs(v) do
		if typeof(v2) == "table" and v2.IncludeExitDialogue then
			table.insert(v2.Dialogue, {
				Reply = "Leave",
				Response = "",
				Void = true
			})
		end
	end
end
return tbl