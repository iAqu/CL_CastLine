-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local AdminPanelDiscovery = require(script.Parent.AdminPanelDiscovery)
local t = {}
local t2 = {
	Bg = Color3.fromRGB(24, 24, 28),
	Surface = Color3.fromRGB(32, 32, 38),
	SurfaceAlt = Color3.fromRGB(40, 40, 46),
	Hover = Color3.fromRGB(52, 52, 60),
	Border = Color3.fromRGB(60, 60, 68),
	Text = Color3.fromRGB(235, 235, 240),
	TextDim = Color3.fromRGB(150, 150, 160),
	Accent = Color3.fromRGB(100, 140, 255),
	AccentHover = Color3.fromRGB(120, 160, 255),
	Danger = Color3.fromRGB(220, 80, 80),
	CloseButton = Color3.fromRGB(255, 0, 0),
	DangerHover = Color3.fromRGB(240, 100, 100),
	DangerText = Color3.fromRGB(240, 140, 140),
	Success = Color3.fromRGB(80, 200, 120)
}
local LocalPlayer = Players.LocalPlayer
local v1 = nil
local t3 = {}
local t4 = {}
local v2 = ""
local v3 = ""
local v4 = nil
local v5 = false
local v6 = nil
local v7 = nil
local v8 = nil
local v9 = nil
local v10 = nil
local v11 = nil
local v12 = nil
local v13 = nil
local v14 = nil
local v15 = nil
local v16 = nil
local v17 = nil
local v18 = nil
local v19 = nil
local v20 = nil
local v21 = nil
local t5 = {}
local v22 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function AttachHover(p1, p2, p3) --[[ AttachHover | Line: 75 | Upvalues: TweenService (copy), v22 (copy) ]]
	p1.MouseEnter:Connect(function() --[[ Line: 77 | Upvalues: TweenService (ref), p1 (copy), v22 (ref), p3 (copy) ]]
		TweenService:Create(p1, v22, {
			BackgroundColor3 = p3
		}):Play()
	end)
	p1.MouseLeave:Connect(function() --[[ Line: 82 | Upvalues: TweenService (ref), p1 (copy), v22 (ref), p2 (copy) ]]
		TweenService:Create(p1, v22, {
			BackgroundColor3 = p2
		}):Play()
	end)
end
local function MakeFieldFrame(p1) --[[ MakeFieldFrame | Line: 88 | Upvalues: v13 (ref), t2 (copy) ]]
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 0, 68)
	Frame.BackgroundTransparency = 1
	Frame.Parent = v13
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1, 0, 0, 18)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p1
	TextLabel.TextColor3 = t2.TextDim
	TextLabel.TextSize = 17
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame
	local Frame_2 = Instance.new("Frame")
	Frame_2.Size = UDim2.new(1, 0, 1, -24)
	Frame_2.Position = UDim2.fromOffset(0, 24)
	Frame_2.BackgroundTransparency = 1
	Frame_2.Parent = Frame
	return Frame, Frame_2
end
local function RenderTextField(p1, p2, p3) --[[ RenderTextField | Line: 118 | Upvalues: MakeFieldFrame (copy), t2 (copy), t4 (copy) ]]
	local v1 = if p3 then 90 else 40
	local v2, v3 = MakeFieldFrame(p1.Label)
	v2.Size = UDim2.new(1, 0, 0, v1 + 24)
	local TextBox = Instance.new("TextBox")
	TextBox.Size = UDim2.new(1, 0, 0, v1)
	TextBox.BackgroundColor3 = t2.Surface
	TextBox.BorderSizePixel = 0
	local v4 = t4[p2][p1.Key] or ""
	TextBox.Text = tostring(v4)
	TextBox.PlaceholderText = p1.Placeholder or ""
	TextBox.PlaceholderColor3 = t2.TextDim
	TextBox.TextColor3 = t2.Text
	TextBox.TextSize = 14
	TextBox.Font = Enum.Font.Gotham
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.TextYAlignment = if p3 then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
	TextBox.MultiLine = p3
	TextBox.ClearTextOnFocus = false
	TextBox.Parent = v3
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = TextBox
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = t2.Border
	UIStroke.Thickness = 1
	UIStroke.Parent = TextBox
	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingLeft = UDim.new(0, 12)
	UIPadding.PaddingRight = UDim.new(0, 12)
	UIPadding.PaddingTop = UDim.new(0, if p3 then 8 else 0)
	UIPadding.Parent = TextBox
	TextBox:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 160 | Upvalues: p1 (copy), t4 (ref), p2 (copy), TextBox (copy) ]]
		if p1.Type == "number" then
			t4[p2][p1.Key] = tonumber(TextBox.Text)
		else
			t4[p2][p1.Key] = TextBox.Text
		end
	end)
