-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local TextChannels = TextChatService:WaitForChild("TextChannels")
local RBXGeneral = TextChannels:WaitForChild("RBXGeneral")
local v1 = nil
local v2 = nil
local t = {}
task.spawn(function() --[[ Line: 23 | Upvalues: RunService (copy), TextChannels (copy), Observers (copy), t (copy), UserPriority (copy), v1 (ref), v2 (ref) ]]
	if RunService:IsServer() then
		local function addChannel(p1) --[[ addChannel | Line: 25 | Upvalues: TextChannels (ref), Observers (ref) ]]
			local TextChannel = Instance.new("TextChannel")
			TextChannel.Name = p1
			TextChannel.Parent = TextChannels
			Observers.observePlayer(function(p1_2_2) --[[ Line: 30 | Upvalues: TextChannel (copy) ]]
				TextChannel:AddUserAsync(p1_2_2.UserId)
			end)
			return TextChannel
		end
		local TextChannel = Instance.new("TextChannel")
		TextChannel.Name = "Global Alerts"
		TextChannel.Parent = TextChannels
		Observers.observePlayer(function(p1_2_2) --[[ Line: 30 | Upvalues: TextChannel (copy) ]]
			TextChannel:AddUserAsync(p1_2_2.UserId)
		end)
		t.Global = TextChannel
		if UserPriority:IsTradePlaza() then
			local TextChannel_2 = Instance.new("TextChannel")
			TextChannel_2.Name = "Booth Sales"
			TextChannel_2.Parent = TextChannels
			Observers.observePlayer(function(p1_2_2) --[[ Line: 30 | Upvalues: TextChannel_2 (copy) ]]
				TextChannel_2:AddUserAsync(p1_2_2.UserId)
			end)
			t.Booth = TextChannel_2
		end
	else
		v1 = TextChannels:WaitForChild("Global Alerts")
		t.Global = v1
		v2 = TextChannels:WaitForChild("Booth Sales", 3600)
		t.Booth = v2
	end
end)
local v3 = Net:RemoteEvent("DisplaySystemMessage")
local t2 = {}
function t2.FormatSystemMessage(p1, p2, p3) --[[ FormatSystemMessage | Line: 74 | Upvalues: t2 (copy) ]]
	local v1
	if p3.tag then
		local v2 = p3.tag.color or p3.color
		local v8 = ("rgb(%*, %*, %*)"):format(math.floor(v2.R * 255), math.floor(v2.G * 255), (math.floor(v2.B * 255)))
		v1 = if p3.tag.bold then ("<b><font size=\"%*\" color=\"%*\">[%*]: </font></b>"):format(p3.tag.size, v8, p3.tag.display) else ("<font color=\"%*\">[%*]: </font>"):format(v8, p3.tag.display)
	else
		v1 = ""
	end
	local v17 = ("rgb(%*, %*, %*)"):format(math.floor(p3.color.R * 255), math.floor(p3.color.G * 255), (math.floor(p3.color.B * 255)))
	t2:DisplaySystemMessage(p2, v1 .. (if p3.size then ("<font size=\"%*\" color=\"%*\">%%s</font>"):format(p3.size, v17) else ("<font color=\"%*\">%%s</font>"):format(v17)):format(p3.message))
end
function t2._displaySystemMessage(p1, p2, p3) --[[ _displaySystemMessage | Line: 105 | Upvalues: RunService (copy), t (copy), RBXGeneral (copy) ]]
	if RunService:IsServer() then
		return
	end
	if not p2 then
		warn("tried to send system message but it was nil?", p2)
		return
	end
	local v1 = if p3 then t[p3] else p3
	if v1 then
		v1:DisplaySystemMessage(p2)
	else
		RBXGeneral:DisplaySystemMessage(p2)
	end
end
function t2.DisplaySystemMessage(p1, p2, p3, p4) --[[ DisplaySystemMessage | Line: 123 | Upvalues: RunService (copy), v3 (copy) ]]
	if not RunService:IsServer() then
		return
	end
	if typeof(p2) == "Instance" and p2:IsA("Player") then
		return v3:FireClient(p2, p3, p4)
	else
		return v3:FireAllClients(p3, p4)
	end
end
function t2.DisplayServerNotification(p1, p2, p3) --[[ DisplayServerNotification | Line: 133 | Upvalues: RunService (copy), Players (copy), Replion (copy), v3 (copy) ]]
	if RunService:IsClient() then
		return
	end
	for i, v in ipairs(Players:GetPlayers()) do
		local v1 = Replion.Server:GetReplionFor(v, "Data")
		if v1 and v1:GetExpect("Settings")["Server Notifications"] then
			v3:FireClient(v, p2, p3)
		end
	end
end
function t2.DisplayGlobalNotification(p1, p2, p3) --[[ DisplayGlobalNotification | Line: 151 | Upvalues: RunService (copy), Players (copy), Replion (copy), v3 (copy) ]]
	if RunService:IsClient() then
		return
	end
	for i, v in ipairs(Players:GetPlayers()) do
		local v1 = Replion.Server:GetReplionFor(v, "Data")
		if v1 and v1:GetExpect("Settings")["Global Notifications"] then
			v3:FireClient(v, p2, p3)
		end
	end
end
if RunService:IsClient() then
	v3.OnClientEvent:Connect(function(...) --[[ Line: 170 | Upvalues: t2 (copy) ]]
		t2:_displaySystemMessage(...)
	end)
end
return t2