local Policy = {}
Policy.__index = Policy

function Policy.new(rods, isAvailable, now: number)
	local ordered = {}
	for id, rod in pairs(rods) do
		table.insert(ordered, { id = id, order = rod.LayoutOrder, price = rod.Price, model = rod.Model })
	end
	table.sort(ordered, function(a, b)
		return if a.order == b.order then a.id < b.id else a.order < b.order
	end)
	return setmetatable({
		ordered = ordered,
		isAvailable = isAvailable,
		seen = {},
		seenBarbells = {},
		notBefore = now + 6,
		lastUpdate = now,
		longBusy = false,
		shopOpen = false,
		active = nil,
	}, Policy)
end

function Policy:BestOwned(owned): number
	local highest = -math.huge
	for _, rod in ipairs(self.ordered) do
		if owned[rod.id] then
			highest = math.max(highest, rod.order)
		end
	end
	return highest
end

function Policy:Candidate(owned, balance: number): string?
	local highest = self:BestOwned(owned)
	for i = #self.ordered, 1, -1 do
		local rod = self.ordered[i]
		if rod.order > highest and rod.price > 0 and rod.price <= balance and self.isAvailable(rod.model) then
			-- Match ThrowFood: do not fall back to lower tiers just because this one was shown.
			return if self.seen[rod.id] then nil else rod.id
		end
	end
	return nil
end

function Policy:Close(now: number, reason: string)
	local active = self.active
	if not active then
		return
	end
	if reason == "Interrupted" and now - active.shownAt < 2 then
		local seen = if active.kind == "Barbell" then self.seenBarbells else self.seen
		seen[active.id] = nil
	end
	self.active = nil
	self.notBefore = math.max(self.notBefore, now + 1.5)
end

function Policy:Update(now: number, context)
	local dt = math.max(0, now - self.lastUpdate)
	self.lastUpdate = now
	if self.longBusy and not context.longBusy then
		self.notBefore = math.max(self.notBefore, now + 5)
	end
	if self.shopOpen and not context.shopOpen then
		self.notBefore = math.max(self.notBefore, now + 1)
	end
	self.longBusy = context.longBusy
	self.shopOpen = context.shopOpen
	local active = self.active
	local barbell = context.barbell
	if active then
		local reason
		local done = if active.kind == "Rod"
			then self:BestOwned(context.owned) >= active.order
			else context.trainingId ~= nil and context.trainingId ~= active.trainingId
		local ready = if active.kind == "Rod"
			then context.rodReady
			else barbell ~= nil and barbell.TrainingID == active.id and barbell.Price <= context.balance
		if done then
			reason = "Done"
		elseif not context.ready or not ready or context.blocked then
			reason = "Interrupted"
		else
			if not context.paused then
				active.remaining = math.max(0, active.remaining - dt)
			end
			if active.remaining <= 0 then
				reason = "Timeout"
			end
		end
		if reason then
			self:Close(now, reason)
			return "Close", reason
		end
	elseif context.ready and not context.blocked and now >= self.notBefore then
		local id = if context.rodReady then self:Candidate(context.owned, context.balance) else nil
		if id then
			local order
			for _, rod in ipairs(self.ordered) do
				if rod.id == id then
					order = rod.order
					break
				end
			end
			self.seen[id] = true
			self.active = { kind = "Rod", id = id, order = order, shownAt = now, remaining = 7 }
			return "Show", id
		end
		if barbell and barbell.Price <= context.balance and not self.seenBarbells[barbell.TrainingID] then
			id = barbell.TrainingID
			self.seenBarbells[id] = true
			self.active = { kind = "Barbell", id = id, trainingId = context.trainingId, shownAt = now, remaining = 7 }
			return "Show", id
		end
	end
	return nil
end

return Policy