end
local function RenderListField(p1, p2, p3) --[[ RenderListField | Line: 171 | Upvalues: MakeFieldFrame (copy), t2 (copy), t4 (copy), TweenService (copy), v22 (copy) ]]
	local v1, v2 = MakeFieldFrame(p1.Label)
	v1.Size = UDim2.new(1, 0, 0, 184)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1, 0, 0, 18)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "None selected"
	TextLabel.TextColor3 = t2.TextDim
	TextLabel.TextSize = 12
	TextLabel.Font = Enum.Font.Gotham
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = v2
	local ScrollingFrame = Instance.new("ScrollingFrame")
	ScrollingFrame.Size = UDim2.new(1, 0, 0, 138)
	ScrollingFrame.Position = UDim2.fromOffset(0, 20)
	ScrollingFrame.BackgroundColor3 = t2.Surface
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 4
	ScrollingFrame.ScrollBarImageColor3 = t2.Border
	ScrollingFrame.CanvasSize = UDim2.new()
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.Parent = v2
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = ScrollingFrame
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = t2.Border
	UIStroke.Thickness = 1
	UIStroke.Parent = ScrollingFrame
	Instance.new("UIListLayout").Parent = ScrollingFrame
	local v3 = t4[p2][p1.Key]
	if v3 then
		TextLabel.Text = ("Selected: %*"):format(v3)
	end
	local t = {}
	for v4, v5 in p3 do
		local v6 = if v3 == v5 then true else false
		local TextButton = Instance.new("TextButton")
		TextButton.Size = UDim2.new(1, 0, 0, 32)
		TextButton.BackgroundColor3 = if v6 then t2.Accent else t2.Surface
		TextButton.BackgroundTransparency = if v6 then 0 else 1
		TextButton.Text = v5
		TextButton.TextColor3 = t2.Text
		TextButton.TextSize = 18
		TextButton.Font = Enum.Font.Gotham
		TextButton.TextXAlignment = Enum.TextXAlignment.Left
		TextButton.BorderSizePixel = 0
		TextButton.AutoButtonColor = false
		TextButton.Parent = ScrollingFrame
		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingLeft = UDim.new(0, 12)
		UIPadding.Parent = TextButton
		TextButton.MouseEnter:Connect(function() --[[ Line: 246 | Upvalues: t4 (ref), p2 (copy), p1 (copy), v5 (copy), TweenService (ref), TextButton (copy), v22 (ref), t2 (ref) ]]
			if t4[p2][p1.Key] == v5 then
				return
			end
			TweenService:Create(TextButton, v22, {
				BackgroundTransparency = 0,
				BackgroundColor3 = t2.Hover
			}):Play()
		end)
		TextButton.MouseLeave:Connect(function() --[[ Line: 256 | Upvalues: t4 (ref), p2 (copy), p1 (copy), v5 (copy), TweenService (ref), TextButton (copy), v22 (ref) ]]
			if t4[p2][p1.Key] == v5 then
				return
			end
			TweenService:Create(TextButton, v22, {
				BackgroundTransparency = 1
			}):Play()
		end)
		TextButton.Activated:Connect(function() --[[ Line: 263 | Upvalues: t4 (ref), p2 (copy), p1 (copy), v5 (copy), TextLabel (copy), t (copy), t2 (ref), TextButton (copy) ]]
			t4[p2][p1.Key] = v5
			TextLabel.Text = ("Selected: %*"):format(v5)
			for v1, v2 in t do
				v2.BackgroundTransparency = 1
				v2.BackgroundColor3 = t2.Surface
			end
			TextButton.BackgroundTransparency = 0
			TextButton.BackgroundColor3 = t2.Accent
		end)
		table.insert(t, TextButton)
	end
