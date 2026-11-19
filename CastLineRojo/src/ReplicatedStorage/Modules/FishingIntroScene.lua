local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Config = require(script.Parent.FishingIntroConfig)
local ItemStatUtil = require(script.Parent.ItemStatUtil)
local RigUtil = require(script.Parent.FishingRigUtil)

local Scene = {}
Scene.__index = Scene
local UP = Vector3.yAxis

local function actor(rig)
	RigUtil.RestoreReadyPose(rig)
	local self = { rig = rig, joints = {}, welds = {} }
	for _, d in rig:GetDescendants() do
		if d:IsA("Motor6D") then
			table.insert(self.joints, { joint = d, base = d.C0 })
		elseif d:IsA("WeldConstraint") and d.Part0 and d.Part1 then
			table.insert(
				self.welds,
				{ part0 = d.Part0, part1 = d.Part1, offset = d.Part0.CFrame:ToObjectSpace(d.Part1.CFrame) }
			)
		end
	end
	self.head = rig:FindFirstChild("DressedHead") or rig.Head
	self.leftHand, self.rightHand = rig.LeftHand, rig.RightHand
	self.rod = rig.HeldFishingRod
	return self
end

local function applyPose(a, values, rootFrame)
	a.rig:PivotTo(rootFrame)
	for _, entry in a.joints do
		local v = values[entry.joint.Name] or Vector3.zero
		entry.joint.C0 = entry.base * CFrame.Angles(math.rad(v.X), math.rad(-v.Y), math.rad(v.Z))
		entry.joint.Transform = CFrame.identity
	end
	-- Resolve from the root immediately: close-up anchors must not lag a physics frame.
	local done = { [a.rig.PrimaryPart] = true }
	for _ = 1, 10 do
		for _, entry in a.joints do
			local j = entry.joint
			if j.Part0 and j.Part1 and done[j.Part0] and not done[j.Part1] then
				j.Part1.CFrame = j.Part0.CFrame * j.C0 * j.C1:Inverse()
				done[j.Part1] = true
			end
		end
	end
	for _, weld in a.welds do
		weld.part1.CFrame = weld.part0.CFrame * weld.offset
	end
	for _, d in a.rig:GetDescendants() do
		if d:IsA("Weld") and d.Part0 and d.Part1 then
			d.Part1.CFrame = d.Part0.CFrame * d.C0 * d.C1:Inverse()
		end
	end
end

