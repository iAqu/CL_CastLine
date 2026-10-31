local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ConditionLabelUtil = require(ReplicatedStorage.Modules.ConditionLabelUtil)
local DigMoundEffect = require(ReplicatedStorage.Modules.DigMoundEffect)
local DigRevealEffectUtil = require(ReplicatedStorage.Modules.DigRevealEffectUtil)
local DigSilhouetteUtil = require(ReplicatedStorage.Modules.DigSilhouetteUtil)
local DropVFXUtil = require(ReplicatedStorage.Modules.DropVFXUtil)
local FovController = require(ReplicatedStorage.Modules.FovController)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemTitlePositionUtil = require(ReplicatedStorage.Modules.ItemTitlePositionUtil)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local MutationTitleUtil = require(ReplicatedStorage.Modules.MutationTitleUtil)
local MutationVisualUtil = require(ReplicatedStorage.Modules.MutationVisualUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PickupFlyEffectUtil = require(ReplicatedStorage.Modules.PickupFlyEffectUtil)
local PromptUtil = require(ReplicatedStorage.Modules.PromptUtil)
local RarityRevealConfig = require(ReplicatedStorage.Modules.RarityRevealConfig)
local ShovelToolUtil = require(ReplicatedStorage.Modules.ShovelToolUtil)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local ItemsData = require(ReplicatedFirst.Data.ItemsData)

local LOCAL_PLAYER = Players.LocalPlayer

local DigController = Knit.CreateController({
	Name = "DigController",
})

export type DigSite = {
	sourceModel: Model,
	anchor: BasePart,
	prompt: ProximityPrompt,
	promptHighlight: Highlight?,
	digPosition: Vector3,
	originalTransparency: { [BasePart]: number },
	sourceDescendantConnection: RBXScriptConnection?,
	isBusy: boolean,
	mound: DigMoundEffect.MoundSession?,
	titleGui: BillboardGui?,
	healthGui: BillboardGui?,
	healthProgressBar: TextLabel?,
	healthLabel: TextLabel?,
	healthTween: Tween?,
	isFinalizing: boolean,
	isInitialized: boolean,
	beamVisible: boolean?,
	idleDropVFX: DropVFXUtil.DropVFXSession?,
	resolvedItemId: string?,
	resolvedIsRareReward: boolean,
	resolvedWeight: number?,
	resolvedBasePrice: number?,
	resolvedMutationId: string?,
	resolvedFootprint: Vector2?,
	resolvedBounds: Vector3?,
}

type ActiveSession = {
	site: DigSite,
	silhouette: DigSilhouetteUtil.SilhouetteSession,
	mound: DigMoundEffect.MoundSession,
	idleTrack: AnimationTrack?,
	digTrack: AnimationTrack?,
	digSpeedMultiplier: number,
	digInterval: number,
	presentationConn: RBXScriptConnection?,
	presentationFromProgress: number,
	presentationTargetProgress: number,
	presentationCurrentProgress: number,
	presentationStartedAt: number,
	restoreWalkSpeed: number,
	shovelTool: Tool?,
	isShowcasing: boolean,
	dropVFX: DropVFXUtil.DropVFXSession?,
	showcaseTitleAnchor: BasePart?,
	revealedModel: Model?,
	revealSizeScale: number,
}

type OtherPlayerDigRevealPayload = {
	Player: Player,
	ItemId: string,
	Weight: number,
	Rarity: string,
	GroundPosition: Vector3,
	RevealCFrame: CFrame,
	MutationId: string?,
}

local GENERATED_FOLDER_NAME = "GeneratedItems"
local TUTORIAL_FOLDER_NAME = "TutorialGeneratedItems"
local GENERATED_ATTRIBUTE = "GeneratedDigItem"
local TUTORIAL_OWNER_ATTRIBUTE = "TutorialOwnerUserId"
local PROMPT_NAME = "DigPrompt"
local PROMPT_HIGHLIGHT_NAME = "DigPromptHighlight"
local POP_DIP_DURATION = 0.16
local POP_DIP_DEPTH = 0.55
local POP_DURATION = 0.5
local POP_DIP_SCALE = 0.82
local SPIN_DURATION = 1.35
local SPIN_TURNS = 2
local FLOAT_DURATION = 1
local FLOAT_AMPLITUDE = 0.15
local FLOAT_SPEED = 2
local SHOWCASE_MIN_GROUND_CLEARANCE = 5
local SHOWCASE_DURATION = POP_DIP_DURATION + POP_DURATION + SPIN_DURATION + FLOAT_DURATION
local HEALTH_TWEEN_DURATION = 0.15
local HEALTH_HIDE_DELAY = 0.3
local PRICE_ROLL_DURATION = 0.9
local DIG_PROGRESS_TWEEN_DURATION = 0.32
local DEFAULT_DIG_INTERVAL = 0.6
local MIN_LOCAL_DIG_INTERVAL = 0.05
local DIG_SITE_REFRESH_INTERVAL = 0.1
local DIG_CAMERA_PUNCH_RENDER_STEP = "SeaDigDigCameraPunch"
local DIG_CAMERA_PUNCH_DURATION = 0.22
local HEALTH_COLOR_LOW = Color3.fromRGB(230, 60, 60)
local HEALTH_COLOR_HIGH = Color3.fromRGB(90, 230, 120)
local TITLE_WEIGHT_COLOR = "#B1DAF8"

local animationFolder = ReplicatedStorage:WaitForChild("Animation"):WaitForChild("Character")
local digIdleAnimation = animationFolder:WaitForChild("Dig_Idle")
local digAnimation = animationFolder:WaitForChild("Dig")

local titleGuiFolder = LOCAL_PLAYER:WaitForChild("PlayerGui"):WaitForChild("TitleGui")
local itemTitleTemplate = titleGuiFolder:WaitForChild("ItemTitleTemplate_New") :: BillboardGui
local itemHealthTemplate = titleGuiFolder:WaitForChild("ItemHealthTemplate") :: BillboardGui
itemTitleTemplate.Enabled = false
itemHealthTemplate.Enabled = false

local sitesByModel: { [Model]: DigSite } = {}
local sitesById: { [string]: DigSite } = {}
local boundFolders: { [Folder]: boolean } = {}
local personalSnapshotsBySiteId: { [string]: any } = {}
local activeSession: ActiveSession? = nil
local showcasingSessions: { [ActiveSession]: boolean } = {}
local nearestPromptSite: DigSite? = nil
local cameraPunchStartedAt: number? = nil
local isCameraPunchBound = false
local tutorialDigEnabled = false
local digSiteRefreshElapsed = DIG_SITE_REFRESH_INTERVAL
local digSiteRefreshDirty = true

local function updateSiteBeamVisibility(site: DigSite, waterTop: BasePart?)
	local mound = site.mound
	if not mound or not mound.folder.Parent then
		return
	end

	local isVisible = not WaterSurfaceUtil.IsPointSubmerged(mound.groundPosition, waterTop)
	if site.beamVisible == isVisible then
		if site.idleDropVFX then
			site.idleDropVFX:SetVisible(isVisible)
		end
		return
	end
	mound:SetBeamVisible(isVisible)
	if site.idleDropVFX then
		site.idleDropVFX:SetVisible(isVisible)
	end
	site.beamVisible = isVisible
end

local function formatTitleName(name: string, weight: number?): string
	return `{name} <font color="{TITLE_WEIGHT_COLOR}">[{WeightFormat.FormatKg(weight)}]</font>`
end

local function formatUnknownTitle(weight: number?): string
	return if typeof(weight) == "number" then formatTitleName("???", weight) else "???"
end

local function cancelServerReservation(model: Model)
	Knit.GetService("DigItemService"):CancelDig(model):catch(function()
		-- The server loop also cancels when the player, shovel, or distance becomes invalid.
	end)
end

local function getPrimaryPart(model: Model): BasePart?
	if model.PrimaryPart then
		return model.PrimaryPart
	end
	return model:FindFirstChildWhichIsA("BasePart", true)
end

local function hideSourceModel(model: Model): ({ [BasePart]: number }, RBXScriptConnection)
	local saved: { [BasePart]: number } = {}
	local function hidePart(part: BasePart)
		if part.Name == "DigAnchor" or saved[part] ~= nil then
			return
		end
		saved[part] = part.Transparency
		part.Transparency = 1
		part.CanQuery = false
	end

	local descendantConnection = model.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			hidePart(descendant)
		end
	end)
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			hidePart(descendant)
		end
	end
	return saved, descendantConnection
