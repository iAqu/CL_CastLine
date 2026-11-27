-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Economy = require(ReplicatedStorage.Shared.Economy)
local SubArena = require(ReplicatedStorage.Shared.SubArena)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local Poses = require(script.Parent.Parent.Character.Poses)
local Controls = require(script.Parent.Parent.Character.Controls)
local TripUi = require(script.Parent.Parent.World2Trip.TripUi)
local TripSet = require(script.Parent.Parent.World2Trip.TripSet)
local BossJuice = require(script.Parent.Parent.Boss.BossJuice)
local SubFleet = require(script.Parent.SubFleet)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local LocalPlayer = Players.LocalPlayer
local IntroTime = Economy.SubBoss.IntroTime
local v1 = false
local t1 = {}

function t1.isPlaying() -- line: 43
    -- upvalues: v1 (ref)
    return v1
end

local function smooth(p1) -- line: 47
    local v2 = math.clamp(p1, 0, 1)

    return v2 * v2 * (3 - v2 * 2)
end

local function lerp(p2, p3, p4) -- line: 52
    return p2 + (p3 - p2) * p4
end

local function readyFace(p5) -- line: 58
    local Head = p5:FindFirstChild("Head")
    local t2 = {}

    if Head then
        local face = Head:FindFirstChild("face")

        if face and face:IsA("Decal") then
            local Texture = face.Texture

            face.Texture = "rbxassetid://11315159"
            table.insert(t2, function() -- line: 66
                -- upvalues: face (copy), Texture (copy)
                face.Texture = Texture
            end)
        end

        local FaceControls = Head:FindFirstChildOfClass("FaceControls")

        if FaceControls then
            for v4, v5 in {
                    LeftBrowLowerer = 0.8,
                    RightBrowLowerer = 0.8,
                    Corrugator = 0.5,
                    LipPresser = 0.6,
                    LeftLipCornerPuller = 0.35,
                    LeftEyeClosed = 0.2,
                    RightEyeClosed = 0.2,
                    ChinRaiser = 0.3
                } do
                local function v6() -- line: 77
                    -- upvalues: FaceControls (copy), v4 (copy)
                    return FaceControls[v4]
                end

                local ok, result = pcall(v6)

                if ok then
                    local function v7() -- line: 80
                        -- upvalues: FaceControls (copy), v4 (copy), v5 (copy)
                        FaceControls[v4] = v5
                    end

                    if pcall(v7) then
                        table.insert(t2, function() -- line: 83
                            -- upvalues: FaceControls (copy), v4 (copy), result (copy)
                            local function v9() -- line: 84
                                -- upvalues: FaceControls (copy), v4 (copy), result (copy)
                                FaceControls[v4] = result
                            end

                            pcall(v9)
                        end)
                    end
                end
            end
        end
    end

    return function() -- line: 92
        -- upvalues: t2 (copy)
        for _, v10 in t2 do
            v10()
        end
    end
end

local function hideOthers() -- line: 100
    -- upvalues: Players (copy), SubFleet (copy), LocalPlayer (copy)
    local t3 = {}

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character then
            for _, descendant in player.Character:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = 1
                    end

                    table.insert(t3, descendant)
                end
            end
        end
    end

    SubFleet.showOthers(false)

    return function() -- line: 115
        -- upvalues: t3 (copy), SubFleet (copy)
        for _, v11 in t3 do
            if v11.Parent and v11:IsA("BasePart") then
                v11.LocalTransparencyModifier = 0
            end
        end

        SubFleet.showOthers(true)
    end
end

local function floorY() -- line: 126
    local v12 = RaycastParams.new()

    v12.FilterType = Enum.RaycastFilterType.Include

    local Map = workspace:FindFirstChild("Map")

    v12.FilterDescendantsInstances = {
        Map and Map:FindFirstChild("World2") or workspace
    }

    local v13 = workspace:Raycast(Vector3.new(6, -965, -5838), Vector3.new(0, -80, 0), v12)

    if v13 then
        return v13.Position.Y
    end

    return -990
