local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Config = require(script.Parent.FishingConfig)

local Feedback = {}
local EDGE = 16

local function ease(value, duration, style)
	return TweenService:GetValue(
		math.clamp(value / duration, 0, 1),
		style or Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)
end

function Feedback.Bind(owner)
	if owner.meterFeedback then
		return
	end
	local meter = owner.meter
	local scale = owner:_scale(meter.holder)
	local state = { scale = scale, baseScale = scale.Scale, fades = {} }
	owner.meterFeedback = state
	owner:_save(meter.gui, { "Enabled" })
	owner:_save(meter.marker, { "BackgroundColor3" })
	local objects = meter.holder:GetDescendants()
	table.insert(objects, meter.holder)
	for _, object in ipairs(objects) do
		local properties = {}
		if object:IsA("GuiObject") then
			table.insert(properties, "BackgroundTransparency")
		end
		if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
			table.insert(properties, "TextTransparency")
			table.insert(properties, "TextStrokeTransparency")
		elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
			table.insert(properties, "ImageTransparency")
		elseif object:IsA("UIStroke") then
			table.insert(properties, "Transparency")
		end
		if #properties > 0 then
			owner:_save(object, properties)
			for _, property in ipairs(properties) do
				table.insert(state.fades, { object = object, property = property, base = object[property] })
			end
		end
	end
end

local function rainbow(owner)
	local state = owner.meterFeedback
	if not state.gradient then
		local gradient = owner.popup:FindFirstChildOfClass("UIGradient")
		if gradient then
			owner:_save(gradient, { "Enabled", "Color", "Rotation" })
		else
			gradient = Instance.new("UIGradient")
			gradient.Name = "CastRatingRainbow"
			gradient.Parent = owner.popup
			state.createdGradient = true
		end
		state.gradient = gradient
	end
	local keys = {}
	for i, rgb in ipairs({
		{ 255, 60, 60 },
		{ 255, 145, 35 },
		{ 255, 235, 60 },
		{ 70, 240, 95 },
		{ 65, 225, 255 },
		{
			90,
			130,
			255,
		},
		{
			195,
			80,
			255,
		},
	}) do
		table.insert(keys, ColorSequenceKeypoint.new((i - 1) / 6, Color3.fromRGB(unpack(rgb))))
	end
	state.gradient.Color = ColorSequence.new(keys)
	state.gradient.Rotation = 0
	state.gradient.Enabled = true
end

function Feedback.Show(owner, rating, now)
	Feedback.Bind(owner)
	local state = owner.meterFeedback
	state.finished = false
	local meter = owner.meter
	local color = Color3.fromRGB(unpack(rating.Color))
	owner.castRating = rating.Id
	owner.meterLockedAt = owner.meterLockedAt or now
	owner.popup.Text = rating.Text
	owner.popup.TextColor3, owner.popup.TextTransparency, owner.popup.Visible = color, 0, true
	owner.popupStroke.Transparency, owner.popupScale.Scale = 0, 0.3
	meter.prompt.Visible = false
	meter.marker.BackgroundColor3 = color
	if rating.Rainbow then
		rainbow(owner)
	elseif state.gradient then
		state.gradient.Enabled = false
	end
	local viewport = Workspace.CurrentCamera.ViewportSize
	local width, height = owner.popup.AbsoluteSize.X / 2, owner.popup.AbsoluteSize.Y / 2
	local marker = meter.marker
	local right = marker.AbsolutePosition.X + marker.AbsoluteSize.X + 12 + width
	local x = if right + width <= viewport.X - EDGE then right else marker.AbsolutePosition.X - 12 - width
	local minX, minY = EDGE + width, EDGE + height
	owner.popupOrigin = Vector2.new(
		math.clamp(x, minX, math.max(minX, viewport.X - EDGE - width)),
		math.clamp(
			marker.AbsolutePosition.Y + marker.AbsoluteSize.Y / 2,
			minY,
			math.max(minY, viewport.Y - EDGE - height)
		)
	)
	owner.popup.Position = UDim2.fromOffset(owner.popupOrigin.X, owner.popupOrigin.Y)
end

function Feedback.Update(owner, now)
	if not owner.meterLockedAt or not owner.meterFeedback or owner.meterFeedback.finished then
		return
	end
	local elapsed = math.max(0, now - owner.meterLockedAt)
	local settings, state = Config.Meter, owner.meterFeedback
	local fade = math.clamp((elapsed - settings.Hold) / settings.Exit, 0, 1)
	state.scale.Scale = state.baseScale * (1 - 0.15 * ease(elapsed - settings.Hold, settings.Exit))
	for _, entry in ipairs(state.fades) do
		entry.object[entry.property] = entry.base + (1 - entry.base) * fade
	end
	owner.meter.gui.Enabled = now < owner.meterLockedAt + (settings.Hold + settings.Exit)
	owner.popupScale.Scale = 0.3 + 0.7 * ease(elapsed, 0.3, Enum.EasingStyle.Back)
	local viewport = Workspace.CurrentCamera.ViewportSize
	local rise = settings.PopupRise * viewport.Y * ease(elapsed - 0.15, settings.PopupDuration - 0.15)
	local halfWidth, halfHeight = owner.popup.AbsoluteSize.X / 2, owner.popup.AbsoluteSize.Y / 2
	local x, y = owner.popupOrigin.X, owner.popupOrigin.Y - rise
	owner.popup.Position = UDim2.fromOffset(
		math.clamp(x, EDGE + halfWidth, math.max(EDGE + halfWidth, viewport.X - EDGE - halfWidth)),
		math.clamp(y, EDGE + halfHeight, math.max(EDGE + halfHeight, viewport.Y - EDGE - halfHeight))
	)
	local popupFade =
		math.clamp((elapsed - settings.PopupFadeAt) / (settings.PopupDuration - settings.PopupFadeAt), 0, 1)
	owner.popup.TextTransparency, owner.popupStroke.Transparency = popupFade, popupFade
	owner.popup.Visible = now < owner.meterLockedAt + settings.PopupDuration
	if not owner.popup.Visible and not owner.meter.gui.Enabled then
		state.finished = true
	end
end

function Feedback.Destroy(owner)
	local state = owner.meterFeedback
	if state and state.createdGradient then
		state.gradient:Destroy()
	end
	owner.meterFeedback = nil
end

return Feedback
