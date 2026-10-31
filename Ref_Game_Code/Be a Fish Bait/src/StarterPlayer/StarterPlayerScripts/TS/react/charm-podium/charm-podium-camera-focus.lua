-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, RunService, TweenService, Workspace = services.CollectionService, services.RunService, services.TweenService, services.Workspace
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").playClonedSound
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmTierConfigs, isCharmTierId = v1.charmTierConfigs, v1.isCharmTierId
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local t1 = {
    rarityColors.common,
    rarityColors.uncommon,
    rarityColors.rare,
    rarityColors.epic,
    rarityColors.legendary,
    rarityColors.mythic
}
local t2
local n1 = 0

local function getCharmPodiumPreviewRoom() -- line: 35
    -- upvalues: Workspace (copy)
    local CharmPodiumPreviewArea = Workspace:FindFirstChild("CharmPodiumPreviewArea")
    local v2 = if CharmPodiumPreviewArea == nil then CharmPodiumPreviewArea else CharmPodiumPreviewArea:FindFirstChild("Camera")
    local v3 = if CharmPodiumPreviewArea == nil then CharmPodiumPreviewArea else CharmPodiumPreviewArea:FindFirstChild("PreviewOrigin")
    local v4 = not (if CharmPodiumPreviewArea == nil then CharmPodiumPreviewArea else CharmPodiumPreviewArea:IsA("Model"))
    local v5

    if v4 then
        v5 = v4
    else
        local v6 = (if v2 == nil then v2 else v2:IsA("BasePart")) ~= true

        v6 = v6 and (if v2 == nil then v2 else v2:IsA("Camera")) ~= true
        v5 = v6 or (if v3 == nil then v3 else v3:IsA("BasePart")) ~= true
    end

    return if not v5 then {
        area = CharmPodiumPreviewArea,
        cameraAnchor = v2,
        previewOrigin = v3
    } else nil
end

local function clonePodiumForPreview(p1, p2, p3) -- line: 83
    -- upvalues: CollectionService (copy), charmTierConfigs (copy), isCharmTierId (copy)
    local CharmPodiumVisual = p1:FindFirstChild("CharmPodiumVisual")

    if not (if CharmPodiumVisual == nil then CharmPodiumVisual else CharmPodiumVisual:IsA("Model")) then
        CharmPodiumVisual = p1
    end

    local Archivable = CharmPodiumVisual.Archivable

    CharmPodiumVisual.Archivable = true

    local clone = CharmPodiumVisual:Clone()

    CharmPodiumVisual.Archivable = Archivable

    if clone == nil then
        return nil
    end

    clone.Name = "ActiveCharmPodiumPreview"
    CollectionService:RemoveTag(clone, "CharmPodium")

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ProximityPrompt") or descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") or descendant:IsA("BaseScript") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
    local v9 = math.min(1, 12 / math.max(BoundingBox2.X, BoundingBox2.Z), 8 / BoundingBox2.Y)

    if v9 < 1 then
        clone:ScaleTo(clone:GetScale() * v9)
        BoundingBox, BoundingBox2 = clone:GetBoundingBox()
    end

    local CharmTierId = p1:GetAttribute("CharmTierId")
    local v10 = if type(CharmTierId) ~= "number" or not isCharmTierId(CharmTierId) then 1 else charmTierConfigs[CharmTierId].previewCharmScale
    local v11 = clone:FindFirstChild("CharmDisplay", true)

    if (if v11 == nil then v11 else v11:IsA("Model")) and v10 ~= 1 then
        v11:ScaleTo(v11:GetScale() * v10)
        BoundingBox, BoundingBox2 = clone:GetBoundingBox()
    end

    local v12 = BoundingBox:ToObjectSpace(clone:GetPivot())
    local v15 = p3.Position + Vector3.new(0, -3, 0) + Vector3.new(0, BoundingBox2.Y / 2, 0)

    clone:PivotTo(CFrame.fromMatrix(v15, p3.CFrame.RightVector, p3.CFrame.UpVector) * v12)
    clone.Parent = p2

    return clone
end

local function getAnchorCFrame(p4) -- line: 144
    return p4.CFrame
end

