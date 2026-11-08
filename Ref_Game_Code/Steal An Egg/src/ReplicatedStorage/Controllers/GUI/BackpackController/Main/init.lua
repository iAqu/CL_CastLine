-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local TextBox, v1, v2
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Areas = require(ReplicatedStorage.Data.Areas)
local GridCellFitter = require(ReplicatedStorage.Client.GridCellFitter)
local GUI = require(ReplicatedStorage.Client.GUI)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local InputIconsConfig = require(ReplicatedStorage.Client.InputIconsConfig)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local Tabs = require(ReplicatedStorage.Client.Tabs)

RarityDirectory = require(ReplicatedStorage.Data.Rarity).Rarities
MutationHandler = require(ReplicatedStorage.Shared.Modules.Mutations)
HoverCard = require(ReplicatedStorage.Client.HoverCard)

local PlatformController = require(ReplicatedStorage.Client.PlatformController)

ButtonHintStrip = require(ReplicatedStorage.Client.ButtonHintStrip)
ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
SimpleNumber = require(ReplicatedStorage.Packages.FormatNumber.Simple)

local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetIconShape = require(ReplicatedStorage.Client.UI.AssetIconShape)
local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)

require(ReplicatedStorage.Shared.Globals.Constants)

local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggSkins = require(ReplicatedStorage.Data.EggSkins)
local EggState = require(ReplicatedStorage.Client.EggState)
local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local WarmAssets = require(ReplicatedStorage.Shared.Utils.Preload).WarmAssets

require(ReplicatedStorage.Shared.Remotes)
require(ReplicatedStorage.Shared.Save)

local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local TreadmillFlags = require(ReplicatedStorage.Shared.Flags.TreadmillFlags)
local Trove = require(ReplicatedStorage.Packages.Trove)
local SlotDragController = require(script.SlotDragController)
local SlotFavoriteController = require(script.SlotFavoriteController)
local HotbarDragFeedback = require(script.HotbarDragFeedback)
local t1 = {
    {
        Name = "Pets",
        Image = "rbxassetid://93714449004895",
        Tags = { "Asset", "Phone" }
    },
    {
        Name = "Eggs",
        Image = "rbxassetid://116524274262912",
        Tags = { "AssetEgg", "PetEgg" }
    },
    {
        Name = "Gear",
        Image = "rbxassetid://78687042850233",
        Tags = { "Gear", "MutationConsumable", "MountStar", "MonsterChest", "ButterflyNet", "TrainPass" }
    }
}
local Name = t1[1] and t1[1].Name or "Pets"
local v3 = Name
local SetCategory
local t2 = {}

for _, v4 in t1 do
    t2[v4.Name] = v4
end

function IsOfCategory(p1) -- line: 96
    -- upvalues: v3 (ref), t2 (copy)
    if not p1 then
        return false
    end

    local v5 = t2[v3]

    if v5 and v5.Tags then
        for _, v6 in v5.Tags do
            if p1:GetAttribute("ItemType") == v6 then
                return true
            end
        end
    end

    return false
end

function GetCategory(p2) -- line: 112
    -- upvalues: Name (copy), t2 (copy)
    for v7, v8 in t2 do
        if v8.Tags then
            for _, v9 in v8.Tags do
                if p2:GetAttribute("ItemType") == v9 then
                    return v7
                end
            end
        end
    end

    return Name
end

function HasInventoryCategory(p3) -- line: 126
    -- upvalues: t2 (copy)
    local ItemType = getAttribute(p3, "ItemType")

    if ItemType ~= nil then
        for _, v10 in t2 do
            if v10.Tags then
                for _, v11 in v10.Tags do
                    if ItemType == v11 then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local t3 = {
    OpenClose = nil,
    IsOpen = false,
    ModuleName = "Backpack",
    KeepVRTopbarOpen = true,
    VRIsExclusive = true,
    VRClosesNonExclusive = true,
    StartFuseSelection = nil,
    EndFuseSelection = nil,
    IsFuseSelectionActive = nil,
    StateChanged = Instance.new("BindableEvent")
}
local n1 = 60

TextSizeAttribute = script:GetAttribute("TextSize")
_BackgroundTransparencyAttribute = script:GetAttribute("BackgroundTransparency")
BackgroundColorAttribute = script:GetAttribute("BackgroundColor")
DraggableColorAttribute = script:GetAttribute("DraggableColor")
EquippedColorAttribute = script:GetAttribute("EquippedColor")
SlotLockedTransparencyAttribute = script:GetAttribute("SlotLockedTransparency")
BorderColorAttribute = script:GetAttribute("BorderColor")
ToggleHotkeys = {
    Enum.KeyCode.Backquote,
    Enum.KeyCode.ButtonSelect
}
EmptySlotsAttribute = script:GetAttribute("EmptySlots")
_SearchBoxColorAttribute = script:GetAttribute("SearchBoxColor")
_SearchBoxTransparencyAttribute = script:GetAttribute("SearchBoxTransparency")
ApiEvent = ReplicatedStorage:FindFirstChild("Api") or script:WaitForChild("Api")
ApiEvent.Parent = ReplicatedStorage
SelectedSlot = nil
BackpackEnabled = true

local t4

ActiveFuseSelectionState = nil

function GetViewportSize() -- line: 199
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
    local Frame = Instance.new("Frame", ScreenGui)

    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1, 0, 1, 0)

    local AbsoluteSize = Frame.AbsoluteSize

    ScreenGui:Destroy()

    return AbsoluteSize
end

local Value = Enum.KeyCode.Zero.Value
local Value2 = Enum.KeyCode.Backspace.Value
local t5 = {
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
}

UserInputService = game:GetService("UserInputService")
Players = game:GetService("Players")
PlayerGui = Players.LocalPlayer.PlayerGui
BackpackGui = PlayerGui:WaitForChild("BackpackGui")
ContextActionService = game:GetService("ContextActionService")
VRService = game:GetService("VRService")
Utility = require(script.Utility)
require(script.GameTranslator)
TopBarPlus = require(ReplicatedStorage.Packages.TopBarPlus)

local function tryCore(p4, ...) -- line: 231
    -- upvalues: StarterGui (copy)
    local n2 = 0.03
    local v12

    for i = 1, 5 do
        local pack = table.pack
        local v13 = StarterGui[p4]
        local v14 = pack(pcall(v13, StarterGui, ...))

        if v14[1] == true then
            return true, table.unpack(v14, 2, v14.n)
        end

        v12 = v14[2]

        if i < 5 then
            task.wait(n2)
            n2 *= 2
        end
    end

    return false, v12
end

local Save = require(ReplicatedStorage.Shared.Save)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local AssetItems2 = require(ReplicatedStorage.Shared.Util.AssetItems)

AssetDirectoryModule = require(ReplicatedStorage.Data.Assets)
AssetDirectory = AssetDirectoryModule.Directory
BaseAssetConfig = AssetDirectoryModule.BaseConfig

local Gears = require(ReplicatedStorage.Data.Gears)

TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
Audio = require(ReplicatedStorage.Shared.Audio)

local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local v15
local v16 = false

CloseButton = nil
InventoryStroke = nil
InventoryStrokeDefaultColor = nil
FuseSelectionVisualTrove = nil
FUSE_SELECTION_ASSET_CATEGORY_NAME = "Pets"
FUSE_SELECTION_BACKGROUND_COLOR = Color3.fromRGB(0, 255, 255)
FUSE_SELECTION_STROKE_COLOR = Color3.fromRGB(0, 183, 186)
FUSE_SELECTION_BACKGROUND_TRANSPARENCY = 0

local v17

local function isBackpackEquipInteractionBlocked() -- line: 272
    -- upvalues: HiddenUIHandler (copy)
    return not BackpackEnabled or not BackpackGui.Enabled or HiddenUIHandler.IsHidden()
end

local v18 = GuiService:IsTenFootInterface()
local v19 = 60

if v18 then
    n1 = 100
    TextSizeAttribute = 24
    v19 = 100
end

local v20 = false
local v21 = GetViewportSize()
local v22 = UserInputService.TouchEnabled and v21.X < 1024
local v23 = v19 * 1.5
local LocalPlayer = Players.LocalPlayer
local LocalPlayer2 = LocalPlayer
local Backpack, Main, v24, Inventory
local v25 = Color3.fromRGB(79, 63, 0)
local v26, ScrollingFrame, UIGridLayout, v27, v28, v29, AspectRatio, v30, v31, v32, PaddingLeft, UIPadding, v33

v33 = if v22 then 5 else 6

local v34 = UDim2.fromScale(0.02, 0.04)
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local v35 = Character
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local Backpack2 = LocalPlayer:WaitForChild("Backpack")
local v36 = TopBarPlus.new()

v36:setImage("rbxasset://textures/ui/TopBar/inventoryOff.png", "deselected")
v36:setImage("rbxasset://textures/ui/TopBar/inventoryOn.png", "selected")

for _, v37 in ToggleHotkeys do
    v36:bindToggleKey(v37)
end

v36:setName("InventoryIcon")
v36:setImageScale(1.12)
v36:setOrder(-5)
v36:setCaption("Toggle the backpack.")
v36.deselectWhenOtherIconSelected = false

local t6 = {}
local v38
local t7 = {}
local t8 = {}
local t9 = {}
local n3 = 0
local v39 = false
local v40 = false
local v41 = false
local v42 = false
local v43 = false
local v44 = false
local t10 = {}
local v45 = false
local n4 = 0
local VREnabled = VRService.VREnabled
local _EmptySlotsAttribute = if VREnabled then EmptySlotsAttribute else nil

if not VREnabled or not _EmptySlotsAttribute then
    _EmptySlotsAttribute = if v22 then 5 else 10
end

local v46 = if VREnabled then 3 elseif v22 then 2 else 4
local v47 = TryLock()
local v48 = TryLock()
local v49 = SlotFavoriteController.new(BackpackGui)
local v50
local t11 = {}
local t12 = {}
local t13 = {}
local t14 = {}
local t15 = {}
local v51 = {}
local v52 = false
local t16 = {}
local t17 = {}
local t18 = {}
local t19 = {}
local v53 = {}
local v54 = false
local v55, AutoSell, EquipBest, clone
local v56 = TryLock()
local n5 = 0
local v57 = false
local v58 = false
local v59 = true
local v60 = false
local v61 = false
local n6 = 0
local Frame = GUI.AutoSell():WaitForChild("Frame"):WaitForChild("Frame")
local t20 = {}
local t21 = {}
local v62 = false
local Template = Frame.UIGridLayout.Template
local v63

function invokeBackpack(p5, ...) -- line: 396
    local t22 = { ... }

    local function v64() -- line: 398
        -- upvalues: p5 (copy), t22 (copy)
        return { p5:InvokeServer(unpack(t22)) }
    end

    local ok, result = pcall(v64)

    if ok then
        return result
    end

    warn((("[Backpack] Failed to invoke '%*': %*"):format(p5 and p5.Name or "?", result)))

    return nil
end

function isLocalPlayerWithinOwnPlotBounds() -- line: 406
    -- upvalues: PlotState (copy), LocalPlayer2 (ref), v35 (ref)
    local v65 = PlotState.ResolvePlot()

    if v65 then
        local v66 = v35 or LocalPlayer2.Character

        if v66 then
            local HumanoidRootPart = v66:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                local BoundingBox, BoundingBox2 = v65.PlotFolder:GetBoundingBox()
                local v67 = BoundingBox:PointToObjectSpace(HumanoidRootPart.Position)
                local v68 = BoundingBox2 * 0.5

                if not (math.abs(v67.X) <= v68.X) then
                    return false
                end

                return math.abs(v67.Z) <= v68.Z
            end
        end
    end

    return false
end

function updateEquipBestButtonVisibility() -- line: 429
    -- upvalues: clone (ref)
    if clone then
        clone.Visible = false
    end
end

function requestEquipBestStatusRefresh(p6) -- line: 437
    -- upvalues: Remotes (copy), clone (ref), v57 (ref), v58 (ref), v59 (ref), v60 (ref), v61 (ref), n6 (ref)
    if not (clone and v61) then
        updateEquipBestButtonVisibility()
    elseif not v60 then
        local ServerTimeNow = workspace:GetServerTimeNow()

        if p6 == true or not (ServerTimeNow - n6 < 0.5) then
            n6 = ServerTimeNow
            v60 = true
            task.spawn(function() -- line: 457
                -- upvalues: Remotes (copy), v57 (ref), v58 (ref), v59 (ref), v60 (ref)
                local v69 = invokeBackpack(Remotes.Haul.FetchWearBestStatus)

                v60 = false

                if v69 then
                    v57 = v69[1] == true
                    v58 = true
                    v59 = false
                end

                updateEquipBestButtonVisibility()
            end)
        end
    end
end

function invalidateEquipBestStatus(p7) -- line: 473
    -- upvalues: v59 (ref), v61 (ref)
    v59 = true

    if v61 then
        requestEquipBestStatusRefresh(p7)
    else
        updateEquipBestButtonVisibility()
    end
end

function showEquipBestDebounceNotification() -- line: 482
    -- upvalues: Toast (copy)
    Toast.Show({
        Text = "Please wait a bit before equipping bests again!",
        Seconds = 2,
        Color = Color3.fromRGB(255, 170, 0)
    })
end

function requestEquipBest() -- line: 490
    -- upvalues: Remotes (copy), v56 (copy), n5 (ref)
    if workspace:GetServerTimeNow() - n5 < 5 or not v56(function() -- line: 497
        -- upvalues: Remotes (copy), n5 (ref)
        local ServerTimeNow = workspace:GetServerTimeNow()

        if ServerTimeNow - n5 < 5 then
            showEquipBestDebounceNotification()
        else
            n5 = ServerTimeNow

            local v70 = invokeBackpack(Remotes.Haul.WearBest)

            if v70 then
                local v71 = v70[1]
                local v72 = v70[2]

                if v71 then
                    invalidateEquipBestStatus(true)
                elseif v72 == "DEBOUNCE" or v72 == "LOCKED" then
                    showEquipBestDebounceNotification()
                end
            end
        end
    end) then
        showEquipBestDebounceNotification()
    end
end

function applyAutoSellSlot(p8, p9) -- line: 528
    -- upvalues: t20 (copy)
    local v73 = t20[p8]

    if not v73 then
        return
    end

    local SelectedGradient = v73.SelectedGradient

    if SelectedGradient then
        SelectedGradient.Enabled = p9
    end

    local RarityGradient = v73.RarityGradient

    if RarityGradient then
        RarityGradient.Enabled = not p9
    end
end

function applyAutoSellMap(p10) -- line: 545
    -- upvalues: t20 (copy), t21 (ref)
    t21 = {}

    for v74, v75 in pairs(p10) do
        if v75 then
            t21[v74] = true
        end
    end

    for v76 in pairs(t20) do
        applyAutoSellSlot(v76, t21[v76] == true)
    end
end

function serializeAutoSellState() -- line: 558
    -- upvalues: t21 (ref)
    local t24 = {}

    for v77, v78 in pairs(t21) do
        if v78 then
            t24[v77] = true
        end
    end

    return t24
end

function pushAutoSellState() -- line: 568
    -- upvalues: Remotes (copy)
    local v79 = serializeAutoSellState()
    local v80 = invokeBackpack(Remotes.Haul.WriteAutoSell, v79)

    if v80 then
        local v81 = v80[1]
        local v82 = v80[2]

        if v81 then
            if typeof(v82) == "table" then
                applyAutoSellMap(v82)
            end

            return true
        end

        if typeof(v82) == "string" then
            warn((("[Backpack] Failed to update auto-sell: %*"):format(v82)))
        end
    end

    return false
end

function buildAutoSellSlots(p11) -- line: 591
    -- upvalues: t20 (copy), t21 (ref), v62 (ref), Template (copy)
    local t25 = {}

    for _, v83 in pairs(AssetDirectory) do
        local Rarity = v83.Rarity

        if Rarity then
            local _id = Rarity._id

            if typeof(_id) == "string" then
                t25[_id] = Rarity
            end
        end
    end

    local t26 = {}

    for _, v84 in pairs(t25) do
        table.insert(t26, v84)
    end

    table.sort(t26, function(p12, p13) -- line: 608
        local Rank2 = typeof(p12.Rank) == "number" and p12.Rank or 0
        local Rank4 = typeof(p13.Rank) == "number" and p13.Rank or 0

        if Rank2 ~= Rank4 then
            return Rank2 < Rank4
        end

        return (typeof(p12.DisplayName) == "string" and p12.DisplayName or p12._id) < (typeof(p13.DisplayName) == "string" and p13.DisplayName or p13._id)
    end)

    for _, v85 in ipairs(t26) do
        local _id = v85._id

        if not t20[_id] then
            local clone = Template:Clone()

            clone.Visible = true
            clone.Name = _id
            clone.LayoutOrder = typeof(v85.Rank) == "number" and v85.Rank or 0

            local TextButton = clone.TextButton
            local Selected = TextButton.Selected

            if Selected and Selected:IsA("UIGradient") then
                Selected.Enabled = false
            else
                Selected = nil
            end

            local TextLabel = clone:FindFirstChild("TextLabel")

            if not (TextLabel and TextLabel:IsA("TextLabel")) then
                TextLabel = nil
            end

            if TextLabel then
                local DisplayName = v85.DisplayName

                if typeof(DisplayName) ~= "string" or DisplayName == "" then
                    TextLabel.Text = _id
                else
                    TextLabel.Text = DisplayName
                end
            end

            clone.Parent = p11

            local RarityGradient = v85.RarityGradient
            local clone2

            if typeof(RarityGradient) == "Instance" then
                clone2 = RarityGradient:Clone()
                clone2.Name = "RarityGradient"
                clone2.Parent = TextButton
            end

            for _, child in ipairs(TextButton:GetChildren()) do
                if child:IsA("UIGradient") then
                    if child == clone2 then
                        child.Enabled = true
                    else
                        child.Enabled = false
                    end
                end
            end

            t20[_id] = {
                Button = TextButton,
                SelectedGradient = Selected,
                RarityGradient = clone2
            }
            ButtonFX(TextButton, nil, function() -- line: 676
                -- upvalues: _id (copy), t21 (ref), v62 (ref)
                if v62 then
                    return
                end

                local v86 = t21[_id] == true
                local v87 = not v86

                t21[_id] = v87
                applyAutoSellSlot(_id, v87)
                v62 = true

                if not pushAutoSellState() then
                    t21[_id] = v86
                    applyAutoSellSlot(_id, v86)
                end

                v62 = false
            end)
        end
    end
end

function initializeAutoSellUI() -- line: 697
    -- upvalues: Tabs (copy), Remotes (copy), AutoSell (ref), Frame (copy)
    ButtonFX(AutoSell, nil, function() -- line: 698
        -- upvalues: Tabs (copy)
        Tabs.Toggle("AutoSell")
    end)

    local t29 = {}
    local v88 = invokeBackpack(Remotes.Haul.FetchAutoSell)

    if v88 then
        local v89 = v88[1]

        if typeof(v89) == "table" then
            for v90, v91 in pairs(v89) do
                if v91 then
                    t29[v90] = true
                end
            end
        end
    end

    buildAutoSellSlots(Frame)
    applyAutoSellMap(t29)
end

function claimLowestEmptySlot(p14) -- line: 717
    -- upvalues: t6 (copy), v38 (ref), _EmptySlotsAttribute (ref)
    local v92 = v38

    if not v92 or not canToolUseHotbarSlot(p14, v92.Index) then
        return nil
    end

    local v93

    for i = 1, _EmptySlotsAttribute do
        v93 = t6[i]

        if v93 and v93 ~= v92 and not v93.Tool and not v93.IsFakeSlot and canToolUseHotbarSlot(p14, i) then
            break
        end

        v93 = nil
    end

    v38 = v93

    return v92
end

function getInsertableHotbarIndices(p15) -- line: 745
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    local t30 = {}

    for i = 1, _EmptySlotsAttribute do
        local v94 = t6[i]

        if v94 and not v94.IsFakeSlot and canToolUseHotbarSlot(p15, i) then
            table.insert(t30, i)
        end
    end

    return t30
end

