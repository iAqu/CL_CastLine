-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local AdminBoosts = require(ReplicatedStorage.Shared.Util.AdminBoosts)

require(ReplicatedStorage.Shared.Types.AreaEggs)

local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local EggState = require(ReplicatedStorage.Client.EggState)
local Elapsed = require(ReplicatedStorage.Shared.Utils.Time).Elapsed
local Hud = require(ReplicatedStorage.Client.Hud)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local SpeedGainPopup = require(ReplicatedStorage.Client.UI.VFX.SpeedGainPopup)
local SpeedPowerProjection = require(ReplicatedStorage.Client.SpeedPowerProjection)
local Trails = require(ReplicatedStorage.Data.Trails)
local TreadmillCharacterPresentationController = require(script.Parent.Parent.Game.Plots.TreadmillCharacterPresentationController)
local Visibility = require(script.Visibility)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local TreadmillVideoController = require(ReplicatedStorage.Shared.TreadmillVideoController)
local TreadmillVideoGate = require(ReplicatedStorage.Client.TreadmillVideoGate)

require(ReplicatedStorage.Shared.TreadmillVideoController.Types.Interface)

local Treadmills = require(ReplicatedStorage.Data.Treadmills)

return {
    Start = function() -- Start | line: 50
        -- upvalues: RunService (copy), UserInputService (copy), Workspace (copy), AdminBoosts (copy), BossMasteryFlags (copy), EggState (copy), Elapsed (copy), Hud (copy), Remotes (copy), Save (copy), Preferences (copy), SpeedGainPopup (copy), SpeedPowerProjection (copy), Trails (copy), TreadmillCharacterPresentationController (copy), Visibility (copy), TreadmillUtil (copy), TreadmillVideoController (copy), TreadmillVideoGate (copy), Treadmills (copy)
        local SpeedValue = Hud.Get("SpeedValue")
        local Treadmill = Hud.Find("SpeedValue", "Treadmill")
        local Treadmill2 = Hud.Find("SpeedMultiShine", "Treadmill")
        local TextColor3 = SpeedValue.TextColor3
        local TemporarySpeedBoost = Hud.Find("TemporarySpeedBoost")
        local CurrentBoost = if TemporarySpeedBoost == nil then nil else TemporarySpeedBoost:FindFirstChild("CurrentBoost")
        local v1 = false
        local v2
        local n1 = 0
        local n2 = 0
        local t2
        local n3 = 1

        local function visibleSpeedLabel() -- line: 75
            -- upvalues: SpeedValue (copy), Treadmill (copy), v2 (ref)
            if v2 == nil or Treadmill == nil then
                return SpeedValue
            end

            return Treadmill
        end

        local function updateSpeedPower() -- line: 82
            -- upvalues: SpeedValue (copy), Treadmill (copy), TextColor3 (copy), v2 (ref), n3 (ref), AdminBoosts (copy), Save (copy), SpeedPowerProjection (copy), Trails (copy), TreadmillUtil (copy)
            local v3 = Save.Await()

            if not v3 then
                return
            end

            local v4 = SpeedPowerProjection.ReadProjected()
            local v5 = TreadmillUtil.ResolveEffectiveSpeedPower(v4, n3) * AdminBoosts.ReadMultiplier(AdminBoosts.SPEED)
            local v6 = TreadmillUtil.FormatSpeedPower((math.floor(v5)))
            local v7 = TreadmillUtil.ResolveSpeedBoostSpeedStepMultiplier(v3)
            local EquippedTrail = v3.EquippedTrail
            local v8, v9

            if EquippedTrail ~= nil then
                if Trails.TrailNameExists(EquippedTrail) and v3.TrailInventory[EquippedTrail] then
                    local v10 = Trails.Directory[EquippedTrail]

                    v8 = v10.SpeedNumberColor or v10.Rarity.Color
                    v9 = v8
                else
                    v9 = TextColor3
                end
            else
                v9 = TextColor3
            end

            if v2 ~= nil and TreadmillUtil.DEFAULT_SPEED_STEP_MULTIPLIER < v7 then
                v6 ..= (" <font color=\"#00FF00\">(%*)</font>"):format((TreadmillUtil.FormatSpeedMultiplierValue(v7)))
            end

            SpeedValue.Text = v6
            SpeedValue.TextColor3 = v9

            if Treadmill ~= nil then
                Treadmill.Text = v6
                Treadmill.TextColor3 = v9
            end
        end

        local function updateTemporarySpeedBoostDisplay() -- line: 121
            -- upvalues: TemporarySpeedBoost (copy), CurrentBoost (copy), Workspace (copy), BossMasteryFlags (copy), Elapsed (copy), Save (copy), TreadmillUtil (copy)
            local v11 = Save.Await()
            local v12 = TreadmillUtil.ResolveTemporarySpeedBoostRemainingSeconds(v11, Workspace:GetServerTimeNow())

            if TemporarySpeedBoost == nil or CurrentBoost == nil then
                return v12 > 0
            end

            if v12 <= 0 then
                TemporarySpeedBoost.Visible = false

                return false
            end

            TemporarySpeedBoost.Visible = true
            CurrentBoost.Text = ("X%* Treadmill Boost (%*)"):format(BossMasteryFlags.TreadmillBoostMultiplier:Get(), (Elapsed(v12)))

            return true
        end

        local function startTemporarySpeedBoostCountdown() -- line: 144
            -- upvalues: n2 (ref), updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy)
            n2 += 1

            local v13 = n2

            if updateTemporarySpeedBoostDisplay() then
                task.spawn(function() -- line: 152
                    -- upvalues: v13 (copy), n2 (ref), updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy)
                    while true do
                        if v13 == n2 then
                            task.wait(1)

                            if updateTemporarySpeedBoostDisplay() then
                                updateSpeedPower()
                                continue
                            end

                            break
                        end

                        return
                    end

                    updateSpeedPower()
                end)
            end
        end

        local function stopActiveTreadmillVisualSimulation() -- line: 164
            -- upvalues: n1 (ref), t2 (ref), SpeedPowerProjection (copy)
            local t3 = t2

            if t3 ~= nil then
                SpeedPowerProjection.CloseSession(t3.Token)
            end

            n1 += 1
            t2 = nil
        end

        local function applyTreadmillVideoSetting(p1) -- line: 173
            -- upvalues: v2 (ref), Save (copy), Preferences (copy), TreadmillVideoController (copy), TreadmillVideoGate (copy)
            local v14 = v2

            if v14 == nil or Preferences.IsOn("DisableVideos") or TreadmillVideoGate.IsVideoPlayerDisabled() then
                TreadmillVideoController.Stop()

                return
            end

            if p1 ~= nil then
                TreadmillVideoController.Start(v14, p1)

                return
            end

            local v15 = Save.Await()

            assert(v15 ~= nil, "Save data must be loaded before enabling treadmill videos")
            TreadmillVideoController.Start(v14, v15.TreadmillMediaFeedState)
        end

        local function resolveCurrentSpeedPowerPerStep(p2, p3) -- line: 194
            -- upvalues: Save (copy), TreadmillUtil (copy)
            return TreadmillUtil.ResolveSpeedPowerPerStep(Save.Await(), p2, p3)
        end

        local function flushPendingScreenSpeedGain(p4) -- line: 198
            -- upvalues: SpeedValue (copy), Treadmill (copy), v2 (ref), SpeedGainPopup (copy), SpeedPowerProjection (copy)
            if p4.PendingScreenSpeedPowerDelta <= 0 then
                return
            end

            local PendingScreenSpeedPowerDelta = p4.PendingScreenSpeedPowerDelta

            SpeedGainPopup.Play(if v2 == nil or Treadmill == nil then SpeedValue else Treadmill, PendingScreenSpeedPowerDelta, nil, function() -- line: 204
                -- upvalues: p4 (copy), PendingScreenSpeedPowerDelta (copy), SpeedPowerProjection (copy)
                SpeedPowerProjection.CreditRevealedGain(p4.Token, PendingScreenSpeedPowerDelta)
            end)
            p4.PendingScreenSpeedPowerDelta = 0
        end

        local function resetNextScreenPopupAt(p5, p6) -- line: 210
            -- upvalues: TreadmillUtil (copy)
            p5.NextScreenPopupAt = p6 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL
        end

        local function handleTransparentModeSpeedGainPulse(p7, p8, p9) -- line: 214
            -- upvalues: SpeedValue (copy), Treadmill (copy), v2 (ref), SpeedGainPopup (copy), SpeedPowerProjection (copy), TreadmillUtil (copy)
            p7.PendingScreenSpeedPowerDelta += p8

            if p7.NextScreenPopupAt <= p9 then
                if not (p7.PendingScreenSpeedPowerDelta <= 0) then
                    local PendingScreenSpeedPowerDelta = p7.PendingScreenSpeedPowerDelta

                    SpeedGainPopup.Play(if v2 == nil or Treadmill == nil then SpeedValue else Treadmill, PendingScreenSpeedPowerDelta, nil, function() -- line: 204
                        -- upvalues: p7 (copy), PendingScreenSpeedPowerDelta (copy), SpeedPowerProjection (copy)
                        SpeedPowerProjection.CreditRevealedGain(p7.Token, PendingScreenSpeedPowerDelta)
                    end)
                    p7.PendingScreenSpeedPowerDelta = 0
                end

                p7.NextScreenPopupAt = p9 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL
            end
        end

        local function handleVisibleModeSpeedGainPulse(p10, p11, p12) -- line: 226
            -- upvalues: SpeedValue (copy), Treadmill (copy), v2 (ref), SpeedGainPopup (copy), SpeedPowerProjection (copy), TreadmillUtil (copy)
            p10.PendingScreenSpeedPowerDelta = 0
            p10.NextScreenPopupAt = p12 + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL
            SpeedGainPopup.PlayWalk(if v2 == nil or Treadmill == nil then SpeedValue else Treadmill, p11, p10.RarityColor, function() -- line: 233
                -- upvalues: p10 (copy), p11 (copy), SpeedPowerProjection (copy)
                SpeedPowerProjection.CreditRevealedGain(p10.Token, p11)
            end)
        end

        local function handleServerSpeedGain(p13, p14) -- line: 238
            -- upvalues: SpeedValue (copy), Treadmill (copy), v2 (ref), t2 (ref), updateSpeedPower (copy), SpeedGainPopup (copy), SpeedPowerProjection (copy)
            if p14 == "Treadmill" and t2 ~= nil then
                return
            end

            local Play, v18

            if p14 ~= "Instant" or t2 == nil then
                updateSpeedPower()

                if p14 == "Walk" then
                    SpeedGainPopup.PlayWalk(if v2 == nil or Treadmill == nil then SpeedValue else Treadmill, p13, nil, updateSpeedPower)
                else
                    SpeedGainPopup.Play(if v2 == nil or Treadmill == nil then SpeedValue else Treadmill, p13, nil, updateSpeedPower)
                end
            else
                local t4 = t2

                t4.SimulatedSpeedPower += p13
                assert(SpeedPowerProjection.CreditRevealedGain(t4.Token, p13), "Instant Speed Power gain must target the active treadmill projection")
                Play = SpeedGainPopup.Play
                v18 = if v2 == nil or Treadmill == nil then SpeedValue else Treadmill
                Play(v18, p13, nil, updateSpeedPower)
            end
        end

        local function startActiveTreadmillVisualSimulation(p15, p16, p17) -- line: 264
            -- upvalues: SpeedValue (copy), Treadmill (copy), v2 (ref), n1 (ref), t2 (ref), Workspace (copy), Save (copy), SpeedGainPopup (copy), SpeedPowerProjection (copy), TreadmillCharacterPresentationController (copy), TreadmillUtil (copy)
            local t5 = t2

            if t5 ~= nil then
                SpeedPowerProjection.CloseSession(t5.Token)
            end

            n1 += 1
            t2 = nil

            local ServerTimeNow = Workspace:GetServerTimeNow()
            local v21 = Save.Await()

            assert(v21 ~= nil, "Save data must be loaded before starting treadmill simulation")

            local v23 = n1

            t2 = {
                PendingScreenSpeedPowerDelta = 0,
                NextScreenPopupAt = ServerTimeNow + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL,
                NextSpeedAwardAt = p16,
                RarityColor = p17,
                SimulatedSpeedPower = TreadmillUtil.NormalizeSpeedPower(v21.SpeedPower),
                SpeedMultiplier = p15,
                Token = v23
            }
            SpeedPowerProjection.OpenSession(v23)
            task.spawn(function() -- line: 286
                -- upvalues: v23 (copy), SpeedValue (copy), Treadmill (copy), v2 (ref), t2 (ref), Workspace (copy), Save (copy), SpeedGainPopup (copy), SpeedPowerProjection (copy), TreadmillCharacterPresentationController (copy), TreadmillUtil (copy)
                while true do
                    local t6 = t2

                    if t6 ~= nil and t6.Token == v23 then
                        local ServerTimeNow = Workspace:GetServerTimeNow()
                        local v25 = math.max(t6.NextSpeedAwardAt - ServerTimeNow, 0)

                        if v25 > 0 then
                            task.wait(v25)
                        end

                        local t7 = t2

                        if t7 ~= nil and t7.Token == v23 then
                            while true do
                                local ServerTimeNow = Workspace:GetServerTimeNow()

                                if ServerTimeNow < t7.NextSpeedAwardAt then
                                    break
                                end

                                local NextSpeedAwardAt, SpeedMultiplier = t7.NextSpeedAwardAt, t7.SpeedMultiplier
                                local v26 = TreadmillUtil.ResolveSpeedPowerPerStep(Save.Await(), SpeedMultiplier, NextSpeedAwardAt)

                                t7.SimulatedSpeedPower += v26

                                if TreadmillCharacterPresentationController.IsLocalCharacterFullyTransparent() then
                                    t7.PendingScreenSpeedPowerDelta += v26

                                    if t7.NextScreenPopupAt <= ServerTimeNow then
                                        if not (t7.PendingScreenSpeedPowerDelta <= 0) then
                                            local PendingScreenSpeedPowerDelta = t7.PendingScreenSpeedPowerDelta
                                            local Play = SpeedGainPopup.Play
                                            local v27 = if v2 == nil or Treadmill == nil then SpeedValue else Treadmill
                                            local t8 = t7

                                            Play(v27, PendingScreenSpeedPowerDelta, nil, function() -- line: 204
                                                -- upvalues: PendingScreenSpeedPowerDelta (copy), t8 (copy), SpeedPowerProjection (copy)
                                                SpeedPowerProjection.CreditRevealedGain(t8.Token, PendingScreenSpeedPowerDelta)
                                            end)
                                            t7.PendingScreenSpeedPowerDelta = 0
                                        end

                                        t7.NextScreenPopupAt = ServerTimeNow + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL
                                    end
                                else
                                    t7.PendingScreenSpeedPowerDelta = 0
                                    t7.NextScreenPopupAt = ServerTimeNow + TreadmillUtil.TREADMILL_SPEED_GAIN_INTERVAL

                                    local PlayWalk = SpeedGainPopup.PlayWalk
                                    local v28 = if v2 == nil or Treadmill == nil then SpeedValue else Treadmill
                                    local RarityColor = t7.RarityColor
                                    local t9 = t7

                                    PlayWalk(v28, v26, RarityColor, function() -- line: 233
                                        -- upvalues: v26 (copy), t9 (copy), SpeedPowerProjection (copy)
                                        SpeedPowerProjection.CreditRevealedGain(t9.Token, v26)
                                    end)
                                end

                                t7 = t2

                                if t7 ~= nil and t7.Token == v23 then
                                    local v29 = TreadmillUtil.SpeedPowerToProgressionWalkSpeed(t7.SimulatedSpeedPower)

                                    t7.NextSpeedAwardAt = NextSpeedAwardAt + TreadmillUtil.ResolveWalkSpeedPowerAwardInterval(v29)
                                    continue
                                end

                                return
                            end

                            continue
                        end
                    end

                    return
                end
            end)
        end

        EggState.CarryChanged:Connect(function(p18) -- line: 336
            -- upvalues: n3 (ref), updateSpeedPower (copy)
            n3 = p18.SpeedMultiplier
            updateSpeedPower()
        end)
        Save.Await()
        SpeedGainPopup.HideSource()
        TreadmillVideoController.Stop()
        TreadmillCharacterPresentationController.StopCameraTransparency()
        updateSpeedPower()
        n2 += 1

        local v30 = n2

        if updateTemporarySpeedBoostDisplay() then
            task.spawn(function() -- line: 152
                -- upvalues: n2 (ref), updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy), v30 (copy)
                while true do
                    if v30 == n2 then
                        task.wait(1)

                        if updateTemporarySpeedBoostDisplay() then
                            updateSpeedPower()
                            continue
                        end

                        break
                    end

                    return
                end

                updateSpeedPower()
            end)
        end

        if Treadmill2 ~= nil then
            RunService.RenderStepped:Connect(function(p19) -- line: 353
                -- upvalues: Treadmill2 (copy)
                Treadmill2.Rotation = (Treadmill2.Rotation + p19 * 20) % 360
            end)
        end

        SpeedPowerProjection.Changed:Connect(updateSpeedPower)
        Save.WatchFields("SpeedBoostTierIndex", updateSpeedPower)
        Save.WatchFields({ "EquippedTrail", "TrailInventory" }, updateSpeedPower)
        AdminBoosts.Observe(AdminBoosts.SPEED):Connect(updateSpeedPower)
        BossMasteryFlags.TreadmillBoostMultiplier.Changed:Connect(function() -- line: 363
            -- upvalues: updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy)
            updateSpeedPower()
            updateTemporarySpeedBoostDisplay()
        end)
        Save.WatchFields("TemporarySpeedBoostRemainingSeconds", function() -- line: 367
            -- upvalues: n2 (ref), updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy)
            updateSpeedPower()
            n2 += 1

            local v31 = n2

            if updateTemporarySpeedBoostDisplay() then
                task.spawn(function() -- line: 152
                    -- upvalues: v31 (copy), n2 (ref), updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy)
                    while true do
                        if v31 == n2 then
                            task.wait(1)

                            if updateTemporarySpeedBoostDisplay() then
                                updateSpeedPower()
                                continue
                            end

                            break
                        end

                        return
                    end

                    updateSpeedPower()
                end)
            end
        end)
        Save.WatchFields("TemporarySpeedBoostActiveStartedAt", function() -- line: 371
            -- upvalues: n2 (ref), updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy)
            updateSpeedPower()
            n2 += 1

            local v32 = n2

            if updateTemporarySpeedBoostDisplay() then
                task.spawn(function() -- line: 152
                    -- upvalues: v32 (copy), n2 (ref), updateSpeedPower (copy), updateTemporarySpeedBoostDisplay (copy)
                    while true do
                        if v32 == n2 then
                            task.wait(1)

                            if updateTemporarySpeedBoostDisplay() then
                                updateSpeedPower()
                                continue
                            end

                            break
                        end

                        return
                    end

                    updateSpeedPower()
                end)
            end
        end)
        Remotes.Treadmill.SpeedGained.OnClientEvent:Connect(handleServerSpeedGain)

        local v33 = Preferences.IsOn("DisableVideos")

        Preferences.Observe("DisableVideos", function(p20) -- line: 379
            -- upvalues: v2 (ref), v33 (ref), Save (copy), Preferences (copy), TreadmillVideoController (copy), TreadmillVideoGate (copy)
            if p20 == v33 then
                return
            end

            v33 = p20

            local v34 = v2

            if v34 == nil or Preferences.IsOn("DisableVideos") or TreadmillVideoGate.IsVideoPlayerDisabled() then
                TreadmillVideoController.Stop()

                return
            end

            local v35 = Save.Await()

            assert(v35 ~= nil, "Save data must be loaded before enabling treadmill videos")
            TreadmillVideoController.Start(v34, v35.TreadmillMediaFeedState)
        end)
        TreadmillVideoGate.Changed:Connect(function() -- line: 387
            -- upvalues: v2 (ref), Save (copy), Preferences (copy), TreadmillVideoController (copy), TreadmillVideoGate (copy)
            local v37 = v2

            if v37 == nil or Preferences.IsOn("DisableVideos") or TreadmillVideoGate.IsVideoPlayerDisabled() then
                TreadmillVideoController.Stop()

                return
            end

            local v38 = Save.Await()

            assert(v38 ~= nil, "Save data must be loaded before enabling treadmill videos")
            TreadmillVideoController.Start(v37, v38.TreadmillMediaFeedState)
        end)
        Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p21, p22, p23, p24) -- line: 392
            -- upvalues: v1 (ref), v2 (ref), n1 (ref), t2 (ref), updateSpeedPower (copy), applyTreadmillVideoSetting (copy), startActiveTreadmillVisualSimulation (copy), SpeedPowerProjection (copy), TreadmillCharacterPresentationController (copy), Visibility (copy), TreadmillVideoController (copy), Treadmills (copy)
            v2 = p21
            v1 = false

            if p21 ~= nil then
                assert(typeof(p22) == "number", "Active treadmill speed multiplier must be a number")
                assert(typeof(p23) == "number", "Active treadmill next award time must be a number")
                assert(typeof(p24) == "table", "Active treadmill media feed state must be a table")

                local v43 = Treadmills.GetById(p21)

                assert(v43 ~= nil, (("Treadmill \"%*\" does not exist"):format(p21)))

                local Color = v43.Rarity.Color

                updateSpeedPower()
                Visibility.Apply(true)
                startActiveTreadmillVisualSimulation(p22, p23, Color)
                TreadmillCharacterPresentationController.StartCameraTransparency(p21)
                applyTreadmillVideoSetting(p24)
            else
                local t10 = t2

                if t10 ~= nil then
                    SpeedPowerProjection.CloseSession(t10.Token)
                end

                n1 += 1
                t2 = nil
                updateSpeedPower()
                TreadmillVideoController.Stop()
                TreadmillCharacterPresentationController.StopCameraTransparency()
                Visibility.Apply(false)
            end
        end)
        UserInputService.JumpRequest:Connect(function() -- line: 433
            -- upvalues: v1 (ref), v2 (ref), Remotes (copy)
            if v2 == nil or v1 then
                return
            end

            v1 = true

            if Remotes.Treadmill.AskDoff:InvokeServer() ~= true then
                v1 = false
            end
        end)
    end
}