end
local function RenderField(p1, p2) --[[ RenderField | Line: 284 | Upvalues: Players (copy), RenderListField (copy), RenderTextField (copy) ]]
	if p1.Type == "player" then
		local t = {}
		for v1, v2 in Players:GetPlayers() do
			table.insert(t, v2.Name)
		end
		RenderListField(p1, p2, t)
	elseif p1.Type == "select" or p1.Type == "itemType" then
		RenderListField(p1, p2, p1.Options or {})
	elseif p1.Type == "textarea" then
		RenderTextField(p1, p2, true)
	else
		RenderTextField(p1, p2, false)
	end
end
local function RefreshSidebarHighlight() --[[ RefreshSidebarHighlight | Line: 306 | Upvalues: t5 (copy), v2 (ref), t2 (copy) ]]
	for v1, v22 in t5 do
		if v1 == v2 then
			v22.BackgroundColor3 = t2.SurfaceAlt
			v22.BackgroundTransparency = 0
			continue
		end
		v22.BackgroundTransparency = 1
	end
end
local function RenderPanel() --[[ RenderPanel | Line: 320 | Upvalues: t3 (ref), v2 (ref), v11 (ref), v12 (ref), v15 (ref), v13 (ref), RenderField (copy), t5 (copy), t2 (copy) ]]
	local v1 = nil
	for v22, v3 in t3 do
		if v3.Id == v2 then
			v1 = v3
			break
		end
	end
	if not v1 then
		return
	end
	v11.Text = v1.Label
	v12.Text = v1.Description
	v15.Text = ""
	for v4, v5 in v13:GetChildren() do
		if not v5:IsA("UILayout") then
			v5:Destroy()
		end
	end
	for v6, v7 in v1.Fields do
		RenderField(v7, v1.Id)
	end
	for v8, v9 in t5 do
		if v8 == v2 then
			v9.BackgroundColor3 = t2.SurfaceAlt
			v9.BackgroundTransparency = 0
			continue
		end
		v9.BackgroundTransparency = 1
	end