function Scene.new(character, part, rod)
	local self = setmetatable({}, Scene)
	self.folder = Instance.new("Folder")
	self.folder.Name, self.folder.Parent = "FishingIntroScene", Workspace
	local ok, err = pcall(function()
		self.playerRig = RigUtil.Create(ReplicatedStorage.Character.PoseDefaultCharacter, character, rod)
		self.playerRig.Name, self.playerRig.Parent = "IntroPlayer", self.folder
		self.player = actor(self.playerRig)
		local ground = part.Position + UP * part.Size.Y / 2
		local forward = (part.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
		self.origin = CFrame.lookAt(ground, ground + forward)
		local humanoid = self.playerRig:FindFirstChildOfClass("Humanoid")
		self.rootHeight = humanoid.HipHeight + self.playerRig.PrimaryPart.Size.Y / 2
		self.playerRig:PivotTo(self:Frame())
		RigUtil.ApplyReadyPose(self.playerRig)
	end)
	if not ok then
		self:Destroy()
		error(err, 0)
	end
	return self
end

function Scene:Frame()
	return self.origin * CFrame.new(0, self.rootHeight, 0)
end

local function hideRod(a)
	for _, instance in a.rod:GetDescendants() do
		if instance:IsA("BasePart") then
			instance.LocalTransparencyModifier = 1
		elseif instance:IsA("Decal") then
			instance.Transparency = 1
		elseif instance:IsA("ParticleEmitter") or instance:IsA("Trail") then
			instance.Enabled = false
			instance:Clear()
		elseif instance:IsA("Beam") or instance:IsA("Light") or instance:IsA("Highlight")
			or instance:IsA("BillboardGui") or instance:IsA("SurfaceGui")
		then
			instance.Enabled = false
		end
	end
end

local function handTop(hand)
	local frame, half = hand.CFrame, hand.Size * 0.5
	return frame.Position + UP * (
		math.abs(frame.XVector.Y) * half.X
		+ math.abs(frame.YVector.Y) * half.Y
		+ math.abs(frame.ZVector.Y) * half.Z
	)
end

local function fitBox(basis, boxFrame, size, horizontal, up, down)
	local distance = 0
	for x = -1, 1, 2 do
		for y = -1, 1, 2 do
			for z = -1, 1, 2 do
				local corner = boxFrame:PointToWorldSpace(size * Vector3.new(x, y, z) * 0.5)
				local p = basis:PointToObjectSpace(corner)
				local vertical = if p.Y >= 0 then up else down
				distance = math.max(distance, p.Z + math.abs(p.X) / horizontal, p.Z + math.abs(p.Y) / vertical)
			end
		end
	end
	return distance
end

function Scene:PresentCatch(bite, elapsed, camera)
	local a = self.player
	if not self.rodHidden then
		self.rodHidden = true
		hideRod(a)
	end

	local progress = math.clamp(elapsed / Config.RaiseFishTime, 0, 1)
	local alpha = progress * progress * (3 - 2 * progress)
	local shoulder, elbow = 119 + 42 * alpha, 13 + 3 * alpha
	-- Counter the arm lift at the wrist to keep the palms under the fish.
	local wrist = 102 - shoulder - elbow
	applyPose(a, {
		Neck = Vector3.new(8 * alpha, 0, 0),
		RightShoulder = Vector3.new(shoulder, 0, -8),
		LeftShoulder = Vector3.new(shoulder, 0, 8),
		RightElbow = Vector3.new(elbow, 0, 0),
		LeftElbow = Vector3.new(elbow, 0, 0),
		RightWrist = Vector3.new(wrist, 0, 0),
		LeftWrist = Vector3.new(wrist, 0, 0),
	}, self:Frame())

	-- Fit and place in the fish's body space so model pivot offsets do not move its belly off the hands.
	local bounds, scale = ItemStatUtil.GetModelBounds(bite.template), bite.scale
	local size = (bounds.maximum - bounds.minimum) * scale
	local center = (bounds.maximum + bounds.minimum) * (0.5 * scale)
	local bottom = center - UP * (size.Y * 0.5)
	local palms = (handTop(a.leftHand) + handTop(a.rightHand)) * 0.5
	local body = CFrame.new(palms - UP * 0.025) * self.origin.Rotation
		* CFrame.Angles(0, math.pi / 2, 0) * CFrame.new(-bottom)

	local fishBox = body * CFrame.new(center)
	local focus = a.head.Position:Lerp(fishBox.Position, 0.30)
	local direction = self.origin.LookVector - self.origin.RightVector * 0.12 + UP * 0.04
	local basis = CFrame.lookAt(focus + direction, focus).Rotation + focus
	local fov = 47
	local viewport = camera.ViewportSize
	local tangent = math.tan(math.rad(fov * 0.5))
	local horizontal = tangent * math.max(viewport.X / math.max(viewport.Y, 1), 0.1) * 0.82
	-- The title and continue prompt begin below this part of the frame.
	local up, down = tangent * 0.82, tangent * 0.34
	local distance = math.max(4.25, fitBox(basis, fishBox, size, horizontal, up, down))
	for _, part in { a.head, a.leftHand, a.rightHand } do
		distance = math.max(distance, fitBox(basis, part.CFrame, part.Size, horizontal, up, down))
	end
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = basis * CFrame.new(0, 0, distance + 0.2)
	camera.FieldOfView, camera.Focus = fov, CFrame.new(focus)
	return body
end

function Scene:Destroy()
	if self.folder then
		self.folder:Destroy()
	end
end

return Scene