end

local function restoreSourceModel(saved: { [BasePart]: number })
	for part, transparency in saved do
		if part.Parent then
			part.Transparency = transparency
			part.CanQuery = true
		end
	end
end

local function getCharacterParts(): (Model?, Humanoid?, BasePart?)
	local character = LOCAL_PLAYER.Character
	if not character then
		return nil, nil, nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not humanoid or not root then
		return character, nil, nil
	end
	return character, humanoid, root
end

local function getPromptTieBreaker(site: DigSite): string
	local itemInstanceId = site.sourceModel:GetAttribute("ItemInstanceId")
	return if typeof(itemInstanceId) == "string" then itemInstanceId else site.sourceModel.Name
end

local function refreshDigSiteState()
	local previousNearest = nearestPromptSite
	local nearest: DigSite? = nil
	local nearestDistanceSquared = math.huge
	local maxDistanceSquared = PromptUtil.PROMPT_MAX_DISTANCE ^ 2
	local _, humanoid, root = getCharacterParts()
	local canSelectPrompt = not activeSession and humanoid ~= nil and humanoid.Health > 0 and root ~= nil
	local rootPosition = if root then root.Position else nil
	local waterTop = WaterSurfaceUtil.GetWaterTop()

	for _, site in pairs(sitesByModel) do
		updateSiteBeamVisibility(site, waterTop)
		local tutorialOwnerUserId = site.sourceModel:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE)
		local tutorialAvailable = typeof(tutorialOwnerUserId) ~= "number" or tutorialDigEnabled
		if canSelectPrompt
			and rootPosition
			and site.isInitialized
			and tutorialAvailable
			and site.sourceModel.Parent
			and not site.isBusy
			and site.sourceModel:GetAttribute("DigReserved") ~= true
			and not WaterSurfaceUtil.IsPointSubmerged(site.digPosition, waterTop)
		then
			local offset = rootPosition - site.anchor.Position
			local distanceSquared = offset.X * offset.X + offset.Y * offset.Y + offset.Z * offset.Z
			if distanceSquared <= maxDistanceSquared then
				if distanceSquared < nearestDistanceSquared
					or (
						distanceSquared == nearestDistanceSquared
						and nearest
						and getPromptTieBreaker(site) < getPromptTieBreaker(nearest)
					)
				then
					nearest = site
					nearestDistanceSquared = distanceSquared
				end
			end
		end
	end

	nearestPromptSite = nearest
	if previousNearest ~= nearest then
		if previousNearest and previousNearest.prompt.Enabled then
			previousNearest.prompt.Enabled = false
		end
		if nearest then
			nearest.prompt.Enabled = true
		end
	elseif nearest and not nearest.prompt.Enabled then
		nearest.prompt.Enabled = true
	end
	digSiteRefreshElapsed = 0
	digSiteRefreshDirty = false
end

local function refreshNearestDigPrompt()
	digSiteRefreshDirty = true
	refreshDigSiteState()
end

local function ensureShovelEquipped(): boolean
	local character, humanoid = getCharacterParts()
	if not character or not humanoid or humanoid.Health <= 0 then
		return false
	end

	local equipped = ShovelToolUtil.FindShovelTool(character)
	if equipped then
		ShovelToolUtil.ApplyIdleGrip(equipped)
		return true
	end

	local shovel = ShovelToolUtil.FindShovelTool(LOCAL_PLAYER:FindFirstChildOfClass("Backpack"))
	if not shovel then
		return false
	end

	local ok = pcall(function()
		humanoid:EquipTool(shovel)
	end)
	local equippedAfter = ShovelToolUtil.FindShovelTool(character)
	if equippedAfter then
		ShovelToolUtil.ApplyIdleGrip(equippedAfter)
	end
	return ok and equippedAfter ~= nil
end

local function getAnimator(humanoid: Humanoid): Animator
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
	return animator
end

local function faceDigPoint(root: BasePart, digPosition: Vector3)
	root.CFrame = CFrame.lookAt(
		root.Position,
		Vector3.new(digPosition.X, root.Position.Y, digPosition.Z)
	)
end

local function stopDigCameraPunch()
	cameraPunchStartedAt = nil
	if not isCameraPunchBound then
		return
	end

	isCameraPunchBound = false
	RunService:UnbindFromRenderStep(DIG_CAMERA_PUNCH_RENDER_STEP)
end

local function playDigCameraPunch()
	cameraPunchStartedAt = os.clock()
	if isCameraPunchBound then
		return
	end

	isCameraPunchBound = true
	RunService:BindToRenderStep(DIG_CAMERA_PUNCH_RENDER_STEP, Enum.RenderPriority.Camera.Value + 1, function()
		local startedAt = cameraPunchStartedAt
		local elapsed = if startedAt then os.clock() - startedAt else math.huge
		local camera = Workspace.CurrentCamera
		if not camera or elapsed >= DIG_CAMERA_PUNCH_DURATION then
			stopDigCameraPunch()
			return
		end

		local impulse = math.sin(elapsed * 40) * (1 - elapsed / DIG_CAMERA_PUNCH_DURATION) ^ 2
		camera.CFrame = camera.CFrame
			* CFrame.new(0, impulse * 0.1, impulse * 0.05)
			* CFrame.Angles(impulse * 0.006, 0, 0)
	end)
end

local function stopAnimationTracks(session: ActiveSession)
	if session.digTrack then
		session.digTrack:Stop(0.1)
	end
	if session.idleTrack then
		session.idleTrack:Stop(0.1)
	end
end

local function stopProgressPresentation(session: ActiveSession)
	if session.presentationConn then
		session.presentationConn:Disconnect()
		session.presentationConn = nil
	end
end

