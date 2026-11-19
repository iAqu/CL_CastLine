local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")

local EventPresentationGate = require(ReplicatedStorage.Modules.EventPresentationGate)
local Loading = require(ReplicatedFirst.LoadingAttributes)
local Knit = require(ReplicatedStorage.Packages.Knit)

local player = Players.LocalPlayer
local PromptEventController = Knit.CreateController({
	Name = "PromptEventController",
})

local function canPrompt()
	return player:GetAttribute(Loading.PLAYER_DATA_LOADED) == true
		and player:GetAttribute(Loading.LOADING_SCREEN_DONE) == true
		and player:GetAttribute(Loading.INTRO_STARTUP_STATE) == Loading.INTRO_STATE.Skipped
		and not EventPresentationGate.IsSuppressed(player)
end

-- Return false when the presentation became blocked during a yielding lookup.
local function promptEvent()
	local ok, events = pcall(function()
		return SocialService:GetUpcomingExperienceEventsAsync()
	end)
	if not canPrompt() then
		return false
	end
	if not ok then
		warn("PromptEventController: could not get upcoming events", events)
		return true
	end
	for _, event in ipairs(events) do
		if not event.HasStarted and not event.HasEnded then
			local found, status = pcall(function()
				return SocialService:GetEventRsvpStatusAsync(event.Id)
			end)
			if not canPrompt() then
				return false
			end
			if not found then
				warn("PromptEventController: could not get event RSVP status", status)
			end
			if not found or status ~= Enum.RsvpStatus.Going then
				local shown, err = pcall(function()
					return SocialService:PromptRsvpToEventAsync(event.Id)
				end)
				if not shown then
					warn("PromptEventController: event RSVP prompt failed", err)
				end
			end
			break
		end
	end
	return true
end

function PromptEventController:KnitStart()
	local minimumDelayElapsed, running, finished = false, false, false
	local connections = {}
	local function attempt()
		if not minimumDelayElapsed or running or finished or not canPrompt() then
			return
		end
		running = true
		task.defer(function()
			finished = canPrompt() and promptEvent()
			running = false
			if finished then
				for _, connection in connections do
					connection:Disconnect()
				end
			end
		end)
	end
	for _, attribute in EventPresentationGate.Attributes do
		table.insert(connections, player:GetAttributeChangedSignal(attribute):Connect(attempt))
	end
	for _, attribute in { Loading.PLAYER_DATA_LOADED, Loading.LOADING_SCREEN_DONE, Loading.INTRO_STARTUP_STATE } do
		table.insert(connections, player:GetAttributeChangedSignal(attribute):Connect(attempt))
	end
	task.delay(2, function()
		minimumDelayElapsed = true
		attempt()
	end)
end

return PromptEventController
