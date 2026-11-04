-- Server
-- ItsKolapo
-- September 25, 2022

-- Documentation
--[[

]]

-- Module requires
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Service refs
local TweenService = game:GetService("TweenService")

-- Constants

-- Module definition
local NumberUtility = {}

function NumberUtility.CurrencyEnding(num)
	num = NumberUtility.Round(num, 2)

	local str = num
	local suffixes = {
		"K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", 
		"Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg", 
		"Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg", "Nov",
		"Tt", "Unt", "Dtt", "Ttt", "Qut", "Qat", "Sst", "Spt", "Oct", "Nvt",
		"Qdt", "Qqt", "Sxt", "Sgt", "Oi", "Noi", "C"
	}

	for i = #suffixes, 1, -1 do
		local arb = math.pow(10, i * 3)
		if num >= arb then
			if suffixes[i] then
				local targetString = string.gsub((num / arb), "/\.0$/", "")
				if not targetString then
					return tostring(num)
				end
				
				local hundreths = NumberUtility.toHundreths(targetString, arb)
				if not hundreths then
					return tostring(num)
				end
				
				str = hundreths .. suffixes[i]
			end
			
			break
		end
	end

	return str
end

function NumberUtility.intToRoman(num)
	local numberMap = {
		{1000, 'M'}, {900, 'CM'}, {500, 'D'}, {400, 'CD'},
		{100, 'C'}, {90, 'XC'}, {50, 'L'}, {40, 'XL'}, {10, 'X'}, {9, 'IX'},
		{5, 'V'}, {4, 'IV'}, {1, 'I'}
	}
	local roman = ""
	while num > 0 do
		for index,v in pairs(numberMap)do 
			local romanChar = v[2]
			local int = v[1]
			while num >= int do
				roman = roman..romanChar
				num = num - int
			end
		end
	end
	return roman
end

function NumberUtility.ScientificNotation(num)
	local str = num

	local count = 0
	for i = 1, 10 do
		if str < 1 then
			str = str * 10
			count += 1
		else
			break
		end
	end

	str = NumberUtility.Round(str, 1)
	str = str.."e-"..count

	return str
end

function NumberUtility.Fractional(chance, total)
	local multi = 1 / chance
	return "1/"..NumberUtility.CurrencyEnding(total * multi)
end

function NumberUtility.IntRound(num)
	local under = math.floor(num)
	local upper = math.floor(num) + 1
	local underV = -(under - num)
	local upperV = upper - num

	if upperV > underV then
		return under
	else
		return upper
	end
end

function NumberUtility.findDecimal(str)
	for i = 1, string.len(str) do
		if string.sub(str, i, i) == "." then
			return i
		end
	end
end

function NumberUtility.Round(num, numDecimalPlaces)
	if num == nil or numDecimalPlaces == nil then return end
	
	if numDecimalPlaces and numDecimalPlaces>0 then
		local mult = 10^numDecimalPlaces
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function NumberUtility.toHundreths(n, arb)
	local str = tostring(n)
	local decimal = NumberUtility.findDecimal(str)

	if decimal then
		return tonumber(string.sub(str,1,decimal-1).."."..string.sub(str,decimal+1,decimal+1)..string.sub(str,decimal+2,decimal+2))
	else
		return n 
	end
end

function NumberUtility.AddCommas(n)
	if n >= 0 and n < 1000 then
		return tostring(n)
	end

	local formatted: string = tostring(n)
	local k: number = -1

	while k ~= 0 do
		formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
	end

	return formatted
end

function NumberUtility.toTime(n)
	local days = math.floor(n/86400)
	local remaining = n % 86400
	local hours = math.floor(remaining/3600)
	remaining = remaining % 3600
	local minutes = math.floor(remaining/60)
	remaining = remaining % 60
	local seconds = remaining
	if (hours < 10) then
		hours = tostring(hours)
	end
	if (minutes < 10) then
		minutes = tostring(minutes)
	end
	if (seconds < 10) then
		seconds = tostring(seconds)
	end

	return tostring(days)..'d '..hours..'h '..minutes..'m '..math.floor(seconds) .. 's'
