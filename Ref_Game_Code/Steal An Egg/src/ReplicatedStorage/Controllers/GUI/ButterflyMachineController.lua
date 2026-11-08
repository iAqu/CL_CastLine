-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local t1 = {
    {
        Button = "Recipe1",
        From = "Green"
    },
    {
        Button = "Recipe2",
        From = "Blue"
    },
    {
        Button = "Recipe3",
        From = "Purple"
    }
}
local v1 = Color3.fromRGB(255, 120, 120)
local v2 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local t2 = {
    "SunburstBack",
    "StarDecor"
}
local v3 = TryLock(8)
local t3 = {}

local function child(p1, p2) -- line: 44
    local v4 = p1:FindFirstChild(p2)

    assert(v4, (("%* needs a child named %*"):format(p1:GetFullName(), p2)))

    return v4
end

local function counts() -- line: 50
    -- upvalues: Save (copy)
    local v6 = if Save.IsLoaded() then Save.Peek() else nil
    local Butterflies = if v6 then v6.Butterflies else nil

    if typeof(Butterflies) == "table" then
        return Butterflies.Counts
    end

    return {
        Green = 0,
        Blue = 0,
        Purple = 0,
        Golden = 0
    }
end

local function plural(p3) -- line: 59
    return (string.gsub(p3, "Butterfly$", "Butterflies"))
end

local function setText(p4, p5) -- line: 63
    if p4 and p4:IsA("TextLabel") then
        p4.Text = p5
    end
end

local function setEnabled(p6, p7) -- line: 69
    p6.Active = p7
    p6.AutoButtonColor = false
    p6:SetAttribute("Disabled", not p7)

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("TextLabel") then
            descendant.TextTransparency = p7 and 0 or 0.45
        end
    end

    p6.BackgroundTransparency = p7 and 0 or 0.45
end

local function pop(p8) -- line: 81
    -- upvalues: TweenService (copy), v2 (copy)
    local PopScale = p8:FindFirstChild("PopScale")

    if PopScale == nil then
        PopScale = Instance.new("UIScale")
        PopScale.Name = "PopScale"
        PopScale.Parent = p8
    end

    PopScale.Scale = 1.12
    TweenService:Create(PopScale, v2, {
        Scale = 1
    }):Play()
end

local function deny(p9) -- line: 94
    -- upvalues: Audio (copy), ButterflyCatalog (copy), Toast (copy), v1 (copy)
    Audio.Play(ButterflyCatalog.Sounds.Deny, script, {
        Volume = 0.6
    })

    if p9 then
        Toast.Show({
            Lane = "Feed",
            Seconds = 2.5,
            Text = p9,
            Color = v1
        })
    end
end

local function request(p10, ...) -- line: 101
    -- upvalues: v3 (copy)
    local v7 = table.pack(...)
    local v8, v9, v10, v11 = v3(function() -- line: 103
        -- upvalues: p10 (copy), v7 (copy)
        local function v12() -- line: 104
            -- upvalues: p10 (copy), v7 (copy)
            return p10:InvokeServer(table.unpack(v7, 1, v7.n))
        end

        return pcall(v12)
    end)

    if v8 and v9 then
        local v13 = v10 == true

        if typeof(v11) == "string" then
            return v13, v11
        end

        return v13, nil
    end

    return false, nil
end

