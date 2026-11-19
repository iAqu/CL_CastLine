local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Modules.EventFishConfig)
local Assets = require(ReplicatedStorage.Modules.FishingAssets)
local FishesData = require(ReplicatedFirst.Data.FishesData)
local Knit = require(ReplicatedStorage.Packages.Knit)

local RAINBOW_VFX_Y_OFFSET = -14.477272 -- 760.889 target Y minus 775.366272 marker Y.

local EventFishService = Knit.CreateService({
	Name = "EventFishService",
	Client = {},
	_Random = Random.new(),
	_Revision = 0,
	_OverrideRevision = 0,
	_Effects = {},
})

function EventFishService:_chooseFish()
	local pool = {}
	for _, fish in pairs(FishesData) do
		if fish.Rarity == "Event" and Assets.GetFish(fish.Model) then
			table.insert(pool, fish)
		end
	end
	table.sort(pool, function(a, b)
		return a.FishID < b.FishID
	end)
	return if #pool > 0 then pool[self._Random:NextInteger(1, #pool)] else nil
end

function EventFishService:_publish(snapshot)
	local previous = self._Snapshot
	if self._StateFolder and self._StateFolder.Parent
		and previous and previous.Phase == snapshot.Phase and previous.SlotId == snapshot.SlotId
		and previous.FishId == snapshot.FishId and previous.StartsAt == snapshot.StartsAt
		and previous.EndsAt == snapshot.EndsAt and previous.NextStartsAt == snapshot.NextStartsAt
	then
		return
	end
	local folder = self._StateFolder
	if not folder or not folder.Parent then
		folder = Instance.new("Folder")
		folder.Name = Config.StateFolderName
		folder.Parent = ReplicatedStorage
		self._StateFolder = folder
	end
	self._Snapshot = snapshot
	for name, value in pairs(snapshot) do
		folder:SetAttribute(name, value)
	end
	self._Revision += 1
	-- Publish the revision after the complete snapshot.
	folder:SetAttribute("Revision", self._Revision)
end

function EventFishService:_updateRainbowVFX(marker: Instance?, active: boolean)
	local rainbow = self._RainbowVFX
	if rainbow then
		if active and marker and rainbow.Parent == marker then
			return
		end
		rainbow:Destroy()
		self._RainbowVFX = nil
	end
	if not active or not marker or not marker:IsA("BasePart") then
		return
	end

	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local event = vfx and vfx:FindFirstChild("Event")
	local template = event and event:FindFirstChild("RainbowVFX")
	local clone = template and template:IsA("Model") and template:Clone()
	if not clone then
		if not self._WarnedRainbowVFX then
			self._WarnedRainbowVFX = true
			warn("EventFishService: ReplicatedStorage.VFX.Event.RainbowVFX is missing or cannot be cloned")
		end
		return
	end

	for _, descendant in clone:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
		end
	end
	clone:PivotTo(marker:GetPivot() + Vector3.new(0, RAINBOW_VFX_Y_OFFSET, 0))
	self._RainbowVFX = clone
	clone.Parent = marker
end

function EventFishService:_updateMarker(snapshot, now: number)
	local areas = Workspace:FindFirstChild("Areas")
	local marker = areas and areas:FindFirstChild("EventFish")
	local active = snapshot.Phase == "Active"
	self:_updateRainbowVFX(marker, active)
	if not marker then
		if not self._WarnedMarker then
			self._WarnedMarker = true
			warn("EventFishService: Workspace.Areas.EventFish is missing")
		end
		return
	end
	if marker ~= self._Marker then
		self._Marker = marker
		table.clear(self._Effects)
	end
	local overhead = marker:FindFirstChild("Overhead")
	local content = overhead and overhead:FindFirstChild("Content")
	local header = content and content:FindFirstChild("Header")
	local time = content and content:FindFirstChild("Time")
	if header and header:IsA("TextLabel") then
		header.Text = if active then Config.ActiveHeader else Config.WaitingHeader
	end
	if time and time:IsA("TextLabel") then
		local deadline = if active then snapshot.EndsAt else snapshot.NextStartsAt
		time.Text = Config.FormatCountdown(deadline - now)
	end
	local rainbow = self._RainbowVFX
	for _, effect in marker:GetDescendants() do
		-- The cloned effects keep their authored Enabled settings.
		if rainbow and effect:IsDescendantOf(rainbow) then
			continue
		end
		if effect:IsA("Beam") or effect:IsA("ParticleEmitter") or effect:IsA("Light") then
			if self._Effects[effect] == nil then
				self._Effects[effect] = effect.Enabled
			end
			local enabled = active and self._Effects[effect]
			if effect:GetAttribute(Config.MarkerEnabledAttribute) ~= enabled then
				effect:SetAttribute(Config.MarkerEnabledAttribute, enabled)
			end
			effect.Enabled = enabled
		elseif effect:IsA("BillboardGui") and effect:GetAttribute(Config.MarkerEnabledAttribute) == nil then
			effect:SetAttribute(Config.MarkerEnabledAttribute, effect.Enabled)
		end
	end
end

function EventFishService:_evaluate(now: number)
	local window = Config.GetWindow(now)
	local fish
	local override = self._OverrideWindow
	if override and now < override.EndsAt then
		window = override
		fish = self._OverrideFish
	else
		self._OverrideWindow, self._OverrideFish = nil, nil
		if self._SlotId ~= window.SlotId then
			self._SlotId, self._SlotFish, self._Chosen = window.SlotId, nil, false
		end
		if now < window.EndsAt then
			if not self._Chosen then
				self._Chosen = true
				self._SlotFish = self:_chooseFish()
				if not self._SlotFish then
					warn("EventFishService: no Event fish has a valid model; skipping this window")
				end
			end
			fish = self._SlotFish
		end
	end
	local snapshot = {
		Phase = if fish then "Active" else "Waiting",
		SlotId = window.SlotId,
		FishId = if fish then fish.FishID else "",
		StartsAt = window.StartsAt,
		EndsAt = window.EndsAt,
		NextStartsAt = window.NextStartsAt,
	}
	self:_publish(snapshot)
	self:_updateMarker(snapshot, now)
	return fish
end

function EventFishService:GetActiveFish()
	return self:_evaluate(Workspace:GetServerTimeNow())
end

-- Server-only entry used by the authorized Cmdr command.
function EventFishService:StartEvent(fishId: string?)
	local fish = if fishId then FishesData[fishId] else self:_chooseFish()
	if not fish or fish.Rarity ~= "Event" or not Assets.GetFish(fish.Model) then
		return nil
	end
	local now = Workspace:GetServerTimeNow()
	self._OverrideRevision += 1
	self._OverrideWindow = {
		SlotId = -self._OverrideRevision,
		StartsAt = now,
		EndsAt = now + Config.Duration,
		NextStartsAt = Config.GetWindow(now).NextStartsAt,
	}
	self._OverrideFish = fish
	self:_evaluate(now)
	return fish
end

function EventFishService:StartDebugEvent(fishId: string?): boolean
	return RunService:IsStudio() and self:StartEvent(fishId) ~= nil
end

function EventFishService:KnitInit()
	self:_evaluate(Workspace:GetServerTimeNow())
end

function EventFishService:KnitStart()
	task.spawn(function()
		while true do
			self:_evaluate(Workspace:GetServerTimeNow())
			task.wait(0.25)
		end
	end)
end

return EventFishService
