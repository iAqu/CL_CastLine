-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local LocalPlayer = Players.LocalPlayer
local Panel = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GiftGui"):WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Main = Panel:WaitForChild("Main")
local List = Main:WaitForChild("List")
local UIListLayout = List:WaitForChild("UIListLayout")
local UIPadding = List:WaitForChild("UIPadding")
local Template = List:WaitForChild("Template")
local Empty = Main:WaitForChild("Empty")
local Close = Main:WaitForChild("Close")
local t1 = {
    ROW_STAGGER = 0.045,
    ROW_HOVER = 1.025,
    ROW_POP = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ROW_GONE = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
}
local v1 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

Panel.Visible = false
Template.Visible = false

local Scale2 = UIListLayout.Padding.Scale
local Scale3 = UIPadding.PaddingTop.Scale

local function fitCanvas() -- line: 49
    -- upvalues: List (copy), UIListLayout (copy), UIPadding (copy), Scale2 (copy), Scale3 (copy)
    local Y = List.AbsoluteWindowSize.Y

    UIListLayout.Padding = UDim.new(0, Scale2 * Y)
    UIPadding.PaddingTop = UDim.new(0, Scale3 * Y)
    UIPadding.PaddingBottom = UDim.new(0, Scale3 * Y)
    List.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 2 * Scale3 * Y)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fitCanvas)

local t2 = {}
local v3 = false
local v4 = false
local v5, v6
local t3 = {}

local function sortRows() -- line: 65
    -- upvalues: Empty (copy), t3 (copy)
    local t4 = {}

    for v7 in pairs(t3) do
        t4[#t4 + 1] = v7
    end

    table.sort(t4, function(p1, p2) -- line: 68
        return p1.DisplayName:lower() < p2.DisplayName:lower()
    end)

    for v8, v9 in ipairs(t4) do
        t3[v9].LayoutOrder = v8
    end

    Empty.Visible = #t4 == 0
end

local function pick(p3, p4) -- line: 73
    -- upvalues: Players (copy), TweenService (copy), ButtonHover (copy), v3 (ref), v4 (ref), v5 (ref)
    local v10 = true

    if v4 then
    elseif v3 and p3.Parent == Players then
        v4 = true
        ButtonHover.Press(p4.Gift)

        local Pop = p4:FindFirstChild("Pop")

        if Pop then
            TweenService:Create(Pop, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 1.06
            }):Play()
        end

        v10 = false
    end

    if v10 then
        return
    end

    task.delay(0.1, function() -- line: 81
        -- upvalues: p3 (copy), Players (copy), v3 (ref), v4 (ref), v5 (ref)
        v4 = false

        if v3 and v5 and p3.Parent == Players then
            v5(p3)
        end
    end)
end

local function addRow(p5, p6, p7) -- line: 87
    -- upvalues: TweenService (copy), ButtonHover (copy), LocalPlayer (copy), List (copy), Template (copy), t1 (copy), v1 (copy), v2 (copy), v4 (ref), t3 (copy), sortRows (copy), pick (copy)
    if p5 ~= LocalPlayer and not t3[p5] then
        local clone = Template:Clone()

        clone.Name = "Row_" .. p5.UserId

        local DisplayName, Username = clone.DisplayName, clone.Username

        DisplayName.AutoLocalize = false
        Username.AutoLocalize = false
        clone.DisplayName.Text = p5.DisplayName
        clone.Username.Text = "@" .. p5.Name
        clone.Head.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p5.UserId .. "&w=150&h=150"

        local Pop = clone:WaitForChild("Pop")

        Pop.Scale = p6 and 0 or 1
        clone.Visible = true
        clone.Parent = List
        t3[p5] = clone
        ButtonHover.Attach(clone.Gift, {
            tile = 1,
            iconTilt = -20,
            highlight = true,
            highlightCorner = 0.3,
            highlightFade = 0.75,
            icon = clone.Gift:FindFirstChild("Icon")
        })
        clone.MouseEnter:Connect(function() -- line: 102
            -- upvalues: Pop (copy), TweenService (copy), t1 (copy), v1 (copy), v4 (ref)
            if not v4 then
                TweenService:Create(Pop, v1, {
                    Scale = t1.ROW_HOVER
                }):Play()
            end
        end)
        clone.MouseLeave:Connect(function() -- line: 105
            -- upvalues: Pop (copy), TweenService (copy), v2 (copy), v4 (ref)
            if not v4 then
                TweenService:Create(Pop, v2, {
                    Scale = 1
                }):Play()
            end
        end)
        clone.Activated:Connect(function() -- line: 108
            -- upvalues: p5 (copy), clone (copy), pick (copy)
            pick(p5, clone)
        end)
        clone.Gift.Activated:Connect(function() -- line: 109
            -- upvalues: p5 (copy), clone (copy), pick (copy)
            pick(p5, clone)
        end)
        sortRows()

        if p6 then
            task.delay(p7 or 0, function() -- line: 112
                -- upvalues: p5 (copy), clone (copy), Pop (copy), TweenService (copy), t1 (copy), t3 (copy)
                if t3[p5] == clone then
                    TweenService:Create(Pop, t1.ROW_POP, {
                        Scale = 1
                    }):Play()
                end
            end)
        end
    end
