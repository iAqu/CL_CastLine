-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local isMobile = ClientProfile.Device == ClientProfile.DeviceTypes.Mobile
local HapticEffect = script:WaitForChild("HapticEffect")
local Prompt = script:WaitForChild("Prompt")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local v1 = PlayerGui:FindFirstChild("SurfaceGUIs") or PlayerGui:WaitForChild("SurfaceGUIs")
local t = {
	Tag = ({
		Tag = Tags.CustomPrompt
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 33 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		ProximityPrompt = p1,
		Adornee = p1.Parent,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t.TweenPrompt(p1) --[[ TweenPrompt | Line: 46 | Upvalues: TweenService (copy) ]]
	local Billboard = p1.Billboard
	if Billboard then
		Billboard.Frame.GroupTransparency = 0
		TweenService:Create(Billboard.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
			GroupTransparency = 1
		}):Play()
	end
end
function t.OnShown(p1) --[[ OnShown | Line: 55 | Upvalues: TweenService (copy) ]]
	if p1.Billboard then
		p1.Billboard.Frame.GroupTransparency = 1
		p1.Billboard.Frame.Rotation = -30
		TweenService:Create(p1.Billboard.Frame, TweenInfo.new(0.25), {
			GroupTransparency = 0
		}):Play()
		TweenService:Create(p1.Billboard.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Rotation = 0
		}):Play()
	end
end
function t.OnHidden(p1) --[[ OnHidden | Line: 64 | Upvalues: TweenService (copy) ]]
	if p1.Billboard then
		p1.Billboard.Frame.GroupTransparency = 0
		TweenService:Create(p1.Billboard.Frame, TweenInfo.new(0.25), {
			GroupTransparency = 1
		}):Play()
	end
end
function t.ClonePrompt(p1, p2) --[[ ClonePrompt | Line: 71 | Upvalues: Prompt (copy), v1 (copy) ]]
	local v12 = Prompt:Clone()
	local Frame = v12:WaitForChild("Frame")
	local InputFrame = Frame:WaitForChild("InputFrame")
	local TextFrame = Frame:WaitForChild("TextFrame")
	local ActionText = TextFrame:WaitForChild("ActionText")
	local ObjectText = TextFrame:WaitForChild("ObjectText")
	local ButtonText = InputFrame:WaitForChild("Frame"):WaitForChild("ButtonText")
	local ButtonIcon = InputFrame.Frame.ButtonIcon
	ActionText.Text = p1.ProximityPrompt.ActionText
	ObjectText.Text = p1.ProximityPrompt.ObjectText
	if #ObjectText.Text == 0 then
		ActionText.Position = UDim2.fromOffset(0, 0)
	else
		ActionText.Position = UDim2.fromOffset(0, 10)
	end
	if p2 then
		ButtonText.Visible = false
		ButtonText.Parent.ButtonImage.Visible = false
		ButtonIcon.Image = p2
		ButtonIcon.Visible = true
	else
		ButtonText.Visible = true
		ButtonIcon.Visible = false
		ButtonText.Parent.ButtonImage.Visible = true
		ButtonText.Text = p1.ProximityPrompt.KeyboardKeyCode.Name
	end
	local UIOffset = p1.ProximityPrompt.UIOffset
	if UIOffset ~= Vector2.zero then
		v12.SizeOffset = Vector2.new(UIOffset.X, UIOffset.Y)
	end
	local function OnTextUpdate() --[[ OnTextUpdate | Line: 110 | Upvalues: ObjectText (copy), p1 (copy), ActionText (copy) ]]
		ObjectText.Text = p1.ProximityPrompt.ObjectText
		ActionText.Text = p1.ProximityPrompt.ActionText
		if #ObjectText.Text == 0 then
			ActionText.Position = UDim2.fromOffset(0, 0)
		else
			ActionText.Position = UDim2.fromOffset(0, 10)
		end
	end
	local EnabledTrove = p1.EnabledTrove
	if EnabledTrove then
		EnabledTrove:Add(p1.ProximityPrompt:GetPropertyChangedSignal("ActionText"):Connect(OnTextUpdate))
		EnabledTrove:Add(p1.ProximityPrompt:GetPropertyChangedSignal("ObjectText"):Connect(OnTextUpdate))
	end
	v12.Parent = v1
	v12.Adornee = p1.Adornee
	return v12
end
function t._init(p1) --[[ _init | Line: 132 | Upvalues: Trove (copy), UserInputService (copy), TweenService (copy), HapticEffect (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		local v1 = Trove.new()
		p1.Trove = v1
		local v2 = v1:Extend()
		p1.EnabledTrove = v2
		local ProximityPrompt = p1.ProximityPrompt
		if ProximityPrompt.Style == Enum.ProximityPromptStyle.Custom then
			local v3 = nil
			if UserInputService.TouchEnabled then
				v3 = "rbxasset://textures/ui/Controls/TouchTapIcon@3x.png"
			elseif UserInputService.GamepadEnabled then
				v3 = UserInputService:GetImageForKeyCode(p1.ProximityPrompt.GamepadKeyCode)
			end
			v1:Add(ProximityPrompt.PromptShown:Connect(function() --[[ Line: 153 | Upvalues: p1 (copy), v3 (ref), v2 (copy), ProximityPrompt (copy), TweenService (ref), v1 (copy) ]]
				local v12 = p1:ClonePrompt(v3)
				p1.Billboard = v12
				p1:OnShown()
				local TextButton = v12.TextButton
				v2:Add(TextButton.InputBegan:Connect(function(p12) --[[ Line: 160 | Upvalues: p1 (ref), ProximityPrompt (ref) ]]
					if not (p12.UserInputType == Enum.UserInputType.MouseButton1 or if p12.UserInputType == Enum.UserInputType.Gamepad1 then p12.KeyCode == p1.ProximityPrompt.GamepadKeyCode else false) then
						return
					end
					ProximityPrompt:InputHoldBegin()
				end))
				v2:Add(TextButton.InputEnded:Connect(function(p12) --[[ Line: 171 | Upvalues: p1 (ref), ProximityPrompt (ref) ]]
					if not (if p12.UserInputType == Enum.UserInputType.MouseButton1 then true elseif p12.UserInputType == Enum.UserInputType.Touch then true else false or if p12.UserInputType == Enum.UserInputType.Gamepad1 then p12.KeyCode == p1.ProximityPrompt.GamepadKeyCode else false) then
						return
					end
					ProximityPrompt:InputHoldEnd()
				end))
				if ProximityPrompt.HoldDuration > 0 then
					local CircularProgressBar = v12.Frame.InputFrame.RoundFrame.CircularProgressBar
					local FR = CircularProgressBar.FR
					local UIGradient = FR.ImageLabel.UIGradient
					local FL = CircularProgressBar.FL
					local UIGradient_2 = FL.ImageLabel.UIGradient
					local Progress = CircularProgressBar.Progress
					local UIScale = v12.Frame.InputFrame.UIScale
					local TextFrame = v12.Frame.TextFrame
					local function UpdateCircle(p1) --[[ UpdateCircle | Line: 196 | Upvalues: UIGradient_2 (copy), UIGradient (copy) ]]
						local v1 = math.clamp(p1, 0, 180)
						local v2 = math.clamp(p1, 180, 360)
						UIGradient_2.Rotation = v1
						UIGradient.Rotation = v2
					end
					local v22 = false
					local function UpdateSizeTween(p1) --[[ UpdateSizeTween | Line: 206 | Upvalues: v22 (ref), TweenService (ref), UIScale (copy), TextFrame (copy) ]]
						local v1 = p1 > 0
						if v22 ~= v1 then
							v22 = v1
							if v1 then
								TweenService:Create(UIScale, TweenInfo.new(0.5), {
									Scale = 1.2
								}):Play()
								TweenService:Create(TextFrame, TweenInfo.new(0.5), {
									GroupTransparency = 1
								}):Play()
								for i, v in ipairs(TextFrame:GetChildren()) do
									if v:IsA("TextLabel") then
										TweenService:Create(v, TweenInfo.new(0.5), {
											Position = UDim2.new(-1, 0, 0, v.Position.Y.Offset)
										}):Play()
									end
								end
							else
								TweenService:Create(UIScale, TweenInfo.new(0.1), {
									Scale = 1
								}):Play()
								TweenService:Create(TextFrame, TweenInfo.new(0.1), {
									GroupTransparency = 0
								}):Play()
								for i, v in ipairs(TextFrame:GetChildren()) do
									if v:IsA("TextLabel") then
										TweenService:Create(v, TweenInfo.new(0.1), {
											Position = UDim2.new(0, 0, 0, v.Position.Y.Offset)
										}):Play()
									end
								end
							end
						end
					end
					v1:Add(Progress:GetPropertyChangedSignal("Value"):Connect(function() --[[ Line: 232 | Upvalues: Progress (copy), FR (copy), FL (copy), UIGradient_2 (copy), UIGradient (copy), UpdateSizeTween (copy) ]]
						local v1 = Progress.Value
						if v1 == 0 then
							FR.Visible = false
							FL.Visible = false
						else
							FR.Visible = true
							FL.Visible = true
						end
						local v2 = math.clamp(v1, 0, 180)
						local v3 = math.clamp(v1, 180, 360)
						UIGradient_2.Rotation = v2
						UIGradient.Rotation = v3
						UpdateSizeTween(v1)
					end))
					v1:Add(ProximityPrompt.PromptButtonHoldBegan:Connect(function() --[[ Line: 246 | Upvalues: TweenService (ref), Progress (copy), p1 (ref) ]]
						TweenService:Create(Progress, TweenInfo.new(p1.ProximityPrompt.HoldDuration), {
							Value = 360
						}):Play()
					end))
					v1:Add(ProximityPrompt.PromptButtonHoldEnded:Connect(function() --[[ Line: 250 | Upvalues: TweenService (ref), Progress (copy) ]]
						TweenService:Create(Progress, TweenInfo.new(0.15), {
							Value = 0
						}):Play()
					end))
					v2:Add(TextButton.InputBegan:Connect(function(p1) --[[ Line: 254 | Upvalues: ProximityPrompt (ref) ]]
						if if p1.UserInputType == Enum.UserInputType.Touch then p1.UserInputState == Enum.UserInputState.Begin else false then
							ProximityPrompt:InputHoldBegin()
						end
					end))
					v2:Add(TextButton.InputEnded:Connect(function(p1) --[[ Line: 261 | Upvalues: ProximityPrompt (ref) ]]
						if p1.UserInputType == Enum.UserInputType.Touch then
							ProximityPrompt:InputHoldEnd()
						end
					end))
				else
					v2:Add(TextButton.InputBegan:Connect(function(p1) --[[ Line: 268 | Upvalues: ProximityPrompt (ref) ]]
						if p1.UserInputType == Enum.UserInputType.Touch and p1.UserInputState == Enum.UserInputState.Begin then
							ProximityPrompt:InputHoldBegin()
						end
					end))
				end
				v2:Add(function() --[[ Line: 275 | Upvalues: p1 (ref) ]]
					p1:OnHidden()
					if p1.Billboard then
						game.Debris:AddItem(p1.Billboard, 0.33)
					end
				end)
			end))
			v1:Add(ProximityPrompt.PromptHidden:Connect(function() --[[ Line: 284 | Upvalues: v2 (copy) ]]
				v2:Clean()
			end))
		end
		v1:Add(p1.ProximityPrompt.Triggered:Connect(function() --[[ Line: 289 | Upvalues: p1 (copy), HapticEffect (ref) ]]
			p1:TweenPrompt()
			HapticEffect:Play()
		end))
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 295 ]]
	p1.Trove:Destroy()
end
return t