-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetIconShape = require(ReplicatedStorage.Client.UI.AssetIconShape)

require(ReplicatedStorage.Shared.Types.AssetItem)

local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local GridCellFitter = require(ReplicatedStorage.Client.GridCellFitter)
local Directory = require(ReplicatedStorage.Data.Assets).Directory
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local FuseKernel = require(ReplicatedStorage.Shared.Util.FuseKernel)

require(ReplicatedStorage.Shared.Types.FuseMachine)

local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local Log = require(ReplicatedStorage.Packages.Log)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)

require(ReplicatedStorage.Shared.Save)

local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "FuseMachineBackpackSelection"

local v2 = UDim2.fromScale(0.02, 0.04)
local GUI = ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("GUI")

assert(GUI:IsA("Folder"), "Controllers.GUI must be a Folder")

local Main = GUI.BackpackController.Main

assert(Main:IsA("ModuleScript"), "BackpackController.Main must be a ModuleScript")

local InventoryTemplate = Main.InventoryTemplate

assert(InventoryTemplate:IsA("GuiButton"), "BackpackController.Main.InventoryTemplate must be a GuiButton")

function t1.new(p1) -- line: 66
    -- upvalues: GridCellFitter (copy), Trove (copy), t1 (copy), v2 (copy)
    local self = setmetatable({}, t1)

    self._active = false
    self._rows = Trove.new()
    self._scrollingFrame = p1
    self._trove = Trove.new()
    self._columns = 5

    local UIGridLayout = p1:FindFirstChildOfClass("UIGridLayout")

    assert(UIGridLayout, "Fuse picker needs a grid layout")
    self._refitGrid = GridCellFitter.Fit(UIGridLayout, self._columns, v2)
    p1.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p1.ScrollingDirection = Enum.ScrollingDirection.Y

    for _, child in p1:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    self._trove:Add(self._rows)
    self._trove:Connect(UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function() -- line: 90
        -- upvalues: self (copy)
        if self._active then
            self._refitGrid()
        end
    end)

    return self
end

local function getConfig(p2) -- line: 103
    -- upvalues: Directory (copy)
    local v4 = Directory[p2.Category]

    assert(v4 ~= nil, (("Missing asset config %*"):format(p2.Category)))

    return v4
end

local function getOddsDenominator(p3) -- line: 109
    -- upvalues: Directory (copy), Mutations (copy)
    local v7 = Directory[p3.Category]

    assert(v7 ~= nil, (("Missing asset config %*"):format(p3.Category)))

    return 1 / v7.DropWeight * Mutations.RarityFactorFor(p3.Mutations, p3.BaseMutation)
end

local function clearDirectGradients(p4) -- line: 120
    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy()
        end
    end
end

local function sortLikeBackpack(p5, p6, p7, p8) -- line: 128
    -- upvalues: AssetEarnings (copy), AssetItems (copy), Directory (copy), Mutations (copy)
    local v10 = Directory[p5.Category]

    assert(v10 ~= nil, (("Missing asset config %*"):format(p5.Category)))

    local v13 = Directory[p7.Category]

    assert(v13 ~= nil, (("Missing asset config %*"):format(p7.Category)))

    local Rank = v10.Rarity.Rank
    local Rank2 = v13.Rarity.Rank

    if Rank ~= Rank2 then
        return Rank2 < Rank
    end

    local v16 = AssetEarnings.MutationOnlyRatePerSecond(p5)
    local v17 = AssetEarnings.MutationOnlyRatePerSecond(p7)

    if v16 ~= v17 then
        return v17 < v16
    end

    local v18 = Directory[p5.Category]

    assert(v18 ~= nil, (("Missing asset config %*"):format(p5.Category)))

    local v21 = 1 / v18.DropWeight * Mutations.RarityFactorFor(p5.Mutations, p5.BaseMutation)
    local v22 = Directory[p7.Category]

    assert(v22 ~= nil, (("Missing asset config %*"):format(p7.Category)))

    local v25 = 1 / v22.DropWeight * Mutations.RarityFactorFor(p7.Mutations, p7.BaseMutation)

    if v21 ~= v25 then
        return v25 < v21
    end

    if v10.DropWeight ~= v13.DropWeight then
        return v10.DropWeight < v13.DropWeight
    end

    local v26 = AssetItems.WeightKg(p5)
    local v27 = AssetItems.WeightKg(p7)

    if v26 == v27 then
        return p6 < p8
    end

    return v27 < v26
end

