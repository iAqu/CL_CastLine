local EggInventory = { MAX_PLACED = 30 }

function EggInventory.Reconcile(data, configs)
	data.Eggs = if type(data.Eggs) == "table" then data.Eggs else {}
	for uuid, egg in pairs(data.Eggs) do
		if type(egg) == "table" then
			local remaining = egg.RemainingSeconds
			if
				remaining ~= nil
				and (type(remaining) ~= "number" or remaining ~= remaining or remaining < 0 or remaining == math.huge)
			then
				egg.RemainingSeconds = nil
			end
		end
		if type(uuid) ~= "string" or type(egg) ~= "table" or not configs[egg.EggId] then
			data.Eggs[uuid] = nil
		elseif egg.Placement then
			local p = egg.Placement
			local valid = type(p) == "table"
			for _, key in ipairs({ "X", "Z", "Yaw", "ReadyAt" }) do
				local v = if valid then p[key] else nil
				valid = valid and type(v) == "number" and v == v and math.abs(v) < math.huge
			end
			if not valid then
				egg.Placement = nil
			end
		end
	end
end

function EggInventory.PlacedCount(eggs)
	local count = 0
	for _, egg in pairs(eggs or {}) do
		if egg.Placement then
			count += 1
		end
	end
	return count
end

function EggInventory.Place(eggs, uuid, x, z, yaw, now, duration)
	local egg = eggs[uuid]
	if not egg then
		return false, "Egg not found"
	end
	if egg.Placement then
		return false, "This egg is already placed"
	end
	if EggInventory.PlacedCount(eggs) >= EggInventory.MAX_PLACED then
		return false, "Your home can hold 30 eggs"
	end
	local remaining = if type(egg.RemainingSeconds) == "number" then math.max(0, egg.RemainingSeconds) else duration
	local placement = { X = x, Z = z, Yaw = yaw, ReadyAt = now + remaining }
	egg.Placement, egg.RemainingSeconds = placement, nil
	return true
end

function EggInventory.Pickup(eggs, uuid, now)
	local egg = eggs[uuid]
	if not egg or not egg.Placement then
		return false, "Placed egg not found"
	end
	egg.RemainingSeconds = math.max(0, egg.Placement.ReadyAt - now)
	egg.Placement = nil
	return true
end

function EggInventory.IsReady(egg, now)
	return egg ~= nil and egg.Placement ~= nil and now >= egg.Placement.ReadyAt
end

function EggInventory.ChoosePet(config, random)
	local total = 0
	for index = 1, 6 do
		local id, weight = config["PetId" .. index], config["Chance" .. index]
		if id and id ~= "nil" and type(weight) == "number" and weight > 0 then
			total += weight
		end
	end
	if total <= 0 then
		return nil
	end
	local roll = random:NextNumber() * total
	for index = 1, 6 do
		local id, weight = config["PetId" .. index], config["Chance" .. index]
		if id and id ~= "nil" and type(weight) == "number" and weight > 0 then
			roll -= weight
			if roll < 0 then
				return id
			end
		end
	end
	return nil
end

return EggInventory
