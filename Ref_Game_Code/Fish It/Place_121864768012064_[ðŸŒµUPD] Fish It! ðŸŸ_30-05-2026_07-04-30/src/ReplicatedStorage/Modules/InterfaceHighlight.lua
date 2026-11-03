-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CanvasGroup = require(script.Parent.CanvasGroup)
local spr = require(ReplicatedStorage.Packages.spr)
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local AreaHighlight = PlayerGui:WaitForChild("AreaHighlight")
local v1 = CanvasGroup.new(AreaHighlight.HighlightObject)
local t = {}
t.__index = t
local function isConsoleNavigationEnabled() --[[ isConsoleNavigationEnabled | Line: 22 | Upvalues: UserInputService (copy), GuiService (copy) ]]
	local v1 = UserInputService:GetLastInputType()
	return GuiService:IsTenFootInterface() or v1.Name:find("Gamepad") ~= nil
end
local function isSelectable(p1) --[[ isSelectable | Line: 27 ]]
	return p1.Visible and (p1.Selectable and (if p1.AbsoluteSize.X > 0 then p1.AbsoluteSize.Y > 0 else false))
end
local function getConsoleSelectionTarget(p1) --[[ getConsoleSelectionTarget | Line: 31 ]]
	if p1.Visible and (p1.Selectable and (if p1.AbsoluteSize.X > 0 then if p1.AbsoluteSize.Y > 0 then true else false else false)) then
		return p1
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("GuiObject") and (v.Visible and (v.Selectable and (if v.AbsoluteSize.X > 0 then if v.AbsoluteSize.Y > 0 then true else false else false))) then
			return v
		end
	end
	return nil
end
local function scrollIntoView(p1) --[[ scrollIntoView | Line: 45 ]]
	local v1 = p1.Parent
	while v1 do
		if v1:IsA("ScrollingFrame") then
			local AbsolutePosition = v1.AbsolutePosition
			local AbsoluteWindowSize = v1.AbsoluteWindowSize
			local AbsolutePosition_2 = p1.AbsolutePosition
			local AbsoluteSize = p1.AbsoluteSize
			local CanvasPosition = v1.CanvasPosition
			local X = CanvasPosition.X
			local Y = CanvasPosition.Y
			if AbsolutePosition_2.X < AbsolutePosition.X then
				X = X - (AbsolutePosition.X - AbsolutePosition_2.X)
			elseif AbsolutePosition_2.X + AbsoluteSize.X > AbsolutePosition.X + AbsoluteWindowSize.X then
				X = X + (AbsolutePosition_2.X + AbsoluteSize.X - (AbsolutePosition.X + AbsoluteWindowSize.X))
			end
			if AbsolutePosition_2.Y < AbsolutePosition.Y then
				Y = Y - (AbsolutePosition.Y - AbsolutePosition_2.Y)
			elseif AbsolutePosition_2.Y + AbsoluteSize.Y > AbsolutePosition.Y + AbsoluteWindowSize.Y then
				Y = Y + (AbsolutePosition_2.Y + AbsoluteSize.Y - (AbsolutePosition.Y + AbsoluteWindowSize.Y))
			end
			local v3 = math.max(0, v1.AbsoluteCanvasSize.X - AbsoluteWindowSize.X)
			local v5 = math.max(0, v1.AbsoluteCanvasSize.Y - AbsoluteWindowSize.Y)
			v1.CanvasPosition = Vector2.new(math.clamp(X, 0, v3), (math.clamp(Y, 0, v5)))
			return
		end
		v1 = v1.Parent
	end
end
local function getScrollingFrameAncestor(p1) --[[ getScrollingFrameAncestor | Line: 84 ]]
	local v1 = p1.Parent
	while v1 do
		if v1:IsA("ScrollingFrame") then
			return v1
		end
		v1 = v1.Parent
	end
	return nil