function t1:_createRow(p10, p11, p12, p13) -- line: 167
    -- upvalues: AssetIconShape (copy), AssetItems (copy), Directory (copy), ButtonFX (copy), ItemDisplay (copy), InventoryTemplate (copy), clearDirectGradients (copy)
    local clone = InventoryTemplate:Clone()

    clone.Name = ("FuseSelection.%*"):format(p10)
    clone.LayoutOrder = p12
    clone:SetAttribute("IsInventorySlot", true)
    clone.Active = true
    clone.AutoButtonColor = false
    clone.BackgroundColor3 = Color3.new(0, 0, 0)
    clone.BackgroundTransparency = 0.5

    local UIStroke = clone.UIStroke

    assert(UIStroke:IsA("UIStroke"), "Fuse inventory row requires UIStroke")
    UIStroke.Thickness = 0
    clone.Visible = true
    clone.Parent = self._scrollingFrame
    self._rows:Add(clone)

    local BaseTemplate = clone.BaseTemplate
    local Amount = BaseTemplate.Amount

    assert(Amount:IsA("TextLabel"), "Fuse inventory row Amount must be a TextLabel")
    Amount.Text = ""
    Amount.Visible = false

    local Mutations = BaseTemplate.Mutations

    assert(Mutations:IsA("GuiObject"), "Fuse inventory row Mutations must be a GuiObject")
    Mutations.Visible = false

    local Icon = clone.Icon

    assert(Icon:IsA("ImageLabel"), "Fuse inventory row Icon must be an ImageLabel")
    AssetIconShape.Paint(Icon, p11)
    Icon.ImageColor3 = Color3.new(1, 1, 1)

    local v28 = Directory[p11.Category]

    assert(v28 ~= nil, (("Missing asset config %*"):format(p11.Category)))

    local ToolName = clone.ToolName

    assert(ToolName:IsA("TextLabel"), "Fuse inventory row ToolName must be a TextLabel")
    clearDirectGradients(ToolName)
    v28.Rarity.RarityGradient:Clone().Parent = ToolName
    ToolName.Text = ("%* (%*)"):format(ItemDisplay.GetNameFromItemData(p11), (AssetItems.WeightLabel(p11)))
    ToolName.Visible = true

    local Shadow = clone.Shadow

    assert(Shadow:IsA("ImageLabel"), "Fuse inventory row Shadow must be an ImageLabel")
    clearDirectGradients(Shadow)
    v28.Rarity.RarityGradient:Clone().Parent = Shadow
    Shadow.Visible = true

    local FavIcon = clone.FavIcon

    assert(FavIcon:IsA("GuiObject"), "Fuse inventory row FavIcon must be a GuiObject")
    FavIcon.Visible = false

    local Weight = clone.Weight

    assert(Weight:IsA("GuiObject"), "Fuse inventory row Weight must be a GuiObject")
    Weight.Visible = false
    self._rows:Add(clone.Activated:Connect(function() -- line: 248
        -- upvalues: p10 (copy), p13 (copy)
        p13(p10)
    end))
    ButtonFX(clone, 1.015)
end

function t1:Open(p15, p16, p17, p18, p19) -- line: 258
    -- upvalues: AssetItems (copy), FuseKernel (copy), sortLikeBackpack (copy)
    if self._active then
        return 0
    end

    local t3 = {}
    local t4 = {}
    local t5 = {}

    for _, v31 in ipairs(p15.EquippedAssets) do
        t5[v31] = true
    end

    for v32, v33 in pairs(p15.Inventory) do
        if (not t5[v32] or p18 == true) and FuseKernel.MayEnterFuse(v32, v33, p16, false, p19) then
            table.insert(t3, v32)
            t4[v32] = AssetItems.Decode(v33)
        end
    end

    table.sort(t3, function(p20, p21) -- line: 293
        -- upvalues: t4 (copy), sortLikeBackpack (copy)
        return (sortLikeBackpack(assert(t4[p20], (("Missing Fuse selection item data for %*"):format(p20))), p20, assert(t4[p21], (("Missing Fuse selection item data for %*"):format(p21))), p21))
    end)
    self._active = true
    self._scrollingFrame.CanvasPosition = Vector2.zero

    for v39, v40 in ipairs(t3) do
        self:_createRow(v40, assert(t4[v40], (("Missing Fuse selection item data for %*"):format(v40))), v39, p17)
    end

    return #t3
end

function t1:Close() -- line: 324
    if self._active then
        self._rows:Clean()
        self._scrollingFrame.CanvasPosition = Vector2.zero
        self._active = false
    end
end

function t1:RefreshGridLayout() -- line: 336
    assert(self._active, "FuseMachine backpack selection must be open before refreshing its grid")

    local X = self._scrollingFrame.AbsoluteSize.X
    local v43 = self._scrollingFrame.AbsoluteSize.Y < 150

    if not (X < 420) or v43 then
        if X < 650 then
            self._columns = 4
        else
            self._columns = 5
        end
    else
        self._columns = 3
    end

    local UIGridLayout = self._scrollingFrame:FindFirstChildOfClass("UIGridLayout")

    assert(UIGridLayout, "Fuse picker needs a grid layout")
    UIGridLayout.FillDirectionMaxCells = self._columns
    self._refitGrid(self._columns)
end

function t1:IsOpen() -- line: 355
    return self._active
end

function t1:Destroy() -- line: 361
    -- upvalues: v1 (copy)
    self:Close()
    self._trove:Destroy()
    v1:AtTrace():Log("Destroyed FuseMachine backpack selection")
end

return t1
