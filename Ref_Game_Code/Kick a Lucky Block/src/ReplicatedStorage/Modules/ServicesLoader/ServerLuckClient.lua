-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local v1 = Network.CreateRemote("sl_upd")
local t = {
	Luck = 1,
	EndTime = nil,
	Changed = Signal.new(),
	GlobalLuck = 1,
	GlobalEndTime = nil
}
function OnUpdate(p1, p2, p3, p4) --[[ OnUpdate | Line: 21 | Upvalues: t (copy) ]]
	t.Luck = p1
	t.EndTime = p2
	t.GlobalLuck = p3
	t.GlobalEndTime = p4
	t.Changed:Fire(p1, p2, p3, p4)
end
function t._init() --[[ _init | Line: 33 | Upvalues: Network (copy), v1 (copy) ]]
	Network.OnClientEvent(v1):Connect(OnUpdate)
end
return t