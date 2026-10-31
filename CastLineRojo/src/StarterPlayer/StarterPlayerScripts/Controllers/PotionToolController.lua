local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)

local PotionToolController = Knit.CreateController({ Name = "PotionToolController" })

function PotionToolController:KnitInit()
end

function PotionToolController:KnitStart()
end

return PotionToolController