end
local function focusConsoleTarget(p1) --[[ focusConsoleTarget | Line: 97 | Upvalues: scrollIntoView (copy), UserInputService (copy), GuiService (copy), getConsoleSelectionTarget (copy) ]]
	scrollIntoView(p1)
	local v1 = UserInputService:GetLastInputType()
	local v2 = GuiService:IsTenFootInterface()
	if not (if v2 then v2 else v1.Name:find("Gamepad") ~= nil) then
		return
	end
	local v4 = getConsoleSelectionTarget(p1)
	if not v4 then
		return
	end
	scrollIntoView(v4)
	if GuiService.SelectedObject == v4 then
		return
	end
	GuiService.SelectedObject = v4
end
local function getCornerRadius(p1) --[[ getCornerRadius | Line: 116 ]]
	local UICorner = p1:FindFirstChild("UICorner")
	if UICorner and UICorner:IsA("UICorner") then
		return UICorner.CornerRadius
	end
	local BG = p1:FindFirstChild("BG")
	if not (BG and BG:IsA("GuiObject")) then
		return nil
	end
	local UICorner_2 = BG:FindFirstChild("UICorner")
	if UICorner_2 and UICorner_2:IsA("UICorner") then
		return UICorner_2.CornerRadius
	else
		return nil
	end
end
local function showHighlightArea() --[[ showHighlightArea | Line: 133 | Upvalues: v1 (copy), spr (copy) ]]
	if v1.Visible then
		v1.Visible = true
		spr.stop(v1.GroupTransparency)
		spr.target(v1.GroupTransparency, 0.7, 4, {
			Value = 0
		})
		return
	end
	v1.GroupTransparency.Value = 1
	v1.Visible = true
	spr.stop(v1.GroupTransparency)
	spr.target(v1.GroupTransparency, 0.7, 4, {
		Value = 0
	})
end
local function calculateHighlightTransform(p1) --[[ calculateHighlightTransform | Line: 146 | Upvalues: v1 (copy) ]]
	local AbsolutePosition = p1.AbsolutePosition
	local AbsoluteSize = p1.AbsoluteSize
	local AbsolutePosition_2 = v1.AbsolutePosition
	return UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X / 2 - AbsolutePosition_2.X, AbsolutePosition.Y + AbsoluteSize.Y / 2 - AbsolutePosition_2.Y), UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
end
local function animateHighlightToElement(p1) --[[ animateHighlightToElement | Line: 164 | Upvalues: v1 (copy), getCornerRadius (copy), spr (copy) ]]
	local AbsolutePosition = p1.AbsolutePosition
	local AbsoluteSize = p1.AbsoluteSize
	local AbsolutePosition_2 = v1.AbsolutePosition
	local v12 = UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X / 2 - AbsolutePosition_2.X, AbsolutePosition.Y + AbsoluteSize.Y / 2 - AbsolutePosition_2.Y)
	local v2 = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y)
	local v3 = getCornerRadius(p1)
	if not v3 then
		spr.stop(v1.Highlight)
		spr.target(v1.Highlight, 0.7, 4, {
			Position = v12,
			Size = v2
		})
		return
	end
	v1.Highlight.UICorner.CornerRadius = v3
	spr.stop(v1.Highlight)
	spr.target(v1.Highlight, 0.7, 4, {
		Position = v12,
		Size = v2
	})
end
function t._disconnect(p1) --[[ _disconnect | Line: 179 ]]
	if p1._sizeConnection then
		p1._sizeConnection:Disconnect()
		p1._sizeConnection = nil
	end
	if p1._positionConnection then
		p1._positionConnection:Disconnect()
		p1._positionConnection = nil
	end
	if not p1._scrollConnection then
		return
	end
	p1._scrollConnection:Disconnect()
	p1._scrollConnection = nil
