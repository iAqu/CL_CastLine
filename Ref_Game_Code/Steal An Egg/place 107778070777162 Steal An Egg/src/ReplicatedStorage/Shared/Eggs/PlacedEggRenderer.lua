-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)

require(ReplicatedStorage.Shared.Types.AreaEggResetCycle)

local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local BossMastery = require(ReplicatedStorage.Data.BossMastery)
local Catalog = require(ReplicatedStorage.Shared.Modules.Mutations.Catalog)
local ScrambleMutationFlags = require(ReplicatedStorage.Shared.Flags.ScrambleMutationFlags)
local RaceRallyFlags = require(ReplicatedStorage.Shared.Flags.RaceRallyFlags)
local TrainEventFlags = require(ReplicatedStorage.Shared.Flags.TrainEventFlags)
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local EggActionMovement = require(script.Parent.EggActionMovement)
local EggGrowthAnimation = require(script.Parent.EggGrowthAnimation)
local EggHatchAnimation = require(script.Parent.EggHatchAnimation)
local EggMechaUpgradeAnimation = require(script.Parent.EggMechaUpgradeAnimation)
local EggPlaceAnimation = require(script.Parent.EggPlaceAnimation)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggRenderer = require(script.Parent.EggRenderer)
local EggSkipAnimation = require(script.Parent.EggSkipAnimation)
local EggState = require(ReplicatedStorage.Client.EggState)
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local Log = require(ReplicatedStorage.Packages.Log)
local ModelCameraOcclusion = require(ReplicatedStorage.Client.ModelCameraOcclusion)
local MutationConsumableFeedback = require(script.Parent.MutationConsumableFeedback)
local NightEggTimeSkipAnimation = require(script.Parent.NightEggTimeSkipAnimation)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local ParasiteVisual = require(script.Parent.ParasiteVisual)
local PlacedEggBillboard = require(script.Parent.PlacedEggBillboard)
local PlacedEggGrowthPresentationPolicy = require(script.Parent.PlacedEggGrowthPresentationPolicy)
local PlacedEggReadyPulse = require(script.Parent.PlacedEggReadyPulse)
local PlotState = require(ReplicatedStorage.Client.PlotState)

require(ReplicatedStorage.Shared.Types.Plots)

local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Packages.Signal)
local SmartProximityPrompt = require(ReplicatedStorage.Client.SmartProximityPrompt)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types)

