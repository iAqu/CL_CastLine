-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local Loc = require(Modules:WaitForChild("Loc"))
local ShopConfig = require(Modules:WaitForChild("ShopConfig"))
local SerialOwners = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SerialOwners")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Side = PlayerGui:WaitForChild("IndexGui"):WaitForChild("Panel"):WaitForChild("Side")
local Stats = Side:WaitForChild("Stats")
local Icon = Side:WaitForChild("Icon")
local Record = Stats:WaitForChild("Record")
local OwnersView = Stats:WaitForChild("OwnersView")
local OwnersBack = Side:WaitForChild("OwnersBack")
local Owners = Side:WaitForChild("Owners")
local Template = Owners:WaitForChild("Template")

Template.Visible = false

local t2 = {
    Stats:WaitForChild("CaughtBy"),
    Stats:WaitForChild("RecordHead"),
    Stats:WaitForChild("RecordBy")
}
local t3 = {
    Side:WaitForChild("HowGot"),
    Side:WaitForChild("Copies")
}
local TextXAlignment = Record.TextXAlignment
local t4 = {
    ROW_AR = 7,
    TEXT = 0.6,
    SPARE = 2
}
local t5 = {
    FRESH = 30,
    ROW_FIRST = 0.18,
    ROW_STEP = 0.03,
    MOVE = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    FOLD_OUT = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    FOLD_IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SWAP_OUT = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    SWAP_IN = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ROW_POP = TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}
local Color = Template:WaitForChild("Num"):WaitForChild("UIGradient").Color
local Color2 = Color

local function v1() -- line: 68
    -- upvalues: PlayerGui (copy), Color2 (ref)
    Color2 = PlayerGui:WaitForChild("XPGui", 10).Leaderboards.Main.ListClip.List.Board1.First.Label.UIGradient.Color
end

pcall(v1)

local OwnersViewPosition = OwnersView.Position
local OwnersBackPosition = OwnersBack.Position

local function foldOf(p1) -- line: 74
    local OwnersFold = p1:FindFirstChild("OwnersFold")

    if not OwnersFold then
        OwnersFold = Instance.new("UIScale")
        OwnersFold.Name = "OwnersFold"
        OwnersFold.Parent = p1
    end

    return OwnersFold
end

local OwnersFold = Stats:FindFirstChild("OwnersFold")

if not OwnersFold then
    OwnersFold = Instance.new("UIScale")
    OwnersFold.Name = "OwnersFold"
    OwnersFold.Parent = Stats
end

local OwnersFold2 = Icon:FindFirstChild("OwnersFold")

if not OwnersFold2 then
    OwnersFold2 = Instance.new("UIScale")
    OwnersFold2.Name = "OwnersFold"
    OwnersFold2.Parent = Icon
end

local function serialRow(p2) -- line: 85
    -- upvalues: ShopConfig (copy)
    for _, v2 in ipairs(ShopConfig.LIMITED) do
        if (v2.rotation and (v2.plainProduct or v2.isSerial) or v2.owners) and v2.fish == p2 then
            return v2
        end
    end

    for _, v3 in ipairs(ShopConfig.OWNERS_ONLY) do
        if v3.fish == p2 then
            return v3
        end
    end

    return nil
end

local v4 = true
local t6 = {
    Num = Template.Num.Position,
    Head = Template.Head.Position,
    Player = Template.Player.Position,
    PlayerW = Template.Player.Size
}

function t1.Is(p3) -- line: 98
    -- upvalues: serialRow (copy)
    return serialRow(p3) ~= nil
end

local t7 = {}
local t8 = {}

