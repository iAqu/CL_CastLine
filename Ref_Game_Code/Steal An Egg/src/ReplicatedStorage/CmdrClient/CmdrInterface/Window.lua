-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local t1 = {
    Enum.UserInputType.MouseButton1,
    Enum.UserInputType.MouseButton2,
    Enum.UserInputType.Touch
}
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

function t2.UpdateLabel(p1) -- line: 29
    -- upvalues: LocalPlayer (copy), Entry (copy)
    Entry.TextLabel.Text = LocalPlayer.Name .. "@" .. p1.Cmdr.PlaceName .. "$"
end

function t2.GetLabel(_) -- line: 34
    -- upvalues: Entry (copy)
    return Entry.TextLabel.Text
end

function t2.UpdateWindowHeight(_) -- line: 39
    -- upvalues: Frame (copy)
    local v1 = Frame.UIListLayout.AbsoluteContentSize.Y + Frame.UIPadding.PaddingTop.Offset + Frame.UIPadding.PaddingBottom.Offset

    Frame.Size = UDim2.new(Frame.Size.X.Scale, Frame.Size.X.Offset, 0, (math.clamp(v1, 0, 300)))
    Frame.CanvasPosition = Vector2.new(0, v1)
end

function t2.AddLine(p4, p5, p6) -- line: 48
    -- upvalues: t2 (copy), Frame (copy), Line (copy)
    local v2 = p6 or {}
    local v3 = tostring(p5)

    if typeof(v2) == "Color3" then
        v2 = {
            Color = v2
        }
    end

    if #v3 == 0 then
        t2:UpdateWindowHeight()
    else
        local v4 = p4.Cmdr.Util.EmulateTabstops(v3 or "nil", 8)
        local clone = Line:Clone()

        clone.Text = v4
        clone.TextColor3 = v2.Color or clone.TextColor3
        clone.RichText = v2.RichText or false
        clone.Parent = Frame
    end
end

function t2.IsVisible(_) -- line: 71
    -- upvalues: Frame (copy)
    return Frame.Visible
end

function t2.SetVisible(p8, p9) -- line: 76
    -- upvalues: UserInputService (copy), TextChatService (copy), Frame (copy), Entry (copy)
    Frame.Visible = p9

    if p9 then
        p8.PreviousChatWindowConfigurationEnabled = TextChatService.ChatWindowConfiguration.Enabled
        p8.PreviousChatInputBarConfigurationEnabled = TextChatService.ChatInputBarConfiguration.Enabled
        TextChatService.ChatWindowConfiguration.Enabled = false
        TextChatService.ChatInputBarConfiguration.Enabled = false
        Entry.TextBox:CaptureFocus()
        p8:SetEntryText("")

        if p8.Cmdr.ActivationUnlocksMouse then
            p8.PreviousMouseBehavior = UserInputService.MouseBehavior
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    else
        local ChatWindowConfiguration = TextChatService.ChatWindowConfiguration

        if p8.PreviousChatWindowConfigurationEnabled ~= nil then
            ChatWindowConfiguration.Enabled = p8.PreviousChatWindowConfigurationEnabled
        else
            ChatWindowConfiguration.Enabled = true
        end

        local ChatInputBarConfiguration = TextChatService.ChatInputBarConfiguration

        if p8.PreviousChatInputBarConfigurationEnabled ~= nil then
            ChatInputBarConfiguration.Enabled = p8.PreviousChatInputBarConfigurationEnabled
        else
            ChatInputBarConfiguration.Enabled = true
        end

        Entry.TextBox:ReleaseFocus()
        p8.AutoComplete:Hide()

        if p8.PreviousMouseBehavior then
            UserInputService.MouseBehavior = p8.PreviousMouseBehavior
            p8.PreviousMouseBehavior = nil
        end
    end
end

function t2.Hide(p10) -- line: 109
    return p10:SetVisible(false)
end

function t2.Show(p11) -- line: 114
    return p11:SetVisible(true)
end

function t2.SetEntryText(p12, p13) -- line: 119
    -- upvalues: t2 (copy), Entry (copy)
    Entry.TextBox.Text = p13

    if not p12:IsVisible() then
        return
    end

    Entry.TextBox:CaptureFocus()
    Entry.TextBox.CursorPosition = #p13 + 1
    t2:UpdateWindowHeight()
end

function t2.GetEntryText(_) -- line: 130
    -- upvalues: Entry (copy)
    return Entry.TextBox.Text:gsub("\t", "")
end

function t2.SetIsValidInput(p15, p16, p17) -- line: 136
    -- upvalues: Entry (copy)
    Entry.TextBox.TextColor3 = p16 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 73, 73)
    p15.Valid = p16
    p15._errorText = p17
end

function t2.HideInvalidState(_) -- line: 142
    -- upvalues: Entry (copy)
    Entry.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
end

function t2.LoseFocus(p19, p20) -- line: 147
    -- upvalues: GuiService (copy), Frame (copy), Entry (copy)
    local Text = Entry.TextBox.Text

    p19:ClearHistoryState()

    if not Frame.Visible or GuiService.MenuIsOpen then
        if GuiService.MenuIsOpen and Frame.Visible then
            p19:Hide()
        end
    else
        Entry.TextBox:CaptureFocus()
    end

    if not (p20 and p19.Valid) then
        if p20 then
            p19:AddLine(p19._errorText, Color3.fromRGB(255, 153, 153))
        end
    else
        wait()
        p19:SetEntryText("")
        p19.ProcessEntry(Text)
    end
