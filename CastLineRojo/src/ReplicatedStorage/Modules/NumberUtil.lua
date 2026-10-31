local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FormatNumberMain = require(ReplicatedStorage.Libs.FormatNumber.Main)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)

local NumberUtil = {}

-- local COMPACT_SUFFIXES = table.freeze({ "K", "M", "B", "T" })
local COMPACT_SUFFIXES = table.freeze({"K","M","B","T","Qa","Qi","Sx","Sp","Oc","No","De","UDe","DDe","TDe","QtDe","QnDe","SxDe","SpDe","OcDe","NoDe","Vg","DVg","TVg","QtVg","QnVg","SxVg","SpVg","OcVg","NoVg","Tg"})

-- 千位加逗号
-- 百万开始显示M
function NumberUtil.formatNumber(number: number): string
    local formattedNumber = tostring(number)
    if number >= 1000000 then
        formattedNumber = FormatNumberSimple.FormatCompact(number)
    else
        formattedNumber = FormatNumberMain.NumberFormatter.with():Format(number)
    end 
    return formattedNumber
end

-- 百万开始显示M缩写
function NumberUtil.FormatNumberStartMWithDecimal(number: number, decimal: number): string
    local formattedNumber = tostring(number)
	decimal = decimal or 2
    if number >= 1000000 then
        -- formattedNumber = FormatNumberSimple.FormatCompact(number)
		formattedNumber = FormatNumberMain.NumberFormatter.with():Notation(FormatNumberMain.Notation.compactWithSuffixThousands(COMPACT_SUFFIXES))
		:Precision(FormatNumberMain.Precision.fixedFraction(decimal)):Format(number)
    else
        formattedNumber = FormatNumberMain.NumberFormatter.with():Format(number)
    end 
    return formattedNumber
end

-- 千开始显示K缩写
function NumberUtil.FormatNumberStartKWithDecimal(number: number, decimal: number?): string
    local formattedNumber = tostring(number)
	decimal = decimal or 2
    if number >= 1_000 then
		-- formattedNumber = FormatNumberMain.NumberFormatter.with():Notation(FormatNumberMain.Notation.compactWithSuffixThousands(COMPACT_SUFFIXES))
		-- :Precision(FormatNumberMain.Precision.fixedFraction(2)):Format(number)
		formattedNumber = FormatNumberMain.NumberFormatter.with():Notation(FormatNumberMain.Notation.compactWithSuffixThousands(COMPACT_SUFFIXES))
		:Precision(FormatNumberMain.Precision.maxFraction(decimal)):Format(number)
    else
        formattedNumber = FormatNumberMain.NumberFormatter.with():Format(number)
    end
    return formattedNumber
end

-- 物品价格显示：千开始缩写，最多两位小数且始终截断。
function NumberUtil.FormatItemPriceCompact(number: number): string
	if number ~= number or number == math.huge or number == -math.huge then
		return "0"
	end

	local value = math.max(0, math.floor(number))
	if value < 1_000 then
		return FormatNumberMain.NumberFormatter.with():Format(value)
	end

	local divisor = 1_000
	local suffixIndex = 1
	while suffixIndex < #COMPACT_SUFFIXES and value >= divisor * 1_000 do
		divisor *= 1_000
		suffixIndex += 1
	end

	local whole = math.floor(value / divisor)
	local remainder = value - whole * divisor
	local hundredths = math.floor(remainder * 100 / divisor)
	local formatted = tostring(whole)
	if hundredths > 0 then
		formatted = string.format("%d.%02d", whole, hundredths):gsub("0+$", "")
	end

	return formatted .. COMPACT_SUFFIXES[suffixIndex]
end

function NumberUtil.FormatWinsAmount(number: number, decimal: number?): string
	return NumberUtil.FormatNumberStartMWithDecimal(number, decimal) .. "$"
end

-- 千位加逗号，不使用 K/M/B 缩写
function NumberUtil.FormatNumberWithComma(number: number): string
	return FormatNumberMain.NumberFormatter.with():Format(number)
end

function NumberUtil.FormatNumberNoComma(number: number): string
	local formattedNumber = tostring(number)
	if number >= 1000000 then
		formattedNumber = FormatNumberSimple.FormatCompact(number)
	end
	return formattedNumber
end

function NumberUtil.ConvertToHM(seconds: number)
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return string.format("%02i", Hours).."h"..string.format("%02i", Minutes).."m"
end

function NumberUtil.ConvertToHMS(seconds: number)
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return string.format("%02i", Hours)..":"..string.format("%02i", Minutes)..":"..string.format("%02i", seconds)
end

function NumberUtil.ConvertToDHMS(seconds: number)
	local Days = (seconds - seconds%86400)/86400
	seconds = seconds - Days*86400
	local Hours = (seconds - seconds%3600)/3600
	seconds = seconds - Hours*3600
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	return string.format("%02i", Days)..":"..string.format("%02i", Hours)..":"..string.format("%02i", Minutes)..":"..string.format("%02i", seconds)
end

