-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActiveAssetIncomePopup = require(script.Parent.Parent.Parent.GUI.ActiveAssetIncomePopup)
local ActiveAssetPerformanceTest = require(script.ActiveAssetPerformanceTest)
local ActiveAssetPerformanceTestConfig = require(script.ActiveAssetPerformanceTestConfig)
local AssetBillboardController = require(script.AssetBillboardController)
local AssetChatBubble = require(ReplicatedStorage.Client.UI.AssetChatBubble)
local AssetComponent = require(script.AssetComponent)
local AssetHoverDataDisplay = require(script.Parent.Parent.Parent.GUI.AssetHoverDataDisplay)
local AssetMovementBatch = require(script.AssetMovementBatch)
local AssetPlacementHints = require(script.AssetPlacementHints)
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)

require(ReplicatedStorage.Shared.Types.AssetRuntime)

local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local ModelCameraOcclusion = require(ReplicatedStorage.Client.ModelCameraOcclusion)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = AssetMovementBatch.new()
local v2 = AssetBillboardController.new()
local t1 = {}
local t2 = {}
local v3 = false
local v4 = Preferences.IsOn("HideOtherPets")
local v5 = Preferences.IsOn("HideSelfPets")
local v6 = false
local t3 = {}
local Folder = Instance.new("Folder")

Folder.Name = "ClientRenderedAssets"
Folder.Parent = workspace

local t4 = {
    ItemAdded = Signal.new(),
    ItemRemoved = Signal.new(),
    CashCollected = Signal.new(),
    InitialLoadCompleted = Signal.new()
}

local function makeKey(p1, p2) -- line: 62
    return (("%*:%*"):format(p1, p2))
end

local function recordForComponent(p3, p4) -- line: 64
    -- upvalues: t2 (copy)
    if p4.IsFirstPlacement ~= true then
        return p4
    end

    if t2[p3] == true then
        local v7 = table.clone(p4)
        local v8 = table.clone(p4.ItemData)

        v8.Mutations = table.clone(p4.ItemData.Mutations)
        v7.ItemData = v8
        v7.IsFirstPlacement = nil

        return v7
    end

    t2[p3] = true

    return p4
end

local function isOwnerHidden(p5) -- line: 83
    -- upvalues: Players (copy), v4 (ref), v5 (ref)
    if p5 == Players.LocalPlayer.UserId then
        return v5
    end

    return v4
end

local function syncHoverEntry(p6) -- line: 87
    -- upvalues: Players (copy), AssetHoverDataDisplay (copy), v4 (ref), v5 (ref), t3 (copy)
    local OwnerUserId = p6:GetOwnerUserId()
    local Uid = p6:GetUid()

    if (if OwnerUserId == Players.LocalPlayer.UserId then v5 else v4) or t3[("%*:%*"):format(OwnerUserId, Uid)] then
        AssetHoverDataDisplay.RemoveEntry(OwnerUserId, Uid)
    else
        local RuntimeRecord = p6:GetRuntimeRecord()

        AssetHoverDataDisplay.SetEntry({
            Record = RuntimeRecord,
            Model = p6:GetModel()
        })
    end
end

local function applyComponentHiddenState(p7) -- line: 102
    -- upvalues: Players (copy), ModelCameraOcclusion (copy), v2 (copy), v4 (ref), v5 (ref), v6 (ref), t3 (copy)
    local v9 = v6

    if not v9 then
        v9 = (if p7:GetOwnerUserId() == Players.LocalPlayer.UserId then v5 else v4) or t3[("%*:%*"):format(p7:GetOwnerUserId(), (p7:GetUid()))] == true
    end

    if p7:IsHidden() ~= v9 then
        local Model = p7:GetModel()

        if v9 then
            ModelCameraOcclusion.SetIgnored(Model, true)
            p7:SetHidden(true)
            v2:SetSuppressed(Model, true)
        else
            p7:SetHidden(false)
            v2:SetSuppressed(Model, false)
            ModelCameraOcclusion.SetIgnored(Model, false)
        end
    end
end