local function fetch(p4, p5) -- line: 103
    -- upvalues: SerialOwners (copy), t5 (copy), t7 (copy), t8 (copy)
    local v5 = t7[p4]
    local v6 = v5

    if not (v5 and os.clock() - v5.at < t5.FRESH) then
        if v5 then
            p5(v5)
        end

        if not t8[p4] then
            t8[p4] = true
            task.spawn(function() -- line: 109
                -- upvalues: p4 (copy), p5 (copy), v6 (ref), SerialOwners (copy), t7 (copy), t8 (copy)
                local InvokeServer = SerialOwners.InvokeServer
                local ok, result = pcall(InvokeServer, SerialOwners, p4)

                t8[p4] = nil

                if ok and type(result) == "table" then
                    v6 = {
                        at = os.clock(),
                        total = tonumber(result.total) or 0,
                        list = type(result.list) == "table" and result.list or {}
                    }
                    t7[p4] = v6
                    p5(v6)
                end
            end)
        end
    else
        p5(v5)
    end
end

local t10 = {}
local v7 = {}

local function scaleOf(p6) -- line: 122
    -- upvalues: PlayerGui (copy)
    local n1 = 1
    local v8 = p6

    while v8 and v8 ~= PlayerGui do
        local UIScale = v8:FindFirstChildOfClass("UIScale")

        n1 = if UIScale then n1 * UIScale.Scale else n1
        v8 = v8.Parent
    end

    return (math.max(n1, 0.05))
end

local function rowCount() -- line: 131
    -- upvalues: Owners (copy)
    local AbsoluteWindowSize = Owners.AbsoluteWindowSize

    if AbsoluteWindowSize.X <= 0 then
        return 1, 0
    end

    local v9 = AbsoluteWindowSize.X / 7

    return v9, math.ceil(AbsoluteWindowSize.Y / v9) + 2
end

local function headOf(p7) -- line: 137
    return ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(if not (p7 > 0) or not p7 then 1 else p7)
end

local function bind(p8, p9) -- line: 141
    -- upvalues: Color (copy), Color2 (ref), v4 (ref), t6 (copy), v7 (ref)
    if p8:GetAttribute("At") == p9 then
        return
    end

    p8:SetAttribute("At", p9)

    local v11 = v7[p9]
    local v12 = #v7

    if type(v11) ~= "table" then
        p8.Visible = false
        p8:SetAttribute("At", nil)

        return
    end

    p8.Position = UDim2.fromScale(0, (p9 - 1) / v12)
    p8.Size = UDim2.fromScale(1, 1 / v12)
    p8.Num.Text = "#" .. tostring(v11[1])
    p8.Player.Text = v11[3] ~= "" and v11[3] or "?"
    p8.Num.Visible = v4

    local v14 = if v4 then 0 else t6.Head.X.Scale - t6.Num.X.Scale

    p8.Head.Position = UDim2.new(t6.Head.X.Scale - v14, 0, t6.Head.Y.Scale, 0)
    p8.Player.Position = UDim2.new(t6.Player.X.Scale - v14, 0, t6.Player.Y.Scale, 0)
    p8.Player.Size = UDim2.new(t6.PlayerW.X.Scale + v14, 0, t6.PlayerW.Y.Scale, 0)

    local Color3, v15

    if v4 and v11[1] == 1 then
        local Color = Color2

        if Color then
            Color3 = Color
            v15 = true
        else
            v15 = false
        end
    else
        v15 = false
    end

    if not v15 then
        Color3 = Color
    end

    local UIGradient = p8.Num.UIGradient
    local UIGradient2 = p8.Player.UIGradient

    UIGradient.Color = Color3
    UIGradient2.Color = Color3

    local Face = p8.Head.Face
    local v16 = v11[2]
    local v17 = "rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"

    if not (v16 > 0) or not v16 then
        v16 = 1
    end

    Face.Image = v17:format(v16)
    p8.Visible = true
end

