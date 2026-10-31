local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FormatNumberMain = require(ReplicatedStorage.Libs.FormatNumber.Main)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)

local MathUtil = {}

-- Format is 2023201
function MathUtil.GetLocalDate(): number
    local dt = DateTime.now()
    local todayTime = dt:FormatLocalTime("YYYY", "en-us") .. dt:FormatLocalTime("DDDD", "en-us")
    return tonumber(todayTime)
end

-- Format is 2023201
function MathUtil.GetUniversalDate(): number
    local todayTime = DateTime.now():FormatUniversalTime("YYYY", "en-us") .. DateTime.now():FormatUniversalTime("DDDD", "en-us")
    return tonumber(todayTime)
end

-- Format is 2023201
function MathUtil.GetUniversalDate_YMDHM(): number
    local dt = DateTime.now()
    local todayTime = dt:FormatUniversalTime("YYYY", "en-us") .. dt:FormatUniversalTime("YYYY MMMM DD HH mm", "en-us")
    return tonumber(todayTime)
end

return MathUtil