local function setHideOtherPets(p8) -- line: 122
    -- upvalues: v1 (copy), t1 (copy), v4 (ref), syncHoverEntry (copy), applyComponentHiddenState (copy)
    if v4 == p8 then
        return
    end

    v4 = p8

    if p8 then
        v1:SetForeignPresentationSuppressed(true)
    end

    for _, v10 in pairs(t1) do
        if v10 ~= nil then
            applyComponentHiddenState(v10)
            syncHoverEntry(v10)
        end
    end

    if not p8 then
        v1:SetForeignPresentationSuppressed(false)
    end
end

local function setHideSelfPets(p9) -- line: 144
    -- upvalues: t1 (copy), v5 (ref), syncHoverEntry (copy), applyComponentHiddenState (copy)
    if v5 == p9 then
        return
    end

    v5 = p9

    for _, v11 in pairs(t1) do
        if v11 ~= nil then
            applyComponentHiddenState(v11)
            syncHoverEntry(v11)
        end
    end
end

function t4.SetAllPetsHidden(p10) -- line: 158
    -- upvalues: t1 (copy), v6 (ref), syncHoverEntry (copy), applyComponentHiddenState (copy)
    if v6 == p10 then
        return
    end

    v6 = p10

    for _, v12 in pairs(t1) do
        if v12 ~= nil then
            applyComponentHiddenState(v12)
            syncHoverEntry(v12)
        end
    end
end

local function destroyComponent(p11) -- line: 172
    -- upvalues: AssetHoverDataDisplay (copy), v2 (copy), t1 (copy), t4 (copy)
    local v13 = t1[p11]

    if v13 == nil then
        return
    end

    local Model = v13:GetModel()

    v2:Remove(Model)
    AssetHoverDataDisplay.RemoveEntry(v13:GetOwnerUserId(), v13:GetUid())
    v13:Destroy()
    t1[p11] = nil
    t4.ItemRemoved:Fire(Model)
end

local function clearOwner(p12) -- line: 185
    -- upvalues: t1 (copy), destroyComponent (copy)
    for v14, v15 in pairs(t1) do
        if v15 ~= nil and v15:GetOwnerUserId() == p12 then
            destroyComponent(v14)
        end
    end
end

local function reconcileOwner(p13, p14) -- line: 193
    -- upvalues: Players (copy), AssetComponent (copy), AssetPlacementHints (copy), AssetRoster (copy), v1 (copy), v2 (copy), t1 (copy), Folder (copy), t4 (copy), recordForComponent (copy), syncHoverEntry (copy), applyComponentHiddenState (copy), destroyComponent (copy), clearOwner (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p13)

    if PlayerByUserId ~= nil then
        local v16 = AssetRoster.FindPenArea(PlayerByUserId)

        if v16 ~= nil then
            local t5 = {}

            for v17, v18 in pairs(p14) do
                local v19 = ("%*:%*"):format(p13, v17)

                t5[v19] = true

                local v20 = recordForComponent(v19, v18)
                local v21 = t1[v19]

                if v21 ~= nil and table.concat(v21:GetRuntimeRecord().ItemData.Mutations, ",") ~= table.concat(v18.ItemData.Mutations, ",") then
                    v21 = nil
                    destroyComponent(v19)
                end

                if v21 ~= nil then
                    if PlayerByUserId == Players.LocalPlayer then
                        AssetPlacementHints.ClearFrontPlacement(v17)
                    end

                    v21:SetRuntimeRecord(v20)
                    v21:SetAssetArea(v16)
                    v2:UpdateMoneyPerSecond(v21:GetModel(), v20.MoneyPerSecond)
                else
                    local v22 = if PlayerByUserId == Players.LocalPlayer then AssetPlacementHints.ConsumeFrontPlacement(v17, v16) else nil

                    v21 = AssetComponent.new(v20, PlayerByUserId, v16, Folder, v2, v1, v22)
                    t1[v19] = v21
                    v2:Add(v21:GetModel(), v20.ItemData, v20.MoneyPerSecond)
                    t4.ItemAdded:Fire(v21:GetModel())
                end

                applyComponentHiddenState(v21)
                syncHoverEntry(v21)
            end

            for v23, v24 in pairs(t1) do
                if v24 ~= nil and v24:GetOwnerUserId() == p13 and t5[v23] ~= true then
                    destroyComponent(v23)
                end
            end
        end
    else
        clearOwner(p13)
    end
end

