local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local FishingRigUtil = {}

local function prepareParts(model: Instance)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BaseScript") then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored = false
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = true
			descendant.LocalTransparencyModifier = 0
		elseif descendant:IsA("Decal") then
			descendant.LocalTransparencyModifier = 0
		end
	end
end

local function stripJoints(model: Instance)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("JointInstance") or descendant:IsA("Constraint") or descendant:IsA("WeldConstraint") then
			descendant:Destroy()
		end
	end
end

local function copyAppearance(rig: Model, character: Model)
	for _, child in ipairs(rig:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") then
			child:Destroy()
		end
	end
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Clothing") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") then
			child:Clone().Parent = rig
		end
	end
	-- 保留模板头部和颈部骨架，用焊接的外观头兼容玩家的动态头/不同头型。
	local head = rig:FindFirstChild("Head")
	local playerHead = character:FindFirstChild("Head")
	local dressedHead
	if head and head:IsA("BasePart") and playerHead and playerHead:IsA("BasePart") then
		dressedHead = playerHead:Clone()
		dressedHead.Name = "DressedHead"
		for _, child in ipairs(dressedHead:GetChildren()) do
			if
				not (
					child:IsA("Attachment")
					or child:IsA("Decal")
					or child:IsA("SpecialMesh")
					or child:IsA("SurfaceAppearance")
					or child:IsA("FaceControls")
				)
			then
				child:Destroy()
			end
		end
		dressedHead.Transparency = playerHead.Transparency
		dressedHead.CFrame = head.CFrame * CFrame.new(0, (dressedHead.Size.Y - head.Size.Y) / 2, 0)
		dressedHead.Parent = rig
		local weld = Instance.new("WeldConstraint")
		weld.Part0, weld.Part1 = head, dressedHead
		weld.Parent = dressedHead
		head.Transparency = 1
		for _, child in ipairs(head:GetChildren()) do
			if child:IsA("Decal") then
				child.Transparency = 1
			end
		end
	end

	for _, child in ipairs(character:GetChildren()) do
		if not child:IsA("Accessory") then
			continue
		end
		local accessory = child:Clone()
		stripJoints(accessory)
		local handle = accessory:FindFirstChild("Handle")
		local targetAttachment, sourceAttachment
		if handle and handle:IsA("BasePart") then
			for _, attachment in ipairs(handle:GetChildren()) do
				if not attachment:IsA("Attachment") then
					continue
				end
				targetAttachment = dressedHead and dressedHead:FindFirstChild(attachment.Name)
				if not targetAttachment then
					for _, part in ipairs(rig:GetChildren()) do
						if part:IsA("BasePart") then
							targetAttachment = part:FindFirstChild(attachment.Name)
							if targetAttachment then
								break
							end
						end
					end
				end
				if targetAttachment and targetAttachment:IsA("Attachment") then
					sourceAttachment = attachment
					break
				end
			end
		end
		-- 模板体型固定；层叠服装依赖玩家身体的 WrapTarget，不能直接平移。
		if
			not (handle and targetAttachment and sourceAttachment)
			or accessory:FindFirstChildWhichIsA("WrapLayer", true)
		then
			accessory:Destroy()
			continue
		end
		handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
		local weld = Instance.new("Weld")
		weld.Name = "AccessoryWeld"
		weld.Part0, weld.Part1 = targetAttachment.Parent, handle
		weld.C0, weld.C1 = targetAttachment.CFrame, sourceAttachment.CFrame
		weld.Parent = handle
		accessory.Parent = rig
	end
end

function FishingRigUtil.Create(template: Model, character: Model, rodTemplate: Tool): Model
	local rig = template:Clone()
	local ok, result = pcall(function()
		local humanoid = assert(rig:FindFirstChildOfClass("Humanoid"), "PoseDefaultCharacter.Humanoid is missing")
		local root = assert(rig:FindFirstChild("HumanoidRootPart"), "PoseDefaultCharacter.HumanoidRootPart is missing")
		local hand = assert(rig:FindFirstChild("RightHand"), "PoseDefaultCharacter.RightHand is missing")
		local gripAttachment = assert(hand:FindFirstChild("RightGripAttachment"), "RightGripAttachment is missing")
		-- Parent 到 Workspace 时，自动体型缩放会重建 C0 并覆盖准备姿势。
		humanoid.AutomaticScalingEnabled = false
		copyAppearance(rig, character)
		prepareParts(rig)
		rig.Name = "FishingRig"
		rig.PrimaryPart = root
		root.Anchored = true
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.EvaluateStateMachine = false
		humanoid.AutoRotate = false

		local source = rodTemplate:Clone()
		local rod = Instance.new("Model")
		rod.Name = "HeldFishingRod"
		rod.Parent = rig
		for _, child in ipairs(source:GetChildren()) do
			child.Parent = rod
		end
		source:Destroy()
		stripJoints(rod)
		prepareParts(rod)
		local handle = assert(rod:FindFirstChild("Handle"), "TestRod.Handle is missing")
		rod.PrimaryPart = handle
		rod:PivotTo(hand.CFrame * gripAttachment.CFrame * rodTemplate.Grip:Inverse())
		for _, part in ipairs(rod:GetDescendants()) do
			if part:IsA("BasePart") and part ~= handle then
				local weld = Instance.new("WeldConstraint")
				weld.Part0, weld.Part1 = handle, part
				weld.Parent = handle
			end
		end
		local grip = Instance.new("Motor6D")
		grip.Name = "RightGrip"
		grip.Part0, grip.Part1 = hand, handle
		grip.C0, grip.C1 = gripAttachment.CFrame, rodTemplate.Grip
		grip.Parent = hand
		-- 静态准备姿势，不依赖 R6 参考动画，也不提前播放抛竿动作。
		FishingRigUtil.ApplyReadyPose(rig)
	end)
	if not ok then
		rig:Destroy()
		error(result, 0)
	end
	return rig
