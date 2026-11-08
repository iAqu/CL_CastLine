-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Buddy = require(script.Parent.Buddy)

require(script.Parent.CalmLoop)

local Fx = require(script.Parent.Fx)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    Catch = {
        Seconds = 5.4,
        Turns = 6,
        Sound = "StarOrbitCatch"
    },
    Gift = {
        Seconds = 4.8,
        Turns = 5,
        Sound = "StarOrbitGift"
    }
}
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local t3 = {}

local function folder() -- line: 72
    -- upvalues: Workspace (copy)
    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

    if ShootingStarClient then
        return ShootingStarClient
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "ShootingStarClient"
    Folder.Parent = Workspace

    return Folder
end

local function smooth(p1) -- line: 83
    local v1 = math.clamp(p1, 0, 1)

    return v1 * v1 * (3 - v1 * 2)
end

local function kitChild(p2) -- line: 88
    -- upvalues: Fx (copy)
    local v2 = Fx.Kit()

    return if v2 then v2:FindFirstChild(p2) else nil
end

local function holdPoint(p3, p4) -- line: 93
    local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart == nil then
        return nil
    end

    local LeftHand = p3:FindFirstChild("LeftHand")
    local RightHand = p3:FindFirstChild("RightHand")
    local Head = p3:FindFirstChild("Head")
    local Rotation = HumanoidRootPart.CFrame.Rotation

    if LeftHand and RightHand then
        return CFrame.new((LeftHand.Position + RightHand.Position) / 2 + Vector3.new(0, p4, 0)) * Rotation
    end

    if Head then
        return CFrame.new(Head.Position + Vector3.new(0, Head.Size.Y / 2 + p4 + 1, 0)) * Rotation
    end

    return CFrame.new(HumanoidRootPart.Position + Vector3.new(0, p4 + 4.5, 0)) * Rotation
end

local function emitterRate(p5, p6, p7) -- line: 111
    local PrimaryPart = p5.PrimaryPart
    local Core = PrimaryPart and PrimaryPart:FindFirstChild("Core")
    local v5 = Core and Core:FindFirstChild(p6)

    if v5 and v5:IsA("ParticleEmitter") then
        v5.Rate = p7
    end
end

local function playerTracks(p8) -- line: 120
    -- upvalues: Fx (copy)
    local t4 = {}
    local Humanoid = p8:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")
    local v6 = Fx.Kit()
    local PlayerAnimations = if v6 then v6:FindFirstChild("PlayerAnimations") else nil

    if Animator ~= nil and PlayerAnimations ~= nil then
        for _, child in PlayerAnimations:GetChildren() do
            if child:IsA("Animation") then
                local function v7() -- line: 130
                    -- upvalues: child (copy), Animator (copy)
                    return Animator:LoadAnimation(child)
                end

                local ok, result = pcall(v7)

                if ok and result then
                    result.Priority = Enum.AnimationPriority.Action
                    t4[child.Name] = result
                end
            end
        end
    end

    return t4
end

local function speak(p9, p10, p11) -- line: 142
    -- upvalues: ReplicatedStorage (copy), MessageTyper (copy), LocalPlayer (copy)
    local PrimaryPart = p9.PrimaryPart
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local UI = Assets and Assets:FindFirstChild("UI")
    local Npcs = UI and UI:FindFirstChild("Npcs")
    local Talk_UI = Npcs and Npcs:FindFirstChild("Talk_UI")

    if PrimaryPart ~= nil and PlayerGui ~= nil and Talk_UI ~= nil and Talk_UI:IsA("BillboardGui") then
        local BoundingBox, BoundingBox2 = p9:GetBoundingBox()
        local v8 = p11:Add(Instance.new("Attachment"))

        v8.Name = "StarGuySpeech"
        v8.Position = PrimaryPart.CFrame:PointToObjectSpace(BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0))
        v8.Parent = PrimaryPart

        local v10 = p11:Add(Talk_UI:Clone())

        v10.Name = "StarGuySpeech"
        v10.Adornee = v8
        v10.MaxDistance = 45
        v10.Enabled = true
        v10.Parent = PlayerGui

        local TextLabel = v10:FindFirstChildOfClass("TextLabel")

        if TextLabel == nil then
            return
        end

        TextLabel.Text = ""

        local v11 = MessageTyper.new(TextLabel, nil, 0.06, false)

        p11:Add(function() -- line: 170
            -- upvalues: v11 (copy)
            v11:Halt()
        end)
        v11:Type(p10, TextLabel.TextColor3)
    end
