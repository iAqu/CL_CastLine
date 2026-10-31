-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local haptics = RuntimeLib.import(script, script.Parent.Parent, "haptics")
local cameraShakeEnabledAtom, hapticBonusRoll = haptics.cameraShakeEnabledAtom, haptics.hapticBonusRoll
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, ReplicatedStorage, RunService = services.CollectionService, services.Players, services.ReplicatedStorage, services.RunService
local TweenService, Workspace = services.TweenService, services.Workspace
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom")
local apexAfterRareFishCutsceneAtom, apexDropAtom, apexRevealAtom, apexSkillCheckAtom = v1.apexAfterRareFishCutsceneAtom, v1.apexDropAtom, v1.apexRevealAtom, v1.apexSkillCheckAtom
local catchFadeAtom, fishingMovementLockedAtom, hookHrpAtom, hookLandedPositionAtom = v1.catchFadeAtom, v1.fishingMovementLockedAtom, v1.hookHrpAtom, v1.hookLandedPositionAtom
local rareFishTransitionAtom, rareFishTransitionDurationSec = v1.rareFishTransitionAtom, v1.rareFishTransitionDurationSec
local vfx = RuntimeLib.import(script, script.Parent.Parent, "vfx")
local emitVFX, playClonedVfxWithSound = vfx.emitVFX, vfx.playClonedVfxWithSound
local ZoneChange = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "ZoneChange")
local playVisulie = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "Visulie", "visulie-utils").playVisulie
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local computeReelArcDurations, reelDropDuration, skipReelArcToLanding = v2.computeReelArcDurations, v2.reelDropDuration, v2.skipReelArcToLanding
local playReelCamera = RuntimeLib.import(script, script.Parent.Parent, "reel-camera").playReelCamera
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local startRareFishBossPov = RuntimeLib.import(script, script.Parent, "rare-fish-boss-pov").startRareFishBossPov
local selectLocalPlayerHook = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-hooks.selectors").selectLocalPlayerHook
local v3 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors")
local selectPlayerFishingState, selectPlayerFishingCaughtFishName = v3.selectPlayerFishingState, v3.selectPlayerFishingCaughtFishName
local selectCastCutsceneAnimationEnded = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "cast-cutscene.selectors").selectCastCutsceneAnimationEnded
local selectHoopTestingEnabled = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "hoop-testing.selectors").selectHoopTestingEnabled
local getMutatedMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getMutatedMoneyPerSecond
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquarium, selectPlayerEquippedFishReelbackVfxId, selectPlayerGamepasses, selectPlayerInventory = selectors.selectPlayerAquarium, selectors.selectPlayerEquippedFishReelbackVfxId, selectors.selectPlayerGamepasses, selectors.selectPlayerInventory
local selectPlayerShowcaseFish = selectors.selectPlayerShowcaseFish
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local v4 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, showcaseFishToMpsInput = v4.getAquariumFishEffectiveMoneyPerSecond, v4.showcaseFishToMpsInput
local VFX = ReplicatedStorage:FindFirstChild("VFX")

if VFX ~= nil then
    VFX = VFX:FindFirstChild("FishLandingVFX")
end

local VFX2 = ReplicatedStorage:FindFirstChild("VFX")

if VFX2 ~= nil then
    VFX2 = VFX2:FindFirstChild("PartyFishLandingVFX")
end

local t1 = {
    PartyFishLandingVFX = VFX2
}

local function playFishLandingVFX(p1, p2) -- line: 114
    -- upvalues: Workspace (copy), clientProducer (copy), emitVFX (copy), selectPlayerEquippedFishReelbackVfxId (copy), localPlayerUserId (copy), VFX (ref), t1 (copy)
    local v5 = if p2 == nil then 5 else p2
    local BoundingBox, BoundingBox2 = p1:GetBoundingBox()
    local v7 = BoundingBox.Position - Vector3.new(0, BoundingBox2.Y / 2, 0)
    local v8 = selectPlayerEquippedFishReelbackVfxId(localPlayerUserId)(clientProducer:getState())
    local v9 = if v8 == "" or not v8 then nil else t1[v8]

    if v9 then
        local clone = v9:Clone()

        clone.CFrame = CFrame.new(v7)
        clone.Parent = Workspace
        emitVFX(clone)
        task.delay(v5, function() -- line: 132
            -- upvalues: clone (copy)
            return clone:Destroy()
        end)

        return nil
    end

    if not VFX then
        return nil
    end

    local Part = Instance.new("Part")

    Part.Size = Vector3.new(1, 1, 1)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1
    Part.CFrame = CFrame.new(v7)
    Part.Parent = Workspace

    local clone = VFX:Clone()

    clone.Parent = Part
    emitVFX(clone)
    task.delay(v5, function() -- line: 151
        -- upvalues: Part (copy)
        return Part:Destroy()
    end)
end

local function playZoneChangeOnRig(p3) -- line: 155
    -- upvalues: Workspace (copy), ZoneChange (copy), playVisulie (copy)
    local Model = Instance.new("Model")

    Model.Name = "ZoneChangeVisulie"
    Model.Parent = Workspace
    playVisulie(ZoneChange, p3:GetPivot(), Model)
    task.delay(0.75, function() -- line: 160
        -- upvalues: Model (copy)
        return Model:Destroy()
    end)
end

local function getRigAnimator(p4) -- line: 173
    local Humanoid = p4:FindFirstChildOfClass("Humanoid")

    if Humanoid == nil then
        local AnimationController = p4:FindFirstChildOfClass("AnimationController")

        if AnimationController == nil then
            return nil
        end

        local Animator = AnimationController:FindFirstChildOfClass("Animator")

        if Animator == nil then
            Animator = Instance.new("Animator")
            Animator.Parent = AnimationController
        end

        return Animator
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    return Animator
end

local function getRigCameraReference(p5) -- line: 194
    local v10 = p5:FindFirstChild("HumanoidRootPart", true)

    if if v10 == nil then v10 else v10:IsA("BasePart") then
        return v10
    end

    local v11 = p5:FindFirstChild("HumanoidPart", true)

    if if v11 == nil then v11 else v11:IsA("BasePart") then
        return v11
    end

    return p5.PrimaryPart
end

local function resetLocalCameraDefaults() -- line: 218
    -- upvalues: Players (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera.FieldOfView = 70
    end

    local LocalPlayer = Players.LocalPlayer

    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 128
end

local function getRigPart(p6, p7, p8) -- line: 227
    local v12 = p6:FindFirstChild(p7, true)

    if if v12 == nil then v12 else v12:IsA("BasePart") then
        return v12
    end

    warn((("[ApexSkillCheck] %*: MiniPlayerRig %* not found"):format(p8, p7)))

    return nil
end

local function setMiniRigBeamVisible(p9, p10) -- line: 241
    local v13 = p9:FindFirstChild("BeamPart", true)
    local v14, v15

    if v13 ~= nil then
        if v13:IsA("BasePart") then
            v13.Transparency = 1
            v13.Anchored = true
            v13.CanCollide = false
            v13.CanQuery = false
            v13.CanTouch = false

            if p10 then
                v14 = p9:FindFirstChild("RightGripAttachment", true)
            end

            v15 = false
        else
            v15 = true
        end
    else
        v15 = true
    end

    if v15 then
        warn("[RareFish] BeamPart not found on MiniPlayerRig")

        return nil
    end

    if p10 and v14 == nil then
        warn("[RareFish] RightGripAttachment not found — beam will not render")
    end

    for _, descendant in v13:GetDescendants() do
        if descendant:IsA("Beam") then
            if p10 then
                if descendant.Attachment0 == nil then
                    local Attachment = v13:FindFirstChildOfClass("Attachment")

                    if Attachment ~= nil then
                        descendant.Attachment0 = Attachment
                    end
                end

                if v14 ~= nil then
                    descendant.Attachment1 = v14
                end
            end

            descendant.Enabled = p10
        end
    end
end

local function prepareMiniRigForCutsceneAnimation(p11) -- line: 281
    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Name == "BeamPart" then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
                descendant.Transparency = 1
            else
                descendant.Anchored = descendant.Name == "HumanoidRootPart"
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end
    end
end

local function setMiniRigVisible(p12, p13) -- line: 307
    local v16 = if p13 then 0 else 1

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Name ~= "BeamPart" then
                descendant.LocalTransparencyModifier = v16
            end
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = p13 and 0 or 1
        elseif (descendant:IsA("Beam") or descendant:IsA("Trail")) and descendant:FindFirstAncestor("BeamPart") == nil then
            descendant.Enabled = p13
        end
    end
end

local t2 = {
    LeftUpperArm = true,
    LeftLowerArm = true,
    LeftHand = true,
    RightUpperArm = true,
    RightLowerArm = true,
    RightHand = true
}

local function setMiniRigArmsOnlyVisible(p14) -- line: 340
    -- upvalues: t2 (copy)
    for _, descendant in p14:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Name ~= "BeamPart" then
                local v17 = t2[descendant.Name] ~= nil

                if not v17 then
                    v17 = descendant.Parent ~= nil
                    v17 = v17 and t2[descendant.Parent.Name] ~= nil
                end

                descendant.LocalTransparencyModifier = v17 and 0 or 1
            end
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            local Parent = descendant.Parent

            if Parent ~= nil then
                Parent = Parent.Name
            end

            descendant.Transparency = (Parent == nil or t2[Parent] == nil) and 1 or 0
        end
    end
end

local function enterMiniRigCutsceneMode(p15) -- line: 370
    local t3 = {}

    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t3, {
                part = descendant,
                canCollide = descendant.CanCollide,
                canQuery = descendant.CanQuery,
                canTouch = descendant.CanTouch,
                massless = descendant.Massless
            })
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
            descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end

    local Humanoid = p15:FindFirstChildOfClass("Humanoid")
    local v18 = if Humanoid == nil then Humanoid else Humanoid.AutoRotate

    if Humanoid ~= nil then
        Humanoid.AutoRotate = false
    end

    return function() -- line: 400
        -- upvalues: t3 (copy), Humanoid (copy), v18 (copy)
        for _, v19 in t3 do
            if v19.part.Parent ~= nil then
                v19.part.CanCollide = v19.canCollide
                v19.part.CanQuery = v19.canQuery
                v19.part.CanTouch = v19.canTouch
                v19.part.Massless = v19.massless
            end
        end

        if Humanoid ~= nil and Humanoid.Parent ~= nil and v18 ~= nil then
            Humanoid.AutoRotate = v18
        end
    end
end

