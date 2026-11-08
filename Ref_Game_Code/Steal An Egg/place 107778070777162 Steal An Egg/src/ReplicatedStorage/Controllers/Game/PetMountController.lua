-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local PetMountFlags = require(ReplicatedStorage.Shared.Flags.PetMountFlags)
local PetMountGeometry = require(ReplicatedStorage.Shared.Modules.PetMountGeometry)
local NightFangHeight = require(ReplicatedStorage.Shared.Modules.NightFangHeight)
local v1, v2
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local v3, v4
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local t1 = {}
local v5 = false
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local Folder
local n1 = 0
local Character = nil

local function basePets() -- line: 24
    -- upvalues: v3 (ref)
    if v3 == nil then
        v3 = require(script.Parent.Plots.ActiveAssetsController)
    end

    return v3
end

local function acknowledge(p1, p2, p3) -- line: 28
    -- upvalues: Players (copy), Remotes (copy)
    if p1 ~= Players.LocalPlayer then
        return
    end

    local Token = p2:GetAttribute("Token")

    task.spawn(function() -- line: 31
        -- upvalues: p3 (copy), Token (copy), Remotes (copy)
        local function v6() -- line: 32
            -- upvalues: p3 (copy), Token (copy), Remotes (copy)
            Remotes.PetMount.Request:InvokeServer("ready", {
                Token = Token,
                Success = p3
            })
        end

        local ok, result = pcall(v6)

        if not ok then
            warn("Pet mount acknowledgement failed: " .. tostring(result))
        end
    end)
end

local function playTransition(p4, p5) -- line: 39
    -- upvalues: Players (copy), ReplicatedStorage (copy), PetMountFlags (copy), v4 (ref), ModelBounds (copy)
    if not p4.Parent or p4.Character ~= p5.Character or p5.Humanoid.Health <= 0 then
        return
    end

    local function v7() -- line: 41
        -- upvalues: p5 (copy), PetMountFlags (copy), ModelBounds (copy)
        local v8, v9 = ModelBounds(p5.Rig)

        return v8, v9, PetMountFlags.IKDistance:Get()
    end

    local v10, v11, v12, v13 = pcall(v7)

    if v10 then
        task.defer(function() -- line: 46
            -- upvalues: p4 (copy), v11 (copy), v12 (copy), v13 (copy), Players (copy), ReplicatedStorage (copy), v4 (ref)
            local function v14() -- line: 47
                -- upvalues: p4 (copy), v11 (copy), v12 (copy), v13 (copy), Players (copy), ReplicatedStorage (copy), v4 (ref)
                if v4 == nil then
                    v4 = require(ReplicatedStorage.Shared.Modules.PetMountEffects)
                end

                v4.Play(v11, v12, v13, p4 == Players.LocalPlayer)
            end

            local ok, result = pcall(v14)

            if not ok then
                warn("Pet mount effect skipped: " .. tostring(result))
            end
        end)
    end
end

local function cleanup(p6, p7) -- line: 55
    -- upvalues: NightFangHeight (copy), t3 (copy), playTransition (copy)
    local v15 = t3[p6]

    if not v15 then
        return
    end

    t3[p6] = nil
    NightFangHeight.Reset(v15.AnimationHeight)

    if v15.JumpGated and v15.Humanoid.Parent then
        v15.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    end

    if p7 then
        playTransition(p6, v15)
    end

    for _, v16 in v15.IKs do
        v16.Enabled = false
        v16:Destroy()
    end

    for _, v17 in v15.Targets do
        v17:Destroy()
    end

    for _, v18 in v15.Tracks do
        v18:Stop(0)
        v18:Destroy()
    end

    for _, v19 in v15.PoseJoints do
        if v19.Parent then
            v19.Transform = CFrame.identity
        end
    end

    if v15.RootMotor and v15.RootMotor.Parent and v15.LastC0 and v15.RootMotor.C0 == v15.LastC0 then
        v15.RootMotor.C0 = v15.OriginalC0
    end

    if v15.RootAttachment and v15.RootAttachment.Parent and v15.LastC0 and v15.RootAttachment.CFrame == v15.LastC0 then
        v15.RootAttachment.CFrame = v15.OriginalC0
    end

    if v15.SeatFollower then
        v15.SeatFollower:Destroy()
    end

    v15.Rig:Destroy()
end

local function clearTarget(p8) -- line: 80
    -- upvalues: v3 (ref), t2 (copy), cleanup (copy)
    cleanup(p8, true)

    local v20 = t2[p8]

    if v20 and v20.UID then
        if v3 == nil then
            v3 = require(script.Parent.Plots.ActiveAssetsController)
        end

        v3.SetMountedPet(p8.UserId, v20.UID, false)
    end

    t2[p8] = nil
end

