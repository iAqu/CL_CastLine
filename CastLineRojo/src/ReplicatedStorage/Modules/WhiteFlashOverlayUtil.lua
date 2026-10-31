--!strict
-- 通用「变白覆盖」工具：把一个模型克隆成整体发光白的覆盖层，用于变白过渡效果。
-- 复用场景：动物升级变白、地块 skin 切换变白。

local TweenService = game:GetService("TweenService")

local NEON_WHITE = Color3.new(1, 1, 1)

local WhiteFlashOverlayUtil = {}

export type Overlay = {
	Model: Model?,
	_parts: { BasePart },
	_fadeTweens: { Tween },
	_fadeSeq: number,
	_destroyed: boolean,
	PivotTo: (self: Overlay, cframe: CFrame) -> (),
	ScaleTo: (self: Overlay, scale: number) -> (),
	SetTransparency: (self: Overlay, transparency: number) -> (),
	FadeIn: (self: Overlay, duration: number, onComplete: (() -> ())?) -> (),
	FadeOut: (self: Overlay, duration: number, onComplete: (() -> ())?) -> (),
	Destroy: (self: Overlay) -> (),
}

export type HighlightOverlay = {
	Highlight: Highlight?,
	_fadeTween: Tween?,
	_fadeSeq: number,
	_destroyed: boolean,
	SetTransparency: (self: HighlightOverlay, transparency: number) -> (),
	FadeIn: (self: HighlightOverlay, duration: number, onComplete: (() -> ())?) -> (),
	FadeOut: (self: HighlightOverlay, duration: number, onComplete: (() -> ())?) -> (),
	Destroy: (self: HighlightOverlay) -> (),
}

local function clearAttributes(instance: Instance)
	for attributeName in instance:GetAttributes() do
		-- RBX_* 为引擎/导入保留属性，客户端无权清除。
		if string.sub(attributeName, 1, 4) == "RBX_" then
			continue
		end
		pcall(function()
			instance:SetAttribute(attributeName, nil)
		end)
	end
end

-- 克隆模型并把所有 BasePart 变成发光纯白、无碰撞；剥离贴图/GUI/脚本/特效等干扰元素。
local function buildNeonClone(source: Model): (Model, { BasePart })
	local clone = source:Clone()
	clearAttributes(clone)

	local parts: { BasePart } = {}
	for _, descendant in clone:GetDescendants() do
		if
			descendant:IsA("SurfaceAppearance")
			or descendant:IsA("Decal")
			or descendant:IsA("Texture")
			or descendant:IsA("SurfaceGui")
			or descendant:IsA("BillboardGui")
			or descendant:IsA("ParticleEmitter")
			or descendant:IsA("Trail")
			or descendant:IsA("Beam")
			or descendant:IsA("Light")
			or descendant:IsA("Fire")
			or descendant:IsA("Smoke")
			or descendant:IsA("Sparkles")
			or descendant:IsA("Sound")
			or descendant:IsA("AnimationController")
			or descendant:IsA("Animator")
			or descendant:IsA("Script")
			or descendant:IsA("LocalScript")
			or descendant:IsA("ClickDetector")
			or descendant:IsA("ProximityPrompt")
		then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			clearAttributes(descendant)
			descendant.Material = Enum.Material.Neon
			descendant.Color = NEON_WHITE
			descendant.Transparency = 0
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
			descendant.Massless = true
			table.insert(parts, descendant)
		end
	end

	return clone, parts
end

local Overlay = {}
Overlay.__index = Overlay

function Overlay:_cancelFades()
	for _, tween in self._fadeTweens do
		tween:Cancel()
	end
	table.clear(self._fadeTweens)
end

function Overlay:PivotTo(cframe: CFrame)
	local model = self.Model
	if model and model.Parent then
		model:PivotTo(cframe)
	end
end

function Overlay:ScaleTo(scale: number)
	local model = self.Model
	if model and model.Parent then
		model:ScaleTo(scale)
	end
end

function Overlay:SetTransparency(transparency: number)
	self:_cancelFades()
	self._fadeSeq += 1
	for _, part in self._parts do
		if part.Parent then
			part.Transparency = transparency
		end
	end
end

function Overlay:_fade(targetTransparency: number, duration: number, onComplete: (() -> ())?)
	if self._destroyed then
		return
	end

	self:_cancelFades()
	self._fadeSeq += 1
	local seq = self._fadeSeq

	if duration <= 0 then
		for _, part in self._parts do
			if part.Parent then
				part.Transparency = targetTransparency
			end
		end
		if onComplete then
			onComplete()
		end
		return
	end

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	for _, part in self._parts do
		if part.Parent and part.Transparency ~= targetTransparency then
			local tween = TweenService:Create(part, tweenInfo, { Transparency = targetTransparency })
			table.insert(self._fadeTweens, tween)
			tween:Play()
		end
	end

	task.delay(duration, function()
		if self._destroyed or self._fadeSeq ~= seq then
			return
		end
		if onComplete then
			onComplete()
		end
	end)
