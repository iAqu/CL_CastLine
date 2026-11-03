-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	DECIMALPOINTS = 1,
	AALENGTHMAX = 3
}
local t2 = {}
t2.__index = t2
local Values = script.Values
local Suffixes = require(Values.Suffixes)
local FullNames = require(Values.FullNames)
local function fixNumber(p1, p2) --[[ fixNumber | Line: 56 ]]
	local v1 = tonumber(p1)
	local v2 = if p2 % 1 > 0 then v1 * 10 ^ (p2 % 1) else v1
	local v3 = math.floor(p2)
	local v4 = math.sign(v2)
	local v5 = nil
	if v2 == 0 or v3 == 0 and v2 < 1 then
		return v2, 0
	elseif v3 == 0 and v2 == 0 then
		return 0, 0
	else
		local sum
		if v2 < v4 * 1 then
			local v6 = math.abs(v2)
			local v9 = math.abs((math.floor((math.log10(v6)))))
			if v9 == 0 then
				v5 = v6
				sum = v3
			else
				v5 = v6 * 10 ^ v9
				sum = v3 - v9
			end
		elseif v4 * 1 <= v2 then
			local v10 = math.abs(v2)
			if math.floor((math.log10(v10))) == 0 then
				v5 = v10
				sum = v3
			else
				sum = v3 + math.floor((math.log10(v10)))
				v5 = v10 / 10 ^ math.floor((math.log10(v10)))
			end
		else
			sum = v3
		end
		if v5 == nil then
			return (0 / 0), (0 / 0)
		else
			if sum < 0 then
				local v14 = math.abs(sum)
				v5 = v5 / 10 ^ v14
				sum = sum + v14
			end
			return v5 * v4, sum
		end
	end
end
local function convert(p1) --[[ convert | Line: 104 ]]
	if typeof(p1) ~= "number" then
		error("Type is not \"number\".")
	end
	local v1 = math.sign(p1)
	local v2 = math.abs(p1)
	local v3 = tostring(v2)
	local v4
	if string.match(v3, "%.") and not string.match(v3, "e") then
		local v5 = string.split(v3, ".")
		v3 = v5[1] .. "" .. v5[2]
		v4 = #v5[2]
	else
		v4 = 0
	end
	local v6 = #v3 - 1 - v4
	local v7
	if string.match(v3, "e") then
		if string.match(v3, "+") then
			v6 = v3:split("+")[2]
		elseif string.match(v3, "-") then
			v6 = v3:split("e")[2]
		end
		v7 = v3:split("e")[1]
	elseif string.match(v3, "inf") then
		v7 = "inf"
		v6 = "inf"
	elseif string.match(v3, "nan") then
		v7 = "nan"
		v6 = "nan"
	elseif #v3 == 1 then
		v7 = v2
	else
		local v8 = v3:sub(1, 1)
		local v9 = v3:sub(2)
		v7 = if tonumber(v9) > 0 then v8 .. "." .. v9 else v8
	end
	return v7 * v1, v6
end
local function checkNumber(p1) --[[ checkNumber | Line: 156 | Upvalues: t (copy) ]]
	if typeof(p1) ~= "number" and (typeof(p1) ~= "string" and typeof(p1) ~= "table") then
		error("\"" .. typeof(p1) .. "\" is not a valid type. Please only use \"number\", \"string\", or constructed numbers.")
	end
	local v1 = t.new(p1)
	if v1.first == nil and v1.second == nil then
		error("\"string\" is not correctly formatted. Correctly formatted strings look like \"1,0\".")
	end
	return v1
