local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FormatNumberMain = require(ReplicatedStorage.Libs.FormatNumber.Main)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)

local MathUtil = {}

function MathUtil.MagnitudeSquared(vec1: Vector3, vec2: Vector3): number
    local vec = vec1 - vec2
    return vec.x * vec.x + vec.y * vec.y + vec.z * vec.z
end

function MathUtil.IsNaN(value)
    return value ~= value
  end

function MathUtil.IsInteger(value)
return value == math.floor(value)
end

-- 检查是否为无穷大
function MathUtil.IsInfinity(value)
    return value == math.huge or value == -math.huge
end

return MathUtil