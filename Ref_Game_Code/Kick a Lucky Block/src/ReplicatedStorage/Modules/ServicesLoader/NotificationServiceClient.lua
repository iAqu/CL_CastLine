-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
require(ReplicatedStorage.Shared.Packages.Signal)
local NotificationController = require(ReplicatedStorage.Modules.ControllerLoader.NotificationController)
local t = {}
function OnServerNotification(p1, p2) --[[ OnServerNotification | Line: 17 | Upvalues: NotificationController (copy) ]]
	NotificationController:Create(p1, p2)
end
function t._init(p1) --[[ _init | Line: 23 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("NotificationUpdate"):Connect(OnServerNotification)
end
return t