local function updateProgressPresentation(session: ActiveSession, now: number)
	local alpha = math.clamp((now - session.presentationStartedAt) / DIG_PROGRESS_TWEEN_DURATION, 0, 1)
	local eased = TweenService:GetValue(alpha, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local progress = session.presentationFromProgress
		+ (session.presentationTargetProgress - session.presentationFromProgress) * eased
	session.presentationCurrentProgress = progress
	session.silhouette:SetProgress(progress)
	session.mound:SetProgress(progress)
end

local function startProgressPresentation(session: ActiveSession)
	stopProgressPresentation(session)
	session.presentationConn = RunService.RenderStepped:Connect(function()
		if activeSession ~= session or session.isShowcasing then
			stopProgressPresentation(session)
			return
		end
		updateProgressPresentation(session, os.clock())
	end)
end

local function playLocalDigPresentation(session: ActiveSession): boolean
	if activeSession ~= session or session.isShowcasing then
		return false
	end

	if session.digTrack then
		session.digTrack:Stop(0)
		session.digTrack:Play(0.05, 1, session.digSpeedMultiplier)
	end
	playDigCameraPunch()
	local strength = 0.45 + session.presentationCurrentProgress * 0.55
	session.mound:Progress(strength)
	session.silhouette:Kick(strength)
	return true
end

local function startLocalDigPresentation(session: ActiveSession)
	if not playLocalDigPresentation(session) then
		return
	end

	task.spawn(function()
		local nextDigAt = os.clock() + math.max(MIN_LOCAL_DIG_INTERVAL, session.digInterval)
		while activeSession == session and not session.isShowcasing do
			local waitDuration = nextDigAt - os.clock()
			if waitDuration > 0 then
				task.wait(waitDuration)
			else
				task.wait()
			end
			if not playLocalDigPresentation(session) then
				return
			end

			local interval = math.max(MIN_LOCAL_DIG_INTERVAL, session.digInterval)
			nextDigAt += interval
			local now = os.clock()
			if nextDigAt <= now then
				nextDigAt = now + interval
			end
		end
	end)
end

local function setPromptHighlightEnabled(site: DigSite, enabled: boolean)
	local highlight = site.promptHighlight
	if highlight and highlight.Parent then
		highlight.Enabled = enabled
	end
end

local function destroySiteMound(site: DigSite)
	setPromptHighlightEnabled(site, false)
	site.promptHighlight = nil
	site.beamVisible = nil
	if site.idleDropVFX then
		site.idleDropVFX:Destroy()
		site.idleDropVFX = nil
	end
	if site.mound then
		site.mound:Destroy()
		site.mound = nil
	end
end

local function ensurePromptHighlight(adornee: Instance): Highlight
	local existing = adornee:FindFirstChild(PROMPT_HIGHLIGHT_NAME)
	if existing and existing:IsA("Highlight") then
		existing.Adornee = adornee
		existing.FillTransparency = 1
		existing.OutlineColor = Color3.new(1, 1, 1)
		existing.OutlineTransparency = 0
		existing.DepthMode = Enum.HighlightDepthMode.Occluded
		existing.Enabled = false
		return existing
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = PROMPT_HIGHLIGHT_NAME
	highlight.Adornee = adornee
	highlight.FillTransparency = 1
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Enabled = false
	highlight.Parent = adornee
	return highlight
end

local function cancelHealthTween(site: DigSite)
	if site.healthTween then
		site.healthTween:Cancel()
		site.healthTween = nil
	end
end

local function getHealthBarColor(ratio: number): Color3
	return HEALTH_COLOR_LOW:Lerp(HEALTH_COLOR_HIGH, math.clamp(ratio, 0, 1))
end

local function resetHealthDisplay(site: DigSite)
	if not site.healthProgressBar or not site.healthLabel then
		return
	end

	cancelHealthTween(site)
	local maxHealth = math.max(1, tonumber(site.sourceModel:GetAttribute("MaxHealth")) or 1)
	local currentHealth = math.clamp(
		tonumber(site.sourceModel:GetAttribute("CurrentHealth")) or maxHealth,
		0,
		maxHealth
	)
	site.healthLabel.Text = `{math.round(currentHealth)}/{math.round(maxHealth)}`
	local progressBar = site.healthProgressBar
	local ratio = currentHealth / maxHealth
	progressBar.Size = UDim2.fromScale(ratio, 1)
	progressBar.BackgroundColor3 = getHealthBarColor(ratio)
end

local function applyHealthSnapshot(site: DigSite, currentHealth: number, maxHealth: number)
	if not site.healthProgressBar or not site.healthLabel then
		return
	end

	local safeMax = math.max(1, maxHealth)
	local current = math.clamp(currentHealth, 0, safeMax)
	site.healthLabel.Text = `{math.round(current)}/{math.round(safeMax)}`

	local ratio = current / safeMax
	local progressBar = site.healthProgressBar
	local targetSize = UDim2.fromScale(ratio, 1)

	cancelHealthTween(site)
	local tween = TweenService:Create(
		progressBar,
		TweenInfo.new(HEALTH_TWEEN_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = targetSize,
			BackgroundColor3 = getHealthBarColor(ratio),
		}
	)
	site.healthTween = tween
	tween:Play()
end

local function showIdleTitleGui(site: DigSite)
	if site.titleGui then
		site.titleGui.StudsOffsetWorldSpace = itemTitleTemplate.StudsOffsetWorldSpace
		site.titleGui.Enabled = true
	end
	if site.healthGui then
		site.healthGui.Enabled = false
	end
	resetHealthDisplay(site)
end

local function showDiggingHealthGui(site: DigSite)
	if site.titleGui then
		site.titleGui.Enabled = false
	end
	if site.healthGui then
		site.healthGui.Enabled = true
	end
	resetHealthDisplay(site)
end

local function hideHealthGuiDelayed(site: DigSite)
	task.delay(HEALTH_HIDE_DELAY, function()
		if sitesByModel[site.sourceModel] ~= site then
			return
		end
		if site.healthGui then
			site.healthGui.Enabled = false
		end
	end)
end

local function createSiteBillboards(site: DigSite, anchor: BasePart)
	local titleGui = itemTitleTemplate:Clone()
	titleGui.Name = "DigItemTitle"
	titleGui.Adornee = anchor
	titleGui.Parent = anchor
	titleGui.Enabled = false

	local healthGui = itemHealthTemplate:Clone()
	healthGui.Name = "DigItemHealth"
	healthGui.Adornee = anchor
	healthGui.Parent = anchor
	healthGui.Enabled = false

	local frame = healthGui:WaitForChild("Frame")
	local healthProgress = frame:WaitForChild("HealthProgress")
	local progressBar = healthProgress:WaitForChild("ProgressBar") :: TextLabel
	local healthLabel = frame:WaitForChild("HealthLabel") :: TextLabel

	site.titleGui = titleGui
	site.healthGui = healthGui
	site.healthProgressBar = progressBar
	site.healthLabel = healthLabel

	local titleFrame = titleGui:WaitForChild("Frame")
	local nameLabel = titleFrame:WaitForChild("NameLabel") :: TextLabel
	local rarityLabel = titleFrame:WaitForChild("RarityLabel") :: TextLabel
	local priceLabel = titleFrame:WaitForChild("PriceLabel") :: TextLabel
	local luckLabel = titleFrame:WaitForChild("LuckLabel") :: TextLabel
	local newTag = titleFrame:FindFirstChild("NewTag")
	nameLabel.RichText = true
	nameLabel.Text = "???"
	nameLabel.Visible = true
	ConditionLabelUtil.HideAll(titleFrame)
	MutationTitleUtil.Hide(titleFrame)
	luckLabel.Text = ""
	luckLabel.Visible = false
	if newTag and newTag:IsA("GuiObject") then
		newTag.Visible = false
	end
	local configuredRarity = site.sourceModel:GetAttribute("Rarity")
	local rarity = if typeof(configuredRarity) == "string" then configuredRarity else "Common"
	rarityLabel.Text = rarity
	GuiUtil.SetRarityGradient(rarityLabel, rarity)
	priceLabel.Text = "$?"
end

local function getSiteRarity(site: DigSite): string?
	local configuredRarity = site.sourceModel:GetAttribute("Rarity")
	if typeof(configuredRarity) == "string" then
		return configuredRarity
	end

	local itemId = site.sourceModel:GetAttribute("ItemId")
	local item = typeof(itemId) == "string" and ItemsData[itemId] or nil
	return item and item.Rarity or nil
end

local function shouldPlayInitialDropVFX(site: DigSite): boolean
	return getSiteRarity(site) == "Secret" and site.resolvedIsRareReward
end

local function ensureInitialDropVFX(site: DigSite, mound: DigMoundEffect.MoundSession)
	if site.idleDropVFX or not shouldPlayInitialDropVFX(site) or not site.resolvedFootprint then
		return
	end

	local horizontalSize = math.max(site.resolvedFootprint.X, site.resolvedFootprint.Y)
	site.idleDropVFX = DropVFXUtil.PlayAtPosition(mound.groundPosition, horizontalSize, mound.rarity)
end

local function applyResolvedPreview(site: DigSite, snapshot): boolean
	local itemId = typeof(snapshot) == "table" and snapshot.ItemId or nil
	local weight = typeof(snapshot) == "table" and snapshot.Weight or nil
	local basePrice = typeof(snapshot) == "table" and snapshot.BasePrice or nil
	local footprint = typeof(snapshot) == "table" and snapshot.Footprint or nil
	local bounds = typeof(snapshot) == "table" and snapshot.Bounds or nil
	local isRareReward = typeof(snapshot) == "table" and snapshot.IsRareReward or nil
	local mutationId = if typeof(snapshot) == "table"
		then MutationDataUtil.NormalizeMutationId(snapshot.MutationId)
		else nil
	if typeof(weight) ~= "number"
		or typeof(basePrice) ~= "number"
		or typeof(footprint) ~= "Vector2"
		or footprint.X <= 0
		or footprint.Y <= 0
	then
		return false
	end
	local resolvedBounds = if typeof(bounds) == "Vector3"
		and bounds.X > 0
		and bounds.Y > 0
		and bounds.Z > 0
		then bounds
		else Vector3.new(footprint.X, 0, footprint.Y)
	if itemId ~= nil then
		if typeof(itemId) ~= "string" or not ItemsData[itemId] then
			return false
		end
		site.resolvedItemId = itemId
	end
	site.resolvedWeight = weight
	if typeof(isRareReward) == "boolean" then
		site.resolvedIsRareReward = isRareReward
	end
	site.resolvedBasePrice = basePrice
	site.resolvedMutationId = mutationId
	site.resolvedFootprint = footprint
	site.resolvedBounds = resolvedBounds
	site.isInitialized = true
	local titleGui = site.titleGui
	local frame = titleGui and titleGui:FindFirstChild("Frame")
	if frame then
		local nameLabel = frame:FindFirstChild("NameLabel") :: TextLabel?
		local priceLabel = frame:FindFirstChild("PriceLabel") :: TextLabel?
		if nameLabel then
			nameLabel.RichText = true
			nameLabel.Text = formatUnknownTitle(weight)
		end
		if priceLabel then
			priceLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(basePrice)
		end
	end
	return true
end

local function createResolvedVisual(snapshot): Model?
	local itemId = typeof(snapshot) == "table" and snapshot.ItemId or nil
	local weight = typeof(snapshot) == "table" and snapshot.Weight or nil
	local item = typeof(itemId) == "string" and ItemsData[itemId] or nil
	local models = ReplicatedStorage:FindFirstChild("Models")
	local itemModels = models and models:FindFirstChild("Items")
	local template = item and itemModels and itemModels:FindFirstChild(item.Model)
	if not item or typeof(weight) ~= "number" or not template or not template:IsA("Model") then
		return nil
	end
	local model = template:Clone()
	ItemStatUtil.ScaleModel(model, item, weight, template:GetScale())
	return model
end

local function disconnectSourceDescendantObserver(site: DigSite)
	if site.sourceDescendantConnection then
		site.sourceDescendantConnection:Disconnect()
		site.sourceDescendantConnection = nil
	end
end

local function destroySiteBillboards(site: DigSite)
	cancelHealthTween(site)
	if site.titleGui then
		site.titleGui:Destroy()
		site.titleGui = nil
	end
	if site.healthGui then
		site.healthGui:Destroy()
		site.healthGui = nil
	end
	site.healthProgressBar = nil
	site.healthLabel = nil
end

local function ensureIdleMound(site: DigSite): DigMoundEffect.MoundSession?
	if not site.isInitialized or not site.resolvedFootprint then
		return nil
	end
	if site.mound and site.mound.folder.Parent then
		site.mound:SetProgress(0)
		if not shouldPlayInitialDropVFX(site) and site.idleDropVFX then
			site.idleDropVFX:Destroy()
			site.idleDropVFX = nil
		end
		ensureInitialDropVFX(site, site.mound)
		site.promptHighlight = ensurePromptHighlight(site.mound.folder)
		updateSiteBeamVisibility(site, WaterSurfaceUtil.GetWaterTop())
		return site.mound
	end

	if site.mound then
		if site.idleDropVFX then
			site.idleDropVFX:Destroy()
			site.idleDropVFX = nil
		end
		site.mound = nil
		site.beamVisible = nil
	end

	local mound = DigMoundEffect.Init(
		site.digPosition,
		{ site.sourceModel },
		getSiteRarity(site),
		site.resolvedFootprint,
		site.resolvedBounds
	)
	if not mound then
		return nil
	end

	mound:SetProgress(0)
	site.mound = mound
	site.beamVisible = nil
	ensureInitialDropVFX(site, mound)
	site.promptHighlight = ensurePromptHighlight(mound.folder)
	site.anchor.CFrame = CFrame.new(mound.groundPosition + mound.groundNormal * 0.5)
	updateSiteBeamVisibility(site, WaterSurfaceUtil.GetWaterTop())

	return mound
end

local function applyPersonalSiteSnapshot(site: DigSite, snapshot): boolean
	local previousFootprint = site.resolvedFootprint
	local previousBounds = site.resolvedBounds
	if not applyResolvedPreview(site, snapshot) then
		return false
	end
	if site.isBusy then
		return true
	end
	local currentFootprint = site.resolvedFootprint
	if not currentFootprint then
		return false
	end
	local footprintChanged = not previousFootprint
		or (previousFootprint - currentFootprint).Magnitude > 0.001
	local currentBounds = site.resolvedBounds
	local boundsChanged = not previousBounds
		or not currentBounds
		or (previousBounds - currentBounds).Magnitude > 0.001
	if site.mound and (footprintChanged or boundsChanged) then
		destroySiteMound(site)
	end
	if not site.mound and not ensureIdleMound(site) then
		site.isInitialized = false
		return false
	end
	showIdleTitleGui(site)
	return true
end

local function cleanupDigSession(session: ActiveSession?, restoreMovement: boolean, restoreMoundIdle: boolean?)
	if not session then
		return
	end

	stopProgressPresentation(session)
	stopAnimationTracks(session)
	stopDigCameraPunch()

	if restoreMovement then
		local _, humanoid = getCharacterParts()
		if humanoid then
			humanoid.WalkSpeed = session.restoreWalkSpeed
			task.defer(function()
				Knit.GetController("CharacterController"):UpdateMoveSpeed()
			end)
		end
	end

	if session.shovelTool and session.shovelTool.Parent then
		ShovelToolUtil.ApplyIdleGrip(session.shovelTool)
	end

	session.silhouette:Destroy()
	if restoreMoundIdle then
		destroySiteMound(session.site)
	end
end

local function resetSite(site: DigSite)
	site.isFinalizing = false
	site.isBusy = false
	if not site.isInitialized then
		site.prompt.Enabled = false
		if site.titleGui then
			site.titleGui.Enabled = false
		end
		if site.healthGui then
			site.healthGui.Enabled = false
		end
		refreshNearestDigPrompt()
		return
	end
	ensureIdleMound(site)
	showIdleTitleGui(site)
	refreshNearestDigPrompt()
end

function DigController:IsDigging(): boolean
	return activeSession ~= nil
end

function DigController:InterruptDigging(): boolean
	local session = activeSession
	if not session then
		return false
	end

	cancelServerReservation(session.site.sourceModel)
	cleanupDigSession(session, true, true)
	activeSession = nil
	resetSite(session.site)
	return true
end

function DigController:SetTutorialDigEnabled(enabled: boolean)
	tutorialDigEnabled = enabled == true
	local session = activeSession
	if not tutorialDigEnabled
		and session
		and session.site.sourceModel:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE) == LOCAL_PLAYER.UserId
	then
		self:InterruptDigging()
	else
		refreshNearestDigPrompt()
	end
