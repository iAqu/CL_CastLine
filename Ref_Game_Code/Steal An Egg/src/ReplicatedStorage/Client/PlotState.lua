-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Log = require(ReplicatedStorage.Packages.Log)
local Plots = require(ReplicatedStorage.Shared.Types.Plots)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Streamable = require(ReplicatedStorage.Packages.Streamable).Streamable
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.instanceIsA("Player"))
local v2 = t.strict(t.Vector3)
local v3 = t.strict(t.instanceIsA("BasePart"))
local v4 = t.strict(t.instanceIsA("Attachment"))
local v5 = t.strict(t.instanceIsA("BillboardGui"))
local v6 = t.strict(t.instanceIsA("Folder"))
local v7 = Log.new()
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local v8 = nil
local t5 = {
    LocalPlotChanged = Signal.new(),
    PlotChanged = Signal.new(),
    FolderChanged = Signal.new()
}
local Plots2 = Streamable.new(Workspace, "Plots")

local function localSlot() -- line: 58
    -- upvalues: LocalPlayer (copy), t1 (copy)
    for v9, v10 in t1 do
        if v10 == LocalPlayer.UserId then
            return v9
        end
    end

    return nil
end

local function announce(p1) -- line: 70
    -- upvalues: LocalPlayer (copy), t1 (copy), t5 (copy)
    t5.PlotChanged:Fire(p1, t1[p1])

    local v11

    for v12, v13 in t1 do
        if v13 == LocalPlayer.UserId then
            v11 = v12
            break
        end
    end

    if v11 == p1 then
        t5.LocalPlotChanged:Fire(p1)
    end
end

local function follow(p2, p3, p4, p5) -- line: 80
    -- upvalues: Streamable (copy)
    local v14 = Streamable.new(p2, p3)

    p4:Add(function() -- line: 82
        -- upvalues: v14 (copy)
        v14:Destroy()
    end)
    v14:Observe(p5)
end

