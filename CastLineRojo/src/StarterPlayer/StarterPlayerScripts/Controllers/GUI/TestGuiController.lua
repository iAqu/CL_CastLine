local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TestGuiController = Knit.CreateController {
    Name = "TestGuiController",
}

function TestGuiController:KnitInit()
end

function TestGuiController:KnitStart()
end

return TestGuiController
