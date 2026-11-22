local Workspace = game:GetService("Workspace")
local Signal = require(script.Parent.Parent.Packages.Signal)
local WhiteFlash = require(script.Parent.WhiteFlashOverlayUtil)
local UpgradeData = require(script.Parent.PlotUpgradeData)
local Timing = require(script.Parent.PlotUpgradeTransitionConfig)

local PlotUpgradeTransition = {}
PlotUpgradeTransition.__index = PlotUpgradeTransition

local function destroyList(list)
	for _, item in list do
		item:Destroy()
	end
	table.clear(list)
end

local function makeHighlights(fence, transparency)
	local highlights = {}
	for _, group in fence:GetChildren() do
		if group:IsA("Model") then
			local overlay = WhiteFlash.CreateHighlight(group)
			if overlay then
				overlay:SetTransparency(transparency)
				table.insert(highlights, overlay)
			end
		end
	end
	return highlights
end

-- Fence is a Folder; assemble only its six groups into an unparented snapshot Model.
local function snapshot(fence)
	local proxy = Instance.new("Model")
	proxy.Name = "FenceWhiteSnapshot"
	for _, group in fence:GetChildren() do
		if group:IsA("Model") then
			local clone = group:Clone()
			clone.Parent = proxy
		end
	end
	for _, item in proxy:GetDescendants() do
		if item:IsA("Highlight") or item:IsA("ModuleScript") then
			item:Destroy()
		elseif item:IsA("BasePart") then
			-- Original parts may already be locally hidden during the handoff.
			if item.Transparency == 1 then
				item:Destroy()
			else
				item.LocalTransparencyModifier = 0
			end
		end
	end
	local overlay = WhiteFlash.Create(proxy)
	proxy:Destroy()
	return overlay
end

local function hideItem(state, item)
	if item:IsA("BasePart") and state.parts[item] == nil then
		state.parts[item] = item.LocalTransparencyModifier
		item.LocalTransparencyModifier = 1
	elseif item:IsA("ParticleEmitter") and state.emitters[item] == nil then
		state.emitters[item] = item.Enabled
		item.Enabled = false
	end
end

local function restoreItems(state)
	for part, value in state.parts do
		if part.Parent then
			part.LocalTransparencyModifier = value
		end
	end
	for emitter, enabled in state.emitters do
		if emitter.Parent then
			emitter.Enabled = enabled
		end
	end
	table.clear(state.parts)
	table.clear(state.emitters)
	state.hidden = false
end

function PlotUpgradeTransition.new()
	return setmetatable({ _states = {}, Changed = Signal.new() }, PlotUpgradeTransition)
end

function PlotUpgradeTransition:IsPlaying(plot): boolean
	return self._states[plot] ~= nil
end

function PlotUpgradeTransition:_current(state): boolean
	return self._states[state.plot] == state and not state.done
end

function PlotUpgradeTransition:_finish(state)
	if state.done then
		return
	end
	state.done = true
	for _, connection in state.connections do
		connection:Disconnect()
	end
	table.clear(state.connections)
	restoreItems(state)
	destroyList(state.highlights)
	if state.oldSnapshot then
		state.oldSnapshot:Destroy()
	end
	if state.newSnapshot then
		state.newSnapshot:Destroy()
	end
	if self._states[state.plot] == state then
		self._states[state.plot] = nil
		self.Changed:Fire(state.plot, false)
	end
end

function PlotUpgradeTransition:_later(state, delay, callback)
	task.delay(delay, function()
		if not self:_current(state) then
			return
		end
		local ok, err = pcall(callback)
		if not ok then
			self:_finish(state)
			warn("PlotUpgradeTransition: could not complete visual transition", err)
		end
	end)
end

function PlotUpgradeTransition:_cover(state)
	if state.covered then
		return
	end
	state.covered = true
	for _, highlight in state.highlights do
		highlight:SetTransparency(0)
	end
	state.oldSnapshot = snapshot(state.fence)
	if state.oldSnapshot then
		state.oldSnapshot:SetTransparency(0)
		state.hidden = true
		for _, item in state.fence:GetDescendants() do
			hideItem(state, item)
		end
		destroyList(state.highlights)
	end
end

