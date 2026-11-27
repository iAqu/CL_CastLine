-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local MutationOdds = require(Modules:WaitForChild("MutationOdds"))
local ShopConfig = require(Modules:WaitForChild("ShopConfig"))
local Zones = require(Modules:WaitForChild("Zones"))
local LocalPlayer = Players.LocalPlayer
local ShopGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShopGui")
local t1 = {
    DIM = 0.45,
    TWIST = -16,
    ROW_FIRST = 0.12,
    ROW_STEP = 0.035,
    BURST_LAP = 12,
    DIM_IN = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    POP = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ROW_POP = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    CLOSE = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    UP = Color3.fromRGB(125, 255, 135),
    DOWN = Color3.fromRGB(255, 135, 125),
    ANY = Color3.fromRGB(70, 30, 110),
    GLOW = Color3.fromRGB(235, 235, 255),
    SHADOW_GLOW = Color3.fromRGB(170, 110, 230)
}

local function pct(p1) -- line: 46
    local v1 = (p1 or 0) * 100

    if v1 <= 0 then
        return "0%"
    end

    local v4 = math.max(0, 4 - math.floor((math.log10(v1))))

    for i = 0, v4 do
        local v5 = 10 ^ i

        if math.abs(math.round(v1 * v5) / v5 - v1) < 1E-09 then
            return string.format("%." .. i .. "f%%", v1)
        end
    end

    return string.format("%." .. v4 .. "f%%", v1)
end

local function dark(p2) -- line: 57
    return 0.299 * p2.R + 0.587 * p2.G + 0.114 * p2.B < 0.18
end

local function tint(p3, p4, p5) -- line: 60
    -- upvalues: t1 (copy)
    p3.TextColor3 = p4

    local UIGradient = p3:FindFirstChildOfClass("UIGradient")

    if UIGradient then
        UIGradient.Enabled = false
    end

    local UIStroke = p3:FindFirstChildOfClass("UIStroke")

    if not UIStroke then
        return
    end

    local v8, v9

    if 0.299 * p4.R + 0.587 * p4.G + 0.114 * p4.B < 0.18 then
        v8 = p5 or t1.GLOW
        v9 = false
    elseif p5 then
        v8 = p5
        v9 = false
    else
        v9 = true
    end

    if not v9 then
        UIStroke.Color = v8
    end
end

local function rainbow(p6) -- line: 68
    p6.TextColor3 = Color3.new(1, 1, 1)

    local UIGradient = p6:FindFirstChildOfClass("UIGradient")

    if not UIGradient then
        return
    end

    UIGradient.Enabled = true
    UIGradient.Rotation = 0

    local t2 = {}

    for i = 0, 6 do
        t2[#t2 + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 * 0.85, 0.7, 1))
    end

    UIGradient.Color = ColorSequence.new(t2)
end

local t3 = {}

local function setup(p7) -- line: 80
    -- upvalues: ShopGui (copy), t3 (copy)
    local v10 = ShopGui:WaitForChild(p7)

    v10.Visible = false

    local Card = v10:WaitForChild("Card")
    local List = Card:WaitForChild("List")
    local t4 = {
        root = v10,
        dim = v10:WaitForChild("Dim"),
        card = Card,
        scale = Card:WaitForChild("Scale"),
        ok = Card:WaitForChild("OK"),
        home = Card.Position,
        list = List,
        rowTemplate = List:WaitForChild("RowTemplate"),
        built = {},
        extra = {},
        before = Card:WaitForChild("Before"),
        after = Card:WaitForChild("After")
    }

    t4.rowTemplate.Visible = false

    local Text = t4.before.Text
    local Text2 = t4.after.Text

    t4.beforeWord = Text
    t4.afterWord = Text2

    local UIListLayout = List:WaitForChild("UIListLayout")
    local UIPadding = List:WaitForChild("UIPadding")
    local Scale = UIListLayout.Padding.Scale
    local Scale2 = UIPadding.PaddingTop.Scale

    local function fit() -- line: 93
        -- upvalues: List (copy), UIListLayout (copy), UIPadding (copy), Scale (copy), Scale2 (copy)
        local Y = List.AbsoluteWindowSize.Y

        UIListLayout.Padding = UDim.new(0, Scale * Y)
        UIPadding.PaddingTop = UDim.new(0, Scale2 * Y)
        UIPadding.PaddingBottom = UDim.new(0, Scale2 * Y)
        List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 2 * Scale2 * Y)
    end

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit)
    List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fit)
    t4.fit = fit
    t3[p7] = t4

    return t4
