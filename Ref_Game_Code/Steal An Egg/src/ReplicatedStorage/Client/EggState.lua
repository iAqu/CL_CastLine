-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local AreaEggs = require(ReplicatedStorage.Shared.Types.AreaEggs)
local Log = require(ReplicatedStorage.Packages.Log)
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local AreaEggResetCycle = require(ReplicatedStorage.Shared.Types.AreaEggResetCycle)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Promise = require(ReplicatedStorage.Packages.Promise)
local OnboardingTiming = require(ReplicatedStorage.Shared.Util.OnboardingTiming)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local t = require(ReplicatedStorage.Packages.t)
local EggWorld = Remotes.EggWorld
local t1 = {
    SnapshotRefreshed = Signal.new(),
    OwnerRefreshed = Signal.new(),
    OwnerCleared = Signal.new(),
    FieldRefreshed = Signal.new(),
    FieldShifted = Signal.new(),
    FieldGone = Signal.new(),
    CarryChanged = Signal.new(),
    FieldClaimed = Signal.new(),
    ResetCountdown = Signal.new(),
    RarityRevealed = Signal.new(),
    RarityPresented = Signal.new(),
    ResetFade = Signal.new()
}
local v1 = t.strict(t.string)
local v2 = t.strict(t.number)
local v3 = t.strict(t.boolean)
local v4 = t.strict(t.optional(t.string))
local v5 = t.strict(t.CFrame)
local v6 = Log.new()
local LocalPlayer = Players.LocalPlayer
local t2 = {}

t2[1] = {}

local t3 = {}
local t4 = {}
local t5 = {}
local n1 = 0
local n2 = 0
local v7
local t6 = {}
local v8 = nil
local v9 = false
local v10 = {
    IsCarrying = false
}

local function twin(p1) -- line: 77
    -- upvalues: TableUtil (copy)
    return TableUtil.Copy(p1, true)
end

local function stampOwner(p2) -- line: 79
    -- upvalues: t4 (copy), n1 (ref)
    n1 += 1
    t4[p2] = n1
end

local function stampField(p3) -- line: 84
    -- upvalues: t5 (copy), n2 (ref)
    n2 += 1
    t5[p3] = n2
end

local function ownedRows() -- line: 89
    -- upvalues: TableUtil (copy), t2 (copy)
    local t7 = {}

    for v11, v12 in t2[1] do
        table.insert(t7, {
            OwnerUserId = v11,
            Records = TableUtil.Copy(v12, true)
        })
    end

    return t7
end

local function fieldRows() -- line: 97
    -- upvalues: Workspace (copy), t3 (ref), twin (copy)
    local t9 = {}

    for _, v13 in t3 do
        table.insert(t9, twin(v13))
    end

    return {
        Records = t9,
        ServerTime = Workspace:GetServerTimeNow()
    }
end

local function tellOwned() -- line: 105
    -- upvalues: t1 (copy), ownedRows (copy)
    t1.SnapshotRefreshed:Fire((ownedRows()))
end

local function tellField() -- line: 107
    -- upvalues: t1 (copy), fieldRows (copy)
    t1.FieldRefreshed:Fire((fieldRows()))
end

local function adoptOwned(p4, p5) -- line: 115
    -- upvalues: TableUtil (copy), t1 (copy), t2 (copy), t4 (copy), ownedRows (copy)
    local t10 = {}

    for v14, v15 in t2[1] do
        if p5 < (t4[v14] or 0) then
            t10[v14] = TableUtil.Copy(v15, true)
        else
            t10[v14] = nil
        end
    end

    for _, v16 in ipairs(p4) do
        local v17 = (t4[v16.OwnerUserId] or 0) <= p5
        local OwnerUserId = v16.OwnerUserId

        if v17 then
            local Records = v16.Records

            t10[OwnerUserId] = TableUtil.Copy(Records, true)
        else
            t10[OwnerUserId] = t10[v16.OwnerUserId]
        end
    end

    t2[1] = t10
    t1.SnapshotRefreshed:Fire((ownedRows()))
end

local function adoptField(p6, p7) -- line: 129
    -- upvalues: TableUtil (copy), t1 (copy), t3 (ref), t5 (copy), fieldRows (copy)
    local t11 = {}

    for v18, v19 in t3 do
        if p7 < (t5[v18] or 0) then
            t11[v18] = TableUtil.Copy(v19, true)
        else
            t11[v18] = nil
        end
    end

    for _, v20 in ipairs(p6.Records) do
        local v21 = (t5[v20.Uid] or 0) <= p7
        local Uid = v20.Uid

        if v21 then
            t11[Uid] = TableUtil.Copy(v20, true)
        else
            t11[Uid] = t11[v20.Uid]
        end
    end

    t3 = t11
    t1.FieldRefreshed:Fire((fieldRows()))
