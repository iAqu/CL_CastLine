local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Modules = ReplicatedStorage.Modules
local FishInventoryData = require(Modules.FishInventoryData)
local Gate = require(Modules.GameplayInputGate)
local ItemToolUtil = require(Modules.ItemToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Loading = require(ReplicatedFirst.LoadingAttributes)
local Onboarding = require(Modules.FishingOnboarding)
local PlotFishMotion = require(Modules.PlotFishMotion)
local PlotWorkspaceUtil = require(Modules.PlotWorkspaceUtil)
local View = require(Modules.FishingInstructionView)
local TutorialClickMask = require(Modules.TutorialClickMask)

local player = Players.LocalPlayer
local Controller = Knit.CreateController({ Name = "FishingOnboardingController" })
local ARROW_TEXTURE = "rbxassetid://94490357052336"
local TRAINING_PROMPT = `TRAIN TO LEVEL {Onboarding.TrainingLevel}`
local yellow = Color3.fromRGB(255, 205, 0)

local function fishUid(tool)
	local uid = ItemToolUtil.GetInstanceId(tool)
	return if uid and FishInventoryData[tool:GetAttribute(ItemToolUtil.ITEM_ID_ATTRIBUTE)] then uid else nil
end

local function createRoute(playerGui)
	local from = Instance.new("Attachment")
	from.Name, from.Parent = "FishingGuideFrom", Workspace.Terrain
	local target = Instance.new("Attachment")
	target.Name, target.Parent = "FishingGuideTarget", Workspace.Terrain
	local beam = Instance.new("Beam")
	beam.Name = "FishingGuideBeam"
	beam.Attachment0, beam.Attachment1 = from, target
	beam.FaceCamera, beam.Width0, beam.Width1 = true, 8, 8
	beam.Segments = 16
	beam.LightInfluence = 0
	beam.TextureMode, beam.TextureLength, beam.TextureSpeed = Enum.TextureMode.Static, 12, 1
	beam.Enabled, beam.Parent = false, from

	local marker = Instance.new("BillboardGui")
	marker.Name = "FishingGuideMarker"
	marker.AlwaysOnTop, marker.Enabled = true, false
	marker.Size = UDim2.fromOffset(48, 48)
	marker.Adornee, marker.Parent = target, playerGui
	local arrow = StarterGui.TitleGui.TrainingUpgradeTemplate.Holder.Arrow:Clone()
	arrow.Visible, arrow.Position, arrow.Size = true, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1)
	arrow.AnchorPoint, arrow.Rotation = Vector2.zero, 0
	arrow.TextScaled, arrow.TextColor3, arrow.Parent = true, yellow, marker
	return from, target, beam, marker
end

local function cloneWaterRaceRoute()
	local source = ReplicatedStorage:FindFirstChild("FishingGuideTemplate")
	local route = source and source:Clone()
	local holder = route and route:FindFirstChild("Beam Holder")
	local endpoint = route and route:FindFirstChild("Beam Part")
	local beam = holder and holder:FindFirstChildWhichIsA("Beam", true)
	if not holder or not endpoint or not holder:IsA("BasePart") or not endpoint:IsA("BasePart")
		or not beam or not beam.Attachment0 or not beam.Attachment0:IsDescendantOf(holder)
		or not beam.Attachment1 or not beam.Attachment1:IsDescendantOf(endpoint)
	then
		if route then
			route:Destroy()
		end
		return nil
	end
	route.Name = "FishingGuideRoute"
	route.Parent = Workspace
	beam.Enabled = false
	return route, holder, endpoint, beam
end

local function visible(target)
	if not target then
		return false
	end
	local parent = target
	while parent do
		if parent:IsA("GuiObject") and not parent.Visible then
			return false
		end
		if parent:IsA("ScreenGui") then
			return parent.Enabled
		end
		parent = parent.Parent
	end
	return false
end

local function findFishSlot(playerGui, uid)
	local backpack = playerGui:FindFirstChild("BackpackGui")
	local fallback
	if backpack then
		for _, reference in backpack:GetDescendants() do
			if reference.Name == "ToolReference" and reference:IsA("ObjectValue") and visible(reference.Parent) then
				local id = fishUid(reference.Value)
				if id == uid and id then
					return reference.Parent
				elseif id and not fallback then
					fallback = reference.Parent
				end
			end
		end
	end
	return fallback
