-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
require(ReplicatedStorage.Shared.Data.Attributes)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local SlotButton = require(script.SlotButton)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = LocalPlayer:GetMouse()
require(ReplicatedStorage.Functional.FormatValue)
local v2 = Trove.new()
local v3 = Trove.new()
local NewInventory = script:WaitForChild("NewInventory")
local v4 = 9
local t = {
	Mobile = {
		Slots = 5,
		HideNums = true,
		Result = UDim2.fromOffset(325, 250)
	},
	PC = {
		Slots = 9,
		Result = UDim2.fromOffset(585, 450)
	},
	Console = {
		Slots = 5,
		HideNums = true,
		Result = UDim2.fromOffset(585, 450)
	}
}
local v5 = nil
local v6 = nil
local v7 = nil
local v8 = nil
local v9 = nil
local v10 = nil
local v11 = "All"
local v12 = ""
local v13 = Signal.new()
local t2 = { "All", "Brainrots", "Lucky Blocks" }
local t3 = {
	All = {},
	Brainrots = {},
	["Lucky Blocks"] = {}
}
local t4 = {
	Enabled = true,
	GUI = NewInventory,
	Backpack = {},
	ButtonToTool = {}
}
function ToggleTool(p1) --[[ ToggleTool | Line: 85 | Upvalues: LocalPlayer (copy) ]]
	if p1 and (typeof(p1) == "Instance" and p1:IsA("Tool")) then
		local Humanoid = LocalPlayer.Character.Humanoid
		if p1.Parent == LocalPlayer.Character then
			Humanoid:UnequipTools()
		else
			Humanoid:EquipTool(p1)
		end
	end
end
function LoadInventory() --[[ LoadInventory | Line: 100 | Upvalues: LocalPlayer (copy) ]]
	for i, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			HandleNewItem(v)
		end
	end
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
		HandleNewItem(LocalPlayer.Character:FindFirstChildOfClass("Tool"))
	end
end
function HandleNewItem(p1) --[[ HandleNewItem | Line: 112 | Upvalues: t4 (copy) ]]
	if p1:IsA("Tool") and not t4.Backpack[p1] then
		AddToBackpack(p1)
	end
end
function DefaultButton(p1) --[[ DefaultButton | Line: 126 ]]
	p1.AnchorPoint = Vector2.new(0.5, 0.5)
	p1.Position = UDim2.fromScale(0.5, 0.5)
	p1.Size = UDim2.fromScale(1, 1)