end

function Overlay:FadeIn(duration: number, onComplete: (() -> ())?)
	self:_fade(0, duration, onComplete)
end

function Overlay:FadeOut(duration: number, onComplete: (() -> ())?)
	self:_fade(1, duration, onComplete)
end

function Overlay:Destroy()
	if self._destroyed then
		return
	end
	self._destroyed = true
	self:_cancelFades()

	local model = self.Model
	if model then
		model:Destroy()
	end
	self.Model = nil
	table.clear(self._parts)
end

local HighlightOverlayClass = {}
HighlightOverlayClass.__index = HighlightOverlayClass

function HighlightOverlayClass:_cancelFade()
	if self._fadeTween then
		self._fadeTween:Cancel()
		self._fadeTween = nil
	end
end

function HighlightOverlayClass:SetTransparency(transparency: number)
	self:_cancelFade()
	self._fadeSeq += 1
	local highlight = self.Highlight
	if highlight and highlight.Parent then
		highlight.FillTransparency = transparency
		highlight.OutlineTransparency = transparency
	end
end

function HighlightOverlayClass:_fade(targetTransparency: number, duration: number, onComplete: (() -> ())?)
	if self._destroyed then
		return
	end

	self:_cancelFade()
	self._fadeSeq += 1
	local seq = self._fadeSeq

	local highlight = self.Highlight
	if not highlight or not highlight.Parent then
		return
	end

	if duration <= 0 then
		highlight.FillTransparency = targetTransparency
		highlight.OutlineTransparency = targetTransparency
		if onComplete then
			onComplete()
		end
		return
	end

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(highlight, tweenInfo, {
		FillTransparency = targetTransparency,
		OutlineTransparency = targetTransparency,
	})
	self._fadeTween = tween
	tween:Play()

	task.delay(duration, function()
		if self._destroyed or self._fadeSeq ~= seq then
			return
		end
		if onComplete then
			onComplete()
		end
	end)
end

function HighlightOverlayClass:FadeIn(duration: number, onComplete: (() -> ())?)
	self:_fade(0, duration, onComplete)
end

function HighlightOverlayClass:FadeOut(duration: number, onComplete: (() -> ())?)
	self:_fade(1, duration, onComplete)
end

function HighlightOverlayClass:Destroy()
	if self._destroyed then
		return
	end
	self._destroyed = true
	self:_cancelFade()

	local highlight = self.Highlight
	if highlight then
		highlight:Destroy()
	end
	self.Highlight = nil
end

-- 在目标模型上挂一个白色 Highlight（fill + outline）覆盖层，初始完全透明。
-- Highlight 会自动覆盖模型后续复制进来的子部件，适合做替换过渡的缓冲。
function WhiteFlashOverlayUtil.CreateHighlight(adornee: Model): HighlightOverlay?
	if not adornee or not adornee:IsA("Model") then
		return nil
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "WhiteFlashHighlight"
	highlight.FillColor = NEON_WHITE
	highlight.OutlineColor = NEON_WHITE
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Adornee = adornee
	highlight.Parent = adornee

	local overlay = setmetatable({
		Highlight = highlight,
		_fadeTween = nil,
		_fadeSeq = 0,
		_destroyed = false,
	}, HighlightOverlayClass)

	return (overlay :: any) :: HighlightOverlay
end

-- 创建一个变白覆盖层。默认全白不透明（Transparency = 0），parent 默认为 workspace。
function WhiteFlashOverlayUtil.Create(source: Model, parent: Instance?): Overlay?
	if not source or not source:IsA("Model") then
		return nil
	end

	local ok, clone, parts = pcall(function()
		return buildNeonClone(source)
	end)
	if not ok or not clone then
		warn("WhiteFlashOverlayUtil.Create failed:", clone)
		return nil
	end

	clone.Parent = parent or workspace

	local overlay = setmetatable({
		Model = clone,
		_parts = parts,
		_fadeTweens = {},
		_fadeSeq = 0,
		_destroyed = false,
	}, Overlay)

	return (overlay :: any) :: Overlay
end

-- 用 LocalTransparencyModifier 在本地隐藏一个模型（不影响服务端/其他客户端），返回受影响的 Part 列表。
function WhiteFlashOverlayUtil.HideModelLocally(model: Model): { BasePart }
	local parts: { BasePart } = {}
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.LocalTransparencyModifier = 1
			table.insert(parts, descendant)
		end
	end
	return parts
end

function WhiteFlashOverlayUtil.ShowModel(parts: { BasePart })
	for _, part in parts do
		if part.Parent then
			part.LocalTransparencyModifier = 0
		end
	end
end

return WhiteFlashOverlayUtil
