local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FormatNumberMain = require(ReplicatedStorage.Libs.FormatNumber.Main)
local FormatNumberSimple = require(ReplicatedStorage.Libs.FormatNumber.Simple)

local PhysicsUtil = {}

--Only works for block shaped part, not sure about meshes
--Perhaps take https://developer.roblox.com/en-us/api-reference/property/Part/Shape into account
function PhysicsUtil.GetPartVolume(part)
	local size = part.Size
	local volume = size.X * size.Y * size.Z
	return volume
end

function PhysicsUtil.SetPartMass(part, mass)
	local partProperties = part.CustomPhysicalProperties or PhysicalProperties.new(part.Material)
	local _, b, c, d, e =
		partProperties.Density, partProperties.Friction, partProperties.Elasticity, partProperties.FrictionWeight, partProperties.ElasticityWeight
	local newDensity = mass / PhysicsUtil.GetPartVolume(part)
	part.CustomPhysicalProperties = PhysicalProperties.new(newDensity, b, c, d, e)
end

function PhysicsUtil.SetPartFriction(part, friction, elasticity, frictionWeight, elasticityWeight)
	local partProperties = part.CustomPhysicalProperties or PhysicalProperties.new(part.Material)
	local density = partProperties.Density
	part.CustomPhysicalProperties = PhysicalProperties.new(
		density,
		friction,
		elasticity or partProperties.Elasticity,
		frictionWeight or partProperties.FrictionWeight,
		elasticityWeight or partProperties.ElasticityWeight
	)
end

return PhysicsUtil