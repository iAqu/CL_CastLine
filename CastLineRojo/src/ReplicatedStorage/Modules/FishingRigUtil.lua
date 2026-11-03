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
		local shoulder = rig:FindFirstChild("RightShoulder", true)
		local elbow = rig:FindFirstChild("RightElbow", true)
		if shoulder then
			shoulder:SetAttribute("FishingReadyC0", shoulder.C0)
			shoulder.C0 *= CFrame.Angles(math.rad(45), 0, math.rad(8))
		end
		if elbow then
			elbow:SetAttribute("FishingReadyC0", elbow.C0)
			elbow.C0 *= CFrame.Angles(math.rad(35), 0, 0)
		end
	end)
	if not ok then
		rig:Destroy()
		error(result, 0)
	end
	return rig
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
