local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Modules.EventFishConfig)
local Assets = require(ReplicatedStorage.Modules.FishingAssets)
local FishesData = require(ReplicatedFirst.Data.FishesData)
local Knit = require(ReplicatedStorage.Packages.Knit)

local EventFishService = Knit.CreateService({
	Name = "EventFishService",
	Client = {},
	_Random = Random.new(),
	_Revision = 0,
	_OverrideRevision = 0,
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

function EventFishService:_evaluate(now: number)
	local window = Config.GetWindow(now)
	local fish
	local override = self._OverrideWindow
	if override and now >= override.StartsAt and now < override.EndsAt then
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
	return fish, if fish then snapshot else nil
end

function EventFishService:GetActiveFish(now: number?)
	return self:_evaluate(now or Workspace:GetServerTimeNow())
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
