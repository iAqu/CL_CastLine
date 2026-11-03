-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Types.Modifiers)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
require(ReplicatedStorage.Modules.Util.TableUtil)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Modules.ToolTip)
local Renderer = require(script.Parent.TradeController.Renderer)
local InventoryPagination = require(ReplicatedStorage.Controllers.InventoryController.InventoryPagination)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local Definitions = require(script.Definitions)
local LocalPlayer = game:GetService("Players").LocalPlayer
local TradeIndex = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeIndex")
local Selected = TradeIndex.Index.Content.Selected
local Tabs = TradeIndex.Index.Content.Tabs
local Bottom = TradeIndex.Index.Content.Index.Bottom
local Index = TradeIndex.Index.Content.Index.Index
local v1 = nil
local v2 = nil
local v3 = nil
local v4 = nil
local v5 = false
local v6 = false
local v7 = nil
local v8 = Renderer.new(LocalPlayer, nil, Index, false, true)
local function PageChanged(p1) --[[ PageChanged | Line: 47 | Upvalues: Index (copy) ]]
	Index.CanvasSize = UDim2.new(0, 0, 0, Index.UIGridLayout.AbsoluteContentSize.Y + 10)
	if not p1 then
		return
	end
	task.wait()
	Index.CanvasPosition = Vector2.new(0, 0, 0, 0)
end
v8.FilterChanged:Connect(function() --[[ Line: 56 | Upvalues: Index (copy) ]]
	Index.CanvasSize = UDim2.new(0, 0, 0, Index.UIGridLayout.AbsoluteContentSize.Y + 10)
	task.wait()
	Index.CanvasPosition = Vector2.new(0, 0, 0, 0)
end)
local function UpdateCategoryTabs() --[[ UpdateCategoryTabs | Line: 61 | Upvalues: Tabs (copy), v2 (ref), Definitions (copy) ]]
	for v1, v22 in Tabs:GetChildren() do
		if v22:IsA("ImageButton") then
			v22.UIGradient.Color = v22.Name == v2 and Definitions.BUTTON_GRADIENTS.Selected or Definitions.BUTTON_GRADIENTS.Default
		end
	end
end
local function UpdateSortOptions() --[[ UpdateSortOptions | Line: 68 | Upvalues: Bottom (copy), v1 (ref), Definitions (copy) ]]
	for v12, v2 in Bottom.SortOptions:GetChildren() do
		if v2:IsA("ImageButton") then
			v2.UIGradient.Color = v2.Name == v1 and Definitions.BUTTON_GRADIENTS.Selected or Definitions.BUTTON_GRADIENTS.Default
		end
	end
end
local function Clear(p1, p2) --[[ Clear | Line: 75 ]]
	if not p2 then
		p1:ClearAllChildren()
		return
	end
	for v1, v2 in p1:GetChildren() do
		if v2:IsA(p2) then
			v2:Destroy()
		end
	end
end
local t = {}
local function f9(p1, p2) --[[ Line: 90 | Upvalues: v8 (copy), t (copy) ]]
	local v1 = v8:Draw(p1.Category, p1.Item.Id, p1.Item, p1.LayoutOrder)
	if v1 then
		v8:AddInteractionFromTile(v1.Tile, function() --[[ Line: 94 | Upvalues: t (ref), p1 (copy) ]]
			t:Display(p1.Item)
		end)
	end
end
function t.Display(p1, p2) --[[ Display | Line: 99 | Upvalues: Bottom (copy), Index (copy), Selected (copy), GuiControl (copy), RAPController (copy), v2 (ref), Replion (copy), PlayerStatsUtility (copy) ]]
	Bottom.Visible = false
	Index.Visible = false
	local v1 = nil
	local function Reset() --[[ Reset | Line: 105 | Upvalues: v1 (ref), Bottom (ref), Index (ref), Selected (ref) ]]
		if v1 then
			v1:Destroy()
		end
		Bottom.Visible = true
		Index.Visible = true
		Selected.Visible = false
	end
	v1 = GuiControl:Hook("Hold Button", Selected.Back).Clicked:Connect(Reset)
	Selected.ItemIcon.Image = p2.Icon
	Selected.ItemIcon.ItemName.Text = p2.Name
	Selected.Description.Text = p2.Description
	task.defer(function() --[[ Line: 119 | Upvalues: Selected (ref), RAPController (ref), v2 (ref), p2 (copy) ]]
		Selected.Rap.Coins.Text = RAPController:GetRAP(v2, p2.Id) or "???"
	end)
	local v22 = Replion.Client:GetReplion("Data")
	if v22 and not v22.Destroyed then
		local v4 = PlayerStatsUtility:GetItemFromInventory(v22, function(p1) --[[ Line: 126 | Upvalues: p2 (copy) ]]
			return p1.Id == p2.Id
		end, if v2 == "Fish" then "Items" else v2) ~= nil
		Selected.Owned.Text = if v4 then "Owned" else "Missing"
		Selected.Owned.TextColor3 = v4 and Color3.fromRGB(61, 232, 82) or Color3.fromRGB(255, 28, 28)
	end
	Selected.Visible = true
