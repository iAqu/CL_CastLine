-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {}
function get_remote_event(p1) --[[ get_remote_event | Line: 7 | Upvalues: RunService (copy) ]]
	local v1 = ("rev_%*"):format(p1)
	local v2 = script:FindFirstChild(v1)
	if v2 then
		return v2
	elseif RunService:IsClient() then
		return script:WaitForChild(v1)
	else
		local v3 = Instance.new("RemoteEvent")
		v3.Name = v1
		v3.Parent = script
		return v3
	end
end
function get_remote_function(p1) --[[ get_remote_function | Line: 24 | Upvalues: RunService (copy) ]]
	local v1 = ("ref_%*"):format(p1)
	local v2 = script:FindFirstChild(v1)
	if v2 then
		return v2
	elseif RunService:IsClient() then
		return script:WaitForChild(v1)
	else
		local v3 = Instance.new("RemoteFunction")
		v3.Name = v1
		v3.Parent = script
	end
end
function t.CreateRemote(p1) --[[ CreateRemote | Line: 40 ]]
	get_remote_event(p1)
	return p1
end
function t.CreateRemoteFunction(p1) --[[ CreateRemoteFunction | Line: 45 ]]
	get_remote_function(p1)
	return p1
end
function t.InvokeServer(p1, ...) --[[ InvokeServer | Line: 50 ]]
	return get_remote_function(p1):InvokeServer(...)
end
function t.OnServerInvoke(p1, p2) --[[ OnServerInvoke | Line: 55 ]]
	get_remote_function(p1).OnServerInvoke = p2
end
function t.FireServer(p1, ...) --[[ FireServer | Line: 60 ]]
	get_remote_event(p1):FireServer(...)
end
function t.FireClient(p1, p2, ...) --[[ FireClient | Line: 65 ]]
	get_remote_event(p2):FireClient(p1, ...)
end
function t.FireAllClients(p1, ...) --[[ FireAllClients | Line: 70 ]]
	get_remote_event(p1):FireAllClients(...)
end
function t.OnClientEvent(p1) --[[ OnClientEvent | Line: 75 ]]
	return get_remote_event(p1).OnClientEvent
end
function t.OnServerEvent(p1) --[[ OnServerEvent | Line: 80 ]]
	return get_remote_event(p1).OnServerEvent
end
return t