-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
function t.__index(p1, p2) --[[ Line: 20 | Upvalues: t (copy) ]]
	if p2 == "GroupTransparency" then
		local GroupTransparency = p1.Instance:FindFirstChild("GroupTransparency")
		if GroupTransparency then
			return GroupTransparency
		end
	elseif p2 == "GroupColor3" then
		local GroupColor3 = p1.Instance:FindFirstChild("GroupColor3")
		if GroupColor3 then
			return GroupColor3
		end
	end
	if p1.__props and p1.__props[p2] ~= nil then
		return p1.__props[p2]
	end
	if t[p2] then
		return t[p2]
	else
		return p1.Instance[p2]
	end
end
function t.__newindex(p1, p2, p3) --[[ Line: 52 ]]
	if p2 == "GroupTransparency" then
		local GroupTransparency = p1.Instance:FindFirstChild("GroupTransparency")
		if GroupTransparency and (typeof(GroupTransparency) == "Instance" and GroupTransparency:IsA("NumberValue")) then
			GroupTransparency.Value = p3
			return
		end
	elseif p2 == "GroupColor3" then
		local GroupColor3 = p1.Instance:FindFirstChild("GroupColor3")
		if GroupColor3 and (typeof(GroupColor3) == "Instance" and GroupColor3:IsA("Color3Value")) then
			GroupColor3.Value = p3
			return
		end
	end
	if p2:sub(1, 1) ~= "_" then
		p1.Instance[p2] = p3
		return
	end
	if not p1.__props then
		p1.__props = {}
	end
	p1.__props[p2] = p3
end
function t.new(p1, p2) --[[ new | Line: 84 | Upvalues: t (copy) ]]
	local t2 = {
		__props = {}
	}
	if p1 and (typeof(p1) == "Instance" and p1:IsA("Frame")) then
		t2.Instance = p1
	else
		t2.Instance = Instance.new("Frame")
		t2.Instance.Name = "CanvasGroup"
		t2.Instance.BackgroundTransparency = 1
	end
	t2.Instance.ClipsDescendants = p2 ~= false
	setmetatable(t2, t)
	local GroupTransparency = t2.Instance:FindFirstChild("GroupTransparency")
	if GroupTransparency and GroupTransparency:IsA("NumberValue") then
		t2._groupTransparencyValue = GroupTransparency
	else
		t2._groupTransparencyValue = Instance.new("NumberValue")
		t2._groupTransparencyValue.Name = "GroupTransparency"
		t2._groupTransparencyValue.Value = 0
		t2._groupTransparencyValue.Parent = t2.Instance
	end
	local GroupColor3 = t2.Instance:FindFirstChild("GroupColor3")
	if GroupColor3 and GroupColor3:IsA("Color3Value") then
		t2._groupColor3Value = GroupColor3
	else
		t2._groupColor3Value = Instance.new("Color3Value")
		t2._groupColor3Value.Name = "GroupColor3"
		t2._groupColor3Value.Value = Color3.new(255/255, 255/255, 255/255)
		t2._groupColor3Value.Parent = t2.Instance
	end
	t2.Instance:SetAttribute("GroupTransparency", t2._groupTransparencyValue.Value)
	t2.Instance:SetAttribute("GroupColor3_R", t2._groupColor3Value.Value.R)
	t2.Instance:SetAttribute("GroupColor3_G", t2._groupColor3Value.Value.G)
	t2.Instance:SetAttribute("GroupColor3_B", t2._groupColor3Value.Value.B)
	t2._attributeChangedConn = t2.Instance.AttributeChanged:Connect(function(p1) --[[ Line: 125 | Upvalues: t2 (copy) ]]
		if p1 == "GroupTransparency" then
			t2:_refreshAllDescendants()
			return
		end
		if not p1:find("GroupColor3_") then
			return
		end
		t2:_refreshAllDescendants()
	end)
	t2._descendants = {}
	t2._originalProps = {}
	t2._descendantAddedConn = t2.Instance.DescendantAdded:Connect(function(p1) --[[ Line: 136 | Upvalues: t2 (copy) ]]
		if not t2:_isValidGuiObject(p1) then
			return
		end
		t2:_registerDescendant(p1)
	end)
	t2._descendantRemovedConn = t2.Instance.DescendantRemoving:Connect(function(p1) --[[ Line: 142 | Upvalues: t2 (copy) ]]
		if not t2:_isValidGuiObject(p1) then
			return
		end
		t2:_unregisterDescendant(p1)
	end)
	if t2:_isValidGuiObject(t2.Instance) then
		t2:_registerDescendant(t2.Instance)
	end
	for i, v in ipairs(t2.Instance:GetDescendants()) do
		if t2:_isValidGuiObject(v) then
			t2:_registerDescendant(v)
		end
	end
	t2._transparencyChangedConn = t2._groupTransparencyValue.Changed:Connect(function() --[[ Line: 159 | Upvalues: t2 (copy) ]]
		t2.Instance:SetAttribute("GroupTransparency", t2._groupTransparencyValue.Value)
	end)
	t2._colorChangedConn = t2._groupColor3Value.Changed:Connect(function() --[[ Line: 163 | Upvalues: t2 (copy) ]]
		local _groupColor3Value = t2._groupColor3Value.Value
		t2.Instance:SetAttribute("GroupColor3_R", _groupColor3Value.R)
		t2.Instance:SetAttribute("GroupColor3_G", _groupColor3Value.G)
		t2.Instance:SetAttribute("GroupColor3_B", _groupColor3Value.B)
	end)
	return t2
