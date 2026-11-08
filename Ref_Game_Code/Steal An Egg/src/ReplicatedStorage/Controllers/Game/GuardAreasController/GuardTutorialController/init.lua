-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Globals.Constants)

local GuardTutorialFlags = require(ReplicatedStorage.Shared.Flags.GuardTutorialFlags)
local GuardTutorialPresentation = require(ReplicatedStorage.Client.GuardTutorialPresentation)
local GuardTutorialSteps = require(ReplicatedStorage.Data.GuardTutorialSteps)
local GuardTutorial = require(ReplicatedStorage.Shared.Types.GuardTutorial)
local Log = require(ReplicatedStorage.Packages.Log)
local MilestoneAdapter = require(script.MilestoneAdapter)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local Promise = require(ReplicatedStorage.Packages.Promise)
local OnboardingTiming = require(ReplicatedStorage.Shared.Util.OnboardingTiming)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Types.Interface)

local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local EquipEgg = require(script.Steps.EquipEgg)
local ExpandPen = require(script.Steps.ExpandPen)
local HatchEgg = require(script.Steps.HatchEgg)
local HeadToPen = require(script.Steps.HeadToPen)
local PlaceEgg = require(script.Steps.PlaceEgg)
local PlacePet = require(script.Steps.PlacePet)
local StealEgg = require(script.Steps.StealEgg)
local TreadmillIntro = require(script.Steps.TreadmillIntro)
local t1 = {}

t1.__index = t1
t1.__class = "GuardTutorialController"

local t2 = {
    [StealEgg.StepId] = StealEgg,
    [HeadToPen.StepId] = HeadToPen,
    [EquipEgg.StepId] = EquipEgg,
    [PlaceEgg.StepId] = PlaceEgg,
    [HatchEgg.StepId] = HatchEgg,
    [PlacePet.StepId] = PlacePet,
    [ExpandPen.StepId] = ExpandPen,
    [TreadmillIntro.StepId] = TreadmillIntro
}
local v1 = Log.new()
local LocalPlayer = Players.LocalPlayer

local function isRacing() -- line: 97
    -- upvalues: MountRace (copy), LocalPlayer (copy)
    return LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil
end

local function getProgressIndex(p1) -- line: 101
    -- upvalues: GuardTutorialSteps (copy)
    if p1.Completed then
        return 1e999
    end

    local CurrentStepId = p1.CurrentStepId

    return CurrentStepId ~= nil and GuardTutorialSteps.GetIndex(CurrentStepId) or 0
end

