-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ValidInputTypes = require(script:WaitForChild("ValidInputTypes"))
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local t = {}
t.__index = t
local function checkPoint(p1, p2) --[[ checkPoint | Line: 21 ]]
	local AbsolutePosition = p2.AbsolutePosition
	local v1 = p2.AbsoluteSize * 1.1
	return if p1.X >= AbsolutePosition.X and (p1.X <= AbsolutePosition.X + v1.X and p1.Y >= AbsolutePosition.Y) then p1.Y <= AbsolutePosition.Y + v1.Y else false
end
function t.new(p1, p2, p3, p4, p5, p6) --[[ new | Line: 33 | Upvalues: t (copy), Trove (copy), Signal (copy) ]]
	local v2 = setmetatable({}, t)
	v2.Cleaner = if p4 then p4 else Trove.new()
	v2.Clicked = Signal.new()
	if p5 then
		v2.MouseDown = Signal.new()
		v2.MouseUp = Signal.new()
	end
	v2.Button = p1
	v2.Scaler = p3 or 1
	v2._clickedState = false
	local v4 = p1:FindFirstChildWhichIsA("UIScale")
	if v4 then
		v2.OriginalScale = if p6 then p6 else v4.Scale
		v2.UIScale = v4
	else
		v2.OriginalScale = p6 or 1
		v2.UIScale = Instance.new("UIScale")
		v2.UIScale.Scale = v2.OriginalScale
		v2.UIScale.Parent = if p2 then p2 else v2.Button
	end
	v2:Init()
	return v2
end
function t.Init(p1) --[[ Init | Line: 65 | Upvalues: ValidInputTypes (copy), PlayerGui (copy) ]]
	p1.Cleaner:Add(p1.Button.InputBegan:Connect(function(p12) --[[ Line: 66 | Upvalues: ValidInputTypes (ref), p1 (copy), PlayerGui (ref) ]]
		if p12.UserInputState ~= Enum.UserInputState.Begin then
			return
		end
		if table.find(ValidInputTypes, p12.UserInputType) then
			local _ = p12.UserInputState.Name
			p1:_userInputStateStarted()
			local v1 = nil
			v1 = p12:GetPropertyChangedSignal("UserInputState"):Connect(function() --[[ Line: 79 | Upvalues: p1 (ref), p12 (copy), PlayerGui (ref), v1 (ref) ]]
				local v12 = p1.Button:GetAttribute("Ignore2D")
				local isChange = p12.UserInputState == Enum.UserInputState.Change
				if p1.Button:IsDescendantOf(PlayerGui) and not v12 then
					local v2 = Vector2.new(p12.Position.X, p12.Position.Y)
					local Button = p1.Button
					local AbsolutePosition = Button.AbsolutePosition
					local v3 = Button.AbsoluteSize * 1.1
					if (if v2.X >= AbsolutePosition.X and (v2.X <= AbsolutePosition.X + v3.X and v2.Y >= AbsolutePosition.Y) then v2.Y <= AbsolutePosition.Y + v3.Y else false) == false then
						isChange = true
					end
				end
				if isChange then
					v1:Disconnect()
					p1:_userInputStateCanceled()
				else
					v1:Disconnect()
					p1:_userInputStateEnded()
				end
			end)
		end
	end))
	p1.Cleaner:Add(p1.Button.Destroying:Once(function() --[[ Line: 120 | Upvalues: p1 (copy) ]]
		p1:Destroy()
	end))
end
function t.Destroy(p1) --[[ Destroy | Line: 125 ]]
	if p1.MouseDown then
		p1.MouseDown:DisconnectAll()
		p1.MouseDown:Destroy()
	end
	if p1.MouseUp then
		p1.MouseUp:DisconnectAll()
		p1.MouseUp:Destroy()
	end
	p1.Clicked:DisconnectAll()
	p1.Clicked:Destroy()
	p1.Cleaner:Destroy()
	p1.UIScale:Destroy()
end
function t.Click(p1) --[[ Click | Line: 143 ]]
	p1.Clicked:Fire(p1.Button)
end
function t.SetClickedState(p1, p2) --[[ SetClickedState | Line: 147 ]]
	p1._clickedState = p2
end
function t.GetClickedState(p1) --[[ GetClickedState | Line: 151 | Upvalues: UserInputService (copy) ]]
	if UserInputService.TouchEnabled then
		return true
	else
		return p1._clickedState
	end
end
function t.ClickEffect(p1, p2) --[[ ClickEffect | Line: 159 | Upvalues: TweenService (copy) ]]
	local t = {}
	if p2 then
		t.Scale = p1.OriginalScale - 0.1 * p1.Scaler
	else
		t.Scale = p1.OriginalScale
	end
	TweenService:Create(p1.UIScale, TweenInfo.new(0.17, Enum.EasingStyle.Quart), t):Play()
end
function t._userInputStateEnded(p1) --[[ _userInputStateEnded | Line: 171 | Upvalues: Soundbook (copy) ]]
	if p1.MouseUp then
		p1.MouseUp:Fire()
	end
	local v1 = p1:GetClickedState() and true or false
	p1:SetClickedState(false)
	p1:ClickEffect(false)
	if not v1 then
		return
	end
	Soundbook.Sounds.ThickClick:Play()
	p1:Click()
end
function t._userInputStateCanceled(p1) --[[ _userInputStateCanceled | Line: 190 ]]
	if p1.MouseUp then
		p1.MouseUp:Fire()
	end
	p1:SetClickedState(false)
	p1:ClickEffect(false)
end
function t._userInputStateStarted(p1) --[[ _userInputStateStarted | Line: 199 ]]
	if p1.MouseDown then
		p1.MouseDown:Fire()
	end
	p1:SetClickedState(true)
	p1:ClickEffect(true)
end
return t