end

function NumberUtility.toTimeNoDay(n)
	local hours = math.floor(n/3600)
	local remaining = n % 3600
	local minutes = math.floor(remaining/60)
	remaining = remaining % 60
	local seconds = remaining
	if (hours < 10) then
		hours = tostring(hours)
	end
	if (minutes < 10) then
		minutes = tostring(minutes)
	end
	if (seconds < 10) then
		seconds = tostring(seconds)
	end

	return hours..'h '..minutes..'m '..math.floor(seconds) .. 's'
end

function NumberUtility.toTimeNoSec(n)
	local days = math.floor(n/86400)
	local remaining = n % 86400
	local hours = math.floor(remaining/3600)
	remaining = remaining % 3600
	local minutes = math.floor(remaining/60)
	remaining = remaining % 60
	local seconds = remaining
	if (hours < 10) then
		hours = tostring(hours)
	end
	if (minutes < 10) then
		minutes = tostring(minutes)
	end

	return tostring(days)..'d '..hours..'h '..minutes..'m'
end

function NumberUtility.codeTime(n)
	local days = math.floor(n/86400)
	local remaining = n % 86400
	local hours = math.floor(remaining/3600)
	remaining = remaining % 3600
	local minutes = math.floor(remaining/60)
	remaining = remaining % 60
	local seconds = remaining
	if (hours < 10) then
		hours = tostring(hours)
	end
	if (minutes < 10) then
		minutes = tostring(minutes)
	end

	return tostring(days)..'d '..hours..'h '..minutes..'m '
end

function NumberUtility.toTimeStore(n)

	if n < 3600 then
		-- send in mins
		return (n/60).." mins"
	elseif n == 3600 then
		-- send in hour
		return "1 hour"
	else
		-- send in hours
		return (n/3600).." hours"
	end
end

function NumberUtility.toTimeSpecific(n)
	if n >= 86400 then
		return math.floor(n/86400).." days"
	end

	if n >= 3600 then
		return math.floor(n/3600).." hours"
	end

	if n >= 60 then
		return math.floor(n/60).." mins"
	end

	return n.." seconds"
end

function NumberUtility.toTimeSpecificCapital(n)
	if n >= 86400 then
		return math.floor(n/86400).." Days"
	end

	if n >= 3600 then
		return math.floor(n/3600).." Hours"
	end

	if n >= 60 then
		return math.floor(n/60).." Mins"
	end

	return n.." Seconds"
end

function NumberUtility.toTimeSpecificShort(n)

	if n >= 86400 then
		return NumberUtility.Round(n/86400, 1).."d"
	end

	if n >= 3600 then
		return NumberUtility.Round(n/3600, 1).."h"
	end

	if n >= 60 then
		return math.floor(n/60).."m"
	end

	return n.."s"
end

function NumberUtility.hoursMinsSeconds(n)
	local hours = math.floor(n/3600)
	local remaining = n % 3600
	local minutes = math.floor(remaining/60)
	remaining = remaining % 60
	local seconds = remaining
	if (hours < 10) then
		hours = "0"..tostring(hours)
	end
	if (minutes < 10) then
		minutes = "0"..tostring(minutes)
	end
	if (seconds < 10) then
		seconds = "0"..tostring(seconds)
	end
	
	return hours..":"..minutes..":"..seconds
end

function NumberUtility.minsSeconds(n)
	local remaining = n % 3600
	local minutes = math.floor(remaining/60)
	remaining = remaining % 60
	local seconds = remaining

	if (minutes < 10) then
		minutes = "0"..tostring(minutes)
	end
	if (seconds < 10) then
		seconds = "0"..tostring(seconds)
	end

	return minutes..":"..seconds
end

function NumberUtility:KnitInit()

end

return NumberUtility
