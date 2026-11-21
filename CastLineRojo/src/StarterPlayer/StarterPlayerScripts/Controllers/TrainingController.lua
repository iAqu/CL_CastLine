local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Progress = require(ReplicatedStorage.Modules.TrainingProgress)
local Config = require(ReplicatedStorage.Modules.TrainingConfig)
local Grip = require(ReplicatedStorage.Modules.TrainingGrip)
local Gate = require(ReplicatedStorage.Modules.GameplayInputGate)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local Loading = require(ReplicatedFirst.LoadingAttributes)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local Notification = require(ReplicatedStorage.Modules.NotificationClient)
local PlotUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)
local Feedback = require(ReplicatedStorage.Modules.TrainingFeedback)
local UIEffects = require(ReplicatedStorage.Modules.TrainingUIEffects)
local BackpackState = require(ReplicatedStorage.Modules.TrainingBackpackState)
local Items = require(ReplicatedFirst.Data.TrainingData)
local Levels = require(ReplicatedFirst.Data.TrainingLevelsData)
local Controller = Knit.CreateController({ Name = "TrainingController" })
local player = Players.LocalPlayer

local function createUpgradeDisplay(anchor)
	local models = ReplicatedStorage:FindFirstChild("Models")
	local pads = models and models:FindFirstChild("TrainingPads")
	local template = pads and pads:FindFirstChild("TrainingUgprade")
	if not template or not template:IsA("Model") then
		return nil
	end
	local model = template:Clone()
	if not model then
		return nil
	end
	model.Name = "TrainingUpgradeDisplay"
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
		end
	end
	-- The model and the thin scene marker both use local X as the vertical axis.
	local box, size = model:GetBoundingBox()
	local bottom = model:GetPivot():PointToObjectSpace(box.Position).X - size.X / 2
	model:PivotTo(anchor.CFrame * CFrame.new(anchor.Size.X / 2 - bottom, 0, 0))
	model.Parent = anchor
	return model
end

function Controller:GetSnapshot()
	return self._snapshot
end