local function reconcileSnapshot(p15) -- line: 257
    -- upvalues: t1 (copy), destroyComponent (copy), reconcileOwner (copy)
    local t6 = {}

    for _, v25 in ipairs(p15) do
        t6[v25.OwnerUserId] = true
        reconcileOwner(v25.OwnerUserId, v25.Records)
    end

    for v26, v27 in pairs(t1) do
        if v27 ~= nil and t6[v27:GetOwnerUserId()] ~= true then
            destroyComponent(v26)
        end
    end
end

function t4.SetMountedPet(p16, p17, p18) -- line: 274
    -- upvalues: t1 (copy), t3 (copy), syncHoverEntry (copy), applyComponentHiddenState (copy)
    local v28 = ("%*:%*"):format(p16, p17)

    t3[v28] = if p18 then true else nil

    local v30 = t1[v28]

    if v30 then
        applyComponentHiddenState(v30)
        syncHoverEntry(v30)
    end
end

function t4.GetModelByUID(p19) -- line: 281
    -- upvalues: t1 (copy)
    for _, v31 in pairs(t1) do
        if v31 ~= nil and v31:GetUid() == p19 then
            return v31:GetModel()
        end
    end

    return nil
end

function t4.GetAll() -- line: 290
    -- upvalues: t1 (copy)
    local t7 = {}

    for _, v32 in pairs(t1) do
        if v32 ~= nil then
            t7[v32:GetUid()] = v32:GetModel()
        end
    end

    return t7
end

function t4.GetActiveModels() -- line: 300
    -- upvalues: t4 (copy)
    local t8 = {}

    for _, v33 in pairs(t4.GetAll()) do
        table.insert(t8, v33)
    end

    return t8
end

AssetRoster.SnapshotRefreshed:Connect(reconcileSnapshot)
AssetRoster.OwnerRefreshed:Connect(reconcileOwner)
AssetRoster.OwnerCleared:Connect(clearOwner)
t4.ItemAdded:Connect(function(p20) -- line: 316
    -- upvalues: ModelCameraOcclusion (copy)
    ModelCameraOcclusion.Register(p20, 1)
end)
t4.ItemRemoved:Connect(ModelCameraOcclusion.Forget)
Preferences.Observe("HideOtherPets", setHideOtherPets)
Preferences.Observe("HideSelfPets", setHideSelfPets)
Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p21) -- line: 321
    -- upvalues: AssetChatBubble (copy), ModelCameraOcclusion (copy), v3 (ref)
    v3 = p21 ~= nil
    ModelCameraOcclusion.SetEnabled(v3)
    AssetChatBubble.PinAbove(not v3)
end)
AssetRoster.PenAreaChanged:Connect(function(p22) -- line: 327
    -- upvalues: AssetRoster (copy), reconcileOwner (copy)
    reconcileOwner(p22.UserId, AssetRoster.ReadOwnerPen(p22.UserId))
end)
Players.PlayerRemoving:Connect(function(p23) -- line: 329
    -- upvalues: clearOwner (copy)
    clearOwner(p23.UserId)
end)
Remotes.PenRoster.CoinsGathered.OnClientEvent:Connect(function(p24) -- line: 330
    -- upvalues: Players (copy), ActiveAssetIncomePopup (copy), v3 (ref), v6 (ref), t3 (copy), t4 (copy)
    for _, v34 in ipairs(p24) do
        local uid = v34.uid

        if uid ~= nil then
            t4.CashCollected:Fire(uid)

            if not v6 and not t3[("%*:%*"):format(Players.LocalPlayer.UserId, uid)] then
                assert(v34.amount > 0, (("Active asset income popup requires positive amount for uid \"%*\""):format(uid)))

                local v39 = assert(t4.GetModelByUID(uid), (("Active asset income popup missing rendered model for uid \"%*\""):format(uid)))

                ActiveAssetIncomePopup.Show(v39, v34.amount, {
                    alwaysOnTop = not v3
                })
            end
        end
    end
end)

if ActiveAssetPerformanceTestConfig.Enabled and Constants.IS_STUDIO then
    ActiveAssetPerformanceTest.Start(Folder, v2, v1)
end

v1:SetForeignPresentationSuppressed(v4)
reconcileSnapshot(AssetRoster.ReadSnapshot())
t4.InitialLoadCompleted:Fire()

return t4
