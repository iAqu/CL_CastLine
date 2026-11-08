-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Log = require(ReplicatedStorage.Packages.Log)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local PlacedEggRenderer = require(ReplicatedStorage.Shared.Eggs.PlacedEggRenderer)
local PlotState = require(ReplicatedStorage.Client.PlotState)

require(script.Parent.Types)

local PetUpdateSchedule = require(script.Parent.PetUpdateSchedule)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local v1 = Log.new()
local t1 = {}

t1.__index = t1
t1.__class = "AssetMovementBatch"
assert(workspace.Transient:IsA("Folder"), "Workspace.Transient must be a Folder")

local World = workspace.World

assert(World:IsA("Folder"), "Workspace.World must be a Folder")

local Areas = World.Areas

assert(Areas:IsA("Folder"), "Workspace.World.Areas must be a Folder")

local Ground = Areas.Ground

assert(Ground:IsA("BasePart"), "Workspace.World.Areas.Ground must be a BasePart")

function t1.new() -- line: 65
    -- upvalues: Trove (copy), v1 (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self._entries = {}
    self._orderedModels = {}
    self._partsBuffer = {}
    self._cframeBuffer = {}
    self._foreignEntryCount = 0
    self._foreignPresentationSuppressed = false
    self._foreignPresentationForcedSuppressed = false
    self._scheduleSettings = {
        Enabled = true,
        HiddenInterval = 0.1,
        DistantInterval = 0.1,
        DistantDistance = 300
    }
    self:_init()
    v1:AtDebug():Log("Created asset movement batch")

    return self
end

function t1._createGroundingRaycastParams(p1) -- line: 90
    -- upvalues: PlacedEggRenderer (copy), Ground (copy)
    local v3 = RaycastParams.new()

    v3.FilterType = Enum.RaycastFilterType.Include
    v3.FilterDescendantsInstances = {
        PlacedEggRenderer.GetRenderFolder(),
        Ground,
        p1
    }
    v3.IgnoreWater = true

    return v3
end

function t1._groundCFrame(p2, p3, p4) -- line: 102
    local Position = p3.Position
    local v4 = Position + Vector3.new(0, 64, 0)
    local v5 = workspace:Raycast(v4, Vector3.new(0, -2000, 0), p4)

    if v5 == nil then
        return nil
    end

    local v7 = Vector3.new(Position.X, v5.Position.Y - p2, Position.Z)

    return CFrame.new(v7) * p3.Rotation
end

function t1:_groundTargetCFrame() -- line: 120
    -- upvalues: t1 (copy)
    local v8 = t1._groundCFrame(self.BottomLocalY, self.TargetCFrame, self.GroundingRaycastParams)

    if v8 ~= nil then
        return v8
    end

    local TargetCFrame = self.TargetCFrame
    local TargetCFramePosition = TargetCFrame.Position
    local Y = self.SimulationCFrame.Position.Y

    return CFrame.new(TargetCFramePosition.X, Y, TargetCFramePosition.Z) * TargetCFrame.Rotation
end

function t1._movementAlpha(p6) -- line: 136
    return (math.clamp(p6 * 8, 0, 1))
end

function t1._airborneMovementAlpha(p7) -- line: 140
    return (math.clamp(p7 * 14, 0, 0.45))
end

function t1:_isPresentationEnabled(p9) -- line: 144
    return not self.PresentationHidden and (self.IsLocalOwner or not p9)
end

function t1:_advanceSuppressedSimulation() -- line: 151
    local TargetCFrame = self.TargetCFrame
    local TargetCFramePosition = TargetCFrame.Position
    local SimulationCFramePosition = self.SimulationCFrame.Position

    self.SimulationCFrame = CFrame.new(TargetCFramePosition.X, SimulationCFramePosition.Y, TargetCFramePosition.Z) * TargetCFrame.Rotation
end

function t1:_forgetEntry(p12) -- line: 159
    local v11 = self._entries[p12]

    if v11 ~= nil then
        if not v11.IsLocalOwner then
            assert(self._foreignEntryCount > 0, "Foreign movement entry count cannot underflow")
            self._foreignEntryCount -= 1
        end

        self._entries[p12] = nil
    end
end

function t1:_removeMissingModels() -- line: 170
    for i = #self._orderedModels, 1, -1 do
        local v13 = self._orderedModels[i]

        if self._entries[v13] == nil or v13.Parent == nil then
            self:_forgetEntry(v13)
            table.remove(self._orderedModels, i)
        end
    end
end

function t1:_flush(p15, p16) -- line: 182
    -- upvalues: t1 (copy)
    table.clear(self._partsBuffer)
    table.clear(self._cframeBuffer)

    for _, v14 in ipairs(self._orderedModels) do
        local v15 = self._entries[v14]

        if v15 ~= nil and v14.Parent ~= nil and t1._isPresentationEnabled(v15, p16) then
            local v16 = if v15.GroundingDue then t1._groundTargetCFrame(v15) else v15.SimulationCFrame

            v15.SimulationCFrame = v16

            if not v15.GroundingEnabled then
                v16 = v15.TargetCFrame
            end

            local v17 = if v15.GroundingEnabled then t1._movementAlpha(p15) else t1._airborneMovementAlpha(p15)

            if v15.CatchUpRemaining > 0 then
                v17 = math.clamp(p15 / v15.CatchUpRemaining, 0, 1)
                v15.CatchUpRemaining = math.max(v15.CatchUpRemaining - p15, 0)
            end

            local v20 = if v15.PresentationFrozen then v15.CurrentCFrame else v15.CurrentCFrame:Lerp(v16, v17)
            local v21 = v20 * v15.PresentationOffset
            local Pivot = v14:GetPivot()

            v15.CurrentCFrame = v20

            for _, v22 in ipairs(v15.VisibleParts) do
                if v22.Parent ~= nil then
                    table.insert(self._partsBuffer, v22)
                    table.insert(self._cframeBuffer, v21 * Pivot:ToObjectSpace(v22.CFrame))
                end
            end
        end
    end

    if #self._partsBuffer > 0 then
        workspace:BulkMoveTo(self._partsBuffer, self._cframeBuffer, Enum.BulkMoveMode.FireCFrameChanged)
    end
end

function t1:_step(p18) -- line: 234
    -- upvalues: PetUpdateSchedule (copy), GameFlags (copy), t1 (copy)
    self:_removeMissingModels()

    local _scheduleSettings = self._scheduleSettings

    _scheduleSettings.Enabled = GameFlags.PetUpdateSchedulingEnabled:Get()
    _scheduleSettings.HiddenInterval = GameFlags.HiddenPetUpdateInterval:Get()
    _scheduleSettings.DistantInterval = GameFlags.DistantPetUpdateInterval:Get()
    _scheduleSettings.DistantDistance = GameFlags.DistantPetUpdateDistance:Get()

    local CurrentCamera = workspace.CurrentCamera
    local Position = if CurrentCamera == nil then nil else CurrentCamera.CFrame.Position
    local v24 = self._foreignPresentationForcedSuppressed or self._foreignEntryCount >= 30
    local v25 = self._foreignPresentationSuppressed ~= v24
    local v26 = self._foreignPresentationSuppressed and not v24

    self._foreignPresentationSuppressed = v24

    for _, v27 in ipairs(self._orderedModels) do
        local v28 = self._entries[v27]

        if v28 ~= nil and v27.Parent ~= nil then
            local v29 = if v28.PresentationHidden or v28.IsLocalOwner or Position == nil then 0 else v28.VisualRadius * (v27:GetScale() / v28.InitialScale)
            local v30 = PetUpdateSchedule.GetInterval(v28.PresentationHidden, v28.IsLocalOwner, v28.CurrentCFrame.Position, v29, Position, _scheduleSettings)
            local v31, v32, v33 = PetUpdateSchedule.TakeStep(v28.StepElapsed, p18, v30, v28.ForceStep or v25)

            v28.StepElapsed = v33
            v28.ForceStep = false
            v28.GroundingDue = v31

            if v31 then
                v28.Step(v32, not v28.IsLocalOwner and v24)
            end

            if v28.PresentationHidden then
                t1._advanceSuppressedSimulation(v28)
            elseif v28.IsLocalOwner then
                if not v28.IsLocalOwner and v26 then
                    v28.CatchUpRemaining = math.max(v28.CatchUpRemaining, 0.25)
                end
            elseif v24 then
                t1._advanceSuppressedSimulation(v28)
            elseif not v28.IsLocalOwner and v26 then
                v28.CatchUpRemaining = math.max(v28.CatchUpRemaining, 0.25)
            end
        end
    end

    self:_flush(p18, v24)
end

function t1:Add(p20, p21, p22, p23, p24, p25, p26) -- line: 283
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p20)
    t.strict(t.array(t.instanceIsA("BasePart")))(p21)
    t.strict(t.CFrame)(p22)
    t.strict(t.number)(p23)
    t.strict(t.instanceIsA("BasePart"))(p24)
    t.strict(t.boolean)(p25)
    assert(self._entries[p20] == nil, (("Asset model %* is already registered in the movement batch"):format(p20.Name)))

    local v36 = t1._createGroundingRaycastParams(p24)
    local v37 = t1._groundCFrame(p23, p22, v36) or p22
    local BoundingBox, BoundingBox2 = p20:GetBoundingBox()
    local v38 = BoundingBox2.Magnitude * 0.5 + (BoundingBox.Position - p20:GetPivot().Position).Magnitude

    self._entries[p20] = {
        GroundingEnabled = true,
        PresentationFrozen = false,
        CatchUpRemaining = 0,
        PresentationHidden = false,
        StepElapsed = 0,
        ForceStep = true,
        GroundingDue = true,
        Model = p20,
        VisibleParts = p21,
        AssetArea = p24,
        GroundingRaycastParams = v36,
        IsLocalOwner = p25,
        BottomLocalY = p23,
        TargetCFrame = p22,
        CurrentCFrame = p22,
        SimulationCFrame = v37,
        Step = p26,
        PresentationOffset = CFrame.identity,
        VisualRadius = v38,
        InitialScale = p20:GetScale()
    }

    if not p25 then
        self._foreignEntryCount += 1
    end

    table.insert(self._orderedModels, p20)
