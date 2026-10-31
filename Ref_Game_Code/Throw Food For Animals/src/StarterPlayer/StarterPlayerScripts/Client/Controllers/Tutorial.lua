-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local FoodsConfig = require(ReplicatedStorage.Config.FoodsConfig)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local ClientState = require(Parent.ClientState)
local Sounds = require(Parent.Sounds)
local ShopController = require(Parent.ShopController)
local TrainingController = require(Parent.TrainingController)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = Color3.fromRGB(255, 205, 0)
local ScreenGui, TextLabel, ImageLabel, UIScale, BillboardGui, Part, Beam, Attachment, Attachment2, v2, v3

local function plotInfo() -- line: 73
    -- upvalues: LocalPlayer (copy)
    local PlotIndex = LocalPlayer:GetAttribute("PlotIndex")
    local Plots = workspace:FindFirstChild("Plots")
    local v4 = PlotIndex and Plots and Plots:FindFirstChild((tostring(PlotIndex)))

    if v4 then
        return v4, v4.Position, v4.Position.Y + v4.Size.Y / 2
    end

    return nil
end

local function animalCounts() -- line: 81
    -- upvalues: DataController (copy)
    local n1 = 0
    local n2 = 0

    for _, v5 in pairs(DataController:Get("Animals") or {}) do
        if v5.Placed then
            n1 += 1
        else
            n2 += 1
        end
    end

    return n1, n2
end

local function holdingAnimal() -- line: 89
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")

    return Tool ~= nil and Tool:GetAttribute("AnimalId") ~= nil
end

local function isDone() -- line: 95
    -- upvalues: DataController (copy)
    return DataController:GetPath("Tutorial.Done") == true
end

local function ownsBoughtFood() -- line: 100
    -- upvalues: FoodsConfig (copy), DataController (copy)
    for i = 2, FoodsConfig.Count() do
        if DataController:GetPath("OwnedFoods." .. i) == true then
            return true
        end
    end

    return false
end

local function currentStep() -- line: 108
    -- upvalues: DataController (copy), animalCounts (copy), ownsBoughtFood (copy)
    if not DataController:IsReady() then
        return nil
    end

    if DataController:GetPath("Tutorial.Done") == true then
        return "Done"
    end

    local v6, v7 = animalCounts()

    if v6 + v7 == 0 then
        return "Throw"
    end

    if v6 == 0 then
        return "Place"
    end

    if (DataController:Get("Stand") or 0) < 1 then
        return "Bar"
    end

    if DataController:GetPath("Tutorial.Trained") ~= true then
        return "Train"
    end

    if ownsBoughtFood() then
        return "ThrowAgain"
    end

    return "Shop"
end

local function setText(p1) -- line: 124
    -- upvalues: TweenService (copy), Sounds (copy), TextLabel (ref), v2 (ref)
    if p1 == v2 then
        return
    end

    v2 = p1

    if not p1 then
        TextLabel.Visible = false

        return
    end

    TextLabel.Text = p1
    TextLabel.Visible = true
    TextLabel.TextTransparency = 1
    TextLabel:FindFirstChild("TextStroke").Transparency = 1
    TweenService:Create(TextLabel, TweenInfo.new(0.25), {
        TextTransparency = 0
    }):Play()
    TweenService:Create(TextLabel:FindFirstChild("TextStroke"), TweenInfo.new(0.25), {
        Transparency = 0
    }):Play()
    Sounds.Play("Pop", {
        Volume = 0.3
    })
end

local function setScreenArrow(p2) -- line: 141
    -- upvalues: TweenService (copy), ScreenGui (ref), ImageLabel (ref), UIScale (ref)
    if not p2 then
        ImageLabel.Visible = false

        return
    end

    local AbsolutePosition = ScreenGui.AbsolutePosition
    local v10 = math.abs((math.sin(os.clock() * 5))) * 12
    local ImageLabel2 = ImageLabel

    ImageLabel2.Position = UDim2.fromOffset(p2.X - AbsolutePosition.X, p2.Y - AbsolutePosition.Y - v10)

    if not ImageLabel.Visible then
        ImageLabel.Visible = true
        UIScale.Scale = 0.3
        TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end