function insertToolIntoFrontHotbar(p16) -- line: 758
    -- upvalues: t6 (copy), v38 (ref)
    local v95 = getInsertableHotbarIndices(p16)
    local v96 = v95[1]

    if not v96 then
        return nil
    end

    local v97 = t6[v96]

    if not v97 or v97.Tool and getLockedHotbarSlotForTool(p16) == v96 and canToolUseHotbarSlot(v97.Tool, v96) then
        return nil
    end

    local v98 = v38
    local v99 = if v98 then table.find(v95, v98.Index) else nil

    if not v98 or not v99 then
        local v100 = v95[#v95]
        local v101 = v100 and t6[v100]

        if v101 and v101.Tool then
            v101:MoveToInventory()
        end

        for i = #v95, 2, -1 do
            local v102 = t6[v95[i]]
            local v103 = t6[v95[i - 1]]

            if v102 and v103 then
                v103:Swap(v102)
            end
        end
    else
        for i = v99, 2, -1 do
            local v104 = t6[v95[i]]
            local v105 = t6[v95[i - 1]]

            if v104 and v105 then
                v105:Swap(v104)
            end
        end
    end

    v97:Fill(p16)

    return v97
end

function _getAssetUID(p17) -- line: 812
    if typeof(p17) == "table" and (p17.IsVirtualAsset or p17.IsVirtualEgg) then
        return p17.UID
    end

    if typeof(p17) == "Instance" then
        return p17:GetAttribute("UID")
    end

    return nil
end

function getAttribute(p18, p19) -- line: 822
    if p18 and (typeof(p18) == "table" and p18.GetAttribute or typeof(p18) == "Instance") then
        return p18:GetAttribute(p19)
    end

    return nil
end

function parseMutations(p20) -- line: 836
    if typeof(p20) == "table" then
        return table.clone(p20)
    end

    if typeof(p20) ~= "string" then
        return {}
    end

    local t31 = {}

    for match in string.gmatch(p20, "[^,]+") do
        local v106 = string.match(match, "^%s*(.-)%s*$")

        if v106 ~= "" then
            table.insert(t31, v106)
        end
    end

    return t31
end

function isAssetUIDFavorite(p21) -- line: 857
    -- upvalues: Save (copy), AssetItems2 (copy)
    local v107

    if typeof(p21) ~= "string" or p21 == "" then
        return false
    else
        local v109 = Save.Await()

        v107 = v109 and v109.Inventory
    end

    local v110 = if typeof(v107) == "table" then v107[p21] else nil

    if typeof(v110) ~= "table" then
        return false
    end

    return AssetItems2.Decode(v110).IsFavorite == true
end

function isToolFavorite(p22) -- line: 872
    if not isAssetTool(p22) then
        return getAttribute(p22, "Favorite") == true
    end

    local Favorite = getAttribute(p22, "Favorite")

    if typeof(Favorite) == "boolean" then
        return Favorite
    end

    local ItemData = getAttribute(p22, "ItemData")

    if typeof(ItemData) ~= "table" or ItemData.IsFavorite ~= true then
        return isAssetUIDFavorite(_getAssetUID(p22))
    end

    return true
end

function getAssetItemData(p23) -- line: 890
    local ItemData = getAttribute(p23, "ItemData")

    if typeof(ItemData) == "table" then
        return ItemData
    end

    local Category = getAttribute(p23, "Category")

    if not Category then
        return nil
    end

    local Scale = getAttribute(p23, "Scale")

    return {
        Category = Category,
        Mutations = parseMutations(getAttribute(p23, "Mutations")),
        BaseMutation = getAttribute(p23, "BaseMutation"),
        Scale = if typeof(Scale) ~= "number" or not Scale then 1 else Scale,
        IsFavorite = isAssetUIDFavorite(_getAssetUID(p23))
    }
end

function getAssetItemDisplayName(p24, p25) -- line: 912
    -- upvalues: ItemDisplay (copy)
    local DisplayName, Category

    if typeof(p24) == "table" then
        if typeof(p24.Category) == "string" and AssetDirectory[p24.Category] then
            return ItemDisplay.GetNameFromItemData(p24)
        end

        DisplayName = p24.DisplayName
        Category = p24.Category
    end

    local v111, v112

    if DisplayName then
        v111 = DisplayName
        v112 = true
    elseif p25 then
        local DisplayName = p25.DisplayName

        if DisplayName then
            v111 = DisplayName
            v112 = true
        else
            v112 = false
        end
    else
        v112 = false
    end

    if not v112 then
        v111 = Category or "Asset"
    end

    return v111
end

function getAssetItemDisplayNameWithVisualWeight(p26, p27) -- line: 927
    -- upvalues: AssetItems (copy)
    return (("%* (%*)"):format(getAssetItemDisplayName(p26, p27), (AssetItems.WeightLabel(p26))))
end

function isAssetTool(p28) -- line: 932
    return getAttribute(p28, "ItemType") == "Asset"
end

function getGearName(p29) -- line: 934
    local GearName = getAttribute(p29, "GearName")

    return if typeof(GearName) == "string" and GearName ~= "" then GearName else nil
end

function getGearConfig(p30) -- line: 939
    -- upvalues: Gears (copy)
    local v113 = getGearName(p30)

    return if v113 then Gears.Directory[v113] else nil
end

function getToolUses(p31) -- line: 944
    local Uses = getAttribute(p31, "Uses")

    if typeof(Uses) == "number" then
        return (math.max(Uses, 0))
    end

    return 0
end

function shouldDisplayToolUses(p32) -- line: 949
    local ItemType = getAttribute(p32, "ItemType")

    if ItemType == "MutationConsumable" or ItemType == "MountStar" then
        return true
    end

    if ItemType ~= "Gear" then
        return false
    end

    local v114 = getGearConfig(p32)

    if not v114 then
        return false
    end

    if typeof(v114.ActiveDeploymentAttribute) == "string" then
        return v114.ActiveDeploymentAttribute ~= ""
    end

    return false
end

function getToolUsesText(p33) -- line: 967
    return (("x%*"):format((getToolUses(p33))))
end

function getHotbarFillTool(p34) -- line: 971
    if typeof(p34) == "table" and (p34.IsVirtualAsset or p34.IsVirtualEgg) then
        return p34
    end

    return p34
end

function virtualAssetMatchesUID(p35, p36) -- line: 979
    if typeof(p35) ~= "table" or not p35.IsVirtualAsset or typeof(p36) ~= "string" then
        return false
    end

    return p35.UID == p36
end

function getVirtualAssetUID(p37) -- line: 987
    return if typeof(p37) == "table" and p37.IsVirtualAsset then p37.UID else nil
end

function getVirtualEggUID(p38) -- line: 995
    return if typeof(p38) == "table" and p38.IsVirtualEgg then p38.UID else nil
end

function virtualEggSlotMatchesUID(p39, p40) -- line: 1003
    if p39 and not p39.IsDeleted then
        return getVirtualEggUID(p39.Tool) == p40
    end

    return false
end

function findVirtualEggSlotByUID(p41) -- line: 1011
    -- upvalues: t6 (copy)
    for _, v116 in pairs(t6) do
        if virtualEggSlotMatchesUID(v116, p41) then
            return v116
        end
    end

    return nil
end

function clearVirtualEggSlotsByUID(p42) -- line: 1021
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = #t6, 1, -1 do
        local v117 = t6[i]

        if virtualEggSlotMatchesUID(v117, p42) then
            v117:Clear()

            if v117.Index > _EmptySlotsAttribute then
                v117:Delete()
            end
        end
    end
end

function clearDuplicateVirtualEggSlotsByUID(p43, p44) -- line: 1033
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = #t6, 1, -1 do
        local v118 = t6[i]

        if v118 ~= p44 and virtualEggSlotMatchesUID(v118, p43) then
            v118:Clear()

            if v118.Index > _EmptySlotsAttribute then
                v118:Delete()
            end
        end
    end
end

function getRegisteredBackpackSlot(p45) -- line: 1045
    -- upvalues: t7 (copy), t11 (copy), t16 (copy)
    local v119 = getVirtualAssetUID(p45)

    if v119 then
        return t11[v119]
    end

    local v120 = getVirtualEggUID(p45)

    if v120 then
        return t16[v120]
    end

    return t7[p45]
end

function registeredSlotContainsTool(p46, p47) -- line: 1059
    if not p46 or p46.IsDeleted then
        return false
    end

    local Tool = p46.Tool
    local v121 = getVirtualAssetUID(p47)

    if v121 then
        return getVirtualAssetUID(Tool) == v121
    end

    local v122 = getVirtualEggUID(p47)

    if v122 then
        return getVirtualEggUID(Tool) == v122
    end

    return Tool == p47
end

function unregisterVirtualBackpackSlot(p48, p49) -- line: 1078
    -- upvalues: t11 (copy), t12 (copy), t16 (copy), t17 (copy)
    local v123 = getVirtualAssetUID(p49)

    if v123 then
        if t11[v123] == p48 then
            t11[v123] = nil
        end

        if t12[v123] == p49 then
            t12[v123] = nil
        end
    end

    local v124 = getVirtualEggUID(p49)

    if v124 then
        if t16[v124] == p48 then
            t16[v124] = nil
        end

        if t17[v124] == p49 then
            t17[v124] = nil
        end
    end
end

function unregisterBackpackSlotTool(p50, p51) -- line: 1096
    -- upvalues: t7 (copy)
    unregisterVirtualBackpackSlot(p50, p51)

    if p51 and t7[p51] == p50 then
        t7[p51] = nil
    end
end

function registerVirtualBackpackSlot(p52, p53) -- line: 1104
    -- upvalues: t11 (copy), t12 (copy), t16 (copy), t17 (copy)
    local v125 = getVirtualAssetUID(p53)

    if v125 then
        t11[v125] = p52
        t12[v125] = p53
    end

    local v126 = getVirtualEggUID(p53)

    if v126 then
        t16[v126] = p52
        t17[v126] = p53
    end
end

function createVirtualAsset(p54, p55) -- line: 1118
    -- upvalues: Save (copy)
    local Category = p55.Category
    local v127 = AssetDirectory[Category] or BaseAssetConfig
    local v128 = table.clone(p55)
    local v129 = getAssetItemDisplayName(v128, v127)

    return {
        IsVirtualAsset = true,
        ToolTip = "",
        UID = p54,
        Name = v129,
        TextureId = v127.Icon or "",
        GetAttribute = function(_, p57) -- GetAttribute | line: 1130
            -- upvalues: p54 (copy), Category (copy), v128 (copy), v129 (copy), Save (copy)
            if p57 == "ItemType" then
                return "Asset"
            end

            if p57 == "UID" then
                return p54
            end

            if p57 == "Category" then
                return Category
            end

            if p57 == "DisplayName" then
                return v129
            end

            if p57 == "Mutations" then
                return table.concat(v128.Mutations or {}, ", ")
            end

            if p57 == "BaseMutation" then
                return v128.BaseMutation
            end

            if p57 == "Scale" then
                return v128.Scale
            end

            if p57 == "ItemData" then
                return v128
            end

            if p57 ~= "Favorite" then
                return nil
            end

            local v130 = Save.Await()
            local v131 = if v130 then typeof(v130.Inventory) == "table" else nil

            if not v130 or not v131 then
                return v128.IsFavorite == true
            end

            return isAssetUIDFavorite(p54)
        end,
        IsA = function(_, p59) -- IsA | line: 1158
            return p59 == "Tool"
        end
    }
end

function isAssetUIDPlaced(p60) -- line: 1162
    -- upvalues: t13 (ref)
    if typeof(p60) == "string" then
        return t13[p60] == true
    end

    return false
end

function hasLocalAssetToolUID(p61) -- line: 1166
    return findAssetToolByUID(p61) ~= nil
end

function refreshPlacedAssetUIDs(p62) -- line: 1168
    -- upvalues: t13 (ref)
    local t34 = {}

    for v132 in pairs(p62) do
        if typeof(v132) == "string" then
            t34[v132] = true
        end
    end

    t13 = t34
end

function assetSignatureField(p63) -- line: 1179
    if p63 == nil then
        return ""
    end

    return (tostring(p63))
end

function getAssetItemSignature(p64) -- line: 1187
    return table.concat({
        assetSignatureField(p64.Category),
        table.concat(p64.Mutations or {}, ","),
        assetSignatureField(p64.BaseMutation),
        assetSignatureField(p64.Scale),
        assetSignatureField(p64.Gender),
        assetSignatureField(p64.EyeColor),
        assetSignatureField(p64.ColorSeed),
        assetSignatureField(p64.ColorIndex),
        assetSignatureField(p64.GeneratedMoney),
        assetSignatureField(p64.PendingEggName),
        assetSignatureField(p64.Claimed),
        assetSignatureField(p64.HasBeenFirstPlaced)
    }, "\031")
end

function buildEligibleAssetDataFromSave() -- line: 1204
    -- upvalues: Save (copy), AssetItems2 (copy)
    local v133 = Save.Await()
    local v134 = if v133 then typeof(v133.Inventory) == "table" else nil

    if not v133 or not v134 then
        return {}, {}
    end

    local t35 = {}
    local t36 = {}

    for v135, v136 in pairs(v133.Inventory) do
        if typeof(v135) == "string" and typeof(v136) == "table" then
            local v137 = AssetItems2.Decode(v136)
            local v138 = table.find(v133.EquippedAssets or {}, v135) ~= nil

            if v137.InFuse ~= true and (not v138 or hasLocalAssetToolUID(v135)) and not isAssetUIDPlaced(v135) then
                t35[v135] = v137
                t36[v135] = getAssetItemSignature(v137)
            end
        end
    end

    return t35, t36
end

function isSerializedAssetEligibleForBackpack(p65, p66) -- line: 1234
    -- upvalues: Save (copy), AssetItems2 (copy)
    if typeof(p66) ~= "table" then
        return false
    end

    local v139 = AssetItems2.Decode(p66)
    local v140 = Save.Await()
    local v141 = v140 and table.find(v140.EquippedAssets or {}, p65) ~= nil

    if v139.InFuse ~= true and (not v141 or hasLocalAssetToolUID(p65)) and not isAssetUIDPlaced(p65) then
        return true
    end

    return false
end

function captureEligibleAssetUIDs() -- line: 1253
    -- upvalues: Save (copy)
    local v142 = Save.Await()
    local t37 = {}
    local v143 = if v142 then typeof(v142.Inventory) == "table" else nil

    if v142 and v143 then
        for v144, v145 in pairs(v142.Inventory) do
            if typeof(v144) == "string" and isSerializedAssetEligibleForBackpack(v144, v145) then
                t37[v144] = true
            end
        end
    end

    return t37
end

function queueNewEligibleAssetsForHotbar(p67, p68) -- line: 1273
    -- upvalues: t15 (copy)
    for v146 in pairs(p68) do
        if p67[v146] ~= true then
            t15[v146] = true
        end
    end
end

function getEggConfigForRecord(p69) -- line: 1281
    local v147 = typeof(p69) == "table"
    local v148 = if v147 then typeof(p69.AssetCategory) == "string" else nil

    if v147 and v148 then
        local v149 = AssetDirectory[p69.AssetCategory]

        if v149 then
            return v149.Egg, v149
        end
    end

    return nil, nil
end

function getAreaForEggRecord(p70) -- line: 1294
    -- upvalues: Areas (copy)
    local _, v150 = getEggConfigForRecord(p70)

    if v150 and v150.Rarity then
        local AssetCategory = p70.AssetCategory
        local v151 = v150.Rarity._id or v150.Rarity.DisplayName

        for _, v152 in pairs(Areas.Directory) do
            for _, v153 in ipairs(v152.DropTable) do
                local v154 = v153[1]

                if v154 == AssetCategory or v154 == v151 then
                    return v152
                end
            end
        end

        return nil
    end

    return nil
end

function getEggDisplayName(p71) -- line: 1314
    -- upvalues: EggSkins (copy)
    local v155 = EggSkins.Get(p71.EggSkin)

    if v155 then
        return v155.DisplayName
    end

    local v156 = MutationHandler.EggDisplayName(p71.Mutations, p71.BaseMutation)

    if v156 then
        return v156
    end

    local v157 = getAreaForEggRecord(p71)

    if v157 then
        return (("%* Egg"):format(v157.DisplayName))
    end

    return "Egg"
end

function getEggDisplayNameWithWeight(p72) -- line: 1333
    -- upvalues: EggRecords (copy)
    return (("%* (%*)"):format(getEggDisplayName(p72), (EggRecords.WeightLabel(p72))))
end

function getEggIconForRecord(p73, p74) -- line: 1338
    -- upvalues: EggSkins (copy)
    if typeof(p73) ~= "table" then
        return p74 and p74.Icon or ""
    end

    local v158 = EggSkins.Get(p73.EggSkin)

    if v158 then
        return v158.Icon
    end

    local v159 = MutationHandler.EggIcon(p73.Mutations, p73.BaseMutation)

    if v159 and v159 ~= "" then
        return v159
    end

    return p74 and p74.Icon or ""
end

function isRobuxEgg(p75, p76) -- line: 1353
    -- upvalues: Save (copy)
    local PurchaseId = if typeof(p75) == "table" then p75.PurchaseId else nil
    local UID, PurchaseId2, v160

    if PurchaseId ~= nil or p76 == nil then
        PurchaseId2 = PurchaseId
    else
        UID = getAttribute(p76, "UID")

        local v161 = Save.Peek()

        v160 = v161 and v161.EggInventory

        local v162 = if typeof(UID) ~= "string" or typeof(v160) ~= "table" then nil else v160[UID]

        PurchaseId2 = if typeof(v162) == "table" then v162.PurchaseId else nil
    end

    if typeof(PurchaseId2) == "string" then
        return PurchaseId2 ~= ""
    end

    return false
end

function getEggRecordFromTool(p77) -- line: 1367
    local EggRecord = getAttribute(p77, "EggRecord")

    if typeof(EggRecord) == "table" then
        return EggRecord
    end

    local v163 = getAttribute(p77, "AssetCategory") or getAttribute(p77, "Category")
    local v164 = getAttribute(p77, "AssetScale") or getAttribute(p77, "Scale")

    return if typeof(v163) == "string" and typeof(v164) == "number" then {
        AssetCategory = v163,
        AssetScale = v164,
        Mutations = parseMutations(getAttribute(p77, "Mutations")),
        BaseMutation = getAttribute(p77, "BaseMutation"),
        EggSkin = getAttribute(p77, "EggSkin")
    } else nil
end

function createVirtualEgg(p78, p79) -- line: 1388
    -- upvalues: EggRecords (copy)
    local v165, v166 = getEggConfigForRecord(p79)

    if not v165 or not v166 then
        return nil
    end

    local v167 = getEggDisplayNameWithWeight(p79)
    local v168 = EggRecords.WeightKg(p79)

    return {
        IsVirtualEgg = true,
        UID = p78,
        Name = v167,
        TextureId = getEggIconForRecord(p79, v165),
        ToolTip = v167,
        GetAttribute = function(_, p81) -- GetAttribute | line: 1402
            -- upvalues: p78 (copy), p79 (copy), v167 (copy), v168 (copy)
            if p81 == "ItemType" then
                return "AssetEgg"
            end

            if p81 == "UID" then
                return p78
            end

            if p81 == "AssetCategory" or p81 == "Category" then
                return p79.AssetCategory
            end

            if p81 == "DisplayName" or p81 == "EggDisplayName" then
                return v167
            end

            if p81 == "EggRecord" then
                return table.clone(p79)
            end

            if p81 == "Mutations" then
                return table.concat(p79.Mutations or {}, ", ")
            end

            if p81 == "BaseMutation" then
                return p79.BaseMutation
            end

            if p81 == "Weight" or p81 == "WeightKg" then
                return v168
            end

            return if p81 == "Favorite" then false else nil
        end,
        IsA = function(_, p83) -- IsA | line: 1427
            return p83 == "Tool"
        end
    }
end

function buildVirtualEggsFromSave() -- line: 1431
    -- upvalues: Save (copy)
    local v169 = Save.Await()
    local v170 = v169 and v169.EggInventory
    local t39 = {}

    if typeof(v170) == "table" then
        for v171, v172 in pairs(v170) do
            if typeof(v171) == "string" and typeof(v172) == "table" and v172.Placement == nil then
                local v173 = createVirtualEgg(v171, v172)

                if v173 then
                    t39[v171] = v173
                end
            end
        end
    end

    return t39
end

function captureEggUIDs() -- line: 1453
    -- upvalues: Save (copy)
    local v174 = Save.Await()
    local v175 = v174 and v174.EggInventory
    local t40 = {}

    if typeof(v175) == "table" then
        for v176, v177 in pairs(v175) do
            if typeof(v176) == "string" and typeof(v177) == "table" and v177.Placement == nil then
                t40[v176] = true
            end
        end
    end

    return t40
end

function queueNewEggsForHotbar(p84, p85) -- line: 1470
    -- upvalues: t18 (copy)
    for v178 in pairs(p85) do
        if not p84[v178] then
            t18[v178] = true
        end
    end
end

function clearInstanceAssetSlots() -- line: 1478
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    local v179 = false

    for _, v180 in pairs(t6) do
        if v180 then
            local Tool = v180.Tool

            if typeof(Tool) == "Instance" and Tool:IsA("Tool") and isAssetTool(Tool) then
                v180:Clear()

                if v180.Index > _EmptySlotsAttribute then
                    v180:Delete()
                end

                v179 = true
            end
        end
    end

    return v179
end

function clearPlacedAssetBackpackSlot(p86) -- line: 1494
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref), t11 (copy), t12 (copy), t14 (copy), t15 (copy)
    t15[p86] = nil
    t14[p86] = nil

    local v181 = #t6
    local v182 = false

    for i = v181, 1, -1 do
        local v183 = t6[i]

        if v183 then
            local Tool = v183.Tool

            if Tool and getAttribute(Tool, "ItemType") == "Asset" and _getAssetUID(Tool) == p86 then
                v183:Clear()

                if v183.Index > _EmptySlotsAttribute then
                    v183:Delete()
                end

                v182 = true
            end
        end
    end

    t11[p86] = nil
    t12[p86] = nil

    return v182
end

function clearPlacedAssetBackpackSlots(p87) -- line: 1521
    local v184 = false

    for v185 in pairs(p87) do
        if typeof(v185) == "string" and clearPlacedAssetBackpackSlot(v185) then
            v184 = true
        end
    end

    return v184
end

function syncAssetsFromSave() -- line: 1532
    -- upvalues: ScrollingFrame (ref), _EmptySlotsAttribute (ref), t11 (copy), t12 (copy), t14 (copy)
    if not ScrollingFrame then
        return false
    end

    local v186, v187 = buildEligibleAssetDataFromSave()
    local v188 = clearInstanceAssetSlots()

    for v189, v190 in pairs(t11) do
        if not v186[v189] then
            if v190 and not v190.IsDeleted then
                v190:Clear()

                if v190.Index > _EmptySlotsAttribute then
                    v190:Delete()
                end
            end

            t11[v189] = nil
            v188 = true
            t14[v189] = nil
        end
    end

    for v191, v192 in pairs(v186) do
        local v193 = v187[v191]
        local v194 = t11[v191]
        local v195 = v194 and not v194.IsDeleted and virtualAssetMatchesUID(v194.Tool, v191)

        if not v195 or t14[v191] ~= v193 then
            if not v195 then
                v194 = FindEmptyInventorySlot() or MakeSlot(ScrollingFrame)
            end

            t11[v191] = v194
            t12[v191] = createVirtualAsset(v191, v192)
            t14[v191] = v193
            v188 = true
            v194:Fill(t12[v191])
        elseif v194 then
            t12[v191] = v194.Tool
            t14[v191] = v193

            if v194.UpdateFavoriteVisual and v194:UpdateFavoriteVisual() then
                v188 = true
            end
        end
    end

    for v196 in pairs(t12) do
        if not v186[v196] then
            t12[v196] = nil
        end
    end

    if v188 then
        AdjustHotbarFrames()
        UpdateInventorySlots()
    end

    return v188
end

function syncEggsFromSave() -- line: 1590
    -- upvalues: ScrollingFrame (ref), t16 (copy), t17 (copy)
    if not ScrollingFrame then
        return
    end

    local v197 = buildVirtualEggsFromSave()

    for v198 in pairs(t16) do
        if not v197[v198] then
            clearVirtualEggSlotsByUID(v198)
            t16[v198] = nil
        end
    end

    for v199, v200 in pairs(v197) do
        local v201 = t16[v199]

        if not virtualEggSlotMatchesUID(v201, v199) then
            v201 = findVirtualEggSlotByUID(v199)
        end

        if not v201 or v201.IsDeleted then
            v201 = FindEmptyInventorySlot() or MakeSlot(ScrollingFrame)
        end

        t16[v199] = v201
        t17[v199] = v200
        clearDuplicateVirtualEggSlotsByUID(v199, v201)
        v201:Fill(v200)
    end

    for v202 in pairs(t17) do
        if not v197[v202] then
            t17[v202] = nil
        end
    end

    AdjustHotbarFrames()
    UpdateInventorySlots()
end

function getAssetRarityNumber(p88) -- line: 1629
    local Category = getAttribute(p88, "Category")
    local v203 = Category and AssetDirectory[Category] or BaseAssetConfig
    local v204 = v203 and v203.Rarity

    if v204 then
        if v204.Rank then
            return v204.Rank
        end

        if RarityDirectory[v204] and RarityDirectory[v204].Rank then
            return RarityDirectory[v204].Rank
        end
    end

    return 1e999
end

function getAssetDropWeight(p89) -- line: 1645
    local Category = getAttribute(p89, "Category")
    local v205 = Category and AssetDirectory[Category] or BaseAssetConfig
    local v206 = if v205 then typeof(v205.DropWeight) == "number" else nil

    if not v205 or not v206 then
        return 1e999
    end

    return v205.DropWeight
end

function getAssetOddsDenominator(p90) -- line: 1656
    if getAttribute(p90, "ItemType") ~= "Asset" then
        return 0
    end

    local Category = getAttribute(p90, "Category")
    local v207 = Category and AssetDirectory[Category] or BaseAssetConfig
    local v208 = v207 and v207.DropWeight

    if typeof(v208) ~= "number" or v208 <= 0 then
        return 0
    end

    local v209 = getAssetItemData(p90)

    if v209 then
        return 1 / v208 * MutationHandler.RarityFactorFor(v209.Mutations, v209.BaseMutation)
    end

    return 0
end

function getAssetEarningRate(p91) -- line: 1677
    -- upvalues: AssetEarnings (copy)
    if getAttribute(p91, "ItemType") == "Asset" then
        local v210 = getAssetItemData(p91)

        if v210 then
            return AssetEarnings.MutationOnlyRatePerSecond(v210)
        end
    end

    return 0
end

function getEggAssetConfig(p92) -- line: 1690
    local v211 = getEggRecordFromTool(p92)
    local _, v212 = getEggConfigForRecord(v211)

    if v212 then
        return v212
    end

    local v213 = getAttribute(p92, "AssetCategory") or getAttribute(p92, "Category")

    return v213 and AssetDirectory[v213] or nil
end

function getEggRarityNumber(p93) -- line: 1701
    local v214 = getEggAssetConfig(p93)
    local v215 = v214 and v214.Rarity

    if v215 then
        if v215.Rank then
            return v215.Rank
        end

        if RarityDirectory[v215] and RarityDirectory[v215].Rank then
            return RarityDirectory[v215].Rank
        end
    end

    return 1e999
end