end

local function lobbyHandler(p12) -- line: 176
    -- upvalues: CollectionService (copy)
    for _, v12 in CollectionService:GetTagged("StarHandlerNpc") do
        if v12:IsA("Model") and v12.PrimaryPart ~= nil and v12:GetAttribute("StarHandlerLocallyHidden") ~= true and (v12:GetPivot().Position - p12.Position).Magnitude <= 40 then
            return v12
        end
    end

    return nil
end

local function giftIntro(p13, p14) -- line: 190
    -- upvalues: RunService (copy), Workspace (copy), Buddy (copy), Fx (copy), speak (copy), lobbyHandler (copy)
    local v13 = Fx.Kit()
    local StarGuy = if v13 then v13:FindFirstChild("StarGuy") else nil
    local HumanoidRootPart = p13:FindFirstChild("HumanoidRootPart")

    if StarGuy == nil or not StarGuy:IsA("Model") or HumanoidRootPart == nil then
        return nil, nil, false
    end

    local v14 = lobbyHandler(HumanoidRootPart)

    if v14 then
        local Pivot = v14:GetPivot()
        local Scale = v14:GetScale()

        Fx.Emit("Reveal", Pivot.Position + Vector3.new(0, 4 * Scale / 0.62, 0), 0.6)
        Fx.Sound("BuddyGiggle", v14.PrimaryPart, 0.6, 0.9)
        speak(v14, "A little star, just for you!", p14)

        local v16 = (HumanoidRootPart.Position - Pivot.Position) * Vector3.new(1, 0, 1)
        local v17 = if v16.Magnitude > 0.1 then v16.Unit else Pivot.LookVector

        return v14, Pivot.Position + Vector3.new(0, 4 * Scale / 0.62, 0) + v17 * 1.5, true
    end

    local clone = StarGuy:Clone()
    local v19 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

    if v19.Magnitude < 0.001 then
        v19 = Vector3.new(0, 0, -1)
    end

    local v20 = HumanoidRootPart.Position + v19.Unit * 8
    local v21 = RaycastParams.new()

    v21.FilterType = Enum.RaycastFilterType.Exclude

    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

    if not ShootingStarClient then
        ShootingStarClient = Instance.new("Folder")
        ShootingStarClient.Name = "ShootingStarClient"
        ShootingStarClient.Parent = Workspace
    end

    v21.FilterDescendantsInstances = {
        p13,
        ShootingStarClient
    }

    local v22 = Workspace:Raycast(v20 + Vector3.new(0, 20, 0), Vector3.new(0, -60, 0), v21)
    local v23 = if v22 then v22.Position else v20 - Vector3.new(0, 3, 0)
    local v24 = CFrame.lookAt(v23, (Vector3.new(HumanoidRootPart.Position.X, v23.Y, HumanoidRootPart.Position.Z)))
    local Scale = clone:GetScale()

    clone:ScaleTo(Scale * 0.05)
    clone:PivotTo(v24)

    local ShootingStarClient2 = Workspace:FindFirstChild("ShootingStarClient")

    if not ShootingStarClient2 then
        ShootingStarClient2 = Instance.new("Folder")
        ShootingStarClient2.Name = "ShootingStarClient"
        ShootingStarClient2.Parent = Workspace
    end

    clone.Parent = ShootingStarClient2
    p14:Add(clone)

    local v25 = Buddy.Tracks(clone)

    if v25.Idle then
        v25.Idle:Play(0)
    end

    Fx.Emit("Reveal", v23 + Vector3.new(0, 3, 0), 1)
    Fx.Sound("BuddyPop", v23, 0.8, 0.85)

    local elapsed = os.clock()
    local connection

    connection = p14:Connect(RunService.RenderStepped, function() -- line: 232
        -- upvalues: clone (copy), v24 (copy), Scale (copy), elapsed (copy), connection (ref)
        local v27 = math.clamp((os.clock() - elapsed) / 0.4, 0, 1)

        clone:ScaleTo((math.max(Scale * ((v27 - 1) ^ 3 * 2.70158 + 1 + (v27 - 1) ^ 2 * 1.70158), Scale * 0.05)))
        clone:PivotTo(v24)

        if v27 >= 1 then
            connection:Disconnect()
        end
    end)
    task.delay(0.45, function() -- line: 242
        -- upvalues: p14 (copy), clone (copy), speak (copy)
        if clone.Parent then
            speak(clone, "A little star, just for you!", p14)
        end
    end)

    return clone, v23 + Vector3.new(0, 4 * Scale / 0.62, 0) + v24.LookVector * 1.5, false