local function ensureMiniRigHeadAnimatable(p16, p17) -- line: 422
    -- upvalues: RunService (copy)
    local v20 = p16:FindFirstChild("Head", true)
    local v21, v22

    if v20 ~= nil then
        if v20:IsA("BasePart") then
            v21 = p16:FindFirstChild("UpperTorso", true)

            if v21 ~= nil and not v21:IsA("BasePart") then
                v21 = nil
            end

            v22 = false
        else
            v22 = true
        end
    else
        v22 = true
    end

    if v22 then
        warn("[RareFish] Head not found; cannot make head animatable")

        return nil
    end

    local v23 = p16:FindFirstChild("Neck", true)
    local v24 = true

    if v23 ~= nil then
        if v23:IsA("Motor6D") then
            if v23.Part1 ~= v20 then
                v23.Part1 = v20
            end

            v24 = false
        end
    end

    if v24 then
        if v21 ~= nil then
            for _, descendant in p16:GetDescendants() do
                if descendant:IsA("WeldConstraint") and (descendant.Part0 == v20 or descendant.Part1 == v20) then
                    descendant:Destroy()
                end
            end

            local NeckRigAttachment = v21:FindFirstChild("NeckRigAttachment")
            local NeckRigAttachment2 = v20:FindFirstChild("NeckRigAttachment")
            local Motor6D = Instance.new("Motor6D")

            Motor6D.Name = "Neck"
            Motor6D.Part0 = v21
            Motor6D.Part1 = v20

            if NeckRigAttachment ~= nil and NeckRigAttachment:IsA("Attachment") and NeckRigAttachment2 ~= nil and NeckRigAttachment2:IsA("Attachment") then
                Motor6D.C0 = NeckRigAttachment.CFrame
                Motor6D.C1 = NeckRigAttachment2.CFrame
            else
                Motor6D.C0 = v21.CFrame:Inverse() * v20.CFrame
                Motor6D.C1 = CFrame.new()
                warn("[RareFish] NeckRigAttachment missing — rebuilt Neck from current pose")
            end

            Motor6D.Parent = v20
        else
            warn("[RareFish] UpperTorso not found; cannot rebuild Neck joint")
        end
    else
        if v23.Part0 == nil and v21 ~= nil then
            v23.Part0 = v21
        end

        v23.Enabled = true
    end

    v20.Anchored = false
    p17:GiveTask(RunService.RenderStepped:Connect(function() -- line: 472
        -- upvalues: v20 (copy)
        if v20.Parent == nil then
            return nil
        end

        if v20.Anchored then
            v20.Anchored = false
        end
    end))
end

local function warnIfMiniRigHeadInvalid(p18) -- line: 481
    local v25 = p18:FindFirstChild("Head", true)
    local v26 = p18:FindFirstChild("Neck", true)

    if v25 == nil then
        warn("[ApexSkillCheck] MiniPlayerRig head not found")
    end

    if v26 == nil or not v26:IsA("Motor6D") then
        warn("[ApexSkillCheck] MiniPlayerRig neck Motor6D not found")
    end
end

local function findAfterRareFishCameraFolder() -- line: 491
    -- upvalues: ReplicatedStorage (copy), Workspace (copy)
    local RareFishSkillCheck = ReplicatedStorage:FindFirstChild("RareFishSkillCheck")

    if RareFishSkillCheck ~= nil then
        RareFishSkillCheck = RareFishSkillCheck:FindFirstChild("Camera")

        if RareFishSkillCheck ~= nil then
            RareFishSkillCheck = RareFishSkillCheck:FindFirstChild("AfterRareFishSC")
        end
    end

    local Camera = ReplicatedStorage:FindFirstChild("Camera")

    if Camera ~= nil then
        Camera = Camera:FindFirstChild("AfterRareFishSC")
    end

    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    if Assets ~= nil then
        Assets = Assets:FindFirstChild("Camera")

        if Assets ~= nil then
            Assets = Assets:FindFirstChild("AfterRareFishSC")
        end
    end

    local Camera2 = Workspace:FindFirstChild("Camera")

    if Camera2 ~= nil then
        Camera2 = Camera2:FindFirstChild("AfterRareFishSC")
    end

    local Cutscenes = Workspace:FindFirstChild("Cutscenes")

    if Cutscenes ~= nil then
        Cutscenes = Cutscenes:FindFirstChild("Camera")

        if Cutscenes ~= nil then
            Cutscenes = Cutscenes:FindFirstChild("AfterRareFishSC")
        end
    end

    for _, v27 in { RareFishSkillCheck, Camera, Assets, Camera2, Cutscenes } do
        if v27 ~= nil and v27:IsA("Folder") then
            return v27
        end
    end

    warn("[AfterRareFishSC] Camera/AfterRareFishSC folder not found in expected locations")

    return nil
end

local function getMoonFrameNumber(p19) -- line: 530
    local v28 = tonumber(p19.Name)

    if v28 ~= nil then
        return v28
    end

    local Parent = p19.Parent

    if Parent ~= nil then
        Parent = Parent.Name
    end

    return (tonumber(Parent))
end

local function playMoonAnimatorCameraFolder(p20, p21, p22) -- line: 541
    -- upvalues: RuntimeLib (copy), Maid (copy), RunService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return RuntimeLib.Promise.resolve()
    end

    local Frames = p20:FindFirstChild("Frames")
    local FOV = p20:FindFirstChild("FOV")
    local Settings = p20:FindFirstChild("Settings")
    local n1 = 24
    local v29

    if Settings ~= nil then
        local FPS = Settings:FindFirstChild("FPS")

        if FPS ~= nil then
            if FPS:IsA("NumberValue") then
                local Value = FPS.Value

                v29 = Value
                n1 = Value
            else
                v29 = 24
            end
        else
            v29 = 24
        end
    else
        v29 = 24
    end

    local t5 = {}

    if Frames ~= nil then
        for _, descendant in Frames:GetDescendants() do
            if descendant:IsA("CFrameValue") then
                local v30 = tonumber(descendant.Name)

                if v30 == nil then
                    local Parent = descendant.Parent

                    if Parent ~= nil then
                        Parent = Parent.Name
                    end

                    v30 = tonumber(Parent)
                end

                if v30 ~= nil then
                    table.insert(t5, {
                        frame = v30,
                        cframe = descendant.Value
                    })
                end
            end
        end
    end

    table.sort(t5, function(p23, p24) -- line: 572
        return p23.frame < p24.frame
    end)

    local t7 = {}

    if FOV ~= nil then
        for _, descendant in FOV:GetDescendants() do
            if descendant:IsA("NumberValue") then
                local v31 = tonumber(descendant.Name)

                if v31 == nil then
                    local Parent = descendant.Parent

                    if Parent ~= nil then
                        Parent = Parent.Name
                    end

                    v31 = tonumber(Parent)
                end

                if v31 ~= nil then
                    table.insert(t7, {
                        frame = v31,
                        fov = descendant.Value
                    })
                end
            end
        end
    end

    table.sort(t7, function(p25, p26) -- line: 591
        return p25.frame < p26.frame
    end)

    if #t5 == 0 then
        warn("[AfterRareFishSC] Camera folder Frames has no CFrameValue children — skipping camera folder")

        return RuntimeLib.Promise.resolve()
    end

    local frame = t5[#t5].frame
    local v32 = frame / v29

    local function v33(p27) -- line: 600
        -- upvalues: t5 (copy)
        if #t5 == 1 then
            return t5[1].cframe
        end

        local v34 = t5[1]
        local v35 = t5[#t5]

        for i = 0, #t5 - 2 do
            if t5[i + 1].frame <= p27 and p27 <= t5[i + 2].frame then
                v34 = t5[i + 1]
                v35 = t5[i + 2]
                break
            end
        end

        local v36 = v35.frame - v34.frame
        local v37 = if v36 > 0 then math.clamp((p27 - v34.frame) / v36, 0, 1) else 0

        return v34.cframe:Lerp(v35.cframe, v37)
    end

    local function v39(p28) -- line: 617
        -- upvalues: t7 (copy)
        if #t7 == 0 then
            return nil
        end

        if #t7 == 1 then
            return t7[1].fov
        end

        local v40 = t7[1]
        local v41 = t7[#t7]

        for i = 0, #t7 - 2 do
            if t7[i + 1].frame <= p28 and p28 <= t7[i + 2].frame then
                v40 = t7[i + 1]
                v41 = t7[i + 2]
                break
            end
        end

        local v42 = v41.frame - v40.frame
        local v43 = if v42 > 0 then math.clamp((p28 - v40.frame) / v42, 0, 1) else 0

        return v40.fov + (v41.fov - v40.fov) * v43
    end

    return RuntimeLib.Promise.new(function(p29) -- line: 637
        -- upvalues: p21 (copy), p22 (copy), CurrentCamera (copy), n1 (ref), frame (copy), v32 (copy), v33 (copy), v39 (copy), Maid (copy), RunService (copy)
        local elapsed = os.clock()
        local v45 = Maid.new()
        local v46 = false

        local function v47() -- line: 641
            -- upvalues: p29 (copy), v45 (copy), v46 (ref)
            if v46 then
                return nil
            end

            v46 = true
            v45:Destroy()
            p29()
        end

        if p22 ~= nil then
            p22:GiveTask(v47)
        end

        v45:GiveTask(task.delay(v32 + 0.5, v47))
        v45:GiveTask(RunService.RenderStepped:Connect(function() -- line: 656
            -- upvalues: p29 (copy), elapsed (copy), v45 (copy), v46 (ref), p21 (copy), CurrentCamera (copy), n1 (ref), frame (copy), v33 (copy), v39 (copy)
            if CurrentCamera.Parent == nil then
                if not v46 then
                    v46 = true
                    v45:Destroy()
                    p29()
                end

                return nil
            end

            local v49 = math.min((os.clock() - elapsed) * n1, frame)
            local v50 = v33(v49)

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CFrame = if p21 ~= nil then p21.CFrame * v50 else v50

            local v51 = v39(v49)

            if v51 ~= nil then
                CurrentCamera.FieldOfView = v51
            end

            if not (frame <= v49) or v46 then
                return
            end

            v46 = true
            v45:Destroy()
            p29()
        end))
    end)
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 679
        return "FishingRodController"
    end
})

self.__index = self

function self.new(...) -- line: 684
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p30, p31) -- line: 688
    -- upvalues: Maid (copy)
    p30._soundController = p31
    p30._cameraMaid = Maid.new()
    p30._hiddenFish = {}
    p30._apexReelSuppressionIds = {}
    p30._isApexCutscenePlaying = false
    p30._isReelCameraPlaying = false
    p30._debugUnstreamCaughtFish = false
