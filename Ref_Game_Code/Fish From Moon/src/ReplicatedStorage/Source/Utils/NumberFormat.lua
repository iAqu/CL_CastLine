local AbbNumber = {}

local units = {"", "k","M","B","T",
	"Qa","Qi","Sx","Sp","Oc","No","Dc",
	"Ud","Dd","Td","Qad","Qu","Sd","St",
	"O","Ap","Aq",
}-- Number Abbreviations

---数字转成K,M,B,T....(保留几位小数)
function AbbNumber.AbbreviateNumber(number, decimalPlaces)
	if not number or type(number) ~= "number" then
		return "Invalid number"
	end
	if not decimalPlaces or type(decimalPlaces) ~= "number" then
		decimalPlaces = 2
	end

	local absNumber = math.abs(number)
	local unitIndex = 1

	while absNumber >= 1000 and unitIndex < #units do
		absNumber = absNumber / 1000
		unitIndex = unitIndex + 1
	end

	local formattedNumber = string.format("%." .. decimalPlaces .. "f", absNumber)

	-- Remove trailing zeros and the decimal point if necessary
	if decimalPlaces > 0 then
		formattedNumber = formattedNumber:gsub("%.?0+$", "")
	end

	local result = formattedNumber .. units[unitIndex]

	return result
end

----K,M,B,T...转成数字
function AbbNumber.ParseNumberWithUnit(str)
	-- 找到数字和单位部分
	local numberPart, unitPart = str:match("([%d%.]+)(%a*)")
	if not numberPart then return nil end

	local number = tonumber(numberPart)
	if not number then return nil end

	-- 找到单位在units表中的索引
	local unitIndex = 0
	for i, unit in ipairs(units) do
		if unit == unitPart then
			unitIndex = i - 1
			break
		end
	end

	-- 计算实际数字
	local multiplier = 1000 ^ unitIndex
	return number * multiplier
end

function AbbNumber.AddDelimiter(num)
	-- Convert the number to a string
	local numStr = tostring(num)

	-- Reverse the string for easier processing
	local reversed = string.reverse(numStr)

	-- Add a comma every 3 digits
	local withCommas = reversed:gsub("(%d%d%d)", "%1,")

	-- Reverse the string again and remove any leading comma
	withCommas = string.reverse(withCommas):gsub("^,", "")

	return withCommas
end


return AbbNumber