local function watchSlot(p6, p7) -- line: 86
    -- upvalues: Streamable (copy), Trove (copy), v3 (copy), v4 (copy), v5 (copy), LocalPlayer (copy), t1 (copy), t3 (copy), t4 (copy), t5 (copy)
    if t4[p6] then
        return
    end

    local v15 = Trove.new()
    local v16 = Streamable.new(p7, (tostring(p6)))
    local t6 = {
        plot = v16,
        trove = v15
    }

    t4[p6] = t6
    v15:Add(function() -- line: 96
        -- upvalues: v16 (copy)
        v16:Destroy()
    end)
    v15:Add(function() -- line: 97
        -- upvalues: p6 (copy), t6 (copy), t4 (copy)
        if t4[p6] == t6 then
            t4[p6] = nil
        end
    end)

    local function ping() -- line: 103
        -- upvalues: p6 (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
        t5.PlotChanged:Fire(p6, t1[p6])

        local v17

        for v18, v19 in t1 do
            if v19 == LocalPlayer.UserId then
                v17 = v18
                break
            end
        end

        if v17 == p6 then
            t5.LocalPlotChanged:Fire(p6)
        end
    end

    v15:Add(v16:Observe(function(p8, p9) -- line: 105
        -- upvalues: p6 (copy), t6 (copy), ping (copy), Streamable (copy), v3 (copy), v4 (copy), v5 (copy), LocalPlayer (copy), t1 (copy), t3 (copy), t4 (copy), t5 (copy)
        if not (p8:IsA("Folder") or p8:IsA("Model")) then
            return
        end

        t5.PlotChanged:Fire(p6, t1[p6])

        local v20

        for v21, v22 in t1 do
            if v22 == LocalPlayer.UserId then
                v20 = v21
                break
            end
        end

        if v20 == p6 then
            t5.LocalPlotChanged:Fire(p6)
        end

        p9:Add(ping)

        local function v23(p10, p11) -- line: 113
            -- upvalues: p6 (copy), ping (copy), v3 (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
            v3(p10)
            t5.PlotChanged:Fire(p6, t1[p6])

            local v24

            for v25, v26 in t1 do
                if v26 == LocalPlayer.UserId then
                    v24 = v25
                    break
                end
            end

            if v24 == p6 then
                t5.LocalPlotChanged:Fire(p6)
            end

            p11:Add(ping)
        end

        local CenterPoint = Streamable.new(p8, "CenterPoint")

        p9:Add(function() -- line: 82
            -- upvalues: CenterPoint (copy)
            CenterPoint:Destroy()
        end)
        CenterPoint:Observe(v23)

        local function v27(p12, p13) -- line: 119
            -- upvalues: p6 (copy), t6 (copy), v3 (copy), LocalPlayer (copy), t1 (copy), t3 (copy), t4 (copy), t5 (copy)
            v3(p12)
            t3[p6] = p12.CFrame + Vector3.new(0, 0, 0)
            t5.PlotChanged:Fire(p6, t1[p6])

            local v28

            for v29, v30 in t1 do
                if v30 == LocalPlayer.UserId then
                    v28 = v29
                    break
                end
            end

            if v28 == p6 then
                t5.LocalPlotChanged:Fire(p6)
            end

            p13:Add(function() -- line: 125
                -- upvalues: p6 (copy), t6 (copy), LocalPlayer (copy), t1 (copy), t4 (copy), t5 (copy)
                if t4[p6] ~= t6 then
                    return
                end

                t5.PlotChanged:Fire(p6, t1[p6])

                local v31

                for v32, v33 in t1 do
                    if v33 == LocalPlayer.UserId then
                        v31 = v32
                        break
                    end
                end

                if v31 == p6 then
                    t5.LocalPlotChanged:Fire(p6)
                end
            end)
        end

        local SpawnPoint = Streamable.new(p8, "SpawnPoint")

        p9:Add(function() -- line: 82
            -- upvalues: SpawnPoint (copy)
            SpawnPoint:Destroy()
        end)
        SpawnPoint:Observe(v27)

        local function v34(p14, p15) -- line: 132
            -- upvalues: p6 (copy), ping (copy), Streamable (copy), v3 (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
            if not p14:IsA("Model") then
                return
            end

            t5.PlotChanged:Fire(p6, t1[p6])

            local v35

            for v36, v37 in t1 do
                if v37 == LocalPlayer.UserId then
                    v35 = v36
                    break
                end
            end

            if v35 == p6 then
                t5.LocalPlotChanged:Fire(p6)
            end

            p15:Add(ping)

            local function v38(p16, p17) -- line: 137
                -- upvalues: p6 (copy), ping (copy), v3 (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
                v3(p16)
                t5.PlotChanged:Fire(p6, t1[p6])

                local v39

                for v40, v41 in t1 do
                    if v41 == LocalPlayer.UserId then
                        v39 = v40
                        break
                    end
                end

                if v39 == p6 then
                    t5.LocalPlotChanged:Fire(p6)
                end

                p17:Add(ping)
            end

            local PetArea = Streamable.new(p14, "PetArea")

            p15:Add(function() -- line: 82
                -- upvalues: PetArea (copy)
                PetArea:Destroy()
            end)
            PetArea:Observe(v38)
        end

        local ToUpdate = Streamable.new(p8, "ToUpdate")

        p9:Add(function() -- line: 82
            -- upvalues: ToUpdate (copy)
            ToUpdate:Destroy()
        end)
        ToUpdate:Observe(v34)

        local function v42(p18, p19) -- line: 145
            -- upvalues: p6 (copy), ping (copy), Streamable (copy), v4 (copy), v5 (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
            t5.PlotChanged:Fire(p6, t1[p6])

            local v43

            for v44, v45 in t1 do
                if v45 == LocalPlayer.UserId then
                    v43 = v44
                    break
                end
            end

            if v43 == p6 then
                t5.LocalPlotChanged:Fire(p6)
            end

            p19:Add(ping)

            local function v46(p20, p21) -- line: 149
                -- upvalues: p6 (copy), ping (copy), Streamable (copy), v4 (copy), v5 (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
                v4(p20)
                t5.PlotChanged:Fire(p6, t1[p6])

                local v47

                for v48, v49 in t1 do
                    if v49 == LocalPlayer.UserId then
                        v47 = v48
                        break
                    end
                end

                if v47 == p6 then
                    t5.LocalPlotChanged:Fire(p6)
                end

                p21:Add(ping)

                local function v50(p22, p23) -- line: 154
                    -- upvalues: p6 (copy), ping (copy), v5 (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
                    v5(p22)
                    t5.PlotChanged:Fire(p6, t1[p6])

                    local v51

                    for v52, v53 in t1 do
                        if v53 == LocalPlayer.UserId then
                            v51 = v52
                            break
                        end
                    end

                    if v51 == p6 then
                        t5.LocalPlotChanged:Fire(p6)
                    end

                    p23:Add(ping)
                end

                local YourBase = Streamable.new(p20, "YourBase")

                p21:Add(function() -- line: 82
                    -- upvalues: YourBase (copy)
                    YourBase:Destroy()
                end)
                YourBase:Observe(v50)
            end

            local Attachment = Streamable.new(p18, "Attachment")

            p19:Add(function() -- line: 82
                -- upvalues: Attachment (copy)
                Attachment:Destroy()
            end)
            Attachment:Observe(v46)
        end

        local PlotSign = Streamable.new(p8, "PlotSign")

        p9:Add(function() -- line: 82
            -- upvalues: PlotSign (copy)
            PlotSign:Destroy()
        end)
        PlotSign:Observe(v42)

        local function v54(p24, p25) -- line: 162
            -- upvalues: p6 (copy), ping (copy), Streamable (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
            t5.PlotChanged:Fire(p6, t1[p6])

            local v55

            for v56, v57 in t1 do
                if v57 == LocalPlayer.UserId then
                    v55 = v56
                    break
                end
            end

            if v55 == p6 then
                t5.LocalPlotChanged:Fire(p6)
            end

            p25:Add(ping)

            local function v58(_, p27) -- line: 166
                -- upvalues: p6 (copy), ping (copy), LocalPlayer (copy), t1 (copy), t5 (copy)
                t5.PlotChanged:Fire(p6, t1[p6])

                local v59

                for v60, v61 in t1 do
                    if v61 == LocalPlayer.UserId then
                        v59 = v60
                        break
                    end
                end

                if v59 == p6 then
                    t5.LocalPlotChanged:Fire(p6)
                end

                p27:Add(ping)
            end

            local Sign = Streamable.new(p24, "Sign")

            p25:Add(function() -- line: 82
                -- upvalues: Sign (copy)
                Sign:Destroy()
            end)
            Sign:Observe(v58)
        end

        local BaseUpgrade = Streamable.new(p8, "BaseUpgrade")

        p9:Add(function() -- line: 82
            -- upvalues: BaseUpgrade (copy)
            BaseUpgrade:Destroy()
        end)
        BaseUpgrade:Observe(v54)
    end))
end

local function forgetSlot(p28) -- line: 174
    -- upvalues: t3 (copy), t4 (copy)
    local v62 = t4[p28]

    if v62 == nil then
        return
    end

    t3[p28] = nil
    t4[p28] = nil
    v62.trove:Destroy()
end

local function forgetEverySlot() -- line: 183
    -- upvalues: t3 (copy), t4 (copy)
    local t7 = {}

    for v63 in t4 do
        table.insert(t7, v63)
    end

    for _, v64 in t7 do
        local v65 = t4[v64]

        if v65 ~= nil then
            t3[v64] = nil
            t4[v64] = nil
            v65.trove:Destroy()
        end
    end
end

local function slotFor(p29) -- line: 194
    -- upvalues: v1 (copy), LocalPlayer (copy), t1 (copy)
    p29 = p29 or LocalPlayer
    v1(p29)

    local v67

    if p29 == LocalPlayer then
        for v68, v69 in t1 do
            if v69 == LocalPlayer.UserId then
                v67 = v68
                break
            end
        end
    end

    for v70, v71 in t1 do
        if v67 == nil and v71 == p29.UserId then
            v67 = v70
        end
    end

    return v67, p29
end

function t5.ReadOwners() -- line: 210
    -- upvalues: t1 (copy)
    return table.clone(t1)
end

function t5.LookupOwner(p30) -- line: 212
    -- upvalues: t1 (copy)
    return t1[p30]
end

function t5.ResolveLocalSlot() -- line: 214
    -- upvalues: LocalPlayer (copy), t1 (copy)
    for v72, v73 in t1 do
        if v73 == LocalPlayer.UserId then
            return v72
        end
    end

    return nil
end

function t5.ResolveFolder() -- line: 216
    -- upvalues: v8 (ref)
    return v8
end

function t5.ResolvePlot(p31) -- line: 220
    -- upvalues: t3 (copy), v8 (ref), slotFor (copy)
    local v74 = slotFor(p31)
    local v75 = v8
    local v76 = if v74 == nil or v75 == nil then nil else v75:FindFirstChild((tostring(v74)))
    local ToUpdate = if v76 == nil then nil else v76:FindFirstChild("ToUpdate")
    local PetArea = if ToUpdate == nil or not ToUpdate:IsA("Model") then nil else ToUpdate:FindFirstChild("PetArea")
    local CenterPoint = if v76 == nil then nil else v76:FindFirstChild("CenterPoint")
    local BasePart

    if PetArea ~= nil then
        BasePart = PetArea:IsA("BasePart")

        if BasePart then
            BasePart = CenterPoint ~= nil and CenterPoint:IsA("BasePart")
        end
    else
        BasePart = false
    end

    if not BasePart then
        return nil
    end

    local SpawnPoint = v76:FindFirstChild("SpawnPoint")

    t3[v74] = if SpawnPoint == nil or not SpawnPoint:IsA("BasePart") then t3[v74] else SpawnPoint.CFrame + Vector3.new(0, 0, 0)

    return {
        Slot = v74,
        PlotFolder = v76,
        PetArea = PetArea,
        CenterPoint = CenterPoint,
        RespawnPointCFrame = t3[v74]
    }
end

function t5.FindLocalBaseSign() -- line: 247
    -- upvalues: t5 (copy)
    local v78 = t5.ResolvePlot()
    local PlotSign = if v78 then v78.PlotFolder:FindFirstChild("PlotSign") else nil
    local Attachment = if PlotSign then PlotSign:FindFirstChild("Attachment") else nil
    local YourBase = if Attachment == nil or not Attachment:IsA("Attachment") then nil else Attachment:FindFirstChild("YourBase")

    return if YourBase ~= nil and YourBase:IsA("BillboardGui") then YourBase else nil
end

function t5.FindRespawnCFrame(p32) -- line: 257
    -- upvalues: t3 (copy), slotFor (copy)
    local v79 = slotFor(p32)

    return if v79 ~= nil then t3[v79] else nil
end

function t5.ContainsLocalPoint(p33) -- line: 262
    -- upvalues: v2 (copy), t5 (copy)
    v2(p33)

    local v80 = t5.ResolvePlot()

    if not v80 then
        return false
    end

    local BoundingBox, BoundingBox2 = v80.PlotFolder:GetBoundingBox()
    local v81 = BoundingBox:PointToObjectSpace(p33)
    local v82 = BoundingBox2 * 0.5

    if not (math.abs(v81.X) <= v82.X) then
        return false
    end

    return math.abs(v81.Z) <= v82.Z
end

local function adoptOwner(p34, p35) -- line: 276
    -- upvalues: LocalPlayer (copy), t1 (copy), t5 (copy)
    local v83

    for v84, v85 in t1 do
        if v85 == LocalPlayer.UserId then
            v83 = v84
            break
        end
    end

    t1[p34] = p35
    t5.PlotChanged:Fire(p34, p35)

    if p35 == LocalPlayer.UserId or v83 == p34 then
        t5.LocalPlotChanged:Fire(p34)
    end
end

local function acceptUpdate(p36) -- line: 286
    -- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), t5 (copy)
    local v86 = t2[p36.Slot]

    if v86 ~= nil and not (v86 < p36.Revision) then
        return
    end

    t2[p36.Slot] = p36.Revision

    local Slot, UserId = p36.Slot, p36.UserId
    local v87

    for v88, v89 in t1 do
        if v89 == LocalPlayer.UserId then
            v87 = v88
            break
        end
    end

    t1[Slot] = UserId
    t5.PlotChanged:Fire(Slot, UserId)

    if UserId == LocalPlayer.UserId or v87 == Slot then
        t5.LocalPlotChanged:Fire(Slot)
    end
end

local function acceptSnapshot(p37) -- line: 294
    -- upvalues: LocalPlayer (copy), t1 (copy), t2 (copy), t5 (copy)
    local t8 = {}

    for v90, v91 in p37.OwnersBySlot do
        local v94 = assert(tonumber(v90), (("plot snapshot carried a non-numeric slot: %*"):format(v90)))

        t8[v94] = true

        local v95 = t2[v94]

        if v95 == nil or v95 < p37.Revision then
            t2[v94] = p37.Revision

            local v96

            for v97, v98 in t1 do
                if v98 == LocalPlayer.UserId then
                    v96 = v97
                    break
                end
            end

            t1[v94] = v91
            t5.PlotChanged:Fire(v94, v91)

            if v91 == LocalPlayer.UserId or v96 == v94 then
                t5.LocalPlotChanged:Fire(v94)
            end
        end
    end

    local t9 = {}

    for v99 in t2 do
        table.insert(t9, v99)
    end

    for _, v100 in t9 do
        local v101 = t8[v100] ~= true and t2[v100] < p37.Revision
        local v102 = v101 and t1[v100] ~= nil

        t2[v100] = if v101 then p37.Revision else t2[v100]

        if v102 then
            local v104

            for v105, v106 in t1 do
                if v106 == LocalPlayer.UserId then
                    v104 = v105
                    break
                end
            end

            t1[v100] = nil
            t5.PlotChanged:Fire(v100, nil)

            if LocalPlayer.UserId == nil or v104 == v100 then
                t5.LocalPlotChanged:Fire(v100)
            end
        end
    end
end

local function askState() -- line: 322
    -- upvalues: Remotes (copy)
    return Remotes.Homestead.AskState:InvokeServer()
end

local function pullSnapshot() -- line: 324
    -- upvalues: Plots (copy), acceptSnapshot (copy), askState (copy)
    local ok, result = pcall(askState)

    if not ok then
        return false, (tostring(result))
    end

    local v107, v108 = Plots.SchemaValidation.PlotStateSnapshot(result)

    if not v107 then
        return false, (("plot snapshot failed validation: %*"):format(v108))
    end

    acceptSnapshot(result)

    return true
end

local function pullUntilAnswered() -- line: 339
    -- upvalues: Plots (copy), v7 (copy), acceptSnapshot (copy), askState (copy), pullUntilAnswered (copy)
    local ok, result = pcall(askState)
    local v109, v110

    if ok then
        local v111, v112 = Plots.SchemaValidation.PlotStateSnapshot(result)

        if v111 then
            v109 = true
            acceptSnapshot(result)
        else
            v109 = false
            v110 = ("plot snapshot failed validation: %*"):format(v112)
        end
    else
        v109 = false
        v110 = tostring(result)
    end

    if not v109 then
        v7:AtError():Log((("plot snapshot request did not land, retrying: %*"):format(v110)))
        task.delay(5, pullUntilAnswered)
    end
end

Remotes.Homestead.StateShifted.OnClientEvent:Connect(function(p38) -- line: 347
    -- upvalues: Plots (copy), v7 (copy), LocalPlayer (copy), t1 (copy), t2 (copy), t5 (copy)
    local v113, v114 = Plots.SchemaValidation.PlotStateUpdate(p38)

    if not v113 then
        v7:AtError():Log((("plot state update failed validation: %*"):format(v114)))

        return
    end

    local v115 = t2[p38.Slot]

    if v115 == nil or v115 < p38.Revision then
        t2[p38.Slot] = p38.Revision

        local Slot, UserId = p38.Slot, p38.UserId
        local v116

        for v117, v118 in t1 do
            if v118 == LocalPlayer.UserId then
                v116 = v117
                break
            end
        end

        t1[Slot] = UserId
        t5.PlotChanged:Fire(Slot, UserId)

        if UserId == LocalPlayer.UserId or v116 == Slot then
            t5.LocalPlotChanged:Fire(Slot)
        end
    end
end)
Plots2:Observe(function(p39, p40) -- line: 356
    -- upvalues: v6 (copy), t3 (copy), t4 (copy), v8 (ref), t5 (copy), watchSlot (copy), forgetEverySlot (copy)
    v6(p39)
    v8 = p39
    t5.FolderChanged:Fire(p39)
    p40:Add(function() -- line: 361
        -- upvalues: p39 (copy), v8 (ref), t5 (copy), forgetEverySlot (copy)
        if v8 == p39 then
            v8 = nil
        end

        forgetEverySlot()
        t5.FolderChanged:Fire(nil)
    end)

    local function watchIfNumbered(p41) -- line: 370
        -- upvalues: p39 (copy), watchSlot (copy)
        local v119 = tonumber(p41.Name)

        if v119 ~= nil then
            watchSlot(v119, p39)
        end
    end

    for _, child in p39:GetChildren() do
        local v120 = tonumber(child.Name)

        if v120 ~= nil then
            watchSlot(v120, p39)
        end
    end

    p40:Connect(p39.ChildAdded, function(p42) -- line: 381
        -- upvalues: p39 (copy), t5 (copy), watchSlot (copy)
        local v121 = tonumber(p42.Name)

        if v121 ~= nil then
            watchSlot(v121, p39)
        end

        t5.FolderChanged:Fire(p39)
    end)
    p40:Connect(p39.ChildRemoved, function(p43) -- line: 386
        -- upvalues: p39 (copy), t3 (copy), t4 (copy), t5 (copy)
        local v122 = tonumber(p43.Name)

        if v122 ~= nil then
            local v123 = t4[v122]

            if v123 ~= nil then
                t3[v122] = nil
                t4[v122] = nil
                v123.trove:Destroy()
            end
        end

        t5.FolderChanged:Fire(p39)
    end)
end)
task.spawn(pullUntilAnswered)

local function onNearbyPurchase(p44) -- line: 401
    -- upvalues: Storefront (copy)
    Storefront.Prompt(p44, true)
end

Remotes.Homestead.AskNearbyPurchase.OnClientEvent:Connect(onNearbyPurchase)

return t5
