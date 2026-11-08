-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local CrateOpeningSpinner = require(ReplicatedStorage.Client.UI.CrateOpeningSpinner)
local EggScaling = require(ReplicatedStorage.Shared.Util.EggScaling)
local EggToolDisplay = require(ReplicatedStorage.Shared.Eggs.EggToolDisplay)
local Emit = require(ReplicatedStorage.UserGenerated.VFX.Emit)
local GUI = require(ReplicatedStorage.Client.GUI)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Message = require(ReplicatedStorage.Client.Message)
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local MonsterParasite2 = require(ReplicatedStorage.Shared.Types.MonsterParasite)

require(ReplicatedStorage.Packages.Networking)

local ParasiteVisual = require(ReplicatedStorage.Shared.Eggs.ParasiteVisual)
local PlayVFX = require(ReplicatedStorage.UserGenerated.VFX.PlayVFX)
local Rarities = require(ReplicatedStorage.Data.Rarity).Rarities
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VisualTransform = require(ReplicatedStorage.Shared.Utils.VisualTransform)

return {
    Start = function() -- Start | line: 72
        -- upvalues: ContentProvider (copy), Debris (copy), HttpService (copy), KeyframeSequenceProvider (copy), Players (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), ButtonFX (copy), CameraShaker (copy), CameraShakerDriver (copy), CrateOpeningSpinner (copy), EggScaling (copy), EggToolDisplay (copy), Emit (copy), GUI (copy), HiddenUIHandler (copy), Message (copy), MonsterParasite (copy), MonsterParasite2 (copy), ParasiteVisual (copy), PlayVFX (copy), Rarities (copy), Remotes (copy), Save (copy), Tabs (copy), Timer (copy), Trove (copy), VisualTransform (copy)
        local MonsterParasite3 = Remotes.MonsterParasite
        local Fader = VisualTransform.Fader
        local v1 = Random.new()
        local LocalPlayer = Players.LocalPlayer
        local v2 = Trove.new()
        local v3 = v2:Extend()
        local t2 = {}
        local t3 = {}
        local v4 = nil
        local clone = nil
        local v5 = nil
        local v6 = MonsterParasite2.DefaultState()
        local v7 = false
        local v8 = false
        local v9 = false
        local v10 = false
        local v11 = false
        local OpeningId = nil
        local OpeningId2 = nil
        local n1 = 0
        local n2 = 0
        local t4 = {}
        local v12, v13, v14, connection, result
        local v15 = CameraShaker.new()

        local function runMotion(p1, p2) -- line: 114
            -- upvalues: RunService (copy)
            local n3 = 0

            repeat
                if not (n3 < p1) then
                    return true
                end

                n3 = math.min(n3 + RunService.PreRender:Wait(), p1)
            until p2(n3 / p1)

            return false
        end

        local function playSound(p3, p4) -- line: 129
            -- upvalues: ReplicatedStorage (copy), Audio (copy), MonsterParasite (copy)
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local Sounds = if Assets then Assets:FindFirstChild("Sounds") else nil
            local v17 = if Sounds then Sounds:FindFirstChild(MonsterParasite.SoundFolderName) else nil
            local v18 = if v17 then v17:FindFirstChild(p3) else nil

            if v18 and v18:IsA("Sound") then
                Audio.Play(v18, p4)
            end
        end

        local function resolveChestTemplate() -- line: 141
            -- upvalues: ReplicatedStorage (copy), MonsterParasite (copy)
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local Models = if Assets then Assets:FindFirstChild("Models") else nil
            local v19 = if Models then Models:FindFirstChild(MonsterParasite.AssetsFolderName) else nil
            local v20 = if v19 then v19:FindFirstChild(MonsterParasite.ChestModelName) else nil

            return if v20 and v20:IsA("Model") and v20.PrimaryPart then v20 else nil
        end

        local function resolveVfxTemplate(p5) -- line: 157
            -- upvalues: ReplicatedStorage (copy), MonsterParasite (copy)
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local VFX = if Assets then Assets:FindFirstChild("VFX") else nil
            local v21 = if VFX then VFX:FindFirstChild(MonsterParasite.VfxFolderName) else nil
            local v22 = if v21 then v21:FindFirstChild(p5) else nil

            return if v22 and v22:IsA("Attachment") then v22 else nil
        end

        local function resolveEnergyBurstTemplate() -- line: 167
            -- upvalues: resolveVfxTemplate (copy), MonsterParasite (copy)
            return (resolveVfxTemplate(MonsterParasite.EnergyBurstVfxName))
        end

        local function resolveSwapPoofTemplate() -- line: 171
            -- upvalues: resolveVfxTemplate (copy), MonsterParasite (copy)
            return (resolveVfxTemplate(MonsterParasite.SwapPoofVfxName))
        end

        local function preloadMonsterAssets() -- line: 184
            -- upvalues: ContentProvider (copy), ReplicatedStorage (copy), MonsterParasite (copy)
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local Models = if Assets then Assets:FindFirstChild("Models") else nil
            local v23 = if Models then Models:FindFirstChild(MonsterParasite.AssetsFolderName) else nil

            if v23 == nil then
                return
            end

            local t5 = {}

            local function enqueueModel(p6) -- line: 194
                -- upvalues: v23 (copy), t5 (copy)
                local v24 = v23:FindFirstChild(p6)

                if v24 ~= nil then
                    table.insert(t5, v24)

                    for _, descendant in v24:GetDescendants() do
                        if descendant:IsA("MeshPart") then
                            table.insert(t5, descendant)
                        end
                    end
                end
            end

            for _, v25 in MonsterParasite.MonsterModelNames do
                enqueueModel(v25)
            end

            enqueueModel(MonsterParasite.ChestModelName)

            local t6 = {}

            for _, v26 in MonsterParasite.MonsterAnimationIdsByIndex do
                local t7 = {
                    v26.Idle,
                    v26.Yank
                }
                local Burp = v26.Burp

                if Burp ~= nil then
                    table.insert(t7, Burp)
                end

                for _, v27 in t7 do
                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = ("rbxassetid://%*"):format(v27)
                    table.insert(t6, Animation)
                    table.insert(t5, Animation)
                end
            end

            local Particles = if Assets then Assets:FindFirstChild("Particles") else nil
            local v28 = if Particles then Particles:FindFirstChild(MonsterParasite.GroundHitParticlesName) else nil

            if v28 ~= nil then
                table.insert(t5, v28)
            end

            local function v29() -- line: 238
                -- upvalues: t5 (copy), ContentProvider (copy)
                ContentProvider:PreloadAsync(t5)
            end

            pcall(v29)

            for _, v30 in t6 do
                v30:Destroy()
            end
        end

        local function getMonsterModelIndex(p7) -- line: 246
            -- upvalues: MonsterParasite (copy)
            local Attribute = p7:GetAttribute(MonsterParasite.MonsterModelIndexAttributeName)

            return if typeof(Attribute) == "number" then Attribute else nil
        end

        local function getMonsterAnimationIds(p8) -- line: 255
            -- upvalues: MonsterParasite (copy)
            local Attribute = p8:GetAttribute(MonsterParasite.MonsterModelIndexAttributeName)

            if typeof(Attribute) ~= "number" then
                Attribute = nil
            end

            return if Attribute ~= nil then MonsterParasite.MonsterAnimationIdsByIndex[Attribute] else nil
        end

        local function waitForAnimator(p9) -- line: 270
            local v31 = p9:FindFirstChildWhichIsA("Animator", true)

            if v31 ~= nil then
                return v31
            end

            local v32 = os.clock() + 5

            while true do
                task.wait()

                if p9.Parent == nil then
                    break
                end

                local v33 = p9:FindFirstChildWhichIsA("Animator", true)

                if v33 == nil then
                    if v32 <= os.clock() then
                        if v33 == nil then
                            warn((("[MonsterParasite] Missing Animator in %*"):format((p9:GetFullName()))))
                        end
                    else
                        continue
                    end
                end

                return v33
            end

            return nil
        end

        local function loadAnimationTrack(p10, p11) -- line: 289
            -- upvalues: waitForAnimator (copy)
            local v34 = waitForAnimator(p10)

            if v34 ~= nil then
                local Animation = Instance.new("Animation")

                Animation.AnimationId = ("rbxassetid://%*"):format(p11)

                local function v35() -- line: 299
                    -- upvalues: v34 (copy), Animation (copy)
                    return v34:LoadAnimation(Animation)
                end

                local ok, result = pcall(v35)

                Animation:Destroy()

                if ok then
                    return result
                end

                warn((("[MonsterParasite] Failed to load animation %*: %*"):format(p11, result)))
            end

            return nil
        end

        local function playAnimationAndWait(p12, p13, p14) -- line: 312
            -- upvalues: Timer (copy), Trove (copy)
            local v36 = false
            local BindableEvent = Instance.new("BindableEvent")
            local v37 = Trove.new()

            v37:Add(BindableEvent)

            local function finish() -- line: 322
                -- upvalues: v36 (ref), BindableEvent (copy)
                if not v36 then
                    v36 = true
                    BindableEvent:Fire()
                end
            end

            v37:Connect(p12.Ended, finish)
            v37:Connect(p12.Stopped, finish)
            v37:Connect(p13.Destroying, finish)
            p12:Play(0.1)
            v37:Add(Timer.Simple(math.max(p12.Length + 1, 5), finish))

            if p14 then
                p14()
            end

            if not v36 then
                BindableEvent.Event:Wait()
            end

            v37:Destroy()
        end

        local function pauseIdle(p15) -- line: 343
            -- upvalues: t3 (copy)
            local v39 = t3[p15]

            if v39 and v39.IsPlaying then
                v39:Stop(0.1)
            end
        end

        local function resumeIdle(p16) -- line: 350
            -- upvalues: t3 (copy)
            local v40 = t3[p16]

            if v40 and p16.Parent and not v40.IsPlaying then
                v40:Play(0.1)
            end
        end

        local t8 = {
            [2] = { "Tongue3" },
            [4] = { "root", "BackLeg1.L", "BackLeg1.R" }
        }
        local t9 = {}

        local function getPoseInfo(p17) -- line: 409
            -- upvalues: t9 (copy), KeyframeSequenceProvider (copy)
            local v41 = t9[p17]

            if v41 ~= nil then
                return v41
            end

            local function v42() -- line: 414
                -- upvalues: p17 (copy), KeyframeSequenceProvider (copy)
                local KeyframeSequenceAsync = KeyframeSequenceProvider:GetKeyframeSequenceAsync((("rbxassetid://%*"):format(p17)))
                local t10 = {}
                local t11 = {}

                local function scan(p18) -- line: 420
                    -- upvalues: t10 (copy), t11 (copy), scan (copy)
                    local Name = p18.Name
                    local v43 = t10[Name]

                    if v43 ~= nil then
                        if not t11[Name] and not v43:FuzzyEq(p18.CFrame, 0.001) then
                            t11[Name] = true
                        end
                    else
                        t10[Name] = p18.CFrame
                    end

                    for _, v44 in p18:GetSubPoses() do
                        scan(v44)
                    end
                end

                for _, v45 in KeyframeSequenceAsync:GetKeyframes() do
                    for _, child in v45:GetChildren() do
                        if child:IsA("Pose") then
                            scan(child)
                        end
                    end
                end

                local t12 = {}

                for v46 in t10 do
                    t12[v46] = {
                        constant = not t11[v46]
                    }
                end

                return t12
            end

            local ok, result = pcall(v42)

            if not ok then
                return nil
            end

            t9[p17] = result

            return result
        end

        local function collectStrayBones(p19, p20, p21) -- line: 455
            -- upvalues: t8 (copy), t9 (copy), KeyframeSequenceProvider (copy)
            local Idle = p20.Idle
            local result = t9[Idle]

            if result == nil then
                local function v47() -- line: 414
                    -- upvalues: Idle (copy), KeyframeSequenceProvider (copy)
                    local KeyframeSequenceAsync = KeyframeSequenceProvider:GetKeyframeSequenceAsync((("rbxassetid://%*"):format(Idle)))
                    local t13 = {}
                    local t14 = {}

                    local function scan(p22) -- line: 420
                        -- upvalues: t13 (copy), t14 (copy), scan (copy)
                        local Name = p22.Name
                        local v48 = t13[Name]

                        if v48 ~= nil then
                            if not t14[Name] and not v48:FuzzyEq(p22.CFrame, 0.001) then
                                t14[Name] = true
                            end
                        else
                            t13[Name] = p22.CFrame
                        end

                        for _, v49 in p22:GetSubPoses() do
                            scan(v49)
                        end
                    end

                    for _, v50 in KeyframeSequenceAsync:GetKeyframes() do
                        for _, child in v50:GetChildren() do
                            if child:IsA("Pose") then
                                scan(child)
                            end
                        end
                    end

                    local t15 = {}

                    for v51 in t13 do
                        t15[v51] = {
                            constant = not t14[v51]
                        }
                    end

                    return t15
                end

                local ok

                ok, result = pcall(v47)

                if ok then
                    t9[Idle] = result
                else
                    result = nil
                end
            end

            if result == nil then
                return {}
            end

            local t16 = {
                p20.Yank
            }
            local Burp = p20.Burp

            if Burp ~= nil then
                table.insert(t16, Burp)
            end

            local t17 = {}

            for _, v52 in t16 do
                local result2 = t9[v52]

                if result2 == nil then
                    local function v53() -- line: 414
                        -- upvalues: v52 (copy), KeyframeSequenceProvider (copy)
                        local KeyframeSequenceAsync = KeyframeSequenceProvider:GetKeyframeSequenceAsync((("rbxassetid://%*"):format(v52)))
                        local t18 = {}
                        local t19 = {}

                        local function scan(p23) -- line: 420
                            -- upvalues: t18 (copy), t19 (copy), scan (copy)
                            local Name = p23.Name
                            local v54 = t18[Name]

                            if v54 ~= nil then
                                if not t19[Name] and not v54:FuzzyEq(p23.CFrame, 0.001) then
                                    t19[Name] = true
                                end
                            else
                                t18[Name] = p23.CFrame
                            end

                            for _, v55 in p23:GetSubPoses() do
                                scan(v55)
                            end
                        end

                        for _, v56 in KeyframeSequenceAsync:GetKeyframes() do
                            for _, child in v56:GetChildren() do
                                if child:IsA("Pose") then
                                    scan(child)
                                end
                            end
                        end

                        local t20 = {}

                        for v57 in t18 do
                            t20[v57] = {
                                constant = not t19[v57]
                            }
                        end

                        return t20
                    end

                    local ok

                    ok, result2 = pcall(v53)

                    if ok then
                        t9[v52] = result2
                    else
                        result2 = nil
                    end
                end

                if result2 ~= nil then
                    for v58 in result2 do
                        if result[v58] == nil then
                            t17[v58] = true
                        end
                    end
                end
            end

            for _, v59 in t8[p21] or {} do
                local v60 = result[v59]

                if v60 == nil or v60.constant then
                    t17[v59] = true
                end
            end

            local t21 = {}

            for v61 in t17 do
                local v62 = p19:FindFirstChild(v61, true)

                if v62 and v62:IsA("Bone") then
                    table.insert(t21, v62)
                end
            end

            return t21
        end

        local function guardStrayBones(p24, p25, p26, p27, p28) -- line: 497
            -- upvalues: collectStrayBones (copy), RunService (copy)
            if p24.Parent == nil then
                return
            end

            local v63 = collectStrayBones(p24, p26, p27)

            if #v63 ~= 0 then
                local t22 = {}
                local n4 = 0

                p28:Connect(RunService.PostSimulation, function(p29) -- line: 519
                    -- upvalues: p25 (copy), v63 (copy), t22 (copy), n4 (ref)
                    if not p25.IsPlaying then
                        n4 = 0
                        table.clear(t22)

                        return
                    end

                    if n4 <= 0 then
                        for _, v64 in v63 do
                            t22[v64] = v64.Transform
                        end
                    end

                    n4 = math.min(n4 + p29, 0.18)

                    local v66 = n4 / 0.18

                    for _, v67 in v63 do
                        local v68 = t22[v67]

                        if v68 == nil or v66 >= 1 then
                            v67.Transform = CFrame.identity
                        else
                            v67.Transform = v68:Lerp(CFrame.identity, v66)
                        end
                    end
                end)
            end
        end

        local function startIdle(p30, p31) -- line: 544
            -- upvalues: t3 (copy), loadAnimationTrack (copy), guardStrayBones (copy), MonsterParasite (copy)
            local Attribute = p30:GetAttribute(MonsterParasite.MonsterModelIndexAttributeName)

            if typeof(Attribute) ~= "number" then
                Attribute = nil
            end

            local v69 = if Attribute == nil then nil else MonsterParasite.MonsterAnimationIdsByIndex[Attribute]
            local Attribute2 = p30:GetAttribute(MonsterParasite.MonsterModelIndexAttributeName)

            if typeof(Attribute2) ~= "number" then
                Attribute2 = nil
            end

            if v69 ~= nil and Attribute2 ~= nil then
                local v70 = false

                p31:Add(function() -- line: 551
                    -- upvalues: v70 (ref)
                    v70 = true
                end)
                task.spawn(function() -- line: 554
                    -- upvalues: p30 (copy), p31 (copy), Attribute2 (ref), v70 (ref), v69 (copy), t3 (copy), loadAnimationTrack (copy), guardStrayBones (copy)
                    local v71 = loadAnimationTrack(p30, v69.Idle)

                    if v71 ~= nil then
                        if v70 or p30.Parent == nil then
                            v71:Destroy()
                        else
                            v71.Looped = true
                            v71.Priority = Enum.AnimationPriority.Idle
                            t3[p30] = v71
                            p31:Add(v71)
                            p31:Add(function() -- line: 573
                                -- upvalues: p30 (copy), t3 (copy)
                                t3[p30] = nil
                            end)
                            v71:Play(0.1)
                            guardStrayBones(p30, v71, v69, Attribute2, p31)
                        end
                    end
                end)
            end
        end

        local function getEquippedEggTool() -- line: 581
            -- upvalues: LocalPlayer (copy), EggToolDisplay (copy)
            local Character = LocalPlayer.Character

            if Character ~= nil then
                for _, child in Character:GetChildren() do
                    if child:IsA("Tool") and EggToolDisplay.IsEggTool(child) then
                        return child
                    end
                end
            end

            return nil
        end

        local function getEquippedEggHandle() -- line: 594
            -- upvalues: getEquippedEggTool (copy)
            local v72 = getEquippedEggTool()
            local Handle = if v72 then v72:FindFirstChild("Handle") else nil

            return if Handle and Handle:IsA("BasePart") then Handle else nil
        end

        local function getEquippedEggModel() -- line: 603
            -- upvalues: LocalPlayer (copy), getEquippedEggTool (copy), EggToolDisplay (copy)
            local v73 = getEquippedEggTool()

            if v73 == nil then
                return nil
            end

            local v74 = EggToolDisplay.GetToolUid(v73)
            local v75 = if v74 then v73:FindFirstChild((("%*_%*"):format(LocalPlayer.UserId, v74))) else nil

            if v75 == nil or not v75:IsA("Model") then
                return v73:FindFirstChildOfClass("Model")
            end

            return v75
        end

        local function getWorldCFrame(p32) -- line: 618
            if p32 ~= nil then
                if p32:IsA("BasePart") then
                    return p32.CFrame
                end

                if p32:IsA("Attachment") or p32:IsA("Bone") then
                    return p32.WorldCFrame
                end
            end

            return nil
        end

        local t23 = {
            ScaleTweenDelaySeconds = 0.2,
            PickupFadeStart = 0.55,
            PickupFadeEnd = 1,
            PickupMinScale = 0.001,
            PickupTargetHeight = 1.5,
            MouthBiteStuds = 2.2,
            SeizeSeconds = 0.1,
            MouthPull = 0.85,
            SwallowSeconds = 0.2,
            HandPoseName = "toolnone",
            HandPoseReleaseSeconds = 0.4,
            SwallowDepth = 0.9,
            SwallowScale = 0.05,
            MinScale = 0.001,
            MouthTargetNames = { "MouthCenter1", "ParasiteEatTarget", "Tongue3" }
        }

        local function getAnimatedWorldCFrame(p33) -- line: 666
            if p33 == nil then
                return nil
            end

            if p33:IsA("Attachment") then
                local Parent = p33.Parent

                if Parent == nil or not Parent:IsA("Bone") then
                    return p33.WorldCFrame
                end

                return Parent.TransformedWorldCFrame * p33.CFrame
            end

            if p33:IsA("Bone") then
                return p33.TransformedWorldCFrame
            end

            if p33 ~= nil then
                if p33:IsA("BasePart") then
                    return p33.CFrame
                end

                if p33:IsA("Attachment") or p33:IsA("Bone") then
                    return p33.WorldCFrame
                end
            end

            return nil
        end

        local function resolveGrabTarget(p34) -- line: 683
            -- upvalues: MonsterParasite (copy)
            return p34:FindFirstChild("ParasiteGrabber", true) or p34:FindFirstChild(MonsterParasite.TongueTipName, true) or p34:FindFirstChild(MonsterParasite.ParasiteEatTargetPartName, true)
        end

        local function resolveMouthTarget(p35) -- line: 691
            -- upvalues: t23 (copy)
            for _, v76 in t23.MouthTargetNames do
                local v77 = p35:FindFirstChild(v76, true)

                if v77 ~= nil then
                    return v77
                end
            end

            return p35.PrimaryPart
        end

        local function resolveChestOrigin(p36) -- line: 701
            -- upvalues: MonsterParasite (copy)
            for _, v78 in MonsterParasite.ChestOriginNames do
                local v79 = p36:FindFirstChild(v78, true)

                if v79 ~= nil then
                    return v79
                end
            end

            return nil
        end

        local function buildGroundProbeParams(p37) -- line: 711
            -- upvalues: clone (ref), Players (copy), Workspace (copy), MonsterParasite (copy)
            local v80 = RaycastParams.new()

            v80.FilterType = Enum.RaycastFilterType.Exclude
            v80.IgnoreWater = true

            local t24 = {
                p37
            }

            if clone then
                table.insert(t24, clone)
            end

            local v81 = Workspace:FindFirstChild(MonsterParasite.MarkerFolderName, true)

            if v81 then
                table.insert(t24, v81)
            end

            for _, player in Players:GetPlayers() do
                local Character = player.Character

                if Character then
                    table.insert(t24, Character)
                end
            end

            v80.FilterDescendantsInstances = t24

            return v80
        end

        local function monsterForward(p38, p39) -- line: 738
            local v82 = p38:GetPivot().LookVector * Vector3.new(1, 0, 1)

            if v82.Magnitude < 0.05 then
                v82 = p39.LookVector * Vector3.new(1, 0, 1)
            end

            if v82.Magnitude > 0.001 then
                return v82.Unit
            end

            return (Vector3.new(0, 0, -1))
        end

        local function probeGround(p40, p41) -- line: 749
            -- upvalues: Workspace (copy), MonsterParasite (copy)
            return Workspace:Raycast(p40 + Vector3.new(0, 1, 0) * MonsterParasite.ChestGroundProbeHeight, Vector3.new(0, 1, 0) * -MonsterParasite.ChestGroundProbeDepth, p41)
        end

        local function resolveGroundLanding(p42, p43) -- line: 772
            -- upvalues: v1 (copy), buildGroundProbeParams (copy), Workspace (copy), MonsterParasite (copy)
            local v83 = p42:GetPivot().LookVector * Vector3.new(1, 0, 1)

            if v83.Magnitude < 0.05 then
                v83 = p43.LookVector * Vector3.new(1, 0, 1)
            end

            local v84 = if v83.Magnitude > 0.001 then v83.Unit else Vector3.new(0, 0, -1)
            local Position = p43.Position
            local v85 = buildGroundProbeParams(p42)
            local ChestThrowDistanceMin = MonsterParasite.ChestThrowDistanceMin
            local v87 = math.max(MonsterParasite.ChestThrowDistanceMax - ChestThrowDistanceMin, 0)
            local v88 = math.rad(MonsterParasite.ChestThrowSpreadDegrees)
            local v89 = math.rad(MonsterParasite.ChestThrowStraightJitterDegrees)
            local v90 = math.max(MonsterParasite.ChestThrowAttempts, 1)
            local v93 = math.max(math.floor(v90 / 2), 1)

            local function candidate(p44) -- line: 787
                -- upvalues: Position (copy), v85 (copy), ChestThrowDistanceMin (copy), v87 (copy), v1 (copy), Workspace (copy), MonsterParasite (copy)
                local v94 = Position + p44 * (ChestThrowDistanceMin + v1:NextNumber() * v87)
                local v95 = Workspace:Raycast(Position, v94 - Position, v85)
                local v96 = v95 == nil
                local v97, v98

                if not v96 then
                    v97 = v95.Position - p44 * 1.5
                    v98 = ((v97 - Position) * Vector3.new(1, 0, 1)).Magnitude < ChestThrowDistanceMin
                end

                if not v96 and v98 then
                    return nil, nil
                end

                if v96 then
                    v97 = v94
                end

                local v99 = Workspace:Raycast(v97 + Vector3.new(0, 1, 0) * MonsterParasite.ChestGroundProbeHeight, Vector3.new(0, 1, 0) * -MonsterParasite.ChestGroundProbeDepth, v85)

                if v99 == nil then
                    return nil, nil
                end

                return CFrame.new(v99.Position) * CFrame.Angles(0, v1:NextNumber() * 3.141592653589793 * 2, 0), v99.Normal
            end

            for i = 1, v90 do
                local v101 = math.floor(i / 2)
                local v102 = if v101 == 0 then (v1:NextNumber() * 2 - 1) * v89 else (if i % 2 == 0 then 1 else -1) * v88 * math.min(v101 / v93, 1)
                local v105, v106 = candidate(CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v102) * v84)

                if v105 ~= nil and v106 ~= nil then
                    return v105, v106
                end
            end

            local v107 = Position + v84 * ChestThrowDistanceMin
            local v108 = Workspace:Raycast(Position, v107 - Position, v85)

            if v108 ~= nil then
                v107 = v108.Position - v84 * 1.5
            end

            local v109 = Workspace:Raycast(v107 + Vector3.new(0, 1, 0) * MonsterParasite.ChestGroundProbeHeight, Vector3.new(0, 1, 0) * -MonsterParasite.ChestGroundProbeDepth, v85)
            local v110 = if v109 then v109.Position else Vector3.new(v107.X, p42:GetPivot().Position.Y, v107.Z)
            local v111 = CFrame.new(v110) * CFrame.Angles(0, v1:NextNumber() * 3.141592653589793 * 2, 0)

            if v109 then
                return v111, v109.Normal
            end

            return v111, (Vector3.new(0, 1, 0))
        end

        local function resolveEffectParent() -- line: 838
            -- upvalues: Workspace (copy)
            local Transient = Workspace:FindFirstChild("Transient")

            if not (Transient and Transient:IsA("Folder")) then
                return Workspace
            end

            return Transient
        end

        local function createChest(p45) -- line: 852
            -- upvalues: clone (ref), resolveChestTemplate (copy), Workspace (copy)
            local v112 = resolveChestTemplate()

            if v112 == nil then
                return nil
            end

            if clone then
                clone:Destroy()
                clone = nil
            end

            local clone2 = v112:Clone()

            for _, descendant in clone2:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanTouch = false
                end
            end

            clone2:PivotTo(p45)

            local Transient = Workspace:FindFirstChild("Transient")

            clone2.Parent = if not (Transient and Transient:IsA("Folder")) then Workspace else Transient
            clone = clone2

            return clone2
        end

        local function stopPendingYankFollow() -- line: 881
            -- upvalues: connection (ref)
            local connection2 = connection

            connection = nil

            if connection2 ~= nil then
                connection2:Disconnect()
            end
        end

        local function prepareEggYankClone(p46) -- line: 901
            -- upvalues: Workspace (copy), MonsterParasite (copy), ParasiteVisual (copy)
            if p46.PrimaryPart == nil then
                return nil
            end

            local clone = p46:Clone()

            local function inside(p47) -- line: 906
                -- upvalues: clone (copy)
                return p47 ~= nil and (p47:IsDescendantOf(clone))
            end

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                    descendant.Massless = true
                elseif descendant:IsA("BillboardGui") then
                    descendant:Destroy()
                elseif descendant:IsA("Motor6D") or descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
                    local Part0 = descendant.Part0

                    if Part0 ~= nil and Part0:IsDescendantOf(clone) then
                        local Part1 = descendant.Part1

                        if Part1 == nil or not Part1:IsDescendantOf(clone) then
                            descendant:Destroy()
                        end
                    else
                        descendant:Destroy()
                    end
                end
            end

            local Transient = Workspace:FindFirstChild("Transient")

            clone.Parent = if not (Transient and Transient:IsA("Folder")) then Workspace else Transient
            clone:PivotTo(p46:GetPivot())

            local v113 = p46:FindFirstChild(MonsterParasite.ParasiteVisualName, true)
            local v114 = clone:FindFirstChild(MonsterParasite.ParasiteVisualName, true)

            if v113 ~= nil and v114 ~= nil and v113:IsA("Model") and v114:IsA("Model") then
                local v115 = ParasiteVisual.PoseDrift(v113) - ParasiteVisual.PoseDrift(v114)

                if v115.Magnitude > 0.001 then
                    v114:PivotTo(v114:GetPivot() + v115)
                end
            end

            return clone
        end

        local function holdHandPose() -- line: 960
            -- upvalues: LocalPlayer (copy), result (ref), t23 (copy)
            if result ~= nil then
                return
            end

            local Character = LocalPlayer.Character

            if Character ~= nil then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local Animator = if Humanoid == nil then nil else Humanoid:FindFirstChildOfClass("Animator")

                if Animator ~= nil then
                    local Animate = Character:FindFirstChild("Animate")
                    local v116 = if Animate == nil then nil else Animate:FindFirstChild(t23.HandPoseName)
                    local Animation = if v116 == nil then nil else v116:FindFirstChildOfClass("Animation")

                    if Animation ~= nil then
                        local Action = Enum.AnimationPriority.Action

                        for _, v117 in Animator:GetPlayingAnimationTracks() do
                            local Animation2 = v117.Animation

                            if Animation2 ~= nil and Animation2.AnimationId == Animation.AnimationId then
                                Action = v117.Priority
                                break
                            end
                        end

                        local function v118() -- line: 996
                            -- upvalues: Animator (copy), Animation (copy)
                            return Animator:LoadAnimation(Animation)
                        end

                        local ok, result2 = pcall(v118)

                        if ok then
                            result2.Looped = true
                            result2.Priority = Action
                            result2:Play(0)
                            result = result2
                        else
                            warn((("[MonsterParasite] Failed to hold the egg pose: %*"):format(result2)))
                        end
                    end
                end
            end
        end

        local function releaseHandPose() -- line: 1011
            -- upvalues: result (ref), t23 (copy)
            local result2 = result

            result = nil

            if result2 == nil then
                return
            end

            result2:Stop(t23.HandPoseReleaseSeconds)
            task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                -- upvalues: result2 (copy)
                result2:Destroy()
            end)
        end

        local function captureEquippedEgg() -- line: 1032
            -- upvalues: Fader (copy), LocalPlayer (copy), v12 (ref), v13 (ref), v14 (ref), connection (ref), getEquippedEggModel (copy), prepareEggYankClone (copy), holdHandPose (copy), RunService (copy), Workspace (copy)
            if v12 ~= nil then
                return
            end

            local v119 = getEquippedEggModel()

            if v119 ~= nil then
                local v120 = prepareEggYankClone(v119)

                if v120 ~= nil then
                    local v121 = Fader()

                    v121:Hide(v120, 1)
                    v12 = v120
                    v14 = v121
                    v13 = v119
                    holdHandPose()

                    local v122
                    local v123 = false
                    local connection2 = connection

                    connection = nil

                    if connection2 ~= nil then
                        connection2:Disconnect()
                    end

                    connection = RunService.RenderStepped:Connect(function() -- line: 1056
                        -- upvalues: v119 (copy), v120 (copy), v121 (copy), v122 (ref), v123 (ref), LocalPlayer (copy), Workspace (copy)
                        if v120.Parent == nil then
                            return
                        end

                        local Character = LocalPlayer.Character
                        local RightHand = if Character == nil then nil else Character:FindFirstChild("RightHand") or Character:FindFirstChild("Right Arm") or Character:FindFirstChild("HumanoidRootPart")

                        if RightHand == nil or not RightHand:IsA("BasePart") then
                            RightHand = nil
                        end

                        if v119:IsDescendantOf(Workspace) then
                            if RightHand ~= nil then
                                v122 = RightHand.CFrame:ToObjectSpace(v119:GetPivot())
                            end

                            v120:PivotTo(v119:GetPivot())
                        else
                            if not v123 then
                                v123 = true
                                v121:Hide(v120, 0)
                            end

                            if RightHand ~= nil and v122 ~= nil then
                                v120:PivotTo(RightHand.CFrame * v122)
                            end
                        end
                    end)
                end
            end
        end

        local function takeCapturedEgg() -- line: 1089
            -- upvalues: Fader (copy), LocalPlayer (copy), v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), t23 (copy), captureEquippedEgg (copy), Workspace (copy), ParasiteVisual (copy)
            captureEquippedEgg()

            local connection2 = connection

            connection = nil

            if connection2 ~= nil then
                connection2:Disconnect()
            end

            local v124 = v12
            local v125 = v14
            local v126 = v13

            v12 = nil
            v14 = nil
            v13 = nil

            if v124 ~= nil and v124.Parent ~= nil then
                if v126 ~= nil and v126:IsDescendantOf(Workspace) then
                    v124:PivotTo(v126:GetPivot())
                    Fader():Hide(v126, 1)
                end

                if v125 ~= nil then
                    v125:Hide(v124, 0)
                end

                local Character = LocalPlayer.Character

                if Character ~= nil then
                    ParasiteVisual.Clear(Character)
                end

                local result2 = result

                result = nil

                if result2 ~= nil then
                    result2:Stop(t23.HandPoseReleaseSeconds)
                    task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                        -- upvalues: result2 (copy)
                        result2:Destroy()
                    end)
                end

                return v124
            end

            local result2 = result

            result = nil

            if result2 ~= nil then
                result2:Stop(t23.HandPoseReleaseSeconds)
                task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                    -- upvalues: result2 (copy)
                    result2:Destroy()
                end)
            end

            return nil
        end

        local function discardPendingYank() -- line: 1122
            -- upvalues: v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), t23 (copy)
            local connection2 = connection

            connection = nil

            if connection2 ~= nil then
                connection2:Disconnect()
            end

            local result2 = result

            result = nil

            if result2 ~= nil then
                result2:Stop(t23.HandPoseReleaseSeconds)
                task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                    -- upvalues: result2 (copy)
                    result2:Destroy()
                end)
            end

            if v12 ~= nil then
                v12:Destroy()
                v12 = nil
            end

            v14 = nil
            v13 = nil
        end

        local function carryEgg(p48, p49) -- line: 1144
            -- upvalues: t23 (copy), EggScaling (copy)
            local BoundingBox = p48:GetBoundingBox()
            local v127 = Vector3.new(1, 1, 1) * (t23.MouthBiteStuds * p49:GetScale())
            local Scale = p48:GetScale()

            return {
                Model = p48,
                StartScale = Scale,
                FitScale = math.min(Scale, EggScaling.FitInside(p48, v127)),
                CenterOffset = p48:GetPivot():PointToObjectSpace(BoundingBox.Position)
            }
        end

        local function placeCarriedEgg(p50, p51, p52) -- line: 1156
            local Model = p50.Model

            Model:ScaleTo(p52)
            Model:PivotTo(p51 * CFrame.new(-p50.CenterOffset * (p52 / p50.StartScale)))
        end

        local function swallowEgg(p53, p54, p55, p56, p57, p58) -- line: 1173
            -- upvalues: t23 (copy), getAnimatedWorldCFrame (copy), RunService (copy), TweenService (copy)
            local Model = p53.Model
            local t26 = {}

            t26[1] = 0

            local connection

            connection = RunService.PreRender:Connect(function(p59) -- line: 1184
                -- upvalues: p53 (copy), p54 (copy), p55 (copy), p56 (copy), p57 (copy), p58 (copy), Model (copy), t26 (copy), connection (ref), t23 (copy), getAnimatedWorldCFrame (copy), TweenService (copy)
                t26[1] = math.min(t26[1] + p59, t23.SwallowSeconds)

                local v129 = Model.Parent == nil or p54.Parent == nil

                if not v129 then
                    local v130 = getAnimatedWorldCFrame(p55)
                    local v131 = if v130 == nil then p57.Position else v130.Position + p54:GetPivot():VectorToWorldSpace(p56) * (t23.SwallowDepth * p54:GetScale())
                    local Value = TweenService:GetValue(t26[1] / t23.SwallowSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    local v132 = CFrame.new(p57.Position:Lerp(v131, Value)) * p57.Rotation
                    local v135 = math.max(t23.MinScale, (math.lerp(p58, p58 * t23.SwallowScale, Value)))
                    local Model = p53.Model

                    Model:ScaleTo(v135)
                    Model:PivotTo(v132 * CFrame.new(-p53.CenterOffset * (v135 / p53.StartScale)))
                end

                if not (v129 or t26[1] >= t23.SwallowSeconds) then
                    return
                end

                connection:Disconnect()
                Model:Destroy()
            end)
        end

        local function animateEggYank(p60) -- line: 1220
            -- upvalues: v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), runMotion (copy), t23 (copy), getAnimatedWorldCFrame (copy), resolveMouthTarget (copy), takeCapturedEgg (copy), carryEgg (copy), RunService (copy), TweenService (copy), MonsterParasite (copy)
            local PrimaryPart = p60.PrimaryPart

            if PrimaryPart ~= nil then
                local v136 = takeCapturedEgg()

                if v136 ~= nil then
                    local v137 = resolveMouthTarget(p60)
                    local v138 = carryEgg(v136, p60)
                    local v139 = v136:GetPivot() * CFrame.new(v138.CenterOffset)

                    runMotion(MonsterParasite.YankDuration, function(p61) -- line: 1233
                        -- upvalues: p60 (copy), PrimaryPart (copy), v136 (copy), v137 (copy), v138 (copy), v139 (copy), getAnimatedWorldCFrame (copy), TweenService (copy)
                        if v136.Parent == nil or p60.Parent == nil then
                            return true
                        end

                        local v140 = getAnimatedWorldCFrame(v137) or PrimaryPart.CFrame
                        local Value = TweenService:GetValue(p61, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                        local v141 = CFrame.new(v139.Position:Lerp(v140.Position, Value)) * v139.Rotation
                        local v142 = math.lerp(v138.StartScale, v138.FitScale, Value)
                        local Model = v138.Model

                        Model:ScaleTo(v142)
                        Model:PivotTo(v141 * CFrame.new(-v138.CenterOffset * (v142 / v138.StartScale)))

                        return nil
                    end)

                    if v136.Parent == nil or p60.Parent == nil then
                        v136:Destroy()
                    else
                        local v143 = v136:GetPivot() * CFrame.new(v138.CenterOffset * (v138.FitScale / v138.StartScale))
                        local FitScale, Model = v138.FitScale, v138.Model
                        local t27 = {}

                        t27[1] = 0

                        local connection
                        local PreRender = RunService.PreRender
                        local v144 = Vector3.new(0, 0, 1)

                        connection = PreRender:Connect(function(p62) -- line: 1184
                            -- upvalues: p60 (copy), v137 (copy), v138 (copy), v143 (copy), FitScale (copy), Model (copy), t27 (copy), connection (ref), v144 (copy), t23 (copy), getAnimatedWorldCFrame (copy), TweenService (copy)
                            t27[1] = math.min(t27[1] + p62, t23.SwallowSeconds)

                            local v146 = Model.Parent == nil or p60.Parent == nil

                            if not v146 then
                                local v147 = getAnimatedWorldCFrame(v137)
                                local v148 = if v147 == nil then v143.Position else v147.Position + p60:GetPivot():VectorToWorldSpace(v144) * (t23.SwallowDepth * p60:GetScale())
                                local Value = TweenService:GetValue(t27[1] / t23.SwallowSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                                local v149 = CFrame.new(v143.Position:Lerp(v148, Value)) * v143.Rotation
                                local v152 = math.max(t23.MinScale, (math.lerp(FitScale, FitScale * t23.SwallowScale, Value)))
                                local Model = v138.Model

                                Model:ScaleTo(v152)
                                Model:PivotTo(v149 * CFrame.new(-v138.CenterOffset * (v152 / v138.StartScale)))
                            end

                            if not (v146 or t27[1] >= t23.SwallowSeconds) then
                                return
                            end

                            connection:Disconnect()
                            Model:Destroy()
                        end)
                    end
                end
            else
                local connection2 = connection

                connection = nil

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                local result2 = result

                result = nil

                if result2 ~= nil then
                    result2:Stop(t23.HandPoseReleaseSeconds)
                    task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                        -- upvalues: result2 (copy)
                        result2:Destroy()
                    end)
                end

                if v12 ~= nil then
                    v12:Destroy()
                    v12 = nil
                end

                v14 = nil
                v13 = nil
            end
        end

        local function animateEggGrab(p63, p64) -- line: 1273
            -- upvalues: t23 (copy), getAnimatedWorldCFrame (copy), resolveMouthTarget (copy), takeCapturedEgg (copy), carryEgg (copy), animateEggYank (copy), RunService (copy), TweenService (copy), MonsterParasite (copy)
            if not p64.IsPlaying then
                animateEggYank(p63)

                return
            end

            local v153 = takeCapturedEgg()

            if v153 ~= nil then
                local v154 = p63:FindFirstChild("ParasiteGrabber", true) or p63:FindFirstChild(MonsterParasite.TongueTipName, true) or p63:FindFirstChild(MonsterParasite.ParasiteEatTargetPartName, true)
                local v155 = resolveMouthTarget(p63)
                local v156 = getAnimatedWorldCFrame(v154)
                local v157 = getAnimatedWorldCFrame(v155)

                if v156 ~= nil and v157 ~= nil then
                    local v158 = carryEgg(v153, p63)
                    local v159 = v153:GetPivot() * CFrame.new(v158.CenterOffset)
                    local Rotation = v159.Rotation
                    local v160 = v159.Position - v156.Position
                    local v161 = v156.Position - v157.Position
                    local Magnitude = v161.Magnitude
                    local v162 = if Magnitude > 0.01 then p63:GetPivot():VectorToObjectSpace(-v161.Unit) else Vector3.new(0, 0, 1)
                    local n5 = 0
                    local n6 = 0
                    local connection

                    connection = RunService.RenderStepped:Connect(function(p65) -- line: 1310
                        -- upvalues: p63 (copy), p64 (copy), v153 (copy), v154 (copy), v155 (copy), v158 (copy), Rotation (copy), v160 (copy), Magnitude (copy), n5 (ref), n6 (ref), connection (ref), v162 (copy), t23 (copy), getAnimatedWorldCFrame (copy), RunService (copy), TweenService (copy), MonsterParasite (copy)
                        if v153.Parent == nil or p63.Parent == nil then
                            connection:Disconnect()
                            v153:Destroy()
                        else
                            local v163 = getAnimatedWorldCFrame(v154)
                            local v164 = getAnimatedWorldCFrame(v155)

                            if v163 ~= nil and v164 ~= nil then
                                n5 += p65

                                local v165 = if Magnitude > 1 then 1 - (v163.Position - v164.Position).Magnitude / Magnitude else n5 / MonsterParasite.YankDuration

                                n6 = math.clamp(math.max(n6, v165), 0, 1)

                                local v170 = n5
                                local Value = TweenService:GetValue(math.clamp(v170 / t23.SeizeSeconds, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local Value2 = TweenService:GetValue(n6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local v171 = CFrame.new(v163.Position:Lerp(v164.Position, Value2 * t23.MouthPull) + v160 * (1 - Value)) * Rotation
                                local StartScale, FitScale = v158.StartScale, v158.FitScale
                                local v172 = n6
                                local v173 = math.lerp(StartScale, FitScale, TweenService:GetValue(v172, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
                                local Model = v158.Model

                                Model:ScaleTo(v173)
                                Model:PivotTo(v171 * CFrame.new(-v158.CenterOffset * (v173 / v158.StartScale)))

                                if not p64.IsPlaying then
                                    connection:Disconnect()

                                    local Model = v158.Model
                                    local t28 = {}

                                    t28[1] = 0

                                    local connection2

                                    connection2 = RunService.PreRender:Connect(function(p66) -- line: 1184
                                        -- upvalues: v171 (copy), v173 (copy), Model (copy), t28 (copy), connection2 (ref), p63 (copy), v155 (copy), v158 (copy), v162 (copy), t23 (copy), getAnimatedWorldCFrame (copy), TweenService (copy)
                                        t28[1] = math.min(t28[1] + p66, t23.SwallowSeconds)

                                        local v175 = Model.Parent == nil or p63.Parent == nil

                                        if not v175 then
                                            local v176 = getAnimatedWorldCFrame(v155)
                                            local v177 = if v176 == nil then v171.Position else v176.Position + p63:GetPivot():VectorToWorldSpace(v162) * (t23.SwallowDepth * p63:GetScale())
                                            local Value = TweenService:GetValue(t28[1] / t23.SwallowSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                                            local v178 = CFrame.new(v171.Position:Lerp(v177, Value)) * v171.Rotation
                                            local v181 = math.max(t23.MinScale, (math.lerp(v173, v173 * t23.SwallowScale, Value)))
                                            local Model = v158.Model

                                            Model:ScaleTo(v181)
                                            Model:PivotTo(v178 * CFrame.new(-v158.CenterOffset * (v181 / v158.StartScale)))
                                        end

                                        if not (v175 or t28[1] >= t23.SwallowSeconds) then
                                            return
                                        end

                                        connection2:Disconnect()
                                        Model:Destroy()
                                    end)
                                end
                            end
                        end
                    end)
                else
                    v153:Destroy()
                end
            end
        end

        local function pulseMonsterScale(p67) -- line: 1369
            -- upvalues: runMotion (copy), TweenService (copy)
            local Scale = p67:GetScale()

            runMotion(0.12, function(p68) -- line: 1371
                -- upvalues: p67 (copy), Scale (copy), TweenService (copy)
                if p67.Parent == nil then
                    return true
                end

                local Value = TweenService:GetValue(p68, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                p67:ScaleTo((math.lerp(Scale, Scale * 1.08, Value)))

                return nil
            end)

            if p67.Parent ~= nil then
                runMotion(0.4, function(p69) -- line: 1386
                    -- upvalues: p67 (copy), Scale (copy), TweenService (copy)
                    if p67.Parent == nil then
                        return true
                    end

                    local Value = TweenService:GetValue(p69, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

                    p67:ScaleTo((math.lerp(Scale * 1.08, Scale, Value)))

                    return nil
                end)

                if p67.Parent then
                    p67:ScaleTo(Scale)
                end
            end
        end

        local t29 = {}
        local n7 = 0
        local n8 = 0

        local function wrapAngle(p70) -- line: 1427
            return (p70 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
        end

        local function getMonsterRestCFrame(p71) -- line: 1431
            -- upvalues: t29 (copy)
            local v184 = t29[p71]

            if v184 ~= nil then
                return v184
            end

            local PrimaryPart = p71.PrimaryPart

            if PrimaryPart == nil then
                return nil
            end

            t29[p71] = PrimaryPart.CFrame

            return PrimaryPart.CFrame
        end

        local function applyFacingYaw(p72, p73) -- line: 1446
            -- upvalues: t29 (copy)
            local PrimaryPart = p72.PrimaryPart
            local v185 = t29[p72]

            if v185 == nil then
                local PrimaryPart = p72.PrimaryPart

                if PrimaryPart ~= nil then
                    t29[p72] = PrimaryPart.CFrame
                    v185 = PrimaryPart.CFrame
                else
                    v185 = nil
                end
            end

            if PrimaryPart ~= nil and v185 ~= nil then
                PrimaryPart.CFrame = v185 * CFrame.fromEulerAnglesYXZ(0, p73, 0)
            end
        end

        local function releaseMonsterFacing() -- line: 1477
            -- upvalues: v4 (ref), runMotion (copy), t29 (copy), n7 (ref), n8 (ref), TweenService (copy)
            n8 += 1

            local v186 = n8
            local v187 = n7

            if math.abs(v187) < 0.001 then
                n7 = 0
            else
                runMotion(0.45, function(p74) -- line: 1485
                    -- upvalues: v186 (copy), v187 (copy), v4 (ref), t29 (copy), n7 (ref), n8 (ref), TweenService (copy)
                    if n8 ~= v186 then
                        return true
                    end

                    n7 = v187 * (1 - TweenService:GetValue(p74, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))

                    local v188 = v4

                    if v188 ~= nil and v188.Parent ~= nil then
                        local v189 = n7
                        local PrimaryPart = v188.PrimaryPart
                        local v190 = t29[v188]

                        if v190 == nil then
                            local PrimaryPart = v188.PrimaryPart

                            if PrimaryPart ~= nil then
                                t29[v188] = PrimaryPart.CFrame
                                v190 = PrimaryPart.CFrame
                            else
                                v190 = nil
                            end
                        end

                        if PrimaryPart ~= nil and v190 ~= nil then
                            PrimaryPart.CFrame = v190 * CFrame.fromEulerAnglesYXZ(0, v189, 0)
                        end
                    end

                    return nil
                end)

                if n8 == v186 then
                    n7 = 0

                    local v191 = v4

                    if v191 ~= nil and v191.Parent ~= nil then
                        local PrimaryPart = v191.PrimaryPart
                        local v192 = t29[v191]

                        if v192 == nil then
                            local PrimaryPart = v191.PrimaryPart

                            if PrimaryPart ~= nil then
                                t29[v191] = PrimaryPart.CFrame
                                v192 = PrimaryPart.CFrame
                            else
                                v192 = nil
                            end
                        end

                        if PrimaryPart ~= nil then
                            if v192 == nil then
                                return
                            end

                            PrimaryPart.CFrame = v192 * CFrame.fromEulerAnglesYXZ(0, 0, 0)
                        end
                    end
                end
            end
        end

        local function playYankAnimation(p75) -- line: 1512
            -- upvalues: t3 (copy), v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), playSound (copy), loadAnimationTrack (copy), playAnimationAndWait (copy), getEquippedEggTool (copy), t23 (copy), animateEggYank (copy), animateEggGrab (copy), t29 (copy), n7 (ref), n8 (ref), RunService (copy), MonsterParasite (copy), Trove (copy)
            local PrimaryPart = p75.PrimaryPart

            if PrimaryPart ~= nil then
                local Attribute = p75:GetAttribute(MonsterParasite.MonsterModelIndexAttributeName)

                if typeof(Attribute) ~= "number" then
                    Attribute = nil
                end

                local v193 = if Attribute == nil then nil else MonsterParasite.MonsterAnimationIdsByIndex[Attribute]
                local v194 = if v193 then loadAnimationTrack(p75, v193.Yank) else nil

                if v194 ~= nil then
                    local v195 = Trove.new()

                    v195:Add(v194)
                    v195:Add(function() -- line: 1530
                        -- upvalues: p75 (copy), t3 (copy)
                        if p75.Parent then
                            local v196 = t3[p75]

                            if v196 and p75.Parent and not v196.IsPlaying then
                                v196:Play(0.1)
                            end
                        end
                    end)
                    n8 += 1
                    v195:Connect(RunService.RenderStepped, function(p76) -- line: 1538
                        -- upvalues: p75 (copy), getEquippedEggTool (copy), t29 (copy), n7 (ref)
                        if p75.Parent == nil then
                            return
                        end

                        local v197 = getEquippedEggTool()
                        local Handle = if v197 then v197:FindFirstChild("Handle") else nil

                        if not (Handle and Handle:IsA("BasePart")) then
                            Handle = nil
                        end

                        if Handle == nil then
                            return
                        end

                        local v198 = t29[p75]

                        if v198 == nil then
                            local PrimaryPart = p75.PrimaryPart

                            if PrimaryPart ~= nil then
                                t29[p75] = PrimaryPart.CFrame
                                v198 = PrimaryPart.CFrame
                            else
                                v198 = nil
                            end
                        end

                        if v198 ~= nil then
                            local v199 = Vector3.new(Handle.Position.X, v198.Position.Y, Handle.Position.Z)

                            if not ((v199 - v198.Position).Magnitude <= 0.001) then
                                local _, v200 = v198:ToOrientation()
                                local _, v201 = CFrame.lookAt(v198.Position, v199):ToOrientation()
                                local v202 = (v201 - v200 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                                local v204 = math.min(p76 * 16, 1)

                                n7 += ((v202 - n7 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v204

                                local v206 = n7
                                local PrimaryPart = p75.PrimaryPart
                                local v207 = t29[p75]

                                if v207 == nil then
                                    local PrimaryPart = p75.PrimaryPart

                                    if PrimaryPart ~= nil then
                                        t29[p75] = PrimaryPart.CFrame
                                        v207 = PrimaryPart.CFrame
                                    else
                                        v207 = nil
                                    end
                                end

                                if PrimaryPart ~= nil then
                                    if v207 == nil then
                                        return
                                    end

                                    PrimaryPart.CFrame = v207 * CFrame.fromEulerAnglesYXZ(0, v206, 0)
                                end
                            end
                        end
                    end)

                    local v208 = false

                    local function grabNow() -- line: 1567
                        -- upvalues: p75 (copy), v194 (copy), v208 (ref), animateEggGrab (copy)
                        if not v208 then
                            v208 = true

                            if p75.Parent ~= nil then
                                animateEggGrab(p75, v194)
                            end
                        end
                    end

                    v195:Connect(v194:GetMarkerReachedSignal(MonsterParasite.GrabMarkerName), grabNow)

                    local v209 = t3[p75]

                    if v209 and v209.IsPlaying then
                        v209:Stop(0.1)
                    end

                    playSound(MonsterParasite.YankSoundName, PrimaryPart)
                    v194.Looped = false
                    v194.Priority = Enum.AnimationPriority.Action4
                    playAnimationAndWait(v194, p75, nil)

                    if not v208 then
                        warn((("[MonsterParasite] Yank animation did not reach the %* marker"):format(MonsterParasite.GrabMarkerName)))

                        if not v208 then
                            v208 = true

                            if p75.Parent ~= nil then
                                animateEggGrab(p75, v194)
                            end
                        end
                    end

                    v195:Destroy()
                else
                    playSound(MonsterParasite.YankSoundName, PrimaryPart)
                    animateEggYank(p75)
                end
            else
                local connection2 = connection

                connection = nil

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                local result2 = result

                result = nil

                if result2 ~= nil then
                    result2:Stop(t23.HandPoseReleaseSeconds)
                    task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                        -- upvalues: result2 (copy)
                        result2:Destroy()
                    end)
                end

                if v12 ~= nil then
                    v12:Destroy()
                    v12 = nil
                end

                v14 = nil
                v13 = nil
            end
        end

        local function emitEnergyBurst(p77, p78) -- line: 1599
            -- upvalues: resolveVfxTemplate (copy), Emit (copy), MonsterParasite (copy)
            local v210 = resolveVfxTemplate(MonsterParasite.EnergyBurstVfxName)

            if v210 == nil then
                return
            end

            local clone = v210:Clone()

            clone.Parent = p77
            p78:Add(clone)
            Emit(clone)
        end

        local function animateMonsterRoar(p79, p80) -- line: 1610
            -- upvalues: RunService (copy), MonsterParasite (copy)
            local Pivot = p79:GetPivot()
            local n9 = 0
            local connection

            connection = RunService.PreRender:Connect(function(p81) -- line: 1614
                -- upvalues: p79 (copy), Pivot (copy), n9 (ref), connection (ref), MonsterParasite (copy)
                if p79.Parent ~= nil then
                    n9 = math.min(n9 + p81, MonsterParasite.RoarDuration)

                    local v212 = n9 / MonsterParasite.RoarDuration
                    local v215 = math.sin(v212 * 3.141592653589793)
                    local v217 = math.sin(v212 * 3.141592653589793 * 3) * 0.15707963267948966 * v215
                    local v219 = math.sin(v212 * 3.141592653589793) * 0.4

                    p79:PivotTo(Pivot * CFrame.new(0, v219, 0) * CFrame.Angles(v217, 0, v217 * -0.35))

                    if v212 >= 1 then
                        p79:PivotTo(Pivot)
                        connection:Disconnect()
                    end
                else
                    connection:Disconnect()
                end
            end)
            p80:Add(connection)
        end

        local function upAlignedCFrame(p82, p83) -- line: 1641
            local v220 = if p83.Magnitude > 0.001 then p83.Unit else Vector3.new(0, 1, 0)
            local v221 = (if math.abs(v220.Y) > 0.99 then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0)):Cross(v220)
            local v222 = if v221.Magnitude > 0.001 then v221.Unit else Vector3.new(1, 0, 0)
            local Unit = v220:Cross(v222).Unit

            return CFrame.fromMatrix(p82, v222, v220, -Unit)
        end

        local function resolveImpactParticles() -- line: 1655
            -- upvalues: ReplicatedStorage (copy), MonsterParasite (copy)
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local Particles = if Assets then Assets:FindFirstChild("Particles") else nil
            local v223 = if Particles then Particles:FindFirstChild(MonsterParasite.GroundHitParticlesName) else nil

            return if v223 ~= nil and (v223:IsA("ParticleEmitter") or v223:FindFirstChildWhichIsA("ParticleEmitter", true) ~= nil) then v223 else nil
        end

        local function emitGroundHit(p84) -- line: 1669
            -- upvalues: resolveImpactParticles (copy), Debris (copy), Workspace (copy), PlayVFX (copy)
            local v224 = resolveImpactParticles()

            if v224 == nil then
                return
            end

            local Part = Instance.new("Part")

            Part.Name = "MonsterChestGroundHit"
            Part.Size = Vector3.new(1, 1, 1)
            Part.CFrame = p84
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 1

            local Transient = Workspace:FindFirstChild("Transient")

            Part.Parent = if not (Transient and Transient:IsA("Folder")) then Workspace else Transient

            local clone = v224:Clone()

            if not pcall(PlayVFX, Part, p84, clone) then
                clone:Destroy()
            end

            Debris:AddItem(Part, 3)
        end

        local function shakeCamera(p85, p86) -- line: 1697
            -- upvalues: v15 (copy), Workspace (copy), MonsterParasite (copy)
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera == nil then
                return
            end

            local ChestImpactShakeRange = MonsterParasite.ChestImpactShakeRange
            local Magnitude = (CurrentCamera.CFrame.Position - p85).Magnitude

            if not (ChestImpactShakeRange <= Magnitude) then
                v15:ShakeOnce(p86 * (1 - Magnitude / ChestImpactShakeRange), MonsterParasite.ChestImpactShakeRoughness, MonsterParasite.ChestImpactShakeFadeIn, MonsterParasite.ChestImpactShakeFadeOut)
            end
        end

        local function animateChestLaunch(p87, p88) -- line: 1715
            -- upvalues: clone (ref), v15 (copy), runMotion (copy), playSound (copy), getAnimatedWorldCFrame (copy), resolveGroundLanding (copy), createChest (copy), upAlignedCFrame (copy), emitGroundHit (copy), TweenService (copy), Workspace (copy), MonsterParasite (copy)
            local PrimaryPart = p87.PrimaryPart

            assert(PrimaryPart ~= nil, "Monster model requires a PrimaryPart")

            local v226 = getAnimatedWorldCFrame(p88) or PrimaryPart.CFrame
            local v227 = createChest(v226)

            if v227 == nil then
                return
            end

            local Scale = v227:GetScale()
            local v228 = Scale * MonsterParasite.ChestLaunchStartScale
            local v229, v230 = resolveGroundLanding(p87, v226)
            local Position = v229.Position

            v227:PivotTo(v229)

            local BoundingBox, BoundingBox2 = v227:GetBoundingBox()
            local v231 = v229 + Vector3.new(0, 1, 0) * (Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y * 0.5))

            v227:PivotTo(v226)
            v227:ScaleTo(v228)

            local Position2 = v226.Position
            local Position3 = v231.Position
            local v232 = (Position3 - Position2) * Vector3.new(1, 0, 1)
            local v233

            if v232.Magnitude > 0.001 then
                v233 = v232.Unit
            else
                local v234 = p87:GetPivot().LookVector * Vector3.new(1, 0, 1)

                if v234.Magnitude < 0.05 then
                    v234 = v226.LookVector * Vector3.new(1, 0, 1)
                end

                v233 = if v234.Magnitude > 0.001 then v234.Unit else Vector3.new(0, 0, -1)
            end

            local v235 = math.max(Position2.Y, Position3.Y) + MonsterParasite.ChestLaunchHeight
            local v236 = v232.Magnitude * 0.55
            local v240 = Vector3.new(Position2.X + v233.X * v236, v235 * 2 - (Position2.Y + Position3.Y) * 0.5, Position2.Z + v233.Z * v236)

            local function curve(p89) -- line: 1757
                -- upvalues: Position2 (copy), Position3 (copy), v240 (copy)
                return Position2:Lerp(v240, p89):Lerp(v240:Lerp(Position3, p89), p89)
            end

            local v241 = (Vector3.new(0, 1, 0)):Cross(v233)
            local v242 = if v241.Magnitude > 0.001 then v241.Unit else Vector3.new(1, 0, 0)
            local v243 = MonsterParasite.ChestLaunchSpins * 3.141592653589793 * 2
            local Rotation = v226.Rotation
            local Rotation2 = v231.Rotation

            runMotion(MonsterParasite.ChestLaunchDuration, function(p90) -- line: 1771
                -- upvalues: v227 (copy), Scale (copy), v228 (copy), curve (copy), v242 (copy), v243 (copy), Rotation (copy), Rotation2 (copy), TweenService (copy)
                if v227.Parent == nil then
                    return true
                end

                local Value = TweenService:GetValue(p90, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                v227:PivotTo(CFrame.new(curve(p90)) * CFrame.fromAxisAngle(v242, v243 * Value) * Rotation:Lerp(Rotation2, Value))
                v227:ScaleTo((math.lerp(v228, Scale, p90)))

                return nil
            end)

            if v227.Parent == nil then
                return
            end

            v227:ScaleTo(Scale)
            v227:PivotTo(v231)

            local v244 = v227.PrimaryPart or PrimaryPart

            playSound(MonsterParasite.ChestLandingSoundName, v244)
            emitGroundHit(upAlignedCFrame(Position, v230))

            local ChestImpactShakeMagnitude = MonsterParasite.ChestImpactShakeMagnitude
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                local ChestImpactShakeRange = MonsterParasite.ChestImpactShakeRange
                local Magnitude = (CurrentCamera.CFrame.Position - Position).Magnitude

                if not (ChestImpactShakeRange <= Magnitude) then
                    v15:ShakeOnce(ChestImpactShakeMagnitude * (1 - Magnitude / ChestImpactShakeRange), MonsterParasite.ChestImpactShakeRoughness, MonsterParasite.ChestImpactShakeFadeIn, MonsterParasite.ChestImpactShakeFadeOut)
                end
            end

            runMotion(MonsterParasite.ChestBounceDuration, function(p91) -- line: 1804
                -- upvalues: v227 (copy), Position3 (copy), Rotation2 (copy), clone (ref), MonsterParasite (copy)
                if clone ~= v227 then
                    return true
                end

                local v245 = 1 - p91
                local v247 = math.sin(p91 * 3.141592653589793) * v245 * MonsterParasite.ChestBounceHeight
                local v249 = math.sin(p91 * 3.141592653589793 * 4) * v245 * 0.20943951023931956

                v227:PivotTo(CFrame.new(Position3 + Vector3.new(0, 1, 0) * v247) * Rotation2 * CFrame.Angles(0, 0, v249))

                return nil
            end)

            if v227.Parent then
                v227:PivotTo(v231)
            end

            task.wait(MonsterParasite.ChestGroundRestDuration)
        end

        local function arcApex(p92, p93) -- line: 1834
            -- upvalues: MonsterParasite (copy)
            local v251 = math.clamp((p93 - p92).Magnitude * 0.6, 2, 36) + MonsterParasite.ChestPickupRise

            return p92:Lerp(p93, 0.5) + Vector3.new(0, 1, 0) * v251
        end

        local function animateChestPickup(p94) -- line: 1840
            -- upvalues: Fader (copy), LocalPlayer (copy), runMotion (copy), t23 (copy), TweenService (copy), MonsterParasite (copy)
            local Character = LocalPlayer.Character
            local PrimaryPart = if Character then Character.PrimaryPart else nil

            if PrimaryPart == nil then
                return
            end

            local Pivot = p94:GetPivot()
            local PivotPosition = Pivot.Position
            local Scale = p94:GetScale()
            local v252 = Fader()
            local v254 = math.max(t23.PickupFadeEnd - t23.PickupFadeStart, 0.001)

            runMotion(MonsterParasite.ChestPickupDuration, function(p95) -- line: 1853
                -- upvalues: p94 (copy), PrimaryPart (copy), Pivot (copy), PivotPosition (copy), Scale (copy), v252 (copy), v254 (copy), t23 (copy), TweenService (copy), MonsterParasite (copy)
                if p94.Parent == nil then
                    return true
                end

                local v255 = PrimaryPart.Position + Vector3.new(0, 1, 0) * t23.PickupTargetHeight
                local v257 = math.clamp((v255 - PivotPosition).Magnitude * 0.6, 2, 36) + MonsterParasite.ChestPickupRise
                local v258 = PivotPosition:Lerp(v255, 0.5) + Vector3.new(0, 1, 0) * v257
                local Value = TweenService:GetValue(p95, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local v259 = PivotPosition:Lerp(v258, Value):Lerp(v258:Lerp(v255, Value), Value)
                local v260 = Vector3.new(v255.X, v259.Y, v255.Z)

                p94:PivotTo(if (v259 - v260).Magnitude < 0.001 then CFrame.new(v259) * Pivot.Rotation else CFrame.lookAt(v259, v260))

                local Value2 = TweenService:GetValue(math.clamp((p95 - t23.PickupFadeStart) / v254, 0, 1), Enum.EasingStyle.Exponential, Enum.EasingDirection.In)

                v252:Hide(p94, Value2)
                p94:ScaleTo((math.max(t23.PickupMinScale, Scale * (1 - Value2))))

                return nil
            end)
        end

        local function playBurpAnimation(p96, p97, p98) -- line: 1894
            -- upvalues: t3 (copy), playSound (copy), loadAnimationTrack (copy), playAnimationAndWait (copy), MonsterParasite (copy), Timer (copy), Trove (copy)
            local Attribute = p96:GetAttribute(MonsterParasite.MonsterModelIndexAttributeName)

            if typeof(Attribute) ~= "number" then
                Attribute = nil
            end

            local v264 = if Attribute == nil then nil else MonsterParasite.MonsterAnimationIdsByIndex[Attribute]
            local Burp = if v264 then v264.Burp else nil
            local v265 = if Burp then loadAnimationTrack(p96, Burp) else nil
            local v266 = false

            local function beatNow() -- line: 1905
                -- upvalues: p97 (copy), p98 (copy), v266 (ref), playSound (copy), MonsterParasite (copy)
                if v266 then
                    return
                end

                v266 = true
                playSound(MonsterParasite.BurpSoundName, p97)
                p98()
            end

            if v265 ~= nil then
                local v267 = Trove.new()

                v267:Add(v265)
                v267:Add(function() -- line: 1921
                    -- upvalues: p96 (copy), t3 (copy)
                    if p96.Parent then
                        local v268 = t3[p96]

                        if v268 and p96.Parent and not v268.IsPlaying then
                            v268:Play(0.1)
                        end
                    end
                end)
                v267:Connect(v265:GetMarkerReachedSignal(MonsterParasite.BurpMarkerName), beatNow)

                local v269 = t3[p96]

                if v269 and v269.IsPlaying then
                    v269:Stop(0.1)
                end

                v265.Looped = false
                v265.Priority = Enum.AnimationPriority.Action3
                playAnimationAndWait(v265, p96, function() -- line: 1939
                    -- upvalues: p97 (copy), p98 (copy), v266 (ref), v265 (copy), v267 (copy), playSound (copy), MonsterParasite (copy), Timer (copy)
                    local ChestLaunchBeatFallback = MonsterParasite.ChestLaunchBeatFallback

                    if v265.Length > 0 then
                        ChestLaunchBeatFallback = math.min(ChestLaunchBeatFallback, (math.max(v265.Length - 0.1, 0.05)))
                    end

                    v267:Add(Timer.Simple(ChestLaunchBeatFallback, function() -- line: 1946
                        -- upvalues: p97 (copy), p98 (copy), v266 (ref), playSound (copy), MonsterParasite (copy)
                        if v266 then
                            return
                        end

                        warn((("[MonsterParasite] Burp animation did not reach the %* marker"):format(MonsterParasite.BurpMarkerName)))

                        if not v266 then
                            v266 = true
                            playSound(MonsterParasite.BurpSoundName, p97)
                            p98()
                        end
                    end))
                end)

                if not v266 then
                    v266 = true
                    playSound(MonsterParasite.BurpSoundName, p97)
                    p98()
                end

                v267:Destroy()
            else
                if not v266 then
                    v266 = true
                    playSound(MonsterParasite.BurpSoundName, p97)
                    p98()
                end

                task.wait(MonsterParasite.BurpBeatDuration)
            end
        end

        local function animateFullCharge(p99) -- line: 1961
            -- upvalues: v5 (ref), playSound (copy), resolveVfxTemplate (copy), resolveChestOrigin (copy), animateChestLaunch (copy), playBurpAnimation (copy), RunService (copy), Emit (copy), MonsterParasite (copy), Trove (copy)
            local PrimaryPart = p99.PrimaryPart

            if PrimaryPart == nil then
                return false
            end

            local v272 = resolveChestOrigin(p99) or PrimaryPart
            local v273 = Trove.new()

            v5 = p99
            v273:Add(function() -- line: 1969
                -- upvalues: p99 (copy), v5 (ref)
                if v5 == p99 then
                    v5 = nil
                end
            end)

            local v274
            local v275 = false

            local function onBurpBeat() -- line: 1976
                -- upvalues: p99 (copy), PrimaryPart (copy), v272 (copy), v273 (copy), v274 (ref), v275 (ref), playSound (copy), resolveVfxTemplate (copy), animateChestLaunch (copy), RunService (copy), Emit (copy), MonsterParasite (copy)
                v274 = task.spawn(function() -- line: 1981
                    -- upvalues: p99 (copy), v272 (copy), v275 (ref), animateChestLaunch (copy), MonsterParasite (copy)
                    if MonsterParasite.ChestLaunchDelay > 0 then
                        task.wait(MonsterParasite.ChestLaunchDelay)
                    end

                    local ok, result = pcall(animateChestLaunch, p99, v272)

                    v275 = true

                    if not ok then
                        warn((("[MonsterParasite] Chest launch failed: %*"):format(result)))
                    end
                end)

                local function v276() -- line: 1991
                    -- upvalues: p99 (copy), PrimaryPart (copy), v272 (copy), v273 (copy), playSound (copy), resolveVfxTemplate (copy), RunService (copy), Emit (copy), MonsterParasite (copy)
                    playSound(MonsterParasite.RoarSoundName, PrimaryPart)
                    playSound(MonsterParasite.EnergyBurstSoundName, v272)

                    local v277 = resolveVfxTemplate(MonsterParasite.EnergyBurstVfxName)

                    if v277 ~= nil then
                        local clone = v277:Clone()

                        clone.Parent = v272
                        v273:Add(clone)
                        Emit(clone)
                    end

                    local Pivot = p99:GetPivot()
                    local n10 = 0
                    local connection

                    connection = RunService.PreRender:Connect(function(p100) -- line: 1614
                        -- upvalues: Pivot (copy), n10 (ref), connection (ref), p99 (copy), MonsterParasite (copy)
                        if p99.Parent ~= nil then
                            n10 = math.min(n10 + p100, MonsterParasite.RoarDuration)

                            local v279 = n10 / MonsterParasite.RoarDuration
                            local v282 = math.sin(v279 * 3.141592653589793)
                            local v284 = math.sin(v279 * 3.141592653589793 * 3) * 0.15707963267948966 * v282
                            local v286 = math.sin(v279 * 3.141592653589793) * 0.4

                            p99:PivotTo(Pivot * CFrame.new(0, v286, 0) * CFrame.Angles(v284, 0, v284 * -0.35))

                            if v279 >= 1 then
                                p99:PivotTo(Pivot)
                                connection:Disconnect()
                            end
                        else
                            connection:Disconnect()
                        end
                    end)
                    v273:Add(connection)
                end

                local ok, result = pcall(v276)

                if not ok then
                    warn((("[MonsterParasite] Full charge dressing failed: %*"):format(result)))
                end
            end

            playBurpAnimation(p99, v272, onBurpBeat)

            while v274 ~= nil and not v275 do
                if coroutine.status(v274) == "dead" then
                    break
                end

                task.wait()
            end

            v273:Destroy()

            return v275
        end

        local function setPromptEnabled(p101, p102) -- line: 2024
            if p101 and p101.Enabled ~= p102 then
                p101.Enabled = p102
            end
        end

        local function isHoldingParasiteEgg() -- line: 2030
            -- upvalues: LocalPlayer (copy), EggToolDisplay (copy), Save (copy)
            local Character = LocalPlayer.Character
            local v287 = Save.Await()

            if Character ~= nil and v287 ~= nil then
                for _, child in Character:GetChildren() do
                    if child:IsA("Tool") and EggToolDisplay.IsEggTool(child) then
                        local v288 = EggToolDisplay.GetToolUid(child)
                        local v289 = if v288 then v287.EggInventory[v288] else nil

                        if v289 ~= nil and v289.HasParasite == true then
                            return true
                        end
                    end
                end
            end

            return false
        end

        local function refreshPrompts() -- line: 2048
            -- upvalues: v4 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), n1 (ref), isHoldingParasiteEgg (copy), MonsterParasite (copy), MonsterParasite2 (copy)
            local TalkPromptName = MonsterParasite.TalkPromptName
            local v290 = v4
            local v291

            if v290 ~= nil then
                v291 = v290:FindFirstChild(TalkPromptName, true)

                if not (v291 and v291:IsA("ProximityPrompt")) then
                    v291 = nil
                end
            end

            local FeedPromptName = MonsterParasite.FeedPromptName
            local v292 = v4
            local v293

            if v292 ~= nil then
                v293 = v292:FindFirstChild(FeedPromptName, true)

                if not (v293 and v293:IsA("ProximityPrompt")) then
                    v293 = nil
                end
            end

            local ChestPromptName = MonsterParasite.ChestPromptName
            local v294 = v4
            local v295

            if v294 ~= nil then
                v295 = v294:FindFirstChild(ChestPromptName, true)

                if not (v295 and v295:IsA("ProximityPrompt")) then
                    v295 = nil
                end
            end

            local ViewRewardsPromptName = MonsterParasite2.ViewRewardsPromptName
            local v296 = v4
            local v297

            if v296 ~= nil then
                v297 = v296:FindFirstChild(ViewRewardsPromptName, true)

                if not (v297 and v297:IsA("ProximityPrompt")) then
                    v297 = nil
                end
            end

            local v298 = v10 or v8 or v9 or v11 or n1 > 0
            local v299 = v7 and not v298 and isHoldingParasiteEgg()
            local v300 = not v299 and not v298

            if v293 and v293.Enabled ~= v299 then
                v293.Enabled = v299
            end

            if v295 and v295.Enabled ~= false then
                v295.Enabled = false
            end

            if v291 and v291.Enabled ~= v300 then
                v291.Enabled = v300
            end

            local v301 = not v298

            if v297 and v297.Enabled ~= v301 then
                v297.Enabled = v301
            end
        end

        local function applyState(p103) -- line: 2083
            -- upvalues: v4 (ref), clone (ref), v6 (ref), v10 (ref), v11 (ref), n1 (ref), n2 (ref), refreshPrompts (copy), MonsterParasite (copy)
            local v302 = p103.PendingChests > v6.PendingChests and p103.Charge < v6.Charge and v6.Charge + MonsterParasite.ChargePerFeed >= MonsterParasite.MaxCharge

            v6 = table.clone(p103)

            if v4 then
                local v303 = v4

                v303:SetAttribute("Charge", p103.Charge)

                local v304 = v4

                v304:SetAttribute("PendingChests", p103.PendingChests)
            end

            if v302 then
                n1 += 1
                n2 += 1
                refreshPrompts()
            elseif not v10 and n1 <= 0 and not v11 then
                if v6.PendingChests <= 0 and n1 <= 0 and clone then
                    clone:Destroy()
                    clone = nil
                end

                refreshPrompts()
            end
        end

        local function showError(p104) -- line: 2105
            -- upvalues: Message (copy)
            task.spawn(Message.Warn, p104)
        end

        local function acknowledgeChest(p105) -- line: 2109
            -- upvalues: MonsterParasite3 (copy), MonsterParasite2 (copy)
            local v305

            for i = 1, 3 do
                local function v306() -- line: 2112
                    -- upvalues: p105 (copy), MonsterParasite3 (copy)
                    return MonsterParasite3.AskChestRevealComplete:InvokeServer(p105)
                end

                local ok, result = pcall(v306)
                local v307

                if ok then
                    if MonsterParasite2.RevealResultSchema(result) then
                        if result.Success then
                            return true, nil
                        else
                            v307 = result.Message
                        end
                    else
                        v307 = "The reward confirmation was invalid."
                    end
                else
                    v307 = tostring(result)
                end

                v305 = v307

                if i < 3 then
                    task.wait(0.4)
                end
            end

            return false, v305
        end

        local function beginChestReveal(p106) -- line: 2133
            -- upvalues: LocalPlayer (copy), v4 (ref), clone (ref), v6 (ref), v11 (ref), OpeningId (ref), OpeningId2 (ref), n1 (ref), playSound (copy), refreshPrompts (copy), acknowledgeChest (copy), CrateOpeningSpinner (copy), Message (copy), MonsterParasite (copy)
            local OpeningId3 = p106.OpeningId

            if OpeningId3 == nil or p106.Reward == nil then
                v11 = false

                if v6.PendingChests <= 0 and n1 <= 0 and clone then
                    clone:Destroy()
                    clone = nil
                end

                refreshPrompts()
                task.spawn(Message.Warn, "The Monster Chest reward was invalid.")
            elseif OpeningId ~= OpeningId3 and OpeningId2 ~= OpeningId3 and OpeningId == nil then
                OpeningId = OpeningId3
                v11 = true
                refreshPrompts()

                local Character = LocalPlayer.Character
                local PrimaryPart = if Character then Character.PrimaryPart else nil
                local clone2 = clone
                local v308 = v4

                if clone2 and clone2.PrimaryPart then
                    PrimaryPart = clone2.PrimaryPart
                elseif not PrimaryPart then
                    PrimaryPart = if v308 then v308.PrimaryPart else nil
                end

                if PrimaryPart then
                    playSound(MonsterParasite.ChestSoundName, PrimaryPart)
                end

                if clone then
                    clone:Destroy()
                    clone = nil
                end

                task.spawn(function() -- line: 2166
                    -- upvalues: p106 (copy), OpeningId3 (copy), clone (ref), v6 (ref), v11 (ref), OpeningId (ref), OpeningId2 (ref), n1 (ref), refreshPrompts (copy), acknowledgeChest (copy), CrateOpeningSpinner (copy), Message (copy)
                    local Play = CrateOpeningSpinner.Play
                    local ok, result = pcall(Play, p106)

                    if not ok then
                        warn((("[MonsterParasite] Crate opening presentation failed: %*"):format(result)))
                    end

                    local v309, v310 = acknowledgeChest(OpeningId3)

                    if not v309 then
                        local v311 = v310 or "The Monster Chest reveal is still finishing."

                        task.spawn(Message.Warn, v311)
                    end

                    OpeningId2 = OpeningId3
                    OpeningId = nil
                    v11 = false
                    v6.PendingChests = p106.PendingChests or 0
                    refreshPrompts()

                    if v6.PendingChests <= 0 and n1 <= 0 and clone then
                        clone:Destroy()
                        clone = nil
                    end

                    refreshPrompts()
                end)
            end
        end

        local function requestFeed() -- line: 2192
            -- upvalues: MonsterParasite3 (copy), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), OpeningId (ref), n1 (ref), v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), t23 (copy), captureEquippedEgg (copy), refreshPrompts (copy), Message (copy), MonsterParasite2 (copy)
            if not v7 then
                task.spawn(Message.Warn, "The Monster Parasite event is not active.")

                return
            end

            if not v8 and not v10 and not v9 and not (n1 > 0) and not v11 and OpeningId == nil then
                v8 = true
                refreshPrompts()
                captureEquippedEgg()
                task.spawn(function() -- line: 2213
                    -- upvalues: MonsterParasite3 (copy), v8 (ref), v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), t23 (copy), refreshPrompts (copy), Message (copy), MonsterParasite2 (copy)
                    local function v313() -- line: 2214
                        -- upvalues: MonsterParasite3 (copy)
                        return MonsterParasite3.AskFeed:InvokeServer()
                    end

                    local ok, result2 = pcall(v313)

                    if ok and MonsterParasite2.FeedResultSchema(result2) then
                        if not result2.Success then
                            v8 = false
                            refreshPrompts()

                            local connection2 = connection

                            connection = nil

                            if connection2 ~= nil then
                                connection2:Disconnect()
                            end

                            local result3 = result

                            result = nil

                            if result3 ~= nil then
                                result3:Stop(t23.HandPoseReleaseSeconds)
                                task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                                    -- upvalues: result3 (copy)
                                    result3:Destroy()
                                end)
                            end

                            if v12 ~= nil then
                                v12:Destroy()
                                v12 = nil
                            end

                            v14 = nil
                            v13 = nil

                            local Message2 = result2.Message

                            task.spawn(Message.Warn, Message2)
                        end
                    else
                        v8 = false
                        refreshPrompts()

                        local connection2 = connection

                        connection = nil

                        if connection2 ~= nil then
                            connection2:Disconnect()
                        end

                        local result3 = result

                        result = nil

                        if result3 ~= nil then
                            result3:Stop(t23.HandPoseReleaseSeconds)
                            task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                                -- upvalues: result3 (copy)
                                result3:Destroy()
                            end)
                        end

                        if v12 ~= nil then
                            v12:Destroy()
                            v12 = nil
                        end

                        v14 = nil
                        v13 = nil

                        local v314 = if ok then "The monster did not understand that request." else tostring(result2)

                        task.spawn(Message.Warn, v314)
                    end
                end)
            end
        end

        local function requestChest() -- line: 2238
            -- upvalues: MonsterParasite3 (copy), clone (ref), v6 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), OpeningId (ref), OpeningId2 (ref), n1 (ref), refreshPrompts (copy), beginChestReveal (copy), HttpService (copy), Message (copy), MonsterParasite2 (copy)
            if v9
                or v8
                or v10
                or n1 > 0
                or v11
                or OpeningId ~= nil then
                return
            end

            v9 = true
            v11 = true
            refreshPrompts()

            local v315 = HttpService:GenerateGUID(false)

            task.spawn(function() -- line: 2253
                -- upvalues: v315 (copy), MonsterParasite3 (copy), clone (ref), v6 (ref), v9 (ref), v11 (ref), OpeningId (ref), OpeningId2 (ref), n1 (ref), refreshPrompts (copy), beginChestReveal (copy), Message (copy), MonsterParasite2 (copy)
                local result, v316

                for i = 1, 3 do
                    local function v317() -- line: 2257
                        -- upvalues: v315 (copy), MonsterParasite3 (copy)
                        return MonsterParasite3.AskChestClaim:InvokeServer(v315)
                    end

                    local ok, result2 = pcall(v317)

                    if ok and MonsterParasite2.ChestResultSchema(result2) then
                        if result2.Success then
                            result = result2
                            break
                        end

                        if result2.Message ~= "Another Monster Parasite action is still finishing." then
                            result = result2
                            break
                        end

                        result = result2
                    else
                        v316 = if ok then "The Monster Chest could not be opened." else tostring(result2)
                    end

                    if OpeningId == v315 or OpeningId2 == v315 then
                        break
                    end

                    if i < 3 then
                        task.wait(0.4)
                    end
                end

                v9 = false
                refreshPrompts()

                if OpeningId ~= v315 and OpeningId2 ~= v315 then
                    if result ~= nil then
                        if result.Success then
                            beginChestReveal(result)
                        elseif OpeningId == nil then
                            v11 = false

                            if v6.PendingChests <= 0 and n1 <= 0 and clone then
                                clone:Destroy()
                                clone = nil
                            end

                            refreshPrompts()

                            local Message2 = result.Message

                            task.spawn(Message.Warn, Message2)
                        end
                    else
                        v11 = false

                        if v6.PendingChests <= 0 and n1 <= 0 and clone then
                            clone:Destroy()
                            clone = nil
                        end

                        refreshPrompts()

                        local v318 = v316 or "The Monster Chest could not be opened."

                        task.spawn(Message.Warn, v318)
                    end
                end
            end)
        end

        local function requestTakeChest() -- line: 2312
            -- upvalues: MonsterParasite3 (copy), clone (ref), Message (copy), MonsterParasite2 (copy)
            local function v319() -- line: 2313
                -- upvalues: MonsterParasite3 (copy)
                return MonsterParasite3.AskChestTake:InvokeServer()
            end

            local ok, result = pcall(v319)

            if not (ok and MonsterParasite2.TakeResultSchema(result)) then
                local v320 = if ok then "The Monster Chest could not be picked up." else tostring(result)

                task.spawn(Message.Warn, v320)
            elseif result.Success then
                if clone then
                    clone:Destroy()
                    clone = nil
                end
            else
                local Message2 = result.Message

                task.spawn(Message.Warn, Message2)
            end
        end

        local function isChestTool(p107) -- line: 2340
            -- upvalues: MonsterParasite (copy)
            return p107:GetAttribute("ItemType") == MonsterParasite.ChestToolItemType
        end

        local function bindChestTool(p108) -- line: 2344
            -- upvalues: v3 (copy), requestChest (copy)
            v3:Connect(p108.Activated, requestChest)
        end

        local t30 = {
            Accessor = "MonsterChestRewards",
            PlateDim = 0.36,
            PanelAspect = 1.18,
            MaxRowAspect = 6,
            MinRowHeight = 30,
            RowGapFraction = 0.09,
            PadXFraction = 0.012,
            PadYFraction = 0.012,
            RowPadFraction = 0.11,
            SlotGapFraction = 0.3,
            PillHeightFraction = 0.52,
            PillPadFraction = 0.34,
            GlowScale = 1.15,
            IconScale = 0.76,
            NameTextCap = 0.44,
            ChanceTextCap = 0.34,
            NoteTextCap = 0.28,
            PillCharWidth = 0.62,
            NoteCharWidth = 0.62,
            FlowSeconds = 6,
            RainbowHueSpan = 0.3,
            Motion = nil,
            Sizing = nil,
            RarityGradients = {
                ["BEST REWARD"] = "Prismatic"
            },
            ScrollerSize = Vector2.new(0.972, 0.862),
            ScrollerCenter = Vector2.new(0.5, 0.5465),
            Cards = {},
            Flowing = {}
        }

        local function dimColor(p109, p110) -- line: 2433
            return Color3.new(p109.R * p110, p109.G * p110, p109.B * p110)
        end

        local function sampleStops(p111, p112) -- line: 2439
            for i = 1, #p111 - 1 do
                local v321 = p111[i]
                local v322 = p111[i + 1]

                if v321.Time <= p112 and p112 <= v322.Time then
                    local v323 = v322.Time - v321.Time

                    return v321.Value:Lerp(v322.Value, if v323 <= 0 then 0 else (p112 - v321.Time) / v323)
                end
            end

            return p111[#p111].Value
        end

        local function rolledPalette(p113, p114) -- line: 2454
            -- upvalues: sampleStops (copy)
            local v324 = sampleStops(p113, -p114 % 1)
            local t31 = { ColorSequenceKeypoint.new(0, v324) }

            for i = 1, #p113 - 1 do
                local v325 = (p113[i].Time + p114) % 1

                if v325 > 0 and v325 < 1 then
                    table.insert(t31, ColorSequenceKeypoint.new(v325, p113[i].Value))
                end
            end

            table.sort(t31, function(p115, p116) -- line: 2465
                return p115.Time < p116.Time
            end)
            table.insert(t31, ColorSequenceKeypoint.new(1, v324))

            return ColorSequence.new(t31)
        end

        local function isRainbow(p117) -- line: 2475
            -- upvalues: t30 (copy)
            local Keypoints = p117.Color.Keypoints
            local Value = Keypoints[1].Value
            local Value2 = Keypoints[#Keypoints].Value

            if math.abs(Value.R - Value2.R) + math.abs(Value.G - Value2.G) + math.abs(Value.B - Value2.B) > 0.02 then
                return false
            end

            local n11 = 1
            local n12 = 0

            for _, v331 in Keypoints do
                local v332 = Color3.toHSV(v331.Value)

                n11 = math.min(n11, v332)
                n12 = math.max(n12, v332)
            end

            return n12 - n11 >= t30.RainbowHueSpan
        end

        local function paintRewardCard(p118, p119) -- line: 2494
            -- upvalues: t30 (copy), dimColor (copy), isRainbow (copy)
            local Keypoints = p119.Color.Keypoints
            local v333 = table.create(#Keypoints)

            for v334, v335 in Keypoints do
                v333[v334] = ColorSequenceKeypoint.new(v335.Time, dimColor(v335.Value, t30.PlateDim))
            end

            local UIGradient = p118:FindFirstChildOfClass("UIGradient")

            if UIGradient ~= nil then
                UIGradient.Color = ColorSequence.new(v333)
                UIGradient.Rotation = isRainbow(p119) and 0 or 90
            end

            local Value = Keypoints[1].Value

            p118.UIStrokeClr.Color = Value
            p118.Glow.ImageColor3 = Value

            if UIGradient ~= nil and isRainbow(p119) then
                table.insert(t30.Flowing, {
                    Plate = UIGradient,
                    Rim = p118.UIStrokeClr,
                    Glow = p118.Glow,
                    Dimmed = v333,
                    Bright = Keypoints
                })
            end
        end

        local function startRewardFlow(p120) -- line: 2530
            -- upvalues: t30 (copy), sampleStops (copy), rolledPalette (copy), RunService (copy)
            if t30.Motion ~= nil then
                t30.Motion:Disconnect()
                t30.Motion = nil
            end

            if #t30.Flowing ~= 0 then
                t30.Motion = RunService.RenderStepped:Connect(function() -- line: 2539
                    -- upvalues: p120 (copy), t30 (copy), sampleStops (copy), rolledPalette (copy)
                    if p120.Enabled then
                        local v336 = os.clock() % t30.FlowSeconds / t30.FlowSeconds

                        for _, v337 in t30.Flowing do
                            v337.Plate.Color = rolledPalette(v337.Dimmed, v336)

                            local v338 = sampleStops(v337.Bright, -v336 % 1)

                            v337.Rim.Color = v338
                            v337.Glow.ImageColor3 = v338
                        end
                    elseif t30.Motion ~= nil then
                        t30.Motion:Disconnect()
                        t30.Motion = nil
                    end
                end)
            end
        end

        local function buildRewardRow(p121) -- line: 2563
            local Frame = Instance.new("Frame")

            Frame.Name = "Slot"
            Frame.AnchorPoint = Vector2.new(0, 0.5)
            Frame.BackgroundColor3 = Color3.new(0, 0, 0)
            Frame.BackgroundTransparency = 0.55
            Frame.ZIndex = 2
            Frame.Parent = p121

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.16, 0)
            UICorner.Parent = Frame

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = Color3.fromHex("#131624")
            UIStroke.Thickness = 2
            UIStroke.Parent = Frame
            p121.Glow.AnchorPoint = Vector2.new(0.5, 0.5)
            p121.Glow.Position = UDim2.fromScale(0.5, 0.5)
            p121.Glow.ZIndex = 3
            p121.Glow.Parent = Frame
            p121.Icon.AnchorPoint = Vector2.new(0.5, 0.5)
            p121.Icon.Position = UDim2.fromScale(0.5, 0.5)
            p121.Icon.ZIndex = 4
            p121.Icon.Parent = Frame
            p121.RewardName.AnchorPoint = Vector2.new(0, 0.5)
            p121.RewardName.TextXAlignment = Enum.TextXAlignment.Left
            p121.Note.AnchorPoint = Vector2.new(0, 0.5)
            p121.Note.TextXAlignment = Enum.TextXAlignment.Left
            p121.Chance.AnchorPoint = Vector2.new(0, 0.5)

            local UICorner2 = p121.Chance:FindFirstChildOfClass("UICorner")

            if UICorner2 == nil then
                UICorner2 = Instance.new("UICorner")
                UICorner2.Parent = p121.Chance
            end

            UICorner2.CornerRadius = UDim.new(0.5, 0)
            p121.Chance.BackgroundColor3 = Color3.fromHex("#1B1B24")
            p121.Chance.BackgroundTransparency = 0
            p121.Chance.ZIndex = 2

            local UIStroke2 = p121.Chance:FindFirstChildOfClass("UIStroke")

            if UIStroke2 == nil then
                UIStroke2 = Instance.new("UIStroke")
                UIStroke2.Parent = p121.Chance
            end

            UIStroke2.Color = Color3.fromHex("#131624")
            UIStroke2.Thickness = 2
            p121.Chance.Value.TextColor3 = Color3.new(1, 1, 1)
            p121.Chance.Value.ZIndex = 3
        end

        local function layoutRewardCards(p122) -- line: 2630
            -- upvalues: t30 (copy)
            local AbsoluteSize = p122.AbsoluteSize
            local v339 = #t30.Cards

            if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) and v339 ~= 0 then
                local v341 = math.round(AbsoluteSize.X * t30.PadXFraction)
                local v343 = math.round(AbsoluteSize.Y * t30.PadYFraction)
                local v344 = AbsoluteSize.X - v341 * 2
                local v345 = AbsoluteSize.Y - v343 * 2
                local v349 = math.floor((math.clamp(v345 / (v339 + (v339 - 1) * t30.RowGapFraction), t30.MinRowHeight, v344 / t30.MaxRowAspect)))
                local v351 = math.round(v349 * t30.RowGapFraction)
                local v352 = v349 * v339 + v351 * (v339 - 1)
                local v353 = v345 < v352

                p122.ScrollingEnabled = v353
                p122.AutomaticCanvasSize = Enum.AutomaticSize.None

                if v353 then
                    p122.CanvasSize = UDim2.fromOffset(0, v352 + v343 * 2)
                else
                    p122.CanvasSize = UDim2.new()
                    v343 += (v345 - v352) / 2
                end

                local v356 = math.max(1, (math.round(v349 * t30.NameTextCap)))
                local v359 = math.max(1, (math.round(v349 * t30.ChanceTextCap)))
                local v362 = math.max(1, (math.round(v349 * t30.NoteTextCap)))
                local TextSize = p122.Template.Note.TextSize
                local v364 = math.round(v349 * t30.RowPadFraction)
                local v365 = v349 - v364 * 2
                local v367 = math.round(v365 * t30.GlowScale)
                local v369 = math.round(v365 * t30.IconScale)
                local v371 = math.round(v349 * t30.PillHeightFraction)
                local v373 = math.round(v349 * t30.PillPadFraction)

                for v374, v375 in t30.Cards do
                    v375.AnchorPoint = Vector2.new(0, 0)
                    v375.Size = UDim2.fromOffset(v344, v349)
                    v375.Position = UDim2.fromOffset(v341, v343 + (v374 - 1) * (v349 + v351))

                    local Slot = v375.Slot

                    Slot.Size = UDim2.fromOffset(v365, v365)
                    Slot.Position = UDim2.fromOffset(v364, v349 / 2)
                    Slot.Glow.Size = UDim2.fromOffset(v367, v367)
                    Slot.Icon.Size = UDim2.fromOffset(v369, v369)

                    local v377 = math.round(#v375.Chance.Value.Text * v359 * t30.PillCharWidth + v373 * 2)

                    v375.Chance.Size = UDim2.fromOffset(v377, v371)
                    v375.Chance.Position = UDim2.fromOffset(v344 - v364 - v377, v349 / 2)

                    local v380 = v364 + v365 + math.round(v349 * t30.SlotGapFraction)
                    local v381 = v344 - v364 * 2 - v377 - v380

                    if v375.Note.Visible then
                        v375.RewardName.Size = UDim2.fromOffset(v381, (math.round(v349 * 0.42)))
                        v375.RewardName.Position = UDim2.fromOffset(v380, (math.round(v349 * 0.36)))
                        v375.Note.Size = UDim2.fromOffset(v381, (math.round(v349 * 0.26)))
                        v375.Note.Position = UDim2.fromOffset(v380, (math.round(v349 * 0.71)))

                        local v386 = #v375.Note.Text * TextSize * t30.NoteCharWidth
                        local Note3 = v375.Note

                        if v381 < v386 then
                            Note3.TextSize = math.max(1, (math.floor(TextSize * v381 / v386)))
                        else
                            Note3.TextSize = TextSize
                        end
                    else
                        v375.RewardName.Size = UDim2.fromOffset(v381, (math.round(v349 * 0.56)))
                        v375.RewardName.Position = UDim2.fromOffset(v380, v349 / 2)
                    end

                    v375.RewardName.UITextSizeConstraint.MaxTextSize = v356
                    v375.Chance.Value.UITextSizeConstraint.MaxTextSize = v359
                    v375.Note.UITextSizeConstraint.MaxTextSize = v362
                end
            end
        end

        local function renderRewardsPanel() -- line: 2724
            -- upvalues: t30 (copy), paintRewardCard (copy), startRewardFlow (copy), buildRewardRow (copy), layoutRewardCards (copy), GUI (copy), MonsterParasite (copy), Rarities (copy)
            local v390 = GUI.Get(t30.Accessor)
            local ScrollingFrame = v390.Frame.ScrollingFrame
            local UIGridLayout = ScrollingFrame:FindFirstChildOfClass("UIGridLayout")

            if UIGridLayout ~= nil then
                UIGridLayout:Destroy()
            end

            local UIAspectRatioConstraint = v390.Frame:FindFirstChildOfClass("UIAspectRatioConstraint")

            if UIAspectRatioConstraint ~= nil then
                UIAspectRatioConstraint.AspectRatio = t30.PanelAspect
            end

            ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            ScrollingFrame.Size = UDim2.fromScale(t30.ScrollerSize.X, t30.ScrollerSize.Y)
            ScrollingFrame.Position = UDim2.fromScale(t30.ScrollerCenter.X, t30.ScrollerCenter.Y)

            local Template = ScrollingFrame.Template

            for _, child in ScrollingFrame:GetChildren() do
                if child:IsA("GuiObject") and child ~= Template then
                    child:Destroy()
                end
            end

            table.clear(t30.Cards)
            table.clear(t30.Flowing)

            local n13 = 0

            for _, v391 in MonsterParasite.Rewards do
                n13 += MonsterParasite.GetRewardWeight(v391.Id)
            end

            for v392, v393 in MonsterParasite.Rewards do
                local clone = Template:Clone()

                clone.Name = ("Reward_%*"):format(v393.Id)
                clone.LayoutOrder = v392
                clone.Visible = true
                clone.RewardName.Text = string.upper(v393.DisplayName)
                clone.Icon.Image = v393.Icon or Template:GetAttribute("FallbackIcon")

                local DisplayNote = v393.DisplayNote

                clone.Note.Visible = DisplayNote ~= nil

                if DisplayNote ~= nil then
                    clone.Note.Text = string.upper(DisplayNote)
                end

                local v395 = math.floor(MonsterParasite.GetRewardWeight(v393.Id) / n13 * 100 * 10 + 0.5) / 10

                clone.Chance.Value.Text = ("%*%%"):format(v395)

                local v396 = Rarities[t30.RarityGradients[v393.Rarity] or v393.Rarity]

                if v396 ~= nil and v396.RarityGradient ~= nil then
                    paintRewardCard(clone, v396.RarityGradient)
                end

                buildRewardRow(clone)
                table.insert(t30.Cards, clone)
                clone.Parent = ScrollingFrame
            end

            if t30.Sizing ~= nil then
                t30.Sizing:Disconnect()
            end

            t30.Sizing = ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 2800
                -- upvalues: ScrollingFrame (copy), layoutRewardCards (copy)
                layoutRewardCards(ScrollingFrame)
            end)
            layoutRewardCards(ScrollingFrame)
            startRewardFlow(v390)
        end

        local t33 = {
            Gui = nil,
            Release = nil
        }

        local function hideTutorial() -- line: 2814
            -- upvalues: t33 (copy)
            local Gui = t33.Gui

            if Gui ~= nil and Gui.Enabled then
                Gui.Enabled = false

                local Release = t33.Release

                t33.Release = nil

                if Release ~= nil then
                    Release()
                end
            end
        end

        local function showTutorial() -- line: 2828
            -- upvalues: t33 (copy), hideTutorial (copy), ButtonFX (copy), GUI (copy), HiddenUIHandler (copy)
            local Gui = t33.Gui

            if Gui == nil then
                Gui = GUI.MonsterEventTutorialFrame()

                local MonsterEventTutorialFrame = Gui.MonsterEventTutorialFrame

                assert(MonsterEventTutorialFrame:IsA("Frame"), "MonsterEventTutorialFrame.MonsterEventTutorialFrame must be a Frame")

                local Ok = MonsterEventTutorialFrame.Ok

                assert(Ok:IsA("ImageButton"), "MonsterEventTutorialFrame.Ok must be an ImageButton")
                GUI.OnActivated(Ok, hideTutorial)
                ButtonFX(Ok)
                t33.Gui = Gui
            end

            if not Gui.Enabled then
                t33.Release = HiddenUIHandler.Acquire()
                Gui.Enabled = true
            end
        end

        local function bindPrompt(p123, p124) -- line: 2852
            -- upvalues: refreshPrompts (copy), requestFeed (copy), t30 (copy), renderRewardsPanel (copy), showTutorial (copy), MonsterParasite (copy), MonsterParasite2 (copy), Tabs (copy)
            if p124.Name == MonsterParasite.TalkPromptName then
                p123:Connect(p124.Triggered, showTutorial)
            elseif p124.Name == MonsterParasite.FeedPromptName then
                p123:Connect(p124.Triggered, requestFeed)
            elseif p124.Name == MonsterParasite2.ViewRewardsPromptName then
                p123:Connect(p124.Triggered, function() -- line: 2858
                    -- upvalues: t30 (copy), renderRewardsPanel (copy), Tabs (copy)
                    renderRewardsPanel()
                    Tabs.Toggle(t30.Accessor)
                end)
            end

            refreshPrompts()
        end

        local function hideModel(p125) -- line: 2888
            for _, descendant in p125:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = 1
                end
            end
        end

        local t34 = {
            CleanupSeconds = 2,
            ParticleScale = 2.6,
            EmitScale = 2.25,
            SuppressSeconds = 1
        }
        local _ = {
            ReferenceDiameter = 8.4,
            MinScale = 0.7,
            MaxScale = 2.2
        }
        local n14 = (-1e999)

        local function scaleNumberSequence(p126, p127) -- line: 2938
            local v397 = table.create(#p126.Keypoints)

            for v398, v399 in p126.Keypoints do
                v397[v398] = NumberSequenceKeypoint.new(v399.Time, v399.Value * p127, v399.Envelope * p127)
            end

            return NumberSequence.new(v397)
        end

        local function isSwapVeilActive() -- line: 2953
            -- upvalues: n14 (ref)
            return os.clock() - n14 < 1
        end

        local function playSwapVeil(p128) -- line: 2957
            -- upvalues: resolveVfxTemplate (copy), n14 (ref), scaleNumberSequence (copy), Debris (copy), Workspace (copy), Emit (copy), MonsterParasite (copy)
            if p128 ~= nil and p128.Parent ~= nil then
                local BoundingBox, BoundingBox2 = p128:GetBoundingBox()
                local BoundingBoxPosition = BoundingBox.Position
                local Part = Instance.new("Part")

                Part.Name = "MonsterSwapVeil"
                Part.Size = Vector3.new(1, 1, 1)
                Part.CFrame = CFrame.new(BoundingBoxPosition)
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanQuery = false
                Part.CanTouch = false
                Part.CastShadow = false
                Part.Transparency = 1

                local Transient = Workspace:FindFirstChild("Transient")

                if not Transient or not Transient:IsA("Folder") then
                    Transient = Workspace
                end

                Part.Parent = Transient
                Debris:AddItem(Part, 2)
                n14 = os.clock()

                local v400 = resolveVfxTemplate(MonsterParasite.EnergyBurstVfxName)

                if v400 ~= nil then
                    local clone = v400:Clone()

                    for _, descendant in clone:GetDescendants() do
                        if descendant:IsA("ParticleEmitter") then
                            descendant.Size = scaleNumberSequence(descendant.Size, 2.6)
                            descendant.Speed = NumberRange.new(descendant.Speed.Min * 2.6, descendant.Speed.Max * 2.6)

                            local EmitCount = descendant:GetAttribute("EmitCount")

                            if type(EmitCount) == "number" then
                                descendant:SetAttribute("EmitCount", (math.ceil(EmitCount * 2.25)))
                            end
                        end
                    end

                    clone.CFrame = CFrame.identity
                    clone.Parent = Part
                    Emit(clone)
                end

                local v402 = resolveVfxTemplate(MonsterParasite.SwapPoofVfxName)

                if v402 == nil then
                    return
                end

                local clone = v402:Clone()
                local v404 = math.clamp(math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z) / 8.4, 0.7, 2.2)

                for _, descendant in clone:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Size = scaleNumberSequence(descendant.Size, v404)
                        descendant.Speed = NumberRange.new(descendant.Speed.Min * v404, descendant.Speed.Max * v404)
                        descendant.Acceleration *= v404
                        descendant.ZOffset *= v404
                    end
                end

                clone.CFrame = CFrame.identity
                clone.Parent = Part
                Emit(clone)
            end
        end

        local function isRetiring(p129) -- line: 3036
            -- upvalues: MonsterParasite (copy)
            return p129:GetAttribute(MonsterParasite.MonsterRetiringAttributeName) == true
        end

        local t35 = {
            FadeSeconds = 0.35,
            Instance = nil,
            Dim = nil,
            Alpha = 1,
            Lit = false,
            Step = nil,
            Path = {
                "Stands",
                "Pads",
                MonsterParasite.PadName
            }
        }
        local v405 = Workspace

        for _, v406 in t35.Path do
            if v405 ~= nil then
                v405 = v405:FindFirstChild(v406)
            end
        end

        if v405 ~= nil then
            local Path = Fader()

            Path:Hide(v405, 1)
            t35.Instance = v405
            t35.Dim = Path
        end

        local function refreshPad() -- line: 3083
            -- upvalues: v4 (ref), t35 (copy), RunService (copy), TweenService (copy), MonsterParasite (copy)
            local Instance, Dim = t35.Instance, t35.Dim

            if Instance == nil or Dim == nil then
                return
            end

            local v407 = v4
            local v408 = v407 ~= nil and v407.Parent ~= nil and v407:GetAttribute(MonsterParasite.MonsterRetiringAttributeName) ~= true

            if v408 == t35.Lit then
                return
            end

            t35.Lit = v408

            local Step = t35.Step

            if Step ~= nil then
                Step:Disconnect()
                t35.Step = nil
            end

            local Alpha = t35.Alpha
            local v409 = if v408 then 0 else 1
            local t36 = {}

            t36[1] = 0

            local connection

            connection = RunService.PreRender:Connect(function(p130) -- line: 3106
                -- upvalues: Instance (copy), Dim (copy), Alpha (copy), t36 (copy), connection (ref), v409 (copy), t35 (copy), TweenService (copy)
                t36[1] = math.min(t36[1] + p130, t35.FadeSeconds)

                local Value = TweenService:GetValue(t36[1] / t35.FadeSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                t35.Alpha = Alpha + (v409 - Alpha) * Value
                Dim:Hide(Instance, t35.Alpha)

                if not (t36[1] >= t35.FadeSeconds) then
                    return
                end

                connection:Disconnect()
                t35.Alpha = v409
                Dim:Hide(Instance, v409)
                t35.Step = nil
            end)
            t35.Step = connection
        end

        local t37 = {
            Arrow = require(ReplicatedStorage.Client.WorldFX.ArrowPointer3D),
            Zones = require(ReplicatedStorage.Client.WorldFX.Pads),
            Pointer = nil,
            Step = nil,
            Dim = nil,
            Surface = nil,
            Origin = nil,
            Alpha = 1,
            Fading = false,
            Shown = false,
            Retired = false,
            PollSeconds = 0.2,
            FadeSeconds = 0.35,
            Config = {
                ProximityThreshold = 5,
                Radius = 5,
                Amplitude = 2,
                Color = MonsterParasite.ParasiteHighlightColor
            }
        }

        function t37.Finished() -- line: 3180
            -- upvalues: v6 (ref), t37 (copy), Save (copy)
            if t37.Retired then
                return true
            end

            local v411 = Save.Await()
            local MonsterParasite = if v411 == nil then nil else v411.MonsterParasite

            if (if MonsterParasite == nil then 0 else MonsterParasite.TotalFeeds) > 0 or v6.TotalFeeds > 0 then
                t37.Retired = true
            end

            return t37.Retired
        end

        function t37.Root() -- line: 3193
            -- upvalues: LocalPlayer (copy)
            local Character = LocalPlayer.Character
            local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

            return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
        end

        function t37.Wanted() -- line: 3201
            -- upvalues: v10 (ref), isHoldingParasiteEgg (copy), t35 (copy), t37 (copy)
            return t35.Lit and not t37.Shown and not t37.Finished() and not v10 and isHoldingParasiteEgg()
        end

        function t37.Ease(p131, p132) -- line: 3211
            -- upvalues: t37 (copy), RunService (copy), TweenService (copy)
            local Pointer, Dim = t37.Pointer, t37.Dim

            if Pointer == nil or Dim == nil then
                return
            end

            local Step = t37.Step

            if Step ~= nil then
                Step:Disconnect()
                t37.Step = nil
            end

            local model = Pointer.model
            local Alpha = t37.Alpha
            local t38 = {}

            t38[1] = 0

            local connection

            connection = RunService.PreRender:Connect(function(p133) -- line: 3226
                -- upvalues: p131 (copy), p132 (copy), Dim (copy), model (copy), Alpha (copy), t38 (copy), connection (ref), t37 (copy), TweenService (copy)
                t38[1] = math.min(t38[1] + p133, t37.FadeSeconds)

                local Value = TweenService:GetValue(t38[1] / t37.FadeSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                t37.Alpha = Alpha + (p131 - Alpha) * Value
                Dim:Hide(model, t37.Alpha)

                if not (t38[1] >= t37.FadeSeconds) then
                    return
                end

                connection:Disconnect()
                t37.Alpha = p131
                Dim:Hide(model, p131)
                t37.Step = nil

                if p132 ~= nil then
                    p132()
                end
            end)
            t37.Step = connection
        end

        function t37.Raise(p134, p135) -- line: 3248
            -- upvalues: Fader (copy), t37 (copy)
            local v413 = t37.Arrow.new(p134, p135, t37.Config)

            t37.Pointer = v413
            t37.Origin = p135
            t37.Dim = Fader()
            t37.Alpha = 1
            t37.Dim:Hide(v413.model, 1)
            v413:Start()
            t37.Ease(0)
        end

        function t37.Drop() -- line: 3263
            -- upvalues: t37 (copy)
            local Pointer = t37.Pointer

            if Pointer == nil or t37.Fading then
                return
            end

            t37.Fading = true
            t37.Ease(1, function() -- line: 3269
                -- upvalues: Pointer (copy), t37 (copy)
                Pointer:Destroy()

                if t37.Pointer == Pointer then
                    t37.Pointer = nil
                    t37.Origin = nil
                    t37.Dim = nil
                end

                t37.Fading = false
            end)
        end

        function t37.Refresh() -- line: 3281
            -- upvalues: t37 (copy)
            if t37.Fading then
                return
            end

            local v414 = t37.Root()
            local Surface = t37.Surface

            if Surface == nil or v414 == nil or not t37.Wanted() then
                t37.Drop()

                return
            end

            if t37.Pointer ~= nil then
                if t37.Origin ~= v414 then
                    local Pointer = t37.Pointer

                    Pointer:PointFrom(v414)
                    t37.Origin = v414
                    Pointer:Start()
                end
            else
                t37.Raise(Surface, v414)
            end
        end

        function t37.Enter() -- line: 3306
            -- upvalues: showTutorial (copy), t37 (copy)
            if not t37.Wanted() then
                return
            end

            t37.Shown = true
            showTutorial()
            t37.Drop()
        end

        task.spawn(function() -- line: 3315
            -- upvalues: v2 (copy), t35 (copy), t37 (copy)
            local Instance = t35.Instance

            if Instance ~= nil and Instance:IsA("BasePart") then
                t37.Surface = Instance
                v2:Add(t37.Zones.Track(Instance, {
                    Entered = t37.Enter
                }))
            end

            while task.wait(t37.PollSeconds) do
                t37.Refresh()

                if t37.Finished() and t37.Pointer == nil and not t37.Fading then
                    break
                end
            end
        end)

        local function bindModel(p136) -- line: 3335
            -- upvalues: LocalPlayer (copy), t2 (copy), v4 (ref), clone (ref), v5 (ref), v6 (ref), v10 (ref), resolveVfxTemplate (copy), startIdle (copy), t29 (copy), n7 (ref), applyState (copy), bindPrompt (copy), hideModel (copy), t34 (copy), n14 (ref), refreshPad (copy), Emit (copy), MonsterParasite (copy), Trove (copy)
            if t2[p136] or p136:GetAttribute("OwnerUserId") == nil then
                return
            end

            if p136:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
                p136:Destroy()

                return
            end

            if p136:GetAttribute(MonsterParasite.MonsterRetiringAttributeName) == true then
                hideModel(p136)
            else
                local v415 = Trove.new()
                local v416 = v4

                t2[p136] = v415
                v4 = p136

                if v416 ~= nil and v416 ~= p136 and v416.Parent ~= nil and v5 ~= v416 then
                    hideModel(v416)
                end

                v415:Connect(p136:GetAttributeChangedSignal(MonsterParasite.MonsterRetiringAttributeName), function() -- line: 3383
                    -- upvalues: p136 (copy), v5 (ref), hideModel (copy), refreshPad (copy), MonsterParasite (copy)
                    if p136:GetAttribute(MonsterParasite.MonsterRetiringAttributeName) == true then
                        task.defer(refreshPad)

                        if v5 == p136 then
                            task.spawn(function() -- line: 3400
                                -- upvalues: p136 (copy), v5 (ref), hideModel (copy)
                                while v5 == p136 and p136.Parent ~= nil do
                                    task.wait()
                                end

                                if p136.Parent ~= nil then
                                    hideModel(p136)
                                end
                            end)
                        else
                            hideModel(p136)
                        end
                    end
                end)

                local PrimaryPart = p136.PrimaryPart
                local v417, PrimaryPart2, v418

                if PrimaryPart ~= nil then
                    t29[p136] = PrimaryPart.CFrame

                    if math.abs(n7) > 0.001 then
                        v417 = n7
                        PrimaryPart2 = p136.PrimaryPart
                        v418 = t29[p136]

                        if v418 == nil then
                            local PrimaryPart = p136.PrimaryPart

                            if PrimaryPart ~= nil then
                                t29[p136] = PrimaryPart.CFrame
                                v418 = PrimaryPart.CFrame
                            else
                                v418 = nil
                            end
                        end

                        if PrimaryPart2 ~= nil and v418 ~= nil then
                            PrimaryPart2.CFrame = v418 * CFrame.fromEulerAnglesYXZ(0, v417, 0)
                        end
                    end
                end

                startIdle(p136, v415)

                if v10 and p136.PrimaryPart ~= nil then
                    local v420 = os.clock() - n14 < t34.SuppressSeconds

                    if not v420 then
                        local PrimaryPart = p136.PrimaryPart
                        local v421 = resolveVfxTemplate(MonsterParasite.EnergyBurstVfxName)

                        if v421 ~= nil then
                            local clone = v421:Clone()

                            clone.Parent = PrimaryPart
                            v415:Add(clone)
                            Emit(clone)
                        end
                    end
                end

                v415:Connect(p136.Destroying, function() -- line: 3424
                    -- upvalues: p136 (copy), v415 (copy), t2 (copy), v4 (ref), clone (ref), t29 (copy), refreshPad (copy)
                    t2[p136] = nil
                    t29[p136] = nil

                    if v4 == p136 then
                        v4 = nil

                        if clone then
                            clone:Destroy()
                            clone = nil
                        end

                        task.defer(refreshPad)
                    end

                    v415:Destroy()
                end)

                for _, descendant in p136:GetDescendants() do
                    if descendant:IsA("ProximityPrompt") then
                        bindPrompt(v415, descendant)
                    end
                end

                v415:Connect(p136.DescendantAdded, function(p137) -- line: 3439
                    -- upvalues: v415 (copy), bindPrompt (copy)
                    if p137:IsA("ProximityPrompt") then
                        bindPrompt(v415, p137)
                    end
                end)
                applyState(v6)
                refreshPad()
            end
        end

        local function inspectInstance(p138) -- line: 3448
            -- upvalues: bindModel (copy)
            if p138:IsA("Model") then
                bindModel(p138)
            end
        end

        local function bindWorldFolder(p139) -- line: 3454
            -- upvalues: v2 (copy), bindModel (copy), inspectInstance (copy)
            for _, child in p139:GetChildren() do
                if child:IsA("Model") then
                    bindModel(child)
                end
            end

            v2:Connect(p139.ChildAdded, inspectInstance)
        end

        local function inspectWorldChild(p140) -- line: 3461
            -- upvalues: v2 (copy), bindModel (copy), inspectInstance (copy), MonsterParasite (copy)
            if p140.Name == MonsterParasite.WorldFolderName and p140:IsA("Folder") then
                for _, child in p140:GetChildren() do
                    if child:IsA("Model") then
                        bindModel(child)
                    end
                end

                v2:Connect(p140.ChildAdded, inspectInstance)
            end
        end

        local function markParasiteSwallowed() -- line: 3473
            -- upvalues: LocalPlayer (copy), MonsterParasite2 (copy)
            LocalPlayer:SetAttribute(MonsterParasite2.ChargeGainAttributeName, os.clock())
        end

        local function releaseFullChargeModel(p141) -- line: 3486
            -- upvalues: MonsterParasite3 (copy), playSwapVeil (copy)
            playSwapVeil(p141)
            MonsterParasite3.AskFullChargeReset:FireServer()
        end

        local function isFullChargeResult(p142) -- line: 3495
            return (p142.PreviousCharge or 0) > (p142.Charge or 0)
        end

        local function isSculptChange(p143) -- line: 3507
            -- upvalues: MonsterParasite (copy)
            local v422 = MonsterParasite.GetMonsterModelIndex(p143.PreviousCharge or 0)

            return MonsterParasite.GetMonsterModelIndex(p143.Charge or 0) ~= v422
        end

        local function waitForThread(p144) -- line: 3519
            while p144 ~= nil and coroutine.status(p144) ~= "dead" do
                task.wait()
            end
        end

        local function getFeedMonster() -- line: 3527
            -- upvalues: v4 (ref)
            local v423 = os.clock() + 2
            local v424

            while true do
                v424 = v4

                if v424 == nil or v424.PrimaryPart == nil then
                    task.wait()

                    if v423 <= os.clock() then
                        return v4
                    end

                    continue
                end

                break
            end

            return v424
        end

        local function playFeedSequence(p145) -- line: 3539
            -- upvalues: MonsterParasite3 (copy), LocalPlayer (copy), clone (ref), v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), playSound (copy), t23 (copy), pulseMonsterScale (copy), releaseMonsterFacing (copy), playYankAnimation (copy), animateChestPickup (copy), animateFullCharge (copy), requestTakeChest (copy), playSwapVeil (copy), waitForThread (copy), getFeedMonster (copy), MonsterParasite (copy), MonsterParasite2 (copy)
            local v425 = getFeedMonster()
            local PrimaryPart = if v425 then v425.PrimaryPart else nil

            if v425 ~= nil and PrimaryPart ~= nil then
                playYankAnimation(v425)

                local v426 = v425:FindFirstChild(MonsterParasite.ParasiteEatTargetPartName, true) or v425:FindFirstChild(MonsterParasite.TongueTipName, true) or PrimaryPart

                playSound(MonsterParasite.ChompSoundName, v426)
                LocalPlayer:SetAttribute(MonsterParasite2.ChargeGainAttributeName, os.clock())
                task.wait(t23.ScaleTweenDelaySeconds)

                local v427

                if v425.Parent then
                    v427 = task.spawn(pulseMonsterScale, v425)
                    task.wait(0.12)
                end

                local v428 = MonsterParasite.GetMonsterModelIndex(p145.PreviousCharge or 0)

                if MonsterParasite.GetMonsterModelIndex(p145.Charge or 0) ~= v428 and not ((p145.PreviousCharge or 0) > (p145.Charge or 0)) then
                    playSwapVeil(v425)
                end

                MonsterParasite3.AskGrowthSwap:FireServer()

                if (p145.PreviousCharge or 0) > (p145.Charge or 0) then
                    task.spawn(releaseMonsterFacing)
                    task.wait(MonsterParasite.FullChargeHoldDuration)

                    local v429 = if v425.Parent == nil then getFeedMonster() else v425

                    if v429 ~= nil and v429.Parent ~= nil then
                        v429:SetAttribute(MonsterParasite2.ChargeDrainAttributeName, os.clock())
                        task.wait(MonsterParasite2.ChargeDrainDuration)

                        local v430 = if v429.Parent == nil then getFeedMonster() else v429

                        if v430 == nil or v430.Parent == nil then
                            warn("[MonsterParasite] Full charge lost its monster during the drain")
                        elseif not animateFullCharge(v430) then
                            warn("[MonsterParasite] Full charge ended without launching a chest")
                        end

                        playSwapVeil(v430)
                        MonsterParasite3.AskFullChargeReset:FireServer()

                        local clone2 = clone

                        if clone2 and clone2.Parent then
                            animateChestPickup(clone2)
                        end
                    else
                        warn("[MonsterParasite] Full charge had no live monster to burp from")
                        MonsterParasite3.AskFullChargeReset:FireServer()

                        local clone2 = clone

                        if clone2 and clone2.Parent then
                            animateChestPickup(clone2)
                        end
                    end

                    requestTakeChest()
                else
                    releaseMonsterFacing()
                    waitForThread(v427)
                end
            else
                local connection2 = connection

                connection = nil

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                local result2 = result

                result = nil

                if result2 ~= nil then
                    result2:Stop(t23.HandPoseReleaseSeconds)
                    task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                        -- upvalues: result2 (copy)
                        result2:Destroy()
                    end)
                end

                if v12 ~= nil then
                    v12:Destroy()
                    v12 = nil
                end

                v14 = nil
                v13 = nil
                LocalPlayer:SetAttribute(MonsterParasite2.ChargeGainAttributeName, os.clock())
                MonsterParasite3.AskGrowthSwap:FireServer()

                if not ((p145.PreviousCharge or 0) > (p145.Charge or 0)) then
                    return
                end

                MonsterParasite3.AskFullChargeReset:FireServer()

                local clone2 = clone

                if clone2 and clone2.Parent then
                    animateChestPickup(clone2)
                end

                requestTakeChest()
            end
        end

        MonsterParasite3.StateShifted.OnClientEvent:Connect(function(p146) -- line: 3677
            -- upvalues: applyState (copy), MonsterParasite2 (copy)
            if MonsterParasite2.StateSchema(p146) then
                applyState(p146)
            end
        end)
        MonsterParasite3.EventStateShifted.OnClientEvent:Connect(function(p147) -- line: 3683
            -- upvalues: v7 (ref), refreshPrompts (copy), MonsterParasite2 (copy)
            if MonsterParasite2.EventStateSchema(p147) then
                v7 = p147.Active
                refreshPrompts()
            end
        end)
        MonsterParasite3.FeedSettled.OnClientEvent:Connect(function(p148) -- line: 3690
            -- upvalues: MonsterParasite3 (copy), LocalPlayer (copy), v4 (ref), clone (ref), v5 (ref), v6 (ref), v8 (ref), v10 (ref), n1 (ref), n2 (ref), t4 (copy), v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), t23 (copy), captureEquippedEgg (copy), releaseMonsterFacing (copy), refreshPrompts (copy), requestTakeChest (copy), playSwapVeil (copy), playFeedSequence (copy), MonsterParasite2 (copy)
            if not MonsterParasite2.FeedResultSchema(p148) then
                return
            end

            v8 = false
            captureEquippedEgg()

            if (p148.PreviousCharge or 0) > (p148.Charge or 0) then
                if n2 > 0 then
                    n2 -= 1
                else
                    n1 += 1
                end
            end

            local t39 = {
                Charge = if p148.Charge == nil then v6.Charge else p148.Charge,
                PendingChests = if p148.PendingChests == nil then v6.PendingChests else p148.PendingChests,
                TotalFeeds = v6.TotalFeeds,
                PendingReward = v6.PendingReward
            }

            v6 = table.clone(t39)

            if v4 then
                v4:SetAttribute("Charge", t39.Charge)
                v4:SetAttribute("PendingChests", t39.PendingChests)
            end

            table.insert(t4, p148)

            if v10 then
                return
            end

            v10 = true
            refreshPrompts()
            task.spawn(function() -- line: 3639
                -- upvalues: MonsterParasite3 (copy), LocalPlayer (copy), v4 (ref), clone (ref), v5 (ref), v6 (ref), v10 (ref), n1 (ref), t4 (copy), v12 (ref), v13 (ref), v14 (ref), connection (ref), result (ref), t23 (copy), releaseMonsterFacing (copy), refreshPrompts (copy), requestTakeChest (copy), playSwapVeil (copy), playFeedSequence (copy), MonsterParasite2 (copy)
                while #t4 > 0 do
                    local v433 = table.remove(t4, 1)

                    assert(v433 ~= nil, "Feed sequence queue changed unexpectedly")

                    local v435 = (v433.PreviousCharge or 0) > (v433.Charge or 0)

                    local function v436() -- line: 3644
                        -- upvalues: playFeedSequence (copy), v433 (copy)
                        playFeedSequence(v433)

                        return true
                    end

                    local ok, result2 = pcall(v436)

                    if v435 then
                        n1 = math.max(0, n1 - 1)
                    end

                    if not ok then
                        local connection2 = connection

                        connection = nil

                        if connection2 ~= nil then
                            connection2:Disconnect()
                        end

                        local result3 = result

                        result = nil

                        if result3 ~= nil then
                            result3:Stop(t23.HandPoseReleaseSeconds)
                            task.delay(t23.HandPoseReleaseSeconds, function() -- line: 1018
                                -- upvalues: result3 (copy)
                                result3:Destroy()
                            end)
                        end

                        if v12 ~= nil then
                            v12:Destroy()
                            v12 = nil
                        end

                        v14 = nil
                        v13 = nil
                        LocalPlayer:SetAttribute(MonsterParasite2.ChargeGainAttributeName, os.clock())
                        task.spawn(releaseMonsterFacing)
                        v5 = nil
                        warn((("[MonsterParasite] Feed sequence failed: %*"):format(result2)))

                        if v435 then
                            playSwapVeil(v4)
                            MonsterParasite3.AskFullChargeReset:FireServer()
                            requestTakeChest()
                        end
                    end
                end

                v10 = false

                if v6.PendingChests <= 0 and n1 <= 0 and clone then
                    clone:Destroy()
                    clone = nil
                end

                refreshPrompts()
            end)
        end)
        MonsterParasite3.ChestOpened.OnClientEvent:Connect(function(p149) -- line: 3718
            -- upvalues: beginChestReveal (copy), MonsterParasite2 (copy)
            if MonsterParasite2.ChestResultSchema(p149) and p149.Success then
                beginChestReveal(p149)
            end
        end)
        CameraShakerDriver.Start(v15, Enum.RenderPriority.Camera.Value + 2)
        v2:Add(function() -- line: 3730
            -- upvalues: v15 (copy), CameraShakerDriver (copy)
            CameraShakerDriver.Stop(v15)
        end)
        task.spawn(preloadMonsterAssets)
        v2:Connect(Workspace.ChildAdded, inspectWorldChild)

        local OnClientEvent = Workspace:FindFirstChild(MonsterParasite.WorldFolderName)

        if OnClientEvent and OnClientEvent:IsA("Folder") then
            bindWorldFolder(OnClientEvent)
        end

        local function bindCharacter(p150) -- line: 3740
            -- upvalues: v3 (copy), refreshPrompts (copy), requestChest (copy), MonsterParasite (copy)
            v3:Clean()
            v3:Connect(p150.ChildAdded, function(p151) -- line: 3742
                -- upvalues: v3 (copy), refreshPrompts (copy), requestChest (copy), MonsterParasite (copy)
                if not p151:IsA("Tool") then
                    return
                end

                refreshPrompts()

                if p151:GetAttribute("ItemType") == MonsterParasite.ChestToolItemType then
                    v3:Connect(p151.Activated, requestChest)
                end
            end)
            v3:Connect(p150.ChildRemoved, function(p152) -- line: 3750
                -- upvalues: refreshPrompts (copy)
                if p152:IsA("Tool") then
                    refreshPrompts()
                end
            end)

            for _, child in p150:GetChildren() do
                if child:IsA("Tool") and child:GetAttribute("ItemType") == MonsterParasite.ChestToolItemType then
                    v3:Connect(child.Activated, requestChest)
                end
            end

            refreshPrompts()
        end

        v2:Connect(LocalPlayer.CharacterAdded, bindCharacter)

        local Character = LocalPlayer.Character

        if Character then
            bindCharacter(Character)
        end

        v2:Connect(Save.Watch("EggInventory"), refreshPrompts)
        v2:Connect(Save.Watch("MonsterParasite"), refreshPrompts)
        task.spawn(function() -- line: 3771
            -- upvalues: MonsterParasite3 (copy), v7 (ref), OpeningId (ref), refreshPrompts (copy), applyState (copy), beginChestReveal (copy), MonsterParasite2 (copy)
            local function v438() -- line: 3772
                -- upvalues: MonsterParasite3 (copy)
                return MonsterParasite3.AskSnapshot:InvokeServer()
            end

            local ok, result = pcall(v438)

            if not (ok and MonsterParasite2.SnapshotSchema(result)) then
                return
            end

            v7 = result.Event.Active
            applyState(result.State)

            local PendingReward = result.State.PendingReward

            if PendingReward ~= nil and OpeningId == nil then
                beginChestReveal({
                    Success = true,
                    Message = ("You received %*!"):format(PendingReward.Reward.DisplayName),
                    OpeningId = PendingReward.OpeningId,
                    Reward = PendingReward.Reward,
                    PendingChests = result.State.PendingChests
                })
            end

            refreshPrompts()
        end)
    end
}
