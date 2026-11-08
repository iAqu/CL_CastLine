-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local ViewportSize = require(ReplicatedStorage.Client.ViewportSize)
local HoverCard = ReplicatedStorage.Assets.UI.Misc.HoverCard
local Card, Rows = HoverCard.Card, HoverCard.Rows
local RarityGradients = ReplicatedStorage.Assets.UI.RarityGradients
local Rarities = Rarity.Rarities
local t1 = {
    ClipToDeviceSafeArea = false,
    DisplayOrder = 16384,
    Name = "HoverCardLayer",
    ResetOnSpawn = false,
    ScreenInsets = Enum.ScreenInsets.None,
    ZIndexBehavior = Enum.ZIndexBehavior.Global
}
local v1 = Color3.new(1, 1, 1)
local t2 = {
    body = "Body",
    heading = "Heading",
    rule = "Rule",
    tier = "Tier"
}
local t3 = {
    body = 190,
    heading = 240,
    tier = 280
}
local t4 = {}
local v2, t5

local function child(p1, p2) -- line: 89
    local v3 = p1:FindFirstChild(p2)

    assert(v3, (("%* is missing %*"):format(p1:GetFullName(), p2)))

    return v3
end

local function layer() -- line: 95
    -- upvalues: Players (copy), t1 (copy), v2 (ref)
    local v5 = v2

    if v5 then
        return v5
    end

    local ScreenGui = Instance.new("ScreenGui")

    for v6, v7 in t1 do
        ScreenGui[v6] = v7
    end

    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    v2 = ScreenGui

    return ScreenGui
end

local function origin() -- line: 111
    -- upvalues: Players (copy), t1 (copy), v2 (ref)
    local v8 = v2

    if not v8 then
        v8 = Instance.new("ScreenGui")

        for v9, v10 in t1 do
            v8[v9] = v10
        end

        v8.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v8
    end

    return v8.AbsolutePosition
end

local function room() -- line: 115
    -- upvalues: Players (copy), Workspace (copy), t1 (copy), v2 (ref)
    local v11 = v2

    if not v11 then
        v11 = Instance.new("ScreenGui")

        for v12, v13 in t1 do
            v11[v12] = v13
        end

        v11.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v11
    end

    local AbsoluteSize = v11.AbsoluteSize

    if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
        return AbsoluteSize
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.ViewportSize
    end

    return Vector2.one
end

local function rectOf(p3) -- line: 124
    -- upvalues: Players (copy), t1 (copy), v2 (ref)
    local AbsolutePosition = p3.AbsolutePosition
    local v14 = v2

    if not v14 then
        v14 = Instance.new("ScreenGui")

        for v15, v16 in t1 do
            v14[v15] = v16
        end

        v14.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v14
    end

    return {
        origin = AbsolutePosition - v14.AbsolutePosition,
        size = p3.AbsoluteSize
    }
end

local function pointer() -- line: 128
    -- upvalues: Players (copy), UserInputService (copy), t1 (copy), v2 (ref)
    local MouseLocation = UserInputService:GetMouseLocation()
    local v17 = v2

    if not v17 then
        v17 = Instance.new("ScreenGui")

        for v18, v19 in t1 do
            v17[v18] = v19
        end

        v17.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v17
    end

    return MouseLocation - v17.AbsolutePosition
end

local function contains(p4, p5) -- line: 132
    local v20 = p5 - p4.origin

    if v20.X >= 0 and v20.Y >= 0 and v20.X <= p4.size.X then
        return v20.Y <= p4.size.Y
    end

    return false
end

local function overlaps(p6, p7) -- line: 137
    if p6.origin.X < p7.origin.X + p7.size.X and p7.origin.X < p6.origin.X + p6.size.X and p6.origin.Y < p7.origin.Y + p7.size.Y then
        return p7.origin.Y < p6.origin.Y + p6.size.Y
    end

    return false
end

local function fitInside(p8, p9, p10) -- line: 144
    local v21 = (p10 - p9):Max(Vector2.zero)

    return p8:Max(Vector2.zero):Min(v21)
