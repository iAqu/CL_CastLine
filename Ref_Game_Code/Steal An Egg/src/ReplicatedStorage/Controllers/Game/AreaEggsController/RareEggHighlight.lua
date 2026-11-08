-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Types.AreaEggResetCycle)
require(ReplicatedStorage.Shared.Types.AreaEggs)

local t = require(ReplicatedStorage.Packages.t)
local Assets = require(ReplicatedStorage.Data.Assets)
local CaptureTheEgg = require(ReplicatedStorage.Data.CaptureTheEgg)
local EggState = require(ReplicatedStorage.Client.EggState)
local Log = require(ReplicatedStorage.Packages.Log)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local WorkspaceEggVisibility = require(script.Parent.WorkspaceEggVisibility)
local Rank = Rarity.Rarities.Secret.Rank
local v1 = Log.new()
local t1 = {}
local t2 = {}
local t3 = {}
local v2
local v3 = false
local n1 = (-1e999)
local v4 = false
local t4 = {}

local function getOutlineColor(p1, p2) -- line: 50
    -- upvalues: Workspace (copy), Assets (copy), CaptureTheEgg (copy), Rank (copy)
    if Workspace:GetAttribute(CaptureTheEgg.EggUidAttribute) == p1 then
        return CaptureTheEgg.EggHighlightColor
    end

    local v5 = Assets.Directory[p2]

    assert(v5 ~= nil, (("Missing asset config %*"):format(p2)))

    local Rarity = v5.Rarity

    return if not (Rarity.Rank < Rank) then Rarity.Color else nil
end

local function clearBinding(p3) -- line: 63
    -- upvalues: t2 (copy)
    local v8 = t2[p3]

    if v8 == nil then
        return
    end

    t2[p3] = nil

    local DestroyConnection = v8.DestroyConnection

    if DestroyConnection ~= nil then
        DestroyConnection:Disconnect()
    end

    if v8.Highlight.Parent ~= nil then
        v8.Highlight:Destroy()
    end
end

local function clearAllBindings() -- line: 78
    -- upvalues: t2 (copy)
    for v9 in pairs(t2) do
        local v10 = t2[v9]

        if v10 ~= nil then
            t2[v9] = nil

            local DestroyConnection = v10.DestroyConnection

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect()
            end

            if v10.Highlight.Parent ~= nil then
                v10.Highlight:Destroy()
            end
        end
    end
end

local function bindModel(p4, p5, p6) -- line: 84
    -- upvalues: t2 (copy)
    local v11 = t2[p4]

    if v11 ~= nil and v11.Model == p5 then
        v11.Highlight.OutlineColor = p6

        return
    end

    local v12 = t2[p4]

    if v12 ~= nil then
        t2[p4] = nil

        local DestroyConnection = v12.DestroyConnection

        if DestroyConnection ~= nil then
            DestroyConnection:Disconnect()
        end

        if v12.Highlight.Parent ~= nil then
            v12.Highlight:Destroy()
        end
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "RareAreaEggHighlight"
    Highlight.Adornee = p5
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 0.25
    Highlight.OutlineColor = p6
    Highlight.Parent = p5

    local t5 = {
        DestroyConnection = nil,
        Model = p5,
        Highlight = Highlight
    }

    t2[p4] = t5
    t5.DestroyConnection = p5.Destroying:Connect(function() -- line: 107
        -- upvalues: p4 (copy), t5 (copy), t2 (copy)
        if t2[p4] == t5 then
            t2[p4] = nil
        end
    end)
end