local v1 = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(1.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v3 = Color3.fromRGB(255, 64, 64)
local v4 = Color3.fromRGB(255, 196, 80)
local v5 = Color3.fromRGB(80, 255, 120)
local t1 = {}
local n1 = 0
local v6 = Random.new()
local v7 = Random.new()
local DayStartsAt
local v8 = false
local v9 = false
local v10 = "Boss"
local v11 = false
local n2 = 0
local v12 = Trove.new()
local Folder = Instance.new("Folder")

Folder.Name = "PlacedEggRenders"
Folder.Parent = workspace

local v13 = Log.new()
local t2 = {
    LocalEggHatchStarted = Signal.new()
}
local GetDirectGrowthTweenRemainingSeconds, GetStartScale, GetTargetScale, GetVisualScale = PlacedEggGrowthPresentationPolicy.GetDirectGrowthTweenRemainingSeconds, PlacedEggGrowthPresentationPolicy.GetStartScale, PlacedEggGrowthPresentationPolicy.GetTargetScale, PlacedEggGrowthPresentationPolicy.GetVisualScale
local IsReady, GetRemainingGrowthSeconds = PlacedEggGrowthPresentationPolicy.IsReady, PlacedEggGrowthPresentationPolicy.GetRemainingGrowthSeconds

local function getKey(p1, p2) -- line: 154
    return (("%*:%*"):format(p1, p2))
end

local function getOwnerPlayer(p3) -- line: 158
    -- upvalues: Players (copy)
    return Players:GetPlayerByUserId(p3)
end

local function readOwnerPlotData(p4) -- line: 162
    -- upvalues: Players (copy), PlotState (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p4)

    if PlayerByUserId == nil then
        return nil
    end

    return PlotState.ResolvePlot(PlayerByUserId)
end

local function isLocalOwner(p5) -- line: 171
    -- upvalues: Players (copy)
    return p5 == Players.LocalPlayer.UserId
end

local function getNextReadyPulseAt(p6) -- line: 175
    -- upvalues: v6 (copy)
    return p6 + v6:NextNumber(5, 10)
end

local function getNextGrowthPulseAt(p7) -- line: 183
    -- upvalues: v7 (copy)
    return p7 + v7:NextNumber(27, 65)
end

local function getInitialGrowthUpdateAt(p8) -- line: 191
    -- upvalues: n1 (ref)
    local v14 = p8 + n1 * 0.2

    n1 = (n1 + 1) % 25

    return v14
end

local function getNightTimeSkipSecondsValue(p9) -- line: 197
    local NightTimeSkipAnimation = p9.NightTimeSkipAnimation

    return if NightTimeSkipAnimation ~= nil then NightTimeSkipAnimation:GetAppliedSecondsValue() else nil
end

local function getNightTimeSkipSeconds(p10) -- line: 202
    local NightTimeSkipAnimation = p10.NightTimeSkipAnimation
    local v15 = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()

    if v15 == nil then
        return 0
    end

    return v15.Value
end

local function isNightTimeSkipControllingPresentation(p11) -- line: 207
    local NightTimeSkipAnimation = p11.NightTimeSkipAnimation

    return NightTimeSkipAnimation ~= nil and not NightTimeSkipAnimation:IsComplete()
end

local function clearNightTimeSkipAnimation(p12) -- line: 214
    -- upvalues: PlacedEggBillboard (copy)
    local NightTimeSkipAnimation = p12.NightTimeSkipAnimation

    if NightTimeSkipAnimation == nil then
        return
    end

    p12.NightTimeSkipAnimation = nil

    if p12.NightBillboardSuppressed then
        p12.NightBillboardSuppressed = false
        PlacedEggBillboard.SetNightPresentationActive(p12.OwnerUserId, p12.Uid, false)
    end

    NightTimeSkipAnimation:Destroy()

    local ScaleValue = p12.ScaleValue

    if ScaleValue ~= nil and p12.Result.Model.Parent ~= nil then
        ScaleValue.Value = p12.Result.Model:GetScale()
    end
end

local function startNightTimeSkipForState(p13, p14) -- line: 236
    -- upvalues: Players (copy), Workspace (copy), AreaEggCycle (copy), EggRecords (copy), NightEggTimeSkipAnimation (copy), PlacedEggBillboard (copy)
    if p13.OwnerUserId ~= Players.LocalPlayer.UserId or p13.IsHatching or p13.Result.Model.Parent == nil or p13.NightTimeSkipAnimation ~= nil then
        return
    end

    local Placement = p13.Record.Placement
    local v16 = p14 - AreaEggCycle.NightLengthSeconds()

    if Placement == nil or Placement.ReadyAt ~= nil or v16 < Placement.PlacedAt or EggRecords.IsGrown(p13.Record, v16, p13.Record.GrowthSpeedMultiplier, nil, Players:GetPlayerByUserId(p13.OwnerUserId)) or p14 <= Workspace:GetServerTimeNow() then
        return
    end

    local GrowthAnimation = p13.GrowthAnimation

    if GrowthAnimation ~= nil then
        GrowthAnimation:Cancel()
    end

    local ReadyPulse = p13.ReadyPulse

    if ReadyPulse ~= nil then
        ReadyPulse:Cancel()
    end

    local ScaleTween = p13.ScaleTween

    if ScaleTween ~= nil then
        ScaleTween:Cancel()
        p13.ScaleTween = nil
        p13.DirectGrowthTweenActive = false
    end

    local v17 = NightEggTimeSkipAnimation.new(p13.Result.Model, p13.Uid, p13.Record, p13.BasePivot, p13.StartScale, p13.TargetScale, v16, p14)

    p13.NightTimeSkipAnimation = v17
    PlacedEggBillboard.SetEntry({
        OwnerUserId = p13.OwnerUserId,
        Uid = p13.Uid,
        Record = p13.Record,
        Model = p13.Result.Model,
        TimeSkipSeconds = v17:GetAppliedSecondsValue()
    })
    p13.NightBillboardSuppressed = true
    PlacedEggBillboard.SetNightPresentationActive(p13.OwnerUserId, p13.Uid, true)
end

local function startNightTimeSkip(p15) -- line: 314
    -- upvalues: t1 (copy), DayStartsAt (ref), startNightTimeSkipForState (copy)
    DayStartsAt = p15.DayStartsAt

    for _, v18 in pairs(t1) do
        startNightTimeSkipForState(v18, p15.DayStartsAt)
    end
end

local function setStateScale(p16, p17, p18, p19, p20) -- line: 323
    -- upvalues: Players (copy), TweenService (copy), EggRenderer (copy), v1 (copy)
    if p16.OwnerUserId ~= Players.LocalPlayer.UserId then
        p16.Result.Model:ScaleTo(p17)
        EggRenderer.DisableCollisions(p16.Result.Model)

        return false
    end

    local ScaleValue = p16.ScaleValue

    if ScaleValue ~= nil then
        local ScaleTween = p16.ScaleTween
        local v19 = ScaleTween ~= nil

        if ScaleTween ~= nil then
            ScaleTween:Cancel()
            p16.ScaleTween = nil
            p16.DirectGrowthTweenActive = false
        end

        if p19 == false then
            if p20 == true then
                p16.DirectGrowthTweenActive = true
            end

            local v21 = math.abs(ScaleValue.Value - p17) > 0.001

            if v21 then
                ScaleValue.Value = p17
            end

            return v19 or v21
        end

        if math.abs(ScaleValue.Value - p17) <= 0.001 then
            if p20 == true then
                p16.DirectGrowthTweenActive = true
            end
        else
            local tween = TweenService:Create(ScaleValue, p18 or v1, {
                Value = p17
            })

            p16.ScaleTween = tween
            p16.DirectGrowthTweenActive = p20 == true
            tween.Completed:Once(function() -- line: 375
                -- upvalues: p16 (copy), p20 (copy), tween (copy)
                if p16.ScaleTween == tween then
                    p16.ScaleTween = nil

                    if p20 == true then
                        p16.DirectGrowthTweenActive = false
                    end
                end
            end)
            tween:Play()
        end
    else
        p16.Result.Model:ScaleTo(p17)
        EggRenderer.DisableCollisions(p16.Result.Model)
    end

    return false
end

local function startDirectGrowthTween(p21, p22) -- line: 387
    -- upvalues: setStateScale (copy)
    local v23 = TweenInfo.new(math.max(p22, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    setStateScale(p21, p21.TargetScale, v23, true, true)
end

local function hasSkipGrowthCredit(p23) -- line: 399
    -- upvalues: ReplicatedStorage (copy)
    local Save = require(ReplicatedStorage.Shared.Save)

    if not Save.IsLoaded() then
        return false
    end

    local v24 = Save.Await()
    local ProductCredits = if v24 == nil then nil else v24.ProductCredits

    if typeof(ProductCredits) ~= "table" then
        return false
    end

    local v25 = ProductCredits[tostring(p23)]

    if typeof(v25) == "number" then
        return v25 > 0
    end

    return false
end

local function updatePrompt(p24) -- line: 413
    -- upvalues: Players (copy), ScrambleMutationFlags (copy), RaceRallyFlags (copy), TrainEventFlags (copy), BossMasteryFlags (copy), Products (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), IsReady (copy), GetRemainingGrowthSeconds (copy), hasSkipGrowthCredit (copy)
    local Prompt = p24.Prompt

    if Prompt ~= nil then
        if v11 or p24.MutationPresenting then
            Prompt.Enabled = false
        elseif p24.OwnerUserId == Players.LocalPlayer.UserId then
            if v9 then
                local v26 = table.find(p24.Record.Mutations or {}, v10) ~= nil or p24.Record.BaseMutation == v10

                Prompt.Enabled = not v8 and not p24.IsHatching and not v26
                Prompt.HoldDuration = 1
                Prompt.ActionText = "Apply Mutation"

                if v10 == "Enchanted" then
                    Prompt.ObjectText = "Enchanted · 100% Success Chance"
                elseif v10 == "Nitro" then
                    Prompt.ObjectText = ("Nitro · %*%% Success Chance"):format((RaceRallyFlags.NitroSuccessPercent:Get()))
                elseif v10 == "Spectral" then
                    Prompt.ObjectText = ("Spectral · %*%% Success Chance"):format((TrainEventFlags.SpectralSuccessPercent:Get()))
                else
                    Prompt.ObjectText = ("%* · %*%% Success Chance"):format(if v10 == "Scrambled" then "Scrambled" else "Fractured", if v10 == "Scrambled" then ScrambleMutationFlags.SuccessPercent:Get() else BossMasteryFlags.MutationConsumableSuccessPercent:Get())
                end
            else
                local NightTimeSkipAnimation = p24.NightTimeSkipAnimation
                local v27 = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()
                local v28 = if v27 == nil then 0 else v27.Value
                local v29 = IsReady(p24.Record, v28)
                local v30 = if v29 then nil else Products.GetEggSkipGrowthProduct(GetRemainingGrowthSeconds(p24.Record, v28))
                local v31 = v30 ~= nil and hasSkipGrowthCredit(v30.ProductId)
                local v32

                if v29 then
                    v32 = "Hatch!"
                else
                    v32 = if v31 then "Skip Growth (FREE!)" else "Skip Growth!"
                    v29 = v30 ~= nil
                end

                Prompt.Enabled = not v8 and not p24.IsHatching and v29
                Prompt.HoldDuration = 0
                Prompt.ActionText = v32
                Prompt.ObjectText = v32
            end
        else
            Prompt.Enabled = v9 and not v8 and not v11 and not p24.IsHatching
            Prompt.HoldDuration = 1
            Prompt.ActionText = "Apply Mutation"
            Prompt.ObjectText = "Egg"
        end
    end
end

local function updateAllPrompts() -- line: 476
    -- upvalues: t1 (copy), updatePrompt (copy)
    for _, v33 in pairs(t1) do
        updatePrompt(v33)
    end
end

local function notifyMutation(p25, p26, p27) -- line: 482
    -- upvalues: ButterflyCatalog (copy), BossMastery (copy), Catalog (copy), Toast (copy), v5 (copy)
    local MutationConsumable = BossMastery.GetShopProduct("MutationConsumable")
    local Essence = if MutationConsumable then MutationConsumable.Icon else nil
    local v34 = if p27 == "Boss" then nil else Catalog[p27]

    if v34 and v34.IconAssetId ~= nil then
        Essence = "rbxassetid://" .. tostring(v34.IconAssetId)
    end

    local v35 = p26

    if p27 == "Enchanted" then
        Essence = ButterflyCatalog.Icons.Essence

        if v34 and p26 == v5 then
            v35 = v34.Tint
        end
    end

    Toast.Show({
        Seconds = 2.5,
        SingleLine = true,
        Text = p25,
        Color = v35,
        Image = Essence
    })
end

local v36, v37

local function applyMutation(p28) -- line: 511
    -- upvalues: Players (copy), Catalog (copy), MutationConsumableFeedback (copy), Remotes (copy), v3 (copy), v4 (copy), v5 (copy), t1 (copy), v10 (ref), v11 (ref), n2 (ref), updatePrompt (copy), notifyMutation (copy), v36 (ref), v37 (ref)
    if p28.OwnerUserId == Players.LocalPlayer.UserId then
        if not v11 then
            local v38 = ("%*:%*"):format(p28.OwnerUserId, p28.Uid)
            local OwnerUserId = p28.OwnerUserId
            local v39 = v10

            v11 = true
            p28.MutationPresenting = true

            for _, v40 in pairs(t1) do
                updatePrompt(v40)
            end

            local function v41() -- line: 537
                -- upvalues: p28 (copy), Remotes (copy)
                return Remotes.BossMastery.AskUseMutationConsumable:InvokeServer(p28.Uid)
            end

            local ok, result = pcall(v41)

            v11 = false

            local v42, v43

            if ok then
                v42 = type(result) == "table" and result.Success and result.Mutated
                v43 = type(result) == "table" and result.Success and not result.Mutated
            else
                v43 = ok
                v42 = ok
            end

            if not v42 and not v43 then
                p28.MutationPresenting = false

                for _, v44 in pairs(t1) do
                    updatePrompt(v44)
                end

                if t1[v38] == p28 then
                    v37(OwnerUserId)
                end
            end

            if not ok or type(result) ~= "table" then
                notifyMutation("Something went wrong, please try again.", v3, v39)
            elseif result.Success then
                local v45 = result.MutationId or v39
                local v46 = Catalog[v45]
                local v47 = if v46 then v46.Label else v45

                local function getCurrentModel() -- line: 580
                    -- upvalues: v38 (copy), t1 (copy)
                    local v48 = t1[v38]

                    return if v48 ~= nil then v48.Result.Model else nil
                end

                if v42 then
                    if t1[v38] ~= p28 then
                        v37(OwnerUserId)
                        notifyMutation(("%* mutation applied!"):format(v47), v5, v45)
                    else
                        MutationConsumableFeedback.PlaySuccess({
                            MutationId = v45,
                            Pivot = p28.BasePivot,
                            GetModel = getCurrentModel,
                            OnReveal = function() -- OnReveal | line: 599
                                -- upvalues: v45 (copy), v47 (copy), v5 (copy), notifyMutation (copy)
                                notifyMutation(("%* mutation applied!"):format(v47), v5, v45)
                            end,
                            OnFinished = function() -- OnFinished | line: 606
                                -- upvalues: p28 (copy), v38 (copy), OwnerUserId (copy), t1 (copy), updatePrompt (copy), v36 (ref), v37 (ref)
                                local v49 = t1[v38]

                                if v49 ~= nil then
                                    v49.MutationPresenting = false
                                end

                                if t1[v38] == p28 then
                                    v36(v38)
                                end

                                v37(OwnerUserId)

                                for _, v50 in pairs(t1) do
                                    updatePrompt(v50)
                                end
                            end
                        })
                    end
                else
                    MutationConsumableFeedback.PlayFailure({
                        MutationId = v45,
                        Pivot = p28.BasePivot,
                        GetModel = getCurrentModel,
                        OnVerdict = function() -- OnVerdict | line: 623
                            -- upvalues: result (copy), v45 (copy), v4 (copy), notifyMutation (copy)
                            notifyMutation(result.Message or "The mutation failed...", v4, v45)
                        end,
                        OnFinished = function() -- OnFinished | line: 631
                            -- upvalues: v38 (copy), OwnerUserId (copy), t1 (copy), updatePrompt (copy), v37 (ref)
                            local v51 = t1[v38]

                            if v51 ~= nil then
                                v51.MutationPresenting = false
                            end

                            v37(OwnerUserId)

                            for _, v52 in pairs(t1) do
                                updatePrompt(v52)
                            end
                        end
                    })
                end
            else
                notifyMutation(result.Message or "The consumable could not be used.", v3, v39)
            end
        end
    else
        local elapsed = os.clock()

        if n2 <= elapsed then
            n2 = elapsed + 2.5
            notifyMutation("can only be used on your own eggs", Color3.fromRGB(255, 100, 100), v10)
        end
    end
end

local function trackOcclusion(p29) -- line: 643
    -- upvalues: ModelCameraOcclusion (copy)
    assert(not p29.OcclusionTracked, (("Placed egg %* occlusion is already tracked"):format(p29.Uid)))
    ModelCameraOcclusion.Register(p29.Result.Model, 1)
    p29.OcclusionTracked = true
end

local function untrackOcclusion(p30) -- line: 655
    -- upvalues: ModelCameraOcclusion (copy)
    if p30.OcclusionTracked then
        ModelCameraOcclusion.Forget(p30.Result.Model)
        p30.OcclusionTracked = false
    end
end

local function runHatchPresentation(p31, p32) -- line: 665
    -- upvalues: Players (copy), EggHatchAnimation (copy), EggState (copy), v13 (copy), t2 (copy), v36 (ref), v37 (ref)
    if p31.OwnerUserId == Players.LocalPlayer.UserId then
        t2.LocalEggHatchStarted:Fire(p31.Uid)
    end

    local v55 = EggHatchAnimation.Play(p31.OwnerUserId, p31.Uid, p31.Record, p31.Result.Model, p32)
    local v56, v57, v58 = EggState.FinishHatch(p31.Uid)

    if v56 then
        if v55 ~= nil then
            local v59 = assert(v58, "Successful hatch completion must return the granted asset UID")

            EggHatchAnimation.FadeSoundWhenGrantedToolUnequips(v55, v59)
        end
    else
        v13:AtWarning():Log((("Failed to complete hatch for egg %*: %*"):format(p31.Uid, v57 or "unknown")))
        v36((("%*:%*"):format(p31.OwnerUserId, p31.Uid)))
        v37(p31.OwnerUserId)
    end
end

local function activatePrompt(p33) -- line: 700
    -- upvalues: EggMechaUpgradeAnimation (copy), EggState (copy), Eggs (copy), ModelCameraOcclusion (copy), MutationConsumableFeedback (copy), Storefront (copy), t1 (copy), v13 (copy), IsReady (copy), updatePrompt (copy), v36 (ref), v37 (ref), runHatchPresentation (copy)
    local ReadyPulse = p33.ReadyPulse

    if ReadyPulse == nil then
        return false, "Egg is not owned by the local player"
    end

    local Record, NightTimeSkipAnimation = p33.Record, p33.NightTimeSkipAnimation
    local v60 = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()

    if IsReady(Record, if v60 == nil then 0 else v60.Value) then
        if p33.HatchLock(function() -- line: 708
            -- upvalues: p33 (copy), ReadyPulse (copy), EggMechaUpgradeAnimation (copy), EggState (copy), Eggs (copy), ModelCameraOcclusion (copy), MutationConsumableFeedback (copy), t1 (copy), v13 (copy), updatePrompt (copy), v36 (ref), v37 (ref), runHatchPresentation (copy)
            p33.IsHatching = true

            if p33.OcclusionTracked then
                ModelCameraOcclusion.Forget(p33.Result.Model)
                p33.OcclusionTracked = false
            end

            p33.NextReadyPulseAt = nil
            ReadyPulse:Cancel()
            updatePrompt(p33)

            local v62, v63, v64 = EggState.BeginHatch(p33.Uid)

            if v62 then
                MutationConsumableFeedback.ClearAfterglow(p33.Result.Model)

                if v64 == Eggs.HATCH_RESULT_MECHA_UPGRADED then
                    local v65 = ("%*:%*"):format(p33.OwnerUserId, p33.Uid)
                    local OwnerUserId = p33.OwnerUserId

                    EggMechaUpgradeAnimation.Play(OwnerUserId, p33.Result.Model, function() -- line: 734
                        -- upvalues: v65 (copy), OwnerUserId (copy), ModelCameraOcclusion (copy), MutationConsumableFeedback (copy), t1 (copy), updatePrompt (copy), v36 (ref), v37 (ref)
                        v36(v65)
                        v37(OwnerUserId)

                        local v66 = t1[v65]

                        if v66 == nil then
                            return nil
                        end

                        v66.IsHatching = true
                        MutationConsumableFeedback.ClearAfterglow(v66.Result.Model)

                        if v66.OcclusionTracked then
                            ModelCameraOcclusion.Forget(v66.Result.Model)
                            v66.OcclusionTracked = false
                        end

                        v66.NextReadyPulseAt = nil

                        local ReadyPulse = v66.ReadyPulse

                        if ReadyPulse ~= nil then
                            ReadyPulse:Cancel()
                        end

                        updatePrompt(v66)

                        return v66.Result.Model
                    end)

                    local v67 = t1[v65]

                    if v67 ~= nil then
                        runHatchPresentation(v67, true)
                    else
                        EggState.FinishHatch(p33.Uid)
                    end
                else
                    runHatchPresentation(p33, false)
                end
            else
                p33.IsHatching = false
                assert(not p33.OcclusionTracked, (("Placed egg %* occlusion is already tracked"):format(p33.Uid)))
                ModelCameraOcclusion.Register(p33.Result.Model, 1)
                p33.OcclusionTracked = true
                updatePrompt(p33)
                v13:AtWarning():Log((("Failed to hatch egg %*: %*"):format(p33.Uid, v63 or "unknown")))
            end
        end) then
            return true
        end

        v13:AtDebug():Log((("Ignored duplicate hatch prompt for egg %*"):format(p33.Uid)))

        return false, "Egg is already hatching"
    end

    local v70, v71, v72 = EggState.BeginSkipGrowth(p33.Uid)

    if not v70 or not v72 then
        v13:AtWarning():Log((("Failed to request skip growth for egg %*: %*"):format(p33.Uid, v71 or "unknown")))

        return false, v71
    end

    Storefront.Prompt(v72, true)

    return true
end

v36 = function(p34) -- line: 790
    -- upvalues: ModelCameraOcclusion (copy), PlacedEggBillboard (copy), t1 (copy), clearNightTimeSkipAnimation (copy)
    local v73 = t1[p34]

    if v73 == nil then
        return
    end

    if v73.OcclusionTracked then
        ModelCameraOcclusion.Forget(v73.Result.Model)
        v73.OcclusionTracked = false
    end

    t1[p34] = nil
    clearNightTimeSkipAnimation(v73)
    PlacedEggBillboard.RemoveEntry(v73.OwnerUserId, v73.Uid)
    v73.Trove:Destroy()
end

local function destroyOwnerStates(p35) -- line: 803
    -- upvalues: t1 (copy), v36 (ref)
    for v74, v75 in pairs(t1) do
        if v75.OwnerUserId == p35 then
            v36(v74)
        end
    end
end

local function addPlacedEggRenderState(p36, p37, p38) -- line: 811
    -- upvalues: Players (copy), Workspace (copy), EggActionMovement (copy), EggGrowthAnimation (copy), EggPlaceAnimation (copy), EggRenderer (copy), EggState (copy), ModelCameraOcclusion (copy), MutationConsumableFeedback (copy), PlacedEggBillboard (copy), PlacedEggReadyPulse (copy), PlotState (copy), SmartProximityPrompt (copy), Trove (copy), TryLock (copy), t1 (copy), n1 (ref), DayStartsAt (ref), v9 (ref), Folder (copy), v13 (copy), GetDirectGrowthTweenRemainingSeconds (copy), GetStartScale (copy), GetTargetScale (copy), GetVisualScale (copy), startNightTimeSkipForState (copy), setStateScale (copy), updatePrompt (copy), applyMutation (copy), activatePrompt (copy)
    local Placement = p38.Placement

    if Placement == nil then
        return
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p36)
    local v76 = if PlayerByUserId == nil then nil else PlotState.ResolvePlot(PlayerByUserId)

    if v76 == nil then
        return
    end

    local v77 = Trove.new()
    local v78 = GetStartScale(p38)
    local v79 = GetTargetScale(p38)
    local v80 = GetVisualScale(p38, v78, v79)
    local v81 = v76.CenterPoint.CFrame * Placement.LocalCFrame
    local v82 = EggRenderer.RenderVisual({
        OwnerUserId = p36,
        UID = p37,
        ModelName = ("%*_%*"):format(p36, p37),
        Record = p38,
        ScaleMultiplier = v80
    }, Folder, false)

    v77:Add(v82.Model)
    MutationConsumableFeedback.AttachAfterglow(v82.Model, p38.Mutations, p38.BaseMutation)
    EggActionMovement.SetPivot(v82.Model, v81)

    if p36 == Players.LocalPlayer.UserId and EggState.TakePlantCue(p37) then
        EggPlaceAnimation.Play(v82.Model, v81, Folder)
    end

    local NumberValue

    if p36 == Players.LocalPlayer.UserId then
        NumberValue = Instance.new("NumberValue")
        NumberValue.Value = v80
        v77:Add(NumberValue)
        v77:Add(NumberValue.Changed:Connect(function(p39) -- line: 859
            -- upvalues: v82 (copy), EggRenderer (copy)
            v82.Model:ScaleTo(p39)
            EggRenderer.DisableCollisions(v82.Model)
        end))
    end

    local v83 = p36 == Players.LocalPlayer.UserId
    local v84, v85
    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
    ProximityPrompt.MaxActivationDistance = 7
    ProximityPrompt:SetAttribute("PlacedEggPrompt", true)
    ProximityPrompt.HoldDuration = 0
    v77:Add(SmartProximityPrompt.AttachToModel(ProximityPrompt, v82.Model, {
        SurfaceOffset = 0.75,
        TrackDistance = 7,
        MaxActivationDistance = ProximityPrompt.MaxActivationDistance
    }))

    local v86, v87

    if v83 then
        local v88 = EggGrowthAnimation.new(v82.Model, v81, 1)

        v84 = v88
        v87 = PlacedEggReadyPulse.new(v82.Model, v81, v79)
        v85 = v87
        v86 = v88
    end

    local t5 = {
        ScaleTween = nil,
        DirectGrowthTweenActive = false,
        NextGrowthPulseAt = nil,
        NightTimeSkipAnimation = nil,
        NightBillboardSuppressed = false,
        NextReadyPulseAt = nil,
        IsHatching = false,
        MutationPresenting = false,
        OcclusionTracked = false,
        OwnerUserId = p36,
        Uid = p37,
        Record = p38,
        Result = v82,
        BasePivot = v81,
        StartScale = v78,
        TargetScale = v79,
        ScaleValue = NumberValue,
        GrowthAnimation = v86
    }
    local v90 = Workspace:GetServerTimeNow() + n1 * 0.2

    n1 = (n1 + 1) % 25
    t5.NextGrowthUpdateAt = v90
    t5.ReadyPulse = v87
    t5.Prompt = ProximityPrompt
    t5.Trove = v77
    t5.HatchLock = TryLock()

    local DayStartsAt2 = DayStartsAt

    if DayStartsAt2 ~= nil then
        startNightTimeSkipForState(t5, DayStartsAt2)
    end

    if v87 ~= nil then
        v77:Add(function() -- line: 921
            -- upvalues: v85 (ref)
            v85:Destroy()
        end)
    end

    if v86 ~= nil then
        v77:Add(function() -- line: 926
            -- upvalues: v84 (ref)
            v84:Destroy()
        end)
    end

    v77:Add(function() -- line: 930
        -- upvalues: t5 (copy)
        local ScaleTween = t5.ScaleTween

        if ScaleTween == nil then
            return
        end

        ScaleTween:Cancel()
        t5.ScaleTween = nil
        t5.DirectGrowthTweenActive = false
    end)
    t1[("%*:%*"):format(p36, p37)] = t5
    assert(not t5.OcclusionTracked, (("Placed egg %* occlusion is already tracked"):format(t5.Uid)))
    ModelCameraOcclusion.Register(t5.Result.Model, 1)
    t5.OcclusionTracked = true

    local SetEntry = PlacedEggBillboard.SetEntry
    local t6 = {
        OwnerUserId = p36,
        Uid = p37,
        Record = p38,
        Model = v82.Model
    }
    local NightTimeSkipAnimation = t5.NightTimeSkipAnimation

    t6.TimeSkipSeconds = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()
    SetEntry(t6)
    updatePrompt(t5)

    if ProximityPrompt ~= nil then
        v77:Add(ProximityPrompt.Triggered:Connect(function(p40) -- line: 949
            -- upvalues: t5 (copy), Players (copy), v9 (ref), applyMutation (copy), activatePrompt (copy)
            if p40 == Players.LocalPlayer then
                if v9 then
                    applyMutation(t5)
                elseif t5.OwnerUserId == Players.LocalPlayer.UserId then
                    activatePrompt(t5)
                end
            end
        end))
    end

    local v93 = GetDirectGrowthTweenRemainingSeconds(p38, (Workspace:GetServerTimeNow()))

    if v83 and v93 > 0 then
        local NightTimeSkipAnimation = t5.NightTimeSkipAnimation

        if NightTimeSkipAnimation == nil or NightTimeSkipAnimation:IsComplete() then
            local v94 = TweenInfo.new(math.max(v93, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

            setStateScale(t5, t5.TargetScale, v94, true, true)
        end
    end

    v13:AtDebug():Log((("Rendered placed egg %* for owner %*"):format(p37, p36)))
end

v37 = function(p41) -- line: 973
    -- upvalues: Players (copy), EggActionMovement (copy), EggRecords (copy), EggSkipAnimation (copy), EggState (copy), MutationConsumableFeedback (copy), ParasiteVisual (copy), PlacedEggBillboard (copy), PlacedEggGrowthPresentationPolicy (copy), PlotState (copy), v2 (copy), t1 (copy), GetStartScale (copy), GetTargetScale (copy), IsReady (copy), clearNightTimeSkipAnimation (copy), setStateScale (copy), updatePrompt (copy), v36 (ref), addPlacedEggRenderState (copy)
    local v95 = EggState.ReadOwnerEggs(p41)
    local PlayerByUserId = Players:GetPlayerByUserId(p41)
    local v96 = if PlayerByUserId == nil then nil else PlotState.ResolvePlot(PlayerByUserId)

    if v96 == nil then
        return
    end

    local t7 = {}

    for v97, v98 in pairs(v95) do
        if v98.Placement ~= nil then
            local v99 = ("%*:%*"):format(p41, v97)

            t7[v99] = true

            local v100 = t1[v99]

            if v100 ~= nil then
                if not v100.IsHatching and not v100.MutationPresenting then
                    if EggRecords.EggModelName(v98.AssetCategory, v98.Mutations, v98.BaseMutation) == EggRecords.EggModelName(v100.Record.AssetCategory, v100.Record.Mutations, v100.Record.BaseMutation) then
                        if v100 ~= nil then
                            local NightTimeSkipAnimation = v100.NightTimeSkipAnimation
                            local AppliedSecondsValue = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()
                            local Value = if AppliedSecondsValue == nil then 0 else AppliedSecondsValue.Value
                            local v101 = IsReady(v100.Record, Value)
                            local v102 = IsReady(v98, Value)
                            local HasParasite = v100.Record.HasParasite

                            v100.Record = v98

                            if v98.HasParasite ~= HasParasite then
                                ParasiteVisual.Attach(v100.Result.Model, v98.HasParasite)
                            end

                            MutationConsumableFeedback.AttachAfterglow(v100.Result.Model, v98.Mutations, v98.BaseMutation)
                            v100.StartScale = GetStartScale(v98)
                            v100.TargetScale = GetTargetScale(v98)

                            if v98.Placement ~= nil then
                                v100.BasePivot = v96.CenterPoint.CFrame * v98.Placement.LocalCFrame

                                local ReadyPulse = v100.ReadyPulse

                                if ReadyPulse ~= nil then
                                    ReadyPulse:SetTransform(v100.BasePivot, v100.TargetScale)
                                end

                                local GrowthAnimation = v100.GrowthAnimation

                                if GrowthAnimation ~= nil then
                                    GrowthAnimation:SetBasePivot(v100.BasePivot)
                                end

                                local NightTimeSkipAnimation = v100.NightTimeSkipAnimation

                                if NightTimeSkipAnimation ~= nil then
                                    NightTimeSkipAnimation:SetTransform(v100.BasePivot, v100.StartScale, v100.TargetScale)
                                    NightTimeSkipAnimation:AcknowledgeRecord(v98)

                                    if v102 then
                                        NightTimeSkipAnimation:CancelVisual()
                                    end
                                end

                                local NightTimeSkipAnimation2 = v100.NightTimeSkipAnimation

                                if not (NightTimeSkipAnimation2 ~= nil and not NightTimeSkipAnimation2:IsComplete()) and (ReadyPulse == nil or not ReadyPulse:IsPlaying()) and (GrowthAnimation == nil or not GrowthAnimation:IsPlaying()) then
                                    EggActionMovement.SetPivot(v100.Result.Model, v100.BasePivot)
                                end
                            end

                            local NightTimeSkipAnimation2 = v100.NightTimeSkipAnimation

                            if NightTimeSkipAnimation2 ~= nil and NightTimeSkipAnimation2:IsComplete() then
                                clearNightTimeSkipAnimation(v100)
                            end

                            local SetEntry = PlacedEggBillboard.SetEntry
                            local t8 = {
                                OwnerUserId = p41,
                                Uid = v97,
                                Record = v98
                            }

                            t8.Model = v100.Result.Model

                            local NightTimeSkipAnimation3 = v100.NightTimeSkipAnimation

                            t8.TimeSkipSeconds = if NightTimeSkipAnimation3 == nil then nil else NightTimeSkipAnimation3:GetAppliedSecondsValue()
                            SetEntry(t8)

                            if p41 == Players.LocalPlayer.UserId and not v101 and v102 and v100.NightTimeSkipAnimation == nil then
                                if EggState.ReadChosenSkipUid() == v97 then
                                    setStateScale(v100, v100.TargetScale, v2)
                                    task.spawn(EggSkipAnimation.Play, v100.Result.Model)
                                else
                                    local v103 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v100.Result.Model)

                                    if setStateScale(v100, v100.TargetScale, nil, v103 == nil) then
                                        local v104 = assert(v103, "Skipped natural completion requires a presentation reason")

                                        PlacedEggGrowthPresentationPolicy.LogSkipped(v100.Uid, "natural completion", v104)
                                    end
                                end
                            end

                            updatePrompt(v100)
                        else
                            addPlacedEggRenderState(p41, v97, v98)
                        end
                    else
                        v36(v99)
                        addPlacedEggRenderState(p41, v97, v98)
                    end
                end
            else
                addPlacedEggRenderState(p41, v97, v98)
            end
        end
    end

    for v105, v106 in pairs(t1) do
        if v106.OwnerUserId == p41 and not t7[v105] then
            v36(v105)
        end
    end
end

local function refreshAll() -- line: 1132
    -- upvalues: EggState (copy), t1 (copy), v36 (ref), v37 (ref)
    local v107 = EggState.ReadOwnedEggs()
    local t9 = {}

    for _, v108 in ipairs(v107) do
        t9[v108.OwnerUserId] = true
        v37(v108.OwnerUserId)
    end

    for v109, v110 in pairs(t1) do
        if not t9[v110.OwnerUserId] then
            v36(v109)
        end
    end
end

local function updateReadyPulses(p42) -- line: 1147
    -- upvalues: PlacedEggGrowthPresentationPolicy (copy), t1 (copy), v6 (copy), IsReady (copy)
    for _, v111 in pairs(t1) do
        local ReadyPulse = v111.ReadyPulse

        if ReadyPulse ~= nil then
            if v111.IsHatching or v111.Result.Model.Parent == nil then
                v111.NextReadyPulseAt = nil
                ReadyPulse:Cancel()
            else
                local Record, NightTimeSkipAnimation = v111.Record, v111.NightTimeSkipAnimation
                local v112 = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()

                if IsReady(Record, if v112 == nil then 0 else v112.Value) then
                    local NightTimeSkipAnimation = v111.NightTimeSkipAnimation

                    if NightTimeSkipAnimation ~= nil and not NightTimeSkipAnimation:IsComplete() then
                        v111.NextReadyPulseAt = nil
                        ReadyPulse:Cancel()
                    else
                        local NextReadyPulseAt = v111.NextReadyPulseAt

                        if ReadyPulse:IsPlaying() then
                            local v114 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v111.Result.Model)

                            if v114 ~= nil then
                                ReadyPulse:Cancel()
                                v111.NextReadyPulseAt = p42 + v6:NextNumber(5, 10)
                                PlacedEggGrowthPresentationPolicy.LogSkipped(v111.Uid, "ready pulse cancellation", v114)
                            elseif NextReadyPulseAt == nil then
                                v111.NextReadyPulseAt = p42 + v6:NextNumber(5, 10)
                            end
                        elseif NextReadyPulseAt ~= nil then
                            if NextReadyPulseAt <= p42 then
                                local v115 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v111.Result.Model)

                                if v115 ~= nil then
                                    v111.NextReadyPulseAt = p42 + v6:NextNumber(5, 10)
                                    PlacedEggGrowthPresentationPolicy.LogSkipped(v111.Uid, "ready pulse", v115)
                                elseif ReadyPulse:Play() then
                                    v111.NextReadyPulseAt = nil
                                end
                            end
                        else
                            v111.NextReadyPulseAt = p42 + v6:NextNumber(5, 10)
                        end
                    end
                else
                    v111.NextReadyPulseAt = nil
                    ReadyPulse:Cancel()
                end
            end
        end
    end
end

local function updateGrowthPulses(p43) -- line: 1202
    -- upvalues: PlacedEggGrowthPresentationPolicy (copy), t1 (copy), v7 (copy), GetDirectGrowthTweenRemainingSeconds (copy), IsReady (copy)
    for _, v116 in pairs(t1) do
        local GrowthAnimation = v116.GrowthAnimation

        if GrowthAnimation ~= nil then
            local v117 = GetDirectGrowthTweenRemainingSeconds(v116.Record, p43)

            if v116.IsHatching or v116.Result.Model.Parent == nil then
                v116.NextGrowthPulseAt = nil
                GrowthAnimation:Cancel()
            else
                local Record, NightTimeSkipAnimation = v116.Record, v116.NightTimeSkipAnimation
                local v118 = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()

                if IsReady(Record, if v118 == nil then 0 else v118.Value) or v117 > 0 then
                    v116.NextGrowthPulseAt = nil
                    GrowthAnimation:Cancel()
                else
                    local NightTimeSkipAnimation = v116.NightTimeSkipAnimation

                    if NightTimeSkipAnimation ~= nil and not NightTimeSkipAnimation:IsComplete() then
                        v116.NextGrowthPulseAt = nil
                        GrowthAnimation:Cancel()
                    else
                        local NextGrowthPulseAt = v116.NextGrowthPulseAt

                        if GrowthAnimation:IsPlaying() then
                            local v120 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v116.Result.Model)

                            if v120 ~= nil then
                                GrowthAnimation:Cancel()
                                v116.NextGrowthPulseAt = p43 + v7:NextNumber(27, 65)
                                PlacedEggGrowthPresentationPolicy.LogSkipped(v116.Uid, "random growth jump cancellation", v120)
                            end
                        elseif NextGrowthPulseAt ~= nil then
                            if NextGrowthPulseAt <= p43 then
                                v116.NextGrowthPulseAt = p43 + v7:NextNumber(27, 65)

                                local v121 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v116.Result.Model)

                                if v121 ~= nil then
                                    PlacedEggGrowthPresentationPolicy.LogSkipped(v116.Uid, "random growth jump", v121)
                                else
                                    GrowthAnimation:Play()
                                end
                            end
                        else
                            v116.NextGrowthPulseAt = p43 + v7:NextNumber(27, 65)
                        end
                    end
                end
            end
        end
    end
