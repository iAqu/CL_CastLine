local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local EventsData = require(ReplicatedFirst.Data.EventsData)
local EventConfig = require(ReplicatedStorage.Modules.EventConfig)

local EventStateUtil = {}

function EventStateUtil.NormalizeEventType(value: unknown): string?
	if typeof(value) ~= "string" then
		return nil
	end
	local normalized = string.lower(value)
	if normalized == "mutation" or normalized == "moreitem" then
		return normalized
	end
	return nil
end

function EventStateUtil.GetStateFolder(): Folder?
	local folder = ReplicatedStorage:FindFirstChild(EventConfig.STATE_FOLDER_NAME)
	return if folder and folder:IsA("Folder") then folder else nil
end

function EventStateUtil.GetActiveEvent(stateFolder: Folder?, timestamp: number?)
	if not stateFolder then
		return nil
	end
	local attributes = EventConfig.STATE_ATTRIBUTE
	if stateFolder:GetAttribute(attributes.PHASE) ~= EventConfig.PHASE.ACTIVE then
		return nil
	end
	local eventId = stateFolder:GetAttribute(attributes.EVENT_ID)
	local endsAt = stateFolder:GetAttribute(attributes.ENDS_AT)
	local now = timestamp or Workspace:GetServerTimeNow()
	if typeof(eventId) ~= "string"
		or typeof(endsAt) ~= "number"
		or endsAt <= now
	then
		return nil
	end
	return EventsData[eventId]
end

return EventStateUtil
