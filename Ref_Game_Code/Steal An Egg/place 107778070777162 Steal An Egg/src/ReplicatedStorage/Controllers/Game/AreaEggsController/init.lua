-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AreaEggNearbyPulse = require(script.AreaEggNearbyPulse)
local AreaEggSlotIdentity = require(ReplicatedStorage.Shared.Util.AreaEggSlotIdentity)
local AreaEggs = require(ReplicatedStorage.Shared.Types.AreaEggs)
local EggRenderer = require(ReplicatedStorage.Shared.Eggs.EggRenderer)
local EggState = require(ReplicatedStorage.Client.EggState)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local HoverHighlight = require(script.HoverHighlight)
local Log = require(ReplicatedStorage.Packages.Log)
local OnboardingTiming = require(ReplicatedStorage.Shared.Util.OnboardingTiming)
local NestResolver = require(script.NestResolver)
local Player = require(ReplicatedStorage.Shared.Player)
local RareEggHighlight = require(script.RareEggHighlight)
local SafeZoneBarriers = require(ReplicatedStorage.Shared.Util.SafeZoneBarriers)
local SmartProximityPrompt = require(ReplicatedStorage.Client.SmartProximityPrompt)
local Trove = require(ReplicatedStorage.Packages.Trove)
local WorkspaceEggVisibility = require(script.WorkspaceEggVisibility)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local States = AreaEggs.States
local LocalPlayer = Players.LocalPlayer
local v1 = Log.new()

local function newRenderQueue(p1) -- line: 71
    return {
        Pumping = false,
        Jobs = {},
        Order = {},
        PerFrame = p1
    }
end

local function discardRender(p2, p3) -- line: 75
    p2.Jobs[p3] = nil
end

local function drainRenderQueue(p4) -- line: 79
    -- upvalues: v1 (copy)
    while #p4.Order > 0 do
        local n1 = 0

        while n1 < p4.PerFrame do
            local v2 = table.remove(p4.Order, 1)

            if v2 == nil then
                break
            end

            local v3 = p4.Jobs[v2]
            local v4

            if v3 ~= nil then
                p4.Jobs[v2] = nil
                v4 = n1 + 1

                local ok, result = pcall(v3)

                if not ok then
                    v1:AtError():Log((("Area egg render for %* failed: %*"):format(v2, result)))
                end
            else
                v4 = n1
            end

            n1 = v4
        end

        task.wait()
    end

    p4.Pumping = false
end

local function enqueueRender(p5, p6, p7) -- line: 102
    -- upvalues: drainRenderQueue (copy)
    if p5.Jobs[p6] == nil then
        table.insert(p5.Order, p6)
    end

    p5.Jobs[p6] = p7

    if not p5.Pumping then
        p5.Pumping = true
        task.defer(drainRenderQueue, p5)
    end
end