end

function self.onStart(p32) -- line: 697
    -- upvalues: hapticBonusRoll (copy), subscribe (copy), CollectionService (copy), Players (copy), RunService (copy), Workspace (copy), events (copy), clientProducer (copy), catchFadeAtom (copy), fishingMovementLockedAtom (copy), hookHrpAtom (copy), hookLandedPositionAtom (copy), selectLocalPlayerHook (copy), selectPlayerFishingState (copy), selectPlayerFishingCaughtFishName (copy), selectCastCutsceneAnimationEnded (copy), selectHoopTestingEnabled (copy), playZoneChangeOnRig (copy)
    local v54 = tostring(Players.LocalPlayer.UserId)
    local v55 = selectPlayerFishingState(v54)(clientProducer:getState())
    local v56 = fishingMovementLockedAtom()
    local v57 = v56

    if v56 then
        local v58 = if v55 == nil then v55 else v55.castTimestamp

        p32._movementLockStartedAt = if v58 == nil then Workspace:GetServerTimeNow() else v58
    end

    subscribe(fishingMovementLockedAtom, function(p33) -- line: 712
        -- upvalues: p32 (copy), v57 (ref), Workspace (copy)
        if not p33 or v57 then
            if not p33 then
                p32._movementLockStartedAt = nil
            end
        else
            p32._movementLockStartedAt = Workspace:GetServerTimeNow()
        end

        v57 = p33
    end)

    if v55 ~= nil then
        v55 = v55.castTimestamp
    end

    local v59 = v55

    clientProducer:subscribe(selectPlayerFishingState(v54), function(p34) -- line: 725
        -- upvalues: p32 (copy), v59 (ref), fishingMovementLockedAtom (copy)
        if (if p34 == nil then p34 else p34.castTimestamp) ~= nil then
            v59 = p34.castTimestamp

            if fishingMovementLockedAtom() and p32._movementLockStartedAt == nil then
                p32._movementLockStartedAt = p34.castTimestamp
            end

            return nil
        end

        if (if p34 == nil then p34 else p34.fishingState) ~= nil or p32:_movementLockStartedAfter(v59) then
            return nil
        end

        p32:_onAuthoritativeFishingSessionEnded()
    end)
    events.fishingSessionEnded:connect(function(p35) -- line: 751
        -- upvalues: p32 (copy)
        if p32:_movementLockStartedAfter(p35) then
            return nil
        end

        p32:_onAuthoritativeFishingSessionEnded()
    end)
    CollectionService:GetInstanceAddedSignal("FishingZoneFish"):Connect(function(p36) -- line: 757
        -- upvalues: p32 (copy)
        if not p36:IsA("Model") or p36.Name ~= p32._activeApexFishId then
            return nil
        end

        local Highlight = p36:FindFirstChildOfClass("Highlight")

        if Highlight ~= nil then
            Highlight:Destroy()
        end

        p32:_setFishVisibility(p36, false)
    end)
    CollectionService:GetInstanceAddedSignal("CastReplicationFocus"):Connect(function(p37) -- line: 770
        -- upvalues: v54 (copy), subscribe (copy), RunService (copy), hookHrpAtom (copy)
        if not p37:IsA("BasePart") or p37:GetAttribute("casterUserId") ~= v54 then
            return nil
        end

        local connection
        local v61 = subscribe(hookHrpAtom, function(p38) -- line: 779
            -- upvalues: p37 (copy), connection (ref), RunService (copy)
            local connection2 = connection

            if connection2 ~= nil then
                connection2:Disconnect()
            end

            connection = nil

            if p38 == nil then
                return nil
            end

            connection = RunService.Heartbeat:Connect(function() -- line: 788
                -- upvalues: p38 (copy), p37 (copy), connection (ref)
                if not p37.Parent then
                    local connection2 = connection

                    if connection2 ~= nil then
                        connection2:Disconnect()
                    end

                    return nil
                end

                p37.CFrame = CFrame.new(p38.Position)
            end)
        end)

        p37.Destroying:Connect(function() -- line: 799
            -- upvalues: connection (ref), v61 (copy)
            v61()

            local connection2 = connection

            if connection2 ~= nil then
                connection2:Disconnect()
            end
        end)
    end)
    events.otherPlayerStartedFishing:connect(function(p39, p40, p41) -- line: 807
        -- upvalues: clientProducer (copy)
        clientProducer.otherPlayerCastReceived({
            casterUserId = p39,
            castParams = p40,
            castTimestamp = p41
        })
    end)
    events.otherPlayerStoppedFishing:connect(function(p42) -- line: 814
        -- upvalues: clientProducer (copy)
        clientProducer.otherPlayerCastRemoved({
            casterUserId = p42
        })
    end)
    subscribe(hookLandedPositionAtom, function(p43) -- line: 819
        -- upvalues: p32 (copy)
        p32._cameraMaid:DoCleaning()

        if p43 == nil then
            return nil
        end

        p32._soundController:fadeFlyMusicVolume(0.6, 0.8)
        p32:_startNibbleCamera(p43)
    end)
    clientProducer:subscribe(selectCastCutsceneAnimationEnded, function(p44) -- line: 831
        -- upvalues: p32 (copy)
        if p44 then
            p32._soundController:playFlyMusic()
        end
    end)
    clientProducer:subscribe(selectPlayerFishingCaughtFishName(v54), function(p45) -- line: 839
        -- upvalues: p32 (copy), v54 (copy), Players (copy), clientProducer (copy), hookHrpAtom (copy), selectLocalPlayerHook (copy), playZoneChangeOnRig (copy)
        if p45 == nil then
            return nil
        end

        p32._soundController:fadeFlyMusicVolume(0.3)

        local v63 = hookHrpAtom()

        if v63 ~= nil then
            v63 = v63.Parent
        end

        if v63 ~= nil then
            playZoneChangeOnRig(v63)
        end

        local v64 = selectLocalPlayerHook(v54)(clientProducer:getState())

        if v64 ~= nil then
            v64 = v64.apexFishId
        end

        if v64 ~= nil then
            return
        end

        local Character = Players.LocalPlayer.Character

        if Character ~= nil then
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        if Character == nil then
            return
        end

        task.spawn(function() -- line: 868
            -- upvalues: Character (ref), Players (copy)
            return Players.LocalPlayer:RequestStreamAroundAsync(Character.Position, 0)
        end)
    end)

    local v65

    clientProducer:subscribe(selectLocalPlayerHook(v54), function(p46) -- line: 875
        -- upvalues: p32 (copy), v65 (ref), hapticBonusRoll (copy), hookHrpAtom (copy), playZoneChangeOnRig (copy)
        local v67 = if p46 == nil then p46 else p46.phase

        if v67 == "bonusWaveIntermission" and v65 ~= "bonusWaveIntermission" then
            p32._soundController:fadeFlyMusicVolume(0.3)
            hapticBonusRoll()

            local v68 = hookHrpAtom()

            if v68 ~= nil then
                v68 = v68.Parent
            end

            if v68 ~= nil then
                playZoneChangeOnRig(v68)
            end
        end

        v65 = v67
    end)
    events.apexFishCaught:connect(function(p47, p48, p49, p50, p51, p52, p53) -- line: 897
        -- upvalues: p32 (copy), v54 (copy), events (copy), clientProducer (copy), catchFadeAtom (copy), selectHoopTestingEnabled (copy)
        print((("[BossAutokill] client received fish=%* route=%*"):format(p49, p53)))
        p32._apexReelSuppressionIds[p47] = true
        task.delay(60, function() -- line: 902
            -- upvalues: p47 (copy), p32 (copy)
            local _apexReelSuppressionIds = p32._apexReelSuppressionIds
            local v69 = _apexReelSuppressionIds[p47] ~= nil

            _apexReelSuppressionIds[p47] = nil

            return v69
        end)

        if p32._lastReelFishId == p47 then
            local _stopReelCamera = p32._stopReelCamera

            p32._stopReelCamera = nil
            p32._isReelCameraPlaying = false
            p32:_runCleanupStep("stop reel that arrived before Apex event", function() -- line: 915
                -- upvalues: _stopReelCamera (copy)
                local v70 = _stopReelCamera

                if _stopReelCamera ~= nil then
                    v70 = _stopReelCamera()
                end

                return v70
            end)
            p32:_runCleanupStep("clear pre-Apex reel fade", function() -- line: 922
                -- upvalues: catchFadeAtom (copy)
                return catchFadeAtom(nil)
            end)
        end

        if p32._movementLockStartedAt ~= nil and p48 < p32._movementLockStartedAt then
            p32:_runCleanupStep("finish stale Apex session on server", function() -- line: 929
                -- upvalues: p47 (copy), events (copy)
                return events.apexCutsceneFinished(p47)
            end)

            return nil
        end

        if selectHoopTestingEnabled(v54)(clientProducer:getState()) then
            print((("[BossAutokill] hoop_testing active — skipping boss presentation for fish=%*"):format(p49)))
            p32:_completeApexCatch(p47)

            return nil
        end

        p32._isApexCutscenePlaying = true

        local function v71() -- line: 940
            -- upvalues: p47 (copy), p49 (copy), p50 (copy), p51 (copy), p52 (copy), p53 (copy), p32 (copy)
            p32:_startApexSkillCheck(p47, p49, p50, p51, p52, p53)
        end

        local ok, result = pcall(v71)

        if not ok then
            warn(("[ApexSkillCheck] setup failed for %*; completing without presentation:"):format(p49), result)
            p32:_completeApexCatch(p47)
        end
    end)
    events.reelStarted:connect(function(p54, p55, p56, p57, p58, p59) -- line: 948
        -- upvalues: p32 (copy), v54 (copy), CollectionService (copy), clientProducer (copy), selectHoopTestingEnabled (copy)
        p32._soundController:stopFlyMusic(0.5)
        p32._lastReelFishId = p59

        if selectHoopTestingEnabled(v54)(clientProducer:getState()) then
            return nil
        end

        local _apexReelSuppressionIds = p32._apexReelSuppressionIds
        local v72 = _apexReelSuppressionIds[p59] ~= nil

        _apexReelSuppressionIds[p59] = nil

        if v72 then
            return nil
        end

        if p32._debugUnstreamCaughtFish then
            p32:_debugForceUnstreamCaughtFish(p59)
        end

        p32:_hideFishZoneModels(p59)

        if p32._isApexCutscenePlaying then
            return nil
        end

        local v73

        for v74, v75 in (CollectionService:GetTagged("FishingZoneFish")) do
            local _ = v74 - 1

            if v75.Name == p59 == true then
                v73 = v75
                break
            end

            v73 = nil
        end

        if if v73 == nil then v73 else v73:IsA("Model") then
            p32:_setFishVisibility(v73, true)
        end

        p32:_onReelStarted(p54, p55, p56, p57, p58)
    end)
