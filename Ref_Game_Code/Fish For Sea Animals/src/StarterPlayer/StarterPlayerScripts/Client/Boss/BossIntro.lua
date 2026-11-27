-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Economy = require(ReplicatedStorage.Shared.Economy)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Settings = require(script.Parent.Parent.UI.Settings)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Controls = require(script.Parent.Parent.Character.Controls)
local Poses = require(script.Parent.Parent.Character.Poses)
local BossFx = require(script.Parent.BossFx)
local BossJuice = require(script.Parent.BossJuice)
local BossSkin = require(script.Parent.BossSkin)
local BossIntroSet = require(script.Parent.BossIntroSet)
local BossSeats = require(ReplicatedStorage.Shared.BossSeats)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local IntroTime = Economy.Boss.IntroTime
local v1 = IntroTime - 3
local v2 = v1 + 0.45
local v3 = false
local v4 = false
local v5, ScreenGui, v6, clone

local function now() -- line: 66
    return workspace:GetServerTimeNow()
end

local function smooth(p1) -- line: 70
    local v7 = math.clamp(p1, 0, 1)

    return v7 * v7 * (3 - v7 * 2)
end

local function lerp(p2, p3, p4) -- line: 75
    return p2 + (p3 - p2) * p4
end

local function bubble(p5, p6, p7, p8) -- line: 80
    -- upvalues: Kit (copy)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(p8, p8)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
    BillboardGui.LightInfluence = 0
    BillboardGui.AlwaysOnTop = false
    BillboardGui.Adornee = p5
    Kit.text(BillboardGui, p6, {
        StrokeThickness = 3,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = p7
    })
    BillboardGui.Parent = p5

    return BillboardGui
end

local function hideRod(p9, p10) -- line: 93
    local RodModel = p9:FindFirstChild("RodModel")

    if RodModel then
        for _, descendant in RodModel:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = p10 and 1 or 0
            end
        end
    end
end

local t2 = {
    BossIntro = true,
    BossHud = true,
    BossJuice = true
}
local t3 = {}

local function hideScreens() -- line: 109
    -- upvalues: LocalPlayer (copy), t2 (copy), t3 (copy)
    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child.Enabled and not t2[child.Name] then
            child.Enabled = false
            t3[child] = true
        end
    end
end

local function showScreens() -- line: 118
    -- upvalues: t3 (copy)
    for v8 in t3 do
        if v8.Parent then
            v8.Enabled = true
        end
    end

    table.clear(t3)
end

