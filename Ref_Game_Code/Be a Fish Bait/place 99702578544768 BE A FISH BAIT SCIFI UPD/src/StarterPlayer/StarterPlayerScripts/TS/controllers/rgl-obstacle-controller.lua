-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Debris, ReplicatedStorage, Workspace = services.Debris, services.ReplicatedStorage, services.Workspace
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local vfx = RuntimeLib.import(script, script.Parent.Parent, "vfx")
local cloneScopedVfxAtCFrame, playClonedSoundAtCFrame, playClonedVfxAtCFrame = vfx.cloneScopedVfxAtCFrame, vfx.playClonedSoundAtCFrame, vfx.playClonedVfxAtCFrame
local fishDataByName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").fishDataByName
local rglConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "rgl-config").rglConfig
local getRglObstacleFallingCFrame = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "rgl-obstacle-utils").getRglObstacleFallingCFrame
local getPortalTargetScale, randomUnitVector, randomBetween
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 21
        return "RglObstacleController"
    end
})

self.__index = self

function self.new(...) -- line: 26
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 30
    p1._obstacles = {}
    p1._warned = {}
end

function self.onStart(p2) -- line: 34
    -- upvalues: Workspace (copy), events (copy)
    events.rglSessionStarted:connect(function(p3) -- line: 35
        -- upvalues: p2 (copy)
        p2:_cleanup()
        p2._sessionId = p3.sessionId
        p2:_createFragmentFolder(p3.sessionId)
    end)
    events.rglObstacleSpawned:connect(function(p4) -- line: 40
        -- upvalues: p2 (copy)
        if p4.sessionId ~= p2._sessionId then
            return nil
        end

        p2:_createObstacle(p4)
    end)
    events.rglObstacleRemoved:connect(function(p5, p6) -- line: 46
        -- upvalues: p2 (copy), Workspace (copy)
        if p5 ~= p2._sessionId then
            return nil
        end

        local v3 = p2._obstacles[p6]

        if not v3 then
            return nil
        end

        p2:_removeObstacle(p6, Workspace:GetServerTimeNow() >= v3.descriptor.expiresAt)
    end)
    events.rglObstaclesCleared:connect(function(p7) -- line: 59
        -- upvalues: p2 (copy)
        if p7 == p2._sessionId then
            p2:_clearObstacles()
        end
    end)
    events.rglSessionEnded:connect(function(p8) -- line: 64
        -- upvalues: p2 (copy)
        if p8 == p2._sessionId then
            p2:_cleanup()
        end
    end)
end

