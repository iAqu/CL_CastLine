local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PetsData = require(game:GetService("ReplicatedFirst").Data.PetsData)
local PetInventory = require(ReplicatedStorage.Modules.PetInventory)
local PetFeatureConfig = require(ReplicatedStorage.Modules.PetFeatureConfig)

local LOCAL_PLAYER = Players.LocalPlayer
local RESOURCE_TIMEOUT = 10
local TELEPORT_DISTANCE = 60
local HOVER_AMPLITUDE = 1
local SLOTS = {
	{ offset = Vector3.new(0, 1, 10), yaw = 0 },
	{ offset = Vector3.new(-7, 1, 8), yaw = -10 },
	{ offset = Vector3.new(7, 1, 8), yaw = 10 },
}

local PetFollowController = Knit.CreateController({ Name = "PetFollowController" })
local warned = {}

local function warnOnce(message: string)
	if not warned[message] then
		warned[message] = true
		warn("PetFollowController: " .. message)
	end
end

local function movePrimaryTo(model: Model, target: CFrame)
	local primary = model.PrimaryPart
	if not primary then
		return
	end
	-- 保留 PrimaryPart 与模型 pivot 的偏移，不让透明辅助部件影响跟随位置。
	model:PivotTo(target * primary.CFrame:ToObjectSpace(model:GetPivot()))
	primary.AssemblyLinearVelocity = Vector3.zero
	primary.AssemblyAngularVelocity = Vector3.zero
end

-- 内部构建入口，也供 Studio 检查特殊模板；不修改传入的资源模型。
function PetFollowController:_CreatePetVisual(template: Model, root: BasePart, slot, folder: Folder, pet)
	local model = template:Clone()
	model:ScaleTo(template:GetScale() * PetInventory.GetModelScale(pet or {}))
	local primary = model.PrimaryPart
	if not primary then
		model:Destroy()
		return nil
	end

	local parts = {}
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = false
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = descendant ~= primary
			table.insert(parts, descendant)
		elseif descendant:IsA("BaseScript") then
			descendant:Destroy()
		end
	end
	model.Parent = folder

	-- 原模板可能有多个锚定部件或独立装饰。只连接断开的组件，保留已有 Motor6D/Weld。
	local connected = { [primary] = true }
	for _, part in primary:GetConnectedParts(true) do
		connected[part] = true
	end
	for _, part in parts do
		if not connected[part] then
			local component = part:GetConnectedParts(true)
			local weld = Instance.new("WeldConstraint")
			weld.Name = "PetFollowWeld"
			weld.Part0 = primary
			weld.Part1 = part
			weld.Parent = primary
			connected[part] = true
			for _, member in component do
				connected[member] = true
			end
		end
	end

	local target = Instance.new("Attachment")
	target.Name = "PetFollowTarget_" .. template.Name
	target.Position = slot.offset - Vector3.new(0, HOVER_AMPLITUDE, 0)
	target.Orientation = Vector3.new(0, slot.yaw, 0)
	target.Parent = root

	local attachment = Instance.new("Attachment")
	attachment.Name = "PetFollowAttachment"
	attachment.Parent = primary

	local position = Instance.new("AlignPosition")
	position.Name = "PetFollowPosition"
	position.Attachment0 = attachment
	position.Attachment1 = target
	position.MaxForce = math.huge
	position.Responsiveness = 1
	position.ApplyAtCenterOfMass = true
	position.Parent = primary

	local orientation = Instance.new("AlignOrientation")
	orientation.Name = "PetFollowOrientation"
	orientation.Attachment0 = attachment
	orientation.Attachment1 = target
	orientation.MaxTorque = math.huge
	orientation.Responsiveness = 10
	orientation.Parent = primary

	movePrimaryTo(model, target.WorldCFrame)
	local tween = TweenService:Create(
		target,
		TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, -1, true),
		{ Position = slot.offset + Vector3.new(0, HOVER_AMPLITUDE, 0) }
	)
	tween:Play()
	return { model = model, target = target, tween = tween }
end

function PetFollowController:_ClearCharacter(player)
	local state = self._states[player]
	if not state then
		return
	end
	self._states[player] = nil
	if state.heartbeat then
		state.heartbeat:Disconnect()
	end
	for _, visual in ipairs(state.visuals) do
		visual.tween:Cancel()
		visual.tween:Destroy()
		visual.target:Destroy()
		visual.model:Destroy()
	end
