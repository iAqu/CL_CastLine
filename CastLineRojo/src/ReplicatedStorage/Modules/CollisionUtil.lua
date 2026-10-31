local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local module = {}

function module.SetCollisionGroup(object: Instance, collisionGroup: string)
    if object:IsA("BasePart") then
        object.CollisionGroup = collisionGroup
    end
end

function module.SetCollisionGroupRecursive(object: Instance, collisionGroup: string)
	module.SetCollisionGroup(object, collisionGroup)
	for _, child in ipairs(object:GetChildren()) do
		module.SetCollisionGroupRecursive(child, collisionGroup)
	end
end

return module