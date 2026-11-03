-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ValidUsers = require(ReplicatedStorage.Shared:WaitForChild("ValidUsers"))
return {
	{
		Tag = "[Owner]",
		PlayerAttribute = "Dev",
		TagColor = Color3.fromRGB(255, 25, 25),
		PlayerCondition = function(p1) --[[ PlayerCondition | Line: 44 | Upvalues: ValidUsers (copy) ]]
			return table.find(ValidUsers.Owners, p1.UserId) and true or false
		end
	},
	{
		Tag = "[Duck Developer]",
		PlayerAttribute = "Dev",
		TagColor = Color3.fromRGB(251, 255, 17),
		PlayerCondition = function(p1) --[[ PlayerCondition | Line: 53 ]]
			return p1.UserId == 33372493
		end
	},
	{
		Tag = "[Developer]",
		PlayerAttribute = "Dev",
		TagColor = Color3.fromRGB(251, 255, 17),
		PlayerCondition = function(p1) --[[ PlayerCondition | Line: 62 | Upvalues: ValidUsers (copy) ]]
			return table.find(ValidUsers.Developers, p1.UserId) and true or false
		end
	},
	{
		Tag = "[Contributor]",
		PlayerAttribute = "Contributor",
		TagColor = Color3.fromRGB(178, 70, 255)
	},
	{
		Tag = "[Content]",
		PlayerAttribute = "ContentCreator",
		TagColor = Color3.fromRGB(255, 153, 223)
	},
	{
		Tag = "[Senior Staff]",
		PlayerAttribute = "SeniorStaff",
		TagColor = Color3.fromRGB(255, 124, 17)
	},
	{
		Tag = "[Staff]",
		PlayerAttribute = "Staff",
		TagColor = Color3.fromRGB(17, 255, 112)
	},
	{
		Tag = "[Tester]",
		PlayerAttribute = "Tester",
		TagColor = Color3.fromRGB(155, 255, 183)
	},
	{
		Tag = "[VIP]",
		PlayerAttribute = "VIP",
		TagColor = Color3.fromRGB(255, 205, 26)
	}
}