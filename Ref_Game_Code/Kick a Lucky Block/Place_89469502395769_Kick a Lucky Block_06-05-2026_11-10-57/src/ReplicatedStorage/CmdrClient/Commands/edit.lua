-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local t = {
	BackgroundTransparency = 0.05,
	BorderSizePixel = 20,
	ClearTextOnFocus = false,
	MultiLine = true,
	TextWrapped = true,
	TextSize = 18,
	TextXAlignment = "Left",
	TextYAlignment = "Top",
	AutoLocalize = false,
	PlaceholderText = "Right click to exit",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(17, 17, 17),
	BorderColor3 = Color3.fromRGB(17, 17, 17),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.5, 0, 0.4, 0),
	Font = Enum.Font.Code,
	TextColor3 = Color3.fromRGB(241, 241, 241)
}
local v1 = nil
return {
	Name = "edit",
	Description = "Edit text in a TextBox",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "string",
			Name = "Input text",
			Description = "The text you wish to edit",
			Default = ""
		},
		{
			Type = "string",
			Name = "Delimiter",
			Description = "The character that separates each line",
			Default = ","
		}
	},
	ClientRun = function(p1, p2, p3) --[[ ClientRun | Line: 45 | Upvalues: v1 (ref), t (copy), Players (copy) ]]
		v1 = v1 or p1.Cmdr.Util.Mutex()
		local v2 = v1()
		p1:Reply("Right-click on the text area to exit.", Color3.fromRGB(158, 158, 158))
		local CmdrEditBox = Instance.new("ScreenGui")
		CmdrEditBox.Name = "CmdrEditBox"
		CmdrEditBox.ResetOnSpawn = false
		local TextBox = Instance.new("TextBox")
		for k, v in pairs(t) do
			TextBox[k] = v
		end
		TextBox.Text = p2:gsub(p3, "\n")
		TextBox.Parent = CmdrEditBox
		CmdrEditBox.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
		local v3 = coroutine.running()
		TextBox.InputBegan:Connect(function(p1) --[[ Line: 69 | Upvalues: v3 (copy), TextBox (copy), p3 (copy), CmdrEditBox (copy), v2 (copy) ]]
			if p1.UserInputType == Enum.UserInputType.MouseButton2 then
				coroutine.resume(v3, TextBox.Text:gsub("\n", p3))
				CmdrEditBox:Destroy()
				v2()
			end
		end)
		return coroutine.yield()
	end
}