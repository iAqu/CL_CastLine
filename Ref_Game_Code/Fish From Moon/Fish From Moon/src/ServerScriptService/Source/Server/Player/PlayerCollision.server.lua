local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

local playerCollisionGroupName = "Players"
PhysicsService:RegisterCollisionGroup(playerCollisionGroupName)
PhysicsService:CollisionGroupSetCollidable(playerCollisionGroupName, playerCollisionGroupName, false)

local previousCollisionGroups = {}

local function setCollisionGroup(object)
	if object.ClassName == "Part" or object.ClassName=="MeshPart" then
		object.CollisionGroup = playerCollisionGroupName
	end
end

local function setCollisionGroupRecursive(character)
	for _, child in ipairs(character:GetDescendants()) do
		setCollisionGroup(child)	
	end
end

local function onCharacterAdded(character)
    setCollisionGroupRecursive(character)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(Character)
		repeat
			task.wait()
		until player.Character
		setCollisionGroupRecursive(Character)
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)


