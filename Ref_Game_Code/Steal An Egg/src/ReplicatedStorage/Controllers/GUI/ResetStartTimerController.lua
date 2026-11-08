-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ServerClock = require(game:GetService("ReplicatedStorage").Shared.Util.ServerClock)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local AreaEggResetCycle = require(ReplicatedStorage.Data.AreaEggResetCycle)

require(ReplicatedStorage.Shared.Types.AreaEggResetCycle)

local Audio = require(ReplicatedStorage.Shared.Audio)
local SystemChat = require(ReplicatedStorage.Client.SystemChat)
local EggState = require(ReplicatedStorage.Client.EggState)
local GUI = require(ReplicatedStorage.Client.GUI)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Log = require(ReplicatedStorage.Packages.Log)
local Notifications = require(ReplicatedStorage.Client.Notifications)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local WarmSounds = require(ReplicatedStorage.Shared.Utils.Preload).WarmSounds
local AreaEggResetWall = require(ReplicatedStorage.Client.AreaEggResetWall)
local v1 = TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local TeleportFadeSeconds, TeleportFadeHoldSeconds = AreaEggResetCycle.TeleportFadeSeconds, AreaEggResetCycle.TeleportFadeHoldSeconds
local v2 = TweenInfo.new(TeleportFadeSeconds, Enum.EasingStyle.Linear)
local v3 = TweenInfo.new(AreaEggResetCycle.SleepIconFadeSeconds, Enum.EasingStyle.Quad)
local v4 = TweenInfo.new(AreaEggResetCycle.NightIconFadeOutSeconds, Enum.EasingStyle.Quad)
local v5 = table.freeze({
    [Rarity.Rarities.Eternal._id] = true,
    [Rarity.Rarities.Divine._id] = true
})
local LocalPlayer = Players.LocalPlayer
local v6 = Log.new()

