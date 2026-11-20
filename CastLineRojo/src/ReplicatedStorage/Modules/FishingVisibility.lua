-- The local cutscene and observer rig may both hide the same character.
local held = {}
local FishingVisibility = {}
FishingVisibility.__index = FishingVisibility

function FishingVisibility.new()
	return setmetatable({ instances = {}, connections = {} }, FishingVisibility)
end

function FishingVisibility:Hide(instance: Instance, property: string, value)
	if self.instances[instance] then
		return
	end
	self.instances[instance] = true
	local entry = held[instance]
	if entry then
		entry.count += 1
		return
	end
	entry = { count = 1, property = property, original = instance[property] }
	held[instance] = entry
	instance[property] = value
	entry.changed = instance:GetPropertyChangedSignal(property):Connect(function()
		if instance[property] ~= value then
			instance[property] = value
		end
	end)
end

function FishingVisibility:_release(instance: Instance)
	if not self.instances[instance] then
		return
	end
	self.instances[instance] = nil
	local entry = held[instance]
	entry.count -= 1
	if entry.count == 0 then
		held[instance] = nil
		entry.changed:Disconnect()
		instance[entry.property] = entry.original
	end
end

function FishingVisibility:HideCharacter(character: Instance)
	local function hide(instance)
		if instance:IsA("BasePart") or instance:IsA("Decal") then
			self:Hide(instance, "LocalTransparencyModifier", 1)
		elseif
			instance:IsA("BillboardGui")
			or instance:IsA("SurfaceGui")
			or instance:IsA("ParticleEmitter")
			or instance:IsA("Trail")
			or instance:IsA("Beam")
			or instance:IsA("Highlight")
		then
			self:Hide(instance, "Enabled", false)
		end
	end
	table.insert(self.connections, character.DescendantAdded:Connect(hide))
	table.insert(
		self.connections,
		character.DescendantRemoving:Connect(function(instance)
			self:_release(instance)
		end)
	)
	for _, instance in ipairs(character:GetDescendants()) do
		hide(instance)
	end
end

function FishingVisibility:Destroy()
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end
	table.clear(self.connections)
	for instance in pairs(self.instances) do
		self:_release(instance)
	end
end

return FishingVisibility
