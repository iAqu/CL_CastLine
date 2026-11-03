-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local CurveUtil = require(ReplicatedStorage.Modules.Util.CurveUtil)
local CosmeticFolder = workspace:WaitForChild("CosmeticFolder")
workspace:WaitForChild("Zones")
local v1 = Net:RemoteEvent("BaitCastVisual")
local v2 = Net:RemoteEvent("BaitDestroyed")
local ModelDownloader = require(game.ReplicatedStorage.Modules.ModelDownloader)
local t = {}
local t2 = {}
local function MoveAlongCurve(p1, p2, p3, p4, p5) --[[ MoveAlongCurve | Line: 45 | Upvalues: RunService (copy) ]]
	local v1 = os.clock()
	local v2 = nil
	v2 = RunService.RenderStepped:Connect(function() --[[ Line: 50 | Upvalues: v1 (copy), p3 (copy), p2 (copy), p5 (copy), p1 (copy), v2 (ref), p4 (copy) ]]
		local v22_2 = math.min((os.clock() - v1) / p3, 1)
		local v3 = v22_2 * (#p2 - 1) + 1
		local v4 = math.floor(v3)
		local v7_2 = p2[v4]:Lerp(p2[math.min(v4 + 1, #p2)], v3 - v4)
		if p5 and (p1 and p1.Parent) then
			local Position = v7_2.Position
			local Unit = ((if v22_2 < 0.99 then p2[math.min(v4 + 2, #p2)].Position else p2[#p2].Position) - Position).Unit
			local v10 = Vector3.new(0, 1, 0)
			if math.abs((Unit:Dot(v10))) > 0.99 then
				v10 = Vector3.new(1, 0, 0)
			end
			local Unit_2 = Unit:Cross(v10).Unit
			local Unit_3 = Unit_2:Cross(Unit).Unit
			p1:PivotTo(CFrame.fromMatrix(Position, Unit_2, Unit_3, -Unit) * CFrame.Angles(0, 0, 0))
		elseif p1 and p1.Parent then
			p1:PivotTo(v7_2)
		end
		if not (v22_2 >= 1) then
			return
		end
		v2:Disconnect()
		if not p4 then
			return
		end
		p4()
	end)
	return v2
end
local function CreateBobAnimation(p1, p2, p3) --[[ CreateBobAnimation | Line: 123 | Upvalues: spr (copy), Soundbook (copy) ]]
	if not (p1 and p1.Parent) then
		return
	end
	local v1 = CFrame.new(p2)
	local v2 = CFrame.Angles(0, 0, 0)
	if p3 then
		v2 = CFrame.Angles(-1.5707963267948966, 0, 0)
	end
	p1:PivotTo(v1)
	spr.stop(p1)
	spr.target(p1, 70, 150, {
		Pivot = CFrame.new(p2) * CFrame.new(0, -2, 0) * v2
	})
	task.delay(1, function() --[[ Line: 149 | Upvalues: p1 (copy), spr (ref), p2 (copy), v2 (ref) ]]
		if p1.Parent then
			spr.stop(p1)
			spr.target(p1, 30, 60, {
				Pivot = CFrame.new(p2) * v2
			})
		end
	end)
	Soundbook:RenderAt("Water Splash", p2)
end
local function CreateBaitVisual(p1, p2) --[[ CreateBaitVisual | Line: 166 | Upvalues: ItemUtility (copy), ModelDownloader (copy), CurveUtil (copy), CosmeticFolder (copy), t (copy), CreateBobAnimation (copy), RunService (copy) ]]
	local Origin = p2.Origin
	local CastPosition = p2.CastPosition
	local Power = p2.Power
	local RodName = p2.RodName
	local CustomModel = p2.CustomModel
	local ConnectingJoint = p2.ConnectingJoint
	local EquippedToolModel = p2.EquippedToolModel
	local CosmeticTemplateId = p2.CosmeticTemplateId
	local v1 = ItemUtility:GetBaitData(p2.BaitIdentifier) or ItemUtility:GetBaitData(1)
	local v2
	if CosmeticTemplateId and CosmeticTemplateId > 0 then
		local v3 = ItemUtility:GetBaitData(CosmeticTemplateId)
		v2 = if v3 then ModelDownloader:Wait(v3.Data.Type, v3.Data.Id) else v3
	else
		v2 = nil
	end
	if not v2 and v1 then
		v2 = ModelDownloader:Wait(v1.Data.Type, v1.Data.Id)
	end
	if CustomModel then
		local v6 = script:FindFirstChild(RodName) or script.OceanicArrowModel
		if v6 then
			v2 = v6
		end
	end
	if not (v2 or CustomModel) then
		return
	end
	local v7 = v2:Clone()
	v7:SetAttribute("UseCosmeticBulletObject", true)
	v7.Anchored = true
	v7.Name = tostring(p1.UserId)
	local v8 = v7:FindFirstChildWhichIsA("Attachment")
	if not v8 then
		local BaitAttachment = Instance.new("Attachment")
		BaitAttachment.Name = "BaitAttachment"
		BaitAttachment.Parent = v7
		if v7:IsA("BasePart") then
			BaitAttachment.Position = Vector3.new(0, v7.Size.Y / 2, 0)
		end
		v8 = BaitAttachment
	end
	local t2 = {}
	if EquippedToolModel and ConnectingJoint then
		local Handle = EquippedToolModel:FindFirstChild("Handle")
		if Handle then
			local v10 = Handle:FindFirstChild((tostring(ConnectingJoint)))
			if v10 then
				v10.Attachment1 = v8
				v10.Enabled = true
				table.insert(t2, v10)
				for i = 1, 5 do
					local v11 = Handle:FindFirstChild((string.format("%d.%d", ConnectingJoint, i)))
					if not v11 then
						break
					end
					v11.Attachment1 = v8
					v11.Enabled = true
					table.insert(t2, v11)
				end
			end
		end
	end
	local v12
	if CustomModel then
		v12 = {}
		for j = 0, 30 do
			local v13 = Origin:Lerp(CastPosition, j / 30)
			table.insert(v12, CFrame.new(v13))
		end
		v12[#v12] = CFrame.new(CastPosition)
	else
		v12 = CurveUtil.GetCurveBetween({
			numPoints = 30,
			visualize = false,
			withRotation = true,
			start = Origin,
			finish = CastPosition,
			curveHeight = math.max(Origin.Y, CastPosition.Y) + (10 + 12 * Power),
			yRotation = CFrame.fromOrientation(0, 0, 0)
		})
	end
	if CustomModel then
		local Unit = (CastPosition - Origin).Unit
		local v16 = Vector3.new(0, 1, 0)
		if math.abs((Unit:Dot(v16))) > 0.99 then
			v16 = Vector3.new(1, 0, 0)
		end
		local Unit_2 = Unit:Cross(v16).Unit
		local Unit_3 = Unit_2:Cross(Unit).Unit
		v7:PivotTo((CFrame.fromMatrix(Origin, Unit_2, Unit_3, -Unit)))
	else
		v7:PivotTo(CFrame.new(Origin))
	end
	v7.Parent = CosmeticFolder
	t[p1] = {
		Connection = nil,
		Model = v7,
		CastPosition = CastPosition,
		Beams = t2,
		EquippedModel = EquippedToolModel
	}
	local v19 = (Origin - CastPosition).Magnitude / ((if CustomModel then v7:GetAttribute("Speed") else nil) or 40) * (1.2 - Power * 0.4)
	local v20 = v12
	local function f21() --[[ Line: 343 | Upvalues: CreateBobAnimation (ref), v7 (copy), CastPosition (copy), CustomModel (copy) ]]
		CreateBobAnimation(v7, CastPosition, CustomModel)
	end
	local v22 = os.clock()
	local v23 = nil
	v23 = RunService.RenderStepped:Connect(function() --[[ Line: 50 | Upvalues: v22 (copy), v19 (copy), v20 (copy), CustomModel (copy), v7 (copy), v23 (ref), f21 (copy) ]]
		local v22_2 = math.min((os.clock() - v22) / v19, 1)
		local v3 = v22_2 * (#v20 - 1) + 1
		local v4 = math.floor(v3)
		local v7_2 = v20[v4]:Lerp(v20[math.min(v4 + 1, #v20)], v3 - v4)
		if CustomModel and (v7 and v7.Parent) then
			local Position = v7_2.Position
			local Unit = ((if v22_2 < 0.99 then v20[math.min(v4 + 2, #v20)].Position else v20[#v20].Position) - Position).Unit
			local v10 = Vector3.new(0, 1, 0)
			if math.abs((Unit:Dot(v10))) > 0.99 then
				v10 = Vector3.new(1, 0, 0)
			end
			local Unit_2 = Unit:Cross(v10).Unit
			local Unit_3 = Unit_2:Cross(Unit).Unit
			v7:PivotTo(CFrame.fromMatrix(Position, Unit_2, Unit_3, -Unit) * CFrame.Angles(0, 0, 0))
		elseif v7 and v7.Parent then
			v7:PivotTo(v7_2)
		end
		if not (v22_2 >= 1) then
			return
		end
		v23:Disconnect()
		if not f21 then
			return
		end
		f21()
	end)
	local v24 = v23
	if not t[p1] then
		return
	end
	t[p1].Connection = v24
end
local function CleanupBait(p1) --[[ CleanupBait | Line: 356 | Upvalues: t (copy), CosmeticFolder (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	if v1.Beams then
		for i, v in ipairs(v1.Beams) do
			v.Attachment1 = nil
		end
	end
	if v1.Connection then
		v1.Connection:Disconnect()
	end
	if v1.Model then
		v1.Model:Destroy()
	end
	for k, v in pairs(CosmeticFolder:GetChildren()) do
		if v.Name == "BaitAttachmentDebug" then
			v:Destroy()
		end
	end
	t[p1] = nil
end
function t2.Init() --[[ Init | Line: 391 | Upvalues: v1 (copy), CleanupBait (copy), CreateBaitVisual (copy), v2 (copy), Players (copy) ]]
	v1.OnClientEvent:Connect(function(p1, p2) --[[ Line: 393 | Upvalues: CleanupBait (ref), CreateBaitVisual (ref) ]]
		CleanupBait(p1)
		CreateBaitVisual(p1, p2)
	end)
	v2.OnClientEvent:Connect(function(p1) --[[ Line: 402 | Upvalues: CleanupBait (ref) ]]
		CleanupBait(p1)
	end)
	Players.PlayerRemoving:Connect(function(p1) --[[ Line: 407 | Upvalues: CleanupBait (ref) ]]
		CleanupBait(p1)
	end)
end
t2.Init()
return t2