local function syncUid(p7) -- line: 114
    -- upvalues: Workspace (copy), Assets (copy), CaptureTheEgg (copy), WorkspaceEggVisibility (copy), Rank (copy), t1 (copy), t2 (copy), t3 (copy), v3 (ref), bindModel (copy)
    local v13 = t1[p7]

    if v13 ~= nil then
        if v3 then
            local v15 = t2[p7]

            if v15 ~= nil then
                t2[p7] = nil

                local DestroyConnection = v15.DestroyConnection

                if DestroyConnection ~= nil then
                    DestroyConnection:Disconnect()
                end

                if v15.Highlight.Parent ~= nil then
                    v15.Highlight:Destroy()
                end
            end
        else
            local v16

            if Workspace:GetAttribute(CaptureTheEgg.EggUidAttribute) == p7 then
                v16 = CaptureTheEgg.EggHighlightColor
            else
                local v17 = Assets.Directory[v13]

                assert(v17 ~= nil, (("Missing asset config %*"):format(v13)))

                local Rarity = v17.Rarity

                if not (Rarity.Rank < Rank) then
                    v16 = Rarity.Color
                end
            end

            if v16 ~= nil then
                local v21 = t3[p7]

                t3[p7] = nil

                if v21 == nil or v21.Parent == nil then
                    local v22 = t2[p7]

                    if v22 == nil or v22.Model.Parent == nil then
                        local v23 = WorkspaceEggVisibility.ResolveModel(p7)

                        if v23 ~= nil then
                            bindModel(p7, v23, v16)
                        end
                    else
                        v22.Highlight.OutlineColor = v16
                    end
                else
                    bindModel(p7, v21, v16)
                end
            else
                t3[p7] = nil

                local v20 = t2[p7]

                if v20 ~= nil then
                    t2[p7] = nil

                    local DestroyConnection = v20.DestroyConnection

                    if DestroyConnection ~= nil then
                        DestroyConnection:Disconnect()
                    end

                    if v20.Highlight.Parent ~= nil then
                        v20.Highlight:Destroy()
                    end
                end
            end
        end
    else
        t3[p7] = nil

        local v14 = t2[p7]

        if v14 ~= nil then
            t2[p7] = nil

            local DestroyConnection = v14.DestroyConnection

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect()
            end

            if v14.Highlight.Parent ~= nil then
                v14.Highlight:Destroy()
            end
        end
    end
end

local function beginResetReveal(p8) -- line: 149
    -- upvalues: t2 (copy), t3 (copy), v3 (ref), n1 (ref)
    if p8.DayStartsAt <= n1 then
        return
    end

    n1 = p8.DayStartsAt
    v3 = true
    table.clear(t3)

    for v24 in pairs(t2) do
        local v25 = t2[v24]

        if v25 ~= nil then
            t2[v24] = nil

            local DestroyConnection = v25.DestroyConnection

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect()
            end

            if v25.Highlight.Parent ~= nil then
                v25.Highlight:Destroy()
            end
        end
    end
end

local function completeResetReveal() -- line: 159
    -- upvalues: t1 (copy), v3 (ref), syncUid (copy)
    v3 = false

    for v26 in pairs(t1) do
        syncUid(v26)
    end
end

local function applyRecord(p9) -- line: 166
    -- upvalues: t1 (copy), syncUid (copy)
    t1[p9.Uid] = p9.AssetCategory
    syncUid(p9.Uid)
end

local function applySnapshot(p10) -- line: 171
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), v2 (ref), syncUid (copy)
    local t6 = {}

    for _, v27 in ipairs(p10.Records) do
        t6[v27.Uid] = true
        t1[v27.Uid] = v27.AssetCategory
    end

    for v28 in pairs(t1) do
        if t6[v28] ~= true and v28 ~= v2 then
            t1[v28] = nil
            t3[v28] = nil

            local v29 = t2[v28]

            if v29 ~= nil then
                t2[v28] = nil

                local DestroyConnection = v29.DestroyConnection

                if DestroyConnection ~= nil then
                    DestroyConnection:Disconnect()
                end

                if v29.Highlight.Parent ~= nil then
                    v29.Highlight:Destroy()
                end
            end
        end
    end

    for v30 in pairs(t6) do
        syncUid(v30)
    end
end

local function applyCarryState(p11) -- line: 189
    -- upvalues: EggState (copy), t1 (copy), t2 (copy), t3 (copy), v2 (ref), syncUid (copy)
    local v31 = v2

    if p11.IsCarrying then
        local v32 = assert(p11.Uid, "Carried area egg state must include Uid")
        local v33 = assert(p11.AssetCategory, "Carried area egg state must include AssetCategory")

        v2 = v32
        t1[v32] = v33
        syncUid(v32)
    else
        v2 = nil

        if v31 ~= nil then
            local v34 = EggState.ReadFieldEgg(v31)

            if v34 ~= nil then
                t1[v34.Uid] = v34.AssetCategory
                syncUid(v34.Uid)
            else
                t1[v31] = nil
                t3[v31] = nil

                local v35 = t2[v31]

                if v35 ~= nil then
                    t2[v31] = nil

                    local DestroyConnection = v35.DestroyConnection

                    if DestroyConnection ~= nil then
                        DestroyConnection:Disconnect()
                    end

                    if v35.Highlight.Parent ~= nil then
                        v35.Highlight:Destroy()
                    end
                end
            end
        end
    end
end

