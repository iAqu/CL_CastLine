local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local SoundHelper = require(script.Parent.SoundHelper)

local Effects = {}
local sounds = ReplicatedStorage.Sound
local starTexture = ReplicatedStorage.Particle.Hatch_Star.Texture
local styles = {
	Normal = { Color = Color3.fromRGB(255, 223, 130), Count = 10, Radius = 0.85, Hold = 0.44 },
	Undead = { Color = Color3.fromRGB(107, 255, 213), Count = 16, Radius = 0.93, Hold = 0.64, Rare = true },
	Galaxy = { Color = Color3.fromRGB(198, 147, 255), Count = 22, Radius = 0.99, Hold = 0.82, Rare = true },
}

function Effects.GetStyle(itemId)
	if itemId == "Fish_005" then
		return styles.Galaxy
	elseif itemId == "Fish_004" then
		return styles.Undead
	end
	return styles.Normal
end

local function guiSound(name, fallback)
	local sound = sounds.Gui:FindFirstChild(name)
	return if sound and sound:IsA("Sound") and sound.SoundId ~= "" then sound else fallback
end

local cues = {
	Success = sounds.Gui.Gui_Fuse_Success,
	Turn = guiSound("Gui_Hatch_Turn", sounds.Gui.Gui_Button_Click),
	Cheer = guiSound("Gui_Hatch_Cheer", sounds:FindFirstChild("FishingCheers", true)),
}
local openSound = guiSound("Gui_Hatch_Open")
local crackSound = guiSound("Gui_Crate_TickSound", sounds.Gui.Gui_Button_Click)

function Effects.Preload(images)
	table.insert(images, starTexture)
	for _, source in pairs(cues) do
		table.insert(images, source)
	end
	table.insert(images, crackSound)
	if openSound then
		table.insert(images, openSound)
	end
	pcall(ContentProvider.PreloadAsync, ContentProvider, images)
end

function Effects.NewAudio()
	local folder = Instance.new("Folder")
	folder.Name = "PaidEggAudio"
	folder.Parent = SoundService
	return folder
end

local function play(audio, cue, source, pitch, delay)
	local sound = SoundHelper.PlaySound(source, audio, delay, 4)
	if sound then
		if pitch then
			sound.PlaybackSpeed *= pitch
		end
		sound:SetAttribute("PaidEggCue", cue)
	end
end

function Effects.Play(audio, cue, pitch)
	play(audio, cue, cues[cue], pitch)
end

function Effects.PlayOpen(audio)
	if
		openSound
		and openSound.IsLoaded
		and openSound.TimeLength > 0
		and openSound.Volume > 0
		and openSound.SoundId ~= cues.Success.SoundId
		and openSound.SoundId ~= cues.Turn.SoundId
	then
		play(audio, "Open", openSound)
		return
	end
	play(audio, "Open", crackSound, 1.08)
	play(audio, "OpenTail", cues.Success, 0.82, 0.045)
end

local function makeCellLayer(parent, cell)
	local container = Instance.new("Frame")
	container.Name = "EffectCell"
	container.AnchorPoint = Vector2.new(0.5, 0)
	container.BackgroundTransparency = 1
	container.ClipsDescendants = true
	container.Position = UDim2.fromScale(cell.X, cell.Y)
	container.Size = UDim2.fromScale(cell.Width, cell.VisualHeight)
	container.Parent = parent
	return container, math.min(container.AbsoluteSize.X, container.AbsoluteSize.Y)
end

local function disc(parent, color, thickness, startSize, endSize, duration, transparency)
	local glow = Instance.new("Frame")
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.Position = UDim2.fromScale(0.5, 0.5)
	glow.Size = UDim2.fromOffset(startSize, startSize)
	glow.BorderSizePixel = 0
	glow.BackgroundColor3 = color
	glow.BackgroundTransparency = transparency
	Instance.new("UICorner", glow).CornerRadius = UDim.new(0.5, 0)
	if thickness > 0 then
		local stroke = Instance.new("UIStroke")
		stroke.Parent = glow
		stroke.Thickness, stroke.Color = thickness, color
		TweenService:Create(stroke, TweenInfo.new(duration), { Transparency = 1 }):Play()
	end
	glow.Parent = parent
	TweenService:Create(glow, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(endSize, endSize),
		BackgroundTransparency = 1,
	}):Play()
end

local function stars(parent, diameter, count, distance, color, duration, angleOffset)
	for i = 1, count do
		local angle = i / count * math.pi * 2 + angleOffset
		local direction = Vector2.new(math.cos(angle), math.sin(angle))
		local pixels = math.clamp(diameter * (if i % 2 == 0 then 0.18 else 0.1), 5, 38)
		local target = direction * (diameter * distance / 2 - pixels / 2)
		local icon = Instance.new("ImageLabel")
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.BackgroundTransparency = 1
		icon.Image = starTexture
		icon.ImageColor3 = if i % 2 == 0 then color else Color3.new(1, 1, 1)
		icon.Size = UDim2.fromOffset(pixels, pixels)
		icon.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(target.X * 0.26, target.Y * 0.26)
		icon.Rotation = i * 21
		icon.Parent = parent
		TweenService:Create(icon, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(target.X, target.Y),
			ImageTransparency = 1,
			Rotation = icon.Rotation + 110,
		}):Play()
	end
end

function Effects.Emit(parent, cells, entries, phase, beat, durationScale)
	local layer = Instance.new("Frame")
	layer.Name = phase
	layer.Size = UDim2.fromScale(1, 1)
	layer.BackgroundTransparency = 1
	layer.ZIndex = if phase == "RevealBack" then 1 else 4
	layer.Parent = parent
	local lifetime = 0
	for index, cell in ipairs(cells) do
		local container, diameter = makeCellLayer(layer, cell)
		local style = entries[index].Style or styles.Normal
		if phase == "TurnStars" then
			lifetime = 0.26 * durationScale
			stars(container, diameter, 2 + beat, 0.48 + beat * 0.14, styles.Normal.Color, lifetime, beat * 0.65)
		elseif phase == "BurstFlash" then
			lifetime = 0.20
			disc(container, Color3.fromRGB(255, 246, 212), 3, diameter * 0.30, diameter * 0.92, lifetime, 0.20)
		elseif phase == "RevealBack" then
			lifetime = math.max(lifetime, style.Hold)
			disc(container, style.Color, 0, diameter * 0.30, diameter * style.Radius, style.Hold, 0.50)
		else
			lifetime = math.max(lifetime, style.Hold)
			disc(container, style.Color, 3, diameter * 0.24, diameter * style.Radius, style.Hold * 0.7, 1)
			stars(container, diameter, style.Count, style.Radius, style.Color, style.Hold, 0.24 * index)
			if style.Rare then
				task.delay(0.07, function()
					if layer.Parent then
						disc(container, style.Color, 2, diameter * 0.12, diameter * style.Radius, style.Hold * 0.8, 1)
					end
				end)
			end
		end
	end
	task.delay(lifetime, function()
		layer:Destroy()
	end)
end

return Effects
