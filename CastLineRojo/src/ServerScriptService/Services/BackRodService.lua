local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Config = require(ReplicatedStorage.Modules.FishingConfig)
local RodsData = require(ReplicatedFirst:WaitForChild("Data"):WaitForChild("RodsData"))

local ROD_NAME = "DefaultBackRod"
local BACK_MOUNT_OFFSET = CFrame.new(0.55, 0.05, 0.72)
local FALLBACK_OFFSET = BACK_MOUNT_OFFSET * CFrame.Angles(math.rad(35), 0, math.rad(18))

local BackRodService = Knit.CreateService({ Name = "BackRodService", Client = {} })

function BackRodService:AttachBackRod(player: Player, character: Model)
	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if not torso then
		local deadline = os.clock() + 5
		repeat
			task.wait()
			torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
		until torso or not character.Parent or os.clock() >= deadline
	end
	if player.Character ~= character or not character.Parent then
		return
	end
	if not torso or not torso:IsA("BasePart") then
		warn("BackRodService: character torso is missing")
		return
	end
	-- Read the equipped ID after waiting for the torso so a stale refresh cannot replace a newer one.
	local rodId = player:GetAttribute("EquippedRodId") or Config.DefaultRodId
	local existing = character:FindFirstChild(ROD_NAME)
	-- Recheck after the torso wait so a queued refresh cannot restore it during training.
	if player:GetAttribute("IsTraining") == true then
		if existing then
			existing:Destroy()
		end
		return
	end
	if existing and existing:GetAttribute("RodId") == rodId then
		return
	end
	local modelName = (RodsData[rodId] or RodsData[Config.DefaultRodId]).Model
	local models = ReplicatedStorage:FindFirstChild("Models")
	local rods = models and models:FindFirstChild("FishRod")
	local template = rods and rods:FindFirstChild(modelName)
	if not template or not (template:IsA("Tool") or template:IsA("Model")) then
		warn("BackRodService: invalid rod template " .. modelName)
		return
	end

	local source = template:Clone()
	local rod = Instance.new("Model")
	rod.Name = ROD_NAME
	for _, child in ipairs(source:GetChildren()) do
		child.Parent = rod
	end
	source:Destroy()
	for _, descendant in ipairs(rod:GetDescendants()) do
		if
			descendant:IsA("LuaSourceContainer")
			or descendant:IsA("JointInstance")
			or descendant:IsA("Constraint")
			or descendant:IsA("WeldConstraint")
		then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored = false
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Massless = true
		end
	end
	local handle = rod:FindFirstChild("Handle", true)
	if not handle or not handle:IsA("BasePart") then
		rod:Destroy()
		warn("BackRodService: invalid Handle for " .. modelName)
		return
	end
	rod.PrimaryPart = handle
	local attachment = rod:FindFirstChild("BackAttachment", true)
	if attachment and attachment:IsA("Attachment") then
		local localMount = rod:GetPivot():ToObjectSpace(attachment.WorldCFrame)
		rod:PivotTo(torso.CFrame * BACK_MOUNT_OFFSET * localMount:Inverse())
	else
		rod:PivotTo(torso.CFrame * FALLBACK_OFFSET)
	end
	for _, descendant in ipairs(rod:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant ~= handle then
			local weld = Instance.new("WeldConstraint")
			weld.Name = "DefaultBackRodInternalWeld"
			weld.Part0, weld.Part1 = handle, descendant
			weld.Parent = handle
		end
	end
	local weld = Instance.new("WeldConstraint")
	weld.Name = "DefaultBackRodWeld"
	weld.Part0, weld.Part1 = torso, handle
	weld.Parent = handle
	rod:SetAttribute("RodId", rodId)
	if existing then
		existing:Destroy()
	end
	rod.Parent = character
end

function BackRodService:KnitStart()
	local boundPlayers = {}
	local function bindPlayer(player: Player)
		if boundPlayers[player] then
			return
		end
		boundPlayers[player] = true
		local function refresh()
			local character = player.Character
			if character then
				task.defer(function()
					self:AttachBackRod(player, character)
				end)
			end
		end
		player.CharacterAdded:Connect(refresh)
		player:GetAttributeChangedSignal("EquippedRodId"):Connect(refresh)
		player:GetAttributeChangedSignal("IsTraining"):Connect(refresh)
		refresh()
	end
	Players.PlayerAdded:Connect(bindPlayer)
	Players.PlayerRemoving:Connect(function(player)
		boundPlayers[player] = nil
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		bindPlayer(player)
	end
end

return BackRodService
