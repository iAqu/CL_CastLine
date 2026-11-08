-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Artifacts = require(script.Artifacts)
local Cast = require(script.Cast)
local Catch = require(script.Catch)
local Chase = require(script.Chase)
local Cine = require(script.Cine)
local Finale = require(script.Finale)
local GhostDogQuestFlags = require(ReplicatedStorage.Shared.Flags.GhostDogQuestFlags)
local Fx = require(script.Fx)
local Handoff = require(script.Handoff)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local GhostDogQuest2 = require(ReplicatedStorage.Shared.Types.GhostDogQuest)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Hud = require(script.Hud)
local Memories = require(script.Memories)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Npcs = require(script.Npcs)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Speech = require(script.Speech)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local LocalPlayer = Players.LocalPlayer
local Stage = GhostDogQuest.Stage
local PlayerAttributes = HalloweenDimension.PlayerAttributes
local v1 = Color3.fromRGB(255, 85, 85)
local v2 = Color3.fromRGB(120, 255, 175)
local v3 = nil
local v4
local v5 = false
local v6 = false
local v7, v8
local v9 = false
local n1 = -1
local v10 = false
local syncWorld
local n2 = 0
local t1 = {}

local function stateOf() -- line: 68
    -- upvalues: GhostDogQuest2 (copy), Save (copy)
    local v11 = Save.Peek()

    return if v11 ~= nil then v11.GhostDogQuest or GhostDogQuest2.Blank() else nil
end

local function markersOf() -- line: 76
    -- upvalues: Workspace (copy), GhostDogQuest (copy), HalloweenDimension (copy)
    local v12 = Workspace:FindFirstChild(HalloweenDimension.MapName)
    local v13 = v12 and v12:FindFirstChild(GhostDogQuest.FolderName)
    local v14 = v13 and v13:FindFirstChild(GhostDogQuest.MarkersName)

    return if v14 ~= nil and v14:IsA("Folder") then v14 else nil
end

local function marker(p1) -- line: 83
    -- upvalues: v4 (ref)
    local v15 = v4
    local v16 = v15 and v15:FindFirstChild(p1)

    return if v16 and v16:IsA("BasePart") then v16 else nil
end

local function rootOf() -- line: 89
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function setGuide(p2) -- line: 95
    -- upvalues: TutorialBeam (copy), v7 (ref), v8 (ref)
    if p2 == v8 then
        return
    end

    v8 = p2

    if v7 then
        TutorialBeam.Destroy(v7)
        v7 = nil
    end

    if p2 then
        v7 = TutorialBeam.Attach(p2, {
            BeamName = "GhostDogGuide"
        })
    end
end

local function isActive() -- line: 109
    -- upvalues: Workspace (copy), GhostDogQuestFlags (copy), GhostDogQuest (copy), HalloweenDimension (copy), Save (copy), LocalPlayer (copy), PlayerAttributes (copy)
    local v17 = GhostDogQuestFlags.Enabled:Get()
    local v18

    if not v17 then
        v18 = v17

        return v18
    end

    if LocalPlayer:GetAttribute(PlayerAttributes.Inside) ~= true then
        v18 = false

        return v18
    end

    local v19 = Workspace:FindFirstChild(HalloweenDimension.MapName)
    local v20 = v19 and v19:FindFirstChild(GhostDogQuest.FolderName)
    local v21 = v20 and v20:FindFirstChild(GhostDogQuest.MarkersName)

    if v21 == nil or not v21:IsA("Folder") then
        v21 = nil
    end

    return v21 ~= nil and Save.IsLoaded()
end

local function allFound(p3) -- line: 116
    -- upvalues: GhostDogQuest (copy), GhostDogQuest2 (copy)
    return GhostDogQuest2.CountFound(p3) >= #GhostDogQuest.Artifacts
end