end

function t1:GetSimulationCFrame(p28) -- line: 341
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p28)

    local v39 = self._entries[p28]

    assert(v39 ~= nil, (("Asset model %* is not registered in the movement batch"):format(p28.Name)))

    return v39.SimulationCFrame
end

function t1:ResolveGroundedCFrame(p30) -- line: 350
    -- upvalues: t (copy), ModelBounds (copy), PlacedEggRenderer (copy), PlotState (copy), t1 (copy), Ground (copy)
    t.strict(t.instanceIsA("Model"))(self)
    t.strict(t.CFrame)(p30)

    local v42, v43 = ModelBounds(self)
    local v44 = self:GetPivot():PointToObjectSpace(v42.Position).Y - v43.Y * 0.5
    local t3 = {
        PlacedEggRenderer.GetRenderFolder(),
        Ground
    }
    local v45 = PlotState.ResolvePlot()

    if v45 and v45.PetArea then
        table.insert(t3, v45.PetArea)
    end

    local v46 = RaycastParams.new()

    v46.FilterType = Enum.RaycastFilterType.Include
    v46.FilterDescendantsInstances = t3
    v46.IgnoreWater = true

    return t1._groundCFrame(v44, p30, v46) or p30
end

function t1:SetAssetArea(p32, p33) -- line: 373
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p32)
    t.strict(t.instanceIsA("BasePart"))(p33)

    local v47 = self._entries[p32]

    assert(v47 ~= nil, (("Asset model %* is not registered in the movement batch"):format(p32.Name)))

    if v47.AssetArea == p33 then
        return
    end

    v47.AssetArea = p33
    v47.GroundingRaycastParams = t1._createGroundingRaycastParams(p33)
    v47.ForceStep = true
