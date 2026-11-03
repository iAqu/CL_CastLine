-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local OfflineFrame = require(ReplicatedStorage.Modules.UILoader.OfflineFrame)
require(ReplicatedStorage.Shared.Data.Types)
local t = {}
function OnOfflineUpdate(p1) --[[ OnOfflineUpdate | Line: 23 | Upvalues: InfiniteMath (copy), OfflineFrame (copy) ]]
	if p1 then
		OfflineFrame:DisplayOffline((InfiniteMath.new(p1)))
	end
end
function OnClose() --[[ OnClose | Line: 31 | Upvalues: OfflineFrame (copy) ]]
	OfflineFrame:Close()
end
function t._init(p1) --[[ _init | Line: 37 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("Offline_Update"):Connect(OnOfflineUpdate)
	Network.OnClientEvent("Offline_Force"):Connect(OnClose)
end
return t