local function objectiveFor(p4) -- line: 120
    -- upvalues: GhostDogQuest (copy), GhostDogQuest2 (copy), Stage (copy), v6 (ref), n2 (ref)
    if v6 then
        return GhostDogQuest.Objectives.Follow
    end

    if p4.Stage == Stage.Collecting then
        if GhostDogQuest2.CountFound(p4) >= #GhostDogQuest.Artifacts then
            return GhostDogQuest.Objectives.Return
        end

        return (("%* (%*/%*)"):format(GhostDogQuest.Objectives.Collecting, GhostDogQuest2.CountFound(p4), #GhostDogQuest.Artifacts))
    end

    if p4.Stage == Stage.Reunion then
        return GhostDogQuest.Objectives.Reunion
    end

    if p4.Stage == Stage.HasRod then
        return GhostDogQuest.Objectives.Cast
    end

    return if p4.Stage == Stage.Done and os.clock() < n2 then GhostDogQuest.Captions.AfterQuest else nil
end

local function toggleMemories() -- line: 142
    -- upvalues: Memories (copy)
    if Memories.IsOpen() then
        Memories.Close()
    else
        Memories.Open()
    end
end

local function dogMood(p5) -- line: 150
    -- upvalues: GhostDogQuest (copy), GhostDogQuest2 (copy), Stage (copy)
    if p5.Stage == Stage.NotMet then
        return "Sad"
    end

    if p5.Stage ~= Stage.Collecting or GhostDogQuest2.CountFound(p5) >= #GhostDogQuest.Artifacts then
        return "Happy"
    end

    return "Idle"
end

local function castLive() -- line: 160
    -- upvalues: GhostDogQuest2 (copy), Save (copy), Stage (copy), v5 (ref), v9 (ref)
    local v22 = Save.Peek()
    local v23 = if v22 == nil then nil else v22.GhostDogQuest or GhostDogQuest2.Blank()

    if v23 ~= nil and v23.Stage == Stage.HasRod then
        return not v5 and v9
    end

    return false
end

local function buildCastRing(p6) -- line: 165
    -- upvalues: RunService (copy), Workspace (copy), Fx (copy), GhostDogQuest2 (copy), Save (copy), Stage (copy), v2 (copy), v4 (ref), v5 (ref), v9 (ref)
    local v24 = v4
    local CastTarget = v24 and v24:FindFirstChild("CastTarget")

    if not (CastTarget and CastTarget:IsA("BasePart")) then
        CastTarget = nil
    end

    if CastTarget == nil then
        return
    end

    local v25 = p6:Add(Instance.new("Part"))

    v25.Name = "GhostDogCastRipples"
    v25.Anchored = true
    v25.CanCollide = false
    v25.CanQuery = false
    v25.CanTouch = false
    v25.CastShadow = false
    v25.Transparency = 1
    v25.Size = Vector3.new(1, 1, 1)
    v25.CFrame = CFrame.new(CastTarget.Position + Vector3.new(0, 0.25, 0))

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v25

    local v26 = Fx.RippleEmitter(Attachment, 0, 0.8)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = Fx.Sparkle
    ParticleEmitter.Color = ColorSequence.new(v2)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rate = 0
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.4)
    ParticleEmitter.Speed = NumberRange.new(1, 3)
    ParticleEmitter.SpreadAngle = Vector2.new(30, 30)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Size = NumberSequence.new(0.5, 0)
    ParticleEmitter.Parent = Attachment

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v2
    PointLight.Range = 14
    PointLight.Brightness = 0
    PointLight.Parent = v25
    v25.Parent = Workspace
    p6:Connect(RunService.Heartbeat, function() -- line: 200
        -- upvalues: v26 (copy), ParticleEmitter (copy), PointLight (copy), GhostDogQuest2 (copy), Save (copy), Stage (copy), v5 (ref), v9 (ref)
        local v27 = Save.Peek()
        local v28 = if v27 == nil then nil else v27.GhostDogQuest or GhostDogQuest2.Blank()
        local v29 = v28 ~= nil and v28.Stage == Stage.HasRod and not v5 and v9

        v26.Rate = v29 and 1.6 or 0
        ParticleEmitter.Rate = v29 and 8 or 0
        PointLight.Brightness = if v29 then math.sin(os.clock() * 4) * 0.5 + 1 else 0
    end)
end

local function buildCastSpot(p7) -- line: 208
    -- upvalues: RunService (copy), Workspace (copy), GhostDogQuest2 (copy), Save (copy), LocalPlayer (copy), Stage (copy), v2 (copy), v4 (ref), v5 (ref), v9 (ref)
    local v32 = v4
    local CastSpot = v32 and v32:FindFirstChild("CastSpot")

    if not (CastSpot and CastSpot:IsA("BasePart")) then
        CastSpot = nil
    end

    if CastSpot == nil then
        return
    end

    local v33 = RaycastParams.new()

    v33.FilterType = Enum.RaycastFilterType.Exclude
    v33.FilterDescendantsInstances = {
        CastSpot,
        LocalPlayer.Character
    }

    local v34 = Workspace:Raycast(CastSpot.Position + Vector3.new(0, 4, 0), Vector3.new(0, -12, 0), v33)
    local Position = if v34 then v34.Position else CastSpot.Position
    local v35 = p7:Add(Instance.new("Model"))

    v35.Name = "GhostDogCastSpot"

    local function disc(p8, p9, p10) -- line: 221
        -- upvalues: v35 (copy), Position (copy), v2 (copy)
        local Part = Instance.new("Part")

        Part.Name = p8
        Part.Shape = Enum.PartType.Cylinder
        Part.Material = Enum.Material.Neon
        Part.Color = v2
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Transparency = p10
        Part.Size = Vector3.new(0.08, p9, p9)
        Part.CFrame = CFrame.new(Position + Vector3.new(0, 0.06, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        Part.Parent = v35

        return Part
    end

    local v36 = disc("Pad", 6, 0.55)
    local v37 = disc("Pulse", 6, 0.3)
    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v36

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(26, 0, 0)
    Attachment2.Parent = v36

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.Width0 = 5
    Beam.Width1 = 5
    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.Color = ColorSequence.new(v2)
    Beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.45),
        NumberSequenceKeypoint.new(1, 1)
    })
    Beam.Parent = v36

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v2
    PointLight.Range = 16
    PointLight.Brightness = 2
    PointLight.Parent = v36

    local Attachment3 = Instance.new("Attachment")

    Attachment3.Name = "FishHerePoint"
    Attachment3.WorldPosition = Position + Vector3.new(0, 7.5, 0)
    Attachment3.Parent = v36

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "FishHere"
    BillboardGui.Adornee = Attachment3
    BillboardGui.Size = UDim2.fromScale(10, 3.4)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 900

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 0.62)
    TextLabel.TextScaled = true
    TextLabel.Text = "FISH HERE"
    TextLabel.TextColor3 = v2
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 3
    UIStroke.Color = Color3.fromRGB(10, 40, 30)
    UIStroke.Parent = TextLabel
    TextLabel.Parent = BillboardGui

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Arrow"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0)
    TextLabel2.Position = UDim2.fromScale(0.5, 0.6)
    TextLabel2.Size = UDim2.fromScale(0.3, 0.4)
    TextLabel2.TextScaled = true
    TextLabel2.Text = "▼"
    TextLabel2.TextColor3 = v2
    TextLabel2.FontFace = TextLabel.FontFace
    UIStroke:Clone().Parent = TextLabel2
    TextLabel2.Parent = BillboardGui
    BillboardGui.Parent = v35
    v35.Parent = Workspace
    p7:Connect(RunService.Heartbeat, function() -- line: 302
        -- upvalues: Position (copy), v36 (copy), v37 (copy), Beam (copy), PointLight (copy), BillboardGui (copy), TextLabel2 (copy), GhostDogQuest2 (copy), Save (copy), LocalPlayer (copy), Stage (copy), v5 (ref), v9 (ref)
        local v38 = Save.Peek()
        local v39 = if v38 == nil then nil else v38.GhostDogQuest or GhostDogQuest2.Blank()
        local v40 = v39 ~= nil and v39.Stage == Stage.HasRod and not v5 and v9
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            HumanoidRootPart = nil
        end

        local v41 = HumanoidRootPart ~= nil and (HumanoidRootPart.Position - Position).Magnitude <= 36
        local elapsed = os.clock()
        local v42 = elapsed * 0.8 % 1

        v36.Transparency = v40 and 0.55 or 1
        v37.Transparency = if v40 then 0.3 + v42 * 0.7 else 1
        v37.Size = Vector3.new(0.08, 6 + v42 * 7, 6 + v42 * 7)
        Beam.Enabled = v40
        PointLight.Enabled = v40
        BillboardGui.Enabled = v40 and v41
        TextLabel2.Position = UDim2.fromScale(0.5, math.abs((math.sin(elapsed * 4))) * 0.1 + 0.6)
    end)