end
function t.fromInstance(p1) --[[ fromInstance | Line: 180 | Upvalues: t (copy) ]]
	if typeof(p1) ~= "Instance" or not p1:IsA("Frame") then
		error("CanvasGroup.fromInstance requires a Frame instance")
	end
	return t.new(p1)
end
function t._isValidGuiObject(p1, p2) --[[ _isValidGuiObject | Line: 194 ]]
	if p2:IsA("UIStroke") or p2:IsA("UIGradient") then
		return true
	end
	if p2:IsA("UIGridStyleLayout") or p2:IsA("UILayout") then
		return false
	end
	local v1 = pcall(function() --[[ Line: 203 | Upvalues: p2 (copy) ]]
		local BackgroundColor3 = p2.BackgroundColor3
		local BackgroundTransparency = p2.BackgroundTransparency
	end)
	return if v1 then p2:IsA("GuiObject") or p2:IsA("UIComponent") else v1
end
function t._registerDescendant(p1, p2) --[[ _registerDescendant | Line: 216 ]]
	if table.find(p1._descendants, p2) then
		return
	end
	table.insert(p1._descendants, p2)
	if p2:IsA("UIStroke") or p2:IsA("UIGradient") then
		p1._originalProps[p2] = {
			Color = p2.Color,
			Transparency = p2.Transparency
		}
	else
		local t = {
			BackgroundColor3 = p2.BackgroundColor3,
			BackgroundTransparency = p2.BackgroundTransparency
		}
		t.TextColor3 = p2:IsA("TextLabel") and p2.TextColor3 or nil
		t.TextTransparency = p2:IsA("TextLabel") and p2.TextTransparency or nil
		t.ImageColor3 = p2:IsA("ImageLabel") and p2.ImageColor3 or nil
		t.ImageTransparency = p2:IsA("ImageLabel") and p2.ImageTransparency or nil
		p1._originalProps[p2] = t
	end
	p1:_applyPropertiesToDescendant(p2)
end
function t._unregisterDescendant(p1, p2) --[[ _unregisterDescendant | Line: 252 ]]
	local v1 = table.find(p1._descendants, p2)
	if not v1 then
		return
	end
	table.remove(p1._descendants, v1)
	local v2 = p1._originalProps[p2]
	if not v2 then
		return
	end
	if p2:IsA("UIStroke") or p2:IsA("UIGradient") then
		p2.Color = v2.Color
		p2.Transparency = v2.Transparency
	else
		p2.BackgroundColor3 = v2.BackgroundColor3
		p2.BackgroundTransparency = v2.BackgroundTransparency
		if p2:IsA("TextLabel") and v2.TextColor3 then
			p2.TextColor3 = v2.TextColor3
			p2.TextTransparency = v2.TextTransparency
		end
		if p2:IsA("ImageLabel") and v2.ImageColor3 then
			p2.ImageColor3 = v2.ImageColor3
			p2.ImageTransparency = v2.ImageTransparency
		end
	end
	p1._originalProps[p2] = nil