function Controller:KnitStart()
	local connections, alive = {}, true
	local function listen(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(connections, connection)
		return connection
	end
	listen(RunService.PreRender, function()
		for _, other in ipairs(Players:GetPlayers()) do
			if other.Character then
				Grip.Update(other.Character)
			end
		end
	end)
	local playerGui = player:WaitForChild("PlayerGui")
	local gui = playerGui:WaitForChild("TrainingGui", 15)
	if not gui then
		warn("TrainingController: install the TrainingGui prefab before playing")
		return
	end
	local titles = playerGui:WaitForChild("TitleGui")
	local titleTemplate = titles:WaitForChild("TrainingUpgradeTemplate", 15)
	if gui:GetAttribute("TrainingPrefabVersion") ~= 2 or not titleTemplate then
		warn("TrainingController: install version 2 training prefabs before playing")
		return
	end
	local xpBar = gui.XPBar
	gui.Info.Visible = false
	gui.StopButton.Visible = true
	gui.StopButton.Active = true
	gui.StopButton.Interactable = true
	gui.StopButton.Selectable = true
	local effects = UIEffects.new(gui)
	local backpack = BackpackState.new(playerGui, function()
		return Gate.IsActive("Fishing") or player:GetAttribute("FishingIntroActive") == true
	end)
	listen(playerGui.ChildAdded, function(child)
		if child.Name == "BackpackGui" then
			backpack:Step()
		end
	end)
	local service = Knit.GetService("TrainingService")
	local snapshot, feedbackPrevious, boundPlot, boundAnchor, prompt, billboard, titleAnchor, priceTween
	local upgradeDisplay
	local allowed, allowedPending, fetching, upgrading, stopping = nil, false, false, false, false
	local fetchAt, elapsed = 0, 0
	local balance, affordable = 0, false
	local function pulsePrice(amount, duration)
		if not alive or not billboard or not billboard.Parent then
			return
		end
		if priceTween then
			priceTween:Cancel()
		end
		local scale = billboard.Holder.PriceHolder.Price.PulseScale
		scale.Scale = 1 + amount
		priceTween = TweenService:Create(
			scale,
			TweenInfo.new(duration, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
			{ Scale = 1 }
		)
		priceTween:Play()
	end
	local function applyWeight()
		local home = playerGui:FindFirstChild("HomeGui")
		local bottom = home and home:FindFirstChild("BottomFrame")
		local currency = bottom and bottom:FindFirstChild("CurrencyFrame")
		local frame = currency and currency:FindFirstChild("Weight")
		if frame and snapshot then
			local text = WeightFormat.FormatKg(snapshot.maxCatchWeight)
			for _, label in ipairs(frame:GetDescendants()) do
				if label:IsA("TextLabel") then
					label.Text = text
				end
			end
		end
	end
	local function refreshUpgrade()
		if not alive or not prompt or not billboard or not snapshot then
			return
		end
		local nextItem = Progress.GetNextEquipment(Items, snapshot.trainingId)
		prompt.Enabled = nextItem ~= nil and not upgrading and not Gate.IsActive("Fishing")
		local holder = billboard.Holder
		local price = holder.PriceHolder.Price
		price.Text = if nextItem then "$" .. NumberUtil.FormatItemPriceCompact(nextItem.Price) else "MAX"
		holder.Xp.Text = if nextItem
			then `+{NumberUtil.FormatNumberStartKWithDecimal(nextItem.XpPerRep * snapshot.multiplier, 1)} XP / rep`
			else `+{NumberUtil.FormatNumberStartKWithDecimal(snapshot.xpPerRep, 1)} XP / rep`
		local canAfford = nextItem ~= nil and balance >= nextItem.Price
		local first, second = Color3.fromRGB(255, 220, 90), Color3.fromRGB(240, 160, 20)
		if nextItem then
			first = if canAfford then Color3.fromRGB(152, 246, 72) else Color3.fromRGB(250, 75, 75)
			second = if canAfford then Color3.fromRGB(98, 204, 34) else Color3.fromRGB(195, 22, 22)
		end
		price.Gradient.Color = ColorSequence.new(first, second)
		holder.Arrow.Visible = canAfford
		if canAfford and not affordable then
			pulsePrice(0.25, 0.5)
		end
		affordable = canAfford
	end
	local function apply(value)
		if not alive or not value or (snapshot and value.revision <= snapshot.revision) then
			return
		end
		local change = Feedback.GetChanges(feedbackPrevious, value, Levels)
		local instantFill = not value.active
			or not feedbackPrevious
			or not feedbackPrevious.active
			or value.level ~= feedbackPrevious.level
		feedbackPrevious = value
		snapshot = value
		self._snapshot = value
		gui.Enabled = value.active
		Gate.SetActive("Training", self, value.active)
		backpack:SetActive(value.active)
		if not value.active then
			effects:Clear()
		end
		xpBar.LevelLabel.Text = "Level " .. value.level
		xpBar.XPLabel.Text = if value.xpToNextLevel > 0
			then NumberUtil.FormatNumberStartKWithDecimal(value.xp, 1) .. "/" .. NumberUtil.FormatNumberStartKWithDecimal(
				value.xpToNextLevel,
				1
			)
			else "MAX"
		local ratio = if value.xpToNextLevel > 0 then math.clamp(value.xp / value.xpToNextLevel, 0, 1) else 1
		effects:SetFill(ratio, instantFill)
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if change.xp > 0 then
			effects:Rep(change.xp, root)
		end
		if change.levels > 0 then
			effects:LevelUp(change.weight, root)
		end
		applyWeight()
		refreshUpgrade()
	end
	local function bindPlot()
		local plot = PlotUtil.getPlotBySlot(player:GetAttribute("PlotSlotId"))
		if plot and plot:GetAttribute("OwnerUserId") ~= player.UserId then
			plot = nil
		end
		local anchor = plot and plot:FindFirstChild("TrainingUpgradeAnchor")
		if anchor and not anchor:IsA("BasePart") then
			anchor = nil
		end
		if upgradeDisplay and (not anchor or upgradeDisplay.Parent ~= anchor) then
			upgradeDisplay:Destroy()
			upgradeDisplay = nil
		end
		if anchor and not upgradeDisplay then
			upgradeDisplay = createUpgradeDisplay(anchor)
		end
		if boundPlot == plot and boundAnchor == anchor and (not anchor or (prompt and prompt.Parent == anchor)) then
			return
		end
		effects:Clear()
		feedbackPrevious = nil
		if priceTween then
			priceTween:Cancel()
			priceTween = nil
		end
		if prompt then
			prompt:Destroy()
		end
		if billboard then
			billboard:Destroy()
		end
		if titleAnchor then
			titleAnchor:Destroy()
		end
		boundPlot, boundAnchor, prompt, billboard, affordable = plot, anchor, nil, nil, false
		titleAnchor = nil
		if not anchor then
			return
		end
		prompt = gui.Templates.UpgradePrompt:Clone()
		prompt.Name = "TrainingUpgradePrompt"
		prompt.ActionText = "UPGRADE"
		prompt.ObjectText = ""
		prompt:SetAttribute("StudsOffsetWorldSpace", Vector3.new(0, -2, 0))
		prompt:SetAttribute("ActionTextStrokeScale", 0.16)
		prompt.Parent = anchor
		billboard = titleTemplate:Clone()
		billboard.Name = "TrainingUpgradeTitle"
		-- Keep the reference's world height stable on the rotated, thin scene marker.
		titleAnchor = gui.Templates.UpgradeTitleAnchor:Clone()
		titleAnchor.Position = anchor.CFrame:VectorToObjectSpace(billboard.StudsOffsetWorldSpace)
		titleAnchor.Parent = anchor
		billboard.StudsOffsetWorldSpace = Vector3.zero
		billboard.Adornee, billboard.Enabled, billboard.Parent = titleAnchor, true, anchor
		prompt.Triggered:Connect(function()
			if upgrading or not snapshot or Gate.IsActive("Fishing") then
				return
			end
			upgrading = true
			refreshUpgrade()
			service
				:Upgrade(snapshot.trainingId)
				:andThen(function(result)
					if result and result.ok then
						apply(result.state)
						if billboard then
							pulsePrice(0.3, 0.6)
						end
						Notification.GreenNotify("Training equipment upgraded!")
					else
						Notification.RedNotify(result and result.message or "Could not upgrade training.")
					end
				end)
				:catch(function()
					Notification.RedNotify("Could not upgrade training. Please try again.")
				end)
				:finally(function()
					upgrading = false
					refreshUpgrade()
				end)
		end)
		refreshUpgrade()
	end
	local function requestStop(jump)
		if stopping or not snapshot or not snapshot.active then
			return
		end
		stopping = true
		local character = player.Character
		service
			:Stop()
			:andThen(function(value)
				apply(value)
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				if
					jump
					and value
					and not value.active
					and character == player.Character
					and humanoid
					and humanoid.Health > 0
				then
					humanoid.Jump = true
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
			:catch(function()
				Notification.RedNotify("Could not stop training. Please try again.")
			end)
			:finally(function()
				stopping = false
			end)
	end
	listen(gui.StopButton.Activated, function()
		requestStop(false)
	end)
	listen(UserInputService.JumpRequest, function()
		if not Gate.IsUiBlockingWorld() then
			requestStop(true)
		end
	end)
	local deathConnection
	local function clearCharacter()
		effects:Clear()
		backpack:SetActive(false)
		feedbackPrevious = nil
		if deathConnection then
			deathConnection:Disconnect()
			deathConnection = nil
		end
	end
	local function bindCharacter(character)
		clearCharacter()
		local humanoid = character:WaitForChild("Humanoid", 10)
		if alive and humanoid and character == player.Character then
			deathConnection = humanoid.Died:Connect(clearCharacter)
		end
	end
	listen(player.CharacterRemoving, clearCharacter)
	listen(player.CharacterAdded, bindCharacter)
	if player.Character then
		task.spawn(bindCharacter, player.Character)
	end
	gui.Destroying:Connect(function()
		alive = false
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		clearCharacter()
		self._snapshot = nil
		backpack:Destroy()
		Gate.SetActive("Training", self, false)
		service:SetAllowed(false):catch(function()
			warn("TrainingController: could not stop training after UI removal")
		end)
		if upgradeDisplay then
			upgradeDisplay:Destroy()
			upgradeDisplay = nil
		end
		if prompt then
			prompt:Destroy()
		end
		if billboard then
			billboard:Destroy()
		end
		if titleAnchor then
			titleAnchor:Destroy()
		end
		if priceTween then
			priceTween:Cancel()
		end
	end)
	listen(service.Changed, apply)
	listen(Knit.GetService("PlayerDataService").WinsChanged, function(value)
		balance = value
		refreshUpgrade()
	end)
	task.spawn(function()
		local cash = player:WaitForChild("leaderstats"):WaitForChild("💵Cash")
		if not alive then
			return
		end
		balance = cash.Value
		listen(cash:GetPropertyChangedSignal("Value"), function()
			balance = cash.Value
			refreshUpgrade()
		end)
		refreshUpgrade()
	end)
	listen(RunService.Heartbeat, function(dt)
		elapsed += dt
		if elapsed < Config.ScanInterval then
			return
		end
		elapsed = 0
		backpack:Step()
		local now = os.clock()
		local size = gui.Effects.AbsoluteSize
		local width = math.min(size.X - 32, math.max(320, math.min(720, size.X * 0.46)))
		local height = math.clamp(width / 12.3, 32, 44)
		xpBar.Size = UDim2.fromOffset(width, height)
		local stopHeight = math.clamp(size.Y * 0.065, 48, 64)
		local stopBottom = math.min(size.Y * 0.86, size.Y * 0.965 - height - 10)
		gui.StopButton.Size = UDim2.fromOffset(math.clamp(size.X * 0.11, 144, 210), stopHeight)
		gui.StopButton.Position = UDim2.new(0.5, 0, 0, stopBottom)
		if billboard then
			billboard.Holder.Arrow.Position =
				UDim2.fromScale(0.5, if affordable then math.sin(now * 5) * 0.05 + 1.02 else 1.02)
			billboard.Holder.PriceHolder.BreathScale.Scale = if affordable then math.sin(now * 3.2) * 0.04 + 1 else 1
		end
		if not snapshot and not fetching and now >= fetchAt then
			fetching = true
			service
				:GetState()
				:andThen(apply)
				:catch(function()
					warn("TrainingController: training state unavailable; retrying")
				end)
				:finally(function()
					fetching, fetchAt = false, os.clock() + 2
				end)
		end
		local hatch = playerGui:FindFirstChild("EggHatchResultGui")
		local offline = playerGui:FindFirstChild("OfflineResultGui")
		local permit = snapshot ~= nil
			and player:GetAttribute(Loading.LOADING_SCREEN_DONE) == true
			and not Gate.IsActive("Fishing")
			and not player:GetAttribute("FishingIntroActive")
			and not (hatch and hatch.Enabled)
			and not (offline and offline.Enabled)
			and GuiAnimation.IsAllPopupGuisClosed()
		if permit ~= allowed and not allowedPending then
			allowedPending = true
			service
				:SetAllowed(permit)
				:andThen(function(ok)
					if ok then
						allowed = permit
					end
				end)
				:catch(function()
					allowed = nil
				end)
				:finally(function()
					allowedPending = false
				end)
		end
		bindPlot()
	end)
end

return Controller
