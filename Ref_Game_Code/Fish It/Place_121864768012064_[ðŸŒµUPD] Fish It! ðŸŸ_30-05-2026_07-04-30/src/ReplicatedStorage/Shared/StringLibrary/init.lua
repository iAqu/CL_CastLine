-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = { "a", "e", "i", "o", "u" }
local t2 = {
	"K",
	"M",
	"B",
	"T",
	"QD",
	"QN",
	"SX",
	"SP",
	"O",
	"N",
	"DE",
	"UD",
	"DD",
	"TDD",
	"QDD",
	"QND",
	"SXD",
	"SPD",
	"OCD",
	"NVD"
}
local t3 = {
	CountryCodeToEmoji = function(p1) --[[ CountryCodeToEmoji | Line: 18 ]]
		if string.len(p1) == 0 or p1:find("?") then
			return "??"
		else
			local v1 = p1:upper()
			local v2 = v1:sub(1, 1)
			local v3 = v1:sub(2, 2)
			return utf8.char(127462 + (v2:byte() - 65)) .. utf8.char(127462 + (v3:byte() - 65))
		end
	end,
	ContainsVowel = function(p1) --[[ ContainsVowel | Line: 34 | Upvalues: t (copy) ]]
		return table.find(t, (p1:sub(1, 1):lower())) ~= nil
	end
}
function t3.AddWeight(p1, p2) --[[ AddWeight | Line: 42 | Upvalues: t3 (copy) ]]
	local v1 = math.round(p2 * 100) / 100
	if v1 <= 999 then
		return ("%*kg"):format(v1)
	else
		return ("%* kg"):format((t3:Shorten(v1)))
	end
end
function t3.Shorten(p1, p2) --[[ Shorten | Line: 52 | Upvalues: t3 (copy), t2 (copy) ]]
	if p2 ~= p2 then
		return "NaN"
	end
	if p2 == 0 then
		return "0"
	end
	if math.abs(p2) < 1000 then
		return t3:AddCommas(p2)
	end
	local v1 = if p2 == math.abs(p2) then "" else "-"
	math.abs((math.floor(p2)))
	local v7 = math.min(bit32.bor(math.log10((math.abs(p2))) / 3, 0), #t2)
	local v8 = p2 / 10 ^ (v7 * 3)
	local v9 = if math.floor(v8) == v8 then 0 else 2
	if t2[v7] then
		return string.format(("%*%%.%*f%%s"):format(v1, v9), v8, t2[v7])
	else
		return tostring(p2)
	end
end
function t3.AddCommas(p1, p2) --[[ AddCommas | Line: 83 ]]
	local v1 = tostring(p2)
	local v2
	while true do
		local v3
		v2, v3 = string.gsub(v1, "^(-?%d+)(%d%d%d)", "%1,%2")
		k = v3
		if k == 0 then
			break
		end
		v1 = v2
	end
	return v2
end
return t3