local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Y_OFFSET = -14.477272 -- 760.889 target Y minus 775.366272 marker Y.

local EventFishRainbow = {}
EventFishRainbow.__index = EventFishRainbow

local function numberAttribute(model, name, fallback, minimum, maximum)
	local value = model:GetAttribute(name)
	return math.clamp(if typeof(value) == "number" then value else fallback, minimum, maximum)
end

local function rainbowSequence(hue, value, isBeam)
	local count = if isBeam then 7 else 4
	local span = if isBeam then 0.92 else 0.42
	local keypoints = table.create(count)
	for index = 0, count - 1 do
		local time = index / (count - 1)
		keypoints[index + 1] = ColorSequenceKeypoint.new(time, Color3.fromHSV((hue + time * span) % 1, 0.96, value))
	end
	return ColorSequence.new(keypoints)
end

function EventFishRainbow.new(marker: BasePart, startsAt: number)
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local event = vfx and vfx:FindFirstChild("Event")
	local template = event and event:FindFirstChild("RainbowVFX")
	local model = template and template:IsA("Model") and template:Clone()
	if not model then
		return nil
	end

	local colors, lights = {}, {}
	for _, instance in model:GetDescendants() do
		if instance:IsA("BaseScript") then
			instance:Destroy()
		elseif instance:IsA("BasePart") then
			instance.CanCollide, instance.CanTouch, instance.CanQuery = false, false, false
		elseif instance:IsA("Beam") or instance:IsA("ParticleEmitter") then
			local isBeam = instance:IsA("Beam")
			table.insert(colors, {
				instance = instance,
				color = instance.Color,
				brightness = if isBeam then instance.Brightness else nil,
			})
		elseif instance:IsA("Light") then
			table.insert(lights, { instance = instance, color = instance.Color, brightness = instance.Brightness })
		end
	end
	model:PivotTo(marker:GetPivot() + Vector3.new(0, Y_OFFSET, 0))
	model.Parent = marker
	return setmetatable({ model = model, startsAt = startsAt, colors = colors, lights = lights }, EventFishRainbow)
end

function EventFishRainbow:Update(now: number)
	local model = self.model
	if model:GetAttribute("RainbowEnabled") == false then
		if self.nextUpdate then
			for _, targets in { self.colors, self.lights } do
				for _, target in targets do
					target.instance.Color = target.color
					if target.brightness then
						target.instance.Brightness = target.brightness
					end
				end
			end
			self.nextUpdate = nil
		end
		return
	end
	if self.nextUpdate and now < self.nextUpdate then
		return
	end
	self.nextUpdate = now + 1 / numberAttribute(model, "UpdateHz", 12, 2, 30)
	local elapsed = math.max(0, now - self.startsAt)
	local hueCycle = numberAttribute(model, "HueCycleSeconds", 4, 0.5, 30)
	local flashHz = numberAttribute(model, "FlashHz", 2, 0, 12)
	local flashDepth = numberAttribute(model, "FlashDepth", 0.55, 0, 0.85)
	local pulse = if flashHz > 0 then (math.sin(elapsed * math.pi * 2 * flashHz) + 1) * 0.5 else 1
	local intensity = (1 - flashDepth) + flashDepth * pulse
	local value = 0.38 + 0.62 * intensity
	local hue = elapsed / hueCycle
	for index, target in self.colors do
		local isBeam = target.brightness ~= nil
		target.instance.Color = rainbowSequence(hue + (index - 1) / #self.colors, value, isBeam)
		if isBeam then
			target.instance.Brightness = target.brightness * (0.45 + 0.55 * intensity)
		end
	end
	for index, target in self.lights do
		local phase = (#self.colors + index - 1) / (#self.colors + #self.lights)
		target.instance.Color = Color3.fromHSV((hue + phase) % 1, 0.9, value)
		target.instance.Brightness = target.brightness * (0.4 + 0.6 * intensity)
	end
end

function EventFishRainbow:Destroy()
	self.model:Destroy()
end

return EventFishRainbow
