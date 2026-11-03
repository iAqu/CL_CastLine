-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local v1 = Color3.fromRGB(0, 255, 220)
local v2 = Color3.fromRGB(255, 0, 200)
local v3 = Color3.fromRGB(255, 255, 255)
local v4 = Color3.fromRGB(180, 180, 180)
local v5 = Color3.fromRGB(220, 220, 230)
local v6 = Color3.fromRGB(255, 255, 255)
local v7 = Color3.fromRGB(60, 255, 90)
local GlitchSoundEffect = SoundService.Effects.GlitchSoundEffect
local function randf(p1, p2) --[[ randf | Line: 32 ]]
	return p1 + math.random() * (p2 - p1)
end
local function pickChar() --[[ pickChar | Line: 36 ]]
	local v1 = math.random(1, 36)
	return string.sub("0123456789ABCDEF!@#$%&*<>/\\|_-=+[]{}", v1, v1)
end
local function makeGlitchText(p1) --[[ makeGlitchText | Line: 41 ]]
	local v1 = table.create(p1)
	for i = 1, p1 do
		local v2 = math.random(1, 36)
		v1[i] = string.sub("0123456789ABCDEF!@#$%&*<>/\\|_-=+[]{}", v2, v2)
	end
	return table.concat(v1)
end
local function makeGui(p1) --[[ makeGui | Line: 51 ]]
	local HackGlitchVFX = Instance.new("ScreenGui")
	HackGlitchVFX.Name = "HackGlitchVFX"
	HackGlitchVFX.IgnoreGuiInset = true
	HackGlitchVFX.ResetOnSpawn = false
	HackGlitchVFX.DisplayOrder = 50000
	HackGlitchVFX.Parent = p1
	return HackGlitchVFX
end
local function makeFullFrame(p1, p2, p3, p4, p5) --[[ makeFullFrame | Line: 61 ]]
	local Frame = Instance.new("Frame")
	Frame.Name = p1
	Frame.Size = UDim2.fromScale(1, 1)
	Frame.Position = UDim2.fromScale(0, 0)
	Frame.BackgroundColor3 = p2
	Frame.BackgroundTransparency = p3
	Frame.BorderSizePixel = 0
	Frame.ZIndex = p4
	Frame.Parent = p5
	return Frame
end
local function makeNoiseTile(p1) --[[ makeNoiseTile | Line: 74 | Upvalues: v4 (copy) ]]
	local Static = Instance.new("ImageLabel")
	Static.Name = "Static"
	Static.Size = UDim2.fromScale(1, 1)
	Static.BackgroundTransparency = 1
	Static.Image = "rbxasset://textures/noise.png"
	Static.ImageColor3 = v4
	Static.ImageTransparency = 1
	Static.ScaleType = Enum.ScaleType.Tile
	Static.TileSize = UDim2.fromOffset(96, 96)
	Static.ZIndex = 200
	Static.Parent = p1
	return Static
end
local function makeVignette(p1) --[[ makeVignette | Line: 89 ]]
	local Vignette = Instance.new("Frame")
	Vignette.Name = "Vignette"
	Vignette.Size = UDim2.fromScale(1, 1)
	Vignette.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
	Vignette.BackgroundTransparency = 1
	Vignette.BorderSizePixel = 0
	Vignette.ZIndex = 800
	Vignette.Parent = p1
	local UIGradient = Instance.new("UIGradient")
	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.4, 0.85),
		NumberSequenceKeypoint.new(0.75, 0.4),
		NumberSequenceKeypoint.new(1, 0)
	})
	UIGradient.Parent = Vignette
	return Vignette