end
function t.Build(p1) --[[ Build | Line: 137 | Upvalues: v7 (ref), InventoryPagination (copy), Index (copy), PageChanged (copy), Clear (copy), v8 (copy), ItemUtility (copy), v2 (ref), Definitions (copy), v1 (ref), v5 (ref), f9 (copy), Bottom (copy) ]]
	if v7 then
		v7:Reset()
	else
		v7 = InventoryPagination.new(Index, {
			ItemsPerPage = 15,
			OnPageLoaded = PageChanged
		})
	end
	Clear(Index, "ImageButton")
	v8:DestroyTiles()
	local list = {}
	local v12 = ItemUtility.GetAllItems()[v2]
	if v12 then
		for i, v in ipairs(v12) do
			if not v.TradeLocked then
				table.insert(list, {
					Item = v.Data,
					Category = v2,
					LayoutOrder = v8:GetLayoutOrder({
						Quantity = 1,
						Timestamp = nil,
						Metadata = nil,
						Favorited = nil,
						TradeLock = nil,
						UUID = ("%*-%*"):format(v2, v.Data.Id),
						Id = v.Data.Id
					}, v)
				})
			end
		end
	end
	if not (list and #list > 0) then
		warn("No entries")
		return
	end
	table.sort(list, Definitions.SORT_FUNCS[v1](v5))
	for i, v in ipairs(list) do
		v.LayoutOrder = i
	end
	v7:SetItems(list)
	if v7:GetTotalItems() > 0 then
		v7:LoadNextPage(f9)
		v7:StartScrollMonitoring(f9)
	end
	v8:SetFilter(v2, Bottom.Search.TextBox.Text)
end
function t.Start(p1) --[[ Start | Line: 197 | Upvalues: UserPriority (copy), TradeIndex (copy), Tabs (copy), Bottom (copy), v3 (ref), v4 (ref), TradeData (copy), Definitions (copy), GuiControl (copy), v2 (ref), UpdateCategoryTabs (copy), t (copy), v1 (ref), v5 (ref), UpdateSortOptions (copy), TweenService (copy), v6 (ref), v8 (copy) ]]
	if not UserPriority:IsTradePlaza() then
		TradeIndex:Destroy()
		return
	end
	local TabTemplate = Tabs:FindFirstChild("TabTemplate")
	assert(TabTemplate, "[Trade Index]: Failed to find a template for categories button!")
	local SortTemplate = Bottom.SortOptions:FindFirstChild("SortTemplate")
	assert(SortTemplate, "[Trade Index]: Failed to find a template for sort button!")
	v3 = Tabs.TabTemplate
	v3.Parent = nil
	v4 = Bottom.SortOptions.SortTemplate
	v4.Parent = nil
	for i, v in ipairs(TradeData.TradableItemTypes) do
		local v12 = v3:Clone()
		v12.Name = v
		v12.LayoutOrder = i
		v12.Label.Text = Definitions.ABBR_TYPE[v] and Definitions.ABBR_TYPE[v] or v
		v12.UIGradient.Color = Definitions.BUTTON_GRADIENTS.Default
		GuiControl:Hook("Hold Button", v12).Clicked:Connect(function() --[[ Line: 222 | Upvalues: v2 (ref), v12 (copy), UpdateCategoryTabs (ref), t (ref) ]]
			if v2 ~= v12.Name then
				v2 = v12.Name
				UpdateCategoryTabs()
				t:Build()
			end
		end)
		v12.Parent = Tabs
	end
	for i, v in ipairs(Definitions.SORT_OPTIONS) do
		local v32 = v4:Clone()
		v32.Name = v
		v32.Label.Text = v
		v32.UIGradient.Color = Definitions.BUTTON_GRADIENTS.Default
		GuiControl:Hook("Hold Button", v32).Clicked:Connect(function() --[[ Line: 240 | Upvalues: v1 (ref), v32 (copy), v5 (ref), t (ref), v (copy), UpdateSortOptions (ref) ]]
			if v1 == v32.Name then
				v5 = not v5
			else
				v1 = v
				v5 = false
				UpdateSortOptions()
			end
			t:Build()
		end)
		v32.Parent = Bottom.SortOptions
		if v == "RAP" then
			v32.Visible = workspace:GetAttribute("RAPLoaded") == true
			if not workspace:GetAttribute("RAPLoaded") then
				workspace:GetAttributeChangedSignal("RAPLoaded"):Once(function() --[[ Line: 259 | Upvalues: v32 (copy) ]]
					v32.Visible = true
				end)
			end
		end
	end
	GuiControl:Hook("Hold Button", Bottom.Sort).Clicked:Connect(function() --[[ Line: 266 | Upvalues: TweenService (ref), Bottom (ref), v6 (ref) ]]
		local v2 = TweenInfo.new(0.2)
		local t = {}
		t.Rotation = if v6 then 0 else 180
		TweenService:Create(Bottom.Sort.Arrow, v2, t):Play()
		v6 = not v6
		Bottom.SortOptions.Visible = v6
	end)
	Bottom.Search.TextBox.FocusLost:Connect(function(p1, p2) --[[ Line: 272 | Upvalues: Bottom (ref), v8 (ref), v2 (ref) ]]
		if not p1 and (Bottom.Search.TextBox.Text ~= "" and Bottom.Search.TextBox.Text ~= " ") then
			return
		end
		v8:SetFilter(v2, Bottom.Search.TextBox.Text)
	end)
	v2 = "Fish"
	v1 = "Default"
	Tabs[v2].UIGradient.Color = Definitions.BUTTON_GRADIENTS.Selected
	Bottom.SortOptions[v1].UIGradient.Color = Definitions.BUTTON_GRADIENTS.Selected
	t:Build()
end
return t