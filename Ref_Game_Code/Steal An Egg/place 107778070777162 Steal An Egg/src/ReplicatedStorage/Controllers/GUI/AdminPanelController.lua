-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local AdminPanelEntry = require(ReplicatedStorage.Client.AdminPanelEntry)
local Personalities = require(ReplicatedStorage.Data.Assets).Personalities
local Assets = require(ReplicatedStorage.Data.Assets)

require(ReplicatedStorage.Shared.Globals.Constants)

local Parse = require(ReplicatedStorage.Shared.Utils.Numbers).Parse
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Directory = Assets.Directory
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)

require(ReplicatedStorage.Shared.Types.AssetItem)

local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Log = require(ReplicatedStorage.Packages.Log)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local v1 = UDim2.fromOffset(900, 600)
local v2 = Log.new()
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 83
        -- upvalues: UserInputService (copy), AdminPanelEntry (copy), Personalities (copy), Parse (copy), Remotes (copy), Save (copy), Directory (copy), AssetEarnings (copy), Simple (copy), Mutations (copy), TreadmillUtil (copy), v1 (copy), v2 (copy), LocalPlayer (copy)
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local Id
        local t2 = {}
        local v3 = "Assets"
        local v4 = false
        local v5 = false
        local v6 = false
        local v7 = false
        local v8 = false

        local function clearGradients(p1) -- line: 95
            for _, child in ipairs(p1:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy()
                end
            end
        end

        local function roundToStep(p2, p3) -- line: 103
            return math.round(p2 / p3) * p3
        end

        local function formatWalkSpeedDisplay(p4) -- line: 107
            local v11 = math.round(p4 / 0.1) * 0.1
            local v12 = string.format("%.1f", v11)

            if string.sub(v12, -2) ~= ".0" then
                return v12
            end

            return (string.sub(v12, 1, #v12 - 2))
        end

        local function formatSpeedPowerDisplay(p5) -- line: 117
            return string.format("%.0f", (math.round(p5)))
        end

        local function parseNumericInput(p6) -- line: 121
            -- upvalues: Parse (copy)
            local v14 = Parse(p6)

            if typeof(v14) == "number" then
                return v14
            end

            return (tonumber(p6))
        end

        local function trimText(p7) -- line: 130
            return string.match(p7, "^%s*(.-)%s*$") or ""
        end

        local function parseOptionalNumberInput(p8) -- line: 132
            -- upvalues: Parse (copy)
            local v15 = string.match(p8, "^%s*(.-)%s*$") or ""

            if v15 == "" then
                return nil, true
            end

            local v16 = Parse(v15)

            if typeof(v16) ~= "number" then
                v16 = tonumber(v15)
            end

            return v16, v16 ~= nil
        end

        local function updateSliderVisual(p9, p10) -- line: 142
            local Step = p9.Step
            local v19 = math.clamp(math.round(p10 / Step) * Step, p9.MinValue, p9.MaxValue)
            local v21 = math.max(p9.MaxValue - p9.MinValue, 1E-04)
            local v23 = math.clamp((v19 - p9.MinValue) / v21, 0, 1)

            p9.CurrentValue = v19
            p9.Fill.Size = UDim2.fromScale(v23, 1)
            p9.Knob.Position = UDim2.fromScale(v23, 0.5)
            p9.ValueLabel.Text = p9.FormatDisplay(v19)
            p9.Input.Text = p9.FormatInput(v19)
        end

        local function createSliderControl(p11, p12, p13, p14, p15, p16, p17, p18, p19) -- line: 155
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = ("%*Label"):format(p12)
            TextLabel.Size = UDim2.fromOffset(190, 18)
            TextLabel.Position = UDim2.fromOffset(690, p14)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = p13
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 15
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Parent = p11

            local TextLabel2 = Instance.new("TextLabel")

            TextLabel2.Name = ("%*Value"):format(p12)
            TextLabel2.Size = UDim2.fromOffset(190, 16)
            TextLabel2.Position = UDim2.fromOffset(690, p14 + 18)
            TextLabel2.BackgroundTransparency = 1
            TextLabel2.Text = "0"
            TextLabel2.TextColor3 = Color3.fromRGB(145, 232, 181)
            TextLabel2.TextSize = 13
            TextLabel2.Font = Enum.Font.Gotham
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel2.Parent = p11

            local TextButton = Instance.new("TextButton")

            TextButton.Name = ("%*Track"):format(p12)
            TextButton.Size = UDim2.fromOffset(124, 16)
            TextButton.Position = UDim2.fromOffset(690, p14 + 40)
            TextButton.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
            TextButton.BorderSizePixel = 0
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            TextButton.Parent = p11

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = TextButton

            local Frame = Instance.new("Frame")

            Frame.Name = "Fill"
            Frame.Size = UDim2.fromScale(0, 1)
            Frame.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
            Frame.BorderSizePixel = 0
            Frame.Parent = TextButton

            local UICorner2 = Instance.new("UICorner")

            UICorner2.CornerRadius = UDim.new(1, 0)
            UICorner2.Parent = Frame

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Knob"
            Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame2.Size = UDim2.fromOffset(14, 14)
            Frame2.Position = UDim2.fromScale(0, 0.5)
            Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame2.BorderSizePixel = 0
            Frame2.Parent = TextButton

            local UICorner3 = Instance.new("UICorner")

            UICorner3.CornerRadius = UDim.new(1, 0)
            UICorner3.Parent = Frame2

            local TextBox = Instance.new("TextBox")

            TextBox.Name = ("%*Input"):format(p12)
            TextBox.Size = UDim2.fromOffset(58, 28)
            TextBox.Position = UDim2.fromOffset(822, p14 + 34)
            TextBox.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
            TextBox.BorderSizePixel = 0
            TextBox.Text = "0"
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 15
            TextBox.Font = Enum.Font.Gotham
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = p11

            local UICorner4 = Instance.new("UICorner")

            UICorner4.CornerRadius = UDim.new(0, 6)
            UICorner4.Parent = TextBox

            return {
                Label = TextLabel,
                TrackButton = TextButton,
                Fill = Frame,
                Knob = Frame2,
                Input = TextBox,
                ValueLabel = TextLabel2,
                MinValue = p15,
                MaxValue = p16,
                Step = p17,
                CurrentValue = p15,
                FormatDisplay = p18,
                FormatInput = p19
            }
        end

        local function createLabelInput(p20, p21, p22, p23) -- line: 257
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = ("%*Label"):format(p21)
            TextLabel.Size = UDim2.fromOffset(190, 18)
            TextLabel.Position = UDim2.fromOffset(690, p23)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = p22
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Parent = p20

            local TextBox = Instance.new("TextBox")

            TextBox.Name = ("%*Input"):format(p21)
            TextBox.Size = UDim2.fromOffset(190, 32)
            TextBox.Position = UDim2.fromOffset(690, p23 + 20)
            TextBox.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
            TextBox.BorderSizePixel = 0
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.PlaceholderColor3 = Color3.fromRGB(156, 168, 188)
            TextBox.TextSize = 15
            TextBox.Font = Enum.Font.Gotham
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = p20

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = TextBox

            return TextLabel, TextBox
        end

        local function buildRarityChancePercentById() -- line: 295
            return {}
        end

        local function buildAssetRows() -- line: 308
            -- upvalues: Personalities (copy), Directory (copy), AssetEarnings (copy)
            local t3 = {}
            local t4 = {}
            local t5 = {}

            for v24, v25 in pairs(Directory) do
                local v26 = v25.DropWeight or 0
                local Rarity = v25.Rarity

                if Rarity then
                    local DisplayName = Rarity.DisplayName or Rarity._id or "Unknown"
                    local v27 = Rarity._id or DisplayName
                    local v28 = Personalities.CreateNewItemData({
                        Scale = 1,
                        Personality = "Normal",
                        HasBeenFirstPlaced = false,
                        Category = v24,
                        Mutations = {}
                    })
                    local v29 = AssetEarnings.RatePerSecond(v28)

                    t4[v27] = (t4[v27] or 0) + v26
                    table.insert(t3, {
                        InRarityDropChancePercent = 0,
                        Id = v24,
                        DisplayName = v25.DisplayName or v24,
                        Icon = v25.Icon or "",
                        RarityId = v27,
                        RarityName = DisplayName,
                        Rank = Rarity.Rank or 0,
                        RarityGradient = Rarity.RarityGradient,
                        MoneyPerSecond = v29,
                        DropWeight = v26
                    })
                end
            end

            for _, v30 in ipairs(t3) do
                local v31 = t4[v30.RarityId] or 0

                if v31 > 0 then
                    v30.InRarityDropChancePercent = v30.DropWeight / v31 * 100
                end
            end

            table.sort(t3, function(p24, p25) -- line: 349
                if p24.Rank ~= p25.Rank then
                    return p24.Rank > p25.Rank
                end

                if p24.MoneyPerSecond == p25.MoneyPerSecond then
                    return p24.DisplayName < p25.DisplayName
                end

                return p24.MoneyPerSecond > p25.MoneyPerSecond
            end)

            return t3, t5
        end

        local function buildMutationNames() -- line: 364
            -- upvalues: Mutations (copy)
            local t7 = {}

            for v32 in pairs(Mutations.All()) do
                table.insert(t7, v32)
            end

            table.sort(t7)

            return t7
        end

        local function createAdminPanel() -- line: 373
            -- upvalues: PlayerGui (copy), formatWalkSpeedDisplay (copy), formatSpeedPowerDisplay (copy), createSliderControl (copy), createLabelInput (copy), TreadmillUtil (copy), v1 (copy)
            local ScreenGui = Instance.new("ScreenGui")

            ScreenGui.Name = "AdminPanel"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.Parent = PlayerGui

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "Toggle"
            TextButton.Size = UDim2.fromScale(0.1, 0.05)
            TextButton.AnchorPoint = Vector2.new(0, 0.5)
            TextButton.Position = UDim2.new(0, 12, 0.75, 0)
            TextButton.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
            TextButton.BorderSizePixel = 0
            TextButton.Text = "Admin"
            TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.TextSize = 20
            TextButton.Font = Enum.Font.GothamBold
            TextButton.Parent = ScreenGui

            local Frame = Instance.new("Frame")

            Frame.Name = "Panel"
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Size = v1
            Frame.Position = UDim2.fromScale(0.5, 0.5)
            Frame.BackgroundColor3 = Color3.fromRGB(18, 24, 35)
            Frame.BorderSizePixel = 0
            Frame.Visible = false
            Frame.Parent = ScreenGui

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = Frame
            Instance.new("UIDragDetector").Parent = Frame

            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Title"
            TextLabel.Size = UDim2.new(1, -60, 0, 42)
            TextLabel.Position = UDim2.fromOffset(18, 8)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = "Admin Asset Grant"
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 25
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Parent = Frame

            local TextButton2 = Instance.new("TextButton")

            TextButton2.Name = "CloseButton"
            TextButton2.Size = UDim2.fromOffset(34, 34)
            TextButton2.Position = UDim2.new(1, -42, 0, 8)
            TextButton2.BackgroundColor3 = Color3.fromRGB(117, 38, 46)
            TextButton2.BorderSizePixel = 0
            TextButton2.Text = "X"
            TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton2.TextSize = 22
            TextButton2.Font = Enum.Font.GothamBold
            TextButton2.Parent = Frame

            local UICorner2 = Instance.new("UICorner")

            UICorner2.CornerRadius = UDim.new(0, 6)
            UICorner2.Parent = TextButton2

            local TextButton3 = Instance.new("TextButton")

            TextButton3.Name = "AssetTabButton"
            TextButton3.Size = UDim2.fromOffset(94, 32)
            TextButton3.Position = UDim2.fromOffset(456, 18)
            TextButton3.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
            TextButton3.BorderSizePixel = 0
            TextButton3.Text = "Assets"
            TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton3.TextSize = 14
            TextButton3.Font = Enum.Font.GothamBold
            TextButton3.Parent = Frame

            local UICorner3 = Instance.new("UICorner")

            UICorner3.CornerRadius = UDim.new(0, 7)
            UICorner3.Parent = TextButton3

            local TextButton4 = Instance.new("TextButton")

            TextButton4.Name = "EggTabButton"
            TextButton4.Size = UDim2.fromOffset(94, 32)
            TextButton4.Position = UDim2.fromOffset(558, 18)
            TextButton4.BackgroundColor3 = Color3.fromRGB(37, 47, 66)
            TextButton4.BorderSizePixel = 0
            TextButton4.Text = "Eggs"
            TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton4.TextSize = 14
            TextButton4.Font = Enum.Font.GothamBold
            TextButton4.Parent = Frame

            local UICorner4 = Instance.new("UICorner")

            UICorner4.CornerRadius = UDim.new(0, 7)
            UICorner4.Parent = TextButton4

            local TextBox = Instance.new("TextBox")

            TextBox.Name = "PetSearch"
            TextBox.Size = UDim2.fromOffset(430, 30)
            TextBox.Position = UDim2.fromOffset(16, 60)
            TextBox.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
            TextBox.BorderSizePixel = 0
            TextBox.Text = ""
            TextBox.PlaceholderText = "Search pet name, asset id or rarity..."
            TextBox.PlaceholderColor3 = Color3.fromRGB(156, 168, 188)
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 15
            TextBox.Font = Enum.Font.Gotham
            TextBox.ClearTextOnFocus = false
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.Parent = Frame

            local UICorner5 = Instance.new("UICorner")

            UICorner5.CornerRadius = UDim.new(0, 6)
            UICorner5.Parent = TextBox

            local UIPadding = Instance.new("UIPadding")

            UIPadding.PaddingLeft = UDim.new(0, 10)
            UIPadding.PaddingRight = UDim.new(0, 10)
            UIPadding.Parent = TextBox

            local ScrollingFrame = Instance.new("ScrollingFrame")

            ScrollingFrame.Name = "AssetList"
            ScrollingFrame.Size = UDim2.fromOffset(430, 482)
            ScrollingFrame.Position = UDim2.fromOffset(16, 98)
            ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 33, 47)
            ScrollingFrame.BorderSizePixel = 0
            ScrollingFrame.ScrollBarThickness = 7
            ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
            ScrollingFrame.Parent = Frame

            local UICorner6 = Instance.new("UICorner")

            UICorner6.CornerRadius = UDim.new(0, 8)
            UICorner6.Parent = ScrollingFrame

            local ScrollingFrame2 = Instance.new("ScrollingFrame")

            ScrollingFrame2.Name = "MutationList"
            ScrollingFrame2.Size = UDim2.fromOffset(220, 300)
            ScrollingFrame2.Position = UDim2.fromOffset(456, 60)
            ScrollingFrame2.BackgroundColor3 = Color3.fromRGB(25, 33, 47)
            ScrollingFrame2.BorderSizePixel = 0
            ScrollingFrame2.ScrollBarThickness = 7
            ScrollingFrame2.CanvasSize = UDim2.fromOffset(0, 0)
            ScrollingFrame2.Parent = Frame

            local UICorner7 = Instance.new("UICorner")

            UICorner7.CornerRadius = UDim.new(0, 8)
            UICorner7.Parent = ScrollingFrame2

            local TextLabel2 = Instance.new("TextLabel")

            TextLabel2.Name = "SelectedLabel"
            TextLabel2.Size = UDim2.fromOffset(220, 50)
            TextLabel2.Position = UDim2.fromOffset(456, 368)
            TextLabel2.BackgroundTransparency = 1
            TextLabel2.Text = "Selected: None"
            TextLabel2.TextColor3 = Color3.fromRGB(226, 230, 236)
            TextLabel2.TextSize = 16
            TextLabel2.Font = Enum.Font.Gotham
            TextLabel2.TextWrapped = true
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
            TextLabel2.Parent = Frame

            local TextLabel3 = Instance.new("TextLabel")

            TextLabel3.Name = "MutationSelectionLabel"
            TextLabel3.Size = UDim2.fromOffset(220, 50)
            TextLabel3.Position = UDim2.fromOffset(456, 420)
            TextLabel3.BackgroundTransparency = 1
            TextLabel3.Text = "Mutations: None"
            TextLabel3.TextColor3 = Color3.fromRGB(226, 230, 236)
            TextLabel3.TextSize = 16
            TextLabel3.Font = Enum.Font.Gotham
            TextLabel3.TextWrapped = true
            TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel3.TextYAlignment = Enum.TextYAlignment.Top
            TextLabel3.Parent = Frame

            local TextLabel4 = Instance.new("TextLabel")

            TextLabel4.Name = "ScaleLabel"
            TextLabel4.Size = UDim2.fromOffset(190, 20)
            TextLabel4.Position = UDim2.fromOffset(690, 142)
            TextLabel4.BackgroundTransparency = 1
            TextLabel4.Text = "Size Scale"
            TextLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel4.TextSize = 15
            TextLabel4.Font = Enum.Font.GothamBold
            TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel4.Parent = Frame

            local TextBox2 = Instance.new("TextBox")

            TextBox2.Name = "ScaleInput"
            TextBox2.Size = UDim2.fromOffset(190, 34)
            TextBox2.Position = UDim2.fromOffset(690, 166)
            TextBox2.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
            TextBox2.BorderSizePixel = 0
            TextBox2.Text = ""
            TextBox2.PlaceholderText = "blank = roll"
            TextBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox2.PlaceholderColor3 = Color3.fromRGB(156, 168, 188)
            TextBox2.TextSize = 17
            TextBox2.Font = Enum.Font.Gotham
            TextBox2.ClearTextOnFocus = false
            TextBox2.Parent = Frame

            local UICorner8 = Instance.new("UICorner")

            UICorner8.CornerRadius = UDim.new(0, 6)
            UICorner8.Parent = TextBox2

            local v33, v34 = createLabelInput(Frame, "ColorIndex", "Color Index Override", 218)

            v34.PlaceholderText = "blank = roll"

            local v35, v36 = createLabelInput(Frame, "ColorSeed", "Color Seed Override", 274)

            v36.PlaceholderText = "blank = roll"

            local v37, v38 = createLabelInput(Frame, "EyeColor", "Eye Hex Override", 330)

            v38.PlaceholderText = "blank = roll"

            local v39 = createSliderControl(Frame, "WalkSpeed", "Walk Speed", 220, 0, 1000, 0.1, formatWalkSpeedDisplay, formatWalkSpeedDisplay)
            local v40 = createSliderControl(Frame, "SpeedPower", "Speed Value", 288, 0, 1E+18, 1, TreadmillUtil.FormatSpeedPower, formatSpeedPowerDisplay)

            local function createMountCheckbox(p26, p27) -- line: 606
                -- upvalues: Frame (copy)
                local TextButton = Instance.new("TextButton")

                TextButton.Name = p26
                TextButton.Size = UDim2.fromOffset(190, 28)
                TextButton.Position = UDim2.fromOffset(690, p27)
                TextButton.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
                TextButton.BorderSizePixel = 0
                TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextButton.TextSize = 15
                TextButton.Font = Enum.Font.GothamBold
                TextButton.TextXAlignment = Enum.TextXAlignment.Left
                TextButton.Parent = Frame

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(0, 6)
                UICorner.Parent = TextButton

                local UIPadding = Instance.new("UIPadding")

                UIPadding.PaddingLeft = UDim.new(0, 8)
                UIPadding.Parent = TextButton

                return TextButton
            end

            local v41 = createMountCheckbox("RideableCheckbox", 366)
            local v42 = createMountCheckbox("InstantMountCheckbox", 400)
            local TextButton5 = Instance.new("TextButton")

            TextButton5.Name = "GiveButton"
            TextButton5.Size = UDim2.fromOffset(190, 46)
            TextButton5.Position = UDim2.fromOffset(690, 446)
            TextButton5.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
            TextButton5.BorderSizePixel = 0
            TextButton5.Text = "Give Selected Asset"
            TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton5.TextSize = 17
            TextButton5.Font = Enum.Font.GothamBold
            TextButton5.Parent = Frame

            local UICorner9 = Instance.new("UICorner")

            UICorner9.CornerRadius = UDim.new(0, 8)
            UICorner9.Parent = TextButton5

            local TextLabel5 = Instance.new("TextLabel")

            TextLabel5.Name = "StatusLabel"
            TextLabel5.Size = UDim2.fromOffset(190, 42)
            TextLabel5.Position = UDim2.fromOffset(690, 498)
            TextLabel5.BackgroundTransparency = 1
            TextLabel5.Text = "Ready."
            TextLabel5.TextWrapped = true
            TextLabel5.TextColor3 = Color3.fromRGB(226, 230, 236)
            TextLabel5.TextSize = 15
            TextLabel5.Font = Enum.Font.Gotham
            TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel5.TextYAlignment = Enum.TextYAlignment.Top
            TextLabel5.Parent = Frame

            local TextButton6 = Instance.new("TextButton")

            TextButton6.Name = "ResetDataButton"
            TextButton6.Size = UDim2.fromOffset(190, 44)
            TextButton6.Position = UDim2.fromOffset(690, 546)
            TextButton6.BackgroundColor3 = Color3.fromRGB(134, 46, 46)
            TextButton6.BorderSizePixel = 0
            TextButton6.Text = "Reset Data"
            TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton6.TextSize = 17
            TextButton6.Font = Enum.Font.GothamBold
            TextButton6.Parent = Frame

            local UICorner10 = Instance.new("UICorner")

            UICorner10.CornerRadius = UDim.new(0, 8)
            UICorner10.Parent = TextButton6

            return {
                screenGui = ScreenGui,
                panel = Frame,
                title = TextLabel,
                toggleButton = TextButton,
                closeButton = TextButton2,
                assetTabButton = TextButton3,
                eggTabButton = TextButton4,
                assetList = ScrollingFrame,
                petSearch = TextBox,
                rideableCheckbox = v41,
                instantMountCheckbox = v42,
                mutationList = ScrollingFrame2,
                selectedLabel = TextLabel2,
                mutationSelectionLabel = TextLabel3,
                scaleLabel = TextLabel4,
                scaleInput = TextBox2,
                colorIndexLabel = v33,
                colorIndexInput = v34,
                colorSeedLabel = v35,
                colorSeedInput = v36,
                eyeColorLabel = v37,
                eyeColorInput = v38,
                walkSpeedControl = v39,
                speedPowerControl = v40,
                giveButton = TextButton5,
                resetButton = TextButton6,
                statusLabel = TextLabel5
            }
        end

        local function setupAdminPanel() -- line: 705
            -- upvalues: Id (ref), t2 (copy), v3 (ref), v4 (ref), v5 (ref), clearGradients (copy), updateSliderVisual (copy), buildAssetRows (copy), buildMutationNames (copy), createAdminPanel (copy), UserInputService (copy), Parse (copy), Remotes (copy), Save (copy), Simple (copy), TreadmillUtil (copy)
            local v43 = createAdminPanel()
            local t8 = {}
            local t9 = {}
            local v44 = false
            local v45, v46, v47

            local function setStatus(p28, p29) -- line: 714
                -- upvalues: v43 (copy)
                v43.statusLabel.Text = p28

                if p29 ~= nil then
                    if p29 then
                        v43.statusLabel.TextColor3 = Color3.fromRGB(145, 232, 181)
                    else
                        v43.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146)
                    end
                else
                    v43.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236)
                end
            end

            local function setSliderControlVisible(p30, p31) -- line: 725
                p30.Label.Visible = p31
                p30.ValueLabel.Visible = p31
                p30.TrackButton.Visible = p31
                p30.Input.Visible = p31
            end

            local function setEggOverrideControlsVisible(p32) -- line: 732
                -- upvalues: v43 (copy)
                v43.colorIndexLabel.Visible = p32
                v43.colorIndexInput.Visible = p32
                v43.colorSeedLabel.Visible = p32
                v43.colorSeedInput.Visible = p32
                v43.eyeColorLabel.Visible = p32
                v43.eyeColorInput.Visible = p32
            end

            local function updateMountCheckboxes() -- line: 741
                -- upvalues: v43 (copy), v4 (ref), v5 (ref)
                v43.rideableCheckbox.Text = (v4 and "[X] " or "[ ] ") .. "Rideable"
                v43.instantMountCheckbox.Text = (v5 and "[X] " or "[ ] ") .. "Instant Mount"

                local rideableCheckbox = v43.rideableCheckbox

                if v4 then
                    rideableCheckbox.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
                else
                    rideableCheckbox.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
                end

                local instantMountCheckbox = v43.instantMountCheckbox

                if v5 then
                    instantMountCheckbox.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
                else
                    instantMountCheckbox.BackgroundColor3 = Color3.fromRGB(31, 45, 71)
                end
            end

            v43.rideableCheckbox.Activated:Connect(function() -- line: 748
                -- upvalues: updateMountCheckboxes (copy), v4 (ref), v5 (ref)
                v4 = not v4

                if not v4 then
                    v5 = false
                end

                updateMountCheckboxes()
            end)
            v43.instantMountCheckbox.Activated:Connect(function() -- line: 753
                -- upvalues: updateMountCheckboxes (copy), v4 (ref), v5 (ref)
                v5 = not v5

                if v5 then
                    v4 = true
                end

                updateMountCheckboxes()
            end)
            updateMountCheckboxes()

            local function applyGrantTabState(p33) -- line: 760
                -- upvalues: v43 (copy), v3 (ref)
                v3 = p33

                local v48 = p33 == "Eggs"

                v43.title.Text = v48 and "Admin Egg Grant" or "Admin Asset Grant"

                local assetTabButton = v43.assetTabButton

                if v48 then
                    assetTabButton.BackgroundColor3 = Color3.fromRGB(37, 47, 66)
                else
                    assetTabButton.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
                end

                local eggTabButton = v43.eggTabButton

                if v48 then
                    eggTabButton.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
                else
                    eggTabButton.BackgroundColor3 = Color3.fromRGB(37, 47, 66)
                end

                v43.scaleLabel.Text = v48 and "Egg Scale Override" or "Size Scale"
                v43.scaleInput.PlaceholderText = "blank = roll"
                v43.giveButton.Text = v48 and "Give Selected Egg" or "Give Selected Asset"

                local walkSpeedControl = v43.walkSpeedControl
                local v49 = not v48

                walkSpeedControl.Label.Visible = v49
                walkSpeedControl.ValueLabel.Visible = v49
                walkSpeedControl.TrackButton.Visible = v49
                walkSpeedControl.Input.Visible = v49

                local speedPowerControl = v43.speedPowerControl
                local v50 = not v48

                speedPowerControl.Label.Visible = v50
                speedPowerControl.ValueLabel.Visible = v50
                speedPowerControl.TrackButton.Visible = v50
                speedPowerControl.Input.Visible = v50
                v43.colorIndexLabel.Visible = v48
                v43.colorIndexInput.Visible = v48
                v43.colorSeedLabel.Visible = v48
                v43.colorSeedInput.Visible = v48
                v43.eyeColorLabel.Visible = v48
                v43.eyeColorInput.Visible = v48
                v43.rideableCheckbox.Visible = not v48
                v43.instantMountCheckbox.Visible = not v48

                if not v48 or v43.scaleInput.Text ~= "1" then
                    if not v48 then
                        local Text = v43.scaleInput.Text

                        if (string.match(Text, "^%s*(.-)%s*$") or "") == "1" then
                            v43.scaleInput.Text = ""
                        end
                    end
                else
                    v43.scaleInput.Text = ""
                end
            end

            local function syncSpeedControlsFromSave(p34) -- line: 786
                -- upvalues: v43 (copy), updateSliderVisual (copy), Save (copy), TreadmillUtil (copy)
                local v51 = Save.Await()

                if not v51 then
                    return
                end

                local v52 = TreadmillUtil.NormalizeSpeedPower(v51.SpeedPower)

                updateSliderVisual(v43.speedPowerControl, v52)

                if p34 then
                    local v53 = TreadmillUtil.SpeedPowerToWalkSpeed(v52)

                    updateSliderVisual(v43.walkSpeedControl, v53)
                end
            end

            local function setSliderValueFromTrack(p35, p36) -- line: 800
                -- upvalues: updateSliderVisual (copy)
                local v56 = math.clamp((p36 - p35.TrackButton.AbsolutePosition.X) / math.max(p35.TrackButton.AbsoluteSize.X, 1), 0, 1)

                updateSliderVisual(p35, p35.MinValue + (p35.MaxValue - p35.MinValue) * v56)
            end

            local function attachSliderBehavior(p37, p38) -- line: 807
                -- upvalues: v43 (copy), v45 (ref), v46 (ref), updateSliderVisual (copy), Parse (copy)
                p37.TrackButton.MouseButton1Down:Connect(function(p39) -- line: 808
                    -- upvalues: p37 (copy), p38 (copy), v45 (ref), v46 (ref), updateSliderVisual (copy)
                    v45 = p37
                    v46 = p38

                    local v60 = math.clamp((p39 - p37.TrackButton.AbsolutePosition.X) / math.max(p37.TrackButton.AbsoluteSize.X, 1), 0, 1)

                    updateSliderVisual(p37, p37.MinValue + (p37.MaxValue - p37.MinValue) * v60)
                end)
                p37.Input.FocusLost:Connect(function(p40) -- line: 814
                    -- upvalues: p37 (copy), p38 (copy), v43 (copy), updateSliderVisual (copy), Parse (copy)
                    if not p40 and p37.Input.Text == p37.FormatInput(p37.CurrentValue) then
                        return
                    end

                    local Text = p37.Input.Text
                    local v62 = Parse(Text)

                    if typeof(v62) ~= "number" then
                        v62 = tonumber(Text)
                    end

                    if v62 ~= nil then
                        updateSliderVisual(p37, v62)
                        p38(p37.CurrentValue)

                        return
                    end

                    updateSliderVisual(p37, p37.CurrentValue)
                    v43.statusLabel.Text = "Enter a valid number."
                    v43.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146)
                end)
            end

            local function updateSelectedAssetState() -- line: 831
                -- upvalues: v43 (copy), t8 (copy), Id (ref), v3 (ref)
                for v63, v64 in pairs(t8) do
                    if Id == v63 then
                        v64.BackgroundColor3 = Color3.fromRGB(36, 114, 84)
                    else
                        v64.BackgroundColor3 = Color3.fromRGB(37, 47, 66)
                    end
                end

                if Id then
                    local selectedLabel = v43.selectedLabel

                    if v3 == "Eggs" then
                        selectedLabel.Text = ("Selected egg: %*"):format(Id)
                    else
                        selectedLabel.Text = ("Selected asset: %*"):format(Id)
                    end
                else
                    v43.selectedLabel.Text = "Selected: None"
                end
            end

            local function updateMutationState() -- line: 847
                -- upvalues: v43 (copy), t9 (copy), t2 (copy)
                local t10 = {}

                for v65, v66 in pairs(t2) do
                    if v66 then
                        table.insert(t10, v65)
                    end
                end

                table.sort(t10)

                for v67, v68 in pairs(t9) do
                    if t2[v67] then
                        v68.BackgroundColor3 = Color3.fromRGB(126, 73, 153)
                    else
                        v68.BackgroundColor3 = Color3.fromRGB(37, 47, 66)
                    end
                end

                if #t10 == 0 then
                    v43.mutationSelectionLabel.Text = "Mutations: None"
                else
                    v43.mutationSelectionLabel.Text = ("Mutations: %*"):format((table.concat(t10, ", ")))
                end
            end

            local v69, v70 = buildAssetRows()
            local t11 = {}
            local n1 = 8
            local RarityName

            for _, v71 in ipairs(v69) do
                if RarityName ~= v71.RarityName then
                    local TextLabel = Instance.new("TextLabel")

                    TextLabel.Name = ("Rarity_%*"):format(v71.RarityName)
                    TextLabel.Size = UDim2.new(1, -14, 0, 22)
                    TextLabel.Position = UDim2.fromOffset(7, n1)
                    TextLabel.BackgroundTransparency = 1

                    local v72 = v70[v71.RarityId] or 0

                    TextLabel.Text = ("%* (%*)"):format(v71.RarityName, (string.format("%.2f%%", v72)))
                    TextLabel.TextColor3 = Color3.fromRGB(193, 203, 219)
                    TextLabel.TextSize = 14
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel.Parent = v43.assetList
                    t11[v71.RarityName] = TextLabel
                    n1 += 24
                    RarityName = v71.RarityName
                end

                local TextButton = Instance.new("TextButton")

                TextButton.Name = v71.Id
                TextButton.Size = UDim2.new(1, -14, 0, 44)
                TextButton.Position = UDim2.fromOffset(7, n1)
                TextButton.BackgroundColor3 = Color3.fromRGB(37, 47, 66)
                TextButton.BorderSizePixel = 0
                TextButton.Text = ""
                TextButton.Parent = v43.assetList

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(0, 7)
                UICorner.Parent = TextButton

                local ImageLabel = Instance.new("ImageLabel")

                ImageLabel.Name = "Icon"
                ImageLabel.Size = UDim2.fromOffset(34, 34)
                ImageLabel.ScaleType = Enum.ScaleType.Fit
                ImageLabel.Position = UDim2.fromOffset(5, 5)
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.Image = v71.Icon
                ImageLabel.Parent = TextButton

                local TextLabel = Instance.new("TextLabel")

                TextLabel.Name = "Name"
                TextLabel.Size = UDim2.new(1, -220, 1, 0)
                TextLabel.Position = UDim2.fromOffset(44, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = v71.DisplayName
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextSize = 14
                TextLabel.Font = Enum.Font.GothamBold
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.Parent = TextButton
                clearGradients(TextLabel)

                if v71.RarityGradient then
                    v71.RarityGradient:Clone().Parent = TextLabel
                end

                local TextLabel2 = Instance.new("TextLabel")

                TextLabel2.Name = "MoneyPerSecond"
                TextLabel2.Size = UDim2.fromOffset(170, 44)
                TextLabel2.AnchorPoint = Vector2.new(1, 0)
                TextLabel2.Position = UDim2.new(1, -6, 0, 0)
                TextLabel2.BackgroundTransparency = 1
                TextLabel2.Text = ("%*/s | %*"):format(Simple.FormatCompact(v71.MoneyPerSecond, ".##"), (string.format("%.2f%%", v71.InRarityDropChancePercent)))
                TextLabel2.TextColor3 = Color3.fromRGB(145, 232, 181)
                TextLabel2.TextSize = 13
                TextLabel2.Font = Enum.Font.Gotham
                TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
                TextLabel2.Parent = TextButton
                TextButton.MouseButton1Click:Connect(function() -- line: 946
                    -- upvalues: updateSelectedAssetState (copy), v71 (copy), Id (ref)
                    Id = v71.Id
                    updateSelectedAssetState()
                end)
                t8[v71.Id] = TextButton
                n1 += 48
            end

            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "NoSearchResults"
            TextLabel.Size = UDim2.new(1, -14, 0, 32)
            TextLabel.Position = UDim2.fromOffset(7, 8)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = "No matching pets."
            TextLabel.TextColor3 = Color3.fromRGB(193, 203, 219)
            TextLabel.TextSize = 15
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Visible = false
            TextLabel.Parent = v43.assetList

            local function filterPetList() -- line: 966
                -- upvalues: v43 (copy), t8 (copy), v69 (copy), t11 (copy), TextLabel (copy)
                local lower = string.lower
                local Text = v43.petSearch.Text
                local v73 = lower(string.match(Text, "^%s*(.-)%s*$") or "")

                for _, v74 in pairs(t11) do
                    v74.Visible = false
                end

                local n2 = 8
                local n3 = 0
                local RarityName

                for _, v75 in ipairs(v69) do
                    local v76 = string.lower(v75.DisplayName .. " " .. v75.Id .. " " .. v75.RarityName)
                    local v77 = v73 == "" or string.find(v76, v73, 1, true) ~= nil
                    local v78 = t8[v75.Id]

                    v78.Visible = v77

                    if v77 then
                        if RarityName ~= v75.RarityName then
                            local v79 = t11[v75.RarityName]

                            v79.Visible = true
                            v79.Position = UDim2.fromOffset(7, n2)
                            n2 += 24
                            RarityName = v75.RarityName
                        end

                        v78.Position = UDim2.fromOffset(7, n2)
                        n2 += 48
                        n3 += 1
                    end
                end

                TextLabel.Visible = n3 == 0
                v43.assetList.CanvasSize = UDim2.fromOffset(0, if n3 == 0 then 44 else n2 + 4)
                v43.assetList.CanvasPosition = Vector2.zero
            end

            v43.petSearch:GetPropertyChangedSignal("Text"):Connect(filterPetList)
            filterPetList()

            local v80 = buildMutationNames()
            local n4 = 8

            for _, v81 in ipairs(v80) do
                local TextButton = Instance.new("TextButton")

                TextButton.Name = v81
                TextButton.Size = UDim2.new(1, -14, 0, 32)
                TextButton.Position = UDim2.fromOffset(7, n4)
                TextButton.BackgroundColor3 = Color3.fromRGB(37, 47, 66)
                TextButton.BorderSizePixel = 0
                TextButton.Text = v81
                TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextButton.TextSize = 14
                TextButton.Font = Enum.Font.Gotham
                TextButton.Parent = v43.mutationList

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(0, 7)
                UICorner.Parent = TextButton
                TextButton.MouseButton1Click:Connect(function() -- line: 1015
                    -- upvalues: updateMutationState (copy), v81 (copy), t2 (copy)
                    t2[v81] = not t2[v81]
                    updateMutationState()
                end)
                t9[v81] = TextButton
                n4 += 36
            end

            v43.mutationList.CanvasSize = UDim2.fromOffset(0, n4 + 4)
            v43.assetTabButton.MouseButton1Click:Connect(function() -- line: 1025
                -- upvalues: applyGrantTabState (copy), updateSelectedAssetState (copy)
                applyGrantTabState("Assets")
                updateSelectedAssetState()
            end)
            v43.eggTabButton.MouseButton1Click:Connect(function() -- line: 1030
                -- upvalues: applyGrantTabState (copy), updateSelectedAssetState (copy)
                applyGrantTabState("Eggs")
                updateSelectedAssetState()
            end)
            v43.giveButton.MouseButton1Click:Connect(function() -- line: 1035
                -- upvalues: v43 (copy), Id (ref), t2 (copy), v3 (ref), v4 (ref), v5 (ref), Parse (copy), Remotes (copy)
                if not Id then
                    v43.statusLabel.Text = "Select an asset first."
                    v43.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146)

                    return
                end

                local t12 = {}

                for v82, v83 in pairs(t2) do
                    if v83 then
                        table.insert(t12, v82)
                    end
                end

                table.sort(t12)

                if v3 == "Eggs" then
                    local Text = v43.scaleInput.Text
                    local v84 = string.match(Text, "^%s*(.-)%s*$") or ""
                    local v85, v86

                    if v84 == "" then
                        v86 = true
                    else
                        v85 = Parse(v84)

                        if typeof(v85) ~= "number" then
                            v85 = tonumber(v84)
                        end

                        v86 = v85 ~= nil
                    end

                    if v86 then
                        local Text = v43.colorSeedInput.Text
                        local v87 = string.match(Text, "^%s*(.-)%s*$") or ""
                        local v88, v89

                        if v87 == "" then
                            v89 = true
                        else
                            v88 = Parse(v87)

                            if typeof(v88) ~= "number" then
                                v88 = tonumber(v87)
                            end

                            v89 = v88 ~= nil
                        end

                        if v89 then
                            local Text = v43.colorIndexInput.Text
                            local v90 = string.match(Text, "^%s*(.-)%s*$") or ""
                            local v91, v92

                            if v90 == "" then
                                v92 = true
                            else
                                v91 = Parse(v90)

                                if typeof(v91) ~= "number" then
                                    v91 = tonumber(v90)
                                end

                                v92 = v91 ~= nil
                            end

                            if v92 then
                                local t13 = {
                                    assetId = Id
                                }

                                if v85 ~= nil then
                                    t13.scale = v85
                                end

                                if v88 ~= nil then
                                    t13.colorSeed = v88
                                end

                                if v91 ~= nil then
                                    t13.colorIndex = v91
                                end

                                local Text = v43.eyeColorInput.Text
                                local v93 = string.match(Text, "^%s*(.-)%s*$") or ""

                                if v93 ~= "" then
                                    t13.eyeColor = v93
                                end

                                if #t12 > 0 then
                                    t13.mutations = t12
                                end

                                v43.statusLabel.Text = "Granting egg..."
                                v43.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236)
                                Remotes.StaffConsole.GrantSelfEgg:FireServer(t13)
                            else
                                v43.statusLabel.Text = "Enter a valid color index override."
                                v43.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146)
                            end
                        else
                            v43.statusLabel.Text = "Enter a valid color seed override."
                            v43.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146)
                        end
                    else
                        v43.statusLabel.Text = "Enter a valid scale override."
                        v43.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146)
                    end
                else
                    local Text = v43.scaleInput.Text
                    local v94 = string.match(Text, "^%s*(.-)%s*$") or ""
                    local v95, v96

                    if v94 == "" then
                        v96 = true
                    else
                        v95 = Parse(v94)

                        if typeof(v95) ~= "number" then
                            v95 = tonumber(v94)
                        end

                        v96 = v95 ~= nil
                    end

                    if v96 then
                        v43.statusLabel.Text = "Granting asset..."
                        v43.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236)

                        local t14 = {
                            assetId = Id,
                            rideable = v4,
                            instantMount = v5
                        }

                        if v95 ~= nil then
                            t14.scale = v95
                        end

                        if #t12 > 0 then
                            t14.mutations = t12
                        end

                        Remotes.StaffConsole.GrantSelfPet:FireServer(t14)
                    else
                        v43.statusLabel.Text = "Enter a valid scale override."
                        v43.statusLabel.TextColor3 = Color3.fromRGB(255, 146, 146)
                    end
                end
            end)
            attachSliderBehavior(v43.walkSpeedControl, function(p41) -- line: 1114
                -- upvalues: v43 (copy), v47 (ref), Remotes (copy)
                v47 = "WalkSpeed"

                local v98 = math.round(p41 / 0.1) * 0.1
                local v99 = string.format("%.1f", v98)

                if string.sub(v99, -2) == ".0" then
                    v99 = string.sub(v99, 1, #v99 - 2)
                end

                local v101 = ("Setting walk speed to %*..."):format(v99)

                v43.statusLabel.Text = v101
                v43.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236)
                Remotes.StaffConsole.WriteWalkSpeed:FireServer(p41)
            end)
            attachSliderBehavior(v43.speedPowerControl, function(p42) -- line: 1120
                -- upvalues: v43 (copy), v47 (ref), Remotes (copy)
                v47 = "SpeedPower"

                local v102 = ("Setting speed value to %*..."):format((string.format("%.0f", (math.round(p42)))))

                v43.statusLabel.Text = v102
                v43.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236)
                Remotes.StaffConsole.WriteSpeedPower:FireServer(p42)
            end)
            v43.resetButton.MouseButton1Click:Connect(function() -- line: 1126
                -- upvalues: v43 (copy), Remotes (copy)
                v43.statusLabel.Text = "Resetting your data..."
                v43.statusLabel.TextColor3 = Color3.fromRGB(226, 230, 236)
                Remotes.StaffConsole.WipeSelfProfile:FireServer()
            end)
            Remotes.StaffConsole.GrantVerdict.OnClientEvent:Connect(function(p43, p44, p45) -- line: 1132
                -- upvalues: setStatus (copy)
                setStatus(if not p45 or p45 == "" then p44 else ("%* UID: %*"):format(p44, p45), p43)
            end)
            Remotes.StaffConsole.WipeVerdict.OnClientEvent:Connect(function(p46, p47) -- line: 1139
                -- upvalues: setStatus (copy)
                setStatus(p47, p46)
            end)
            Remotes.StaffConsole.SpeedPowerVerdict.OnClientEvent:Connect(function(p48, p49) -- line: 1143
                -- upvalues: v43 (copy), v47 (ref), setStatus (copy), updateSliderVisual (copy), Save (copy), TreadmillUtil (copy)
                setStatus(p49, p48)

                if v47 == "SpeedPower" then
                    local v104 = Save.Await()

                    if v104 then
                        local v105 = TreadmillUtil.NormalizeSpeedPower(v104.SpeedPower)

                        updateSliderVisual(v43.speedPowerControl, v105)

                        local v106 = TreadmillUtil.SpeedPowerToWalkSpeed(v105)

                        updateSliderVisual(v43.walkSpeedControl, v106)
                    end
                elseif v47 == "WalkSpeed" then
                    local v107 = Save.Await()

                    if v107 then
                        local v108 = TreadmillUtil.NormalizeSpeedPower(v107.SpeedPower)

                        updateSliderVisual(v43.speedPowerControl, v108)
                    end
                end

                v47 = nil
            end)

            local function togglePanel() -- line: 1154
                -- upvalues: v43 (copy), v44 (ref)
                v44 = not v44
                v43.panel.Visible = v44
            end

            v43.toggleButton.MouseButton1Click:Connect(togglePanel)
            v43.closeButton.MouseButton1Click:Connect(togglePanel)
            UserInputService.InputBegan:Connect(function(p50, p51) -- line: 1162
                -- upvalues: v43 (copy), v44 (ref)
                if not p51 and p50.KeyCode == Enum.KeyCode.F9 then
                    v44 = not v44
                    v43.panel.Visible = v44
                end
            end)
            UserInputService.InputChanged:Connect(function(p52, _) -- line: 1171
                -- upvalues: v45 (ref), updateSliderVisual (copy)
                if v45 ~= nil and (p52.UserInputType == Enum.UserInputType.MouseMovement or p52.UserInputType == Enum.UserInputType.Touch) then
                    local v109 = v45
                    local v112 = math.clamp((p52.Position.X - v109.TrackButton.AbsolutePosition.X) / math.max(v109.TrackButton.AbsoluteSize.X, 1), 0, 1)

                    updateSliderVisual(v109, v109.MinValue + (v109.MaxValue - v109.MinValue) * v112)
                end
            end)
            UserInputService.InputEnded:Connect(function(p54, _) -- line: 1186
                -- upvalues: v45 (ref), v46 (ref)
                if v45 == nil or v46 == nil or p54.UserInputType ~= Enum.UserInputType.MouseButton1 and p54.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                local v114 = v45
                local v115 = v46

                v45 = nil
                v46 = nil
                v115(v114.CurrentValue)
            end)

            local v116 = Save.Await()

            if v116 then
                local v117 = TreadmillUtil.NormalizeSpeedPower(v116.SpeedPower)

                updateSliderVisual(v43.speedPowerControl, v117)

                local v118 = TreadmillUtil.SpeedPowerToWalkSpeed(v117)

                updateSliderVisual(v43.walkSpeedControl, v118)
            end

            Save.WatchFields("SpeedPower", function() -- line: 1206
                -- upvalues: v43 (copy), updateSliderVisual (copy), Save (copy), TreadmillUtil (copy)
                local v119 = Save.Await()

                if v119 then
                    local v120 = TreadmillUtil.NormalizeSpeedPower(v119.SpeedPower)

                    updateSliderVisual(v43.speedPowerControl, v120)
                end
            end)
            applyGrantTabState("Assets")
            updateSelectedAssetState()
            updateMutationState()
        end

        local function tryInitializeAdminPanel() -- line: 1214
            -- upvalues: v6 (ref), v8 (ref), setupAdminPanel (copy), Save (copy), v2 (copy)
            if v6 or not v8 or Save.Await() == nil then
                return
            end

            v6 = true
            v2:AtInfo():Log("Admin status confirmed, initializing admin panel")
            setupAdminPanel()
        end

        Remotes.StaffConsole.StaffVerdict.OnClientEvent:Connect(function(p56) -- line: 1223
            -- upvalues: v6 (ref), v7 (ref), v8 (ref), setupAdminPanel (copy), AdminPanelEntry (copy), Save (copy), v2 (copy)
            v7 = true
            v8 = p56
            AdminPanelEntry.SetAdminStatus(p56)

            if not p56 then
                v2:AtInfo():Log("Admin panel unavailable for this user")

                return
            end

            if not v6 and v8 then
                if Save.Await() == nil then
                    return
                end

                v6 = true
                v2:AtInfo():Log("Admin status confirmed, initializing admin panel")
                setupAdminPanel()
            end
        end)
        task.spawn(function() -- line: 1234
            -- upvalues: v7 (ref), Remotes (copy)
            while not v7 do
                Remotes.StaffConsole.ProbeStaffStatus:FireServer()
                task.wait(2)
            end
        end)
        task.spawn(function() -- line: 1241
            -- upvalues: v6 (ref), v8 (ref), setupAdminPanel (copy), Save (copy), v2 (copy)
            while Save.Await() == nil do
                task.wait(0.25)
            end

            if v6 or not v8 or Save.Await() == nil then
                return
            end

            v6 = true
            v2:AtInfo():Log("Admin status confirmed, initializing admin panel")
            setupAdminPanel()
        end)
    end
}