end
local function makeGlitchLabel(p1, p2, p3) --[[ makeGlitchLabel | Line: 110 | Upvalues: v7 (copy) ]]
	local GlitchText = Instance.new("TextLabel")
	GlitchText.Name = "GlitchText"
	GlitchText.AnchorPoint = Vector2.new(p2, p3)
	GlitchText.Position = UDim2.new(p2, if p2 == 0 then 16 else -16, p3, if p3 == 0 then 16 else -16)
	GlitchText.Size = UDim2.fromOffset(360, 80)
	GlitchText.BackgroundTransparency = 1
	GlitchText.Font = Enum.Font.Code
	GlitchText.TextSize = 16
	GlitchText.TextColor3 = v7
	GlitchText.TextStrokeColor3 = Color3.new(0/255, 0/255, 0/255)
	GlitchText.TextStrokeTransparency = 0.4
	GlitchText.TextXAlignment = p2 == 0 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
	GlitchText.TextYAlignment = p3 == 0 and Enum.TextYAlignment.Top or Enum.TextYAlignment.Bottom
	GlitchText.Text = ""
	GlitchText.TextTransparency = 1
	GlitchText.ZIndex = 700
	GlitchText.Parent = p1
	return GlitchText
end
local function makeColorCorrection() --[[ makeColorCorrection | Line: 131 | Upvalues: v3 (copy), Lighting (copy) ]]
	local HackGlitchCC = Instance.new("ColorCorrectionEffect")
	HackGlitchCC.Name = "HackGlitchCC"
	HackGlitchCC.Brightness = 0
	HackGlitchCC.Contrast = 0
	HackGlitchCC.Saturation = 0
	HackGlitchCC.TintColor = v3
	HackGlitchCC.Parent = Lighting
	return HackGlitchCC
