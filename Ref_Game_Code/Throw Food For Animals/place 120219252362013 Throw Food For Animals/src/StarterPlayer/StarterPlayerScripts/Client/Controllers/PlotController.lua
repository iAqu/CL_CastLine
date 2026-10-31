-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local StandsConfig = require(ReplicatedStorage.Config.StandsConfig)
local FenceConfig = require(ReplicatedStorage.Config.FenceConfig)
local NumberFormat = require(ReplicatedStorage.Shared.NumberFormat)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Boosts = require(ReplicatedStorage.Shared.Boosts)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local HUDController = require(Parent.HUDController)
local TrainingController = require(Parent.TrainingController)
local ShopController = require(Parent.ShopController)
local ClientState = require(Parent.ClientState)
local CameraRig = require(Parent.CameraRig)
local ScreenFX = require(Parent.ScreenFX)
local UpgradeSign = require(Parent.UpgradeSign)
local t1 = {
    Ready = false
}
local Colors = UITheme.Colors
local LocalPlayer = Players.LocalPlayer
local PlotIndex, v1
local t2 = {}

t2[1] = nil

local Folder, BillboardGui, SurfaceGui

local function buildProps() -- line: 61
    -- upvalues: TweenService (copy), ReplicatedStorage (copy), GameConfig (copy), TrainingController (copy), ShopController (copy), t1 (copy), t2 (copy), Folder (ref)
    local PlotTemplates = ReplicatedStorage:WaitForChild("PlotTemplates")

    Folder = Instance.new("Folder")
    Folder.Name = "LocalPlotProps"

    local Folder2 = Folder

    Folder2.Parent = workspace

    local FoodShop = PlotTemplates:FindFirstChild("FoodShop")

    if FoodShop then
        local clone = FoodShop:Clone()
        local ActivationCircle = clone:FindFirstChild("ActivationCircle")

        if ActivationCircle then
            clone.PrimaryPart = ActivationCircle
        end

        local Pivot = clone:GetPivot()

        clone:PivotTo(CFrame.new(t2[1] + GameConfig.Plot.ShopCircleOffset) * (Pivot - Pivot.Position))

        for _, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
            end
        end

        clone.Parent = Folder

        if ActivationCircle then
            ActivationCircle.CanCollide = false
            ShopController.BindCircle(ActivationCircle)
            task.spawn(function() -- line: 83
                -- upvalues: ActivationCircle (copy), TweenService (copy)
                while ActivationCircle.Parent do
                    TweenService:Create(ActivationCircle, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        Transparency = 0.55
                    }):Play()
                    task.wait(1.2)
                    TweenService:Create(ActivationCircle, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        Transparency = 0.85
                    }):Play()
                    task.wait(1.2)
                end
            end)
        end
    end

    local TrainingSpot = PlotTemplates:FindFirstChild("TrainingSpot")

    if TrainingSpot then
        local Model = Instance.new("Model")

        Model.Name = "TrainingArea"

        local clone = TrainingSpot:Clone()

        clone.Parent = Model
        Model.PrimaryPart = clone

        local _CFrame = clone.CFrame

        Model:PivotTo(CFrame.new(t2[1] + GameConfig.Plot.TrainingSpotOffset) * (_CFrame - _CFrame.Position))

        for _, descendant in ipairs(Model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
            end
        end

        Model.Parent = Folder
        clone.CanCollide = false
        TrainingController.BindSpot(clone)

        local UpgradeButton = clone:FindFirstChild("UpgradeButton")

        if UpgradeButton then
            t1.SetupUpgradeButton(UpgradeButton)
        end
    end

    t1.BuildUpgradeSign()
    t1.Ready = true
end

local function sparkleBurst(p1, p2, p3, p4) -- line: 125
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Transparency = 1
    Part.Position = p1
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(p2, Color3.new(1, 1, 1))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, p4 or 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.2)
    ParticleEmitter.Speed = NumberRange.new(5, 12)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p3 or 30)
    task.delay(2, function() -- line: 144
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

function t1.BuildUpgradeSign() -- line: 147
    -- upvalues: FenceConfig (copy), Remotes (copy), DataController (copy), UIKit (copy), Sounds (copy), HUDController (copy), ClientState (copy), CameraRig (copy), UpgradeSign (copy), Colors (copy), LocalPlayer (copy), v1 (ref), t2 (copy), Folder (ref), SurfaceGui (ref), sparkleBurst (copy)
    local v2 = v1.Position.Y + v1.Size.Y / 2
    local v3 = t2[1] + FenceConfig.SignOffset
    local v4 = Vector3.new(v3.X, v2, v3.Z)
    local v5 = CFrame.lookAt(v4, v4 + Vector3.new(0, 0, -1))
    local v6, v7 = UpgradeSign.BuildModel(v5)

    v6.Parent = Folder

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local PlotUpgradeSign = PlayerGui:FindFirstChild("PlotUpgradeSign")

    if PlotUpgradeSign then
        PlotUpgradeSign:Destroy()
    end

    local SurfaceGui2 = Instance.new("SurfaceGui")

    SurfaceGui2.Name = "PlotUpgradeSign"
    SurfaceGui2.Adornee = v7
    SurfaceGui2.Face = Enum.NormalId.Front
    SurfaceGui2.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    SurfaceGui2.PixelsPerStud = 70
    SurfaceGui2.LightInfluence = 0
    SurfaceGui2.MaxDistance = 70
    SurfaceGui2.ResetOnSpawn = false
    SurfaceGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SurfaceGui2.Parent = PlayerGui
    SurfaceGui = SurfaceGui2

    local v8 = false
    local v9

    v9 = UpgradeSign.BuildFace(SurfaceGui2, function() -- line: 175
        -- upvalues: v2 (copy), v7 (copy), v8 (ref), v9 (ref), FenceConfig (copy), Remotes (copy), UIKit (copy), Sounds (copy), HUDController (copy), ClientState (copy), CameraRig (copy), Colors (copy), v1 (ref), sparkleBurst (copy)
        if v8 or ClientState.Busy then
            return
        end

        v8 = true

        local Plot_UpgradeFence = Remotes.Invoke("Plot_UpgradeFence")

        v8 = false

        if Plot_UpgradeFence.Ok then
            local v10 = FenceConfig.Styles[FenceConfig.StyleFor(Plot_UpgradeFence.Level)] or FenceConfig.Styles.Wood
            local v11 = FenceConfig.GrowFor(Plot_UpgradeFence.Level) > FenceConfig.GrowFor(Plot_UpgradeFence.Level - 1)

            Sounds.Play("PurchaseSuccess")
            Sounds.Play("LevelUp", {
                Volume = 0.5,
                Pitch = 1.05
            })
            CameraRig.PunchFOV(6, 0.05, 0.45)
            UIKit.Punch(v9.Root, 0.12, 0.5)
            sparkleBurst(v7.Position, Colors.YellowA, 40, 1.2)

            local v12 = (v1:GetAttribute("FenceGrow") or 0) * FenceConfig.SegmentLength
            local v13 = v1.Position.Z + v1.Size.Z / 2 + v12
            local v14 = v10.Rail or Colors.YellowA

            for i = -2, 2 do
                task.delay((i + 2) * 0.12 + 0.35, function() -- line: 193
                    -- upvalues: v13 (copy), i (copy), v14 (copy), v2 (copy), v1 (ref), sparkleBurst (copy)
                    sparkleBurst(Vector3.new(v1.Position.X + i * 10, v2 + 3, v13), v14, 25, 1.4)
                end)
            end

            local v17 = "Plot upgraded! It holds " .. (Plot_UpgradeFence.Slots or FenceConfig.SlotsFor(Plot_UpgradeFence.Level)) .. " animals now"

            if not v11 and v10.Name then
                v17 ..= " - " .. v10.Name .. "!"
            end

            HUDController.Notify(v17, "Success")
        elseif Plot_UpgradeFence.Reason == "Money" then
            Sounds.Play("PurchaseFail")
            UIKit.Punch(v9.Button, 0.15, 0.35)
        elseif Plot_UpgradeFence.Reason == "TooFar" then
            HUDController.Notify("Walk up to the sign to upgrade!", "Info")
        end
    end)

    local function refresh() -- line: 208
        -- upvalues: v6 (copy), v9 (ref), FenceConfig (copy), DataController (copy), UpgradeSign (copy)
        local v18 = DataController:Get("FenceLevel") or 0
        local v19 = FenceConfig.Get(v18 + 1)

        UpgradeSign.ApplyStyle(v6, FenceConfig.StyleFor(v18))
        v9.Show({
            Current = FenceConfig.SlotsFor(v18),
            Next = v19 and v19.Slots,
            Price = v19 and v19.Price,
            CanBuy = v19 ~= nil and (DataController:Get("Money") or 0) >= v19.Price
        })
    end

    DataController:Observe("FenceLevel", refresh)
    DataController:Observe("Money", refresh)
    refresh()
end

local function teleportTo(p5, p6) -- line: 229
    -- upvalues: Sounds (copy), ScreenFX (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return false
    end

    Sounds.Play("CameraWhoosh", {
        Volume = 0.4,
        Pitch = 1.15
    })
    ScreenFX.FadeOut(Color3.new(1, 1, 1), 0.16)
    Character:PivotTo(p5)
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    workspace.CurrentCamera.CFrame = CFrame.lookAt(p5.Position - p5.LookVector * 11 + Vector3.new(0, 6, 0), p6)
    ScreenFX.FadeIn(0.3)

    return true
end

function t1.TeleportToShop() -- line: 244
    -- upvalues: GameConfig (copy), t2 (copy), Folder (ref), teleportTo (copy)
    if not t2[1] then
        return false
    end

    local v20 = t2[1] + GameConfig.Plot.ShopCircleOffset
    local FoodShop = Folder and Folder:FindFirstChild("FoodShop")
    local Position = FoodShop and FoodShop:GetBoundingBox().Position or v20 + Vector3.new(0, 0, -6)
    local v22 = Vector3.new(v20.X, v20.Y + 3, v20.Z)

    return (teleportTo(CFrame.lookAt(v22, (Vector3.new(Position.X, v22.Y, Position.Z))), Position))
end

function t1.TeleportToStand() -- line: 254
    -- upvalues: TweenService (copy), GameConfig (copy), Sounds (copy), Colors (copy), t2 (copy), teleportTo (copy)
    if not t2[1] then
        return false
    end

    local v23 = t2[1] + GameConfig.Plot.UpgradeButtonOffset
    local v24 = t2[1] + GameConfig.Plot.TrainingSpotOffset
    local v27 = Vector3.new(v23.X - v24.X, 0, v23.Z - v24.Z)
    local v28 = v23 + (v27.Magnitude > 0.1 and v27.Unit or Vector3.new(0, 0, -1)) * 3.8 + Vector3.new(0, 3, 0)
    local v29 = teleportTo(CFrame.lookAt(v28, (Vector3.new(v23.X, v28.Y, v23.Z))), v23 + Vector3.new(0, 4, 0))

    if v29 then
        for i = 0, 2 do
            task.delay(i * 0.35 + 0.25, function() -- line: 265
                -- upvalues: v23 (copy), TweenService (copy), Colors (copy)
                local Part = Instance.new("Part")

                Part.Shape = Enum.PartType.Cylinder
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.Material = Enum.Material.Neon
                Part.Color = Colors.YellowA
                Part.Transparency = 0.2
                Part.Size = Vector3.new(0.15, 3, 3)
                Part.CFrame = CFrame.new(v23 + Vector3.new(0, 0.3, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                Part.Parent = workspace
                TweenService:Create(Part, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = Vector3.new(0.15, 11, 11),
                    Transparency = 1
                }):Play()
                task.delay(0.8, function() -- line: 279
                    -- upvalues: Part (copy)
                    Part:Destroy()
                end)
            end)
        end

        Sounds.Play("Pop", {
            Volume = 0.4
        })
    end

    return v29
end

function t1.SetupUpgradeButton(p7) -- line: 287
    -- upvalues: RunService (copy), GameConfig (copy), StandsConfig (copy), NumberFormat (copy), Remotes (copy), Boosts (copy), DataController (copy), UIKit (copy), Sounds (copy), HUDController (copy), ClientState (copy), CameraRig (copy), Colors (copy), LocalPlayer (copy), t2 (copy), BillboardGui (ref)
    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.ActionText = "Upgrade"
    ProximityPrompt.ObjectText = "Pull-Up Stand"
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.MaxActivationDistance = 9
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Parent = p7

    local Part = Instance.new("Part")

    Part.Name = "PriceAnchor"
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CFrame = CFrame.new(p7.Position + Vector3.new(0, 5.2, 0))
    Part.Parent = p7

    local BillboardGui2 = Instance.new("BillboardGui")

    BillboardGui2.Name = "PriceBillboard"
    BillboardGui2.Size = UDim2.fromScale(7.5, 3.4)
    BillboardGui2.MaxDistance = 90
    BillboardGui2.LightInfluence = 0
    BillboardGui2.Adornee = Part
    BillboardGui2.Parent = Part
    BillboardGui = BillboardGui2

    local v30 = UIKit.Frame({
        Name = "Holder",
        Transparency = 1,
        Parent = BillboardGui2,
        Size = UDim2.fromScale(1, 1)
    })
    local v31 = UIKit.Frame({
        Name = "PriceHolder",
        Transparency = 1,
        ZIndex = 2,
        Parent = v30,
        Size = UDim2.fromScale(1, 0.46),
        Position = UDim2.fromScale(0.5, 0.42),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local v32 = UIKit.Text({
        Name = "Price",
        Text = "$0",
        Stroke = 4,
        ZIndex = 3,
        Parent = v31,
        Size = UDim2.fromScale(1, 1),
        Color = Color3.new(1, 1, 1)
    })
    local v33 = UIKit.Gradient(v32, Colors.GreenA, Colors.GreenB, 90)
    local v34 = UIKit.Text({
        Name = "Xp",
        Text = "",
        Stroke = 3,
        ZIndex = 2,
        Parent = v30,
        Size = UDim2.fromScale(1, 0.22),
        Position = UDim2.fromScale(0.5, 0.79),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.Xp
    })
    local v35 = UIKit.Text({
        Name = "Arrow",
        Text = "▼",
        Stroke = 3,
        ZIndex = 2,
        Parent = v30,
        Size = UDim2.fromScale(0.18, 0.2),
        Position = UDim2.fromScale(0.5, 1.02),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.YellowA
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Parent = v31

    local v36 = false

    local function refresh() -- line: 328
        -- upvalues: ProximityPrompt (copy), v31 (copy), v32 (copy), v33 (copy), v34 (copy), v35 (copy), v36 (ref), StandsConfig (copy), NumberFormat (copy), Boosts (copy), DataController (copy), UIKit (copy), Colors (copy), LocalPlayer (copy)
        local v37 = DataController:Get("Stand") or 0
        local v38 = StandsConfig.Get(v37 + 1)
        local v39 = DataController:Get("Money") or 0

        if v38 then
            ProximityPrompt.Enabled = true
            ProximityPrompt.ActionText = v37 == 0 and "Buy" or "Upgrade"
            ProximityPrompt.ObjectText = v38.Name
            v32.Text = NumberFormat.Money(v38.Price)

            local v40 = v38.Price <= v39

            v33.Color = v40 and ColorSequence.new(Colors.GreenA, Colors.GreenB) or ColorSequence.new(Colors.RedA, Colors.RedB)

            if v40 and not v36 then
                UIKit.Punch(v31, 0.25, 0.5)
            end

            v36 = v40
            v35.Visible = v40
            v34.Text = Boosts.XpText(v38.XpPerRep, LocalPlayer, " XP / rep")
        else
            v32.Text = StandsConfig.GetAny(v37 + 1) and "SOON" or "MAX"
            v33.Color = ColorSequence.new(Colors.YellowA, Colors.YellowB)

            local v42 = StandsConfig.GetAny(v37) or StandsConfig.Get(StandsConfig.Count())

            v34.Text = v42 and Boosts.XpText(v42.XpPerRep, LocalPlayer, " XP / rep") or ""
            v35.Visible = false
            v36 = false
            ProximityPrompt.Enabled = false
        end
    end

    RunService.RenderStepped:Connect(function() -- line: 356
        -- upvalues: BillboardGui2 (copy), v35 (copy), UIScale (copy), v36 (ref)
        if BillboardGui2.Enabled and v36 then
            local elapsed = os.clock()

            v35.Position = UDim2.fromScale(0.5, math.sin(elapsed * 5) * 0.05 + 1.02)
            UIScale.Scale = math.sin(elapsed * 3.2) * 0.04 + 1
        end
    end)
    v34.RichText = true
    LocalPlayer:GetAttributeChangedSignal("XpMultiplier"):Connect(refresh)
    DataController:Observe("Stand", refresh)
    DataController:Observe("Money", refresh)
    ProximityPrompt.Triggered:Connect(function() -- line: 367
        -- upvalues: v31 (copy), GameConfig (copy), StandsConfig (copy), Remotes (copy), UIKit (copy), Sounds (copy), HUDController (copy), ClientState (copy), CameraRig (copy), Colors (copy), t2 (copy)
        if not ClientState.Busy and not ClientState.OfflineOpen then
            local Stand_Upgrade = Remotes.Invoke("Stand_Upgrade")

            if Stand_Upgrade.Ok then
                Sounds.Play("PurchaseSuccess")
                Sounds.Play("LevelUp", {
                    Volume = 0.35,
                    Pitch = 1.2
                })
                CameraRig.PunchFOV(5, 0.05, 0.4)
                UIKit.Punch(v31, 0.3, 0.6)

                local v46 = StandsConfig.Get(Stand_Upgrade.NewIndex)

                if Stand_Upgrade.NewIndex > 1 then
                    HUDController.Notify("Upgraded to " .. (v46 and v46.Name or "a new stand") .. "!", "Success")
                end

                local v47 = t2[1] + GameConfig.Plot.PullUpBarOffset
                local Part = Instance.new("Part")

                Part.Anchored = true
                Part.CanCollide = false
                Part.Transparency = 1
                Part.Position = v47
                Part.Parent = workspace

                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                ParticleEmitter.Color = ColorSequence.new(Colors.YellowA, Color3.new(1, 1, 1))
                ParticleEmitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.2, 1.2),
                    NumberSequenceKeypoint.new(1, 0)
                })
                ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.2)
                ParticleEmitter.Speed = NumberRange.new(6, 14)
                ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
                ParticleEmitter.LightEmission = 1
                ParticleEmitter.Rate = 0
                ParticleEmitter.Parent = Part
                ParticleEmitter:Emit(45)
                task.delay(2, function() -- line: 399
                    -- upvalues: Part (copy)
                    Part:Destroy()
                end)
            elseif Stand_Upgrade.Reason == "Money" then
                Sounds.Play("PurchaseFail")
                UIKit.Punch(v31, 0.2, 0.4)
            end
        end
    end)
end

local Part, v48

local function getEquippedAnimalTool() -- line: 414
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character then
        local Tool = Character:FindFirstChildOfClass("Tool")

        if Tool and (Tool:GetAttribute("AnimalId") or Tool:GetAttribute("EggKey")) then
            return Tool
        end
    end

    return nil
end

local function isPlotFloor(p8) -- line: 423
    -- upvalues: v1 (ref)
    if p8 and v1 then
        if p8 == v1 then
            return true
        end

        if p8.Name == "FloorExtension" then
            return (p8:IsDescendantOf(v1))
        end

        return false
    end

    return false
end

local function raycastMouse() -- line: 428
    -- upvalues: UserInputService (copy), LocalPlayer (copy), Folder (ref), Part (ref)
    local CurrentCamera = workspace.CurrentCamera
    local MouseLocation = UserInputService:GetMouseLocation()
    local v49 = CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y)
    local v50 = RaycastParams.new()

    v50.FilterType = Enum.RaycastFilterType.Exclude

    local t4 = {}

    if LocalPlayer.Character then
        table.insert(t4, LocalPlayer.Character)
    end

    if Folder then
        table.insert(t4, Folder)
    end

    if Part then
        table.insert(t4, Part)
    end

    v50.FilterDescendantsInstances = t4

    return workspace:Raycast(v49.Origin, v49.Direction * 300, v50)
end

local function ensureMarker() -- line: 442
    -- upvalues: UIKit (copy), Colors (copy), Part (ref), v48 (ref)
    if Part then
        return Part
    end

    Part = Instance.new("Part")
    Part.Name = "PlacementMarker"

    local Part2 = Part

    Part2.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(0.15, 5, 5)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false

    local Part3 = Part

    Part3.Material = Enum.Material.Neon

    local Part4 = Part

    Part4.Color = Color3.fromRGB(120, 255, 120)
    Part.Transparency = 0.5

    local Part5 = Part

    Part5.Parent = workspace

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "HatchHint"
    BillboardGui.Size = UDim2.fromScale(7, 1.6)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Enabled = false
    BillboardGui.Parent = Part
    v48 = UIKit.Text({
        Text = "CLICK TO HATCH!",
        Stroke = 3,
        Parent = BillboardGui,
        Size = UDim2.fromScale(1, 1),
        Color = Colors.YellowA
    })

    return Part
end

local function updateMarker() -- line: 468
    -- upvalues: ClientState (copy), LocalPlayer (copy), v1 (ref), BillboardGui (ref), SurfaceGui (ref), Part (ref), v48 (ref), raycastMouse (copy), ensureMarker (copy)
    if BillboardGui then
        local BillboardGui2 = BillboardGui

        if ClientState.Busy ~= nil then
            BillboardGui2.Enabled = ClientState.Busy == "Training"
        else
            BillboardGui2.Enabled = true
        end
    end

    if SurfaceGui then
        SurfaceGui.Enabled = ClientState.Busy == nil
    end

    local Character = LocalPlayer.Character
    local Tool

    if Character then
        Tool = Character:FindFirstChildOfClass("Tool")

        if not (Tool and (Tool:GetAttribute("AnimalId") or Tool:GetAttribute("EggKey"))) then
            Tool = nil
        end
    end

    local v51, v52, v53, v54

    if not Tool or ClientState.Busy then
        v54 = true
    elseif v1 then
        v51 = raycastMouse()
        v52 = ensureMarker()
        v53 = Tool:GetAttribute("EggKey") ~= nil
        v54 = false
    else
        v54 = true
    end

    if not v54 then
        local HatchHint = v52:FindFirstChild("HatchHint")

        if HatchHint then
            if v53 then
                if v51 ~= nil then
                    local Instance = v51.Instance

                    if Instance and v1 then
                        if Instance == v1 then
                            HatchHint.Enabled = true
                        elseif Instance.Name == "FloorExtension" then
                            HatchHint.Enabled = Instance:IsDescendantOf(v1)
                        else
                            HatchHint.Enabled = false
                        end
                    else
                        HatchHint.Enabled = false
                    end
                else
                    HatchHint.Enabled = false
                end
            else
                HatchHint.Enabled = v53
            end
        end

        if v48 and v53 then
            v48.Position = UDim2.fromScale(0, math.sin(os.clock() * 4) * 0.08)
        end

        if v51 then
            local Instance = v51.Instance

            if Instance and v1 and (Instance == v1 or Instance.Name == "FloorExtension" and Instance:IsDescendantOf(v1)) then
                v52.CFrame = CFrame.new(v51.Position + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                v52.Transparency = math.sin(os.clock() * 5) * 0.15 + 0.45
                v52.Color = v53 and Color3.fromRGB(255, 220, 90) or Color3.fromRGB(120, 255, 120)
            else
                v52.CFrame = CFrame.new(v51.Position + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
                v52.Transparency = 0.7
                v52.Color = Color3.fromRGB(255, 90, 90)
            end
        else
            v52.Transparency = 1
        end
    else
        if not Part then
            return
        end

        Part.Transparency = 1

        local HatchHint = Part:FindFirstChild("HatchHint")

        if HatchHint then
            HatchHint.Enabled = false
        end
    end
end

local function tryPlace() -- line: 503
    -- upvalues: Remotes (copy), Sounds (copy), LocalPlayer (copy), v1 (ref), raycastMouse (copy)
    local Character = LocalPlayer.Character
    local Tool

    if Character then
        Tool = Character:FindFirstChildOfClass("Tool")

        if not (Tool and (Tool:GetAttribute("AnimalId") or Tool:GetAttribute("EggKey"))) then
            Tool = nil
        end
    end

    if Tool then
        local v58 = raycastMouse()

        if v58 then
            local _Instance = v58.Instance

            if _Instance and v1 and (_Instance == v1 or _Instance.Name == "FloorExtension" and _Instance:IsDescendantOf(v1)) then
                local EggKey = Tool:GetAttribute("EggKey")

                if EggKey then
                    local v59 = Remotes.Invoke("Egg_Place", EggKey, v58.Position)

                    if not v59.Ok and v59.Reason ~= "Full" and v59.Reason ~= "Outside" then
                        Sounds.Play("PurchaseFail", {
                            Volume = 0.4
                        })
                    end
                else
                    if not Remotes.Invoke("Plot_PlaceAnimal", Tool:GetAttribute("AnimalId"), v58.Position).Ok then
                        return false
                    end

                    Sounds.Play("Pop", {
                        Volume = 0.6
                    })
                    Sounds.Play("GroundSmash", {
                        Volume = 0.25,
                        Pitch = 1.4
                    })

                    local Part = Instance.new("Part")

                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.Transparency = 1
                    Part.Position = v58.Position
                    Part.Parent = workspace

                    local ParticleEmitter = Instance.new("ParticleEmitter")

                    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
                    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(230, 230, 230))
                    ParticleEmitter.Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 2.5)
                    })
                    ParticleEmitter.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.4),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                    ParticleEmitter.Lifetime = NumberRange.new(0.4, 0.8)
                    ParticleEmitter.Speed = NumberRange.new(4, 9)
                    ParticleEmitter.SpreadAngle = Vector2.new(80, 80)
                    ParticleEmitter.Rate = 0
                    ParticleEmitter.Parent = Part
                    ParticleEmitter:Emit(18)
                    task.delay(1.5, function() -- line: 538
                        -- upvalues: Part (copy)
                        Part:Destroy()
                    end)
                end

                return true
            end
        end
    end

    return false
