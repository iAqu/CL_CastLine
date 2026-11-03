-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local function ToPolar(p1) --[[ ToPolar | Line: 35 ]]
	return math.atan2(p1.Y, p1.X), p1.Magnitude
end
local function RadToDeg(p1) --[[ RadToDeg | Line: 39 ]]
	return (p1 + math.pi) / 6.283185307179586 * 360
end
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 48 | Upvalues: t (copy), Trove (copy), Signal (copy) ]]
	local v2 = setmetatable({}, t)
	v2._Root = p1
	v2._Trove = Trove.new()
	v2._WheelTrove = Trove.new()
	v2._Hue = 0
	v2._Saturation = 0
	v2._Value = 1
	v2._Connections = {
		WheelUpdate = nil,
		ShadeUpdate = nil
	}
	local _ColorPicker = p1:WaitForChild("_ColorPicker")
	v2._PickerFrame = _ColorPicker
	v2._Wheel = _ColorPicker:WaitForChild("Wheel")
	v2._Shade = _ColorPicker:WaitForChild("Shade")
	v2._Indicator = _ColorPicker:WaitForChild("Indicator")
	v2.ColorChanged = v2._Trove:Add(Signal.new())
	v2._Callback = nil
	v2:SetColor(Color3.fromRGB(255, 255, 255))
	return v2
end
function t.GetMousePosition(p1) --[[ GetMousePosition | Line: 89 | Upvalues: UserInputService (copy) ]]
	return UserInputService:GetMouseLocation() - Vector2.new(0, 36)
end
function t.GetColor(p1) --[[ GetColor | Line: 94 ]]
	return Color3.fromHSV(p1._Hue, p1._Saturation, p1._Value)
end
function t.SetColor(p1, p2) --[[ SetColor | Line: 99 ]]
	if p2 then
		local v1, v2, v3 = p2:ToHSV()
		p1._Hue = v1
		p1._Saturation = v2
		p1._Value = v3
		local v4 = v1 * math.pi * 2
		local v5 = Vector2.new(-math.cos(v4) / 2 * v2, math.sin(v4) / 2 * v2)
		p1._Wheel.Image.Select.Position = UDim2.fromScale(0.5 + v5.X, 0.5 + v5.Y)
		p1._Shade.Select.Position = UDim2.fromScale(0, 1 - v3)
		p1:_UpdateVisuals()
	end
end
function t.Open(p1, p2) --[[ Open | Line: 119 ]]
	p1._Callback = p2
	p1:_ResetDragConnections()
	p1._PickerFrame.Visible = true
	p1:_ConnectInputs()
end
function t.Close(p1) --[[ Close | Line: 127 ]]
	p1:_ResetDragConnections()
	p1._PickerFrame.Visible = false
	p1._Callback = nil
end
function t._FireChanged(p1) --[[ _FireChanged | Line: 134 ]]
	local v1 = p1:GetColor()
	p1.ColorChanged:Fire(v1)
	if not p1._Callback then
		return
	end
	p1._Callback(v1)
end
function t._UpdateVisuals(p1) --[[ _UpdateVisuals | Line: 144 ]]
	local v1 = p1:GetColor()
	p1._Shade.UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHSV(p1._Hue, p1._Saturation, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) })
	p1._Indicator.IndicatorFrame.BackgroundColor3 = v1
end
function t._ResetDragConnections(p1) --[[ _ResetDragConnections | Line: 156 ]]
	p1._WheelTrove:Clean()
	for v1, v2 in p1._Connections do
		if v2 then
			v2:Disconnect()
			p1._Connections[v1] = nil
		end
	end
end
function t._ConnectInputs(p1) --[[ _ConnectInputs | Line: 168 | Upvalues: RunService (copy), UserInputService (copy) ]]
	p1:_ResetDragConnections()
	p1._WheelTrove:Add(p1._Wheel.Button.InputBegan:Connect(function(p12) --[[ Line: 172 | Upvalues: p1 (copy), RunService (ref) ]]
		if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
			p1._Connections.WheelUpdate = RunService.Heartbeat:Connect(function() --[[ Line: 179 | Upvalues: p1 (ref) ]]
				local v1 = (p1:GetMousePosition() - (p1._Wheel.Image.AbsolutePosition + p1._Wheel.Image.AbsoluteSize / 2)) / p1._Wheel.Image.AbsoluteSize
				if v1.Magnitude > 0.5 then
					v1 = v1.Unit / 2
				end
				p1._Wheel.Image.Select.Position = UDim2.fromScale(0.5 + v1.X, 0.5 + v1.Y)
				local v2 = v1 * Vector2.new(1, -1)
				p1._Hue = math.clamp((math.atan2(v2.Y, v2.X) + math.pi) / 6.283185307179586 * 360 / 360, 0, 1)
				p1._Saturation = math.clamp(v2.Magnitude * 2, 0, 1)
				p1:_UpdateVisuals()
			end)
		end
	end))
	p1._WheelTrove:Add(p1._Shade.Button.InputBegan:Connect(function(p12) --[[ Line: 199 | Upvalues: p1 (copy), RunService (ref) ]]
		if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
			p1._Connections.ShadeUpdate = RunService.Heartbeat:Connect(function() --[[ Line: 206 | Upvalues: p1 (ref) ]]
				local v3 = 1 - math.clamp((p1:GetMousePosition().Y - p1._Shade.AbsolutePosition.Y) / p1._Shade.AbsoluteSize.Y, 0, 1)
				p1._Value = v3
				p1._Shade.Select.Position = UDim2.fromScale(0, 1 - v3)
				p1:_UpdateVisuals()
			end)
		end
	end))
	p1._WheelTrove:Add(UserInputService.InputEnded:Connect(function(p12) --[[ Line: 219 | Upvalues: p1 (copy) ]]
		if p12.UserInputType ~= Enum.UserInputType.MouseButton1 and p12.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		for v1, v2 in p1._Connections do
			if v2 then
				v2:Disconnect()
				p1._Connections[v1] = nil
			end
		end
		p1:_FireChanged()
	end))
end
function t.Destroy(p1) --[[ Destroy | Line: 238 ]]
	p1:_ResetDragConnections()
	p1._Trove:Destroy()
	p1._WheelTrove:Destroy()
end
return t