-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

require(script.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(ReplicatedStorage.Shared.Modules.RaceTrackPath)
require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local v1 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local v2 = Color3.fromRGB(255, 70, 40)
local v3 = Color3.fromRGB(255, 170, 40)
local v4 = Color3.fromRGB(255, 130, 30)
local t1 = {}

local function stroke(p1, p2) -- line: 45
    local UIStroke = Instance.new("UIStroke")

    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke.Thickness = p2
    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.Parent = p1
end

local function label(p3, p4, p5, p6, p7) -- line: 54
    -- upvalues: v1 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p3
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Size = p5
    TextLabel.Position = p6
    TextLabel.FontFace = v1
    TextLabel.Text = p4
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Parent = p7

    return TextLabel
end

local function buildGui() -- line: 69
    -- upvalues: v2 (copy), v3 (copy), label (copy)
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "RaceWrongWay"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 7
    ScreenGui.Enabled = false

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Vignette"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://104574024062008"
    ImageLabel.ImageColor3 = v2
    ImageLabel.ImageTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Parent = ScreenGui

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Banner"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.27)
    CanvasGroup.Size = UDim2.fromScale(0.62, 0.2)
    CanvasGroup.GroupTransparency = 1
    CanvasGroup.Parent = ScreenGui

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 3.6
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    UIAspectRatioConstraint.Parent = CanvasGroup

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = CanvasGroup

    local Frame = Instance.new("Frame")

    Frame.Name = "Plate"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.42)
    Frame.Size = UDim2.fromScale(0.94, 0.62)
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.Parent = CanvasGroup

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.22, 0)
    UICorner.Parent = Frame

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(v2, v3)
    UIGradient.Rotation = 90
    UIGradient.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke.Thickness = 0.03
    UIStroke.Color = Color3.fromRGB(80, 10, 0)
    UIStroke.Parent = Frame

    local v5 = label("Title", "WRONG WAY!", UDim2.fromScale(0.86, 0.72), UDim2.fromScale(0.5, 0.5), Frame)
    local UIStroke2 = Instance.new("UIStroke")

    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke2.Thickness = 0.09
    UIStroke2.Color = Color3.new(0, 0, 0)
    UIStroke2.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke2.Parent = v5

    local v6 = label("Hint", "TURN AROUND", UDim2.fromScale(0.6, 0.3), UDim2.fromScale(0.5, 0.88), CanvasGroup)

    v6.TextColor3 = Color3.fromRGB(255, 236, 200)

    local UIStroke3 = Instance.new("UIStroke")

    UIStroke3.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke3.Thickness = 0.12
    UIStroke3.Color = Color3.new(0, 0, 0)
    UIStroke3.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke3.Parent = v6

    return ScreenGui, ImageLabel, CanvasGroup, UIScale
end

local function buildArrow() -- line: 137
    -- upvalues: v3 (copy), v4 (copy)
    local Model = Instance.new("Model")

    Model.Name = "RaceWrongWayArrow"

    local t2 = {}

    for i = 1, 3 do
        for _, v7 in { -1, 1 } do
            local Part = Instance.new("Part")

            Part.Name = ("Chevron%*"):format(i)
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Material = Enum.Material.Neon
            Part.Color = v4
            Part.Size = Vector3.new(0.75, 0.45, 2.6)
            Part:SetAttribute("Index", i)
            Part:SetAttribute("Side", v7)
            Part.Parent = Model
            table.insert(t2, Part)
        end
    end

    local Highlight = Instance.new("Highlight")

    Highlight.FillTransparency = 0.6
    Highlight.FillColor = v3
    Highlight.OutlineColor = Color3.new(1, 1, 1)
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Parent = Model

    return Model, t2
end

local function flat(p8, p9) -- line: 168
    local v8 = p8 - p9 * p8:Dot(p9)

    return if v8.Magnitude > 0.001 then v8.Unit else nil
end

