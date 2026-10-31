local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local PlayerService = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local RebirthDataHelper = require(ReplicatedFirst.DataHelpers.RebirthDataHelper)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Constants = require(ReplicatedStorage.Modules.Constants)
local CharacterUtil = require(ReplicatedStorage.Modules.CharacterUtil)
local EffectUtil = require(ReplicatedStorage.Modules.EffectUtil)
local MovementSpeedUtil = require(ReplicatedStorage.Modules.MovementSpeedUtil)

local localPlayer = PlayerService.LocalPlayer
-- local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
-- local Animate = localCharacter:WaitForChild("Animate")
-- local defaultIdle1AnimId = Animate:WaitForChild("idle").Animation1.AnimationId
-- local defaultIdle2AnimId = Animate:WaitForChild("idle").Animation2.AnimationId
-- local defaultIdeleAnimIds = {}
-- use find first child of class to get the animation id, prevent the animation name changed by player skin
-- local defaultRunAnimId = Animate:WaitForChild("run"):FindFirstChildOfClass("Animation").AnimationId
-- local defaultJumpAnimId = Animate:WaitForChild("jump"):FindFirstChildOfClass("Animation").AnimationId
-- local defaultFallAnimId = Animate:WaitForChild("fall"):FindFirstChildOfClass("Animation").AnimationId

-- local greatSword_Run: Animation = ReplicatedStorage.Animation.GreatSword.GreatSword_Run
-- local greatSword_Idle: Animation = ReplicatedStorage.Animation.GreatSword.GreatSword_Idle
-- -- local greatSword_Jump: Animation = ReplicatedStorage.Animation.GreatSword.GreatSword_Jump
-- local greatSword_Fall: Animation = ReplicatedStorage.Animation.GreatSword.GreatSword_Fall

local PlayerGui = localPlayer:WaitForChild("PlayerGui")
local PlayerNameTemple: BillboardGui? = nil
if Constants.PLAYER_TITLE_GUI_ENABLED then
	local titleGui = PlayerGui:WaitForChild("TitleGui")
	PlayerNameTemple = titleGui:WaitForChild("PlayerNameTemple")
end

-- local DEFAULT_DENSITY = 0.7
-- local DefaultPyhsicalProperties = {Density = 0.7, Friction = 0.3, Elasticity = 0.5, FrictionWeight = 1, ElasticityWeight = 1}
-- local DefaultPyhsicalProperties = {Density = 5, Friction = 0.3, Elasticity = 0.5, FrictionWeight = 1, ElasticityWeight = 1}

local DefaultPyhsicalProperties = {Density = 50, Friction = 0.3, Elasticity = 0.5, FrictionWeight = 1, ElasticityWeight = 1}

-- local defaultMovementSpeed = localCharacter:WaitForChild("Humanoid").WalkSpeed
local playersInLeaderboard = {}
local monitoredHumanoidRootParts = setmetatable({}, {__mode = "k"})
local stabilizedCharacters = setmetatable({}, {__mode = "k"})

local function applyHumanoidRootPartDensity(humanoidRootPart: BasePart)
	local currentProperties = humanoidRootPart.CurrentPhysicalProperties
	if currentProperties.Density == Constants.CHARACTER_PHYSICS.HRP_DENSITY then
		return
	end

	humanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(
		Constants.CHARACTER_PHYSICS.HRP_DENSITY,
		currentProperties.Friction,
		currentProperties.Elasticity,
		currentProperties.FrictionWeight,
		currentProperties.ElasticityWeight
	)
end

local function monitorCharacterDensity(character: Model)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
	end
	if not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then
		return
	end

	applyHumanoidRootPartDensity(humanoidRootPart)
	if monitoredHumanoidRootParts[humanoidRootPart] then
		return
	end
	monitoredHumanoidRootParts[humanoidRootPart] = true

	humanoidRootPart:GetPropertyChangedSignal("CustomPhysicalProperties"):Connect(function()
		if humanoidRootPart.Parent then
			task.defer(applyHumanoidRootPartDensity, humanoidRootPart)
		end
	end)
end

local function makeCharacterBodyPartsMassless(character: Model)
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
			child.Massless = true
		end
	end
end

local function configureCharacterPhysics(character: Model)
	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 10)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 10)
	if not humanoid or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then
		return
	end

	makeCharacterBodyPartsMassless(character)
	monitorCharacterDensity(character)

	if not stabilizedCharacters[character] then
		stabilizedCharacters[character] = true
		CharacterUtil.MakeCharacterStable(character)
	end
end

local CharacterController = Knit.CreateController {
    Name = "CharacterController",
}