end

local function abortSession() -- line: 318
    -- upvalues: Remotes (copy)
    local function v48() -- line: 319
        -- upvalues: Remotes (copy)
        Remotes.GhostDogQuest.Abort:InvokeServer()
    end

    pcall(v48)
end

local function runCast(p11) -- line: 324
    -- upvalues: Cast (copy), Chase (copy), Cine (copy), Finale (copy), Handoff (copy), GhostDogQuest (copy), Hud (copy), Memories (copy), MusicDirector (copy), Npcs (copy), Remotes (copy), Speech (copy), Toast (copy), TutorialBeam (copy), LocalPlayer (copy), PlayerAttributes (copy), v1 (copy), v3 (ref), v4 (ref), v5 (ref), v7 (ref), v8 (ref), abortSession (copy)
    if v5 then
        return false
    end

    local v49 = v4
    local v50 = v3

    if v49 ~= nil and v50 ~= nil then
        v5 = true
        Speech.Stop()
        Memories.Close()

        while Handoff.IsRunning() do
            task.wait()
        end

        if v3 == v50 then
            Npcs.SetQuiet(true)

            if v8 ~= nil then
                v8 = nil

                if v7 then
                    TutorialBeam.Destroy(v7)
                    v7 = nil
                end
            end

            Hud.SetObjective(nil)
            Hud.Cinematic(true)

            local function v51() -- line: 347
                -- upvalues: Remotes (copy)
                return Remotes.GhostDogQuest.Cast:InvokeServer()
            end

            local v52, v53, v54 = pcall(v51)

            if v52 and typeof(v53) == "number" then
                Cine.Hold()

                local v55 = v50:Extend()
                local Play = Cast.Play
                local ok, result = pcall(Play, v55, v49, p11)
                local v56

                if ok then
                    if result then
                        local function v57() -- line: 362
                            -- upvalues: Remotes (copy)
                            return Remotes.GhostDogQuest.Dive:InvokeServer()
                        end

                        local ok, result = pcall(v57)

                        v56 = ok and result == true
                    else
                        v56 = false
                    end
                else
                    v56 = false
                    warn((("[GhostDogQuest] cast failed: %*"):format(result)))
                end

                if not v56 then
                    local function v58() -- line: 319
                        -- upvalues: Remotes (copy)
                        Remotes.GhostDogQuest.Abort:InvokeServer()
                    end

                    pcall(v58)
                    v55:Clean()
                    Cine.Settle(0.4)
                    Hud.Fade(0, 0.4)
                    v5 = false

                    return false
                end

                local v59 = v50:Extend()

                v59:Add(MusicDirector.Suppress())

                local v60 = v50:Extend()
                local v61 = false
                local Character = LocalPlayer.Character

                local function stillHere() -- line: 383
                    -- upvalues: Character (copy), LocalPlayer (copy), PlayerAttributes (copy)
                    if LocalPlayer.Character ~= Character or Character == nil or Character.Parent == nil then
                        return false
                    end

                    return LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true
                end

                local function v62() -- line: 389
                    -- upvalues: v49 (copy), v53 (copy), v55 (copy), v60 (copy), v61 (ref), Character (copy), stillHere (copy), Chase (copy), Finale (copy), GhostDogQuest (copy), LocalPlayer (copy), PlayerAttributes (copy)
                    local v63, v64, _, v65 = Chase.Run(v60, v53, function() -- line: 390
                        -- upvalues: Character (copy), GhostDogQuest (copy), LocalPlayer (copy), PlayerAttributes (copy)
                        return LocalPlayer.Character == Character and Character ~= nil and Character.Parent ~= nil and LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true and LocalPlayer:GetAttribute(GhostDogQuest.ChaseAttribute) ~= nil
                    end, v55)

                    if v63 == "Won" and v64 then
                        v61 = Finale.Play(v60, v53, v64, v49, stillHere, v65)
                    end
                end

                local ok2, result2 = pcall(v62)

                if not ok2 then
                    warn((("[GhostDogQuest] chase failed: %*"):format(result2)))
                end

                v55:Clean()

                if not v61 and LocalPlayer.Character == Character and Character ~= nil and Character.Parent ~= nil and LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true then
                    local function v66() -- line: 319
                        -- upvalues: Remotes (copy)
                        Remotes.GhostDogQuest.Abort:InvokeServer()
                    end

                    pcall(v66)
                end

                v60:Clean()

                if v61 and v3 == v50 then
                    local v67 = v50:Extend()
                    local Rescue = Finale.Rescue
                    local ok, result = pcall(Rescue, v67, v49, stillHere)

                    if not ok then
                        warn((("[GhostDogQuest] rescue failed: %*"):format(result)))
                    end

                    v67:Clean()
                    task.spawn(abortSession)
                end

                v59:Clean()
                Cine.Settle(0.4)
                Hud.Fade(0, 0.4)
                v5 = false

                return v61
            end

            v5 = false

            if v52 and typeof(v54) == "string" then
                Toast.Show({
                    Seconds = 2.5,
                    Text = v54,
                    Color = v1
                })
            end
        else
            v5 = false
        end
    end

    return false
