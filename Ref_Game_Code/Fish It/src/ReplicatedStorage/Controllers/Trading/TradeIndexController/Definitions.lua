-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
return {
	BUTTON_GRADIENTS = {
		Selected = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 211, 34)), ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255, 231, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 126, 34)) }),
		Default = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(37, 197, 255)), ColorSequenceKeypoint.new(0.325, Color3.fromRGB(29, 225, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 104, 255)) }),
		Default2 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 93, 98)), ColorSequenceKeypoint.new(0.325, Color3.fromRGB(93, 99, 104)), ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 50, 53)) })
	},
	SORT_OPTIONS = { "Default", "Alphabetical", "RAP" },
	SORT_FUNCS = {
		Default = function(p1) --[[ Default | Line: 25 ]]
			return function(p12, p2) --[[ Line: 26 | Upvalues: p1 (copy) ]]
				if p12.LayoutOrder == p2.LayoutOrder then
					if p1 then
						return p12.Item.Name < p2.Item.Name
					else
						return p12.Item.Name > p2.Item.Name
					end
				elseif p1 then
					return p12.LayoutOrder > p2.LayoutOrder
				else
					return p12.LayoutOrder < p2.LayoutOrder
				end
			end
		end,
		Alphabetical = function(p1) --[[ Alphabetical | Line: 42 ]]
			return function(p12, p2) --[[ Line: 43 | Upvalues: p1 (copy) ]]
				if p1 then
					return p12.Item.Name > p2.Item.Name
				else
					return p12.Item.Name < p2.Item.Name
				end
			end
		end,
		RAP = function(p1) --[[ RAP | Line: 51 | Upvalues: RAPController (copy) ]]
			return function(p12, p2) --[[ Line: 52 | Upvalues: RAPController (ref), p1 (copy) ]]
				local v1 = RAPController:GetRAP(p12.Item.Type, p12.Item.Id) or 0
				local v2 = RAPController:GetRAP(p2.Item.Type, p2.Item.Id) or 0
				if v1 == v2 then
					if p1 then
						return p12.Item.Name < p2.Item.Name
					else
						return p12.Item.Name > p2.Item.Name
					end
				elseif p1 then
					return v1 < v2
				else
					return v2 < v1
				end
			end
		end
	},
	ABBR_TYPE = {
		["Fishing Rods"] = "Rods"
	}
}