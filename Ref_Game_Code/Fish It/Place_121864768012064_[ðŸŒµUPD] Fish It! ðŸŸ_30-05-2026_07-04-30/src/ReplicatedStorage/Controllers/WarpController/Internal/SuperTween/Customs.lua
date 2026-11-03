-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local DataTypes = require(script.Parent.DataTypes)
return {
	Pivot = {
		Whitelist = { "PVInstance" },
		Set = function(p1, p2, p3, p4) --[[ Set | Line: 7 | Upvalues: DataTypes (copy) ]]
			p1:PivotTo((DataTypes.CFrame(p2, p3, p4)))
		end,
		Get = function(p1) --[[ Get | Line: 12 ]]
			return p1:GetPivot()
		end
	},
	Scale = {
		Whitelist = { "Model" },
		Set = function(p1, p2, p3, p4) --[[ Set | Line: 19 | Upvalues: DataTypes (copy) ]]
			p1:ScaleTo((DataTypes.number(p2, p3, p4)))
		end,
		Get = function(p1) --[[ Get | Line: 24 ]]
			return p1:GetScale()
		end
	}
}