end

function self._startApexSkillCheck(p60, p61, p62, p63, p64, p65, p66) -- line: 1001
    -- upvalues: Maid (copy), Players (copy), Workspace (copy), events (copy), apexAfterRareFishCutsceneAtom (copy), apexSkillCheckAtom (copy), hookHrpAtom (copy), rareFishTransitionAtom (copy), rareFishTransitionDurationSec (copy), fishDataByName (copy), isFishData (copy), animations (copy), startRareFishBossPov (copy), getRigAnimator (copy), setMiniRigBeamVisible (copy), setMiniRigVisible (copy), ensureMiniRigHeadAnimatable (copy), warnIfMiniRigHeadInvalid (copy)
    p60._activeApexFishId = p61
    apexAfterRareFishCutsceneAtom(false)
    rareFishTransitionAtom({
        fishName = p62
    })
    p60._soundController:stopFlyMusic(0.3)
    p60._soundController:playRareFishEncounter(rareFishTransitionDurationSec)

    local v76 = p60:_findRewardModel(p61)

    print(("[BossAutokill] fish=%* route=%* "):format(p62, p66) .. ("targetModelExists=%*"):format(v76 ~= nil))

    if v76 ~= nil then
        local Highlight = v76:FindFirstChildOfClass("Highlight")

        if Highlight ~= nil then
            Highlight:Destroy()
        end

        p60:_setFishVisibility(v76, true)
    end

    p60:_hideFishZoneModels(p61)

    local v77 = fishDataByName[p62]

    if v77 ~= nil and isFishData(v77) then
        local v78 = hookHrpAtom()

        if v78 ~= nil then
            v78 = v78.Parent
        end

        if v78 ~= nil then
            setMiniRigBeamVisible(v78, false)
            p60._cameraMaid:DoCleaning()

            local CurrentCamera = Workspace.CurrentCamera
            local v79 = v76 or v77.model
            local v80 = if v76 == nil then v76 else v76:GetPivot().Position

            if v79 ~= nil and CurrentCamera ~= nil then
                if v76 ~= nil then
                    p60:_setFishVisibility(v76, false)
                end

                local v81 = Maid.new()

                p60._apexSkillCheckMaid = v81

                local t12 = {
                    brace = animations.holdReleaseBrace,
                    counter = animations.actionCounter,
                    punch = animations.actionPunch,
                    slap = animations.actionSlap,
                    surge = animations.holdReleaseSurge,
                    yank = animations.holdReleaseYank
                }
                local t13 = {}
                local v82 = getRigAnimator(v78)

                if v82 ~= nil then
                    warnIfMiniRigHeadInvalid(v78)
                    ensureMiniRigHeadAnimatable(v78, v81)

                    local Animation = Instance.new("Animation")

                    Animation.AnimationId = animations.idleFloat

                    local track = v82:LoadAnimation(Animation)

                    track.Priority = Enum.AnimationPriority.Idle
                    track.Looped = true
                    track:Play()
                    v81:GiveTask(function() -- line: 1094
                        -- upvalues: track (copy)
                        return track:Stop()
                    end)

                    local t14 = {}

                    for v83, v84 in pairs(t12) do
                        local v85 = t14[v84]

                        if v85 == nil then
                            local Animation = Instance.new("Animation")

                            Animation.AnimationId = v84

                            local track = v82:LoadAnimation(Animation)

                            track.Priority = Enum.AnimationPriority.Action3
                            track.Looped = false
                            t14[v84] = track
                            v81:GiveTask(function() -- line: 1110
                                -- upvalues: track (copy)
                                return track:Stop()
                            end)
                            v85 = track
                        end

                        t13[v83] = v85
                    end
                end

                local v86 = startRareFishBossPov({
                    aimPosition = v80,
                    camera = CurrentCamera,
                    fishModel = v79,
                    rig = v78
                })

                p60._bossPovHandle = v86
                v81:GiveTask(function() -- line: 1129
                    -- upvalues: v86 (copy)
                    return v86:destroy()
                end)
                setMiniRigVisible(v78, false)

                local v87 = v78

                v81:GiveTask(function() -- line: 1137
                    -- upvalues: v87 (copy), setMiniRigVisible (copy)
                    return setMiniRigVisible(v87, true)
                end)

                local function v88(p67) -- line: 1142
                    -- upvalues: t13 (copy), v86 (copy)
                    v86:reactToHit(p67)

                    if p67.rating == "miss" then
                        return
                    end

                    local v89 = t13[p67.action]

                    if v89 == nil then
                        return
                    end

                    v89:Stop(0)
                    v89:Play(0)
                    v89.TimePosition = 0
                end

                local function v90(p68) -- line: 1156
                    -- upvalues: v86 (copy)
                    v86:setPhase(p68)
                end

                local function v91(p69) -- line: 1159
                    -- upvalues: v86 (copy)
                    v86:telegraphPrompt(p69)
                end

                local function v92() -- line: 1162
                    -- upvalues: v86 (copy)
                    v86:playSuccessCutscene()
                end

                local function v93(p70) -- line: 1165
                    -- upvalues: p60 (copy), p61 (copy), p62 (copy), p63 (copy), p64 (copy), p65 (copy), p66 (copy), v87 (copy), Players (copy), Workspace (copy), events (copy), apexAfterRareFishCutsceneAtom (copy), apexSkillCheckAtom (copy), setMiniRigVisible (copy)
                    local ok, result

                    if p70 then
                        local function v94() -- line: 1167
                            -- upvalues: p60 (copy), p61 (copy), p62 (copy), p63 (copy), p64 (copy), p65 (copy), p66 (copy), v87 (copy), Players (copy), Workspace (copy), events (copy), apexAfterRareFishCutsceneAtom (copy), apexSkillCheckAtom (copy), setMiniRigVisible (copy)
                            if p66 == "skillCheck" then
                                events.analyticsApexSkillCheckPassed:fire()
                            end

                            apexAfterRareFishCutsceneAtom(true)
                            apexSkillCheckAtom(nil)

                            local _bossPovHandle = p60._bossPovHandle

                            if _bossPovHandle ~= nil then
                                _bossPovHandle:destroy()
                            end

                            p60._bossPovHandle = nil

                            local CurrentCamera = Workspace.CurrentCamera

                            if CurrentCamera ~= nil then
                                CurrentCamera.FieldOfView = 70
                            end

                            local LocalPlayer = Players.LocalPlayer

                            LocalPlayer.CameraMinZoomDistance = 0.5
                            LocalPlayer.CameraMaxZoomDistance = 128
                            setMiniRigVisible(v87, true)
                            task.spawn(function() -- line: 1187
                                -- upvalues: p60 (copy), p61 (copy), p62 (copy), p63 (copy), p64 (copy), p65 (copy), v87 (copy), apexAfterRareFishCutsceneAtom (copy)
                                local function v95() -- line: 1188
                                    -- upvalues: p60 (copy), p61 (copy), p62 (copy), p63 (copy), p64 (copy), p65 (copy), v87 (copy)
                                    local v96, v97 = p60:_playAfterRareFishSkillCheckCutscene(v87):await()

                                    if not v96 then
                                        warn("[RareFish] AfterRareFishSC rejected; continuing reward drop", v97)
                                    end

                                    p60:_cleanupApexSkillCheck(false, false)
                                    p60:_runCleanupStep("stop rare-fish audio before fish fall", function() -- line: 1196
                                        -- upvalues: p60 (copy)
                                        return p60._soundController:stopRareFishAudio()
                                    end)
                                    p60._soundController:playSfxInstant("JackpotFishSuccess")
                                    p60:_playApexCutscene(p61, p62, p63, p64, p65)
                                end

                                local ok, result = pcall(v95)

                                if not ok then
                                    warn(("[ApexSkillCheck] success continuation failed for %*; "):format(p62) .. "completing without presentation", result)
                                    p60:_completeApexCatch(p61)
                                end

                                p60:_runCleanupStep("clear post-Boss cutscene state", function() -- line: 1207
                                    -- upvalues: apexAfterRareFishCutsceneAtom (copy)
                                    return apexAfterRareFishCutsceneAtom(false)
                                end)
                            end)
                        end

                        ok, result = pcall(v94)
                    else
                        p60:_runCleanupStep("stop rare-fish audio after Boss failure", function() -- line: 1217
                            -- upvalues: p60 (copy)
                            return p60._soundController:stopRareFishAudio()
                        end)
                        p60:_onApexSkillCheckFailure(p61)
                    end

                    if not (p70 and ok or not p70) then
                        warn(("[ApexSkillCheck] success setup failed for %*; "):format(p62) .. "completing without presentation", result)
                        p60:_completeApexCatch(p61)
                    end
                end

                v81:GiveTask(task.delay(rareFishTransitionDurationSec, function() -- line: 1227
                    -- upvalues: p60 (copy)
                    return p60._soundController:playRareFishMusic()
                end))
                apexSkillCheckAtom({
                    fishData = v77,
                    fishId = p61,
                    mutations = p65,
                    route = p66,
                    onComplete = v93,
                    onFailed = function() -- line: 1230
                        -- upvalues: Players (copy)
                        local LocalPlayer = Players.LocalPlayer
                        local Character = LocalPlayer.Character

                        if Character ~= nil then
                            Character = Character:GetPivot().Position
                        end

                        if Character == nil then
                            return
                        end

                        task.spawn(function() -- line: 1238
                            -- upvalues: LocalPlayer (copy), Character (ref)
                            return LocalPlayer:RequestStreamAroundAsync(Character, 0)
                        end)
                    end,
                    onHit = v88,
                    onPhaseChanged = v90,
                    onSuccessCutscene = v92,
                    getBossFishPivot = function() -- getBossFishPivot | line: 1253
                        -- upvalues: p60 (copy)
                        local _bossPovHandle = p60._bossPovHandle

                        if _bossPovHandle ~= nil then
                            _bossPovHandle = _bossPovHandle:getFishPivot()
                        end

                        return _bossPovHandle
                    end,
                    onTelegraph = v91
                })

                return
            end

            warn("[ApexSkillCheck] Missing Apex source model or camera — falling through to cutscene")
        else
            warn("[ApexSkillCheck] Active MiniPlayerRig not found — falling through to cutscene")
        end

        p60:_playApexCutscene(p61, p62, p63, p64, p65)

        return nil
    end

    p60:_playApexCutscene(p61, p62, p63, p64, p65)

    return nil
