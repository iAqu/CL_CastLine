local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Constants = require(ReplicatedStorage.Modules.Constants)

module = {}

function module.Print(message: string, ...)
    if Constants.DEBUG then
        print(message, ...)
    end
end

return module