local function showBanner() -- line: 130
    -- upvalues: Config (copy), UIUtil (copy), RarityText (copy), BossSkin (copy), LocalPlayer (copy), ScreenGui (ref), clone (ref)
    local Cutscene = LocalPlayer.PlayerGui:FindFirstChild("Cutscene")
    local Banner = Cutscene and Cutscene:FindFirstChild("Banner")

    if not Banner then
        return
    end

    if clone then
        clone:Destroy()
    end

    local clone2 = Banner:Clone()

    clone2.Name = "BossBanner"

    local Scale = clone2:FindFirstChild("Scale")

    if Scale then
        Scale.Scale = UIUtil.scale
    end

    for _, v9 in { "NewTag", "MutationTag", "SizeTag" } do
        local v10 = clone2:FindFirstChild(v9)

        if v10 then
            v10:Destroy()
        end
    end

    local Rarity = clone2:FindFirstChild("Rarity")
    local AnimalName = clone2:FindFirstChild("AnimalName")
    local Income = clone2:FindFirstChild("Income")

    Rarity.Text = "SEA MONSTER"
    RarityText.apply(Rarity, Config.RarityByName.Secret or Config.Rarities[#Config.Rarities])
    AnimalName.Text = BossSkin.name()
    Income.Text = "Cast near it, then reel it in!"
    Income.TextColor3 = Color3.new(1, 1, 1)
    clone2.Visible = true
    clone2.Parent = ScreenGui
    clone = clone2

    for v11, v12 in { Rarity, AnimalName, Income } do
        v12.Visible = false
        task.delay((v11 - 1) * 0.18, function() -- line: 165
            -- upvalues: v12 (copy), UIUtil (copy)
            v12.Visible = true
            UIUtil.pop(v12, 0.2)
        end)
    end

    UIUtil.sound("Reveal", 0.9)
end

local function hideBanner(p11) -- line: 173
    -- upvalues: UIUtil (copy), clone (ref)
    local clone2 = clone

    task.delay(p11, function() -- line: 175
        -- upvalues: clone2 (copy), UIUtil (copy)
        if clone2 and clone2.Parent then
            for _, child in clone2:GetChildren() do
                if child:IsA("TextLabel") then
                    UIUtil.tween(child, 0.3, {
                        TextTransparency = 1
                    })

                    local UIStroke = child:FindFirstChildOfClass("UIStroke")

                    if UIStroke then
                        UIUtil.tween(UIStroke, 0.3, {
                            Transparency = 1
                        })
                    end
                end
            end

            task.wait(0.35)
            clone2:Destroy()
        end
    end)
end

function t1.isPlaying() -- line: 194
    -- upvalues: v3 (ref)
    return v3
end

function t1.play() -- line: 198
    -- upvalues: Players (copy), RunService (copy), UIUtil (copy), Settings (copy), Controls (copy), Poses (copy), BossFx (copy), BossJuice (copy), BossSkin (copy), BossIntroSet (copy), BossSeats (copy), LocalPlayer (copy), IntroTime (copy), v1 (copy), v2 (copy), v3 (ref), v4 (ref), v5 (ref), ScreenGui (ref), v6 (ref), clone (ref), bubble (copy), hideRod (copy), t3 (copy), hideScreens (copy), showBanner (copy)
    local BossArena = workspace:FindFirstChild("BossArena")
    local Character = LocalPlayer.Character
    local v13 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v14 = Character and Character:FindFirstChildOfClass("Humanoid")
    local BossIntroAt = workspace:GetAttribute("BossIntroAt")
    local v15, v16, v17

    if v3 then
        v17 = true
    elseif BossArena and v13 and v14 and BossIntroAt then
        v3 = true
        v4 = false
        v15 = v5
        v16 = (LocalPlayer:GetAttribute("BossesFought") or 0) >= 2
        v17 = false
    else
        v17 = true
    end

    if v17 then
        return
    end

    v15.Visible = v16

    local Center = BossArena:GetAttribute("Center")
    local v18 = BossArena:GetAttribute("WaterY") or 0
    local v19 = Center.Y + (BossArena:GetAttribute("RaftTop") or 3)
    local v20 = BossArena:GetAttribute("RaftHalf") or 22
    local v21 = BossSkin.monster()
    local BossFacing = workspace:GetAttribute("BossFacing")

    if typeof(BossFacing) ~= "Vector3" then
        BossFacing = if v21 then (v21:GetPivot().Position - Center) * Vector3.new(1, 0, 1) else Vector3.new(1, 0, 0)
    end

    local v22 = Vector3.new(BossFacing.X, 0, BossFacing.Z)
    local v23

    if v22.Magnitude > 0.01 then
        local Unit = v22.Unit

        v22 = Unit
        v23 = Unit
    else
        v23 = Vector3.new(1, 0, 0)
        v22 = Vector3.new(1, 0, 0)
    end

    local v24 = BossSeats.spot(BossSeats.CHAIR, Center, v19, v20, v22)

    local function at(p12, p13, p14) -- line: 224
        -- upvalues: v24 (copy)
        return (v24 * CFrame.new(p12, p13, p14)).Position
    end

    local v25 = RaycastParams.new()

    v25.FilterType = Enum.RaycastFilterType.Include
    v25.FilterDescendantsInstances = { BossArena }

    local function floorUnder(p15) -- line: 231
        -- upvalues: v19 (copy), v25 (copy)
        local v27 = workspace:Raycast(Vector3.new(p15.X, v19 + 6, p15.Z), Vector3.new(0, -12, 0), v25)

        if v27 then
            return v27.Position.Y - v19
        end

        return 0
    end

    local function floorAt(p16, p17) -- line: 235
        -- upvalues: v19 (copy), v24 (copy), v25 (copy)
        local Position = (v24 * CFrame.new(p16, 0, p17)).Position
        local v29 = workspace:Raycast(Vector3.new(Position.X, v19 + 6, Position.Z), Vector3.new(0, -12, 0), v25)

        if v29 then
            return v29.Position.Y - v19
        end

        return 0
    end

    local function standOf(p18) -- line: 238
        local Humanoid = p18:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = p18:FindFirstChild("HumanoidRootPart")

        if Humanoid and HumanoidRootPart and Humanoid.RigType == Enum.HumanoidRigType.R15 then
            return Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2
        end

        return 3
    end

    local function seatOf(p19) -- line: 245
        return p19:GetAttribute("BossSeat")
    end

    local v30 = LocalPlayer
    local v31 = LocalPlayer
    local v32

    for _, player in Players:GetPlayers() do
        v32 = player.Character

        if player:GetAttribute("BossSeat") == BossSeats.CHAIR and v32 and v32:FindFirstChild("HumanoidRootPart") and v32:FindFirstChildOfClass("Humanoid") then
            v30 = player
            v31 = player
        end
    end

    local Character2 = v30.Character
    local Humanoid = Character2:FindFirstChildOfClass("Humanoid")
    local Folder = Instance.new("Folder")

    Folder.Name = "BossIntroSet"
    Folder.Parent = workspace

    local v33 = Humanoid.RigType == Enum.HumanoidRigType.R15

    v32 = if v33 then (Humanoid.HipHeight + 0.4) * 0.55 else 1.2

    local Position = (v24 * CFrame.new(0, 0, 1)).Position
    local _workspace = workspace
    local v34 = Position.X
    local v35 = v19 + 6

    _workspace = _workspace:Raycast(Vector3.new(v34, v35, Position.Z), Vector3.new(0, -12, 0), v25)

    local v36 = if _workspace then _workspace.Position.Y - v19 else 0

    BossIntroSet.chair(Folder, v32):PivotTo(v24 * CFrame.new(0, v36, 1))
    _workspace = if v33 then 1.1 * Humanoid.HipHeight / 2 else 1.5

    local v37 = v32 + _workspace
    local t4 = {}
    local t5 = {}

    local function placeOf(p20) -- line: 275
        -- upvalues: Center (copy), v19 (copy), v20 (copy), v23 (ref), v24 (copy), v25 (copy), v31 (ref), v36 (copy), v37 (copy), BossSeats (copy)
        local Character = p20.Character

        if not Character then
            return nil
        end

        if p20 == v31 then
            return v24 * CFrame.new(0, v36 + v37, 0.9)
        end

        local BossSeat = p20:GetAttribute("BossSeat")
        local v38, v39

        if not BossSeat or BossSeat == BossSeats.CHAIR then
            return nil
        else
            v38 = BossSeats.spot(BossSeat, Center, v19, v20, v23)

            local Position = v38.Position
            local v42 = workspace:Raycast(Vector3.new(Position.X, v19 + 6, Position.Z), Vector3.new(0, -12, 0), v25)

            v39 = if v42 then v42.Position.Y - v19 else 0
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        return v38 + Vector3.new(0, v39 + (if Humanoid and HumanoidRootPart and Humanoid.RigType == Enum.HumanoidRigType.R15 then Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2 else 3), 0)
    end

    local function placeCast(p21) -- line: 290
        -- upvalues: v18 (copy), v31 (ref), Folder (copy), t4 (copy), t5 (copy), placeOf (copy), Players (copy), BossIntroSet (copy)
        for _, player in Players:GetPlayers() do
            local Character = player.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            local v44 = HumanoidRootPart and placeOf(player)

            if v44 then
                if t4[HumanoidRootPart] == nil then
                    t4[HumanoidRootPart] = HumanoidRootPart.Anchored
                end

                HumanoidRootPart.Anchored = true
                HumanoidRootPart.CFrame = v44
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                if player ~= v31 then
                    if not t5[player] then
                        local v45 = v44.Position + v44.LookVector * 13

                        t5[player] = BossIntroSet.line(Folder, (Vector3.new(v45.X, v18 + 0.15, v45.Z)))
                    end

                    t5[player](Character, p21)
                end
            end
        end
    end

    local v47 = placeOf(LocalPlayer) or v24 * CFrame.new(0, v36 + v37, 0.9)
    local v48

    if v31 == LocalPlayer then
        local new = CFrame.new
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        v48 = Character:FindFirstChild("HumanoidRootPart")
        v34 = v24 * new(0, v36 + (if Humanoid and v48 and Humanoid.RigType == Enum.HumanoidRigType.R15 then Humanoid.HipHeight + v48.Size.Y / 2 else 3), 0.4)
    else
        v34 = v47
    end

    Controls.lock("BossIntro", v47)
    placeCast(workspace:GetServerTimeNow() - BossIntroAt)
    Poses.playFor(Character2, "Doze")
    hideRod(Character2, true)

    local CurrentCamera = workspace.CurrentCamera
    local FieldOfView = CurrentCamera.FieldOfView

    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    ScreenGui.Enabled = true
    v6.BackgroundTransparency = 0
    UIUtil.tween(v6, 0.8, {
        BackgroundTransparency = 1
    })

    local v50 = BossIntroSet.rod(Folder, Character2)
    local v51 = Character2:FindFirstChild("RightHand") or Character2:FindFirstChild("Right Arm")
    local Position2 = (v24 * CFrame.new(-0.2, 0, -0.4)).Position
    local _workspace2 = workspace

    _workspace2 = _workspace2:Raycast(Vector3.new(Position2.X, v19 + 6, Position2.Z), Vector3.new(0, -12, 0), v25)

    local v54 = Vector3.new(-0.2, (if _workspace2 then _workspace2.Position.Y - v19 else 0) + 0.15, -0.4)

    _workspace2 = (v24 * CFrame.new(2.8, 0, -0.9)).Position

    local _workspace3 = workspace

    _workspace3 = _workspace3:Raycast(Vector3.new(_workspace2.X, v19 + 6, _workspace2.Z), Vector3.new(0, -12, 0), v25)
    Position2 = if _workspace3 then _workspace3.Position.Y - v19 else 0

    local v55 = Vector3.new(2.8, Position2 + 0.75, -0.9)

    v48 = Vector3.new(v55.X - v54.X, 0, v55.Z - v54.Z)

    local v56 = math.deg((math.atan2(v48.X, -v48.Z)))
    local v57 = math.deg((math.atan2(1.5, v48.Magnitude - 0.8)))
    local v58 = v24:VectorToWorldSpace((Vector3.new(0.3, 0, -1)).Unit)
    local Unit = v58:Cross((Vector3.new(0, 1, 0))).Unit
    local v59 = BossIntroSet.bucket(Folder)

    v59:PivotTo(v24 * CFrame.new(v55))

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(200, 230, 255)
    PointLight.Range = 0
    PointLight.Brightness = 1.8
    PointLight.Shadows = false
    PointLight.Parent = v59.PrimaryPart

    local function rodAt(p22, p23, p24) -- line: 347
        -- upvalues: v24 (copy), v50 (copy)
        local v63 = (v24 * CFrame.Angles(0, -math.rad(p23), 0)).LookVector * math.cos((math.rad(p24))) + Vector3.new(0, 1, 0) * math.sin((math.rad(p24)))

        v50:PivotTo(CFrame.lookAt(p22, p22 + v63))
    end

    local function handPoint() -- line: 352
        -- upvalues: v24 (copy), v33 (copy), v37 (copy), v51 (copy)
        if v51 then
            return (v51.CFrame * CFrame.new(0, if v33 then -0.1 else -0.9, 0)).Position
        end

        return (v24 * CFrame.new(0.6, v37, 0)).Position
    end

    local Head = Character2:FindFirstChild("Head")
    local v64 = Head and bubble(Head, "Z z z", Color3.fromRGB(200, 220, 255), 3)
    local v65 = -v24.RightVector
    local Unit2 = v65:Cross((Vector3.new(0, 1, 0))).Unit
    local v66
    local v67 = nil
    local t6 = {}

    t6[1] = nil

    local v68, v69, v70, v71, v72, v73
    local t7 = {}

    local function once(p25, p26) -- line: 373
        -- upvalues: t7 (copy)
        if not t7[p25] then
            t7[p25] = true
            p26()
        end
    end

    local n1 = 0

    local function aim(p27) -- line: 380
        -- upvalues: CurrentCamera (copy), n1 (ref), Settings (copy)
        CurrentCamera.CFrame = p27 + (if n1 > 0 and Settings.get("Shake") then Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * n1 else Vector3.new(0, 0, 0))
    end

    local function look(p28, p29) -- line: 387
        -- upvalues: aim (copy)
        aim(CFrame.lookAt(p28, p29))
    end

    local connection

    local function finish() -- line: 392
        -- upvalues: v23 (ref), Character2 (copy), Folder (copy), t4 (copy), CurrentCamera (copy), FieldOfView (copy), v71 (ref), v72 (ref), connection (ref), v64 (copy), v13 (copy), v14 (copy), v34 (ref), UIUtil (copy), Controls (copy), Poses (copy), BossIntroSet (copy), v3 (ref), v5 (ref), ScreenGui (ref), clone (ref), hideRod (copy), t3 (copy)
        connection:Disconnect()
        Folder:Destroy()

        if v64 then
            v64:Destroy()
        end

        for _, v78 in { v71, v72 } do
            if v78 then
                v78:Destroy()
            end
        end

        BossIntroSet.restoreLight()
        hideRod(Character2, false)

        for v79 in t3 do
            if v79.Parent then
                v79.Enabled = true
            end
        end

        table.clear(t3)
        Poses.playFor(Character2, nil)

        for v80, v81 in t4 do
            if v80.Parent then
                v80.Anchored = v81
            end
        end

        local clone2 = clone

        task.delay(1.6, function() -- line: 175
            -- upvalues: clone2 (copy), UIUtil (copy)
            if clone2 and clone2.Parent then
                for _, child in clone2:GetChildren() do
                    if child:IsA("TextLabel") then
                        UIUtil.tween(child, 0.3, {
                            TextTransparency = 1
                        })

                        local UIStroke = child:FindFirstChildOfClass("UIStroke")

                        if UIStroke then
                            UIUtil.tween(UIStroke, 0.3, {
                                Transparency = 1
                            })
                        end
                    end
                end

                task.wait(0.35)
                clone2:Destroy()
            end
        end)
        ScreenGui.Enabled = clone ~= nil
        task.delay(2.2, function() -- line: 414
            -- upvalues: v3 (ref), ScreenGui (ref)
            if not v3 then
                ScreenGui.Enabled = false
            end
        end)

        for _, child in ScreenGui:GetChildren() do
            if child.Name == "Bar" then
                child.Visible = false
            end
        end

        local Position = v34.Position

        v13.Anchored = false
        v13.CFrame = CFrame.lookAt(Position, Position + v23)
        v13.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        CurrentCamera.FieldOfView = FieldOfView
        CurrentCamera.CFrame = CFrame.lookAt(Position - v23 * 16 + Vector3.new(0, 6, 0), Position + v23 * 40 + Vector3.new(0, 3, 0))
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.CameraSubject = v14
        Controls.unlock("BossIntro")
        v5.Visible = false
        v3 = false
    end

    for _, child in ScreenGui:GetChildren() do
        if child.Name == "Bar" then
            child.Visible = true
        end
    end

    connection = RunService.RenderStepped:Connect(function() -- line: 445
        -- upvalues: Character (copy), BossIntroAt (copy), Center (copy), v18 (copy), v21 (copy), v23 (ref), v24 (copy), Character2 (copy), Folder (copy), v33 (copy), v37 (copy), t5 (copy), placeCast (copy), CurrentCamera (copy), FieldOfView (copy), v54 (copy), v55 (copy), v56 (copy), v57 (copy), v58 (copy), Unit (copy), v59 (copy), PointLight (copy), rodAt (copy), Head (copy), v65 (copy), Unit2 (copy), v66 (ref), v67 (ref), t6 (copy), v68 (ref), v69 (ref), v70 (ref), v71 (ref), v72 (ref), v73 (ref), t7 (copy), n1 (ref), aim (copy), finish (copy), v64 (copy), v51 (copy), UIUtil (copy), Poses (copy), BossFx (copy), BossJuice (copy), BossIntroSet (copy), IntroTime (copy), v1 (copy), v2 (copy), v4 (ref), bubble (copy), hideRod (copy), hideScreens (copy), showBanner (copy)
        local v82 = workspace:GetServerTimeNow() - BossIntroAt
        local v83, _CFrame, v84

        if IntroTime <= v82 or v4 then
            v84 = true
        elseif Character.Parent and workspace:GetAttribute("BossState") == "Fight" then
            hideScreens()
            hideRod(Character2, true)
            placeCast(v82)
            _CFrame = n1 - 0.02
            n1 = math.max(0, _CFrame)

            if v64 then
                v83 = 2.4 + v82 * 0.8 % 1.2
                v64.StudsOffsetWorldSpace = Vector3.new(0.6, v83, 0)
            end

            v84 = false
        else
            v84 = true
        end

        if v84 then
            finish()

            return
        end

        local v85, new, v86, Z, v87, v88

        if v82 < 2.95 then
            local Position

            if v51 then
                _CFrame = v51.CFrame
                v83 = CFrame.new
                v85 = if v33 then -0.1 else -0.9
                Position = (_CFrame * v83(0, v85, 0)).Position
            else
                Position = (v24 * CFrame.new(0.6, v37, 0)).Position
            end

            v86 = v82 * 1.7
            rodAt(Position, 8, math.sin(v86) * 3 + 42)
        elseif v82 < 3.3 then
            local v90 = math.clamp((v82 - 2.95) / 0.34999999999999964, 0, 1)
            local v91 = v90 * v90 * (3 - v90 * 2)

            if v51 then
                v83 = v51.CFrame
                new = CFrame.new
                v86 = if v33 then -0.1 else -0.9
                v90 = (v83 * new(0, v86, 0)).Position
            else
                v90 = (v24 * CFrame.new(0.6, v37, 0)).Position
            end

            v85 = v54.X
            v86 = v54.Y
            Z = v54.Z
            rodAt(v90:Lerp((v24 * CFrame.new(v85, v86, Z)).Position, v91), (v56 - 8) * v91 + 8, v91 * 26 + 42)
        elseif v82 < 4.1 then
            v87 = (v82 - 3.3) / 0.7999999999999998
            v83 = v54.X
            new = v54.Y
            v85 = v54.Z

            local Position = (v24 * CFrame.new(v83, new, v85)).Position

            v86 = v87 * v87
            rodAt(Position, v56, (v57 - 68) * v86 + 68)
        else
            v87 = v82 - 4.1

            if v87 < 0.12 then
                v85 = v87 / 0.12 * 3.141592653589793
                v88 = v57 + math.sin(v85) * 5
            elseif v87 < 0.5 then
                local v92 = (v87 - 0.12) / 0.38

                new = v92 * v92
                v88 = v57 + (3 - v57) * new
            else
                v86 = (v87 - 0.5) * 9
                v85 = math.sin(v86)
                v83 = math.abs(v85) * 4
                v85 = -(v87 - 0.5) * 6
                v88 = v83 * math.exp(v85) + 3
            end

            new = v54.X
            v85 = v54.Y
            v86 = v54.Z
            rodAt((v24 * CFrame.new(new, v85, v86)).Position, v56 + math.min(v87, 0.5) * 6, v88)
        end

        local v93, v94

        if v82 >= 4.1 and v82 < 5.7 then
            v88 = v82 - 4.1
            v87 = math.min(v88, 0.85)
            v93 = v55.X
            v94 = v55.Y
            new = v55.Z
            v88 = (v24 * CFrame.new(v93, v94, new)).Position
            v94 = (14.45 - (v88.Y - v18)) / 0.85
            new = v88 + v58 * (v87 * 5.9)
            Z = v94 * v87 - v87 * 20 * v87
            v93 = new + Vector3.new(0, Z, 0)
            v94 = v87 * 9

            if v82 >= 4.949999999999999 then
                v88 = v82 - 4.949999999999999
                v87 = v66 or v93
                v85 = v87.X
                v86 = v18 + 0.1 - v88 * v88 * 1.6
                Z = v87.Z
                v93 = Vector3.new(v85, v86, Z)
                v94 = 7.649999999999997 + v88 * 1.2
            end

            v59:PivotTo(CFrame.new(v93) * CFrame.fromAxisAngle(Unit, -v94))
        end

        if v82 < 2.4 then
            v87 = function() -- line: 503
                -- upvalues: UIUtil (copy)
                UIUtil.sound("Snore", 0.7)
            end

            if not t7.snore then
                t7.snore = true
                UIUtil.sound("Snore", 0.7)
            end

            v88 = v82 / 2.4

            local v95 = math.clamp(v88, 0, 1)
            local v96 = v95 * v95 * (3 - v95 * 2)

            v95 = v96 * 2 + -10
            v94 = 7.5 - v96 * 1.5
            new = v96 * 3 + -13
            v88 = (v24 * CFrame.new(v95, v94, new)).Position
            v95 = (v24 * CFrame.new(0.8, 2, -0.5)).Position
            aim(CFrame.lookAt(v88, v95))
        elseif v82 < 5.7 then
            if not t7.slump then
                t7.slump = true
                task.delay(0.30000000000000027, function() -- line: 511
                    -- upvalues: Character2 (copy), v64 (copy), UIUtil (copy), Poses (copy)
                    Poses.playFor(Character2, "Slump")
                    UIUtil.sound("ChairCreak", 0.8)

                    if v64 then
                        v64.Enabled = false
                    end
                end)
            end

            local v97

            if v82 >= 2.95 then
                v97 = function() -- line: 520
                    -- upvalues: UIUtil (copy)
                    UIUtil.sound("Whoosh", 0.35, 1.5)
                end

                if not t7.slip then
                    t7.slip = true
                    UIUtil.sound("Whoosh", 0.35, 1.5)
                end
            end

            if v82 >= 4.1 and not t7.clang then
                t7.clang = true
                UIUtil.sound("MetalClang", 1)
                UIUtil.sound("Clank", 0.5, 1.4)
                n1 = 0.12
            end

            if v82 >= 4.949999999999999 and not t7.splash then
                t7.splash = true
                v88 = v59:GetPivot().Position
                v94 = v88.X
                v85 = v88.Z
                v66 = Vector3.new(v94, v18, v85)
                BossFx.splash(v66 + Vector3.new(0, 0.5, 0), 3)
                UIUtil.sound("BigSplash", 0.9, 1.2)
            end

            v88 = (v82 - 4.1) / 0.9

            local v98 = math.clamp(v88, 0, 1)

            v97 = v98 * v98 * (3 - v98 * 2)
            v88 = (v24 * CFrame.new(6.6, 4.4, 1.8)).Position:Lerp((v24 * CFrame.new(6.2, 5.2, 0.8)).Position, v97)
            v98 = (v24 * CFrame.new(1.1, 1.3, -0.9)).Position:Lerp((v24 * CFrame.new(3.9, -0.6, -5.2)).Position, v97)
            aim(CFrame.lookAt(v88, v98))
        elseif v82 < 14.7 then
            v87 = function() -- line: 546
                -- upvalues: v18 (copy), Folder (copy), CurrentCamera (copy), v59 (copy), PointLight (copy), v65 (copy), Unit2 (copy), v66 (ref), v67 (ref), t6 (copy), v68 (ref), v69 (ref), v70 (ref), v71 (ref), UIUtil (copy), BossIntroSet (copy)
                local v99 = v66 or v59:GetPivot().Position

                v67 = Vector3.new(v99.X, v18 - 44, v99.Z)
                t6[1] = v67 + v65 * 6.3 - Vector3.new(0, 3, 0) - Unit2 * 2

                local v102, v103, v104 = BossIntroSet.eye(Folder, t6[1], -v65)

                v68 = v103
                v69 = v104
                BossIntroSet.backdrop(v102, t6[1] + v65 * 40, -v65)
                v70 = BossIntroSet.specks(v102)
                PointLight.Range = 12
                PointLight.Brightness = 3

                local Highlight = Instance.new("Highlight")

                Highlight.FillColor = Color3.fromRGB(150, 180, 215)
                Highlight.FillTransparency = 0.62
                Highlight.OutlineColor = Color3.fromRGB(205, 228, 255)
                Highlight.OutlineTransparency = 0.5
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight.Parent = v59
                CurrentCamera.FieldOfView = 60
                v71 = UIUtil.sound("Sinking", 0.7, 0.85, 12)

                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(220, 240, 255))
                ParticleEmitter.LightInfluence = 0
                ParticleEmitter.LightEmission = 0.3
                ParticleEmitter.Size = NumberSequence.new(0.22, 0.05)
                ParticleEmitter.Transparency = NumberSequence.new(0.25, 1)
                ParticleEmitter.Lifetime = NumberRange.new(1.2, 1.8)
                ParticleEmitter.Speed = NumberRange.new(2, 4)
                ParticleEmitter.EmissionDirection = Enum.NormalId.Top
                ParticleEmitter.SpreadAngle = Vector2.new(20, 20)
                ParticleEmitter.Rate = 14
                ParticleEmitter.Parent = v59.PrimaryPart
            end

            if not t7.under then
                t7.under = true
                v87()
            end

            v88 = v67.X
            v93 = v18 - 1.4
            v94 = v67.Z
            v87 = Vector3.new(v88, v93, v94)

            local v105, v106, v107

            if v82 < 11.6 then
                v94 = (v82 - 5.7) / 5.8999999999999995
                v85 = v87:Lerp(v67, v94 ^ 1.1)
                v106 = v82 * 1.3
                new = v85 + Unit2 * math.sin(v106) * 0.35
                v86 = v65 * 0.3
                v107 = (v94 - 0.85) / 0.15
                v106 = math.clamp(v107, 0, 1)
                v88 = new - v86 * (1 - v106 * v106 * (3 - v106 * 2))
                v85 = v82 * 1.7
                v93 = math.sin(v85) * 0.35
                new = BossIntroSet.underwater
                v105 = v94 * 2.2
                v107 = math.clamp(v105, 0, 1)
                new(v107 * v107 * (3 - v107 * 2) * 0.55 + 0.45)
            else
                v94 = v82 - 11.6
                v107 = v94 / 0.45
                v86 = math.min(v107, 1) * 3.141592653589793 * 0.5
                new = math.sin(v86) * 1.6
                v107 = math.min(v94 / 0.6, 1) * 3.141592653589793
                v105 = math.sin(v107)
                v85 = math.max(0, v105) * 0.7
                v105 = v94 - 0.35
                v86 = math.max(0, v105)
                Z = v67 - v65 * (new - 0.3)
                v106 = v85 - v86 * v86 * 1.1 - v86 * 0.4
                v88 = Z + Vector3.new(0, v106, 0)
                v93 = 0.35 + v94 * 1.6
                BossIntroSet.underwater(1)
            end

            if v82 >= 11.6 then
                v87 = 1.2 + (v82 - 11.6) * 2.2
            else
                v85 = v82 * 0.9
                v87 = math.sin(v85) * 0.3 + 1.2
            end

            v59:PivotTo(CFrame.new(v88) * CFrame.fromAxisAngle(v65, v93) * CFrame.fromAxisAngle(Unit2, v87))

            if v82 >= 11.6 and not t7.bonk then
                t7.bonk = true
                UIUtil.sound("SubBoom", 1, 0.9)
                UIUtil.sound("MetalClang", 0.55, 0.55)
                n1 = 0.5
            end

            if v82 >= 12.3 then
                local v110 = v82 - 12.3

                v94 = v110 / 1.1
                new = math.clamp(v94, 0, 1)

                local v111 = new * new * (3 - new * 2)

                v94 = v68
                v86 = (v110 - 1.1) / 0.7
                Z = math.clamp(v86, 0, 1)
                v94(v111, Z * Z * (3 - Z * 2))
                BossIntroSet.eyeGlow(v111)
                v94 = CFrame.lookAt(t6[1], t6[1] - v65):PointToObjectSpace(v88)

                local v112 = Vector2.new(v94.X, v94.Y)

                if v112.Magnitude > 0.01 then
                    new = v112.Unit
                    v86 = v112.Magnitude * 0.25
                    v111 = new * math.min(v86, 1.4)
                else
                    v111 = Vector2.zero
                end

                new = v69
                Z = (v110 - 0.4) / 0.6
                v105 = math.clamp(Z, 0, 1)
                new(v111 * (v105 * v105 * (3 - v105 * 2)))

                new = function() -- line: 620
                    -- upvalues: v71 (ref), UIUtil (copy)
                    UIUtil.sound("BossGrowl", 1, 0.45)
                    UIUtil.sound("SubBoom", 0.8, 0.6)

                    if v71 then
                        UIUtil.tween(v71, 0.6, {
                            Volume = 0
                        })
                    end
                end

                if not t7.eye then
                    t7.eye = true
                    new()
                end
            end

            new = (v82 - 11.6) / 1.6
            v85 = math.clamp(new, 0, 1)
            v94 = v85 * v85 * (3 - v85 * 2)
            v86 = (v82 - 12.3) / 2.4
            Z = math.clamp(v86, 0, 1)
            new = Z * Z * (3 - Z * 2) * 1.5
            v86 = v88.Y + 0.6
            v85 = v86 + (t6[1].Y + 1 - v86) * v94
            Z = v67.X
            v86 = Vector3.new(Z, 0, v67.Z)
            v88 = v86:Lerp(Vector3.new(t6[1].X, 0, t6[1].Z) - v65 * 6.3, v94) - v65 * (9 - new)
            Z = v88.X
            v86 = Vector3.new(Z, v85, v88.Z)
            v85 = CFrame.lookAt(v86, v86 + v65)
            aim(v85)

            if v70 then
                v86 = v70
                v86.CFrame = v85 * CFrame.new(0, 0, -7)
            end
        elseif v82 < v1 then
            local function v113() -- line: 642
                -- upvalues: Folder (copy), CurrentCamera (copy), FieldOfView (copy), v59 (copy), v72 (ref), UIUtil (copy), BossIntroSet (copy)
                BossIntroSet.restoreLight()
                CurrentCamera.FieldOfView = FieldOfView
                v59:Destroy()

                local Eye = Folder:FindFirstChild("Eye")

                if Eye then
                    Eye:Destroy()
                end

                v72 = UIUtil.sound("Rumble", 0.9, 0.9, 12)
                UIUtil.sound("SubBoom", 0.6, 0.25)
            end

            if not t7.surface then
                t7.surface = true
                v113()
            end

            v88 = n1
            v85 = (v82 - 14.7) / 2
            v86 = math.clamp(v85, 0, 1)
            n1 = math.max(v88, v86 * v86 * (3 - v86 * 2) * 0.3 + 0.12)

            if v82 >= 15.5 then
                v113 = function() -- line: 655
                    -- upvalues: Character2 (copy), t5 (copy), Head (copy), UIUtil (copy), Poses (copy), bubble (copy)
                    Poses.playFor(Character2, "Startle")

                    if Head then
                        local v115 = bubble(Head, "?", Color3.new(1, 1, 1), 3.5)

                        UIUtil.pop(v115:FindFirstChildWhichIsA("TextLabel"), 1.8)
                        task.delay(1.6, function() -- line: 660
                            -- upvalues: v115 (copy)
                            v115:Destroy()
                        end)
                    end

                    for v116 in t5 do
                        local v117 = v116.Character and v116.Character:FindFirstChild("Head")

                        if v117 then
                            local v118 = bubble(v117, "!", Color3.fromRGB(255, 220, 80), 3)

                            UIUtil.pop(v118:FindFirstChildWhichIsA("TextLabel"), 1.6)
                            task.delay(1.6, function() -- line: 670
                                -- upvalues: v118 (copy)
                                v118:Destroy()
                            end)
                        end
                    end

                    UIUtil.sound("Pop", 0.7, 0.8)
                end

                if not t7.wake then
                    t7.wake = true
                    v113()
                end
            end

            v113 = if not (v21 and v21.Parent) then Center + v23 * 105 else v21:GetPivot().Position

            local v114 = v113.X

            new = v113.Z

            local v119 = Vector3.new(v114, v18, new)

            if v82 < 16.6 then
                v113 = if Head then Head.Position else (v24 * CFrame.new(0, 3.4, 1)).Position
                v114 = (v24 * CFrame.new(0.6, 4.3, -5.4)).Position
                v94 = v113 - Vector3.new(0, 0.3, 0)
                aim(CFrame.lookAt(v114, v94))
            else
                v114 = function() -- line: 686
                    -- upvalues: v119 (copy), Folder (copy), v73 (ref), UIUtil (copy), BossIntroSet (copy)
                    v73 = BossIntroSet.prop(Folder, {
                        Size = Vector3.new(30, 1, 30),
                        Transparency = 1,
                        CFrame = CFrame.new(v119)
                    })

                    local ParticleEmitter = Instance.new("ParticleEmitter")

                    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(230, 245, 255))
                    ParticleEmitter.Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1.5),
                        NumberSequenceKeypoint.new(1, 4)
                    })
                    ParticleEmitter.Transparency = NumberSequence.new(0.2, 1)
                    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.2)
                    ParticleEmitter.Speed = NumberRange.new(4, 12)
                    ParticleEmitter.SpreadAngle = Vector2.new(60, 60)
                    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
                    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
                    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
                    ParticleEmitter.Rate = 120
                    ParticleEmitter.Parent = v73
                    UIUtil.sound("Bubbles", 1, 0.6)
                end

                if not t7.bubbling then
                    t7.bubbling = true
                    v114()
                end

                v94 = (v82 - 16.6) / (v1 - 16.6)
                new = math.clamp(v94, 0, 1)
                new = 9.5 - new * new * (3 - new * 2) * 1.5
                v94 = (v24 * CFrame.new(2.4, 4.2, new)).Position
                new = (v24 * CFrame.new(0, 4, 0)).Position:Lerp(v119 + Vector3.new(0, 6, 0), 0.8)
                aim(CFrame.lookAt(v94, new))
            end
        else
            local v120 = if not (v21 and v21.Parent) then Center + v23 * 105 else v21:GetPivot().Position
            local v121 = v120.X

            new = v120.Z

            local v122 = Vector3.new(v121, v18, new)

            v121 = function() -- line: 709
                -- upvalues: v122 (copy), v72 (ref), v73 (ref), n1 (ref), UIUtil (copy), BossJuice (copy)
                BossJuice.eruption(v122)
                BossJuice.impactFrame(Color3.new(1, 1, 1), 0.6, 0.35)
                UIUtil.sound("BossFirstRoar", 1, 1, 10)
                UIUtil.sound("BigSplash", 1, 0.6)
                UIUtil.sound("SubBoom", 0.9, 0.35)
                n1 = 1.2

                if v73 then
                    v73:Destroy()
                end

                if v72 then
                    UIUtil.tween(v72, 1.5, {
                        Volume = 0
                    })
                end
            end

            if not t7.erupt then
                t7.erupt = true
                v121()
            end

            if v2 <= v82 and not t7.banner then
                t7.banner = true
                showBanner()
            end

            v94 = n1
            n1 = math.max(v94, 0.25)
            v120 = v21 and v21:FindFirstChild("Nessie_Head", true)
            v121 = if not (v120 and v120.Position.Y > v18 - 10) then v122 + Vector3.new(0, 10, 0) else v120.Position
            v94 = (v24 * CFrame.new(2.6, 3.4, 9)).Position
            new = (v24 * CFrame.new(0, 4, 0)).Position:Lerp(v121, 0.75)
            aim(CFrame.lookAt(v94, new))
        end
    end)