end

local function hasFish(playerInventory)
	if not playerInventory then
		return false
	end
	for _, tool in playerInventory:GetChildren() do
		if fishUid(tool) then
			return true
		end
	end
	return false
end

function Controller:KnitStart()
	local playerGui = player:WaitForChild("PlayerGui")
	playerGui:WaitForChild("FishingSequenceGui")
	local fishing = Knit.GetController("FishingController")
	local shop = Knit.GetController("RodShopGuiController")
	local analytics = Knit.GetService("OnboardingAnalyticsService").GuidePresentation
	local observed = {}
	local function report(detail)
		if detail and not observed[detail] then
			observed[detail] = true
			analytics:Fire(detail)
		end
	end
	local gui, label, finger, biteCue, mask
	local from, target, beam, marker, waterRaceRoute
	local lastStage, trainAt
	local slot, nextSlotCheck

	local function clear()
		if gui then
			gui:Destroy()
			if waterRaceRoute then
				waterRaceRoute:Destroy()
			else
				marker:Destroy()
				from:Destroy()
				target:Destroy()
			end
			gui = nil
		end
	end

	local function hideRoute()
		beam.Enabled = false
		if marker then
			marker.Enabled = false
		end
	end

	RunService.RenderStepped:Connect(function()
		local stage = player:GetAttribute(Onboarding.StageAttribute)
		local inLesson, hint, baitTarget, baitMessage, cuePhase = fishing:GetOnboardingHint()
		if not inLesson and (not stage or stage == "Complete") then
			clear()
			return
		end
		if not gui then
			gui, label, finger, biteCue = View.Create(playerGui, "FishingOnboardingGui")
			gui.ScreenInsets, gui.ClipToDeviceSafeArea = Enum.ScreenInsets.None, false
			label.ZIndex = 3
			mask = TutorialClickMask.new(gui)
			waterRaceRoute, from, target, beam = cloneWaterRaceRoute()
			if not waterRaceRoute then
				from, target, beam, marker = createRoute(playerGui)
			else
				marker = nil
			end
			beam.Texture = ARROW_TEXTURE
			beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
			beam.Transparency = NumberSequence.new(0)
		end
		local now = os.clock()
		if stage ~= lastStage then
			if lastStage == "PlaceFish" and stage == "Train" then
				trainAt = now + 1
			end
			lastStage = stage
			slot, nextSlotCheck = nil, 0
		end
		label.Visible = false
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root or not humanoid or humanoid.Health <= 0 or GuiService.MenuIsOpen
			or UserInputService:GetFocusedTextBox() or player:GetAttribute("FishingIntroActive")
			or player:GetAttribute(Loading.LOADING_SCREEN_DONE) ~= true
		then
			View.ShowBiteCue(biteCue, finger)
			hideRoute()
			mask:Clear()
			return
		end

		local pointAt, destination, message, detail
		View.ShowBiteCue(biteCue, finger, cuePhase, now)
		if inLesson then
			pointAt, message = baitTarget, baitMessage
			if hint then
				View.ShowFishing(label, hint)
			end
			fishing:ReportOnboardingPrompt(hint, baitTarget and visible(baitTarget))
		elseif not Gate.IsActive("Fishing") then
			local plot = PlotWorkspaceUtil.getPlotBySlot(player:GetAttribute("PlotSlotId"))
			if not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
				hideRoute()
				mask:Clear()
				return
			end
			if stage == "RodReward" or stage == "FinalCatch" then
				pointAt = shop.GetOnboardingTarget and shop:GetOnboardingTarget()
				if pointAt and stage == "RodReward" then
					detail = "RodRewardPrompt"
				end
			end
			if player:GetAttribute("IsTraining") then
				if stage == "StopTraining" then
					local training = playerGui:FindFirstChild("TrainingGui")
					message, pointAt = "TRAINING GOAL REACHED", training and training:FindFirstChild("StopButton")
					detail = "StopTrainingPrompt"
				elseif stage == "Train" then
					message = TRAINING_PROMPT
					detail = "TrainingPrompt"
				end
			elseif stage == "PlaceFish" and not Gate.IsActive("Popup") then
				local held = character:FindFirstChildOfClass("Tool")
				local boundary = PlotFishMotion.GetBoundary(plot)
				local holdingFish = fishUid(held) ~= nil
				if holdingFish then
					report("FishHeld")
				end
				if holdingFish and boundary then
					if not Gate.IsUiBlockingWorld() then
						if PlotFishMotion.GetEntry(boundary, root) then
							message = if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
								then "PRESS R2 TO PLACE"
								else "TAP TO PLACE"
							detail = "PlacementPrompt"
						else
							destination = boundary
							message = "PLACE YOUR FISH AT HOME"
							detail = "PlacementRoute"
						end
					end
				elseif now >= nextSlotCheck then
					slot = findFishSlot(playerGui, player:GetAttribute(Onboarding.FishAttribute))
					nextSlotCheck = now + 0.15
				end
				if not holdingFish then
					if visible(slot) then
						message, pointAt = "HOLD YOUR FISH", slot
						detail = "HoldFishPrompt"
					elseif hasFish(player:FindFirstChildOfClass("Backpack")) then
						message = "OPEN YOUR BACKPACK"
						detail = "BackpackPrompt"
					elseif not Gate.IsUiBlockingWorld() then
						message, destination = "CATCH A FISH TO PLACE", plot:FindFirstChild("FishingStartPart")
						detail = "ReplacementFishRoute"
					end
				end
			elseif not pointAt and not Gate.IsUiBlockingWorld() then
				if stage == "FinalCatch" then
					message = "CAST WITH YOUR NEW ROD!"
					destination = plot:FindFirstChild("FishingStartPart")
					detail = "FinalLessonRoute"
				elseif stage == "RodReward" then
					message, destination = "GET YOUR NEW ROD", plot:FindFirstChild("RodShopAnchor")
					detail = "RodShopRoute"
				elseif (stage == "Train" or stage == "StopTraining")
					and not player:GetAttribute("IsTraining") and now >= (trainAt or 0)
				then
					message, destination = "TRAIN TO CATCH BIGGER FISH", plot:FindFirstChild("TrainingAnchor")
					detail = if stage == "Train" then "TrainingRoute" else "ResumeTrainingRoute"
				end
			end
		end

		if destination and destination:IsA("BasePart") then
			local startPosition = root.Position
			local endPosition = destination.Position + Vector3.yAxis * 2.4
			local distance = (Vector2.new(startPosition.X, startPosition.Z)
				- Vector2.new(destination.Position.X, destination.Position.Z)).Magnitude
			if waterRaceRoute then
				-- Center the beam attachment while preserving its authored transform in the holder.
				local attachmentOffset = beam.Attachment0.WorldPosition - from.Position
				from.Position, target.Position = startPosition - attachmentOffset, endPosition
				beam.Enabled = distance > 4
			else
				from.WorldPosition, target.WorldPosition = startPosition, endPosition
				marker.StudsOffsetWorldSpace = Vector3.yAxis * (2.8 + math.sin(now * 5) * 0.35)
				beam.Enabled, marker.Enabled = distance > 4, true
			end
		else
			hideRoute()
		end
		if message then
			label.Text, label.TextColor3, label.Visible = message, yellow, true
			label.Position = UDim2.fromScale(0.5, if pointAt then 0.70 else 0.78)
			label:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 48
		end
		if message or (pointAt and visible(pointAt)) then
			report(detail)
		end
		if pointAt then
			local low, high = mask:Update(pointAt)
			if low and high then
				local center = (low + high) * 0.5
				local x = if high.X + 34 <= gui.AbsoluteSize.X then high.X + 6 else low.X - 6
				x = math.clamp(x, 28, math.max(28, gui.AbsoluteSize.X - 28))
				local y = math.clamp(center.Y - math.sin(now * 8) * 6, 28, math.max(28, gui.AbsoluteSize.Y - 28))
				finger.Position, finger.Size = UDim2.fromOffset(x, y), UDim2.fromOffset(56, 56)
				finger.Visible = true
			end
		else
			mask:Clear()
		end
	end)
end

return Controller