end

local function subPath(p6, p7) -- line: 136
    -- upvalues: SubArena (copy)
    local v15 = math.clamp((p6 - 6.5) / 5.6, 0, 1)
    local v16 = v15 * v15 * (3 - v15 * 2)
    local v17 = 9760 + (p7.Position.X - 9760) * v16
    local v19 = math.clamp((9465 - v17) / 50, 0, 1)
    local v20 = v19 * v19 * (3 - v19 * 2)
    local Z = SubArena.CRACK.Z
    local v21 = Z + (p7.Position.Z - Z) * v20
    local v22 = SubArena.FLOOR_Y + 22
    local v26 = Vector3.new(v17, v22 + (p7.Position.Y - v22) * v20 + math.sin(p6 * 1.3) * 0.6, v21)

    return CFrame.lookAt(v26, v26 - Vector3.new(1, 0, 0)) * CFrame.Angles(0, 0, math.sin(p6 * 0.9) * 0.03)
end

local v29 = SubArena.yawOf((Vector3.new(-1, -0, -0, -0)))
local v30 = SubArena.yawOf((Vector3.new(1, 0, 0)))

local function monsterAt(p8) -- line: 151
    -- upvalues: SubArena (copy), v29 (copy), v30 (copy)
    local MONSTER_START = SubArena.MONSTER_START
    local v32 = math.clamp((p8 - 13.4) / 2, 0, 1)
    local v33 = v32 * v32 * (3 - v32 * 2)
    local v34 = v29 + (v30 - v29) * v33
    local v35 = SubArena.monsterPivot(MONSTER_START, v34)
    local t5 = {
        walk = 0.1,
        speed = 0.8,
        open = 0.25,
        raise = 0,
        prop = 0.4,
        jaw = (math.sin(p8 * 1.4) + 1) * 0.05 + 0.08
    }

    if p8 < 13.4 then
        return v35, t5
    end

    if p8 < 15.6 then
        return v35, {
            walk = 0.8,
            speed = 1.6,
            open = 0.35,
            raise = 0,
            jaw = 0.15,
            prop = 0.8
        }
    end

    local v38 = math.clamp((p8 - 15.6) / 0.5, 0, 1)
    local v39 = v38 * v38 * (3 - v38 * 2)
    local v40 = if not (p8 > 16 and p8 < 18) then 0 else math.sin(p8 * 37) * 0.012

    return v35 * CFrame.Angles(v39 * -0.12 + v40, 0, v40), {
        walk = 0.15,
        speed = 1,
        open = v39 * 0.6 + 0.4,
        snap = p8 > 16.6 and p8 < 17.8,
        raise = v39 * 0.85,
        jaw = v39,
        prop = v39 * 2 + 1
    }
end

local function shakeCam(p9, p10) -- line: 169
    -- upvalues: Settings (copy)
    if p10 <= 0 or not Settings.get("Shake") then
        return p9
    end

    return p9 * CFrame.new((math.random() - 0.5) * p10, (math.random() - 0.5) * p10, 0) * CFrame.Angles(0, 0, (math.random() - 0.5) * p10 * 0.02)
end

