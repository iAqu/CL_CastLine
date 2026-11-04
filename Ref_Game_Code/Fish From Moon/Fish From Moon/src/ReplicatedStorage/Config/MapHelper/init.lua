local MapHelper = {}

local MapConfig = require(script.MapConfig)

function MapHelper.GetMap()
	return MapConfig
end
function MapHelper.GetMapTypes(worldId)
	return MapConfig[tonumber(worldId)].types
end
function MapHelper.GetMapImg(worldId)
	return MapConfig[tonumber(worldId)].img
end
function MapHelper.GetMapName(worldId)
	return MapConfig[tonumber(worldId)].name
end
function MapHelper.GetMapDevice(worldId)
	return MapConfig[tonumber(worldId)]["Device"]
end
function MapHelper.GetMapPrice(worldId)
	return MapConfig[tonumber(worldId)].price
end
function MapHelper.GetMapGemPrice(worldId)
	return MapConfig[tonumber(worldId)].gemPrice
end

return MapHelper
