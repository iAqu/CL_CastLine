local function read(path)
	local f = assert(io.open(path, "r"))
	local text = f:read("*a")
	f:close()
	return text
end
local function signal()
	local listeners = {}
	return {
		Connect = function(_, callback)
			local c = { Connected = true }
			function c:Disconnect()
				self.Connected = false
			end
			table.insert(listeners, { connection = c, callback = callback })
			return c
		end,
		Fire = function(_, ...)
			for _, listener in table.clone(listeners) do
				if listener.connection.Connected then
					listener.callback(...)
				end
			end
		end,
		Destroy = function()
			for _, listener in listeners do
				listener.connection:Disconnect()
			end
		end,
	}
end
local methods = {}
local node
function methods:IsA(class)
	return self.ClassName == class or class == "BasePart" and self.ClassName == "Part"
end
function methods:GetChildren()
	return table.clone(self._children)
end
function methods:GetDescendants()
	local result = {}
	for _, child in self._children do
		table.insert(result, child)
		for _, descendant in child:GetDescendants() do
			table.insert(result, descendant)
		end
	end
	return result
end
function methods:FindFirstChild(name)
	for _, child in self._children do
		if child.Name == name then
			return child
		end
	end
	return nil
end
function methods:IsDescendantOf(parent)
	local ancestor = self.Parent
	while ancestor do
		if ancestor == parent then
			return true
		end
		ancestor = ancestor.Parent
	end
	return false
end
function methods:GetAttribute(name)
	return self._attributes[name]
end
function methods:GetAttributeChangedSignal(name)
	if not self._signals[name] then
		self._signals[name] = signal()
	end
	return self._signals[name]
end
function methods:SetAttribute(name, value)
	self._attributes[name] = value
	self:GetAttributeChangedSignal(name):Fire()
end
function methods:Clone()
	local copy = node(self.ClassName)
	for key, value in self._properties do
		if key ~= "Parent" then
			copy[key] = value
		end
	end
	copy._attributes = table.clone(self._attributes)
	for _, child in self:GetChildren() do
		child:Clone().Parent = copy
	end
	return copy
end
function methods:Destroy()
	self.Parent = nil
	for _, child in self:GetChildren() do
		child:Destroy()
	end
end
node = function(class, parent)
	local value = {
		_properties = { ClassName = class, Name = class, LocalTransparencyModifier = 0, Enabled = true },
		_children = {},
		_attributes = {},
		_signals = {},
		AncestryChanged = signal(),
		DescendantAdded = signal(),
	}
	setmetatable(value, {
		__index = function(self, key)
			return methods[key] or self._properties[key]
		end,
		__newindex = function(self, key, content)
			if key ~= "Parent" then
				self._properties[key] = content
				return
			end
			local old = self._properties.Parent
			if old then
				local index = table.find(old._children, self)
				if index then
					table.remove(old._children, index)
				end
			end
			self._properties.Parent = content
			if content then
				table.insert(content._children, self)
				local added = self:GetDescendants()
				table.insert(added, self)
				local ancestor = content
				while ancestor do
					for _, item in added do
						ancestor.DescendantAdded:Fire(item)
					end
					ancestor = ancestor.Parent
				end
			end
			self.AncestryChanged:Fire(self, content)
		end,
	})
	value.Parent = parent
	return value
end
local workspace = node("Workspace")
local overlays, events, warnings = {}, {}, {}
local now, jobs = 0, {}
local function delay(duration, callback)
	table.insert(jobs, { at = now + duration, callback = callback })
end
local function step(duration)
	local target = now + duration
	while true do
		local selected, earliest
		for index, job in jobs do
			if job.at <= target and (not earliest or job.at < earliest) then
				selected, earliest = index, job.at
			end
		end
		if not selected then
			break
		end
		local job = table.remove(jobs, selected)
		now = job.at
		job.callback()
	end
	now = target
end
local function overlay(kind, model)
	local item = { destroyed = false, kind = kind }
	local instance = node(if kind == "highlight" then "Highlight" else "Model", model or workspace)
	item.instance = instance
	function item:SetTransparency(value)
		self.transparency = value
	end
	function item:FadeIn(duration)
		self.fadeIn = duration
	end
	function item:FadeOut(duration)
		self.fadeOut = duration
	end
	function item:Destroy()
		self.destroyed = true
		instance:Destroy()
	end
	table.insert(overlays, item)
	return item