end

local function runGhostFish(p12) -- line: 421
    -- upvalues: Cast (copy), Catch (copy), Chase (copy), Cine (copy), Handoff (copy), GhostDogQuest (copy), Hud (copy), Memories (copy), MusicDirector (copy), Npcs (copy), Remotes (copy), Speech (copy), Toast (copy), Trove (copy), TutorialBeam (copy), LocalPlayer (copy), v1 (copy), v3 (ref), v4 (ref), v5 (ref), v7 (ref), v8 (ref), abortSession (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if v5 or Character == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
        return nil
    end

    v5 = true
    Speech.Stop()
    Memories.Close()

    while Handoff.IsRunning() do
        task.wait()
    end

    local v68 = Hud.Get() == nil

    if v68 then
        Hud.Mount()
    end

    if v3 ~= nil then
        Npcs.SetQuiet(true)

        if v8 ~= nil then
            v8 = nil

            if v7 then
                TutorialBeam.Destroy(v7)
                v7 = nil
            end
        end
    end

    Hud.SetObjective(nil)
    Hud.Cinematic(true)

    local function v69() -- line: 449
        -- upvalues: p12 (copy), Remotes (copy)
        return Remotes.GhostDogQuest.Cast:InvokeServer(p12.Id)
    end

    local v70, v71, v72, v73 = pcall(v69)

    if v70 and typeof(v71) == "number" and type(v73) == "table" then
        local Target = p12.Target
        local v74 = CFrame.lookAt(HumanoidRootPart.Position, (Vector3.new(Target.X, HumanoidRootPart.Position.Y, Target.Z)))

        local function stillHere() -- line: 461
            -- upvalues: Character (copy), LocalPlayer (copy)
            if LocalPlayer.Character == Character then
                return Character.Parent ~= nil
            end

            return false
        end

        local v75 = Trove.new()

        Cine.Hold()

        local v76 = v75:Extend()
        local Play = Cast.Play
        local v77 = v4
        local ok, result = pcall(Play, v76, v77, p12)

        if not ok then
            warn((("[GhostDogQuest] ghost fish cast failed: %*"):format(result)))
        end

        local v78 = false

        if ok and result then
            local function v79() -- line: 473
                -- upvalues: Remotes (copy)
                return Remotes.GhostDogQuest.Dive:InvokeServer()
            end

            local ok, result = pcall(v79)

            v78 = ok and result == true
        end

        local v80 = false

        if v78 then
            v75:Add(MusicDirector.Suppress())

            local v81 = v75:Extend()

            local function v82() -- line: 482
                -- upvalues: Character (copy), v71 (copy), stillHere (copy), v76 (copy), v80 (ref), v81 (copy), Catch (copy), Chase (copy), GhostDogQuest (copy), LocalPlayer (copy)
                local v83, _, _, v84, v85 = Chase.Run(v81, v71, function() -- line: 483
                    -- upvalues: Character (copy), GhostDogQuest (copy), LocalPlayer (copy)
                    return LocalPlayer.Character == Character and Character.Parent ~= nil and LocalPlayer:GetAttribute(GhostDogQuest.ChaseAttribute) ~= nil
                end, v76, {
                    Ending = "Catch"
                })

                if v83 == "Won" and v84 then
                    v80 = Catch.Play(v81, v71, v84, v85, stillHere)
                end
            end

            local ok, result = pcall(v82)

            if not ok then
                warn((("[GhostDogQuest] ghost fish chase failed: %*"):format(result)))
            end

            v76:Clean()

            if not v80 and LocalPlayer.Character == Character and Character.Parent ~= nil then
                local function v86() -- line: 319
                    -- upvalues: Remotes (copy)
                    Remotes.GhostDogQuest.Abort:InvokeServer()
                end

                pcall(v86)
            end

            v81:Clean()

            if LocalPlayer.Character == Character and Character.Parent ~= nil then
                local v87 = v75:Extend()
                local Breach = Catch.Breach
                local ok, result = pcall(Breach, v87, Target, v74, stillHere)

                if not ok then
                    warn((("[GhostDogQuest] ghost fish breach failed: %*"):format(result)))
                end

                v87:Clean()
            end
        else
            local function v88() -- line: 319
                -- upvalues: Remotes (copy)
                Remotes.GhostDogQuest.Abort:InvokeServer()
            end

            pcall(v88)
            v76:Clean()
        end

        v75:Destroy()
        task.spawn(abortSession)
        Cine.Settle(0.4)
        Hud.Fade(0, 0.4)

        if v68 and v3 == nil then
            Hud.Unmount()
        end

        v5 = false

        return v73
    end

    if v70 and typeof(v72) == "string" then
        Toast.Show({
            Seconds = 2.5,
            Text = v72,
            Color = v1
        })
    end

    if v68 and v3 == nil then
        Hud.Unmount()
    end

    v5 = false

    return nil
end

local function openCast() -- line: 519
    -- upvalues: GhostDogQuest2 (copy), Hud (copy), Save (copy), TutorialBeam (copy), LocalPlayer (copy), Stage (copy), v3 (ref), v4 (ref), v5 (ref), v7 (ref), v8 (ref), v9 (ref), objectiveFor (copy)
    local v89 = Save.Peek()
    local v90 = if v89 == nil then nil else v89.GhostDogQuest or GhostDogQuest2.Blank()
    local CastSpot, v91

    if v5 or v90 == nil or v3 == nil then
        v91 = true
    elseif v90.Stage == Stage.HasRod then
        v9 = true
        Hud.SetObjective((objectiveFor(v90)))

        local v92 = v4

        CastSpot = v92 and v92:FindFirstChild("CastSpot")
        v91 = false
    else
        v91 = true
    end

    if v91 then
        return
    end

    if not (CastSpot and CastSpot:IsA("BasePart")) then
        CastSpot = nil
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        HumanoidRootPart = nil
    end

    if not (CastSpot and HumanoidRootPart and (HumanoidRootPart.Position - CastSpot.Position).Magnitude >= 18) or CastSpot == v8 then
        return
    end

    v8 = CastSpot

    if v7 then
        TutorialBeam.Destroy(v7)
        v7 = nil
    end

    v7 = TutorialBeam.Attach(CastSpot, {
        BeamName = "GhostDogGuide"
    })
end

local function linesFor(p13, p14) -- line: 533
    -- upvalues: GhostDogQuest (copy), GhostDogQuest2 (copy)
    local v93 = GhostDogQuest.Lines[p13]

    if v93 == nil then
        return nil
    end

    if p13 ~= "DogWaiting" or p14 == nil then
        return v93
    end

    local v94 = GhostDogQuest2.CountFound(p14)
    local v95 = #GhostDogQuest.Artifacts - v94
    local t2 = {}

    for _, v96 in v93 do
        local v97 = string.gsub(v96, "{found}", (tostring(v94)))

        table.insert(t2, (string.gsub(v97, "{left}", (tostring(v95)))))
    end

    return t2
end

local talkBody

local function talkTo(p15) -- line: 554
    -- upvalues: Workspace (copy), LocalPlayer (copy), v5 (ref), v6 (ref), v10 (ref), talkBody (ref)
    if v5 or v10 then
        return
    end

    local talkBody2 = talkBody
    local ok, result = pcall(talkBody2, p15)

    if ok then
        return
    end

    warn((("[GhostDogQuest] talk failed: %*"):format(result)))
    v10 = false
    v6 = false

    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid")

        if Character then
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.CameraSubject = Character
        end
    end
end

function talkBody(p16) -- line: 573
    -- upvalues: Handoff (copy), GhostDogQuest (copy), GhostDogQuest2 (copy), Hud (copy), Memories (copy), Npcs (copy), Remotes (copy), Save (copy), Speech (copy), Toast (copy), TutorialBeam (copy), LocalPlayer (copy), Stage (copy), v1 (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v10 (ref), syncWorld (ref), openCast (copy), linesFor (copy), talkTo (copy)
    if v5 or v10 then
        return
    end

    local v99 = if p16 == "Dog" then Npcs.Dog() else Npcs.Fisherman()
    local v100 = v3

    if v99 == nil or v100 == nil then
        return
    end

    v10 = true

    if v8 ~= nil then
        v8 = nil

        if v7 then
            TutorialBeam.Destroy(v7)
            v7 = nil
        end
    end

    Memories.Close()

    local function v101() -- line: 585
        -- upvalues: p16 (copy), Remotes (copy)
        return Remotes.GhostDogQuest.Talk:InvokeServer(p16)
    end

    local v102, v103, v104 = pcall(v101)

    if v102 and typeof(v103) == "string" then
        local v105 = Save.Peek()
        local v107 = linesFor(v103, if v105 == nil then nil else v105.GhostDogQuest or GhostDogQuest2.Blank())

        if v107 ~= nil then
            Npcs.FacePlayer(v99)
            Npcs.SetMarker(p16, nil)
            v99.Prompt.Enabled = false
            v99.Rig:SetMood("Talk")

            if v103 == "FisherReunion" then
                v99.Rig:SetMood("Pet")
                Npcs.SetDogMood("Happy")
            end

            local v108

            if v103 == "FisherReunion" then
                v108 = 3
            elseif v103 == "FisherHint" and not Handoff.HasRod() then
                v108 = 1
            end

            local v109

            if v103 == "FisherReunion" then
                v109 = 4
            elseif v103 == "FisherHint" then
                v109 = 1
            end

            Speech.Say(v99.Model, v99.Head, v107, {
                WalkAway = 40,
                Voice = v99.Voice,
                Clicks = p16 ~= "Dog",
                OnLine = function(p17) -- OnLine | line: 620
                    -- upvalues: p16 (copy), v99 (copy), v103 (copy), v108 (ref), v109 (ref), Handoff (copy), openCast (copy)
                    if p17 == v109 then
                        openCast()
                    end

                    if p17 == v108 then
                        Handoff.Play(v99)
                    elseif p16 == "Fisherman" and (v103 ~= "FisherReunion" or p17 ~= 1) then
                        v99.Rig:SetMood("Talk")
                    end
                end
            })
            v99.Prompt.Enabled = true

            if v103 == "DogRemembers" then
                v6 = true
            end

            v10 = false

            local v110 = Save.Peek()
            local v111 = if v110 == nil then nil else v110.GhostDogQuest or GhostDogQuest2.Blank()

            if p16 == "Dog" then
                v99.Rig:SetMood(if not v111 then "Idle"
                    elseif v111.Stage == Stage.NotMet then "Sad"
                    elseif v111.Stage ~= Stage.Collecting then "Happy"
                    elseif GhostDogQuest2.CountFound(v111) >= #GhostDogQuest.Artifacts then "Happy"
                    else "Idle")
            else
                v99.Rig:SetMood("Idle")
            end

            if v103 == "DogFirst" or v103 == "DogWaiting" then
                Memories.Open(v99.Model.PrimaryPart)
            end

            task.delay(v103 == "DogFirst" and 0.9 or 0.4, function() -- line: 645
                -- upvalues: v100 (copy), v3 (ref), syncWorld (ref)
                if v3 == v100 then
                    syncWorld()
                end
            end)

            if v103 == "DogRemembers" then
                local v112 = v4
                local DogHome = v112 and v112:FindFirstChild("DogHome")

                if not (DogHome and DogHome:IsA("BasePart")) then
                    DogHome = nil
                end

                local v113 = v4
                local DockEntrance = v113 and v113:FindFirstChild("DockEntrance")

                if not (DockEntrance and DockEntrance:IsA("BasePart")) then
                    DockEntrance = nil
                end

                if DogHome == nil or DockEntrance == nil then
                    v6 = false
                else
                    v99.Prompt.Enabled = false

                    local v114 = Npcs.Dog()

                    if v114 then
                        local PrimaryPart = v114.Model.PrimaryPart

                        if PrimaryPart ~= v8 then
                            v8 = PrimaryPart

                            if v7 then
                                TutorialBeam.Destroy(v7)
                                v7 = nil
                            end

                            if PrimaryPart then
                                v7 = TutorialBeam.Attach(PrimaryPart, {
                                    BeamName = "GhostDogGuide"
                                })
                            end
                        end
                    end

                    Hud.SetObjective(GhostDogQuest.Objectives.Follow)

                    local v115 = Npcs.Lead({
                        DockEntrance.Position,
                        DogHome.Position
                    }, DogHome.CFrame, function() -- line: 666
                        -- upvalues: v100 (copy), v3 (ref)
                        return v3 ~= v100
                    end)

                    v6 = false

                    if v114 then
                        v114.Prompt.Enabled = true
                    end

                    if v8 ~= nil then
                        v8 = nil

                        if v7 then
                            TutorialBeam.Destroy(v7)
                            v7 = nil
                        end
                    end

                    if v115 then
                        local v116 = Npcs.Fisherman()

                        if v116 then
                            v116.Prompt.Enabled = true

                            local PrimaryPart = v116.Model.PrimaryPart

                            if PrimaryPart ~= v8 then
                                v8 = PrimaryPart

                                if v7 then
                                    TutorialBeam.Destroy(v7)
                                    v7 = nil
                                end

                                if PrimaryPart then
                                    v7 = TutorialBeam.Attach(PrimaryPart, {
                                        BeamName = "GhostDogGuide"
                                    })
                                end
                            end

                            local elapsed = os.clock()

                            while v3 == v100 and os.clock() - elapsed < 90 do
                                local Character = LocalPlayer.Character
                                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                local HumanoidRootPart2 = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart

                                if HumanoidRootPart2 and (HumanoidRootPart2.Position - v116.Rig.Root.Position).Magnitude <= 16 then
                                    if v8 ~= nil then
                                        v8 = nil

                                        if v7 then
                                            TutorialBeam.Destroy(v7)
                                            v7 = nil
                                        end
                                    end

                                    task.spawn(talkTo, "Fisherman")

                                    return
                                end

                                task.wait(0.2)
                            end
                        end
                    end
                end
            end
        else
            v10 = false
        end
    else
        v10 = false

        if v102 and typeof(v104) == "string" then
            Toast.Show({
                Seconds = 2.5,
                Text = v104,
                Color = v1
            })
        end
    end
end

function syncWorld() -- line: 699
    -- upvalues: Artifacts (copy), GhostDogQuest (copy), GhostDogQuest2 (copy), Hud (copy), Memories (copy), Npcs (copy), Save (copy), TutorialBeam (copy), LocalPlayer (copy), Stage (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), n1 (ref), v10 (ref), n2 (ref), objectiveFor (copy), toggleMemories (copy)
    local v117 = Save.Peek()
    local v118 = if v117 == nil then nil else v117.GhostDogQuest or GhostDogQuest2.Blank()
    local v119 = v3

    if v118 == nil or v119 == nil or v10 then
        return
    end

    local v120 = v118.Stage == Stage.Collecting

    Memories.Sync(v118.Artifacts, v118.Stage <= Stage.Collecting)
    Artifacts.Sync(v4, v118.Artifacts, v120 and not v5)

    if not v5 then
        Hud.SetObjective(objectiveFor(v118), if v120 then toggleMemories else nil)
    end

    local v122 = if v118.Stage == Stage.NotMet then "!" elseif v118.Stage == Stage.Collecting and GhostDogQuest2.CountFound(v118) >= #GhostDogQuest.Artifacts then "?" else nil

    if not v6 then
        Npcs.SetMarker("Dog", v122)
    end

    Npcs.SetMarker("Fisherman", if v118.Stage ~= Stage.Reunion or v6 then nil else "!")
    Npcs.SetQuiet(v5 or v6)

    if not v5 then
        Npcs.SetRodVisible(true)
    end

    local v123 = Npcs.Dog()
    local Rig, v124

    if v123 and not v6 and not v10 and not v5 then
        Rig = v123.Rig
        v124 = if v118.Stage == Stage.NotMet then "Sad" elseif v118.Stage ~= Stage.Collecting or GhostDogQuest2.CountFound(v118) >= #GhostDogQuest.Artifacts then "Happy" else "Idle"
        Rig:SetMood(v124)
        v123.Prompt.ObjectText = GhostDogQuest.DogName
    end

    v9 = v118.Stage == Stage.HasRod and not v5

    if not (v5 or v6 or v10) then
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            HumanoidRootPart = nil
        end

        local v125

        if v118.Stage == Stage.Collecting and GhostDogQuest2.CountFound(v118) >= #GhostDogQuest.Artifacts and v123 then
            v125 = v123.Model.PrimaryPart
        elseif v118.Stage == Stage.Reunion then
            local v126 = Npcs.Fisherman()

            v125 = v126 and v126.Model.PrimaryPart
        elseif v118.Stage == Stage.HasRod then
            local v127 = v4
            local CastSpot = v127 and v127:FindFirstChild("CastSpot")

            if CastSpot and CastSpot:IsA("BasePart") then
                v125 = CastSpot
            end
        end

        if v125 and HumanoidRootPart and (HumanoidRootPart.Position - v125.Position).Magnitude < 18 then
            v125 = nil
        end

        if v125 ~= v8 then
            v8 = v125

            if v7 then
                TutorialBeam.Destroy(v7)
                v7 = nil
            end

            if v125 then
                v7 = TutorialBeam.Attach(v125, {
                    BeamName = "GhostDogGuide"
                })
            end
        end
    end

    if n1 == v118.Stage then
        return
    end

    local v129 = n1

    n1 = v118.Stage

    if v129 == Stage.HasRod and v118.Stage == Stage.Done then
        n2 = os.clock() + 20
    end
end

local function mountWorld() -- line: 756
    -- upvalues: Workspace (copy), Artifacts (copy), Handoff (copy), GhostDogQuest (copy), GhostDogQuest2 (copy), HalloweenDimension (copy), Hud (copy), Memories (copy), Npcs (copy), Save (copy), Speech (copy), Trove (copy), TutorialBeam (copy), Stage (copy), v3 (ref), v4 (ref), v7 (ref), v8 (ref), v9 (ref), n1 (ref), syncWorld (ref), buildCastRing (copy), buildCastSpot (copy), talkTo (copy)
    local v130 = Workspace:FindFirstChild(HalloweenDimension.MapName)
    local v131 = v130 and v130:FindFirstChild(GhostDogQuest.FolderName)
    local v132 = v131 and v131:FindFirstChild(GhostDogQuest.MarkersName)

    if v132 == nil or not v132:IsA("Folder") then
        v132 = nil
    end

    local v133 = Save.Peek()
    local v134 = if v133 == nil then nil else v133.GhostDogQuest or GhostDogQuest2.Blank()

    if v132 == nil or v134 == nil then
        return
    end

    v4 = v132

    local v135 = Trove.new()

    v3 = v135
    Hud.Mount()
    v135:Add(Hud.Unmount)
    v135:Add(Memories.Reset)
    Npcs.Spawn(v132, v134.Stage >= Stage.Reunion, v134.Stage == Stage.HasRod and Handoff.HasRod())
    v135:Add(Npcs.Clear)
    v135:Add(Artifacts.Clear)
    v135:Add(Speech.Stop)
    v135:Add(function() -- line: 776
        -- upvalues: TutorialBeam (copy), v7 (ref), v8 (ref), v9 (ref)
        if v8 ~= nil then
            v8 = nil

            if v7 then
                TutorialBeam.Destroy(v7)
                v7 = nil
            end
        end

        v9 = false
    end)

    local v136 = Npcs.Dog()
    local v137 = Npcs.Fisherman()

    if v136 then
        v135:Connect(v136.Prompt.Triggered, function() -- line: 783
            -- upvalues: talkTo (copy)
            task.spawn(talkTo, "Dog")
        end)
    end

    if v137 then
        v135:Connect(v137.Prompt.Triggered, function() -- line: 788
            -- upvalues: talkTo (copy)
            task.spawn(talkTo, "Fisherman")
        end)
    end

    buildCastRing(v135)
    buildCastSpot(v135)
    n1 = v134.Stage
    syncWorld()
end

local function unmountWorld() -- line: 798
    -- upvalues: v3 (ref), v4 (ref), v6 (ref), v10 (ref)
    local v138 = v3

    v3 = nil
    v4 = nil
    v6 = false
    v10 = false

    if v138 then
        v138:Destroy()
    end
end

local function syncRunning() -- line: 809
    -- upvalues: Hud (copy), Memories (copy), LocalPlayer (copy), PlayerAttributes (copy)
    local v139 = LocalPlayer:GetAttribute(PlayerAttributes.Carrying) == true

    Hud.SetHidden(v139)

    if v139 and Memories.IsOpen() then
        Memories.Close()
    end
end

local function refresh() -- line: 817
    -- upvalues: Workspace (copy), GhostDogQuestFlags (copy), GhostDogQuest (copy), HalloweenDimension (copy), Save (copy), LocalPlayer (copy), PlayerAttributes (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v10 (ref), syncWorld (ref), mountWorld (copy)
    local v140 = GhostDogQuestFlags.Enabled:Get()
    local v141, v142

    if v140 then
        if LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true then
            local v143 = Workspace:FindFirstChild(HalloweenDimension.MapName)

            v141 = v143 and v143:FindFirstChild(GhostDogQuest.FolderName)

            local v144 = v141 and v141:FindFirstChild(GhostDogQuest.MarkersName)

            if v144 == nil or not v144:IsA("Folder") then
                v144 = nil
            end

            v142 = v144 ~= nil and Save.IsLoaded()
        else
            v142 = false
        end
    else
        v142 = v140
    end

    if v142 and v3 == nil then
        mountWorld()
    elseif not v142 and v3 ~= nil and not v5 then
        local v145 = v3

        v3 = nil
        v4 = nil
        v6 = false
        v10 = false

        if v145 then
            v145:Destroy()
        end
    elseif v142 then
        local v146 = Workspace:FindFirstChild(HalloweenDimension.MapName)
        local v147 = v146 and v146:FindFirstChild(GhostDogQuest.FolderName)
        local v148 = v147 and v147:FindFirstChild(GhostDogQuest.MarkersName)

        if v148 == nil or not v148:IsA("Folder") then
            v148 = nil
        end

        if v148 ~= v4 and not v5 then
            local v149 = v3

            v3 = nil
            v4 = nil
            v6 = false
            v10 = false

            if v149 then
                v149:Destroy()
            end

            mountWorld()
        else
            syncWorld()
        end
    end
end

function t1.PrepareCast() -- line: 834
    -- upvalues: Handoff (copy), GhostDogQuest2 (copy), Memories (copy), Save (copy), Speech (copy), Stage (copy), v3 (ref), v5 (ref), v10 (ref)
    local v150 = Save.Peek()
    local v151 = if v150 == nil then nil else v150.GhostDogQuest or GhostDogQuest2.Blank()

    if v151 == nil or v151.Stage ~= Stage.HasRod or v3 == nil then
        return true
    end

    if v5 or Handoff.IsRunning() then
        return false
    end

    if v10 then
        Speech.Stop()
    end

    Memories.Close()

    return true
end

function t1.Hooked(p18) -- line: 849
    -- upvalues: runCast (copy)
    return (runCast(p18))
end

function t1.GhostFish(p19) -- line: 853
    -- upvalues: runGhostFish (copy)
    return (runGhostFish(p19))
end

function t1.Start() -- line: 857
    -- upvalues: RunService (copy), GhostDogQuestFlags (copy), Hud (copy), Memories (copy), Save (copy), Trove (copy), LocalPlayer (copy), PlayerAttributes (copy), unmountWorld (copy), syncRunning (copy), refresh (copy)
    local v152 = Trove.new()

    v152:Connect(Save.Watch("GhostDogQuest"), function() -- line: 859
        -- upvalues: refresh (copy)
        task.defer(refresh)
    end)
    v152:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Inside), function() -- line: 862
        -- upvalues: refresh (copy)
        task.defer(refresh)
    end)
    v152:Connect(GhostDogQuestFlags.Enabled.Changed, function() -- line: 865
        -- upvalues: refresh (copy)
        task.defer(refresh)
    end)
    v152:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Carrying), syncRunning)

    local v153 = LocalPlayer:GetAttribute(PlayerAttributes.Carrying) == true

    Hud.SetHidden(v153)

    if v153 and Memories.IsOpen() then
        Memories.Close()
    end

    local n3 = 0

    v152:Connect(RunService.Heartbeat, function(p20) -- line: 874
        -- upvalues: n3 (ref), refresh (copy)
        n3 += p20

        if n3 >= 0.5 then
            n3 = 0
            refresh()
        end
    end)
    v152:Add(unmountWorld)
    task.spawn(function() -- line: 882
        -- upvalues: Save (copy), refresh (copy)
        Save.Await()
        refresh()
    end)

    return v152
end

return t1
