local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FormatNumberMain = require(ReplicatedStorage.Libs.FormatNumber.Main)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)

local TableUtil = {}

function TableUtil.CalculateTableLength(table: table): number
    local length = 0
    for _, _ in pairs(table) do
        length = length + 1
    end
    return length
end

return TableUtil