local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Modules.EventFishConfig)
local EventPresentationGate = require(ReplicatedStorage.Modules.EventPresentationGate)
local EventFishRainbow = require(ReplicatedStorage.Modules.EventFishRainbow)
local FishesData = require(ReplicatedFirst.Data.FishesData)
local Assets = require(ReplicatedStorage.Modules.FishingAssets)
local FishAnimationController = require(ReplicatedStorage.Modules.FishAnimationController)
local FishShadowAppearance = require(ReplicatedStorage.Modules.FishShadowAppearance)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)

local LOCAL_PLAYER = Players.LocalPlayer
local RAINBOW_HUE_SPEED = 0.5
local originalWaterColors: { [Instance]: Color3 } = {}
local markerEffects: { [Instance]: boolean } = {}
local EventFishController = Knit.CreateController({ Name = "EventFishController" })

local function getLiveEvent(state, now: number)
	if not state or state:GetAttribute("Phase") ~= "Active" then
		return nil
	end
	local startsAt = state:GetAttribute("StartsAt")
	local endsAt = state:GetAttribute("EndsAt")
	local fishId = state:GetAttribute("FishId")
	local slotId = state:GetAttribute("SlotId")
	if typeof(startsAt) == "number" and typeof(endsAt) == "number" and now >= startsAt and now < endsAt
		and type(fishId) == "string" and fishId ~= "" and type(slotId) == "number"
	then
		return { FishId = fishId, SlotId = slotId, StartsAt = startsAt, EndsAt = endsAt }
	end
	return nil
end

function EventFishController:GetLiveEvent(now: number)
	return getLiveEvent(ReplicatedStorage:FindFirstChild(Config.StateFolderName), now)
end

local function updateWater(water: Instance?, active: boolean, now: number)
	if not active then
		for instance, color in originalWaterColors do
			if instance.Parent then
				if instance:IsA("BasePart") then
					instance.Color = color
				elseif instance:IsA("Decal") then
					instance.Color3 = color
				end
			end
		end
		table.clear(originalWaterColors)
	elseif water then
		local color = Color3.fromHSV((now * RAINBOW_HUE_SPEED) % 1, 1, 1)
		for _, instance in water:GetDescendants() do
			if instance:IsA("BasePart") then
				originalWaterColors[instance] = originalWaterColors[instance] or instance.Color
				instance.Color = color
			elseif instance:IsA("Decal") then
				originalWaterColors[instance] = originalWaterColors[instance] or instance.Color3
				instance.Color3 = color
			end
		end
	end
end

function EventFishController:_clearShadow()
	local shadow = self._Shadow
	if shadow then
		self._Shadow = nil
		if shadow.animation then
			shadow.animation:Destroy()
		end
		FishShadowAppearance.Destroy(shadow.appearance)
		shadow.model:Destroy()
	end
end

function EventFishController:_makeShadow(fish, slotId, startsAt)
	local template = Assets.GetFish(fish.Model)
	if not template then
		return nil
	end
	local model = template:Clone()
	model.Name = "EventFishShadow"

	local _, size = model:GetBoundingBox()
	model:ScaleTo(model:GetScale() * Config.Shadow.Length / math.max(size.X, size.Y, size.Z, 0.01))
	local bounds = ItemStatUtil.GetModelBounds(model)
	local appearance = FishShadowAppearance.Prepare(model)
	FishShadowAppearance.Apply(appearance, true, false, 0, 0)
	return {
		model = model,
		appearance = appearance,
		fishId = fish.FishID,
		slotId = slotId,
		startsAt = startsAt,
		bodyToPivot = model.PrimaryPart.CFrame:ToObjectSpace(model:GetPivot()),
		topOffset = bounds.maximum.Y,
	}
end

function EventFishController:_updateMarker(marker, visible: boolean, event, nextStartsAt: number, now: number)
	if not marker then
		return
	end
	if self._Marker ~= marker then
		self._Marker = marker
		table.clear(markerEffects)
	end
	local overhead = marker:FindFirstChild("Overhead")
	if overhead and overhead:IsA("BillboardGui") then
		local content = overhead:FindFirstChild("Content")
		local header = content and content:FindFirstChild("Header")
		local time = content and content:FindFirstChild("Time")
		if header and header:IsA("TextLabel") then
			header.Text = if event then Config.ActiveHeader else Config.WaitingHeader
		end
		if time and time:IsA("TextLabel") then
			time.Text = Config.FormatCountdown((if event then event.EndsAt else nextStartsAt) - now)
		end
		overhead.Enabled = visible
	end
	local rainbow = self._Rainbow and self._Rainbow.model
	for _, effect in marker:GetDescendants() do
		if rainbow and effect:IsDescendantOf(rainbow) then
			continue
		end
		if effect:IsA("Beam") or effect:IsA("ParticleEmitter") or effect:IsA("Light") then
			if markerEffects[effect] == nil then
				markerEffects[effect] = effect.Enabled
			end
			local enabled = event ~= nil and markerEffects[effect]
			if effect.Enabled and not enabled and effect:IsA("ParticleEmitter") then
				effect:Clear()
			end
			effect.Enabled = enabled
		end
	end