local function getAuraRollEmitter() -- line: 147
    -- upvalues: Workspace (copy)
    local Map = Workspace:FindFirstChild("Map")

    if Map ~= nil then
        Map = Map:FindFirstChild("BaitAuraArea")

        if Map ~= nil then
            Map = Map:FindFirstChild("BGVFXPart")

            if Map ~= nil then
                Map = Map:FindFirstChild("BGVFXAttachment")

                if Map ~= nil then
                    Map = Map:FindFirstChild("BGVFX")
                end
            end
        end
    end

    return if if Map == nil then Map else Map:IsA("ParticleEmitter") then Map else nil
end

local function scaleNumberRange(p5, p6) -- line: 168
    return NumberRange.new(p5.Min * p6, p5.Max * p6)
end

local function scaleNumberSequence(p7, p8) -- line: 171
    local Keypoints = p7.Keypoints
    local v16 = table.create(#Keypoints)

    for v17, v18 in Keypoints do
        local _ = v17 - 1

        v16[v17] = NumberSequenceKeypoint.new(v18.Time, v18.Value * p8, v18.Envelope * p8)
    end

    return NumberSequence.new(v16)
end

local function createAuraRollVfxAnchor(p9) -- line: 184
    local previewPodium = p9.previewPodium

    if previewPodium == nil then
        return nil
    end

    local BoundingBox, BoundingBox2 = previewPodium:GetBoundingBox()
    local CFramePosition = p9.cameraAnchor.CFrame.Position
    local v21 = Vector3.new(BoundingBox.Position.X - CFramePosition.X, 0, BoundingBox.Position.Z - CFramePosition.Z)
    local v22 = if v21.Magnitude > 0.01 then v21.Unit else BoundingBox.LookVector
    local BoundingBoxPosition = BoundingBox.Position
    local v23 = v22 * (math.max(BoundingBox2.X, BoundingBox2.Z) / 2 + 1.5)
    local v25 = Vector3.new(0, BoundingBox2.Y * 0.25, 0)
    local v26 = BoundingBoxPosition + v23 + v25
    local Part = Instance.new("Part")

    Part.Name = "CharmAuraRollVfxAnchor"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CFrame = CFrame.lookAt(v26, v26 + v22)
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.Transparency = 1
    Part.Parent = p9.area

    return Part
end

local function attachAuraRollVfx(p10) -- line: 211
    -- upvalues: getAuraRollEmitter (copy), scaleNumberSequence (copy)
    local v27 = getAuraRollEmitter()

    if v27 ~= nil then
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "CharmAuraRollVfxAttachment"
        Attachment.Parent = p10

        local clone = v27:Clone()

        if clone:IsA("ParticleEmitter") then
            clone.Name = "CharmAuraRollBGVFX"
            clone.Enabled = true
            clone.Rate *= 0.45
            clone.Size = scaleNumberSequence(clone.Size, 0.5)

            local Speed = clone.Speed

            clone.Speed = NumberRange.new(Speed.Min * 0.5, Speed.Max * 0.5)
            clone.LightEmission = math.min(clone.LightEmission, 0.25)
            clone.Transparency = NumberSequence.new(0.35)
            clone.Parent = Attachment
            clone:Emit((math.max(12, (math.floor(clone.Rate * 0.6)))))

            return clone
        end

        Attachment:Destroy()
    else
        warn("Charm Roll VFX requires Workspace.Map.BaitAuraArea.BGVFXPart.BGVFXAttachment.BGVFX.")
    end

    return nil
end

local function startAuraRollVfxColorCycle(p11, p12) -- line: 237
    -- upvalues: RunService (copy), t1 (copy)
    local v30 = tick()

    local function v31() -- line: 239
        -- upvalues: p12 (copy), v30 (copy), t1 (copy)
        local v32 = (tick() - v30) / 0.12
        local v33 = math.floor(v32) % #t1
        local v34 = (v33 + 1) % #t1
        local v35 = v32 % 1
        local v36 = t1[v33 + 1]:Lerp(t1[v34 + 1], v35)

        p12.Color = ColorSequence.new(v36)
    end

    v31()
    p11.rollVfxColorConnection = RunService.RenderStepped:Connect(v31)
end

local function cleanupRollPresentation(p13, p14) -- line: 251
    -- upvalues: TweenService (copy)
    local cameraTween = p13.cameraTween

    if cameraTween ~= nil then
        cameraTween:Cancel()
    end

    p13.cameraTween = nil

    if p13.rollRiserThread ~= nil then
        task.cancel(p13.rollRiserThread)
    end

    p13.rollRiserThread = nil

    local rollVfxColorConnection = p13.rollVfxColorConnection

    if rollVfxColorConnection ~= nil then
        rollVfxColorConnection:Disconnect()
    end

    p13.rollVfxColorConnection = nil

    local rollVfxAnchor = p13.rollVfxAnchor

    if rollVfxAnchor ~= nil then
        rollVfxAnchor:Destroy()
    end

    p13.rollVfxAnchor = nil

    if not p14 then
        p13.camera.FieldOfView = 50

        return
    end

    local v37 = TweenService:Create(p13.camera, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FieldOfView = 50
    })

    p13.cameraTween = v37
    v37:Play()