function getEggBaseEarningRate(p94) -- line: 1716
    local v216 = getEggAssetConfig(p94)
    local v217 = if v216 then typeof(v216.EarningRate) == "number" else nil

    if not v216 or not v217 then
        return 0
    end

    return v216.EarningRate
end

function requestFavoriteToggle(p95) -- line: 1721
    -- upvalues: Remotes (copy), v48 (copy)
    if not ActiveFuseSelectionState and isAssetTool(p95) then
        local v218 = _getAssetUID(p95)

        if typeof(v218) == "string" and v218 ~= "" then
            local v219 = not isToolFavorite(p95)

            v48(function() -- line: 1736
                -- upvalues: v218 (copy), v219 (copy), Remotes (copy)
                Remotes.PetSatchel.WriteFavourite:FireServer(v218, v219)
            end)
        end
    end
end

function getStackQuantity(p96) -- line: 1739
    local StackQuantity = getAttribute(p96, "StackQuantity")

    if typeof(StackQuantity) ~= "number" or not (StackQuantity > 1) then
        return 1
    end

    return (math.floor(StackQuantity))
end

function clearMutationIconFrame(p97, p98) -- line: 1748
    if p97 and p98 then
        for _, child in ipairs(p97:GetChildren()) do
            if child:IsA("ImageLabel") and child ~= p98 then
                child:Destroy()
            end
        end

        p97.Visible = false
    end
end

function populateMutationIconFrame(p99, p100, _, _) -- line: 1762
    if p99 and p100 then
        clearMutationIconFrame(p99, p100)
        p99.Visible = false
    end
end

function updateEquipSelectionVisuals() -- line: 1777
    -- upvalues: t6 (copy)
    for _, v220 in pairs(t6) do
        if v220 then
            v220:UpdateEquipView()
        end
    end
end

function findVirtualAssetSlotContainingUID(p103) -- line: 1785
    -- upvalues: t6 (copy)
    for _, v221 in pairs(t6) do
        if v221 and virtualAssetMatchesUID(v221.Tool, p103) then
            return v221
        end
    end

    return nil
end