function self.onRender(p9) -- line: 70
    -- upvalues: Workspace (copy), playClonedSoundAtCFrame (copy), playClonedVfxAtCFrame (copy), rglConfig (copy), getRglObstacleFallingCFrame (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local t4 = {}

    for v5, v6 in p9._obstacles do
        local descriptor = v6.descriptor

        if descriptor.expiresAt <= ServerTimeNow then
            table.insert(t4, v5)
        else
            if descriptor.warningAppearsAt <= ServerTimeNow and ServerTimeNow < descriptor.fallsAt then
                p9:_ensureWarning(v6)

                local v9 = math.floor((ServerTimeNow - descriptor.blinkingStartsAt) / math.max(0.01, rglConfig.warningBlinkIntervalSeconds))

                p9:_setWarningVisible(v6, ServerTimeNow < descriptor.blinkingStartsAt or v9 % 2 == 0)
            elseif v6.warning then
                v6.warning:Destroy()
                v6.warning = nil
                table.clear(v6.warningTransparency)
            end

            if ServerTimeNow < descriptor.fallsAt then
                p9:_updateReveal(v6, ServerTimeNow)
                v6.model:PivotTo(descriptor.skyCFrame)
            elseif ServerTimeNow < descriptor.landsAt then
                v6.model:PivotTo(getRglObstacleFallingCFrame(descriptor, ServerTimeNow))
            else
                local portal = v6.portal

                if portal ~= nil then
                    portal:Destroy()
                end

                v6.portal = nil
                v6.model:PivotTo(descriptor.landingCFrame)

                if not v6.landingVfxPlayed then
                    v6.landingVfxPlayed = true

                    local Pivot = v6.model:GetPivot()

                    playClonedVfxAtCFrame(rglConfig.landingVfxName, Pivot, rglConfig.obstacleVfxFolderName, rglConfig.landingVfxLifetimeSeconds)
                    playClonedSoundAtCFrame(rglConfig.landingSfxName, Pivot)
                end

                if not v6.grounded then
                    v6.grounded = true
                    p9:_setModelGrounded(v6.model)
                end
            end
        end
    end

    for _, v10 in t4 do
        p9:_removeObstacle(v10, true)
    end
end

function self._createObstacle(p10, p11) -- line: 119
    -- upvalues: Workspace (copy), cloneScopedVfxAtCFrame (copy), playClonedSoundAtCFrame (copy), fishDataByName (copy), rglConfig (copy), getPortalTargetScale (ref)
    if p10._obstacles[p11.obstacleId] ~= nil then
        return nil
    end

    local v11 = fishDataByName[p11.fishId]

    if v11 ~= nil then
        v11 = v11.model
    end

    if v11 and v11:IsA("Model") and v11.Parent ~= nil then
        local clone = v11:Clone()

        clone.Name = ("RglObstacle-%*"):format(p11.obstacleId)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
                descendant:Destroy()
            elseif descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end

        clone:ScaleTo((math.max(0.001, rglConfig.obstacleModelScale * 0.001)))
        clone.Parent = Workspace
        clone:PivotTo(p11.skyCFrame)

        local v13 = cloneScopedVfxAtCFrame(rglConfig.spawnVfxName, p11.skyCFrame, rglConfig.obstacleVfxFolderName)
        local v14 = Vector3.new(rglConfig.spawnVfxSizeStuds, rglConfig.spawnVfxSizeStuds, rglConfig.spawnVfxSizeStuds)
        local v15 = if if v13 == nil then v13 else v13:IsA("Model") then getPortalTargetScale(v13, v14) else nil

        if not (if v13 == nil then v13 else v13:IsA("BasePart")) then
            v14 = nil
        end

        local _obstacles = p10._obstacles
        local obstacleId = p11.obstacleId
        local t5 = {
            grounded = false,
            landingVfxPlayed = false,
            descriptor = p11,
            model = clone
        }

        t5.portal = if (if v13 == nil then v13 else v13:IsA("BasePart")) or (if v13 == nil then v13 else v13:IsA("Model")) then v13 else nil
        t5.portalBaseSize = if if v13 == nil then v13 else v13:IsA("BasePart") then v13.Size else nil
        t5.portalTargetScale = v15
        t5.portalTargetSize = v14
        t5.warningTransparency = {}
        _obstacles[obstacleId] = t5
        playClonedSoundAtCFrame(rglConfig.spawnSfxName, p11.skyCFrame)

        return
    end

    p10:_warnOnce(("fish-%*"):format(p11.fishId), (("RGL obstacles: fish model \"%*\" is unavailable on the client"):format(p11.fishId)))

    return nil
end

function self._updateReveal(_, p13, p14) -- line: 198
    -- upvalues: rglConfig (copy)
    local v16 = math.max(0.001, rglConfig.portalScaleUpSeconds)
    local v17 = math.max(0.001, rglConfig.modelScaleUpSeconds)
    local v19 = math.clamp((p14 - p13.descriptor.spawnedAt) / v16, 0, 1)
    local v21 = math.clamp((p14 - p13.descriptor.spawnedAt - v16) / v17, 0, 1)
    local portal = p13.portal

    if portal and p13.descriptor.spawnedAt + rglConfig.spawnVfxLifetimeSeconds <= p14 then
        portal:Destroy()
        p13.portal = nil
    end

    if (if portal == nil then portal else portal:IsA("Model")) and p13.portalTargetScale ~= nil then
        portal:ScaleTo((math.max(0.001, p13.portalTargetScale * v19)))
    elseif (if portal == nil then portal else portal:IsA("BasePart")) and p13.portalBaseSize and p13.portalTargetSize then
        portal.Size = p13.portalBaseSize:Lerp(p13.portalTargetSize, v19)
    end

    p13.model:ScaleTo((math.max(0.001, rglConfig.obstacleModelScale * v21)))
end

function self._ensureWarning(p15, p16) -- line: 233
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), rglConfig (copy)
    local warning = p16.warning

    if warning ~= nil then
        warning = warning.Parent
    end

    if warning ~= nil then
        return nil
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild(rglConfig.obstacleVfxFolderName)

        if VFX ~= nil then
            VFX = VFX:FindFirstChild(rglConfig.warningTemplateName)
        end
    end

    local v24 = not (if VFX == nil then VFX else VFX:IsA("BasePart"))

    v24 = v24 and not (if VFX == nil then VFX else VFX:IsA("Model"))

    if v24 then
        p15:_warnOnce("warning", (("RGL obstacles: ReplicatedStorage.VFX.%*.%* is missing or not a Model/BasePart"):format(rglConfig.obstacleVfxFolderName, rglConfig.warningTemplateName)))

        return nil
    end

    local clone = VFX:Clone()

    clone.Name = ("RglObstacleWarning-%*"):format(p16.descriptor.obstacleId)

    local v25 = p16.descriptor.boundsSize.X + rglConfig.warningFootprintPaddingStuds
    local v26 = p16.descriptor.boundsSize.Z + rglConfig.warningFootprintPaddingStuds

    if clone:IsA("BasePart") then
        clone.Anchored = true
        clone.CanCollide = false
        clone.CanQuery = false
        clone.CanTouch = false
        clone.Size = Vector3.new(v25, clone.Size.Y, v26)
        clone.CFrame = p16.descriptor.warningCFrame + Vector3.new(0, clone.Size.Y / 2, 0)
    else
        local _, BoundingBox = clone:GetBoundingBox()

        clone:ScaleTo((math.min(v25 / math.max(0.01, BoundingBox.X), v26 / math.max(0.01, BoundingBox.Z))))
        clone:PivotTo(p16.descriptor.warningCFrame)
    end

    clone.Parent = Workspace
    p16.warning = clone
    table.clear(p16.warningTransparency)

    local t6 = {
        clone
    }
    local v30 = #t6
    local Descendants = clone:GetDescendants()

    table.move(Descendants, 1, #Descendants, v30 + 1, t6)

    for _, v31 in t6 do
        if v31:IsA("BasePart") or v31:IsA("Decal") or v31:IsA("Texture") then
            p16.warningTransparency[v31] = v31.Transparency
        end

        if v31:IsA("BasePart") then
            v31.Anchored = true
            v31.CanCollide = false
            v31.CanQuery = false
            v31.CanTouch = false
        end
    end
end

function self._setWarningVisible(_, p18, p19) -- line: 306
    for v32, v33 in p18.warningTransparency do
        if v32.Parent ~= nil then
            if p19 then
                v32.Transparency = v33
            else
                v32.Transparency = 1
            end
        end
    end
end

function self._setModelGrounded(_, p21) -- line: 313
    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = true
            descendant.CanQuery = true
            descendant.CanTouch = false
        end
    end
end

function self._removeObstacle(p22, p23, p24) -- line: 324
    local v34 = p22._obstacles[p23]

    if not v34 then
        return nil
    end

    p22._obstacles[p23] = nil

    local warning = v34.warning

    if warning ~= nil then
        warning:Destroy()
    end

    if p24 then
        p22:_explodeModel(v34.model)
    end

    v34.model:Destroy()
end

function self._explodeModel(p25, p26) -- line: 343
    -- upvalues: Debris (copy), rglConfig (copy), randomUnitVector (ref), randomBetween (ref)
    if p26.Parent == nil then
        return nil
    end

    local _fragmentFolder = p25._fragmentFolder

    if not _fragmentFolder or _fragmentFolder.Parent == nil then
        return nil
    end

    local BoundingBox, BoundingBox2 = p26:GetBoundingBox()
    local Descendants = p26:GetDescendants()
    local t7 = {}

    local function v35(p27) -- line: 355
        return p27:IsA("BasePart")
    end

    local n1 = 0

    for v36, v37 in Descendants do
        local _ = v36 - 1

        if v37:IsA("BasePart") == true then
            n1 += 1
            t7[n1] = v37
        end
    end

    if #t7 == 0 then
        return nil
    end

    local v38 = math.max(0.25, rglConfig.voxelSizeStuds)
    local v41 = math.max(1, (math.ceil(BoundingBox2.X / v38)))
    local v44 = math.max(1, (math.ceil(BoundingBox2.Y / v38)))
    local v47 = math.max(1, (math.ceil(BoundingBox2.Z / v38)))
    local v51 = Vector3.new(BoundingBox2.X / v41, BoundingBox2.Y / v44, BoundingBox2.Z / v47)
    local v52 = v41 * v44 * v47
    local v53 = math.min(v52, rglConfig.voxelFragmentLimit)
    local n2 = 0
    local v54 = false

    while true do
        if v54 then
            n2 += 1
        else
            v54 = true
        end

        if not (n2 < v53) then
            break
        end

        local v56 = math.floor(n2 * v52 / v53)
        local v58 = math.floor(v56 / (v44 * v47))
        local v59 = v56 % (v44 * v47)
        local v61 = math.floor(v59 / v47)
        local v62 = v59 % v47
        local v66 = Vector3.new(-BoundingBox2.X / 2 + (v58 + 0.5) * v51.X, -BoundingBox2.Y / 2 + (v61 + 0.5) * v51.Y, -BoundingBox2.Z / 2 + (v62 + 0.5) * v51.Z)
        local Part = Instance.new("Part")
        local v67 = t7[math.random(0, #t7 - 1) + 1]

        Part.Name = "RglObstacleVoxel"
        Part.Size = v51
        Part.Color = v67.Color
        Part.Material = v67.Material
        Part.CFrame = BoundingBox * CFrame.new(v66)
        Part.Anchored = false
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Parent = _fragmentFolder
        Part.AssemblyLinearVelocity = (if v66.Magnitude > 0.01 then v66.Unit else randomUnitVector()) * randomBetween(rglConfig.voxelImpulseMinStudsPerSecond, rglConfig.voxelImpulseMaxStudsPerSecond)
        Part.AssemblyAngularVelocity = randomUnitVector() * randomBetween(3, 8)
        Debris:AddItem(Part, rglConfig.voxelFragmentLifetimeSeconds)
    end
end

function self._createFragmentFolder(p28, p29) -- line: 418
    -- upvalues: Workspace (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = ("RglObstacleFragments-%*"):format(p29)
    Folder.Parent = Workspace
    p28._fragmentFolder = Folder
end

function self._clearObstacles(p30) -- line: 424
    for _, v68 in p30._obstacles do
        local warning = v68.warning

        if warning ~= nil then
            warning:Destroy()
        end

        v68.model:Destroy()
    end

    table.clear(p30._obstacles)

    local _fragmentFolder = p30._fragmentFolder

    if _fragmentFolder ~= nil then
        _fragmentFolder:ClearAllChildren()
    end
end

function self._cleanup(p31) -- line: 438
    p31:_clearObstacles()

    local _fragmentFolder = p31._fragmentFolder

    if _fragmentFolder ~= nil then
        _fragmentFolder:Destroy()
    end

    p31._fragmentFolder = nil
    p31._sessionId = nil
end

function self._warnOnce(p32, p33, p34) -- line: 447
    if p32._warned[p33] ~= nil then
        return nil
    end

    p32._warned[p33] = true
    warn(p34)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/rgl-obstacle-controller@RglObstacleController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

function getPortalTargetScale(p35, p36) -- line: 466
    local _, BoundingBox = p35:GetBoundingBox()

    return (math.max(0.001, p36.X / math.max(0.001, BoundingBox.X), p36.Y / math.max(0.001, BoundingBox.Y), p36.Z / math.max(0.001, BoundingBox.Z)))
end

function randomBetween(p37, p38) -- line: 470
    return p37 + math.random() * (p38 - p37)
end

function randomUnitVector() -- line: 473
    local v75 = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1)

    if v75.Magnitude > 0.01 then
        return v75.Unit
    end

    return (Vector3.new(0, 1, 0))
end

return {
    RglObstacleController = self
}