end
function t2.__add(p1, p2) --[[ __add | Line: 171 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	local v3, v4 = fixNumber(v1.first, v1.second)
	local v5, v6 = fixNumber(v2.first, v2.second)
	if math.abs(v4 - v6) > 16 then
		if math.max(v4, v6) == v4 then
			return t.new({ v3, v4 })
		else
			return t.new({ v5, v6 })
		end
	else
		local v7, v8 = fixNumber(v3 + v5 * 10 ^ (-(v4 - v6)), v4)
		return t.new({ v7, v8 })
	end
end
function t2.__sub(p1, p2) --[[ __sub | Line: 192 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	local v3, v4 = fixNumber(v1.first, v1.second)
	local v5, v6 = fixNumber(v2.first, v2.second)
	if math.abs(v4 - v6) > 16 then
		if math.max(v4, v6) == v4 then
			return t.new({ v3, v4 })
		else
			return t.new({ v5, v6 })
		end
	else
		local v7, v8 = fixNumber(v3 - v5 * 10 ^ (-(v4 - v6)), v4)
		return t.new({ v7, v8 })
	end
end
function t2.__mul(p1, p2) --[[ __mul | Line: 213 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	local v3, v4 = fixNumber(v1.first, v1.second)
	local v5, v6 = fixNumber(v2.first, v2.second)
	local v7, v8 = fixNumber(v3 * v5, v4 + v6)
	return t.new({ v7, v8 })
end
function t2.__div(p1, p2) --[[ __div | Line: 224 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	local v3, v4 = fixNumber(v1.first, v1.second)
	local v5, v6 = fixNumber(v2.first, v2.second)
	local v7, v8 = fixNumber(v3 / v5, v4 - v6)
	return t.new({ v7, v8 })
end
function t2.__pow(p1, p2) --[[ __pow | Line: 235 | Upvalues: checkNumber (copy), t (copy), fixNumber (copy) ]]
	local v1 = checkNumber(p1)
	if typeof(p2) ~= "number" then
		p2 = p2:Reverse()
	end
	if p2 == (1 / 0) or (p2 ~= p2 or typeof(p2) ~= "number") then
		local v3
		v3 = v1
		error("\'" .. p2 .. "\' is not a valid power. If power is \'inf\' you must keep it below 10^308")
	end
	local v4 = t.sign(v1)
	local v5 = v1 * v4
	local v6, v7 = fixNumber(v5.first, v5.second)
	if v6 ^ p2 == (1 / 0) or v7 * p2 == (1 / 0) then
		if typeof(p2) ~= "number" then
			p2 = p2:Reverse()
		end
		local v9 = t.new(1)
		local v10, v11
		if p2 > 1 then
			while p2 > 0 do
				if if bit32.band(p2, 1) == 1 then true else false then
					v9 = v9 * v5
				end
				p2, v5 = bit32.rshift(p2, 1), v5 * v5
			end
			local v14, v15 = fixNumber(v9.first, v9.second)
			v10 = v14
			v11 = v15
		elseif p2 == 0 then
			v10 = 1
			v11 = 0
		else
			v10 = v6
			v11 = v7
		end
		return t.new({ v10, v11 })
	else
		return t.new({ v6 ^ p2, v7 * p2 }) * v4
	end
end
function t2.__mod(p1, p2) --[[ __mod | Line: 285 | Upvalues: checkNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	local v3, v4, v5
	if t.sign(v1) == 1 then
		v3, v4, v5 = v2, t.floor(v1 / v2), v1
	else
		v3, v4, v5 = v2, t.round(v1 / v2), v1
	end
	return v5 - v3 * v4
end
function t2.__eq(p1, p2) --[[ __eq | Line: 302 | Upvalues: checkNumber (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	if v1.first == "nan" or v2.first == "nan" then
		return false
	else
		return if v1.first == v2.first then v1.second == v2.second else false
	end
end
function t2.__lt(p1, p2) --[[ __lt | Line: 312 | Upvalues: checkNumber (copy), fixNumber (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	local v3, v4 = fixNumber(v1.first, v1.second)
	local v5, v6 = fixNumber(v2.first, v2.second)
	local v7 = v4 * math.sign(v3)
	local v8 = v6 * math.sign(v6)
	if v7 == v8 then
		return v3 < v5
	else
		return v7 < v8
	end
end
function t2.__le(p1, p2) --[[ __le | Line: 327 | Upvalues: checkNumber (copy), fixNumber (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	local v3, v4 = fixNumber(v1.first, v1.second)
	local v5, v6 = fixNumber(v2.first, v2.second)
	local v7 = v4 * math.sign(v3)
	local v8 = v6 * math.sign(v6)
	if v7 == v8 then
		return v3 <= v5
	else
		return v7 < v8
	end
end
function t2.__unm(p1) --[[ __unm | Line: 342 | Upvalues: checkNumber (copy) ]]
	return checkNumber(p1) * -1
end
function t2.__tostring(p1) --[[ __tostring | Line: 348 ]]
	return p1:GetSuffix(true)
end
function t2.__concat(p1, p2) --[[ __concat | Line: 352 ]]
	return tostring(p1) .. tostring(p2)
end
function t.new(p1) --[[ new | Line: 380 | Upvalues: t2 (copy), fixNumber (copy), convert (copy) ]]
	local v1, v2
	if typeof(p1) == "table" then
		if p1.first == nil or p1.second == nil then
			v1 = p1[1]
			v2 = p1[2]
		elseif getmetatable(p1) == t2 then
			return p1
		else
			return setmetatable(p1, t2)
		end
	elseif typeof(p1) == "string" then
		if tonumber(p1) == nil then
			local v4, v5 = fixNumber(table.unpack(p1:split(",")))
			v1 = v4
			v2 = v5
		else
			local v6, v7 = convert((tonumber(p1)))
			v1 = v6
			v2 = v7
		end
	elseif typeof(p1) == "number" then
		if p1 == (1 / 0) then
			error("INF number is not allowed. Please use \"string\" or \"table\" instead of \"number\" to go above INF.")
		end
		local v8, v9 = convert(p1)
		v1 = v8
		v2 = v9
	else
		error("\"" .. typeof(p1) .. "\" is not a valid type. Please only use \"number\", \"string\", \"table\", or constructed numbers.")
	end
	return setmetatable({
		first = v1,
		second = v2
	}, t2)
end
function t2.SetValue(p1, p2, p3) --[[ SetValue | Line: 436 | Upvalues: fixNumber (copy) ]]
	if type(p2) ~= "number" and type(p3) ~= "number" then
		error("Both parameters of SetValue must be \"number\"")
	end
	local v1, v2 = fixNumber(p2, p3)
	p1.first = v1
	p1.second = v2
end
function t2.Reverse(p1) --[[ Reverse | Line: 460 | Upvalues: fixNumber (copy) ]]
	local v1, v2 = fixNumber(p1.first, p1.second)
	return v1 * 10 ^ v2
end
function t2.GetSuffix(p1, p2) --[[ GetSuffix | Line: 484 | Upvalues: fixNumber (copy), t (copy), Suffixes (copy), FullNames (copy) ]]
	if p2 == nil then
		p2 = true
	end
	local v1, v2 = fixNumber(p1.first, p1.second)
	if v2 < 3 then
		local v3 = tostring(p1:Reverse())
		local v4 = if math.sign(v1) == -1 then 3 else 2
		local v5
		if math.abs(v1) >= 1 then
			if t.DECIMALPOINTS > 0 then
				local v6 = v3:sub(1, v2 + v4 + t.DECIMALPOINTS)
				local v7 = v6:split(".")[2]
				if v7 == nil then
					return v6
				end
				if tonumber(v7) == 0 then
					return v6:split(".")[1]
				end
				if v7 == string.rep(9, t.DECIMALPOINTS) then
					return tonumber(v6:split(".")[1]) + 1
				end
				v5 = v6
			else
				return v3:split(".")[1]
			end
		else
			if math.abs(v1) <= 0.01 then
				return "0"
			end
			local v9 = v3:sub(1, v2 + v4 + t.DECIMALPOINTS)
			v5 = if v9:split(".")[2] == string.rep(9, t.DECIMALPOINTS) then tonumber(v9:split(".")[1]) + 1 else v9
		end
		return v5
	else
		local v11 = math.floor(v2 / 3)
		local v13 = math.floor(v1 * 10 ^ (v2 % 3) * 10 ^ t.DECIMALPOINTS) / 10 ^ t.DECIMALPOINTS
		local v14 = if p2 then Suffixes[v11] else FullNames[v11] and " " .. FullNames[v11] or nil
		if v11 > 0 and v14 == nil then
			v13 = p1:ScientificNotation(p2)
		elseif v11 > 0 then
			return v13 .. v14
		end
		return v13
	end
end
function t2.ScientificNotation(p1, p2, p3) --[[ ScientificNotation | Line: 571 | Upvalues: fixNumber (copy), t (copy) ]]
	local v1, v2 = fixNumber(p1.first, p1.second)
	local v3 = tostring(v1)
	local v4 = tostring(v2)
	local v6 = math.floor(v3 * 10 ^ t.DECIMALPOINTS) / 10 ^ t.DECIMALPOINTS
	return v6 .. "e+" .. if tonumber(v4) > 1000000 and p3 ~= false then if p2 == true or p2 == nil then t.new((tonumber(v4))):GetSuffix(true) else t.new((tonumber(v4))):ScientificNotation(nil, false) else v4
end
function t2.LogarithmNotation(p1) --[[ LogarithmNotation | Line: 601 | Upvalues: fixNumber (copy), t (copy) ]]
	local v1, v2 = fixNumber(p1.first, p1.second)
	local v3 = tostring(v1)
	local v4 = tostring(v2)
	if math.floor(v4 / 3) == 0 then
		return math.floor(v3 * 10 ^ (v4 % 3) * 10 ^ t.DECIMALPOINTS) / 10 ^ t.DECIMALPOINTS
	else
		local v7 = tostring((math.log10(v3)))
		if string.match(v7, "%.") then
			v7 = string.split(v7, ".")[2]:sub(1, 3)
		end
		return "e" .. v4 .. "." .. v7
	end
end
local t3 = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z"
}
function t2.aaNotation(p1) --[[ aaNotation | Line: 639 | Upvalues: fixNumber (copy), t3 (copy), t (copy) ]]
	local v1, v2 = fixNumber(p1.first, p1.second)
	local v3 = math.floor(v2 / 3) - 4
	if v3 <= 0 then
		return p1:GetSuffix()
	else
		local v4 = ""
		local v5 = v1 * 10 ^ (v2 % 3)
		while v3 > 0 do
			local v6 = v3 % #t3 and #t3
			v4 = t3[v6] .. v4
			v3 = math.floor((v3 - v6) / #t3)
		end
		if #v4 > t.AALENGTHMAX then
			return p1:ScientificNotation()
		else
			return math.floor(v5 * 10 ^ t.DECIMALPOINTS) / 10 ^ t.DECIMALPOINTS .. v4
		end
	end
end
function t2.ConvertForLeaderboards(p1) --[[ ConvertForLeaderboards | Line: 679 | Upvalues: fixNumber (copy) ]]
	local v1, v2 = fixNumber(p1.first, p1.second)
	local v3 = tostring(v1)
	return math.floor(tonumber(tostring(v2) .. "." .. v3:gsub("%.", ""):sub(1, 5)) * 10000)
end
function t.ConvertFromLeaderboards(p1, p2) --[[ ConvertFromLeaderboards | Line: 703 | Upvalues: t (copy) ]]
	if p2 == 0 then
		return t.new(0)
	else
		local v1 = tostring(p2 / 10000):split(".")
		local v3 = v1[2]
		local v4 = tostring(v3):sub(1, 1) .. "." .. tostring(v3):sub(2)
		return t.new({ tonumber(v4), (tonumber(v1[1])) })
	end
end
function t.floor(p1) --[[ floor | Line: 733 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local _, v2 = fixNumber(v1.first, v1.second)
	if v2 >= 300 then
		return v1
	else
		return t.new((math.floor((v1:Reverse()))))
	end
end
function t.round(p1) --[[ round | Line: 751 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2, v3 = fixNumber(v1.first, v1.second)
	if v3 >= 300 then
		return v1
	else
		local v4 = tostring(v2):sub(3 + v3)
		if v4 == "" then
			return v1
		elseif tonumber(v4) / 10 ^ (#v4) >= 0.5 then
			return t.new((math.ceil((v1:Reverse()))))
		else
			return t.new((math.floor((v1:Reverse()))))
		end
	end
end
function t.ceil(p1) --[[ ceil | Line: 781 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local _, v2 = fixNumber(v1.first, v1.second)
	if v2 >= 300 then
		return v1
	else
		return t.new((math.ceil((v1:Reverse()))))
	end
end
function t.abs(p1) --[[ abs | Line: 799 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2, v3 = fixNumber(v1.first, v1.second)
	return t.new({ math.abs(v2), v3 })
end
function t.clamp(p1, p2, p3) --[[ clamp | Line: 817 | Upvalues: checkNumber (copy), fixNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2, v3 = fixNumber(v1.first, v1.second)
	local v4 = t.new({ v2, v3 })
	local v5
	if p2 == nil then
		v5 = t.new(0)
	else
		local v7 = checkNumber(p2)
		local v8, v9 = fixNumber(v7.first, v7.second)
		v5 = t.new({ v8, v9 })
	end
	local v11, v12
	if p3 == nil then
		v11, v12 = v4, t.new({ 1, 1e308 })
	else
		local v14 = checkNumber(p3)
		local v15, v16 = fixNumber(v14.first, v14.second)
		v11, v12 = v4, t.new({ v15, v16 })
	end
	if v11 < v5 then
		return v5
	elseif v12 < v11 then
		return v12
	else
		return v11
	end
end
function t.min(...) --[[ min | Line: 852 | Upvalues: checkNumber (copy) ]]
	local t = { ... }
	if t[1] == nil then
		error("InfiniteMath.min requires at least 1 argument.")
	end
	for v1, v2 in t do
		t[v1] = checkNumber(v2)
	end
	local v3 = t[1]
	for v4, v5 in t do
		if v5 < v3 then
			v3 = v5
		end
	end
	return v3
end
function t.max(...) --[[ max | Line: 882 | Upvalues: checkNumber (copy) ]]
	local t = { ... }
	if t[1] == nil then
		error("InfiniteMath.max requires at least 1 argument.")
	end
	for v1, v2 in t do
		t[v1] = checkNumber(v2)
	end
	local v3 = t[1]
	for v4, v5 in t do
		if v3 < v5 then
			v3 = v5
		end
	end
	return v3
end
function t.sign(p1) --[[ sign | Line: 913 | Upvalues: checkNumber (copy), fixNumber (copy) ]]
	local v1 = checkNumber(p1)
	local v2, _ = fixNumber(v1.first, v1.second)
	local v3 = tonumber(v2)
	if v3 > 0 then
		return 1
	elseif v3 < 0 then
		return -1
	else
		return 0
	end
end
function t.sqrt(p1) --[[ sqrt | Line: 930 ]]
	return p1 ^ 0.5
end
function t.fmod(p1, p2) --[[ fmod | Line: 944 | Upvalues: checkNumber (copy), t (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = checkNumber(p2)
	return v1 - v2 * t.floor(v1 / v2)
end
function t.modf(p1) --[[ modf | Line: 962 | Upvalues: checkNumber (copy), t (copy), fixNumber (copy) ]]
	local v1 = checkNumber(p1)
	local v2 = t.sign(v1)
	local v3 = v1 * v2
	local v4, v5 = fixNumber(v3.first, v3.second)
	local v6 = tostring(v4):split(".")
	if v6[2] == nil then
		return v3
	else
		local v8 = v6[1] .. "." .. v6[2]:sub(1, v5)
		local v9 = if v5 == 0 then 2 else v5
		local v10 = if v5 > 0 then v6[2]:sub(v9 + 1) / 10 ^ (#v6[2]:sub(v9 + 1)) else v6[2] / 10 ^ (#v6[2])
		return t.new({ v8, v5 }) * v2, v10
	end
end
function t.log(p1, p2) --[[ log | Line: 999 | Upvalues: checkNumber (copy), t (copy), fixNumber (copy) ]]
	local v1 = checkNumber(p1)
	if t.sign(v1) == -1 then
		return (0 / 0)
	else
		if p2 == nil then
			p2 = 2.7182818
		end
		local v2, v3 = fixNumber(v1.first, v1.second)
		return t.new(math.log(v2, p2) + v3 * math.log(10, p2))
	end
end
function t.log10(p1) --[[ log10 | Line: 1024 | Upvalues: t (copy) ]]
	return t.log(p1, 10)
end
return t