-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Assets = ReplicatedStorage:WaitForChild("Assets")
local v1 = Assets:WaitForChild("Core Boat Assets")
Assets:WaitForChild("Boats")
local ProximityPrompt = v1:WaitForChild("ProximityPrompt")
local t = {
	VehicleSeat = Enum.KeyCode.DPadUp,
	Seat = Enum.KeyCode.DPadDown
}
local v2 = nil
local function onOccupantChanged(p1, p2) --[[ onOccupantChanged | Line: 33 | Upvalues: Players (copy), LocalPlayer (copy), ProximityPromptService (copy) ]]
	local Occupant = p1.Occupant
	if Occupant then
		p2.Enabled = false
	else
		p1.Disabled = true
		p2.Enabled = true
	end
	local v1 = if Occupant then Occupant.Parent else Occupant
	local v2 = if v1 then Players:GetPlayerFromCharacter(v1) else v1
	if v2 and v2 == LocalPlayer then
		ProximityPromptService.Enabled = false
	else
		ProximityPromptService.Enabled = true
	end
	if not Occupant then
		return
	end
	local SitSound = p1:FindFirstChild("SitSound")
	if not SitSound then
		return
	end
	local v3 = workspace:GetServerTimeNow()
	if not ((p1:GetAttribute("SeatTimer") or 0) <= v3) then
		return
	end
	p1:SetAttribute("SeatTimer", v3 + 5)
	SitSound:Play()
end
local function promptTriggered(p1, p2) --[[ promptTriggered | Line: 66 | Upvalues: LocalPlayer (copy), v2 (ref), ReplicatedStorage (copy) ]]
	if p2 ~= LocalPlayer then
		return
	end
	if not p2.Character then
		return
	end
	if p1:IsA("VehicleSeat") then
		local v1 = p1.Parent
		if not v1 then
			return
		end
		if v1:GetAttribute("OwnerId") ~= p2.UserId then
			if v2 then
				v2:DeliverNotification({
					Type = "Text",
					Text = "You do not own this boat!",
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
				return
			end
			v2 = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("TextNotificationController"))
			v2:DeliverNotification({
				Type = "Text",
				Text = "You do not own this boat!",
				TextColor = {
					R = 255,
					G = 0,
					B = 0
				}
			})
			return
		end
	end
	local v22 = p2.Character:FindFirstChildWhichIsA("Humanoid")
	if v22 then
		p1.Disabled = false
		p1:Sit(v22)
		return true
	end
end
return function(p1, p2) --[[ DrawSeatUtility | Line: 104 | Upvalues: ProximityPrompt (copy), t (copy), onOccupantChanged (copy), promptTriggered (copy), ProximityPromptService (copy) ]]
	p1.Disabled = true
	local v1 = ProximityPrompt:Clone()
	v1.GamepadKeyCode = t[p1.ClassName] or Enum.KeyCode.DPadDown
	v1.ObjectText = p1.Parent and p1.Parent.Name or "???"
	v1.ActionText = p2
	local v4 = p1:GetPropertyChangedSignal("Occupant"):Connect(function() --[[ Line: 115 | Upvalues: onOccupantChanged (ref), p1 (copy), v1 (copy) ]]
		onOccupantChanged(p1, v1)
	end)
	onOccupantChanged(p1, v1)
	local v5 = v1.Triggered:Connect(function(p12) --[[ Line: 122 | Upvalues: p1 (copy), promptTriggered (ref) ]]
		if not p1.Occupant then
			promptTriggered(p1, p12)
		end
	end)
	p1.Destroying:Once(function() --[[ Line: 130 | Upvalues: ProximityPromptService (ref) ]]
		ProximityPromptService.Enabled = true
	end)
	v1.Destroying:Once(function() --[[ Line: 134 | Upvalues: v4 (copy), v5 (copy) ]]
		v4:Disconnect()
		v5:Disconnect()
	end)
	v1.Enabled = true
	v1.Parent = p1
end