end
function InitButton(p1, p2) --[[ InitButton | Line: 132 | Upvalues: v3 (copy), SlotButton (copy), v10 (ref), NewInventory (copy), v11 (ref), t3 (copy), EntitiesData (copy), v12 (ref), Network (copy), t4 (copy), LocalPlayer (copy), v13 (copy), v6 (ref), v9 (ref), v7 (ref), v5 (ref) ]]
	local v1 = v3:Extend()
	local v2 = SlotButton.new(p1)
	v2.Button.Parent = p2
	local Button = v2.Button
	local SlotNum = Button.SlotNum
	local function UpdateButtonSlotNum(p1) --[[ UpdateButtonSlotNum | Line: 141 | Upvalues: v10 (ref), NewInventory (ref), v2 (copy) ]]
		if if p1 then not v10 else p1 and p1.Parent == NewInventory.InventoryFrame.Slots then
			v2:UpdateSlotNum((p1.Name:gsub("Slot", "")))
		else
			v2:UpdateSlotNum(nil)
		end
	end
	local function CheckCanShow() --[[ CheckCanShow | Line: 157 | Upvalues: Button (copy), v11 (ref), t3 (ref), p1 (copy), EntitiesData (ref), v12 (ref) ]]
		if Button.Parent.Name:match("Slot") then
			Button.Visible = true
		else
			local v1 = if v11 == "All" then true else t3[v11][p1.Name]
			local v2 = p1.Name:lower():gsub(" ", "")
			local v3 = (p1:GetAttribute("Mutation") or ""):lower():gsub(" ", "")
			local v4 = EntitiesData.Brainrots[p1.Name] and EntitiesData.Brainrots[p1.Name].Rarity
			if v4 then
				v4 = v4:lower():gsub(" ", "")
			end
			Button.Visible = v1 and if v12 == "" then true else v2:match(v12) or (v3:match(v12) or if v4 then v4:match(v12) else v4)
		end
	end
	local function ToggleFavorite() --[[ ToggleFavorite | Line: 183 | Upvalues: Network (ref), p1 (copy) ]]
		Network.FireServer("ToggleFav", p1:GetAttribute("GUID"))
	end
	v1:Add(Button)
	t4.Backpack[p1] = v2
	t4.ButtonToTool[Button] = p1
	v1:Add(function() --[[ Line: 191 | Upvalues: t4 (ref), p1 (copy), Button (copy) ]]
		t4.Backpack[p1] = nil
		t4.ButtonToTool[Button] = nil
	end)
	Button.Parent = p2
	v1:Add(p1:GetAttributeChangedSignal("Favorite"):Connect(function() --[[ Line: 198 | Upvalues: v2 (copy) ]]
		v2:UpdateFavorite()
	end))
	UpdateButtonSlotNum(p2)
	CheckCanShow()
	v1:Add(p1.AncestryChanged:Connect(function() --[[ Line: 208 | Upvalues: LocalPlayer (ref), p1 (copy), v1 (copy), v2 (copy) ]]
		if LocalPlayer.Character and LocalPlayer:FindFirstChild("Backpack") then
			if p1.Parent == LocalPlayer.Backpack or p1.Parent == LocalPlayer.Character then
				v2:UpdateEquipped()
			else
				v1:Clean()
			end
		end
	end))
	v1:Add(v13:Connect(CheckCanShow))
	v1:Add(p1:GetAttributeChangedSignal("Count"):Connect(function() --[[ Line: 223 | Upvalues: v2 (copy) ]]
		v2:UpdateCount()
	end))
	v1:Add(Button.AncestryChanged:Connect(function() --[[ Line: 227 | Upvalues: UpdateButtonSlotNum (copy), Button (copy), NewInventory (ref), CheckCanShow (copy) ]]
		UpdateButtonSlotNum(Button.Parent)
		if Button.Parent == NewInventory.InventoryFrame.Backpack.Items then
			CheckCanShow()
		end
	end))
	v1:Add(Button.Activated:Connect(function() --[[ Line: 234 | Upvalues: p1 (copy) ]]
		ToggleTool(p1)
	end))
	local v32 = nil
	v1:Add(Button.InputBegan:Connect(function(p12) --[[ Line: 240 | Upvalues: p1 (copy), v32 (ref), NewInventory (ref), v6 (ref), v9 (ref), Button (copy), v7 (ref) ]]
		if not p1:HasTag("SquatTool") then
			if p12.UserInputType == Enum.UserInputType.Touch or p12.UserInputType == Enum.UserInputType.MouseButton1 then
				v32 = tick()
			end
			if NewInventory.InventoryFrame.Backpack.Visible and (if p12.UserInputType == Enum.UserInputType.Touch then true else p12.UserInputType == Enum.UserInputType.MouseButton1 and not v6) then
				v9 = Button.Parent
				v7 = tick()
				v6 = Button
			end
		end
	end))
	v1:Add(Button.InputEnded:Connect(function(p12) --[[ Line: 261 | Upvalues: Network (ref), p1 (copy), v5 (ref), v32 (ref) ]]
		if p12.UserInputType == Enum.UserInputType.MouseButton2 then
			Network.FireServer("ToggleFav", p1:GetAttribute("GUID"))
		elseif p12.UserInputType == Enum.UserInputType.Touch and (not v5 and (v32 and tick() - v32 > 1)) then
			v32 = nil
			Network.FireServer("ToggleFav", p1:GetAttribute("GUID"))
		end
	end))