end

local function updateShowcaseTitleAnchor(titleAnchor: BasePart?, model: Model)
	if not titleAnchor or not titleAnchor.Parent then
		return
	end
	local boundsCFrame, boundsSize = model:GetBoundingBox()
	titleAnchor.Position = boundsCFrame.Position + Vector3.yAxis * (boundsSize.Y * 0.5)
	local titleGui = titleAnchor:FindFirstChild("DigItemTitle")
	if titleGui and titleGui:IsA("BillboardGui") then
		ItemTitlePositionUtil.ApplyBottomOffset(titleGui, model)
	end
end

local function revealItemTitle(site: DigSite, model: Model, result): BasePart?
	local titleGui = site.titleGui
	if not titleGui then return nil end
	local frame = titleGui:FindFirstChild("Frame")
	if not frame then return nil end
	local nameLabel = frame:FindFirstChild("NameLabel") :: TextLabel?
	local priceLabel = frame:FindFirstChild("PriceLabel") :: TextLabel?
	local luckLabel = frame:FindFirstChild("LuckLabel") :: TextLabel?
	local newTag = frame:FindFirstChild("NewTag")
	if nameLabel then
		local itemId = if result and typeof(result.ItemId) == "string" then result.ItemId else site.resolvedItemId
		local item = typeof(itemId) == "string" and ItemsData[itemId] or nil
		local weight = if result and typeof(result.Weight) == "number" then result.Weight else site.resolvedWeight
		nameLabel.RichText = true
		nameLabel.Text = formatTitleName(item and item.DisplayName or "???", weight)
		nameLabel.Visible = true
	end
	ConditionLabelUtil.Show(frame, if result then result.ConditionId else nil)
	MutationTitleUtil.Show(
		frame,
		if result and result.MutationId ~= nil then result.MutationId else site.resolvedMutationId
	)
	if luckLabel then
		local itemLuck = if result and typeof(result.ItemLuck) == "number" then result.ItemLuck else nil
		luckLabel.Text = if itemLuck then "Luck: " .. ItemStatUtil.FormatLuckPercent(itemLuck) else ""
		luckLabel.Visible = itemLuck ~= nil
	end
	if newTag and newTag:IsA("GuiObject") then
		newTag.Visible = typeof(result) == "table" and result.IsFirstItemAcquisition == true
	end
	local titleAnchor = Instance.new("Part")
	titleAnchor.Name = "DigTitleAnchor"
	titleAnchor.Anchored = true
	titleAnchor.CanCollide = false
	titleAnchor.CanTouch = false
	titleAnchor.CanQuery = false
	titleAnchor.Transparency = 1
	titleAnchor.Size = Vector3.new(0.1, 0.1, 0.1)
	titleAnchor.Parent = model.Parent or Workspace
	updateShowcaseTitleAnchor(titleAnchor, model)

	titleGui.Parent = titleAnchor
	titleGui.Adornee = titleAnchor
	ItemTitlePositionUtil.ApplyBottomOffset(titleGui, model)
	titleGui.Enabled = true

	if not priceLabel then return titleAnchor end
	local basePrice = if result and typeof(result.BasePrice) == "number"
		then result.BasePrice
		else site.resolvedBasePrice or 0
	local finalPrice = if result and typeof(result.Price) == "number"
		then result.Price
		else basePrice
	priceLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(basePrice)
	local value = Instance.new("NumberValue")
	value.Value = basePrice
	local changed = value:GetPropertyChangedSignal("Value"):Connect(function()
		if priceLabel.Parent then
			priceLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(value.Value)
		end
	end)
	local tween = TweenService:Create(value, TweenInfo.new(PRICE_ROLL_DURATION, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Value = finalPrice,
	})
	tween.Completed:Connect(function()
		changed:Disconnect()
		if priceLabel.Parent then
			priceLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(finalPrice)
		end
		value:Destroy()
	end)
	tween:Play()
	return titleAnchor