end
function t._applyPropertiesToDescendant(p1, p2) --[[ _applyPropertiesToDescendant | Line: 290 ]]
	local v1 = p1._originalProps[p2]
	if not v1 then
		return
	end
	local v2 = p1.Instance:GetAttribute("GroupTransparency")
	local v3 = Color3.new(p1.Instance:GetAttribute("GroupColor3_R"), p1.Instance:GetAttribute("GroupColor3_G"), p1.Instance:GetAttribute("GroupColor3_B"))
	if p2:IsA("UIStroke") then
		p2.Color = p1:_multiplyColors(v1.Color, v3)
		if v2 >= 0.99 then
			p2.Transparency = 1
		else
			p2.Transparency = p1:_combineTransparency(v1.Transparency, v2)
		end
	else
		if p2:IsA("UIGradient") then
			p2.Color = p1:_applyColorToColorSequence(v1.Color, v3)
			p2.Transparency = p1:_applyTransparencyToNumberSequence(v1.Transparency, v2)
			return
		end
		p2.BackgroundColor3 = p1:_multiplyColors(v1.BackgroundColor3, v3)
		p2.BackgroundTransparency = p1:_combineTransparency(v1.BackgroundTransparency, v2)
		if p2:IsA("TextLabel") and v1.TextColor3 then
			p2.TextColor3 = p1:_multiplyColors(v1.TextColor3, v3)
			p2.TextTransparency = p1:_combineTransparency(v1.TextTransparency, v2)
		end
		if not (p2:IsA("ImageLabel") and v1.ImageColor3) then
			return
		end
		p2.ImageColor3 = p1:_multiplyColors(v1.ImageColor3, v3)
		p2.ImageTransparency = p1:_combineTransparency(v1.ImageTransparency, v2)
	end