function NumberUtil.ConvertToHMS_Unit(seconds: number)
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	if Hours > 0 then
		return string.format("%02i", Hours) .. "h" .. " " .. string.format("%02i", Minutes).."m" .. " " ..  string.format("%02i", seconds) .. "s"
	elseif Minutes > 0 then
		return string.format("%02i", Minutes).."m" .. " " ..  string.format("%02i", seconds) .. "s"
	else
		return string.format("%02i", seconds) .. "s"
	end
	-- return string.format("%02i", Hours) .. "h" .. " " .. string.format("%02i", Minutes).."m" .. " " ..  string.format("%02i", seconds) .. "s"
end

function NumberUtil.ConvertToDHM_Unit(seconds: number)
	local Days = (seconds - seconds%86400)/86400
	seconds = seconds - Days*86400
	local Hours = (seconds - seconds%3600)/3600
	seconds = seconds - Hours*3600
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	if Days > 0 then
		local result = Days.."d"
		if Hours > 0 then
			result = result.." "..Hours.."h"
		end
		if Minutes > 0 then
			result = result.." "..Minutes.."m"
		end
		return result
	elseif Hours > 0 then
		local result = Hours.."h"
		if Minutes > 0 then
			result = result.." "..Minutes.."m"
		end
		return result
	else
		return Minutes.."m"
	end
end

function NumberUtil.ConvertToMS(seconds: number)
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	-- local Hours = (Minutes - Minutes%60)/60
	-- Minutes = Minutes - Hours*60
	-- return string.format("%02i", Hours)..":"..string.format("%02i", Minutes)..":"..string.format("%02i", seconds)
	return string.format("%02i", Minutes)..":"..string.format("%02i", seconds)
end

function NumberUtil.ConvertToAutoHMS(seconds: number)
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	if Hours > 0 then
		return string.format("%02i", Hours)..":"..string.format("%02i", Minutes)..":"..string.format("%02i", seconds)
	else
		return string.format("%02i", Minutes)..":"..string.format("%02i", seconds)
	end
end

function NumberUtil.ZeroOutFromThirdDigit(number)
	number = math.ceil(number)
    if number > 100 then
        number = math.floor(number / 10^(string.len(tostring(number)) - 2)) * 10^(string.len(tostring(number)) - 2)
    end
    return math.ceil(number)
end


--获取整数长度
function NumberUtil.GetIntNumLength(num)
    -- 处理0和负数的情况
    if num == 0 then return 1 end
    if num < 0 then
        num = -num
    end
    
    local length = 0
    while num >= 1 do
        num = num / 10
        length = length + 1
    end
    return length
end

-- 获得前几位数
function NumberUtil.GetFrontNum(num, frontLength)
	local length = NumberUtil.GetIntNumLength(num)
	local frontNum = math.floor(num / 10 ^ (length - frontLength))
	return frontNum
end

-- 保留前 frontLength 位数字，其余位归零（如 3838 → 3800）
function NumberUtil.RoundToFrontDigits(num: number, frontLength: number): number
	local rounded = math.floor(num + 0.5)
	if rounded <= 0 then
		return 0
	end

	local length = NumberUtil.GetIntNumLength(rounded)
	if length <= frontLength then
		return rounded
	end

	local frontNum = NumberUtil.GetFrontNum(rounded, frontLength)
	return frontNum * 10 ^ (length - frontLength)
end

local Tag_YYYYY = "11111"
function NumberUtil.IsNumberShortened(num: number): boolean
    -- if end with the number Tag_YYYYY.
    if tostring(num % 100000) == Tag_YYYYY then
        return true
    end
end

--格式解析:?(位数)_aaa(前3位)_yyyyy(标记位)
-- 1654311111 = 5.43*（10的16次方）
function NumberUtil.ShortenNumber(num: number): number
	-- if NumberUtil.IsNumberShortened(num) then return num end
	-- always shorten the number
	local frontThreeNum = NumberUtil.GetFrontNum(num, 3)
	local length = NumberUtil.GetIntNumLength(num)
	local shortenedNum = length * 10^(3 + #Tag_YYYYY) + frontThreeNum * 10^#Tag_YYYYY + Tag_YYYYY
	return math.floor(shortenedNum)
end

function NumberUtil.RecoverShortenNumber(num: number): number
	if not NumberUtil.IsNumberShortened(num) then return num end
	local length = math.floor(num / 10^(3 + #Tag_YYYYY))
	local frontThreeNum = math.floor((num % 10^(3 + #Tag_YYYYY)) / 10^#Tag_YYYYY)
	local recoveredNum = math.floor(frontThreeNum * 10^(length - 3))
	return recoveredNum
end

return NumberUtil