end
local failSnapshot = false
local white = {
	CreateHighlight = function(model)
		return overlay("highlight", model)
	end,
	Create = function(proxy)
		if failSnapshot then
			error("Injected snapshot failure")
		end
		for _, part in proxy:GetDescendants() do
			assert(not part:IsA("Highlight"), "A snapshot cannot inherit permanent white highlights")
			if part:IsA("BasePart") then
				assert(part.Transparency ~= 1, "Hidden layout anchors must not appear in white snapshots")
				assert(part.LocalTransparencyModifier == 0, "Hidden originals must produce visible snapshots")
			end
		end
		return overlay("snapshot")
	end,
}
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/PlotUpgradeTransitionConfig.lua")))()
local root = {
	PlotUpgradeTransitionConfig = config,
	WhiteFlashOverlayUtil = white,
	PlotUpgradeData = require("./helpers/PlotUpgrades").data,
	Parent = { Packages = { Signal = { new = signal } } },
}
local Transition = assert(
	load(
		read("src/ReplicatedStorage/Modules/PlotUpgradeTransition.lua"),
		"PlotUpgradeTransition",
		"t",
		setmetatable({
			game = {
				GetService = function()
					return workspace
				end,
			},
			script = { Parent = root },
			require = function(value)
				return value
			end,
			Instance = { new = node },
			task = { delay = delay },
			warn = function(...)
				table.insert(warnings, { ... })
			end,
		}, { __index = getfenv() })
	)
)()
local transition = Transition.new()
transition.Changed:Connect(function(plot, playing)
	table.insert(events, { plot = plot, playing = playing })
end)
local function plot()
	local home = node("Model", workspace)
	home:SetAttribute("OwnerUserId", 42)
	home:SetAttribute("PlotUpgradeLevel", 0)
	home:SetAttribute("PlotWidth", 60)
	home:SetAttribute("PlotDepth", 56)
	local fence = node("Folder", home)
	fence.Name = "Fence"
	for _, name in { "Entrance", "FrontLeft", "FrontRight", "Back", "Left", "Right" } do
		local group = node("Model", fence)
		group.Name = name
		local part = node("Part", group)
		part.Color = "original"
	end
	local part = fence:GetChildren()[1]:GetChildren()[1]
	local anchor = node("Part", fence:GetChildren()[1])
	anchor.Transparency = 1
	part.LocalTransparencyModifier = 0.2
	local emitter = node("ParticleEmitter", part)
	local disabled = node("ParticleEmitter", part)
	disabled.Enabled = false
	local water = node("Part", home)
	water.Name = "Ground"
	local fish = node("Part", home)
	fish.Name = "Fish"
	return home, fence, part, emitter, disabled, water, fish
end
local function noVisuals()
	for _, item in overlays do
		assert(item.destroyed, "Leaked transition overlay")
	end
end
local home, fence, part, emitter, disabled, water, fish = plot()
transition:Handle("Begin", home, "one", 1)
assert(transition:IsPlaying(home) and #overlays == 6)
step(0.25)
assert(part.LocalTransparencyModifier == 1 and not emitter.Enabled)
assert(water.LocalTransparencyModifier == 0 and fish.LocalTransparencyModifier == 0)
local added = node("Part", fence:GetChildren()[2])
local addedEmitter = node("ParticleEmitter", added)
assert(added.LocalTransparencyModifier == 1 and not addedEmitter.Enabled, "Late replicated parts must remain covered")
transition:Handle("Applied", home, "one", 1)
step(0.1)
assert(transition:IsPlaying(home), "Applied must wait for the replicated level and dimensions")
home:SetAttribute("PlotUpgradeLevel", 1)
home:SetAttribute("PlotWidth", root.PlotUpgradeData.Get(1).Width)
step(1.1)
assert(not transition:IsPlaying(home))
assert(part.LocalTransparencyModifier == 0.2 and added.LocalTransparencyModifier == 0)
assert(emitter.Enabled and addedEmitter.Enabled and not disabled.Enabled)
assert(part.Color == "original" and water.LocalTransparencyModifier == 0 and fish.LocalTransparencyModifier == 0)
noVisuals()
-- Cancel and timeout restore the original local visibility, including false emitter values.
transition:Handle("Begin", home, "cancel", 2)
step(0.25)
transition:Handle("Cancel", home, "stale", 2)
assert(transition:IsPlaying(home))
transition:Handle("Cancel", home, "cancel", 2)
assert(not transition:IsPlaying(home) and part.LocalTransparencyModifier == 0.2 and not disabled.Enabled)
transition:Handle("Begin", home, "timeout", 2)
step(2.01)
assert(not transition:IsPlaying(home) and part.LocalTransparencyModifier == 0.2)
-- Superseded callback sequences cannot finish or clear a newer transition.
transition:Handle("Begin", home, "old", 2)
step(0.25)
transition:Handle("Begin", home, "new", 2)
transition:Handle("Applied", home, "old", 2)
transition:Handle("Cancel", home, "old", 2)
assert(transition:IsPlaying(home))
step(0.25)
transition:Handle("Cancel", home, "new", 2)
step(3)
assert(not transition:IsPlaying(home))
noVisuals()
transition:Handle("Begin", home, "owner", 2)
step(0.25)
home:SetAttribute("OwnerUserId", 99)
assert(not transition:IsPlaying(home) and part.LocalTransparencyModifier == 0.2)
-- An early Applied error must also clean up, rather than disabling the timeout forever.
transition:Handle("Begin", home, "error", 1)
failSnapshot = true
transition:Handle("Applied", home, "error", 1)
failSnapshot = false
assert(not transition:IsPlaying(home) and #warnings == 1)
local other = plot()
transition:Handle("Begin", other, "removed", 1)
step(0.25)
other.Parent = nil
assert(not transition:IsPlaying(other))
transition:Handle("Begin", home, "destroy", 2)
step(0.25)
transition:Destroy()
step(5)
noVisuals()
assert(part.LocalTransparencyModifier == 0.2 and emitter.Enabled and not disabled.Enabled)
print("PlotUpgradeTransition.test.lua passed")
