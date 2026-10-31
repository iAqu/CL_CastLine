local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local REMOTE_NAME = "TideDebugRemote"

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if remote and not remote:IsA("RemoteEvent") then
    warn("TideDebug: ReplicatedStorage." .. REMOTE_NAME .. " is not a RemoteEvent")
    return
end

if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = REMOTE_NAME
    remote.Parent = ReplicatedStorage
end

local TideService = require(ServerScriptService.Services.TideService)

remote.OnServerEvent:Connect(function(_, tide: unknown)
    if not RunService:IsStudio() then
        warn("TideDebug: ignored tide change outside Studio")
        return
    end
    if tide == "TogglePause" then
        TideService:TogglePause()
        return
    end
    if tide == "InstantHigh" then
        TideService:ForceInstantTideTarget("High")
        return
    end
    if tide == "InstantLow" then
        TideService:ForceInstantTideTarget("Low")
        return
    end
    if tide ~= "High" and tide ~= "Low" then
        warn("TideDebug: unsupported tide state", tide)
        return
    end

    TideService:ForceTideTarget(tide)
end)