end

local function getGroundY(surface: Vector3): number
	local excluded = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			table.insert(excluded, player.Character)
		end
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = excluded
	params.RespectCanCollide = true
	params.IgnoreWater = true
	local hit = Workspace:Raycast(surface + Vector3.yAxis * 8, Vector3.yAxis * -24, params)
	return if hit then hit.Position.Y else surface.Y
end

local function getSoleOffset(root: BasePart, humanoid: Humanoid): number
	local rig = root.Parent
	local lowest = math.huge
	for _, name in ipairs({ "LeftFoot", "RightFoot" }) do
		local foot = rig and rig:FindFirstChild(name)
		if foot and foot:IsA("BasePart") then
			local frame = root.CFrame:ToObjectSpace(foot.CFrame)
			local half = foot.Size / 2
			local extent = math.abs(frame.RightVector.Y) * half.X
				+ math.abs(frame.UpVector.Y) * half.Y
				+ math.abs(frame.LookVector.Y) * half.Z
			lowest = math.min(lowest, frame.Position.Y - extent)
		end
	end
	return if lowest < math.huge then -lowest else humanoid.HipHeight + root.Size.Y / 2
end

function FishingRigUtil.GetSpotRootCFrame(part: BasePart, root: BasePart, humanoid: Humanoid): (CFrame, Vector3, number)
	local forward = part.CFrame.LookVector * Vector3.new(1, 0, 1)
	assert(forward.Magnitude >= 0.001, "FishingStartPart must face horizontally")
	local surface = part.Position + part.CFrame.UpVector * (part.Size.Y / 2)
	local groundY = getGroundY(surface)
	local position = Vector3.new(surface.X, groundY + getSoleOffset(root, humanoid), surface.Z)
	return CFrame.lookAt(position, position + forward), forward.Unit, groundY
end

function FishingRigUtil.PlaceAtFishingSpot(rig: Model, part: BasePart)
	local root = assert(rig.PrimaryPart, "FishingRig.PrimaryPart is missing")
	local humanoid = assert(rig:FindFirstChildOfClass("Humanoid"), "FishingRig.Humanoid is missing")
	local target, forward, groundY = FishingRigUtil.GetSpotRootCFrame(part, root, humanoid)
	rig:PivotTo(target * root.CFrame:ToObjectSpace(rig:GetPivot()))
	return target.Position, forward, groundY
end

function FishingRigUtil.ApplyReadyPose(rig: Model)
	for _, name in ipairs({ "RightShoulder", "RightElbow" }) do
		local joint = rig:FindFirstChild(name, true)
		if joint then
			local original = joint:GetAttribute("FishingReadyC0")
			if typeof(original) ~= "CFrame" then
				original = joint.C0
				joint:SetAttribute("FishingReadyC0", original)
			end
			local offset = if name == "RightShoulder"
				then CFrame.Angles(math.rad(45), 0, math.rad(8))
				else CFrame.Angles(math.rad(35), 0, 0)
			joint.C0 = original * offset
		end
	end
end

function FishingRigUtil.ApplyCastWindup(rig: Model, progress: number)
	local blend = progress * progress * (3 - 2 * progress)
	for _, name in ipairs({ "RightShoulder", "RightElbow" }) do
		local joint = rig:FindFirstChild(name, true)
		local original = joint and joint:GetAttribute("FishingReadyC0")
		if typeof(original) == "CFrame" then
			local offset = if name == "RightShoulder"
				then CFrame.Angles(math.rad(45 + 22 * blend), 0, math.rad(8 + 5 * blend))
				else CFrame.Angles(math.rad(35 + 13 * blend), 0, 0)
			joint.C0 = original * offset
		end
	end
end

function FishingRigUtil.RestoreReadyPose(rig: Model)
	for _, name in ipairs({ "RightShoulder", "RightElbow" }) do
		local joint = rig:FindFirstChild(name, true)
		local original = joint and joint:GetAttribute("FishingReadyC0")
		if joint and typeof(original) == "CFrame" then
			joint.C0 = original
		end
	end
end

return FishingRigUtil
