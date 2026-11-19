local RainbowCastTrail = {}
RainbowCastTrail.__index = RainbowCastTrail

function RainbowCastTrail.new(parent, settings, colors)
	local self = setmetatable({ settings = settings, bands = {}, history = {}, enabled = false }, RainbowCastTrail)
	local carrier = Instance.new("Part")
	self.carrier = carrier
	carrier.Name, carrier.Size, carrier.Transparency = "RainbowCastTrail", Vector3.one * 0.05, 1
	carrier.Anchored, carrier.CanCollide, carrier.CanTouch, carrier.CanQuery = true, false, false, false
	local width = settings.Width / #colors
	for index = 0, #colors + 1 do
		local edge = index == 0 or index == #colors + 1
		local low = if index == 0
			then -settings.Width * 0.5 - settings.EdgeWidth
			elseif index == #colors + 1 then settings.Width * 0.5
			else -settings.Width * 0.5 + (index - 1) * width
		local high = low + (if edge then settings.EdgeWidth else width)
		local a, b = Instance.new("Attachment"), Instance.new("Attachment")
		a.Name, b.Name = "Band" .. index .. "A", "Band" .. index .. "B"
		a.Parent, b.Parent = carrier, carrier
		local trail = Instance.new("Trail")
		trail.Name = if edge then "DarkEdge" .. index else "RainbowBand" .. index
		trail.Attachment0, trail.Attachment1 = a, b
		trail.Color =
			ColorSequence.new(if edge then Color3.fromRGB(25, 20, 45) else Color3.fromRGB(unpack(colors[index])))
		trail.FaceCamera, trail.LightInfluence = true, 0
		trail.Brightness, trail.LightEmission = if edge then 1 else 1.3, if edge then 0 else 0.4
		trail.Lifetime, trail.MaxLength, trail.MinLength = settings.Lifetime, settings.MaxLength, 0.02
		trail.WidthScale = NumberSequence.new(1)
		trail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, if edge then 0.45 else 0.08),
			NumberSequenceKeypoint.new(0.65, if edge then 0.45 else 0.08),
			NumberSequenceKeypoint.new(1, 1),
		})
		trail.Enabled, trail.Parent = false, carrier
		table.insert(self.bands, { trail = trail, a = a, b = b, low = low, high = high, edge = edge })
	end
	carrier.Parent = parent
	return self
end

function RainbowCastTrail:_prune(now)
	for index = #self.history, 1, -1 do
		if now - self.history[index].at >= self.settings.Lifetime then
			table.remove(self.history, index)
		end
	end
	local last, length = self.head, 0
	for index = #self.history, 1, -1 do
		local sample = self.history[index]
		if last then
			length += (sample.position - last.position).Magnitude
		end
		if length > self.settings.MaxLength then
			for _ = 1, index do
				table.remove(self.history, 1)
			end
			break
		end
		last = sample
	end
	if self.head and now - self.head.at >= self.settings.Lifetime then
		self.head = nil
	end
end

function RainbowCastTrail:Update(position, cameraFrame, now)
	if self.destroyed then
		return false
	end
	if self.expiresAt and now >= self.expiresAt then
		self:Destroy()
		return false
	end
	if self.updatedAt and now <= self.updatedAt then
		return true
	end
	self:_prune(now)
	if not self.enabled and self.started then
		return true
	end
	local dt = if self.updatedAt then now - self.updatedAt else 0
	local axis = self.axis or cameraFrame.RightVector
	local velocity = self.position and position - self.position
	local view = cameraFrame.Position - position
	if velocity and velocity.Magnitude > 0.0001 and view.Magnitude > 0.0001 then
		local cross = velocity.Unit:Cross(view.Unit)
		if cross.Magnitude > 0.05 then
			local target = cross.Unit
			if target:Dot(axis) < 0 then
				target = -target
			end
			axis = axis:Lerp(target, 1 - math.exp(-20 * dt)).Unit
		end
	end
	self.axis, self.position, self.updatedAt = axis, position, now
	-- An unrotated carrier keeps the seven bands independent of the rod/bait's spin and scaling.
	self.carrier.CFrame = CFrame.new(position)
	for _, band in ipairs(self.bands) do
		band.a.Position, band.b.Position = axis * band.low, axis * band.high
	end
	if self.enabled then
		self.head = { position = position, axis = axis, at = now }
		if not self.sampledAt or now - self.sampledAt >= 1 / 30 then
			self.sampledAt = now
			table.insert(self.history, self.head)
		end
	end
	return true
end

function RainbowCastTrail:Start(position, cameraFrame, now)
	if self.destroyed or self.started then
		return
	end
	self:Update(position, cameraFrame, now)
	self.started, self.enabled = true, true
	self.head = { position = position, axis = self.axis, at = now }
	self.sampledAt = now
	table.insert(self.history, self.head)
	for _, band in ipairs(self.bands) do
		band.trail:Clear()
		band.trail.Enabled = true
	end
end

function RainbowCastTrail:Stop(now)
	if self.destroyed or not self.enabled then
		return
	end
	self.enabled, self.expiresAt = false, now + self.settings.Lifetime
	for _, band in ipairs(self.bands) do
		band.trail.Enabled = false
	end
end

function RainbowCastTrail:AppendBounds(points, now)
	if self.destroyed then
		return
	end
	self:_prune(now)
	local half = self.settings.Width * 0.5 + self.settings.EdgeWidth
	for _, sample in ipairs(self.history) do
		table.insert(points, sample.position + sample.axis * half)
		table.insert(points, sample.position - sample.axis * half)
	end
	if self.head then
		table.insert(points, self.head.position + self.head.axis * half)
		table.insert(points, self.head.position - self.head.axis * half)
	end
end

function RainbowCastTrail:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed, self.enabled = true, false
	self.carrier:Destroy()
	self.bands, self.history, self.head = {}, {}, nil
end

return RainbowCastTrail