local function buttonTop(p3) -- line: 157
    return if p3 and p3.Visible then p3.AbsolutePosition + Vector2.new(p3.AbsoluteSize.X / 2, -4) else nil
end

local function buildBeam() -- line: 162
    -- upvalues: v1 (copy), Beam (ref), Attachment (ref), Attachment2 (ref)
    Attachment2 = Instance.new("Attachment")
    Attachment2.Name = "TutorialBeamTo"

    local Attachment3 = Attachment2

    Attachment3.Parent = workspace.Terrain
    Attachment = Instance.new("Attachment")
    Attachment.Name = "TutorialBeamFrom"

    local Attachment4 = Attachment

    Attachment4.Parent = workspace.Terrain
    Beam = Instance.new("Beam")
    Beam.Name = "TutorialBeam"
    Beam.Attachment0 = Attachment2
    Beam.Attachment1 = Attachment
    Beam.Texture = "rbxassetid://74885007861450"

    local Beam2 = Beam

    Beam2.TextureMode = Enum.TextureMode.Static
    Beam.TextureLength = 2.6
    Beam.TextureSpeed = -0.9
    Beam.Width0 = 2.6
    Beam.Width1 = 2.6
    Beam.FaceCamera = true
    Beam.Segments = 1
    Beam.CurveSize0 = 0
    Beam.CurveSize1 = 0
    Beam.LightInfluence = 0
    Beam.LightEmission = 0.5
    Beam.Brightness = 2.5

    local Beam3 = Beam

    Beam3.Color = ColorSequence.new(v1)

    local Beam4 = Beam

    Beam4.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.85, 0),
        NumberSequenceKeypoint.new(1, 0.6)
    })
    Beam.Enabled = false

    local Beam5 = Beam

    Beam5.Parent = workspace.Terrain
end

local function setBeam(p4, p5) -- line: 195
    -- upvalues: Beam (ref), Attachment (ref), Attachment2 (ref)
    if not p4 then
        Beam.Enabled = false

        return
    end

    Attachment.WorldPosition = p4
    Attachment2.WorldPosition = p5
    Beam.Enabled = true
end

local function setMarker(p6) -- line: 206
    -- upvalues: BillboardGui (ref), Part (ref)
    if not p6 then
        BillboardGui.Enabled = false

        return
    end

    local Part2 = Part

    Part2.CFrame = CFrame.new(p6 + Vector3.new(0, math.abs((math.sin(os.clock() * 4))) * 1.2, 0))
    BillboardGui.Enabled = true
end

local function playerMiddle() -- line: 216
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v14 = Character

    if Character then
        v14 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    return if v14 and Character and not (Character.Health <= 0) then v14.Position else nil
end

local function guideTo(p7, p8) -- line: 226
    -- upvalues: LocalPlayer (copy), BillboardGui (ref), Part (ref), Beam (ref), Attachment (ref), Attachment2 (ref)
    local Character = LocalPlayer.Character
    local v15 = Character

    if Character then
        v15 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    local Position = if v15 and Character and not (Character.Health <= 0) then v15.Position else nil

    if not Position then
        Beam.Enabled = false
        BillboardGui.Enabled = false

        return
    end

    local v17 = p7 + Vector3.new(0, p8 or 4, 0)

    if v17 then
        local Part2 = Part

        Part2.CFrame = CFrame.new(v17 + Vector3.new(0, math.abs((math.sin(os.clock() * 4))) * 1.2, 0))
        BillboardGui.Enabled = true
    else
        BillboardGui.Enabled = false
    end

    if (Vector3.new(Position.X, 0, Position.Z) - Vector3.new(p7.X, 0, p7.Z)).Magnitude < 4.5 then
        Beam.Enabled = false
    else
        local v22 = p7 + Vector3.new(0, 1.3, 0)

        Attachment.WorldPosition = Position
        Attachment2.WorldPosition = v22
        Beam.Enabled = true
    end
