local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FormatNumberMain = require(ReplicatedStorage.Libs.FormatNumber.Main)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)

local StringUtil = {}

function StringUtil.Escape(str: string): string
    -- return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
    local escape= string.gsub(str, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
    return escape
end

return StringUtil