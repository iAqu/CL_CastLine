-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.array(t.integer), function(p1) -- line: 17
    local t1 = {}

    for _, v2 in ipairs(p1) do
        if t1[v2] then
            return false
        end

        t1[v2] = true
    end

    return true
end)
local Transition = require(ReplicatedStorage.Client.BaseUpgrade).Transition

require(ReplicatedStorage.Shared.Globals.Constants)

local EmitAt = require(ReplicatedStorage.Shared.Utils.VFX).EmitAt
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local Log = require(ReplicatedStorage.Packages.Log)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local PlotUpgradeVisibility = require(ReplicatedStorage.Client.PlotUpgradeVisibility)
local WarmAssets = require(ReplicatedStorage.Shared.Utils.Preload).WarmAssets
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local TreadmillStaticCover = require(ReplicatedStorage.Client.UI.TreadmillStaticCover)
local TreadmillVideoGate = require(ReplicatedStorage.Client.TreadmillVideoGate)
local Render = require(script.Render)

require(script.Types.Interface)

local TreadmillVideoController = require(ReplicatedStorage.Shared.TreadmillVideoController)
local Treadmills = require(ReplicatedStorage.Data.Treadmills)
local LocalPlayer = Players.LocalPlayer
local v3 = Log.new()

local function releaseActiveTreadmill(p2) -- line: 70
    -- upvalues: CollectionService (copy)
    for _, v4 in CollectionService:GetTagged("ActiveTreadmill") do
        if p2 == nil or v4:GetAttribute("ActiveTreadmillId") == p2 then
            CollectionService:RemoveTag(v4, "ActiveTreadmill")
            v4:SetAttribute("ActiveTreadmillId", nil)
        end
    end
end

local function bindActiveTreadmill(p3, p4) -- line: 82
    -- upvalues: CollectionService (copy), releaseActiveTreadmill (copy)
    releaseActiveTreadmill(p3)
    CollectionService:RemoveTag(p4, "ActiveTreadmill")
    p4:SetAttribute("ActiveTreadmillId", p3)
    CollectionService:AddTag(p4, "ActiveTreadmill")
end

