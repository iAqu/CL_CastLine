-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Modules.ControllerLoader.TeleportController)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	RebirthLevel = 0,
	RebirthChanged = require(ReplicatedStorage.Shared.Packages.Signal).new()
}
function OnRebirthUpdate(p1) --[[ OnRebirthUpdate | Line: 19 | Upvalues: t (copy) ]]
	t.RebirthLevel = p1
	t.RebirthChanged:Fire(p1)
end
function t.RequestRebirth(p1) --[[ RequestRebirth | Line: 26 | Upvalues: Network (copy) ]]
	Network.FireServer("RebirthRequest")
end
function t._init() --[[ _init | Line: 31 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("RebirthUpdate"):Connect(OnRebirthUpdate)
end
return t