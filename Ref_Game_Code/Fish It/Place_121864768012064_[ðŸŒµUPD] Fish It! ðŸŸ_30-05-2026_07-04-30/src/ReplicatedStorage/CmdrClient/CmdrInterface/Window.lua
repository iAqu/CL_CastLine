-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = { Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.Touch }
local t2 = {
	Valid = true,
	AutoComplete = nil,
	ProcessEntry = nil,
	OnTextChanged = nil,
	Cmdr = nil,
	HistoryState = nil
}
local Frame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Frame")
local Line = Frame:WaitForChild("Line")
local Entry = Frame:WaitForChild("Entry")
Line.Parent = nil
function t2.UpdateLabel(p1) --[[ UpdateLabel | Line: 30 | Upvalues: Entry (copy), LocalPlayer (copy) ]]
	Entry.TextLabel.Text = ("%*:"):format(LocalPlayer.Name)
end
function t2.GetLabel(p1) --[[ GetLabel | Line: 37 | Upvalues: Entry (copy) ]]
	return Entry.TextLabel.Text
end
function t2.UpdateWindowHeight(p1) --[[ UpdateWindowHeight | Line: 42 | Upvalues: Frame (copy) ]]
	local sum = 20
	for k, v in pairs(Frame:GetChildren()) do
		if v:IsA("GuiObject") then
			sum = sum + v.Size.Y.Offset
		end
	end
	Frame.CanvasSize = UDim2.new(Frame.CanvasSize.X.Scale, Frame.CanvasSize.X.Offset, 0, sum)
	Frame.Size = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 0, if sum > 300 then 300 else sum)
	Frame.CanvasPosition = Vector2.new(0, (math.clamp(sum - 300, 0, (1 / 0))))
end
function t2.AddLine(p1, p2, p3) --[[ AddLine | Line: 64 | Upvalues: t2 (copy), Line (copy), TextService (copy), Frame (copy) ]]
	local v1 = tostring(p2)
	if #v1 == 0 then
		t2:UpdateWindowHeight()
		return
	end
	local v2 = p1.Cmdr.Util.EmulateTabstops(v1 or "nil", 8)
	local v3 = Line:Clone()
	v3.Size = UDim2.new(v3.Size.X.Scale, v3.Size.X.Offset, 0, TextService:GetTextSize(v2, v3.TextSize, v3.Font, Vector2.new(Frame.UIListLayout.AbsoluteContentSize.X, (1 / 0))).Y + (20 - v3.TextSize))
	v3.Text = v2
	v3.TextColor3 = if p3 then p3 else v3.TextColor3
	v3.Parent = Frame
end
function t2.IsVisible(p1) --[[ IsVisible | Line: 92 | Upvalues: Frame (copy) ]]
	return Frame.Visible
end
function t2.SetVisible(p1, p2) --[[ SetVisible | Line: 97 | Upvalues: Frame (copy), Entry (copy), UserInputService (copy) ]]
	Frame.Visible = p2
	if p2 then
		Entry.TextBox:CaptureFocus()
		p1:SetEntryText("")
		if p1.Cmdr.ActivationUnlocksMouse then
			p1.PreviousMouseBehavior = UserInputService.MouseBehavior
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	else
		Entry.TextBox:ReleaseFocus()
		p1.AutoComplete:Hide()
		if not p1.PreviousMouseBehavior then
			return
		end
		UserInputService.MouseBehavior = p1.PreviousMouseBehavior
		p1.PreviousMouseBehavior = nil
	end
end
function t2.Hide(p1) --[[ Hide | Line: 120 ]]
	return p1:SetVisible(false)
end
function t2.Show(p1) --[[ Show | Line: 125 ]]
	return p1:SetVisible(true)
end
function t2.SetEntryText(p1, p2) --[[ SetEntryText | Line: 130 | Upvalues: Entry (copy) ]]
	Entry.TextBox.Text = p2
	if not p1:IsVisible() then
		return
	end
	Entry.TextBox:CaptureFocus()
	Entry.TextBox.CursorPosition = #p2 + 1
end
function t2.GetEntryText(p1) --[[ GetEntryText | Line: 140 | Upvalues: Entry (copy) ]]
	return Entry.TextBox.Text:gsub("\t", "")
end
function t2.SetIsValidInput(p1, p2, p3) --[[ SetIsValidInput | Line: 146 | Upvalues: Entry (copy) ]]
	Entry.TextBox.TextColor3 = p2 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 73, 73)
	p1.Valid = p2
	p1._errorText = p3
end
function t2.HideInvalidState(p1) --[[ HideInvalidState | Line: 152 | Upvalues: Entry (copy) ]]
	Entry.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
end
function t2.LoseFocus(p1, p2) --[[ LoseFocus | Line: 157 | Upvalues: Entry (copy), Frame (copy), GuiService (copy) ]]
	local Text = Entry.TextBox.Text
	p1:ClearHistoryState()
	if Frame.Visible and not GuiService.MenuIsOpen then
		Entry.TextBox:CaptureFocus()
	elseif GuiService.MenuIsOpen and Frame.Visible then
		p1:Hide()
	end
	if p2 and p1.Valid then
		wait()
		p1:SetEntryText("")
		p1.ProcessEntry(Text)
		return
	end
	if not p2 then
		return
	end
	p1:AddLine(p1._errorText, Color3.fromRGB(255, 153, 153))
