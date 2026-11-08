-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetRuntime = require(ReplicatedStorage.Shared.Types.AssetRuntime)
local Log = require(ReplicatedStorage.Packages.Log)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Packages.Signal)
local PenRoster = Remotes.PenRoster
local t1 = {
    SnapshotRefreshed = Signal.new(),
    OwnerRefreshed = Signal.new(),
    OwnerCleared = Signal.new(),
    PenAreaChanged = Signal.new()
}
local v1 = Log.new()
local t2 = {}
local t3 = {}
local n1 = 0

local function copyContents(p1) -- line: 47
    local t4 = {}

    for v2, v3 in p1 do
        local v4 = table.clone(v3.ItemData)

        v4.Mutations = table.clone(v3.ItemData.Mutations)
        t4[v2] = {
            OwnerUserId = v3.OwnerUserId,
            UID = v3.UID,
            ItemData = v4,
            MoneyPerSecond = v3.MoneyPerSecond,
            Seed = v3.Seed,
            IsFirstPlacement = v3.IsFirstPlacement
        }
    end

    return t4
end

local function everyPen() -- line: 64
    -- upvalues: t2 (ref), copyContents (copy)
    local t5 = {}

    for v5, v6 in t2 do
        table.insert(t5, {
            OwnerUserId = v5,
            Records = copyContents(v6)
        })
    end

    return t5
end

local function announce() -- line: 72
    -- upvalues: t1 (copy), everyPen (copy)
    t1.SnapshotRefreshed:Fire((everyPen()))
end

local function adopt(p2, p3) -- line: 74
    -- upvalues: t1 (copy), t2 (ref), t3 (copy), copyContents (copy), everyPen (copy)
    local t7 = {}

    for v7, v8 in t2 do
        if p3 < (t3[v7] or 0) then
            t7[v7] = copyContents(v8)
        else
            t7[v7] = nil
        end
    end

    for _, v9 in ipairs(p2) do
        local v10 = (t3[v9.OwnerUserId] or 0) <= p3
        local OwnerUserId = v9.OwnerUserId

        if v10 then
            t7[OwnerUserId] = copyContents(v9.Records)
        else
            t7[OwnerUserId] = t7[v9.OwnerUserId]
        end
    end

    t2 = t7
    t1.SnapshotRefreshed:Fire((everyPen()))
end

local function pullUntilAnswered() -- line: 89
    -- upvalues: AssetRuntime (copy), PenRoster (copy), v1 (copy), n1 (ref), adopt (copy), pullUntilAnswered (copy)
    local v11 = n1

    local function v12() -- line: 91
        -- upvalues: PenRoster (copy)
        return PenRoster.AskLiveSnapshot:InvokeServer()
    end

    local ok, result = pcall(v12)
    local v13, v14

    if ok then
        v13, v14 = AssetRuntime.SchemaValidation.RuntimeAssetSnapshot(result)
    else
        v14 = tostring(result)
        v13 = false
    end

    if v13 then
        adopt(result, v11)
    else
        v1:AtError():Log((("pen roster snapshot never landed, going round again: %*"):format(v14)))
        task.delay(5, pullUntilAnswered)
    end
end

local function outcome(p4, p5) -- line: 107
    local v15 = p4 == true

    if typeof(p5) == "string" then
        return v15, p5
    end

    return v15, nil
end

local function confirmed(p6) -- line: 111
    return p6:InvokeServer() == true
end

function t1.WearAsset(p7) -- line: 113
    -- upvalues: PenRoster (copy)
    local v16, v17, v18 = PenRoster.AskWear:InvokeServer(p7)
    local v19 = v16 == true

    if typeof(v17) ~= "string" then
        v17 = nil
    end

    if typeof(v18) == "string" then
        return v19, v17, v18
    end

    return v19, v17, nil
end

function t1.DoffAsset(p8) -- line: 119
    -- upvalues: PenRoster (copy), outcome (copy)
    return outcome(PenRoster.AskDoff:InvokeServer(p8))
end

function t1.ReadWearLimit() -- line: 123
    -- upvalues: PenRoster (copy)
    local v20 = PenRoster.AskWearLimit:InvokeServer()

    if typeof(v20) == "number" then
        return v20
    end

    return 0
end

function t1.AckPetsBadge() -- line: 128
    -- upvalues: PenRoster (copy)
    return PenRoster.ConfirmPetsBadge:InvokeServer() == true
end

function t1.AckEquipBestBadge() -- line: 130
    -- upvalues: PenRoster (copy)
    return PenRoster.ConfirmEquipBestBadge:InvokeServer() == true
end

function t1.ReadSnapshot() -- line: 132
    -- upvalues: everyPen (copy)
    return (everyPen())
end

function t1.ReadOwnerPen(p9) -- line: 134
    -- upvalues: t2 (ref), copyContents (copy)
    local v21 = t2[p9]

    if v21 == nil then
        return {}
    end

    return (copyContents(v21))
end

function t1.FindPenArea(p10) -- line: 139
    -- upvalues: PlotState (copy)
    local v22 = PlotState.ResolvePlot(p10)

    return if v22 ~= nil then v22.PetArea else nil
end

local t12 = {
    {
        complaint = "pen roster owner write turned away",
        feed = PenRoster.OwnerShifted,
        vet = AssetRuntime.SchemaValidation.RuntimeAssetOwnerUpdate,
        apply = function(p11) -- apply | line: 149
            -- upvalues: t1 (copy), t2 (ref), copyContents (copy)
            local t9 = t2

            t9[p11.OwnerUserId] = copyContents(p11.Records)
            t1.OwnerRefreshed:Fire(p11.OwnerUserId, (copyContents(p11.Records)))
        end
    },
    {
        complaint = "pen roster owner erase turned away",
        feed = PenRoster.OwnerDropped,
        vet = AssetRuntime.SchemaValidation.RuntimeAssetOwnerClear,
        apply = function(p12) -- apply | line: 158
            -- upvalues: t1 (copy), t2 (ref)
            local t11 = t2

            t11[p12.OwnerUserId] = nil
            t1.OwnerCleared:Fire(p12.OwnerUserId)
        end
    }
}

for _, v23 in ipairs(t12) do
    v23.feed.OnClientEvent:Connect(function(p13) -- line: 166
        -- upvalues: t1 (copy), v1 (copy), t3 (copy), n1 (ref), everyPen (copy), v23 (copy)
        local v24, v25 = v23.vet(p13)

        if not v24 then
            v1:AtError():Log((("%*: %*"):format(v23.complaint, v25)))

            return
        end

        n1 += 1
        t3[p13.OwnerUserId] = n1
        v23.apply(p13)
        t1.SnapshotRefreshed:Fire((everyPen()))
    end)
end

PlotState.PlotChanged:Connect(function(_, p15) -- line: 181
    -- upvalues: Players (copy), t1 (copy)
    local v26 = if p15 == nil then nil else Players:GetPlayerByUserId(p15)

    if v26 ~= nil then
        t1.PenAreaChanged:Fire(v26, t1.FindPenArea(v26))
    end
end)
task.spawn(pullUntilAnswered)

return t1