end

local function giftOutro(p15, p16) -- line: 250
    -- upvalues: RunService (copy), Fx (copy)
    local Scale = p15:GetScale()
    local Pivot = p15:GetPivot()
    local elapsed = os.clock()

    Fx.Sound("BuddyGiggle", p15.PrimaryPart, 0.6, 0.85)

    local connection

    connection = p16:Connect(RunService.RenderStepped, function() -- line: 256
        -- upvalues: p15 (copy), Scale (copy), Pivot (copy), elapsed (copy), connection (ref), Fx (copy)
        local v33 = math.clamp((os.clock() - elapsed) / 0.35, 0, 1)

        p15:ScaleTo((math.max(Scale * (1 - v33), 0.02)))
        p15:PivotTo(Pivot)

        if not (v33 >= 1) then
            return
        end

        connection:Disconnect()
        Fx.Emit("Collect", Pivot.Position + Vector3.new(0, 3, 0), 1)
        p15:Destroy()
    end)
end

function t3.Play(p17, p18) -- line: 272
    -- upvalues: RunService (copy), Workspace (copy), Buddy (copy), Fx (copy), Trove (copy), t1 (copy), LocalPlayer (copy), t2 (copy), holdPoint (copy), playerTracks (copy), giftIntro (copy), giftOutro (copy)
    local Character = p17.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if Character ~= nil and HumanoidRootPart ~= nil and not t2[p17] then
        local CurrentCamera = Workspace.CurrentCamera

        if p17 ~= LocalPlayer and CurrentCamera and (CurrentCamera.CFrame.Position - HumanoidRootPart.Position).Magnitude > 320 then
            return
        end

        if Fx.KitReady() then
            local v35 = Fx.Kit()

            if (if v35 then v35:FindFirstChild("Buddy") else nil) ~= nil then
                t2[p17] = true

                local v36 = Trove.new()

                v36:Add(function() -- line: 300
                    -- upvalues: p17 (copy), p18 (copy), t2 (copy)
                    t2[p17] = nil

                    if p18.OnDone then
                        task.spawn(p18.OnDone)
                    end
                end)
                v36:Connect(p17.CharacterRemoving, function() -- line: 306
                    -- upvalues: v36 (copy)
                    v36:Destroy()
                end)

                local v37 = p17 == LocalPlayer
                local v38 = Fx.Kit()
                local Buddy2 = if v38 then v38:FindFirstChild("Buddy") else nil
                local v39 = Buddy2:GetAttribute("HeldScale") or 0.42
                local v40 = Buddy2:GetAttribute("HeldLift") or -0.7

                task.spawn(function() -- line: 315
                    -- upvalues: p18 (copy), Character (copy), v36 (copy), v39 (copy), v40 (copy), HumanoidRootPart (copy), v37 (copy), RunService (copy), Workspace (copy), Buddy (copy), Fx (copy), t1 (copy), holdPoint (copy), playerTracks (copy), giftIntro (copy), giftOutro (copy)
                    local v41
                    local From = p18.From

                    if p18.Kind == "Gift" then
                        local v42, v43, v44 = giftIntro(Character, v36)

                        if not v44 then
                            v41 = v42
                        end

                        task.wait(2.2)

                        if HumanoidRootPart.Parent == nil then
                            v36:Destroy()

                            return
                        end

                        From = v43
                    end

                    local Model = p18.Model
                    local Scale, Scale2

                    if Model then
                        Scale = Model:GetScale()
                        Scale2 = Scale
                    else
                        local Spawn = Buddy.Spawn
                        local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

                        if not ShootingStarClient then
                            ShootingStarClient = Instance.new("Folder")
                            ShootingStarClient.Name = "ShootingStarClient"
                            ShootingStarClient.Parent = Workspace
                        end

                        Model = Spawn(ShootingStarClient, CFrame.new(From or HumanoidRootPart.Position + Vector3.new(0, 3, 0)))
                        Scale = if p18.Kind == "Gift" then v39 * 0.5 else Model:GetScale()
                        Scale2 = Scale
                        Model:ScaleTo(Scale)
                        Fx.Emit("Reveal", Model:GetPivot().Position, 0.7)
                    end

                    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

                    if not ShootingStarClient then
                        ShootingStarClient = Instance.new("Folder")
                        ShootingStarClient.Name = "ShootingStarClient"
                        ShootingStarClient.Parent = Workspace
                    end

                    Model.Parent = ShootingStarClient
                    v36:Add(Model)

                    local PrimaryPart = Model.PrimaryPart

                    PrimaryPart.Anchored = true

                    local v45 = Buddy.CalmIdle(Model)

                    if v45 then
                        v45:Play(0.1)
                        v45:SetSpeed(1.4)
                    end

                    v36:Add(function() -- line: 351
                        -- upvalues: v45 (copy)
                        if v45 then
                            v45:Stop(0)
                        end
                    end)

                    local PrimaryPart2 = Model.PrimaryPart
                    local Core = PrimaryPart2 and PrimaryPart2:FindFirstChild("Core")
                    local Twinkles = Core and Core:FindFirstChild("Twinkles")

                    if Twinkles and Twinkles:IsA("ParticleEmitter") then
                        Twinkles.Rate = 55
                    end

                    local PrimaryPart3 = Model.PrimaryPart
                    local Core2 = PrimaryPart3 and PrimaryPart3:FindFirstChild("Core")
                    local Stardust = Core2 and Core2:FindFirstChild("Stardust")

                    if Stardust and Stardust:IsA("ParticleEmitter") then
                        Stardust.Rate = 18
                    end

                    local v48 = math.clamp(math.floor(p18.Count or 1), 1, 10)
                    local t6 = {}

                    for i = 2, v48 do
                        local Spawn = Buddy.Spawn
                        local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

                        if not ShootingStarClient then
                            ShootingStarClient = Instance.new("Folder")
                            ShootingStarClient.Name = "ShootingStarClient"
                            ShootingStarClient.Parent = Workspace
                        end

                        local v49 = Spawn(ShootingStarClient, PrimaryPart.CFrame)

                        v49:ScaleTo(Scale * 0.8)
                        v36:Add(v49)

                        local PrimaryPart2 = v49.PrimaryPart

                        PrimaryPart2.Anchored = true

                        local v50 = Buddy.CalmIdle(v49)

                        if v50 then
                            v50:Play(0.1)
                            v50:Seek(i * 0.37)
                        end

                        local PrimaryPart3 = v49.PrimaryPart
                        local Core = PrimaryPart3 and PrimaryPart3:FindFirstChild("Core")
                        local Twinkles = Core and Core:FindFirstChild("Twinkles")

                        if Twinkles and Twinkles:IsA("ParticleEmitter") then
                            Twinkles.Rate = 20
                        end

                        local PrimaryPart4 = v49.PrimaryPart
                        local Core2 = PrimaryPart4 and PrimaryPart4:FindFirstChild("Core")
                        local Stardust = Core2 and Core2:FindFirstChild("Stardust")

                        if Stardust and Stardust:IsA("ParticleEmitter") then
                            Stardust.Rate = 6
                        end

                        table.insert(t6, {
                            Model = v49,
                            Idle = v50,
                            Root = PrimaryPart2,
                            Offset = (i - 1) / v48 * 3.141592653589793 * 2,
                            Index = i
                        })
                    end

                    local function haloFrame(p19, p20, p21) -- line: 383
                        local v51 = p19.Offset + p21 * 2.2
                        local v54 = Vector3.new(math.cos(v51), 0, (math.sin(v51))) * 1.7
                        local v56 = math.sin(p21 * 3 + p19.Index) * 0.15

                        return CFrame.new(p20.Position + Vector3.new(0, v56 + 1.5, 0) + v54) * p20.Rotation * CFrame.Angles(0, 0, math.sin(p21 * 5 + p19.Index) * 0.2)
                    end

                    local PrimaryPartPosition = PrimaryPart.Position
                    local v60 = PrimaryPartPosition - HumanoidRootPart.Position
                    local v61 = math.atan2(v60.Z, v60.X)
                    local v62 = math.clamp(Vector3.new(v60.X, 0, v60.Z).Magnitude, 3, 9)
                    local Y = v60.Y

                    Fx.Sound("BuddyCaught", PrimaryPart, 0.75)
                    Fx.Sound("BuddyGiggle", PrimaryPart, 0.6, 1.25)
                    Fx.Emit("Collect", PrimaryPartPosition, 0.6)

                    local v63 = t1[p18.Kind] or t1.Catch
                    local Seconds, Turns = v63.Seconds, v63.Turns
                    local n1 = 0
                    local v64 = if v37 then playerTracks(Character) else {}
                    local elapsed = os.clock()

                    if v37 then
                        Fx.Sound(v63.Sound, nil, 0.85)
                    else
                        Fx.Sound(("%*Mono"):format(v63.Sound), PrimaryPart, 0.7)
                    end

                    local v65 = false
                    local v66 = false
                    local n2 = 0
                    local n3 = 0

                    v36:Connect(RunService.RenderStepped, function() -- line: 418
                        -- upvalues: v41 (ref), Model (ref), Scale2 (ref), PrimaryPart (copy), v45 (copy), t6 (copy), haloFrame (copy), v61 (copy), v62 (copy), Y (copy), Seconds (copy), Turns (copy), n1 (ref), elapsed (copy), v65 (ref), v66 (ref), n2 (ref), n3 (ref), v64 (copy), p18 (copy), Character (copy), v36 (copy), v39 (copy), v40 (copy), HumanoidRootPart (copy), Fx (copy), holdPoint (copy), giftOutro (copy)
                        if v65 or HumanoidRootPart.Parent == nil then
                            return
                        end

                        local v67 = os.clock() - elapsed

                        if v45 then
                            v45:Step(true)
                        end

                        for _, v68 in t6 do
                            if v68.Idle then
                                v68.Idle:Step(true)
                            end
                        end

                        if v67 < Seconds then
                            local v69 = v67 / Seconds
                            local v70 = v69 ^ 1.9 * Turns

                            if math.floor(v70) > n1 then
                                n1 = math.floor(v70)

                                if p18.OnLap then
                                    task.spawn(p18.OnLap, n1)
                                end
                            end

                            local v72 = math.clamp(1.9 * v69 ^ 0.8999999999999999, 0.2, 2.4)
                            local v73 = v72 * 40 + 25
                            local PrimaryPart2 = Model.PrimaryPart
                            local Core = PrimaryPart2 and PrimaryPart2:FindFirstChild("Core")
                            local Twinkles = Core and Core:FindFirstChild("Twinkles")

                            if Twinkles and Twinkles:IsA("ParticleEmitter") then
                                Twinkles.Rate = v73
                            end

                            local v74 = v72 * 10 + 6
                            local PrimaryPart3 = Model.PrimaryPart
                            local Core2 = PrimaryPart3 and PrimaryPart3:FindFirstChild("Core")
                            local Stardust = Core2 and Core2:FindFirstChild("Stardust")

                            if Stardust and Stardust:IsA("ParticleEmitter") then
                                Stardust.Rate = v74
                            end

                            local v75 = v61 + v70 * 3.141592653589793 * 2
                            local v77 = math.clamp(v69 / 0.25, 0, 1)
                            local v78 = v77 * v77 * (3 - v77 * 2)
                            local v80 = math.clamp((v69 - 0.7) / 0.3, 0, 1)
                            local v81 = v80 * v80 * (3 - v80 * 2)
                            local v82 = v62 + (4.2 - v62) * v78
                            local v83 = v82 + (2.4 - v82) * v81
                            local v84 = holdPoint(Character, v40)
                            local v85 = v84.Position.Y - HumanoidRootPart.Position.Y
                            local v86 = Y + (1.2 - Y) * v78
                            local v89 = v86 + (v85 + 0.6 - v86) * v81 + math.sin(v70 * 3.141592653589793) * 0.6 * (1 - v81)
                            local Position = HumanoidRootPart.Position
                            local v92 = Position + Vector3.new(math.cos(v75) * v83, v89, math.sin(v75) * v83)
                            local v95 = Vector3.new(-math.sin(v75), 0, (math.cos(v75)))
                            local v97 = math.clamp((v69 - 0.88) / 0.12, 0, 1)
                            local v98 = v97 * v97 * (3 - v97 * 2)
                            local v99 = v92:Lerp(v84.Position, v98)
                            local Scale = Scale2
                            local v100 = v39 - Scale2
                            local v101 = math.clamp(v69, 0, 1)

                            Model:ScaleTo(Scale + v100 * (v101 * v101 * (3 - v101 * 2)))
                            PrimaryPart.CFrame = CFrame.lookAt(v99, v99 + v95):Lerp(CFrame.new(v99) * v84.Rotation, v98) * CFrame.Angles(0, 0, math.sin(v67 * 9) * 0.25 * (1 - v98))

                            local elapsed = os.clock()

                            for _, v104 in t6 do
                                local v107 = v61 + (math.clamp(v67 - v104.Index * 0.08, 0, Seconds) / Seconds) ^ 1.9 * Turns * 3.141592653589793 * 2 + v104.Offset
                                local v109 = v83 * (math.sin(v104.Index * 1.7) * 0.12 + 0.9)
                                local v111 = v89 + math.sin(v104.Index * 2.3) * 0.7 * (1 - v81)
                                local v114 = Position + Vector3.new(math.cos(v107) * v109, v111, math.sin(v107) * v109)
                                local v115 = haloFrame(v104, v84, elapsed)
                                local v118 = Vector3.new(-math.sin(v107), 0, (math.cos(v107)))
                                local v119 = CFrame.lookAt(v114, v114 + v118)

                                v104.Root.CFrame = v119:Lerp(v115, v98)

                                local Model = v104.Model
                                local v120 = Scale2 * 0.8
                                local v121 = v39 * 0.55 - Scale2 * 0.8
                                local v122 = math.clamp(v69, 0, 1)

                                Model:ScaleTo(v120 + v121 * (v122 * v122 * (3 - v122 * 2)))
                            end
                        else
                            if not v66 then
                                v66 = true
                                n2 = os.clock()
                                Model:ScaleTo(v39)

                                local PrimaryPart2 = Model.PrimaryPart
                                local Core = PrimaryPart2 and PrimaryPart2:FindFirstChild("Core")
                                local Twinkles = Core and Core:FindFirstChild("Twinkles")

                                if Twinkles and Twinkles:IsA("ParticleEmitter") then
                                    Twinkles.Rate = 22
                                end

                                local PrimaryPart3 = Model.PrimaryPart
                                local Core2 = PrimaryPart3 and PrimaryPart3:FindFirstChild("Core")
                                local Stardust = Core2 and Core2:FindFirstChild("Stardust")

                                if Stardust and Stardust:IsA("ParticleEmitter") then
                                    Stardust.Rate = 6
                                end

                                Fx.Emit("Reveal", PrimaryPart.Position, 0.35)

                                if v64.Raise then
                                    v64.Raise:Play(0.08)
                                end

                                if v64.Hold then
                                    task.delay(0.3, function() -- line: 503
                                        -- upvalues: v65 (ref), v64 (copy)
                                        if not v65 then
                                            v64.Hold:Play(0.15)
                                        end
                                    end)
                                end

                                if p18.OnRaised then
                                    task.spawn(p18.OnRaised)
                                end

                                if v41 then
                                    task.delay(0.8, function() -- line: 513
                                        -- upvalues: v41 (ref), v36 (copy), giftOutro (copy)
                                        if v41.Parent then
                                            giftOutro(v41, v36)
                                        end
                                    end)
                                end
                            end

                            local v123 = os.clock() - n2
                            local v124 = holdPoint(Character, v40)

                            if v123 < 2.8 then
                                local v126 = math.sin(v123 * 4) * 0.12
                                local v128 = math.sin(v123 * 7) * 0.10471975511965978

                                PrimaryPart.CFrame = v124 * CFrame.new(0, v126, 0) * CFrame.Angles(0, 0, v128)

                                local elapsed = os.clock()

                                for _, v129 in t6 do
                                    v129.Root.CFrame = haloFrame(v129, v124, elapsed)
                                end
                            else
                                if n3 == 0 then
                                    n3 = os.clock()
                                    Fx.Sound("BuddyStow", HumanoidRootPart, 0.7)

                                    for _, v130 in v64 do
                                        v130:Stop(0.3)
                                    end
                                end

                                local v132 = math.clamp((os.clock() - n3) / 0.45, 0, 1)
                                local v133 = v132 * v132
                                local v134 = v124.Position:Lerp(HumanoidRootPart.Position, v133)
                                local v135 = v39 * (1 - v133)

                                Model:ScaleTo((math.max(v135, 0.02)))
                                PrimaryPart.CFrame = CFrame.new(v134) * v124.Rotation * CFrame.Angles(0, v132 * 8, 0)

                                local elapsed = os.clock()

                                for _, v136 in t6 do
                                    local v137 = haloFrame(v136, v124, elapsed)

                                    v136.Root.CFrame = CFrame.new(v137.Position:Lerp(HumanoidRootPart.Position, v133)) * CFrame.Angles(0, v132 * 8, 0)
                                    v136.Model:ScaleTo((math.max(v39 * 0.55 * (1 - v133), 0.02)))
                                end

                                if v132 >= 1 then
                                    v65 = true
                                    Fx.Emit("Collect", HumanoidRootPart.Position, 0.8)
                                    v36:Destroy()
                                end
                            end
                        end
                    end)
                end)

                return
            end
        end
    elseif p18.Model then
        p18.Model:Destroy()
    end

    if p18.OnDone then
        task.spawn(p18.OnDone)
    end
end

function t3.IsPlaying(p22) -- line: 560
    -- upvalues: t2 (copy)
    return t2[p22] == true
end

return t3