end

function t2.TraverseHistory(p21, p22) -- line: 168
    local History = p21.Cmdr.Dispatcher:GetHistory()

    if p21.HistoryState == nil then
        p21.HistoryState = {
            Position = #History + 1,
            InitialText = p21:GetEntryText()
        }
    end

    p21.HistoryState.Position = math.clamp(p21.HistoryState.Position + p22, 1, #History + 1)
    p21:SetEntryText(p21.HistoryState.Position == #History + 1 and p21.HistoryState.InitialText or History[p21.HistoryState.Position])
end

function t2.ClearHistoryState(p23) -- line: 186
    p23.HistoryState = nil
end

function t2.SelectVertical(p24, p25) -- line: 190
    if not p24.AutoComplete:IsVisible() or p24.HistoryState then
        p24:TraverseHistory(p25)
    else
        p24.AutoComplete:Select(p25)
    end
end

local n1 = 0
local n2 = 0

function t2.BeginInput(p26, p27, p28) -- line: 201
    -- upvalues: GuiService (copy), t1 (copy), Frame (copy), n1 (ref), n2 (ref)
    if GuiService.MenuIsOpen then
        p26:Hide()
    end

    if p28 and p26:IsVisible() == false then
        return
    end

    if p26.Cmdr.ActivationKeys[p27.KeyCode] then
        if not p26.Cmdr.MashToEnable or p26.Cmdr.Enabled then
            if p26.Cmdr.Enabled then
                p26:SetVisible(not p26:IsVisible())
                wait()
                p26:SetEntryText("")

                if GuiService.MenuIsOpen then
                    p26:Hide()
                end
            end
        else
            if tick() - n1 < 1 then
                if n2 >= 5 then
                    return p26.Cmdr:SetEnabled(true)
                end

                n2 += 1
            else
                n2 = 1
            end

            n1 = tick()
        end
    elseif p26.Cmdr.Enabled == false or not p26:IsVisible() then
        if p26:IsVisible() then
            p26:Hide()
        end
    elseif not (p26.Cmdr.HideOnLostFocus and table.find(t1, p27.UserInputType)) then
        if p27.KeyCode == Enum.KeyCode.Down then
            p26:SelectVertical(1)
        elseif p27.KeyCode == Enum.KeyCode.Up then
            p26:SelectVertical(-1)
        elseif p27.KeyCode == Enum.KeyCode.Return then
            wait()
            p26:SetEntryText(p26:GetEntryText():gsub("\n", ""):gsub("\r", ""))
        elseif p27.KeyCode == Enum.KeyCode.Tab then
            local SelectedItem = p26.AutoComplete:GetSelectedItem()
            local EntryText = p26:GetEntryText()

            if not (not SelectedItem or EntryText:sub(#EntryText, #EntryText):match("%s") and p26.AutoComplete.LastItem) then
                local v7 = SelectedItem[2]
                local Command = p26.AutoComplete.Command
                local Alias, v8

                if Command then
                    local Arg = p26.AutoComplete.Arg

                    Alias = Command.Alias
                    v8 = p26.AutoComplete.NumArgs ~= #Command.ArgumentDefinitions and p26.AutoComplete.IsPartial == false

                    local Arguments = Command.Arguments

                    for i = 1, #Arguments do
                        local v9 = Arguments[i]
                        local RawSegments = v9.RawSegments

                        if v9 == Arg then
                            RawSegments[#RawSegments] = v7
                        end

                        local v10 = v9.Prefix .. table.concat(RawSegments, ",")

                        if v10:find(" ") or v10 == "" then
                            v10 = ("%q"):format(v10)
                        end

                        Alias = ("%s %s"):format(Alias, v10)

                        if v9 == Arg then
                            break
                        end
                    end
                else
                    Alias = v7
                    v8 = true
                end

                wait()
                p26:SetEntryText(Alias .. (v8 and " " or ""))
            else
                wait()
                p26:SetEntryText(p26:GetEntryText())
            end
        else
            p26:ClearHistoryState()
        end
    else
        local Position = p27.Position
        local AbsolutePosition, AbsoluteSize = Frame.AbsolutePosition, Frame.AbsoluteSize

        if Position.X < AbsolutePosition.X or Position.X > AbsolutePosition.X + AbsoluteSize.X or Position.Y < AbsolutePosition.Y or Position.Y > AbsolutePosition.Y + AbsoluteSize.Y then
            p26:Hide()
        end
    end
end

Entry.TextBox.FocusLost:Connect(function(p29) -- line: 312
    -- upvalues: t2 (copy)
    return t2:LoseFocus(p29)
end)
UserInputService.InputBegan:Connect(function(p30, p31) -- line: 316
    -- upvalues: t2 (copy)
    return t2:BeginInput(p30, p31)
end)
Entry.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 320
    -- upvalues: t2 (copy), Frame (copy), Entry (copy)
    Frame.CanvasPosition = Vector2.new(0, Frame.AbsoluteCanvasSize.Y)

    if Entry.TextBox.Text:match("\t") then
        Entry.TextBox.Text = Entry.TextBox.Text:gsub("\t", "")
    elseif t2.OnTextChanged then
        return t2.OnTextChanged(Entry.TextBox.Text)
    end
end)
Frame.ChildAdded:Connect(function() -- line: 332
    -- upvalues: t2 (copy)
    task.defer(t2.UpdateWindowHeight)
end)

return t2
