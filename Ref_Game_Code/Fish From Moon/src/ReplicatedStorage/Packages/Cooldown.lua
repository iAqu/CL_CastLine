-- Server
-- ItsKolapo
-- September 25, 2022

-- Documentation
--[[

]]

local Cooldown = {}
Cooldown.__index = Cooldown

function Cooldown.new(timeBetween)
	local self = setmetatable({}, Cooldown)

	self._list = {}
	self._timeList = {}
	self._timeBetween = timeBetween

	return self
end

function Cooldown:CanFire(name)
	if self._list[name] then
		local timeBetween = self._timeList[name] or self._timeBetween
		if (tick() - self._list[name]) >= timeBetween then
			return true
		else
			return false
		end
	else
		return true
	end
end

function Cooldown:SetTimeBetween(name, timeBetween)
	self._timeList[name] = timeBetween
end
	
function Cooldown:AddTimestamp(name)
	self._list[name] = tick()
end

return Cooldown