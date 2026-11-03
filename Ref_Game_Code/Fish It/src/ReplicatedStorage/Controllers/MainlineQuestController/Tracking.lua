-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local Quests = require(ReplicatedStorage.Modules.Quests)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()
local DestinationBeam = script:WaitForChild("DestinationBeam")
local NPCTracker = script:WaitForChild("NPCTracker")
local v2 = nil
local v3 = nil
local v4 = nil
local v5 = nil
local v6 = nil
local function createPartAtCFrame(p1) --[[ createPartAtCFrame | Line: 37 ]]
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
local t = {
	Position = function(p1, p2) --[[ Position | Line: 54 | Upvalues: DestinationBeam (copy), RunService (copy), v1 (copy) ]]
		local PrimaryPart = p1.PrimaryPart
		if PrimaryPart then
			local Terrain = workspace:WaitForChild("Terrain")
			local v12 = DestinationBeam:Clone()
			local Part = Instance.new("Part")
			Part.CFrame = p2
			Part.Transparency = 1
			Part.Anchored = true
			Part.CanCollide = false
			Part.CanQuery = false
			Part.CanTouch = false
			Part.CastShadow = false
			Part.Size = Vector3.new(0.1, 0.1, 0.1)
			Part.CanTouch = false
			Part.Parent = workspace
			local v2 = Part
			v2.Parent = Terrain
			local Attachment = Instance.new("Attachment")
			Attachment.Parent = PrimaryPart
			Attachment.WorldCFrame = PrimaryPart.CFrame
			local Attachment_2 = Instance.new("Attachment")
			Attachment_2.Parent = v2
			Attachment_2.WorldCFrame = v2.CFrame
			v12.Attachment0 = Attachment
			v12.Attachment1 = Attachment_2
			v12.Parent = v2
			RunService:BindToRenderStep("UpdateArrow", Enum.RenderPriority.Camera.Value, function(p12) --[[ Line: 80 | Upvalues: p1 (copy), PrimaryPart (copy), RunService (ref), Attachment_2 (copy), v12 (copy) ]]
				if not p1 or PrimaryPart ~= p1.PrimaryPart then
					RunService:UnbindFromRenderStep("UpdateArrow")
					return
				end
				local Magnitude = (PrimaryPart.Position - Attachment_2.WorldPosition).Magnitude
				if Magnitude < 45 then
					v12.Transparency = NumberSequence.new((math.min((45 - Magnitude) / 45 + 0.1, 0.5)))
				else
					v12.Transparency = NumberSequence.new(0)
				end
			end)
			v1:Add(function() --[[ Line: 96 | Upvalues: RunService (ref), v12 (copy), Attachment (copy), Attachment_2 (copy), v2 (copy) ]]
				RunService:UnbindFromRenderStep("UpdateArrow")
				v12:Destroy()
				Attachment:Destroy()
				Attachment_2:Destroy()
				v2:Destroy()
			end)
		end
	end,
	NPC = function(p1, p2) --[[ NPC | Line: 106 | Upvalues: NPCTracker (copy), DestinationBeam (copy), RunService (copy), v1 (copy), LocalPlayer (copy) ]]
		local PrimaryPart = p1.PrimaryPart
		if not PrimaryPart then
			return
		end
		local v12 = workspace:WaitForChild("NPC"):WaitForChild(p2)
		if not v12 then
			return
		end
		local Head = v12:WaitForChild("Head")
		if not Head then
			return
		end
		local Terrain = workspace:WaitForChild("Terrain")
		local v2 = v12:GetPivot()
		local v3 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#9cfff0")), ColorSequenceKeypoint.new(0.256, Color3.fromHex("#9cfff0")), ColorSequenceKeypoint.new(1, Color3.fromHex("#57e3ff")) })
		local v4 = NPCTracker:Clone()
		local Frame = v4.Frame.Frame.Frame
		local Distance = v4.Frame.Distance
		Frame.UIGradient.Color = v3
		Frame.UIStroke.UIGradient.Color = v3
		v4.Frame.Glow.UIGradient.Color = v3
		Distance.UIGradient.Color = v3
		local v5 = DestinationBeam:Clone()
		v5.Color = v3
		local v6 = CFrame.new(v2.Position)
		local Part = Instance.new("Part")
		Part.CFrame = v6
		Part.Transparency = 1
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanQuery = false
		Part.CanTouch = false
		Part.CastShadow = false
		Part.Size = Vector3.new(0.1, 0.1, 0.1)
		Part.CanTouch = false
		Part.Parent = workspace
		local v7 = Part
		v7.Parent = Terrain
		local Attachment = Instance.new("Attachment")
		Attachment.Parent = PrimaryPart
		Attachment.WorldCFrame = PrimaryPart.CFrame
		local Attachment_2 = Instance.new("Attachment")
		Attachment_2.Parent = v7
		Attachment_2.WorldCFrame = v7.CFrame
		v5.Attachment0 = Attachment
		v5.Attachment1 = Attachment_2
		v5.Parent = v7
		local function updateDistance() --[[ updateDistance | Line: 162 | Upvalues: p1 (copy), PrimaryPart (copy), RunService (ref), v2 (copy), Distance (copy) ]]
			if not p1 or PrimaryPart ~= p1.PrimaryPart then
				RunService:UnbindFromRenderStep("UpdateArrow")
				return
			end
			local Magnitude = (PrimaryPart.Position - v2.Position).Magnitude
			Distance.Text = ("%*M"):format(if Magnitude < 12 then 0 else math.floor(Magnitude * 0.28))
		end
		RunService:BindToRenderStep("UpdateDistance", Enum.RenderPriority.Camera.Value, updateDistance)
		v1:Add(function() --[[ Line: 183 | Upvalues: RunService (ref), v4 (copy), v5 (copy), Attachment (copy), Attachment_2 (copy), v7 (copy) ]]
			RunService:UnbindFromRenderStep("UpdateDistance")
			v4:Destroy()
			v5:Destroy()
			Attachment:Destroy()
			Attachment_2:Destroy()
			v7:Destroy()
		end)
		if p1 and PrimaryPart == p1.PrimaryPart then
			local Magnitude = (PrimaryPart.Position - v2.Position).Magnitude
			Distance.Text = ("%*M"):format(if Magnitude < 12 then 0 else math.floor(Magnitude * 0.28))
		else
			RunService:UnbindFromRenderStep("UpdateArrow")
		end
		v4.Adornee = Head
		v4.Parent = LocalPlayer.PlayerGui
		v4.Enabled = true
	end
}
local t2 = {
	GetLastQuestName = function(p1) --[[ GetLastQuestName | Line: 204 | Upvalues: v5 (ref) ]]
		return v5
	end
}
function t2.Resume(p1) --[[ Resume | Line: 208 | Upvalues: v2 (ref), v3 (ref), v4 (ref), t2 (copy) ]]
	if v2 and (v3 and v4) then
		local v1 = table.pack(v2, v3, v4, false)
		t2:Stop()
		t2:Track(table.unpack(v1))
		return true
	else
		return false
	end