function t3.Start() -- line: 118
    -- upvalues: Audio (copy), ButterflyCatalog (copy), ButtonFX (copy), GUI (copy), Remotes (copy), Save (copy), Tabs (copy), Toast (copy), t1 (copy), t2 (copy), counts (copy), setEnabled (copy), pop (copy), deny (copy), request (copy)
    local ButterflyMachine = GUI.Get("ButterflyMachine")
    local Frame = ButterflyMachine:FindFirstChild("Frame")

    assert(Frame, (("%* needs a child named Frame"):format((ButterflyMachine:GetFullName()))))

    local Collection = Frame:FindFirstChild("Collection")

    assert(Collection, (("%* needs a child named Collection"):format((Frame:GetFullName()))))

    local TradeUp = Collection:FindFirstChild("TradeUp")

    assert(TradeUp, (("%* needs a child named TradeUp"):format((Collection:GetFullName()))))

    local Recipes = TradeUp:FindFirstChild("Recipes")

    assert(Recipes, (("%* needs a child named Recipes"):format((TradeUp:GetFullName()))))

    local TradeButton = TradeUp:FindFirstChild("TradeButton")

    assert(TradeButton, (("%* needs a child named TradeButton"):format((TradeUp:GetFullName()))))

    local SlotTemplates = ButterflyMachine:FindFirstChild("SlotTemplates")

    assert(SlotTemplates, (("%* needs a child named SlotTemplates"):format((ButterflyMachine:GetFullName()))))

    local InputSlot = TradeUp:FindFirstChild("InputSlot")

    assert(InputSlot, (("%* needs a child named InputSlot"):format((TradeUp:GetFullName()))))

    local OutputSlot = TradeUp:FindFirstChild("OutputSlot")

    assert(OutputSlot, (("%* needs a child named OutputSlot"):format((TradeUp:GetFullName()))))

    local InputSlotPosition = InputSlot.Position
    local OutputSlotPosition = OutputSlot.Position
    local child

    for _, child2 in Collection:GetChildren() do
        if child2.Name == "Hint" and child2:IsA("TextLabel") and string.find(child2.Text, "Uses") then
            child = child2
        end
    end

    local v22 = "Green"
    local v23 = nil
    local Next
    local v24 = InputSlot
    local v25 = OutputSlot

    local function placeSlot(p11, p12, p13, p14, p15) -- line: 143
        -- upvalues: SlotTemplates (copy), t2 (copy)
        local v26 = SlotTemplates:FindFirstChild(p12)

        if v26 == nil or not v26:IsA("GuiObject") then
            return p11
        end

        local clone = v26:Clone()

        clone.Name = p13
        clone.Position = p14
        clone.Visible = true

        for _, v27 in t2 do
            for _, child in clone:GetChildren() do
                if child.Name == v27 and child:IsA("GuiObject") then
                    child.Visible = p15
                end
            end
        end

        clone.Parent = p11.Parent
        p11:Destroy()

        return clone
    end

    local function render() -- line: 170
        -- upvalues: Recipes (copy), TradeButton (copy), InputSlotPosition (copy), OutputSlotPosition (copy), child (ref), v22 (ref), v23 (ref), Next (ref), v24 (ref), v25 (ref), placeSlot (copy), ButterflyCatalog (copy), t1 (copy), counts (copy), setEnabled (copy)
        local v28 = counts()
        local v29 = ButterflyCatalog.Get(v22)
        local Next2 = v29.Next
        local v30 = ButterflyCatalog.Get(Next2)
        local v31 = ButterflyCatalog.TradeUpCost(v22) or 0
        local v32 = v28[v22] or 0
        local v33 = v23

        if v33 ~= v22 then
            v24 = placeSlot(v24, v22, "InputSlot", InputSlotPosition, false)
            v23 = v22
        end

        if Next ~= Next2 then
            v25 = placeSlot(v25, Next2, "OutputSlot", OutputSlotPosition, true)
            Next = Next2
        end

        local Quantity = v24:FindFirstChild("Quantity")
        local v34 = ("<font color=\"%*\">%*</font> / %*"):format(if v31 <= v32 then "#7CFF6B" else "#FF6B6B", v32, v31)

        if Quantity and Quantity:IsA("TextLabel") then
            Quantity.Text = v34
        end

        local Quantity2 = v25:FindFirstChild("Quantity")

        if Quantity2 and Quantity2:IsA("TextLabel") then
            Quantity2.Text = "x1"
        end

        if child then
            local child2 = child
            local DisplayName = v29.DisplayName

            child2.Text = ("Uses %* %* to make 1 %*"):format(v31, string.gsub(DisplayName, "Butterfly$", "Butterflies"), v30.DisplayName)
        end

        for _, v35 in t1 do
            local v36 = Recipes:FindFirstChild(v35.Button)

            if v36 ~= nil then
                local v37 = ButterflyCatalog.TradeUpCost(v35.From) or 0
                local Amount = v36:FindFirstChild("Amount")

                if Amount and Amount:IsA("TextLabel") then
                    Amount.Text = string.gsub(Amount.Text, "^%d+", (tostring(v37)))
                end

                local SelectStroke = v36:FindFirstChild("SelectStroke")

                if SelectStroke and SelectStroke:IsA("UIStroke") then
                    SelectStroke.Enabled = v35.From == v22
                end
            end
        end

        setEnabled(TradeButton, v31 <= v32 and v31 > 0)
    end

    for _, v39 in t1 do
        local v40 = Recipes:FindFirstChild(v39.Button)

        if v40 ~= nil and v40:IsA("GuiButton") then
            ButtonFX(v40)
            GUI.OnActivated(v40, function() -- line: 220
                -- upvalues: v22 (ref), render (copy), v39 (copy)
                if v22 ~= v39.From then
                    v22 = v39.From
                    render()
                end
            end)
        end
    end

    ButtonFX(TradeButton)
    GUI.OnActivated(TradeButton, function() -- line: 230
        -- upvalues: TradeButton (copy), v22 (ref), v25 (ref), Audio (copy), ButterflyCatalog (copy), Remotes (copy), Toast (copy), pop (copy), deny (copy), request (copy)
        local v42 = ButterflyCatalog.TradeUpCost(v22) or 0
        local v43 = ButterflyCatalog.Get(v22)

        if TradeButton:GetAttribute("Disabled") == true then
            local DisplayName = v43.DisplayName

            deny((("Collect %* %* to trade up!"):format(v42, (string.gsub(DisplayName, "Butterfly$", "Butterflies")))))
        else
            local v44, v45 = request(Remotes.Butterflies.AskTradeUp, v22)

            if v44 then
                local v46 = ButterflyCatalog.Get(v43.Next)

                Audio.Play(ButterflyCatalog.Sounds.Craft, script, {
                    Volume = 0.7
                })
                pop(v25)
                Toast.Show({
                    Lane = "Feed",
                    Seconds = 2.5,
                    Text = ("Traded up for a %*!"):format(v46.DisplayName),
                    Color = v46.Color,
                    StrokeColor = v46.StrokeColor,
                    Image = v46.Icon
                })
            else
                deny(v45)
            end
        end
    end)
    Save.WatchFields("Butterflies", render)
    Tabs.Activated:Connect(function(p16) -- line: 256
        -- upvalues: render (copy)
        if p16 == "ButterflyMachine" then
            render()
        end
    end)
    render()
end

return t3
