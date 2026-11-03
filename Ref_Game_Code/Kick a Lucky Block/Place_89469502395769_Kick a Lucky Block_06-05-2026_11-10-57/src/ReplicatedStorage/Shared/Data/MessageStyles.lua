-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
function TypingEffect(p1) --[[ TypingEffect | Line: 11 | Upvalues: TweenService (copy) ]]
	local MessageLabel = p1.MessageLabel
	local Background = p1:FindFirstChild("Background")
	MessageLabel.MaxVisibleGraphemes = 0
	if Background then
		Background.BackgroundTransparency = 1
	end
	p1.Visible = true
	local v1 = TweenService:Create(MessageLabel, TweenInfo.new(2), {
		MaxVisibleGraphemes = #MessageLabel.Text
	})
	if Background then
		TweenService:Create(Background, TweenInfo.new(1), {
			BackgroundTransparency = 0
		}):Play()
	end
	v1:Play()
	v1.Completed:Wait()
end
function Pop(p1) --[[ Pop | Line: 29 | Upvalues: TweenService (copy) ]]
	local v1 = UDim2.fromScale(0.8, 0.07)
	p1.Size = UDim2.fromScale(0, 0)
	p1.Visible = true
	local v2 = TweenService:Create(p1, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = v1
	})
	v2:Play()
	v2.Completed:Wait()
end
function PopOut(p1) --[[ PopOut | Line: 41 | Upvalues: TweenService (copy) ]]
	local v1 = TweenService:Create(p1, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.fromScale(0, 0)
	})
	v1:Play()
	v1.Completed:Wait()
end
function RotateAppear(p1) --[[ RotateAppear | Line: 47 | Upvalues: TweenService (copy) ]]
	local Size = p1.Size
	p1.Size = UDim2.fromScale(0, 0)
	p1.Visible = true
	local v1 = TweenService:Create(p1, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Rotation = 0,
		Size = Size
	})
	v1:Play()
	v1.Completed:Wait()
end
function FadeAway(p1) --[[ FadeAway | Line: 58 | Upvalues: TweenService (copy) ]]
	local v1 = TweenService:Create(p1, TweenInfo.new(0.1), {
		GroupTransparency = 1
	})
	v1:Play()
	v1.Completed:Wait()
end
function FadeIn(p1) --[[ FadeIn | Line: 64 | Upvalues: TweenService (copy) ]]
	p1.GroupTransparency = 1
	p1.Visible = true
	local v1 = TweenService:Create(p1, TweenInfo.new(0.1), {
		GroupTransparency = 0
	})
	v1:Play()
	v1.Completed:Wait()