function PlotUpgradeTransition:_finishReveal(state)
	if not self:_current(state) then
		return
	end
	destroyList(state.highlights)
	state.highlights = makeHighlights(state.fence, 0)
	-- Transfer white to the real geometry before removing the white snapshots.
	restoreItems(state)
	if state.newSnapshot then
		state.newSnapshot:Destroy()
		state.newSnapshot = nil
	end
	if state.oldSnapshot then
		state.oldSnapshot:Destroy()
		state.oldSnapshot = nil
	end
	for _, highlight in state.highlights do
		highlight:FadeOut(Timing.FadeOut)
	end
	self:_later(state, Timing.FadeOut, function()
		self:_finish(state)
	end)
end

function PlotUpgradeTransition:_reveal(state)
	state.revealing = true
	self:_cover(state)
	self:_later(state, Timing.OldWhiteHold, function()
		state.newSnapshot = snapshot(state.fence)
		if not state.newSnapshot then
			self:_finishReveal(state)
			return
		end
		state.newSnapshot:SetTransparency(1)
		state.newSnapshot:FadeIn(Timing.NewWhiteFadeIn)
		self:_later(state, Timing.NewWhiteFadeIn, function()
			if state.oldSnapshot then
				state.oldSnapshot:FadeOut(Timing.OldFadeOut)
			end
			self:_later(state, Timing.OldFadeOut, function()
				self:_finishReveal(state)
			end)
		end)
	end)
end

function PlotUpgradeTransition:_awaitReplication(state)
	local config = UpgradeData.Get(state.level)
	if
		state.plot:GetAttribute("PlotUpgradeLevel") == state.level
		and state.plot:GetAttribute("PlotWidth") == config.Width
		and state.plot:GetAttribute("PlotDepth") == config.Depth
	then
		self:_reveal(state)
	else
		self:_later(state, Timing.ReplicationPollInterval, function()
			self:_awaitReplication(state)
		end)
	end
end

function PlotUpgradeTransition:Handle(phase, plot, id, level)
	if not plot or typeof(id) ~= "string" then
		return
	end
	local state = self._states[plot]
	if phase == "Cancel" then
		if state and state.id == id then
			self:_finish(state)
		end
		return
	elseif phase == "Applied" then
		if state and state.id == id and not state.applied then
			state.applied = true
			local ok, err = pcall(function()
				self:_awaitReplication(state)
			end)
			if not ok then
				self:_finish(state)
				warn("PlotUpgradeTransition: could not reveal upgraded fence", err)
			end
		end
		return
	elseif phase ~= "Begin" or typeof(level) ~= "number" then
		return
	end
	if state then
		self:_finish(state)
	end
	local fence = plot:FindFirstChild("Fence")
	if not plot:IsDescendantOf(Workspace) or not fence then
		return
	end
	state = {
		plot = plot,
		fence = fence,
		id = id,
		level = level,
		owner = plot:GetAttribute("OwnerUserId"),
		highlights = {},
		parts = {},
		emitters = {},
		connections = {},
		hidden = false,
		covered = false,
		applied = false,
		revealing = false,
		done = false,
	}
	self._states[plot] = state
	table.insert(
		state.connections,
		plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
			if plot:GetAttribute("OwnerUserId") ~= state.owner then
				self:_finish(state)
			end
		end)
	)
	table.insert(
		state.connections,
		plot.AncestryChanged:Connect(function()
			if not plot:IsDescendantOf(Workspace) then
				self:_finish(state)
			end
		end)
	)
	table.insert(
		state.connections,
		fence.AncestryChanged:Connect(function()
			if fence.Parent ~= plot then
				self:_finish(state)
			end
		end)
	)
	table.insert(
		state.connections,
		fence.DescendantAdded:Connect(function(item)
			if state.hidden then
				hideItem(state, item)
			end
		end)
	)
	self.Changed:Fire(plot, true)
	local ok, err = pcall(function()
		state.highlights = makeHighlights(fence, 1)
		for _, highlight in state.highlights do
			highlight:FadeIn(Timing.FadeIn)
		end
	end)
	if not ok then
		self:_finish(state)
		warn("PlotUpgradeTransition: could not start visual transition", err)
		return
	end
	self:_later(state, Timing.FadeIn, function()
		self:_cover(state)
	end)
	self:_later(state, Timing.Timeout, function()
		if not state.revealing then
			self:_finish(state)
		end
	end)
end

function PlotUpgradeTransition:Destroy()
	local states = {}
	for _, state in self._states do
		table.insert(states, state)
	end
	for _, state in states do
		self:_finish(state)
	end
	self.Changed:Destroy()
end

return PlotUpgradeTransition
