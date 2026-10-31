local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local REMOTE_NAME = "EventDebugRemote"

if not RunService:IsStudio() then
	return
end

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if remote and not remote:IsA("RemoteEvent") then
	warn("EventDebug: ReplicatedStorage." .. REMOTE_NAME .. " is not a RemoteEvent")
	return
end

if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = REMOTE_NAME
	remote.Parent = ReplicatedStorage
end

local EventService = require(ServerScriptService.Services.EventService)

remote.OnServerEvent:Connect(function(_, eventId: unknown)
	if typeof(eventId) ~= "string" then
		warn("EventDebug: unsupported event id", eventId)
		return
	end
	if not EventService:StartDebugEvent(eventId) then
		warn("EventDebug: unsupported event id", eventId)
	end
end)
