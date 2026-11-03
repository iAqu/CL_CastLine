-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local v1 = Random.new()
local t = {
	Tag = ({
		Tag = Tags.Button
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 27 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Object = p1,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t.InitAnimations(p1) --[[ InitAnimations | Line: 38 | Upvalues: ClientProfile (copy), SoundService (copy), TweenService (copy), v1 (copy) ]]
	local Object = p1.Object
	local v12 = Object:HasTag("Rotate") and Object:FindFirstChildOfClass("ImageLabel")
	if v12 then
		(v12:FindFirstChild("UIScale") or Instance.new("UIScale")).Parent = v12
	end
	local v3 = 1
	local v4 = Object:FindFirstChild("UIScale") or Instance.new("UIScale")
	v4.Parent = Object
	local Scale = v4.Scale
	local v5 = Scale * 0.9
	local v6 = Scale * 1.05
	local function Pressed() --[[ Pressed | Line: 56 | Upvalues: SoundService (ref), TweenService (ref), v4 (copy), v5 (copy) ]]
		SoundService.Effects.UI["UI Click"]:Play()
		TweenService:Create(v4, TweenInfo.new(0.02), {
			Scale = v5
		}):Play()
	end
	local function Released() --[[ Released | Line: 61 | Upvalues: v12 (copy), TweenService (ref), v4 (copy), Scale (copy) ]]
		if v12 then
			TweenService:Create(v12, TweenInfo.new(0.1), {
				Rotation = 0
			}):Play()
			TweenService:Create(v12.UIScale, TweenInfo.new(0.1), {
				Scale = 1
			}):Play()
		end
		TweenService:Create(v4, TweenInfo.new(0.02), {
			Scale = Scale
		}):Play()
	end
	local function Hover() --[[ Hover | Line: 69 | Upvalues: v12 (copy), v3 (ref), TweenService (ref), v1 (ref), v4 (copy), v6 (copy) ]]
		if v12 then
			v3 = v3 * -1
			TweenService:Create(v12, TweenInfo.new(0.1), {
				Rotation = v3 * v1:NextInteger(10, 20)
			}):Play()
			TweenService:Create(v12.UIScale, TweenInfo.new(0.1), {
				Scale = 1.1
			}):Play()
		end
		TweenService:Create(v4, TweenInfo.new(0.02), {
			Scale = v6
		}):Play()
	end
	local function Tap() --[[ Tap | Line: 78 | Upvalues: v4 (copy), Scale (copy), TweenService (ref), v5 (copy) ]]
		local v1 = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true)
		v4.Scale = Scale
		TweenService:Create(v4, v1, {
			Scale = v5
		}):Play()
	end
	if ClientProfile.Device == ClientProfile.DeviceTypes.Mobile then
		Object.TouchLongPress:Connect(function(p1, p2) --[[ Line: 85 | Upvalues: Pressed (copy), Released (copy) ]]
			if p2 == Enum.UserInputState.Begin then
				Pressed()
			elseif p2 == Enum.UserInputState.End then
				Released()
			end
		end)
		Object.TouchTap:Connect(Tap)
		Object.InputEnded:Connect(function(p1) --[[ Line: 95 | Upvalues: Released (copy) ]]
			if p1.UserInputType == Enum.UserInputType.Touch then
				Released()
			end
		end)
	else
		local v7 = false
		Object.InputBegan:Connect(function(p1) --[[ Line: 102 | Upvalues: v7 (ref), SoundService (ref), Hover (copy), Pressed (copy) ]]
			local isMouseMovement = p1.UserInputType == Enum.UserInputType.MouseMovement
			local v1 = if p1.UserInputType == Enum.UserInputType.MouseButton1 then true else false
			if isMouseMovement then
				v7 = true
				SoundService.Effects.UI.Hover:Play()
				Hover()
			elseif v1 then
				Pressed()
			end
		end)
		Object.InputEnded:Connect(function(p1) --[[ Line: 114 | Upvalues: Released (copy), v7 (ref), Hover (copy) ]]
			local isMouseMovement = p1.UserInputType == Enum.UserInputType.MouseMovement
			local v1 = if p1.UserInputType == Enum.UserInputType.MouseButton1 then true else false
			if isMouseMovement then
				Released()
				v7 = false
			end
			if v1 then
				if v7 then
					Hover()
					return
				end
				Released()
			end
		end)
	end
end
function t._init(p1) --[[ _init | Line: 135 ]]
	if not p1.Initialized then
		p1.Initialized = true
		p1:InitAnimations()
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 143 ]] end
return t