end

local function keepAsking(p8, p9) -- line: 143
    -- upvalues: v6 (copy), keepAsking (copy)
    local ok, result = pcall(p9)

    if not ok then
        v6:AtError():Log((("%* never landed, going round again: %*"):format(p8, result)))
        task.delay(5, keepAsking, p8, p9)
    end
end

local function outcome(p10, p11) -- line: 154
    local v22 = p10 == true

    if typeof(p11) == "string" then
        return v22, p11
    end

    return v22, nil
end

function t1.FetchEggRecord(p12) -- line: 158
    -- upvalues: Eggs (copy), EggWorld (copy), v1 (copy), v6 (copy), twin (copy)
    v1(p12)

    local v23 = EggWorld.AskEggRecord:InvokeServer(p12)

    if v23 ~= nil then
        local v24, v25 = Eggs.SchemaValidation.SavedEgg(v23)

        if v24 then
            return twin(v23)
        end

        v6:AtError():Log((("the egg record for %* came back malformed: %*"):format(p12, v25)))
    end

    return nil
end

function t1.SyncOwnedEggs() -- line: 175
    -- upvalues: Eggs (copy), EggWorld (copy), n1 (ref), ownedRows (copy), adoptOwned (copy)
    local v26 = n1
    local v27 = EggWorld.AskLiveSnapshot:InvokeServer()
    local v28, v29 = Eggs.SchemaValidation.RuntimeEggSnapshot(v27)

    assert(v28, (("the owned egg snapshot failed validation: %*"):format(v29)))
    adoptOwned(v27, v26)

    return (ownedRows())
end

function t1.SyncFieldEggs() -- line: 185
    -- upvalues: AreaEggs (copy), Promise (copy), OnboardingTiming (copy), EggWorld (copy), n2 (ref), v8 (ref), v9 (ref), fieldRows (copy), adoptField (copy)
    local v31 = v8

    if v31 == nil then
        local v32 = n2

        v31 = Promise.try(function() -- line: 189
            -- upvalues: AreaEggs (copy), EggWorld (copy)
            local v33 = EggWorld.AskFieldEggSnapshot:InvokeServer()
            local v34, v35 = AreaEggs.SchemaValidation.AreaEggSnapshot(v33)

            assert(v34, (("the field egg snapshot failed validation: %*"):format(v35)))

            return v33
        end):timeout(30):andThen(function(p13) -- line: 194
            -- upvalues: v32 (copy), OnboardingTiming (copy), v9 (ref), adoptField (copy)
            v9 = true
            adoptField(p13, v32)
            OnboardingTiming.Mark("FieldSnapshotReceived")
        end)
        v8 = v31

        local function v37() -- line: 200
            -- upvalues: v31 (ref), v8 (ref)
            if v8 == v31 then
                v8 = nil
            end
        end

        v31:finally(v37):catch(function() -- line: 204
        end)
    end

    local v38, v39 = v31:await()

    if not v38 then
        error(tostring(v39), 2)
    end

    return (fieldRows())
end

function t1.FetchRarityShows() -- line: 214
    -- upvalues: AreaEggResetCycle (copy), EggWorld (copy), v3 (copy)
    local v40, v41 = EggWorld.AskFieldEggRarityShows:InvokeServer()

    v3(v40)

    if v40 ~= true or v41 == nil then
        return v40 == true, nil
    end

    local v42, v43 = AreaEggResetCycle.SchemaValidation.RevealPayload(v41)

    assert(v42, (("the rare spawn reveal payload failed validation: %*"):format(v43)))

    return true, v41
end

function t1.WearEggTool(p14) -- line: 226
    -- upvalues: EggWorld (copy), v1 (copy), outcome (copy)
    v1(p14)

    return outcome(EggWorld.AskWearTool:InvokeServer(p14))
end

function t1.DoffEggTool(p15) -- line: 231
    -- upvalues: EggWorld (copy), v4 (copy), outcome (copy)
    v4(p15)

    return outcome(EggWorld.AskDoffTool:InvokeServer(p15))
end

