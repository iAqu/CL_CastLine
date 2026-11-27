-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local ScreenGui, v1, v2, From
local n1 = 0

local function hide() -- line: 22
    -- upvalues: UIUtil (copy), v1 (ref), From (ref)
    From = nil

    if v1.Visible then
        UIUtil.tween(v1, 0.2, {
            Position = UDim2.new(0.5, 0, 0, -200)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.2, function() -- line: 26
            -- upvalues: v1 (ref), From (ref)
            if From == nil then
                v1.Visible = false
            end
        end)
    end
end

local function answer(p1) -- line: 34
    -- upvalues: Remotes (copy), From (ref), hide (copy)
    if From then
        local Trade = Remotes.Trade

        Trade:FireServer("Respond", From, p1)
    end

    hide()
end

local function build() -- line: 41
    -- upvalues: Remotes (copy), UIUtil (copy), Kit (copy), Style (copy), LocalPlayer (copy), ScreenGui (ref), v1 (ref), v2 (ref), From (ref), hide (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TradeRequest"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 8

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v1 = Style.card(ScreenGui, Style.SEAFOAM, {
        Name = "Card",
        Visible = false,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, -200),
        Size = UDim2.fromOffset(520, 150)
    })

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v1
    UIUtil.onScale(function(p2) -- line: 56
        -- upvalues: UIScale (copy)
        UIScale.Scale = math.max(p2, 0.6)
    end)
    v2 = Style.text(v1, "", {
        ZIndex = 2,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(18, 12),
        Size = UDim2.new(1, -36, 0, 48)
    })
    Kit.button(v1, "TRADE!", Style.BUY, {
        ZIndex = 2,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(0.5, -8, 1, -16),
        Size = UDim2.fromOffset(220, 64)
    }, function() -- line: 65
        -- upvalues: Remotes (copy), From (ref), hide (copy)
        if From then
            Remotes.Trade:FireServer("Respond", From, true)
        end

        hide()
    end).Label.ZIndex = 3
    Kit.button(v1, "NO", Color3.fromRGB(235, 70, 70), {
        ZIndex = 2,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0.5, 8, 1, -16),
        Size = UDim2.fromOffset(220, 64)
    }, function() -- line: 69
        -- upvalues: Remotes (copy), From (ref), hide (copy)
        if From then
            Remotes.Trade:FireServer("Respond", From, false)
        end

        hide()
    end).Label.ZIndex = 3

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

function t1.init() -- line: 76
    -- upvalues: Remotes (copy), UIUtil (copy), v1 (ref), v2 (ref), From (ref), n1 (ref), hide (copy), build (copy)
    build()
    Remotes.Trade.OnClientEvent:Connect(function(p3, p4) -- line: 78
        -- upvalues: UIUtil (copy), v1 (ref), v2 (ref), From (ref), n1 (ref), hide (copy)
        if p3 == "Request" and type(p4) == "table" and type(p4.From) == "number" then
            From = p4.From

            local elapsed = os.clock()

            n1 = elapsed
            v2.Text = ("🤝 <font color=\"#FFE15A\">%*</font> wants to trade!"):format(p4.Name)
            v1.Visible = true
            v1.Position = UDim2.new(0.5, 0, 0, -200)
            UIUtil.tween(v1, 0.35, {
                Position = UDim2.new(0.5, 0, 0, 70)
            }, Enum.EasingStyle.Back)
            UIUtil.sound("ShopBell", 0.7)
            task.delay(18, function() -- line: 88
                -- upvalues: elapsed (copy), n1 (ref), hide (copy)
                if n1 == elapsed then
                    hide()
                end
            end)

            return
        end

        if p3 == "State" then
            hide()
        end
    end)
end

return t1