function t1.Run(p10, p11, p12, p13) -- line: 173
    -- upvalues: GuiService (copy), RunService (copy), SoundService (copy), Workspace (copy), MountRace (copy), LocalPlayer (copy), buildGui (copy), buildArrow (copy)
    local v9, v10, v11, v12 = buildGui()

    p10:Add(v9)
    v9.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local v13, v14 = buildArrow()

    p10:Add(v13)
    v13.Parent = nil

    local v15 = p13:Project(p12.Root.Position, 0, p13.Length, p13.Length)
    local n1 = 0
    local n2 = 0
    local n3 = 0
    local v16 = false
    local n4 = 0
    local Unit
    local n5 = 0

    local function show(p14) -- line: 194
        -- upvalues: v9 (copy), v12 (copy), v13 (copy), v16 (ref), GuiService (copy), SoundService (copy), Workspace (copy), MountRace (copy)
        if p14 == v16 then
            return
        end

        v16 = p14

        if p14 then
            v9.Enabled = true
            v13.Parent = Workspace.CurrentCamera
            v12.Scale = GuiService.ReducedMotionEnabled and 1 or 1.35
            SoundService:PlayLocalSound(MountRace.Sounds.CountdownTick)
        end
    end

    p10:Connect(RunService.RenderStepped, function(p15) -- line: 207
        -- upvalues: p11 (copy), p12 (copy), p13 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (ref), n1 (ref), n2 (ref), n3 (ref), v16 (ref), n4 (ref), Unit (ref), n5 (ref), GuiService (copy), SoundService (copy), Workspace (copy), MountRace (copy), LocalPlayer (copy)
        local Root = p12.Root

        v15 = p13:Project(Root.Position, v15, 30, 80)

        local Up = p11.Up
        local LookVector = p13:FrameAt(v15 + 25).LookVector
        local v18 = LookVector - Up * LookVector:Dot(Up)
        local Unit2 = if v18.Magnitude > 0.001 then v18.Unit else nil

        if p11.StickMinRatio ~= nil then
            n5 = os.clock() + 1
        end

        local v19 = Unit2 ~= nil and os.clock() >= n5 and not p11:IsHeld() and LocalPlayer:GetAttribute(MountRace.PlayerAttributes.FinishPlace) == nil
        local Unit3, v20, v21

        if not v19 or Unit2 == nil then
            v20 = false
            v21 = false
        else
            local AssemblyLinearVelocity = Root.AssemblyLinearVelocity
            local v22 = AssemblyLinearVelocity - Up * AssemblyLinearVelocity:Dot(Up)

            if v22.Magnitude > 0.001 then
                Unit3 = v22.Unit
            end

            local Magnitude = Root.AssemblyLinearVelocity.Magnitude

            v20 = Unit3 ~= nil and Magnitude > 12 and Unit3:Dot(Unit2) < -0.3

            local Heading = p11.Heading
            local v23 = Heading - Up * Heading:Dot(Up)
            local Unit = if v23.Magnitude > 0.001 then v23.Unit else nil

            v21 = Unit ~= nil and Magnitude <= 12 and Unit:Dot(Unit2) < -0.5
        end

        if v20 then
            n1 += p15
        else
            n1 = 0
        end

        if v21 then
            n2 += p15
        else
            n2 = 0
        end

        if v20 or v21 then
            n3 = 0
        else
            n3 += p15
        end

        if v19 then
            if n1 >= 0.7 or n2 >= 1.5 then
                if v16 ~= true then
                    v16 = true
                    v9.Enabled = true
                    v13.Parent = Workspace.CurrentCamera
                    v12.Scale = GuiService.ReducedMotionEnabled and 1 or 1.35
                    SoundService:PlayLocalSound(MountRace.Sounds.CountdownTick)
                end
            elseif n3 >= 0.4 and v16 ~= false then
                v16 = false
            end
        elseif v16 ~= false then
            v16 = false
        end

        local v25 = if v16 then 1 else 0

        n4 += (v25 - n4) * math.min(1, p15 * 8)

        if not (n4 < 0.01) or v16 then
            local elapsed = os.clock()
            local ReducedMotionEnabled = GuiService.ReducedMotionEnabled
            local v29 = if ReducedMotionEnabled then 0.5 else (math.sin(elapsed * 6) + 1) / 2

            v10.ImageTransparency = 1 - n4 * (v29 * 0.35 + 0.55)
            v11.GroupTransparency = 1 - n4
            v12.Scale = v12.Scale + ((if ReducedMotionEnabled then 0 else v29 * 0.04) + 1 - v12.Scale) * math.min(1, p15 * 10)

            if Unit2 ~= nil then
                local v36 = (Unit or Unit2):Lerp(Unit2, (math.min(1, p15 * 7)))

                if v36.Magnitude > 0.001 then
                    Unit2 = v36.Unit
                end

                Unit = Unit2

                local v37 = if ReducedMotionEnabled then 0 else math.sin(elapsed * 3) * 0.5
                local v39 = Root.Position + Up * (v37 + 6)
                local v40 = CFrame.lookAt(v39, v39 + Unit, Up) * CFrame.Angles(0.4886921905584123, 0, 0)
                local v41 = if ReducedMotionEnabled then 0 else elapsed * 1.6 % 1
                local v42 = n4 * 0.65 + 0.35

                for _, v43 in v14 do
                    local Index = v43:GetAttribute("Index")
                    local Side = v43:GetAttribute("Side")
                    local v44 = (Index - 1 + v41) % 3
                    local v45 = (v44 - 1) * 2.4
                    local v48 = math.sin(3.141592653589793 * math.clamp(v44 / 2.5, 0, 1))
                    local v50 = Vector3.new(0, 0, -v45)
                    local v52 = Vector3.new(Side * 0.6691306063588582, 0, 0.7431448254773942)
                    local v53 = v50 + v52 * 2.6 * v42 / 2

                    v43.Size = Vector3.new(0.75, 0.45, 2.6) * v42
                    v43.CFrame = v40 * CFrame.lookAt(v53, v53 + v52)
                    v43.Transparency = 1 - n4 * (v48 * 0.75 + 0.25)
                end
            end
        else
            n4 = 0
            v9.Enabled = false
            v13.Parent = nil
            Unit = nil
        end
    end)
end

return t1