end

local function clearWorld() -- line: 242
    -- upvalues: BillboardGui (ref), Beam (ref)
    Beam.Enabled = false
    BillboardGui.Enabled = false
end

local function floorAt(_, p10) -- line: 251
    -- upvalues: plotInfo (copy)
    local _, v23, v24 = plotInfo()

    return (Vector3.new(v23.X + p10.X, v24, v23.Z + p10.Z))
end

local function throwTarget() -- line: 256
    local StarterArea = workspace:FindFirstChild("StarterArea")
    local CrossLine = StarterArea and StarterArea:FindFirstChild("CrossLine")

    if not CrossLine then
        return nil
    end

    local v27 = StarterArea.Position.Y + StarterArea.Size.Y / 2

    return (Vector3.new(CrossLine.Position.X, v27, CrossLine.Position.Z - 2))
end

local function hotbarPosition() -- line: 266
    -- upvalues: Parent (copy)
    local _require = require
    local Inventory = Parent.Inventory
    local ok, result = pcall(_require, Inventory)
    local v29 = ok and result.GetAnimalSlot() or nil

    return if v29 and v29.Visible then v29.AbsolutePosition + Vector2.new(v29.AbsoluteSize.X / 2, -4) else nil
end

local function firstFoodAffordable() -- line: 276
    -- upvalues: FoodsConfig (copy), DataController (copy)
    local v30 = FoodsConfig.Get(2)

    return v30 ~= nil and (DataController:Get("Money") or 0) >= v30.Price
end