function t1.new() -- line: 118
    -- upvalues: GuardTutorialPresentation (copy), GuardTutorial (copy), MilestoneAdapter (copy), Trove (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._activeStepCleanup = nil
    self._activeStepId = nil
    self._adapter = MilestoneAdapter.new()
    self._currentProgress = GuardTutorial.CopyProgress(GuardTutorial.DEFAULT_PROGRESS)
    self._lastStoredIndex = nil
    self._presentation = GuardTutorialPresentation.new()
    self._refreshGeneration = 0
    self._retryScheduled = false
    self._runtimeEnabled = false
    self._runtimeRevision = -1
    self._runtimeStateReady = false
    self._runtimeStateRequestPending = false
    self._pauseNotificationShown = false
    self._pausedForAdminAbuse = false
    self._started = false
    self._trove = Trove.new()

    return self
end

function t1:_clearActiveStep() -- line: 145
    local _activeStepCleanup = self._activeStepCleanup

    if _activeStepCleanup ~= nil then
        self._activeStepCleanup = nil
        _activeStepCleanup()
    end

    self._presentation:DropEverything()
    self._activeStepId = nil
end

function t1:_maybeShowPauseNotification() -- line: 155
    -- upvalues: ReplicatedStorage (copy), GuardTutorialFlags (copy), Save (copy)
    if not self._pauseNotificationShown and self._runtimeStateReady and not self._runtimeEnabled and self._pausedForAdminAbuse and GuardTutorialFlags.PauseNotificationEnabled:Get() and Save.IsLoaded() and not self:_readStoredProgress().Completed then
        self._pauseNotificationShown = true
        require(ReplicatedStorage.Client.Notifications.Toast).Show({
            Lane = "Banner",
            Text = "Tutorial paused during Admin Abuse. It will resume after the event.",
            Seconds = 5,
            ShowShadow = true,
            Unique = true,
            Color = Color3.new(1, 1, 1)
        })
    end
end

function t1:_applyRuntimeState(p5) -- line: 183
    -- upvalues: OnboardingTiming (copy)
    if p5.Revision < self._runtimeRevision then
        return
    end

    local _runtimeStateReady, _runtimeEnabled = self._runtimeStateReady, self._runtimeEnabled

    self._runtimeEnabled = p5.Enabled
    self._runtimeRevision = p5.Revision
    self._runtimeStateReady = true
    OnboardingTiming.Mark("TutorialRuntimeReady")
    self._pausedForAdminAbuse = p5.PausedForAdminAbuse

    if not p5.PausedForAdminAbuse then
        self._pauseNotificationShown = false
    end

    if p5.Enabled then
        if not _runtimeStateReady or not _runtimeEnabled then
            self:RefreshProgress()
        end
    else
        self:_clearActiveStep()
        self._refreshGeneration += 1
        self:_maybeShowPauseNotification()
    end
end

function t1:_requestRuntimeState() -- line: 215
    -- upvalues: GuardTutorial (copy), Promise (copy), Remotes (copy)
    if self._runtimeStateRequestPending then
        return false
    end

    self._runtimeStateRequestPending = true

    local v3, v4 = Promise.try(function() -- line: 221
        -- upvalues: Remotes (copy)
        return Remotes.GuardOnboarding.AskLiveState:InvokeServer()
    end):timeout(30):await()

    self._runtimeStateRequestPending = false

    if v3 and self._started then
        if not GuardTutorial.SchemaValidation.RuntimeState(v4) then
            return false
        end

        self:_applyRuntimeState(v4)

        return true
    end

    return false
end

function t1:_queueRuntimeStateRetry() -- line: 238
    -- upvalues: Timer (copy)
    if self._runtimeStateReady or not self._started then
        return
    end

    local v5

    v5 = Timer.Simple(0.5, function() -- line: 244
        -- upvalues: self (copy), v5 (ref)
        if not self._started or self._runtimeStateReady or self:_requestRuntimeState() then
            local v6 = v5

            if v6 ~= nil then
                v6:Disconnect()
            end
        end
    end)
    self._trove:Add(v5)
end

function t1._readStoredProgress(_) -- line: 255
    -- upvalues: GuardTutorial (copy), Save (copy)
    local v7 = Save.Await()

    if v7 == nil then
        return GuardTutorial.CopyProgress(GuardTutorial.DEFAULT_PROGRESS)
    end

    return GuardTutorial.SanitizeProgress(v7.GuardTutorialProgress)
end

function t1._syncProgress(_, p10) -- line: 266
    -- upvalues: GuardTutorial (copy), Remotes (copy), TryCall (copy)
    local v8, v9, v10 = TryCall(function() -- line: 271
        -- upvalues: p10 (copy), Remotes (copy)
        return Remotes.GuardOnboarding.AskProgressSync:InvokeServer(p10)
    end)

    if not v8 or v9 ~= true then
        return nil
    end

    local v11, v12 = GuardTutorial.SchemaValidation.Progress(v10)

    assert(v11, v12)

    return GuardTutorial.SanitizeProgress(v10)
end

function t1:_queueSyncRetry() -- line: 285
    -- upvalues: v1 (copy)
    if self._retryScheduled or not self._started or not self._runtimeStateReady or not self._runtimeEnabled then
        return
    end

    v1:AtTrace():Log("[GuardTutorialController] Queueing tutorial progress sync retry")
    self._retryScheduled = true
    task.delay(0.5, function() -- line: 297
        -- upvalues: self (copy)
        if self._started and self._runtimeStateReady and self._runtimeEnabled then
            self._retryScheduled = false
            self:RefreshProgress()
        else
            self._retryScheduled = false
        end
    end)
end

function t1:_resolveNextProgress(p13) -- line: 308
    -- upvalues: GuardTutorialSteps (copy), GuardTutorial (copy), t2 (copy)
    if p13.Completed then
        return GuardTutorial.CopyProgress(p13)
    end

    if not self._currentProgress.Completed then
        local v13 = GuardTutorialSteps.GetOrderedStepIds()
        local v14

        if p13.CurrentStepId ~= nil then
            v14 = GuardTutorialSteps.GetIndex(p13.CurrentStepId)
            assert(v14 ~= nil, (("Unknown guard tutorial step id: %*"):format(p13.CurrentStepId)))
        else
            v14 = 1
        end

        local CurrentStepId = self._currentProgress.CurrentStepId

        if CurrentStepId ~= nil then
            local v18 = GuardTutorialSteps.GetIndex(CurrentStepId)

            if v18 ~= nil and v14 < v18 then
                v14 = v18
            end
        end

        for i = v14, #v13 do
            local v19 = v13[i]
            local v20 = t2[v19]

            assert(v20 ~= nil, (("Missing guard tutorial step module for %*"):format(v19)))

            if not v20.IsSatisfied(self._adapter) then
                return {
                    Completed = false,
                    CurrentStepId = v19
                }
            end
        end
    end

    return {
        Completed = true,
        CurrentStepId = nil
    }
end

function t1:_bindCurrentStep() -- line: 361
    -- upvalues: t2 (copy)
    local CurrentStepId = self._currentProgress.CurrentStepId

    if self._currentProgress.Completed or CurrentStepId == nil then
        self:_clearActiveStep()
    elseif self._activeStepId ~= CurrentStepId or self._activeStepCleanup == nil then
        self:_clearActiveStep()

        local v23 = t2[CurrentStepId]

        assert(v23 ~= nil, (("Missing guard tutorial step module for %*"):format(CurrentStepId)))
        self._activeStepId = CurrentStepId

        local v26 = if v23.Present ~= nil then v23.Present(self._presentation, self._adapter) else nil
        local v27 = v23.Bind(self._adapter, function() -- line: 383
            -- upvalues: self (copy), CurrentStepId (copy)
            if not self._currentProgress.Completed and self._currentProgress.CurrentStepId == CurrentStepId then
                self:RefreshProgress()
            end
        end)

        self._activeStepCleanup = function() -- line: 390
            -- upvalues: self (copy), v26 (copy), v27 (copy)
            v27()

            if v26 ~= nil then
                v26()
            end

            self._presentation:DropEverything()
        end
    end
end

function t1:_startAfterReadiness() -- line: 399
    local v28 = self:_readStoredProgress()

    self._currentProgress = v28

    if v28.Completed then
        self:_clearActiveStep()
    else
        self:RefreshProgress()
        self:_maybeShowPauseNotification()
    end
end

function t1:Start() -- line: 416
    -- upvalues: GuardTutorialFlags (copy), GuardTutorial (copy), MountRace (copy), Remotes (copy), Save (copy), LocalPlayer (copy)
    if self._started then
        return
    end

    self._started = true
    self._trove:Add(Remotes.GuardOnboarding.LiveStateShifted.OnClientEvent:Connect(function(p17) -- line: 424
        -- upvalues: self (copy), GuardTutorial (copy)
        if GuardTutorial.SchemaValidation.RuntimeState(p17) then
            self:_applyRuntimeState(p17)
        end
    end))
    self._trove:Add(GuardTutorialFlags.PauseNotificationEnabled.Changed:Connect(function(p18) -- line: 432
        -- upvalues: self (copy)
        if p18 then
            self:_maybeShowPauseNotification()
        else
            self._pauseNotificationShown = false
        end
    end))
    task.spawn(function() -- line: 440
        -- upvalues: self (copy)
        if not self:_requestRuntimeState() then
            self:_queueRuntimeStateRetry()
        end
    end)
    self._trove:Add(self._adapter.Changed:Connect(function() -- line: 446
        -- upvalues: self (copy)
        self:RefreshProgress()
    end))
    self._trove:Add(LocalPlayer:GetAttributeChangedSignal(MountRace.PlayerAttributes.RaceId):Connect(function() -- line: 448
        -- upvalues: self (copy), MountRace (copy), LocalPlayer (copy)
        if LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil then
            self:_clearActiveStep()
            self._refreshGeneration += 1
        else
            self:RefreshProgress()
        end
    end))
    self._trove:Add(Save.Watch("GuardTutorialProgress"):Connect(function() -- line: 458
        -- upvalues: self (copy)
        self:RefreshProgress()
    end))

    if Save.IsLoaded() then
        self:_startAfterReadiness()
    else
        local connection = Save.Loaded:Connect(function() -- line: 466
            -- upvalues: self (copy)
            self:_startAfterReadiness()
        end)

        self._trove:Add(connection)

        if Save.IsLoaded() then
            connection:Disconnect()
            self:_startAfterReadiness()
        end
    end
end

function t1:RefreshProgress() -- line: 475
    -- upvalues: GuardTutorialSteps (copy), GuardTutorial (copy), MountRace (copy), OnboardingTiming (copy), Save (copy), LocalPlayer (copy)
    if not self._started or not self._runtimeStateReady or not self._runtimeEnabled or not Save.IsLoaded() or LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil then
        return
    end

    self._refreshGeneration += 1

    local _refreshGeneration = self._refreshGeneration
    local v29 = self:_readStoredProgress()
    local v30

    if v29.Completed then
        v30 = 1e999
    else
        local CurrentStepId = v29.CurrentStepId

        v30 = CurrentStepId ~= nil and GuardTutorialSteps.GetIndex(CurrentStepId) or 0
    end

    if self._lastStoredIndex ~= nil and v30 < self._lastStoredIndex then
        self._currentProgress = GuardTutorial.CopyProgress(v29)
    end

    self._lastStoredIndex = v30

    local v31 = self:_resolveNextProgress(v29)
    local v32 = v29.Completed ~= v31.Completed or v29.CurrentStepId ~= v31.CurrentStepId

    self._currentProgress = v31
    self:_bindCurrentStep()

    if self._activeStepId ~= nil then
        OnboardingTiming.Mark("FirstStepBound")
    end

    if v32 then
        local v33 = self:_syncProgress(v31)

        if not self._started or _refreshGeneration ~= self._refreshGeneration then
            return
        end

        if v33 ~= nil then
            self._currentProgress = v33
            self:_bindCurrentStep()
        else
            self:_queueSyncRetry()
        end
    end
end

function t1:Destroy() -- line: 520
    self._started = false
    self:_clearActiveStep()
    self._trove:Destroy()
    self._presentation:Destroy()
    self._adapter:Destroy()
end

return t1