return {
    Start = function() -- Start | line: 66
        -- upvalues: ServerClock (copy), TweenService (copy), Workspace (copy), AreaEggCycle (copy), AreaEggResetCycle (copy), Audio (copy), SystemChat (copy), EggState (copy), GUI (copy), HalloweenDimension (copy), Notifications (copy), WarmSounds (copy), AreaEggResetWall (copy), v1 (copy), TeleportFadeHoldSeconds (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), LocalPlayer (copy), v6 (copy)
        local v7 = GUI.FadeFrame()
        local v8 = GUI.ResetStartTimer()
        local TextLabel, NightTimer = v8.Frame.TextLabel, v8.Frame.NightTimer
        local UIStroke = NightTimer.UIStroke
        local SleepIcon = v8.Frame.SleepIcon
        local v9 = GUI.ResetStartTimerLabelScale()
        local n1 = 0
        local tween
        local n2 = 0
        local tween2, tween3, tween4, tween5, DayStartsAt
        local n3 = (-1e999)
        local n4 = -1

        v8.Adornee = AreaEggResetWall.ResolveWallPart()
        task.spawn(WarmSounds, 117751546358455, 136029417452204)

        local function stopActiveTween() -- line: 93
            -- upvalues: tween (ref)
            if tween == nil then
                return
            end

            tween:Cancel()
            tween = nil
        end

        local function stopActiveFadeTween() -- line: 100
            -- upvalues: tween2 (ref)
            if tween2 == nil then
                return
            end

            tween2:Cancel()
            tween2 = nil
        end

        local function stopActiveNightVisualTweens() -- line: 107
            -- upvalues: tween3 (ref), tween4 (ref), tween5 (ref)
            if tween3 ~= nil then
                tween3:Cancel()
                tween3 = nil
            end

            if tween4 ~= nil then
                tween4:Cancel()
                tween4 = nil
            end

            if tween5 == nil then
                return
            end

            tween5:Cancel()
            tween5 = nil
        end

        local function tweenFadeFrame(p1, p2) -- line: 122
            -- upvalues: v7 (copy), n2 (ref), tween2 (ref), TweenService (copy), v2 (copy)
            if tween2 ~= nil then
                tween2:Cancel()
                tween2 = nil
            end

            local tween = TweenService:Create(v7, v2, {
                BackgroundTransparency = p2
            })

            tween2 = tween
            tween:Play()
            tween.Completed:Wait()

            if p1 ~= n2 then
                return false
            end

            tween2 = nil

            return true
        end

        local function runTeleportFade(p3) -- line: 137
            -- upvalues: n2 (ref), tweenFadeFrame (copy), TeleportFadeHoldSeconds (copy)
            if tweenFadeFrame(p3, 0) then
                task.wait(TeleportFadeHoldSeconds)

                if p3 == n2 then
                    tweenFadeFrame(p3, 1)
                end
            end
        end

        local function setCountdownVisible(p4) -- line: 148
            -- upvalues: TextLabel (copy)
            TextLabel.Visible = p4
        end

        local function tweenNightVisuals(p5, p6) -- line: 150
            -- upvalues: NightTimer (copy), UIStroke (copy), SleepIcon (copy), n1 (ref), tween3 (ref), tween4 (ref), tween5 (ref), TweenService (copy), v3 (copy), v4 (copy)
            if tween3 ~= nil then
                tween3:Cancel()
                tween3 = nil
            end

            if tween4 ~= nil then
                tween4:Cancel()
                tween4 = nil
            end

            if tween5 ~= nil then
                tween5:Cancel()
                tween5 = nil
            end

            local v10 = if p6 == 1 then v4 else v3
            local tween = TweenService:Create(SleepIcon, v10, {
                ImageTransparency = p6
            })
            local tween2 = TweenService:Create(NightTimer, v10, {
                TextTransparency = p6
            })
            local tween6 = TweenService:Create(UIStroke, v10, {
                Transparency = p6
            })

            tween3 = tween
            tween4 = tween2
            tween5 = tween6
            tween:Play()
            tween2:Play()
            tween6:Play()
            tween.Completed:Wait()

            if p5 ~= n1 then
                return false
            end

            tween3 = nil
            tween4 = nil
            tween5 = nil

            return true
        end

        local function animateCount(p7) -- line: 180
            -- upvalues: TextLabel (copy), v9 (copy), tween (ref), TweenService (copy), v1 (copy)
            if tween ~= nil then
                tween:Cancel()
                tween = nil
            end

            TextLabel.Text = tostring(p7)
            v9.Scale = 1.3

            local tween2 = TweenService:Create(v9, v1, {
                Scale = 1
            })

            tween = tween2
            tween2:Play()
        end

        local function isHiddenInDimension(p8) -- line: 191
            -- upvalues: HalloweenDimension (copy), v5 (copy), LocalPlayer (copy)
            if LocalPlayer:GetAttribute(HalloweenDimension.PlayerAttributes.Inside) == true then
                return v5[p8] == nil
            end

            return false
        end

        local function announceRareSpawns(p9) -- line: 196
            -- upvalues: SystemChat (copy), EggState (copy), HalloweenDimension (copy), Notifications (copy), v5 (copy), LocalPlayer (copy)
            for _, v11 in ipairs(p9) do
                local RarityId = v11.RarityId

                if LocalPlayer:GetAttribute(HalloweenDimension.PlayerAttributes.Inside) ~= true or v5[RarityId] ~= nil then
                    SystemChat.Post({
                        Text = v11.Message
                    })
                    Notifications.Toast.Show({
                        Lane = "Banner",
                        Seconds = 4,
                        Text = v11.Message,
                        Color = Color3.new(1, 1, 1),
                        Sound = v11.SoundId
                    })
                end
            end

            EggState.RarityPresented:Fire(p9)
        end

        local function handleRareSpawnReveal(p10) -- line: 213
            -- upvalues: n4 (ref), announceRareSpawns (copy)
            if not (p10.PeriodIndex <= n4) then
                n4 = p10.PeriodIndex
                announceRareSpawns(p10.RareSpawns)
            end
        end

        local function requestJoinRareSpawnPresentations(p11) -- line: 221
            -- upvalues: n4 (ref), announceRareSpawns (copy), requestJoinRareSpawnPresentations (copy), EggState (copy), v6 (copy)
            local v12, v13 = EggState.FetchRarityShows()

            if v12 then
                if v13 ~= nil then
                    if v13.PeriodIndex <= n4 then
                        return
                    end

                    n4 = v13.PeriodIndex
                    announceRareSpawns(v13.RareSpawns)
                end
            elseif p11 >= 30 then
                v6:AtError():Log("Area egg rare spawn join presentation request exhausted profile-readiness retries")
            else
                task.delay(1, function() -- line: 236
                    -- upvalues: p11 (copy), requestJoinRareSpawnPresentations (copy)
                    requestJoinRareSpawnPresentations(p11 + 1)
                end)
            end
        end

        local function runCountdown(p12, p13) -- line: 240
            -- upvalues: v8 (copy), TextLabel (copy), NightTimer (copy), v9 (copy), n1 (ref), tween (ref), DayStartsAt (ref), n3 (ref), tweenNightVisuals (copy), animateCount (copy), ServerClock (copy), AreaEggResetCycle (copy), Audio (copy), Notifications (copy), AreaEggResetWall (copy)
            AreaEggResetWall.ArmReveal()
            v8.Enabled = true
            TextLabel.Visible = false
            task.spawn(AreaEggResetWall.RaiseWall)
            NightTimer.Text = ("%*s"):format((math.max(math.ceil(p13.DayStartsAt - ServerClock.Now()), 1)))

            if tweenNightVisuals(p12, 0) then
                while true do
                    local v16 = ServerClock.Now()
                    local v17 = p13.DayStartsAt - v16

                    if v17 <= 0 then
                        break
                    end

                    local v18 = math.ceil(v17)

                    NightTimer.Text = ("%*s"):format(v18)

                    local v19 = p13.DayStartsAt - (v18 - 1)

                    task.wait((math.max(v19 - v16, 0.05)))

                    if p12 == n1 then
                        continue
                    end

                    return
                end

                if tweenNightVisuals(p12, 1) then
                    local v21 = p13.DayStartsAt + AreaEggResetCycle.WallCountdownDelayAfterDayStartsSeconds

                    task.wait((math.max(v21 - ServerClock.Now(), 0)))

                    if p12 == n1 then
                        Notifications.Toast.Show({
                            Lane = "Banner",
                            Text = "ALL EGG RESET!",
                            Seconds = 3.5
                        })

                        local v23 = AreaEggResetWall.ResolveWallPart()
                        local v24 = v23.Position + v23.CFrame.LookVector * (v23.Size.Z / 2)

                        for i = AreaEggResetCycle.WallCountdownSeconds, 1, -1 do
                            if p12 ~= n1 then
                                return
                            end

                            Audio.Play(117751546358455, v24, {
                                Volume = 2,
                                MaxDistance = 220
                            })
                            animateCount(i)

                            if i == AreaEggResetCycle.WallCountdownSeconds then
                                TextLabel.Visible = true
                            end

                            task.wait(1)
                        end

                        if p12 == n1 then
                            if tween ~= nil then
                                tween:Cancel()
                                tween = nil
                            end

                            v9.Scale = 1
                            Audio.Play(136029417452204, v24, {
                                Volume = 1.5,
                                MaxDistance = 220
                            })
                            TextLabel.Visible = false
                            AreaEggResetWall.DropWall()

                            if p12 ~= n1 then
                                return
                            end

                            v8.Enabled = false
                            n3 = p13.DayStartsAt
                            DayStartsAt = nil
                        end
                    end
                end
            end
        end

        local function startSequence(p14) -- line: 312
            -- upvalues: n1 (ref), DayStartsAt (ref), n3 (ref), runCountdown (copy)
            if p14.DayStartsAt <= n3 then
                return
            end

            local DayStartsAt2 = DayStartsAt

            if (DayStartsAt2 == nil or not (p14.DayStartsAt < DayStartsAt2)) and p14.DayStartsAt ~= DayStartsAt2 then
                DayStartsAt = p14.DayStartsAt
                n1 += 1

                local v25 = n1

                task.spawn(runCountdown, v25, p14)
            end
        end

        v6:AtDebug():Log("Reset start timer controller initialized")
        v8.Enabled = false
        TextLabel.Visible = false
        SleepIcon.ImageTransparency = 1
        NightTimer.TextTransparency = 1
        UIStroke.Transparency = 1
        AreaEggResetWall.ClearWall()
        EggState.ResetFade:Connect(function() -- line: 342
            -- upvalues: n2 (ref), runTeleportFade (copy)
            n2 += 1

            local v26 = n2

            task.spawn(runTeleportFade, v26)
        end)
        EggState.ResetCountdown:Connect(startSequence)
        EggState.RarityRevealed:Connect(handleRareSpawnReveal)
        task.spawn(requestJoinRareSpawnPresentations, 1)
        Workspace:GetAttributeChangedSignal("NightIconOverride"):Connect(function() -- line: 353
            -- upvalues: SleepIcon (copy), Workspace (copy)
            SleepIcon.Image = Workspace:GetAttribute("NightIconOverride") or "rbxassetid://123238464128459"
        end)
        SleepIcon.Image = Workspace:GetAttribute("NightIconOverride") or "rbxassetid://123238464128459"

        local t2, DayStartsAt2, v27

        if AreaEggCycle.IsNightPhase(ServerClock.Now()) then
            t2 = {
                DayStartsAt = AreaEggCycle.NextResetTime(ServerClock.Now())
            }

            if t2.DayStartsAt <= n3 then
                v27 = true
            else
                DayStartsAt2 = DayStartsAt
                v27 = DayStartsAt2 ~= nil and t2.DayStartsAt < DayStartsAt2
            end
        else
            v27 = true
        end

        if v27 or t2.DayStartsAt == DayStartsAt2 then
            return
        end

        DayStartsAt = t2.DayStartsAt
        n1 += 1

        local v28 = n1

        task.spawn(runCountdown, v28, t2)
    end
}