end

function t1:SetTarget(p35, p36) -- line: 392
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p35)
    t.strict(t.CFrame)(p36)

    local v50 = self._entries[p35]

    assert(v50 ~= nil, (("Asset model %* is not registered in the movement batch"):format(p35.Name)))
    v50.TargetCFrame = p36
end

function t1:SetGroundingEnabled(p38, p39) -- line: 402
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p38)
    t.strict(t.boolean)(p39)

    local v53 = self._entries[p38]

    assert(v53 ~= nil, (("Asset model %* is not registered in the movement batch"):format(p38.Name)))
    v53.GroundingEnabled = p39
end

function t1:SetPresentationFrozen(p41, p42, p43) -- line: 416
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p41)
    t.strict(t.boolean)(p42)
    t.strict(t.optional(t.number))(p43)

    local v56 = self._entries[p41]

    assert(v56 ~= nil, (("Asset model %* is not registered in the movement batch"):format(p41.Name)))
    v56.PresentationFrozen = p42

    if p42 then
        v56.CatchUpRemaining = 0
    else
        v56.CatchUpRemaining = math.max(p43 or 0, 0)
    end
end

function t1:SetPresentationOffset(p45, p46) -- line: 432
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p45)
    t.strict(t.CFrame)(p46)

    local v60 = self._entries[p45]

    assert(v60 ~= nil, (("Asset model %* is not registered in the movement batch"):format(p45.Name)))
    v60.PresentationOffset = p46
end

function t1:SetHidden(p48, p49) -- line: 445
    local v63 = self._entries[p48]

    assert(v63 ~= nil, "Asset model must be registered before changing visibility")

    if v63.PresentationHidden == p49 then
        return
    end

    v63.PresentationHidden = p49
    v63.ForceStep = true

    if not p49 then
        v63.CatchUpRemaining = math.max(v63.CatchUpRemaining, 0.25)
    end
end

function t1:SetForeignPresentationSuppressed(p51) -- line: 458
    -- upvalues: t (copy)
    t.strict(t.boolean)(p51)
    self._foreignPresentationForcedSuppressed = p51
end

function t1:Remove(p53) -- line: 466
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p53)
    self:_forgetEntry(p53)

    for i = #self._orderedModels, 1, -1 do
        if self._orderedModels[i] == p53 then
            table.remove(self._orderedModels, i)

            return
        end
    end
end

function t1:Destroy() -- line: 478
    self._trove:Destroy()
    table.clear(self._entries)
    table.clear(self._orderedModels)
    table.clear(self._partsBuffer)
    table.clear(self._cframeBuffer)
    self._foreignEntryCount = 0
    self._foreignPresentationSuppressed = false
    self._foreignPresentationForcedSuppressed = false
end

function t1:_init() -- line: 493
    -- upvalues: RunService (copy)
    self._trove:Add(RunService.PreRender:Connect(function(p56) -- line: 494
        -- upvalues: self (copy)
        self:_step(p56)
    end))
end

return t1