end
function MoveButtons() --[[ MoveButtons | Line: 280 | Upvalues: v2 (copy), UserInputService (copy), v6 (ref), v7 (ref), NewInventory (copy), v8 (ref), v5 (ref), v1 (copy), LocalPlayer (copy), v9 (ref), t4 (copy) ]]
	v2:Add(UserInputService.InputChanged:Connect(function(p1) --[[ Line: 281 | Upvalues: v6 (ref), v7 (ref), NewInventory (ref), v8 (ref), v5 (ref), v1 (ref) ]]
		if v6 then
			local v12 = v6
			if v7 and (tick() - v7 > 0.05 and NewInventory.InventoryFrame.Backpack.Visible) then
				if not v8 then
					v12.Active = false
					v8 = true
					v5 = true
					local v2 = (Vector2.new(v1.X, v1.Y) - v12.AbsolutePosition) / v12.AbsoluteSize
					v12.Size = UDim2.fromOffset(v12.AbsoluteSize.X, v12.AbsoluteSize.Y)
					v12.AnchorPoint = v2
					v12.Parent = NewInventory
				end
				v12.Position = UDim2.fromOffset(p1.Position.X, p1.Position.Y)
			end
		end
	end))
	v2:Add(UserInputService.InputEnded:Connect(function(p1) --[[ Line: 306 | Upvalues: v6 (ref), v7 (ref), v8 (ref), v5 (ref), LocalPlayer (ref), v9 (ref), NewInventory (ref), t4 (ref) ]]
		if v6 and v7 then
			local v1 = v6
			if if p1.UserInputType == Enum.UserInputType.Touch then true elseif p1.UserInputType == Enum.UserInputType.MouseButton1 then true else false then
				v7 = nil
				v6 = nil
				if not v8 then
					return
				end
				v8 = false
				v5 = false
				local v3 = LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(p1.Position.X, p1.Position.Y)
				if #v3 == 0 then
					v1.Parent = v9
					DefaultButton(v1)
					v1.Active = true
					return
				end
				local list = {}
				for i, v in ipairs(v3) do
					if v.Parent == NewInventory.InventoryFrame.Slots or v == NewInventory.InventoryFrame.Backpack.Items then
						table.insert(list, v)
					end
				end
				local v4 = nil
				for i, v in ipairs(list) do
					if v.Name:match("Slot") then
						local Button = v:FindFirstChild("Button")
						if Button then
							local v52 = t4.ButtonToTool[Button]
							if v52 and v52:HasTag("SquatTool") then
								continue
							end
							Button.Parent = v9
						end
						v4 = true
						v1.Parent = v
						DefaultButton(v1)
						v1.Active = true
						v9 = v
					end
				end
				if v4 then
					return
				end
				if table.find(list, NewInventory.InventoryFrame.Backpack.Items) then
					v9 = NewInventory.InventoryFrame.Backpack.Items
				end
				v1.Parent = v9
				DefaultButton(v1)
				v1.Active = true
			end
		end
	end))
	v2:Add(UserInputService.InputBegan:Connect(function(p1) --[[ Line: 374 | Upvalues: v6 (ref), LocalPlayer (ref), NewInventory (ref) ]]
		if if p1.UserInputType == Enum.UserInputType.Touch or p1.UserInputType == Enum.UserInputType.MouseButton1 then true elseif p1.KeyCode == Enum.KeyCode.ButtonB then true else false and not v6 then
			if p1.Position.Y < 0 then
				return
			end
			local t = {}
			for i, v in ipairs((LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(p1.Position.X, p1.Position.Y))) do
				if v:IsDescendantOf(NewInventory) then
					table.insert(t, v)
				end
			end
			if #t ~= 0 then
				return
			end
			NewInventory.InventoryFrame.Backpack.Visible = false
		end
	end))
end
function GetFreeSlot() --[[ GetFreeSlot | Line: 397 | Upvalues: v4 (ref), NewInventory (copy) ]]
	for i = 1, v4 do
		local v1 = NewInventory.InventoryFrame.Slots:FindFirstChild((("Slot%*"):format(i)))
		if v1 and not v1:FindFirstChild("Button") then
			return v1
		end
	end
end
function AddToBackpack(p1) --[[ AddToBackpack | Line: 406 | Upvalues: NewInventory (copy) ]]
	local v1 = GetFreeSlot()
	if p1:HasTag("SquatTool") then
		local Slot1 = NewInventory.InventoryFrame.Slots:FindFirstChild("Slot1")
		if Slot1 then
			if Slot1:FindFirstChild("Button") then
				local Button = Slot1:FindFirstChild("Button")
				Button.Parent = GetFreeSlot() or NewInventory.InventoryFrame.Backpack.Items
			end
			v1 = Slot1
		end
	end
	local v3 = InitButton
	v3(p1, if v1 then v1 else NewInventory.InventoryFrame.Backpack.Items)
end
function InitSlotsBehavior() --[[ InitSlotsBehavior | Line: 423 | Upvalues: NewInventory (copy) ]]
	for i, v in ipairs(NewInventory.InventoryFrame.Slots:GetChildren()) do
		if v.Name:match("Slot") then
			v.ChildRemoved:Connect(function() --[[ Line: 426 | Upvalues: v (copy), NewInventory (ref) ]]
				v.BackgroundTransparency = 0.5
				if NewInventory.InventoryFrame.Backpack.Visible then
					v.Visible = true
				else
					v.Visible = false
				end
			end)
			v.ChildAdded:Connect(function() --[[ Line: 435 | Upvalues: v (copy) ]]
				v.BackgroundTransparency = 1
				v.Visible = true
			end)
		end
	end