end

function EventFishController:_updateRainbow(marker, event, now: number)
	local rainbow = self._Rainbow
	if rainbow and (not event or not marker or rainbow.slotId ~= event.SlotId or rainbow.model.Parent ~= marker) then
		rainbow:Destroy()
		self._Rainbow = nil
		rainbow = nil
	end
	if event and marker and marker:IsA("BasePart") and not rainbow then
		rainbow = EventFishRainbow.new(marker, event.StartsAt)
		if rainbow then
			rainbow.slotId = event.SlotId
			self._Rainbow = rainbow
		elseif not self._WarnedRainbow then
			self._WarnedRainbow = true
			warn("EventFishController: ReplicatedStorage.VFX.Event.RainbowVFX is missing or cannot be cloned")
		end
	end
	if rainbow then
		rainbow:Update(now)
	end
end

function EventFishController:_updateShadow(marker, event, fishing: boolean, now: number)
	if not event then
		self:_clearShadow()
		return
	end
	local waterY = WaterSurfaceUtil.GetWaterSurfaceY()
	local character = LOCAL_PLAYER.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local fishId, slotId, startsAt = event.FishId, event.SlotId, event.StartsAt
	local fish = FishesData[fishId]
	if not fish or not marker or not marker:IsA("BasePart") or not waterY or not humanoid or humanoid.Health <= 0 then
		self:_clearShadow()
		return
	end
	local shadow = self._Shadow
	if shadow and (shadow.slotId ~= slotId or shadow.fishId ~= fishId or not shadow.model.PrimaryPart) then
		self:_clearShadow()
		shadow = nil
	end
	if not shadow and fishing then
		return
	end
	if not shadow then
		shadow = self:_makeShadow(fish, slotId, startsAt)
		self._Shadow = shadow
	end
	if not shadow then
		return
	end
	if fishing then
		if shadow.animation then
			shadow.animation:Destroy()
			shadow.animation = nil
		end
		-- Removing only the local clone hides geometry and every retained effect.
		shadow.model.Parent = nil
		return
	end
	local angle = (now - startsAt) * math.pi * 2 / Config.Shadow.Period
	local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * Config.Shadow.Radius
	local position = Vector3.new(marker.Position.X, waterY - Config.Shadow.Clearance - shadow.topOffset, marker.Position.Z) + offset
	local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))
	shadow.model:PivotTo(CFrame.lookAt(position, position + tangent) * shadow.bodyToPivot)
	if shadow.model.Parent ~= Workspace then
		shadow.model.Parent = Workspace
	end
	if not shadow.animation then
		shadow.animation = FishAnimationController.new(shadow.model, startsAt, nil, "SwimLoop")
	end
	shadow.animation:Update("Holding", startsAt, now, nil, 1)
end

function EventFishController:_update(now: number)
	local state = ReplicatedStorage:FindFirstChild(Config.StateFolderName)
	local liveEvent = getLiveEvent(state, now)
	local fishingController = Knit.GetController("FishingController")
	local fishing = fishingController:IsPreparing()
	local suppressed = EventPresentationGate.IsSuppressed(LOCAL_PLAYER)
	local event = if suppressed then nil elseif fishing then fishingController:GetEventFishSnapshot() else liveEvent
	local visible = not suppressed and not fishing
	local nextStartsAt = state and state:GetAttribute("NextStartsAt")
	if typeof(nextStartsAt) ~= "number" then
		nextStartsAt = Config.GetWindow(now).NextStartsAt
	end
	local areas = Workspace:FindFirstChild("Areas")
	local marker = areas and areas:FindFirstChild("EventFish")
	self:_updateMarker(marker, visible, event, nextStartsAt, now)
	self:_updateRainbow(marker, event, now)
	updateWater(areas and areas:FindFirstChild("Water"), event ~= nil, now)
	self:_updateShadow(marker, if suppressed then nil else liveEvent, fishing, now)
end

function EventFishController:KnitStart()
	LOCAL_PLAYER.CharacterRemoving:Connect(function()
		self:_clearShadow()
	end)
	RunService.RenderStepped:Connect(function()
		self:_update(Workspace:GetServerTimeNow())
	end)
end

return EventFishController
