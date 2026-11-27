-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameConfig = require(Shared.GameConfig)
local Fish = require(Shared.Data.Fish)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local FishModels = require(Shared.FishModels)
local PlotFrame = require(Shared:WaitForChild("PlotFrame"))
local TutorialSteps = require(Shared.TutorialSteps)
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local Toasts = require(script.Parent.Toasts)
local Pad = require(script.Parent.Pad)
local t1 = {
    Uid = nil
}
local LocalPlayer = Players.LocalPlayer
local Colors = UIKit.Colors
local v1 = Color3.fromRGB(255, 225, 60)
local v2 = Color3.fromRGB(255, 160, 20)
local v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
local v14 = CFrame.new()
local v15
local n1 = 0
local v16

local function cameraDistance() -- line: 50
    local CurrentCamera = workspace.CurrentCamera

    return (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude
end

local Magnitude

game:GetService("RunService").RenderStepped:Connect(function() -- line: 56
    -- upvalues: v15 (ref), v16 (ref), Magnitude (ref)
    local CurrentCamera = workspace.CurrentCamera

    if v15 == nil and v16 == nil and CurrentCamera.CameraType == Enum.CameraType.Custom and CurrentCamera.CameraSubject ~= nil and CurrentCamera.CameraSubject:IsDescendantOf(workspace) then
        local CurrentCamera = workspace.CurrentCamera

        Magnitude = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude
    end
end)

local function zoomBack(p1) -- line: 63
    -- upvalues: LocalPlayer (copy), n1 (ref), v16 (ref)
    n1 += 1

    local v17 = n1
    local CurrentCamera = workspace.CurrentCamera
    local Magnitude = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude
    local v21 = math.clamp(p1[3] or p1[2], p1[1], p1[2])

    if Magnitude <= v21 + 0.5 then
        LocalPlayer.CameraMinZoomDistance = p1[1]
        LocalPlayer.CameraMaxZoomDistance = p1[2]
    else
        v16 = p1
        task.spawn(function() -- line: 74
            -- upvalues: p1 (copy), v17 (copy), Magnitude (copy), v21 (copy), LocalPlayer (copy), n1 (ref), v16 (ref)
            local elapsed = os.clock()

            while n1 == v17 do
                local v23 = math.min(1, (os.clock() - elapsed) / 0.45)
                local v24 = Magnitude + (v21 - Magnitude) * (1 - (1 - v23) ^ 3)

                LocalPlayer.CameraMinZoomDistance = math.min(p1[1], v24)
                LocalPlayer.CameraMaxZoomDistance = v24

                if v23 >= 1 then
                    break
                end

                game:GetService("RunService").RenderStepped:Wait()
            end

            if n1 ~= v17 then
                return
            end

            v16 = nil
            LocalPlayer.CameraMinZoomDistance = p1[1]
            LocalPlayer.CameraMaxZoomDistance = p1[2]
        end)
    end
end

local v26 = nil
local n2 = 0
local n3 = 0
local Part, BillboardGui
local t2 = {}

local function getChar() -- line: 98
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v27, v28

    if Character then
        v27 = Character:FindFirstChild("HumanoidRootPart")
        v28 = Character:FindFirstChildOfClass("Humanoid")
    else
        v28 = Character
        v27 = Character
    end

    if v27 and v28 and v28.Health > 0 then
        return Character, v27, v28
    end

    return nil, nil, nil
end

local function findShoulders(p2) -- line: 108
    local t3 = {}

    for _, v29 in ipairs({ "Right", "Left" }) do
        local v30 = p2:FindFirstChild(v29 .. "UpperArm")
        local v31 = v30 and v30:FindFirstChild(v29 .. "Shoulder")

        if v31 then
            table.insert(t3, {
                r15 = true,
                joint = v31
            })
        end
    end

    if #t3 == 0 then
        local Torso = p2:FindFirstChild("Torso")
        local v32 = Torso and Torso:FindFirstChild("Right Shoulder")
        local v33 = Torso and Torso:FindFirstChild("Left Shoulder")

        if v32 then
            table.insert(t3, {
                sign = 1,
                joint = v32
            })
        end

        if v33 then
            table.insert(t3, {
                sign = -1,
                joint = v33
            })
        end
    end

    return t3
end

local function capacity() -- line: 130
    -- upvalues: GameConfig (copy), DataClient (copy)
    return GameConfig.CAPACITY_LEVELS[DataClient.Get("CapacityLevel") or 1] or GameConfig.CAPACITY_LEVELS[1]
end

local function plotFull() -- line: 134
    -- upvalues: GameConfig (copy), DataClient (copy)
    return #(DataClient.Get("Placed") or {}) >= (GameConfig.CAPACITY_LEVELS[DataClient.Get("CapacityLevel") or 1] or GameConfig.CAPACITY_LEVELS[1])
end

local function ownPlot() -- line: 138
    -- upvalues: LocalPlayer (copy)
    local PlotId = LocalPlayer:GetAttribute("PlotId")
    local World = workspace:FindFirstChild("World")
    local Plots = World and World:FindFirstChild("Plots")
    local v34, v35

    if Plots and type(PlotId) == "number" then
        local v36 = Plots:FindFirstChild("Plot" .. PlotId)

        if v36 then
            v34 = v36
            v35 = true
        else
            v35 = false
        end
    else
        v35 = false
    end

    if not v35 then
        v34 = nil
    end

    return v34
end

local function ownWater() -- line: 146
    -- upvalues: ownPlot (copy)
    local v37 = ownPlot()
    local Pond = v37 and v37:FindFirstChild("Pond")
    local Water = Pond and Pond:FindFirstChild("Water")

    return if Water and Water:IsA("BasePart") then Water else nil
end

local function pointOnPond(p3) -- line: 154
    -- upvalues: ownPlot (copy)
    local v38 = ownPlot()
    local Pond = v38 and v38:FindFirstChild("Pond")
    local Water = Pond and Pond:FindFirstChild("Water")

    if not (Water and Water:IsA("BasePart")) then
        Water = nil
    end

    local CurrentCamera = workspace.CurrentCamera

    if not Water or not CurrentCamera then
        return nil
    end

    local v39 = CurrentCamera:ScreenPointToRay(p3.X, p3.Y)
    local v40 = Water.Position.Y + Water.Size.Y / 2

    if math.abs(v39.Direction.Y) < 1E-04 then
        return nil
    end

    local v41 = (v40 - v39.Origin.Y) / v39.Direction.Y

    if v41 <= 0 then
        return nil
    end

    local v42 = v39.Origin + v39.Direction * v41
    local v43 = Water.CFrame:PointToObjectSpace(v42)

    return if math.abs(v43.X) <= Water.Size.X / 2 + 2.5 and math.abs(v43.Z) <= Water.Size.Z / 2 + 2.5 then v42 else nil
end

local PlotId

local function setOwnerTag(p4, p5) -- line: 181
    local World = workspace:FindFirstChild("World")
    local Plots = World and World:FindFirstChild("Plots")
    local v46 = Plots and Plots:FindFirstChild("Plot" .. p4)
    local OwnerTag = v46 and v46:FindFirstChild("OwnerTag")
    local BillboardGui = OwnerTag and OwnerTag:FindFirstChildOfClass("BillboardGui")

    if BillboardGui then
        BillboardGui.Enabled = p5
    end
end

local function setHotbarGlow(p6) -- line: 192
    -- upvalues: HUD (copy)
    if HUD.HotbarGlow then
        HUD.HotbarGlow(p6)
    end
end

local function showMarker(p7) -- line: 198
    -- upvalues: Part (ref), BillboardGui (ref), t2 (copy)
    if not Part then
        return
    end

    BillboardGui.Enabled = p7

    for _, v47 in ipairs(t2) do
        v47.Transparency = p7 and 0.2 or 1
    end
end

function t1.Drop() -- line: 207
    -- upvalues: ContextActionService (copy), Remotes (copy), HUD (copy), t1 (copy), v4 (ref), v12 (ref), v13 (ref), v15 (ref), zoomBack (copy), v26 (ref), n2 (ref), Part (ref), BillboardGui (ref), t2 (copy), PlotId (ref), setOwnerTag (copy)
    if t1.Uid then
        t1.Uid = nil
        Remotes.HoldFish:FireServer(nil)

        if PlotId then
            setOwnerTag(PlotId, true)
            PlotId = nil
        end

        v13 = nil
        v26 = nil
        n2 = 0

        if v15 then
            local v48 = v15

            v15 = nil
            zoomBack(v48)
        end

        if v12 then
            v12:Destroy()
            v12 = nil
        end

        v4.Visible = false

        if Part then
            BillboardGui.Enabled = false

            for _, v49 in ipairs(t2) do
                v49.Transparency = 1
            end
        end

        if HUD.HotbarGlow then
            HUD.HotbarGlow(false)
        end

        ContextActionService:UnbindAction("PlaceHeldFish")
        HUD.RefreshPrompts()
    end
end

local function splash(p8) -- line: 237
    -- upvalues: UIKit (copy)
    for i = 0, 1 do
        local Part = Instance.new("Part")

        Part.Name = "PlaceSplash"
        Part.Shape = Enum.PartType.Cylinder
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.Color = Color3.new(1, 1, 1)
        Part.Transparency = 0.25
        Part.Size = Vector3.new(0.12, 2, 2)
        Part.CFrame = CFrame.new(p8 + Vector3.new(0, 0.12, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        Part.Parent = workspace
        task.delay(i * 0.12, function() -- line: 253
            -- upvalues: Part (copy), i (copy), UIKit (copy)
            UIKit.tween(Part, 0.5, {
                Transparency = 1,
                Size = Vector3.new(0.12, i * 4 + 11, i * 4 + 11)
            })
            task.delay(0.55, function() -- line: 255
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end)
    end
end

function t1.Place(p9) -- line: 263
    -- upvalues: RunService (copy), Remotes (copy), GameConfig (copy), UIKit (copy), DataClient (copy), Toasts (copy), t1 (copy), v12 (ref), v15 (ref), ownPlot (copy), splash (copy)
    local Uid = t1.Uid

    if Uid then
        if #(DataClient.Get("Placed") or {}) >= (GameConfig.CAPACITY_LEVELS[DataClient.Get("CapacityLevel") or 1] or GameConfig.CAPACITY_LEVELS[1]) then
            t1.Drop()
            Toasts.Show("error", "Your plot is full! Sell or pick up a fish first.")

            local MyFish = UIKit.Windows.MyFish

            if MyFish then
                MyFish.Open()
            end
        else
            local v52 = ownPlot()
            local Pond = v52 and v52:FindFirstChild("Pond")
            local v53 = Pond and Pond:FindFirstChild("Water")

            if not (v53 and v53:IsA("BasePart")) then
                v53 = nil
            end

            v53 = p9 or v53 and v53.Position + Vector3.new(0, v53.Size.Y / 2, 0)

            local v55 = v12
            local v56 = v15 == nil

            v12 = nil
            t1.Drop()

            if v55 and v53 and v56 then
                local Pivot = v55:GetPivot()
                local v57 = CFrame.new(v53 + Vector3.new(0, 0.6, 0)) * (Pivot - Pivot.Position)
                local Magnitude = (v53 - Pivot.Position).Magnitude
                local v59 = math.clamp(Magnitude * 0.3, 1.5, 70)
                local v61 = math.clamp(Magnitude / 150, 0.3, 1.1)
                local spawn = task.spawn
                local v62 = v53

                spawn(function() -- line: 291
                    -- upvalues: v55 (copy), Pivot (copy), v57 (copy), v59 (copy), v61 (copy), v62 (copy), RunService (copy), UIKit (copy), splash (copy)
                    local elapsed = os.clock()

                    while v55.Parent do
                        local v64 = math.min((os.clock() - elapsed) / v61, 1)

                        v55:PivotTo(Pivot:Lerp(v57, v64) + Vector3.new(0, math.sin(v64 * 3.141592653589793) * v59, 0))

                        if v64 >= 1 then
                            break
                        end

                        RunService.RenderStepped:Wait()
                    end

                    v55:Destroy()
                    splash(v62)
                    UIKit.sound("Splash")
                end)
            else
                if v55 then
                    v55:Destroy()
                end

                if v53 then
                    splash(v53)
                end

                UIKit.sound("Splash")
            end

            task.spawn(function() -- line: 314
                -- upvalues: Uid (copy), Remotes (copy)
                local function v68() -- line: 315
                    -- upvalues: Uid (copy), Remotes (copy)
                    Remotes.PlaceFish:InvokeServer(Uid)
                end

                pcall(v68)
            end)
        end
    end
end

local function sellText(p10) -- line: 321
    -- upvalues: Roll (copy), NumberFormat (copy)
    return "SELL  " .. NumberFormat.money(Roll.sellValue(p10.fishId, p10.variant, p10.size, p10.event, p10.base))
end

function t1.Sell() -- line: 327
    -- upvalues: RunService (copy), Remotes (copy), Roll (copy), NumberFormat (copy), UIKit (copy), Toasts (copy), t1 (copy), v9 (ref), v10 (ref), v12 (ref), v26 (ref), n2 (ref), n3 (ref)
    local Uid = t1.Uid
    local v69 = v26

    if Uid and v69 and not (os.clock() - n3 < 0.5) then
        if not (Roll.thrill(v69.fishId, v69.variant, v69.size) >= 2 and os.clock() - n2 > 2.5) then
            local v70 = v12

            v12 = nil
            t1.Drop()

            if v70 then
                local Pivot = v70:GetPivot()
                local Scale = v70:GetScale()

                task.spawn(function() -- line: 349
                    -- upvalues: v70 (copy), Pivot (copy), Scale (copy), RunService (copy)
                    local elapsed = os.clock()

                    while v70.Parent do
                        local v72 = math.min((os.clock() - elapsed) / 0.22, 1)

                        v70:ScaleTo(Scale * math.max(1 - v72, 0.05))
                        v70:PivotTo(Pivot + Vector3.new(0, v72 * 2, 0))

                        if v72 >= 1 then
                            break
                        end

                        RunService.RenderStepped:Wait()
                    end

                    v70:Destroy()
                end)
            end

            task.spawn(function() -- line: 363
                -- upvalues: Uid (copy), Remotes (copy), Toasts (copy)
                local function v75() -- line: 364
                    -- upvalues: Uid (copy), Remotes (copy)
                    return Remotes.SellFish:InvokeServer(Uid)
                end

                local ok, result = pcall(v75)

                if not ok or not result then
                    Toasts.Show("error", "Couldn't sell that fish")
                end
            end)
        else
            n2 = os.clock()
            v10.Text = "TAP AGAIN TO SELL"
            UIKit.pop(v9, 1.12)
            task.delay(2.5, function() -- line: 336
                -- upvalues: Uid (copy), v69 (copy), Roll (copy), NumberFormat (copy), t1 (copy), v10 (ref), v26 (ref), n2 (ref)
                if t1.Uid == Uid and v26 == v69 and os.clock() - n2 >= 2.45 then
                    v10.Text = "SELL  " .. NumberFormat.money(Roll.sellValue(v69.fishId, v69.variant, v69.size, v69.event, v69.base))
                end
            end)
        end
    end
end

local function inTutorial() -- line: 374
    -- upvalues: TutorialSteps (copy), DataClient (copy)
    return (DataClient.Get("TutorialStep") or TutorialSteps.DONE) < TutorialSteps.DONE
end

local function groundY(p11, p12) -- line: 379
    local v77 = RaycastParams.new()

    v77.FilterType = Enum.RaycastFilterType.Exclude
    v77.FilterDescendantsInstances = { p12 }

    local v78 = workspace:Raycast(p11 + Vector3.new(0, 8, 0), Vector3.new(0, -40, 0), v77)

    return v78 and v78.Position.Y
end

function t1.Show(p13, p14) -- line: 389
    -- upvalues: ContextActionService (copy), Remotes (copy), Fish (copy), Variants (copy), Sizes (copy), Roll (copy), NumberFormat (copy), FishModels (copy), PlotFrame (copy), TutorialSteps (copy), UIKit (copy), DataClient (copy), HUD (copy), t1 (copy), LocalPlayer (copy), v4 (ref), v5 (ref), v6 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), n1 (ref), v16 (ref), Magnitude (ref), v26 (ref), n2 (ref), n3 (ref), findShoulders (copy), PlotId (ref), setOwnerTag (copy), groundY (copy)
    t1.Drop()

    local Character = LocalPlayer.Character
    local v79, v80

    if Character then
        v79 = Character:FindFirstChild("HumanoidRootPart")
        v80 = Character:FindFirstChildOfClass("Humanoid")
    else
        v80 = Character
        v79 = Character
    end

    if not (v79 and v80 and v80.Health > 0) then
        Character = nil
        v79 = nil
    end

    local PlotId2 = LocalPlayer:GetAttribute("PlotId")
    local v81 = Fish.ById[p13.fishId]
    local v82 = false
    local v83 = false
    local v84 = false
    local v85 = false
    local v86 = false

    if Character then
        v82 = true
    else
        v86 = true
    end

    if v82 then
        if type(PlotId2) == "number" then
            v83 = true
        else
            v86 = true
        end
    end

    v82 = false

    if v83 then
        if v81 then
            v82 = true
        else
            v86 = true
        end
    end

    v83 = false

    if v82 then
        if type(p13.uid) == "number" then
            v83 = true
        else
            v86 = true
        end
    end

    v82 = false

    local v87

    if v83 then
        local Position = v79.Position
        local v88 = CFrame.new(Position)

        if p14 then
            v87 = v88
            v86 = false
        else
            v82 = true
        end
    end

    v83 = false

    local v89

    if v82 then
        local TutorialStep = DataClient.Get("TutorialStep")

        if TutorialStep then
            v89 = TutorialStep
            v84 = true
        else
            v83 = true
        end
    end

    v82 = false

    if v83 then
        v89 = TutorialSteps.DONE
        v84 = true
    end

    v83 = false

    if v84 then
        if v89 < TutorialSteps.DONE then
            v82 = true
        else
            v83 = true
        end
    end

    v84 = false

    local v90

    if v83 then
        v90 = false
        v84 = true
    end

    v83 = false

    if v82 then
        v90 = true
        v84 = true
    end

    v82 = false

    if v84 then
        if v90 then
            v83 = true
        else
            v82 = true
        end
    end

    v84 = false

    local v91

    if v82 then
        local v93 = Vector3.new(0 + math.random(-10, 10), v79.Position.Y, 16)

        v91 = CFrame.lookAt(v93, v93 + Vector3.new(0, 0, -1))
        v84 = true
    end

    v82 = false

    local v94, v95, v96

    if v83 then
        v94 = PlotFrame.ById(PlotId2)
        v95 = v94 * Vector3.new(math.random(-3, 1), 0, -10)
        v96 = groundY(v79.Position, Character)

        if v96 then
            v85 = true
        else
            v82 = true
        end
    end

    v83 = false

    local v98

    if v82 then
        v98 = 3
        v83 = true
    end

    v82 = false

    if v85 then
        v98 = math.clamp(v79.Position.Y - v96, 2, 6)
        v83 = true
    end

    v85 = false

    local X, v100

    if v83 then
        X = v95.X

        local v101 = groundY(v95, Character)

        if v101 then
            v100 = v101
            v82 = true
        else
            v85 = true
        end
    end

    if v85 then
        v100 = v95.Y
        v82 = true
    end

    if v82 then
        local v103 = Vector3.new(X, v100 + v98, v95.Z)

        v91 = CFrame.lookAt(v103, v103 + v94:VectorToWorldSpace((Vector3.new(0, 0, 1))))
        v84 = true
    end

    if v84 then
        v79.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        Character:PivotTo(v91)
        workspace.CurrentCamera.CFrame = CFrame.lookAt(v91 * Vector3.new(7, 6.5, 11), v91 * Vector3.new(-1.5, 1, -9))
        v87 = v91
        v86 = false
    end

    if v86 then
        return
    end

    setOwnerTag(PlotId2, false)
    PlotId = PlotId2
    v12 = FishModels.Get(p13.fishId, p13.variant, p13.size)

    local _, BoundingBox = v12:GetBoundingBox()
    local v104 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z, 0.1)
    local v105 = math.max(v104, 2.2)

    v12:ScaleTo(v12:GetScale() * v105 / v104)
    v12:PivotTo(CFrame.new())

    local _, BoundingBox2 = v12:GetBoundingBox()
    local v108 = FishModels.CenterOffset(v12)

    for _, descendant in ipairs(v12:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
        end
    end

    local v109 = CFrame.Angles(0, -1.5707963267948966, 0)
    local v110 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

    if v110 <= 7 then
        v14 = CFrame.new(0, 0.5 + BoundingBox2.Y * 0.2, -(1.7 + BoundingBox2.X / 2)) * v109 * CFrame.new(-v108)
    else
        local Head = Character:FindFirstChild("Head")
        local v111 = if Head and Head:IsA("BasePart") then v79.CFrame:PointToObjectSpace(Head.Position).Y + Head.Size.Y / 2 else 2.5

        v14 = CFrame.new(0, v111 + 0.3 + BoundingBox2.Y / 2, -(math.min(BoundingBox2.X * 0.2, 3) + 0.6)) * v109 * CFrame.new(-v108)

        local v115 = math.clamp(v110 * 1.25 + 14, 16, 1400)

        if not v15 then
            n1 += 1

            local v116 = v16

            if not v116 then
                v116 = {}

                local CameraMinZoomDistance, CameraMaxZoomDistance = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance
                local Magnitude2 = Magnitude

                if not Magnitude2 then
                    local CurrentCamera = workspace.CurrentCamera

                    Magnitude2 = (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude
                end

                v116[1] = CameraMinZoomDistance
                v116[2] = CameraMaxZoomDistance
                v116[3] = Magnitude2
            end

            v15 = v116
            v16 = nil
        end

        local v117 = v15[2]

        LocalPlayer.CameraMaxZoomDistance = math.max(v117, v115 * 1.5)
        LocalPlayer.CameraMinZoomDistance = v115

        if not p14 then
            workspace.CurrentCamera.CFrame = CFrame.lookAt(v87 * Vector3.new(v115 * 0.5, v115 * 0.3 + BoundingBox2.Y * 0.4, v115 * 0.8), v87 * Vector3.new(0, 3 + BoundingBox2.Y * 0.5, -4))
        end

        task.delay(0.4, function() -- line: 465
            -- upvalues: LocalPlayer (copy), v15 (ref)
            if v15 then
                LocalPlayer.CameraMinZoomDistance = v15[1]
            end
        end)
    end

    v12.Parent = workspace
    Remotes:WaitForChild("HoldFish"):FireServer(p13.uid)
    v13 = findShoulders(Character)

    local v125 = Variants.List[p13.variant] or Variants.List[1]
    local v126 = Sizes.List[p13.size] or Sizes.List[Sizes.NORMAL_INDEX]
    local v127 = if v125.index >= 2 then v125.id .. " " else ""

    if v126.index ~= Sizes.NORMAL_INDEX then
        v127 ..= v126.id .. " "
    end

    v5.Text = v127 .. v81.name
    v6.Text = NumberFormat.rate(Roll.income(p13.fishId, p13.variant, p13.size, p13.event, p13.base))
    v26 = p13
    n2 = 0
    v10.Text = "SELL  " .. NumberFormat.money(Roll.sellValue(p13.fishId, p13.variant, p13.size, p13.event, p13.base))
    t1.Uid = p13.uid
    n3 = os.clock()
    v4.Visible = true
    UIKit.pop(v4, 0.7)

    if HUD.HotbarGlow then
        HUD.HotbarGlow(true)
    end

    ContextActionService:BindAction("PlaceHeldFish", function(_, p16) -- line: 494
        -- upvalues: t1 (copy)
        if p16 == Enum.UserInputState.Begin then
            t1.Place()
        end

        return Enum.ContextActionResult.Sink
    end, false, Enum.KeyCode.E, Enum.KeyCode.ButtonX)
    HUD.RefreshPrompts()
end

local function onHotbar(p17) -- line: 504
    -- upvalues: t1 (copy)
    if t1.Uid then
        local v131 = t1.Uid == p17.uid

        t1.Drop()

        if v131 then
            return
        end
    end

    t1.Show({
        uid = p17.uid,
        fishId = p17.id,
        variant = p17.v,
        size = p17.s,
        event = p17.e,
        base = p17.b
    }, true)
end

local function buildMarker() -- line: 515
    -- upvalues: UIKit (copy), v1 (copy), v2 (copy), Part (ref), BillboardGui (ref), t2 (copy)
    Part = Instance.new("Part")
    Part.Name = "PlaceMarker"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)

    local Part2 = Part

    Part2.Parent = workspace
    BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "Arrow"

    local BillboardGui2 = BillboardGui

    BillboardGui2.Size = UDim2.fromOffset(130, 130)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 600
    BillboardGui.Enabled = false
    BillboardGui.Parent = Part

    local v132 = UIKit.frame(BillboardGui, {
        Name = "Tip",
        GradientRotation = 45,
        Size = UDim2.fromScale(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.58),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = v1,
        Color2 = v2
    })

    v132.Rotation = 45
    UIKit.stroke(v132, 6)

    local v133 = UIKit.frame(BillboardGui, {
        Name = "Body",
        Size = UDim2.fromScale(0.34, 0.4),
        Position = UDim2.fromScale(0.5, 0.26),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = v1
    })

    UIKit.stroke(v133, 6)
    UIKit.frame(BillboardGui, {
        Name = "Join",
        ZIndex = 2,
        Size = UDim2.fromScale(0.34, 0.2),
        Position = UDim2.fromScale(0.5, 0.42),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = v1
    })

    for i = 1, 4 do
        local Part = Instance.new("Part")

        Part.Name = "PlaceOutline" .. i
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.Color = v1
        Part.Transparency = 1
        Part.Parent = workspace
        t2[i] = Part
    end
end

function t1.Init() -- line: 557
    -- upvalues: RunService (copy), UserInputService (copy), GameConfig (copy), FishModels (copy), UIKit (copy), DataClient (copy), HUD (copy), Pad (copy), t1 (copy), LocalPlayer (copy), Colors (copy), v1 (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), n3 (ref), Part (ref), BillboardGui (ref), t2 (copy), ownPlot (copy), pointOnPond (copy), onHotbar (copy), buildMarker (copy)
    v3 = UIKit.screenGui("Held", 6)
    v4 = UIKit.frame(v3, {
        Name = "Panel",
        Transparency = 1,
        Size = UDim2.fromOffset(640, 212),
        Position = UDim2.new(0.5, 0, 1, -128),
        AnchorPoint = Vector2.new(0.5, 1)
    })
    v5 = UIKit.text(v4, {
        Name = "FishName",
        Text = "",
        TextSize = 40,
        Stroke = 5,
        Size = UDim2.new(1, 0, 0, 44)
    })
    v5.TextScaled = true

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    UITextSizeConstraint.MaxTextSize = 40
    UITextSizeConstraint.MinTextSize = 12
    UITextSizeConstraint.Parent = v5
    v6 = UIKit.text(v4, {
        Name = "Rate",
        Text = "",
        TextSize = 34,
        Stroke = 5,
        Size = UDim2.new(1, 0, 0, 38),
        Position = UDim2.fromOffset(0, 42),
        Color = Colors.Cash,
        StrokeColor = Colors.CashStroke
    })
    v7, v8 = UIKit.button(v4, {
        Name = "Place",
        Text = "PLACE",
        Corner = 18,
        Stroke = 5,
        TextStroke = 4,
        Size = UDim2.fromOffset(300, 76),
        Position = UDim2.new(0.5, -10, 0, 90),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Green,
        Color2 = Colors.GreenDark,
        OnClick = function() -- OnClick | line: 568
            -- upvalues: t1 (copy), n3 (ref)
            if os.clock() - n3 >= 0.5 then
                t1.Place()
            end
        end
    })
    v9, v10 = UIKit.button(v4, {
        Name = "Sell",
        Text = "SELL",
        Corner = 18,
        Stroke = 5,
        TextStroke = 4,
        Size = UDim2.fromOffset(300, 76),
        Position = UDim2.new(0.5, 10, 0, 90),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = t1.Sell
    })
    Pad.Icon(v7, Enum.KeyCode.ButtonX, {
        ZIndex = 6,
        Size = UDim2.fromOffset(52, 52),
        Position = UDim2.new(0, -8, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5)
    })
    v11 = UIKit.text(v4, {
        Name = "Hint",
        Text = "",
        TextSize = 28,
        Stroke = 4,
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.fromOffset(0, 176),
        Color = v1
    })
    v4.Visible = false
    buildMarker()

    local function refreshHint() -- line: 580
        -- upvalues: UserInputService (copy), GameConfig (copy), UIKit (copy), DataClient (copy), Pad (copy), Colors (copy), v1 (copy), v7 (ref), v8 (ref), v11 (ref)
        local v134 = #(DataClient.Get("Placed") or {}) >= (GameConfig.CAPACITY_LEVELS[DataClient.Get("CapacityLevel") or 1] or GameConfig.CAPACITY_LEVELS[1])
        local v135 = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

        v8.Text = v134 and "PLOT FULL" or "PLACE"

        local setButtonColor = UIKit.setButtonColor
        local v137 = v7
        local v139 = if v134 then Colors.Orange else Colors.Green
        local v138 = if v134 then Colors.OrangeDark else Colors.GreenDark

        setButtonColor(v137, v139, v138)

        local v140 = v11

        if v134 then
            v140.Text = "Sell it, or make room in My Fish"
        elseif Pad.Using() then
            v140.Text = ""
        elseif v135 then
            v140.Text = "or tap your pond to drop it in"
        else
            v140.Text = "or click your pond to drop it in"
        end

        local v141 = v11

        if v134 then
            v141.TextColor3 = Colors.Orange
        else
            v141.TextColor3 = v1
        end
    end

    DataClient.Observe("Placed", refreshHint)
    DataClient.Observe("CapacityLevel", refreshHint)
    Pad.Changed:Connect(refreshHint)
    refreshHint()
    DataClient.Observe("Backpack", function(p18) -- line: 594
        -- upvalues: t1 (copy)
        if t1.Uid then
            for _, v142 in ipairs(p18 or {}) do
                if v142.uid == t1.Uid then
                    return
                end
            end

            t1.Drop()
        end
    end)
    LocalPlayer.CharacterAdded:Connect(t1.Drop)
    HUD.OnHotbar = onHotbar

    HUD.HeldFishUid = function() -- line: 608
        -- upvalues: t1 (copy)
        return t1.Uid
    end

    local function tryPlace(p19) -- line: 613
        -- upvalues: UIKit (copy), t1 (copy), n3 (ref), pointOnPond (copy)
        if t1.Uid and not (os.clock() - n3 < 0.5 or UIKit.anyWindowOpen()) then
            local v143 = pointOnPond(p19)

            if v143 then
                t1.Place(v143)
            end
        end
    end

    UserInputService.InputBegan:Connect(function(p20, p21) -- line: 622
        -- upvalues: UIKit (copy), t1 (copy), n3 (ref), pointOnPond (copy)
        if p21 or p20.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        local Position = p20.Position

        if t1.Uid and not (os.clock() - n3 < 0.5) then
            if UIKit.anyWindowOpen() then
                return
            end

            local v144 = pointOnPond(Position)

            if v144 then
                t1.Place(v144)
            end
        end
    end)
    UserInputService.TouchTapInWorld:Connect(function(p22, p23) -- line: 627
        -- upvalues: UIKit (copy), t1 (copy), n3 (ref), pointOnPond (copy)
        if p23 or not t1.Uid or os.clock() - n3 < 0.5 or UIKit.anyWindowOpen() then
            return
        end

        local v145 = pointOnPond(p22)

        if v145 then
            t1.Place(v145)
        end
    end)
    RunService.Stepped:Connect(function() -- line: 634
        -- upvalues: t1 (copy), v13 (ref), v15 (ref)
        if not (t1.Uid and v13) then
            return
        end

        local v146 = if v15 then 165 else 82

        for _, v147 in ipairs(v13) do
            if v147.joint.Parent then
                local joint = v147.joint

                if v147.r15 then
                    joint.Transform = CFrame.Angles(math.rad(v146), 0, 0)
                else
                    joint.Transform = CFrame.Angles(0, 0, v147.sign * math.rad(v146))
                end
            end
        end
    end)
    RunService.RenderStepped:Connect(function() -- line: 646
        -- upvalues: FishModels (copy), UIKit (copy), HUD (copy), t1 (copy), LocalPlayer (copy), v4 (ref), v12 (ref), v14 (ref), Part (ref), BillboardGui (ref), t2 (copy), ownPlot (copy)
        if t1.Uid then
            local Character = LocalPlayer.Character
            local v148, v149

            if Character then
                v148 = Character:FindFirstChild("HumanoidRootPart")
                v149 = Character:FindFirstChildOfClass("Humanoid")
            else
                v149 = Character
                v148 = Character
            end

            if not (v148 and v149 and v149.Health > 0) then
                Character = nil
                v148 = nil
            end

            if not Character or HUD.GetMode() ~= "normal" then
                t1.Drop()

                return
            end

            local v150 = UIKit.anyWindowOpen()

            v4.Visible = not v150

            local elapsed = os.clock()

            if v12 then
                v12:PivotTo(v148.CFrame * CFrame.new(0, math.sin(elapsed * 2.2) * 0.08, 0) * v14)
                FishModels.Animate(v12, elapsed, 9)
            end

            local v154 = ownPlot()
            local Pond = v154 and v154:FindFirstChild("Pond")
            local Water = Pond and Pond:FindFirstChild("Water")

            if not (Water and Water:IsA("BasePart")) then
                Water = nil
            end

            if not Water or v150 then
                if Part then
                    BillboardGui.Enabled = false

                    for _, v155 in ipairs(t2) do
                        v155.Transparency = 1
                    end
                end
            else
                local v157 = Water.Position + Vector3.new(0, Water.Size.Y / 2, 0)
                local Magnitude = (workspace.CurrentCamera.CFrame.Position - v157).Magnitude
                local v159 = math.clamp(Magnitude * 0.1, 7, 40)

                Part.CFrame = CFrame.new(v157 + Vector3.new(0, v159 * (math.sin(elapsed * 4) * 0.12 + 1), 0))
                BillboardGui.Enabled = true

                local v162 = Water.Size.X / 2
                local v163 = Water.Size.Z / 2
                local v165 = (math.sin(elapsed * 4) + 1) * 0.2 + 0.25
                local v167 = math.clamp(Magnitude * 0.012, 0.5, 3)
                local t11 = {
                    {
                        Vector3.new(0, 0, -v163),
                        (Vector3.new(v162 * 2, 0.3, v167))
                    },
                    {
                        Vector3.new(0, 0, v163),
                        (Vector3.new(v162 * 2, 0.3, v167))
                    },
                    {
                        Vector3.new(-v162, 0, 0),
                        (Vector3.new(v167, 0.3, v163 * 2))
                    },
                    {
                        Vector3.new(v162, 0, 0),
                        (Vector3.new(v167, 0.3, v163 * 2))
                    }
                }

                for v178, v179 in ipairs(t2) do
                    v179.Size = t11[v178][2]
                    v179.CFrame = CFrame.new(v157) * Water.CFrame.Rotation * CFrame.new(t11[v178][1] + Vector3.new(0, 0.5, 0))
                    v179.Transparency = v165
                end
            end
        end
    end)
end

return t1