end
return function(p1, p2) --[[ HackGlitch | Line: 144 | Upvalues: Players (copy), GlitchSoundEffect (copy), makeFullFrame (copy), makeNoiseTile (copy), makeGlitchLabel (copy), makeVignette (copy), v3 (copy), Lighting (copy), RunService (copy), v6 (copy), Debris (copy), TweenService (copy), v1 (copy), v2 (copy), v5 (copy) ]]
	local v12 = p1 or 5
	local v22 = p2 or 0.3
	local LocalPlayer = Players.LocalPlayer
	local v32 = if LocalPlayer then LocalPlayer:FindFirstChildOfClass("PlayerGui") else LocalPlayer
	if v32 then
		local t = {}
		local t2 = {}
		local t3 = {}
		local v4 = false
		local function track(p1) --[[ track | Line: 156 | Upvalues: t2 (copy), t (copy) ]]
			if typeof(p1) == "Instance" then
				table.insert(t2, p1)
			elseif typeof(p1) == "RBXScriptConnection" then
				table.insert(t, p1)
			end
			return p1
		end
		local function cleanup() --[[ cleanup | Line: 165 | Upvalues: v4 (ref), t (copy), t3 (copy), t2 (copy) ]]
			if not v4 then
				v4 = true
				for v1, v2 in t do
					v2:Disconnect()
				end
				for v3, v42 in t3 do
					task.cancel(v42)
				end
				for v5, v6 in t2 do
					if v6.Parent then
						v6:Destroy()
					end
				end
			end
		end
		GlitchSoundEffect:Play()
		local v52 = os.clock()
		local v62 = if math.random() < 0.5 then true else false
		local v7 = math.random() * 1000
		local HackGlitchVFX = Instance.new("ScreenGui")
		HackGlitchVFX.Name = "HackGlitchVFX"
		HackGlitchVFX.IgnoreGuiInset = true
		HackGlitchVFX.ResetOnSpawn = false
		HackGlitchVFX.DisplayOrder = 50000
		HackGlitchVFX.Parent = v32
		local v8 = HackGlitchVFX
		if typeof(v8) == "Instance" then
			table.insert(t2, v8)
		elseif typeof(v8) == "RBXScriptConnection" then
			table.insert(t, v8)
		end
		local v9 = makeFullFrame("Backing", Color3.new(0/255, 0/255, 0/255), 1, 100, v8)
		local v10 = makeNoiseTile(v8)
		local Scanlines = Instance.new("Frame")
		Scanlines.Name = "Scanlines"
		Scanlines.Size = UDim2.fromScale(1, 1)
		Scanlines.BackgroundTransparency = 1
		Scanlines.ZIndex = 300
		Scanlines.Parent = v8
		local Tears = Instance.new("Frame")
		Tears.Name = "Tears"
		Tears.Size = UDim2.fromScale(1, 1)
		Tears.BackgroundTransparency = 1
		Tears.ClipsDescendants = true
		Tears.ZIndex = 400
		Tears.Parent = v8
		local v11 = makeFullFrame("RGB_Red", Color3.fromRGB(255, 0, 0), 1, 500, v8)
		local v122 = makeFullFrame("RGB_Cyan", Color3.fromRGB(0, 255, 255), 1, 500, v8)
		local v13 = makeFullFrame("Strobe", Color3.new(255/255, 255/255, 255/255), 1, 600, v8)
		local v14 = makeGlitchLabel(v8, 0, 0)
		local v15 = makeGlitchLabel(v8, 1, 1)
		local v16 = makeVignette(v8)
		local HackGlitchCC = Instance.new("ColorCorrectionEffect")
		HackGlitchCC.Name = "HackGlitchCC"
		HackGlitchCC.Brightness = 0
		HackGlitchCC.Contrast = 0
		HackGlitchCC.Saturation = 0
		HackGlitchCC.TintColor = v3
		HackGlitchCC.Parent = Lighting
		local v17 = HackGlitchCC
		if typeof(v17) == "Instance" then
			table.insert(t2, v17)
		elseif typeof(v17) == "RBXScriptConnection" then
			table.insert(t, v17)
		end
		local v18 = v17
		local CurrentCamera = workspace.CurrentCamera
		local v19 = 0
		local v20 = RunService.RenderStepped:Connect(function() --[[ Line: 212 | Upvalues: v19 (ref), v7 (copy), CurrentCamera (copy) ]]
			if not (v19 <= 0) then
				local v1 = os.clock() * 35
				local v2 = math.noise(v1, v7) * v19
				local v3 = math.noise(v1, v7 + 13) * v19
				local v4 = math.noise(v1, v7 + 27) * v19 * 0.06
				CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(v2, v3, 0) * CFrame.Angles(0, 0, v4)
			end
		end)
		if typeof(v20) == "Instance" then
			table.insert(t2, v20)
		elseif typeof(v20) == "RBXScriptConnection" then
			table.insert(t, v20)
		end
		local v21 = RunService.RenderStepped:Connect(function() --[[ Line: 221 | Upvalues: v10 (copy) ]]
			if not (v10.ImageTransparency >= 0.99) then
				v10.ImageRectOffset = Vector2.new(math.random(0, 256), math.random(0, 256))
			end
		end)
		if typeof(v21) == "Instance" then
			table.insert(t2, v21)
		elseif typeof(v21) == "RBXScriptConnection" then
			table.insert(t, v21)
		end
		local function f23() --[[ Line: 226 | Upvalues: v4 (ref), v14 (copy), v15 (copy) ]]
			while not v4 do
				local v2 = math.random(18, 32)
				local v3 = table.create(v2)
				for i = 1, v2 do
					local v42 = math.random(1, 36)
					v3[i] = string.sub("0123456789ABCDEF!@#$%&*<>/\\|_-=+[]{}", v42, v42)
				end
				v14.Text = table.concat(v3)
				local v6 = math.random(18, 32)
				local v7 = table.create(v6)
				for j = 1, v6 do
					local v8 = math.random(1, 36)
					v7[j] = string.sub("0123456789ABCDEF!@#$%&*<>/\\|_-=+[]{}", v8, v8)
				end
				v15.Text = table.concat(v7)
				task.wait(0.05)
			end
		end
		table.insert(t3, task.spawn(f23))
		local function f25() --[[ Line: 235 | Upvalues: v12 (copy), makeFullFrame (ref), v6 (ref), Scanlines (copy), Debris (ref), v13 (copy), TweenService (ref), v18 (copy) ]]
			task.wait(v12 * 0.1)
			local v1 = makeFullFrame("Whisper", v6, 0.55, 301, Scanlines)
			v1.Size = UDim2.new(1, 0, 0, 2)
			v1.Position = UDim2.fromScale(0, 0.2 + math.random() * 0.6000000000000001)
			Debris:AddItem(v1, 0.08)
			task.wait(v12 * 0.08)
			v13.BackgroundTransparency = 0.85
			TweenService:Create(v13, TweenInfo.new(0.06), {
				BackgroundTransparency = 1
			}):Play()
			TweenService:Create(v18, TweenInfo.new(0.04), {
				Saturation = -0.3
			}):Play()
			task.wait(0.04)
			TweenService:Create(v18, TweenInfo.new(0.3), {
				Saturation = 0
			}):Play()
		end
		table.insert(t3, task.spawn(f25))
		local function f27() --[[ Line: 252 | Upvalues: v12 (copy), TweenService (ref), v10 (copy), v11 (copy), v122 (copy), v19 (ref), v14 (copy), v15 (copy), v52 (copy), v4 (ref), makeFullFrame (ref), v6 (ref), Scanlines (copy), Debris (ref) ]]
			task.wait(v12 * 0.3)
			TweenService:Create(v10, TweenInfo.new(v12 * 0.25), {
				ImageTransparency = 0.7
			}):Play()
			local v1 = v12 * 0.39999999999999997
			TweenService:Create(v11, TweenInfo.new(v1), {
				BackgroundTransparency = 0.92,
				Position = UDim2.new(0, 8, 0, 0)
			}):Play()
			TweenService:Create(v122, TweenInfo.new(v1), {
				BackgroundTransparency = 0.92,
				Position = UDim2.new(0, -8, 0, 0)
			}):Play()
			v19 = 0.012
			TweenService:Create(v14, TweenInfo.new(0.4), {
				TextTransparency = 0.5
			}):Play()
			TweenService:Create(v15, TweenInfo.new(0.4), {
				TextTransparency = 0.5
			}):Play()
			while os.clock() < v52 + v12 * 0.7 and not v4 do
				for i = 1, math.random(1, 3) do
					local v3 = makeFullFrame("Scan", v6, 0.5 + math.random() * 0.30000000000000004, 301, Scanlines)
					v3.Size = UDim2.new(1, 0, 0, math.random(1, 3))
					v3.Position = UDim2.fromScale(0, -0.05 + math.random() * 1.05)
					local v42 = 0.18 + math.random() * 0.27
					TweenService:Create(v3, TweenInfo.new(v42), {
						Position = UDim2.fromScale(0, -0.05 + math.random() * 1.05)
					}):Play()
					Debris:AddItem(v3, v42 + 0.05)
				end
				task.wait(0.18 + math.random() * 0.14)
			end
		end
		table.insert(t3, task.spawn(f27))
		local function f29() --[[ Line: 287 | Upvalues: v12 (copy), TweenService (ref), v10 (copy), v11 (copy), v122 (copy), v19 (ref), v14 (copy), v15 (copy), v16 (copy), v52 (copy), t3 (copy), v4 (ref), v62 (ref), v1 (ref), v2 (ref), v18 (copy), v5 (ref), Tears (copy), makeFullFrame (ref), Debris (ref) ]]
			task.wait(v12 * 0.7)
			TweenService:Create(v10, TweenInfo.new(0.2), {
				ImageTransparency = 0.45
			}):Play()
			TweenService:Create(v11, TweenInfo.new(0.25), {
				BackgroundTransparency = 0.85,
				Position = UDim2.new(0, 16, 0, 0)
			}):Play()
			TweenService:Create(v122, TweenInfo.new(0.25), {
				BackgroundTransparency = 0.85,
				Position = UDim2.new(0, -16, 0, 0)
			}):Play()
			v19 = 0.045
			TweenService:Create(v14, TweenInfo.new(0.2), {
				TextTransparency = 0
			}):Play()
			TweenService:Create(v15, TweenInfo.new(0.2), {
				TextTransparency = 0
			}):Play()
			TweenService:Create(v16, TweenInfo.new(0.3), {
				BackgroundTransparency = 0
			}):Play()
			local v13 = v52 + v12 * 0.96
			local function f4() --[[ Line: 306 | Upvalues: v13 (copy), v4 (ref), v62 (ref), v1 (ref), v2 (ref), TweenService (ref), v18 (ref) ]]
				while os.clock() < v13 and not v4 do
					TweenService:Create(v18, TweenInfo.new(0.15), {
						Contrast = 0.3,
						TintColor = v62 and v1 or v2
					}):Play()
					task.wait(0.15)
					v62 = not v62
				end
			end
			table.insert(t3, task.spawn(f4))
			while os.clock() < v13 and not v4 do
				for i = 1, math.random(4, 8) do
					local v53 = math.random(20, 80)
					local v6 = math.random(0, 1080) / 1080
					local Tear = Instance.new("Frame")
					Tear.Name = "Tear"
					Tear.Size = UDim2.new(1, 0, 0, v53)
					Tear.Position = UDim2.fromScale(0, v6)
					Tear.BackgroundColor3 = v5
					Tear.BackgroundTransparency = 0.1 + math.random() * 0.30000000000000004
					Tear.BorderSizePixel = 0
					Tear.ZIndex = 401
					Tear.ClipsDescendants = true
					Tear.Parent = Tears
					makeFullFrame("Shift", Color3.new(0/255, 0/255, 0/255), 0.6, 402, Tear).Position = UDim2.new(0, math.random(-60, 60), 0, 0)
					Debris:AddItem(Tear, 0.06 + math.random() * 0.1)
				end
				if math.random() < 0.35 then
					v18.Brightness = -0.4
					task.delay(0.05, function() --[[ Line: 338 | Upvalues: v18 (ref) ]]
						if v18.Parent then
							v18.Brightness = 0
						end
					end)
				end
				task.wait(0.08 + math.random() * 0.06000000000000001)
			end
		end
		table.insert(t3, task.spawn(f29))
		local function f31() --[[ Line: 348 | Upvalues: v12 (copy), v19 (ref), v13 (copy), TweenService (ref), v10 (copy), v11 (copy), v122 (copy), v14 (copy), v15 (copy), v16 (copy), v9 (copy), v18 (copy), v22 (copy), v3 (ref) ]]
			task.wait(v12 * 0.96)
			v19 = 0
			v13.BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
			v13.BackgroundTransparency = 0
			TweenService:Create(v13, TweenInfo.new(0.06), {
				BackgroundTransparency = 1
			}):Play()
			task.wait(0.04)
			v10.ImageTransparency = 1
			v11.BackgroundTransparency = 1
			v122.BackgroundTransparency = 1
			v14.TextTransparency = 1
			v15.TextTransparency = 1
			v16.BackgroundTransparency = 1
			v9.BackgroundTransparency = 0
			task.wait(v12 * 0.025)
			TweenService:Create(v18, TweenInfo.new(v22), {
				Saturation = 0,
				Contrast = 0,
				Brightness = 0,
				TintColor = v3
			}):Play()
			TweenService:Create(v9, TweenInfo.new(v22), {
				BackgroundTransparency = 1
			}):Play()
		end
		table.insert(t3, task.spawn(f31))
		task.delay(math.max(0, v12 + v22 + 0.1 - 0.5), function() --[[ Line: 377 | Upvalues: GlitchSoundEffect (ref) ]]
			GlitchSoundEffect:Stop()
		end)
		task.delay(v12 + v22 + 0.1, cleanup)
	end
end