local function step() -- line: 281
    -- upvalues: GameConfig (copy), FoodsConfig (copy), Parent (copy), DataController (copy), ClientState (copy), ShopController (copy), TrainingController (copy), LocalPlayer (copy), ScreenGui (ref), TextLabel (ref), ImageLabel (ref), BillboardGui (ref), Beam (ref), v2 (ref), v3 (ref), plotInfo (copy), currentStep (copy), setText (copy), setScreenArrow (copy), guideTo (copy)
    local v31 = currentStep()

    ClientState.TutorialActive = v31 ~= nil and v31 ~= "Done"

    if ClientState.TutorialActive then
        ScreenGui.Enabled = true

        local Busy = ClientState.Busy

        if Busy == "Training" then
            Beam.Enabled = false
            BillboardGui.Enabled = false

            local v33 = TrainingController.GetStopButton()

            if v33 and TrainingController.GetTrainingTime() > 10 then
                setText("Press STOP")
                setScreenArrow(v33.AbsolutePosition + Vector2.new(v33.AbsoluteSize.X / 2, -6))
            else
                if v2 ~= nil then
                    v2 = nil
                    TextLabel.Visible = false
                end

                ImageLabel.Visible = false
            end

            v3 = nil
        else
            local OfflineOpen = if not Busy then ClientState.OfflineOpen else nil

            if Busy or OfflineOpen then
                if v2 ~= nil then
                    v2 = nil
                    TextLabel.Visible = false
                end

                ImageLabel.Visible = false
                Beam.Enabled = false
                BillboardGui.Enabled = false
            elseif plotInfo() then
                if v31 ~= "Train" then
                    v3 = nil
                end

                if v31 == "Throw" then
                    if v2 ~= nil then
                        v2 = nil
                        TextLabel.Visible = false
                    end

                    ImageLabel.Visible = false

                    local StarterArea = workspace:FindFirstChild("StarterArea")
                    local CrossLine = StarterArea and StarterArea:FindFirstChild("CrossLine")
                    local v35

                    if CrossLine then
                        local v36 = StarterArea.Position.Y + StarterArea.Size.Y / 2

                        v35 = Vector3.new(CrossLine.Position.X, v36, CrossLine.Position.Z - 2)
                    end

                    if v35 then
                        guideTo(v35, 4.5)
                    else
                        Beam.Enabled = false
                        BillboardGui.Enabled = false
                    end
                elseif v31 == "Place" then
                    local Character = LocalPlayer.Character
                    local Tool = Character and Character:FindFirstChildOfClass("Tool")

                    if Tool ~= nil and Tool:GetAttribute("AnimalId") ~= nil then
                        setText("Place your animal")
                        ImageLabel.Visible = false

                        local _, v38, v39 = plotInfo()

                        guideTo(Vector3.new(v38.X, v39, v38.Z), 3.5)
                    else
                        setText("Pick your animal")

                        local _require = require
                        local Inventory = Parent.Inventory
                        local ok, result = pcall(_require, Inventory)
                        local v40 = ok and result.GetAnimalSlot() or nil

                        setScreenArrow(if not (v40 and v40.Visible) then nil else v40.AbsolutePosition + Vector2.new(v40.AbsoluteSize.X / 2, -4))
                        Beam.Enabled = false
                        BillboardGui.Enabled = false
                    end
                elseif v31 == "Bar" then
                    setText("Buy a pull-up bar")
                    ImageLabel.Visible = false

                    local UpgradeButtonOffset = GameConfig.Plot.UpgradeButtonOffset
                    local _, v42, v43 = plotInfo()

                    guideTo(Vector3.new(v42.X + UpgradeButtonOffset.X, v43, v42.Z + UpgradeButtonOffset.Z), 9.5)
                elseif v31 == "Train" then
                    ImageLabel.Visible = false
                    v3 = v3 or os.clock()

                    if os.clock() - v3 >= 2 then
                        setText("Step on the circle")

                        local TrainingSpotOffset = GameConfig.Plot.TrainingSpotOffset
                        local _, v46, v47 = plotInfo()

                        guideTo(Vector3.new(v46.X + TrainingSpotOffset.X, v47, v46.Z + TrainingSpotOffset.Z), 4)
                    else
                        if v2 ~= nil then
                            v2 = nil
                            TextLabel.Visible = false
                        end

                        Beam.Enabled = false
                        BillboardGui.Enabled = false
                    end
                elseif v31 == "Shop" then
                    local v50 = FoodsConfig.Get(2)

                    if v50 ~= nil and (DataController:Get("Money") or 0) >= v50.Price then
                        if ClientState.ShopOpen then
                            setText("Buy new food")
                            Beam.Enabled = false
                            BillboardGui.Enabled = false

                            local v51 = ShopController.GetVisibleButton(2)

                            setScreenArrow(if not (v51 and v51.Visible) then nil else v51.AbsolutePosition + Vector2.new(v51.AbsoluteSize.X / 2, -4))
                        else
                            setText("Buy new food")
                            ImageLabel.Visible = false

                            local ShopCircleOffset = GameConfig.Plot.ShopCircleOffset
                            local _, v53, v54 = plotInfo()

                            guideTo(Vector3.new(v53.X + ShopCircleOffset.X, v54, v53.Z + ShopCircleOffset.Z), 5)
                        end
                    else
                        if v2 ~= nil then
                            v2 = nil
                            TextLabel.Visible = false
                        end

                        ImageLabel.Visible = false
                        Beam.Enabled = false
                        BillboardGui.Enabled = false
                    end
                elseif v31 == "ThrowAgain" then
                    setText("Throw again")

                    if ClientState.ShopOpen then
                        Beam.Enabled = false
                        BillboardGui.Enabled = false

                        local v57 = ShopController.GetCloseButton()

                        setScreenArrow(if not (v57 and v57.Visible) then nil else v57.AbsolutePosition + Vector2.new(v57.AbsoluteSize.X / 2, -4))
                    else
                        ImageLabel.Visible = false

                        local StarterArea = workspace:FindFirstChild("StarterArea")
                        local CrossLine = StarterArea and StarterArea:FindFirstChild("CrossLine")
                        local v59

                        if CrossLine then
                            local v60 = StarterArea.Position.Y + StarterArea.Size.Y / 2

                            v59 = Vector3.new(CrossLine.Position.X, v60, CrossLine.Position.Z - 2)
                        end

                        if v59 then
                            guideTo(v59, 4.5)
                        else
                            Beam.Enabled = false
                            BillboardGui.Enabled = false
                        end
                    end
                end
            else
                Beam.Enabled = false
                BillboardGui.Enabled = false
            end
        end
    else
        if v2 ~= nil then
            v2 = nil
            TextLabel.Visible = false
        end

        ImageLabel.Visible = false
        Beam.Enabled = false
        BillboardGui.Enabled = false
        ScreenGui.Enabled = v31 == nil
    end