function t1.CarryFieldEgg(p16, p17) -- line: 236
    -- upvalues: EggWorld (copy), v1 (copy), v4 (copy), outcome (copy)
    v1(p16)
    v4(p17)

    local t12 = {
        Uid = p16,
        FirstAreaSlotKey = p17
    }

    return outcome(EggWorld.AskFieldEggCarry:InvokeServer(t12))
end

function t1.DropFieldEgg(p18) -- line: 244
    -- upvalues: AreaEggs (copy), EggWorld (copy), outcome (copy)
    local v45, v46 = AreaEggs.SchemaValidation.DropReason(p18)

    if p18 == nil then
        v45 = true
    end

    assert(v45, v46)

    return outcome(EggWorld.AskFieldEggDrop:InvokeServer({
        Reason = p18
    }))
end

function t1.PlantEgg(p19, p20) -- line: 250
    -- upvalues: EggWorld (copy), v1 (copy), v5 (copy), t6 (copy)
    v1(p19)
    v5(p20)
    t6[p19] = true

    local t13 = {
        Uid = p19,
        LocalCFrame = p20
    }
    local v47, v48 = EggWorld.AskPlaceEgg:InvokeServer(t13)
    local v49 = v47 == true

    if typeof(v48) ~= "string" then
        v48 = nil
    end

    if v49 ~= true then
        t6[p19] = nil
    end

    return v49, v48
end

function t1.TakePlantCue(p21) -- line: 267
    -- upvalues: v1 (copy), t6 (copy)
    v1(p21)

    local v50 = t6[p21] == true

    t6[p21] = nil

    return v50
end

function t1.BeginSkipGrowth(p22) -- line: 275
    -- upvalues: EggWorld (copy), v1 (copy), v6 (copy), v7 (ref)
    v1(p22)

    local v51, v52, v53 = EggWorld.AskSkipGrowth:InvokeServer(p22)

    if v51 == true then
        if typeof(v53) ~= "number" then
            v53 = nil
        end

        if v53 == nil then
            v6:AtError():Log("skip-growth was granted but arrived without a product id")

            return false, "Invalid skip growth product", nil
        end

        v7 = p22

        return true, nil, v53
    end

    if typeof(v52) ~= "string" then
        v52 = nil
    end

    return false, v52, nil
end

function t1.BeginHatch(p23) -- line: 293
    -- upvalues: EggWorld (copy), v1 (copy)
    v1(p23)

    local v54, v55, v56 = EggWorld.AskHatch:InvokeServer(p23)
    local v57 = v54 == true

    if typeof(v55) ~= "string" then
        v55 = nil
    end

    if typeof(v56) == "string" then
        return v57, v55, v56
    end

    return v57, v55, nil
end

function t1.FinishHatch(p24) -- line: 302
    -- upvalues: EggWorld (copy), v1 (copy), v6 (copy)
    v1(p24)

    local v58, v59, v60 = EggWorld.AskFinishHatch:InvokeServer(p24)

    if v58 == true then
        if typeof(v60) ~= "string" then
            v60 = nil
        end

        if v60 ~= nil then
            return true, nil, v60
        end

        v6:AtError():Log("the hatch finished but the granted asset uid was not a string")

        return false, "Invalid granted asset UID", nil
    end

    if typeof(v59) ~= "string" then
        v59 = nil
    end

    return false, v59, nil
end

function t1.ReadChosenSkipUid() -- line: 319
    -- upvalues: v7 (ref)
    return v7
end

function t1.ForgetChosenSkip() -- line: 321
    -- upvalues: v7 (ref)
    v7 = nil
end

function t1.ReadOwnedEggs() -- line: 323
    -- upvalues: ownedRows (copy)
    return (ownedRows())
end

function t1.ReadFieldEggs() -- line: 325
    -- upvalues: fieldRows (copy)
    return (fieldRows())
end

function t1.HasFieldSnapshot() -- line: 327
    -- upvalues: v9 (ref)
    return v9
end

function t1.ReadCarryState() -- line: 329
    -- upvalues: v10 (ref), twin (copy)
    return twin(v10)
end

function t1.ReadOwnerEggs(p25) -- line: 331
    -- upvalues: TableUtil (copy), v2 (copy), t2 (copy)
    v2(p25)

    local v61 = t2[1][p25]

    if v61 == nil then
        return {}
    end

    return (TableUtil.Copy(v61, true))
end

