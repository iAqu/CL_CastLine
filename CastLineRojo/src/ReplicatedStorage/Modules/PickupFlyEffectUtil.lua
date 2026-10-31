local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local PickupFlyEffectUtil = {}

local FLY_DURATION = 0.35
local FINAL_SCALE_RATIO = 0.05

local Snapshot = {}
Snapshot.__index = Snapshot

export type Snapshot = typeof(setmetatable(
	{} :: {
		_model: Model?,
		_startCFrame: CFrame,
		_startScale: number,
		_connection: RBXScriptConnection?,
	},
	Snapshot
))

local function prepareVisual(model: Model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BaseScript")
			or descendant:IsA("ProximityPrompt")
			or descendant:IsA("Highlight")
			or descendant:IsA("BillboardGui")
		then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
		end
	end
end

function Snapshot.Destroy(self: Snapshot)
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end

	if self._model then
		self._model:Destroy()
		self._model = nil
	end
end

function Snapshot.Play(self: Snapshot, targetPart: BasePart?): boolean
	local model = self._model
	if not model or not targetPart or not targetPart.Parent then
		self:Destroy()
		return false
	end

	model:ScaleTo(self._startScale)
	model:PivotTo(self._startCFrame)
	model.Parent = workspace

	local startedAt = os.clock()
	self._connection = RunService.RenderStepped:Connect(function()
		if not model.Parent or not targetPart.Parent then
			self:Destroy()
			return
		end

		local alpha = math.clamp((os.clock() - startedAt) / FLY_DURATION, 0, 1)
		local easedAlpha = TweenService:GetValue(alpha, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local position = self._startCFrame.Position:Lerp(targetPart.Position, easedAlpha)
		local scale = self._startScale * (1 + (FINAL_SCALE_RATIO - 1) * easedAlpha)

		model:ScaleTo(math.max(scale, 0.001))
		model:PivotTo(CFrame.new(position) * self._startCFrame.Rotation)

		if alpha >= 1 then
			self:Destroy()
		end
	end)
	return true
end

function PickupFlyEffectUtil.CreateSnapshot(sourceModel: Model): Snapshot?
	local success, clone = pcall(function()
		return sourceModel:Clone()
	end)
	if not success or not clone then
		return nil
	end

	prepareVisual(clone)
	return setmetatable({
		_model = clone,
		_startCFrame = sourceModel:GetPivot(),
		_startScale = sourceModel:GetScale(),
		_connection = nil,
	}, Snapshot)
end

return PickupFlyEffectUtil