end

local releaseCharmPodiumFocus

local function focusCharmPodium(p15) -- line: 283
    -- upvalues: Workspace (copy), t2 (ref), n1 (ref), getCharmPodiumPreviewRoom (copy), clonePodiumForPreview (copy), releaseCharmPodiumFocus (ref)
    releaseCharmPodiumFocus()

    local v38 = getCharmPodiumPreviewRoom()
    local CurrentCamera = Workspace.CurrentCamera

    if v38 == nil or CurrentCamera == nil then
        warn("Charm podium preview requires Workspace.CharmPodiumPreviewArea.Camera and Workspace.CharmPodiumPreviewArea.PreviewOrigin.")

        return nil
    end

    local v39 = clonePodiumForPreview(p15, v38.area, v38.previewOrigin)

    if v39 == nil then
        return nil
    end

    n1 += 1

    local v40 = n1

    t2 = {
        area = v38.area,
        camera = CurrentCamera,
        cameraAnchor = v38.cameraAnchor,
        previewPodium = v39,
        previewOrigin = v38.previewOrigin,
        snapshot = {
            cameraSubject = CurrentCamera.CameraSubject,
            cameraType = CurrentCamera.CameraType,
            cframe = CurrentCamera.CFrame,
            fieldOfView = CurrentCamera.FieldOfView
        },
        token = v40
    }
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.CameraSubject = nil
    CurrentCamera.CFrame = v38.cameraAnchor.CFrame
    CurrentCamera.FieldOfView = 50

    return v40
end

local function setCharmPodiumRollPresentationActive(p16) -- line: 318
    -- upvalues: RunService (copy), TweenService (copy), playClonedSound (copy), t1 (copy), t2 (ref), createAuraRollVfxAnchor (copy), attachAuraRollVfx (copy), cleanupRollPresentation (copy)
    local t3 = t2

    if t3 ~= nil then
        if p16 then
            local cameraTween = t3.cameraTween

            if cameraTween ~= nil then
                cameraTween:Cancel()
            end

            t3.cameraTween = nil

            if t3.rollRiserThread ~= nil then
                task.cancel(t3.rollRiserThread)
            end

            t3.rollRiserThread = nil

            local rollVfxColorConnection = t3.rollVfxColorConnection

            if rollVfxColorConnection ~= nil then
                rollVfxColorConnection:Disconnect()
            end

            t3.rollVfxColorConnection = nil

            local rollVfxAnchor = t3.rollVfxAnchor

            if rollVfxAnchor ~= nil then
                rollVfxAnchor:Destroy()
            end

            t3.rollVfxAnchor = nil
            t3.camera.FieldOfView = 50

            local v41 = createAuraRollVfxAnchor(t3)

            if v41 ~= nil then
                t3.rollVfxAnchor = v41

                local v42 = attachAuraRollVfx(v41)

                if v42 ~= nil then
                    local v43 = tick()

                    local function v44() -- line: 239
                        -- upvalues: v42 (copy), v43 (copy), t1 (copy)
                        local v45 = (tick() - v43) / 0.12
                        local v46 = math.floor(v45) % #t1
                        local v47 = (v46 + 1) % #t1
                        local v48 = v45 % 1
                        local v49 = t1[v46 + 1]:Lerp(t1[v47 + 1], v48)

                        v42.Color = ColorSequence.new(v49)
                    end

                    v44()
                    t3.rollVfxColorConnection = RunService.RenderStepped:Connect(v44)
                end
            end

            t3.rollRiserThread = task.delay(1, function() -- line: 336
                -- upvalues: t3 (copy), playClonedSound (copy)
                playClonedSound("AuraRiser", {
                    timePosition = 1.65
                })
                t3.rollRiserThread = nil
            end)
            t3.camera.CameraType = Enum.CameraType.Scriptable
            t3.camera.CameraSubject = nil
            t3.camera.CFrame = t3.cameraAnchor.CFrame

            local v50 = TweenService:Create(t3.camera, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                FieldOfView = 34
            })

            t3.cameraTween = v50
            v50:Play()

            return
        end

        cleanupRollPresentation(t3, true)
    end

    return nil