end

local function removeRow(p8) -- line: 118
    -- upvalues: TweenService (copy), t1 (copy), v3 (ref), t3 (copy), sortRows (copy)
    local v12 = t3[p8]

    if not v12 then
        return
    end

    t3[p8] = nil
    sortRows()

    local Pop = v12:FindFirstChild("Pop")

    if not (Pop and v3) then
        v12:Destroy()
    else
        local tween = TweenService:Create(Pop, t1.ROW_GONE, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 126
            -- upvalues: v12 (copy)
            v12:Destroy()
        end)
        tween:Play()
    end
end

function t2.IsOpen() -- line: 133
    -- upvalues: v3 (ref)
    return v3
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))

function t2.Open(p9, p10) -- line: 140
    -- upvalues: Players (copy), TweenService (copy), PanelFocus (copy), LocalPlayer (copy), Panel (copy), Scale (copy), List (copy), Close (copy), t1 (copy), fitCanvas (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), t3 (copy), sortRows (copy), addRow (copy), removeRow (copy), PadMenu (copy)
    if v3 then
        return
    end

    for v13 in pairs(t3) do
        removeRow(v13)
    end

    v3 = true
    v4 = false
    v5 = p9
    v6 = p10

    local t5 = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            t5[#t5 + 1] = player
        end
    end

    table.sort(t5, function(p11, p12) -- line: 150
        return p11.DisplayName:lower() < p12.DisplayName:lower()
    end)

    for v14, v15 in ipairs(t5) do
        addRow(v15, true, PanelFocus.FEEL.OPEN_TIME * 0.45 + (v14 - 1) * t1.ROW_STAGGER)
    end

    sortRows()
    List.CanvasPosition = Vector2.zero
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    Scale.Scale = PanelFocus.FEEL.FROM
    Panel.Visible = true
    fitCanvas()
    TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    }):Play()
    PadMenu.Open(Panel, function() -- line: 160
        -- upvalues: v3 (ref), v6 (ref)
        if v3 and v6 then
            v6()
        end
    end, {
        closeButton = Close
    })
end

function t2.Close(p13) -- line: 164
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), v3 (ref), v5 (ref), v6 (ref), PadMenu (copy)
    if not v3 then
        return
    end

    v3 = false
    PadMenu.Close(Panel)
    v5 = nil
    v6 = nil

    if p13 then
        Panel.Visible = false
    else
        local tween = TweenService:Create(Scale, PanelFocus.popOut, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 174
            -- upvalues: Panel (copy), v3 (ref)
            if not v3 then
                Panel.Visible = false
            end
        end)
        tween:Play()
    end
end

Close.Activated:Connect(function() -- line: 180
    -- upvalues: v3 (ref), v6 (ref)
    if v3 and v6 then
        v6()
    end
end)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
Players.PlayerAdded:Connect(function(p14) -- line: 185
    -- upvalues: v3 (ref), addRow (copy)
    if v3 then
        addRow(p14, true, 0)
    end
end)
Players.PlayerRemoving:Connect(removeRow)

return t2