end

function self._cleanupApexSkillCheck(p71, p72, p73) -- line: 1263
    -- upvalues: Players (copy), Workspace (copy), apexSkillCheckAtom (copy), hookHrpAtom (copy), setMiniRigBeamVisible (copy)
    local v99 = p72 == nil or p72
    local v100 = p73 == nil or p73

    apexSkillCheckAtom(nil)

    if v100 then
        p71._soundController:stopRareFishAudio()
    end

    local _apexSkillCheckMaid = p71._apexSkillCheckMaid

    if _apexSkillCheckMaid ~= nil then
        _apexSkillCheckMaid:Destroy()
    end

    p71._apexSkillCheckMaid = nil
    p71._bossPovHandle = nil

    local v101 = hookHrpAtom()

    if v101 ~= nil then
        v101 = v101.Parent
    end

    if v101 ~= nil then
        setMiniRigBeamVisible(v101, false)
    end

    if not v99 then
        return nil
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom

    local CurrentCamera2 = Workspace.CurrentCamera

    if CurrentCamera2 ~= nil then
        CurrentCamera2.FieldOfView = 70
    end

    local LocalPlayer = Players.LocalPlayer

    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 128

    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if Character ~= nil then
        CurrentCamera.CameraSubject = Character
    end
end

function self._playAfterRareFishSkillCheckCutscene(p74, p75) -- line: 1311
    -- upvalues: RuntimeLib (copy), Maid (copy), Players (copy), RunService (copy), Workspace (copy), playClonedVfxWithSound (copy), animations (copy), getRigAnimator (copy), getRigCameraReference (copy), setMiniRigBeamVisible (copy), prepareMiniRigForCutsceneAnimation (copy), setMiniRigVisible (copy), enterMiniRigCutsceneMode (copy), ensureMiniRigHeadAnimatable (copy), warnIfMiniRigHeadInvalid (copy), findAfterRareFishCameraFolder (copy), playMoonAnimatorCameraFolder (copy)
    local v102 = getRigAnimator(p75)

    if v102 == nil then
        warn("[RareFish] Cannot play AfterRareFishSC: missing Animator")

        return RuntimeLib.Promise.resolve()
    end

    local v103 = getRigCameraReference(p75)

    if v103 == nil then
        warn("[RareFish] Cannot play AfterRareFishSC: missing MiniRig root")
    end

    warnIfMiniRigHeadInvalid(p75)
    prepareMiniRigForCutsceneAnimation(p75)

    local v104 = enterMiniRigCutsceneMode(p75)

    setMiniRigBeamVisible(p75, true)

    local Animation = Instance.new("Animation")

    Animation.Name = "AfterRareFishSCAnimation"
    Animation.AnimationId = animations.afterRareFishSkillCheck

    local track = v102:LoadAnimation(Animation)

    track.Priority = Enum.AnimationPriority.Action4
    track.Looped = false

    local v105 = Maid.new()

    ensureMiniRigHeadAnimatable(p75, v105)

    local v106 = p75:FindFirstChild("BeamPart", true)

    if v106 ~= nil and v106:IsA("BasePart") then
        v105:GiveTask(RunService.RenderStepped:Connect(function() -- line: 1344
            -- upvalues: p75 (copy), v106 (copy)
            if v106.Parent == nil then
                return nil
            end

            local Position = p75:GetPivot().Position

            v106.CFrame = CFrame.new(Position + Vector3.new(0, 6, 0))
        end))
    end

    local v107 = false
    local v108

    v105:GiveTask(track:GetMarkerReachedSignal("HideMiniRig"):Connect(function() -- line: 1374
        -- upvalues: p75 (copy), v107 (ref), v108 (ref), setMiniRigBeamVisible (copy), setMiniRigVisible (copy)
        if v107 then
            return
        end

        v107 = true
        setMiniRigVisible(p75, false)
        setMiniRigBeamVisible(p75, false)

        local v110 = v108

        if v110 ~= nil then
            v110()
        end
    end))

    local v111 = false

    local function v112() -- line: 1381
        -- upvalues: p74 (copy), p75 (copy), v111 (ref), Players (copy), playClonedVfxWithSound (copy)
        if v111 then
            return nil
        end

        v111 = true
        task.spawn(function() -- line: 1386
            -- upvalues: Players (copy)
            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                Character = Character:GetPivot().Position
            end

            if Character ~= nil then
                Players.LocalPlayer:RequestStreamAroundAsync(Character, 0)
            end
        end)
        p74._soundController:playSfxInstant("BubblesUp")

        local v113 = p75:FindFirstChild("RightLowerLeg", true)

        if not (if v113 == nil then v113 else v113:IsA("BasePart")) then
            v113 = nil
            warn("[ApexSkillCheck] BubblesUp VFX: MiniPlayerRig RightLowerLeg not found")
        end

        local v114 = p75:FindFirstChild("LeftLowerLeg", true)

        if not (if v114 == nil then v114 else v114:IsA("BasePart")) then
            v114 = nil
            warn("[ApexSkillCheck] BubblesUp VFX: MiniPlayerRig LeftLowerLeg not found")
        end

        if v113 ~= nil then
            playClonedVfxWithSound("BubblesUp", "BubblesUp", {
                playSound = false,
                targetPart = v113
            })
        end

        if v114 ~= nil then
            playClonedVfxWithSound("BubblesUp", "BubblesUp", {
                playSound = false,
                targetPart = v114
            })
        end
    end

    v105:GiveTask(track:GetMarkerReachedSignal("BubblesUp"):Connect(v112))
    v105:GiveTask(track.KeyframeReached:Connect(function(p76) -- line: 1416
        -- upvalues: v112 (copy)
        if p76 == "BubblesUp" then
            v112()
        end
    end))

    return RuntimeLib.Promise.new(function(p77) -- line: 1421
        -- upvalues: p75 (copy), v103 (copy), v104 (copy), Animation (copy), track (copy), v105 (copy), v107 (ref), v108 (ref), Players (copy), RunService (copy), Workspace (copy), setMiniRigBeamVisible (copy), setMiniRigVisible (copy), findAfterRareFishCameraFolder (copy), playMoonAnimatorCameraFolder (copy)
        local v115 = false

        local function v116() -- line: 1428
            -- upvalues: p77 (copy), v115 (ref), p75 (copy), v104 (copy), Animation (copy), track (copy), v105 (copy), Players (copy), Workspace (copy), setMiniRigBeamVisible (copy)
            if v115 then
                return nil
            end

            v115 = true
            v105:Destroy()

            if track.IsPlaying then
                track:Stop(0)
            end

            track:Destroy()
            Animation:Destroy()
            setMiniRigBeamVisible(p75, false)

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                CurrentCamera.FieldOfView = 70
            end

            local LocalPlayer = Players.LocalPlayer

            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 128
            v104()
            p77()
        end

        v108 = v116
        v105:GiveTask(track.Stopped:Connect(function() -- line: 1447
            -- upvalues: p75 (copy), v107 (ref), v108 (ref), setMiniRigBeamVisible (copy), setMiniRigVisible (copy)
            if v107 then
                return
            end

            warn("[RareFish] HideMiniRig marker not reached; hiding on animation end")

            if v107 then
                return
            end

            v107 = true
            setMiniRigVisible(p75, false)
            setMiniRigBeamVisible(p75, false)

            local v117 = v108

            if v117 ~= nil then
                v117()
            end
        end))
        v105:GiveTask(task.delay(math.max(track.Length, 0) + 8, function() -- line: 1456
            -- upvalues: v115 (ref), v116 (copy)
            if not v115 then
                warn("[RareFish] AfterRareFishSC timeout fallback")
                v116()
            end
        end))
        track:Play(0.05)

        local v119 = findAfterRareFishCameraFolder()

        if v119 ~= nil and v103 ~= nil then
            playMoonAnimatorCameraFolder(v119, v103, v105)

            return
        end

        if v103 ~= nil then
            warn("[RareFish] Cannot play AfterRareFishSC: missing Camera/AfterRareFishSC folder")

            local CurrentCamera = Workspace.CurrentCamera
            local v120

            if CurrentCamera ~= nil then
                v120 = function() -- line: 1474
                    -- upvalues: CurrentCamera (copy), v103 (copy)
                    if v103.Parent == nil then
                        return nil
                    end

                    local v121 = v103.Position + Vector3.new(0, 2, 0)
                    local v122 = v121 + Vector3.new(0, 2, 8)

                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = CFrame.lookAt(v122, v121)
                end

                if v103.Parent ~= nil then
                    local v123 = v103.Position + Vector3.new(0, 2, 0)
                    local v124 = v123 + Vector3.new(0, 2, 8)

                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = CFrame.lookAt(v124, v123)
                end

                v105:GiveTask(RunService.RenderStepped:Connect(v120))
            end
        end
    end)
end

function self._onApexSkillCheckFailure(p78, p79) -- line: 1492
    -- upvalues: events (copy)
    local v125 = p78:_findRewardModel(p79)

    if v125 ~= nil then
        p78:_runCleanupStep("hide failed Apex model", function() -- line: 1497
            -- upvalues: p78 (copy), v125 (copy)
            local Highlight = v125:FindFirstChildOfClass("Highlight")

            if Highlight ~= nil then
                Highlight:Destroy()
            end

            p78:_setFishVisibility(v125, false)
        end)
    end

    p78:_forceFishingClientCleanup()
    p78:_runCleanupStep("notify server that Apex skill check failed", function() -- line: 1506
        -- upvalues: p79 (copy), events (copy)
        return events.apexSkillCheckFailed(p79)
    end)
    p78:_runCleanupStep("notify server that camera returned after Apex failure", function() -- line: 1509
        -- upvalues: events (copy)
        return events.cameraReturnedToPier:fire()
    end)
end

function self._hideFishZoneModels(p80, p81) -- line: 1513
    -- upvalues: CollectionService (copy)
    for _, v126 in CollectionService:GetTagged("FishingZoneFish") do
        if v126:IsA("Model") and v126.Name ~= p81 then
            p80._hiddenFish[v126] = true
            p80:_setFishVisibility(v126, false)
        end
    end
end

function self._showFishZoneModels(p82) -- line: 1522
    for v127 in p82._hiddenFish do
        p82:_setFishVisibility(v127, true)
    end

    table.clear(p82._hiddenFish)
end

function self.setDebugUnstreamCaughtFish(p83, p84) -- line: 1528
    p83._debugUnstreamCaughtFish = p84
end

