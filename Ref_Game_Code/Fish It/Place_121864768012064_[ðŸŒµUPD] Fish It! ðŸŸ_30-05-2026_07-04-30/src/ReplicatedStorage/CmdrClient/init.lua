-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Shared = script:WaitForChild("Shared")
local Util = require(Shared:WaitForChild("Util"))
local UserPriority = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("UserPriority"))
if RunService:IsClient() == false then
	error("Server scripts cannot require the client library. Please require the server library to use Cmdr in your own code.")
end
local v1 = if UserPriority:GetPriorityLevel(LocalPlayer) >= 3 then {
	[Enum.KeyCode.F2] = true
} else {}
local v2 = setmetatable({
	Enabled = true,
	MashToEnable = false,
	ActivationUnlocksMouse = false,
	HideOnLostFocus = true,
	PlaceName = "Cmdr",
	ReplicatedRoot = script,
	RemoteFunction = script:WaitForChild("CmdrFunction"),
	RemoteEvent = script:WaitForChild("CmdrEvent"),
	ActivationKeys = v1,
	Util = Util,
	Events = {}
}, {
	__index = function(p1, p2) --[[ __index | Line: 37 ]]
		local v1 = p1.Dispatcher[p2]
		if v1 and type(v1) == "function" then
			return function(p12, ...) --[[ Line: 40 | Upvalues: v1 (copy), p1 (copy) ]]
				return v1(p1.Dispatcher, ...)
			end
		end
	end
})
v2.Registry = require(Shared.Registry)(v2)
v2.Dispatcher = require(Shared.Dispatcher)(v2)
if StarterGui:WaitForChild("Cmdr") and (wait() and LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Cmdr") == nil) then
	StarterGui.Cmdr:Clone().Parent = LocalPlayer.PlayerGui
end
local v3 = require(script.CmdrInterface)(v2)
function v2.SetActivationKeys(p1, p2) --[[ SetActivationKeys | Line: 58 | Upvalues: Util (copy) ]]
	p1.ActivationKeys = Util.MakeDictionary(p2)
end
function v2.SetPlaceName(p1, p2) --[[ SetPlaceName | Line: 63 | Upvalues: v3 (copy) ]]
	p1.PlaceName = p2
	v3.Window:UpdateLabel()
end
function v2.SetEnabled(p1, p2) --[[ SetEnabled | Line: 69 ]]
	p1.Enabled = p2
end
function v2.SetActivationUnlocksMouse(p1, p2) --[[ SetActivationUnlocksMouse | Line: 74 ]]
	p1.ActivationUnlocksMouse = p2
end
function v2.Show(p1) --[[ Show | Line: 79 | Upvalues: v3 (copy) ]]
	if p1.Enabled then
		v3.Window:Show()
	end
end
function v2.Hide(p1) --[[ Hide | Line: 88 | Upvalues: v3 (copy) ]]
	v3.Window:Hide()
end
function v2.Toggle(p1) --[[ Toggle | Line: 93 | Upvalues: v3 (copy) ]]
	if p1.Enabled then
		v3.Window:SetVisible(not v3.Window:IsVisible())
	else
		return p1:Hide()
	end
end
function v2.SetMashToEnable(p1, p2) --[[ SetMashToEnable | Line: 102 ]]
	p1.MashToEnable = p2
	if not p2 then
		return
	end
	p1:SetEnabled(false)
end
function v2.SetHideOnLostFocus(p1, p2) --[[ SetHideOnLostFocus | Line: 111 ]]
	p1.HideOnLostFocus = p2
end
function v2.HandleEvent(p1, p2, p3) --[[ HandleEvent | Line: 116 ]]
	p1.Events[p2] = p3
end
if RunService:IsServer() == false then
	v2.Registry:RegisterTypesIn(script:WaitForChild("Types"))
	v2.Registry:RegisterCommandsIn(script:WaitForChild("Commands"))
end
v2.RemoteEvent.OnClientEvent:Connect(function(p1, ...) --[[ Line: 127 | Upvalues: v2 (ref) ]]
	if not v2.Events[p1] then
		return
	end
	v2.Events[p1](...)
end)
require(script.DefaultEventHandlers)(v2)
return v2