end

function PetFollowController:_BindCharacter(player, character)
	self:_ClearCharacter(player)
	local visible = if player == LOCAL_PLAYER then self._showYourPets else self._showOtherPets
	local roster = self._rosters[player.UserId]
	if not visible or not roster or #roster == 0 or player.Character ~= character then
		return
	end
	local state = { visuals = {} }
	self._states[player] = state
	task.spawn(function()
		local root = character:WaitForChild("HumanoidRootPart", RESOURCE_TIMEOUT)
		if self._states[player] ~= state or player.Character ~= character or not root or not root:IsA("BasePart") then
			return
		end
		local models = ReplicatedStorage:FindFirstChild("Models")
		local pets = models and models:FindFirstChild("Pets")
		if not pets then
			warnOnce("Models.Pets is missing")
			return
		end
		for index, pet in ipairs(roster) do
			if index > #SLOTS then
				break
			end
			local config = PetsData[pet.PetID]
			local template = config and pets:FindFirstChild(config.Model)
			if template and template:IsA("Model") and template.PrimaryPart then
				local visual = self:_CreatePetVisual(template, root, SLOTS[index], self._folder, pet)
				if visual then
					table.insert(state.visuals, visual)
				end
			else
				warnOnce("missing pet model: " .. tostring(pet.PetID))
			end
		end
		local previousPosition = root.Position
		state.heartbeat = RunService.Heartbeat:Connect(function()
			if root.Parent ~= character or player.Character ~= character then
				self:_ClearCharacter(player)
				return
			end
			if (root.Position - previousPosition).Magnitude > TELEPORT_DISTANCE then
				for _, visual in ipairs(state.visuals) do
					movePrimaryTo(visual.model, visual.target.WorldCFrame)
				end
			end
			previousPosition = root.Position
		end)
	end)
end

function PetFollowController:_ApplyRoster(userId, roster)
	self._rosters[userId] = roster
	local player = Players:GetPlayerByUserId(userId)
	if player and player.Character then
		self:_BindCharacter(player, player.Character)
	end
end

function PetFollowController:KnitStart()
	if not PetFeatureConfig.Enabled then return end
	self._states, self._rosters, self._connections = {}, {}, {}
	self._showYourPets, self._showOtherPets = true, true
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "PetFollowers", Workspace
	self._folder = folder
	local function bind(player)
		self._connections[player] = {
			player.CharacterAdded:Connect(function(character)
				self:_BindCharacter(player, character)
			end),
			player.CharacterRemoving:Connect(function()
				self:_ClearCharacter(player)
			end),
		}
		if player.Character then
			self:_BindCharacter(player, player.Character)
		end
	end
	Players.PlayerAdded:Connect(bind)
	Players.PlayerRemoving:Connect(function(player)
		self:_ClearCharacter(player)
		self._rosters[player.UserId] = nil
		for _, connection in ipairs(self._connections[player] or {}) do
			connection:Disconnect()
		end
		self._connections[player] = nil
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		bind(player)
	end
	local service = Knit.GetService("PetService")
	local received = {}
	service.EquippedChanged:Connect(function(userId, roster)
		received[userId] = true
		self:_ApplyRoster(userId, roster)
	end)
	service
		:GetAllPlayersEquippedPets()
		:andThen(function(rosters)
			for id, roster in pairs(rosters) do
				local userId = tonumber(id)
				if userId and not received[userId] then
					self:_ApplyRoster(userId, roster)
				end
			end
		end)
		:catch(function(err)
			warn("PetFollowController: " .. tostring(err))
		end)
	local function refreshVisibility(settings)
		self._showYourPets = settings.ShowYourPets ~= false
		self._showOtherPets = settings.ShowOtherPets ~= false
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				self:_BindCharacter(player, player.Character)
			end
		end
	end
	task.spawn(function()
		local data = Knit.GetController("PlayerDataController"):GetData()
		refreshVisibility(data.Settings)
	end)
	Knit.GetService("SettingsService").ChangeSetting:Connect(function(settingId, enabled)
		if settingId == "ShowYourPets" or settingId == "ShowOtherPets" then
			local settings = { ShowYourPets = self._showYourPets, ShowOtherPets = self._showOtherPets }
			settings[settingId] = enabled
			refreshVisibility(settings)
		end
	end)
end

return PetFollowController