end

local function sideFacingCentre(p11) -- line: 151
    -- upvalues: Players (copy), Workspace (copy), t1 (copy), v2 (ref)
    local v22 = v2

    if not v22 then
        v22 = Instance.new("ScreenGui")

        for v23, v24 in t1 do
            v22[v23] = v24
        end

        v22.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v22
    end

    local AbsoluteSize = v22.AbsoluteSize

    if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
        local CurrentCamera = Workspace.CurrentCamera

        AbsoluteSize = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one
    end

    return Vector2.new(if p11.X <= AbsoluteSize.X / 2 then 1 else -1, if p11.Y <= AbsoluteSize.Y / 2 then 1 else -1)
end

local function settle(p12, p13, p14) -- line: 156
    -- upvalues: Players (copy), Workspace (copy), t1 (copy), v2 (ref)
    local v25 = v2

    if not v25 then
        v25 = Instance.new("ScreenGui")

        for v26, v27 in t1 do
            v25[v26] = v27
        end

        v25.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v25
    end

    local AbsoluteSize = v25.AbsoluteSize

    if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
        local CurrentCamera = Workspace.CurrentCamera

        AbsoluteSize = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one
    end

    local v28 = (AbsoluteSize - p14):Max(Vector2.zero)
    local v29 = p13:Max(Vector2.zero):Min(v28)

    p12.AnchorPoint = Vector2.zero
    p12.Position = UDim2.fromOffset(v29.X, v29.Y)
end

local function placeAtPointer(p15, p16, p17) -- line: 162
    -- upvalues: Players (copy), Workspace (copy), t1 (copy), v2 (ref)
    local side, clearance, card = p15.side, p15.clearance, p15.card
    local v30 = Vector2.new(if side.X > 0 then p16.X + clearance else p16.X - clearance - p17.X, if side.Y > 0 then p16.Y + clearance else p16.Y - clearance - p17.Y)
    local v31 = v2

    if not v31 then
        v31 = Instance.new("ScreenGui")

        for v32, v33 in t1 do
            v31[v32] = v33
        end

        v31.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v31
    end

    local AbsoluteSize = v31.AbsoluteSize

    if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
        local CurrentCamera = Workspace.CurrentCamera

        AbsoluteSize = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one
    end

    local v34 = (AbsoluteSize - p17):Max(Vector2.zero)
    local v35 = v30:Max(Vector2.zero):Min(v34)

    card.AnchorPoint = Vector2.zero
    card.Position = UDim2.fromOffset(v35.X, v35.Y)
end

local function hintsFrameFor(p18) -- line: 170
    local ScreenGui = p18:FindFirstAncestorOfClass("ScreenGui")
    local Parent = p18.Parent
    local GamepadHintsFrame

    while true do
        if Parent == nil or Parent == ScreenGui then
            return nil
        end

        GamepadHintsFrame = Parent:FindFirstChild("GamepadHintsFrame")

        if GamepadHintsFrame and GamepadHintsFrame:IsA("GuiObject") and GamepadHintsFrame.Visible then
            break
        end

        Parent = Parent.Parent
    end

    return GamepadHintsFrame
end

