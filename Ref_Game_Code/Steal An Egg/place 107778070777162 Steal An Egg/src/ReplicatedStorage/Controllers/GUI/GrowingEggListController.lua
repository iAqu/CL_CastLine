-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ServerClock = require(game:GetService("ReplicatedStorage").Shared.Util.ServerClock)
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

game:GetService("Workspace")

local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)

require(ReplicatedStorage.Shared.Eggs.Types)

local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggState = require(ReplicatedStorage.Client.EggState)

require(ReplicatedStorage.Shared.Types.Eggs)

local GamepadBindings = require(ReplicatedStorage.Client.GamepadBindings)
local Elapsed = require(ReplicatedStorage.Shared.Utils.Time).Elapsed
local GUI = require(ReplicatedStorage.Client.GUI)
local Hud = require(ReplicatedStorage.Client.Hud)
local GrowingEggListRow = require(ReplicatedStorage.Shared.Eggs.GrowingEggListRow)
local Log = require(ReplicatedStorage.Packages.Log)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PlacedEggRenderer = require(ReplicatedStorage.Shared.Eggs.PlacedEggRenderer)
local Products = require(ReplicatedStorage.Data.Products)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local SlideDock = require(ReplicatedStorage.Client.UI.SlideDock)

return {
    Start = function() -- Start | line: 67
        -- upvalues: ServerClock (copy), Players (copy), GuiService (copy), RunService (copy), AreaEggCycle (copy), ButtonFX (copy), EggRecords (copy), EggState (copy), GamepadBindings (copy), Elapsed (copy), GUI (copy), Hud (copy), GrowingEggListRow (copy), Log (copy), MenuNavigation (copy), Toast (copy), PlacedEggRenderer (copy), Products (copy), Storefront (copy), SlideDock (copy)
        local function claimRowTemplate(p1) -- line: 70
            local child

            for _, child2 in p1:GetChildren() do
                if child2.Name == "Template" and child2:IsA("GuiObject") then
                    if child ~= nil then
                        child2:Destroy()
                    else
                        child = child2
                    end
                end
            end

            assert(child ~= nil, "GrowingEggs.Frame.ScrollingFrame has no Template row")

            return child
        end

        local function optionalBadge(p2, p3) -- line: 86
            if p2 == nil then
                return nil
            end

            local v2 = p2:FindFirstChild(p3)

            return if v2 ~= nil then v2 else nil
        end

        local LocalPlayer = Players.LocalPlayer
        local v3 = GUI.GrowingEggs()
        local Frame = v3.Frame
        local Close = Frame.Close
        local GrowAll = Frame.Header.GrowAll
        local ScrollingFrame = Frame.ScrollingFrame
        local EmptyLast = ScrollingFrame:FindFirstChild("EmptyLast")
        local v4 = claimRowTemplate(ScrollingFrame)
        local EggsButton = Hud.Every("EggsButton")
        local v5 = Hud.Find("EggsButton")
        local NightImage = if v5 == nil then nil else v5:FindFirstChild("NightImage")
        local NightText = if v5 == nil then nil else v5:FindFirstChild("NightText")
        local Notification = if v5 == nil then nil else v5:FindFirstChild("Notification")
        local TextLabel = if Notification == nil then nil else Notification.InletTexture.TextLabel
        local Shadow = if TextLabel == nil then nil else TextLabel.Shadow
        local ReadyNotification = if v5 == nil then nil else v5:FindFirstChild("ReadyNotification")

        v5 = if ReadyNotification ~= nil then ReadyNotification.InletTexture.TextLabel else nil

        local Shadow2 = if v5 == nil then nil else v5.Shadow
        local t2 = {}
        local t3 = {}
        local t4 = {}
        local t5 = {}
        local t6 = {}
        local t7 = {}
        local n1 = 0
        local n2 = 0
        local n3 = 0

        assert(v3:IsA("ScreenGui"), "PlayerGui.GrowingEggs must be a ScreenGui")
        assert(Frame:IsA("GuiObject"), "GrowingEggs.Frame must be a GuiObject")
        assert(Close:IsA("GuiButton"), "GrowingEggs.Frame.Close must be a GuiButton")
        assert(GrowAll:IsA("GuiButton"), "GrowingEggs.Frame.Header.GrowAll must be a GuiButton")
        assert(ScrollingFrame:IsA("ScrollingFrame"), "GrowingEggs.Frame.ScrollingFrame must be a ScrollingFrame")
        assert(#EggsButton > 0, "the HUD has no EggsButton to open GrowingEggs with")
        v3.ResetOnSpawn = false
        GamepadBindings.TrackCloseButton(Close)

        local v6 = SlideDock.new(v3, Frame, SlideDock.EscortFramesOf(EggsButton))
        local v7 = Log.new()

        local function setNightDecoration(p4) -- line: 157
            -- upvalues: NightImage (copy), NightText (copy)
            if NightImage ~= nil then
                NightImage.Visible = p4
            end

            if NightText ~= nil then
                NightText.Visible = p4
            end
        end

        local function setOpen(p5, p6) -- line: 166
            -- upvalues: v6 (copy)
            v6:SetOpen(p5, p6)
        end

        local function getGrowthAlpha(p7) -- line: 170
            -- upvalues: LocalPlayer (copy), ServerClock (copy), EggRecords (copy)
            local v8 = ServerClock.Now()

            return EggRecords.GrowthAlpha(p7, v8, p7.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(p7, v8, p7.GrowthSpeedMultiplier), LocalPlayer)
        end

        local function isReady(p8) -- line: 181
            -- upvalues: LocalPlayer (copy), ServerClock (copy), EggRecords (copy)
            local v9 = ServerClock.Now()

            return EggRecords.GrowthAlpha(p8, v9, p8.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(p8, v9, p8.GrowthSpeedMultiplier), LocalPlayer) >= 1
        end

        local function getRemainingSeconds(p9) -- line: 183
            -- upvalues: LocalPlayer (copy), ServerClock (copy), EggRecords (copy)
            if p9.Placement ~= nil then
                local v10 = ServerClock.Now()

                if not (EggRecords.GrowthAlpha(p9, v10, p9.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(p9, v10, p9.GrowthSpeedMultiplier), LocalPlayer) >= 1) then
                    local v11 = ServerClock.Now()

                    return EggRecords.GrowthSecondsRemaining(p9, v11, p9.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(p9, v11, p9.GrowthSpeedMultiplier), LocalPlayer)
                end
            end

            return 0
        end

        local function getRemainingText(p10) -- line: 199
            -- upvalues: LocalPlayer (copy), ServerClock (copy), EggRecords (copy), Elapsed (copy)
            local Placement = p10.Placement
            local v12, v13

            if Placement ~= nil then
                if Placement.ReadyAt ~= nil then
                    v13 = true
                else
                    if p10.Placement ~= nil then
                        local v14 = ServerClock.Now()

                        if EggRecords.GrowthAlpha(p10, v14, p10.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(p10, v14, p10.GrowthSpeedMultiplier), LocalPlayer) >= 1 then
                            v12 = 0
                        else
                            local v15 = ServerClock.Now()

                            v12 = EggRecords.GrowthSecondsRemaining(p10, v15, p10.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(p10, v15, p10.GrowthSpeedMultiplier), LocalPlayer)
                        end
                    else
                        v12 = 0
                    end

                    v13 = false
                end
            else
                v13 = true
            end

            if v13 or v12 <= 0 then
                return "Ready!"
            end

            return (Elapsed(v12))
        end

        local function updateRow(p11) -- line: 209
            -- upvalues: LocalPlayer (copy), v3 (copy), getRemainingSeconds (copy), ServerClock (copy), GuiService (copy), EggRecords (copy), Elapsed (copy), GrowingEggListRow (copy), MenuNavigation (copy), Products (copy)
            local SelectedObject = GuiService.SelectedObject
            local Enabled = v3.Enabled and not MenuNavigation.IsSuspended() and not MenuNavigation.IsCursorActive() and (SelectedObject == p11.GrowButton or SelectedObject == p11.HatchButton)
            local Record = p11.Record
            local v16 = ServerClock.Now()
            local v17 = EggRecords.GrowthAlpha(Record, v16, Record.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record, v16, Record.GrowthSpeedMultiplier), LocalPlayer)
            local v18 = v17 >= 1
            local v19 = not v18 and Products.GetEggSkipGrowthProduct(getRemainingSeconds(Record)) ~= nil
            local Update = GrowingEggListRow.Update
            local v20 = EggRecords.EggIcon(Record)
            local Placement = Record.Placement
            local v21, v22

            if Placement ~= nil then
                if Placement.ReadyAt ~= nil then
                    v22 = true
                else
                    if Record.Placement ~= nil then
                        local v23 = ServerClock.Now()

                        if EggRecords.GrowthAlpha(Record, v23, Record.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record, v23, Record.GrowthSpeedMultiplier), LocalPlayer) >= 1 then
                            v21 = 0
                        else
                            local v24 = ServerClock.Now()

                            v21 = EggRecords.GrowthSecondsRemaining(Record, v24, Record.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record, v24, Record.GrowthSpeedMultiplier), LocalPlayer)
                        end
                    else
                        v21 = 0
                    end

                    v22 = false
                end
            else
                v22 = true
            end

            Update(p11, v20, v17, if v22 or v21 <= 0 then "Ready!" else Elapsed(v21), v18, v19)

            if Enabled then
                local v25 = if v18 then p11.HatchButton else p11.GrowButton

                if v25.Visible and v25.Active and v25.Interactable then
                    v25.Selectable = true

                    if GuiService.SelectedObject ~= v25 then
                        GuiService.SelectedObject = v25
                    end
                end
            end
        end

        local function updateNotification(p12, p13, p14, p15) -- line: 237
            if p12 == nil or p13 == nil or p14 == nil then
                return
            end

            local v26 = p15 > 0

            p12.Visible = v26

            if not v26 then
                return
            end

            local v27 = tostring(p15)

            p13.Text = v27
            p14.Text = v27
        end

        local function updatePlacedNotification() -- line: 256
            -- upvalues: Notification (copy), TextLabel (copy), n1 (ref), Shadow (copy)
            local v28 = n1

            if Notification == nil or TextLabel == nil or Shadow == nil then
                return
            end

            local v29 = v28 > 0

            Notification.Visible = v29

            if not v29 then
                return
            end

            local v30 = tostring(v28)

            TextLabel.Text = v30
            Shadow.Text = v30
        end

        local function updateReadyNotification() -- line: 265
            -- upvalues: ReadyNotification (copy), v5 (ref), n2 (ref), Shadow2 (copy)
            local v31 = n2

            if ReadyNotification == nil or v5 == nil or Shadow2 == nil then
                return
            end

            local v32 = v31 > 0

            ReadyNotification.Visible = v32

            if not v32 then
                return
            end

            local v33 = tostring(v31)

            v5.Text = v33
            Shadow2.Text = v33
        end

        local function clearPlacedNotification() -- line: 274
            -- upvalues: Notification (copy), TextLabel (copy), t6 (copy), n1 (ref), Shadow (copy)
            n1 = 0
            table.clear(t6)

            local v34 = n1

            if Notification == nil or TextLabel == nil or Shadow == nil then
                return
            end

            local v35 = v34 > 0

            Notification.Visible = v35

            if not v35 then
                return
            end

            local v36 = tostring(v34)

            TextLabel.Text = v36
            Shadow.Text = v36
        end

        local function clearReadyNotification() -- line: 280
            -- upvalues: ReadyNotification (copy), v5 (ref), t7 (copy), n2 (ref), Shadow2 (copy)
            n2 = 0
            table.clear(t7)

            local v37 = n2

            if ReadyNotification == nil or v5 == nil or Shadow2 == nil then
                return
            end

            local v38 = v37 > 0

            ReadyNotification.Visible = v38

            if not v38 then
                return
            end

            local v39 = tostring(v37)

            v5.Text = v39
            Shadow2.Text = v39
        end

        local function incrementPlacedNotification(p16) -- line: 286
            -- upvalues: v3 (copy), Notification (copy), TextLabel (copy), t6 (copy), n1 (ref), Shadow (copy)
            if v3.Enabled or t6[p16] then
                return
            end

            t6[p16] = true
            n1 += 1

            local v40 = n1

            if Notification == nil or TextLabel == nil or Shadow == nil then
                return
            end

            local v41 = v40 > 0

            Notification.Visible = v41

            if v41 then
                local v42 = tostring(v40)

                TextLabel.Text = v42
                Shadow.Text = v42
            end
        end

        local function incrementReadyNotification(p17) -- line: 296
            -- upvalues: v3 (copy), ReadyNotification (copy), v5 (ref), t7 (copy), n2 (ref), Shadow2 (copy)
            if v3.Enabled or t7[p17] then
                return
            end

            t7[p17] = true
            n2 += 1

            local v43 = n2

            if ReadyNotification == nil or v5 == nil or Shadow2 == nil then
                return
            end

            local v44 = v43 > 0

            ReadyNotification.Visible = v44

            if v44 then
                local v45 = tostring(v43)

                v5.Text = v45
                Shadow2.Text = v45
            end
        end

        local function consumePlacedNotification(p18) -- line: 306
            -- upvalues: Notification (copy), TextLabel (copy), t6 (copy), n1 (ref), Shadow (copy)
            if t6[p18] then
                t6[p18] = nil
                n1 = math.max(n1 - 1, 0)

                local v47 = n1

                if Notification == nil or TextLabel == nil or Shadow == nil then
                    return
                end

                local v48 = v47 > 0

                Notification.Visible = v48

                if v48 then
                    local v49 = tostring(v47)

                    TextLabel.Text = v49
                    Shadow.Text = v49
                end
            end
        end

        local function consumeReadyNotification(p19) -- line: 316
            -- upvalues: ReadyNotification (copy), v5 (ref), t7 (copy), n2 (ref), Shadow2 (copy)
            if t7[p19] then
                t7[p19] = nil
                n2 = math.max(n2 - 1, 0)

                local v51 = n2

                if ReadyNotification == nil or v5 == nil or Shadow2 == nil then
                    return
                end

                local v52 = v51 > 0

                ReadyNotification.Visible = v52

                if v52 then
                    local v53 = tostring(v51)

                    v5.Text = v53
                    Shadow2.Text = v53
                end
            end
        end

        local function syncReadyState(p20, p21, p22) -- line: 326
            -- upvalues: LocalPlayer (copy), v3 (copy), ReadyNotification (copy), v5 (ref), t5 (copy), t7 (copy), n2 (ref), Shadow2 (copy), ServerClock (copy), EggRecords (copy)
            local v54 = ServerClock.Now()
            local v55 = EggRecords.GrowthAlpha(p21, v54, p21.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(p21, v54, p21.GrowthSpeedMultiplier), LocalPlayer) >= 1

            if not v55 or t5[p20] then
                if not v55 and t5[p20] then
                    t5[p20] = nil

                    if not t7[p20] then
                        return v55
                    end

                    t7[p20] = nil
                    n2 = math.max(n2 - 1, 0)

                    local v57 = n2

                    if ReadyNotification ~= nil and v5 ~= nil then
                        if Shadow2 == nil then
                            return v55
                        end

                        local v58 = v57 > 0

                        ReadyNotification.Visible = v58

                        if v58 then
                            local v59 = tostring(v57)

                            v5.Text = v59
                            Shadow2.Text = v59
                        end
                    end
                end
            else
                t5[p20] = true

                if p22 and not v3.Enabled then
                    if t7[p20] then
                        return v55
                    end

                    t7[p20] = true
                    n2 += 1

                    local v60 = n2

                    if ReadyNotification ~= nil and v5 ~= nil then
                        if Shadow2 == nil then
                            return v55
                        end

                        local v61 = v60 > 0

                        ReadyNotification.Visible = v61

                        if v61 then
                            local v62 = tostring(v60)

                            v5.Text = v62
                            Shadow2.Text = v62

                            return v55
                        end
                    end
                end
            end

            return v55
        end

        local function compareRows(p23, p24) -- line: 345
            -- upvalues: LocalPlayer (copy), ServerClock (copy), EggRecords (copy)
            local Record = p23.Record
            local v63 = ServerClock.Now()
            local v64 = EggRecords.GrowthAlpha(Record, v63, Record.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record, v63, Record.GrowthSpeedMultiplier), LocalPlayer) >= 1
            local Record2 = p24.Record
            local v65 = ServerClock.Now()

            if v64 ~= (EggRecords.GrowthAlpha(Record2, v65, Record2.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record2, v65, Record2.GrowthSpeedMultiplier), LocalPlayer) >= 1) then
                return v64
            end

            local Record3 = p23.Record
            local v66 = false

            if Record3.Placement ~= nil then
                local v67 = ServerClock.Now()

                v66 = not (EggRecords.GrowthAlpha(Record3, v67, Record3.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record3, v67, Record3.GrowthSpeedMultiplier), LocalPlayer) >= 1)
            end

            local v68 = 0

            if v66 then
                local v69 = ServerClock.Now()

                v68 = EggRecords.GrowthSecondsRemaining(Record3, v69, Record3.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record3, v69, Record3.GrowthSpeedMultiplier), LocalPlayer)
            end

            local Record4 = p24.Record
            local v70 = false

            if Record4.Placement ~= nil then
                local v71 = ServerClock.Now()

                v70 = not (EggRecords.GrowthAlpha(Record4, v71, Record4.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record4, v71, Record4.GrowthSpeedMultiplier), LocalPlayer) >= 1)
            end

            local v72 = 0

            if v70 then
                local v73 = ServerClock.Now()

                v72 = EggRecords.GrowthSecondsRemaining(Record4, v73, Record4.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record4, v73, Record4.GrowthSpeedMultiplier), LocalPlayer)
            end

            if v68 ~= v72 then
                return v68 < v72
            end

            return tostring(p23.Uid) < tostring(p24.Uid)
        end

        local function pinEmptyLast() -- line: 361
            -- upvalues: EmptyLast (copy)
            if EmptyLast ~= nil then
                EmptyLast.LayoutOrder = 1E+06
            end
        end

        local function rowAction(p25) -- line: 367
            local v75 = if p25.Ready then p25.HatchButton else p25.GrowButton

            return if v75.Visible and v75.Active and v75.Interactable then v75 else nil
        end

        local function linkRows() -- line: 372
            -- upvalues: Close (copy), GrowAll (copy), t2 (copy)
            local t8 = {}

            for _, v76 in t2 do
                table.insert(t8, v76)
            end

            table.sort(t8, function(p26, p27) -- line: 375
                return p26.Root.LayoutOrder < p27.Root.LayoutOrder
            end)

            local t9 = {}

            for _, v77 in t8 do
                for _, v78 in {
                        v77.GrowButton,
                        v77.HatchButton
                    } do
                    v78.NextSelectionUp = nil
                    v78.NextSelectionDown = nil
                    v78.NextSelectionLeft = nil
                    v78.NextSelectionRight = nil
                end

                local v79 = if v77.Ready then v77.HatchButton else v77.GrowButton

                if not (v79.Visible and v79.Active and v79.Interactable) then
                    v79 = nil
                end

                if v79 then
                    table.insert(t9, v79)
                end
            end

            GrowAll.NextSelectionUp = Close
            GrowAll.NextSelectionLeft = GrowAll
            GrowAll.NextSelectionRight = Close
            Close.NextSelectionUp = Close
            Close.NextSelectionLeft = GrowAll
            Close.NextSelectionRight = Close
            GrowAll.NextSelectionDown = t9[1] or Close
            Close.NextSelectionDown = t9[1] or GrowAll

            for v80, v81 in t9 do
                v81.NextSelectionUp = t9[v80 - 1] or GrowAll
                v81.NextSelectionDown = t9[v80 + 1] or Close
                v81.NextSelectionLeft = v81
                v81.NextSelectionRight = Close
            end
        end

        local function relayoutRows() -- line: 405
            -- upvalues: EmptyLast (copy), t2 (copy), compareRows (copy), linkRows (copy)
            local t10 = {}

            for _, v82 in pairs(t2) do
                table.insert(t10, v82)
            end

            table.sort(t10, compareRows)

            for v83, v84 in ipairs(t10) do
                v84.Root.LayoutOrder = v83
            end

            if EmptyLast ~= nil then
                EmptyLast.LayoutOrder = 1E+06
            end

            linkRows()
        end

        local function destroyRow(p28) -- line: 419
            -- upvalues: v3 (copy), GrowAll (copy), t2 (copy), linkRows (copy), GuiService (copy), GrowingEggListRow (copy), MenuNavigation (copy)
            local v85 = t2[p28]

            if v85 == nil then
                return
            end

            t2[p28] = nil

            local SelectedObject = GuiService.SelectedObject

            if v3.Enabled and not MenuNavigation.IsSuspended() and not MenuNavigation.IsCursorActive() and SelectedObject and SelectedObject:IsDescendantOf(v85.Root) then
                local v86, v87

                for _, v88 in t2 do
                    local v89 = if v88.Ready then v88.HatchButton else v88.GrowButton

                    if v89.Visible and v89.Active and v89.Interactable and v89 then
                        if v88.Root.LayoutOrder >= v85.Root.LayoutOrder then
                            if v86 == nil or v88.Root.LayoutOrder < v86.Root.LayoutOrder then
                                v86 = v88
                            end
                        elseif v87 == nil or v88.Root.LayoutOrder > v87.Root.LayoutOrder then
                            v87 = v88
                        end
                    end
                end

                local v90 = v86 or v87
                local v91

                if v90 then
                    v91 = if v90.Ready then v90.HatchButton else v90.GrowButton

                    if not (v91.Visible and v91.Active and v91.Interactable) then
                        v91 = nil
                    end
                else
                    v91 = GrowAll
                end

                if v91 then
                    v91.Selectable = true
                end

                GuiService.SelectedObject = v91
            end

            GrowingEggListRow.Destroy(v85)
            linkRows()
        end

        local function requestGrow(p29) -- line: 448
            -- upvalues: v7 (copy), PlacedEggRenderer (copy)
            local v92, v93 = PlacedEggRenderer.RequestSkipGrowthForLocalEgg(p29)

            if not v92 then
                v7:AtWarning():Log((("Failed to request egg growth skip from list for %*: %*"):format(p29, v93 or "unknown")))
            end
        end

        local function showNoGrowingEggs(p30) -- line: 456
            -- upvalues: Toast (copy)
            Toast.Show({
                Seconds = 2,
                Text = p30 or "You have no growing eggs!",
                Color = Color3.fromRGB(255, 80, 80)
            })
        end

        local function requestGrowAll() -- line: 464
            -- upvalues: EggState (copy), Toast (copy), Products (copy), Storefront (copy)
            local v94, v95 = EggState.MayBuyGrowAll()

            if v94 then
                EggState.ForgetChosenSkip()
                Storefront.Prompt(Products.Directory.EggGrowAll.ProductId, true)
            else
                Toast.Show({
                    Seconds = 2,
                    Text = v95 or "You have no growing eggs!",
                    Color = Color3.fromRGB(255, 80, 80)
                })
            end
        end

        local function requestHatch(p31) -- line: 475
            -- upvalues: v7 (copy), PlacedEggRenderer (copy)
            local v96, v97 = PlacedEggRenderer.ActivateLocalEgg(p31)

            if not v96 then
                v7:AtWarning():Log((("Failed to hatch egg from list for %*: %*"):format(p31, v97 or "unknown")))
            end
        end

        local function removeHatchingRow(p32) -- line: 482
            -- upvalues: Notification (copy), TextLabel (copy), ReadyNotification (copy), v5 (ref), t3 (copy), t6 (copy), t7 (copy), n1 (ref), n2 (ref), destroyRow (copy), Shadow2 (copy), Shadow (copy)
            t3[p32] = true

            local Notification2, TextLabel2, Shadow3, v98, v99

            if t6[p32] then
                t6[p32] = nil
                n1 = math.max(n1 - 1, 0)
                Notification2 = Notification
                TextLabel2 = TextLabel
                Shadow3 = Shadow
                v98 = n1

                if Notification ~= nil and TextLabel ~= nil and Shadow ~= nil then
                    v99 = v98 > 0
                    Notification2.Visible = v99

                    if v99 then
                        local v101 = tostring(v98)

                        TextLabel2.Text = v101
                        Shadow3.Text = v101
                    end
                end
            end

            local ReadyNotification2, v102, Shadow4, v103, v104

            if t7[p32] then
                t7[p32] = nil
                n2 = math.max(n2 - 1, 0)
                ReadyNotification2 = ReadyNotification
                v102 = v5
                Shadow4 = Shadow2
                v103 = n2

                if ReadyNotification ~= nil and v5 ~= nil and Shadow2 ~= nil then
                    v104 = v103 > 0
                    ReadyNotification2.Visible = v104

                    if v104 then
                        local v106 = tostring(v103)

                        v102.Text = v106
                        Shadow4.Text = v106
                    end
                end
            end

            destroyRow(p32)
        end

        local function mountRow(p33, p34) -- line: 489
            -- upvalues: ScrollingFrame (copy), v4 (copy), t2 (copy), updateRow (copy), requestGrow (copy), requestHatch (copy), ButtonFX (copy), GrowingEggListRow (copy)
            local v107 = GrowingEggListRow.Mount(v4, ScrollingFrame, p33, requestGrow, requestHatch)

            v107.Record = p34
            t2[p33] = v107
            v107.Trove:Add(ButtonFX(v107.GrowButton, 1.08))

            if v107.HatchButton ~= v107.GrowButton then
                v107.Trove:Add(ButtonFX(v107.HatchButton, 1.08))
            end

            updateRow(v107)

            return v107
        end

        local function refreshRows(p35, p36) -- line: 503
            -- upvalues: LocalPlayer (copy), v3 (copy), Notification (copy), TextLabel (copy), ReadyNotification (copy), v5 (ref), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), n1 (ref), n2 (ref), updateRow (copy), relayoutRows (copy), destroyRow (copy), mountRow (copy), Shadow2 (copy), Shadow (copy), ServerClock (copy), EggRecords (copy), EggState (copy)
            local v108 = EggState.ReadOwnerEggs(LocalPlayer.UserId)
            local t11 = {}
            local t12 = {}

            for v109, v110 in pairs(v108) do
                if v110.Placement ~= nil then
                    t12[v109] = true

                    if not t4[v109] then
                        t4[v109] = true

                        if p35 and not v3.Enabled and not t6[v109] then
                            t6[v109] = true
                            n1 += 1

                            local v111 = n1

                            if Notification ~= nil and TextLabel ~= nil and Shadow ~= nil then
                                local v112 = v111 > 0

                                Notification.Visible = v112

                                if v112 then
                                    local v113 = tostring(v111)

                                    TextLabel.Text = v113
                                    Shadow.Text = v113
                                end
                            end
                        end
                    end

                    local v114 = ServerClock.Now()

                    if EggRecords.GrowthAlpha(v110, v114, v110.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(v110, v114, v110.GrowthSpeedMultiplier), LocalPlayer) >= 1 then
                        if not t5[v109] then
                            t5[v109] = true

                            if p36 and not v3.Enabled and not t7[v109] then
                                t7[v109] = true
                                n2 += 1

                                local v115 = n2

                                if ReadyNotification ~= nil and v5 ~= nil and Shadow2 ~= nil then
                                    local v116 = v115 > 0

                                    ReadyNotification.Visible = v116

                                    if v116 then
                                        local v117 = tostring(v115)

                                        v5.Text = v117
                                        Shadow2.Text = v117
                                    end
                                end
                            end
                        end
                    elseif t5[v109] then
                        t5[v109] = nil

                        if t7[v109] then
                            t7[v109] = nil

                            local v118 = n2

                            n2 = math.max(v118 - 1, 0)

                            local v120 = n2

                            if ReadyNotification ~= nil and v5 ~= nil and Shadow2 ~= nil then
                                local v121 = v120 > 0

                                ReadyNotification.Visible = v121

                                if v121 then
                                    local v122 = tostring(v120)

                                    v5.Text = v122
                                    Shadow2.Text = v122
                                end
                            end
                        end
                    end

                    if t3[v109] then
                        destroyRow(v109)
                    else
                        t11[v109] = true

                        local v123 = t2[v109]

                        if v123 ~= nil then
                            v123.Record = v110
                            updateRow(v123)
                        else
                            mountRow(v109, v110)
                        end
                    end
                end
            end

            for v124 in pairs(t2) do
                if not t11[v124] then
                    destroyRow(v124)
                end
            end

            for v125 in pairs(t4) do
                if not t12[v125] then
                    if t6[v125] then
                        t6[v125] = nil
                        n1 = math.max(n1 - 1, 0)

                        local v127 = n1

                        if Notification ~= nil and TextLabel ~= nil and Shadow ~= nil then
                            local v128 = v127 > 0

                            Notification.Visible = v128

                            if v128 then
                                local v129 = tostring(v127)

                                TextLabel.Text = v129
                                Shadow.Text = v129
                            end
                        end
                    end

                    if t7[v125] then
                        t7[v125] = nil
                        n2 = math.max(n2 - 1, 0)

                        local v131 = n2

                        if ReadyNotification ~= nil and v5 ~= nil and Shadow2 ~= nil then
                            local v132 = v131 > 0

                            ReadyNotification.Visible = v132

                            if v132 then
                                local v133 = tostring(v131)

                                v5.Text = v133
                                Shadow2.Text = v133
                            end
                        end
                    end

                    t4[v125] = nil
                    t5[v125] = nil
                    t3[v125] = nil
                end
            end

            relayoutRows()
        end

        local function updateVisibleRows() -- line: 554
            -- upvalues: LocalPlayer (copy), v3 (copy), ReadyNotification (copy), v5 (ref), t2 (copy), t5 (copy), t7 (copy), n2 (ref), n3 (ref), updateRow (copy), linkRows (copy), relayoutRows (copy), Shadow2 (copy), NightImage (copy), NightText (copy), ServerClock (copy), AreaEggCycle (copy), EggRecords (copy)
            local v134 = ServerClock.Now()

            if v134 - n3 < 0.25 then
                return
            end

            n3 = v134

            local v135 = AreaEggCycle.IsNightPhase(v134)

            if NightImage ~= nil then
                NightImage.Visible = v135
            end

            if NightText ~= nil then
                NightText.Visible = v135
            end

            local v136 = false

            for _, v137 in pairs(t2) do
                local v138 = t5[v137.Uid] == true
                local Uid, Record = v137.Uid, v137.Record
                local v139 = ServerClock.Now()
                local v140 = EggRecords.GrowthAlpha(Record, v139, Record.GrowthSpeedMultiplier, EggRecords.CurrentNightCredit(Record, v139, Record.GrowthSpeedMultiplier), LocalPlayer) >= 1

                if v140 then
                    if not t5[Uid] then
                        t5[Uid] = true

                        if not v3.Enabled and not t7[Uid] then
                            t7[Uid] = true
                            n2 += 1

                            local v141 = n2

                            if ReadyNotification ~= nil and v5 ~= nil and Shadow2 ~= nil then
                                local v142 = v141 > 0

                                ReadyNotification.Visible = v142

                                if v142 then
                                    local v143 = tostring(v141)

                                    v5.Text = v143
                                    Shadow2.Text = v143
                                end
                            end
                        end
                    end
                elseif t5[Uid] then
                    t5[Uid] = nil

                    if t7[Uid] then
                        t7[Uid] = nil

                        local v144 = n2

                        n2 = math.max(v144 - 1, 0)

                        local v146 = n2

                        if ReadyNotification ~= nil and v5 ~= nil and Shadow2 ~= nil then
                            local v147 = v146 > 0

                            ReadyNotification.Visible = v147

                            if v147 then
                                local v148 = tostring(v146)

                                v5.Text = v148
                                Shadow2.Text = v148
                            end
                        end
                    end
                end

                if v140 ~= v138 then
                    v136 = true
                end

                updateRow(v137)
            end

            if v136 then
                relayoutRows()
            else
                linkRows()
            end
        end

        v4.Visible = false
        v6:SetOpen(false, true)

        local v149 = n1
        local v150

        if Notification ~= nil and TextLabel ~= nil and Shadow ~= nil then
            local v151 = v149 > 0

            Notification.Visible = v151

            if v151 then
                v150 = tostring(v149)
                TextLabel.Text = v150
                Shadow.Text = v150
            end
        end

        local v152 = n2

        if ReadyNotification ~= nil and v5 ~= nil and Shadow2 ~= nil then
            local v153 = v152 > 0

            ReadyNotification.Visible = v153

            if v153 then
                v150 = tostring(v152)
                v5.Text = v150
                Shadow2.Text = v150
            end
        end

        local OwnerCleared = AreaEggCycle.IsNightPhase(ServerClock.Now())

        if NightImage ~= nil then
            NightImage.Visible = OwnerCleared
        end

        if NightText ~= nil then
            NightText.Visible = OwnerCleared
        end

        refreshRows(false, true)

        for _, v154 in EggsButton do
            local OnActivated = GUI.OnActivated
            local v155 = v5

            OnActivated(v154, function() -- line: 591
                -- upvalues: Notification (copy), TextLabel (copy), ReadyNotification (copy), t6 (copy), t7 (copy), n1 (ref), n2 (ref), v6 (copy), refreshRows (copy), v155 (copy), Shadow2 (copy), Shadow (copy)
                v6:SetOpen(true, nil)
                n1 = 0
                table.clear(t6)

                local v156 = n1

                if Notification ~= nil and TextLabel ~= nil and Shadow ~= nil then
                    local v157 = v156 > 0

                    Notification.Visible = v157

                    if v157 then
                        local v158 = tostring(v156)

                        TextLabel.Text = v158
                        Shadow.Text = v158
                    end
                end

                n2 = 0
                table.clear(t7)

                local v159 = n2

                if ReadyNotification ~= nil and v155 ~= nil and Shadow2 ~= nil then
                    local v160 = v159 > 0

                    ReadyNotification.Visible = v160

                    if v160 then
                        local v161 = tostring(v159)

                        v155.Text = v161
                        Shadow2.Text = v161
                    end
                end

                refreshRows(true, true)
            end)
            ButtonFX(v154, 1.08)
        end

        GUI.OnActivated(Close, function() -- line: 599
            -- upvalues: v6 (copy)
            v6:SetOpen(false, nil)
        end)
        ButtonFX(Close, 1.08)
        GUI.OnActivated(GrowAll, requestGrowAll)
        ButtonFX(GrowAll, 1.08)
        EggState.SnapshotRefreshed:Connect(function() -- line: 603
            -- upvalues: refreshRows (copy)
            refreshRows(true, true)
        end)
        EggState.OwnerRefreshed:Connect(function(p37) -- line: 604
            -- upvalues: LocalPlayer (copy), refreshRows (copy)
            if p37 == LocalPlayer.UserId then
                refreshRows(true, true)
            end
        end)
        EggState.OwnerCleared:Connect(function(p38) -- line: 609
            -- upvalues: LocalPlayer (copy), Notification (copy), TextLabel (copy), ReadyNotification (copy), v5 (ref), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), n1 (ref), n2 (ref), destroyRow (copy), Shadow2 (copy), Shadow (copy)
            if p38 ~= LocalPlayer.UserId then
                return
            end

            for v162 in pairs(t2) do
                destroyRow(v162)
            end

            table.clear(t3)
            table.clear(t4)
            table.clear(t5)
            n1 = 0
            table.clear(t6)

            local v163 = n1

            if Notification ~= nil and TextLabel ~= nil and Shadow ~= nil then
                local v164 = v163 > 0

                Notification.Visible = v164

                if v164 then
                    local v165 = tostring(v163)

                    TextLabel.Text = v165
                    Shadow.Text = v165
                end
            end

            n2 = 0
            table.clear(t7)

            local v166 = n2

            if ReadyNotification == nil or v5 == nil or Shadow2 == nil then
                return
            end

            local v167 = v166 > 0

            ReadyNotification.Visible = v167

            if v167 then
                local v168 = tostring(v166)

                v5.Text = v168
                Shadow2.Text = v168
            end
        end)
        PlacedEggRenderer.LocalEggHatchStarted:Connect(removeHatchingRow)
        RunService.Heartbeat:Connect(updateVisibleRows)
    end
}