end
function ShowCategory(p1) --[[ ShowCategory | Line: 443 | Upvalues: t3 (copy), v11 (ref), NewInventory (copy) ]]
	if t3[p1] then
		v11 = p1
		NewInventory.InventoryFrame.Backpack.TitleLabel.Text = if p1 == "All" then "All Items" else p1
		SearchText(NewInventory.InventoryFrame.Backpack.SearchBox.Text)
	end
end
function InitOptions() --[[ InitOptions | Line: 455 | Upvalues: t3 (copy), t2 (copy), NewInventory (copy), ReplicatedStorage (copy) ]]
	for k in pairs(t3) do
		if k ~= "All" then
			local v1 = table.find(t2, k) or 9
			local v2 = NewInventory.InventoryFrame.Backpack.Options.All:Clone()
			v2.Name = k
			v2.Text = k
			v2.LayoutOrder = v1
			v2.Parent = NewInventory.InventoryFrame.Backpack.Options
		end
	end
	local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
	for k in pairs(EntitiesData.Brainrots) do
		t3.Brainrots[k] = true
	end
	for k in pairs(EntitiesData.LuckyBlocks) do
		t3["Lucky Blocks"][k] = true
	end
	for i, v in ipairs(NewInventory.InventoryFrame.Backpack.Options:GetChildren()) do
		if v:IsA("GuiButton") then
			local v3 = v.Name
			v.Activated:Connect(function() --[[ Line: 485 | Upvalues: v3 (copy) ]]
				ShowCategory(v3)
			end)
		end
	end
	ShowCategory("All")
end
function InitInputConnections() --[[ InitInputConnections | Line: 494 | Upvalues: t4 (copy), UserInputService (copy), NewInventory (copy), LocalPlayer (copy), v4 (ref) ]]
	script:WaitForChild("ToggleBackpack").Pressed:Connect(t4.ToggleBackpack)
	UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 498 | Upvalues: t4 (ref), UserInputService (ref), NewInventory (ref), LocalPlayer (ref), v4 (ref) ]]
		if t4.Enabled then
			if not p2 and p1.UserInputType == Enum.UserInputType.Keyboard then
				local v2 = tonumber((UserInputService:GetStringForKeyCode(p1.KeyCode)))
				if not v2 then
					return
				end
				local v3 = NewInventory.InventoryFrame.Slots:FindFirstChild((("Slot%*"):format(v2)))
				if v3 and v3:FindFirstChild("Button") then
					ToggleTool(t4.ButtonToTool[v3.Button])
				end
			elseif not p2 then
				if p1.UserInputType ~= Enum.UserInputType.Gamepad1 then
					return
				end
				local v42 = if p1.KeyCode == Enum.KeyCode.ButtonR1 then 1 elseif p1.KeyCode == Enum.KeyCode.ButtonL1 then -1 else false
				if v42 then
					local v5 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
					local v6 = 0
					if v5 then
						local v7 = t4.Backpack[v5] and t4.Backpack[v5].Button
						local v8 = if v7 then v7.Parent else v7
						if v8 then
							local v10 = tonumber((v8.Name:gsub("Slot", "")))
							if v10 then
								v6 = v10
							end
						end
					end
					local v11, v12, v13, v14
					if v6 == 0 or v6 == 1 then
						if v42 == -1 then
							v11 = 10
						else
							v11 = v6
							if v6 == 9 and v42 == 1 then
								v11 = 0
							end
						end
						v12 = if v42 == -1 then 1 else v4 + 9
						for i = v11 + v42, v12, v42 do
							v13 = NewInventory.InventoryFrame.Slots:FindFirstChild((("Slot%*"):format(i % 9)))
							if v13 and v13:FindFirstChild("Button") then
								v14 = t4.ButtonToTool[v13.Button]
								ToggleTool(v14)
								return
							end
						end
						return
					end
					if v6 == 9 and v42 == 1 then
						v11 = 0
					end
					v12 = if v42 == -1 then 1 else v4 + 9
					for i = v11 + v42, v12, v42 do
						v13 = NewInventory.InventoryFrame.Slots:FindFirstChild((("Slot%*"):format(i % 9)))
						if v13 and v13:FindFirstChild("Button") then
							v14 = t4.ButtonToTool[v13.Button]
							ToggleTool(v14)
							return
						end
					end
				end
			end
		end
	end)