local function placeBeside(p19, p20) -- line: 183
    -- upvalues: Players (copy), Workspace (copy), t1 (copy), v2 (ref), overlaps (copy), hintsFrameFor (copy)
    local side, clearance, source = p19.side, p19.clearance, p19.source
    local AbsolutePosition = source.AbsolutePosition
    local v36 = v2

    if not v36 then
        v36 = Instance.new("ScreenGui")

        for v37, v38 in t1 do
            v36[v37] = v38
        end

        v36.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v36
    end

    local t7 = {
        origin = AbsolutePosition - v36.AbsolutePosition,
        size = source.AbsoluteSize
    }
    local v39 = v2

    if not v39 then
        v39 = Instance.new("ScreenGui")

        for v40, v41 in t1 do
            v39[v40] = v41
        end

        v39.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v39
    end

    local AbsoluteSize = v39.AbsoluteSize

    if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
        local CurrentCamera = Workspace.CurrentCamera

        AbsoluteSize = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one
    end

    local v42 = t7.origin + (t7.size - p20) / 2
    local v43 = t7.origin.Y + t7.size.Y + clearance
    local v44 = t7.origin.Y - clearance - p20.Y
    local v45 = t7.origin.X + t7.size.X + clearance
    local v46 = t7.origin.X - clearance - p20.X
    local v47 = Vector2.new(v42.X, if side.Y > 0 then v43 else v44)
    local v48 = Vector2.new(v42.X, if not (side.Y > 0) then v43 else v44)
    local v49 = Vector2.new(if side.X > 0 then v45 else v46, v42.Y)
    local new2 = Vector2.new

    if not (side.X > 0) then
        v46 = v45
    end

    local t8 = {
        v47,
        v48,
        v49,
        new2(v46, v42.Y)
    }
    local v50 = hintsFrameFor(p19.source)
    local t9

    if v50 then
        t9 = {}

        local AbsolutePosition = v50.AbsolutePosition
        local v51 = v2

        if not v51 then
            v51 = Instance.new("ScreenGui")

            for v52, v53 in t1 do
                v51[v52] = v53
            end

            v51.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            v2 = v51
        end

        t9.origin = AbsolutePosition - v51.AbsolutePosition
        t9.size = v50.AbsoluteSize
    end

    for _, v54 in t8 do
        local v55 = (AbsoluteSize - p20):Max(Vector2.zero)
        local v56 = v54 == v54:Max(Vector2.zero):Min(v55)
        local v57 = t9 == nil or not overlaps({
            origin = v54,
            size = p20
        }, t9)

        if v56 and v57 then
            local card = p19.card
            local v58 = v2

            if not v58 then
                v58 = Instance.new("ScreenGui")

                for v59, v60 in t1 do
                    v58[v59] = v60
                end

                v58.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
                v2 = v58
            end

            local AbsoluteSize = v58.AbsoluteSize

            if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
                local CurrentCamera = Workspace.CurrentCamera

                AbsoluteSize = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one
            end

            local v61 = (AbsoluteSize - p20):Max(Vector2.zero)
            local v62 = v54:Max(Vector2.zero):Min(v61)

            card.AnchorPoint = Vector2.zero
            card.Position = UDim2.fromOffset(v62.X, v62.Y)

            return
        end
    end

    local card = p19.card
    local v63 = t8[1]
    local v64 = v2

    if not v64 then
        v64 = Instance.new("ScreenGui")

        for v65, v66 in t1 do
            v64[v65] = v66
        end

        v64.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v64
    end

    local AbsoluteSize2 = v64.AbsoluteSize

    if not (AbsoluteSize2.X > 0 and AbsoluteSize2.Y > 0) then
        local CurrentCamera = Workspace.CurrentCamera

        AbsoluteSize2 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one
    end

    local v67 = (AbsoluteSize2 - p20):Max(Vector2.zero)
    local v68 = v63:Max(Vector2.zero):Min(v67)

    card.AnchorPoint = Vector2.zero
    card.Position = UDim2.fromOffset(v68.X, v68.Y)
end

local function stripMarkup(p21) -- line: 214
    return (string.gsub(p21, "<[^<>]*>", ""))
end

local function looksMarkedUp(p22) -- line: 218
    return string.find(p22, "<%a[^<>]*>") ~= nil
end

local function measure(p23, p24, p25) -- line: 222
    -- upvalues: TextService (copy)
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

    GetTextBoundsParams.Font = p23.FontFace
    GetTextBoundsParams.Size = p23.TextSize
    GetTextBoundsParams.Text = string.gsub(p24, "<[^<>]*>", "")
    GetTextBoundsParams.Width = p25

    local function v69() -- line: 228
        -- upvalues: GetTextBoundsParams (copy), TextService (copy)
        return TextService:GetTextBoundsAsync(GetTextBoundsParams)
    end

    local ok, result = pcall(v69)

    if not ok or typeof(result) ~= "Vector2" then
        return Vector2.new(p25, p23.TextSize)
    end

    return result
