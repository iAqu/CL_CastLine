-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	Pity = {},
	PityChanged = require(ReplicatedStorage.Shared.Packages.Signal).new()
}
function OnUpdate(p1) --[[ OnUpdate | Line: 19 | Upvalues: t (copy) ]]
	t.Pity = if p1 then p1 else {}
end
function t._init(p1) --[[ _init | Line: 25 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("PackData"):Connect(OnUpdate)
end
return t