-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local function transform(p1) --[[ transform | Line: 42 ]]
	if p1 < 0.04045 then
		return p1 / 12.92
	else
		return ((p1 + 0.055) / 1.055) ^ 2.4
	end
end
local function inverse(p1) --[[ inverse | Line: 52 ]]
	if p1 < 0.0031308 then
		return p1 * 12.92
	else
		return p1 ^ 0.4166666666666667 * 1.055 - 0.055
	end
end
function t.fromLinear(p1) --[[ fromLinear | Line: 61 ]]
	local v1 = Color3.new
	local R = p1.R
	local G = p1.G
	local B = p1.B
	return v1(if R < 0.0031308 then R * 12.92 else R ^ 0.4166666666666667 * 1.055 - 0.055, if G < 0.0031308 then G * 12.92 else G ^ 0.4166666666666667 * 1.055 - 0.055, if B < 0.0031308 then B * 12.92 else B ^ 0.4166666666666667 * 1.055 - 0.055)
end
function t.toLinear(p1) --[[ toLinear | Line: 67 ]]
	local v1 = Color3.new
	local R = p1.R
	local G = p1.G
	local B = p1.B
	return v1(if R < 0.04045 then R / 12.92 else ((R + 0.055) / 1.055) ^ 2.4, if G < 0.04045 then G / 12.92 else ((G + 0.055) / 1.055) ^ 2.4, if B < 0.04045 then B / 12.92 else ((B + 0.055) / 1.055) ^ 2.4)
end
return t