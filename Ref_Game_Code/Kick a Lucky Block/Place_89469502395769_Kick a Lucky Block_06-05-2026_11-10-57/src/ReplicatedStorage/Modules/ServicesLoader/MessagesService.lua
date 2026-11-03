-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local MessageStyles = require(ReplicatedStorage.Shared.Data.MessageStyles)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local Messages = script:WaitForChild("Messages")
local v1 = MessageStyles.Default.Name
local t = {
	StackedTimes = {},
	Messages = {},
	Threads = {}
}
function UpdateMessage(p1, p2, p3) --[[ UpdateMessage | Line: 28 ]]
	p1.MessageLabel.Text = ("%* (x%*)"):format(p2, p3)
end
function OnDestroy(p1) --[[ OnDestroy | Line: 32 | Upvalues: t (copy) ]]
	t.StackedTimes[p1] = nil
	t.Messages[p1] = nil
end
function BuildMessage(p1, p2) --[[ BuildMessage | Line: 37 ]]
	local v1 = script:FindFirstChild(p2)
	if v1 then
		local v2 = v1:Clone()
		v2:WaitForChild("MessageLabel").Text = p1
		v2.MessageLabel:WaitForChild("UIStroke")
		return v2
	end
end
function t.PlayMessage(p1, p2, p3, ...) --[[ PlayMessage | Line: 52 | Upvalues: v1 (copy), MessageStyles (copy), Messages (copy) ]]
	local v2 = MessageStyles[p3 or v1]
	local v3 = v2.Type or "Default"
	local v4
	if v2.Stackable and (p1.Messages[p2] and (p1.Threads[p2] and coroutine.status(p1.Threads[p2]) ~= "running")) then
		task.cancel(p1.Threads[p2])
		v4 = p1.Messages[p2]
		p1.StackedTimes[p2] = (p1.StackedTimes[p2] or 1) + 1
		UpdateMessage(v4, p2, p1.StackedTimes[p2])
	else
		v4 = BuildMessage(p2, v3)
		p1.Messages[p2] = v4
	end
	if v2.TransformFunction then
		v2.TransformFunction(v4, ...)
	end
	if v2.Setup then
		v2.Setup(v4)
	end
	if v2.Sound then
		v2.Sound:Play()
	end
	p1.Threads[p2] = task.delay(v2.Time, function() --[[ Line: 84 | Upvalues: v2 (copy), v4 (ref), p2 (copy) ]]
		if v2.Destroy then
			v2.Destroy(v4)
		else
			v4.Visible = false
		end
		v4:Destroy()
		OnDestroy(p2)
	end)
	task.spawn(function() --[[ Line: 94 | Upvalues: v4 (ref), Messages (ref), v2 (copy) ]]
		v4.Parent = Messages.MessagesFrame
		if v2.Show then
			v2.Show(v4)
		else
			v4.Visible = true
		end
	end)
end
function InitializeGUI() --[[ InitializeGUI | Line: 104 | Upvalues: Messages (copy), PlayerGui (copy) ]]
	Messages.Parent = PlayerGui
end
function t._init() --[[ _init | Line: 108 | Upvalues: Network (copy), t (copy) ]]
	InitializeGUI()
	Network.OnClientEvent("PlayMessage"):Connect(function(...) --[[ Line: 111 | Upvalues: t (ref) ]]
		t:PlayMessage(...)
	end)
end
return t