end
local function BuildSidebar() --[[ BuildSidebar | Line: 357 | Upvalues: v10 (ref), t5 (copy), v3 (ref), t3 (ref), v2 (ref), t2 (copy), TweenService (copy), v22 (copy), RenderPanel (copy) ]]
	for v1, v23 in v10:GetChildren() do
		if v23:IsA("TextButton") or (v23:IsA("TextLabel") or v23:IsA("Frame")) then
			v23:Destroy()
		end
	end
	table.clear(t5)
	local v32 = v3:lower()
	local t = {}
	for v4, v5 in t3 do
		if v32 == "" or (v5.Label:lower():find(v32, 1, true) or v5.CmdrName:lower():find(v32, 1, true)) then
			table.insert(t, v5)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 381 ]]
		return p1.Label < p2.Label
	end)
	for v6, v7 in t do
		local isId = v7.Id == v2
		local TextButton = Instance.new("TextButton")
		TextButton.Size = UDim2.new(1, 0, 0, 34)
		TextButton.BackgroundColor3 = if isId then t2.SurfaceAlt else t2.Hover
		TextButton.BackgroundTransparency = if isId then 0 else 1
		TextButton.Text = ""
		TextButton.BorderSizePixel = 0
		TextButton.AutoButtonColor = false
		TextButton.Parent = v10
		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TextButton
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Size = UDim2.new(1, -20, 1, 0)
		TextLabel.Position = UDim2.fromOffset(12, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = v7.Label
		TextLabel.TextColor3 = if v7.Danger then t2.DangerText else t2.Text
		TextLabel.TextScaled = true
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = TextButton
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		UITextSizeConstraint.MaxTextSize = 17
		UITextSizeConstraint.Parent = TextLabel
		TextButton.MouseEnter:Connect(function() --[[ Line: 419 | Upvalues: v7 (copy), v2 (ref), TweenService (ref), TextButton (copy), v22 (ref), t2 (ref) ]]
			if v7.Id == v2 then
				return
			end
			TweenService:Create(TextButton, v22, {
				BackgroundTransparency = 0,
				BackgroundColor3 = t2.Hover
			}):Play()
		end)
		TextButton.MouseLeave:Connect(function() --[[ Line: 429 | Upvalues: v7 (copy), v2 (ref), TweenService (ref), TextButton (copy), v22 (ref) ]]
			if v7.Id == v2 then
				return
			end
			TweenService:Create(TextButton, v22, {
				BackgroundTransparency = 1
			}):Play()
		end)
		TextButton.Activated:Connect(function() --[[ Line: 436 | Upvalues: v2 (ref), v7 (copy), RenderPanel (ref) ]]
			v2 = v7.Id
			RenderPanel()
		end)
		t5[v7.Id] = TextButton
	end
	for v11, v12 in t5 do
		if v11 == v2 then
			v12.BackgroundColor3 = t2.SurfaceAlt
			v12.BackgroundTransparency = 0
			continue
		end
		v12.BackgroundTransparency = 1
	end
end
local function QuoteIfNeeded(p1) --[[ QuoteIfNeeded | Line: 450 ]]
	if p1:find("%s") then
		return "\"" .. p1:gsub("\"", "\\\"") .. "\""
	else
		return p1
	end
end
local function BuildCommandString(p1) --[[ BuildCommandString | Line: 461 | Upvalues: t4 (copy) ]]
	local t = { p1.CmdrName }
	for v1, v2 in p1.ArgOrder do
		local v3 = nil
		for v4, v5 in p1.Fields do
			if v5.Key == v2 then
				v3 = v5
				break
			end
		end
		if not v3 then
			return nil, ("Missing field definition for arg: %*"):format(v2)
		end
		local v6 = t4[p1.Id][v2]
		if v6 == nil or v6 == "" then
			if not v3.Optional then
				return nil, ("Missing: %*"):format(v3.Label)
			end
			v6 = v3.Default or ""
		end
		local v7 = tostring(v6)
		table.insert(t, if v7:find("%s") then "\"" .. v7:gsub("\"", "\\\"") .. "\"" else v7)
	end
	return table.concat(t, " "), nil
end
local function OpenModal(p1, p2) --[[ OpenModal | Line: 503 | Upvalues: v17 (ref), v18 (ref), v19 (ref), t2 (copy), v4 (ref), v16 (ref) ]]
	v17.Text = ("Running \"%*\". Review the command string below."):format(p1.Label)
	v18.Text = p2
	v19.BackgroundColor3 = if p1.Danger then t2.Danger else t2.Accent
	v4 = p2
	v16.Visible = true
end
local function CloseModal() --[[ CloseModal | Line: 515 | Upvalues: v16 (ref), v4 (ref) ]]
	v16.Visible = false
	v4 = nil
end
local function UpdateScale() --[[ UpdateScale | Line: 521 | Upvalues: v8 (ref) ]]
	if v8 then
		local ViewportSize = workspace.CurrentCamera.ViewportSize
		v8.Scale = math.min(math.clamp(ViewportSize.X / 1280, 0.6, 1), (math.clamp(ViewportSize.Y / 720, 0.6, 1)))
	end
end
local function FindTemplate() --[[ FindTemplate | Line: 530 ]]
	local AdminPanel = script:FindFirstChild("AdminPanel")
	if AdminPanel and AdminPanel:IsA("ScreenGui") then
		return AdminPanel
	else
		return nil
	end
end
local function ResolveCmdr() --[[ ResolveCmdr | Line: 540 | Upvalues: ReplicatedStorage (copy) ]]
	local CmdrClient = ReplicatedStorage:WaitForChild("CmdrClient", 5)
	if CmdrClient and CmdrClient:IsA("ModuleScript") then
		return require(CmdrClient)
	else
		return nil
	end
end
local function BindReferences() --[[ BindReferences | Line: 554 | Upvalues: v7 (ref), v6 (ref), v8 (ref), v21 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), v17 (ref), v18 (ref), v20 (ref), v19 (ref) ]]
	v7 = v6:WaitForChild("Root")
	v8 = v7:FindFirstChildWhichIsA("UIScale")
	local v1, v2, v3
	if not v8 then
		v8 = Instance.new("UIScale")
		v8.Parent = v7
	end
	v21 = v7:WaitForChild("Header"):WaitForChild("CloseBtn")
	v9 = v7:WaitForChild("SearchBox")
	v10 = v7:WaitForChild("Sidebar")
	v1 = v7:WaitForChild("Panel")
	v11 = v1:WaitForChild("PanelTitle")
	v12 = v1:WaitForChild("PanelDesc")
	v13 = v1:WaitForChild("FieldsContainer")
	v2 = v1:WaitForChild("RunRow")
	v14 = v2:WaitForChild("RunBtn")
	v15 = v2:WaitForChild("Output")
	v16 = v7:WaitForChild("ModalBg")
	v3 = v16:WaitForChild("Modal")
	v17 = v3:WaitForChild("Description")
	v18 = v3:WaitForChild("PreviewBox")
	v20 = v3:WaitForChild("CancelBtn")
	v19 = v3:WaitForChild("ConfirmBtn")