end

local function cardScale() -- line: 237
    -- upvalues: ViewportSize (copy)
    return (math.sqrt((math.min(ViewportSize.ReadScale(), 1))))
end

local function labelInset(p26) -- line: 241
    local UIStroke = p26:FindFirstChildOfClass("UIStroke")
    local v72 = if UIStroke then UIStroke.Thickness else 0
    local v74 = math.round(p26.TextSize / 4)

    return Vector2.new(v74, 0) * 2 + Vector2.one * (v72 * 2)
end

local function paintGradient(p27, p28) -- line: 250
    local UIGradient = p27:FindFirstChildOfClass("UIGradient")

    if UIGradient ~= nil then
        UIGradient.Color = p28.Color
        UIGradient.Enabled = p28.Enabled
        UIGradient.Offset = p28.Offset
        UIGradient.Rotation = p28.Rotation
        UIGradient.Transparency = p28.Transparency
    else
        p28:Clone().Parent = p27
    end
end

local function gradientNamed(p29) -- line: 263
    -- upvalues: RarityGradients (copy)
    if type(p29) ~= "string" then
        return nil
    end

    local v75 = RarityGradients:FindFirstChild(p29)

    return if v75 and v75:IsA("UIGradient") then v75 else nil
end

local function styleText(p30, p31) -- line: 271
    -- upvalues: RarityGradients (copy), v1 (copy)
    local v77 = tostring(p31.text or "")

    p30.RichText = string.find(v77, "<%a[^<>]*>") ~= nil
    p30.Text = v77

    if typeof(p31.tint) == "Color3" then
        p30.TextColor3 = p31.tint
    end

    local gradient = p31.gradient
    local v78

    if type(gradient) == "string" then
        v78 = RarityGradients:FindFirstChild(gradient)

        if not (v78 and v78:IsA("UIGradient")) then
            v78 = nil
        end
    end

    if v78 then
        p30.TextColor3 = v1

        local UIGradient = p30:FindFirstChildOfClass("UIGradient")

        if UIGradient == nil then
            v78:Clone().Parent = p30

            return v77
        end

        UIGradient.Color = v78.Color
        UIGradient.Enabled = v78.Enabled
        UIGradient.Offset = v78.Offset
        UIGradient.Rotation = v78.Rotation
        UIGradient.Transparency = v78.Transparency
    end

    return v77
end

local function rarityConfig(p32) -- line: 286
    -- upvalues: Rarities (copy)
    local v79 = if type(p32) == "table" then p32 else Rarities[p32]

    assert(v79, (("Unknown rarity: %*"):format((tostring(p32)))))

    return v79
end

local t10 = {
    body = styleText,
    heading = styleText,
    tier = function(p33, p34) -- styleTier | line: 292
        -- upvalues: Rarities (copy)
        local rarity = p34.rarity
        local v81 = if type(rarity) == "table" then rarity else Rarities[rarity]

        assert(v81, (("Unknown rarity: %*"):format((tostring(rarity)))))
        p33.Text = v81.DisplayName

        local RarityGradient = v81.RarityGradient
        local UIGradient = p33:FindFirstChildOfClass("UIGradient")

        if UIGradient ~= nil then
            UIGradient.Color = RarityGradient.Color
            UIGradient.Enabled = RarityGradient.Enabled
            UIGradient.Offset = RarityGradient.Offset
            UIGradient.Rotation = RarityGradient.Rotation
            UIGradient.Transparency = RarityGradient.Transparency
        else
            RarityGradient:Clone().Parent = p33
        end

        local UIStroke = p33:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            local RarityGradient = v81.RarityGradient
            local UIGradient = UIStroke:FindFirstChildOfClass("UIGradient")

            if UIGradient ~= nil then
                UIGradient.Color = RarityGradient.Color
                UIGradient.Enabled = RarityGradient.Enabled
                UIGradient.Offset = RarityGradient.Offset
                UIGradient.Rotation = RarityGradient.Rotation
                UIGradient.Transparency = RarityGradient.Transparency
            else
                RarityGradient:Clone().Parent = UIStroke
            end
        end

        return v81.DisplayName
    end
}