local function refresh() -- line: 167
    -- upvalues: Owners (copy), Template (copy), t4 (copy), t10 (copy), v7 (ref), scaleOf (copy), bind (copy)
    local v18 = #v7

    if v18 == 0 then
        for _, v19 in ipairs(t10) do
            v19.Visible = false
        end
    else
        local AbsoluteWindowSize = Owners.AbsoluteWindowSize
        local v20, v21

        if AbsoluteWindowSize.X <= 0 then
            v21 = 1
            v20 = 0
        else
            v21 = AbsoluteWindowSize.X / t4.ROW_AR
            v20 = math.ceil(AbsoluteWindowSize.Y / v21) + t4.SPARE
        end

        while #t10 < math.min(v20, v18) do
            local clone = Template:Clone()

            clone.Name = "Row"

            local Num, Player = clone.Num, clone.Player

            Num.TextScaled = false
            Player.TextScaled = false
            clone.Parent = Owners
            t10[#t10 + 1] = clone
        end

        local v25 = math.max(1, (math.floor(v21 * 0.6 / scaleOf(Owners))))
        local v31 = math.clamp(math.floor(Owners.CanvasPosition.Y / math.max(Owners.AbsoluteCanvasSize.Y / v18, 1)), 0, (math.max(0, v18 - #t10)))

        for v32, v33 in ipairs(t10) do
            local v34 = v31 + v32

            if v34 <= v18 then
                bind(v33, v34)

                local Num, Player = v33.Num, v33.Player

                Num.TextSize = v25
                Player.TextSize = v25
            else
                v33.Visible = false
                v33:SetAttribute("At", nil)
            end
        end
    end
end

local function fitCanvas() -- line: 198
    -- upvalues: Owners (copy), v7 (ref)
    local AbsoluteWindowSize = Owners.AbsoluteWindowSize
    local Y = Owners.Parent.AbsoluteSize.Y

    Owners.CanvasSize = UDim2.fromScale(0, Y > 0 and #v7 * (AbsoluteWindowSize.X / 7) / Y or 0)
end

Owners:GetPropertyChangedSignal("CanvasPosition"):Connect(refresh)
Owners:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 203
    -- upvalues: Owners (copy), t4 (copy), v7 (ref), refresh (copy)
    if Owners.Visible then
        local AbsoluteWindowSize = Owners.AbsoluteWindowSize
        local Y = Owners.Parent.AbsoluteSize.Y

        Owners.CanvasSize = UDim2.fromScale(0, Y > 0 and #v7 * (AbsoluteWindowSize.X / t4.ROW_AR) / Y or 0)
        refresh()
    end
end)

local function fill(p10) -- line: 208
    -- upvalues: Owners (copy), t4 (copy), t10 (copy), v7 (ref), refresh (copy)
    v7 = p10.list

    for _, v37 in ipairs(t10) do
        v37:SetAttribute("At", nil)
    end

    local AbsoluteWindowSize = Owners.AbsoluteWindowSize
    local Y = Owners.Parent.AbsoluteSize.Y

    Owners.CanvasSize = UDim2.fromScale(0, Y > 0 and #v7 * (AbsoluteWindowSize.X / t4.ROW_AR) / Y or 0)
    refresh()
end

local function popRows() -- line: 214
    -- upvalues: TweenService (copy), t5 (copy), t10 (copy)
    for v39, v40 in ipairs(t10) do
        local Pop = v40.Pop

        if v40.Visible then
            Pop.Scale = 0
            TweenService:Create(Pop, TweenInfo.new(t5.ROW_POP.Time, t5.ROW_POP.EasingStyle, t5.ROW_POP.EasingDirection, 0, false, t5.ROW_FIRST + (v39 - 1) * t5.ROW_STEP), {
                Scale = 1
            }):Play()
        else
            Pop.Scale = 1
        end
    end
end

local v41 = nil
local v42 = false
local v43 = false
local HoverScale, HoverScale2

local function setCount(p11, p12) -- line: 231
    -- upvalues: Loc (copy), Record (copy)
    local v44 = p11 and tostring(p11) or "..."
    local v45 = Loc.F("idx.owners", "OWNERS: {n}", {
        n = "\000"
    })
    local v46 = v45:find("\000", 1, true)

    local function r(p13) -- line: 235
        -- upvalues: p12 (copy)
        if p13 == "" then
            return ""
        end

        return "<font color=\"" .. p12 .. "\">" .. p13:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>"
    end

    Record.RichText = true

    local v47, v48

    if v46 then
        local v49 = v45:sub(1, v46 - 1)
        local v50 = if v49 == "" then "" else "<font color=\"" .. p12 .. "\">" .. v49:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>"
        local v51 = v45:sub(v46 + 1)
        local v52 = v50 .. v44 .. (if v51 == "" then "" else "<font color=\"" .. p12 .. "\">" .. v51:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>")

        if v52 then
            v47 = v52
            v48 = true
        else
            v48 = false
        end
    else
        v48 = false
    end

    if not v48 then
        v47 = if v45 == "" then "" else "<font color=\"" .. p12 .. "\">" .. v45:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</font>"
    end

    Record.Text = v47
end

local function expandIn() -- line: 243
    -- upvalues: TweenService (copy), PanelFocus (copy), Side (copy), Stats (copy), Icon (copy), OwnersView (copy), OwnersBack (copy), Owners (copy), t3 (copy), t5 (copy), OwnersBackPosition (copy), OwnersFold (ref), OwnersFold2 (ref), t7 (copy), fill (copy), popRows (copy), v41 (ref), v42 (ref), v43 (ref), HoverScale (ref)
    if v43 or v42 or not v41 then
        return
    end

    local v53 = t7[v41]

    if not v53 or #v53.list == 0 then
        return
    end

    v43 = true
    v42 = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)

    for _, v54 in ipairs(t3) do
        v54:SetAttribute("OwnersWas", v54.Visible)
        v54.Visible = false
    end

    for _, v55 in ipairs({ OwnersFold, OwnersFold2 }) do
        TweenService:Create(v55, t5.FOLD_OUT, {
            Scale = 0
        }):Play()
    end

    task.delay(t5.FOLD_OUT.Time, function() -- line: 255
        -- upvalues: Stats (copy), Icon (copy), v42 (ref)
        if v42 then
            Stats.Visible = false
            Icon.Visible = false
        end
    end)

    local v56 = OwnersView.AbsolutePosition + OwnersView.AbsoluteSize / 2 - Side.AbsolutePosition

    OwnersBack.Position = UDim2.fromScale(v56.X / Side.AbsoluteSize.X, v56.Y / Side.AbsoluteSize.Y)
    HoverScale.Scale = 0
    OwnersBack.Visible = true
    TweenService:Create(HoverScale, t5.SWAP_IN, {
        Scale = 1
    }):Play()
    TweenService:Create(OwnersBack, t5.MOVE, {
        Position = OwnersBackPosition
    }):Play()
    Owners.CanvasPosition = Vector2.zero
    Owners.Visible = true
    fill(v53)
    popRows()
    task.delay(t5.MOVE.Time, function() -- line: 270
        -- upvalues: v42 (ref), v43 (ref)
        if v42 then
            v43 = false
        end
    end)
end

local function expandOut() -- line: 273
    -- upvalues: TweenService (copy), PanelFocus (copy), Stats (copy), Icon (copy), OwnersBack (copy), Owners (copy), t3 (copy), t5 (copy), OwnersFold (ref), OwnersFold2 (ref), v42 (ref), v43 (ref), HoverScale (ref), HoverScale2 (ref)
    if v43 or not v42 then
        return
    end

    v43 = true
    v42 = false
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    Owners.Visible = false
    Stats.Visible = true
    Icon.Visible = true

    for _, v57 in ipairs({ OwnersFold, OwnersFold2 }) do
        v57.Scale = 0
        TweenService:Create(v57, t5.FOLD_IN, {
            Scale = 1
        }):Play()
    end

    for _, v58 in ipairs(t3) do
        v58.Visible = v58:GetAttribute("OwnersWas") == true
    end

    TweenService:Create(HoverScale, t5.SWAP_OUT, {
        Scale = 0
    }):Play()
    task.delay(t5.SWAP_OUT.Time, function() -- line: 287
        -- upvalues: OwnersBack (copy), v42 (ref)
        if not v42 then
            OwnersBack.Visible = false
        end
    end)
    HoverScale2.Scale = 0
    TweenService:Create(HoverScale2, t5.SWAP_IN, {
        Scale = 1
    }):Play()
    task.delay(t5.FOLD_IN.Time, function() -- line: 290
        -- upvalues: v42 (ref), v43 (ref)
        if not v42 then
            v43 = false
        end
    end)
end

function t1.Reset() -- line: 294
    -- upvalues: Stats (copy), Icon (copy), OwnersBack (copy), Owners (copy), t3 (copy), OwnersFold (ref), OwnersFold2 (ref), v42 (ref), v43 (ref), HoverScale (ref), HoverScale2 (ref)
    if v42 then
        for _, v59 in ipairs(t3) do
            local OwnersWas = v59:GetAttribute("OwnersWas")

            if OwnersWas ~= nil then
                v59.Visible = OwnersWas
            end
        end
    end

    for _, v60 in ipairs(t3) do
        v60:SetAttribute("OwnersWas", nil)
    end

    v42 = false
    v43 = false
    Owners.Visible = false
    OwnersBack.Visible = false

    if HoverScale then
        HoverScale.Scale = 1
    end

    if HoverScale2 then
        HoverScale2.Scale = 1
    end

    Stats.Visible = true
    Icon.Visible = true
    OwnersFold.Scale = 1
    OwnersFold2.Scale = 1
end

function t1.Show(p14, p15) -- line: 313
    -- upvalues: t1 (copy), Record (copy), OwnersView (copy), t2 (copy), TextXAlignment (copy), OwnersViewPosition (copy), serialRow (copy), v4 (ref), t7 (copy), fetch (copy), t10 (copy), fill (copy), v41 (ref), v42 (ref), setCount (copy)
    t1.Reset()
    OwnersView.Visible = false
    OwnersView.Position = OwnersViewPosition

    if serialRow(p14) then
        v41 = p14
        v4 = serialRow(p14).owners ~= true

        for _, v61 in ipairs(t10) do
            v61:SetAttribute("At", nil)
        end

        for _, v62 in ipairs(t2) do
            v62.Visible = false
        end

        Record.TextXAlignment = Enum.TextXAlignment.Center

        local v63 = t7[p14]

        setCount(v63 and v63.total, p15)
        OwnersView.Visible = v63 ~= nil and #v63.list > 0
        fetch(p14, function(p16) -- line: 330
            -- upvalues: p14 (copy), p15 (copy), OwnersView (copy), fill (copy), v41 (ref), v42 (ref), setCount (copy)
            if v41 ~= p14 then
                return
            end

            setCount(p16.total, p15)
            OwnersView.Visible = #p16.list > 0

            if v42 then
                fill(p16)
            end
        end)

        return true
    end

    v41 = nil
    Record.TextXAlignment = TextXAlignment

    return false
end

ButtonHover.Attach(OwnersView, {
    shine = false,
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    icon = OwnersView:FindFirstChild("Icon"),
    highlightCorner = OwnersView:GetAttribute("Corner") or 0.3,
    corner = OwnersView:GetAttribute("Corner") or 0.3
})
HoverScale2 = OwnersView:WaitForChild("HoverScale")
OwnersView.Activated:Connect(function() -- line: 342
    -- upvalues: ButtonHover (copy), OwnersView (copy), expandIn (copy)
    ButtonHover.Press(OwnersView)
    expandIn()
end)
ButtonHover.Attach(OwnersBack, {
    shine = false,
    tile = 1
})
HoverScale = OwnersBack:WaitForChild("HoverScale")
OwnersBack.Activated:Connect(expandOut)
Owners.Visible = false
OwnersBack.Visible = false
OwnersView.Visible = false

return t1