function t1.play(p11, p12, p13) -- line: 177
    -- upvalues: RunService (copy), SubArena (copy), Remotes (copy), UIUtil (copy), Poses (copy), Controls (copy), TripUi (copy), TripSet (copy), BossJuice (copy), SubFleet (copy), Kit (copy), LocalPlayer (copy), IntroTime (copy), v1 (ref), readyFace (copy), hideOthers (copy), floorY (copy), subPath (copy), monsterAt (copy), shakeCam (copy)
    local Character = LocalPlayer.Character
    local v43, v44

    if Character then
        v43 = Character:FindFirstChild("HumanoidRootPart")
        v44 = Character:FindFirstChildOfClass("Humanoid")
    else
        v44 = Character
        v43 = Character
    end

    local SubBossIntroAt = workspace:GetAttribute("SubBossIntroAt")
    local CurrentCamera, v45, Head, v46, v47, t7, t8, v48, v49

    if v1 then
        v49 = true
    elseif v43 and v44 and type(SubBossIntroAt) == "number" then
        v1 = true
        CurrentCamera = workspace.CurrentCamera
        v45 = SubArena.start(p11, p12)
        Head = Character:FindFirstChild("Head")

        local v50 = floorY()

        v46 = CFrame.lookAt(Vector3.new(6, v50 + v44.HipHeight + v43.Size.Y / 2, -5838), (Vector3.new(6, v50 + v44.HipHeight + v43.Size.Y / 2, -5811)))
        Controls.lock("SubIntro")
        v43.Anchored = true
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        TripUi.open()
        TripUi.letterbox(true, 0.01)
        v47 = hideOthers()
        t7 = {}
        t7[1] = nil
        SubFleet.holdMonster(monsterAt)
        t8 = {}

        local t9 = t8

        local function at(p14, p15, p16, p17) -- line: 200
            -- upvalues: t9 (copy)
            if p15 <= p14 and not t9[p16] then
                t9[p16] = true
                p17()
            end
        end

        v48 = UIUtil.sound("Reel", 0, 0.3, 60)

        if v48 then
            v48.Looped = true
        end

        v49 = false
    else
        v49 = true
    end

    if v49 then
        return
    end

    local Part
    local n1 = 0
    local v54

    local function pose(p18) -- line: 214
        -- upvalues: v54 (ref), Poses (copy)
        if v54 ~= p18 then
            v54 = p18
            Poses.play(p18)
        end
    end

    local function now() -- line: 220
        -- upvalues: SubBossIntroAt (copy)
        return workspace:GetServerTimeNow() - SubBossIntroAt
    end

    local v55 = false
    local ScreenGui

    if (LocalPlayer:GetAttribute("SubBossesFought") or 0) >= 2 then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SubIntroSkip"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.DisplayOrder = 40
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        local v56 = math.max(UIUtil.scale, 0.6)

        Kit.button(ScreenGui, "SKIP ▶", Color3.fromRGB(60, 70, 90), {
            Name = "Skip",
            ZIndex = 10,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -24, 1, -24),
            Size = UDim2.fromOffset(v56 * 170, v56 * 64)
        }, function() -- line: 234
            -- upvalues: v55 (ref), Remotes (copy)
            v55 = true
            Remotes.SubBoss:FireServer("SkipIntro")
        end).Label.ZIndex = 11
    end

    local n2 = 0
    local v57, v58, v59

    while v1 do
        local v60 = RunService.RenderStepped:Wait()
        local v61 = workspace:GetServerTimeNow() - SubBossIntroAt

        if IntroTime <= v61 or v55 then
            break
        end

        local v62 = v60 * 1.5
        local v64 = math.max(0, n1 - v62)

        n1 = v64

        local v65 = subPath(v61, v45)

        n2 += (if v61 > 6 then 9 else 0) * v60
        SubFleet.place(LocalPlayer, if v61 < 4.6 then subPath(6.5, v45) else v65, n2, 0)

        local _ = CurrentCamera.CFrame
        local v67, v68

        if v61 < 4.6 then
            v43.CFrame = v46

            if v54 ~= "LookUp" then
                v54 = "LookUp"
                v57 = "LookUp"
                Poses.play("LookUp")
            end

            if v61 < 2.4 then
                local v70 = math.clamp(v61 / 2.4, 0, 1)
                local v71 = v70 * v70 * (3 - v70 * 2)
                local v72 = v46 * CFrame.new(5, 0.5 - v71 * 0.5, 9 - v71 * 2)

                v67 = CFrame.lookAt(v72.Position, (Vector3.new(6, -962, -5811)))
                v68 = 60
            else
                local Position = Head and Head.Position or v46.Position
                local v73 = v46 * CFrame.new(-2, -1.2, -5.5)

                v67 = CFrame.lookAt(v73.Position, Position + Vector3.new(0, 0.6, 0))

                local v75 = math.clamp((v61 - 2.4) / 2, 0, 1)

                v68 = 55 + -10 * (v75 * v75 * (3 - v75 * 2))
            end

            local function v76() -- line: 267
                -- upvalues: Part (ref), n1 (ref), UIUtil (copy), TripSet (copy), SubFleet (copy)
                UIUtil.sound("BossFirstRoar", 0.85, 0.55, 10)
                UIUtil.sound("Rumble", 0.8, 0.5)
                n1 = 0.8
                Part = Instance.new("Part")

                local Part2 = Part
                local Part3 = Part
                local Part4 = Part
                local Part5 = Part

                Part2.Anchored = true
                Part3.CanCollide = false
                Part4.CanQuery = false
                Part5.CanTouch = false
                Part.Transparency = 1
                Part.Size = Vector3.new(26, 2, 6)

                local Part6 = Part

                Part6.CFrame = CFrame.new((Vector3.new(6, -944, -5814)))

                local Part7 = Part

                Part7.Parent = SubFleet.folder() or workspace
                TripSet.emitter(Part, {
                    Acceleration = Vector3.new(0, -14, 0),
                    Rate = 60,
                    Color = ColorSequence.new(Color3.fromRGB(150, 160, 185)),
                    Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.4),
                        NumberSequenceKeypoint.new(1, 1.2)
                    }),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.2),
                        NumberSequenceKeypoint.new(1, 1)
                    }),
                    Lifetime = NumberRange.new(1.5, 2.5),
                    Speed = NumberRange.new(0, 2),
                    Shape = Enum.ParticleEmitterShape.Box,
                    ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
                })
            end

            if v61 >= 1.5 and not t8.roar1 then
                t8.roar1 = true
                v76()
            end

            if v61 >= 3.3 and not t8.roar2 then
                t8.roar2 = true
                UIUtil.sound("BossGrowl", 0.6, 0.5)
                n1 = math.max(n1, 0.4)
            end

            local function v78() -- line: 293
                -- upvalues: TripUi (copy)
                task.spawn(TripUi.fade, true, 0.6)
            end

            if v61 >= 3.9 and not t8.black then
                t8.black = true
                task.spawn(TripUi.fade, true, 0.6)
            end
        elseif v61 < 6.5 then
            local v79

            if not (v61 >= 4.6) or t8.intoSub then
                v79 = v58
            else
                t8.intoSub = true
                TripUi.black(true)

                if Part then
                    Part:Destroy()
                    Part = nil
                else
                    v79 = v58
                end
            end

            v43.CFrame = SubFleet.rootFrame(LocalPlayer, v65) or v43.CFrame

            if v54 ~= "Drive" then
                v54 = "Drive"
                v57 = "Drive"
                Poses.play("Drive")
            end

            if v48 then
                local v81 = math.clamp((v61 - 4.6) / 1.9, 0, 1)

                v48.Volume = v81 * v81 * (3 - v81 * 2) * 0.25
            end

            local v82 = v65 * CFrame.new(16, 7, 26)

            v58 = v79
            v67 = CFrame.lookAt(v82.Position, (v65 * CFrame.new(0, 0, -30)).Position)
            v68 = 70
        else
            v43.CFrame = SubFleet.rootFrame(LocalPlayer, v65) or v43.CFrame

            local function v84() -- line: 314
                -- upvalues: UIUtil (copy), TripUi (copy)
                task.spawn(TripUi.fade, false, 0.8)
                UIUtil.sound("BubbleSwell", 0.5, 0.9)
            end

            if v61 >= 6.5 and not t8.fadeUp then
                t8.fadeUp = true
                task.spawn(TripUi.fade, false, 0.8)
                UIUtil.sound("BubbleSwell", 0.5, 0.9)
            end

            if v61 < 9 then
                if v54 ~= "Drive" then
                    v54 = "Drive"
                    v57 = "Drive"
                    Poses.play("Drive")
                end

                local v85 = v65 * CFrame.new(4, 11, 62)

                v67 = CFrame.lookAt(v85.Position, (v65 * CFrame.new(0, 0, -40)).Position)
                v68 = 66
            elseif v61 < 11.5 then
                if v54 ~= "Drive" then
                    v54 = "Drive"
                    v57 = "Drive"
                    Poses.play("Drive")
                end

                local v89 = Vector3.new(9345, SubArena.FLOOR_Y + 30, SubArena.CRACK.Z + 55)

                v67 = CFrame.lookAt(v89, v65.Position:Lerp(SubArena.CRACK, 0.3))
                v68 = 62
            elseif v61 < 13.4 then
                if v54 ~= "Drive" then
                    v54 = "Drive"
                    v57 = "Drive"
                    Poses.play("Drive")
                end

                if v61 >= 11.6 and not t8.spot then
                    t8.spot = true
                    UIUtil.sound("TripGasp", 0.6, 1)

                    if v48 then
                        UIUtil.tween(v48, 1.5, {
                            Volume = 0.08
                        })
                    end
                end

                local v91 = v65 * CFrame.new(14, 16, 52)

                v67 = CFrame.lookAt(v91.Position, SubArena.MONSTER_START + Vector3.new(0, 34, 0))

                local v93 = math.clamp((v61 - 11.5) / 1.9, 0, 1)

                v68 = 60 + -8 * (v93 * v93 * (3 - v93 * 2))
            elseif v61 < 15.6 then
                local v95

                if v54 == "Cower" then
                    v95 = v57
                else
                    v54 = "Cower"
                    v95 = "Cower"
                    Poses.play("Cower")
                end

                local function v96() -- line: 345
                    -- upvalues: UIUtil (copy)
                    UIUtil.sound("BossGrowl", 0.9, 0.45)
                    UIUtil.sound("MetalClang", 0.4, 0.35)
                    UIUtil.sound("Rumble", 0.6, 0.6)
                end

                if v61 >= 13.4 and not t8.turn then
                    t8.turn = true
                    UIUtil.sound("BossGrowl", 0.9, 0.45)
                    UIUtil.sound("MetalClang", 0.4, 0.35)
                    UIUtil.sound("Rumble", 0.6, 0.6)
                end

                local v99 = Vector3.new(9370, SubArena.FLOOR_Y + 12, SubArena.CRACK.Z + 120)

                v57 = v95
                v67 = CFrame.lookAt(v99, SubArena.MONSTER_START + Vector3.new(0, 30, 0))
                v68 = 58
            elseif v61 < 18 then
                local v101

                if v54 == "Cower" then
                    v101 = v57
                else
                    v54 = "Cower"
                    v101 = "Cower"
                    Poses.play("Cower")
                end

                local function v102() -- line: 356
                    -- upvalues: n1 (ref), UIUtil (copy), TripUi (copy), BossJuice (copy)
                    UIUtil.sound("BossRoar", 1, 0.7, 10)
                    UIUtil.sound("BossFirstRoar", 0.6, 0.6, 10)
                    n1 = 1.6
                    BossJuice.fovPunch(-6, 0.6)
                    TripUi.title("BOSS", "HULLBREAKER", 2.1, Color3.fromRGB(255, 80, 70))
                end

                if v61 >= 15.9 and not t8.roar then
                    t8.roar = true
                    v102()
                end

                local v104 = math.clamp((v61 - 15.6) / 2.4, 0, 1)
                local v105 = v104 * v104 * (3 - v104 * 2)
                local v108 = SubArena.MONSTER_START + Vector3.new(70, 0, 0) + Vector3.new(40 + -15 * v105, 10, 6)

                v57 = v101
                v67 = CFrame.lookAt(v108, SubArena.MONSTER_START + Vector3.new(30, 52, 0))
                v68 = 66 + -8 * v105
            elseif v61 < 21 then
                local v110, v111

                if not (v61 >= 18) or t8.ready then
                    v110 = v64
                    v111 = v59
                else
                    t8.ready = true

                    local v112 = readyFace(Character)

                    t7[1] = v112
                    n1 = 0
                    UIUtil.sound("LuckHeartbeat", 0.5, 1.3, 3)
                    v111 = v112
                    v110 = 0
                end

                local function v113() -- line: 375
                    -- upvalues: UIUtil (copy)
                    UIUtil.sound("GoodCast", 0.6, 0.8)
                end

                if v61 >= 19.3 and not t8.nod then
                    t8.nod = true
                    UIUtil.sound("GoodCast", 0.6, 0.8)
                end

                if v54 ~= "Ready" then
                    v54 = "Ready"
                    v57 = "Ready"
                    Poses.play("Ready")
                end

                local Position = if Head then Head.Position else nil
                local v114 = if not Head or not Position then v43.Position else Position
                local v116 = math.clamp((v61 - 18) / 3, 0, 1)
                local v117 = v116 * v116 * (3 - v116 * 2)
                local v118 = v114 + v65.LookVector * (6 + -1.4000000000000004 * v117) + Vector3.new(0, 1.7, 0) + v65.RightVector * 1.1

                v59 = v111

                local v119 = v110

                v67 = CFrame.lookAt(v118, v114 + Vector3.new(0, 0.1, 0))
                v68 = 50
            else
                if v54 ~= "Drive" then
                    v54 = "Drive"
                    v57 = "Drive"
                    Poses.play("Drive")
                end

                if v61 >= 21 and not t8.pullBack then
                    t8.pullBack = true
                    TripUi.letterbox(false, 1.2)

                    if t7[1] then
                        t7[1]()
                        v59 = nil
                        t7[1] = nil
                    end
                end

                local function v120() -- line: 395
                    -- upvalues: UIUtil (copy), BossJuice (copy)
                    BossJuice.stamp("FIGHT!", Color3.fromRGB(255, 225, 90), 140, 0.32, 1)
                    UIUtil.sound("BossExplosion", 0.4, 1.2)
                    UIUtil.sound("GoodCast", 0.8, 1)
                end

                if v61 >= 22.1 and not t8.fight then
                    t8.fight = true
                    v120()
                end

                local v122 = math.clamp((v61 - 21) / 2, 0, 1)
                local v123 = v122 * v122 * (3 - v122 * 2)
                local Position = (v65 * CFrame.new(0, 26 + -10 * v123, 95 + -37 * v123)).Position

                v67 = CFrame.lookAt(Position, (v65 * CFrame.new(0, 0, -60)).Position)
                v68 = 70
            end
        end

        local v125 = shakeCam(v67, n1)

        CurrentCamera.CFrame = v125
        CurrentCamera.Focus = v125
        CurrentCamera.FieldOfView = v68
    end

    if v48 then
        v48:Destroy()
    end

    if Part then
        Part:Destroy()
    end

    if t7[1] then
        t7[1]()
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end

    SubFleet.place(LocalPlayer, nil)
    SubFleet.holdMonster(nil)
    v47()
    TripUi.black(false)
    TripUi.close()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    Controls.unlock("SubIntro")
    v1 = false
    p13(SubFleet.rootFrame(LocalPlayer, v45) or v43.CFrame)
end

function t1.stop() -- line: 438
    -- upvalues: v1 (ref)
    v1 = false
end

return t1