function CharacterController:Init()
	if Constants.PLAYER_TITLE_GUI_ENABLED and PlayerNameTemple then
		PlayerNameTemple.TagsLabel.Text = ""
		PlayerNameTemple.Adornee = nil
	end

    -- fix the bug that some players' idle animation name is not "Animation1" or "Animation2"
    -- for _, animation in pairs(Animate:WaitForChild("idle"):GetChildren()) do
    --     if animation:IsA("Animation") then
    --         defaultIdeleAnimIds[animation.Name] = animation.AnimationId
    --     end
    -- end
end

function CharacterController:UpdatePhysicalProperties()
--[[ 体型/重生比例已禁用：不再按 RebirthData 调整 HRP 密度
    local rebirth = PlayerDataController:GetData().Rebirths
    local bodyWidthScale = RebirthDataHelper.GetBodyWidthScale(rebirth)
    local bodyHeightScale = RebirthDataHelper.GetBodyHeightScale(rebirth)
    local bodyDepthScale = RebirthDataHelper.GetBodyDepthScale(rebirth)
    local newDensity = DefaultPyhsicalProperties.Density / (bodyWidthScale * bodyHeightScale * bodyDepthScale)
    newDensity = math.clamp(newDensity, 0.01, 100)

    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    character:WaitForChild("HumanoidRootPart").CustomPhysicalProperties = PhysicalProperties.new(newDensity, DefaultPyhsicalProperties.Friction, DefaultPyhsicalProperties.Elasticity, DefaultPyhsicalProperties.FrictionWeight, DefaultPyhsicalProperties.ElasticityWeight)
]]
end


-- function CharacterController:setCollisionGroup(object)
-- 	if object:IsA("BasePart") then
-- 		object.CollisionGroup = PLAYER_COLLISTION_GROUP
-- 	end
-- end