local function observeWorkspaceChild(p12) -- line: 215
    -- upvalues: Workspace (copy), Assets (copy), CaptureTheEgg (copy), Rank (copy), t1 (copy), v3 (ref), bindModel (copy)
    if p12:IsA("Model") then
        task.defer(function() -- line: 219
            -- upvalues: p12 (copy), Workspace (copy), Assets (copy), CaptureTheEgg (copy), Rank (copy), t1 (copy), v3 (ref), bindModel (copy)
            if v3 then
                return
            end

            local Name = p12.Name
            local v36 = t1[Name]

            if p12.Parent == Workspace and v36 ~= nil then
                local v37

                if Workspace:GetAttribute(CaptureTheEgg.EggUidAttribute) == Name then
                    v37 = CaptureTheEgg.EggHighlightColor
                else
                    local v38 = Assets.Directory[v36]

                    assert(v38 ~= nil, (("Missing asset config %*"):format(v36)))

                    local Rarity = v38.Rarity

                    if not (Rarity.Rank < Rank) then
                        v37 = Rarity.Color
                    end
                end

                if v37 ~= nil then
                    bindModel(Name, p12, v37)
                end
            end
        end)
    end
end

function t4.BindRenderedModel(p13, p14) -- line: 239
    -- upvalues: Workspace (copy), t (copy), Assets (copy), CaptureTheEgg (copy), Rank (copy), t1 (copy), t2 (copy), t3 (copy), v3 (ref), bindModel (copy)
    t.strict(t.table)(p13)
    t.strict(t.instanceIsA("Model"))(p14)
    t1[p13.Uid] = p13.AssetCategory

    if v3 then
        t3[p13.Uid] = p14

        local Uid = p13.Uid
        local v41 = t2[Uid]

        if v41 ~= nil then
            t2[Uid] = nil

            local DestroyConnection = v41.DestroyConnection

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect()
            end

            if v41.Highlight.Parent ~= nil then
                v41.Highlight:Destroy()
            end
        end
    else
        local Uid, AssetCategory = p13.Uid, p13.AssetCategory
        local v42

        if Workspace:GetAttribute(CaptureTheEgg.EggUidAttribute) == Uid then
            v42 = CaptureTheEgg.EggHighlightColor
        else
            local v43 = Assets.Directory[AssetCategory]

            assert(v43 ~= nil, (("Missing asset config %*"):format(AssetCategory)))

            local Rarity = v43.Rarity

            if not (Rarity.Rank < Rank) then
                v42 = Rarity.Color
            end
        end

        if v42 ~= nil then
            bindModel(p13.Uid, p14, v42)
        else
            local Uid = p13.Uid
            local v46 = t2[Uid]

            if v46 ~= nil then
                t2[Uid] = nil

                local DestroyConnection = v46.DestroyConnection

                if DestroyConnection ~= nil then
                    DestroyConnection:Disconnect()
                end

                if v46.Highlight.Parent ~= nil then
                    v46.Highlight:Destroy()
                end
            end
        end
    end
end

function t4.Start() -- line: 256
    -- upvalues: Workspace (copy), CaptureTheEgg (copy), EggState (copy), v1 (copy), t1 (copy), t2 (copy), t3 (copy), v2 (ref), v4 (ref), syncUid (copy), beginResetReveal (copy), completeResetReveal (copy), applyRecord (copy), applySnapshot (copy), applyCarryState (copy), observeWorkspaceChild (copy)
    assert(not v4, "RareEggHighlight.Start may only be called once")
    v4 = true
    EggState.ResetCountdown:Connect(beginResetReveal)
    EggState.RarityPresented:Connect(completeResetReveal)
    EggState.FieldRefreshed:Connect(applySnapshot)
    EggState.FieldShifted:Connect(applyRecord)
    EggState.FieldGone:Connect(function(p15) -- line: 263
        -- upvalues: t1 (copy), t2 (copy), t3 (copy), v2 (ref), syncUid (copy)
        local v48 = p15 == v2
        local v49, v50

        if v48 then
            syncUid(p15)
        else
            t1[p15] = nil
            t3[p15] = nil
            v49 = t2[p15]

            if v49 == nil then
                return
            end

            t2[p15] = nil

            local DestroyConnection = v49.DestroyConnection

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect()
            end

            v50 = v49.Highlight.Parent == nil
        end

        if not (not v48 and v50 or v48) then
            v49.Highlight:Destroy()
        end
    end)
    EggState.CarryChanged:Connect(applyCarryState)
    Workspace.ChildAdded:Connect(observeWorkspaceChild)
    Workspace:GetAttributeChangedSignal(CaptureTheEgg.EggUidAttribute):Connect(function() -- line: 274
        -- upvalues: t1 (copy), syncUid (copy)
        for v51 in pairs(t1) do
            syncUid(v51)
        end
    end)
    applySnapshot(EggState.ReadFieldEggs())
    v1:AtDebug():Log("Rare area egg highlight lifecycle started")
end

return table.freeze(t4)