local function suppressBase(p9, p10) -- line: 86
    -- upvalues: v3 (ref)
    local UID = p10.Model:GetAttribute("UID")

    if typeof(UID) ~= "string" or UID == p10.UID then
        return
    elseif p10.UID then
        if v3 == nil then
            v3 = require(script.Parent.Plots.ActiveAssetsController)
        end

        local v22 = v3

        v22.SetMountedPet(p9.UserId, p10.UID, false)
    end

    p10.UID = UID

    if v3 == nil then
        v3 = require(script.Parent.Plots.ActiveAssetsController)
    end

    v3.SetMountedPet(p9.UserId, UID, true)
end

local function newTarget(p11, p12) -- line: 94
    -- upvalues: v3 (ref), t2 (copy), cleanup (copy), suppressBase (copy)
    if t2[p11] and t2[p11].Model == p12 then
        return
    end

    cleanup(p11, true)

    local v23 = t2[p11]

    if v23 and v23.UID then
        if v3 == nil then
            v3 = require(script.Parent.Plots.ActiveAssetsController)
        end

        v3.SetMountedPet(p11.UserId, v23.UID, false)
    end

    t2[p11] = nil
    t2[p11] = {
        Model = p12,
        AddedAt = os.clock()
    }
    suppressBase(p11, t2[p11])
end

local function loadTrack(p13, p14, p15) -- line: 100
    if not p14 then
        return nil
    end

    local function v24() -- line: 102
        -- upvalues: p13 (copy), p14 (copy), p15 (copy)
        local track = p13:LoadAnimation(p14)

        track.Priority = p15
        track.Looped = true

        return track
    end

    local ok, result = pcall(v24)

    if not ok or not result then
        result = nil
    end

    return result
end

