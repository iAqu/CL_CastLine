-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(script.Parent.AssetBillboardController)

local AssetComponent = require(script.Parent.AssetComponent)
local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
local AssetGender = require(ReplicatedStorage.Shared.Util.AssetGender)

require(script.Parent.AssetMovementBatch)

local AssetRuntime = require(ReplicatedStorage.Shared.Types.AssetRuntime)
local Assets = require(ReplicatedStorage.Data.Assets)
local ActiveAssetPerformanceTestConfig = require(script.Parent.ActiveAssetPerformanceTestConfig)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local Log = require(ReplicatedStorage.Packages.Log)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local v1 = Log.new()
local v2 = Random.new()
local t1 = {}
local t2 = {}
local v3, v4, Folder

for v5 in pairs(Assets.Directory) do
    if v5 ~= "Frigo Camelo" then
        table.insert(t1, v5)
    end
end

table.sort(t1)
assert(#t1 > 0, "Active asset performance test requires at least one eligible category")

local t3 = {}

local function buildRuntimeRecord(p1, p2) -- line: 56
    -- upvalues: Players (copy), AssetEarnings (copy), AssetGender (copy), AssetRuntime (copy), EggRecords (copy), v2 (copy), t1 (copy)
    local v7 = t1[v2:NextInteger(1, #t1)]
    local v8 = EggRecords.NewEgg(v7, v2)

    v8.AssetGender = AssetGender.Settle(v7, nil, v2)

    local v9 = EggRecords.ToAssetItemData(v8)

    v9.HasBeenFirstPlaced = true

    local v10 = ("PERFORMANCE_TEST_%*_%*"):format(p1, p2)
    local t4 = {
        OwnerUserId = Players.LocalPlayer.UserId,
        UID = v10,
        ItemData = v9,
        MoneyPerSecond = AssetEarnings.LiveRatePerSecond(v9),
        Seed = v2:NextInteger(1, 2147483647)
    }

    assert(AssetRuntime.SchemaValidation.RuntimeAssetRecord(t4), "Invalid performance-test asset record")

    return t4
end

local function destroySlot(p3) -- line: 77
    -- upvalues: t2 (copy), v3 (ref)
    local v12 = t2[p3]

    if v12 == nil then
        return
    end

    t2[p3] = nil

    for _, v13 in ipairs(v12.Components) do
        local v14 = v3

        v14:Remove(v13:GetModel())
        v13:Destroy()
    end

    v12.Container:Destroy()
end

local function activateSlot(p4, p5) -- line: 90
    -- upvalues: Players (copy), AssetComponent (copy), ActiveAssetPerformanceTestConfig (copy), v1 (copy), t2 (copy), v3 (ref), v4 (ref), Folder (ref), buildRuntimeRecord (copy)
    local Folder2 = Instance.new("Folder")

    Folder2.Name = ("Plot%*"):format(p4)
    Folder2.Parent = Folder

    local t5 = {}

    for i = 1, ActiveAssetPerformanceTestConfig.PetsPerPlot do
        local v15 = buildRuntimeRecord(p4, i)
        local v16 = AssetComponent.new(v15, Players.LocalPlayer, p5, Folder2, v3, v4, nil)
        local v17 = v3

        v17:Add(v16:GetModel(), v15.ItemData, v15.MoneyPerSecond)
        table.insert(t5, v16)
    end

    t2[p4] = {
        Area = p5,
        Components = t5,
        Container = Folder2
    }
    v1:AtInfo():Log((("Created %* performance-test pets for plot %*"):format(ActiveAssetPerformanceTestConfig.PetsPerPlot, p4)))
end

local function syncSlot(p6) -- line: 117
    -- upvalues: PlotState (copy), t2 (copy), destroySlot (copy), activateSlot (copy)
    local v18 = PlotState.ResolveFolder()
    local PetArea, v19

    if v18 ~= nil then
        local v20 = v18:FindFirstChild((tostring(p6)))

        v19 = v20 ~= nil

        local ToUpdate = if v20 == nil then nil else v20:FindFirstChild("ToUpdate")

        if ToUpdate ~= nil and ToUpdate:IsA("Model") then
            PetArea = ToUpdate:FindFirstChild("PetArea")
        end

        if PetArea ~= nil and not PetArea:IsA("BasePart") then
            PetArea = nil
        end
    else
        v19 = false
    end

    local v21 = t2[p6]

    if not v19 then
        destroySlot(p6)

        return
    end

    if PetArea ~= nil then
        if v21 ~= nil then
            if v21.Area ~= PetArea then
                v21.Area = PetArea

                for _, v22 in ipairs(v21.Components) do
                    v22:SetAssetArea(PetArea)
                end
            end
        else
            activateSlot(p6, PetArea)
        end
    end
end

local function syncAllSlots() -- line: 153
    -- upvalues: PlotState (copy), t2 (copy), destroySlot (copy), syncSlot (copy)
    local v23 = PlotState.ResolveFolder()
    local t6 = {}

    if v23 ~= nil then
        for _, child in ipairs(v23:GetChildren()) do
            local v24 = tonumber(child.Name)

            if v24 ~= nil then
                t6[v24] = true
                syncSlot(v24)
            end
        end
    end

    for v25 in pairs(t2) do
        if t6[v25] ~= true then
            destroySlot(v25)
        end
    end
end

function t3.Start(p7, p8, p9) -- line: 176
    -- upvalues: ActiveAssetPerformanceTestConfig (copy), PlotState (copy), v3 (ref), v4 (ref), Folder (ref), syncSlot (copy), syncAllSlots (copy)
    assert(ActiveAssetPerformanceTestConfig.PetsPerPlot > 0 and ActiveAssetPerformanceTestConfig.PetsPerPlot % 1 == 0, "PetsPerPlot must be a positive integer")
    v3 = p8
    v4 = p9
    Folder = Instance.new("Folder")
    Folder.Name = "PerformanceTestAssets"
    Folder.Parent = p7
    PlotState.PlotChanged:Connect(syncSlot)
    PlotState.FolderChanged:Connect(syncAllSlots)
    syncAllSlots()
end

return t3
