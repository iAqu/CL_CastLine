local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local EffectUtil = require(script.Parent.EffectUtil)
local SoundHelper = require(script.Parent.SoundHelper)
local WeightFormat = require(script.Parent.WeightFormat)
local NumberUtil = require(script.Parent.NumberUtil)
local Effects = {}
Effects.__index = Effects
local palette = {
	Color3.fromRGB(152, 246, 72),
	Color3.fromRGB(96, 205, 255),
	Color3.fromRGB(255, 220, 90),
	Color3.fromRGB(248, 92, 232),
	Color3.fromRGB(250, 75, 75),
	Color3.new(1, 1, 1),
}

function Effects.new(gui)
	return setmetatable({ gui = gui, tweens = {}, objects = {}, random = Random.new() }, Effects)
end

function Effects:_tween(object, info, properties)
	local tween = TweenService:Create(object, info, properties)
	self.tweens[tween] = true
	tween.Completed:Once(function()
		self.tweens[tween] = nil
	end)
	tween:Play()
	return tween
end

function Effects:SetFill(ratio, instant)
	if not instant and ratio == self.fillTarget then
		return
	end
	self.fillTarget = ratio
	if self.fillTween then
		self.fillTween:Cancel()
		self.fillTween = nil
	end
	local fill = self.gui.XPBar.Track.Fill
	if instant then
		fill.Size = UDim2.fromScale(ratio, 1)
	else
		self.fillTween = self:_tween(fill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(ratio, 1),
		})
	end
end

function Effects:_expire(object, delay)
	self.objects[object] = true
	task.delay(delay, function()
		self.objects[object] = nil
		object:Destroy()
	end)
end

function Effects:_trackUntilDestroyed(object)
	if not object then
		return
	end
	local objects = self.objects
	objects[object] = true
	object.Destroying:Once(function()
		objects[object] = nil
	end)
end

function Effects:_popup(template, root, value, offset, direction, duration)
	if not root or not root.Parent then
		return
	end
	local popup = self.gui.Templates[template]:Clone()
	popup.Name = "Training" .. template
	popup.AlwaysOnTop = true
	popup.Adornee, popup.StudsOffsetWorldSpace, popup.Enabled = root, offset, true
	local label = popup.Text
	label.Text, label.PulseScale.Scale = value, 0.3
	popup.Parent = root
	self:_expire(popup, duration + 0.2)
	self:_tween(label.PulseScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	self:_tween(popup, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		StudsOffsetWorldSpace = offset + direction,
	})
	task.delay(duration * 0.55, function()
		if not self.objects[popup] then
			return
		end
		local fade = TweenInfo.new(duration * 0.45)
		self:_tween(label, fade, { TextTransparency = 1 })
		self:_tween(label.Stroke, fade, { Transparency = 1 })
	end)
end

function Effects:Rep(amount, root)
	local camera = workspace.CurrentCamera
	if amount <= 0 or not camera then
		return
	end
	local angle = self.random:NextNumber(0, math.pi * 2)
	local direction = camera.CFrame.RightVector * math.cos(angle) + camera.CFrame.UpVector * math.sin(angle)
	self:_popup(
		"XpPopup",
		root,
		"+" .. NumberUtil.FormatNumberStartKWithDecimal(amount, 1) .. " XP",
		Vector3.new(0, 1, 0) + direction * 0.6,
		direction * self.random:NextNumber(2.2, 3.4),
		0.85
	)
end

function Effects:_playLevelUpEffect(root)
	local character = root and root.Parent
	local humanoid = character and character:IsA("Model") and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 or not root:IsA("BasePart") then
		return
	end

	self:_trackUntilDestroyed(EffectUtil.PlayBodySizeChangeEffect(root, character:GetScale(), false))

	local sounds = ReplicatedStorage:FindFirstChild("Sound")
	local otherSounds = sounds and sounds:FindFirstChild("Others")
	local getCup = otherSounds and otherSounds:FindFirstChild("Get_Cup")
	if getCup and getCup:IsA("Sound") then
		local objects = self.objects
		local sound = SoundHelper.PlaySound(getCup)
		if sound and self.objects ~= objects then
			sound:Destroy()
		else
			self:_trackUntilDestroyed(sound)
		end
	end
end

function Effects:LevelUp(weight, root)
	self:_popup("LevelPopup", root, "LEVEL UP!", Vector3.new(0, 4.2, 0), Vector3.new(0, 1.3, 0), 1.6)
	self:_popup(
		"WeightPopup",
		root,
		"Max Catch +" .. WeightFormat.FormatMaxCatchWeight(weight),
		Vector3.new(0, 3.1, 0),
		Vector3.new(0, 1.3, 0),
		1.6
	)
	local layer = self.gui.Effects
	local bar = self.gui.XPBar
	local center = bar.AbsolutePosition + bar.AbsoluteSize / 2 - layer.AbsolutePosition
	for _ = 1, 26 do
		local piece = self.gui.Templates.ConfettiPiece:Clone()
		piece.Visible = true
		piece.Position = UDim2.fromOffset(center.X, center.Y)
		piece.Size = UDim2.fromOffset(self.random:NextInteger(8, 14), self.random:NextInteger(8, 14))
		piece.BackgroundColor3 = palette[self.random:NextInteger(1, #palette)]
		piece.Rotation = self.random:NextInteger(0, 360)
		piece.Parent = layer
		local angle = math.rad(self.random:NextInteger(200, 340))
		local speed = self.random:NextInteger(120, 320)
		local duration = self.random:NextNumber(0.9, 1.4)
		self:_expire(piece, duration + 0.1)
		self:_tween(piece, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(center.X + math.cos(angle) * speed, center.Y + math.sin(angle) * speed + 120),
			Rotation = piece.Rotation + self.random:NextInteger(-360, 360),
		})
	end
	self:_playLevelUpEffect(root)
end

function Effects:Clear()
	local tweens, objects = self.tweens, self.objects
	self.tweens, self.objects = {}, {}
	for tween in pairs(tweens) do
		tween:Cancel()
	end
	for object in pairs(objects) do
		object:Destroy()
	end
	self.fillTween, self.fillTarget = nil, nil
end

return Effects