end
function t.Init(p1) --[[ Init | Line: 594 | Upvalues: v5 (ref), UserPriority (copy), LocalPlayer (copy), v1 (ref), ReplicatedStorage (copy), t3 (ref), AdminPanelDiscovery (copy), v2 (ref), t4 (copy), v6 (ref), BindReferences (copy), AttachHover (copy), v21 (ref), t2 (copy), v14 (ref), v20 (ref), v19 (ref), TweenService (copy), v22 (copy), v9 (ref), v3 (ref), BuildSidebar (copy), BuildCommandString (copy), v15 (ref), v17 (ref), v18 (ref), v4 (ref), v16 (ref), CloseModal (copy), v8 (ref), UpdateScale (copy) ]]
	v5 = UserPriority:GetPriorityLevel(LocalPlayer) >= 3
	if not v5 then
		return
	end
	local CmdrClient = ReplicatedStorage:WaitForChild("CmdrClient", 5)
	v1 = if CmdrClient and CmdrClient:IsA("ModuleScript") then require(CmdrClient) else nil
	if not v1 then
		v5 = false
		return
	end
	t3 = AdminPanelDiscovery.BuildCommands(v1)
	if #t3 == 0 then
		warn("No commands discovered.")
		v5 = false
		return
	end
	v2 = t3[1].Id
	for v42, v52 in t3 do
		t4[v52.Id] = {}
		for v62, v7 in v52.Fields do
			if v7.Default ~= nil then
				t4[v52.Id][v7.Key] = v7.Default
			end
		end
	end
	local AdminPanel = script:FindFirstChild("AdminPanel")
	local v82 = if AdminPanel and AdminPanel:IsA("ScreenGui") then AdminPanel else nil
	if not v82 then
		v5 = false
		return
	end
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	v6 = v82:Clone()
	v6.Enabled = false
	v6.Parent = PlayerGui
	BindReferences()
	AttachHover(v21, t2.CloseButton, t2.Hover)
	AttachHover(v14, t2.Accent, t2.AccentHover)
	AttachHover(v20, t2.SurfaceAlt, t2.Hover)
	v19.MouseEnter:Connect(function() --[[ Line: 658 | Upvalues: v19 (ref), t2 (ref), TweenService (ref), v22 (ref) ]]
		TweenService:Create(v19, v22, {
			BackgroundColor3 = if v19.BackgroundColor3 == t2.Danger then t2.DangerHover else t2.AccentHover
		}):Play()
	end)
	v19.MouseLeave:Connect(function() --[[ Line: 665 | Upvalues: v19 (ref), t2 (ref), TweenService (ref), v22 (ref) ]]
		TweenService:Create(v19, v22, {
			BackgroundColor3 = if v19.BackgroundColor3 == t2.DangerHover then t2.Danger else t2.Accent
		}):Play()
	end)
	v21.Activated:Connect(function() --[[ Line: 673 | Upvalues: v6 (ref) ]]
		v6.Enabled = false
	end)
	v9:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 678 | Upvalues: v3 (ref), v9 (ref), BuildSidebar (ref) ]]
		v3 = v9.Text
		BuildSidebar()
	end)
	v14.Activated:Connect(function() --[[ Line: 684 | Upvalues: t3 (ref), v2 (ref), BuildCommandString (ref), v15 (ref), t2 (ref), v17 (ref), v18 (ref), v19 (ref), v4 (ref), v16 (ref) ]]
		local v1 = nil
		for v22, v3 in t3 do
			if v3.Id == v2 then
				v1 = v3
				break
			end
		end
		if not v1 then
			return
		end
		local v42, v5 = BuildCommandString(v1)
		if not v42 then
			v15.Text = ("\226\154\160 %*"):format(v5 or "error")
			v15.TextColor3 = t2.Danger
			return
		end
		v17.Text = ("Running \"%*\". Review the command string below."):format(v1.Label)
		v18.Text = v42
		v19.BackgroundColor3 = if v1.Danger then t2.Danger else t2.Accent
		v4 = v42
		v16.Visible = true
	end)
	v20.Activated:Connect(CloseModal)
	v19.Activated:Connect(function() --[[ Line: 719 | Upvalues: v4 (ref), v16 (ref), v15 (ref), t2 (ref), v1 (ref) ]]
		if v4 then
			local v12 = v4
			v16.Visible = false
			v4 = nil
			v15.Text = "Running..."
			v15.TextColor3 = t2.TextDim
			task.spawn(function() --[[ Line: 732 | Upvalues: v1 (ref), v12 (copy), v15 (ref), t2 (ref) ]]
				local v13, v2 = pcall(function() --[[ Line: 734 | Upvalues: v1 (ref), v12 (ref) ]]
					return v1.Dispatcher:Send(v12)
				end)
				if v13 then
					v15.Text = tostring(v2)
					v15.TextColor3 = t2.Success
				else
					v15.Text = ("Error: %*"):format(v2)
					v15.TextColor3 = t2.Danger
				end
			end)
		end
	end)
	if v8 then
		local ViewportSize = workspace.CurrentCamera.ViewportSize
		v8.Scale = math.min(math.clamp(ViewportSize.X / 1280, 0.6, 1), (math.clamp(ViewportSize.Y / 720, 0.6, 1)))
	end
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end
function t.Start(p1) --[[ Start | Line: 755 | Upvalues: v5 (ref), BuildSidebar (copy), RenderPanel (copy), UserInputService (copy), v6 (ref), v8 (ref) ]]
	if v5 then
		BuildSidebar()
		RenderPanel()
		UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 764 | Upvalues: v6 (ref), v8 (ref), BuildSidebar (ref), RenderPanel (ref) ]]
			if p2 then
				return
			end
			if p1.KeyCode ~= Enum.KeyCode.F3 then
				return
			end
			v6.Enabled = not v6.Enabled
			if not v6.Enabled then
				return
			end
			if v8 then
				local ViewportSize = workspace.CurrentCamera.ViewportSize
				v8.Scale = math.min(math.clamp(ViewportSize.X / 1280, 0.6, 1), (math.clamp(ViewportSize.Y / 720, 0.6, 1)))
			end
			BuildSidebar()
			RenderPanel()
		end)
	end
end
function t.Open(p1) --[[ Open | Line: 782 | Upvalues: v5 (ref), v6 (ref), v8 (ref), BuildSidebar (copy), RenderPanel (copy) ]]
	if not (v5 and v6) then
		return
	end
	v6.Enabled = true
	if v8 then
		local ViewportSize = workspace.CurrentCamera.ViewportSize
		v8.Scale = math.min(math.clamp(ViewportSize.X / 1280, 0.6, 1), (math.clamp(ViewportSize.Y / 720, 0.6, 1)))
	end
	BuildSidebar()
	RenderPanel()
end
function t.Close(p1) --[[ Close | Line: 794 | Upvalues: v6 (ref) ]]
	if v6 then
		v6.Enabled = false
	end
end
return t