end

function t1.OnShopOpened() -- line: 391
    -- upvalues: ShopController (copy), currentStep (copy)
    if currentStep() == "Shop" then
        ShopController.Focus(2)
    end
end

local function build() -- line: 397
    -- upvalues: UITheme (copy), PlayerGui (copy), v1 (copy), ScreenGui (ref), TextLabel (ref), ImageLabel (ref), UIScale (ref), BillboardGui (ref), Part (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Tutorial"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = false
    ScreenGui.DisplayOrder = 142

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Instruction"
    TextLabel.BackgroundTransparency = 1

    local TextLabel2 = TextLabel

    TextLabel2.Size = UDim2.fromScale(0.6, 0.06)

    local TextLabel3 = TextLabel

    TextLabel3.Position = UDim2.fromScale(0.5, 0.03)

    local TextLabel4 = TextLabel

    TextLabel4.AnchorPoint = Vector2.new(0.5, 0)

    local TextLabel5 = TextLabel

    TextLabel5.FontFace = UITheme.Font
    TextLabel.TextScaled = true

    local TextLabel6 = TextLabel

    TextLabel6.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Text = ""
    TextLabel.Visible = false

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Name = "TextStroke"
    UIStroke.Thickness = 3
    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.Parent = TextLabel

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 40
    UITextSizeConstraint.Parent = TextLabel
    TextLabel.Parent = ScreenGui
    ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "PointArrow"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://74885007861450"
    ImageLabel.ImageColor3 = v1
    ImageLabel.Rotation = 180

    local ImageLabel2 = ImageLabel

    ImageLabel2.Size = UDim2.fromScale(0.09, 0.09)

    local ImageLabel3 = ImageLabel

    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY

    local ImageLabel4 = ImageLabel

    ImageLabel4.AnchorPoint = Vector2.new(0.5, 1)
    ImageLabel.ZIndex = 5
    ImageLabel.Visible = false
    ImageLabel.Parent = ScreenGui
    UIScale = Instance.new("UIScale")
    UIScale.Parent = ImageLabel
    Part = Instance.new("Part")
    Part.Name = "TutorialMarker"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)

    local Part2 = Part

    Part2.Parent = workspace
    BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "TutorialMarker"

    local BillboardGui2 = BillboardGui

    BillboardGui2.Size = UDim2.fromScale(3.2, 3.2)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 500
    BillboardGui.Adornee = Part
    BillboardGui.Enabled = false
    BillboardGui.Parent = ScreenGui

    local ImageLabel5 = Instance.new("ImageLabel")

    ImageLabel5.BackgroundTransparency = 1
    ImageLabel5.Size = UDim2.fromScale(1, 1)
    ImageLabel5.Image = "rbxassetid://74885007861450"
    ImageLabel5.ImageColor3 = v1
    ImageLabel5.Rotation = 180
    ImageLabel5.Parent = BillboardGui
end

function t1.IsActive() -- line: 471
    -- upvalues: ClientState (copy)
    return ClientState.TutorialActive
end

function t1.Init() -- line: 475
    -- upvalues: RunService (copy), ShopController (copy), t1 (copy), buildBeam (copy), clearWorld (copy), step (copy), build (copy)
    build()
    buildBeam()
    ShopController.Opened:Connect(t1.OnShopOpened)

    local result

    RunService.RenderStepped:Connect(function() -- line: 480
        -- upvalues: result (ref), clearWorld (copy), step (copy)
        local ok, result2 = pcall(step)

        if not ok then
            if result2 ~= result then
                result = result2
                warn("[Tutorial] " .. tostring(result2))
            end

            pcall(clearWorld)
        end
    end)
end

return t1