function self._debugForceUnstreamCaughtFish(_, p86) -- line: 1531
    -- upvalues: Maid (copy), CollectionService (copy), RunService (copy)
    local v128 = Maid.new()

    local function v129() -- line: 1534
        -- upvalues: p86 (copy), CollectionService (copy)
        for _, v130 in CollectionService:GetTagged("FishingZoneFish") do
            if v130.Name == p86 and v130.Parent ~= nil then
                warn((("[DebugUnstream] destroying caught fish model %*"):format(p86)))
                v130:Destroy()
            end
        end
    end

    v129()
    v128:GiveTask(RunService.Heartbeat:Connect(v129))
    v128:GiveTask(task.delay(12, function() -- line: 1544
        -- upvalues: v128 (copy)
        return v128:Destroy()
    end))
end

function self._setFishVisibility(_, p88, p89) -- line: 1548
    local v131 = if p89 then 0 else 1

    for _, descendant in p88:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name ~= "__FishMouthAnchor" then
            descendant.LocalTransparencyModifier = v131
        end
    end
end

function self._revealApexSilhouette(_) -- line: 1556
    -- upvalues: CollectionService (copy), TweenService (copy)
    for _, v132 in CollectionService:GetTagged("FishingZoneFish") do
        if v132:IsA("Model") then
            local Highlight = v132:FindFirstChildOfClass("Highlight")

            if Highlight then
                local v133 = TweenService:Create(Highlight, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    FillTransparency = 1
                })

                v133.Completed:Connect(function() -- line: 1568
                    -- upvalues: Highlight (copy)
                    return Highlight:Destroy()
                end)
                v133:Play()

                return
            end
        end
    end
end

function self._tweenCFrameValue(_, p92, p93, p94) -- line: 1575
    -- upvalues: TweenService (copy), Workspace (copy)
    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = p92.CFrame
    CFrameValue.Parent = Workspace

    local connection = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 1579
        -- upvalues: p92 (copy), CFrameValue (copy)
        p92.CFrame = CFrameValue.Value
    end)
    local v134 = TweenService:Create(CFrameValue, TweenInfo.new(p94, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = p93
    })

    v134.Completed:Connect(function() -- line: 1585
        -- upvalues: CFrameValue (copy), connection (copy)
        connection:Disconnect()
        CFrameValue:Destroy()
    end)
    v134:Play()
end

