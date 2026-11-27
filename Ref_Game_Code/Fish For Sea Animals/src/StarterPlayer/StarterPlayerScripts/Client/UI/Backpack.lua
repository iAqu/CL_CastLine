-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Tooltip = require(script.Parent.Tooltip)
local HotbarDrag = require(script.Parent.HotbarDrag)
local Viewport = require(script.Parent.Viewport)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    items = {}
}
local v1 = {}
local HotbarSlots = Config.HotbarSlots
local t2 = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5,
    [Enum.KeyCode.Six] = 6,
    [Enum.KeyCode.Seven] = 7,
    [Enum.KeyCode.Eight] = 8,
    [Enum.KeyCode.Nine] = 9,
    [Enum.KeyCode.Zero] = 10
}
local v2 = Color3.fromRGB(70, 140, 255)
local v3, Panel, Grid, ItemTemplate, Search, Inventory, BackgroundColor3
local t3 = {}
local v4 = {}
local t4 = {}
local n1 = 1
local t5 = {}
local v5 = false

local function v6() -- line: 54
    return false
end

local function holding() -- line: 58
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character and Character:GetAttribute("Holding")
end

function t1.entry(p1) -- line: 63
    -- upvalues: t1 (copy)
    for _, v7 in t1.items do
        if v7.Uid == p1 then
            return v7
        end
    end

    return nil
end

local function clearIcon(p2) -- line: 72
    for _, child in p2.Viewport:GetChildren() do
        child:Destroy()
    end

    p2:SetAttribute("Species", nil)
end

local function fill(p3, p4) -- line: 79
    -- upvalues: Animals (copy), AnimalModel (copy), Format (copy), Viewport (copy), LocalPlayer (copy)
    p3.Rate.Text = Format.money(Animals.income(p4)) .. "/s"
    p3.Rate.Visible = true

    local v8 = p4.Id .. "/" .. (p4.Mutation or "")

    if p3:GetAttribute("Species") ~= v8 then
        local v9 = AnimalModel.clone(p4.Id, 4, p4.Mutation)

        if v9 then
            Viewport.show(p3.Viewport, v9, 50, 0.85)
        end

        p3:SetAttribute("Species", v8)
    end

    local Outline = p3.Outline
    local Uid = p4.Uid
    local Character = LocalPlayer.Character

    Outline.Transparency = Uid == (Character and Character:GetAttribute("Holding")) and 0 or 1
end

local function equip(p5) -- line: 93
    -- upvalues: Remotes (copy), v6 (ref)
    if not v6() then
        Remotes.HoldAnimal:FireServer(p5)
    end
end

function t1.toggleSlot(p6) -- line: 100
    -- upvalues: Remotes (copy), LocalPlayer (copy), v4 (ref), v6 (ref)
    local v10 = v4[p6]

    if not v10 then
        return
    end

    local Character = LocalPlayer.Character

    if (Character and Character:GetAttribute("Holding")) == v10 then
        v10 = nil
    end

    if v6() then
        return
    end

    Remotes.HoldAnimal:FireServer(v10)
end

local function dropped(p7, p8, p9) -- line: 110
    -- upvalues: Remotes (copy), UIUtil (copy), HotbarDrag (copy), LocalPlayer (copy), t1 (copy), Panel (ref), t3 (copy), v4 (ref), v6 (ref)
    if not p7 then
        return
    end

    for v11, v12 in t3 do
        if HotbarDrag.over(v12, p9) then
            if p8 then
                local v13 = v4
                local v14 = v4
                local v15 = v4[v11]
                local v16 = v4[p8]

                v13[p8] = v15
                v14[v11] = v16
            else
                local v17 = v4

                v17[v11] = p7
            end

            UIUtil.sound("Click", 0.5, 1.1)
            t1.render()

            return
        end
    end

    if p8 and Panel.Visible and HotbarDrag.over(Panel, p9) then
        local v18 = v4

        v18[p8] = nil

        local Character = LocalPlayer.Character

        if (Character and Character:GetAttribute("Holding")) == p7 and not v6() then
            Remotes.HoldAnimal:FireServer(nil)
        end

        UIUtil.sound("Click", 0.5, 0.9)
        t1.render()
    end
end

local function takeOut(p10) -- line: 138
    -- upvalues: Remotes (copy), LocalPlayer (copy), t1 (copy), HotbarSlots (copy), v4 (ref), v6 (ref)
    local v19

    for i = 1, HotbarSlots do
        if v4[i] == nil then
            v19 = i
            break
        end
    end

    if not v19 then
        local find = table.find
        local v20 = v4
        local Character = LocalPlayer.Character

        v19 = find(v20, Character and Character:GetAttribute("Holding")) or HotbarSlots
    end

    local v21 = v4

    v21[v19] = p10

    if not v6() then
        Remotes.HoldAnimal:FireServer(p10)
    end

    t1.render()