end

local t5 = {
    ScreenFX = true,
    Freecam = true
}

local function mouseOverGui() -- line: 549
    -- upvalues: UserInputService (copy), LocalPlayer (copy), t5 (copy)
    local v60 = UserInputService:GetMouseLocation() - game:GetService("GuiService"):GetGuiInset()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

    if PlayerGui then
        for _, v61 in ipairs(PlayerGui:GetGuiObjectsAtPosition(v60.X, v60.Y)) do
            local LayerCollector = v61:FindFirstAncestorWhichIsA("LayerCollector")

            if LayerCollector and LayerCollector:IsA("ScreenGui") and not t5[LayerCollector.Name] and (v61.BackgroundTransparency < 0.95 or v61:IsA("GuiButton") or v61:IsA("ViewportFrame")) then
                return true
            end
        end
    end

    return false
end

local function onClick() -- line: 564
    -- upvalues: ClientState (copy), tryPlace (copy), mouseOverGui (copy)
    if not (ClientState.Busy or ClientState.OfflineOpen) and not mouseOverGui() then
        tryPlace()
    end
end

function t1.GetPlotPart() -- line: 574
    -- upvalues: v1 (ref)
    return v1
end

function t1.Init() -- line: 578
    -- upvalues: UserInputService (copy), RunService (copy), ClientState (copy), LocalPlayer (copy), PlotIndex (ref), v1 (ref), t2 (copy), buildProps (copy), updateMarker (copy), tryPlace (copy), mouseOverGui (copy)
    task.spawn(function() -- line: 579
        -- upvalues: LocalPlayer (copy), PlotIndex (ref), v1 (ref), t2 (copy), buildProps (copy)
        local PlotIndex2 = LocalPlayer:GetAttribute("PlotIndex")

        while not PlotIndex2 do
            LocalPlayer:GetAttributeChangedSignal("PlotIndex"):Wait()
            PlotIndex2 = LocalPlayer:GetAttribute("PlotIndex")
        end

        PlotIndex = PlotIndex2
        v1 = workspace:WaitForChild("Plots"):WaitForChild((tostring(PlotIndex2)))
        t2[1] = v1.Position
        buildProps()
    end)
    UserInputService.InputBegan:Connect(function(p9, p10) -- line: 591
        -- upvalues: ClientState (copy), tryPlace (copy), mouseOverGui (copy)
        if not p10 and (p9.UserInputType == Enum.UserInputType.MouseButton1 or p9.UserInputType == Enum.UserInputType.Touch) and not ClientState.Busy then
            if ClientState.OfflineOpen or mouseOverGui() then
                return
            end

            tryPlace()
        end
    end)
    RunService.RenderStepped:Connect(updateMarker)
end

return t1
