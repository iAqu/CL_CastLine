-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()
local v2 = Signal.new()
local DestinationBeam = script:WaitForChild("DestinationBeam")
local v3 = nil
local t = {
	StopSignal = v2,
	GetTrackingId = function(p1) --[[ GetTrackingId | Line: 21 | Upvalues: v3 (ref) ]]
		return v3
	end,
	Stop = function(p1) --[[ Stop | Line: 25 | Upvalues: v3 (ref), v1 (copy) ]]
		v3 = nil
		v1:Destroy()
	end,
	Track = function(p1, p2, p3) --[[ Track | Line: 30 | Upvalues: UserPriority (copy), LocalPlayer (copy), v3 (ref), v1 (copy), DestinationBeam (copy), v2 (copy) ]]
		if UserPriority:IsTradePlaza() then
			return
		end
		local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		if HumanoidRootPart then
			v3 = p2
			v1:Clean()
			local v12 = DestinationBeam:Clone()
			local v22 = createPartAtCFrame(p3)
			v22.Parent = workspace
			local Attachment = Instance.new("Attachment")
			Attachment.Parent = HumanoidRootPart
			Attachment.WorldCFrame = HumanoidRootPart.CFrame
			local Attachment_2 = Instance.new("Attachment")
			Attachment_2.Parent = v22
			Attachment_2.WorldCFrame = v22.CFrame
			v12.Attachment0 = Attachment
			v12.Attachment1 = Attachment_2
			v12.Parent = v22
			v1:Add(function() --[[ Line: 62 | Upvalues: v12 (copy), Attachment (copy), Attachment_2 (copy), v22 (copy), v2 (ref) ]]
				v12:Destroy()
				Attachment:Destroy()
				Attachment_2:Destroy()
				v22:Destroy()
				v2:Fire()
			end)
		end
	end
}
function createPartAtCFrame(p1) --[[ createPartAtCFrame | Line: 72 ]]
	local Part = Instance.new("Part")
	Part.CFrame = p1
	Part.Transparency = 1
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanQuery = false
	Part.CanTouch = false
	Part.CastShadow = false
	Part.Size = Vector3.new(0.1, 0.1, 0.1)
	Part.CanTouch = false
	Part.Parent = workspace
	return Part
end
return t