local function buildBlock(p35, p36) -- line: 309
    -- upvalues: Rows (copy), t2 (copy), t3 (copy), measure (copy), t10 (copy)
    local v83 = tostring(p35.kind)
    local v84 = t2[v83]

    assert(v84 ~= nil, (("Unknown hover card row kind: %*"):format(v83)))

    local v87 = Rows:FindFirstChild(v84)

    assert(v87 and v87:IsA("GuiObject"), (("Missing hover card row template: %*"):format(v84)))

    local clone = v87:Clone()

    clone.LayoutOrder = p36

    local v90 = t10[v83]

    if v90 == nil then
        return {
            width = 72,
            frame = clone,
            height = clone.Size.Y.Offset
        }
    end

    local title = clone:FindFirstChild("title")

    assert(title and title:IsA("TextLabel"), (("Hover card row template %* needs a title label"):format(v84)))

    local v93 = v90(title, p35)
    local v94 = t3[v83]
    local v95 = measure(title, v93, v94)
    local UIStroke = title:FindFirstChildOfClass("UIStroke")
    local v96 = if UIStroke then UIStroke.Thickness else 0
    local v98 = math.round(title.TextSize / 4)
    local v99 = v95 + (Vector2.new(v98, 0) * 2 + Vector2.one * (v96 * 2))
    local v101 = math.max(math.ceil(v99.Y), title.TextSize)

    clone.Size = UDim2.new(1, 0, 0, v101)

    return {
        frame = clone,
        height = v101,
        width = math.clamp(math.ceil(v99.X), 72, v94)
    }
end

local function follow(p37, p38) -- line: 339
    -- upvalues: Players (copy), UserInputService (copy), GamepadBindings (copy), t1 (copy), t4 (copy), v2 (ref), placeAtPointer (copy), placeBeside (copy)
    local source = p37.source

    if not GamepadBindings.IsOnScreen(source) then
        t4.Dismiss()

        return
    end

    local v103 = p38 or p37.card.AbsoluteSize

    if v103.X <= 0 or v103.Y <= 0 then
        v103 = p37.footprint
    end

    if p37.viaSelection then
        placeBeside(p37, v103)
    else
        local MouseLocation = UserInputService:GetMouseLocation()
        local v104 = v2

        if not v104 then
            v104 = Instance.new("ScreenGui")

            for v105, v106 in t1 do
                v104[v105] = v106
            end

            v104.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            v2 = v104
        end

        placeAtPointer(p37, MouseLocation - v104.AbsolutePosition, v103)
    end
end

local function stillHovered(p39) -- line: 356
    -- upvalues: GuiService (copy), Players (copy), UserInputService (copy), t1 (copy), v2 (ref)
    if p39.viaSelection then
        return GuiService.SelectedObject == p39.source
    end

    local source = p39.source
    local AbsolutePosition = source.AbsolutePosition
    local v107 = v2

    if not v107 then
        v107 = Instance.new("ScreenGui")

        for v108, v109 in t1 do
            v107[v108] = v109
        end

        v107.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v107
    end

    local t12 = {
        origin = AbsolutePosition - v107.AbsolutePosition,
        size = source.AbsoluteSize
    }
    local MouseLocation = UserInputService:GetMouseLocation()
    local v110 = v2

    if not v110 then
        v110 = Instance.new("ScreenGui")

        for v111, v112 in t1 do
            v110[v111] = v112
        end

        v110.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v110
    end

    local v113 = MouseLocation - v110.AbsolutePosition - t12.origin

    if v113.X >= 0 and v113.Y >= 0 and v113.X <= t12.size.X then
        return v113.Y <= t12.size.Y
    end

    return false
end