function t1.ReadOwnedEgg(p26, p27) -- line: 338
    -- upvalues: TableUtil (copy), v1 (copy), v2 (copy), t2 (copy)
    v2(p26)
    v1(p27)

    local v62 = t2[1][p26]
    local v63 = if v62 == nil then nil else v62[p27]

    return if v63 ~= nil then TableUtil.Copy(v63, true) else nil
end

function t1.ReadFieldEgg(p28) -- line: 347
    -- upvalues: TableUtil (copy), v1 (copy), t3 (ref)
    v1(p28)

    local v64 = t3[p28]

    return if v64 ~= nil then TableUtil.Copy(v64, true) else nil
end

function t1.IsReadyToHatch(p29) -- line: 354
    -- upvalues: Workspace (copy), EggRecords (copy), t1 (copy), v1 (copy), LocalPlayer (copy)
    v1(p29)

    local v65 = t1.ReadOwnedEgg(LocalPlayer.UserId, p29)

    if v65 == nil or v65.Placement == nil then
        return false
    end

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local GrowthSpeedMultiplier = v65.GrowthSpeedMultiplier
    local v66 = EggRecords.CurrentNightCredit(v65, ServerTimeNow, GrowthSpeedMultiplier)

    return EggRecords.IsGrown(v65, ServerTimeNow, GrowthSpeedMultiplier, v66, LocalPlayer)
end

function t1.MayBuyChosenSkip() -- line: 368
    -- upvalues: t1 (copy), LocalPlayer (copy), v7 (ref)
    local v67 = v7

    if not v67 then
        return false, "No egg selected"
    end

    local v68 = t1.ReadOwnedEgg(LocalPlayer.UserId, v67)

    if v68 == nil or v68.Placement == nil then
        return false, "Egg not placed"
    end

    if t1.IsReadyToHatch(v67) then
        return false, "Egg is already ready"
    end

    return true
end

function t1.MayBuyGrowAll() -- line: 386
    -- upvalues: t1 (copy), LocalPlayer (copy), t2 (copy)
    for v69, v70 in t2[1][LocalPlayer.UserId] or {} do
        if v70.Placement ~= nil and not t1.IsReadyToHatch(v69) then
            return true
        end
    end

    return false, "You have no growing eggs!"
end