function getCharacterAssetToolUID() -- line: 1795
    -- upvalues: v35 (ref)
    for _, child in ipairs(v35:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("ItemType") == "Asset" then
            local UID = child:GetAttribute("UID")

            if typeof(UID) == "string" then
                return UID
            end
        end
    end

    return nil
end

function findAssetToolByUID(p104) -- line: 1808
    -- upvalues: v35 (ref), Backpack2 (ref)
    local function searchContainer(p105) -- line: 1809
        -- upvalues: p104 (copy)
        if not p105 then
            return nil
        end

        for _, child in ipairs(p105:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("ItemType") == "Asset" and child:GetAttribute("UID") == p104 then
                return child
            end
        end

        return nil
    end

    return searchContainer(v35) or searchContainer(Backpack2) or nil
end

function applyVirtualAssetEquipUID(p106) -- line: 1840
    -- upvalues: v50 (ref)
    v50 = p106

    if typeof(p106) == "string" then
        SelectedSlot = findVirtualAssetSlotContainingUID(p106)
    elseif SelectedSlot and getAttribute(SelectedSlot.Tool, "ItemType") == "Asset" then
        SelectedSlot = nil
    end

    updateEquipSelectionVisuals()
end

function reconcileVirtualAssetEquipState() -- line: 1851
    -- upvalues: v50 (ref)
    local v222 = getCharacterAssetToolUID()

    if v222 == v50 then
        if typeof(v222) == "string" and not SelectedSlot then
            SelectedSlot = findVirtualAssetSlotContainingUID(v222)
            updateEquipSelectionVisuals()
        end
    else
        applyVirtualAssetEquipUID(v222)
    end

    return v222
end

function syncVirtualAssetEquipStateFromTool(p107) -- line: 1863
    -- upvalues: v35 (ref), Backpack2 (ref), v50 (ref)
    local UID = p107:GetAttribute("UID")

    if typeof(UID) == "string" then
        if p107.Parent == v35 then
            applyVirtualAssetEquipUID(UID)
        elseif p107.Parent == Backpack2 and v50 == UID then
            task.defer(reconcileVirtualAssetEquipState)
        end
    end
end

function getCharacterEggToolUID() -- line: 1876
    -- upvalues: v35 (ref)
    for _, child in ipairs(v35:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
            local UID = child:GetAttribute("UID")

            if typeof(UID) == "string" then
                return UID
            end
        end
    end

    return nil
end

function applyVirtualEggEquipUID(p108) -- line: 1889
    -- upvalues: v55 (ref)
    v55 = p108

    if typeof(p108) == "string" then
        SelectedSlot = findVirtualEggSlotByUID(p108)
    elseif SelectedSlot and getAttribute(SelectedSlot.Tool, "ItemType") == "AssetEgg" then
        SelectedSlot = nil
    end

    updateEquipSelectionVisuals()
end

function reconcileVirtualEggEquipState() -- line: 1900
    -- upvalues: v55 (ref)
    local v223 = getCharacterEggToolUID()

    if v223 == v55 then
        if typeof(v223) == "string" and not SelectedSlot then
            SelectedSlot = findVirtualEggSlotByUID(v223)
            updateEquipSelectionVisuals()
        end
    else
        applyVirtualEggEquipUID(v223)
    end

    return v223
end

function syncVirtualEggEquipStateFromTool(p109) -- line: 1912
    -- upvalues: v35 (ref), Backpack2 (ref), v55 (ref)
    local UID = p109:GetAttribute("UID")

    if typeof(UID) == "string" then
        if p109.Parent == v35 then
            applyVirtualEggEquipUID(UID)
        elseif p109.Parent == Backpack2 and v55 == UID then
            task.defer(reconcileVirtualEggEquipState)
        end
    end
end

function requestUnequipVirtualEgg() -- line: 1925
    -- upvalues: Toast (copy), EggState (copy), v47 (copy), v55 (ref)
    reconcileVirtualEggEquipState()

    if not v55 then
        return true
    end

    local v224 = false

    v47(function() -- line: 1932
        -- upvalues: v224 (ref), Toast (copy), EggState (copy), v55 (ref)
        local v225 = v55
        local v226, v227 = EggState.DoffEggTool(v225)

        if v226 then
            v55 = nil

            if SelectedSlot and getAttribute(SelectedSlot.Tool, "UID") == v225 then
                SelectedSlot = nil
            end

            updateEquipSelectionVisuals()
            v224 = true
        elseif v227 then
            Toast.Show({
                Seconds = 2,
                Text = v227,
                Color = Color3.fromRGB(255, 64, 64)
            })
        end
    end)

    return v224
end

function requestEquipVirtualEgg(p110, p111) -- line: 1957
    -- upvalues: HiddenUIHandler (copy), Toast (copy), EggState (copy), Humanoid (ref), v47 (copy), v55 (ref)
    if BackpackEnabled and BackpackGui.Enabled and not HiddenUIHandler.IsHidden() then
        if reconcileVirtualEggEquipState() == p110 then
            SelectedSlot = p111
            updateEquipSelectionVisuals()
        else
            v47(function() -- line: 1968
                -- upvalues: p110 (copy), p111 (copy), Toast (copy), EggState (copy), Humanoid (ref), v55 (ref)
                requestUnequipVirtualAsset()

                if Humanoid then
                    Humanoid:UnequipTools()
                end

                local v228, v229 = EggState.WearEggTool(p110)

                if v228 then
                    v55 = p110
                    SelectedSlot = p111
                    updateEquipSelectionVisuals()
                elseif v229 then
                    Toast.Show({
                        Seconds = 2,
                        Text = v229,
                        Color = Color3.fromRGB(255, 64, 64)
                    })
                end
            end)
        end
    end
end

function requestUnequipVirtualAsset() -- line: 1992
    -- upvalues: Toast (copy), Remotes (copy), v47 (copy), v50 (ref)
    reconcileVirtualAssetEquipState()

    if not v50 then
        return true
    end

    local v230 = false

    v47(function() -- line: 1999
        -- upvalues: v230 (ref), Toast (copy), Remotes (copy), v50 (ref)
        local v231 = v50
        local v232, v233 = Remotes.PenRoster.AskDoff:InvokeServer(v231)

        if v232 == false then
            if v233 and v233 ~= "Asset is not available." then
                Toast.Show({
                    Seconds = 2,
                    Text = v233,
                    Color = Color3.fromRGB(255, 64, 64)
                })
            end
        else
            v50 = nil

            if SelectedSlot and virtualAssetMatchesUID(SelectedSlot.Tool, v231) then
                SelectedSlot = nil
            end

            updateEquipSelectionVisuals()
            v230 = true
        end
    end)

    return v230
end

function addVirtualAssetOverlay(p112, p113, p114, p115, p116) -- line: 2024
    -- upvalues: AssetEarnings (copy), AssetItems (copy), ItemDisplay (copy)
    if not ((p112:GetAttribute("IsInventorySlot") or p116) and (not p112:GetAttribute("HasAssetOverlay") or p116)) then
        return
    end

    local DisplayName = if p114.Rarity then p114.Rarity.DisplayName or p114.Rarity._id or p114.Rarity.Name else "Unknown"
    local v234 = getAssetItemDisplayName(p113, p114)
    local v235 = false

    if typeof(p113) == "table" and typeof(p113.Category) == "string" then
        v235 = not not AssetDirectory[p113.Category]
    end

    local v236 = if v235 then AssetEarnings.MutationOnlyRatePerSecond(p113) else AssetEarnings.ComputeBaseRateFromDropWeight(p114.DropWeight)
    local v237 = typeof(p113) == "table"
    local v238 = if v237 then typeof(p113.Mutations) == "table" else nil
    local v239 = if not v237 or not v238 then nil else ItemDisplay.GetMutationRichTextLine(p113.Mutations, p113.BaseMutation)
    local v240 = false

    if typeof(p113) == "table" and typeof(p113.Category) == "string" then
        v240 = typeof(p113.Scale) == "number"
    end

    local v241 = if v240 then AssetItems.WeightLabel(p113) else nil

    local function getInfo() -- line: 2057
        -- upvalues: p112 (copy), DisplayName (copy), v234 (copy), v241 (copy), v236 (copy), v239 (copy)
        if not p112:GetAttribute("IsInventorySlot") then
            return nil
        end

        local t41 = {
            {
                kind = "heading",
                text = v234
            },
            {
                kind = "rule"
            },
            {
                kind = "tier",
                rarity = DisplayName
            },
            {
                kind = "rule"
            },
            {
                kind = "heading",
                text = "$" .. SimpleNumber.FormatCompact(v236, ".#") .. "/s",
                tint = Color3.new(0, 1, 0)
            }
        }

        if v241 then
            table.insert(t41, 2, {
                kind = "body",
                text = v241
            })
        end

        if v239 then
            table.insert(t41, {
                kind = "rule"
            })
            table.insert(t41, {
                kind = "body",
                text = v239
            })
        end

        return t41
    end

    local v242 = HoverCard.Attach(p112, getInfo)

    if p115 then
        p115:Add(v242)
    end

    p112:SetAttribute("HasAssetOverlay", true)
end

function addVirtualEggOverlay(p117, p118, p119, p120) -- line: 2091
    if p117:GetAttribute("IsInventorySlot") and not p117:GetAttribute("HasEggOverlay") then
        local v243 = getEggDisplayNameWithWeight(p118)
        local _, v244 = getEggConfigForRecord(p118)
        local v245 = v244 and v244.Rarity
        local v246 = v244 ~= nil and (v244.Egg.HideRarity == true or isRobuxEgg(p118, p120))
        local DisplayName = if v245 then v245.DisplayName or v245._id or v245.Name else "Egg"
        local Color = if not v245 or isRobuxEgg(p118) then nil else v245.Color

        local function getInfo() -- line: 2108
            -- upvalues: p117 (copy), v243 (copy), DisplayName (copy), Color (copy), v246 (copy)
            if not p117:GetAttribute("IsInventorySlot") then
                return nil
            end

            local t45 = {
                {
                    kind = "heading",
                    text = v243
                }
            }

            if not v246 then
                table.insert(t45, {
                    kind = "rule"
                })
                table.insert(t45, {
                    kind = "heading",
                    text = DisplayName,
                    tint = Color
                })
            end

            return t45
        end

        local v247 = HoverCard.Attach(p117, getInfo)

        if p119 then
            p119:Add(v247)
        end

        p117:SetAttribute("HasEggOverlay", true)
    end
end

function NewGui(p121, p122) -- line: 2131
    local v248 = Instance.new(p121)

    v248.Name = p122
    v248.BackgroundColor3 = Color3.new(0, 0, 0)
    v248.BackgroundTransparency = 1
    v248.BorderColor3 = Color3.new(0, 0, 0)
    v248.BorderSizePixel = 0
    v248.Size = UDim2.new(1, 0, 1, 0)

    if p121:match("Text") then
        v248.TextColor3 = Color3.new(1, 1, 1)
        v248.Text = ""
        v248.FontFace = script:GetAttribute("LabelFont")
        v248.TextSize = TextSizeAttribute
        v248.TextWrapped = true

        if p121 == "TextButton" then
            v248.FontFace = script:GetAttribute("SlotFont")
        end
    end

    return v248
end

function FindLowestEmpty(p123) -- line: 2151
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = 1, _EmptySlotsAttribute do
        local v249 = t6[i]

        if v249 and not v249.IsFakeSlot and not v249.Tool and canToolUseHotbarSlot(p123, i) then
            return v249
        end
    end

    return nil
end

function FindEmptyInventorySlot() -- line: 2165
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = _EmptySlotsAttribute + 1, #t6 do
        local v250 = t6[i]

        if v250 and not v250.Tool then
            return v250
        end
    end

    return nil
end

function cancelPendingBackpackRoundRestore() -- line: 2175
    -- upvalues: v63 (ref)
    if v63 then
        task.cancel(v63)
        v63 = nil
    end
end

function moveRestrictedHotbarToolsToInventory() -- line: 2182
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = 1, _EmptySlotsAttribute do
        local v251 = t6[i]

        if v251 and not v251.IsFakeSlot and v251.Tool and not isToolLockedToCurrentHotbarSlot(v251) then
            v251:MoveToInventory()
        end
    end
end

function isGearTool(p124) -- line: 2191
    if getAttribute(p124, "ItemType") == "Gear" then
        return true
    end

    return typeof(getAttribute(p124, "GearName")) == "string"
end

function isPhoneTool(p125) -- line: 2196
    return getAttribute(p125, "ItemType") == "Phone"
end

function isBatGearTool(p126) -- line: 2198
    local v252 = getGearConfig(p126)

    if v252 == nil then
        return false
    end

    if getGearName(p126) == "Bat" then
        return true
    end

    return v252.IndexBatTier ~= nil
end

function isTrapGearTool(p127) -- line: 2203
    return getGearName(p127) == "Trap"
end

function getLockedHotbarSlotForTool(p128) -- line: 2205
    -- upvalues: TreadmillFlags (copy)
    if typeof(p128) == "Instance" and p128:IsA("Tool") then
        if isPhoneTool(p128) and TreadmillFlags.PhoneEnabled:Get() then
            return 3
        end

        if isGearTool(p128) then
            if isBatGearTool(p128) then
                return 1
            end

            if isTrapGearTool(p128) then
                return 2
            end
        end
    end

    return nil
end

function canToolUseHotbarSlot(p129, p130) -- line: 2226
    -- upvalues: TreadmillFlags (copy)
    if p130 == 3 and TreadmillFlags.PhoneEnabled:Get() then
        if typeof(p129) == "Instance" then
            return p129:IsA("Tool") and isPhoneTool(p129)
        end

        return false
    end

    if p130 == 1 then
        if typeof(p129) == "Instance" then
            return p129:IsA("Tool") and isGearTool(p129) and isBatGearTool(p129)
        end

        return false
    end

    if p130 == 2 then
        if typeof(p129) == "Instance" then
            return p129:IsA("Tool") and isGearTool(p129) and isTrapGearTool(p129)
        end

        return false
    end

    local v253 = getLockedHotbarSlotForTool(p129)

    if v253 == nil then
        return true
    end

    return v253 == p130
end

function isToolLockedToCurrentHotbarSlot(p131) -- line: 2247
    if p131 and not p131.IsFakeSlot and p131.Tool then
        local v255 = getLockedHotbarSlotForTool(p131.Tool)

        return v255 ~= nil and v255 == p131.Index
    end

    return false
end

function findGearSlot(p132) -- line: 2256
    -- upvalues: t6 (copy)
    for _, v256 in pairs(t6) do
        if v256 and not v256.IsFakeSlot and v256.Tool and isGearTool(v256.Tool) and p132(v256.Tool) then
            return v256
        end
    end

    return nil
end

function moveGameplayGearToHotbarSlot(p133, p134) -- line: 2272
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    local v257 = findGearSlot(p133)

    if not v257 then
        return false
    end

    local v258 = t6[p134]

    if not v258 or v258.IsFakeSlot or v257 == v258 or v258.Tool and canToolUseHotbarSlot(v258.Tool, p134) then
        return false
    end

    v257:Swap(v258)

    if v257.Index > _EmptySlotsAttribute and not v257.Tool then
        v257:Delete()
    end

    return true
end

function moveInvalidLockedHotbarSlotToolToInventory(p135) -- line: 2301
    -- upvalues: t6 (copy)
    local v259 = t6[p135]

    if not v259 or v259.IsFakeSlot or not v259.Tool or canToolUseHotbarSlot(v259.Tool, p135) then
        return false
    end

    local Tool = v259.Tool

    v259:MoveToInventory()

    return v259.Tool ~= Tool
end

function returnUncategorizedToolsToHotbar() -- line: 2315
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    local t48 = {}

    for _, v260 in pairs(t6) do
        if v260 and not v260.IsFakeSlot and v260.Index > _EmptySlotsAttribute and v260.Tool and not HasInventoryCategory(v260.Tool) then
            table.insert(t48, v260)
        end
    end

    local v261 = false

    for _, v262 in t48 do
        if v262.Tool then
            for i = 1, _EmptySlotsAttribute do
                local v263 = t6[i]

                if v263 and not v263.IsFakeSlot and not v263.Tool and canToolUseHotbarSlot(v262.Tool, i) then
                    v262:Swap(v263)

                    if not v262.Tool then
                        v262:Delete()
                    end

                    v261 = true
                    break
                end
            end
        end
    end

    return v261
end

function ensureGameplayGearHotbarSlots() -- line: 2354
    -- upvalues: v1 (ref)
    local v264 = not not moveGameplayGearToHotbarSlot(isBatGearTool, 1)

    if moveGameplayGearToHotbarSlot(isTrapGearTool, 2) then
        v264 = true
    end

    if moveInvalidLockedHotbarSlotToolToInventory(1) then
        v264 = true
    end

    if moveInvalidLockedHotbarSlotToolToInventory(2) then
        v264 = true
    end

    if not (returnUncategorizedToolsToHotbar() or v264) then
        return
    end

    AdjustHotbarFrames()
    UpdateInventorySlots()

    if v1 then
        v1(true)
    end
end

function isToolInCharacterOrBackpack(p136) -- line: 2382
    -- upvalues: v35 (ref), Backpack2 (ref)
    if typeof(p136) ~= "Instance" or not p136:IsA("Tool") then
        return false
    end

    local Parent = p136.Parent

    if Parent == v35 then
        return true
    end

    return Parent == Backpack2
end

function _isInventoryEmpty() -- line: 2391
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = _EmptySlotsAttribute + 1, #t6 do
        local v265 = t6[i]

        if v265 and v265.Tool then
            return false
        end
    end

    return true
end

function _UseGazeSelection() -- line: 2400
    return UserInputService.VREnabled
end

function AdjustHotbarFrames() -- line: 2401
    -- upvalues: Inventory (ref), t6 (copy), n3 (ref), v41 (ref), _EmptySlotsAttribute (ref)
    debug.profilebegin("BackpackController :: AdjustHotbarFrames")

    for i = 1, _EmptySlotsAttribute do
        local v266 = t6[i]

        if v266 then
            v266:SetNumberText(nil)
        end
    end

    local Visible = Inventory.Visible
    local t49 = {}

    for i = 1, _EmptySlotsAttribute do
        local v267 = t6[i]
        local IsFakeSlot = v267 and (v267.IsFakeSlot or v267.Tool or Visible)

        if if v41 then v267 and v267.Tool and isPhoneTool(v267.Tool) else IsFakeSlot then
            table.insert(t49, {
                Kind = "Slot",
                Slot = v267
            })
        end
    end

    local v269 = math.max(1, #t49)

    n3 = v269

    for i = 1, _EmptySlotsAttribute do
        local v270 = t6[i]

        if v270 then
            v270.Frame.Visible = false
        end
    end

    local n7 = 0

    for _, v271 in ipairs(t49) do
        n7 += 1

        local Slot = v271.Slot

        if Slot then
            Slot.Frame.LayoutOrder = n7
            Slot:Readjust(n7, v269)
            Slot.Frame.Visible = true
        end
    end

    PositionInventoryAffordances()
    debug.profileend()
end

function UpdateScrollingFrameCanvasSize() -- line: 2452
    -- upvalues: v27 (ref)
    debug.profilebegin("BackpackController :: UpdateScrollingFrameCanvasSize")

    if v27 then
        v27()
    end

    debug.profileend()
end

function UpdateInventorySlots() -- line: 2461
    -- upvalues: v1 (ref), t6 (copy), v44 (ref), _EmptySlotsAttribute (ref)
    debug.profilebegin("BackpackController :: UpdateInventorySlots")

    if v44 then
        if v1 then
            v1()
        end
    else
        local t51 = {}
        local t52 = {}
        local t53 = {}
        local t54 = {}
        local t55 = {}

        for i = _EmptySlotsAttribute + 1, #t6 do
            local v272 = t6[i]
            local Tool = v272.Tool

            if Tool then
                if IsOfCategory(Tool) then
                    local ItemType = getAttribute(Tool, "ItemType")

                    if ItemType == "Asset" then
                        table.insert(t51, v272)
                    elseif ItemType == "AssetEgg" then
                        table.insert(t52, v272)
                    elseif ItemType == "Sword" then
                        table.insert(t53, v272)
                    else
                        table.insert(t54, v272)
                    end

                    v272.Frame.Visible = true
                else
                    v272.Frame.Visible = false
                end
            else
                table.insert(t55, v272)
                v272.Frame.Visible = false
            end
        end

        table.sort(t51, function(p137, p138) -- line: 2499
            local Tool = p137.Tool
            local Tool2 = p138.Tool
            local v273 = Tool and isToolFavorite(Tool)

            if v273 ~= (Tool2 and isToolFavorite(Tool2)) then
                return v273
            end

            local v274 = Tool and getAssetRarityNumber(Tool) or 1e999
            local v275 = Tool2 and getAssetRarityNumber(Tool2) or 1e999

            if v274 ~= v275 then
                return v275 < v274
            end

            local v276 = Tool and getAssetEarningRate(Tool) or 0
            local v277 = Tool2 and getAssetEarningRate(Tool2) or 0

            if v276 ~= v277 then
                return v277 < v276
            end

            local v278 = Tool and getAssetOddsDenominator(Tool) or 0
            local v279 = Tool2 and getAssetOddsDenominator(Tool2) or 0

            if v278 ~= v279 then
                return v279 < v278
            end

            local v280 = Tool and getAssetDropWeight(Tool) or 1e999
            local v281 = Tool2 and getAssetDropWeight(Tool2) or 1e999

            if v280 ~= v281 then
                return v280 < v281
            end

            local Weight = Tool and getAttribute(Tool, "Weight") or 0
            local Weight2 = Tool2 and getAttribute(Tool2, "Weight") or 0

            if Weight ~= Weight2 then
                return Weight2 < Weight
            end

            return (Tool and getAttribute(Tool, "UID") or "") < (Tool2 and getAttribute(Tool2, "UID") or "")
        end)

        local t56 = {}

        for _, v282 in ipairs(t52) do
            t56[v282] = isRobuxEgg(getEggRecordFromTool(v282.Tool), v282.Tool)
        end

        table.sort(t52, function(p139, p140) -- line: 2553
            -- upvalues: t56 (copy)
            local Tool = p139.Tool
            local Tool2 = p140.Tool
            local v283

            if t56[p139] then
                v283 = 1e999
            else
                if Tool then
                    v283 = getEggRarityNumber(Tool)
                end

                if not Tool or not v283 then
                    v283 = 1e999
                end
            end

            local v284

            if t56[p140] then
                v284 = 1e999
            else
                if Tool2 then
                    v284 = getEggRarityNumber(Tool2)
                end

                if not Tool2 or not v284 then
                    v284 = 1e999
                end
            end

            if v283 ~= v284 then
                return v284 < v283
            end

            local v285

            if t56[p139] then
                v285 = 0
            else
                if Tool then
                    v285 = getEggBaseEarningRate(Tool)
                end

                if not Tool or not v285 then
                    v285 = 0
                end
            end

            local v286

            if t56[p140] then
                v286 = 0
            else
                if Tool2 then
                    v286 = getEggBaseEarningRate(Tool2)
                end

                if not Tool2 or not v286 then
                    v286 = 0
                end
            end

            if v285 ~= v286 then
                return v286 < v285
            end

            return (Tool and getAttribute(Tool, "UID") or "") < (Tool2 and getAttribute(Tool2, "UID") or "")
        end)
        table.sort(t53, function(p141, p142) -- line: 2583
            return (getAttribute(p141.Tool, "MoneyCost") or 0) > (getAttribute(p142.Tool, "MoneyCost") or 0)
        end)

        local v287 = _EmptySlotsAttribute

        for _, v288 in ipairs(t51) do
            v287 += 1
            v288.Frame.LayoutOrder = v287
        end

        for _, v289 in ipairs(t52) do
            v287 += 1

            local v290 = if v289.Tool then getEggAssetConfig(v289.Tool) else nil
            local Frame = v289.Frame

            if v290 and v290.Egg.HideRarity then
                Frame.LayoutOrder = -2147483648
            else
                Frame.LayoutOrder = v287
            end
        end

        for _, v291 in ipairs(t53) do
            v287 += 1
            v291.Frame.LayoutOrder = v287
        end

        for _, v292 in ipairs(t54) do
            v287 += 1
            v292.Frame.LayoutOrder = v287
        end

        for _, v293 in ipairs(t55) do
            v287 += 1
            v293.Frame.LayoutOrder = v287
        end

        UpdateScrollingFrameCanvasSize()
        debug.profileend()
    end
end

function ResizeContainers() -- line: 2617
    -- upvalues: n1 (ref), Main (ref), v24 (ref), VREnabled (copy), _EmptySlotsAttribute (ref), v46 (copy)
    local v294 = v24

    v294.Size = UDim2.new(0, 5 + _EmptySlotsAttribute * (n1 + 5), 0, n1 + 5 + 5)
    v294.Position = UDim2.new(0.5, -v24.Size.X.Offset / 2, 1, -v24.Size.Y.Offset)

    local Main2 = Main

    Main2.Size = UDim2.new(0, v24.Size.X.Offset, 0, v24.Size.Y.Offset * v46 + 40 + (VREnabled and 80 or 0))
    Main2.Position = UDim2.new(0.5, -Main.Size.X.Offset / 2, 1, v24.Position.Y.Offset - Main.Size.Y.Offset)
    PositionInventoryAffordances()
    AdjustHotbarFrames()
    UpdateInventorySlots()
end

INVENTORY_AFFORDANCE_GAP = 8
PROMPT_HOTBAR_GAP = 28

function PositionInventoryAffordances() -- line: 2641
    -- upvalues: PlatformController (copy), n1 (ref), n3 (ref), v40 (ref)
    local X = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 0

    if X > 0 then
        local v297 = 2.5 - (n1 + 5) * math.max(1, n3) * 0.5

        ButtonHintStrip.PinRight(0.5 + (v297 - PROMPT_HOTBAR_GAP) / X)
    end

    if PlatformController.IsConsole() and v40 then
        ButtonHintStrip.Present("Backpack", Enum.KeyCode.ButtonSelect, "Backpack")
    else
        ButtonHintStrip.Retract("Backpack")
    end
end

function _Clamp(p143, p144, p145) -- line: 2655
    return (math.min(p144, (math.max(p143, p145))))
end

function CheckBounds(p146, p147, p148) -- line: 2656
    local AbsolutePosition, AbsoluteSize = p146.AbsolutePosition, p146.AbsoluteSize

    if AbsolutePosition.X < p147 and p147 <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y < p148 then
        return p148 <= AbsolutePosition.Y + AbsoluteSize.Y
    end

    return false
end

function GetOffset(p149, p150) -- line: 2671
    return (p149.AbsolutePosition + p149.AbsoluteSize / 2 - p150).magnitude
end

UnequipAllTools = function(_, _) -- line: 2675
    -- upvalues: Humanoid (ref)
    requestUnequipVirtualAsset()
    requestUnequipVirtualEgg()

    if Humanoid then
        Humanoid:UnequipTools()
    end
end

function _EquipNewTool(p153) -- line: 2682
    -- upvalues: HiddenUIHandler (copy), v35 (ref), Humanoid (ref)
    if BackpackEnabled and BackpackGui.Enabled and not HiddenUIHandler.IsHidden() and Humanoid ~= nil and not (Humanoid.Health <= 0) then
        UnequipAllTools()
        p153.Parent = v35
    end
end

function _ToggleFavoriteTool(p154) -- line: 2693
    local Tool = p154.Tool

    if Tool then
        requestFavoriteToggle(Tool)
    end
end

function _IsEquipped(p155) -- line: 2702
    -- upvalues: v35 (ref)
    return p155 and p155.Parent == v35
end

function MakeSlot(p156, p157) -- line: 2704
    -- upvalues: TextBox (ref), v1 (ref), GuiService (copy), RunService (copy), MenuNavigation (copy), HiddenUIHandler (copy), AssetIconShape (copy), Trove (copy), SlotDragController (copy), HotbarDragFeedback (copy), Name (copy), v3 (ref), SetCategory (ref), t3 (copy), n1 (ref), t4 (ref), Value (copy), v16 (ref), v20 (ref), v23 (copy), LocalPlayer2 (ref), v24 (ref), Inventory (ref), ScrollingFrame (ref), v35 (ref), Humanoid (ref), Backpack2 (ref), v36 (copy), t6 (copy), v38 (ref), t7 (copy), t8 (copy), t9 (copy), n3 (ref), v40 (ref), v44 (ref), _EmptySlotsAttribute (ref), v49 (copy), v50 (ref), v55 (ref)
    p157 = p157 or #t6 + 1

    local t57 = {
        Tool = nil,
        Frame = nil,
        IsFakeSlot = false,
        FakeType = nil,
        IsDeleted = false,
        Index = p157
    }
    local v300 = p156 == ScrollingFrame or _EmptySlotsAttribute < p157
    local v301, Shadow, ToolName, Weight, Mutations, Template, connection, connection2, connection3
    local t58 = {}
    local v302, v303, Selector, ToolTip, Number, FavIcon, v304, TextXAlignment, TextYAlignment
    local n8 = 0
    local Tool, UICorner

    UICorner = if v300 then script.InventoryTemplate else script.HotbarTemplate

    local clone = UICorner:Clone()

    clone.Name = p157
    clone.ZIndex = 20

    local Icon = clone.Icon
    local CooldownOverlay = NewGui("Frame", "CooldownOverlay")

    CooldownOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    CooldownOverlay.BackgroundTransparency = 0.35
    CooldownOverlay.BorderSizePixel = 0
    CooldownOverlay.Size = UDim2.fromScale(1, 1)
    CooldownOverlay.Visible = false
    CooldownOverlay.ZIndex = 20
    CooldownOverlay.Parent = clone
    UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = script:GetAttribute("CornerRadius")
    UICorner.Parent = CooldownOverlay

    local CooldownLabel = NewGui("TextLabel", "CooldownLabel")

    CooldownLabel.BackgroundTransparency = 1
    CooldownLabel.Size = UDim2.new(1, -4, 1, -4)
    CooldownLabel.Position = UDim2.fromOffset(2, 2)
    CooldownLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
    CooldownLabel.TextColor3 = Color3.new(1, 1, 1)
    CooldownLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    CooldownLabel.TextStrokeTransparency = 0.4
    CooldownLabel.TextScaled = true
    CooldownLabel.TextXAlignment = Enum.TextXAlignment.Center
    CooldownLabel.TextYAlignment = Enum.TextYAlignment.Center
    CooldownLabel.Visible = false
    CooldownLabel.ZIndex = CooldownOverlay.ZIndex + 1
    CooldownLabel.Text = ""
    CooldownLabel.Parent = CooldownOverlay

    local v305 = Trove.new()

    local function restoreAssetIconHover(_) -- line: 2778
    end

    local function clearSlotOverlays() -- line: 2780
        -- upvalues: Mutations (ref), Template (ref), clone (copy), v305 (copy)
        v305:Clean()
        clearMutationIconFrame(Mutations, Template)

        if clone then
            clone:SetAttribute("HasAssetOverlay", nil)
            clone:SetAttribute("HasEggOverlay", nil)
            clone:SetAttribute("HasSwordOverlay", nil)
        end
    end

    local function isDragRestrictedItemType(_) -- line: 2790
        return false
    end

    local function canPlaceToolInSlot(p160, p161) -- line: 2792
        -- upvalues: _EmptySlotsAttribute (ref)
        if p160.IsFakeSlot then
            return false
        end

        if p161 and not (p160.Index > _EmptySlotsAttribute) then
            if not canToolUseHotbarSlot(p161, p160.Index) then
                return false
            end

            if typeof(p161) == "table" and (p161.IsVirtualAsset or p161.IsVirtualEgg) then
                return getHotbarFillTool(p161) ~= nil
            end

            getAttribute(p161, "ItemType")
        end

        return true
    end

    local function shouldAllowSlotDragging(p162) -- line: 2818
        -- upvalues: t57 (copy), canPlaceToolInSlot (copy), Inventory (ref), _EmptySlotsAttribute (ref)
        p162 = p162 or t57.Tool

        if not p162 then
            return false
        end

        if typeof(p162) == "Instance" or typeof(p162) == "table" and (p162.IsVirtualAsset or p162.IsVirtualEgg) then
            getAttribute(p162, "ItemType")

            if not canPlaceToolInSlot(t57, p162) or UserInputService.VREnabled then
                return false
            end

            return not (t57.Index <= _EmptySlotsAttribute) or Inventory.Visible
        end

        return false
    end

    function t57.RefreshDragDetector(_) -- line: 2848
        -- upvalues: v301 (ref), clone (copy), MenuNavigation (copy)
        if not v301 then
            return
        end

        local v307 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad and not MenuNavigation.IsCursorActive()

        v301:SetEnabled(clone:GetAttribute("Draggable") == true and not v307 and not UserInputService.VREnabled)
    end

    local function applySlotDraggableState(p164) -- line: 2859
        -- upvalues: t57 (copy), clone (copy)
        clone:SetAttribute("Draggable", p164)
        t57:RefreshDragDetector()
    end

    local function stopCooldownHeartbeat() -- line: 2864
        -- upvalues: v302 (ref)
        if v302 then
            v302:Disconnect()
            v302 = nil
        end
    end

    local function disconnectCooldownConnections() -- line: 2871
        -- upvalues: t58 (ref)
        for _, v309 in ipairs(t58) do
            v309:Disconnect()
        end

        t58 = {}
    end

    local function hideCooldownOverlay() -- line: 2878
        -- upvalues: v302 (ref), CooldownOverlay (copy), CooldownLabel (copy)
        if v302 then
            v302:Disconnect()
            v302 = nil
        end

        if CooldownOverlay then
            CooldownOverlay.Visible = false
        end

        if CooldownLabel then
            CooldownLabel.Visible = false
            CooldownLabel.Text = ""
        end
    end

    local function updateCooldownDisplay() -- line: 2889
        -- upvalues: t57 (copy), v302 (ref), CooldownOverlay (copy), CooldownLabel (copy)
        local Tool = t57.Tool

        if Tool then
            local CooldownEndTime = Tool:GetAttribute("CooldownEndTime")

            if typeof(CooldownEndTime) == "number" and not (CooldownEndTime <= 0) and Tool:GetAttribute("CooldownActive") then
                local v310 = CooldownEndTime - workspace:GetServerTimeNow()

                if v310 <= 1 then
                    if v302 then
                        v302:Disconnect()
                        v302 = nil
                    end

                    if CooldownOverlay then
                        CooldownOverlay.Visible = false
                    end

                    if CooldownLabel then
                        CooldownLabel.Visible = false
                        CooldownLabel.Text = ""
                    end

                    return false
                end

                if CooldownOverlay then
                    CooldownOverlay.Visible = true
                end

                if CooldownLabel then
                    CooldownLabel.Visible = true
                    CooldownLabel.Text = tostring((math.max(math.ceil(v310), 0)))
                end

                return true
            end
        end

        if v302 then
            v302:Disconnect()
            v302 = nil
        end

        if CooldownOverlay then
            CooldownOverlay.Visible = false
        end

        if CooldownLabel then
            CooldownLabel.Visible = false
            CooldownLabel.Text = ""
        end

        return false
    end

    local function ensureCooldownHeartbeat(p165) -- line: 2926
        -- upvalues: t57 (copy), v302 (ref), CooldownOverlay (copy), CooldownLabel (copy), updateCooldownDisplay (copy), RunService (copy)
        v302 = v302 or RunService.Heartbeat:Connect(function() -- line: 2931
            -- upvalues: p165 (copy), t57 (copy), v302 (ref), CooldownOverlay (copy), CooldownLabel (copy), updateCooldownDisplay (copy)
            if t57.Tool == p165 then
                if not updateCooldownDisplay() and v302 then
                    v302:Disconnect()
                    v302 = nil
                end
            else
                if v302 then
                    v302:Disconnect()
                    v302 = nil
                end

                if CooldownOverlay then
                    CooldownOverlay.Visible = false
                end

                if CooldownLabel then
                    CooldownLabel.Visible = false
                    CooldownLabel.Text = ""
                end

                if v302 then
                    v302:Disconnect()
                    v302 = nil
                end
            end
        end)
    end

    local function connectCooldownListeners(p166) -- line: 2944
        -- upvalues: t57 (copy), t58 (ref), v302 (ref), CooldownOverlay (copy), CooldownLabel (copy), disconnectCooldownConnections (copy), updateCooldownDisplay (copy), RunService (copy)
        disconnectCooldownConnections()

        if v302 then
            v302:Disconnect()
            v302 = nil
        end

        if CooldownOverlay then
            CooldownOverlay.Visible = false
        end

        if CooldownLabel then
            CooldownLabel.Visible = false
            CooldownLabel.Text = ""
        end

        if not p166 then
            return
        end

        local function onAttributeChanged() -- line: 2952
            -- upvalues: p166 (copy), t57 (copy), v302 (ref), CooldownOverlay (copy), CooldownLabel (copy), updateCooldownDisplay (copy), RunService (copy)
            if updateCooldownDisplay() then
                v302 = v302 or RunService.Heartbeat:Connect(function() -- line: 2931
                    -- upvalues: p166 (copy), t57 (copy), v302 (ref), CooldownOverlay (copy), CooldownLabel (copy), updateCooldownDisplay (copy)
                    if t57.Tool == p166 then
                        if not updateCooldownDisplay() and v302 then
                            v302:Disconnect()
                            v302 = nil
                        end
                    else
                        if v302 then
                            v302:Disconnect()
                            v302 = nil
                        end

                        if CooldownOverlay then
                            CooldownOverlay.Visible = false
                        end

                        if CooldownLabel then
                            CooldownLabel.Visible = false
                            CooldownLabel.Text = ""
                        end

                        if v302 then
                            v302:Disconnect()
                            v302 = nil
                        end
                    end
                end)
            elseif v302 then
                v302:Disconnect()
                v302 = nil
            end
        end

        local t59 = t58

        table.insert(t59, p166:GetAttributeChangedSignal("CooldownEndTime"):Connect(onAttributeChanged))

        local t60 = t58

        table.insert(t60, p166:GetAttributeChangedSignal("CooldownActive"):Connect(onAttributeChanged))

        local t61 = t58

        table.insert(t61, p166:GetAttributeChangedSignal("CooldownDuration"):Connect(onAttributeChanged))

        if updateCooldownDisplay() then
            v302 = v302 or RunService.Heartbeat:Connect(function() -- line: 2931
                -- upvalues: p166 (copy), t57 (copy), v302 (ref), CooldownOverlay (copy), CooldownLabel (copy), updateCooldownDisplay (copy)
                if t57.Tool == p166 then
                    if not updateCooldownDisplay() and v302 then
                        v302:Disconnect()
                        v302 = nil
                    end
                else
                    if v302 then
                        v302:Disconnect()
                        v302 = nil
                    end

                    if CooldownOverlay then
                        CooldownOverlay.Visible = false
                    end

                    if CooldownLabel then
                        CooldownLabel.Visible = false
                        CooldownLabel.Text = ""
                    end

                    if v302 then
                        v302:Disconnect()
                        v302 = nil
                    end
                end
            end)
        elseif v302 then
            v302:Disconnect()
            v302 = nil
        end
    end

    function t57.updateDragAppearance(p167) -- line: 2977
        -- upvalues: t57 (copy), v300 (copy), clone (copy)
        if t57.IsFakeSlot then
            clone.BackgroundTransparency = SlotLockedTransparencyAttribute
            clone.BackgroundColor3 = BackgroundColorAttribute
        else
            clone.SelectionImageObject = nil

            local v313 = p167.Tool and getAttribute(p167.Tool, "ItemType")

            if v300 then
                clone.BackgroundTransparency = (v313 == "Asset" or v313 == "Sword") and 0.5 or 0.5
                clone.BackgroundColor3 = Color3.new(0, 0, 0)
            else
                local Draggable = clone:GetAttribute("Draggable")

                clone.BackgroundTransparency = SlotLockedTransparencyAttribute
                clone.BackgroundColor3 = Draggable and DraggableColorAttribute or BackgroundColorAttribute
            end
        end
    end

    function t57.Readjust(_, p169, p170) -- line: 2999
        -- upvalues: clone (copy), n1 (ref), v24 (ref)
        local v315 = v24.Size.X.Offset / 2
        local v316 = n1 + 5
        local v317 = p169 - (p170 / 2 + 0.5)
        local AnchorPoint, Size = clone.AnchorPoint, clone.Size

        clone.Position = UDim2.new(0, v315 - n1 / 2 + v316 * v317 + Size.X.Offset * AnchorPoint.X, 0, 5 + Size.Y.Offset * AnchorPoint.Y)
    end

    function t57.SetNumberText(_, p172) -- line: 3014
        -- upvalues: Number (ref), v304 (ref)
        if not Number then
            return
        end

        Number.Text = p172 or v304 or ""
    end

    function t57.Fill(p173, p174) -- line: 3019
        -- upvalues: t57 (copy), v301 (ref), Shadow (ref), ToolName (ref), Weight (ref), Mutations (ref), Template (ref), connection (ref), connection2 (ref), connection3 (ref), v302 (ref), Selector (ref), ToolTip (ref), TextXAlignment (ref), TextYAlignment (ref), n8 (ref), Tool (ref), v300 (copy), clone (copy), Icon (copy), CooldownOverlay (copy), CooldownLabel (copy), v305 (copy), clearSlotOverlays (copy), canPlaceToolInSlot (copy), shouldAllowSlotDragging (copy), disconnectCooldownConnections (copy), connectCooldownListeners (copy), AssetIconShape (copy), v20 (ref), Inventory (ref), v38 (ref), t7 (copy), n3 (ref), v40 (ref), v44 (ref), _EmptySlotsAttribute (ref)
        if not ((not p173.IsFakeSlot or p173.FakeType == "SwordEquip") and (not p174 or canPlaceToolInSlot(p173, p174))) then
            return
        end

        if v301 then
            v301:Cancel()
        end

        if p173.Tool ~= p174 then
            n8 = 0
            Tool = nil
        end

        clearSlotOverlays()

        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        disconnectCooldownConnections()

        if v302 then
            v302:Disconnect()
            v302 = nil
        end

        if CooldownOverlay then
            CooldownOverlay.Visible = false
        end

        if CooldownLabel then
            CooldownLabel.Visible = false
            CooldownLabel.Text = ""
        end

        if not p174 then
            return p173:Clear()
        end

        if p173.Tool and p173.Tool ~= p174 then
            p173:Clear()
        end

        local v318 = typeof(p174) == "Instance"
        local ItemType = getAttribute(p174, "ItemType")
        local v319 = getRegisteredBackpackSlot(p174)

        if v319 and v319 ~= p173 and registeredSlotContainsTool(v319, p174) then
            v319:Clear()

            if v319.Index > _EmptySlotsAttribute then
                v319:Delete()
            end
        end

        p173.Tool = p174
        registerVirtualBackpackSlot(p173, p174)
        p173:UpdateFavoriteVisual()

        if v318 then
            connection2 = p174:GetAttributeChangedSignal("Favorite"):Connect(function() -- line: 3070
                -- upvalues: p173 (copy), p174 (copy)
                p173:UpdateFavoriteVisual()

                if isAssetTool(p174) then
                    UpdateInventorySlots()
                end
            end)
        end

        function t57.UpdateVisuals() -- line: 3077
            -- upvalues: p173 (copy), p174 (copy), ItemType (copy), Shadow (ref), ToolName (ref), Weight (ref), Mutations (ref), Template (ref), Selector (ref), ToolTip (ref), TextXAlignment (ref), TextYAlignment (ref), v300 (copy), Icon (copy), AssetIconShape (copy), _EmptySlotsAttribute (ref)
            local TextureId = p174.TextureId

            AssetIconShape.Strip(Icon)
            Icon.Image = TextureId
            Icon.ScaleType = Enum.ScaleType.Fit

            local ToolName2 = ToolName

            ToolName2.TextXAlignment = TextXAlignment
            ToolName2.TextYAlignment = TextYAlignment
            Shadow.Visible = false
            clearMutationIconFrame(Mutations, Template)

            for _, child in ipairs(Shadow:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy()
                end
            end

            for _, child in ipairs(ToolName:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy()
                end
            end

            for _, child in ipairs(Weight:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy()
                end
            end

            local v320 = string.match(p174.Name, "%[X(%d+)%]")
            local Name = p174.Name
            local v321, v322

            if ItemType == "Asset" then
                local Category = getAttribute(p174, "Category")
                local v325 = Category and AssetDirectory[Category]

                if v325 then
                    local v326 = getAssetItemData(p174)

                    if v326 then
                        AssetIconShape.Paint(Icon, v326)
                    else
                        Icon.Image = v325.Icon or TextureId
                    end

                    Icon.ImageColor3 = Color3.new(1, 1, 1)

                    if v325.Rarity and v325.Rarity.RarityGradient then
                        local ToolName2 = ToolName

                        v325.Rarity.RarityGradient:Clone().Parent = ToolName2

                        if v300 then
                            v325.Rarity.RarityGradient:Clone().Parent = Shadow
                        end
                    end
                end

                Shadow.Visible = v300

                local v327 = getAssetItemData(p174)

                Name = if v327 then getAssetItemDisplayNameWithVisualWeight(v327, v325 or BaseAssetConfig) else getAttribute(p174, "DisplayName") or p174.Name

                local v328 = parseMutations(getAttribute(p174, "Mutations"))
                local BaseMutation = getAttribute(p174, "BaseMutation")

                if not v300 and (typeof(p174) ~= "table" or not p174.IsVirtualAsset) then
                    Name = ""
                    v322 = true
                else
                    populateMutationIconFrame(Mutations, Template, BaseMutation, v328)
                    v322 = not not v300
                end

                v321 = Name
            elseif ItemType == "AssetEgg" then
                local v329 = getEggRecordFromTool(p174)
                local v330, v331 = getEggConfigForRecord(v329)

                if v330 and v331 then
                    local v332 = getEggIconForRecord(v329, v330)

                    Icon.Image = v332 ~= "" and v332 or TextureId
                    Icon.ImageColor3 = Color3.new(1, 1, 1)

                    if not v330.HideRarity and not isRobuxEgg(v329, p174) and v331.Rarity and v331.Rarity.RarityGradient then
                        local ToolName2 = ToolName

                        v331.Rarity.RarityGradient:Clone().Parent = ToolName2

                        if v300 then
                            v331.Rarity.RarityGradient:Clone().Parent = Shadow
                        end
                    end
                end

                Shadow.Visible = v300
                Name = if v329 then getEggDisplayNameWithWeight(v329) else getAttribute(p174, "DisplayName") or p174.Name
                v321 = Name
                v322 = true
            elseif ItemType ~= "Gear" and ItemType ~= "MutationConsumable" and ItemType ~= "MountStar" then
                if TextureId == "" then
                    v321 = Name
                    v322 = true
                elseif v320 then
                    Name = ""
                    v321 = ""
                    v322 = true
                else
                    v321 = Name
                    v322 = false
                end
            else
                local v333 = getGearConfig(p174)
                local v334

                if not TextureId or TextureId == "" then
                    local Icon = if v333 then v333.Icon else nil

                    v334 = if not v333 or not Icon then "" else Icon
                else
                    v334 = TextureId
                end

                Icon.Image = v334
                Icon.ImageColor3 = Color3.new(1, 1, 1)
                Shadow.Visible = false
                v321 = if shouldDisplayToolUses(p174) then getToolUsesText(p174) else ""
                v322 = v321 ~= ""

                if v322 then
                    local ToolName2 = ToolName

                    ToolName2.TextXAlignment = Enum.TextXAlignment.Center
                    ToolName2.TextYAlignment = Enum.TextYAlignment.Center
                end

                Name = ""
            end

            local v323 = ""
            local v324 = false
            local v336, v337, v338, v339, v340

            if v300 then
                v340 = v324
                v337 = Name
                v336 = v321
                v338 = v322
                v339 = v323
            else
                local v341, v342, v343

                if shouldDisplayToolUses(p174) then
                    v343 = v322
                    v341 = Name
                    v342 = v321
                else
                    v341 = ""
                    v342 = ""
                    v343 = false
                end

                v337 = v341
                v336 = v342
                v338 = v343
                v339 = ""
                v340 = false
            end

            ToolName2.Text = v336 or v337
            ToolName2.Visible = v338

            local Weight2 = Weight

            Weight2.Text = v339
            Weight2.Visible = v340

            if Selector then
                Selector.Visible = true
            end

            if ToolTip and p174:IsA("Tool") then
                if p173.Index <= _EmptySlotsAttribute and (ItemType == "Asset" or ItemType == "Pet" or ItemType == "AssetEgg" or ItemType == "Gear") then
                    local ToolTip2 = ToolTip

                    ToolTip2.Text = ""
                    ToolTip2.Visible = false
                else
                    local ToolTip2 = p174.ToolTip

                    if ToolTip2 == "" then
                        ToolTip2 = p174.Name
                    end

                    ToolTip.Text = ToolTip2
                end
            end
        end

        t57.UpdateVisuals()

        if connection then
            connection:Disconnect()
            connection = nil
        end

        if v318 then
            connection = p174.Changed:Connect(function(p175) -- line: 3271
                -- upvalues: t57 (copy)
                if p175 == "TextureId" or p175 == "Name" or p175 == "ToolTip" then
                    t57.UpdateVisuals()
                end
            end)
        end

        if not v318 or ItemType ~= "Asset" then
            if v318 and (ItemType == "Gear" or ItemType == "MutationConsumable" or ItemType == "MountStar") then
                connection3 = p174:GetAttributeChangedSignal("Uses"):Connect(function() -- line: 3286
                    -- upvalues: t57 (copy)
                    t57.UpdateVisuals()
                end)

                if ItemType == "Gear" then
                    connectCooldownListeners(p174)
                end
            end
        else
            connection3 = p174:GetAttributeChangedSignal("Weight"):Connect(function() -- line: 3280
                UpdateInventorySlots()
            end)
        end

        local v344 = p173.Index <= _EmptySlotsAttribute

        clone:SetAttribute("Draggable", (shouldAllowSlotDragging(p174)))
        t57:RefreshDragDetector()
        p173:UpdateEquipView()

        if v344 and not p173.IsFakeSlot then
            n3 += 1

            if v40 and n3 >= 1 and not v20 then
                v20 = true
                ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
            end
        end

        if typeof(p174) == "Instance" then
            t7[p174] = p173
        end

        if ItemType == "Asset" then
            local v346 = AssetDirectory[getAttribute(p174, "Category")] or BaseAssetConfig
            local v347 = getAssetItemData(p174) or {}

            addVirtualAssetOverlay(clone, v347, v346, v305)
        elseif ItemType == "AssetEgg" then
            local v348 = getEggRecordFromTool(p174)

            if v348 then
                addVirtualEggOverlay(clone, v348, v305, p174)
            end
        end

        v38 = FindLowestEmpty()

        if v300 and Inventory.Visible and not v44 then
            clone.Visible = IsOfCategory(p174)
        end
    end

    function t57.Clear(p176) -- line: 3332
        -- upvalues: t57 (copy), v301 (ref), Shadow (ref), ToolName (ref), Weight (ref), connection (ref), connection2 (ref), connection3 (ref), v302 (ref), ToolTip (ref), FavIcon (ref), n8 (ref), Tool (ref), clone (copy), Icon (copy), CooldownOverlay (copy), CooldownLabel (copy), clearSlotOverlays (copy), disconnectCooldownConnections (copy), AssetIconShape (copy), v20 (ref), v38 (ref), n3 (ref), _EmptySlotsAttribute (ref)
        if not p176.Tool or p176.IsFakeSlot then
            return
        end

        if v301 then
            v301:Cancel()
        end

        n8 = 0
        Tool = nil
        clearSlotOverlays()

        if connection then
            connection:Disconnect()
            connection = nil
        end

        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        disconnectCooldownConnections()

        if v302 then
            v302:Disconnect()
            v302 = nil
        end

        if CooldownOverlay then
            CooldownOverlay.Visible = false
        end

        if CooldownLabel then
            CooldownLabel.Visible = false
            CooldownLabel.Text = ""
        end

        for _, child in ipairs(Shadow:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy()
            end
        end

        Shadow.Visible = false
        AssetIconShape.Strip(Icon)
        Icon.Image = ""

        local ToolName2 = ToolName

        ToolName2.Text = ""
        ToolName2.Visible = true

        local Weight2 = Weight

        Weight2.Text = ""
        Weight2.Visible = false

        if ToolTip then
            local ToolTip2 = ToolTip

            ToolTip2.Text = ""
            ToolTip2.Visible = false
        end

        clone:SetAttribute("Draggable", false)
        t57:RefreshDragDetector()
        FavIcon.Visible = false
        p176:UpdateEquipView(true)

        if p176.Index <= _EmptySlotsAttribute and not p176.IsFakeSlot then
            n3 -= 1

            if n3 < 1 then
                v20 = false
                ContextActionService:UnbindAction("RBXHotbarEquip")
            end
        end

        unregisterBackpackSlotTool(p176, p176.Tool)
        p176.Tool = nil
        v38 = FindLowestEmpty()
    end

    function t57.UpdateEquipView(p177, p178) -- line: 3394
        -- upvalues: v303 (ref), clone (copy), v35 (ref), v50 (ref), v55 (ref)
        if p177.IsFakeSlot then
            return
        end

        local ItemType = getAttribute(p177.Tool, "ItemType")
        local v349 = false

        if ItemType == "Asset" and typeof(p177.Tool) == "table" then
            v349 = not not p177.Tool.IsVirtualAsset
        end

        local v350

        if v349 then
            v350 = not p178 and virtualAssetMatchesUID(p177.Tool, v50)
        elseif ItemType == "AssetEgg" and typeof(p177.Tool) == "table" and not not p177.Tool.IsVirtualEgg then
            v350 = not p178

            if v350 then
                v350 = typeof(v55) == "string" and p177.Tool.UID == v55
            end
        elseif p178 then
            v350 = false
        else
            local Tool = p177.Tool

            v350 = if Tool and typeof(Tool) == "Instance" then Tool.Parent == v35 else false
        end

        if v350 then
            if not v303 then
                v303 = NewGui("Frame", "Equipped")
                v303.ZIndex = 3
                v303.Size = UDim2.fromScale(1, 1)
                v303.AnchorPoint = Vector2.new(0.5, 0.5)
                v303.Position = UDim2.fromScale(0.5, 0.5)

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = script:GetAttribute("CornerRadius")
                UICorner.Parent = v303

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Color = EquippedColorAttribute
                UIStroke.Thickness = 3.8
                UIStroke.Parent = v303
            end

            v303.Parent = clone
        elseif v303 then
            v303.Parent = nil
        end
    end

    function t57.Delete(p179) -- line: 3434
        -- upvalues: v301 (ref), v302 (ref), clone (copy), CooldownOverlay (copy), CooldownLabel (copy), clearSlotOverlays (copy), disconnectCooldownConnections (copy), t6 (copy)
        if p179.IsFakeSlot or p179.IsDeleted then
            return
        end

        p179.IsDeleted = true

        if v301 then
            v301:Destroy()
        end

        if p179.Tool then
            p179:Clear()
        end

        clearSlotOverlays()
        disconnectCooldownConnections()

        if v302 then
            v302:Disconnect()
            v302 = nil
        end

        if CooldownOverlay then
            CooldownOverlay.Visible = false
        end

        if CooldownLabel then
            CooldownLabel.Visible = false
            CooldownLabel.Text = ""
        end

        clone:Destroy()

        local v356 = table.find(t6, p179)

        if v356 then
            table.remove(t6, v356)

            for i = v356, #t6 do
                t6[i]:SlideBack()
            end
        end

        UpdateScrollingFrameCanvasSize()
    end

    function t57.UpdateFavoriteVisual(p180) -- line: 3462
        -- upvalues: FavIcon (ref)
        if FavIcon and p180.Tool then
            local v357 = isToolFavorite(p180.Tool)

            if FavIcon.Visible ~= v357 then
                FavIcon.Visible = v357

                return true
            end
        end

        return false
    end

    function t57.CanSwap(p181, p182) -- line: 3473
        -- upvalues: canPlaceToolInSlot (copy)
        if p181.IsFakeSlot or p182.IsFakeSlot then
            return false
        end

        local Tool = p181.Tool
        local Tool2 = p182.Tool

        if Tool and isToolLockedToCurrentHotbarSlot(p181) and p182 ~= p181 or Tool2 and isToolLockedToCurrentHotbarSlot(p182) and p181 ~= p182 or Tool and not canPlaceToolInSlot(p182, Tool) then
            return false
        end

        local v358 = if Tool2 then canPlaceToolInSlot(p181, Tool2) else nil

        return not not (not Tool2 or v358)
    end

    function t57.Swap(p183, p184) -- line: 3495
        if p183:CanSwap(p184) then
            local Tool = p183.Tool
            local Tool2 = p184.Tool

            p183:Clear()

            if Tool2 then
                p184:Clear()
                p183:Fill(Tool2)
            end

            if Tool then
                p184:Fill(Tool)
            else
                p184:Clear()
            end
        end
    end

    function t57.SlideBack(p185) -- line: 3514
        -- upvalues: clone (copy)
        p185.Index -= 1
        clone.Name = p185.Index
        clone.LayoutOrder = p185.Index
    end

    function t57.TurnNumber(_, p187) -- line: 3519
        -- upvalues: Number (ref)
        if Number then
            Number.Visible = p187
        end
    end

    function t57.SetClickability(p188, p189) -- line: 3525
        -- upvalues: t57 (copy), clone (copy), shouldAllowSlotDragging (copy)
        if p188.IsFakeSlot or not p188.Tool then
            return
        end

        clone:SetAttribute("Draggable", not p189 and shouldAllowSlotDragging(p188.Tool))
        t57:RefreshDragDetector()
        p188:updateDragAppearance()
    end

    function t57.CheckTerms(p190, p191) -- line: 3536
        -- upvalues: ToolName (ref), ToolTip (ref)
        local Tool = p190.Tool
        local v360

        if not Tool then
            v360 = 0

            return v360
        end

        local t62 = {}

        if ToolName and ToolName.Text ~= "" then
            table.insert(t62, ToolName.Text:lower())
        end

        local v361 = typeof(Tool) == "table"
        local Name = Tool.Name

        if v361 then
            Name = Name or Tool.Name
        end

        if Name then
            table.insert(t62, tostring(Name):lower())
        end

        local v363 = ToolTip and ToolTip.Text

        if v363 and v363 ~= "" then
            table.insert(t62, v363:lower())
        end

        local v364 = typeof(Tool) == "table"
        local ToolTip2 = Tool.ToolTip

        if v364 then
            ToolTip2 = ToolTip2 or Tool.ToolTip
        end

        if ToolTip2 and ToolTip2 ~= "" then
            table.insert(t62, tostring(ToolTip2):lower())
        end

        local n9 = 0

        v360 = 0

        for v366 in pairs(p191) do
            for _, v368 in ipairs(t62) do
                local _, v369 = v368:gsub(v366, "")

                n9 += v369
            end

            v360 = n9
        end

        return v360
    end

    function t57.Select(p192) -- line: 3569
        -- upvalues: HiddenUIHandler (copy), t3 (copy), t4 (ref), v35 (ref), Humanoid (ref), Backpack2 (ref), _EmptySlotsAttribute (ref), v50 (ref)
        local Tool = p192.Tool

        if not Tool then
            return
        end

        if t4 then
            if t4.ItemType == getAttribute(Tool, "ItemType") and (p192.Index > _EmptySlotsAttribute or t4.AllowHotbar) then
                local Validator = t4.Validator

                if not Validator or Validator(Tool) ~= false then
                    local t64 = t4

                    if ActiveFuseSelectionState then
                        t3:EndFuseSelection()
                        task.spawn(t64.Callback, Tool)
                    else
                        t64.Callback(Tool)

                        if t64.Preserve ~= true then
                            t4 = nil
                        end
                    end

                    return
                end
            end

            if ActiveFuseSelectionState then
                return
            end
        end

        if not BackpackEnabled or not BackpackGui.Enabled or HiddenUIHandler.IsHidden() then
            return
        end

        if typeof(Tool) == "table" and Tool.IsVirtualAsset then
            local v370 = _getAssetUID(Tool)

            if typeof(v370) == "string" then
                SelectedSlot = p192

                local v371 = findAssetToolByUID(v370)

                if v371 and Humanoid then
                    if v371.Parent == v35 then
                        Humanoid:UnequipTools()
                    else
                        Humanoid:UnequipTools()
                        Humanoid:EquipTool(v371)
                    end
                elseif v50 == v370 then
                    requestUnequipVirtualAsset()
                end

                updateEquipSelectionVisuals()
            end
        elseif typeof(Tool) == "table" and Tool.IsVirtualEgg then
            local v373 = reconcileVirtualEggEquipState()
            local UID = getAttribute(Tool, "UID")

            if typeof(UID) == "string" then
                if v373 == UID then
                    requestUnequipVirtualEgg()
                else
                    requestEquipVirtualEgg(UID, p192)
                end
            end
        else
            SelectedSlot = p192

            if Tool.Parent == v35 then
                SelectedSlot = nil

                if Humanoid then
                    UnequipAllTools()
                end
            elseif Tool.Parent == Backpack2 then
                if Humanoid == nil or Humanoid.Health <= 0 then
                    SelectedSlot = nil
                else
                    UnequipAllTools()
                    Tool.Parent = v35
                end
            end
        end
    end

    t57.MainImage = clone.ImageLabel

    local BaseTemplate = clone.BaseTemplate

    BaseTemplate.Amount.Visible = false
    BaseTemplate.Amount.Text = ""
    Mutations = BaseTemplate:FindFirstChild("Mutations")
    Template = Mutations and Mutations:FindFirstChild("Template")
    clearMutationIconFrame(Mutations, Template)

    local UIStroke = clone.UIStroke

    UIStroke.Thickness = 0
    clone.BackgroundColor3 = v300 and Color3.new(0, 0, 0) or BackgroundColorAttribute
    UIStroke.Color = BorderColorAttribute
    clone.Text = ""
    clone.AutoButtonColor = false
    clone.BorderSizePixel = 0

    local v375 = p156 == ScrollingFrame and v23 or n1

    clone.Size = UDim2.new(0, v375, 0, v375)
    clone.Active = true
    clone.Draggable = false
    clone:SetAttribute("Draggable", false)
    clone:SetAttribute("IsInventorySlot", v300)

    local v374 = if v300 then 0.5 else SlotLockedTransparencyAttribute

    clone.BackgroundTransparency = v374
    ButtonFX(clone, 1.015, nil, true)

    local function activateSlot(p193) -- line: 3684
        -- upvalues: t57 (copy), v301 (ref), n8 (ref), Tool (ref), clone (copy), canPlaceToolInSlot (copy), shouldAllowSlotDragging (copy), v1 (ref), GuiService (copy), MenuNavigation (copy), HiddenUIHandler (copy), t4 (ref), v16 (ref), _EmptySlotsAttribute (ref)
        if os.clock() < 0 or v301 and v301:IsActivationSuppressed() then
            return
        end

        local Tool2 = t57.Tool

        if v16 and Tool2 and isAssetTool(Tool2) then
            n8 = 0
            Tool = nil
            requestFavoriteToggle(Tool2)
        else
            local v376 = p193 == Enum.UserInputType.MouseButton1 or p193 == Enum.UserInputType.MouseMovement or p193 == Enum.UserInputType.Touch
            local v377, v378

            if v376 then
                if not (t57.Index > _EmptySlotsAttribute) or Tool2 == nil then
                    v378 = false
                else
                    local v379 = not t57.IsDeleted

                    if v379 then
                        local v380 = not v16

                        if v380 then
                            local v381 = not t4

                            if v381 then
                                local v382 = not ActiveFuseSelectionState

                                if v382 then
                                    v377 = not BackpackEnabled or not BackpackGui.Enabled or HiddenUIHandler.IsHidden()
                                    v378 = not v377

                                    if v378 then
                                        v378 = clone:GetAttribute("Draggable") == true and shouldAllowSlotDragging(Tool2) and (MenuNavigation.IsCursorActive() or clone ~= GuiService.SelectedObject)
                                    end
                                else
                                    v378 = v382
                                end
                            else
                                v378 = v381
                            end
                        else
                            v378 = v380
                        end
                    else
                        v378 = v379
                    end
                end
            else
                v378 = v376
            end

            local elapsed = os.clock()
            local v383 = v378 and Tool == Tool2 and elapsed - n8 < 0.5

            Tool = if not v378 or v383 then nil else Tool2

            if not v378 or v383 then
                elapsed = 0
            end

            n8 = elapsed

            local v384 = true

            if v383 then
                local v385 = FindLowestEmpty(Tool2)

                if v385 and canPlaceToolInSlot(v385, Tool2) then
                    t57:Swap(v385)

                    if not t57.Tool then
                        t57:Delete()
                    end

                    v384 = false
                end
            end

            if v384 then
                changeSlot(t57)
            elseif v1 then
                task.defer(function() -- line: 3722
                    -- upvalues: v1 (ref)
                    v1(true)
                end)
            end
        end
    end

    clone.Activated:Connect(function(p194) -- line: 3730
        -- upvalues: v301 (ref), activateSlot (copy)
        local activateSlot2, UserInputType

        if not v301 or v301:ShouldHandleNativeActivation() then
            activateSlot2 = activateSlot
            UserInputType = p194 and p194.UserInputType
            activateSlot2(UserInputType)
        end
    end)

    if UserInputService.TouchEnabled then
        clone.TouchLongPress:Connect(function(_, p196, _) -- line: 3738
            -- upvalues: t57 (copy), v301 (ref)
            if not (p196 ~= Enum.UserInputState.End or v301 and v301:IsActivationSuppressed()) then
                local Tool = t57.Tool

                if Tool and isAssetTool(Tool) then
                    requestFavoriteToggle(Tool)
                end
            end
        end)
    end

    v49:Register(clone, {
        GetTool = function() -- GetTool | line: 3750
            -- upvalues: t57 (copy)
            return t57.Tool
        end,
        CanFavorite = function(p198) -- CanFavorite | line: 3751
            -- upvalues: t57 (copy), v301 (ref), t4 (ref), Inventory (ref)
            local Visible = Inventory.Visible
            local v388, v389

            if Visible then
                local v390 = not t57.IsDeleted

                if v390 then
                    if p198 ~= nil then
                        local v391 = isAssetTool(p198)

                        if v391 then
                            local v392 = not ActiveFuseSelectionState

                            if v392 then
                                local v393 = not t4

                                if v393 then
                                    v388 = v301 and v301:IsActivationSuppressed()
                                    v389 = not v388
                                else
                                    v389 = v393
                                end
                            else
                                v389 = v392
                            end
                        else
                            v389 = v391
                        end
                    else
                        v389 = false
                    end
                else
                    v389 = v390
                end
            else
                v389 = Visible
            end

            return v389
        end,
        OnFavorite = function(p199) -- OnFavorite | line: 3756
            -- upvalues: v301 (ref), n8 (ref), Tool (ref)
            n8 = 0
            Tool = nil

            if v301 then
                v301:Cancel()
            end

            requestFavoriteToggle(p199)
        end
    })
    t57.Frame = clone
    Selector = clone.SelectionObjectClipper.Selector
    Shadow = clone.Shadow
    Shadow.Visible = false
    t57.IconImage = Icon
    FavIcon = clone.FavIcon
    FavIcon.Visible = false
    ToolName = clone.ToolName
    TextXAlignment = ToolName.TextXAlignment
    TextYAlignment = ToolName.TextYAlignment
    Weight = clone.Weight
    Weight.Visible = false
    t57.Frame.LayoutOrder = t57.Index

    local v394, v395

    if p157 <= _EmptySlotsAttribute then
        clone.StrokeFrame.Visible = false
        ToolTip = clone.ToolTip
        ToolTip.Visible = false
        t57.TooltipLabel = ToolTip
        clone.MouseEnter:Connect(function() -- line: 3788
            -- upvalues: ToolTip (ref)
            if ToolTip.Text ~= "" then
                ToolTip.Visible = false
            end
        end)
        clone.MouseLeave:Connect(function() -- line: 3793
            -- upvalues: ToolTip (ref)
            ToolTip.Visible = false
        end)

        function t57.MoveToInventory(p200) -- line: 3794
            -- upvalues: Inventory (ref), ScrollingFrame (ref), v35 (ref), Humanoid (ref), v44 (ref), _EmptySlotsAttribute (ref)
            if p200.IsFakeSlot or isToolLockedToCurrentHotbarSlot(p200) or p200.Tool ~= nil and not HasInventoryCategory(p200.Tool) or not (p200.Index <= _EmptySlotsAttribute) then
                return
            end

            local Tool = p200.Tool

            p200:Clear()

            local v396 = MakeSlot(ScrollingFrame)

            v396:Fill(Tool)

            if Tool and Tool.Parent == v35 and Humanoid then
                UnequipAllTools()
            end

            if Tool and typeof(Tool) == "Instance" and getAttribute(Tool, "ItemType") == "Asset" then
                task.defer(syncAssetsFromSave)
            end

            if v44 then
                v396.Frame.Visible = false
                v396.Frame.Parent = Inventory
            end
        end

        if p157 <= 10 then
            v394 = if p157 == 10 then 0 else p157
            v395 = false
        else
            v395 = true
        end
    else
        v395 = true
    end

    local v397

    if not v395 then
        Number = clone.Number

        local Number2 = Number

        Number2.Text = v394
        v304 = tostring(v394)
        Number2.Visible = false
        v397 = Value + v394

        t8[v397] = function() -- line: 3828
            -- upvalues: t57 (copy)
            changeSlot(t57)
        end
    end

    local connection4

    local function finishDrag(p201, p202) -- line: 3832
        -- upvalues: t57 (copy), clone (copy), shouldAllowSlotDragging (copy), UIStroke (copy), connection4 (ref), TextBox (ref), v1 (ref), HotbarDragFeedback (copy), Name (copy), v3 (ref), SetCategory (ref), v24 (ref), Inventory (ref), v35 (ref), Humanoid (ref), v36 (copy), t6 (copy), t9 (copy), v44 (ref), _EmptySlotsAttribute (ref)
        t9[clone] = nil
        HotbarDragFeedback.Finish()

        if connection4 then
            connection4:Disconnect()
            connection4 = nil
        end

        UIStroke.Thickness = 0
        v36:unlock()

        if not p202 and not t57.IsDeleted and t57.Tool then
            if shouldAllowSlotDragging(t57.Tool) then
                local v398 = CheckBounds(v24, p201.X, p201.Y)

                if isToolLockedToCurrentHotbarSlot(t57) and not v398 and not CheckBounds(clone, p201.X, p201.Y) then
                    HotbarDragFeedback.Reject(clone)
                end

                if CheckBounds(Inventory, p201.X, p201.Y) then
                    if t57.Index <= _EmptySlotsAttribute then
                        if v3 ~= Name then
                            local v399 = GetCategory(t57.Tool)

                            SetCategory(v399)
                        end

                        t57:MoveToInventory()
                        TextBox.Text = ""
                        task.delay(0.01, function() -- line: 3865
                            -- upvalues: v1 (ref)
                            if v1 then
                                v1(true)
                            end
                        end)
                    end
                elseif v398 then
                    local t65 = {
                        1e999,
                        nil
                    }

                    for i = 1, _EmptySlotsAttribute do
                        local v400 = t6[i]
                        local Frame = v400.Frame
                        local v401 = GetOffset(Frame, p201)

                        if v401 < t65[1] then
                            t65 = { v401, v400 }
                        end
                    end

                    local v402 = t65[2]

                    if v402 ~= t57 then
                        if not t57:CanSwap(v402) then
                            HotbarDragFeedback.Reject(v402.Frame)
                        end

                        t57:Swap(v402)

                        if t57.Index > _EmptySlotsAttribute then
                            local Tool = t57.Tool

                            if Tool then
                                if Tool.Parent == v35 and Humanoid then
                                    UnequipAllTools()
                                end

                                if v44 then
                                    t57.Frame.Visible = false
                                    t57.Frame.Parent = Inventory
                                end
                            else
                                t57:Delete()
                            end
                        end
                    end
                elseif t57.Index <= _EmptySlotsAttribute then
                    t57:MoveToInventory()
                    task.delay(0.01, function() -- line: 3905
                        -- upvalues: v1 (ref)
                        if v1 then
                            v1(true)
                        end
                    end)
                elseif typeof(t57.Tool) == "Instance" and t57.Tool:IsA("Tool") and t57.Tool.CanBeDropped then
                    t57.Tool.Parent = workspace
                end

                task.delay(0.01, function() -- line: 3914
                    -- upvalues: v1 (ref)
                    if v1 then
                        v1(true)
                    end
                end)
            else
                clone:SetAttribute("Draggable", false)
                t57:RefreshDragDetector()
                t57:updateDragAppearance()
            end
        end
    end

    local v387 = SlotDragController.new
    local v403 = {}

    if v300 then
        v403.ScrollingFrame = ScrollingFrame
    else
        v403.ScrollingFrame = nil
    end

    function v403.CanStart() -- line: 3922
        -- upvalues: t57 (copy), clone (copy), shouldAllowSlotDragging (copy), HiddenUIHandler (copy)
        local v404 = not t57.IsDeleted
        local v405, v406

        if v404 then
            if clone:GetAttribute("Draggable") == true then
                v405 = not BackpackEnabled or not BackpackGui.Enabled or HiddenUIHandler.IsHidden()
                v406 = not v405 and shouldAllowSlotDragging(t57.Tool)
            else
                v406 = false
            end
        else
            v406 = v404
        end

        return v406
    end

    v403.OnActivate = activateSlot

    function v403.OnDragStart() -- line: 3928
        -- upvalues: t57 (copy), v301 (ref), n8 (ref), Tool (ref), clone (copy), UIStroke (copy), connection4 (ref), HotbarDragFeedback (copy), LocalPlayer2 (ref), v36 (copy), t6 (copy), t9 (copy), _EmptySlotsAttribute (ref)
        n8 = 0
        Tool = nil

        local t66 = {}

        for i = 1, _EmptySlotsAttribute do
            local v407 = t6[i]

            if v407 and v407 ~= t57 and not t57:CanSwap(v407) then
                table.insert(t66, v407.Frame)
            end
        end

        HotbarDragFeedback.Start(t66)
        t9[clone] = true
        UIStroke.Thickness = 2
        v36:lock()

        local Tool2 = t57.Tool

        if typeof(Tool2) == "Instance" then
            connection4 = Tool2.AncestryChanged:Connect(function() -- line: 3945
                -- upvalues: Tool2 (copy), t57 (copy), v301 (ref), LocalPlayer2 (ref)
                if t57.Tool ~= Tool2 or Tool2.Parent ~= LocalPlayer2.Backpack and Tool2.Parent ~= LocalPlayer2.Character then
                    v301:Cancel()
                end
            end)
        end
    end

    v403.OnDragEnd = finishDrag
    v301 = v387(clone, v403)
    clone.Parent = p156
    t6[p157] = t57

    if _EmptySlotsAttribute < p157 then
        v397 = ScrollingFrame.CanvasPosition
        UpdateScrollingFrameCanvasSize()
        v387 = ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteSize.Y

        local v408 = Inventory.Visible

        if not v408 or v44 then
            v408 = ScrollingFrame
            v408.CanvasPosition = v397
        else
            v408 = ScrollingFrame
            v403 = Vector2.new
            v408.CanvasPosition = v403(v397.X, (math.min(v397.Y, (math.max(0, v387)))))
        end
    end

    return t57
end

function moveStackSlotIntoFrontHotbar(p203) -- line: 3972
    -- upvalues: t6 (copy), v38 (ref), _EmptySlotsAttribute (ref)
    if not p203 or p203.IsDeleted then
        return nil
    end

    if p203.Index <= _EmptySlotsAttribute then
        return p203
    end

    local v410 = getInsertableHotbarIndices(p203.Tool)
    local v411 = v410[1]

    if not v411 then
        return nil
    end

    local v412 = t6[v411]

    if not v412 then
        return nil
    end

    local v413 = v38
    local v414 = v413 and table.find(v410, v413.Index)
    local v415 = v414

    if not v414 then
        local v416 = v410[#v410]
        local v417 = v416 and t6[v416]

        if v417 and v417.Tool then
            v417:MoveToInventory()
            v415 = #v410
        end
    end

    if not v415 then
        return nil
    end

    for i = v415, 2, -1 do
        local v418 = t6[v410[i]]
        local v419 = t6[v410[i - 1]]

        if v418 and v419 then
            v419:Swap(v418)
        end
    end

    p203:Swap(v412)

    if p203.Index > _EmptySlotsAttribute and not p203.Tool then
        p203:Delete()
    end

    return v412
end

function movePendingHotbarAssets() -- line: 4021
    -- upvalues: v1 (ref), t11 (copy), t15 (copy)
    local v420 = false

    for v421 in pairs(t15) do
        local v422 = t11[v421]

        if v422 then
            local v423 = moveStackSlotIntoFrontHotbar(v422)

            if v423 then
                t11[v421] = v423
                v420 = true
                t15[v421] = nil
            end
        end
    end

    if v420 then
        AdjustHotbarFrames()
        UpdateInventorySlots()

        if v1 then
            v1(true)
        end
    end

    return v420
end

function movePendingHotbarEggs() -- line: 4046
    -- upvalues: v1 (ref), t3 (copy), t16 (copy), t18 (copy), t19 (copy)
    local v424 = false

    for v425 in pairs(t18) do
        local v426 = t16[v425]

        if v426 then
            local v427 = moveStackSlotIntoFrontHotbar(v426)

            if v427 then
                t16[v425] = v427
                v424 = true
                t18[v425] = nil
            end
        end
    end

    if v424 then
        AdjustHotbarFrames()
        UpdateInventorySlots()

        if v1 then
            v1(true)
        end
    end

    for v428 in pairs(t19) do
        if t3:ForceEggIntoTutorialHotbar(v428) ~= nil then
            t19[v428] = nil
        end
    end

    return v424
end

function OnChildAdded(p204, _) -- line: 4077
    -- upvalues: v1 (ref), LocalPlayer2 (ref), Inventory (ref), ScrollingFrame (ref), v35 (ref), Humanoid (ref), Backpack2 (ref), t7 (copy), v39 (ref), n4 (ref), _EmptySlotsAttribute (ref)
    if p204:IsA("Tool") then
        if p204.Parent == v35 then
            n4 = tick()
        end

        local ItemType = p204:GetAttribute("ItemType")

        if ItemType == "Asset" then
            invalidateEquipBestStatus()
            syncVirtualAssetEquipStateFromTool(p204)
            task.defer(syncAssetsFromSave)
        elseif ItemType == "AssetEgg" then
            syncVirtualEggEquipStateFromTool(p204)
        else
            local ScrollingFrame2 = ScrollingFrame
            local CanvasPosition = ScrollingFrame.CanvasPosition
            local v429, v430

            if v39 then
                v430 = true
            elseif p204.Parent ~= v35 or t7[p204] then
                v430 = true
            else
                local StarterGear = LocalPlayer2:FindFirstChild("StarterGear")

                if StarterGear and StarterGear:FindFirstChild(p204.Name) then
                    v39 = true
                    v429 = insertToolIntoFrontHotbar(p204) or claimLowestEmptySlot(p204) or MakeSlot(ScrollingFrame)
                    v430 = false
                else
                    v430 = true
                end
            end

            if not v430 then
                if v429.Tool ~= p204 then
                    v429:Fill(p204)
                end

                if isGearTool(p204) then
                    ensureGameplayGearHotbarSlots()
                end

                for _, child in pairs(v35:GetChildren()) do
                    if child:IsA("Tool") and child ~= p204 then
                        child.Parent = Backpack2
                    end
                end

                AdjustHotbarFrames()

                if v1 then
                    v1(true)
                end

                UpdateInventorySlots()

                local v431 = ScrollingFrame2.AbsoluteCanvasSize.Y - ScrollingFrame2.AbsoluteSize.Y

                ScrollingFrame2.CanvasPosition = Vector2.new(CanvasPosition.X, (math.min(CanvasPosition.Y, (math.max(0, v431)))))
            else
                local v433 = t7[p204]

                if v433 then
                    v433:UpdateEquipView()
                else
                    local v434 = insertToolIntoFrontHotbar(p204) or claimLowestEmptySlot(p204) or MakeSlot(ScrollingFrame)

                    if v434.Tool ~= p204 then
                        v434:Fill(p204)
                    end

                    if isGearTool(p204) then
                        ensureGameplayGearHotbarSlots()
                    end

                    if v434.Index <= _EmptySlotsAttribute and not Inventory.Visible then
                        AdjustHotbarFrames()
                    end

                    UpdateInventorySlots()

                    local v435 = ScrollingFrame2.AbsoluteCanvasSize.Y - ScrollingFrame2.AbsoluteSize.Y

                    ScrollingFrame2.CanvasPosition = Vector2.new(CanvasPosition.X, (math.min(CanvasPosition.Y, (math.max(0, v435)))))
                    task.delay(0.05, function() -- line: 4156
                        -- upvalues: v1 (ref)
                        if v1 then
                            v1(true)
                        end
                    end)
                end
            end
        end
    elseif p204:IsA("Humanoid") and p204.Parent == v35 then
        Humanoid = p204
    end
end

function OnChildRemoved(p206) -- line: 4165
    -- upvalues: Inventory (ref), v35 (ref), Backpack2 (ref), t6 (copy), t7 (copy), n4 (ref), _EmptySlotsAttribute (ref)
    if not p206:IsA("Tool") then
        return
    end

    n4 = tick()

    local ItemType = p206:GetAttribute("ItemType")

    if ItemType == "Asset" then
        invalidateEquipBestStatus()
        task.defer(reconcileVirtualAssetEquipState)
        task.defer(syncAssetsFromSave)

        local v437 = t7[p206]

        if v437 and v437.Tool == p206 then
            v437:Clear()

            if v437.Index > _EmptySlotsAttribute then
                v437:Delete()
            end

            if v437.Index <= _EmptySlotsAttribute and not Inventory.Visible then
                AdjustHotbarFrames()
            end

            UpdateInventorySlots()
        end
    elseif ItemType == "AssetEgg" then
        task.defer(reconcileVirtualEggEquipState)
    else
        local v438 = t7[p206]
        local Parent = p206.Parent

        if Parent ~= v35 and Parent ~= Backpack2 then
            if not v438 or v438.Tool ~= p206 then
                for _, v439 in pairs(t6) do
                    if v439.Tool == p206 then
                        v438 = v439
                        break
                    end
                end
            end

            if v438 and v438.Tool == p206 then
                v438:Clear()

                if v438.Index > _EmptySlotsAttribute then
                    v438:Delete()
                end

                if v438.Index <= _EmptySlotsAttribute and not Inventory.Visible then
                    AdjustHotbarFrames()
                end

                UpdateInventorySlots()
            end
        end
    end
end

function SetupCharacter(p207) -- line: 4222
    -- upvalues: Constants (copy), LocalPlayer2 (ref), v35 (ref), Backpack2 (ref), t6 (copy), t10 (ref), v50 (ref), v55 (ref)
    v50 = nil
    v55 = nil

    for i = #t6, 1, -1 do
        local v440 = t6[i]

        if v440.Tool then
            if typeof(v440.Tool) == "Instance" then
                v440:Clear()
            else
                v440:UpdateEquipView(true)
            end
        end
    end

    for _, v441 in pairs(t10) do
        v441:Disconnect()
    end

    t10 = {}
    v35 = p207

    local t67 = t10

    table.insert(t67, p207.ChildRemoved:Connect(OnChildRemoved))

    local t68 = t10

    table.insert(t68, p207.ChildAdded:Connect(function(p208) -- line: 4244
        -- upvalues: Constants (copy)
        if p208:IsA("Tool") and (p208.Name == Constants.LUCKY_BLOCK_TOOL_NAME or p208:GetAttribute("HideFromBackpackUI") == true) then
            return
        end

        OnChildAdded(p208, false)
    end))

    for _, child in pairs(p207:GetChildren()) do
        task.spawn(OnChildAdded, child, false)
    end

    Backpack2 = LocalPlayer2:WaitForChild("Backpack")

    local t69 = t10

    table.insert(t69, Backpack2.ChildRemoved:Connect(OnChildRemoved))

    local t70 = t10

    table.insert(t70, Backpack2.ChildAdded:Connect(function(p209) -- line: 4264
        -- upvalues: Constants (copy)
        if p209:IsA("Tool") and (p209.Name == Constants.LUCKY_BLOCK_TOOL_NAME or p209:GetAttribute("HideFromBackpackUI") == true) then
            return
        end

        OnChildAdded(p209, true)
    end))

    for _, child in pairs(Backpack2:GetChildren()) do
        task.spawn(OnChildAdded, child, false)
    end

    local t71 = t10

    table.insert(t71, LocalPlayer2.ChildAdded:Connect(function(p210) -- line: 4282
        -- upvalues: p207 (copy), v35 (ref), Backpack2 (ref)
        if p210:IsA("Backpack") and p210 ~= Backpack2 and v35 == p207 then
            SetupCharacter(p207)
        end
    end))
    AdjustHotbarFrames()
    invalidateEquipBestStatus(true)
    reconcileVirtualAssetEquipState()
end

local _PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

function HandleInputBegan(p211, p212) -- line: 4293
    -- upvalues: Value2 (copy), Inventory (ref), v36 (copy), t8 (copy), v40 (ref), v43 (ref), _PlayerGui (copy)
    if p212 ~= false then
        return
    end

    if p211.UserInputType == Enum.UserInputType.Keyboard and not v43 and (v40 or p211.KeyCode.Value == Value2) then
        local v445 = t8[p211.KeyCode.Value]

        if v445 then
            if ActiveFuseSelectionState then
                return
            end

            v445(p212)
        end
    end

    local UserInputType = p211.UserInputType

    if (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) and Inventory.Visible and not ActiveFuseSelectionState then
        local MouseLocation = UserInputService:GetMouseLocation()
        local v446 = false
        local v447

        for _, v448 in _PlayerGui:GetGuiObjectsAtPosition(MouseLocation.X, MouseLocation.Y) do
            if v448.Name:find("CategoryFrame") then
                v447 = v448
                v446 = true
                break
            end
        end

        if not v446 then
            v447 = nil
        end

        if not v447 then
            v36:deselect()
        end
    end
end

function OnInputServiceChanged(p213) -- line: 4328
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    if p213 ~= "KeyboardEnabled" and p213 ~= "VREnabled" then
        return
    end

    local KeyboardEnabled = UserInputService.KeyboardEnabled and not UserInputService.VREnabled

    for i = 1, _EmptySlotsAttribute do
        t6[i]:TurnNumber(KeyboardEnabled)
    end
end

function OnGamepadFocus() -- line: 4336
    -- upvalues: MenuNavigation (copy)
    if MenuNavigation.IsCursorActive() then
        return Enum.ContextActionResult.Pass
    end

    return Enum.ContextActionResult.Sink
end

function unbindAllGamepadEquipActions() -- line: 4339
    ContextActionService:UnbindAction("RBXBackpackHasGamepadFocus")
    ContextActionService:UnbindAction("RBXCloseInventory")
end

function _setHotbarVisibility(p214, p215) -- line: 4343
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = 1, _EmptySlotsAttribute do
        local v449 = t6[i]

        if v449 and v449.Frame and (p215 or v449.Tool) then
            v449.Frame.Visible = p214
        end
    end
end

function getEquippedHotbarSlot() -- line: 4351
    -- upvalues: v35 (ref), t7 (copy), _EmptySlotsAttribute (ref), t11 (copy), t16 (copy)
    local v450 = reconcileVirtualAssetEquipState()

    if typeof(v450) == "string" then
        local v451 = t11[v450]

        if v451 and not v451.IsDeleted and v451.Index <= _EmptySlotsAttribute and v451.Tool then
            return v451
        end
    end

    local v452 = reconcileVirtualEggEquipState()

    if typeof(v452) == "string" then
        local v453 = t16[v452]

        if v453 and not v453.IsDeleted and v453.Index <= _EmptySlotsAttribute and v453.Tool then
            return v453
        end
    end

    if v35 then
        for _, child in ipairs(v35:GetChildren()) do
            if child:IsA("Tool") then
                local v454 = t7[child]

                if v454 and v454.Index <= _EmptySlotsAttribute and v454.Tool then
                    return v454
                end
            end
        end
    end

    return nil
end

function changeTool(_, p217, p218) -- line: 4391
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    if p217 ~= Enum.UserInputState.Begin then
        return
    end

    local v455 = if p218.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 1
    local v456 = getEquippedHotbarSlot()
    local v457 = if v456 then v456.Index elseif v455 == -1 then 1 else _EmptySlotsAttribute

    for _ = 1, _EmptySlotsAttribute do
        v457 += v455

        if _EmptySlotsAttribute < v457 then
            v457 = 1
        elseif v457 < 1 then
            v457 = _EmptySlotsAttribute
        end

        local v458 = t6[v457]

        if v458.Tool and v458 ~= v456 then
            v458:Select()

            return
        end
    end
end

function getGamepadSwapSlot() -- line: 4418
    -- upvalues: t6 (copy)
    for i = 1, #t6 do
        if t6[i].Frame:WaitForChild("UIStroke").Thickness > 0 then
            return t6[i]
        end
    end
end

changeSlot = function(p219) -- line: 4426
    -- upvalues: GuiService (copy), MenuNavigation (copy), Inventory (ref), v26 (ref), _EmptySlotsAttribute (ref)
    if p219.IsFakeSlot then
        p219:Select()
    else
        local v459 = not VRService.VREnabled or Inventory.Visible

        if not MenuNavigation.IsCursorActive() and p219.Frame == GuiService.SelectedObject and v459 then
            local v460 = getGamepadSwapSlot()

            if v460 then
                v460.Frame:WaitForChild("UIStroke").Thickness = 0

                if v460 ~= p219 then
                    p219:Swap(v460)
                    v26.SelectionImageObject.Visible = false

                    if p219.Index > _EmptySlotsAttribute and not p219.Tool then
                        if GuiService.SelectedObject == p219.Frame then
                            GuiService.SelectedObject = v460.Frame
                        end

                        p219:Delete()
                    end

                    if v460.Index > _EmptySlotsAttribute and not v460.Tool then
                        if GuiService.SelectedObject == v460.Frame then
                            GuiService.SelectedObject = p219.Frame
                        end

                        v460:Delete()
                    end
                end
            else
                local Size, FramePosition = p219.Frame.Size, p219.Frame.Position

                p219.Frame:TweenSizeAndPosition(Size + UDim2.new(0, 10, 0, 10), FramePosition - UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function() -- line: 4465
                    -- upvalues: p219 (copy), Size (copy), FramePosition (copy)
                    p219.Frame:TweenSizeAndPosition(Size, FramePosition, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
                end)
                p219.Frame:WaitForChild("UIStroke").Thickness = 3
                v26.SelectionImageObject.Visible = true
            end
        else
            p219:Select()
            v26.SelectionImageObject.Visible = false
        end
    end
end

function vrMoveSlotToInventory() -- line: 4485
    -- upvalues: v26 (ref)
    if VRService.VREnabled then
        local v461 = getGamepadSwapSlot()

        if v461 and v461.Tool then
            v461:WaitForChild("UIStroke").Thickness = 0
            v461:MoveToInventory()
            v26.SelectionImageObject.Visible = false
        end
    end
end

function enableGamepadInventoryControl() -- line: 4496
    -- upvalues: GuiService (copy), MenuNavigation (copy), v24 (ref), Inventory (ref), v36 (copy)
    local function handleBackAction(_, p221) -- line: 4497
        -- upvalues: Inventory (ref), v36 (copy)
        if p221 == Enum.UserInputState.Begin then
            local v462 = getGamepadSwapSlot()

            if v462 then
                v462.Frame:WaitForChild("UIStroke").Thickness = 0
            elseif Inventory.Visible then
                v36:deselect()
            end
        end
    end

    ContextActionService:BindAction("RBXBackpackHasGamepadFocus", OnGamepadFocus, false, Enum.UserInputType.Gamepad1)
    ContextActionService:BindAction("RBXCloseInventory", handleBackAction, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart, Enum.KeyCode.ButtonSelect)

    if not UserInputService.VREnabled and not MenuNavigation.IsCursorActive() then
        GuiService.SelectedObject = v24:FindFirstChild("1")
    end
end

function disableGamepadInventoryControl() -- line: 4528
    -- upvalues: GuiService (copy), Backpack (ref), t6 (copy), _EmptySlotsAttribute (ref)
    unbindAllGamepadEquipActions()

    for i = 1, _EmptySlotsAttribute do
        local v463 = t6[i]

        if v463 and v463.Frame then
            v463.Frame:WaitForChild("UIStroke").Thickness = 0
        end
    end

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(Backpack) then
        GuiService.SelectedObject = nil
    end
end

function _bindBackpackHotbarAction() -- line: 4540
    -- upvalues: v20 (ref), v40 (ref)
    if v40 and not v20 then
        v20 = true
        ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
    end
end

function _unbindBackpackHotbarAction() -- line: 4552
    -- upvalues: v20 (ref)
    disableGamepadInventoryControl()
    v20 = false
    ContextActionService:UnbindAction("RBXHotbarEquip")
end

function gamepadDisconnected() -- line: 4557
    -- upvalues: v45 (ref)
    v45 = false
    disableGamepadInventoryControl()
end

function gamepadConnected() -- line: 4561
    -- upvalues: GuiService (copy), v20 (ref), Backpack (ref), Inventory (ref), n3 (ref), v40 (ref), v45 (ref)
    v45 = true
    GuiService:AddSelectionParent("RBXBackpackSelection", Backpack)

    if n3 >= 1 and v40 and not v20 then
        v20 = true
        ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
    end

    if Inventory.Visible then
        enableGamepadInventoryControl()
    end
end

function OnIconChanged(p222) -- line: 4579
    -- upvalues: GuiService (copy), tryCore (copy), v20 (ref), Backpack (ref), v36 (copy), n3 (ref), v40 (ref)
    local v464 = p222 and tryCore("GetCore", "TopbarEnabled")

    v36:setEnabled(v464 and not GuiService.MenuIsOpen and not ActiveFuseSelectionState)
    v40 = v464
    Backpack.Visible = v464
    PositionInventoryAffordances()

    if v464 then
        if n3 >= 1 and v40 and not v20 then
            v20 = true
            ContextActionService:BindAction("RBXHotbarEquip", changeTool, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
        end
    else
        disableGamepadInventoryControl()
        v20 = false
        ContextActionService:UnbindAction("RBXHotbarEquip")
    end
end

function createScrollButton(p223, p224) -- line: 4602
    local v466 = NewGui("ImageButton", p223)

    v466.Size = UDim2.new(0, 40, 0, 40)
    v466.Image = "rbxasset://textures/ui/Keyboard/close_button_background.png"

    local Icon = NewGui("ImageLabel", "Icon")

    Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Position = UDim2.new(0.25, 0, 0.25, 0)
    Icon.Image = p224
    Icon.Parent = v466

    local Selection = NewGui("ImageLabel", "Selection")

    Selection.Size = UDim2.new(0.9, 0, 0.9, 0)
    Selection.Position = UDim2.new(0.05, 0, 0.05, 0)
    Selection.Image = "rbxasset://textures/ui/Keyboard/close_button_selection.png"
    v466.SelectionImageObject = Selection

    return v466, Icon, Selection
end

Backpack = BackpackGui:WaitForChild("Backpack")
Backpack.Visible = false
v24 = NewGui("Frame", "Hotbar")
v24.Parent = Backpack

local RoundChoices = script:FindFirstChild("RoundChoices")

if RoundChoices then
    RoundChoices.Parent = v24

    if v22 then
        RoundChoices.Size = UDim2.fromScale(1, 0.4)
    end
elseif RunService:IsStudio() then
    error("RoundChoices frame not found in Backpack script")
end

for i = 1, _EmptySlotsAttribute do
    MakeSlot(v24, i).Frame.Visible = false
end

Main = Backpack:WaitForChild("Main")
Inventory = Main:WaitForChild("Inventory")

local Loading = Inventory:WaitForChild("Loading")

Loading.Visible = false
task.spawn(WarmAssets, Inventory.ImageLabel.ImageLabel)
AutoSell = Inventory.AutoSell
AutoSell.Visible = false
task.spawn(initializeAutoSellUI)
v38 = FindLowestEmpty()
AdjustHotbarFrames()
v36.selected:Connect(function() -- line: 4653
    -- upvalues: GuiService (copy), t3 (copy)
    if not GuiService.MenuIsOpen then
        t3.OpenClose()
    end
end)
v36.deselected:Connect(function() -- line: 4658
    -- upvalues: t3 (copy), Inventory (ref)
    if Inventory.Visible then
        t3.OpenClose()
    end
end)

local selected = NewGui("ImageLabel", "LeftBumper")

selected.Size = UDim2.new(0, 40, 0, 40)
selected.Position = UDim2.new(0, -selected.Size.X.Offset, 0.5, -selected.Size.Y.Offset / 2)
selected = NewGui("ImageLabel", "RightBumper")
selected.Size = UDim2.new(0, 40, 0, 40)
selected.Position = UDim2.new(1, 0, 0.5, -selected.Size.Y.Offset / 2)

local BackgroundColor3 = Inventory.BackgroundColor3

InventoryStroke = Inventory:FindFirstChildWhichIsA("UIStroke")
InventoryStrokeDefaultColor = InventoryStroke and InventoryStroke.Color or nil
InventoryStrokeDefaultTransparency = Inventory.BackgroundTransparency
Inventory.Visible = false

function refreshInventoryFrameVisuals() -- line: 4675
    -- upvalues: v16 (ref), Inventory (ref), v25 (copy), BackgroundColor3 (copy)
    if ActiveFuseSelectionState then
        local Inventory2 = Inventory

        Inventory2.BackgroundColor3 = FUSE_SELECTION_BACKGROUND_COLOR

        if InventoryStroke then
            InventoryStroke.Color = FUSE_SELECTION_STROKE_COLOR
        end

        Inventory2.BackgroundTransparency = FUSE_SELECTION_BACKGROUND_TRANSPARENCY
    else
        local Inventory2 = Inventory

        Inventory2.BackgroundColor3 = v16 and v25 or BackgroundColor3

        if InventoryStroke and InventoryStrokeDefaultColor then
            InventoryStroke.Color = InventoryStrokeDefaultColor
        end

        Inventory2.BackgroundTransparency = InventoryStrokeDefaultTransparency
    end
end

local UIStroke = Instance.new("UIStroke")

UIStroke.Name = "FavoriteMode"
UIStroke.Thickness = 4.5
UIStroke.Color = Color3.fromRGB(255, 170, 0)
UIStroke.Enabled = false
UIStroke.ZIndex = 2
UIStroke.Parent = Inventory

function updateFavoriteModeVisuals() -- line: 4699
    -- upvalues: v15 (ref), v16 (ref), UIStroke (copy)
    local TextLabel = v15 and v15:FindFirstChildWhichIsA("TextLabel")

    if TextLabel then
        TextLabel.Text = v16 and "Favorite: ON" or "Favorite: OFF"
    end

    if UIStroke then
        UIStroke.Enabled = v16 and not ActiveFuseSelectionState
    end

    refreshInventoryFrameVisuals()
end

function setFavoriteModeActive(p225) -- line: 4712
    -- upvalues: v15 (ref), v16 (ref), UIStroke (copy)
    v16 = p225

    if v15 then
        updateFavoriteModeVisuals()
    else
        refreshInventoryFrameVisuals()

        if UIStroke then
            UIStroke.Enabled = v16 and not ActiveFuseSelectionState
        end
    end
end

function hideFavoriteModeButton() -- line: 4725
    -- upvalues: v15 (ref), v16 (ref), AutoSell (ref), EquipBest (ref)
    if v16 then
        setFavoriteModeActive(false)
    end

    if not v15 then
        return
    end

    v15.Visible = false

    if AutoSell then
        AutoSell.Visible = false
    end

    if EquipBest then
        EquipBest.Visible = false
    end
end

function refreshFavoriteModeVisibility() -- line: 4741
    -- upvalues: Name (copy), v3 (ref), t2 (copy), v15 (ref), AutoSell (ref), EquipBest (ref)
    if not v15 then
        return
    end

    local v469 = t2[v3]
    local v470 = v3 == Name

    if v469 and v469.Tags then
        for _, v471 in v469.Tags do
            if v471 == "Asset" then
                v470 = true
                break
            end
        end
    end

    if v470 then
        v15.Visible = false

        if AutoSell then
            AutoSell.Visible = false
        end

        if EquipBest then
            EquipBest.Visible = false
        end
    else
        hideFavoriteModeButton()
    end

    updateEquipBestButtonVisibility()
end

v15 = Inventory:FindFirstChild("FavoriteMode") or script:FindFirstChild("FavoriteMode")

if v15 then
    local v472 = v15

    v472.Parent = Inventory
    v472.Visible = false
    updateFavoriteModeVisuals()
    ButtonFX(v15, nil, function() -- line: 4779
        -- upvalues: v16 (ref)
        setFavoriteModeActive(not v16)
    end)
end

EquipBest = Inventory:FindFirstChild("EquipBest")

if EquipBest then
    EquipBest.Visible = false
    ButtonFX(EquipBest, nil, requestEquipBest)
end

local Color = script:FindFirstChild("EquipBest")

if Color and Color:IsA("GuiButton") then
    clone = Color:Clone()

    local clone2 = clone

    assert(clone2, "missing hotbar")
    clone2.Parent = v24
    clone2.Visible = false
    ButtonFX(clone, nil, requestEquipBest)
end

Color = Inventory:FindFirstChild("CategoryLabel") or script.CategoryTemplate:Clone()
Color.Parent = Inventory

if not Color:IsA("TextLabel") then
    Color = Color:FindFirstChildWhichIsA("TextLabel", true)
end

assert(Color and Color:IsA("TextLabel"), "Category label template must contain a TextLabel")

local t72 = {}
local t73 = {}

local function v473() -- line: 4809
    -- upvalues: t73 (copy)
    local _ActiveFuseSelectionState = ActiveFuseSelectionState
    local v474 = _ActiveFuseSelectionState ~= nil

    for v475, v476 in t73 do
        local v477 = not v474 or _ActiveFuseSelectionState.AllowedCategories[v475] == true

        v476.Visible = v477

        local ImageButton = v476:FindFirstChild("ImageButton")

        if ImageButton and ImageButton:IsA("GuiButton") then
            ImageButton.Active = v477
        end
    end
end

function updateCategorySelectionVisuals() -- line: 4826
    -- upvalues: v3 (ref), t72 (copy)
    for v478, v479 in t72 do
        v479.Enabled = v478 == v3
    end
end

function updateCategoryLabel(p226) -- line: 4832
    -- upvalues: Inventory (ref), Color (ref)
    Color.Text = p226
    Inventory:SetAttribute("CapacityCategory", p226)
end

function applyCategoryLayout() -- line: 4837
    -- upvalues: ScrollingFrame (ref), UIGridLayout (ref), v28 (ref), v29 (ref), AspectRatio (ref), v30 (ref), v31 (ref), v32 (ref), PaddingLeft (ref), UIPadding (ref)
    if not (UIGridLayout and ScrollingFrame) then
        return
    end

    v28 = v28 or UIGridLayout.CellSize

    if not v29 then
        v29 = UIGridLayout:FindFirstChildWhichIsA("UIAspectRatioConstraint") or ScrollingFrame:FindFirstChildWhichIsA("UIAspectRatioConstraint")

        if v29 then
            AspectRatio = v29.AspectRatio
        end
    end

    v32 = v32 or ScrollingFrame.ScrollingDirection
    v30 = v30 or UIGridLayout.FillDirection
    v31 = v31 or UIGridLayout.HorizontalAlignment

    if UIPadding and not PaddingLeft then
        PaddingLeft = UIPadding.PaddingLeft
    end

    local UIGridLayout2 = UIGridLayout

    UIGridLayout2.CellSize = v28

    if v29 and AspectRatio then
        v29.AspectRatio = AspectRatio
    end

    local ScrollingFrame2 = ScrollingFrame

    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame2.ScrollingDirection = v32
    UIGridLayout2.FillDirection = v30
    UIGridLayout2.HorizontalAlignment = v31

    if UIPadding and PaddingLeft then
        UIPadding.PaddingLeft = PaddingLeft
    end
end

function SetCategory(p227) -- line: 4883
    -- upvalues: TextBox (ref), v1 (ref), v2 (ref), Name (copy), v3 (ref), v16 (ref), ScrollingFrame (ref), Loading (copy)
    local v480 = if not ActiveFuseSelectionState then p227 elseif ActiveFuseSelectionState.AllowedCategories[p227] == true then p227 else ActiveFuseSelectionState.PreferredCategory

    if v3 == v480 then
        updateCategoryLabel(v480)
    else
        v3 = v480
        applyCategoryLayout()

        if TextBox and TextBox.Text ~= "" then
            if v2 then
                v2()
            end

            TextBox.Text = ""
        end

        if v3 ~= Name and v16 then
            setFavoriteModeActive(false)
        end

        if Loading and v3 ~= Name then
            Loading.Visible = false
        end

        refreshFavoriteModeVisibility()
        updateCategoryLabel(v480)

        if ScrollingFrame then
            ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
        end

        v1()
    end

    updateCategorySelectionVisuals()
end

local CategoryFrame = Inventory:WaitForChild("CategoryFrame")
local CategoryTemplate = CategoryFrame.CategoryTemplate

if not CategoryFrame:FindFirstChildWhichIsA("UIGridLayout") then
    CategoryFrame:FindFirstChildWhichIsA("UIListLayout")
end

function createHintForCategory(p228, p229) -- line: 4922
    local v481, v482, v483 = p228:ToHSV()
    local v485 = math.clamp(v483 + p229, 0, 1)

    return Color3.fromHSV(v481, v482, v485)
end

for _, v486 in t1 do
    local Name = v486.Name
    local clone = CategoryTemplate:Clone()
    local ImageButton = clone.ImageButton
    local BackgroundColor3 = clone:FindFirstChild("CategoryName")

    if BackgroundColor3 and BackgroundColor3:IsA("TextLabel") then
        BackgroundColor3.Text = Name
    end

    BackgroundColor3 = clone.BackgroundColor3

    local tween = TweenService:Create(clone, TweenInfo.new(0.2), {
        BackgroundColor3 = createHintForCategory(BackgroundColor3, 0.2)
    })
    local tween2 = TweenService:Create(clone, TweenInfo.new(0.2), {
        BackgroundColor3 = BackgroundColor3
    })

    ImageButton.MouseEnter:Connect(function() -- line: 4942
        -- upvalues: tween (copy)
        tween:Play()
    end)
    ImageButton.MouseLeave:Connect(function() -- line: 4943
        -- upvalues: tween2 (copy)
        tween2:Play()
    end)
    ImageButton.MouseButton1Down:Connect(function() -- line: 4944
        -- upvalues: tween2 (copy)
        tween2:Play()
    end)
    ImageButton.Activated:Connect(function() -- line: 4945
        -- upvalues: SetCategory (ref), Name (copy), tween (copy)
        tween:Play()
        SetCategory(Name)
    end)
    BackgroundColor3 = clone.UIStroke
    assert(BackgroundColor3:IsA("UIStroke"), "Category button UIStroke must be a UIStroke")
    BackgroundColor3.Enabled = false
    t72[Name] = BackgroundColor3
    t73[Name] = clone
    ImageButton.Image = v486.Image
    clone.Visible = true
    clone.Parent = CategoryFrame
end

v473()
updateCategoryLabel(v3)
updateCategorySelectionVisuals()
refreshFavoriteModeVisibility()
v26 = NewGui("TextButton", "VRInventorySelector")

local v487 = UDim2.new(0, 0, 0, 0)

v26.Position = v487
v26.Size = UDim2.new(1, 0, 1, 0)
v26.BackgroundTransparency = 1
v26.Text = ""
v26.Parent = Inventory
v487 = NewGui("ImageLabel", "Selector")
v487.Size = UDim2.new(1, 0, 1, 0)
v487.Image = "rbxasset://textures/ui/Keyboard/key_selection_9slice.png"
v487.ScaleType = Enum.ScaleType.Slice
v487.SliceCenter = Rect.new(12, 12, 52, 52)
v487.Visible = false
v26.SelectionImageObject = v487
v26.MouseButton1Click:Connect(function() -- line: 4975
    vrMoveSlotToInventory()
end)
ScrollingFrame = Inventory:WaitForChild("ScrollingFrame")
UIGridLayout = ScrollingFrame:WaitForChild("UIGridLayout")
UIPadding = ScrollingFrame:FindFirstChildWhichIsA("UIPadding")
v29 = UIGridLayout:FindFirstChildWhichIsA("UIAspectRatioConstraint") or ScrollingFrame:FindFirstChildWhichIsA("UIAspectRatioConstraint")

if v29 then
    AspectRatio = v29.AspectRatio
end

v32 = ScrollingFrame.ScrollingDirection

if UIPadding then
    PaddingLeft = UIPadding.PaddingLeft
end

if v22 then
    v487 = UDim2.new(UIGridLayout.CellSize.X.Scale, UIGridLayout.CellSize.X.Offset, UIGridLayout.CellSize.Y.Scale, UIGridLayout.CellSize.Y.Offset / 2)
    UIGridLayout.CellSize = v487
end

v28 = UIGridLayout.CellSize
applyCategoryLayout()
v27 = GridCellFitter.Fit(UIGridLayout, v33, v34)

local v488 = createScrollButton("ScrollUpButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v488.Size = UDim2.new(0, 34, 0, 34)
v488.Position = UDim2.new(0.5, -v488.Size.X.Offset / 2, 0, 43)
v488.Icon.Position = v488.Icon.Position - UDim2.new(0, 0, 0, 2)
v488.MouseButton1Click:Connect(function() -- line: 5015
    -- upvalues: v23 (copy), ScrollingFrame (ref)
    ScrollingFrame.CanvasPosition = Vector2.new(ScrollingFrame.CanvasPosition.X, (math.min(ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y, (math.max(0, ScrollingFrame.CanvasPosition.Y - (v23 + 5))))))
end)

local v492 = createScrollButton("ScrollDownButton", "rbxasset://textures/ui/Backpack/ScrollUpArrow.png")

v492.Rotation = 180
v492.Icon.Position = v492.Icon.Position - UDim2.new(0, 0, 0, 2)
v492.Size = UDim2.new(0, 34, 0, 34)
v492.Position = UDim2.new(0.5, -v492.Size.X.Offset / 2, 1, -v492.Size.Y.Offset - 3)
v492.MouseButton1Click:Connect(function() -- line: 5040
    -- upvalues: v23 (copy), ScrollingFrame (ref)
    ScrollingFrame.CanvasPosition = Vector2.new(ScrollingFrame.CanvasPosition.X, (math.min(ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y, (math.max(0, ScrollingFrame.CanvasPosition.Y + (v23 + 5))))))
end)
ScrollingFrame.Changed:Connect(function(p230) -- line: 5052
    -- upvalues: ScrollingFrame (ref), v488 (copy), v492 (copy)
    if p230 ~= "AbsoluteWindowSize" and p230 ~= "CanvasPosition" and p230 ~= "AbsoluteCanvasSize" then
        return
    end

    local v496 = ScrollingFrame.CanvasPosition.Y ~= 0
    local v497 = ScrollingFrame.CanvasPosition.Y < ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y

    v488.Visible = v496
    v492.Visible = v497
end)
ResizeContainers()
Inventory:GetPropertyChangedSignal("Visible"):Connect(PositionInventoryAffordances)
PlatformController.Changed:Connect(PositionInventoryAffordances)
PositionInventoryAffordances()
v487 = Utility:Create("Frame")

local t74 = {
    Name = "GamepadHintsFrame",
    BackgroundTransparency = 1,
    Visible = false,
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.fromScale(0.22, 0.062),
    Size = UDim2.new(0.76, 0, 0, v18 and 36 or 32),
    Parent = Inventory
}
local v498 = v487(t74)

function createHint(p231, p232) -- line: 5080
    -- upvalues: InputIconsConfig (copy), v18 (copy), v498 (copy)
    local v499 = Utility:Create("Frame")({
        Name = "HintFrame",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -5),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = v498
    })
    local v500 = Utility:Create("ImageLabel")({
        Name = "HintImage",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(48, 48),
        Image = InputIconsConfig.Image(p231) or "",
        ScaleType = Enum.ScaleType.Fit,
        Parent = v499
    })

    InputIconsConfig.Changed:Connect(function() -- line: 5098
        -- upvalues: p231 (copy), v500 (copy), InputIconsConfig (copy)
        v500.Image = InputIconsConfig.Image(p231) or ""
    end)

    local v501 = Utility:Create("TextLabel")({
        Name = "HintText",
        BackgroundTransparency = 1,
        TextWrapped = false,
        Position = UDim2.fromOffset(56, 0),
        Size = UDim2.new(1, -56, 1, 0),
        Font = Enum.Font.SourceSansBold,
        TextSize = v18 and 26 or 22,
        Text = p232,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = v499
    })

    Instance.new("UITextSizeConstraint", v501).MaxTextSize = v501.TextSize
end

function PositionHintFrame() -- line: 5116
    -- upvalues: v18 (copy), v498 (copy)
    local v502 = if v18 then 36 else 32
    local v503 = if v18 then 26 else 22
    local TextService = game:GetService("TextService")
    local Children = v498:GetChildren()
    local t76 = {}
    local n10 = 0

    for v504, v505 in Children do
        local TextSize = TextService:GetTextSize(v505.HintText.Text, v503, v505.HintText.Font, Vector2.new(10000, v502))

        t76[v504] = v502 + 8 + math.ceil(TextSize.X) + 4
        n10 += t76[v504]
    end

    local v507 = v498.AbsoluteSize.Y / v502
    local v508 = v498.AbsoluteSize.X / math.max(v507, 0.001)
    local v510 = math.max(1, #Children - 1)
    local v512 = math.min(1, v508 / (n10 + v510 * 20))
    local v513 = (v508 - n10 * v512) / v510
    local n11 = 0

    for v514, v515 in Children do
        v515.Position = UDim2.fromOffset(n11, 0)
        v515.Size = UDim2.new(0, t76[v514] * v512, 1, 0)
        v515.HintImage.Size = UDim2.fromOffset(v502 * v512, v502 * v512)
        v515.HintText.Position = UDim2.fromOffset((v502 + 8) * v512, 0)
        v515.HintText.Size = UDim2.new(1, -(v502 + 8) * v512, 1, 0)
        v515.HintText.TextSize = v503 * v512
        n11 += t76[v514] * v512 + v513
    end
end

createHint(Enum.KeyCode.ButtonX, "Remove From Hotbar")
createHint(Enum.KeyCode.ButtonA, "Select/Swap")
createHint(Enum.KeyCode.ButtonB, "Close Backpack")
v498:GetPropertyChangedSignal("AbsoluteSize"):Connect(PositionHintFrame)
PositionHintFrame()

local Search = Inventory:WaitForChild("Search")

TextBox = Search:WaitForChild("TextBox")
TextBox.ClearTextOnFocus = false
TextBox.TextXAlignment = Enum.TextXAlignment.Left
CloseButton = Inventory:FindFirstChild("Close")

if CloseButton and CloseButton:IsA("GuiButton") then
    ButtonFX(CloseButton, nil, function() -- line: 5164
        -- upvalues: t3 (copy), Inventory (ref)
        if Inventory.Visible then
            t3.OpenClose()
        end
    end)
end

v487 = Search:FindFirstChild("StrokeTemplate") or Search:FindFirstChildWhichIsA("UIStroke") or script.StrokeTemplate:Clone()
v487.Enabled = false
v487.Parent = Search
RunService.Heartbeat:Connect(function(p233) -- line: 5176
    -- upvalues: v487 (ref)
    if v487.Enabled then
        local UIGradient = v487.UIGradient

        UIGradient.Rotation = (UIGradient.Rotation + p233 * 20) % 360
    end
end)

local X = Search:FindFirstChild("X") or Search:FindFirstChild("ClearSearch") or Search:WaitForChild("X")

X.Visible = false

function PerformSearch() -- line: 5187
    -- upvalues: TextBox (ref), Inventory (ref), ScrollingFrame (ref), t6 (copy), v44 (ref), _EmptySlotsAttribute (ref), X (copy)
    if TextBox.Text == "" then
        ResetSearchResults()
    else
        local t77 = {}

        for match in TextBox.Text:gmatch("%S+") do
            t77[match:lower()] = true
        end

        local t78 = {}

        for i = _EmptySlotsAttribute + 1, #t6 do
            local v516 = t6[i]

            if v516 and v516.Tool then
                if IsOfCategory(v516.Tool) then
                    table.insert(t78, {
                        v516,
                        v516:CheckTerms(t77)
                    })
                    v516.Frame.Visible = false

                    local function v517() -- line: 5210
                        -- upvalues: v516 (copy), Inventory (ref)
                        v516.Frame.Parent = Inventory
                    end

                    pcall(v517)
                else
                    v516.Frame.Visible = false
                end
            end
        end

        table.sort(t78, function(p234, p235) -- line: 5213
            return p234[2] > p235[2]
        end)
        v44 = true

        local n12 = 0

        for _, v518 in ipairs(t78) do
            local v519 = v518[1]

            if v518[2] > 0 then
                v519.Frame.Visible = true
                v519.Frame.Parent = ScrollingFrame
                v519.Frame.LayoutOrder = _EmptySlotsAttribute + n12
                n12 += 1
                continue
            end

            v519.Frame.Visible = false
        end

        UpdateScrollingFrameCanvasSize()
        X.ZIndex = 2000
    end
end

v1 = PerformSearch

function ResetSearchResults() -- line: 5232
    -- upvalues: ScrollingFrame (ref), t6 (copy), v44 (ref), _EmptySlotsAttribute (ref), X (copy)
    v44 = false

    for i = _EmptySlotsAttribute + 1, #t6 do
        local v520 = t6[i]

        if v520 and v520.Tool then
            local Tool = v520.Tool

            if IsOfCategory(Tool) then
                v520.Frame.Parent = ScrollingFrame
                v520.Frame.Visible = true
            else
                v520.Frame.Visible = false
            end
        end
    end

    X.ZIndex = 0
    UpdateInventorySlots()
end

v2 = ResetSearchResults

function ClearSearchText() -- line: 5250
    -- upvalues: TextBox (ref)
    ResetSearchResults()
    TextBox.Text = ""
end

function OnSearchTextChanged(p236) -- line: 5254
    -- upvalues: TextBox (ref), v487 (ref), X (copy)
    if p236 ~= "Text" then
        return
    end

    PerformSearch()

    local v521 = TextBox.Text ~= ""

    X.Visible = v521
    v487.Enabled = v521
end

function OnSearchFocusLost(p237) -- line: 5262
    if p237 then
        PerformSearch()
    end
end

X.MouseButton1Click:Connect(ClearSearchText)
TextBox.Changed:Connect(OnSearchTextChanged)
TextBox.FocusLost:Connect(OnSearchFocusLost)
t3.StateChanged.Event:Connect(function(p238) -- line: 5270
    -- upvalues: Inventory (ref), v36 (copy)
    if not p238 and not Inventory.Visible then
        v36:deselect()
    end
end)

function OnEscapePressed(p239) -- line: 5275
    -- upvalues: Inventory (ref), v36 (copy)
    if not p239 and not ActiveFuseSelectionState and Inventory.Visible then
        v36:deselect()
    end
end

t8[Enum.KeyCode.Escape.Value] = OnEscapePressed

local function updateSearchVisibility() -- line: 5285
    -- upvalues: Search (copy)
    Search.Visible = UserInputService.VREnabled or UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad
end

local function refreshSlotDragDetectors() -- line: 5289
    -- upvalues: t6 (copy)
    for _, v522 in t6 do
        if not v522.IsDeleted then
            v522:RefreshDragDetector()
        end
    end
end

local function updateBackpackInputMode() -- line: 5296
    -- upvalues: t6 (copy), Search (copy)
    Search.Visible = UserInputService.VREnabled or UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad

    for _, v523 in t6 do
        if not v523.IsDeleted then
            v523:RefreshDragDetector()
        end
    end
end

UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(updateBackpackInputMode)
UserInputService:GetPropertyChangedSignal("VREnabled"):Connect(updateBackpackInputMode)
MenuNavigation.CursorChanged:Connect(refreshSlotDragDetectors)
Inventory:GetPropertyChangedSignal("Visible"):Connect(updateSearchVisibility)
updateBackpackInputMode()
GuiService.MenuOpened:Connect(function() -- line: 5305
    -- upvalues: Inventory (ref), v36 (copy)
    if Inventory.Visible then
        v36:deselect()
    end
end)

function RemoveSlotAction(_, p241, _) -- line: 5310
    -- upvalues: v2 (ref), GuiService (copy), t6 (copy), _EmptySlotsAttribute (ref)
    if p241 == Enum.UserInputState.Begin and GuiService.SelectedObject then
        for i = 1, _EmptySlotsAttribute do
            if t6[i].Frame == GuiService.SelectedObject and t6[i].Tool then
                t6[i]:MoveToInventory()
                v2()

                return
            end
        end

        v2()
    end
end

function setInventoryVisibility(p243) -- line: 5328
    -- upvalues: MenuNavigation (copy), t3 (copy), t4 (ref), t5 (copy), v16 (ref), v17 (ref), Backpack (ref), v24 (ref), Inventory (ref), v36 (copy), t6 (copy), v45 (ref), _EmptySlotsAttribute (ref), v498 (copy)
    Inventory.Visible = p243
    AdjustHotbarFrames()
    v24.Active = not p243

    for i = 1, _EmptySlotsAttribute do
        t6[i]:SetClickability(not p243)
    end

    if Inventory.Visible then
        if v45 then
            if t5[UserInputService:GetLastInputType()] then
                PositionHintFrame()
                v498.Visible = not UserInputService.VREnabled
            end

            enableGamepadInventoryControl()
        end
    else
        if v45 then
            v498.Visible = false
        end

        disableGamepadInventoryControl()
    end

    if Inventory.Visible then
        ContextActionService:BindActionAtPriority("RBXRemoveSlot", RemoveSlotAction, false, Enum.ContextActionPriority.High.Value + 100, Enum.KeyCode.ButtonX)
    else
        ContextActionService:UnbindAction("RBXRemoveSlot")
    end

    MenuNavigation.SetOverride("Backpack", if p243 then Backpack else nil, v24:FindFirstChild("1"), function() -- line: 5364
        -- upvalues: v36 (copy)
        v36:deselect()
    end, 100)
    t3.IsOpen = Inventory.Visible
    t3.StateChanged:Fire(Inventory.Visible)

    if not Inventory.Visible then
        if ActiveFuseSelectionState and v17 then
            v17(false)
        else
            t4 = nil

            if v16 then
                setFavoriteModeActive(false)
            end
        end
    end
end

function t3.OpenClose() -- line: 5384
    -- upvalues: t3 (copy), Inventory (ref), t9 (copy), v41 (ref)
    if not v41 or Inventory.Visible then
        if ActiveFuseSelectionState then
            if Inventory.Visible then
                setInventoryVisibility(false)
            else
                t3.IsOpen = Inventory.Visible
            end
        elseif not next(t9) then
            setInventoryVisibility(not Inventory.Visible)
        end
    end
end

function setFuseSelectionSlotClickability(p244) -- line: 5404
    -- upvalues: t6 (copy)
    for _, v526 in t6 do
        if v526 and v526.Tool then
            v526:SetClickability(not p244)
        end
    end
end

function captureFuseHotbarSnapshot() -- line: 5412
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    local t80 = {}

    for i = 1, _EmptySlotsAttribute do
        local v527 = t6[i]

        if v527 then
            local Tool = v527.Tool

            if not v527.IsFakeSlot and typeof(Tool) == "Instance" and Tool:IsA("Tool") and isAssetTool(Tool) then
                t80[i] = Tool
            end
        end
    end

    return t80
end

function moveFuseHotbarAssetsToInventory() -- line: 5432
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = 1, _EmptySlotsAttribute do
        local v528 = t6[i]

        if v528 and not v528.IsFakeSlot and v528.Tool and isAssetTool(v528.Tool) then
            v528:MoveToInventory()
        end
    end
end

function restoreFuseHotbarSnapshot(p245) -- line: 5441
    -- upvalues: t6 (copy), t7 (copy), _EmptySlotsAttribute (ref)
    local t81 = {}

    for v529, v530 in p245 do
        if typeof(v530) == "Instance" and v530:IsA("Tool") and v530.Parent then
            t81[v530] = v529
        end
    end

    for i = 1, _EmptySlotsAttribute do
        local v531 = t6[i]

        if v531 and not v531.IsFakeSlot and v531.Tool and isAssetTool(v531.Tool) and not t81[v531.Tool] then
            v531:MoveToInventory()
        end
    end

    for v532, v533 in p245 do
        if typeof(v533) == "Instance" and v533:IsA("Tool") and v533.Parent then
            local v534 = t6[v532]
            local v535 = t7[v533]

            if v534 and not v534.IsFakeSlot and v535 and not v535.IsFakeSlot and v535.Tool == v533 and v534 ~= v535 then
                if v534.Tool then
                    v534:MoveToInventory()
                end

                v535:Swap(v534)
            end
        end
    end
end

function stopFuseSelectionVisuals() -- line: 5490
    if FuseSelectionVisualTrove then
        FuseSelectionVisualTrove:Clean()
        FuseSelectionVisualTrove = nil
    end

    refreshInventoryFrameVisuals()
end

function startFuseSelectionVisuals() -- line: 5499
    -- upvalues: RunService (copy), Trove (copy)
    stopFuseSelectionVisuals()

    if InventoryStroke then
        FuseSelectionVisualTrove = Trove.new()

        local n13 = 0

        FuseSelectionVisualTrove:Add(RunService.Heartbeat:Connect(function(p246) -- line: 5509
            -- upvalues: n13 (ref)
            if not ActiveFuseSelectionState then
                return
            end

            n13 += p246 * 3

            local v538 = (math.sin(n13) + 1) / 2

            InventoryStroke.Color = FUSE_SELECTION_STROKE_COLOR:Lerp(Color3.fromRGB(255, 255, 255), v538)
        end))
    end

    refreshInventoryFrameVisuals()
end

function t3.StartMachineSelection(p247, p248, p249, p250, p251, p252) -- line: 5521
    -- upvalues: TextBox (ref), v2 (ref), v3 (ref), SetCategory (ref), v15 (ref), v16 (ref), v44 (ref), AutoSell (ref), EquipBest (ref), v473 (copy)
    assert(type(p248) == "string", "Expected machine selection item type to be a string")
    assert(type(p249) == "function", "Expected fuse selection callback to be a function")
    assert(type(p252) == "string", "Expected preferred category to be a string")

    if ActiveFuseSelectionState then
        p247:EndFuseSelection()
    end

    ActiveFuseSelectionState = {
        AllowedCategories = p251,
        ItemType = p248,
        PreviousCategory = v3,
        PreviousFavoriteModeActive = v16,
        PreferredCategory = p252,
        HotbarSnapshot = captureFuseHotbarSnapshot()
    }
    p247:RequestSelection(p248, p249, false, false, p250)

    if v16 then
        setFavoriteModeActive(false)
    end

    if TextBox and TextBox.Text ~= "" then
        if v2 then
            v2()
        end

        TextBox.Text = ""
    end

    if v15 then
        v15.Visible = false

        if AutoSell then
            AutoSell.Visible = false
        end

        if EquipBest then
            EquipBest.Visible = false
        end
    end

    if v44 and v2 then
        v2()
    end

    if TextBox and TextBox.Text ~= "" then
        TextBox.Text = ""
    end

    v473()
    updateEquipBestButtonVisibility()
    SetCategory(p252)

    if p248 == "Asset" then
        moveFuseHotbarAssetsToInventory()
    end

    AdjustHotbarFrames()
    setInventoryVisibility(true)
    setFuseSelectionSlotClickability(false)
    UpdateInventorySlots()
    startFuseSelectionVisuals()
    OnIconChanged(BackpackEnabled)

    return true
end

v17 = function(p253) -- line: 5591
    -- upvalues: SetCategory (ref), t4 (ref), v15 (ref), AutoSell (ref), EquipBest (ref), v473 (copy)
    local _ActiveFuseSelectionState = ActiveFuseSelectionState

    if not _ActiveFuseSelectionState then
        return
    end

    ActiveFuseSelectionState = nil
    stopFuseSelectionVisuals()
    t4 = nil

    if p253 then
        setInventoryVisibility(false)
    end

    setFuseSelectionSlotClickability(true)

    if CloseButton then
        CloseButton.Active = true
        CloseButton.Visible = true
    end

    if v15 then
        v15.Visible = false

        if AutoSell then
            AutoSell.Visible = false
        end

        if EquipBest then
            EquipBest.Visible = false
        end
    end

    v473()

    if _ActiveFuseSelectionState.ItemType == "Asset" then
        restoreFuseHotbarSnapshot(_ActiveFuseSelectionState.HotbarSnapshot)
    end

    SetCategory(_ActiveFuseSelectionState.PreviousCategory)
    refreshFavoriteModeVisibility()

    if _ActiveFuseSelectionState.PreviousFavoriteModeActive then
        setFavoriteModeActive(true)
    else
        refreshInventoryFrameVisuals()
    end

    UpdateInventorySlots()
    OnIconChanged(BackpackEnabled)
    updateEquipBestButtonVisibility()
end

function t3.EndFuseSelection(_) -- line: 5635
    -- upvalues: v17 (ref)
    v17(true)
end

function t3.StartFuseSelection(p255, p256, p257) -- line: 5637
    return p255:StartMachineSelection("Asset", p256, p257, {
        [FUSE_SELECTION_ASSET_CATEGORY_NAME] = true
    }, FUSE_SELECTION_ASSET_CATEGORY_NAME)
end

function t3.IsFuseSelectionActive(_) -- line: 5646
    return ActiveFuseSelectionState ~= nil
end

tryCore("SetCoreGuiEnabled", Enum.CoreGuiType.Backpack, false)

while not LocalPlayer2 do
    wait()
    LocalPlayer2 = Players.LocalPlayer
end

LocalPlayer2.CharacterAdded:Connect(SetupCharacter)

if LocalPlayer2.Character then
    SetupCharacter(LocalPlayer2.Character)
end

local function handleLocalActiveAssetRecords(p259) -- line: 5658
    refreshPlacedAssetUIDs(p259)

    local v542 = clearPlacedAssetBackpackSlots(p259)
    local v543 = syncAssetsFromSave()

    if v542 and not v543 then
        AdjustHotbarFrames()
        UpdateInventorySlots()
    end

    reconcileVirtualAssetEquipState()
end

refreshPlacedAssetUIDs(AssetRoster.ReadOwnerPen(LocalPlayer2.UserId))
AssetRoster.OwnerRefreshed:Connect(function(p260, p261) -- line: 5671
    -- upvalues: LocalPlayer2 (ref), handleLocalActiveAssetRecords (copy)
    if p260 == LocalPlayer2.UserId then
        handleLocalActiveAssetRecords(p261)
    end
end)
AssetRoster.OwnerCleared:Connect(function(p262) -- line: 5677
    -- upvalues: LocalPlayer2 (ref), handleLocalActiveAssetRecords (copy)
    if p262 == LocalPlayer2.UserId then
        handleLocalActiveAssetRecords({})
    end
end)
task.spawn(function() -- line: 5683
    -- upvalues: Save (copy), v51 (ref), v52 (ref), v53 (ref), v54 (ref)
    Save.Await()
    syncAssetsFromSave()
    syncEggsFromSave()
    reconcileVirtualAssetEquipState()
    reconcileVirtualEggEquipState()
    v51 = captureEligibleAssetUIDs()
    v53 = captureEggUIDs()
    v52 = true
    v54 = true
end)
Save.WatchFields({ "Inventory", "AssetFavoriteCategories" }, function() -- line: 5696
    -- upvalues: v51 (ref), v52 (ref)
    local v544 = captureEligibleAssetUIDs()

    if v52 then
        queueNewEligibleAssetsForHotbar(v51, v544)
    end

    v51 = v544
    v52 = true
    syncAssetsFromSave()
    reconcileVirtualAssetEquipState()
    movePendingHotbarAssets()
end)
Save.WatchFields({
    "EquippedAssets",
    "BaseUpgradeLevel",
    "Gamepasses",
    "Products"
}, function() -- line: 5708
    syncAssetsFromSave()
    reconcileVirtualAssetEquipState()
end)
Save.WatchFields("EggInventory", function() -- line: 5713
    -- upvalues: v53 (ref), v54 (ref)
    local v545 = captureEggUIDs()

    if v54 then
        queueNewEggsForHotbar(v53, v545)
    end

    v53 = v545
    v54 = true
    syncEggsFromSave()
    reconcileVirtualEggEquipState()
    movePendingHotbarEggs()
end)
EggState.SnapshotRefreshed:Connect(function() -- line: 5725
    syncEggsFromSave()
    reconcileVirtualEggEquipState()
end)
PlotState.LocalPlotChanged:Connect(function() -- line: 5730
    invalidateEquipBestStatus(true)
end)
PlotState.FolderChanged:Connect(function() -- line: 5731
    invalidateEquipBestStatus(true)
end)
UserInputService.InputBegan:Connect(HandleInputBegan)
UserInputService.TextBoxFocused:Connect(function() -- line: 5734
    -- upvalues: v43 (ref)
    v43 = true
end)
UserInputService.TextBoxFocusReleased:Connect(function() -- line: 5735
    -- upvalues: v43 (ref)
    v43 = false
end)

t8[Value2] = function() -- line: 5736
    -- upvalues: Humanoid (ref)
    if Humanoid then
        UnequipAllTools()
    end
end

UserInputService.Changed:Connect(OnInputServiceChanged)
OnInputServiceChanged("KeyboardEnabled")

if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
    gamepadConnected()
end

UserInputService.GamepadConnected:Connect(function(p263) -- line: 5746
    if p263 == Enum.UserInputType.Gamepad1 then
        gamepadConnected()
    end
end)
UserInputService.GamepadDisconnected:Connect(function(p264) -- line: 5751
    if p264 == Enum.UserInputType.Gamepad1 then
        gamepadDisconnected()
    end
end)

function t3.RequestSelection(_, p266, p267, p268, p269, p270) -- line: 5756
    -- upvalues: t4 (ref)
    t4 = {
        ItemType = p266,
        Callback = p267,
        AllowHotbar = p268 == true,
        Preserve = p269 == true,
        Validator = p270
    }
end

function t3.ClearSelectionRequest(_) -- line: 5771
    -- upvalues: t4 (ref)
    t4 = nil
end

function t3.SetCategory(_, p273) -- line: 5772
    -- upvalues: SetCategory (ref)
    SetCategory(p273)
end

function t3.OpenInventory(_) -- line: 5773
    -- upvalues: t3 (copy)
    if not t3.IsOpen then
        t3.OpenClose()
    end
end

function t3.SetBackpackEnabled(_, p276) -- line: 5778
    BackpackEnabled = p276
end

function t3.SetTreadmillPhoneOnlyMode(_, p278) -- line: 5779
    -- upvalues: Inventory (ref), v36 (copy), v41 (ref)
    if v41 == p278 then
        return
    end

    v41 = p278

    if p278 and Inventory.Visible then
        v36:deselect()
    end

    AdjustHotbarFrames()
end

function t3.IsOpened(_) -- line: 5789
    -- upvalues: t3 (copy)
    return t3.IsOpen
end

function t3.GetBackpackEnabled(_) -- line: 5790
    return BackpackEnabled
end

function t3.GetCategory(_) -- line: 5791
    -- upvalues: v3 (ref)
    return v3
end

function t3.RefreshInventory(_) -- line: 5792
    -- upvalues: v1 (ref)
    if v1 then
        v1()
    else
        UpdateInventorySlots()
    end
end

function t3.GetStateChangedEvent(_) -- line: 5800
    -- upvalues: t3 (copy)
    return t3.StateChanged.Event
end

function t3.ForceEggIntoTutorialHotbar(_, p285) -- line: 5802
    -- upvalues: v1 (ref), t6 (copy), t16 (copy), t18 (copy), t19 (copy)
    local v546 = t16[p285] or findVirtualEggSlotByUID(p285)
    local v547, v548

    if v546 and not v546.IsDeleted then
        t18[p285] = nil
        t19[p285] = nil
        v547 = t6[5]
        v548 = v547 and not v547.IsFakeSlot
        assert(v548, (`Tutorial egg hotbar slot {5} must be available`))
        assert(canToolUseHotbarSlot(v546.Tool, 5), (`Tutorial egg must be insertable in slot {5}`))

        if v547.Tool and v547 ~= v546 then
            v547:MoveToInventory()
        end

        if v546 ~= v547 then
            v546:Swap(v547)
        end

        t16[p285] = v547
        AdjustHotbarFrames()
        UpdateInventorySlots()

        if v1 then
            v1(true)
        end

        if reconcileVirtualEggEquipState() ~= p285 then
            v547:Select()
        end

        return v547.Frame
    end

    t19[p285] = true

    return nil
end

function t3.GetPhoneSlotFrame(_) -- line: 5844
    -- upvalues: t6 (copy), _EmptySlotsAttribute (ref)
    for i = 1, _EmptySlotsAttribute do
        local v552 = t6[i]

        if v552 and not v552.IsFakeSlot and v552.Tool and isPhoneTool(v552.Tool) then
            return v552.Frame
        end
    end

    return nil
end

function t3.GetEggSlotFrame(_, p288) -- line: 5855
    -- upvalues: t16 (copy)
    local v553 = t16[p288] or findVirtualEggSlotByUID(p288)

    return if v553 ~= nil and not v553.IsDeleted then v553.Frame else nil
end

RunService.Heartbeat:Connect(function() -- line: 5866
    -- upvalues: ToolGameplayGuard (copy), v42 (ref), v58 (ref), v59 (ref), v61 (ref)
    OnIconChanged(BackpackEnabled)

    local v554 = ToolGameplayGuard.IsLocalInsideArena()

    if v554 and not v42 then
        ensureGameplayGearHotbarSlots()
    end

    v42 = v554

    local v555 = isLocalPlayerWithinOwnPlotBounds()

    if v61 == v555 then
        if v61 and (v59 or not v58) then
            requestEquipBestStatusRefresh()
        else
            updateEquipBestButtonVisibility()
        end
    else
        v61 = v555

        if v555 then
            requestEquipBestStatusRefresh(true)
        else
            updateEquipBestButtonVisibility()
        end
    end
end)
ApiEvent.Event:Connect(function(p289, p290) -- line: 5891
    -- upvalues: t3 (copy)
    if p289 == "SetBackpackEnabled" then
        t3:SetBackpackEnabled(p290)
    elseif p289 == "SetInventoryOpen" then
        if type(p290) == "boolean" and p290 == true then
            t3.IsOpen = true
        elseif type(p290) == "boolean" then
            t3.IsOpen = false
        end
    elseif p289 == "ToggleBackpack" then
        t3.OpenClose()
    end
end)
require(script.Navigation)(Backpack, Inventory, ScrollingFrame, v24, CategoryFrame)
require(script.Capacity)(Inventory, Backpack)
require(script.MutationHint)(v24, Inventory)

function t3.GetMutationRewardTarget(_, p292) -- line: 5914
    -- upvalues: v24 (ref), t6 (copy), _EmptySlotsAttribute (ref)
    for _, v556 in t6 do
        local Tool = v556.Tool

        if v556.Index <= _EmptySlotsAttribute and typeof(Tool) == "Instance" and Tool:IsA("Tool") and Tool:GetAttribute("MutationId") == p292 and v556.Frame and v556.Frame.Visible and not v556.IsDeleted then
            return v556.Frame
        end
    end

    return v24
end

return t3