end
function t2.TraverseHistory(p1, p2) --[[ TraverseHistory | Line: 178 ]]
	local v1 = p1.Cmdr.Dispatcher:GetHistory()
	if p1.HistoryState == nil then
		p1.HistoryState = {
			Position = #v1 + 1,
			InitialText = p1:GetEntryText()
		}
	end
	p1.HistoryState.Position = math.clamp(p1.HistoryState.Position + p2, 1, #v1 + 1)
	p1:SetEntryText(p1.HistoryState.Position == #v1 + 1 and p1.HistoryState.InitialText or v1[p1.HistoryState.Position])
end
function t2.ClearHistoryState(p1) --[[ ClearHistoryState | Line: 197 ]]
	p1.HistoryState = nil
end
function t2.SelectVertical(p1, p2) --[[ SelectVertical | Line: 201 ]]
	if p1.AutoComplete:IsVisible() and not p1.HistoryState then
		p1.AutoComplete:Select(p2)
		return
	end
	p1:TraverseHistory(p2)
end
local v1 = 0
local v2 = 0
function t2.BeginInput(p1, p2, p3) --[[ BeginInput | Line: 212 | Upvalues: GuiService (copy), v1 (ref), v2 (ref), t (copy), Frame (copy) ]]
	if GuiService.MenuIsOpen then
		p1:Hide()
	end
	if p3 and p1:IsVisible() == false then
		return
	end
	if p1.Cmdr.ActivationKeys[p2.KeyCode] then
		if p1.Cmdr.MashToEnable and not p1.Cmdr.Enabled then
			if tick() - v1 < 1 then
				if v2 >= 5 then
					return p1.Cmdr:SetEnabled(true)
				end
				v2 = v2 + 1
			else
				v2 = 1
			end
			v1 = tick()
		else
			if not p1.Cmdr.Enabled then
				return
			end
			p1:SetVisible(not p1:IsVisible())
			wait()
			p1:SetEntryText("")
			if not GuiService.MenuIsOpen then
				return
			end
			p1:Hide()
		end
	elseif p1.Cmdr.Enabled == false or not p1:IsVisible() then
		if not p1:IsVisible() then
			return
		end
		p1:Hide()
	elseif p1.Cmdr.HideOnLostFocus and table.find(t, p2.UserInputType) then
		local Position = p2.Position
		local AbsolutePosition = Frame.AbsolutePosition
		local AbsoluteSize = Frame.AbsoluteSize
		if Position.X < AbsolutePosition.X or (Position.X > AbsolutePosition.X + AbsoluteSize.X or (Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
			p1:Hide()
		end
	else
		if p2.KeyCode == Enum.KeyCode.Down then
			p1:SelectVertical(1)
			return
		end
		if p2.KeyCode == Enum.KeyCode.Up then
			p1:SelectVertical(-1)
			return
		end
		if p2.KeyCode == Enum.KeyCode.Return then
			wait()
			p1:SetEntryText(p1:GetEntryText():gsub("\n", ""):gsub("\r", ""))
			return
		end
		if p2.KeyCode == Enum.KeyCode.Tab then
			local v12 = p1.AutoComplete:GetSelectedItem()
			local v22 = p1:GetEntryText()
			if v12 and not (v22:sub(#v22, #v22):match("%s") and p1.AutoComplete.LastItem) then
				local v3 = v12[2]
				local Command = p1.AutoComplete.Command
				local v4, v5
				if Command then
					local Arg = p1.AutoComplete.Arg
					v4 = Command.Alias
					local v6 = if p1.AutoComplete.NumArgs == #Command.ArgumentDefinitions then false elseif p1.AutoComplete.IsPartial == false then true else false
					local Arguments = Command.Arguments
					v5 = v6
					for i = 1, #Arguments do
						local v7 = Arguments[i]
						local RawSegments = v7.RawSegments
						if v7 == Arg then
							RawSegments[#RawSegments] = v3
						end
						local v8 = v7.Prefix .. table.concat(RawSegments, ",")
						if v8:find(" ") or v8 == "" then
							v8 = ("%q"):format(v8)
						end
						v4 = ("%s %s"):format(v4, v8)
						if v7 == Arg then
							break
						end
					end
				else
					v4 = v3
					v5 = true
				end
				wait()
				p1:SetEntryText(v4 .. (if v5 then " " else ""))
			else
				wait()
				p1:SetEntryText(p1:GetEntryText())
			end
			return
		end
		p1:ClearHistoryState()
	end
end
Entry.TextBox.FocusLost:Connect(function(p1) --[[ Line: 323 | Upvalues: t2 (copy) ]]
	return t2:LoseFocus(p1)
end)
UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 329 | Upvalues: t2 (copy) ]]
	return t2:BeginInput(p1, p2)
end)
Entry.TextBox:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 335 | Upvalues: Entry (copy), t2 (copy) ]]
	if Entry.TextBox.Text:match("\t") then
		Entry.TextBox.Text = Entry.TextBox.Text:gsub("\t", "")
		return
	end
	if t2.OnTextChanged then
		return t2.OnTextChanged(Entry.TextBox.Text)
	end
end)
Frame.ChildAdded:Connect(t2.UpdateWindowHeight)
return t2