end

local function clearRows(p8) -- line: 106
    for _, v11 in ipairs(p8.built) do
        v11:Destroy()
    end

    table.clear(p8.built)
end

local function addRow(p9, p10, p11, p12, p13, p14) -- line: 111
    -- upvalues: t1 (copy), pct (copy)
    local clone = p9.rowTemplate:Clone()

    clone.Name = "Row" .. p10
    clone.LayoutOrder = p10
    clone.Rarity.Text = p11

    if p14 then
        p14(clone)
    end

    clone.Before.Text = pct(p12)
    clone.After.Text = pct(p13)

    local v12 = (p13 or 0) - (p12 or 0)

    if math.abs(v12) > 1E-12 then
        local After = clone.After
        local UP = v12 > 0 and t1.UP or t1.DOWN

        After.TextColor3 = UP

        local UIGradient = After:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient.Enabled = false
        end

        local UIStroke = After:FindFirstChildOfClass("UIStroke")

        if UIStroke and 0.299 * UP.R + 0.587 * UP.G + 0.114 * UP.B < 0.18 then
            UIStroke.Color = t1.GLOW
        end
    end

    clone.Visible = true
    clone.Parent = p9.list
    p9.built[#p9.built + 1] = clone

    return clone
end

local function markNow(p15, p16) -- line: 127
    p15.before.Text = p15.beforeWord .. (p16 and "" or " (NOW)")
    p15.after.Text = p15.afterWord .. (p16 and " (NOW)" or "")
end

local LuckInfo = setup("LuckInfo")
local Art = LuckInfo.card:WaitForChild("Art")
local Burst = Art:WaitForChild("Burst")

LuckInfo.extra = {
    Art,
    LuckInfo.card:WaitForChild("Sub")
}

local v13 = ShopConfig.PASSES[4]

for _, v14 in ipairs(ShopConfig.PASSES) do
    if v14.perks and v14.perks.luck then
        v13 = v14
    end
end

local v15

function LuckInfo.build() -- line: 142
    -- upvalues: ReplicatedStorage (copy), HttpService (copy), MutationDisplay (copy), MutationOdds (copy), ShopConfig (copy), LocalPlayer (copy), t1 (copy), rainbow (copy), addRow (copy), LuckInfo (copy), v13 (ref)
    local JSONDecode = HttpService.JSONDecode
    local v16 = ReplicatedStorage:GetAttribute("MutationWeights") or ""
    local ok, result = pcall(JSONDecode, HttpService, v16)

    if ok and type(result) == "table" then
        for _, v17 in ipairs(LuckInfo.built) do
            v17:Destroy()
        end

        table.clear(LuckInfo.built)

        local Level = LocalPlayer:GetAttribute("Level")
        local v18 = MutationOdds.Chances(result, Level, 1)
        local v19 = MutationOdds.Chances(result, Level, v13.perks.luck)
        local v20 = 0 + 1

        addRow(LuckInfo, v20, "ANY MUTATION", 1 - (v18.None or 1), 1 - (v19.None or 1)).BackgroundColor3 = t1.ANY

        for _, v21 in ipairs(result) do
            if v21.n ~= "None" then
                v20 += 1

                local v22 = MutationDisplay[v21.n]

                addRow(LuckInfo, v20, v22 and v22.display or string.upper(v21.n), v18[v21.n], v19[v21.n], function(p17) -- line: 157
                    -- upvalues: v21 (copy), v22 (copy), t1 (copy), rainbow (copy)
                    if v22 then
                        if v22.cycle then
                            rainbow(p17.Rarity)
                        else
                            local Rarity = p17.Rarity
                            local v25 = v22.textColor or v22.color
                            local SHADOW_GLOW = v21.n == "Shadow" and t1.SHADOW_GLOW or nil

                            Rarity.TextColor3 = v25

                            local UIGradient = Rarity:FindFirstChildOfClass("UIGradient")

                            if UIGradient then
                                UIGradient.Enabled = false
                            end

                            local UIStroke = Rarity:FindFirstChildOfClass("UIStroke")

                            if UIStroke then
                                local v26, v27

                                if 0.299 * v25.R + 0.587 * v25.G + 0.114 * v25.B < 0.18 then
                                    v26 = SHADOW_GLOW or t1.GLOW
                                    v27 = false
                                elseif SHADOW_GLOW then
                                    v26 = SHADOW_GLOW
                                    v27 = false
                                else
                                    v27 = true
                                end

                                if not v27 then
                                    UIStroke.Color = v26
                                end
                            end
                        end
                    end
                end)
            end
        end

        addRow(LuckInfo, v20 + 1, "NO MUTATION", v18.None, v19.None)

        local v29 = LocalPlayer:GetAttribute(ShopConfig.PassAttr(v13.key)) == true

        LuckInfo.before.Text = LuckInfo.beforeWord .. (v29 and "" or " (NOW)")
        LuckInfo.after.Text = LuckInfo.afterWord .. (v29 and " (NOW)" or "")
        LuckInfo.fit()
    end
end

local ServerOdds = setup("ServerOdds")
local ZoneTemplate = ServerOdds.list:WaitForChild("ZoneTemplate")

ZoneTemplate.Visible = false

local function luckOn() -- line: 173
    return (workspace:GetAttribute("ServerLuckEnd") or 0) > workspace:GetServerTimeNow()
end

function ServerOdds.build() -- line: 176
    -- upvalues: ReplicatedStorage (copy), HttpService (copy), RarityDisplay (copy), Zones (copy), t1 (copy), addRow (copy), ServerOdds (copy), ZoneTemplate (copy)
    local JSONDecode = HttpService.JSONDecode
    local v30 = ReplicatedStorage:GetAttribute("DropOdds") or ""
    local ok, result = pcall(JSONDecode, HttpService, v30)

    if ok and type(result) == "table" then
        for _, v31 in ipairs(ServerOdds.built) do
            v31:Destroy()
        end

        table.clear(ServerOdds.built)

        local n1 = 0

        for v32, v33 in ipairs(result) do
            if type(v33) == "table" and #v33 > 0 then
                n1 += 1

                local clone = ZoneTemplate:Clone()

                clone.Name = "Zone" .. v32
                clone.LayoutOrder = n1
                clone:FindFirstChild("Name").Text = string.upper(Zones.NAMES[v32] or "Zone " .. v32)
                clone:FindFirstChild("Zone").Text = "ZONE " .. v32

                if not clone:FindFirstChild("Pop") then
                    Instance.new("UIScale", clone).Name = "Pop"
                end

                clone.Visible = true
                clone.Parent = ServerOdds.list
                ServerOdds.built[#ServerOdds.built + 1] = clone

                local v34 = n1

                for _, v35 in ipairs(v33) do
                    v34 += 1
                    n1 = v34

                    local v36 = RarityDisplay[v35.r]

                    addRow(ServerOdds, v34, v36 and v36.display or string.upper(v35.r), v35.before, v35.after, function(p18) -- line: 196
                        -- upvalues: v36 (copy), t1 (copy)
                        if not (v36 and v36.color) then
                            return
                        end

                        local Rarity = p18.Rarity
                        local color, glow = v36.color, v36.glow

                        Rarity.TextColor3 = color

                        local UIGradient = Rarity:FindFirstChildOfClass("UIGradient")

                        if UIGradient then
                            UIGradient.Enabled = false
                        end

                        local UIStroke = Rarity:FindFirstChildOfClass("UIStroke")

                        if UIStroke then
                            local v37, v38

                            if 0.299 * color.R + 0.587 * color.G + 0.114 * color.B < 0.18 then
                                v37 = glow or t1.GLOW
                                v38 = false
                            elseif glow then
                                v37 = glow
                                v38 = false
                            else
                                v38 = true
                            end

                            if not v38 then
                                UIStroke.Color = v37
                            end
                        end
                    end)
                end
            end
        end

        local v39 = (workspace:GetAttribute("ServerLuckEnd") or 0) > workspace:GetServerTimeNow()

        ServerOdds.before.Text = ServerOdds.beforeWord .. (v39 and "" or " (NOW)")
        ServerOdds.after.Text = ServerOdds.afterWord .. (v39 and " (NOW)" or "")
        ServerOdds.fit()
    end
end

local MassiveOdds = setup("MassiveOdds")

function MassiveOdds.build() -- line: 209
    -- upvalues: RarityDisplay (copy), ShopConfig (copy), t1 (copy), pct (copy), MassiveOdds (copy)
    for _, v40 in ipairs(MassiveOdds.built) do
        v40:Destroy()
    end

    table.clear(MassiveOdds.built)

    for v41, v42 in ipairs(ShopConfig.MASSIVE_EGG_RARITY) do
        local v43 = RarityDisplay[v42.rarity]
        local clone = MassiveOdds.rowTemplate:Clone()

        clone.Name = "Row" .. v41
        clone.LayoutOrder = v41
        clone.Rarity.Text = v43 and v43.display or string.upper(v42.rarity)

        if v43 and v43.color then
            local Rarity = clone.Rarity
            local color, glow = v43.color, v43.glow

            Rarity.TextColor3 = color

            local UIGradient = Rarity:FindFirstChildOfClass("UIGradient")

            if UIGradient then
                UIGradient.Enabled = false
            end

            local UIStroke = Rarity:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                if 0.299 * color.R + 0.587 * color.G + 0.114 * color.B < 0.18 then
                    UIStroke.Color = glow or t1.GLOW
                elseif glow then
                    UIStroke.Color = glow
                end
            end
        end

        clone.After.Text = pct(v42.odds / 100)
        clone.Visible = true
        clone.Parent = MassiveOdds.list
        MassiveOdds.built[#MassiveOdds.built + 1] = clone
    end

    MassiveOdds.fit()
end

local v44 = nil
local v45 = false
local PadMenu = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PadMenu"))
local t5 = {}

function t5.IsUp() -- line: 232
    -- upvalues: v44 (ref)
    return v44 ~= nil
end

function t5.Show(p19, p20) -- line: 236
    -- upvalues: TweenService (copy), PanelFocus (copy), t1 (copy), t3 (copy), LuckInfo (copy), Burst (copy), v15 (ref), ServerOdds (copy), t5 (copy), v44 (ref), v45 (ref), PadMenu (copy)
    local v46 = t3[p19]

    if not v46 or v44 or v45 then
        return
    else
        v44 = v46
        v45 = true
        v46.build()
        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)

        if p20 then
            local v48 = p20.AbsolutePosition + p20.AbsoluteSize / 2 - v46.root.AbsolutePosition

            v46.card.Position = UDim2.fromScale(v48.X / math.max(1, v46.root.AbsoluteSize.X), v48.Y / math.max(1, v46.root.AbsoluteSize.Y))
        else
            v46.card.Position = v46.home
        end
    end

    v46.card.Rotation = t1.TWIST
    v46.scale.Scale = 0
    v46.dim.BackgroundTransparency = 1

    local t6 = {}

    for _, v50 in ipairs(v46.extra) do
        t6[#t6 + 1] = v50
    end

    for _, v51 in ipairs(v46.built) do
        t6[#t6 + 1] = v51
    end

    for _, v52 in ipairs(t6) do
        local Pop = v52:FindFirstChild("Pop")

        if Pop then
            Pop.Scale = 0
        end
    end

    v46.list.CanvasPosition = Vector2.zero
    v46.root.Visible = true
    TweenService:Create(v46.dim, t1.DIM_IN, {
        BackgroundTransparency = t1.DIM
    }):Play()
    TweenService:Create(v46.card, t1.POP, {
        Rotation = 0,
        Position = v46.home
    }):Play()

    local tween = TweenService:Create(v46.scale, t1.POP, {
        Scale = 1
    })

    tween.Completed:Once(function() -- line: 264
        -- upvalues: v45 (ref)
        v45 = false
    end)
    tween:Play()
    PadMenu.Open(v46.root, function() -- line: 266
        -- upvalues: t5 (copy)
        t5.Hide()
    end, {
        first = v46.ok
    })

    for v53, v54 in ipairs(t6) do
        local Pop = v54:FindFirstChild("Pop")

        if Pop then
            TweenService:Create(Pop, TweenInfo.new(t1.ROW_POP.Time, t1.ROW_POP.EasingStyle, t1.ROW_POP.EasingDirection, 0, false, t1.ROW_FIRST + math.min(v53 - 1, 14) * t1.ROW_STEP), {
                Scale = 1
            }):Play()
        end
    end

    if v46 == ServerOdds then
        task.spawn(function() -- line: 276
            -- upvalues: ServerOdds (copy), v44 (ref)
            while v44 == ServerOdds do
                task.wait(1)

                if v44 == ServerOdds then
                    local v56 = (workspace:GetAttribute("ServerLuckEnd") or 0) > workspace:GetServerTimeNow()

                    ServerOdds.before.Text = ServerOdds.beforeWord .. (v56 and "" or " (NOW)")
                    ServerOdds.after.Text = ServerOdds.afterWord .. (v56 and " (NOW)" or "")
                end
            end
        end)
    end

    if v46 ~= LuckInfo then
        return
    end

    Burst.Rotation = 0
    v15 = TweenService:Create(Burst, TweenInfo.new(t1.BURST_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 360
    })
    v15:Play()
end

function t5.Hide(p21) -- line: 291
    -- upvalues: TweenService (copy), PanelFocus (copy), t1 (copy), v15 (ref), v44 (ref), v45 (ref), PadMenu (copy)
    local v57 = v44

    if v57 then
        local function gone() -- line: 294
            -- upvalues: v57 (copy), v15 (ref), v44 (ref), v45 (ref), PadMenu (copy)
            PadMenu.Close(v57.root)
            v57.root.Visible = false

            if v15 then
                v15:Cancel()
                v15 = nil
            end

            v44 = nil
            v45 = false
        end

        if p21 then
            PadMenu.Close(v57.root)
            v57.root.Visible = false

            if v15 then
                v15:Cancel()
                v15 = nil
            end

            v44 = nil
            v45 = false
        elseif not v45 then
            v45 = true
            PadMenu.Close(v57.root)
            PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
            TweenService:Create(v57.dim, t1.CLOSE, {
                BackgroundTransparency = 1
            }):Play()

            local tween = TweenService:Create(v57.scale, t1.CLOSE, {
                Scale = 0
            })

            tween.Completed:Once(gone)
            tween:Play()
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("Level"):Connect(function() -- line: 314
    -- upvalues: LuckInfo (copy), v44 (ref)
    if v44 == LuckInfo then
        LuckInfo.build()
    end
end)
LocalPlayer:GetAttributeChangedSignal(ShopConfig.PassAttr(v13.key)):Connect(function() -- line: 315
    -- upvalues: LuckInfo (copy), v44 (ref)
    if v44 == LuckInfo then
        LuckInfo.build()
    end
end)
ReplicatedStorage:GetAttributeChangedSignal("MutationWeights"):Connect(function() -- line: 316
    -- upvalues: LuckInfo (copy), v44 (ref)
    if v44 == LuckInfo then
        LuckInfo.build()
    end
end)
ReplicatedStorage:GetAttributeChangedSignal("DropOdds"):Connect(function() -- line: 317
    -- upvalues: ServerOdds (copy), v44 (ref)
    if v44 == ServerOdds then
        ServerOdds.build()
    end
end)
workspace:GetAttributeChangedSignal("ServerLuckEnd"):Connect(function() -- line: 318
    -- upvalues: ServerOdds (copy), v44 (ref)
    if v44 ~= ServerOdds then
        return
    end

    local v58 = (workspace:GetAttribute("ServerLuckEnd") or 0) > workspace:GetServerTimeNow()

    ServerOdds.before.Text = ServerOdds.beforeWord .. (v58 and "" or " (NOW)")
    ServerOdds.after.Text = ServerOdds.afterWord .. (v58 and " (NOW)" or "")
end)

for _, v59 in pairs(t3) do
    ButtonHover.Attach(v59.ok, {
        shine = false,
        tile = 1,
        highlight = true,
        highlightFade = 0.8,
        highlightCorner = 0.25,
        corner = 0.25
    })
    v59.ok.Activated:Connect(function() -- line: 322
        -- upvalues: ButtonHover (copy), t5 (copy), v59 (copy)
        ButtonHover.Press(v59.ok)
        t5.Hide()
    end)
    v59.dim.Active = true
    v59.dim.InputBegan:Connect(function(p22) -- line: 328
        -- upvalues: t5 (copy), v44 (ref), v59 (copy)
        local UserInputType = p22.UserInputType

        if v44 == v59 and (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch) then
            t5.Hide()
        end
    end)
end

return t5