end

local function updateGrowth(p44) -- line: 1256
    -- upvalues: Players (copy), PlacedEggGrowthPresentationPolicy (copy), t1 (copy), GetDirectGrowthTweenRemainingSeconds (copy), GetVisualScale (copy), setStateScale (copy), updatePrompt (copy)
    for _, v122 in pairs(t1) do
        if not v122.IsHatching and not v122.MutationPresenting and v122.Result.Model.Parent ~= nil then
            local NightTimeSkipAnimation = v122.NightTimeSkipAnimation

            if NightTimeSkipAnimation == nil or NightTimeSkipAnimation:IsComplete() then
                local v123 = GetDirectGrowthTweenRemainingSeconds(v122.Record, p44)

                if v122.OwnerUserId == Players.LocalPlayer.UserId and v123 > 0 then
                    if not v122.DirectGrowthTweenActive then
                        updatePrompt(v122)

                        local v124 = TweenInfo.new(math.max(v123, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                        setStateScale(v122, v122.TargetScale, v124, true, true)
                    end
                else
                    local NextGrowthUpdateAt = v122.NextGrowthUpdateAt

                    if not (p44 < NextGrowthUpdateAt) then
                        v122.NextGrowthUpdateAt = NextGrowthUpdateAt + (math.floor((p44 - NextGrowthUpdateAt) / 5) + 1) * 5
                        updatePrompt(v122)

                        local v126 = GetVisualScale(v122.Record, v122.StartScale, v122.TargetScale)
                        local v127 = PlacedEggGrowthPresentationPolicy.GetNaturalGrowthSkipReason(v122.Result.Model, v126)

                        if setStateScale(v122, v126, nil, v127 == nil) then
                            local v128 = assert(v127, "Skipped natural growth requires a presentation reason")

                            PlacedEggGrowthPresentationPolicy.LogSkipped(v122.Uid, "natural growth", v128)
                        end
                    end
                end
            end
        end
    end
end

local function updateNightTimeSkips() -- line: 1309
    -- upvalues: PlacedEggBillboard (copy), t1 (copy), clearNightTimeSkipAnimation (copy), updatePrompt (copy)
    for _, v129 in pairs(t1) do
        local NightTimeSkipAnimation = v129.NightTimeSkipAnimation

        if NightTimeSkipAnimation ~= nil then
            if v129.IsHatching or v129.Result.Model.Parent == nil then
                clearNightTimeSkipAnimation(v129)
            else
                updatePrompt(v129)

                if v129.NightBillboardSuppressed and NightTimeSkipAnimation:IsBillboardFadeFinished() then
                    v129.NightBillboardSuppressed = false
                    PlacedEggBillboard.SetNightPresentationActive(v129.OwnerUserId, v129.Uid, false)
                end

                if NightTimeSkipAnimation:IsComplete() then
                    clearNightTimeSkipAnimation(v129)
                    PlacedEggBillboard.SetEntry({
                        TimeSkipSeconds = nil,
                        OwnerUserId = v129.OwnerUserId,
                        Uid = v129.Uid,
                        Record = v129.Record,
                        Model = v129.Result.Model
                    })
                end
            end
        end
    end
end

local function stepPlacedEggs() -- line: 1345
    -- upvalues: Workspace (copy), updateReadyPulses (copy), updateGrowthPulses (copy), updateGrowth (copy), updateNightTimeSkips (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()

    updateNightTimeSkips()
    updateGrowthPulses(ServerTimeNow)
    updateReadyPulses(ServerTimeNow)
    updateGrowth(ServerTimeNow)
end

function t2.GetRenderFolder() -- line: 1357
    -- upvalues: Folder (copy)
    return Folder
end

function t2.Refresh() -- line: 1361
    -- upvalues: refreshAll (copy)
    refreshAll()
end

function t2.SetPromptsSuppressed(p45) -- line: 1365
    -- upvalues: t (copy), t1 (copy), v8 (ref), updatePrompt (copy)
    t.strict(t.boolean)(p45)
    v8 = p45

    for _, v130 in pairs(t1) do
        updatePrompt(v130)
    end
end

function t2.ActivateLocalEgg(p46) -- line: 1374
    -- upvalues: Players (copy), t (copy), t1 (copy), activatePrompt (copy)
    t.strict(t.string)(p46)

    local v131 = t1[("%*:%*"):format(Players.LocalPlayer.UserId, p46)]

    if v131 == nil then
        return false, "Egg is not rendered"
    end

    return activatePrompt(v131)
end

function t2.RequestSkipGrowthForLocalEgg(p47) -- line: 1385
    -- upvalues: Players (copy), t (copy), t1 (copy), IsReady (copy), activatePrompt (copy)
    t.strict(t.string)(p47)

    local v132 = t1[("%*:%*"):format(Players.LocalPlayer.UserId, p47)]

    if v132 == nil then
        return false, "Egg is not rendered"
    end

    local Record, NightTimeSkipAnimation = v132.Record, v132.NightTimeSkipAnimation
    local v133 = if NightTimeSkipAnimation == nil then nil else NightTimeSkipAnimation:GetAppliedSecondsValue()

    if IsReady(Record, if v133 == nil then 0 else v133.Value) then
        return false, "Egg is already ready"
    end

    return activatePrompt(v132)
end

function t2.AppendRaycastTargets(p48, p49) -- line: 1401
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.number)(p49)

    for _, v135 in pairs(t1) do
        if v135.OwnerUserId == p49 and v135.Result.Model.Parent ~= nil then
            table.insert(p48, v135.Result.Model)
        end
    end
end

function t2.DestroyOwner(p50) -- line: 1417
    -- upvalues: PlacedEggBillboard (copy), t (copy), destroyOwnerStates (copy)
    t.strict(t.number)(p50)
    destroyOwnerStates(p50)
    PlacedEggBillboard.DestroyOwner(p50)
end

function t2.SetAllHidden(p51) -- line: 1424
    -- upvalues: t (copy), Folder (copy), t2 (copy)
    t.strict(t.boolean)(p51)
    Folder.Parent = if p51 then nil else workspace
    t2.SetPromptsSuppressed(p51)
end

local function refreshMutationConsumableEquipped(p52) -- line: 1430
    -- upvalues: t1 (copy), v9 (ref), v10 (ref), updatePrompt (copy)
    local v137 = false
    local v138 = "Boss"

    for _, child in p52:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("ItemType") == "MutationConsumable" then
            v138 = child:GetAttribute("MutationId") or "Boss"

            if v138 == "Boss" or v138 == "Scrambled" or v138 == "Enchanted" or v138 == "Nitro" or v138 == "Spectral" then
                v137 = true
                break
            end
        end

        v137 = false
        v138 = "Boss"
    end

    if v9 == v137 and v10 == v138 then
        return
    end

    v9 = v137
    v10 = v138

    for _, v139 in pairs(t1) do
        updatePrompt(v139)
    end
end

local function bindCharacter(p53) -- line: 1453
    -- upvalues: v12 (copy), refreshMutationConsumableEquipped (copy)
    v12:Clean()
    v12:Connect(p53.ChildAdded, function() -- line: 1455
        -- upvalues: p53 (copy), refreshMutationConsumableEquipped (copy)
        refreshMutationConsumableEquipped(p53)
    end)
    v12:Connect(p53.ChildRemoved, function() -- line: 1458
        -- upvalues: p53 (copy), refreshMutationConsumableEquipped (copy)
        refreshMutationConsumableEquipped(p53)
    end)
    refreshMutationConsumableEquipped(p53)
end

EggState.SnapshotRefreshed:Connect(refreshAll)
EggState.OwnerRefreshed:Connect(v37)
EggState.OwnerCleared:Connect(t2.DestroyOwner)
EggState.ResetCountdown:Connect(startNightTimeSkip)
PlotState.PlotChanged:Connect(refreshAll)
RunService.Heartbeat:Connect(stepPlacedEggs)
Players.LocalPlayer.CharacterAdded:Connect(bindCharacter)

if Players.LocalPlayer.Character ~= nil then
    bindCharacter(Players.LocalPlayer.Character)
end

ScrambleMutationFlags.SuccessPercent.Changed:Connect(updateAllPrompts)
RaceRallyFlags.NitroSuccessPercent.Changed:Connect(updateAllPrompts)
TrainEventFlags.SpectralSuccessPercent.Changed:Connect(updateAllPrompts)
BossMasteryFlags.MutationConsumableSuccessPercent.Changed:Connect(updateAllPrompts)
task.defer(function() -- line: 1484
    -- upvalues: Workspace (copy), AreaEggCycle (copy), t1 (copy), DayStartsAt (ref), startNightTimeSkipForState (copy), refreshAll (copy)
    refreshAll()

    local ServerTimeNow = Workspace:GetServerTimeNow()

    if not AreaEggCycle.IsNightPhase(ServerTimeNow) then
        return
    end

    local t10 = {
        DayStartsAt = AreaEggCycle.NextResetTime(ServerTimeNow)
    }

    DayStartsAt = t10.DayStartsAt

    for _, v140 in pairs(t1) do
        startNightTimeSkipForState(v140, t10.DayStartsAt)
    end
end)

return t2