end

local function setCharmPodiumSuccessPresentationActive(p17) -- line: 352
    -- upvalues: TweenService (copy), t2 (ref), cleanupRollPresentation (copy)
    local t4 = t2

    if t4 ~= nil then
        if p17 then
            local cameraTween = t4.cameraTween

            if cameraTween ~= nil then
                cameraTween:Cancel()
            end

            t4.cameraTween = nil

            if t4.rollRiserThread ~= nil then
                task.cancel(t4.rollRiserThread)
            end

            t4.rollRiserThread = nil

            local rollVfxColorConnection = t4.rollVfxColorConnection

            if rollVfxColorConnection ~= nil then
                rollVfxColorConnection:Disconnect()
            end

            t4.rollVfxColorConnection = nil

            local rollVfxAnchor = t4.rollVfxAnchor

            if rollVfxAnchor ~= nil then
                rollVfxAnchor:Destroy()
            end

            t4.rollVfxAnchor = nil
            t4.camera.FieldOfView = 50
            t4.camera.CameraType = Enum.CameraType.Scriptable
            t4.camera.CameraSubject = nil
            t4.camera.CFrame = t4.cameraAnchor.CFrame

            local v51 = TweenService:Create(t4.camera, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                FieldOfView = 27
            })

            t4.cameraTween = v51
            v51:Play()

            return
        end

        cleanupRollPresentation(t4, true)
    end

    return nil
end

local function isCharmPodiumFocusActive(p18) -- line: 371
    -- upvalues: t2 (ref)
    local v52 = p18 ~= nil

    if not v52 then
        return v52
    end

    local v53 = t2

    if v53 ~= nil then
        v53 = v53.token
    end

    return v53 == p18
end

function releaseCharmPodiumFocus() -- line: 383
    -- upvalues: t2 (ref)
    local t5 = t2

    t2 = nil

    if not t5 then
        return nil
    end

    local cameraTween = t5.cameraTween

    if cameraTween ~= nil then
        cameraTween:Cancel()
    end

    t5.cameraTween = nil

    if t5.rollRiserThread ~= nil then
        task.cancel(t5.rollRiserThread)
    end

    t5.rollRiserThread = nil

    local rollVfxColorConnection = t5.rollVfxColorConnection

    if rollVfxColorConnection ~= nil then
        rollVfxColorConnection:Disconnect()
    end

    t5.rollVfxColorConnection = nil

    local rollVfxAnchor = t5.rollVfxAnchor

    if rollVfxAnchor ~= nil then
        rollVfxAnchor:Destroy()
    end

    t5.rollVfxAnchor = nil
    t5.camera.FieldOfView = 50

    local previewPodium = t5.previewPodium

    if previewPodium ~= nil then
        previewPodium:Destroy()
    end

    t5.camera.CameraType = t5.snapshot.cameraType
    t5.camera.CameraSubject = t5.snapshot.cameraSubject
    t5.camera.CFrame = t5.snapshot.cframe
    t5.camera.FieldOfView = t5.snapshot.fieldOfView
end

return {
    charmPodiumPreviewFieldOfView = 50,
    getCharmPodiumPreviewRoom = getCharmPodiumPreviewRoom,
    focusCharmPodium = focusCharmPodium,
    setCharmPodiumRollPresentationActive = setCharmPodiumRollPresentationActive,
    setCharmPodiumSuccessPresentationActive = setCharmPodiumSuccessPresentationActive,
    isCharmPodiumFocusActive = isCharmPodiumFocusActive,
    releaseCharmPodiumFocus = releaseCharmPodiumFocus
}