local function build(p16, p17) -- line: 110
    -- upvalues: ReplicatedStorage (copy), HttpService (copy), PetMountFlags (copy), PetMountGeometry (copy), NightFangHeight (copy), v1 (ref), v2 (ref), t3 (copy), Folder (ref), cleanup (copy)
    if v1 == nil then
        v1 = require(ReplicatedStorage.Shared.Modules.AssetRigFactory)
    end

    if v2 == nil then
        v2 = require(ReplicatedStorage.Data.Assets)
    end

    local Character = p16.Character
    local v25 = Character and Character:FindFirstChildOfClass("Humanoid")
    local v26 = Character and Character:FindFirstChild("HumanoidRootPart")
    local Carrier = p17:FindFirstChild("Carrier")
    local RiderSeat = p17:FindFirstChild("RiderSeat")
    local PetRecord = p17:FindFirstChild("PetRecord")
    local ModelScale = p17:GetAttribute("ModelScale")
    local Seat = p17:GetAttribute("Seat")

    if not (v25 and v26 and Carrier and RiderSeat and PetRecord and ModelScale and Seat) then
        return nil
    end

    local v27 = HttpService:JSONDecode(PetRecord.Value)

    if not ReplicatedStorage.AssetModels:FindFirstChild(v27.Category) then
        return nil
    end

    v27.Scale = 1

    local v28, t6

    local function v29() -- line: 128
        -- upvalues: p16 (copy), p17 (copy), Character (copy), Carrier (copy), RiderSeat (copy), ModelScale (copy), Seat (copy), v27 (copy), v28 (ref), t6 (ref), v25 (copy), v26 (copy), PetMountFlags (copy), PetMountGeometry (copy), NightFangHeight (copy), v1 (ref), v2 (ref), Folder (ref)
        v28 = v1.Build(v27, true)
        v28:ScaleTo(ModelScale)
        v28.Name = "MountedPet_" .. p16.UserId
        v28:SetAttribute("UID", p17:GetAttribute("UID"))
        v28:SetAttribute("OwnerUserId", p16.UserId)

        for _, descendant in v28:GetDescendants() do
            if descendant:IsA("LuaSourceContainer")
                or descendant:IsA("Humanoid")
                or descendant:IsA("Tool")
                or descendant:IsA("ProximityPrompt")
                or descendant:IsA("ClickDetector")
                or descendant:IsA("BillboardGui") then
                descendant:Destroy()
            elseif descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = true
                descendant.Anchored = false
            elseif descendant:IsA("Sound") then
                descendant:Stop()
            end
        end

        v28.PrimaryPart.Anchored = true
        v28.PrimaryPart.PivotOffset = CFrame.identity

        local v33 = v28.PrimaryPart.CFrame:ToObjectSpace(v28:GetPivot())
        local v34 = CFrame.new(0, -1, 0) * Seat:Inverse()

        v28:PivotTo(v26.CFrame * v34 * v33)
        v28:SetAttribute("MountOwnsAnimationHeight", true)
        v28.Parent = Folder

        local t7 = {
            [v28.PrimaryPart] = true
        }

        for _, v36 in v28.PrimaryPart:GetConnectedParts(true) do
            t7[v36] = true
        end

        for _, descendant in v28:GetDescendants() do
            if descendant:IsA("BasePart") and not t7[descendant] then
                descendant.Anchored = true
            end
        end

        t6 = {
            Rig = v28,
            Root = v26,
            Carrier = Carrier,
            RiderSeat = RiderSeat,
            Model = p17,
            Character = Character,
            Humanoid = v25,
            RootToPivot = v33,
            RiderToPet = v34,
            IKs = {},
            Targets = {},
            Tracks = {},
            Grips = {},
            PoseJoints = {},
            Seat = PetMountGeometry.EnsureSeat(v28, Seat),
            RestSeat = Seat,
            SeatLocal = Seat
        }
        t6.AnimationHeight = NightFangHeight.New(v28)
        t6.AuthoredSeat = t6.Seat.CFrame

        local MountMaximumAnimationSeatOffset = v28:GetAttribute("MountMaximumAnimationSeatOffset")
        local t10 = t6

        if typeof(MountMaximumAnimationSeatOffset) ~= "number" or not PetMountGeometry.IsFinite(MountMaximumAnimationSeatOffset) then
            t10.SeatTravelLimit = nil
        else
            t10.SeatTravelLimit = math.clamp(MountMaximumAnimationSeatOffset, 0, 32)
        end

        local MountMaximumSeatTiltDegrees = v28:GetAttribute("MountMaximumSeatTiltDegrees")
        local t11 = t6

        if typeof(MountMaximumSeatTiltDegrees) ~= "number" or not PetMountGeometry.IsFinite(MountMaximumSeatTiltDegrees) then
            t11.SeatTiltLimit = 180
        else
            t11.SeatTiltLimit = math.clamp(MountMaximumSeatTiltDegrees, 0, 180)
        end

        for _, descendant in Character:GetDescendants() do
            if descendant:IsA("Motor6D") and descendant.Part0 and descendant.Part1 and descendant.Part0.Parent == Character and descendant.Part1.Parent == Character then
                table.insert(t6.PoseJoints, descendant)
            end
        end

        local Part = Instance.new("Part")

        t6.SeatFollower = Part
        Part.Name = "MountedSeat_" .. p16.UserId
        Part.Size = Vector3.new(0.1, 0.1, 0.1)
        Part.Transparency = 1
        Part.Anchored = false
        Part.Massless = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CFrame = PetMountGeometry.AnimatedWorld(t6.Seat)

        local Attachment = Instance.new("Attachment")

        Attachment.Name = "RiderSeatAttachment"
        Attachment.Parent = Part

        local RigidConstraint = Instance.new("RigidConstraint")

        RigidConstraint.Name = "MountSeatConstraint"
        RigidConstraint.Attachment0 = t6.Seat
        RigidConstraint.Attachment1 = Attachment
        RigidConstraint.Parent = Part
        Part.Parent = Folder

        local LowerTorso = Character:FindFirstChild("LowerTorso")
        local v37, v38

        for _, v39 in LowerTorso and LowerTorso:GetChildren() or {} do
            if v39.Name == "Root" and v39:IsA("Motor6D") then
                v37 = v39
            end

            if v39.Name == "Root" and v39:IsA("AnimationConstraint") and v39.Attachment0 then
                v38 = v39
            end
        end

        if v37 then
            t6.RootMotor = v37
            t6.OriginalC0 = v37.C0
        elseif v38 then
            t6.RootAttachment = v38.Attachment0
            t6.OriginalC0 = v38.Attachment0.CFrame
        end

        local UpperTorso = Character:FindFirstChild("UpperTorso")

        if LowerTorso and UpperTorso then
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "PetMountTorsoTarget"
            Attachment.CFrame = CFrame.Angles(-math.rad((PetMountFlags.TorsoLeanDegrees:Get())), 0, 0)
            Attachment.Parent = v26

            local IKControl = Instance.new("IKControl")

            IKControl.Name = "PetMountTorso"
            IKControl.Type = Enum.IKControlType.Rotation
            IKControl.ChainRoot = LowerTorso
            IKControl.EndEffector = UpperTorso
            IKControl.Target = Attachment
            IKControl.Priority = 0
            IKControl.SmoothTime = 0
            IKControl.Enabled = false
            IKControl.Parent = v25
            t6.TorsoIK = IKControl
            t6.TorsoTarget = Attachment
            table.insert(t6.IKs, IKControl)
            table.insert(t6.Targets, Attachment)
        end

        local function grip(p18, p19, p20, p21, p22) -- line: 237
            -- upvalues: Character (copy), v28 (ref), t6 (ref), v25 (copy), v26 (copy), PetMountGeometry (copy)
            local v41 = PetMountGeometry.EnsureGrip(v28, p21, p22, t6.Seat)
            local v42 = Character:FindFirstChild(p18 .. "Upper" .. p19)
            local v43 = Character:FindFirstChild(p18 .. "Lower" .. p19)
            local v44 = Character:FindFirstChild(p18 .. p20)

            if v42 and v44 then
                local Attachment = Instance.new("Attachment")

                Attachment.Name = "PetMount" .. p18 .. p19 .. "Target"
                Attachment.Parent = v26

                local IKControl = Instance.new("IKControl")

                IKControl.Name = "PetMount" .. p18 .. p19
                IKControl.Type = Enum.IKControlType.Position
                IKControl.Priority = 1
                IKControl.ChainRoot = v42
                IKControl.EndEffector = v44
                IKControl.Target = Attachment
                IKControl.SmoothTime = 0

                if p19 == "Leg" then
                    local Attachment = Instance.new("Attachment")

                    Attachment.Name = "PetMount" .. p18 .. "KneePole"
                    Attachment.CFrame = CFrame.new(p18 == "Left" and -1 or 1, -1, -3)
                    Attachment.Parent = v26
                    IKControl.Pole = Attachment

                    local t15 = t6

                    table.insert(t15.Targets, Attachment)
                end

                IKControl.Enabled = false
                IKControl.Parent = v25
                table.insert(t6.IKs, IKControl)
                table.insert(t6.Targets, Attachment)

                local v45, v46 = PetMountGeometry.LimbReach(v42, v43, v44, p18, p19)

                table.insert(t6.Grips, {
                    Attachment = v41,
                    Target = Attachment,
                    IK = IKControl,
                    Upper = v42,
                    Origin = v45,
                    Reach = v46,
                    SeatOffset = t6.Seat.CFrame:ToObjectSpace(v41.CFrame)
                })
            end
        end

        grip("Left", "Arm", "Hand", "MountLeftHand", p17:GetAttribute("LeftHand") or Seat * PetMountGeometry.DefaultGripOffsets.MountLeftHand)
        grip("Right", "Arm", "Hand", "MountRightHand", p17:GetAttribute("RightHand") or Seat * PetMountGeometry.DefaultGripOffsets.MountRightHand)
        grip("Left", "Leg", "Foot", "MountLeftFoot", p17:GetAttribute("LeftFoot") or Seat * PetMountGeometry.DefaultGripOffsets.MountLeftFoot)
        grip("Right", "Leg", "Foot", "MountRightFoot", p17:GetAttribute("RightFoot") or Seat * PetMountGeometry.DefaultGripOffsets.MountRightFoot)

        local v47 = v28:FindFirstChildWhichIsA("AnimationController", true)

        if not v47 then
            v47 = Instance.new("AnimationController")
            v47.Parent = v28
        end

        local Animator = v47:FindFirstChildOfClass("Animator")

        if not Animator then
            Animator = Instance.new("Animator")
            Animator.Parent = v47
        end

        local v48 = v2.Directory[v27.Category]

        t6.WalkReferenceSpeed = v48.WalkAnimationReferenceSpeed
        t6.AnimationSpeed = 0

        local t18 = t6
        local Idle = v48.Animations.Idle
        local Idle2 = Enum.AnimationPriority.Idle
        local result

        if Idle then
            local Animator2 = Animator

            local function v49() -- line: 102
                -- upvalues: Idle (copy), Idle2 (copy), Animator2 (copy)
                local track = Animator2:LoadAnimation(Idle)

                track.Priority = Idle2
                track.Looped = true

                return track
            end

            local ok

            ok, result = pcall(v49)

            if not ok or not result then
                result = nil
            end
        end

        t18.Idle = result

        local t19 = t6
        local Walk = v48.Animations.Walk
        local Movement = Enum.AnimationPriority.Movement
        local result2

        if Walk then
            local Animator2 = Animator

            local function v50() -- line: 102
                -- upvalues: Walk (copy), Movement (copy), Animator2 (copy)
                local track = Animator2:LoadAnimation(Walk)

                track.Priority = Movement
                track.Looped = true

                return track
            end

            local ok

            ok, result2 = pcall(v50)

            if not ok or not result2 then
                result2 = nil
            end
        end

        t19.Walk = result2

        for _, v51 in {
                t6.Idle,
                t6.Walk
            } do
            if v51 then
                table.insert(t6.Tracks, v51)
            end
        end

        if t6.Idle then
            t6.Idle:Play(0.15)
        end

        local Animator2 = v25:FindFirstChildOfClass("Animator")

        if not Animator2 then
            return
        end

        local Animate = Character:FindFirstChild("Animate")
        local sit = Animate and Animate:FindFirstChild("sit")
        local Animation = sit and sit:FindFirstChildWhichIsA("Animation")
        local Animation2

        if not Animation then
            Animation = Instance.new("Animation")
            Animation2 = Animation
            Animation.AnimationId = "rbxassetid://507768133"
        end

        local Action = Enum.AnimationPriority.Action
        local result3

        if Animation then
            local Animation2 = Animation

            local function v52() -- line: 102
                -- upvalues: Animator2 (copy), Action (copy), Animation2 (copy)
                local track = Animator2:LoadAnimation(Animation2)

                track.Priority = Action
                track.Looped = true

                return track
            end

            local ok

            ok, result3 = pcall(v52)

            if not ok or not result3 then
                result3 = nil
            end
        end

        if Animation2 then
            Animation2:Destroy()
        end

        if result3 then
            result3:Play(0.15)
            table.insert(t6.Tracks, result3)
        end
    end

    local traceback = debug.traceback
    local v53, v54 = xpcall(v29, traceback)

    if not v53 then
        if t6 then
            t3[p16] = t6
            cleanup(p16)
        elseif v28 then
            v28:Destroy()
        end

        error(v54)
    end

    return t6
