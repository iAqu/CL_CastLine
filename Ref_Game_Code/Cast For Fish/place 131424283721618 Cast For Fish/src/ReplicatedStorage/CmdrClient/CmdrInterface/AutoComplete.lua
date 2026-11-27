-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LocalPlayer = game:GetService("Players").LocalPlayer

return function(p1) -- line: 5
    -- upvalues: LocalPlayer (copy)
    local t1 = {
        SelectedItem = 0,
        Items = {},
        ItemOptions = {}
    }
    local Util = p1.Util
    local Autocomplete = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Autocomplete")
    local TextButton = Autocomplete:WaitForChild("TextButton")
    local Title = Autocomplete:WaitForChild("Title")
    local Description = Autocomplete:WaitForChild("Description")
    local Entry = Autocomplete.Parent:WaitForChild("Frame"):WaitForChild("Entry")

    TextButton.Parent = nil

    local ScrollBarThickness = Autocomplete.ScrollBarThickness

    local function SetText(p2, p3, p4, p5) -- line: 24
        -- upvalues: Util (copy)
        p2.Visible = p4 ~= nil
        p3.Text = p4 or ""

        if p5 then
            p3.Size = UDim2.new(0, Util.GetTextSize(p4 or "", p3, Vector2.new(1000, 1000), 1, 0).X, p2.Size.Y.Scale, p2.Size.Y.Offset)
        end
    end

    local function UpdateContainerSize() -- line: 38
        -- upvalues: Autocomplete (copy), Title (copy)
        Autocomplete.Size = UDim2.new(0, math.max(Title.Field.TextBounds.X + Title.Field.Type.TextBounds.X, Autocomplete.Size.X.Offset), 0, (math.min(Autocomplete.UIListLayout.AbsoluteContentSize.Y, Autocomplete.Parent.AbsoluteSize.Y - Autocomplete.AbsolutePosition.Y - 10)))
    end

    local function UpdateInfoDisplay(p6) -- line: 48
        -- upvalues: Autocomplete (copy), Title (copy), Description (copy), ScrollBarThickness (copy), SetText (copy), UpdateContainerSize (copy)
        SetText(Title, Title.Field, p6.name, true)

        local Type, Type2 = Title.Field.Type, Title.Field.Type
        local v4 = p6.type and ": " .. p6.type:sub(1, 1):upper() .. p6.type:sub(2)

        Type.Visible = v4 ~= nil
        Type2.Text = v4 or ""

        local Label = Description.Label
        local description = p6.description

        Description.Visible = description ~= nil
        Label.Text = description or ""
        Description.Label.TextColor3 = p6.invalid and Color3.fromRGB(255, 73, 73) or Color3.fromRGB(255, 255, 255)
        Description.Size = UDim2.new(1, 0, 0, 40)

        while not Description.Label.TextFits do
            Description.Size += UDim2.new(0, 0, 0, 2)

            if Description.Size.Y.Offset > 500 then
                break
            end
        end

        task.wait()
        Autocomplete.UIListLayout:ApplyLayout()
        UpdateContainerSize()
        Autocomplete.ScrollBarThickness = ScrollBarThickness
    end

    function t1.Show(p7, p8, p9) -- line: 77
        -- upvalues: Util (copy), Autocomplete (copy), TextButton (copy), Entry (copy), UpdateInfoDisplay (copy)
        local v5 = p9 or {}

        for _, v6 in pairs(p7.Items) do
            if v6.gui then
                v6.gui:Destroy()
            end
        end

        p7.SelectedItem = 1
        p7.Items = p8
        p7.Prefix = v5.prefix or ""
        p7.LastItem = v5.isLast or false
        p7.Command = v5.command
        p7.Arg = v5.arg
        p7.NumArgs = v5.numArgs
        p7.IsPartial = v5.isPartial
        Autocomplete.ScrollBarThickness = 0

        local n1 = 200

        for v7, v8 in pairs(p7.Items) do
            local v9 = v8[1]
            local v10 = v8[2]
            local clone = TextButton:Clone()

            clone.Name = v9 .. v10
            clone.BackgroundTransparency = v7 == p7.SelectedItem and 0.5 or 1

            local v11, v12 = string.find(v10:lower(), v9:lower(), 1, true)

            clone.Typed.Text = string.rep(" ", v11 - 1) .. v9
            clone.Suggest.Text = string.sub(v10, 0, v11 - 1) .. string.rep(" ", #v9) .. string.sub(v10, v12 + 1)
            clone.Parent = Autocomplete
            clone.LayoutOrder = v7

            local v17 = math.max(clone.Typed.TextBounds.X, clone.Suggest.TextBounds.X) + 20

            if n1 < v17 then
                n1 = v17
            end

            v8.gui = clone
        end

        Autocomplete.UIListLayout:ApplyLayout()

        local Text = Entry.TextBox.Text
        local v18 = Util.SplitString(Text)

        if Text:sub(#Text, #Text) == " " and not v5.at then
            v18[#v18 + 1] = "e"
        end

        table.remove(v18, #v18)

        local v19 = (v5.at and v5.at or #table.concat(v18, " ") + 1) * 7

        Autocomplete.Position = UDim2.new(0, Entry.TextBox.AbsolutePosition.X - 10 + v19, 0, Entry.TextBox.AbsolutePosition.Y + 30)
        Autocomplete.Size = UDim2.new(0, n1, 0, Autocomplete.UIListLayout.AbsoluteContentSize.Y)
        Autocomplete.Visible = true
        v5 = p7.Items[1] and p7.Items[1].options or v5
        UpdateInfoDisplay(v5)
    end

    function t1.GetSelectedItem(_) -- line: 147
        -- upvalues: t1 (copy), Autocomplete (copy)
        return if Autocomplete.Visible ~= false then t1.Items[t1.SelectedItem] else nil
    end

    function t1.Hide(_) -- line: 155
        -- upvalues: Autocomplete (copy)
        Autocomplete.Visible = false
    end

    function t1.IsVisible(_) -- line: 159
        -- upvalues: Autocomplete (copy)
        return Autocomplete.Visible
    end

    function t1.Select(p13, p14) -- line: 163
        -- upvalues: Autocomplete (copy), TextButton (copy), Title (copy), Description (copy), UpdateInfoDisplay (copy)
        if Autocomplete.Visible then
            p13.SelectedItem += p14

            if p13.SelectedItem > #p13.Items then
                p13.SelectedItem = 1
            elseif p13.SelectedItem < 1 then
                p13.SelectedItem = #p13.Items
            end

            for v20, v21 in pairs(p13.Items) do
                v21.gui.BackgroundTransparency = v20 == p13.SelectedItem and 0.5 or 1
            end

            Autocomplete.CanvasPosition = Vector2.new(0, (math.max(0, Title.Size.Y.Offset + Description.Size.Y.Offset + p13.SelectedItem * TextButton.Size.Y.Offset - Autocomplete.Size.Y.Offset)))

            if p13.Items[p13.SelectedItem] and p13.Items[p13.SelectedItem].options then
                UpdateInfoDisplay(p13.Items[p13.SelectedItem].options or {})
            end
        end
    end

    Autocomplete.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateContainerSize)

    return t1
end
