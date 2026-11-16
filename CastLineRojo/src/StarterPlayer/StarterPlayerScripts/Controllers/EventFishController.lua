local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Modules.EventFishConfig)
local FishesData = require(ReplicatedFirst.Data.FishesData)
local Assets = require(ReplicatedStorage.Modules.FishingAssets)
local FishAnimationController = require(ReplicatedStorage.Modules.FishAnimationController)
local FishShadowAppearance = require(ReplicatedStorage.Modules.FishShadowAppearance)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)

local LOCAL_PLAYER = Players.LocalPlayer
local EventFishController = Knit.CreateController({ Name = "EventFishController" })

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

function EventFishController:_update(now: number)
	local state = ReplicatedStorage:FindFirstChild(Config.StateFolderName)
	local phase = state and state:GetAttribute("Phase")
	local startsAt = state and state:GetAttribute("StartsAt")
	local endsAt = state and state:GetAttribute("EndsAt")
	local active = phase == "Active" and typeof(startsAt) == "number" and typeof(endsAt) == "number"
		and now >= startsAt and now < endsAt
	Knit.GetController("EventController"):SetEventFishActive(active)
	if not active then
		self:_clearShadow()
		return
	end
	local areas = Workspace:FindFirstChild("Areas")
	local marker = areas and areas:FindFirstChild("EventFish")
	local waterY = WaterSurfaceUtil.GetWaterSurfaceY()
	local character = LOCAL_PLAYER.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local fishId, slotId = state:GetAttribute("FishId"), state:GetAttribute("SlotId")
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
	local fishing = Knit.GetController("FishingController"):IsPreparing()
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

function EventFishController:KnitStart()
	LOCAL_PLAYER.CharacterRemoving:Connect(function()
		self:_clearShadow()
	end)
	RunService.RenderStepped:Connect(function()
		self:_update(Workspace:GetServerTimeNow())
	end)
end

return EventFishController