end

local function distanceTo(_, p24) -- line: 308
    -- upvalues: Players (copy)
    local v55 = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Carrier = p24:FindFirstChild("Carrier")
    local v56, v57

    if v55 and Carrier then
        local Magnitude = (v55.Position - Carrier.Position).Magnitude

        if Magnitude then
            v56 = Magnitude
            v57 = true
        else
            v57 = false
        end
    else
        v57 = false
    end

    if not v57 then
        v56 = 1e999
    end

    return v56
end

local function maintain() -- line: 313
    -- upvalues: Players (copy), PetMountFlags (copy), Remotes (copy), v3 (ref), t2 (copy), t3 (copy), t5 (copy), Character (ref), playTransition (copy), cleanup (copy), suppressBase (copy), build (copy)
    local Character2 = Players.LocalPlayer.Character

    if Character2 and Character2 ~= Character and Character2:FindFirstChildOfClass("Humanoid") and Character2:FindFirstChild("HumanoidRootPart") then
        Character = Character2
        task.spawn(function() -- line: 317
            -- upvalues: Character2 (copy), Remotes (copy), Character (ref)
            local function v58() -- line: 318
                -- upvalues: Character2 (copy), Remotes (copy)
                return Remotes.PetMount.Request:InvokeServer("prepare", Character2)
            end

            local ok, result = pcall(v58)

            if (not ok or not result) and Character == Character2 then
                Character = nil
            end
        end)
    end

    local v59 = false

    for v60, v61 in t2 do
        local Model = v61.Model

        if v60.Parent and v60.Character and Model.Parent == v60.Character then
            suppressBase(v60, v61)

            local Token = Model:GetAttribute("Token")
            local v62 = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local Carrier = Model:FindFirstChild("Carrier")
            local v63 = v62 and Carrier and (v62.Position - Carrier.Position).Magnitude or 1e999

            if v60 == Players.LocalPlayer then
                if t3[v60] == nil and not v59 and Token and t5[v60] ~= Token then
                    local ok, result = pcall(build, v60, Model)

                    if ok then
                        if result then
                            t3[v60] = result

                            if v60 == Players.LocalPlayer then
                                local Token = Model:GetAttribute("Token")
                                local spawn = task.spawn
                                local v64 = true

                                spawn(function() -- line: 31
                                    -- upvalues: Token (copy), v64 (copy), Remotes (copy)
                                    local function v65() -- line: 32
                                        -- upvalues: Token (copy), v64 (copy), Remotes (copy)
                                        Remotes.PetMount.Request:InvokeServer("ready", {
                                            Token = Token,
                                            Success = v64
                                        })
                                    end

                                    local ok, result = pcall(v65)

                                    if not ok then
                                        warn("Pet mount acknowledgement failed: " .. tostring(result))
                                    end
                                end)
                            end

                            if not v61.PoofPlayed then
                                v61.PoofPlayed = true
                                playTransition(v60, result)
                            end

                            v59 = true
                        elseif os.clock() - v61.AddedAt > PetMountFlags.ClientBuildTimeout:Get() - 1 then
                            t5[v60] = Token

                            if v60 == Players.LocalPlayer then
                                local Token = Model:GetAttribute("Token")
                                local spawn = task.spawn
                                local v66 = false

                                spawn(function() -- line: 31
                                    -- upvalues: Token (copy), v66 (copy), Remotes (copy)
                                    local function v67() -- line: 32
                                        -- upvalues: Token (copy), v66 (copy), Remotes (copy)
                                        Remotes.PetMount.Request:InvokeServer("ready", {
                                            Token = Token,
                                            Success = v66
                                        })
                                    end

                                    local ok, result = pcall(v67)

                                    if not ok then
                                        warn("Pet mount acknowledgement failed: " .. tostring(result))
                                    end
                                end)
                            end
                        end
                    else
                        t5[v60] = Token

                        if v60 == Players.LocalPlayer then
                            local Token = Model:GetAttribute("Token")
                            local spawn = task.spawn
                            local v68 = false

                            spawn(function() -- line: 31
                                -- upvalues: Remotes (copy), Token (copy), v68 (copy)
                                local function v69() -- line: 32
                                    -- upvalues: Remotes (copy), Token (copy), v68 (copy)
                                    Remotes.PetMount.Request:InvokeServer("ready", {
                                        Token = Token,
                                        Success = v68
                                    })
                                end

                                local ok, result = pcall(v69)

                                if not ok then
                                    warn("Pet mount acknowledgement failed: " .. tostring(result))
                                end
                            end)
                        end

                        warn("Pet mount render failed: " .. tostring(result))
                    end
                end
            elseif PetMountFlags.RenderDistance:Get() < v63 then
                cleanup(v60)
            elseif t3[v60] == nil and not v59 and Token and t5[v60] ~= Token then
                local ok, result = pcall(build, v60, Model)

                if ok then
                    if result then
                        t3[v60] = result

                        if v60 == Players.LocalPlayer then
                            local Token = Model:GetAttribute("Token")
                            local spawn = task.spawn
                            local v70 = true

                            spawn(function() -- line: 31
                                -- upvalues: Remotes (copy), Token (copy), v70 (copy)
                                local function v71() -- line: 32
                                    -- upvalues: Remotes (copy), Token (copy), v70 (copy)
                                    Remotes.PetMount.Request:InvokeServer("ready", {
                                        Token = Token,
                                        Success = v70
                                    })
                                end

                                local ok, result = pcall(v71)

                                if not ok then
                                    warn("Pet mount acknowledgement failed: " .. tostring(result))
                                end
                            end)
                        end

                        if not v61.PoofPlayed then
                            v61.PoofPlayed = true
                            playTransition(v60, result)
                        end

                        v59 = true
                    elseif os.clock() - v61.AddedAt > PetMountFlags.ClientBuildTimeout:Get() - 1 then
                        t5[v60] = Token

                        if v60 == Players.LocalPlayer then
                            local Token = Model:GetAttribute("Token")
                            local spawn = task.spawn
                            local v72 = false

                            spawn(function() -- line: 31
                                -- upvalues: Remotes (copy), Token (copy), v72 (copy)
                                local function v73() -- line: 32
                                    -- upvalues: Remotes (copy), Token (copy), v72 (copy)
                                    Remotes.PetMount.Request:InvokeServer("ready", {
                                        Token = Token,
                                        Success = v72
                                    })
                                end

                                local ok, result = pcall(v73)

                                if not ok then
                                    warn("Pet mount acknowledgement failed: " .. tostring(result))
                                end
                            end)
                        end
                    end
                else
                    t5[v60] = Token

                    if v60 == Players.LocalPlayer then
                        local Token = Model:GetAttribute("Token")
                        local spawn = task.spawn
                        local v74 = false

                        spawn(function() -- line: 31
                            -- upvalues: Remotes (copy), Token (copy), v74 (copy)
                            local function v75() -- line: 32
                                -- upvalues: Remotes (copy), Token (copy), v74 (copy)
                                Remotes.PetMount.Request:InvokeServer("ready", {
                                    Token = Token,
                                    Success = v74
                                })
                            end

                            local ok, result = pcall(v75)

                            if not ok then
                                warn("Pet mount acknowledgement failed: " .. tostring(result))
                            end
                        end)
                    end

                    warn("Pet mount render failed: " .. tostring(result))
                end
            end
        else
            cleanup(v60, true)

            local v76 = t2[v60]

            if v76 and v76.UID then
                if v3 == nil then
                    v3 = require(script.Parent.Plots.ActiveAssetsController)
                end

                local v77 = v3

                v77.SetMountedPet(v60.UserId, v76.UID, false)
            end

            t2[v60] = nil
        end
    end
