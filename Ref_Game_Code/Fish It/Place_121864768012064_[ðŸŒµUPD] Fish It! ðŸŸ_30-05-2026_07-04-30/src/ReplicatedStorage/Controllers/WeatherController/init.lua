-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(script.Internal.Types)
local Device = require(ReplicatedStorage.Modules.Device)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local EventUtility = require(ReplicatedStorage.Shared.EventUtility)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local Internal = script:WaitForChild("Internal")
local DisabledLocations = require(Internal:WaitForChild("DisabledLocations"))
local LocalPlayer = Players.LocalPlayer
local Events = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Events")
local Events_2 = Events.Frame.Events
local t = {}
local t2 = {}
local t3 = {}
local t4 = {
	Start = function(p1) --[[ Start | Line: 33 | Upvalues: Replion (copy), t3 (ref), Loader (copy), LocalPlayer (copy), DisabledLocations (copy), Device (copy) ]]
		local v1 = Replion.Client:WaitReplion("Events")
		t3 = Loader.LoadChildren(script.Weather)
		for k, v in pairs((v1:GetExpect("Events"))) do
			task.spawn(OnInsert, k, v)
		end
		v1:OnArrayInsert("Events", OnInsert)
		v1:OnArrayRemove("Events", OnRemove)
		LocalPlayer:GetAttributeChangedSignal("InCutscene"):Connect(function() --[[ Line: 48 | Upvalues: LocalPlayer (ref) ]]
			if LocalPlayer:GetAttribute("InCutscene") then
				Pause()
			else
				Resume()
			end
		end)
		LocalPlayer:GetAttributeChangedSignal("LocationName"):Connect(function() --[[ Line: 57 | Upvalues: LocalPlayer (ref), DisabledLocations (ref) ]]
			local v1 = LocalPlayer:GetAttribute("LocationName")
			if v1 and table.find(DisabledLocations, v1) then
				Pause()
			else
				Resume()
			end
		end)
		Device:RegisterDeviceChanged(DeviceChanged)
		DeviceChanged()
	end
}
function DeviceChanged() --[[ DeviceChanged | Line: 71 | Upvalues: Device (copy), Events (copy) ]]
	if not Device:IsMobile() then
		return
	end
	Events.UIPadding.PaddingLeft = UDim.new(0, 20)
	Events.UIPadding.PaddingRight = UDim.new(0, 20)
end
function HasActiveWeatherObject(p1) --[[ HasActiveWeatherObject | Line: 78 | Upvalues: t (copy) ]]
	for k, v in pairs(t) do
		if v.Event == p1 and v:IsActive() then
			return true
		end
	end
	return false
end
function OnInsert(p1, p2) --[[ OnInsert | Line: 87 | Upvalues: EventUtility (copy), t3 (ref), LocalPlayer (copy), DisabledLocations (copy), t (copy), Events_2 (copy), t2 (copy), ToolTip (copy), TextNotificationController (copy) ]]
	local v1 = EventUtility:GetEvent(p2)
	if not v1 or HasActiveWeatherObject(p2) then
		return
	end
	if t3[p2] then
		local v2 = t3[p2].new()
		v2:Start()
		local v3 = LocalPlayer:GetAttribute("LocationName")
		if v3 and table.find(DisabledLocations, v3) then
			v2:Pause()
		end
		table.insert(t, v2)
	end
	local v5 = Events_2:FindFirstChild(p2)
	if v5 then
		v5.Visible = true
		t2[v5] = ToolTip.observe(v5, nil, function() --[[ Line: 108 | Upvalues: v1 (copy), p2 (copy) ]]
			local t = {
				Style = "Label"
			}
			t.Text = v1.Description or p2 or "???"
			return t
		end)
	end
	if p2 ~= "Galaxy" then
		return
	end
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = "Tip: Galaxy weather increases cosmic fish odds!",
		CustomDuration = 7,
		TextColor = {
			R = 179,
			G = 143,
			B = 255
		}
	})
end
function OnRemove(p1, p2) --[[ OnRemove | Line: 126 | Upvalues: t (copy), Events_2 (copy), t2 (copy) ]]
	local v1 = nil
	local v2 = nil
	for k, v in pairs(t) do
		if v.Event == p2 then
			v1 = v
			v2 = k
			break
		end
	end
	if v1 then
		v1:Stop()
		table.remove(t, v2)
	end
	local v3 = Events_2:FindFirstChild(p2)
	if not v3 then
		return
	end
	v3.Visible = false
	local v4 = t2[v3]
	if v4 then
		task.defer(v4)
		return
	end
	warn("Failed to find ToolTip cleanup!")
end
function Pause() --[[ Pause | Line: 157 | Upvalues: t (copy) ]]
	for k, v in pairs(t) do
		if v:IsActive() then
			v:Pause()
		end
	end
end
function Resume() --[[ Resume | Line: 164 | Upvalues: t (copy) ]]
	for k, v in pairs(t) do
		if not v:IsActive() then
			v:Resume()
		end
	end
end
return t4