-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	toMS = function(p1, p2) --[[ toMS | Line: 4 ]]
		if if p2 == nil then true else p2 then
			return ("%02i:%02i"):format(p1 / 60 % 60, p1 % 60)
		else
			return ("%02iM %02iS"):format(p1 / 60 % 60, p1 % 60)
		end
	end,
	toHMS = function(p1, p2) --[[ toHMS | Line: 14 ]]
		if p2 then
			return ("%02ih %02im %02is"):format(p1 / 3600, p1 / 60 % 60, p1 % 60)
		else
			return ("%02i:%02i:%02i"):format(p1 / 3600, p1 / 60 % 60, p1 % 60)
		end
	end,
	toDHMS = function(p1, p2) --[[ toDHMS | Line: 23 ]]
		if p2 then
			return ("%id %ih %im %is"):format(p1 / 86400, p1 / 3600 % 24, p1 / 60 % 60, p1 % 60)
		else
			return ("%02i:%02i:%02i:%02i"):format(p1 / 86400, p1 / 3600 % 24, p1 / 60 % 60, p1 % 60)
		end
	end,
	toWDH = function(p1) --[[ toWDH | Line: 32 ]]
		return ("%02iw %02id %02ih"):format(p1 / 604800, p1 / 86400 % 7, p1 / 3600 % 24)
	end
}
local t2 = {
	"k",
	"m",
	"b",
	"t",
	"qd",
	"qn",
	"sx",
	"sp",
	"o",
	"n",
	"de",
	"ud",
	"dd",
	"td",
	"qtd",
	"qnd",
	"sxd",
	"spd",
	"od",
	"nd",
	"vg",
	"uv",
	"dv",
	"tv",
	"qdv",
	"qnv",
	"sxv",
	"spv",
	"ov",
	"nv",
	"tt",
	"ut",
	"dt",
	"g",
	"gp"
}
function t.comma(p1) --[[ comma | Line: 38 ]]
	local v1 = p1
	local v2
	while true do
		local v3
		v2, v3 = string.gsub(v1, "^(-?%d+)(%d%d%d)", "%1,%2")
		if v3 == 0 then
			break
		end
		v1 = v2
	end
	return v2
end
function t.abbr(p1) --[[ abbr | Line: 50 | Upvalues: t2 (copy) ]]
	if typeof(p1) == "string" then
		return p1
	end
	if p1 == "0" or p1 == 0 then
		return 0
	end
	local v2 = math.abs((tonumber(p1)))
	local v6 = math.min(math.floor(math.log10(v2) / 3), #t2)
	local v7 = tonumber(v6) > 0 and t2[v6] or ""
	if string.len(v7) > 1 then
		v7 = string.sub(v7, 1, 1):upper() .. string.sub(v7, 2):lower()
	elseif string.len(v7) == 1 then
		v7 = v7:upper()
	end
	local v9 = tostring(v2 / 10 ^ (v6 * 3))
	local v10 = (v9:match("%d+.%d") or v9) .. v7
	if p1 < 0 then
		v10 = "-" .. v10
	end
	if v10:sub(#v10 - 1, #v10) == ".0" then
		v10 = v10:sub(1, #v10 - 2)
	end
	return v10
end
return t