return {
    Start = function() -- Start | line: 93
        -- upvalues: CollectionService (copy), Players (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), t (copy), v1 (copy), Transition (copy), EmitAt (copy), TryLock (copy), Toast (copy), PlotState (copy), PlotUpgradeVisibility (copy), WarmAssets (copy), Remotes (copy), Save (copy), TreadmillStaticCover (copy), TreadmillVideoGate (copy), Render (copy), TreadmillVideoController (copy), Treadmills (copy), LocalPlayer (copy), v3 (copy), releaseActiveTreadmill (copy)
        local TreadmillUpgrade = ReplicatedStorage.Assets.Particles.TreadmillUpgrade
        local Folder = Instance.new("Folder")

        Folder.Name = "__ClientTreadmillRenders"
        Folder.Parent = Workspace
        task.spawn(WarmAssets, TreadmillUpgrade)

        local v5
        local v6 = false
        local t3 = {}
        local v7 = false
        local v8 = TryLock()
        local v9 = false
        local n1 = 0
        local v10 = true
        local n2 = 0
        local n3 = 0
        local v11 = false
        local v12 = false
        local v13 = false
        local t4 = {}
        local t5 = {}
        local t6 = {}

        local function destroyRender(p5) -- line: 123
            -- upvalues: t5 (copy), CollectionService (copy), LocalPlayer (copy)
            local v14 = t5[p5]

            if v14 == nil then
                return
            end

            t5[p5] = nil

            if v14.OwnerUserId == LocalPlayer.UserId then
                CollectionService:RemoveTag(v14.Model, "ActiveTreadmill")
            end

            if v14.Cover ~= nil then
                v14.Cover:Destroy()
            end

            v14.Model:Destroy()
        end

        local function resolveLocalRender() -- line: 138
            -- upvalues: t5 (copy), PlotState (copy)
            local v15 = PlotState.ResolveLocalSlot()

            return if v15 ~= nil then t5[v15] else nil
        end

        local function animateScale(p6, p7, p8, p9, p10) -- line: 143
            -- upvalues: RunService (copy), TweenService (copy), Render (copy)
            local n4 = 0

            while n4 < p9 do
                local v16 = RunService.PreRender:Wait()

                if p6.Model.Parent == nil then
                    break
                end

                n4 = math.min(n4 + v16, p9)

                local Value = TweenService:GetValue(n4 / p9, p10, Enum.EasingDirection.Out)

                Render.SetGroundedScale(p6, p7 + (p8 - p7) * Value)
            end

            if p6.Model.Parent ~= nil then
                Render.SetGroundedScale(p6, p8)
            end
        end

        local function runLocalUpgradeAnimation(p11, p12) -- line: 169
            -- upvalues: TreadmillUpgrade (copy), animateScale (copy), TweenService (copy), Audio (copy), EmitAt (copy), Toast (copy)
            local Root = p11.Model.Root

            assert(Root:IsA("BasePart"), (("Treadmill \"%*\" Root must be a BasePart"):format(p11.TreadmillId)))

            local Highlight = Instance.new("Highlight")

            Highlight.Adornee = p11.Model
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = Color3.new(1, 1, 1)
            Highlight.FillTransparency = 1
            Highlight.OutlineColor = Color3.new(1, 1, 1)
            Highlight.OutlineTransparency = 1
            Highlight.Parent = p11.Model

            local tween = TweenService:Create(Highlight, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                FillTransparency = 0.15,
                OutlineTransparency = 0
            })
            local tween2 = TweenService:Create(Highlight, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                FillTransparency = 1,
                OutlineTransparency = 1
            })

            tween.Completed:Once(function() -- line: 201
                -- upvalues: tween2 (copy)
                tween2:Play()
            end)
            tween2.Completed:Once(function() -- line: 204
                -- upvalues: Highlight (copy)
                Highlight:Destroy()
            end)
            tween:Play()
            EmitAt(Root, TreadmillUpgrade:Clone():GetChildren())
            Audio.Play(130233661094961, script, {
                Volume = 1.5,
                PlaybackSpeed = { 0.9, 1.1 }
            })
            Toast.Show({
                Text = "Successfully upgraded your treadmill!",
                Seconds = 0.7,
                Color = Color3.fromRGB(0, 255, 47)
            })
            animateScale(p11, p12 * 0.8, p12, 0.55, Enum.EasingStyle.Elastic)
        end

        local function replaceRender(p13, p14, p15, p16) -- line: 226
            -- upvalues: Folder (copy), v5 (ref), v6 (ref), t5 (copy), t6 (copy), animateScale (copy), runLocalUpgradeAnimation (copy), CollectionService (copy), TreadmillStaticCover (copy), Render (copy), LocalPlayer (copy), releaseActiveTreadmill (copy)
            local v19 = (t6[p13] or 0) + 1

            t6[p13] = v19

            local v20 = t5[p13]

            if p16 and v20 ~= nil then
                local Scale = v20.Model:GetScale()

                animateScale(v20, Scale, Scale * 0.8, 0.22, Enum.EasingStyle.Quad)

                if t6[p13] ~= v19 then
                    return
                end
            end

            local v21 = t5[p13]

            if v21 ~= nil then
                t5[p13] = nil

                if v21.OwnerUserId == LocalPlayer.UserId then
                    CollectionService:RemoveTag(v21.Model, "ActiveTreadmill")
                end

                if v21.Cover ~= nil then
                    v21.Cover:Destroy()
                end

                v21.Model:Destroy()
            end

            local v22 = Render.Build(p13, p14, p15, if p16 then 0.8 else 1, p14 == LocalPlayer.UserId, Folder)

            t5[p13] = v22

            if p14 == LocalPlayer.UserId then
                v22.RateSign.Enabled = v5 == nil

                local Cover = v22.Cover

                if Cover ~= nil then
                    TreadmillStaticCover.SetEnabled(Cover, v5 == nil)
                end

                if v5 ~= nil and not v6 then
                    local TreadmillId, Model = v22.TreadmillId, v22.Model

                    releaseActiveTreadmill(TreadmillId)
                    CollectionService:RemoveTag(Model, "ActiveTreadmill")
                    Model:SetAttribute("ActiveTreadmillId", TreadmillId)
                    CollectionService:AddTag(Model, "ActiveTreadmill")
                end
            end

            if p16 then
                runLocalUpgradeAnimation(v22, v22.Model:GetScale() / 0.8)
            end
        end

        local function refreshSlot(p17, p18, p19) -- line: 273
            -- upvalues: t3 (copy), n1 (ref), v13 (ref), t5 (copy), t6 (copy), replaceRender (copy), CollectionService (copy), Players (copy), Transition (copy), PlotState (copy), Save (copy), LocalPlayer (copy)
            if p18 ~= nil then
                if p18 == LocalPlayer.UserId or t3[p18] == true then
                    local PlayerByUserId = Players:GetPlayerByUserId(p18)

                    if PlayerByUserId ~= nil then
                        local v24 = Save.Await(PlayerByUserId)

                        if v24 ~= nil and PlotState.LookupOwner(p17) == p18 then
                            if v24.BaseUpgradeLevel == 0 then
                                local v25 = t5[p17]

                                if v25 ~= nil then
                                    t5[p17] = nil

                                    if v25.OwnerUserId == LocalPlayer.UserId then
                                        CollectionService:RemoveTag(v25.Model, "ActiveTreadmill")
                                    end

                                    if v25.Cover ~= nil then
                                        v25.Cover:Destroy()
                                    end

                                    v25.Model:Destroy()
                                end
                            elseif p18 == LocalPlayer.UserId and (v13 or n1 == 0 and Transition.IsPlaying()) then
                                v13 = true

                                local v26 = t5[p17]

                                if v26 ~= nil then
                                    t5[p17] = nil

                                    if v26.OwnerUserId == LocalPlayer.UserId then
                                        CollectionService:RemoveTag(v26.Model, "ActiveTreadmill")
                                    end

                                    if v26.Cover ~= nil then
                                        v26.Cover:Destroy()
                                    end

                                    v26.Model:Destroy()
                                end
                            else
                                replaceRender(p17, p18, v24, p19)
                            end
                        end
                    end
                else
                    t6[p17] = (t6[p17] or 0) + 1

                    local v27 = t5[p17]

                    if v27 ~= nil then
                        t5[p17] = nil

                        if v27.OwnerUserId == LocalPlayer.UserId then
                            CollectionService:RemoveTag(v27.Model, "ActiveTreadmill")
                        end

                        if v27.Cover ~= nil then
                            v27.Cover:Destroy()
                        end

                        v27.Model:Destroy()
                    end
                end
            else
                t6[p17] = (t6[p17] or 0) + 1

                local v23 = t5[p17]

                if v23 ~= nil then
                    t5[p17] = nil

                    if v23.OwnerUserId == LocalPlayer.UserId then
                        CollectionService:RemoveTag(v23.Model, "ActiveTreadmill")
                    end

                    if v23.Cover ~= nil then
                        v23.Cover:Destroy()
                    end

                    v23.Model:Destroy()
                end
            end
        end

        local function refreshPlayerRender(p20, p21) -- line: 310
            -- upvalues: refreshSlot (copy), PlotState (copy)
            for v28, v29 in pairs(PlotState.ReadOwners()) do
                if v29 == p20.UserId then
                    refreshSlot(v28, v29, p21)

                    return
                end
            end
        end

        local function applyRemoteSessionTransition(p22, p23, p24) -- line: 319
            -- upvalues: t3 (copy), n2 (ref), refreshPlayerRender (copy), LocalPlayer (copy)
            if not (p24 <= n2) then
                n2 = p24

                if p22 ~= LocalPlayer then
                    if p23 then
                        t3[p22.UserId] = true
                    else
                        t3[p22.UserId] = nil
                    end

                    refreshPlayerRender(p22, false)
                end
            end
        end

        local function synchronizeRemoteSessionSnapshot() -- line: 335
            -- upvalues: t3 (copy), v10 (ref), n2 (ref), t4 (copy), refreshPlayerRender (copy), t (copy), v1 (copy), Remotes (copy), LocalPlayer (copy)
            local v30, v31 = Remotes.Treadmill.AskRenderSnapshot:InvokeServer()

            t.strict(v1)(v30)
            t.strict(t.number)(v31)
            table.clear(t3)

            for _, v32 in ipairs(v30) do
                if v32 ~= LocalPlayer.UserId then
                    t3[v32] = true
                end
            end

            n2 = v31
            table.sort(t4, function(p25, p26) -- line: 346
                return p25.Revision < p26.Revision
            end)
            v10 = false

            for _, v33 in ipairs(t4) do
                local Player, Active, Revision = v33.Player, v33.Active, v33.Revision

                if not (Revision <= n2) then
                    n2 = Revision

                    if Player ~= LocalPlayer then
                        if Active then
                            t3[Player.UserId] = true
                        else
                            t3[Player.UserId] = nil
                        end

                        refreshPlayerRender(Player, false)
                    end
                end
            end

            table.clear(t4)
        end

        local function refreshLocalRender(p27) -- line: 356
            -- upvalues: v9 (ref), refreshPlayerRender (copy), LocalPlayer (copy)
            v9 = true
            refreshPlayerRender(LocalPlayer, p27)
            v9 = false
        end

        local function consumePendingUpgradeRefresh() -- line: 362
            -- upvalues: v5 (ref), v7 (ref), v9 (ref), n3 (ref), v11 (ref), v12 (ref), refreshPlayerRender (copy), Workspace (copy), LocalPlayer (copy)
            if not v7 or not v11 or v5 ~= nil then
                return
            end

            local v34 = v12

            v7 = false
            v11 = false
            v12 = false
            v9 = true
            refreshPlayerRender(LocalPlayer, v34)
            v9 = false
            n3 = Workspace:GetServerTimeNow() + 1.25
        end

        local function onTreadmillOverrideChanged(p28) -- line: 374
            -- upvalues: v5 (ref), v7 (ref), v9 (ref), n3 (ref), v11 (ref), v12 (ref), refreshPlayerRender (copy), Workspace (copy), LocalPlayer (copy)
            if p28 ~= LocalPlayer then
                refreshPlayerRender(p28, false)

                return
            end

            if v5 ~= nil or v7 then
                v11 = true

                if v7 and v11 then
                    if v5 ~= nil then
                        return
                    end

                    local v35 = v12

                    v7 = false
                    v11 = false
                    v12 = false
                    v9 = true
                    refreshPlayerRender(LocalPlayer, v35)
                    v9 = false
                    n3 = Workspace:GetServerTimeNow() + 1.25
                end
            else
                v9 = true
                refreshPlayerRender(LocalPlayer, false)
                v9 = false
            end
        end

        local function watchTreadmillOverride(p29) -- line: 389
            -- upvalues: v5 (ref), v7 (ref), v9 (ref), n3 (ref), v11 (ref), v12 (ref), refreshPlayerRender (copy), Workspace (copy), Treadmills (copy), LocalPlayer (copy)
            p29:GetAttributeChangedSignal(Treadmills.OverrideAttribute):Connect(function() -- line: 390
                -- upvalues: p29 (copy), v5 (ref), v7 (ref), v9 (ref), n3 (ref), v11 (ref), v12 (ref), refreshPlayerRender (copy), Workspace (copy), LocalPlayer (copy)
                if p29 ~= LocalPlayer then
                    refreshPlayerRender(p29, false)

                    return
                end

                if v5 ~= nil or v7 then
                    v11 = true

                    if v7 and v11 and v5 == nil then
                        local v36 = v12

                        v7 = false
                        v11 = false
                        v12 = false
                        v9 = true
                        refreshPlayerRender(LocalPlayer, v36)
                        v9 = false
                        n3 = Workspace:GetServerTimeNow() + 1.25
                    end
                else
                    v9 = true
                    refreshPlayerRender(LocalPlayer, false)
                    v9 = false
                end
            end)
        end

        local function refreshPlotUpgradeVisibility() -- line: 395
            -- upvalues: n1 (ref), PlotUpgradeVisibility (copy)
            PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)
        end

        local function revealFirstExpansionTreadmill() -- line: 399
            -- upvalues: v9 (ref), n1 (ref), n3 (ref), v13 (ref), refreshPlayerRender (copy), Workspace (copy), PlotUpgradeVisibility (copy), Save (copy), LocalPlayer (copy)
            local v37 = Save.Await()

            assert(v37 ~= nil, "First expansion treadmill reveal requires local save data")

            if v37.BaseUpgradeLevel == 0 then
                return
            end

            n1 = v37.BaseUpgradeLevel
            v13 = false
            PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)
            v9 = true
            refreshPlayerRender(LocalPlayer, true)
            v9 = false
            n3 = Workspace:GetServerTimeNow() + 1.25
        end

        local function tryEnterStaticTreadmill() -- line: 413
            -- upvalues: v5 (ref), v7 (ref), v8 (copy), v9 (ref), n3 (ref), t5 (copy), CollectionService (copy), Workspace (copy), PlotState (copy), Remotes (copy), LocalPlayer (copy), v3 (copy), releaseActiveTreadmill (copy)
            local v39 = PlotState.ResolveLocalSlot()
            local v40 = if v39 == nil then nil else t5[v39]

            if v5 == nil and not v7 and not v9 and v40 ~= nil then
                local ServerTimeNow = Workspace:GetServerTimeNow()

                if ServerTimeNow < n3 then
                    return
                end

                local Character = LocalPlayer.Character
                local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                    local v41 = RaycastParams.new()

                    v41.FilterType = Enum.RaycastFilterType.Include
                    v41.FilterDescendantsInstances = { v40.Bottom }

                    if Workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -8, 0), v41) ~= nil then
                        n3 = ServerTimeNow + 1.25
                        v8(function() -- line: 442
                            -- upvalues: v40 (copy), CollectionService (copy), Remotes (copy), v3 (copy), releaseActiveTreadmill (copy)
                            local TreadmillId, Model = v40.TreadmillId, v40.Model

                            releaseActiveTreadmill(TreadmillId)
                            CollectionService:RemoveTag(Model, "ActiveTreadmill")
                            Model:SetAttribute("ActiveTreadmillId", TreadmillId)
                            CollectionService:AddTag(Model, "ActiveTreadmill")

                            local v42, v43 = Remotes.Treadmill.AskWearStill:InvokeServer()

                            if v42 ~= true then
                                releaseActiveTreadmill(v40.TreadmillId)
                                v3:AtWarning():Log((("Static treadmill entry rejected: %*"):format(v43)))
                            end
                        end)
                    end
                end
            end
        end

        Save.Await()

        local v44 = Save.Await()

        assert(v44 ~= nil, "Static treadmill controller requires local save data")

        local TreadmillUpgradeLevel = v44.TreadmillUpgradeLevel

        n1 = v44.BaseUpgradeLevel
        Remotes.Treadmill.RenderStateShifted.OnClientEvent:Connect(function(p30, p31, p32) -- line: 462
            -- upvalues: t3 (copy), v10 (ref), n2 (ref), t4 (copy), refreshPlayerRender (copy), t (copy), LocalPlayer (copy)
            t.strict(t.instanceIsA("Player"))(p30)
            t.strict(t.boolean)(p31)
            t.strict(t.number)(p32)

            if v10 then
                table.insert(t4, {
                    Active = p31,
                    Player = p30,
                    Revision = p32
                })
            elseif not (p32 <= n2) then
                n2 = p32

                if p30 ~= LocalPlayer then
                    if p31 then
                        t3[p30.UserId] = true
                    else
                        t3[p30.UserId] = nil
                    end

                    refreshPlayerRender(p30, false)
                end
            end
        end)
        synchronizeRemoteSessionSnapshot()

        for v46, v47 in pairs(PlotState.ReadOwners()) do
            task.spawn(refreshSlot, v46, v47, false)
        end

        PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)
        PlotState.PlotChanged:Connect(function(p33, p34) -- line: 483
            -- upvalues: n1 (ref), refreshSlot (copy), PlotUpgradeVisibility (copy)
            PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)
            task.spawn(refreshSlot, p33, p34, false)
        end)
        TreadmillVideoGate.Changed:Connect(function() -- line: 488
            -- upvalues: v5 (ref), refreshSlot (copy), PlotState (copy), LocalPlayer (copy)
            for v48, v49 in pairs(PlotState.ReadOwners()) do
                if v49 ~= LocalPlayer.UserId or v5 == nil then
                    task.spawn(refreshSlot, v48, v49, false)
                end
            end
        end)
        PlotState.FolderChanged:Connect(function() -- line: 496
            -- upvalues: n1 (ref), refreshSlot (copy), PlotState (copy), PlotUpgradeVisibility (copy)
            PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)

            for v50, v51 in pairs(PlotState.ReadOwners()) do
                task.spawn(refreshSlot, v50, v51, false)
            end
        end)
        Players.PlayerAdded:Connect(function(p35) -- line: 502
            -- upvalues: refreshPlayerRender (copy)
            task.spawn(refreshPlayerRender, p35, false)
        end)
        Players.PlayerAdded:Connect(watchTreadmillOverride)

        for _, player in Players:GetPlayers() do
            player:GetAttributeChangedSignal(Treadmills.OverrideAttribute):Connect(function() -- line: 390
                -- upvalues: v5 (ref), v7 (ref), v9 (ref), n3 (ref), v11 (ref), v12 (ref), refreshPlayerRender (copy), player (copy), Workspace (copy), LocalPlayer (copy)
                if player ~= LocalPlayer then
                    refreshPlayerRender(player, false)

                    return
                end

                if v5 ~= nil or v7 then
                    v11 = true

                    if v7 and v11 and v5 == nil then
                        local v52 = v12

                        v7 = false
                        v11 = false
                        v12 = false
                        v9 = true
                        refreshPlayerRender(LocalPlayer, v52)
                        v9 = false
                        n3 = Workspace:GetServerTimeNow() + 1.25
                    end
                else
                    v9 = true
                    refreshPlayerRender(LocalPlayer, false)
                    v9 = false
                end
            end)
        end

        Players.PlayerRemoving:Connect(function(p36) -- line: 509
            -- upvalues: t3 (copy), t5 (copy), t6 (copy), CollectionService (copy), LocalPlayer (copy)
            t3[p36.UserId] = nil

            for v53, v54 in pairs(t5) do
                if v54 and v54.OwnerUserId == p36.UserId then
                    t6[v53] = (t6[v53] or 0) + 1

                    local v55 = t5[v53]

                    if v55 ~= nil then
                        t5[v53] = nil

                        if v55.OwnerUserId == LocalPlayer.UserId then
                            CollectionService:RemoveTag(v55.Model, "ActiveTreadmill")
                        end

                        if v55.Cover ~= nil then
                            v55.Cover:Destroy()
                        end

                        v55.Model:Destroy()
                    end
                end
            end
        end)
        Save.PeerLoaded:Connect(function(p37) -- line: 518
            -- upvalues: refreshPlayerRender (copy)
            refreshPlayerRender(p37, false)
        end)
        Save.PeerChanged:Connect(function(p38, p39) -- line: 521
            -- upvalues: t5 (copy), refreshPlayerRender (copy), Save (copy), TreadmillStaticCover (copy)
            if p39 == "TreadmillUpgradeLevel" then
                refreshPlayerRender(p38, false)
            elseif p39 == "TreadmillMediaFeedState" then
                local v56 = Save.Peek(p38)

                if v56 ~= nil then
                    for _, v57 in pairs(t5) do
                        if v57 and v57.OwnerUserId == p38.UserId and v57.Cover ~= nil then
                            TreadmillStaticCover.ApplyFeed(v57.Cover, v56.TreadmillMediaFeedState)
                        end
                    end
                end
            end
        end)
        Remotes.Treadmill.ViewStateShifted.OnClientEvent:Connect(function(p40, p41) -- line: 538
            -- upvalues: t5 (copy), t (copy), TreadmillStaticCover (copy), TreadmillVideoController (copy), LocalPlayer (copy)
            t.strict(t.instanceIsA("Player"))(p40)
            t.strict(t.string)(p41)

            if p40 ~= LocalPlayer then
                local v58 = TreadmillVideoController.GetMediaEntryByKey(p41)

                if v58 ~= nil then
                    for _, v59 in pairs(t5) do
                        if v59 and v59.OwnerUserId == p40.UserId and v59.Cover ~= nil then
                            TreadmillStaticCover.ApplyMedia(v59.Cover, v58)
                        end
                    end
                end
            end
        end)
        Save.Watch("TreadmillUpgradeLevel"):Connect(function() -- line: 557
            -- upvalues: v5 (ref), v7 (ref), v9 (ref), n1 (ref), n3 (ref), v11 (ref), v12 (ref), refreshPlayerRender (copy), TreadmillUpgradeLevel (ref), Workspace (copy), PlotUpgradeVisibility (copy), Save (copy), LocalPlayer (copy)
            local v60 = Save.Await()

            assert(v60 ~= nil, "Local treadmill upgrade requires save data")

            local v62 = v60.TreadmillUpgradeLevel > TreadmillUpgradeLevel

            TreadmillUpgradeLevel = v60.TreadmillUpgradeLevel
            PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)

            if v5 ~= nil or v7 then
                v11 = true
                v12 = v12 or v62

                if v7 and v11 then
                    if v5 ~= nil then
                        return
                    end

                    local v63 = v12

                    v7 = false
                    v11 = false
                    v12 = false
                    v9 = true
                    refreshPlayerRender(LocalPlayer, v63)
                    v9 = false
                    n3 = Workspace:GetServerTimeNow() + 1.25
                end
            else
                v9 = true
                refreshPlayerRender(LocalPlayer, v62)
                v9 = false
            end
        end)
        Save.Watch("BaseUpgradeLevel"):Connect(function() -- line: 571
            -- upvalues: v9 (ref), n1 (ref), n3 (ref), v13 (ref), refreshPlayerRender (copy), Workspace (copy), Transition (copy), PlotUpgradeVisibility (copy), Save (copy), LocalPlayer (copy)
            local v64 = Save.Await()

            assert(v64 ~= nil, "Local base upgrade requires save data")

            local v66 = n1 == 0 and v64.BaseUpgradeLevel > 0

            n1 = v64.BaseUpgradeLevel

            if not v66 then
                PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)

                return
            end

            if Transition.IsPlaying() then
                n1 = 0
                v13 = true
                PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)
            else
                local v67 = Save.Await()

                assert(v67 ~= nil, "First expansion treadmill reveal requires local save data")

                if v67.BaseUpgradeLevel ~= 0 then
                    n1 = v67.BaseUpgradeLevel
                    v13 = false
                    PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)
                    v9 = true
                    refreshPlayerRender(LocalPlayer, true)
                    v9 = false
                    n3 = Workspace:GetServerTimeNow() + 1.25
                end
            end
        end)
        Transition.Completed:Connect(function() -- line: 590
            -- upvalues: v9 (ref), n1 (ref), n3 (ref), v13 (ref), refreshPlayerRender (copy), Workspace (copy), PlotUpgradeVisibility (copy), Save (copy), LocalPlayer (copy)
            if not v13 then
                return
            end

            local v69 = Save.Await()

            assert(v69 ~= nil, "First expansion treadmill reveal requires local save data")

            if v69.BaseUpgradeLevel == 0 then
                return
            end

            n1 = v69.BaseUpgradeLevel
            v13 = false
            PlotUpgradeVisibility.Apply("TreadmillUpgrade", n1 > 0)
            v9 = true
            refreshPlayerRender(LocalPlayer, true)
            v9 = false
            n3 = Workspace:GetServerTimeNow() + 1.25
        end)
        Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p42, _, _, _, p46, p47) -- line: 596
            -- upvalues: v5 (ref), v6 (ref), v7 (ref), v9 (ref), n3 (ref), v11 (ref), v12 (ref), t5 (copy), refreshPlayerRender (copy), CollectionService (copy), Workspace (copy), PlotState (copy), TreadmillStaticCover (copy), LocalPlayer (copy), releaseActiveTreadmill (copy)
            v5 = p42
            v6 = p42 ~= nil and p47 == true

            local v71, v72, v73

            if p42 ~= nil then
                if p47 == true then
                    v71 = Workspace:WaitForChild("AdminTreadmill", 5)
                    v72 = v71 ~= nil and v71:IsA("Tool")
                    v73 = false
                else
                    v73 = true
                end
            else
                v73 = true
            end

            if v73 then
                if p42 ~= nil then
                    local v75 = PlotState.ResolveLocalSlot()
                    local v76 = if v75 == nil then nil else t5[v75]

                    assert(v76 ~= nil and v76.TreadmillId == p42, (("Missing active treadmill render \"%*\""):format(p42)))

                    local Model = v76.Model

                    releaseActiveTreadmill(p42)
                    CollectionService:RemoveTag(Model, "ActiveTreadmill")
                    Model:SetAttribute("ActiveTreadmillId", p42)
                    CollectionService:AddTag(Model, "ActiveTreadmill")
                else
                    releaseActiveTreadmill()
                    n3 = Workspace:GetServerTimeNow() + 1.25

                    if p46 == true then
                        v7 = true

                        if v7 and v11 and v5 == nil then
                            local v74 = v12

                            v7 = false
                            v11 = false
                            v12 = false
                            v9 = true
                            refreshPlayerRender(LocalPlayer, v74)
                            v9 = false
                            n3 = Workspace:GetServerTimeNow() + 1.25
                        end
                    end
                end
            else
                assert(v72, "Workspace.AdminTreadmill must be a Tool")
                releaseActiveTreadmill(p42)
                CollectionService:RemoveTag(v71, "ActiveTreadmill")
                v71:SetAttribute("ActiveTreadmillId", p42)
                CollectionService:AddTag(v71, "ActiveTreadmill")
            end

            local v79 = PlotState.ResolveLocalSlot()
            local v80 = if v79 == nil then nil else t5[v79]

            if v80 == nil then
                return
            end

            local v81 = p42 == nil or p47 == true

            v80.RateSign.Enabled = v81

            local Cover = v80.Cover

            if Cover ~= nil then
                TreadmillStaticCover.SetEnabled(Cover, v81)
            end
        end)
        TreadmillVideoController.MediaChanged:Connect(function(p48) -- line: 639
            -- upvalues: t5 (copy), PlotState (copy), TreadmillStaticCover (copy)
            local v82 = PlotState.ResolveLocalSlot()
            local v83 = if v82 == nil then nil else t5[v82]

            if v83 ~= nil then
                local Cover = v83.Cover

                if Cover ~= nil then
                    TreadmillStaticCover.ApplyMedia(Cover, p48)
                end
            end
        end)
        RunService.Heartbeat:Connect(tryEnterStaticTreadmill)
    end
}