local function dismissWhenLeft(p40) -- line: 363
    -- upvalues: GuiService (copy), t4 (copy)
    local source, links = p40.source, p40.links

    links:Connect(if p40.viaSelection then source.SelectionLost else source.MouseLeave, t4.Dismiss)
    links:Connect(source.Destroying, t4.Dismiss)

    if p40.viaSelection then
        links:Connect(GuiService:GetPropertyChangedSignal("SelectedObject"), function() -- line: 370
            -- upvalues: source (copy), GuiService (copy), t4 (copy)
            if GuiService.SelectedObject ~= source then
                t4.Dismiss()
            end
        end)
    end
end

local function present(p41, p42, p43) -- line: 378
    -- upvalues: GuiService (copy), Players (copy), RunService (copy), UserInputService (copy), Workspace (copy), Audio (copy), Trove (copy), ViewportSize (copy), Card (copy), t1 (copy), t4 (copy), v2 (ref), t5 (ref), buildBlock (copy), follow (copy), dismissWhenLeft (copy)
    t4.Dismiss()

    if #p42 == 0 then
        return
    end

    local clone = Card:Clone()

    clone.Visible = false

    local Frame = clone:FindFirstChild("Frame")

    assert(Frame, (("%* is missing Frame"):format((clone:GetFullName()))))

    local Rows = Frame:FindFirstChild("Rows")

    assert(Rows, (("%* is missing Rows"):format((Frame:GetFullName()))))

    local v116 = assert(Rows:FindFirstChildOfClass("UIListLayout"), "Hover card template needs a UIListLayout under Rows")
    local v117 = assert(Rows:FindFirstChildOfClass("UIPadding"), "Hover card template needs a UIPadding under Rows")
    local t13 = {
        clearance = 12,
        card = clone,
        footprint = Vector2.zero,
        links = Trove.new(),
        side = Vector2.one,
        source = p41,
        viaSelection = if p43 == nil then GuiService.SelectedObject == p41 else p43
    }

    t5 = t13
    t13.links:Add(clone)
    dismissWhenLeft(t13)

    local v119 = 72
    local v120 = v116.Padding.Offset * (#p42 - 1)

    for v121, v122 in p42 do
        local v123 = buildBlock(v122, v121)

        if t5 ~= t13 then
            return
        end

        v119 = math.max(v119, v123.width)
        v120 += v123.height
        v123.frame.Parent = Rows
    end

    local v124 = v2

    if not v124 then
        v124 = Instance.new("ScreenGui")

        for v125, v126 in t1 do
            v124[v125] = v126
        end

        v124.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v124
    end

    clone.Parent = v124
    task.wait()

    if t5 ~= t13 then
        return
    end

    local AbsoluteContentSize = v116.AbsoluteContentSize
    local v127 = v119 + v117.PaddingLeft.Offset + v117.PaddingRight.Offset

    if AbsoluteContentSize.Y > 0 then
        v120 = AbsoluteContentSize.Y
    end

    local v128 = v120 + v117.PaddingTop.Offset + v117.PaddingBottom.Offset
    local v131 = math.sqrt((math.min(ViewportSize.ReadScale(), 1)))
    local UIScale = clone:FindFirstChild("UIScale")

    assert(UIScale, (("%* is missing UIScale"):format((clone:GetFullName()))))
    UIScale.Scale = v131
    clone.Size = UDim2.fromOffset(v127, v128)
    t13.clearance = v131 * 12
    t13.footprint = Vector2.new(v127, v128) * v131

    local t14

    if t13.viaSelection then
        t14 = {}

        local AbsolutePosition = p41.AbsolutePosition
        local v133 = v2

        if not v133 then
            v133 = Instance.new("ScreenGui")

            for v134, v135 in t1 do
                v133[v134] = v135
            end

            v133.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            v2 = v133
        end

        t14.origin = AbsolutePosition - v133.AbsolutePosition
        t14.size = p41.AbsoluteSize
    end

    local v136

    if t14 then
        v136 = t14.origin + t14.size / 2
    else
        local MouseLocation = UserInputService:GetMouseLocation()
        local v137 = v2

        if not v137 then
            v137 = Instance.new("ScreenGui")

            for v138, v139 in t1 do
                v137[v138] = v139
            end

            v137.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            v2 = v137
        end

        v136 = MouseLocation - v137.AbsolutePosition
    end

    local v140 = v2

    if not v140 then
        v140 = Instance.new("ScreenGui")

        for v141, v142 in t1 do
            v140[v141] = v142
        end

        v140.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        v2 = v140
    end

    local AbsoluteSize = v140.AbsoluteSize

    if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
        local CurrentCamera = Workspace.CurrentCamera

        AbsoluteSize = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.one
    end

    t13.side = Vector2.new(v136.X <= AbsoluteSize.X / 2 and 1 or -1, v136.Y <= AbsoluteSize.Y / 2 and 1 or -1)

    local v144

    if t13.viaSelection then
        v144 = GuiService.SelectedObject == t13.source
    else
        local source = t13.source
        local AbsolutePosition = source.AbsolutePosition
        local v145 = v2

        if not v145 then
            v145 = Instance.new("ScreenGui")

            for v146, v147 in t1 do
                v145[v146] = v147
            end

            v145.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            v2 = v145
        end

        local t15 = {
            origin = AbsolutePosition - v145.AbsolutePosition,
            size = source.AbsoluteSize
        }
        local MouseLocation = UserInputService:GetMouseLocation()
        local v148 = v2

        if not v148 then
            v148 = Instance.new("ScreenGui")

            for v149, v150 in t1 do
                v148[v149] = v150
            end

            v148.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            v2 = v148
        end

        local v151 = MouseLocation - v148.AbsolutePosition - t15.origin

        v144 = v151.X >= 0 and v151.Y >= 0 and v151.X <= t15.size.X and v151.Y <= t15.size.Y
    end

    if not v144 then
        t4.Dismiss()

        return
    end

    Audio.Play("rbxassetid://89944486811970", script, {
        Volume = 0.3
    })
    follow(t13, t13.footprint)

    if t5 == t13 then
        clone.Visible = true
        t13.links:Connect(RunService.RenderStepped, function() -- line: 444
            -- upvalues: t13 (copy), follow (copy)
            follow(t13)
        end)
    end
end

function t4.Show(p44, p45) -- line: 451
    -- upvalues: present (copy)
    present(p44, p45, nil)
end

function t4.Attach(p46, p47) -- line: 458
    -- upvalues: Trove (copy), t4 (copy), t5 (ref), present (copy)
    local function reveal(p48) -- line: 459
        -- upvalues: p46 (copy), p47 (copy), present (copy)
        local v152 = if type(p47) == "function" then p47() else p47

        if v152 then
            present(p46, v152, p48)
        end
    end

    local v153 = Trove.new()

    v153:Connect(p46.MouseEnter, function() -- line: 467
        -- upvalues: p46 (copy), p47 (copy), present (copy)
        local v154 = if type(p47) == "function" then p47() else p47

        if v154 then
            present(p46, v154, false)
        end
    end)
    v153:Connect(p46.SelectionGained, function() -- line: 470
        -- upvalues: p46 (copy), p47 (copy), present (copy)
        local v155 = if type(p47) == "function" then p47() else p47

        if v155 then
            present(p46, v155, true)
        end
    end)
    v153:Add(function() -- line: 473
        -- upvalues: p46 (copy), t4 (copy), t5 (ref)
        local t16 = t5

        if t16 and t16.source == p46 then
            t4.Dismiss()
        end
    end)

    return function() -- line: 480
        -- upvalues: v153 (copy)
        v153:Destroy()
    end
end

function t4.Dismiss() -- line: 485
    -- upvalues: t5 (ref)
    local t17 = t5

    if t17 ~= nil then
        t5 = nil
        t17.links:Destroy()
    end
end

Tabs.Deactivated:Connect(function() -- line: 494
    -- upvalues: t4 (copy)
    t4.Dismiss()
end)

return t4