end

local function applySeatPose(p25) -- line: 351
    -- upvalues: PetMountFlags (copy), PetMountGeometry (copy)
    local v78 = p25.RootMotor or p25.RootAttachment

    if not (v78 and v78.Parent) then
        return
    end

    if PetMountFlags.StabilizeSeat:Get() then
        p25.SeatLocal = PetMountGeometry.ClampAnimatedSeat(p25.RestSeat, p25.SeatLocal, p25.SeatTravelLimit or PetMountFlags.MaximumAnimationSeatOffset:Get(), (math.min(PetMountFlags.MaximumSeatTiltDegrees:Get(), p25.SeatTiltLimit)))
    end

    local v81 = p25.Root.CFrame * p25.RiderToPet * p25.SeatLocal

    p25.LastC0 = p25.Root.CFrame:ToObjectSpace(v81 * CFrame.new(0, 1, 0)) * p25.OriginalC0

    if p25.RootMotor then
        p25.RootMotor.C0 = p25.LastC0
        p25.LastC0 = p25.RootMotor.C0
    else
        p25.RootAttachment.CFrame = p25.LastC0
        p25.LastC0 = p25.RootAttachment.CFrame
    end
end

local function stabilizeSeat(p26) -- line: 371
    -- upvalues: PetMountFlags (copy), PetMountGeometry (copy)
    local TransformedWorldCFrame = p26.Seat.Parent.TransformedWorldCFrame
    local CFrame = p26.Rig.PrimaryPart.CFrame
    local v82 = CFrame:ToObjectSpace(TransformedWorldCFrame * p26.AuthoredSeat)

    if PetMountFlags.StabilizeSeat:Get() then
        v82 = PetMountGeometry.ClampAnimatedSeat(p26.RestSeat, v82, p26.SeatTravelLimit or PetMountFlags.MaximumAnimationSeatOffset:Get(), (math.min(PetMountFlags.MaximumSeatTiltDegrees:Get(), p26.SeatTiltLimit)))
    end

    p26.Seat.CFrame = TransformedWorldCFrame:ToObjectSpace(CFrame * v82)

    for _, v85 in p26.Grips do
        v85.Attachment.CFrame = p26.Seat.CFrame * v85.SeatOffset
    end

    p26.SeatLocal = v82
