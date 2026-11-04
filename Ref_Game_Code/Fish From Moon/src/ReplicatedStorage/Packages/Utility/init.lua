-- Server
-- ItsKolapo
-- September 25, 2022

-- Documentation
--[[

]]

-- Module requires
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Service refs

-- Constants

-- Variables
local modules = {}

-- Module definition
local Utility = {}

function Utility:KnitInit()
	for _, child in pairs(script:GetChildren()) do
		if child:IsA("ModuleScript") then
			modules[child.Name] = require(child)
			
			for funcName, func in pairs(modules[child.Name]) do
				Utility[funcName] = func
			end
			
			modules[child.Name]:KnitInit()
		end
	end
end

return Utility