end
return {
	Default = {
		Name = "Default",
		Time = 5,
		Stackable = true,
		Show = FadeIn,
		Setup = function(p1) --[[ Setup | Line: 79 ]]
			local MessageLabel = p1.MessageLabel
			if p1:FindFirstChild("Background") then
				p1.Background.Visible = false
			end
			MessageLabel.FontFace = Font.new(MessageLabel.FontFace.Family, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			MessageLabel.UIStroke.Color = Color3.fromRGB(0)
		end,
		Sound = SoundService.Effects.Notification,
		Destroy = FadeAway
	},
	Steal = {
		Name = "Steal",
		Time = 4,
		Stackable = false,
		Sound = SoundService.Effects.EvilLaugh,
		Show = Pop,
		Destroy = PopOut
	},
	Typing = {
		Name = "Typing",
		Time = 4,
		Show = TypingEffect,
		Destroy = FadeAway
	},
	Error = {
		Name = "Error",
		Time = 5,
		Stackable = true,
		Setup = function(p1) --[[ Setup | Line: 114 ]]
			local MessageLabel = p1.MessageLabel
			if p1:FindFirstChild("Background") then
				p1.Background.Visible = false
			end
			MessageLabel.FontFace = Font.new(MessageLabel.FontFace.Family, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			MessageLabel.TextColor3 = Color3.fromRGB(255, 33, 37)
			MessageLabel.UIStroke.Color = Color3.fromRGB(95, 12, 15)
		end,
		Show = Pop,
		Sound = SoundService.Effects.ErrorSound,
		Destroy = PopOut
	},
	Dev = {
		Name = "Dev",
		Time = 7,
		Stackable = false,
		Setup = function(p1) --[[ Setup | Line: 134 ]]
			local MessageLabel = p1.MessageLabel
			p1.Size = UDim2.fromScale(0.8, 0.05)
			MessageLabel.FontFace = Font.new(MessageLabel.FontFace.Family, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			MessageLabel.UIStroke.Color = Color3.fromRGB(0)
		end,
		TransformFunction = function(p1, p2) --[[ TransformFunction | Line: 143 ]]
			p1.MessageLabel.Text = ("<font color = \"#D5D5D5\">%*%*</font> %*"):format(p2, utf8.char(57344), p1.MessageLabel.Text)
		end,
		Show = FadeIn,
		Destroy = FadeAway,
		Sound = SoundService.Effects.Notification
	},
	Reward = {
		Name = "Reward",
		Time = 7,
		Setup = function(p1) --[[ Setup | Line: 154 ]]
			local MessageLabel = p1.MessageLabel
			MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			MessageLabel.UIStroke.Color = Color3.fromRGB(0, 0, 0)
			game:GetService("ReplicatedStorage").Objects.UI.RarityGradients.og:Clone().Parent = MessageLabel
		end,
		Sound = SoundService.Effects.Notification,
		Show = RotateAppear,
		Destroy = FadeAway
	},
	Info = {
		Name = "Info",
		Type = "Info",
		Time = 10,
		TransformFunction = function(p1, p2) --[[ TransformFunction | Line: 170 ]]
			p1.Info.Text = p2
		end,
		Sound = SoundService.Effects.Notification,
		Show = FadeIn,
		Destroy = FadeAway
	},
	Alert = {
		Name = "Alert",
		Time = 5,
		TransformFunction = function(p1) --[[ TransformFunction | Line: 181 | Upvalues: RunService (copy) ]]
			local v1 = nil
			v1 = RunService.PreRender:Connect(function() --[[ Line: 184 | Upvalues: p1 (copy), v1 (ref) ]]
				if p1 then
					local v2 = math.floor(tick() * 4 % 2) == 0
					p1.MessageLabel.TextColor3 = v2 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 0, 0)
				else
					v1:Disconnect()
				end
			end)
			p1.Destroying:Once(function() --[[ Line: 195 | Upvalues: v1 (ref) ]]
				if v1 and v1.Connected then
					v1:Disconnect()
				end
			end)
		end,
		Show = Pop,
		Destroy = FadeAway,
		Sound = SoundService.Effects.ErrorSound
	},
	Hacker = {
		Name = "Hacker",
		Type = "Hacker",
		Time = 7,
		TransformFunction = function(p1) --[[ TransformFunction | Line: 210 ]]
			game:GetService("ReplicatedStorage").Objects.UI.hackerGrad:Clone().Parent = p1.MessageLabel
		end,
		Show = TypingEffect,
		Destroy = FadeAway,
		Sound = SoundService.Effects.ErrorSound
	},
	Guest666 = {
		Name = "Guest666",
		Type = "Guest666",
		Time = 7,
		TransformFunction = function(p1) --[[ TransformFunction | Line: 221 ]]
			game:GetService("ReplicatedStorage").Objects.UI.guestGrad:Clone().Parent = p1.MessageLabel
		end,
		Show = TypingEffect,
		Destroy = FadeAway,
		Sound = SoundService.Effects.ErrorSound
	},
	System = {
		Name = "System",
		Type = "System",
		Time = 5,
		Sound = SoundService.Effects.ErrorSound
	}
}