end

local function stabilizeAnimatedSeats() -- line: 386
    -- upvalues: NightFangHeight (copy), t3 (copy), stabilizeSeat (copy)
    for v86, v87 in t3 do
        if v87.Model.Parent == v87.Character and v86.Character == v87.Character then
            NightFangHeight.Apply(v87.AnimationHeight)
            stabilizeSeat(v87)
        end
    end
end

local function followSeatBones() -- line: 394
    -- upvalues: t3 (copy), applySeatPose (copy)
    for v88, v89 in t3 do
        if v89.Model.Parent == v89.Character and v88.Character == v89.Character then
            v89.SeatLocal = v89.Rig.PrimaryPart.CFrame:ToObjectSpace(v89.SeatFollower.CFrame)
            applySeatPose(v89)
        end
    end
end

local function followRiders() -- line: 403
    -- upvalues: t3 (copy), applySeatPose (copy)
    for v90, v91 in t3 do
        if v91.Model.Parent == v91.Character and v90.Character == v91.Character then
            v91.Rig:PivotTo(v91.Root.CFrame * v91.RiderToPet * v91.RootToPivot)
            applySeatPose(v91)
        end
    end
end

local v92 = RaycastParams.new()

v92.FilterType = Enum.RaycastFilterType.Exclude

local function gateJump(p27) -- line: 415
    -- upvalues: Folder (ref), v92 (copy)
    local Humanoid = p27.Humanoid

    v92.FilterDescendantsInstances = {
        p27.Character,
        Folder
    }

    local v93 = Humanoid.HipHeight + p27.Root.Size.Y / 2 - 1 + 1

    if workspace:Spherecast(p27.Root.Position, 1, Vector3.new(0, -v93, 0), v92) ~= nil then
        if p27.JumpGated then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            p27.JumpGated = false
        end
    elseif not p27.JumpGated and Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        p27.JumpGated = true
    end
