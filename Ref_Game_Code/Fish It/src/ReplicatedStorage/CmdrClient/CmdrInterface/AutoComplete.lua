-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local LocalPlayer = game:GetService("Players").LocalPlayer
return function(p1) --[[ Line: 5 | Upvalues: LocalPlayer (copy) ]]
	local t = {
		SelectedItem = 0,
		Items = {},
		ItemOptions = {}
	}
	local Util = p1.Util
	local v1 = Util.MakeDictionary({ "me", "all", ".", "*", "others" })
	local Autocomplete = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Autocomplete")
	local TextButton = Autocomplete:WaitForChild("TextButton")
	local Title = Autocomplete:WaitForChild("Title")
	local Description = Autocomplete:WaitForChild("Description")
	local Entry = Autocomplete.Parent:WaitForChild("Frame"):WaitForChild("Entry")
	TextButton.Parent = nil
	local function SetText(p1, p2, p3, p4) --[[ SetText | Line: 23 | Upvalues: Util (copy) ]]
		p1.Visible = if p3 == nil then false else true
		p2.Text = p3 or ""
		if not p4 then
			return
		end
		p2.Size = UDim2.new(0, Util.GetTextSize(p3 or "", p2, Vector2.new(1000, 1000), 1, 0).X, p1.Size.Y.Scale, p1.Size.Y.Offset)
	end
	local function UpdateInfoDisplay(p1) --[[ UpdateInfoDisplay | Line: 33 | Upvalues: SetText (copy), Title (copy), Description (copy), Autocomplete (copy) ]]
		SetText(Title, Title.Field, p1.name, true)
		local v1 = p1.type and ": " .. p1.type:sub(1, 1):upper() .. p1.type:sub(2)
		Title.Field.Type.Visible = if v1 == nil then false else true
		Title.Field.Type.Text = v1 or ""
		local Label = Description.Label
		local description = p1.description
		Description.Visible = description ~= nil
		Label.Text = description or ""
		Description.Label.TextColor3 = p1.invalid and Color3.fromRGB(255, 73, 73) or Color3.fromRGB(255, 255, 255)
		local v7 = math.max(Title.Field.TextBounds.X + Title.Field.Type.TextBounds.X, Autocomplete.Size.X.Offset)
		Description.Size = UDim2.new(1, 0, 0, 40)
		repeat
			if Description.Label.TextFits then
				break
			end
			Description.Size = Description.Size + UDim2.new(0, 0, 0, 2)
		until Description.Size.Y.Offset > 500
		wait()
		Autocomplete.UIListLayout:ApplyLayout()
		Autocomplete.Size = UDim2.new(0, v7, 0, Autocomplete.UIListLayout.AbsoluteContentSize.Y)
	end
	function t.Show(p1, p2, p3) --[[ Show | Line: 73 | Upvalues: v1 (copy), TextButton (copy), Autocomplete (copy), Entry (copy), Util (copy), UpdateInfoDisplay (copy) ]]
		local v2 = if p3 then p3 else {}
		for k, v in pairs(p1.Items) do
			if v.gui then
				v.gui:Destroy()
			end
		end
		p1.SelectedItem = 1
		p1.Items = p2
		p1.Prefix = v2.prefix or ""
		p1.LastItem = v2.isLast or false
		p1.Command = v2.command
		p1.Arg = v2.arg
		p1.NumArgs = v2.numArgs
		p1.IsPartial = v2.isPartial
		local v3 = 200
		for k, v in pairs(p1.Items) do
			local v4 = v[1]
			local v5 = v[2]
			if v1[v4] then
				v4 = v5
			end
			local v6 = TextButton:Clone()
			v6.Name = v4 .. v5
			v6.BackgroundTransparency = if k == p1.SelectedItem then 0.5 else 1
			v6.Typed.Text = v4
			v6.Suggest.Text = string.rep(" ", #v4) .. v5:sub(#v4 + 1)
			v6.Parent = Autocomplete
			v6.LayoutOrder = k
			local v8 = math.max(v6.Typed.TextBounds.X, v6.Suggest.TextBounds.X) + 20
			if v3 < v8 then
				v3 = v8
			end
			v.gui = v6
		end
		Autocomplete.UIListLayout:ApplyLayout()
		local Text = Entry.TextBox.Text
		local v9 = Util.SplitString(Text)
		if Text:sub(#Text, #Text) == " " and not v2.at then
			v9[#v9 + 1] = "e"
		end
		table.remove(v9, #v9)
		Autocomplete.Position = UDim2.new(0, Entry.TextBox.AbsolutePosition.X - 10 + (v2.at and v2.at or #table.concat(v9, " ") + 1) * 7, 0, Entry.TextBox.AbsolutePosition.Y + 30)
		Autocomplete.Size = UDim2.new(0, v3, 0, Autocomplete.UIListLayout.AbsoluteContentSize.Y)
		Autocomplete.Visible = true
		UpdateInfoDisplay(if p1.Items[1] then p1.Items[1].options or v2 else v2)
	end
	function t.GetSelectedItem(p1) --[[ GetSelectedItem | Line: 141 | Upvalues: Autocomplete (copy), t (copy) ]]
		if Autocomplete.Visible == false then
			return nil
		else
			return t.Items[t.SelectedItem]
		end
	end
	function t.Hide(p1) --[[ Hide | Line: 150 | Upvalues: Autocomplete (copy) ]]
		Autocomplete.Visible = false
	end
	function t.IsVisible(p1) --[[ IsVisible | Line: 155 | Upvalues: Autocomplete (copy) ]]
		return Autocomplete.Visible
	end
	function t.Select(p1, p2) --[[ Select | Line: 160 | Upvalues: Autocomplete (copy), UpdateInfoDisplay (copy) ]]
		if not Autocomplete.Visible then
			return
		end
		p1.SelectedItem = p1.SelectedItem + p2
		if p1.SelectedItem > #p1.Items then
			p1.SelectedItem = 1
		elseif p1.SelectedItem < 1 then
			p1.SelectedItem = #p1.Items
		end
		for k, v in pairs(p1.Items) do
			v.gui.BackgroundTransparency = if k == p1.SelectedItem then 0.5 else 1
		end
		if not (p1.Items[p1.SelectedItem] and p1.Items[p1.SelectedItem].options) then
			return
		end
		UpdateInfoDisplay(p1.Items[p1.SelectedItem].options or {})
	end
	return t
end