local t27 = {
    {
        complaint = "an owned egg write turned up malformed",
        feed = EggWorld.OwnerShifted,
        vet = Eggs.SchemaValidation.RuntimeEggOwnerUpdate,
        apply = function(p30) -- apply | line: 402
            -- upvalues: TableUtil (copy), t1 (copy), t2 (copy), t4 (copy), n1 (ref), ownedRows (copy)
            local OwnerUserId = p30.OwnerUserId

            n1 += 1
            t4[OwnerUserId] = n1

            local v71 = t2[1]
            local OwnerUserId2, Records = p30.OwnerUserId, p30.Records

            v71[OwnerUserId2] = TableUtil.Copy(Records, true)
            t1.OwnerRefreshed:Fire(p30.OwnerUserId, t1.ReadOwnerEggs(p30.OwnerUserId))
            t1.SnapshotRefreshed:Fire((ownedRows()))
        end
    },
    {
        complaint = "an owned egg erase turned up malformed",
        feed = EggWorld.OwnerDropped,
        vet = Eggs.SchemaValidation.RuntimeEggOwnerClear,
        apply = function(p31) -- apply | line: 413
            -- upvalues: t1 (copy), t2 (copy), t4 (copy), n1 (ref), ownedRows (copy)
            local OwnerUserId = p31.OwnerUserId

            n1 += 1
            t4[OwnerUserId] = n1

            local OwnerUserId2 = p31.OwnerUserId

            t2[1][OwnerUserId2] = nil
            t1.OwnerCleared:Fire(OwnerUserId2)
            t1.SnapshotRefreshed:Fire((ownedRows()))
        end
    },
    {
        complaint = "a field egg write turned up malformed",
        feed = EggWorld.FieldEggShifted,
        vet = AreaEggs.SchemaValidation.AreaEggRecord,
        apply = function(p32) -- apply | line: 422
            -- upvalues: TableUtil (copy), t1 (copy), t3 (ref), t5 (copy), n2 (ref)
            local Uid = p32.Uid

            n2 += 1
            t5[Uid] = n2

            local t17 = t3

            t17[p32.Uid] = TableUtil.Copy(p32, true)
            t1.FieldShifted:Fire((t1.ReadFieldEgg(p32.Uid)))
        end
    },
    {
        complaint = "a field egg removal turned up malformed",
        feed = EggWorld.FieldEggGone,
        vet = function(p33) -- vet | line: 430
            return typeof(p33) == "string", "expected a uid string"
        end,
        apply = function(p34) -- apply | line: 432
            -- upvalues: t1 (copy), t3 (ref), t5 (copy), n2 (ref)
            n2 += 1
            t5[p34] = n2

            local t19 = t3

            t19[p34] = nil
            t1.FieldGone:Fire(p34)
        end
    },
    {
        complaint = "a field egg batch turned up malformed",
        feed = EggWorld.FieldEggBatchShifted,
        vet = AreaEggs.SchemaValidation.AreaEggBatchUpdate,
        apply = function(p35) -- apply | line: 442
            -- upvalues: TableUtil (copy), t1 (copy), t3 (ref), t5 (copy), n2 (ref), fieldRows (copy)
            for _, v73 in ipairs(p35.RemovedUids) do
                n2 += 1
                t5[v73] = n2

                local t21 = t3

                t21[v73] = nil
            end

            for _, v74 in ipairs(p35.UpdatedRecords) do
                local Uid = v74.Uid

                n2 += 1
                t5[Uid] = n2

                local t22 = t3

                t22[v74.Uid] = TableUtil.Copy(v74, true)
            end

            t1.FieldRefreshed:Fire((fieldRows()))
        end
    },
    {
        complaint = "a field egg carry state turned up malformed",
        feed = EggWorld.FieldEggCarry,
        vet = AreaEggs.SchemaValidation.AreaEggCarryState,
        apply = function(p36) -- apply | line: 458
            -- upvalues: TableUtil (copy), t1 (copy), v10 (ref), twin (copy)
            v10 = TableUtil.Copy(p36, true)
            t1.CarryChanged:Fire(twin(v10))
        end
    },
    {
        complaint = "a field egg claim verdict turned up malformed",
        feed = EggWorld.FieldEggRedeemVerdict,
        vet = AreaEggs.SchemaValidation.AreaEggClaimFeedback,
        apply = function(p37) -- apply | line: 467
            -- upvalues: Workspace (copy), t1 (copy), v6 (copy), LocalPlayer (copy)
            v6:AtInfo():Log("Area egg claim latency trace", {
                Stage = "CLIENT_FEEDBACK_RECEIVED",
                UserId = LocalPlayer.UserId,
                ServerTime = Workspace:GetServerTimeNow(),
                AssetCategory = p37.AssetCategory,
                DisplayName = p37.DisplayName
            })
            t1.FieldClaimed:Fire(p37)
        end
    },
    {
        complaint = "a field egg reset sequence turned up malformed",
        feed = EggWorld.FieldEggCycleCountdown,
        vet = AreaEggResetCycle.SchemaValidation.SequencePayload,
        apply = function(p38) -- apply | line: 482
            -- upvalues: t1 (copy)
            t1.ResetCountdown:Fire(p38)
        end
    },
    {
        complaint = "a field egg rarity reveal turned up malformed",
        feed = EggWorld.FieldEggRaritiesShown,
        vet = AreaEggResetCycle.SchemaValidation.RevealPayload,
        apply = function(p39) -- apply | line: 488
            -- upvalues: t1 (copy)
            t1.RarityRevealed:Fire(p39)
        end
    }
}

for _, v76 in ipairs(t27) do
    v76.feed.OnClientEvent:Connect(function(p40) -- line: 493
        -- upvalues: v6 (copy), v76 (copy)
        local v77, v78 = v76.vet(p40)

        if v77 then
            v76.apply(p40)
        else
            v6:AtError():Log((("%*: %*"):format(v76.complaint, v78)))
        end
    end)
end

Players.PlayerRemoving:Connect(function(p41) -- line: 504
    -- upvalues: t1 (copy), t2 (copy), t4 (copy), n1 (ref), ownedRows (copy)
    local UserId = p41.UserId

    n1 += 1
    t4[UserId] = n1

    local UserId2 = p41.UserId

    t2[1][UserId2] = nil
    t1.OwnerCleared:Fire(UserId2)
    t1.SnapshotRefreshed:Fire((ownedRows()))
end)
task.spawn(keepAsking, "the owned egg snapshot", t1.SyncOwnedEggs)
task.spawn(keepAsking, "the field egg snapshot", t1.SyncFieldEggs)

return t1