end

local function updatePose(p28) -- line: 428
    -- upvalues: Players (copy), PetMountFlags (copy), PetMountGeometry (copy), t3 (copy), cleanup (copy), applySeatPose (copy), stabilizeSeat (copy), gateJump (copy)
    for v95, v96 in t3 do
        if v96.Model.Parent == v96.Character and v95.Character == v96.Character then
            local v97 = v96.Root.CFrame * v96.RiderToPet

            v96.Rig:PivotTo(v97 * v96.RootToPivot)
            stabilizeSeat(v96)

            if v95 == Players.LocalPlayer then
                gateJump(v96)
            end

            local Model = v96.Model
            local v98 = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local Carrier = Model:FindFirstChild("Carrier")
            local v99 = v98 and Carrier and (v98.Position - Carrier.Position).Magnitude or 1e999
            local v100 = v95 == Players.LocalPlayer or v99 <= PetMountFlags.IKDistance:Get()
            local AssemblyLinearVelocity = v96.Root.AssemblyLinearVelocity
            local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude

            v96.AnimationSpeed = v96.AnimationSpeed + (Magnitude - v96.AnimationSpeed) * (1 - math.exp(-math.max(p28, 0) / 0.1))

            local v103 = Magnitude > 0.5

            if v96.Walk and v96.Moving ~= v103 then
                if v103 then
                    if v96.Idle then
                        v96.Idle:Stop(0.15)
                    end

                    v96.Walk:Play(0.15)
                else
                    v96.Walk:Stop(0.15)

                    if v96.Idle then
                        v96.Idle:Play(0.15)
                    end
                end
            end

            v96.Moving = v103

            if v96.Walk and v103 then
                local v104 = v96.WalkReferenceSpeed or PetMountFlags.WalkAnimationReferenceSpeed:Get()

                if not PetMountGeometry.IsFinite(v104) or v104 <= 0 then
                    v104 = PetMountFlags.WalkAnimationReferenceSpeed:Get()
                end

                v96.Walk:AdjustSpeed((math.clamp(v96.AnimationSpeed / v104, PetMountFlags.WalkAnimationMinRate:Get(), PetMountFlags.WalkAnimationMaxRate:Get())))
            end

            if v96.TorsoIK then
                v96.TorsoTarget.CFrame = (v96.RiderToPet * v96.SeatLocal).Rotation * CFrame.Angles(-math.rad((PetMountFlags.TorsoLeanDegrees:Get())), 0, 0)
                v96.TorsoIK.Enabled = v100
            end

            applySeatPose(v96)

            for _, v108 in v96.Grips do
                v108.IK.Enabled = v100

                if v100 then
                    local v109 = PetMountGeometry.AnimatedWorld(v108.Attachment)
                    local WorldPosition = v108.Origin and v108.Origin.WorldPosition or v108.Upper.Position
                    local v110 = v109.Position - WorldPosition
                    local Reach = v108.Reach

                    if Reach < v110.Magnitude then
                        v109 = v109.Rotation + WorldPosition + v110.Unit * Reach
                    end

                    v108.Target.WorldCFrame = v109
                end
            end

            continue
        end

        cleanup(v95, true)
    end
