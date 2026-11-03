-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	Changed = require(ReplicatedStorage.Shared.Packages.Signal).new(),
	Friends = {}
}
function OnUpdate(p1) --[[ OnUpdate | Line: 15 | Upvalues: t (copy) ]]
	t.Friends = p1
	t.Changed:Fire(p1)
end
function UpdateServerOnFriend(p1) --[[ UpdateServerOnFriend | Line: 20 | Upvalues: Players (copy), Network (copy) ]]
	if p1 and p1.Parent == Players then
		Network.FireServer("CheckFriend", p1)
	end
end
function InitClientEvents() --[[ InitClientEvents | Line: 28 | Upvalues: StarterGui (copy) ]]
	task.spawn(function() --[[ Line: 29 | Upvalues: StarterGui (ref) ]]
		local v1
		repeat
			task.wait(1)
			local v2
			v2, v1 = pcall(function() --[[ Line: 34 | Upvalues: StarterGui (ref) ]]
				return StarterGui:GetCore("PlayerUnfriendedEvent")
			end)
		until v2
		v1.Event:Connect(UpdateServerOnFriend)
	end)
	task.spawn(function() --[[ Line: 42 | Upvalues: StarterGui (ref) ]]
		local v1
		repeat
			task.wait(1)
			local v2
			v2, v1 = pcall(function() --[[ Line: 47 | Upvalues: StarterGui (ref) ]]
				return StarterGui:GetCore("PlayerFriendedEvent")
			end)
		until v2
		v1.Event:Connect(UpdateServerOnFriend)
	end)
end
function t._init() --[[ _init | Line: 56 | Upvalues: Network (copy) ]]
	InitClientEvents()
	Network.OnClientEvent("FriendsUPD"):Connect(OnUpdate)
end
return t