return {
    Start = function() -- Start | line: 115
        -- upvalues: ReplicatedStorage (copy), RunService (copy), Workspace (copy), AreaEggNearbyPulse (copy), AreaEggSlotIdentity (copy), EggRenderer (copy), EggState (copy), GuardAreaGeometry (copy), HoverHighlight (copy), OnboardingTiming (copy), NestResolver (copy), Player (copy), RareEggHighlight (copy), SafeZoneBarriers (copy), SmartProximityPrompt (copy), Trove (copy), WorkspaceEggVisibility (copy), TryCall (copy), States (copy), LocalPlayer (copy), v1 (copy), newRenderQueue (copy), drainRenderQueue (copy)
        local v5 = AreaEggNearbyPulse.new(LocalPlayer)
        local v6 = newRenderQueue(1)
        local v7 = newRenderQueue(8)
        local World = Workspace.World

        assert(World:IsA("Folder"), "Workspace.World must be a Folder")

        local Areas = World.Areas

        assert(Areas:IsA("Folder"), "Workspace.World.Areas must be a Folder")

        local SeparationLine = Areas.SeparationLine

        assert(SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

        local Folder3 = Instance.new("Folder")

        Folder3.Name = "AreaEggSlotsClient"
        Folder3.Parent = Workspace

        local t2 = {}
        local t3 = {}
        local v8 = EggState.ReadCarryState()
        local v9 = EggState.HasFieldSnapshot()
        local n2 = 0

        local function isLocalPlayerInGameplay() -- line: 142
            -- upvalues: SeparationLine (copy), GuardAreaGeometry (copy), Player (copy), LocalPlayer (copy)
            local v10 = Player.FindRootPart(LocalPlayer)

            return v10 ~= nil and (GuardAreaGeometry.IsPastLine(SeparationLine, v10.Position))
        end

        local function isLocalPlayerTrapLocked() -- line: 147
            -- upvalues: Player (copy), LocalPlayer (copy)
            local v11 = Player.FindCharacter(LocalPlayer)

            return v11 ~= nil and v11:GetAttribute("IsTrapped") == true
        end

        local n3 = 8

        local function riderPromptReach() -- line: 154
            -- upvalues: Player (copy), LocalPlayer (copy)
            local v12 = Player.FindCharacter(LocalPlayer)
            local PetMountSession = if v12 == nil then nil else v12:FindFirstChild("PetMountSession")
            local HeightIncrease = if PetMountSession == nil then nil else PetMountSession:GetAttribute("HeightIncrease")

            if typeof(HeightIncrease) ~= "number" or HeightIncrease <= 0 then
                return 8
            end

            return (math.sqrt(64 + HeightIncrease * HeightIncrease))
        end

        local function isEggReachable(p8) -- line: 172
            -- upvalues: n3 (ref), Player (copy), SafeZoneBarriers (copy), LocalPlayer (copy)
            local v14 = Player.FindRootPart(LocalPlayer)

            if v14 == nil then
                return false
            end

            local BoundsCFramePosition = p8.Record.BoundsCFrame.Position

            if (BoundsCFramePosition - v14.Position).Magnitude > n3 + 4 then
                return true
            end

            return not SafeZoneBarriers.Separates(v14.Position, BoundsCFramePosition, SafeZoneBarriers.IsFencedUid(p8.Record.Uid))
        end

        local function updatePromptEnabled(p9) -- line: 189
            -- upvalues: SeparationLine (copy), isEggReachable (copy), GuardAreaGeometry (copy), Player (copy), LocalPlayer (copy)
            local Prompt = p9.Prompt
            local v15 = Player.FindRootPart(LocalPlayer)
            local v16 = v15 ~= nil and GuardAreaGeometry.IsPastLine(SeparationLine, v15.Position)

            if v16 then
                local v17 = Player.FindCharacter(LocalPlayer)

                Prompt.Enabled = not (v17 ~= nil and v17:GetAttribute("IsTrapped") == true) and isEggReachable(p9)
            else
                Prompt.Enabled = v16
            end
        end

        local function cleanupRendered(p10) -- line: 195
            -- upvalues: v6 (copy), v7 (copy), t2 (copy), t3 (copy), TryCall (copy)
            t3[p10] = nil
            v6.Jobs[p10] = nil
            v7.Jobs[p10] = nil

            local v18 = t2[p10]

            if v18 == nil then
                return
            end

            t2[p10] = nil
            v18.Trove:Destroy()

            if v18.OwnsModel and v18.Model.Parent ~= nil then
                TryCall(v18.Model.Destroy, v18.Model)
            end
        end

        local function scaleNestForRecord(p11) -- line: 210
            -- upvalues: NestResolver (copy)
            local v19 = NestResolver.Resolve(p11)

            v19:ScaleTo(p11.NestScale)

            return v19
        end

        local function renderClientEgg(p12) -- line: 216
            -- upvalues: Folder3 (copy), EggRenderer (copy)
            local Model = EggRenderer.RenderVisual({
                OwnerUserId = 0,
                ScaleAlpha = 1,
                UID = p12.Uid,
                ModelName = p12.Uid,
                Record = {
                    AssetCategory = p12.AssetCategory,
                    AssetScale = p12.AssetScale,
                    AssetEyeColor = p12.AssetEyeColor,
                    AssetColorSeed = p12.AssetColorSeed,
                    AssetColorIndex = p12.AssetColorIndex,
                    Mutations = table.clone(p12.Mutations),
                    BaseMutation = p12.BaseMutation,
                    HasParasite = p12.HasParasite
                }
            }, Folder3, false).Model

            Model:PivotTo(p12.BottomCFrame)

            return Model
        end

        local function bindPrompt(p13, p14, p15) -- line: 238
            -- upvalues: v5 (copy), SeparationLine (copy), t2 (copy), n2 (ref), isEggReachable (copy), cleanupRendered (copy), ReplicatedStorage (copy), Workspace (copy), AreaEggSlotIdentity (copy), EggState (copy), GuardAreaGeometry (copy), HoverHighlight (copy), Player (copy), RareEggHighlight (copy), SmartProximityPrompt (copy), Trove (copy), WorkspaceEggVisibility (copy), States (copy), LocalPlayer (copy), v1 (copy)
            RareEggHighlight.BindRenderedModel(p13, p14)

            local ProximityPrompt = Instance.new("ProximityPrompt")

            ProximityPrompt.Name = "CarryAreaEgg"
            ProximityPrompt.ActionText = "Steal"
            ProximityPrompt.ObjectText = "Egg"
            ProximityPrompt.MaxActivationDistance = 8
            ProximityPrompt.HoldDuration = Workspace:GetAttribute("FastEggPickupTime") and 0.25 or 1.2
            ProximityPrompt.RequiresLineOfSight = false
            ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom

            local v20 = SmartProximityPrompt.AttachToModel(ProximityPrompt, p14, {
                MaxActivationDistance = 8,
                TrackDistance = 8,
                SurfaceOffset = 0.75
            })
            local v21 = Trove.new()

            v21:Add(v20)

            local t4 = {
                Record = p13,
                Model = p14,
                OwnsModel = p15,
                Prompt = ProximityPrompt,
                Trove = v21
            }

            t2[p13.Uid] = t4

            if p13.State == States.Slot then
                v21:Add(v5:Bind(p13.Uid, p14, Workspace:GetServerTimeNow()))
            end

            HoverHighlight.Bind(p14, ProximityPrompt, v21)
            v21:Connect(ProximityPrompt.Triggered, function(p16) -- line: 269
                -- upvalues: p13 (copy), n2 (ref), cleanupRendered (copy), ReplicatedStorage (copy), AreaEggSlotIdentity (copy), EggState (copy), WorkspaceEggVisibility (copy), LocalPlayer (copy), v1 (copy)
                if p16 ~= LocalPlayer then
                    return
                end

                local Character = LocalPlayer.Character

                if Character then
                    for _, child in Character:GetChildren() do
                        if child:IsA("Tool") and child:GetAttribute("ItemType") == "MutationConsumable" then
                            local elapsed = os.clock()

                            if n2 <= elapsed then
                                n2 = elapsed + 2.5
                                require(ReplicatedStorage.Client.Notifications.Toast).Show({
                                    Text = "can only be used on your own eggs",
                                    Seconds = 2.5,
                                    SingleLine = true,
                                    Color = Color3.fromRGB(255, 100, 100)
                                })
                            end

                            return
                        end
                    end
                end

                local v22 = if AreaEggSlotIdentity.LooksLikeFirstAreaUid(p13.Uid) then AreaEggSlotIdentity.SlotKey(p13.AreaId, p13.NestId) else nil
                local v23, v24 = EggState.CarryFieldEgg(p13.Uid, v22)

                if v23 then
                    if v22 ~= nil then
                        cleanupRendered(p13.Uid)
                        WorkspaceEggVisibility.SetHidden(p13.Uid, false)
                    end
                elseif v24 ~= nil then
                    v1:AtDebug():Log((("Area egg carry denied for %*: %*"):format(p13.Uid, v24)))
                end
            end)

            local Prompt = t4.Prompt
            local v25 = Player.FindRootPart(LocalPlayer)
            local v26 = v25 ~= nil and GuardAreaGeometry.IsPastLine(SeparationLine, v25.Position)

            if v26 then
                local v27 = Player.FindCharacter(LocalPlayer)

                Prompt.Enabled = not (v27 ~= nil and v27:GetAttribute("IsTrapped") == true) and isEggReachable(t4)
            else
                Prompt.Enabled = v26
            end
        end

        local function renderSlot(p17) -- line: 306
            -- upvalues: cleanupRendered (copy), renderClientEgg (copy), bindPrompt (copy), AreaEggSlotIdentity (copy), OnboardingTiming (copy), NestResolver (copy), WorkspaceEggVisibility (copy)
            cleanupRendered(p17.Uid)

            if not AreaEggSlotIdentity.LooksLikeEventNestId(p17.NestId) then
                local v28 = NestResolver.Resolve(p17)

                v28:ScaleTo(p17.NestScale)
                v28:PivotTo(v28:GetPivot())
            end

            if AreaEggSlotIdentity.LooksLikeFirstAreaUid(p17.Uid) then
                WorkspaceEggVisibility.SetHidden(p17.Uid, true)
            else
                local v29 = WorkspaceEggVisibility.ResolveModel(p17.Uid)

                if v29 ~= nil then
                    WorkspaceEggVisibility.SetHidden(p17.Uid, false)
                    bindPrompt(p17, v29, false)

                    return
                end
            end

            bindPrompt(p17, renderClientEgg(p17), true)

            if AreaEggSlotIdentity.LooksLikeFirstAreaUid(p17.Uid) then
                OnboardingTiming.Mark("FirstForestEggRendered")
            end
        end

        local function renderDropped(p18) -- line: 330
            -- upvalues: cleanupRendered (copy), renderClientEgg (copy), bindPrompt (copy), AreaEggSlotIdentity (copy), WorkspaceEggVisibility (copy), v1 (copy)
            cleanupRendered(p18.Uid)

            if AreaEggSlotIdentity.LooksLikeFirstAreaUid(p18.Uid) then
                WorkspaceEggVisibility.SetHidden(p18.Uid, true)
                bindPrompt(p18, renderClientEgg(p18), true)
            else
                WorkspaceEggVisibility.SetHidden(p18.Uid, false)

                local v30 = WorkspaceEggVisibility.ResolveModel(p18.Uid)

                if v30 ~= nil then
                    bindPrompt(p18, v30, false)
                else
                    v1:AtDebug():Log((("Dropped area egg %* skipped because its Workspace model is not parented"):format(p18.Uid)))
                end
            end
        end

        local function applyRecordNow(p19) -- line: 347
            -- upvalues: cleanupRendered (copy), renderSlot (copy), renderDropped (copy), WorkspaceEggVisibility (copy), States (copy)
            WorkspaceEggVisibility.SetHidden(p19.Uid, false)

            if p19.State == States.Dropped then
                renderDropped(p19)
            elseif p19.State == States.Slot then
                renderSlot(p19)
            else
                cleanupRendered(p19.Uid)
            end
        end

        local function shouldQueueRender(p20) -- line: 360
            -- upvalues: t2 (copy), t3 (copy)
            if t3[p20.Uid] == p20.Version then
                return false
            end

            local v31 = t2[p20.Uid]

            if v31 ~= nil and v31.Record.Version == p20.Version then
                return v31.Record.State ~= p20.State
            end

            return true
        end

        local function queueApplyRecord(p21, p22) -- line: 371
            -- upvalues: t2 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy), drainRenderQueue (copy)
            local v32

            if t3[p21.Uid] == p21.Version then
                v32 = false
            else
                local v33 = t2[p21.Uid]

                v32 = v33 == nil or v33.Record.Version ~= p21.Version or v33.Record.State ~= p21.State
            end

            if not v32 then
                return
            end

            t3[p21.Uid] = p21.Version

            local Uid = p21.Uid

            local function v34() -- line: 377
                -- upvalues: p21 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy)
                local v35 = EggState.ReadFieldEgg(p21.Uid)

                if v35 == nil or v35.Version ~= p21.Version then
                    return
                end

                t3[p21.Uid] = nil
                WorkspaceEggVisibility.SetHidden(v35.Uid, false)

                if v35.State == States.Dropped then
                    renderDropped(v35)
                elseif v35.State == States.Slot then
                    renderSlot(v35)
                else
                    cleanupRendered(v35.Uid)
                end
            end

            if p22.Jobs[Uid] == nil then
                table.insert(p22.Order, Uid)
            end

            p22.Jobs[Uid] = v34

            if not p22.Pumping then
                p22.Pumping = true
                task.defer(drainRenderQueue, p22)
            end
        end

        local function applySnapshot(p23, p24) -- line: 387
            -- upvalues: t2 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy), drainRenderQueue (copy)
            local t5 = {}
            local t6 = {}

            for _, v36 in ipairs(p23.Records) do
                t5[v36.Uid] = true
                WorkspaceEggVisibility.SetHidden(v36.Uid, false)

                if v36.State == States.Slot or v36.State == States.Dropped then
                    table.insert(t6, v36)
                end
            end

            for v37 in pairs(t2) do
                if not t5[v37] then
                    cleanupRendered(v37)
                end
            end

            for _, v38 in ipairs(t6) do
                if t3[v38.Uid] ~= v38.Version then
                    local v39 = t2[v38.Uid]

                    if v39 == nil or v39.Record.Version ~= v38.Version or v39.Record.State ~= v38.State then
                        t3[v38.Uid] = v38.Version

                        local Uid = v38.Uid

                        local function v40() -- line: 377
                            -- upvalues: v38 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy)
                            local v41 = EggState.ReadFieldEgg(v38.Uid)

                            if v41 == nil or v41.Version ~= v38.Version then
                                return
                            end

                            t3[v38.Uid] = nil
                            WorkspaceEggVisibility.SetHidden(v41.Uid, false)

                            if v41.State == States.Dropped then
                                renderDropped(v41)
                            elseif v41.State == States.Slot then
                                renderSlot(v41)
                            else
                                cleanupRendered(v41.Uid)
                            end
                        end

                        if p24.Jobs[Uid] == nil then
                            table.insert(p24.Order, Uid)
                        end

                        p24.Jobs[Uid] = v40

                        if not p24.Pumping then
                            p24.Pumping = true
                            task.defer(drainRenderQueue, p24)
                        end
                    end
                end
            end
        end

        local function applyInitialSnapshot(p25) -- line: 410
            -- upvalues: v7 (copy), t2 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), AreaEggSlotIdentity (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy), drainRenderQueue (copy)
            local t7 = {}
            local t8 = {}
            local t9 = {}

            for _, v42 in ipairs(p25.Records) do
                t7[v42.Uid] = true
                WorkspaceEggVisibility.SetHidden(v42.Uid, false)

                if v42.State == States.Slot or v42.State == States.Dropped then
                    if AreaEggSlotIdentity.LooksLikeFirstAreaUid(v42.Uid) then
                        table.insert(t8, v42)
                    else
                        table.insert(t9, v42)
                    end
                end
            end

            for v43 in pairs(t2) do
                if not t7[v43] then
                    cleanupRendered(v43)
                end
            end

            for _, v44 in ipairs(t8) do
                t3[v44.Uid] = nil
                WorkspaceEggVisibility.SetHidden(v44.Uid, false)

                if v44.State == States.Dropped then
                    renderDropped(v44)
                elseif v44.State == States.Slot then
                    renderSlot(v44)
                else
                    cleanupRendered(v44.Uid)
                end
            end

            for _, v45 in ipairs(t9) do
                if t3[v45.Uid] ~= v45.Version then
                    local v46 = t2[v45.Uid]

                    if v46 == nil or v46.Record.Version ~= v45.Version or v46.Record.State ~= v45.State then
                        t3[v45.Uid] = v45.Version

                        local Uid = v45.Uid

                        local function v47() -- line: 377
                            -- upvalues: v45 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy)
                            local v48 = EggState.ReadFieldEgg(v45.Uid)

                            if v48 == nil or v48.Version ~= v45.Version then
                                return
                            end

                            t3[v45.Uid] = nil
                            WorkspaceEggVisibility.SetHidden(v48.Uid, false)

                            if v48.State == States.Dropped then
                                renderDropped(v48)
                            elseif v48.State == States.Slot then
                                renderSlot(v48)
                            else
                                cleanupRendered(v48.Uid)
                            end
                        end

                        if v7.Jobs[Uid] == nil then
                            table.insert(v7.Order, Uid)
                        end

                        v7.Jobs[Uid] = v47

                        if not v7.Pumping then
                            v7.Pumping = true
                            task.defer(drainRenderQueue, v7)
                        end
                    end
                end
            end
        end

        EggState.FieldClaimed:Connect(function(p26) -- line: 443
            -- upvalues: ReplicatedStorage (copy)
            require(ReplicatedStorage.Client.UI.VFX.RewardScreenTransition)()
            require(ReplicatedStorage.Client.Notifications.Toast).Show({
                Seconds = 2.5,
                Text = ("You stole an <font color=\"#%*\">EGG</font>!"):format((p26.Color:ToHex())),
                Color = Color3.new(1, 1, 1)
            })
        end)
        EggState.FieldRefreshed:Connect(function(p27) -- line: 452
            -- upvalues: v6 (copy), v9 (ref), applySnapshot (copy), applyInitialSnapshot (copy)
            if v9 then
                applySnapshot(p27, v6)
            else
                v9 = true
                applyInitialSnapshot(p27)
            end
        end)
        EggState.FieldShifted:Connect(function(p28) -- line: 460
            -- upvalues: v6 (copy), v7 (copy), t2 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy), drainRenderQueue (copy)
            WorkspaceEggVisibility.SetHidden(p28.Uid, false)

            if p28.State ~= States.Slot and p28.State ~= States.Dropped then
                cleanupRendered(p28.Uid)

                return
            end

            local Uid = p28.Uid

            v6.Jobs[Uid] = nil

            local Uid2 = p28.Uid

            v7.Jobs[Uid2] = nil
            t3[p28.Uid] = nil

            if t3[p28.Uid] ~= p28.Version then
                local v49 = t2[p28.Uid]

                if v49 == nil or v49.Record.Version ~= p28.Version or v49.Record.State ~= p28.State then
                    t3[p28.Uid] = p28.Version

                    local Uid = p28.Uid

                    local function v50() -- line: 377
                        -- upvalues: p28 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy)
                        local v51 = EggState.ReadFieldEgg(p28.Uid)

                        if v51 == nil or v51.Version ~= p28.Version then
                            return
                        end

                        t3[p28.Uid] = nil
                        WorkspaceEggVisibility.SetHidden(v51.Uid, false)

                        if v51.State == States.Dropped then
                            renderDropped(v51)
                        elseif v51.State == States.Slot then
                            renderSlot(v51)
                        else
                            cleanupRendered(v51.Uid)
                        end
                    end

                    if v6.Jobs[Uid] == nil then
                        table.insert(v6.Order, Uid)
                    end

                    v6.Jobs[Uid] = v50

                    if not v6.Pumping then
                        v6.Pumping = true
                        task.defer(drainRenderQueue, v6)
                    end
                end
            end
        end)
        EggState.CarryChanged:Connect(function(p29) -- line: 471
            -- upvalues: v8 (ref), cleanupRendered (copy), AreaEggSlotIdentity (copy), WorkspaceEggVisibility (copy)
            v8 = p29

            if p29.IsCarrying and p29.Uid ~= nil then
                if AreaEggSlotIdentity.LooksLikeFirstAreaUid(p29.Uid) then
                    cleanupRendered(p29.Uid)
                end

                WorkspaceEggVisibility.SetHidden(p29.Uid, false)
            end
        end)
        EggState.FieldGone:Connect(function(p30) -- line: 482
            -- upvalues: v8 (ref), cleanupRendered (copy), WorkspaceEggVisibility (copy)
            cleanupRendered(p30)

            local v52 = v8

            WorkspaceEggVisibility.SetHidden(p30, not (v52 ~= nil and v52.IsCarrying and v52.Uid == p30))
        end)
        WorkspaceEggVisibility.ModelAdded:Connect(function(p31) -- line: 490
            -- upvalues: v6 (copy), t2 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), AreaEggSlotIdentity (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy), drainRenderQueue (copy)
            local v53 = EggState.ReadFieldEgg(p31.Name)
            local v54, v55, v56

            if v53 ~= nil then
                if v53.State ~= States.Dropped or AreaEggSlotIdentity.LooksLikeFirstAreaUid(v53.Uid) then
                    v56 = true
                else
                    v54 = v6

                    if t3[v53.Uid] == v53.Version then
                        v55 = false
                    else
                        local v57 = t2[v53.Uid]

                        v55 = v57 == nil or v57.Record.Version ~= v53.Version or v57.Record.State ~= v53.State
                    end

                    v56 = false
                end
            else
                v56 = true
            end

            if v56 or not v55 then
                return
            end

            t3[v53.Uid] = v53.Version

            local Uid = v53.Uid

            local function v58() -- line: 377
                -- upvalues: v53 (copy), t3 (copy), cleanupRendered (copy), renderSlot (copy), renderDropped (copy), EggState (copy), WorkspaceEggVisibility (copy), States (copy)
                local v59 = EggState.ReadFieldEgg(v53.Uid)

                if v59 == nil or v59.Version ~= v53.Version then
                    return
                end

                t3[v53.Uid] = nil
                WorkspaceEggVisibility.SetHidden(v59.Uid, false)

                if v59.State == States.Dropped then
                    renderDropped(v59)
                elseif v59.State == States.Slot then
                    renderSlot(v59)
                else
                    cleanupRendered(v59.Uid)
                end
            end

            if v54.Jobs[Uid] == nil then
                table.insert(v54.Order, Uid)
            end

            v54.Jobs[Uid] = v58

            if not v54.Pumping then
                v54.Pumping = true
                task.defer(drainRenderQueue, v54)
            end
        end)
        task.spawn(function() -- line: 500
            require(script.CarryRunBackEffects).Start()
        end)
        WorkspaceEggVisibility.Start()
        RareEggHighlight.Start()
        RunService.Heartbeat:Connect(function() -- line: 504
            -- upvalues: v5 (copy), SeparationLine (copy), t2 (copy), n3 (ref), riderPromptReach (copy), isEggReachable (copy), Workspace (copy), GuardAreaGeometry (copy), Player (copy), LocalPlayer (copy)
            v5:Step(Workspace:GetServerTimeNow())
            n3 = riderPromptReach()

            for _, v60 in pairs(t2) do
                if v60.Prompt.MaxActivationDistance ~= n3 then
                    v60.Prompt.MaxActivationDistance = n3
                end

                local Prompt = v60.Prompt
                local v61 = Player.FindRootPart(LocalPlayer)
                local v62 = v61 ~= nil and GuardAreaGeometry.IsPastLine(SeparationLine, v61.Position)

                if v62 then
                    local v63 = Player.FindCharacter(LocalPlayer)

                    v62 = not (v63 ~= nil and v63:GetAttribute("IsTrapped") == true) and isEggReachable(v60)
                end

                Prompt.Enabled = v62
            end
        end)
        applyInitialSnapshot((EggState.ReadFieldEggs()))
    end
}