end

function t1.init() -- line: 736
    -- upvalues: Remotes (copy), UIUtil (copy), Kit (copy), LocalPlayer (copy), v4 (ref), v5 (ref), ScreenGui (ref), v6 (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BossIntro"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.DisplayOrder = 20
    ScreenGui.Enabled = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    for _, v123 in { true, false } do
        Kit.frame(ScreenGui, {
            Name = "Bar",
            AnchorPoint = Vector2.new(0, v123 and 0 or 1),
            Position = UDim2.fromScale(0, v123 and 0 or 1),
            Size = UDim2.fromScale(1, 0.09),
            BackgroundColor3 = Color3.new(0, 0, 0)
        })
    end

    v5 = Kit.button(ScreenGui, "SKIP ▶", Color3.fromRGB(60, 70, 90), {
        Name = "Skip",
        ZIndex = 10,
        Visible = false,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -24),
        Size = UDim2.fromOffset(170, 64)
    }, function() -- line: 749
        -- upvalues: Remotes (copy), v4 (ref)
        v4 = true
        Remotes.Boss:FireServer("SkipIntro")
    end)
    v5.Label.ZIndex = 11
    UIUtil.onScale(function(p30) -- line: 754
        -- upvalues: v5 (ref)
        local v124 = math.max(p30, 0.6)

        v5.Size = UDim2.fromOffset(v124 * 170, v124 * 64)
    end)
    v6 = Kit.frame(ScreenGui, {
        Name = "Fade",
        BackgroundTransparency = 1,
        ZIndex = 5,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0)
    })
end

return t1
