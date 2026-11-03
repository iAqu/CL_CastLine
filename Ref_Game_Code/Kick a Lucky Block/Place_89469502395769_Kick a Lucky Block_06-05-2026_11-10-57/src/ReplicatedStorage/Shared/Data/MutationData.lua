-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MaterialService = game:GetService("MaterialService")
return {
	ValidMutations = {
		"Golden",
		"Diamond",
		"Plasma",
		"Radioactive",
		"Molten",
		"Void",
		"Shadow",
		"Electrified",
		"Rainbow",
		"Virus"
	},
	EventMutations = {
		Void = 20,
		Virus = 10
	},
	Mutations = {
		{
			Name = "Golden",
			Chance = 10
		},
		{
			Name = "Diamond",
			Chance = 4
		},
		{
			Name = "Plasma",
			Chance = 3
		},
		{
			Name = "Molten",
			Chance = 0.8
		},
		{
			Name = "Radioactive",
			Chance = 0.3
		},
		{
			Name = "Shadow",
			Chance = 0.05
		},
		{
			Name = "Electrified",
			Chance = 0.02
		},
		{
			Name = "Rainbow",
			Chance = 0.005
		}
	},
	SurfaceApearances = {
		Golden = Color3.fromRGB(255, 200, 0),
		Diamond = Color3.fromRGB(0, 229, 255),
		Plasma = Color3.fromRGB(255, 0, 212),
		Molten = Color3.fromRGB(255, 140, 0),
		Radioactive = Color3.fromRGB(153, 255, 0),
		Void = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(67, 67, 67),
		Electrified = Color3.fromRGB(7, 111, 163),
		Rainbow = Color3.fromRGB(255, 255, 255),
		Virus = Color3.fromRGB(0, 0, 0)
	},
	Buffs = {
		Golden = {
			Value = 1.5
		},
		Diamond = {
			Value = 2
		},
		Plasma = {
			Value = 4
		},
		Molten = {
			Value = 6
		},
		Radioactive = {
			Value = 8
		},
		Shadow = {
			Value = 12
		},
		Electrified = {
			Value = 16
		},
		Rainbow = {
			Value = 30
		},
		Void = {
			Value = 10
		},
		Virus = {
			Value = 10
		}
	},
	Properties = {
		Diamond = {
			Color = Color3.fromRGB(4, 175, 236),
			Material = Enum.Material.Glacier,
			MaterialVariant = MaterialService["Metallic-Hammered"].Name
		},
		Golden = {
			Color = Color3.fromRGB(239, 184, 56),
			Material = Enum.Material.Glacier,
			MaterialVariant = MaterialService["Metallic-Hammered"].Name
		},
		Molten = {
			Color = Color3.fromRGB(170, 87, 32),
			Material = Enum.Material.Neon
		},
		Plasma = {
			Color = Color3.fromRGB(156, 45, 121),
			Material = Enum.Material.Neon
		},
		Radioactive = {
			Color = Color3.fromRGB(115, 163, 38),
			Material = Enum.Material.Neon
		},
		Void = {
			Color = Color3.fromRGB(0, 0, 0),
			Material = Enum.Material.Neon
		},
		Rainbow = {
			Color = Color3.fromRGB(255, 255, 255),
			Material = Enum.Material.Neon
		},
		Shadow = {
			Color = Color3.fromRGB(67, 67, 67),
			Material = Enum.Material.Neon
		},
		Electrified = {
			Color = Color3.fromRGB(7, 111, 163),
			Material = Enum.Material.Neon
		},
		Virus = {
			Color = Color3.fromRGB(0, 0, 0),
			Material = Enum.Material.Glacier
		}
	},
	SpecialFunctions = {
		Rainbow = function(p1) --[[ Line: 145 ]]
			for i, v in ipairs(p1:GetDescendants()) do
				if v:IsA("BasePart") and not v:HasTag("_CP") then
					v:AddTag("ColorRainbow")
				end
			end
			return function() --[[ Line: 152 | Upvalues: p1 (copy) ]]
				for i, v in ipairs(p1:GetDescendants()) do
					if v:IsA("BasePart") and v:HasTag("ColorRainbow") then
						v:RemoveTag("ColorRainbow")
					end
				end
			end
		end
	},
	Index = {
		Diamond = {
			Color = Color3.fromRGB(24, 236, 255)
		},
		Golden = {
			Color = Color3.fromRGB(255, 197, 21)
		},
		Molten = {
			Color = Color3.fromRGB(255, 99, 26)
		},
		Plasma = {
			Color = Color3.fromRGB(255, 48, 255)
		},
		Radioactive = {
			Color = Color3.fromRGB(78, 255, 75)
		},
		Void = {
			Color = Color3.fromRGB(186, 12, 255)
		},
		Virus = {
			Color = Color3.fromRGB(22, 255, 5)
		},
		Electrified = {
			Color = Color3.fromRGB(0, 229, 255)
		},
		Rainbow = {
			Color = Color3.fromRGB(255, 255, 255)
		},
		Shadow = {
			Color = Color3.fromRGB(52, 52, 52)
		}
	},
	LabelFunctions = {
		Rainbow = function(p1) --[[ Line: 196 | Upvalues: ReplicatedStorage (copy) ]]
			p1.TextColor3 = Color3.new(255/255, 255/255, 255/255)
			ReplicatedStorage.Objects.UI.RarityGradients.rainbow:Clone().Parent = p1
		end
	}
}