end
function RemoveDefaultBackpack() --[[ RemoveDefaultBackpack | Line: 566 ]]
	local v1, _ = pcall(function() --[[ Line: 567 ]]
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	end)
	if not v1 then
		repeat
			task.wait(3)
			local v2, _2 = pcall(function() --[[ Line: 573 ]]
				game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			end)
		until v2
	end
end
function SearchText(p1) --[[ SearchText | Line: 580 | Upvalues: v12 (ref), v13 (copy) ]]
	local v1 = p1:lower():gsub(" ", "")
	v12 = v1
	v13:Fire(v1)
end
function InitSearchBar() --[[ InitSearchBar | Line: 587 | Upvalues: NewInventory (copy) ]]
	local SearchBox = NewInventory.InventoryFrame.Backpack.SearchBox
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 589 | Upvalues: SearchBox (copy) ]]
		SearchText(SearchBox.Text)
	end)
end
function BackpackToggled() --[[ BackpackToggled | Line: 594 | Upvalues: NewInventory (copy), ClientProfile (copy), GuiService (copy), v4 (ref), v2 (copy) ]]
	local Visible = NewInventory.InventoryFrame.Backpack.Visible
	if Visible and ClientProfile.Device == ClientProfile.DeviceTypes.Console then
		GuiService.SelectedObject = NewInventory.InventoryFrame.Backpack.Items:FindFirstChild("Button")
	elseif not Visible then
		GuiService.SelectedObject = nil
	end
	for i = 1, v4 do
		local v1 = NewInventory.InventoryFrame.Slots:FindFirstChild((("Slot%*"):format(i)))
		if v1 and not v1:FindFirstChild("Button") then
			v1.Visible = Visible
		end
	end
	if Visible then
		MoveButtons()
	else
		v2:Clean()
	end
end
function CheckDevice() --[[ CheckDevice | Line: 617 | Upvalues: t (copy), ClientProfile (copy), NewInventory (copy), v10 (ref), v4 (ref) ]]
	local v1 = t[ClientProfile.Device]
	if v1 then
		NewInventory.InventoryFrame.Size = v1.Result
		v10 = v1.HideNums
		v4 = v1.Slots
	end
end
function ListenToTools(p1) --[[ ListenToTools | Line: 626 | Upvalues: v3 (copy), LocalPlayer (copy) ]]
	if p1 then
		v3:Clean()
		LoadInventory()
		v3:Add(LocalPlayer.Backpack.ChildAdded:Connect(HandleNewItem))
		v3:Add(p1.ChildAdded:Connect(HandleNewItem))
	end
end
function InitBackpack() --[[ InitBackpack | Line: 639 ]]
	InitSlotsBehavior()
	InitSearchBar()
	InitInputConnections()
	InitOptions()
end
function t4.ToggleBackpack() --[[ ToggleBackpack | Line: 648 | Upvalues: v5 (ref), NewInventory (copy) ]]
	if not v5 then
		NewInventory.InventoryFrame.Backpack.Visible = not NewInventory.InventoryFrame.Backpack.Visible
	end
end
function t4.GetButton(p1, p2) --[[ GetButton | Line: 655 ]]
	return p1.Backpack[p2] and p1.Backpack[p2].Button
end
function t4.Disable(p1) --[[ Disable | Line: 659 | Upvalues: LocalPlayer (copy), NewInventory (copy) ]]
	if p1.Enabled then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
			local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
			if Humanoid then
				Humanoid:UnequipTools()
			end
		end
		p1.Enabled = false
		NewInventory.Enabled = false
	end
end
function t4.Enable(p1) --[[ Enable | Line: 675 | Upvalues: NewInventory (copy) ]]
	if not p1.Enabled then
		p1.Enabled = true
		NewInventory.Enabled = true
	end
end
function t4._init(p1) --[[ _init | Line: 686 | Upvalues: NewInventory (copy), LocalPlayer (copy), ClientProfile (copy) ]]
	RemoveDefaultBackpack()
	CheckDevice()
	InitBackpack()
	NewInventory.Parent = LocalPlayer.PlayerGui
	if LocalPlayer.Character then
		ListenToTools(LocalPlayer.Character)
	end
	ClientProfile.DeviceChanged:Connect(CheckDevice)
	LocalPlayer.CharacterAdded:Connect(ListenToTools)
	NewInventory.InventoryFrame.Backpack:GetPropertyChangedSignal("Visible"):Connect(BackpackToggled)
end
return t4