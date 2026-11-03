-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
RunService:IsClient()
local v1 = RunService:IsServer()
local t = { "EquipIdle", "ReelStart", "RodThrow", "FishCaught", "ReelingIdle", "ReelIntermission", "StartRodCharge", "LoopedRodCharge" }
local t2 = {
	Disabled = true
}
local t3 = {
	Looped = true,
	AnimationId = "rbxassetid://102117622211678",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Core
}
local t4 = {
	Looped = true,
	AnimationId = "rbxassetid://117916601972477",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t5 = {
	Looped = true,
	AnimationId = "rbxassetid://76025825877481",
	Length = 1.66,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t6 = {
	Looped = true,
	AnimationId = "rbxassetid://125894255406678",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t7 = {
	Looped = true,
	AnimationId = "rbxassetid://71203766210712",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t8 = {
	Looped = true,
	AnimationId = "rbxassetid://133684030438919",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t9 = {
	Looped = true,
	AnimationId = "rbxassetid://132353806217092",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t10 = {
	Looped = true,
	AnimationId = "rbxassetid://129253404684071",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t11 = {
	Looped = true,
	AnimationId = "rbxassetid://80846217511838",
	Length = 1.67,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t12 = {
	Looped = true,
	AnimationId = "rbxassetid://108109505072403",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t13 = {
	Looped = true,
	AnimationId = "rbxassetid://111994676873099",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t14 = {
	Looped = true,
	AnimationId = "rbxassetid://133354558740014",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t15 = {
	Looped = true,
	AnimationId = "rbxassetid://140344626493067",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t16 = {
	Looped = true,
	AnimationId = "rbxassetid://129632039690279",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t17 = {
	Looped = true,
	AnimationId = "rbxassetid://84396532594877",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t18 = {
	Looped = true,
	AnimationId = "rbxassetid://136083891799222",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t19 = {
	Looped = true,
	AnimationId = "rbxassetid://98387167886533",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t20 = {
	Looped = true,
	AnimationId = "rbxassetid://96366659600981",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t21 = {
	Looped = true,
	AnimationId = "rbxassetid://112759143341343",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t22 = {
	Looped = true,
	AnimationId = "rbxassetid://85246394508551",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t23 = {
	Looped = true,
	AnimationId = "rbxassetid://92036914464034",
	Length = 1,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t24 = {
	Looped = true,
	AnimationId = "rbxassetid://86376110148779",
	Length = 1.33,
	AnimationPriority = Enum.AnimationPriority.Action2
}
local t25 = {
	Looped = true,
	AnimationId = "rbxassetid://76325124055693",
	Length = 5,
	PlaybackSpeed = 1.2,
	AnimationPriority = Enum.AnimationPriority.Action
}
local t26 = {
	Looped = true,
	AnimationId = "rbxassetid://126831815839724",
	Length = 4,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t27 = {
	Looped = true,
	AnimationId = "rbxassetid://115229621326605",
	Length = 1.08,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t28 = {
	Looped = true,
	AnimationId = "rbxassetid://104188512165442",
	Length = 6,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t29 = {
	Looped = true,
	AnimationId = "rbxassetid://110738276580375",
	Length = 0.55,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t30 = {
	Looped = true,
	AnimationId = "rbxassetid://74643095451174",
	Length = 1.09,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t31 = {
	Looped = true,
	AnimationId = "rbxassetid://81700883907369",
	Length = 1.08,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t32 = {
	Looped = true,
	AnimationId = "rbxassetid://138790747812051",
	Length = 1.08,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t33 = {
	Looped = true,
	AnimationId = "rbxassetid://98716967215984",
	Length = 1.08,
	AnimationPriority = Enum.AnimationPriority.Idle
}
local t36 = {
	AnimationOverride = {
		Variants = true,
		AnimationId = "",
		Length = 0,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	RodThrow = {
		Default = true,
		Variants = true,
		AnimationId = "rbxassetid://92624107165273",
		Length = 0.966,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			THROW_LINE = "ReelingIdle"
		}
	},
	ReelingIdle = {
		Default = true,
		Variants = true,
		Looped = true,
		AnimationId = "rbxassetid://134965425664034",
		Length = 1.316,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	ReelStart = {
		Default = true,
		Variants = true,
		Looped = false,
		AnimationId = "rbxassetid://136614469321844",
		PlaybackSpeed = 1.2,
		Length = 0.666,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "ReelingIdle" }
	},
	ReelIntermission = {
		Default = true,
		Variants = true,
		Looped = true,
		AnimationId = "rbxassetid://114959536562596",
		PlaybackSpeed = 1.2,
		Length = 1.316,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	FishCaught = {
		Default = true,
		Variants = true,
		AnimationId = "rbxassetid://117319000848286",
		PlaybackSpeed = 1.2,
		Length = 1.233,
		AnimationPriority = Enum.AnimationPriority.Action4,
		LinkedMarkers = {
			FISH_CAUGHT = true
		}
	},
	EquipIdleFake = {
		Default = true,
		Looped = true,
		AnimationId = "rbxassetid://96586569072385",
		Length = 0.5,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	EquipIdle = {
		Default = true,
		Variants = true,
		Looped = true,
		AnimationId = "rbxassetid://96586569072385",
		Length = 0.5,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Electric Guitar - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://108792932396384",
		Length = 8.33,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Electric Guitar - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://108792932396384",
		Length = 8.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Pirate Banjo - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://120677591068007",
		Length = 10.5,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Pirate Banjo - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://120677591068007",
		Length = 10.5,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Kraken Anchor - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://126023229958416",
		Length = 12.5,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Oceanic Harpoon - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://77549515147440",
		Length = 8.33,
		PlaybackSpeed = 1.2,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Oceanic Harpoon - RodThrow"] = {
		AnimationId = "rbxassetid://127872348080219",
		PlaybackSpeed = 2.5,
		Length = 1.88,
		AnimationPriority = Enum.AnimationPriority.Action,
		CustomMarkers = { "ADD_ARROW", "HARP_THROW_LINE" },
		LinkedAnimations = { "Oceanic Harpoon - EquipIdle" }
	},
	["Oceanic Harpoon - FishCaught"] = t2,
	["Oceanic Harpoon - ReelingIdle"] = t25,
	["Oceanic Harpoon - ReelStart"] = t2,
	["Oceanic Harpoon - ReelIntermission"] = t2,
	["Oceanic Harpoon - LoopedRodCharge"] = t25,
	["Oceanic Harpoon - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://84873660213983",
		PlaybackSpeed = 1.5,
		Length = 1.58,
		AnimationPriority = Enum.AnimationPriority.Idle,
		CustomMarkers = { "HIDE_ARROW" },
		LinkedAnimations = { "Oceanic Harpoon - LoopedRodCharge" }
	},
	["Soul Scythe - RodThrow"] = {
		AnimationId = "rbxassetid://104946400643250",
		Length = 0.9,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			THROW_SCYTHE = "Soul Scythe - ReelingIdle"
		}
	},
	["Soul Scythe - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://95453600470089",
		Length = 1.316,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Soul Scythe - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://137684649541594",
		PlaybackSpeed = 1.2,
		Length = 0.65,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Soul Scythe - ReelingIdle" }
	},
	["Soul Scythe - ReelIntermission"] = {
		Looped = true,
		AnimationId = "rbxassetid://139621583239992",
		PlaybackSpeed = 1.2,
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Soul Scythe - FishCaught"] = {
		AnimationId = "rbxassetid://82259219343456",
		PlaybackSpeed = 1.2,
		Length = 1.25,
		AnimationPriority = Enum.AnimationPriority.Action4,
		LinkedMarkers = {
			FISH_CAUGHT = true
		}
	},
	["Soul Scythe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://84686809448947",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Soul Scythe - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://117668204114399",
		PlaybackSpeed = 1.4,
		Length = 2.6,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Soul Scythe - LoopedRodCharge" }
	},
	["Soul Scythe - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://88768375910397",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Aether Monarch - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://121491018104381",
		Length = 14
	},
	["Aether Monarch - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://90830760763606",
		Length = 0.98,
		CustomCastSFX = "Aether Monarch Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Aether Monarch - ReelIntermission" }
	},
	["Aether Monarch - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://74447876553309",
		Length = 1.05,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Aether Monarch - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://84610696434784",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Aether Monarch - AnimationOverride"] = t2,
	["Aether Monarch - ReelIntermission"] = t14,
	["Aether Monarch - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://126835913497348",
		Length = 0.82,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Aether Monarch - ReelingIdle" }
	},
	["Aether Monarch - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://76209550449427",
		Length = 0.65,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Aether Monarch - LoopedRodCharge" }
	},
	["Aether Monarch - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://116748897248196",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Cloud Weaver - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://76234007743182",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Cloud Weaver - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://102714856937891",
		Length = 1.66,
		PlaybackSpeed = 1.2,
		CustomCastSFX = "Cloud Weaver Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Cloud Weaver - ReelIntermission" }
	},
	["Cloud Weaver - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://121026156047780",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Cloud Weaver - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://138988285345072",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Cloud Weaver - AnimationOverride"] = t2,
	["Cloud Weaver - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://115924576544610",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Cloud Weaver - ReelingIdle" }
	},
	["Cloud Weaver - ReelIntermission"] = t4,
	["Cloud Weaver - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://88248360410785",
		Length = 0.66,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Cloud Weaver - LoopedRodCharge" }
	},
	["Cloud Weaver - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://98590600287473",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Luminary - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://104917097456556",
		Length = 10,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Blinding Bloom - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://104917097456556",
		Length = 10,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["The Telamonster - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://104917097456556",
		Length = 10,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Overdrive - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://100644136384320",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Overdrive - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://136289880957120",
		Length = 1.83,
		CustomCastSFX = "Overdrive Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Overdrive - ReelIntermission" }
	},
	["Overdrive - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://71232649901855",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Overdrive - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://72150560317484",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Overdrive - AnimationOverride"] = t2,
	["Overdrive - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://116450258618206",
		Length = 0.833,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Overdrive - ReelingIdle" }
	},
	["Overdrive - ReelIntermission"] = t3,
	["Overdrive - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://130585468103636",
		Length = 0.66,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Overdrive - LoopedRodCharge" }
	},
	["Overdrive - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://79925230717376",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Void Guitar - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://95999201117305",
		Length = 10,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Void Guitar - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://138518478924583",
		Length = 1.66,
		CustomCastSFX = "Void Guitar Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Void Guitar - ReelIntermission" }
	},
	["Void Guitar - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://79346352464845",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Void Guitar - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://97524757863614",
		Length = 0.78,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Void Guitar - AnimationOverride"] = t2,
	["Void Guitar - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://121313066400444",
		Length = 0.69,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Void Guitar - ReelingIdle" }
	},
	["Void Guitar - ReelIntermission"] = t5,
	["Void Guitar - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://82239185066630",
		Length = 0.69,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Void Guitar - LoopedRodCharge" }
	},
	["Void Guitar - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://109164729589309",
		Length = 1.66,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Kitty Guitar - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://87630031202735",
		Length = 10.67,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Kitty Guitar - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://72646314724257",
		Length = 1.33,
		CustomCastSFX = "Kitty Guitar Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Kitty Guitar - ReelIntermission" }
	},
	["Kitty Guitar - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://132530630982956",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Kitty Guitar - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://73825195414215",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Kitty Guitar - AnimationOverride"] = t2,
	["Kitty Guitar - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://114789328075535",
		Length = 0.67,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Kitty Guitar - ReelingIdle" }
	},
	["Kitty Guitar - ReelIntermission"] = t13,
	["Kitty Guitar - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://80820259983828",
		Length = 0.6,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Kitty Guitar - LoopedRodCharge" }
	},
	["Kitty Guitar - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://131979504798684",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Draconic Soul - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://81883372005196",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Draconic Soul - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://107444381732004",
		Length = 1.5,
		CustomCastSFX = "Draconic Soul Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Draconic Soul - ReelIntermission" }
	},
	["Draconic Soul - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://109818439508879",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Draconic Soul - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://90442979154401",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Draconic Soul - AnimationOverride"] = t2,
	["Draconic Soul - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://133372674989037",
		Length = 0.83,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Draconic Soul - ReelingIdle" }
	},
	["Draconic Soul - ReelIntermission"] = t9,
	["Draconic Soul - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://136915405644675",
		Length = 0.666,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Draconic Soul - LoopedRodCharge" }
	},
	["Draconic Soul - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://98341571572763",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Divine Staff - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://86423072130126",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Divine Staff - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://131024887950419",
		Length = 0.666,
		CustomCastSFX = "Divine Staff Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Divine Staff - ReelIntermission" }
	},
	["Divine Staff - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://107412232735920",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Divine Staff - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://104500532198687",
		Length = 1.333,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Divine Staff - AnimationOverride"] = t2,
	["Divine Staff - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://94338456707283",
		Length = 1.333,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Divine Staff - ReelingIdle" }
	},
	["Divine Staff - ReelIntermission"] = t8,
	["Divine Staff - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://78883363310496",
		Length = 0.75,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Divine Staff - LoopedRodCharge" }
	},
	["Divine Staff - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://76515943378128",
		Length = 1.333,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Empyrean Staff - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://118320952614262",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Empyrean Staff - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://133489421127513",
		Length = 1.33,
		CustomCastSFX = "Empyrean Staff Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Empyrean Staff - ReelIntermission" }
	},
	["Empyrean Staff - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://101971777673013",
		Length = 0.66,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Empyrean Staff - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://114085962755545",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Empyrean Staff - AnimationOverride"] = t2,
	["Empyrean Staff - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://91816004457745",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Empyrean Staff - ReelingIdle" }
	},
	["Empyrean Staff - ReelIntermission"] = t6,
	["Empyrean Staff - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://120248017494827",
		Length = 0.66,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Empyrean Staff - LoopedRodCharge" }
	},
	["Empyrean Staff - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://92905940219008",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Golden Clockwork - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://72700354353152",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Golden Clockwork - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://96332415342353",
		Length = 1,
		CustomCastSFX = "Golden Clockwork Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Golden Clockwork - ReelIntermission" }
	},
	["Golden Clockwork - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://126346193348309",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Golden Clockwork - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://94790395153696",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Golden Clockwork - AnimationOverride"] = t2,
	["Golden Clockwork - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://98742641645152",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Golden Clockwork - ReelingIdle" }
	},
	["Golden Clockwork - ReelIntermission"] = t7,
	["Golden Clockwork - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://72080262343677",
		Length = 0.5,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Golden Clockwork - LoopedRodCharge" }
	},
	["Golden Clockwork - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://75957773780398",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Bunny Summoner - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://74385277734645",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Bunny Summoner - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://92119014037155",
		Length = 1.33,
		CustomCastSFX = "Bunny Summoner Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Bunny Summoner - ReelIntermission" }
	},
	["Bunny Summoner - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://101318598176860",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Bunny Summoner - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://97917999692588",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Bunny Summoner - AnimationOverride"] = t2,
	["Bunny Summoner - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://99383419428134",
		Length = 1.16,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Bunny Summoner - ReelingIdle" }
	},
	["Bunny Summoner - ReelIntermission"] = {
		Looped = true,
		AnimationId = "rbxassetid://98638046654639",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Bunny Summoner - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://84847030328946",
		Length = 0.666,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Bunny Summoner - LoopedRodCharge" }
	},
	["Bunny Summoner - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://98533317186460",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Easter Parasol - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://116168889227689",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Easter Parasol - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://70995681870036",
		Length = 1.33,
		CustomCastSFX = "Easter Parasol Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Easter Parasol - ReelIntermission" }
	},
	["Easter Parasol - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://90572706842137",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Easter Parasol - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://74166101599898",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Easter Parasol - AnimationOverride"] = t2,
	["Easter Parasol - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://108663234139216",
		Length = 0.67,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Easter Parasol - ReelingIdle" }
	},
	["Easter Parasol - ReelIntermission"] = {
		Looped = true,
		AnimationId = "rbxassetid://86972585039200",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Easter Parasol - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://122696491900122",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Easter Parasol - LoopedRodCharge" }
	},
	["Easter Parasol - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://137844984210476",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Serpent\'s Trident - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://122561472973242",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Serpent\'s Trident - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://96623842733032",
		Length = 1.5,
		CustomCastSFX = "Serpent\'s Trident Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Serpent\'s Trident - ReelIntermission" }
	},
	["Serpent\'s Trident - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://140142098810185",
		Length = 1.25,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Serpent\'s Trident - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://131408040089892",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Serpent\'s Trident - AnimationOverride"] = t2,
	["Serpent\'s Trident - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://138782980424544",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Serpent\'s Trident - ReelingIdle" }
	},
	["Serpent\'s Trident - ReelIntermission"] = t10,
	["Serpent\'s Trident - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://107344802557950",
		Length = 0.5,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Serpent\'s Trident - LoopedRodCharge" }
	},
	["Serpent\'s Trident - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://76952291492667",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Crimson Retribution - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://134618541979874",
		Length = 10,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Crimson Retribution - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://123005446937658",
		Length = 0.93,
		CustomCastSFX = "Crimson Retribution Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Crimson Retribution - ReelIntermission" }
	},
	["Crimson Retribution - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://108205633866814",
		Length = 1.3,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Crimson Retribution - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://89468138971946",
		Length = 1.67,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Crimson Retribution - AnimationOverride"] = t2,
	["Crimson Retribution - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://93235258977772",
		Length = 1.15,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Crimson Retribution - ReelingIdle" }
	},
	["Crimson Retribution - ReelIntermission"] = t11,
	["Crimson Retribution - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://83552070588647",
		Length = 0.77,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Crimson Retribution - LoopedRodCharge" }
	},
	["Crimson Retribution - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://89520986909291",
		Length = 1.67,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Dark Matter Scythe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://85161190305071",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Dark Matter Scythe - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://110686477991133",
		Length = 1,
		CustomCastSFX = "Dark Matter Scythe Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Dark Matter Scythe - ReelIntermission" }
	},
	["Dark Matter Scythe - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://106846315932087",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Dark Matter Scythe - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://73201695035651",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Dark Matter Scythe - AnimationOverride"] = t2,
	["Dark Matter Scythe - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://121698837409469",
		Length = 2.17,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Dark Matter Scythe - ReelingIdle" }
	},
	["Dark Matter Scythe - ReelIntermission"] = t12,
	["Dark Matter Scythe - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://91028613996544",
		Length = 0.83,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Dark Matter Scythe - LoopedRodCharge" }
	},
	["Dark Matter Scythe - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://88250854196189",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Ethereal Sword - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://116654265230180",
		Length = 12.33,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Ethereal Sword - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://102875258412698",
		Length = 1.08,
		PlaybackSpeed = 1.2,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Aether Monarch - ReelIntermission" }
	},
	["Ethereal Sword - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://110866636674655",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Ethereal Sword - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://74353386311203",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Ethereal Sword - AnimationOverride"] = t2,
	["Ethereal Sword - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://134537167807676",
		Length = 0.73,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Ethereal Sword - ReelingIdle" }
	},
	["Ethereal Sword - ReelIntermission"] = t16,
	["Ethereal Sword - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://117245023195506",
		Length = 0.48,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Ethereal Sword - LoopedRodCharge" }
	},
	["Ethereal Sword - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://128015350117740",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Cupid\'s Harp - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://85435462874982",
		Length = 12.5,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Cupid\'s Harp - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://119286359658156",
		Length = 1.97,
		PlaybackSpeed = 1.1,
		CustomCastSFX = "Cupid\'s Harp Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "ReelIntermission" }
	},
	["Cupid\'s Harp - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://93542218938956",
		Length = 1.35,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Cupid\'s Harp - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://117980059371136",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Cupid\'s Harp - AnimationOverride"] = t2,
	["Cupid\'s Harp - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://88976110787345",
		Length = 1.12,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Cupid\'s Harp - ReelingIdle" }
	},
	["Cupid\'s Harp - ReelIntermission"] = t17,
	["Cupid\'s Harp - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://135163693343497",
		Length = 1.32,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Cupid\'s Harp - LoopedRodCharge" }
	},
	["Cupid\'s Harp - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://81522018863770",
		Length = 1.32,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Aurelian Bow - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://112757205434160",
		Length = 14,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Aurelian Bow - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://140314062309330",
		Length = 0.82,
		CustomCastSFX = "Aurelian Bow Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "ReelIntermission" }
	},
	["Aurelian Bow - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://89083607138153",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Aurelian Bow - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://115413643438054",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Aurelian Bow - AnimationOverride"] = t2,
	["Aurelian Bow - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://130610377568181",
		Length = 0.57,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Aurelian Bow - ReelingIdle" }
	},
	["Aurelian Bow - ReelIntermission"] = t21,
	["Aurelian Bow - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://99852728253687",
		Length = 0.48,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Aurelian Bow - LoopedRodCharge" }
	},
	["Aurelian Bow - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://76014507717255",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Void Kraken - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://140259064859736",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Void Kraken - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://91800773031236",
		Length = 1.42,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "ReelIntermission" }
	},
	["Void Kraken - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://71093335229963",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Void Kraken - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://136083891799222",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Void Kraken - AnimationOverride"] = t2,
	["Void Kraken - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://97058472206742",
		Length = 0.67,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Void Kraken - ReelingIdle" }
	},
	["Void Kraken - ReelIntermission"] = t18,
	["Void Kraken - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://123838669084263",
		Length = 0.67,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Void Kraken - LoopedRodCharge" }
	},
	["Void Kraken - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://119373786212333",
		Length = 1.67,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Celestial Scythe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://73640940565483",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Celestial Scythe - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://72684025408985",
		Length = 1.25,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "ReelIntermission" }
	},
	["Celestial Scythe - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://125568004947137",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Celestial Scythe - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://73495874837411",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Celestial Scythe - AnimationOverride"] = t2,
	["Celestial Scythe - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://74277199564109",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Celestial Scythe - ReelingIdle" }
	},
	["Celestial Scythe - ReelIntermission"] = t19,
	["Celestial Scythe - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://88265194667318",
		Length = 0.67,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Celestial Scythe - LoopedRodCharge" }
	},
	["Celestial Scythe - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://127871237502766",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Kitsune Greatsword - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://93518967822593",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Kitsune Greatsword - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://78058861691473",
		Length = 1.33,
		CustomCastSFX = "Kitsune Greatsword Custom Cast",
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Kitsune Greatsword - ReelIntermission" }
	},
	["Kitsune Greatsword - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://139914168110430",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Kitsune Greatsword - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://107242166477585",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Kitsune Greatsword - AnimationOverride"] = t2,
	["Kitsune Greatsword - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://74277199564109",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Kitsune Greatsword - ReelingIdle" }
	},
	["Kitsune Greatsword - ReelIntermission"] = t20,
	["Kitsune Greatsword - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://124057409227984",
		Length = 0.67,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Kitsune Greatsword - LoopedRodCharge" }
	},
	["Kitsune Greatsword - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://94478411484452",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Chromatic Katana - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://87355322562067",
		Length = 12.33,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Chromatic Katana - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://126097033168659",
		Length = 1.33,
		PlaybackSpeed = 1.3,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Chromatic Katana - ReelIntermission" }
	},
	["Chromatic Katana - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://75078942392746",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Chromatic Katana - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://85246394508551",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Chromatic Katana - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://84160502333903",
		Length = 0.5,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Chromatic Katana - ReelingIdle" }
	},
	["Chromatic Katana - AnimationOverride"] = t2,
	["Chromatic Katana - ReelIntermission"] = t22,
	["Chromatic Katana - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://75015195359151",
		Length = 0.48,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Chromatic Katana - LoopedRodCharge" }
	},
	["Chromatic Katana - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://85246394508551",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Crescendo Scythe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://91723046661800",
		Length = 12,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Crescendo Scythe - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://140421284729758",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Crescendo Scythe - ReelIntermission" }
	},
	["Crescendo Scythe - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://101593515409348",
		Length = 0.82,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Crescendo Scythe - ReelingHold"] = {
		Looped = true,
		AnimationId = "rbxassetid://123869733913273",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Crescendo Scythe - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://111056917953819",
		Length = 0.73,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Crescendo Scythe - ReelingIdle" }
	},
	["Crescendo Scythe - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://123869733913273",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Crescendo Scythe - AnimationOverride"] = t2,
	["Crescendo Scythe - ReelIntermission"] = t15,
	["Crescendo Scythe - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://95597987757506",
		Length = 0.65,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Crescendo Scythe - LoopedRodCharge" }
	},
	["Crescendo Scythe - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://128488550256172",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Blackhole Sword - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://110434285817259",
		Length = 13.47,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Blackhole Sword - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://120554144611008",
		Length = 0.57,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Blackhole Sword - ReelIntermission" }
	},
	["Blackhole Sword - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://88993991486322",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Blackhole Sword - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://126645853428201",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Blackhole Sword - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://80063739027478",
		Length = 0.73,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Blackhole Sword - ReelingIdle" }
	},
	["Blackhole Sword - AnimationOverride"] = t2,
	["Blackhole Sword - ReelIntermission"] = t23,
	["Blackhole Sword - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://106390588424443",
		Length = 0.48,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Blackhole Sword - LoopedRodCharge" }
	},
	["Blackhole Sword - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://76049869128172",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Eternal Flower - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://115119558523816",
		Length = 1.5,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Eternal Flower - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://105844949829012",
		PlaybackSpeed = 1.2,
		Length = 1.32,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Eternal Flower - ReelIntermission" }
	},
	["Eternal Flower - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://119567958965696",
		Length = 0.9,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Eternal Flower - ReelingIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://110020934764602",
		Length = 0.67,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Eternal Flower - ReelStart"] = {
		Looped = false,
		AnimationId = "rbxassetid://135819234295555",
		Length = 0.73,
		AnimationPriority = Enum.AnimationPriority.Action2,
		LinkedAnimations = { "Eternal Flower - ReelingIdle" }
	},
	["Eternal Flower - AnimationOverride"] = t2,
	["Eternal Flower - ReelIntermission"] = t24,
	["Eternal Flower - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://77131632555646",
		Length = 0.98,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "Eternal Flower - LoopedRodCharge" }
	},
	["Eternal Flower - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://124036821497471",
		Length = 1.33,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Holy Trident - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://83219020397849",
		Length = 6.67,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Holy Trident - RodThrow"] = {
		AnimationId = "rbxassetid://114917462794864",
		PlaybackSpeed = 1.3,
		Length = 0.966,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			FLEX_THROW_LINE = "ReelingIdle"
		}
	},
	["Holy Trident - FishCaught"] = {
		AnimationId = "rbxassetid://128167068291703",
		Length = 1.67,
		PlaybackSpeed = 1.2,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Holy Trident - ReelingIdle"] = t26,
	["Holy Trident - ReelStart"] = t26,
	["Holy Trident - ReelIntermission"] = t26,
	["Holy Trident - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://83219020397849",
		Length = 6.67,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Binary Edge - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://103714544264522",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Binary Edge - RodThrow"] = {
		AnimationId = "rbxassetid://104527781253009",
		Length = 0.88,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["Binary Edge - FishCaught"] = {
		AnimationId = "rbxassetid://109653945741202",
		Length = 0.8,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Binary Edge - ReelingIdle"] = t31,
	["Binary Edge - ReelStart"] = t31,
	["Binary Edge - ReelIntermission"] = t31,
	["Binary Edge - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://72745361965091",
		Length = 0.53,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Binary Edge - LoopedRodCharge" }
	},
	["Binary Edge - LoopedRodCharge"] = {
		Variants = true,
		Looped = true,
		AnimationId = "rbxassetid://98710992523201",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action
	},
	["The Vanquisher - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://123194574699925",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["The Vanquisher - RodThrow"] = {
		AnimationId = "rbxassetid://102380394663862",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["The Vanquisher - FishCaught"] = {
		AnimationId = "rbxassetid://93884986836266",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["The Vanquisher - ReelingIdle"] = t32,
	["The Vanquisher - ReelStart"] = t32,
	["The Vanquisher - AnimationOverride"] = t2,
	["The Vanquisher - ReelIntermission"] = t32,
	["The Vanquisher - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://92063415632933",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "The Vanquisher - LoopedRodCharge" }
	},
	["The Vanquisher - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://92063415632933",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action
	},
	["Frozen Krampus Scythe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://124265469726043",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Movement
	},
	["Frozen Krampus Scythe - RodThrow"] = {
		Looped = false,
		AnimationId = "rbxassetid://96196869100887",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Frozen Krampus Scythe - ReelingIdle" }
	},
	["Frozen Krampus Scythe - FishCaught"] = {
		Looped = false,
		AnimationId = "rbxassetid://134934781977605",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Frozen Krampus Scythe - ReelingIdle"] = t33,
	["Frozen Krampus Scythe - ReelStart"] = t33,
	["Frozen Krampus Scythe - AnimationOverride"] = t2,
	["Frozen Krampus Scythe - ReelIntermission"] = t33,
	["Frozen Krampus Scythe - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://93987679432095",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "Frozen Krampus Scythe - LoopedRodCharge" }
	},
	["Frozen Krampus Scythe - LoopedRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://107284147985305",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action
	},
	["1x1x1x1 Ban Hammer - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://81302570422307",
		Length = 1.09,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["1x1x1x1 Ban Hammer - RodThrow"] = {
		AnimationId = "rbxassetid://123133988645038",
		Length = 1.18,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["1x1x1x1 Ban Hammer - FishCaught"] = {
		AnimationId = "rbxassetid://96285280763544",
		Length = 1.18,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["1x1x1x1 Ban Hammer - ReelingIdle"] = t30,
	["1x1x1x1 Ban Hammer - ReelStart"] = t30,
	["1x1x1x1 Ban Hammer - ReelIntermission"] = t30,
	["1x1x1x1 Ban Hammer - StartRodCharge"] = {
		Looped = false,
		AnimationId = "rbxassetid://134431618143422",
		Length = 0.62,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedAnimations = { "1x1x1x1 Ban Hammer - LoopedRodCharge" }
	},
	["1x1x1x1 Ban Hammer - LoopedRodCharge"] = {
		Variants = true,
		Looped = true,
		AnimationId = "rbxassetid://128538861163297",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action
	},
	["Corruption Edge - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://93958525241489",
		Length = 2.18,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Corruption Edge - RodThrow"] = {
		AnimationId = "rbxassetid://84892442268560",
		Length = 0.62,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["Corruption Edge - FishCaught"] = {
		AnimationId = "rbxassetid://126613975718573",
		Length = 0.93,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Corruption Edge - ReelingIdle"] = t29,
	["Corruption Edge - ReelStart"] = t29,
	["Corruption Edge - ReelIntermission"] = t29,
	["Corruption Edge - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://112104009500915",
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Gingerbread Katana - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://103641983335689",
		Length = 1.06,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Gingerbread Katana - RodThrow"] = {
		AnimationId = "rbxassetid://124037675493192",
		PlaybackSpeed = 1.4,
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["Gingerbread Katana - FishCaught"] = {
		AnimationId = "rbxassetid://107940819382815",
		Length = 1.07,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Gingerbread Katana - ReelingIdle"] = t27,
	["Gingerbread Katana - ReelStart"] = t27,
	["Gingerbread Katana - ReelIntermission"] = t27,
	["Gingerbread Katana - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://115229621326605",
		Length = 1.09,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Eclipse Katana - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://103641983335689",
		Length = 1.06,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Eclipse Katana - RodThrow"] = {
		AnimationId = "rbxassetid://82600073500966",
		PlaybackSpeed = 1.4,
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["Eclipse Katana - FishCaught"] = {
		AnimationId = "rbxassetid://107940819382815",
		Length = 1.07,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Eclipse Katana - ReelingIdle"] = t27,
	["Eclipse Katana - ReelStart"] = t27,
	["Eclipse Katana - ReelIntermission"] = t27,
	["Eclipse Katana - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://115229621326605",
		Length = 1.09,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Christmas Parasol - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://79754634120924",
		Length = 6,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Christmas Parasol - RodThrow"] = {
		AnimationId = "rbxassetid://122784676901871",
		PlaybackSpeed = 1.3,
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["Christmas Parasol - FishCaught"] = {
		AnimationId = "rbxassetid://99143072029495",
		Length = 1.55,
		PlaybackSpeed = 1.2,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Christmas Parasol - ReelingIdle"] = t28,
	["Christmas Parasol - ReelStart"] = t28,
	["Christmas Parasol - ReelIntermission"] = t28,
	["Christmas Parasol - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://104188512165442",
		Length = 1.13,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	["Princess Parasol - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://79754634120924",
		Length = 6,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Princess Parasol - RodThrow"] = {
		AnimationId = "rbxassetid://108621937425425",
		PlaybackSpeed = 1.3,
		Length = 1.08,
		AnimationPriority = Enum.AnimationPriority.Action,
		LinkedMarkers = {
			Throw = "ReelingIdle"
		}
	},
	["Princess Parasol - FishCaught"] = {
		AnimationId = "rbxassetid://99143072029495",
		Length = 1.55,
		PlaybackSpeed = 1.2,
		AnimationPriority = Enum.AnimationPriority.Action4
	},
	["Princess Parasol - ReelingIdle"] = t28,
	["Princess Parasol - ReelStart"] = t28,
	["Princess Parasol - ReelIntermission"] = t28,
	["Princess Parasol - StartRodCharge"] = {
		Looped = true,
		AnimationId = "rbxassetid://104188512165442",
		Length = 1.13,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	FishingFailure = {
		Default = true,
		AnimationId = "rbxassetid://78824620552051",
		PlaybackSpeed = 1.2,
		Length = 1.8,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	StartRodCharge = {
		Default = true,
		Variants = true,
		AnimationId = "rbxassetid://139622307103608",
		Length = 2.683,
		AnimationPriority = Enum.AnimationPriority.Idle,
		LinkedAnimations = { "LoopedRodCharge" }
	},
	LoopedRodCharge = {
		Default = true,
		Variants = true,
		Looped = true,
		AnimationId = "rbxassetid://137429009359442",
		Length = 1.166,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	NPC_Emote = {
		Looped = true,
		AnimationId = "rbxassetid://113892097123931",
		Length = 15.5,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	NPC_Sit = {
		Looped = true,
		AnimationId = "rbxassetid://119383377956726",
		Length = 7.5,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	NPC_Leaning = {
		Looped = true,
		AnimationId = "rbxassetid://100479761518539",
		Length = 5,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	NPC_Sleep = {
		Looped = true,
		AnimationId = "rbxassetid://91507769462696",
		Length = 12.5,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	NPC_Chill = {
		Looped = true,
		AnimationId = "rbxassetid://82584695013092",
		Length = 8.33,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	NPC_Scared = {
		Looped = true,
		AnimationId = "rbxassetid://135510090299807",
		Length = 4,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	NPC_Headless = {
		Looped = true,
		AnimationId = "rbxassetid://138312424622026",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	NPC_Witch = {
		Looped = true,
		AnimationId = "rbxassetid://80495385390558",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	HoldFish3 = {
		Default = true,
		Looped = true,
		AnimationId = "rbxassetid://126738217543503",
		Length = 0.533,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	HoldFish2 = {
		Default = true,
		Looped = true,
		AnimationId = "rbxassetid://75033370620947",
		Length = 0.55,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	HoldFish1 = {
		Default = true,
		Looped = true,
		AnimationId = "rbxassetid://131771776568234",
		Length = 0.366,
		AnimationPriority = Enum.AnimationPriority.Action2
	},
	["Undead Guitar - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://130474623877752",
		Length = 7.5,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Royal Spider - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://79263851052023",
		Length = 4.17,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Trick O\' Treat - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://105569745192317",
		Length = 8.33,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Reaver Scythe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://79066316609985",
		Length = 11.67,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Spirit Staff - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://77452908864699",
		Length = 13.33,
		AnimationPriority = Enum.AnimationPriority.Core
	},
	["Divine Blade - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://82781088583962",
		Length = 10.83
	},
	["Heartfelt Blade - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://111118151202469",
		Length = 1.33
	},
	["Candy Cane Trident - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://131643088615283",
		Length = 1
	},
	["Ornament Axe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://90021589040653",
		Length = 1
	},
	["Gingerbread Sword - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://106017647759827",
		Length = 1
	},
	["Xmas Tree Rod - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://97171752999251",
		Length = 1
	},
	["Pink Present Lance - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://101986838283328",
		Length = 1
	},
	["Wings of Everlove - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://125409322606200",
		Length = 12
	},
	["Voidpunk Axe - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://82305386881445",
		Length = 11.67
	},
	["Crimson Rose - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://99781097640024",
		Length = 11.67
	},
	["Heartbreaker Surge - EquipIdle"] = {
		Looped = true,
		AnimationId = "rbxassetid://105432325608290",
		Length = 11.67
	},
	PickaxeIdle = {
		Looped = true,
		AnimationId = "rbxassetid://132127568585411",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Idle
	},
	PickaxeMining = {
		Looped = false,
		AnimationId = "rbxassetid://127791492757405",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action
	},
	["LavaSurfboard-Surf"] = {
		Looped = true,
		AnimationId = "rbxassetid://82189048200405",
		Length = 1,
		AnimationPriority = Enum.AnimationPriority.Action
	}
}
local function CopyAnimation(p1, p2, p3) --[[ CopyAnimation | Line: 3070 | Upvalues: t36 (copy), TableUtil (copy) ]]
	local v1 = t36[p3]
	if not v1 then
		return
	end
	local v2 = TableUtil.Copy(v1, true)
	if v2.LinkedAnimations then
		v2.LinkedAnimations[1] = v2.LinkedAnimations[1]:gsub(p2, p1)
	end
	if v2.CustomCastSFX then
		v2.CustomCastSFX = v2.CustomCastSFX:gsub(p2, p1)
	end
	if v2.LinkedMarkers then
		for k, v in pairs(v2.LinkedMarkers) do
			v2.LinkedMarkers[k] = ("%* - %*"):format(p1, v)
		end
	end
	return v2
end
local function Copy(p1, p2, p3) --[[ Copy | Line: 3095 | Upvalues: t (copy), CopyAnimation (copy), t36 (copy), TableUtil (copy), t2 (copy) ]]
	for i, v in ipairs(t) do
		local v1 = ("%* - %*"):format(p1, v)
		local v2 = CopyAnimation(p1, p2, (("%* - %*"):format(p2, v)))
		if v2 then
			t36[v1] = v2
		end
	end
	if not p3 then
		return
	end
	t36[("%* - AnimationOverride"):format(p1)] = TableUtil.Copy(t2, true)
end
Copy("Fallen Staff", "Divine Staff", true)
Copy("Energy Blaster", "Oceanic Harpoon", true)
Copy("Blossom Guitar", "Kitty Guitar", true)
if v1 then
	for v2, v3 in t36 do
		if not v3.Disabled then
			if not v3.Length then
				warn((("Error! No length provided for animation: %*"):format(v2)))
			end
			if v3.AnimationId and string.len(v3.AnimationId) ~= 0 then
				local Animation = Instance.new("Animation")
				Animation.Name = v2
				Animation.AnimationId = v3.AnimationId
				Animation.Parent = script
				t36[v2].Animation = Animation
			end
		end
	end
else
	for v4, v5 in t36 do
		if not v5.Disabled and v5.AnimationId and string.len(v5.AnimationId) ~= 0 then
			local v6 = script:WaitForChild(v4)
			if v6 then
				t36[v4].Animation = v6
			end
		end
	end
end
return t36