function self._playApexCutscene(p95, p96, p97, p98, p99, p100) -- line: 1591
    -- upvalues: Players (copy), TweenService (copy), Workspace (copy), events (copy), clientProducer (copy), apexDropAtom (copy), apexRevealAtom (copy), fishDataByName (copy), isFishData (copy), getMutatedMoneyPerSecond (copy), selectPlayerAquarium (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerShowcaseFish (copy), localPlayerUserId (copy), getExclusiveFishConfigByFishName (copy), getAquariumFishEffectiveMoneyPerSecond (copy), showcaseFishToMpsInput (copy)
    local ScreenGui, v135
    local v136 = false

    local function v137() -- line: 1595
        -- upvalues: p95 (copy), p96 (copy), ScreenGui (ref), v135 (ref), v136 (ref)
        if v136 then
            return nil
        end

        v136 = true
        p95:_runCleanupStep("destroy Apex flash GUI", function() -- line: 1600
            -- upvalues: ScreenGui (ref)
            local v138 = ScreenGui

            if v138 ~= nil then
                v138 = v138:Destroy()
            end

            return v138
        end)
        p95:_runCleanupStep("destroy Apex drop model", function() -- line: 1607
            -- upvalues: v135 (ref)
            local v139 = v135

            if v139 ~= nil then
                v139 = v139:Destroy()
            end

            return v139
        end)
        p95:_completeApexCatch(p96)
    end

    local function v140() -- line: 1622
        -- upvalues: p95 (copy), p96 (copy), p97 (copy), p98 (copy), p99 (copy), p100 (copy), ScreenGui (ref), v135 (ref), Players (copy), TweenService (copy), Workspace (copy), events (copy), clientProducer (copy), apexDropAtom (copy), apexRevealAtom (copy), fishDataByName (copy), isFishData (copy), getMutatedMoneyPerSecond (copy), selectPlayerAquarium (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerShowcaseFish (copy), localPlayerUserId (copy), getExclusiveFishConfigByFishName (copy), getAquariumFishEffectiveMoneyPerSecond (copy), showcaseFishToMpsInput (copy)
        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera == nil then
            error("[ApexCutscene] CurrentCamera unavailable")
        end

        local LocalPlayer = Players.LocalPlayer
        local v141 = fishDataByName[p97]
        local model = if v141 == nil or not isFishData(v141) then nil else v141.model
        local v142 = if v141 == nil or not isFishData(v141) then p97 else v141.displayName
        local v143 = clientProducer:getState()
        local v144 = selectPlayerAquarium(localPlayerUserId)(v143)
        local v145 = selectPlayerInventory(localPlayerUserId)(v143)
        local v146 = selectPlayerGamepasses(localPlayerUserId)(v143)
        local v147 = showcaseFishToMpsInput(selectPlayerShowcaseFish(localPlayerUserId)(v143))
        local v148

        if v141 ~= nil and isFishData(v141) and getExclusiveFishConfigByFishName(p97) ~= nil then
            local t16 = {
                level = 1,
                fishId = p97,
                fishSpecies = p97,
                mutations = p100
            }

            if v144 ~= nil then
                v144 = v144.fishItems
            end

            if v144 == nil then
                v144 = {}
            end

            v148 = getAquariumFishEffectiveMoneyPerSecond(t16, v144, v146, nil, 0, v145, v147)
        else
            v148 = if v141 == nil or not isFishData(v141) then getMutatedMoneyPerSecond(p99, 1, p100) else getMutatedMoneyPerSecond(v141.moneyPerSecond, 1, p100)
        end

        local Character = LocalPlayer.Character

        if Character ~= nil then
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        local v149 = if Character == nil then Character else Character.Position

        if v149 == nil then
            v149 = Vector3.new(0, 0, 0)
        end

        if Character ~= nil then
            Character = Character.CFrame.LookVector
        end

        if Character == nil then
            Character = Vector3.new(0, 0, -1)
        end

        local v152 = Vector3.new(v149.X + Character.X * 10, v149.Y, v149.Z + Character.Z * 10)
        local ScreenGui2 = Instance.new("ScreenGui")

        ScreenGui = ScreenGui2
        ScreenGui2.IgnoreGuiInset = true
        ScreenGui2.ResetOnSpawn = false
        ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local Frame = Instance.new("Frame")

        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 100
        Frame.Parent = ScreenGui2
        ScreenGui2.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")

        local function v153(p101, p102) -- line: 1698
            -- upvalues: Frame (copy), TweenService (copy)
            TweenService:Create(Frame, TweenInfo.new(p102, Enum.EasingStyle.Linear), {
                BackgroundTransparency = p101
            }):Play()
        end

        p95:_runCleanupStep("notify server that camera returned to pier", function() -- line: 1704
            -- upvalues: events (copy)
            return events.cameraReturnedToPier:fire()
        end)
        v153(0, 0.15)
        task.wait(0.15)

        local v155 = p95:_tryGetRewardExtents(p95:_findRewardModel(p96), "world", p96) or p95:_tryGetRewardExtents(model, "configured", p96) or Vector3.new(6, 6, 6)
        local v157 = math.clamp(math.max(v155.X, v155.Y, v155.Z) / 2, 3, 20)
        local v158 = v155.Y / 2
        local v160 = Vector3.new(v152.X, v152.Y + v158, v152.Z)
        local v162 = Vector3.new(v160.X, v160.Y + 400, v160.Z)
        local v163 = p95:_spawnRewardModel(p96, model, v162)

        if v163 == nil then
            warn(("[FishCatch] apex reward model unavailable (fishId=%*) — "):format(p96) .. "dropping invisible placeholder so the cutscene still completes")
        end

        local v164 = v163 or p95:_spawnPlaceholderRewardModel(v162)

        v135 = v164
        p95:_setCameraScriptable(CurrentCamera)
        apexDropAtom({
            fishMoneyPerSecond = v148,
            fishName = v142,
            mutations = p100
        })
        v153(1, 0.15)
        p95:_playDropSequence(CurrentCamera, v164, v162, v160, Character, v157)
        p95:_playLandingVFX(v164)
        p95._soundController:playSound("JackpotLandingImpact")
        p95:_applyImpactJolt(CurrentCamera, 9)
        v153(0, 0.15)
        task.wait(0.15)
        apexDropAtom(nil)
        v153(1, 0.15)
        p95:_playRevealShot(CurrentCamera, v164, Character)
        apexRevealAtom({
            fishImageId = p98,
            fishMoneyPerSecond = v148,
            fishName = v142,
            mutations = p100
        })
        task.wait(3)
    end

    local ok, result = pcall(v140)

    if not ok then
        warn(("[ApexCutscene] presentation failed for %*; completing safely"):format(p97), result)
    end

    v137()
end

function self._findRewardModel(_, p104) -- line: 1767
    -- upvalues: CollectionService (copy)
    for _, v165 in CollectionService:GetTagged("FishingZoneFish") do
        if v165:IsA("Model") and v165.Name == p104 then
            return v165
        end
    end

    return nil
end

function self._tryGetRewardExtents(_, p106, p107, p108) -- line: 1775
    if p106 == nil then
        return nil
    end

    local function v166() -- line: 1779
        -- upvalues: p106 (copy)
        return (select(2, p106:GetBoundingBox()))
    end

    local ok, result = pcall(v166)

    if ok then
        return result
    end

    warn(("[FishCatch] failed to measure %* Apex model %*; trying fallback"):format(p107, p108), result)

    return nil
end

function self._spawnRewardModel(p109, p110, p111, p112) -- line: 1788
    -- upvalues: Workspace (copy)
    local v167 = p109:_findRewardModel(p110)

    local function v168(p113, p114, p115) -- line: 1790
        -- upvalues: p109 (copy), p110 (copy), p112 (copy), Workspace (copy)
        local clone

        local function v169() -- line: 1792
            -- upvalues: p113 (copy), clone (ref), p112 (copy), Workspace (copy)
            local clone2 = p113:Clone()

            clone = clone2
            clone2:RemoveTag("FishingZoneFish")

            for _, descendant in clone2:GetDescendants() do
                if descendant:IsA("Highlight") then
                    descendant:Destroy()
                end
            end

            for _, descendant in clone2:GetDescendants() do
                if descendant:IsA("WeldConstraint") then
                    descendant:Destroy()
                end
            end

            for _, descendant in clone2:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                    descendant.CastShadow = false
                    descendant.LocalTransparencyModifier = 0
                end
            end

            if clone2.PrimaryPart == nil then
                local v170 = clone2:FindFirstChildWhichIsA("BasePart", true)

                if v170 ~= nil then
                    clone2.PrimaryPart = v170
                end
            end

            clone2.Parent = Workspace
            clone2:PivotTo(CFrame.new(p112))
        end

        local ok, result = pcall(v169)

        if ok and clone ~= nil then
            if p115 then
                p109:_runCleanupStep("hide streamed Apex source model", function() -- line: 1843
                    -- upvalues: p113 (copy), p109 (copy)
                    return p109:_setFishVisibility(p113, false)
                end)
            end

            return clone
        end

        p109:_runCleanupStep(("destroy failed %* Apex clone"):format(p114), function() -- line: 1832
            -- upvalues: clone (ref)
            local v171 = clone

            if v171 ~= nil then
                v171 = v171:Destroy()
            end

            return v171
        end)
        warn(("[FishCatch] failed to prepare %* Apex model %*; trying fallback"):format(p114, p110), result)

        return nil
    end

    local v172 = v167 == nil
    local v173, v174

    if not v172 then
        v173 = v168(v167, "world", true)
        v174 = v173 == nil
    end

    if v172 or v174 then
        return if p111 ~= nil and p111 ~= v167 then v168(p111, "configured", false) else nil
    end

    return v173
end

function self._spawnPlaceholderRewardModel(_, p117) -- line: 1860
    -- upvalues: Workspace (copy)
    local Model = Instance.new("Model")
    local Part = Instance.new("Part")

    Part.Size = Vector3.new(6, 6, 6)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Parent = Model
    Model.PrimaryPart = Part
    Model.Parent = Workspace
    Model:PivotTo(CFrame.new(p117))

    return Model
end

function self._setCameraScriptable(_, p119) -- line: 1876
    p119.CameraType = Enum.CameraType.Scriptable
end

function self._restoreCamera(p120, p121) -- line: 1879
    -- upvalues: Players (copy), Workspace (copy)
    p120._cameraMaid:DoCleaning()

    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if Character then
        p121.CameraSubject = Character
    end

    p121.CameraType = Enum.CameraType.Custom

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera.FieldOfView = 70
    end

    local LocalPlayer = Players.LocalPlayer

    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 128
end

function self._runCleanupStep(_, p123, p124) -- line: 1892
    local ok, result = pcall(p124)

    if not ok then
        warn(("[FishCatch] cleanup step failed: %*"):format(p123), result)
    end
end

function self._movementLockStartedAfter(p125, p126) -- line: 1898
    -- upvalues: fishingMovementLockedAtom (copy)
    return fishingMovementLockedAtom() and p125._movementLockStartedAt ~= nil and p126 ~= nil and p126 < p125._movementLockStartedAt
end

function self._clearSessionEndRecovery(p127) -- line: 1901
    if p127._sessionEndRecoveryThread == nil then
        return nil
    end

    task.cancel(p127._sessionEndRecoveryThread)
    p127._sessionEndRecoveryThread = nil
end

function self._onAuthoritativeFishingSessionEnded(p128) -- line: 1908
    -- upvalues: fishingMovementLockedAtom (copy)
    if not fishingMovementLockedAtom() then
        p128:_clearSessionEndRecovery()

        return nil
    end

    if p128._isReelCameraPlaying or p128._isApexCutscenePlaying then
        p128:_clearSessionEndRecovery()
        p128._sessionEndRecoveryThread = task.delay(5, function() -- line: 1919
            -- upvalues: p128 (copy), fishingMovementLockedAtom (copy)
            p128._sessionEndRecoveryThread = nil

            if not fishingMovementLockedAtom() then
                return nil
            end

            warn("[FishCatch] client presentation outlived server session; forcing cleanup")
            p128:_forceFishingClientCleanup()
        end)

        return
    end

    warn("[FishCatch] server ended fishing without a client presentation; recovering")
    p128:_forceFishingClientCleanup()

    return nil
end

function self._completeApexCatch(p129, p130) -- line: 1928
    -- upvalues: events (copy)
    p129:_forceFishingClientCleanup()
    p129:_runCleanupStep("notify server that Apex catch completed", function() -- line: 1930
        -- upvalues: p130 (copy), events (copy)
        return events.apexCutsceneFinished(p130)
    end)
end

function self._forceFishingClientCleanup(p131) -- line: 1934
    -- upvalues: Workspace (copy), apexAfterRareFishCutsceneAtom (copy), apexDropAtom (copy), apexRevealAtom (copy), apexSkillCheckAtom (copy), catchFadeAtom (copy), fishingMovementLockedAtom (copy), hookHrpAtom (copy), rareFishTransitionAtom (copy), setMiniRigBeamVisible (copy)
    local _stopReelCamera, _apexSkillCheckMaid, _bossPovHandle = p131._stopReelCamera, p131._apexSkillCheckMaid, p131._bossPovHandle

    p131._stopReelCamera = nil
    p131._isReelCameraPlaying = false
    p131._isApexCutscenePlaying = false
    p131._activeApexFishId = nil
    p131._lastReelFishId = nil
    p131._apexSkillCheckMaid = nil
    p131._bossPovHandle = nil
    p131:_runCleanupStep("release fishing movement lock", function() -- line: 1947
        -- upvalues: fishingMovementLockedAtom (copy)
        return fishingMovementLockedAtom(false)
    end)
    p131:_runCleanupStep("cancel session-end recovery timer", function() -- line: 1950
        -- upvalues: p131 (copy)
        return p131:_clearSessionEndRecovery()
    end)
    p131:_runCleanupStep("stop reel camera", function() -- line: 1953
        -- upvalues: _stopReelCamera (copy)
        local v175 = _stopReelCamera

        if _stopReelCamera ~= nil then
            v175 = _stopReelCamera()
        end

        return v175
    end)
    p131:_runCleanupStep("clear Apex skill-check state", function() -- line: 1960
        -- upvalues: apexSkillCheckAtom (copy)
        return apexSkillCheckAtom(nil)
    end)
    p131:_runCleanupStep("destroy Apex skill-check resources", function() -- line: 1963
        -- upvalues: _apexSkillCheckMaid (copy)
        local v176 = _apexSkillCheckMaid

        if _apexSkillCheckMaid ~= nil then
            v176 = _apexSkillCheckMaid:Destroy()
        end

        return v176
    end)
    p131:_runCleanupStep("destroy Apex Boss POV", function() -- line: 1970
        -- upvalues: _bossPovHandle (copy)
        local v177 = _bossPovHandle

        if _bossPovHandle ~= nil then
            v177 = _bossPovHandle:destroy()
        end

        return v177
    end)
    p131:_runCleanupStep("disable MiniPlayerRig beam", function() -- line: 1977
        -- upvalues: hookHrpAtom (copy), setMiniRigBeamVisible (copy)
        local v178 = hookHrpAtom()

        if v178 ~= nil then
            v178 = v178.Parent
        end

        if v178 ~= nil then
            setMiniRigBeamVisible(v178, false)
        end
    end)
    p131:_runCleanupStep("clear post-Boss cutscene state", function() -- line: 1987
        -- upvalues: apexAfterRareFishCutsceneAtom (copy)
        return apexAfterRareFishCutsceneAtom(false)
    end)
    p131:_runCleanupStep("clear Apex drop state", function() -- line: 1990
        -- upvalues: apexDropAtom (copy)
        return apexDropAtom(nil)
    end)
    p131:_runCleanupStep("clear Apex reveal state", function() -- line: 1993
        -- upvalues: apexRevealAtom (copy)
        return apexRevealAtom(nil)
    end)
    p131:_runCleanupStep("clear catch fade state", function() -- line: 1996
        -- upvalues: catchFadeAtom (copy)
        return catchFadeAtom(nil)
    end)
    p131:_runCleanupStep("clear rare-fish transition state", function() -- line: 1999
        -- upvalues: rareFishTransitionAtom (copy)
        return rareFishTransitionAtom(nil)
    end)
    p131:_runCleanupStep("restore hidden fishing-zone models", function() -- line: 2002
        -- upvalues: p131 (copy)
        return p131:_showFishZoneModels()
    end)
    p131:_runCleanupStep("stop hook-flight music", function() -- line: 2005
        -- upvalues: p131 (copy)
        return p131._soundController:stopFlyMusic()
    end)
    p131:_runCleanupStep("stop rare-fish audio", function() -- line: 2008
        -- upvalues: p131 (copy)
        return p131._soundController:stopRareFishAudio()
    end)

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        p131:_runCleanupStep("restore gameplay camera", function() -- line: 2013
            -- upvalues: p131 (copy), CurrentCamera (copy)
            return p131:_restoreCamera(CurrentCamera)
        end)
    end
end

function self._applyCameraShake(_, p133, p134, p135) -- line: 2018
    -- upvalues: cameraShakeEnabledAtom (copy), shake (copy)
    if not cameraShakeEnabledAtom() then
        return nil
    end

    local v179 = shake.new()

    v179.Amplitude = p134
    v179.Frequency = p135
    v179.FadeInTime = 0.15
    v179.FadeOutTime = 0.4
    v179.Sustain = true
    v179.PositionInfluence = Vector3.new(0.6, 0.6, 0.6)
    v179.RotationInfluence = Vector3.new(0.12, 0.12, 0.12)
    v179:Start()
    v179:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p136, p137) -- line: 2032
        -- upvalues: p133 (copy)
        local _CFrame = p133.CFrame
        local v180 = CFrame.new(p136)
        local v181 = CFrame.fromEulerAnglesXYZ(p137.X, p137.Y, p137.Z)

        p133.CFrame = _CFrame * v180 * v181
    end)

    return v179
end

function self._applyImpactJolt(_, p139, p140) -- line: 2040
    -- upvalues: cameraShakeEnabledAtom (copy), shake (copy)
    if not cameraShakeEnabledAtom() then
        return nil
    end

    local v182 = shake.new()

    v182.Amplitude = p140
    v182.Frequency = 0.15000000000000002
    v182.FadeInTime = 0
    v182.FadeOutTime = 0.5
    v182.SustainTime = 0.05
    v182.PositionInfluence = Vector3.new(0.4, 0.4, 0.4)
    v182.RotationInfluence = Vector3.new(0.15, 0.15, 0.15)
    v182:Start()
    v182:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p141, p142) -- line: 2053
        -- upvalues: p139 (copy)
        local _CFrame = p139.CFrame
        local v184 = CFrame.new(p141)
        local v185 = CFrame.fromEulerAnglesXYZ(p142.X, p142.Y, p142.Z)

        p139.CFrame = _CFrame * v184 * v185
    end)
    task.delay(0.7, function() -- line: 2059
        -- upvalues: v182 (copy)
        return v182:Destroy()
    end)