function CharacterController:InitPlayerDisplayName(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local head = character:WaitForChild("Head")
    if not head then warn("Head not found"); return end
    
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    if not Constants.PLAYER_TITLE_GUI_ENABLED then
        return
    end
	if not PlayerNameTemple then
		return
	end

    local clone = PlayerNameTemple:Clone()
    clone.Name = "PlayerDisplayName"
    clone.Enabled = player ~= localPlayer
    -- clone.Parent = humanoidRootPart
    -- clone.Adornee = humanoidRootPart
    clone.Parent = character
    -- clone.Adornee = head
    clone.Adornee = humanoidRootPart
    clone.NamelLabel.Text = player.DisplayName
    clone.HealthBar.Visible = false
    clone.ItemFrame.Visible = false
    -- if AllPlayerStrength[tostring(player.UserId)] then
    --     local strength = AllPlayerStrength[tostring(player.UserId)]
    --     -- local rebirthTitle =  RebirthDataHelper.GetRebirthTitle(rebirth)
    --     clone.RebirthLabel.Text = rebirth .. "." .. rebirthTitle
    -- end
    -- self:UpdatePlayerDisplayStrength(player, AllPlayerStrength[tostring(player.UserId)])
    self:UpdateAnimalLevelName(player)

end

function CharacterController:UpdateAnimalLevelName(player: Player)
    -- local character = player.Character or player.CharacterAdded:Wait()
    -- local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- local horse = character:WaitForChild("Horse")
    -- if not horse then warn("Horse not found") return end

    -- local animalLevel = horse:GetAttribute("AnimalLevel")
    -- if not animalLevel then warn("AnimalLevel not found") return end

    --  if humanoidRootPart:FindFirstChild("PlayerDisplayName") then
    --     humanoidRootPart.PlayerDisplayName.StrengthLabel.Text = Constants.ANIMAL_LEVEL_NAMES[animalLevel]
    -- end
end

local function showDisplayName(isEnabled: boolean)
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local playerDisplayName = humanoidRootPart:FindFirstChild("PlayerDisplayName")
    if playerDisplayName then
        playerDisplayName.Enabled = isEnabled
    end
end

-- function CharacterController:UpdateDisplayPosition(player: Player)
--     local character = player.Character or player.CharacterAdded:Wait()
--     local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

--     -- local horseId
--     -- for _, child in pairs(character:GetChildren()) do
--     --     if child:IsA("Model") and child.Name:match("Horse") and child:GetAttribute("HorseId") then
--     --         horseId = child:GetAttribute("HorseId")
--     --         break
--     --     end
--     -- end
--     -- if not horseId then warn("Horse not found") return end

--     local displayGui = humanoidRootPart:FindFirstChild("PlayerDisplayName")
--     -- if not displayGui then warn("PlayerDisplayName not found") return end
--     if not displayGui then return end
--     local defaultStudsOffset = PlayerNameTemple.StudsOffsetWorldSpace
--     -- local sizeScale = HorsesDataHelper.GetSizeScale(horseId)
--     -- local meshScaleY = HorsesDataHelper.GetMeshScaleY(horseId)
--     -- local horseScale = character:WaitForChild("Horse"):GetScale()
--     -- local horseScale = HorsesDataHelper.GetCurrentHorseRelativeScale(PlayerDataController:GetData())
--     -- local horseScale = 1

--     -- local heightScale = character.Humanoid.BodyHeightScale.Value
--     -- local heightScale = character:WaitForChild("Humanoid"):WaitForChild("BodyHeightScale").Value
--     -- LogHelper.Print("UpdateDisplayPosition", sizeScale, meshScaleY, heightScale)

--     -- 1.4 is default humanoid height scale
--     -- displayGui.StudsOffsetWorldSpace = Vector3.new(defaultStudsOffset.x, defaultStudsOffset.y + ((sizeScale*meshScaleY -1)*5) + ((heightScale-1.4)/1.4*2), defaultStudsOffset.z)
--     displayGui.StudsOffsetWorldSpace = Vector3.new(defaultStudsOffset.x, defaultStudsOffset.y + ((horseScale -1)*2) , defaultStudsOffset.z)
-- end

local function updatePlayerDisplaySize(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    -- local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local playerDisplayName = character:FindFirstChild("PlayerDisplayName")
    -- if not playerDisplayName then warn("PlayerDisplayName not found") return end
    if not playerDisplayName then return end
	if not PlayerNameTemple then
		return
	end

    local scale = character:GetScale()

    playerDisplayName.Size = UDim2.new(PlayerNameTemple.Size.X.Scale * scale, 0, PlayerNameTemple.Size.Y.Scale * scale , 0)
    playerDisplayName.StudsOffsetWorldSpace = PlayerNameTemple.StudsOffsetWorldSpace * scale

    if player == localPlayer then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
            EffectUtil.PlayBodySizeChangeEffect(humanoidRootPart, scale)
        end
    end
end

-- local function makeCharacetUpright()
--     local charatcter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
--     if not charatcter:FindFirstChild("Humanoid") then warn("Humanoid not found") return end

--     charatcter.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
--     charatcter.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

--     -- keep chracater upright
--     if charatcter.HumanoidRootPart:FindFirstChild("BodyGyro") then
--         charatcter.HumanoidRootPart.BodyGyro:Destroy()
--     end
--     local bodyGyro = Instance.new("BodyGyro")
--     bodyGyro.Name = "BodyGyro"
--     bodyGyro.Parent = charatcter.HumanoidRootPart
--     bodyGyro.MaxTorque = Vector3.new(math.huge, 0, math.huge)
-- end

function CharacterController:UpdateAllPlayerDisplayTag()
    for _, player in pairs(PlayerService:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
        character:WaitForChild("HumanoidRootPart")

        -- [👑VIP] [💪#1] [🏆#1] [🥚#1] [💰#1] [🔄#1] [🕕#1]  
        local playerDisplayName = character:FindFirstChild("PlayerDisplayName")
        if playerDisplayName then
            local tagText = self:GetTagText(player.UserId)
            playerDisplayName.TagsLabel.Text = tagText
        end
    end
end

function CharacterController:GetTagText(userId: number): string
    local player = PlayerService:GetPlayerByUserId(userId)
    local tagText = if player and player:GetAttribute("HasVIP") then "👑 VIP" else ""
    local leaderboardData = playersInLeaderboard[tostring(userId)]
    if not leaderboardData then return tagText end
    for type, index in pairs(leaderboardData) do
        if type == "Trophy" then
            tagText = tagText .. " [🏆#" .. index .. "]"
        elseif type == "Wins" then
            tagText = tagText .. " [💵#" .. index .. "]"
        elseif type == "Weight" then
            tagText = tagText .. " [⚖️#" .. index .. "]"
        end
    end
    return tagText
end

local function updateMovementSpeed()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local playerData = PlayerDataController:GetData()
    local zoneWalkSpeedPercent = localPlayer:GetAttribute(MovementSpeedUtil.ZONE_WALK_SPEED_PERCENT_ATTRIBUTE)
    local walkSpeed = MovementSpeedUtil.CalculateWalkSpeed(playerData, zoneWalkSpeedPercent)

    humanoid.WalkSpeed = walkSpeed
end

function CharacterController:UpdateMoveSpeed()
    updateMovementSpeed()
end

-- function CharacterController:UpdateMoveSpeed()
--     -- local moveSpeed = GameDataUtil.CalculateMoveSpeed(PlayerDataController:GetData(), defaultMovementSpeed)
--     local moveSpeed = GameDataUtil.CalculateMoveSpeed(

--     local humanoid = character:WaitForChild("Humanoid")
--     humanoid.WalkSpeed = moveSpeed
-- end

local function updateJumpPower()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.UseJumpPower = true
    humanoid.JumpPower = Constants.CHARACTER_DEFAULT_PARAMS.JUMP_POWER
end

function CharacterController:KnitInit()
    -- localPlayer.CharacterAdded:Connect(function(char)
    --     localCharacter = char
    -- end)

end

function CharacterController:KnitStart()
	localPlayer.CharacterAdded:Connect(function(character: Model)
		task.spawn(configureCharacterPhysics, character)
	end)
	localPlayer.CharacterAppearanceLoaded:Connect(function(character: Model)
		task.defer(configureCharacterPhysics, character)
	end)
	if localPlayer.Character then
		task.spawn(configureCharacterPhysics, localPlayer.Character)
	end

    PlayerDataController:GetData()      -- just to make sure it's loaded

    localPlayer:GetAttributeChangedSignal(MovementSpeedUtil.ZONE_WALK_SPEED_PERCENT_ATTRIBUTE):Connect(function()
        task.defer(updateMovementSpeed)
    end)

    -- Initialize all players that are already in the game
    for _, player in pairs(game.Players:GetPlayers()) do
        self:InitPlayerDisplayName(player)
        updatePlayerDisplaySize(player)

        player.CharacterAdded:Connect(function(_char)
            self:InitPlayerDisplayName(player)
            updatePlayerDisplaySize(player)
			self:UpdateAllPlayerDisplayTag()
        end)
		player:GetAttributeChangedSignal("HasVIP"):Connect(function() self:UpdateAllPlayerDisplayTag() end)
    end

    PlayerService.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(_char)
            self:InitPlayerDisplayName(player)
            updatePlayerDisplaySize(player)
			self:UpdateAllPlayerDisplayTag()
        end)
		player:GetAttributeChangedSignal("HasVIP"):Connect(function() self:UpdateAllPlayerDisplayTag() end)
    end)

    -- set player collision group
    -- for _, player in pairs(PlayerService:GetPlayers()) do
    --     if player.Character then
    --         for _, child in pairs(player.Character:GetChildren()) do
    --             CollisionUtil.SetCollisionGroup(child, "Player")
    --         end
    --         player.Character.ChildAdded:Connect(function(child)
    --             CollisionUtil.SetCollisionGroup(child, "Player")
    --         end)
    --     end

    --     player.CharacterAdded:Connect(function(char)
    --         for _, child in pairs(player.Character:GetChildren()) do
    --             CollisionUtil.SetCollisionGroup(child, "Player")
    --         end
    --         char.ChildAdded:Connect(function(child)
    --             CollisionUtil.SetCollisionGroup(child, "Player")
    --         end)
    --     end)
    --  end

    --  PlayerService.PlayerAdded:Connect(function(player)
    --     player.CharacterAdded:Connect(function(char)
    --         for _, child in pairs(player.Character:GetChildren()) do
    --             CollisionUtil.SetCollisionGroup(child, "Player")
    --         end
    --         char.ChildAdded:Connect(function(child)
    --             CollisionUtil.SetCollisionGroup(child, "Player")
    --         end)
    --     end)
    -- end)



    localPlayer.Idled:Connect(function(time)
        if time >= Constants.MAX_IDLED_TIME then
            if not game:GetService("RunService"):IsStudio() then
				TeleportService:Teleport(game.PlaceId)
			else
				LogHelper.Print("TeleportService:Teleport(game.PlaceId) is not allowed in studio")
			end
        end
    end)

    local GlobalLeaderboardService = Knit.GetService("GlobalLeaderboardService")
    GlobalLeaderboardService.UpdatePlayersInLeaderboard:Connect(function(playersData: {[string]: {[string]: number}})
        LogHelper.Print("UpdatePlayersInLeaderboard", playersData)
        playersInLeaderboard = playersData
        self:UpdateAllPlayerDisplayTag()
    end)

	Knit.GetService("GamePassService").GiveGamePass:Connect(function(gamePassId)
		if gamePassId == Constants.GAMEPASS.FAST_MOVE then task.defer(updateMovementSpeed) end
	end)

    self:Init()
    -- self:UpdatePhysicalProperties()

    updatePlayerDisplaySize(localPlayer)

    task.delay(2, updateMovementSpeed)
    
end

return CharacterController