end

local t6 = {}

for _, v22 in Products.PackPotions do
    t6[v22.Stat] = v22.Image
end

local function potions() -- line: 159
    -- upvalues: HttpService (copy), LocalPlayer (copy)
    local JSONDecode = HttpService.JSONDecode
    local v23 = LocalPlayer:GetAttribute("PotionStock") or "{}"
    local ok, result = pcall(JSONDecode, HttpService, v23)
    local t7 = {}

    if ok and type(result) == "table" then
        for v24, v25 in result do
            local v26, v27 = string.match(tostring(v24), "^(%a+):(%d+)$")

            if v26 and type(v25) == "number" and v25 > 0 then
                table.insert(t7, {
                    key = v24,
                    stat = v26,
                    seconds = tonumber(v27),
                    count = v25
                })
            end
        end
    end

    local t9 = {
        Cash = 1,
        Strength = 2,
        Luck = 3
    }

    table.sort(t7, function(p11, p12) -- line: 171
        -- upvalues: t9 (copy)
        if p11.stat == p12.stat then
            return p11.seconds < p12.seconds
        end

        return (t9[p11.stat] or 9) < (t9[p12.stat] or 9)
    end)

    return t7
end

local function potionButton(p13, p14) -- line: 181
    -- upvalues: Remotes (copy), UIUtil (copy), Grid (ref), ItemTemplate (ref), t6 (copy)
    local clone = ItemTemplate:Clone()

    clone.Name = "Potion_" .. p13.key
    clone.LayoutOrder = p14
    clone.Visible = true
    clone.Viewport.Visible = false
    clone.Outline.Transparency = 1
    clone.Rate.Text = ("2x %* · %*m"):format(p13.stat, p13.seconds // 60)
    clone.Rate.Visible = true

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Potion"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = clone.Viewport.AnchorPoint
    ImageLabel.Position = clone.Viewport.Position
    ImageLabel.Size = clone.Viewport.Size
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Image = t6[p13.stat] or ""
    ImageLabel.Parent = clone

    local clone2 = clone.Rate:Clone()

    clone2.Name = "Count"
    clone2.AnchorPoint = Vector2.new(1, 1)
    clone2.Position = UDim2.new(1, -4, 1, -2)
    clone2.Size = UDim2.new(0.6, 0, 0, 22)
    clone2.TextXAlignment = Enum.TextXAlignment.Right
    clone2.TextColor3 = Color3.new(1, 1, 1)
    clone2.Text = ("x%*"):format(p13.count)
    clone2.Parent = clone
    UIUtil.bindButton(clone, function() -- line: 208
        -- upvalues: p13 (copy), Remotes (copy)
        Remotes.UsePotion:FireServer(p13.key)
    end)
    clone.Parent = Grid
end

local function renderGrid() -- line: 214
    -- upvalues: Animals (copy), UIUtil (copy), Tooltip (copy), HotbarDrag (copy), t1 (copy), v3 (ref), Panel (ref), Grid (ref), ItemTemplate (ref), Search (ref), v4 (ref), v5 (ref), fill (copy), dropped (copy), takeOut (copy), potions (copy), potionButton (copy)
    for _, child in Grid:GetChildren() do
        if child:IsA("GuiObject") and child ~= ItemTemplate then
            child:Destroy()
        end
    end

    local v28 = string.lower(Search.Text)
    local t10 = {}

    for _, v29 in t1.items do
        if not table.find(v4, v29.Uid) and (v28 == "" or string.find(string.lower(Animals.displayName(v29)), v28, 1, true)) then
            table.insert(t10, v29)
        end
    end

    table.sort(t10, function(p15, p16) -- line: 228
        -- upvalues: Animals (copy)
        local v30 = Animals.income(p15)
        local v31 = Animals.income(p16)

        if v30 == v31 then
            return p15.Uid < p16.Uid
        end

        return v31 < v30
    end)

    for v32, v33 in t10 do
        local clone = ItemTemplate:Clone()

        clone.Name = v33.Uid
        clone.LayoutOrder = v32
        clone.Visible = true
        fill(clone, v33)
        UIUtil.bindButton(clone, function() -- line: 241
            -- upvalues: v33 (copy), HotbarDrag (copy), takeOut (copy)
            if not HotbarDrag.justDropped() then
                takeOut(v33.Uid)
            end
        end)
        Tooltip.bind(clone, function() -- line: 246
            -- upvalues: v33 (copy)
            return v33
        end)
        HotbarDrag.attach(clone, {
            gui = v3,
            scroller = Grid,
            canStart = function() -- canStart | line: 252
                -- upvalues: v5 (ref)
                return not v5
            end,
            onDrop = function(p17) -- onDrop | line: 255
                -- upvalues: v33 (copy), dropped (copy)
                dropped(v33.Uid, nil, p17)
            end
        })
        clone.Parent = Grid
    end

    local v34 = if v28 == "" or string.find("potions", v28, 1, true) then potions() else {}

    for v35, v36 in v34 do
        potionButton(v36, v35 - #v34 - 1)
    end

    Panel.Empty.Text = v28 == "" and "No other items" or "No matches"

    local Empty = Panel.Empty

    if #t10 == 0 then
        Empty.Visible = #v34 == 0
    else
        Empty.Visible = false
    end
end

function t1.render() -- line: 269
    -- upvalues: t1 (copy), Panel (ref), t3 (copy), v4 (ref), v5 (ref), fill (copy), renderGrid (copy)
    local Visible = Panel.Visible

    for v37, v38 in t3 do
        local v39 = t1.entry(v4[v37])

        if v39 then
            fill(v38, v39)
        else
            for _, child in v38.Viewport:GetChildren() do
                child:Destroy()
            end

            v38:SetAttribute("Species", nil)
            v38.Rate.Visible = false
            v38.Outline.Transparency = 1
        end

        local v40 = not v5 and (v39 ~= nil or Visible)

        v38.Visible = v40
    end

    if Visible then
        renderGrid()
    end
end

function t1.isOpen() -- line: 287
    -- upvalues: Panel (ref)
    return Panel.Visible
end

function t1.setOpen(p18) -- line: 291
    -- upvalues: UIUtil (copy), t1 (copy), v2 (copy), Panel (ref), Search (ref), Inventory (ref), BackgroundColor3 (ref), v5 (ref)
    if p18 and v5 then
        return
    end

    Panel.Visible = p18

    local Inventory2 = Inventory

    if p18 then
        Inventory2.BackgroundColor3 = v2
        UIUtil.pop(Panel, 0.85)
    else
        Inventory2.BackgroundColor3 = BackgroundColor3
        Search:ReleaseFocus()
    end

    t1.render()
end

function t1.setVisible(p19) -- line: 306
    -- upvalues: t1 (copy), Panel (ref), v5 (ref)
    v5 = not p19

    if v5 and Panel.Visible then
        t1.setOpen(false)
    end

    t1.render()
end

function t1.setBusyCheck(p20) -- line: 314
    -- upvalues: v6 (ref)
    v6 = p20
end

local function onInventory(p21) -- line: 318
    -- upvalues: Animals (copy), LocalPlayer (copy), t1 (copy), v1 (ref), HotbarSlots (copy), v4 (ref), t4 (copy), n1 (ref), t5 (ref)
    v1 = p21
    n1 = LocalPlayer:GetAttribute("World") or 1

    local v41 = t4[n1] == nil
    local v42 = n1

    t4[v42] = t4[n1] or {}
    v4 = t4[n1]

    local t12 = {}

    for _, v43 in p21 do
        if Animals.inWorld(v43, n1) then
            table.insert(t12, v43)
        end
    end

    t1.items = t12

    local t13 = {}

    for _, v44 in v1 do
        t13[v44.Uid] = true
    end

    for _, v45 in t4 do
        for i = 1, HotbarSlots do
            if v45[i] and not t13[v45[i]] then
                v45[i] = nil
            end
        end
    end

    for _, v46 in t12 do
        local v47 = v41

        if not v47 then
            local t14 = t5

            v47 = not t14[v46.Uid]
        end

        if v47 then
            local find = table.find
            local v48 = v4

            if not find(v48, v46.Uid) then
                for j = 1, HotbarSlots do
                    local v49 = v4

                    if v49[j] == nil then
                        local v50 = v4

                        v50[j] = v46.Uid
                        break
                    end
                end
            end
        end
    end

    t5 = t13
    t1.render()
end

local function disableCoreBackpack() -- line: 358
    -- upvalues: StarterGui (copy)
    for _ = 1, 20 do
        local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled
        local Backpack = Enum.CoreGuiType.Backpack

        if pcall(SetCoreGuiEnabled, StarterGui, Backpack, false) then
            return
        end

        task.wait(0.5)
    end
end

function t1.init() -- line: 374
    -- upvalues: GuiService (copy), UserInputService (copy), Remotes (copy), UIUtil (copy), Tooltip (copy), HotbarDrag (copy), LocalPlayer (copy), t1 (copy), v1 (ref), HotbarSlots (copy), t2 (copy), v3 (ref), Panel (ref), Grid (ref), ItemTemplate (ref), Search (ref), Inventory (ref), BackgroundColor3 (ref), t3 (copy), v4 (ref), v5 (ref), dropped (copy), renderGrid (copy), onInventory (copy), disableCoreBackpack (copy)
    task.spawn(disableCoreBackpack)
    v3 = UIUtil.gui("Backpack")

    local Holder = v3:WaitForChild("Holder")

    UIUtil.onScale(function(p22) -- line: 378
        -- upvalues: Holder (copy), GuiService (copy), UIUtil (copy)
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v53 = math.min((ViewportSize.Y - GuiService:GetGuiInset().Y - 20) / Holder.Size.Y.Offset, ViewportSize.X * 0.9 / Holder.Size.X.Offset)

        Holder.Scale.Scale = math.min(p22 * 1.15 * UIUtil.smallScreenBoost(p22, 1.6), v53)
    end)

    local Hotbar = Holder:WaitForChild("Hotbar")

    Panel = Holder:WaitForChild("Panel")
    Grid = Panel.Grid
    ItemTemplate = Grid.ItemTemplate
    Search = Panel.Search
    Inventory = UIUtil.gui("HUD"):WaitForChild("TopLeftButtons"):WaitForChild("Inventory")
    BackgroundColor3 = Inventory.BackgroundColor3
    Panel.Visible = false

    local SlotTemplate = Hotbar.SlotTemplate

    for i = 1, HotbarSlots do
        local clone = SlotTemplate:Clone()

        clone.Name = "Slot" .. i
        clone.LayoutOrder = i
        clone.Number.Text = tostring(i % 10)
        UIUtil.bindButton(clone, function() -- line: 399
            -- upvalues: i (copy), HotbarDrag (copy), t1 (copy)
            if not HotbarDrag.justDropped() then
                t1.toggleSlot(i)
            end
        end)
        Tooltip.bind(clone, function() -- line: 404
            -- upvalues: i (copy), t1 (copy), v4 (ref)
            return t1.entry(v4[i])
        end)
        HotbarDrag.attach(clone, {
            gui = v3,
            canStart = function() -- canStart | line: 409
                -- upvalues: i (copy), v4 (ref), v5 (ref)
                return v4[i] ~= nil and not v5
            end,
            onDrop = function(p23) -- onDrop | line: 412
                -- upvalues: i (copy), v4 (ref), dropped (copy)
                dropped(v4[i], i, p23)
            end
        })
        clone.Parent = Hotbar
        t3[i] = clone
    end

    UIUtil.bindButton(Inventory, function() -- line: 420
        -- upvalues: t1 (copy), Panel (ref)
        t1.setOpen(not Panel.Visible)
    end)
    UIUtil.bindButton(Panel.Close, function() -- line: 423
        -- upvalues: t1 (copy)
        t1.setOpen(false)
    end)
    Search:GetPropertyChangedSignal("Text"):Connect(function() -- line: 426
        -- upvalues: Panel (ref), renderGrid (copy)
        if Panel.Visible then
            renderGrid()
        end
    end)
    UserInputService.InputBegan:Connect(function(p24, p25) -- line: 432
        -- upvalues: UserInputService (copy), t1 (copy), t2 (copy), Panel (ref), v5 (ref)
        if not (p25 or UserInputService:GetFocusedTextBox()) then
            if p24.KeyCode == Enum.KeyCode.Backquote then
                t1.setOpen(not Panel.Visible)
            elseif t2[p24.KeyCode] and not v5 then
                t1.toggleSlot(t2[p24.KeyCode])
            end
        end
    end)

    local function watchCharacter(p26) -- line: 444
        -- upvalues: t1 (copy)
        p26:GetAttributeChangedSignal("Holding"):Connect(t1.render)
        t1.render()
    end

    LocalPlayer.CharacterAdded:Connect(watchCharacter)

    if LocalPlayer.Character then
        LocalPlayer.Character:GetAttributeChangedSignal("Holding"):Connect(t1.render)
        t1.render()
    end

    LocalPlayer:GetAttributeChangedSignal("PotionStock"):Connect(function() -- line: 453
        -- upvalues: Panel (ref), renderGrid (copy)
        if Panel.Visible then
            renderGrid()
        end
    end)
    Remotes.Inventory.OnClientEvent:Connect(onInventory)
    LocalPlayer:GetAttributeChangedSignal("World"):Connect(function() -- line: 460
        -- upvalues: v1 (ref), onInventory (copy)
        onInventory(v1)
    end)
    Remotes.Inventory:FireServer()
end

return t1