end
function t._applyColorToColorSequence(p1, p2, p3) --[[ _applyColorToColorSequence | Line: 341 ]]
	local Keypoints = p2.Keypoints
	local v1 = table.create(#Keypoints)
	for i, v in ipairs(Keypoints) do
		v1[i] = ColorSequenceKeypoint.new(v.Time, (p1:_multiplyColors(v.Value, p3)))
	end
	return ColorSequence.new(v1)
end
function t._applyTransparencyToNumberSequence(p1, p2, p3) --[[ _applyTransparencyToNumberSequence | Line: 360 ]]
	local Keypoints = p2.Keypoints
	local v1 = table.create(#Keypoints)
	for i, v in ipairs(Keypoints) do
		v1[i] = NumberSequenceKeypoint.new(v.Time, p1:_combineTransparency(v.Value, p3), v.Envelope)
	end
	return NumberSequence.new(v1)
end
function t._multiplyColors(p1, p2, p3) --[[ _multiplyColors | Line: 379 ]]
	return Color3.new(p2.R * p3.R, p2.G * p3.G, p2.B * p3.B)
end
function t._combineTransparency(p1, p2, p3) --[[ _combineTransparency | Line: 394 ]]
	return 1 - (1 - p2) * (1 - p3)
end
function t._refreshAllDescendants(p1) --[[ _refreshAllDescendants | Line: 401 ]]
	for i, v in ipairs(p1._descendants) do
		p1:_applyPropertiesToDescendant(v)
	end
end
function t.GetGroupColor3(p1) --[[ GetGroupColor3 | Line: 412 ]]
	return p1._groupColor3Value.Value
end
function t.SetGroupColor3(p1, p2) --[[ SetGroupColor3 | Line: 421 ]]
	p1._groupColor3Value.Value = p2
end
function t.GetGroupTransparency(p1) --[[ GetGroupTransparency | Line: 430 ]]
	return p1._groupTransparencyValue.Value
end
function t.SetGroupTransparency(p1, p2) --[[ SetGroupTransparency | Line: 439 ]]
	p1._groupTransparencyValue.Value = p2
end
function t.GetInstance(p1) --[[ GetInstance | Line: 448 ]]
	return p1.Instance
end
function t.SetParent(p1, p2) --[[ SetParent | Line: 457 ]]
	p1.Instance.Parent = p2
end
function t.GetParent(p1) --[[ GetParent | Line: 466 ]]
	return p1.Instance.Parent
end
function t.GetName(p1) --[[ GetName | Line: 475 ]]
	return p1.Instance.Name
end
function t.SetName(p1, p2) --[[ SetName | Line: 484 ]]
	p1.Instance.Name = p2
end
function t.GetSize(p1) --[[ GetSize | Line: 493 ]]
	return p1.Instance.Size
end
function t.SetSize(p1, p2) --[[ SetSize | Line: 502 ]]
	p1.Instance.Size = p2
end
function t.GetPosition(p1) --[[ GetPosition | Line: 511 ]]
	return p1.Instance.Position
end
function t.SetPosition(p1, p2) --[[ SetPosition | Line: 520 ]]
	p1.Instance.Position = p2
end
function t.GetAnchorPoint(p1) --[[ GetAnchorPoint | Line: 529 ]]
	return p1.Instance.AnchorPoint
end
function t.SetAnchorPoint(p1, p2) --[[ SetAnchorPoint | Line: 538 ]]
	p1.Instance.AnchorPoint = p2
end
function t.GetVisible(p1) --[[ GetVisible | Line: 547 ]]
	return p1.Instance.Visible
end
function t.SetVisible(p1, p2) --[[ SetVisible | Line: 556 ]]
	p1.Instance.Visible = p2
end
function t.GetZIndex(p1) --[[ GetZIndex | Line: 565 ]]
	return p1.Instance.ZIndex
end
function t.SetZIndex(p1, p2) --[[ SetZIndex | Line: 574 ]]
	p1.Instance.ZIndex = p2
end
function t.GetLayoutOrder(p1) --[[ GetLayoutOrder | Line: 583 ]]
	return p1.Instance.LayoutOrder
end
function t.SetLayoutOrder(p1, p2) --[[ SetLayoutOrder | Line: 592 ]]
	p1.Instance.LayoutOrder = p2
end
function t.Destroy(p1) --[[ Destroy | Line: 599 ]]
	if p1._descendantAddedConn then
		p1._descendantAddedConn:Disconnect()
		p1._descendantAddedConn = nil
	end
	if p1._descendantRemovedConn then
		p1._descendantRemovedConn:Disconnect()
		p1._descendantRemovedConn = nil
	end
	if p1._attributeChangedConn then
		p1._attributeChangedConn:Disconnect()
		p1._attributeChangedConn = nil
	end
	if p1._transparencyChangedConn then
		p1._transparencyChangedConn:Disconnect()
		p1._transparencyChangedConn = nil
	end
	if p1._colorChangedConn then
		p1._colorChangedConn:Disconnect()
		p1._colorChangedConn = nil
	end
	local v1 = p1.Instance
	for k, v in pairs(p1._originalProps) do
		if k and k:IsA("Instance") then
			if k:IsA("UIStroke") then
				k.Color = v.Color
				k.Transparency = v.Transparency
				continue
			end
			if k:IsA("UIGradient") then
				k.Color = v.Color
				k.Transparency = v.Transparency
				continue
			end
			k.BackgroundColor3 = v.BackgroundColor3
			k.BackgroundTransparency = v.BackgroundTransparency
			if k:IsA("TextLabel") and v.TextColor3 then
				k.TextColor3 = v.TextColor3
				k.TextTransparency = v.TextTransparency
			end
			if k:IsA("ImageLabel") and v.ImageColor3 then
				k.ImageColor3 = v.ImageColor3
				k.ImageTransparency = v.ImageTransparency
			end
		end
	end
	p1._descendants = {}
	p1._originalProps = {}
	if p1.Instance and p1.Instance ~= v1 then
		p1.Instance:Destroy()
	end
	p1.Instance = nil
end
return t