end
function t2.Stop(p1) --[[ Stop | Line: 221 | Upvalues: v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v1 (copy) ]]
	v2 = nil
	v3 = nil
	v4 = nil
	v5 = nil
	v6 = nil
	v1:Destroy()
end
function t2.Track(p1, p2, p3, p4, p5) --[[ Track | Line: 228 | Upvalues: UserPriority (copy), v6 (ref), Quests (copy), LocalPlayer (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v1 (copy), t2 (copy), t (copy), TextNotificationController (copy) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	local v12 = ("%*%*"):format(p3, p4)
	if v6 == v12 then
		return
	end
	local v22 = Quests[p2][p3]
	if not v22 then
		return
	end
	local Character = LocalPlayer.Character
	if not Character:WaitForChild("HumanoidRootPart") then
		return
	end
	v2 = p2
	v3 = p3
	v4 = p4
	v5 = p3
	v6 = v12
	v1:Clean()
	local v32, v42 = t2:_getQuestCFrame(v22, p4)
	local v52 = if v32 then t[v32] else nil
	if v52 then
		v52(Character, v42)
	end
	if not p5 then
		return
	end
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = "Tracking quest!",
		CustomDuration = 0.75,
		TextColor = {
			R = 0,
			G = 255,
			B = 0
		}
	})
end
function t2._getQuestCFrame(p1, p2, p3) --[[ _getQuestCFrame | Line: 272 | Upvalues: LocalPlayer (copy) ]]
	local v1 = p2.Objectives[p3]
	if not v1 then
		return
	end
	local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end
	if v1.TrackNPC then
		return "NPC", v1.TrackNPC
	end
	if p2.TrackNPC then
		return "NPC", p2.TrackNPC
	end
	local v2 = nil
	if typeof(v1.TrackQuestCFrame) == "table" then
		if HumanoidRootPart then
			local Position = HumanoidRootPart.Position
			table.sort(v1.TrackQuestCFrame, function(p1, p2) --[[ Line: 296 | Upvalues: Position (copy) ]]
				return (p1.Position - Position).Magnitude < (p2.Position - Position).Magnitude
			end)
			local v3 = v1.TrackQuestCFrame[1]
			if v3 then
				v2 = v3
			end
		else
			local v4 = math.random(1, #v1.TrackQuestCFrame)
			if v4 then
				v2 = v1.TrackQuestCFrame[v4]
			end
		end
	elseif typeof(v1.TrackQuestCFrame) == "CFrame" then
		v2 = v1.TrackQuestCFrame
	end
	if v2 then
		return "Position", v2
	end
end
return t2