end

local function bindCharacter(p29, p30) -- line: 475
    -- upvalues: v3 (ref), t2 (copy), t4 (copy), cleanup (copy), newTarget (copy)
    local v111 = t4[p29]

    if v111 then
        if v111.Child then
            v111.Child:Disconnect()
        end

        if v111.Removing then
            v111.Removing:Disconnect()
        end
    end

    cleanup(p29, true)

    local v112 = t2[p29]

    if v112 and v112.UID then
        if v3 == nil then
            v3 = require(script.Parent.Plots.ActiveAssetsController)
        end

        v3.SetMountedPet(p29.UserId, v112.UID, false)
    end

    t2[p29] = nil

    if not p30 then
        return
    end

    local function added(p31) -- line: 481
        -- upvalues: p29 (copy), newTarget (copy)
        if p31.Name == "PetMountSession" and p31:IsA("Model") then
            newTarget(p29, p31)
        end
    end

    v111.Child = p30.ChildAdded:Connect(added)
    v111.Removing = p30.ChildRemoved:Connect(function(p32) -- line: 485
        -- upvalues: p29 (copy), v3 (ref), t2 (copy), cleanup (copy)
        if t2[p29] and t2[p29].Model == p32 then
            cleanup(p29, true)

            local v113 = t2[p29]

            if v113 and v113.UID then
                if v3 == nil then
                    v3 = require(script.Parent.Plots.ActiveAssetsController)
                end

                v3.SetMountedPet(p29.UserId, v113.UID, false)
            end

            t2[p29] = nil
        end
    end)

    for _, child in p30:GetChildren() do
        if child.Name == "PetMountSession" and child:IsA("Model") then
            newTarget(p29, child)
        end
    end
end

local function bindPlayer(p33) -- line: 490
    -- upvalues: t4 (copy), bindCharacter (copy)
    t4[p33] = {}
    t4[p33].Added = p33.CharacterAdded:Connect(function(p34) -- line: 492
        -- upvalues: p33 (copy), bindCharacter (copy)
        bindCharacter(p33, p34)
    end)
    bindCharacter(p33, p33.Character)
end

function t1.Start() -- line: 495
    -- upvalues: Players (copy), RunService (copy), NightFangHeight (copy), v3 (ref), v5 (ref), t2 (copy), t3 (copy), t4 (copy), t5 (copy), Folder (ref), n1 (ref), cleanup (copy), maintain (copy), stabilizeAnimatedSeats (copy), followSeatBones (copy), followRiders (copy), updatePose (copy), bindPlayer (copy)
    if v5 then
        return
    end

    v5 = true
    Folder = Instance.new("Folder")
    Folder.Name = "ClientMountedPets"
    Folder.Parent = workspace
    Players.PlayerAdded:Connect(bindPlayer)
    Players.PlayerRemoving:Connect(function(p35) -- line: 502
        -- upvalues: v3 (ref), t2 (copy), t4 (copy), t5 (copy), cleanup (copy)
        cleanup(p35, true)

        local v116 = t2[p35]

        if v116 and v116.UID then
            if v3 == nil then
                v3 = require(script.Parent.Plots.ActiveAssetsController)
            end

            v3.SetMountedPet(p35.UserId, v116.UID, false)
        end

        t2[p35] = nil

        for _, v117 in t4[p35] or {} do
            v117:Disconnect()
        end

        t4[p35] = nil
        t5[p35] = nil
    end)

    for _, player in Players:GetPlayers() do
        bindPlayer(player)
    end

    RunService.Heartbeat:Connect(function(p36) -- line: 509
        -- upvalues: n1 (ref), maintain (copy)
        n1 += p36

        if n1 >= 0.1 then
            n1 = 0
            maintain()
        end
    end)
    RunService.PreAnimation:Connect(function(p37) -- line: 513
        -- upvalues: NightFangHeight (copy), t3 (copy), updatePose (copy)
        updatePose(p37)

        for _, v118 in t3 do
            NightFangHeight.Reset(v118.AnimationHeight)
        end
    end)
    RunService.PreSimulation:Connect(stabilizeAnimatedSeats)
    RunService.PostSimulation:Connect(followSeatBones)
    RunService:BindToRenderStep("PetMountFollow", Enum.RenderPriority.Character.Value + 1, followRiders)
end

return t1