end

local function getHorizontalRotation(rotation: CFrame): CFrame
	local look = rotation.LookVector
	local horizontalLook = Vector3.new(look.X, 0, look.Z)
	if horizontalLook.Magnitude < 0.001 then
		local right = rotation.RightVector
		local horizontalRight = Vector3.new(right.X, 0, right.Z)
		if horizontalRight.Magnitude < 0.001 then
			return CFrame.identity
		end
		horizontalLook = Vector3.new(horizontalRight.Z, 0, -horizontalRight.X).Unit
	end

	return CFrame.lookAt(Vector3.zero, horizontalLook.Unit, Vector3.yAxis)
end

local function playShowcase(
	model: Model,
	sourceRotation: CFrame,
	groundPosition: Vector3,
	titleAnchor: BasePart?
)
	local showcaseUp = Vector3.yAxis
	local horizontalRotation = getHorizontalRotation(sourceRotation)
	local boundsCFrame = model:GetBoundingBox()
	local initialBoundsPosition = boundsCFrame.Position
	model:PivotTo(CFrame.new(initialBoundsPosition) * horizontalRotation)
	local boundsSize: Vector3
	boundsCFrame, boundsSize = model:GetBoundingBox()
	local boundsToPivot = boundsCFrame:ToObjectSpace(model:GetPivot())
	local boundsRotation = boundsCFrame - boundsCFrame.Position
	local startBoundsCFrame = CFrame.new(initialBoundsPosition) * boundsRotation
	local startCFrame = startBoundsCFrame * boundsToPivot
	local dippedBoundsCFrame = startBoundsCFrame - showcaseUp * POP_DIP_DEPTH
	local targetBottom = groundPosition.Y + SHOWCASE_MIN_GROUND_CLEARANCE + FLOAT_AMPLITUDE
	local currentBottom = boundsCFrame.Position.Y - boundsSize.Y * 0.5
	local uprightBoundsCFrame = boundsCFrame + showcaseUp * (targetBottom - currentBottom)
	local baseScale = model:GetScale()
	local startedAt = os.clock()
	model:PivotTo(startCFrame)
	updateShowcaseTitleAnchor(titleAnchor, model)

	local connection: RBXScriptConnection
	connection = RunService.RenderStepped:Connect(function()
		if not model.Parent then
			connection:Disconnect()
			return
		end

		local elapsed = os.clock() - startedAt
		if elapsed < POP_DIP_DURATION then
			local t = TweenService:GetValue(elapsed / POP_DIP_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			model:PivotTo(startBoundsCFrame:Lerp(dippedBoundsCFrame, t) * boundsToPivot)
			model:ScaleTo(baseScale * (1 - (1 - POP_DIP_SCALE) * t))
		elseif elapsed < POP_DIP_DURATION + POP_DURATION then
			local t = TweenService:GetValue(
				(elapsed - POP_DIP_DURATION) / POP_DURATION,
				Enum.EasingStyle.Back,
				Enum.EasingDirection.Out
			)
			model:PivotTo(dippedBoundsCFrame:Lerp(uprightBoundsCFrame, t) * boundsToPivot)
			model:ScaleTo(baseScale * (POP_DIP_SCALE + (1 - POP_DIP_SCALE) * t))
		else
			model:ScaleTo(baseScale)
			local spinElapsed = elapsed - POP_DIP_DURATION - POP_DURATION
			if spinElapsed < SPIN_DURATION then
				local spinAlpha = spinElapsed / SPIN_DURATION
				local t = TweenService:GetValue(spinAlpha, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local yaw = t * math.pi * 2 * SPIN_TURNS
				model:PivotTo(
					CFrame.new(uprightBoundsCFrame.Position)
						* CFrame.fromAxisAngle(showcaseUp, yaw)
						* boundsRotation
						* boundsToPivot
				)
			else
				local floatElapsed = spinElapsed - SPIN_DURATION
				local offset = math.sin(floatElapsed * FLOAT_SPEED) * FLOAT_AMPLITUDE
				model:PivotTo((uprightBoundsCFrame + showcaseUp * offset) * boundsToPivot)
			end
		end
		updateShowcaseTitleAnchor(titleAnchor, model)
		if elapsed >= SHOWCASE_DURATION then
			connection:Disconnect()
		end
	end)
end

local function shouldPlayDropVFX(site: DigSite, result): boolean
	local itemId = if typeof(result) == "table" and typeof(result.ItemId) == "string"
		then result.ItemId
		else site.resolvedItemId
	local item = typeof(itemId) == "string" and ItemsData[itemId] or nil
	return item ~= nil and item.IsRareReward == 1
end

local function getOtherPlayerDigRevealPayload(payload: unknown): OtherPlayerDigRevealPayload?
	if typeof(payload) ~= "table" then
		return nil
	end
	local player = payload.Player
	local itemId = payload.ItemId
	local weight = payload.Weight
	local rarity = payload.Rarity
	local groundPosition = payload.GroundPosition
	local revealCFrame = payload.RevealCFrame
	local mutationId = MutationDataUtil.NormalizeMutationId(payload.MutationId)
	if not (typeof(player) == "Instance" and player:IsA("Player"))
		or typeof(itemId) ~= "string"
		or not ItemsData[itemId]
		or typeof(weight) ~= "number"
		or typeof(rarity) ~= "string"
		or typeof(groundPosition) ~= "Vector3"
		or typeof(revealCFrame) ~= "CFrame"
	then
		return nil
	end
	return {
		Player = player,
		ItemId = itemId,
		Weight = weight,
		Rarity = rarity,
		GroundPosition = groundPosition,
		RevealCFrame = revealCFrame,
		MutationId = mutationId,
	}
end

local function playOtherPlayerDigReveal(payload: unknown)
	local reveal = getOtherPlayerDigRevealPayload(payload)
	if not reveal or reveal.Player == LOCAL_PLAYER then
		return
	end

	local visual = createResolvedVisual(reveal)
	if not visual then
		return
	end
	local _, bounds = visual:GetBoundingBox()
	local revealSizeScale = RarityRevealConfig.GetSizeScale(bounds)
	local silhouette = DigSilhouetteUtil.Create(visual, reveal.GroundPosition, Vector3.yAxis)
	visual:Destroy()
	if not silhouette then
		return
	end

	local effectsFolder = Workspace:FindFirstChild("DigEffects")
	local revealedModel = silhouette.model
	revealedModel.Parent = effectsFolder or Workspace
	silhouette:SetProgress(1)
	local outlineStyle = DigRevealEffectUtil.GetOutlineStyle(reveal.Rarity)
	revealedModel = silhouette:Reveal(
		outlineStyle.color,
		outlineStyle.transparency,
		outlineStyle.alwaysOnTop
	)
	MutationVisualUtil.Apply(revealedModel, reveal.MutationId)
	local revealPart = getPrimaryPart(revealedModel)
	if revealPart then
		DigMoundEffect.PlayFinishSparkles(revealPart, reveal.Rarity, revealSizeScale)
	end
	DigRevealEffectUtil.PlayBurst(revealedModel, reveal.Rarity, revealSizeScale)

	local item = ItemsData[reveal.ItemId]
	local dropVFX = if item and item.IsRareReward == 1 then DropVFXUtil.Play(revealedModel, reveal.Rarity) else nil
	playShowcase(revealedModel, reveal.RevealCFrame, reveal.GroundPosition, nil)

	task.delay(SHOWCASE_DURATION, function()
		if dropVFX then
			dropVFX:Destroy()
		end
		if revealedModel.Parent then
			revealedModel:Destroy()
		end
		silhouette:Destroy()
	end)
end

local function getReceivedItemDisplayName(site: DigSite, result): string
	local itemId = if typeof(result) == "table" and typeof(result.ItemId) == "string"
		then result.ItemId
		else site.resolvedItemId
	local item = typeof(itemId) == "string" and ItemsData[itemId] or nil
	return item and item.DisplayName or "item"
end

local function playPickupFlyEffect(model: Model): boolean
	local _, _, root = getCharacterParts()
	if not root or not root.Parent then
		return false
	end

	local snapshot = PickupFlyEffectUtil.CreateSnapshot(model)
	if not snapshot then
		return false
	end

	return snapshot:Play(root)
end

local function beginShowcaseSession(session: ActiveSession)
	local shouldEnableShowcaseFov = next(showcasingSessions) == nil
	showcasingSessions[session] = true
	if shouldEnableShowcaseFov then
		FovController.SetAdjuster(FovController.ROLL_ADJUSTER, FovController.ROLL_TWEEN_TIME)
	end
end

local function cleanupShowcaseSession(session: ActiveSession)
	if not showcasingSessions[session] then
		return
	end
	showcasingSessions[session] = nil
	local site = session.site

	if session.dropVFX then
		session.dropVFX:Destroy()
		session.dropVFX = nil
	end

	local revealedModel = session.revealedModel
	if revealedModel then
		revealedModel:Destroy()
		session.revealedModel = nil
	end
	if session.showcaseTitleAnchor then
		session.showcaseTitleAnchor:Destroy()
		session.showcaseTitleAnchor = nil
	end

	session.silhouette:Destroy()
	destroySiteMound(site)
	destroySiteBillboards(site)
	disconnectSourceDescendantObserver(site)
	sitesByModel[site.sourceModel] = nil

	if next(showcasingSessions) == nil then
		FovController.ClearAdjuster(FovController.ROLL_RESTORE_TWEEN_TIME)
	end
end

local function cleanupAllShowcaseSessions()
	local sessions = {}
	for session in pairs(showcasingSessions) do
		table.insert(sessions, session)
	end
	for _, session in ipairs(sessions) do
		cleanupShowcaseSession(session)
	end
end

local function playFinishedDigSession(session: ActiveSession, result)
	if session.isShowcasing then return end
	session.isShowcasing = true
	stopProgressPresentation(session)
	session.presentationFromProgress = 1
	session.presentationTargetProgress = 1
	session.presentationCurrentProgress = 1
	session.silhouette:SetProgress(1)
	session.mound:SetProgress(1)
	stopAnimationTracks(session)

	local _, humanoid = getCharacterParts()
	if humanoid then
		humanoid.WalkSpeed = session.restoreWalkSpeed
		task.defer(function()
			Knit.GetController("CharacterController"):UpdateMoveSpeed()
		end)
	end
	if session.shovelTool and session.shovelTool.Parent then
		ShovelToolUtil.ApplyIdleGrip(session.shovelTool)
	end

	local site = session.site
	setPromptHighlightEnabled(site, false)
	local rarity = session.mound.rarity
	local outlineStyle = DigRevealEffectUtil.GetOutlineStyle(rarity)
	local revealedModel = session.silhouette:Reveal(
		outlineStyle.color,
		outlineStyle.transparency,
		outlineStyle.alwaysOnTop
	)
	MutationVisualUtil.Apply(
		revealedModel,
		if result and result.MutationId ~= nil then result.MutationId else site.resolvedMutationId
	)
	session.revealedModel = revealedModel
	local revealPart = getPrimaryPart(revealedModel) or session.mound.center
	local titleAnchor = revealItemTitle(site, revealedModel, result)
	session.showcaseTitleAnchor = titleAnchor
	if site.idleDropVFX then
		site.idleDropVFX:Destroy()
		site.idleDropVFX = nil
	end
	if shouldPlayDropVFX(site, result) then
		session.dropVFX = DropVFXUtil.Play(revealedModel, rarity)
	end

	local revealStyle = RarityRevealConfig.GetStyle(rarity)
	DigSilhouetteUtil.PlayRevealFlash(
		revealStyle.flashDuration,
		GuiUtil.GetRarityGradientColor(rarity),
		revealStyle.flashBrightness
	)
	DigMoundEffect.PlayFinishSparkles(revealPart, rarity, session.revealSizeScale)
	DigRevealEffectUtil.PlayBurst(revealedModel, rarity, session.revealSizeScale)
	DigMoundEffect.PlayRevealSound(revealPart, rarity)
	session.mound:Clear(false)
	site.mound = nil
	site.promptHighlight = nil
	site.beamVisible = nil
	beginShowcaseSession(session)
	if activeSession == session then
		activeSession = nil
		refreshNearestDigPrompt()
	end
	hideHealthGuiDelayed(site)

	playShowcase(revealedModel, session.silhouette.sourceRotation, session.mound.groundPosition, titleAnchor)

	task.delay(SHOWCASE_DURATION, function()
		if not showcasingSessions[session] then
			return
		end
		local didStartPickupFly = playPickupFlyEffect(revealedModel)
		if didStartPickupFly then
			NotificationClient.GreenNotify("Got " .. getReceivedItemDisplayName(site, result))
		end
		revealedModel:Destroy()
		session.revealedModel = nil
		cleanupShowcaseSession(session)
	end)
end

local function startDigSession(site: DigSite, serverSnapshot)
	if activeSession or site.isBusy then
		return
	end

	local _, humanoid, root = getCharacterParts()
	if not humanoid or not root or humanoid.Health <= 0 then
		return
	end

	site.isBusy = true
	site.prompt.Enabled = false
	setPromptHighlightEnabled(site, false)
	faceDigPoint(root, site.digPosition)
	if not applyResolvedPreview(site, serverSnapshot) then
		cancelServerReservation(site.sourceModel)
		resetSite(site)
		return
	end

	local mound = ensureIdleMound(site)
	if not mound then
		cancelServerReservation(site.sourceModel)
		resetSite(site)
		return
	end

	local resolvedVisual = createResolvedVisual(serverSnapshot)
	if not resolvedVisual then
		cancelServerReservation(site.sourceModel)
		resetSite(site)
		return
	end
	local _, resolvedBounds = resolvedVisual:GetBoundingBox()
	local revealSizeScale = RarityRevealConfig.GetSizeScale(resolvedBounds)
	local silhouette = DigSilhouetteUtil.Create(resolvedVisual, mound.groundPosition, mound.groundNormal)
	resolvedVisual:Destroy()
	if not silhouette then
		cancelServerReservation(site.sourceModel)
		resetSite(site)
		return
	end

	local effectsFolder = Workspace:FindFirstChild("DigEffects")
	silhouette.model.Parent = effectsFolder or Workspace
	silhouette:SetProgress(0)
	mound:SetProgress(0)

	local character = LOCAL_PLAYER.Character
	local shovelTool = character and ShovelToolUtil.FindShovelTool(character)
	if shovelTool then
		ShovelToolUtil.ApplyDigGrip(shovelTool)
	end

	local animator = getAnimator(humanoid)
	local idleTrack = animator:LoadAnimation(digIdleAnimation)
	idleTrack.Priority = Enum.AnimationPriority.Action
	idleTrack.Looped = true
	idleTrack:Play(0.1)

	local digTrack = animator:LoadAnimation(digAnimation)
	digTrack.Priority = Enum.AnimationPriority.Action2
	digTrack.Looped = false

	local restoreWalkSpeed = humanoid.WalkSpeed
	humanoid.WalkSpeed = 0
	showDiggingHealthGui(site)
	local digSpeedMultiplier = if typeof(serverSnapshot) == "table"
		and typeof(serverSnapshot.DigSpeedMultiplier) == "number"
		and serverSnapshot.DigSpeedMultiplier > 0
		then serverSnapshot.DigSpeedMultiplier
		else 1
	local digInterval = if typeof(serverSnapshot) == "table"
		and typeof(serverSnapshot.Interval) == "number"
		and serverSnapshot.Interval > 0
		then serverSnapshot.Interval
		else DEFAULT_DIG_INTERVAL / digSpeedMultiplier

	local session: ActiveSession = {
		site = site,
		silhouette = silhouette,
		mound = mound,
		idleTrack = idleTrack,
		digTrack = digTrack,
		digSpeedMultiplier = digSpeedMultiplier,
		digInterval = digInterval,
		presentationConn = nil,
		presentationFromProgress = 0,
		presentationTargetProgress = 0,
		presentationCurrentProgress = 0,
		presentationStartedAt = os.clock(),
		restoreWalkSpeed = restoreWalkSpeed,
		shovelTool = shovelTool,
		isShowcasing = false,
		dropVFX = nil,
		showcaseTitleAnchor = nil,
		revealedModel = nil,
		revealSizeScale = revealSizeScale,
	}
	activeSession = session
	refreshNearestDigPrompt()
	site.isFinalizing = true
	local maxHealth = if serverSnapshot and typeof(serverSnapshot.MaxHealth) == "number"
		then serverSnapshot.MaxHealth
		else tonumber(site.sourceModel:GetAttribute("MaxHealth")) or 1
	local currentHealth = if serverSnapshot and typeof(serverSnapshot.CurrentHealth) == "number"
		then serverSnapshot.CurrentHealth
		else tonumber(site.sourceModel:GetAttribute("CurrentHealth")) or maxHealth
	local progress = 1 - math.clamp(currentHealth / math.max(1, maxHealth), 0, 1)
	session.presentationFromProgress = progress
	session.presentationTargetProgress = progress
	session.presentationCurrentProgress = progress
	silhouette:SetProgress(progress)
	mound:SetProgress(progress)
	applyHealthSnapshot(site, currentHealth, maxHealth)
	startProgressPresentation(session)
	startLocalDigPresentation(session)
end

local function registerDigSite(sourceModel: Model)
	local tutorialOwnerUserId = sourceModel:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE)
	if typeof(tutorialOwnerUserId) == "number" and tutorialOwnerUserId ~= LOCAL_PLAYER.UserId then
		return
	end
	if sitesByModel[sourceModel] or sourceModel:GetAttribute(GENERATED_ATTRIBUTE) ~= true then
		return
	end

	local configuredPosition = sourceModel:GetAttribute("DigSurfacePosition")
	local digPosition = if typeof(configuredPosition) == "Vector3" then configuredPosition else sourceModel:GetPivot().Position

	local anchor = Instance.new("Part")
	anchor.Name = "DigAnchor"
	anchor.Size = Vector3.new(4, 1, 4)
	anchor.Transparency = 1
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = true
	anchor.CanTouch = false
	anchor.CFrame = CFrame.new(digPosition + Vector3.new(0, 0.5, 0))
	anchor.Parent = sourceModel

	local prompt = PromptUtil.Ensure(anchor, PROMPT_NAME, {
		ActionText = "Dig",
		HoldDuration = 1,
		MaxActivationDistance = PromptUtil.PROMPT_MAX_DISTANCE,
		RequiresLineOfSight = false,
	})
	prompt.AutoLocalize = false
	prompt.Enabled = false
	local originalTransparency, sourceDescendantConnection = hideSourceModel(sourceModel)
	local site: DigSite = {
		sourceModel = sourceModel,
		anchor = anchor,
		prompt = prompt,
		promptHighlight = nil,
		digPosition = digPosition,
		originalTransparency = originalTransparency,
		sourceDescendantConnection = sourceDescendantConnection,
		isBusy = false,
		mound = nil,
		titleGui = nil,
		healthGui = nil,
		healthProgressBar = nil,
		healthLabel = nil,
		healthTween = nil,
		isFinalizing = false,
		isInitialized = false,
		beamVisible = nil,
		idleDropVFX = nil,
		resolvedItemId = nil,
		resolvedIsRareReward = false,
		resolvedWeight = nil,
		resolvedBasePrice = nil,
		resolvedFootprint = nil,
		resolvedBounds = nil,
	}
	anchor.CanQuery = true
	sitesByModel[sourceModel] = site
	local siteId = sourceModel:GetAttribute("ItemInstanceId")
	if typeof(siteId) == "string" then
		sitesById[siteId] = site
	end
	createSiteBillboards(site, anchor)
	local pendingSnapshot = if typeof(siteId) == "string" then personalSnapshotsBySiteId[siteId] else nil
	if pendingSnapshot then
		applyPersonalSiteSnapshot(site, pendingSnapshot)
	end

	prompt.PromptShown:Connect(function()
		if not site.isBusy then
			setPromptHighlightEnabled(site, true)
		end
	end)

	prompt.PromptHidden:Connect(function()
		setPromptHighlightEnabled(site, false)
	end)

	prompt.Triggered:Connect(function(player)
		if player ~= LOCAL_PLAYER then
			return
		end
		if nearestPromptSite ~= site then
			return
		end
		if not ensureShovelEquipped() then
			return
		end
		setPromptHighlightEnabled(site, false)
		Knit.GetService("DigItemService"):BeginDig(sourceModel):andThen(function(snapshot)
			if snapshot and snapshot.Accepted == true and sourceModel.Parent and not activeSession and not site.isBusy then
				startDigSession(site, snapshot)
			end
		end)
	end)

	sourceModel:GetAttributeChangedSignal("DigReserved"):Connect(function()
		refreshNearestDigPrompt()
	end)
	refreshNearestDigPrompt()
end

local function bindDigFolder(folder: Folder)
	if boundFolders[folder] then
		return
	end
	boundFolders[folder] = true

	for _, child in folder:GetChildren() do
		if child:IsA("Model") then
			registerDigSite(child)
		end
	end

	folder.ChildAdded:Connect(function(child)
		if child:IsA("Model") then
			registerDigSite(child)
		end
	end)

	folder.ChildRemoved:Connect(function(child)
		if child:IsA("Model") then
			local siteId = child:GetAttribute("ItemInstanceId")
			if typeof(siteId) == "string" then
				personalSnapshotsBySiteId[siteId] = nil
				sitesById[siteId] = nil
			end
			local site = sitesByModel[child]
			if site then
				if site.isFinalizing then
					return
				end
				setPromptHighlightEnabled(site, false)
				if activeSession and activeSession.site == site then
					cleanupDigSession(activeSession, true, false)
					activeSession = nil
				end
				destroySiteMound(site)
				destroySiteBillboards(site)
				disconnectSourceDescendantObserver(site)
				restoreSourceModel(site.originalTransparency)
				sitesByModel[child] = nil
				refreshNearestDigPrompt()
			end
		end
	end)
end

local function bindZone(zone: Instance)
	if not zone.Name:match("^Zone_%d+$") then
		return
	end
	for _, folderName in ipairs({ GENERATED_FOLDER_NAME, TUTORIAL_FOLDER_NAME }) do
		local generated = zone:FindFirstChild(folderName)
		if generated and generated:IsA("Folder") then
			bindDigFolder(generated)
		end
	end
	zone.ChildAdded:Connect(function(child)
		if (child.Name == GENERATED_FOLDER_NAME or child.Name == TUTORIAL_FOLDER_NAME)
			and child:IsA("Folder")
		then
			bindDigFolder(child)
		end
	end)
end

local function applyPersonalSnapshots(snapshots)
	if typeof(snapshots) ~= "table" then
		return
	end
	local incomingSiteIds = {}
	for _, snapshot in snapshots do
		if typeof(snapshot) == "table" and typeof(snapshot.SiteId) == "string" then
			incomingSiteIds[snapshot.SiteId] = true
		end
	end
	for siteId, site in pairs(sitesById) do
		if incomingSiteIds[siteId] then
			continue
		end
		if activeSession and activeSession.site == site then
			cancelServerReservation(site.sourceModel)
			cleanupDigSession(activeSession, true, false)
			activeSession = nil
		end
		destroySiteMound(site)
		site.isInitialized = false
		site.resolvedItemId = nil
		site.resolvedIsRareReward = false
		site.resolvedWeight = nil
		site.resolvedBasePrice = nil
		site.resolvedFootprint = nil
		site.resolvedBounds = nil
		site.prompt.Enabled = false
		if site.titleGui then
			site.titleGui.Enabled = false
		end
		if site.healthGui then
			site.healthGui.Enabled = false
		end
	end
	table.clear(personalSnapshotsBySiteId)
	for _, snapshot in snapshots do
		if typeof(snapshot) ~= "table" then
			continue
		end
		local siteId = snapshot.SiteId
		local sourceModel = snapshot.Site
		if typeof(siteId) ~= "string" then
			continue
		end
		personalSnapshotsBySiteId[siteId] = snapshot
		local site = if typeof(sourceModel) == "Instance" and sourceModel:IsA("Model")
			then sitesByModel[sourceModel]
			else sitesById[siteId]
		if site then
			applyPersonalSiteSnapshot(site, snapshot)
		end
	end
	refreshNearestDigPrompt()
end

function DigController:KnitStart()
	local digItemService = Knit.GetService("DigItemService")
	UserInputService.JumpRequest:Connect(function()
		local session = activeSession
		if session and not session.isShowcasing then
			self:InterruptDigging()
		end
	end)

	digItemService.DigSitesInitialized:Connect(function(snapshots)
		applyPersonalSnapshots(snapshots)
	end)
	digItemService.DigStep:Connect(function(model: Model, snapshot)
		local session = activeSession
		if not session or session.isShowcasing or session.site.sourceModel ~= model or typeof(snapshot) ~= "table" then return end
		local currentHealth = tonumber(snapshot.CurrentHealth)
		local maxHealth = tonumber(snapshot.MaxHealth)
		if not currentHealth or not maxHealth then return end
		local digSpeedMultiplier = tonumber(snapshot.DigSpeedMultiplier)
		if digSpeedMultiplier and digSpeedMultiplier > 0 then
			session.digSpeedMultiplier = digSpeedMultiplier
		end
		local digInterval = tonumber(snapshot.Interval)
		if digInterval and digInterval > 0 then
			session.digInterval = digInterval
		end
		local progress = 1 - math.clamp(currentHealth / math.max(1, maxHealth), 0, 1)
		session.presentationFromProgress = session.presentationCurrentProgress
		session.presentationTargetProgress = progress
		session.presentationStartedAt = os.clock()
		applyHealthSnapshot(session.site, currentHealth, maxHealth)
	end)
	digItemService.DigEnded:Connect(function(model: Model, result)
		local session = activeSession
		if not session or session.site.sourceModel ~= model then return end
		if typeof(result) == "table" and result.Completed == true then
			playFinishedDigSession(session, result)
			return
		end
		local site = session.site
		cleanupDigSession(session, true, true)
		activeSession = nil
		if site.sourceModel.Parent then
			resetSite(site)
		end
	end)
	digItemService.OtherPlayerDigRevealed:Connect(playOtherPlayerDigReveal)

	local areas = Workspace:WaitForChild("Areas")
	for _, zone in ipairs(areas:GetChildren()) do
		bindZone(zone)
	end
	areas.ChildAdded:Connect(bindZone)
	digItemService:GetDigSiteSnapshots():andThen(function(snapshots)
		applyPersonalSnapshots(snapshots)
	end):catch(function(err)
		warn("DigController: failed to load personal dig sites", err)
	end)
	RunService.Heartbeat:Connect(function(deltaTime)
		digSiteRefreshElapsed += deltaTime
		if digSiteRefreshDirty or digSiteRefreshElapsed >= DIG_SITE_REFRESH_INTERVAL then
			refreshDigSiteState()
		end
	end)

	LOCAL_PLAYER.CharacterAdded:Connect(function()
		if activeSession then
			cancelServerReservation(activeSession.site.sourceModel)
			cleanupDigSession(activeSession, true, true)
			activeSession = nil
		end
		cleanupAllShowcaseSessions()
		for _, site in pairs(sitesByModel) do
			resetSite(site)
		end
		refreshNearestDigPrompt()
	end)
end

return DigController
