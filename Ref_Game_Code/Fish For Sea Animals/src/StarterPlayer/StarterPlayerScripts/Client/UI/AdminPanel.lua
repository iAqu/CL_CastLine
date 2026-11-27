-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Menus = require(script.Parent.Menus)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local RevealPreview = require(script.Parent.Parent.Fishing.RevealPreview)
local Intro = require(script.Parent.Parent.Intro.Intro)
local Promo = require(script.Parent.Parent.Promo.Promo)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(235, 70, 70)
local ScreenGui, TextButton

local function isOpen() -- line: 30
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

local function open() -- line: 34
    -- upvalues: UIUtil (copy), Menus (copy), ScreenGui (ref)
    Menus.closeAll()
    UIUtil.openPanel(ScreenGui)
end

local function close() -- line: 39
    -- upvalues: UIUtil (copy), ScreenGui (ref)
    UIUtil.closePanel(ScreenGui)
end

local function build() -- line: 43
    -- upvalues: Config (copy), Remotes (copy), UIUtil (copy), Kit (copy), RevealPreview (copy), Intro (copy), Promo (copy), LocalPlayer (copy), v1 (copy), ScreenGui (ref), close (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminPanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 5
    ScreenGui.Enabled = false

    local v2 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(480, 1060),
        BackgroundColor3 = Kit.DARK
    })

    Kit.corner(v2, 22)
    Kit.stroke(v2, 5)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v2
    Kit.text(v2, "ADMIN", {
        StrokeThickness = 4,
        Position = UDim2.fromOffset(28, 18),
        Size = UDim2.fromOffset(300, 56),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Kit.button(v2, "X", v1, {
        Name = "Close",
        Position = UDim2.new(1, -78, 0, 18),
        Size = UDim2.fromOffset(58, 58)
    }, function() -- line: 66
        -- upvalues: close (copy)
        task.spawn(close)
    end)

    local elapsed = nil
    local v3

    v3 = Kit.button(v2, "RESET ECONOMY", v1, {
        Name = "ResetEconomy",
        Position = UDim2.fromOffset(24, 96),
        Size = UDim2.new(1, -48, 0, 78)
    }, function() -- line: 73
        -- upvalues: elapsed (ref), v3 (ref), Remotes (copy)
        local elapsed2 = os.clock()

        if not (elapsed and elapsed2 - elapsed < 3) then
            elapsed = elapsed2
            v3.Label.Text = "TAP AGAIN TO CONFIRM"
            task.delay(3, function() -- line: 83
                -- upvalues: elapsed2 (copy), elapsed (ref), v3 (ref)
                if elapsed == elapsed2 then
                    elapsed = nil
                    v3.Label.Text = "RESET ECONOMY"
                end
            end)
        else
            elapsed = nil
            v3.Label.Text = "RESET ECONOMY"
            Remotes.Admin:FireServer("ResetEconomy")
        end
    end)
    Kit.text(v2, "Money, strength, rods, barbell, tank, rebirths, animals and index back to a new player's", {
        StrokeThickness = 2,
        Position = UDim2.fromOffset(24, 180),
        Size = UDim2.new(1, -48, 0, 40),
        TextColor3 = Color3.fromRGB(190, 195, 215)
    })
    Kit.button(v2, "REPLAY CUTSCENE", Color3.fromRGB(90, 140, 235), {
        Name = "ReplayCutscene",
        Position = UDim2.fromOffset(24, 236),
        Size = UDim2.new(1, -48, 0, 78)
    }, function() -- line: 97
        -- upvalues: UIUtil (copy), Intro (copy), ScreenGui (ref)
        task.spawn(function() -- line: 98
            -- upvalues: UIUtil (copy), Intro (copy), ScreenGui (ref)
            UIUtil.closePanel(ScreenGui)
            Intro.replay()
        end)
    end)
    Kit.button(v2, "PLAY PROMO VIDEO", Color3.fromRGB(240, 150, 40), {
        Name = "PlayPromo",
        Position = UDim2.fromOffset(24, 330),
        Size = UDim2.new(1, -48, 0, 78)
    }, function() -- line: 104
        -- upvalues: UIUtil (copy), Promo (copy), ScreenGui (ref)
        task.spawn(function() -- line: 105
            -- upvalues: UIUtil (copy), Promo (copy), ScreenGui (ref)
            UIUtil.closePanel(ScreenGui)
            Promo.play()
        end)
    end)
    Kit.button(v2, "START BOSS FIGHT", Color3.fromRGB(40, 170, 120), {
        Name = "StartBoss",
        Position = UDim2.fromOffset(24, 424),
        Size = UDim2.new(1, -48, 0, 78)
    }, function() -- line: 111
        -- upvalues: Remotes (copy), close (copy)
        Remotes.Admin:FireServer("StartBoss")
        task.spawn(close)
    end)
    Kit.button(v2, "LOCK WORLD 2", Color3.fromRGB(150, 80, 200), {
        Name = "LockWorld2",
        Position = UDim2.fromOffset(24, 518),
        Size = UDim2.new(1, -48, 0, 78)
    }, function() -- line: 116
        -- upvalues: Remotes (copy), close (copy)
        Remotes.Admin:FireServer("LockWorld2")
        task.spawn(close)
    end)
    Kit.button(v2, "PLAY W2 OPENING", Color3.fromRGB(30, 120, 190), {
        Name = "PlayWorld2Trip",
        Position = UDim2.fromOffset(24, 612),
        Size = UDim2.new(0.5, -28, 0, 78)
    }, function() -- line: 123
        -- upvalues: Remotes (copy), close (copy)
        Remotes.Admin:FireServer("PlayWorld2Trip")
        task.spawn(close)
    end)
    Kit.button(v2, "GO TO WORLD 2", Color3.fromRGB(20, 160, 170), {
        Name = "GoToWorld2",
        Position = UDim2.new(0.5, 4, 0, 612),
        Size = UDim2.new(0.5, -28, 0, 78)
    }, function() -- line: 127
        -- upvalues: Remotes (copy), close (copy)
        Remotes.Admin:FireServer("GoToWorld2")
        task.spawn(close)
    end)
    Kit.text(v2, "PLAY LUCK REVEAL", {
        StrokeThickness = 3,
        Position = UDim2.fromOffset(24, 708),
        Size = UDim2.new(1, -48, 0, 44)
    })

    local v4 = Kit.frame(v2, {
        Name = "Stages",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 764),
        Size = UDim2.new(1, -48, 0, 272)
    })
    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.CellSize = UDim2.new(0.3333333333333333, -6, 0, 58)
    UIGridLayout.CellPadding = UDim2.fromOffset(8, 8)
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.Parent = v4

    for v5, v6 in Config.LuckStages do
        Kit.button(v4, ("%*  %*"):format(v5, v6.Title), v6.Color:Lerp(Kit.DARK, 0.15), {
            Name = "Stage" .. v5,
            LayoutOrder = v5
        }, function() -- line: 146
            -- upvalues: v5 (copy), UIUtil (copy), RevealPreview (copy), ScreenGui (ref)
            task.spawn(function() -- line: 147
                -- upvalues: v5 (copy), UIUtil (copy), RevealPreview (copy), ScreenGui (ref)
                UIUtil.closePanel(ScreenGui)
                RevealPreview.play(v5)
            end)
        end)
    end

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function buildToggle() -- line: 159
    -- upvalues: Config (copy), UIUtil (copy), Menus (copy), ScreenGui (ref), TextButton (ref), close (copy)
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Admin"
    TextButton.LayoutOrder = 3

    local TextButton2 = TextButton

    TextButton2.Size = UDim2.fromOffset(44, 44)

    local TextButton3 = TextButton

    TextButton3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
    TextButton.BackgroundTransparency = 0.1
    TextButton.AutoButtonColor = false
    TextButton.Text = "🛠️"
    TextButton.TextScaled = true

    local TextButton4 = TextButton

    TextButton4.FontFace = Config.Font

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = TextButton

    local TextButton5 = TextButton

    TextButton5.Parent = UIUtil.gui("HUD"):WaitForChild("TopLeftButtons")
    UIUtil.bindButton(TextButton, function() -- line: 174
        -- upvalues: UIUtil (copy), Menus (copy), ScreenGui (ref), close (copy)
        if ScreenGui ~= nil and ScreenGui.Enabled then
            task.spawn(close)
        else
            Menus.closeAll()
            UIUtil.openPanel(ScreenGui)
        end
    end)
end

function t1.init() -- line: 183
    -- upvalues: LocalPlayer (copy), build (copy), buildToggle (copy)
    task.spawn(function() -- line: 184
        -- upvalues: LocalPlayer (copy), build (copy), buildToggle (copy)
        if not LocalPlayer:GetAttribute("Admin") then
            LocalPlayer:GetAttributeChangedSignal("Admin"):Wait()
        end

        build()
        buildToggle()
    end)
end

return t1