end

function self._playDropSequence(p143, p144, p145, p146, p147, p148, p149) -- line: 2063
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy)
    local v186 = p148 * -1
    local v187 = p145:FindFirstChild("__FishMouthAnchor", true)
    local Pivot = p145:GetPivot()
    local BoundingBox = p145:GetBoundingBox()
    local v188

    if v187 ~= nil then
        local v189 = v187.Position - BoundingBox.Position

        v188 = if v189.Magnitude > 0.01 then Pivot:VectorToObjectSpace(v189).Unit else Vector3.new(0, 0, -1)
    else
        v188 = Vector3.new(0, 0, -1)
    end

    local v190 = CFrame.lookAt(Vector3.new(), v188)
    local v191 = CFrame.lookAt(Vector3.new(), v186, (Vector3.new(0, 1, 0))) * v190:Inverse()
    local v192 = CFrame.lookAt(Vector3.new(), Vector3.new(0, -1, 0), v186) * v190:Inverse()
    local v194 = Vector3.new(p147.X, p147.Y + 300, p147.Z)
    local v195 = p147.Y + 300
    local v196 = p148:Cross((Vector3.new(0, 1, 0)))

    if v196.Magnitude < 0.01 then
        v196 = Vector3.new(1, 0, 0)
    end

    local Unit = v196.Unit
    local v197 = p143:_applyCameraShake(p144, 1.2, 0.1)
    local FallingSound = p143._soundController:playSound("FallingSound")
    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = CFrame.new(p146) * v191
    CFrameValue.Parent = Workspace
    p144.CFrame = CFrame.lookAt(v194, p146, p148)

    local v199 = math.clamp(p149 * 3, 22, 60)
    local v200 = p146.Y - p147.Y
    local elapsed = os.clock()
    local v201 = false
    local Y = p146.Y
    local connection = RunService.RenderStepped:Connect(function() -- line: 2123
        -- upvalues: p143 (copy), p144 (copy), p145 (copy), p146 (copy), p147 (copy), p148 (copy), p149 (copy), v191 (copy), v192 (copy), v194 (copy), v195 (copy), Unit (copy), v197 (copy), CFrameValue (copy), v199 (copy), v200 (copy), elapsed (copy), v201 (ref), Y (ref)
        local ValuePosition = CFrameValue.Value.Position
        local v203 = math.clamp((p146.Y - ValuePosition.Y) / v200, 0, 1)

        if v197 then
            v197.Amplitude = v203 * 3.8 * v203 + 1.2
        end

        local v204 = (1 - v203) * 0.4
        local v205 = os.clock() - elapsed
        local v211 = CFrame.Angles(math.sin(v205 * 16) * v204, math.sin(v205 * 16 * 0.6) * v204 * 0.5, math.cos(v205 * 16 * 0.85) * v204)
        local v214 = v192:Lerp(v191, (math.clamp((v195 - ValuePosition.Y) / (v195 - p147.Y), 0, 1)))

        p145:PivotTo(CFrame.new(ValuePosition) * v214 * v211)

        local v216 = math.clamp(1 - (ValuePosition.Y - v195) / 130, 0, 1)
        local v217 = v216 * v216 * (3 - v216 * 2)
        local v218 = CFrame.lookAt(v194, ValuePosition, p148)
        local v222 = Vector3.new(ValuePosition.X - p148.X * v199 * 0.3, ValuePosition.Y + v199, ValuePosition.Z - p148.Z * v199 * 0.3)
        local v223 = v218:Lerp(CFrame.lookAt(v222, ValuePosition), v217)
        local v226 = Unit * ((p149 * 3 + 25) * math.sin(v217 * 3.141592653589793))

        p144.CFrame = CFrame.lookAt(v223.Position + v226, ValuePosition, v223.UpVector)

        if not v201 and Y > v195 and ValuePosition.Y <= v195 then
            v201 = true
            p143:_applyImpactJolt(p144, 18)
        end

        Y = ValuePosition.Y
    end)

    TweenService:Create(CFrameValue, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Value = CFrame.new(p147) * v191
    }):Play()
    task.wait(2)
    FallingSound:Stop()
    connection:Disconnect()
    CFrameValue:Destroy()

    if v197 then
        v197:StopSustain()
        task.delay(0.5, function() -- line: 2178
            -- upvalues: v197 (copy)
            return v197:Destroy()
        end)
    end

    p145:PivotTo(CFrame.new(p147) * v191)
end

function self._playLandingVFX(_, p151) -- line: 2184
    -- upvalues: playFishLandingVFX (copy)
    playFishLandingVFX(p151, 5)
end

function self._playRevealShot(p152, p153, p154, p155) -- line: 2187
    local BoundingBox, BoundingBox2 = p154:GetBoundingBox()
    local BoundingBoxPosition = BoundingBox.Position
    local v227 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)
    local v228 = math.rad(p153.FieldOfView)
    local v231 = v227 * 0.5 / math.tan(v228 / 2) / 0.7
    local v232 = p155 * -1
    local v235 = BoundingBoxPosition + Vector3.new(v232.X * 0.8191520442889918, 0.573576436351046, v232.Z * 0.8191520442889918).Unit * v231

    p152:_tweenCFrameValue(p153, CFrame.lookAt(v235, BoundingBoxPosition), 0.7)
    p152:_revealApexSilhouette()
end

function self._startNibbleCamera(p156, p157) -- line: 2208
    -- upvalues: Players (copy), TweenService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if not CurrentCamera then
        return nil
    end

    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.5, 0.5, 0.5)
    Part.CFrame = CFrame.new(p157)
    Part.Parent = Workspace
    p156._cameraMaid:GiveTask(Part)

    local CameraMinZoomDistance, CameraMaxZoomDistance = LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance

    p156._cameraMaid:GiveTask(function() -- line: 2224
        -- upvalues: LocalPlayer (copy), CameraMinZoomDistance (copy), CameraMaxZoomDistance (copy)
        LocalPlayer.CameraMinZoomDistance = CameraMinZoomDistance
        LocalPlayer.CameraMaxZoomDistance = CameraMaxZoomDistance
    end)

    local CFramePosition = CurrentCamera.CFrame.Position
    local CameraSubject = CurrentCamera.CameraSubject

    if CameraSubject ~= nil then
        CameraSubject = CameraSubject.Position
    end

    if CameraSubject == nil then
        CameraSubject = CurrentCamera.CFrame.Position
    end

    local v236 = math.clamp((CFramePosition - CameraSubject).Magnitude, CameraMinZoomDistance, CameraMaxZoomDistance)
    local NumberValue = Instance.new("NumberValue")

    NumberValue.Value = v236
    NumberValue.Parent = Workspace

    local connection = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 2241
        -- upvalues: LocalPlayer (copy), NumberValue (copy)
        LocalPlayer.CameraMinZoomDistance = NumberValue.Value
        LocalPlayer.CameraMaxZoomDistance = NumberValue.Value
    end)
    local v237 = TweenService:Create(NumberValue, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = 22
    })

    v237.Completed:Connect(function() -- line: 2248
        -- upvalues: LocalPlayer (copy), NumberValue (copy), connection (copy)
        connection:Disconnect()
        NumberValue:Destroy()
        LocalPlayer.CameraMinZoomDistance = 22
        LocalPlayer.CameraMaxZoomDistance = 22
    end)
    v237:Play()

    local v238 = p157 + Vector3.new(0, 14, 8)
    local v239 = CFrame.lookAt(v238, p157)

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = CurrentCamera.CFrame
    CFrameValue.Parent = Workspace

    local connection2 = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 2263
        -- upvalues: CurrentCamera (copy), CFrameValue (copy)
        CurrentCamera.CFrame = CFrameValue.Value
    end)
    local v240 = TweenService:Create(CFrameValue, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = v239
    })

    v240.Completed:Connect(function() -- line: 2269
        -- upvalues: CurrentCamera (copy), Part (copy), CFrameValue (copy), connection2 (copy)
        connection2:Disconnect()
        CFrameValue:Destroy()

        if Part.Parent ~= nil then
            CurrentCamera.CameraSubject = Part
            CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end)
    p156._cameraMaid:GiveTask(v240)
    v240:Play()
end

function self._onReelStarted(p158, p159, p160, p161, p162, p163) -- line: 2282
    -- upvalues: CollectionService (copy), Players (copy), Workspace (copy), events (copy), fishingMovementLockedAtom (copy), computeReelArcDurations (copy), reelDropDuration (copy), skipReelArcToLanding (copy), playReelCamera (copy), playFishLandingVFX (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if not CurrentCamera then
        return nil
    end

    local total = computeReelArcDurations(p159, p160, p162, p163).total

    p158:_clearSessionEndRecovery()

    local _stopReelCamera = p158._stopReelCamera

    if _stopReelCamera ~= nil then
        _stopReelCamera()
    end

    p158._isReelCameraPlaying = true
    p158._stopReelCamera = playReelCamera(CurrentCamera, LocalPlayer, p159, p160, p161, p162, p163, function() -- line: 2296
        -- upvalues: p158 (copy)
        p158._cameraMaid:DoCleaning()
    end, function() -- line: 2298
        -- upvalues: p158 (copy), events (copy), fishingMovementLockedAtom (copy)
        events.cameraReturnedToPier:fire()
        p158._isReelCameraPlaying = false
        p158._stopReelCamera = nil
        p158:_clearSessionEndRecovery()
        fishingMovementLockedAtom(false)
        p158:_showFishZoneModels()
    end)

    if skipReelArcToLanding then
        total = reelDropDuration
    end

    local _lastReelFishId = p158._lastReelFishId

    task.delay(total, function() -- line: 2308
        -- upvalues: p158 (copy), _lastReelFishId (copy), CollectionService (copy), playFishLandingVFX (copy)
        local v242

        for v243, v244 in (CollectionService:GetTagged("FishingZoneFish")) do
            local _ = v243 - 1

            if (v244.Name == _lastReelFishId and v244:IsA("Model")) == true then
                v242 = v244
                break
            end

            v242 = nil
        end

        if v242 then
            playFishLandingVFX(v242)
        end

        p158._soundController:playSound("LandingImpact")
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/fishing-rod-controller@FishingRodController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    FishingRodController = self
}