end
function t.setTarget(p1, p2) --[[ setTarget | Line: 196 | Upvalues: PlayerGui (copy), showHighlightArea (copy), scrollIntoView (copy), UserInputService (copy), GuiService (copy), getConsoleSelectionTarget (copy), animateHighlightToElement (copy) ]]
	if p1._destroyed then
		return
	end
	p1:_disconnect()
	p1._target = p2
	if not p2:IsDescendantOf(PlayerGui) then
		return
	end
	showHighlightArea()
	scrollIntoView(p2)
	local v1 = UserInputService:GetLastInputType()
	local v2 = GuiService:IsTenFootInterface()
	if if v2 then v2 else v1.Name:find("Gamepad") ~= nil then
		local v4 = getConsoleSelectionTarget(p2)
		if v4 then
			scrollIntoView(v4)
			if GuiService.SelectedObject ~= v4 then
				GuiService.SelectedObject = v4
			end
		end
	end
	animateHighlightToElement(p2)
	task.defer(function() --[[ Line: 212 | Upvalues: p1 (copy), p2 (copy), PlayerGui (ref), animateHighlightToElement (ref) ]]
		if not p1._destroyed and (p1._target == p2 and p2:IsDescendantOf(PlayerGui)) then
			animateHighlightToElement(p2)
		end
	end)
	p1._sizeConnection = p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 220 | Upvalues: p1 (copy), p2 (copy), PlayerGui (ref), animateHighlightToElement (ref) ]]
		if not p1._destroyed and (p1._target == p2 and p2:IsDescendantOf(PlayerGui)) then
			animateHighlightToElement(p2)
		end
	end)
	p1._positionConnection = p2:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() --[[ Line: 228 | Upvalues: p1 (copy), p2 (copy), PlayerGui (ref), animateHighlightToElement (ref) ]]
		if not p1._destroyed and (p1._target == p2 and p2:IsDescendantOf(PlayerGui)) then
			animateHighlightToElement(p2)
		end
	end)
	local v5 = p2.Parent
	local v6
	while v5 do
		if v5:IsA("ScrollingFrame") then
			v6 = v5
			if not v5 then
				return
			end
			p1._scrollConnection = v5:GetPropertyChangedSignal("CanvasPosition"):Connect(function() --[[ Line: 238 | Upvalues: p1 (copy), p2 (copy), PlayerGui (ref), animateHighlightToElement (ref) ]]
				if not p1._destroyed and (p1._target == p2 and p2:IsDescendantOf(PlayerGui)) then
					animateHighlightToElement(p2)
				end
			end)
			return
		end
		v5 = v5.Parent
	end
	v6 = nil
	if not v6 then
		return
	end
	p1._scrollConnection = v6:GetPropertyChangedSignal("CanvasPosition"):Connect(function() --[[ Line: 238 | Upvalues: p1 (copy), p2 (copy), PlayerGui (ref), animateHighlightToElement (ref) ]]
		if not p1._destroyed and (p1._target == p2 and p2:IsDescendantOf(PlayerGui)) then
			animateHighlightToElement(p2)
		end
	end)
end
function t.destroy(p1) --[[ destroy | Line: 248 | Upvalues: spr (copy), v1 (copy) ]]
	if not p1._destroyed then
		p1._destroyed = true
		p1._target = nil
		p1:_disconnect()
		spr.stop(v1.GroupTransparency)
		spr.target(v1.GroupTransparency, 0.7, 4, {
			Value = 1
		})
		spr.stop(v1.Highlight)
		spr.target(v1.Highlight, 0.7, 4, {
			Size = UDim2.fromScale(1, 1)
		})
	end
end
local function trackElementHighlight(p1) --[[ trackElementHighlight | Line: 268 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		_destroyed = false,
		_positionConnection = nil,
		_sizeConnection = nil,
		_target = nil
	}, t)
	v2:setTarget(p1)
	return v2
end
return {
	highlight = function(p1) --[[ highlight | Line: 282 | Upvalues: t (copy) ]]
		local v2 = setmetatable({
			_destroyed = false,
			_positionConnection = nil,
			_sizeConnection = nil,
			_target = nil
		}, t)
		v2:setTarget(p1)
		local v3 = v2
		return function() --[[ Line: 285 | Upvalues: v3 (copy) ]]
			v3:destroy()
		end
	end,
	track = trackElementHighlight
}