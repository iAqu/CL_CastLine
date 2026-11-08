-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetViewport = require(ReplicatedStorage.Client.AssetViewport)
local GUI = require(ReplicatedStorage.Client.GUI)

return {
    Start = function() -- Start | line: 22
        -- upvalues: ProximityPromptService (copy), ReplicatedStorage (copy), TweenService (copy), Workspace (copy), Assets (copy), AssetViewport (copy), GUI (copy)
        local OnboardingQuestline = ReplicatedStorage.Data:FindFirstChild("OnboardingQuestline")

        if OnboardingQuestline == nil then
            return
        end

        local v1 = require(OnboardingQuestline)
        local OnboardingQuestlineFlags = require(ReplicatedStorage.Shared.Flags.OnboardingQuestlineFlags)
        local OnboardingQuestline2 = require(ReplicatedStorage.Shared.Types.OnboardingQuestline)
        local Remotes = require(ReplicatedStorage.Shared.Remotes)
        local Save = require(ReplicatedStorage.Shared.Save)
        local Audio = require(ReplicatedStorage.Shared.Audio)
        local Tabs = require(ReplicatedStorage.Client.Tabs)
        local Time = require(ReplicatedStorage.Shared.Utils.Time)
        local ProfileKey = v1.ProfileKey
        local v2 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v3 = GUI.Get(v1.ScreenName)
        local v4 = v3:WaitForChild(v1.ApiFolderName)
        local FTUEQuestMain = v3:WaitForChild("FTUEQuestMain")
        local Content = FTUEQuestMain:WaitForChild("Content")
        local Info1 = Content:WaitForChild("Info1")
        local Info2 = Content:WaitForChild("Info2")
        local Text = Info1.Text
        local Text2 = Info2.Text

        local function apiEvent(p1) -- line: 69
            -- upvalues: v4 (copy)
            local v5 = v4:WaitForChild(p1)

            assert(v5:IsA("BindableEvent"), (("RescueDragonAPI.%* must be a BindableEvent"):format(p1)))

            return v5
        end

        local Open = v4:WaitForChild("Open")

        assert(Open:IsA("BindableEvent"), "RescueDragonAPI.Open must be a BindableEvent")

        local Close = v4:WaitForChild("Close")

        assert(Close:IsA("BindableEvent"), "RescueDragonAPI.Close must be a BindableEvent")

        local LoadQuestSet = v4:WaitForChild("LoadQuestSet")

        assert(LoadQuestSet:IsA("BindableEvent"), "RescueDragonAPI.LoadQuestSet must be a BindableEvent")

        local SetQuest = v4:WaitForChild("SetQuest")

        assert(SetQuest:IsA("BindableEvent"), "RescueDragonAPI.SetQuest must be a BindableEvent")

        local ClaimQuest = v4:WaitForChild("ClaimQuest")

        assert(ClaimQuest:IsA("BindableEvent"), "RescueDragonAPI.ClaimQuest must be a BindableEvent")

        local UnlockNextLock = v4:WaitForChild("UnlockNextLock")

        assert(UnlockNextLock:IsA("BindableEvent"), "RescueDragonAPI.UnlockNextLock must be a BindableEvent")

        local ResetAll = v4:WaitForChild("ResetAll")

        assert(ResetAll:IsA("BindableEvent"), "RescueDragonAPI.ResetAll must be a BindableEvent")

        local ClaimClicked = v4:WaitForChild("ClaimClicked")

        assert(ClaimClicked:IsA("BindableEvent"), "RescueDragonAPI.ClaimClicked must be a BindableEvent")

        local GoNowClicked = v4:WaitForChild("GoNowClicked")

        assert(GoNowClicked:IsA("BindableEvent"), "RescueDragonAPI.GoNowClicked must be a BindableEvent")

        local CloseClicked = v4:WaitForChild("CloseClicked")

        assert(CloseClicked:IsA("BindableEvent"), "RescueDragonAPI.CloseClicked must be a BindableEvent")

        local LockUnlocked = v4:WaitForChild("LockUnlocked")

        assert(LockUnlocked:IsA("BindableEvent"), "RescueDragonAPI.LockUnlocked must be a BindableEvent")

        local AllLocksUnlocked = v4:WaitForChild("AllLocksUnlocked")

        assert(AllLocksUnlocked:IsA("BindableEvent"), "RescueDragonAPI.AllLocksUnlocked must be a BindableEvent")

        local v7
        local n1 = 0
        local v8 = {}
        local t2 = {}
        local v9 = true
        local v10 = false
        local n2 = 0
        local v11 = false
        local v12
        local v13 = false
        local v14, v15, v16
        local t3 = {}

        local function now() -- line: 107
            -- upvalues: Workspace (copy)
            return Workspace:GetServerTimeNow()
        end

        local function currentState() -- line: 111
            -- upvalues: OnboardingQuestline2 (copy), Save (copy), ProfileKey (copy)
            local v17 = Save.Await()

            return if v17 then OnboardingQuestline2.Reconcile(v17[ProfileKey]) else nil
        end

        local function acknowledge(p2) -- line: 116
            -- upvalues: Remotes (copy)
            task.spawn(function() -- line: 117
                -- upvalues: p2 (copy), Remotes (copy)
                local function v18() -- line: 118
                    -- upvalues: p2 (copy), Remotes (copy)
                    Remotes.OnboardingQuestline.AskAcknowledge:InvokeServer(p2)
                end

                pcall(v18)
            end)
        end

        local function renderTimer(p3) -- line: 126
            -- upvalues: v1 (copy), Time (copy), v16 (ref), Workspace (copy)
            local v19 = v16

            if v19 ~= nil then
                if p3.RewardGranted then
                    v19.Text = "RESCUED!"
                else
                    local v20 = v1.ExpiresAt(p3) - Workspace:GetServerTimeNow()

                    if v20 <= 0 then
                        v19.Text = "EXPIRED"
                    else
                        v19.Text = ("%* LEFT"):format((Time.Elapsed(v20)))
                    end
                end
            end
        end

        local function playCue(p4, p5, p6) -- line: 143
            -- upvalues: v1 (copy), Audio (copy)
            local v21 = v1.Sounds[p4]

            assert(v21 ~= nil, (("no sound slot named %* in OnboardingQuestline.Sounds"):format(p4)))

            if v21 == 0 then
                return nil
            end

            return Audio.Play(v21, p5 or script, p6 or {})
        end

        local function applyCageLocks(p7, p8) -- line: 156
            -- upvalues: v2 (copy), t3 (ref), TweenService (copy)
            for v24, v25 in t3 do
                local v26 = v24 <= p7

                if v26 then
                    if p8 and v25.LocalTransparencyModifier < 1 then
                        TweenService:Create(v25, v2, {
                            LocalTransparencyModifier = 1
                        }):Play()
                    else
                        v25.LocalTransparencyModifier = 1
                    end
                else
                    v25.LocalTransparencyModifier = 0
                end

                v25.CanCollide = not v26
            end
        end

        local function showRewardScreen() -- line: 171
            -- upvalues: v1 (copy), Tabs (copy), Assets (copy), GUI (copy)
            local GenericRewardScreen2 = GUI.PlayerGui():FindFirstChild("GenericRewardScreen2")

            assert(GenericRewardScreen2 ~= nil, "PlayerGui is missing GenericRewardScreen2")

            local ShowReward = GenericRewardScreen2:FindFirstChild("ShowReward")

            assert(ShowReward ~= nil and ShowReward:IsA("BindableEvent"), "GenericRewardScreen2 has no ShowReward event; its RewardController did not start")

            local v29 = Assets.Directory[v1.RewardAssetId]

            assert(v29 ~= nil, (("no asset config for %*"):format(v1.RewardAssetId)))
            Tabs.Deactivate({
                instant = true
            })
            ShowReward:Fire({
                autoClose = 0,
                title = v1.TitleComplete,
                item = v29.DisplayName,
                rarity = v29.Rarity._id,
                image = v29.Icon
            })
        end

        local function setRescuedPresentation(p9) -- line: 194
            -- upvalues: v1 (copy), Info1 (copy), Info2 (copy), Text (copy), Text2 (copy)
            Info1.Text = if p9 then v1.TitleComplete else Text
            Info2.Text = if p9 then v1.SubtitleComplete else Text2
        end

        local function renderEntryPoints(p10) -- line: 199
            -- upvalues: v1 (copy), v14 (ref), v15 (ref), now (copy)
            local v34 = v1.ShouldShowEntryPoint(p10, now())
            local v35 = v14

            if v35 ~= nil then
                v35.Enabled = v34 and not p10.RewardGranted
            end

            local v36 = v15

            if v36 ~= nil then
                v36.Enabled = v34
            end
        end

        local function loadSet(p11) -- line: 213
            -- upvalues: v1 (copy), LoadQuestSet (copy), n1 (ref), v8 (ref), t2 (ref)
            local v37 = v1.BuildQuestRows(p11)

            n1 = p11.SetIndex
            v8 = v37
            t2 = {}

            for v38, v39 in v1.GetActiveQuests(p11) or {} do
                local t4 = t2

                t4[v38] = v39.Id
            end

            LoadQuestSet:Fire(v37)
        end

        local function everyRowClaimed() -- line: 226
            -- upvalues: v8 (ref)
            if #v8 == 0 then
                return false
            end

            for _, v40 in v8 do
                if v40.State ~= "Claimed" then
                    return false
                end
            end

            return true
        end

        local function claimRow(p12, p13) -- line: 241
            -- upvalues: v1 (copy), Audio (copy), ClaimQuest (copy), v8 (ref), v10 (ref)
            local v41 = v8

            v41[p12] = p13

            local QuestClaimed = v1.Sounds.QuestClaimed

            assert(QuestClaimed ~= nil, "no sound slot named QuestClaimed in OnboardingQuestline.Sounds")

            if QuestClaimed ~= 0 then
                Audio.Play(QuestClaimed, script, {})
            end

            ClaimQuest:Fire(p12)

            local v43

            if #v8 == 0 then
                v43 = false
            else
                local v44 = false

                for _, v45 in v8 do
                    if v45.State ~= "Claimed" then
                        v43 = false
                        v44 = true
                        break
                    end
                end

                if not v44 then
                    v43 = true
                end
            end

            if not v43 then
                return
            end

            v10 = true

            local KeyEarned = v1.Sounds.KeyEarned

            assert(KeyEarned ~= nil, "no sound slot named KeyEarned in OnboardingQuestline.Sounds")

            if KeyEarned == 0 then
                return
            end

            Audio.Play(KeyEarned, script, {})
        end

        local function pushRows(p14) -- line: 252
            -- upvalues: v1 (copy), Audio (copy), SetQuest (copy), ClaimQuest (copy), v8 (ref), v10 (ref)
            for v47, v48 in p14 do
                local v49 = v8[v47]

                if v49 ~= nil then
                    if v48.State ~= "Claimed" or v49.State == "Claimed" then
                        if v49.Current ~= v48.Current or v49.State ~= v48.State or v49.ProgressText ~= v48.ProgressText then
                            local t8 = {
                                Current = v48.Current,
                                Goal = v48.Goal,
                                ProgressText = v48.ProgressText
                            }

                            if v49.State ~= v48.State then
                                t8.State = v48.State
                            end

                            local v59 = v8

                            v59[v47] = v48
                            SetQuest:Fire(v47, t8)
                        end
                    else
                        local v52 = v8

                        v52[v47] = v48

                        local QuestClaimed = v1.Sounds.QuestClaimed

                        assert(QuestClaimed ~= nil, "no sound slot named QuestClaimed in OnboardingQuestline.Sounds")

                        if QuestClaimed ~= 0 then
                            Audio.Play(QuestClaimed, script, {})
                        end

                        ClaimQuest:Fire(v47)

                        local v54

                        if #v8 == 0 then
                            v54 = false
                        else
                            local v55 = false

                            for _, v56 in v8 do
                                if v56.State ~= "Claimed" then
                                    v54 = false
                                    v55 = true
                                    break
                                end
                            end

                            if not v55 then
                                v54 = true
                            end
                        end

                        if v54 then
                            v10 = true

                            local KeyEarned = v1.Sounds.KeyEarned

                            assert(KeyEarned ~= nil, "no sound slot named KeyEarned in OnboardingQuestline.Sounds")

                            if KeyEarned ~= 0 then
                                Audio.Play(KeyEarned, script, {})
                            end
                        end
                    end
                end
            end
        end

        local function reconcile(p15) -- line: 283
            -- upvalues: v1 (copy), Audio (copy), Time (copy), ClaimQuest (copy), v7 (ref), n1 (ref), v8 (ref), v9 (ref), v10 (ref), n2 (ref), v12 (ref), v14 (ref), v15 (ref), v16 (ref), now (copy), pushRows (copy), Workspace (copy)
            v7 = p15

            local v60 = v1.ShouldShowEntryPoint(p15, now())
            local v61 = v14

            if v61 ~= nil then
                v61.Enabled = v60 and not p15.RewardGranted
            end

            local v62 = v15

            if v62 ~= nil then
                v62.Enabled = v60
            end

            local v63 = v16

            if v63 ~= nil then
                if p15.RewardGranted then
                    v63.Text = "RESCUED!"
                else
                    local v64 = v1.ExpiresAt(p15) - Workspace:GetServerTimeNow()

                    if v64 <= 0 then
                        v63.Text = "EXPIRED"
                    else
                        v63.Text = ("%* LEFT"):format((Time.Elapsed(v64)))
                    end
                end
            end

            if not (v9 or v10) then
                if p15.SetIndex == n1 then
                    local v65 = n2

                    if v65 == math.min(p15.UnlockedPadlocks, v1.PadlockCount) then
                        if not v1.IsComplete(p15) then
                            pushRows(v1.BuildQuestRows(p15))
                        end
                    else
                        v12(p15)
                    end
                else
                    local v66 = p15.SetIndex == n1 + 1
                    local v67

                    if v66 then
                        v67 = false

                        for v68, v69 in v8 do
                            if v69.State ~= "Claimed" then
                                local v70 = table.clone(v69)

                                v70.State = "Claimed"
                                v70.Current = v70.Goal
                                v70.ProgressText = v69.ProgressText

                                local v71 = v8

                                v71[v68] = v70

                                local QuestClaimed = v1.Sounds.QuestClaimed

                                assert(QuestClaimed ~= nil, "no sound slot named QuestClaimed in OnboardingQuestline.Sounds")

                                if QuestClaimed ~= 0 then
                                    Audio.Play(QuestClaimed, script, {})
                                end

                                ClaimQuest:Fire(v68)

                                local v73

                                if #v8 == 0 then
                                    v73 = false
                                else
                                    local v74 = false

                                    for _, v75 in v8 do
                                        if v75.State ~= "Claimed" then
                                            v73 = false
                                            v74 = true
                                            break
                                        end
                                    end

                                    if not v74 then
                                        v73 = true
                                    end
                                end

                                if v73 then
                                    v10 = true

                                    local KeyEarned = v1.Sounds.KeyEarned

                                    assert(KeyEarned ~= nil, "no sound slot named KeyEarned in OnboardingQuestline.Sounds")

                                    if KeyEarned ~= 0 then
                                        Audio.Play(KeyEarned, script, {})
                                    end
                                end

                                v67 = true
                            end
                        end
                    end

                    if not v66 or not v67 then
                        v12(p15)
                    end
                end
            end
        end

        v12 = function(p16) -- line: 334
            -- upvalues: v1 (copy), Info1 (copy), Info2 (copy), Text (copy), Text2 (copy), UnlockNextLock (copy), ResetAll (copy), n1 (ref), v9 (ref), v10 (ref), n2 (ref), v13 (ref), applyCageLocks (copy), loadSet (copy), reconcile (copy)
            v9 = true
            v10 = false
            v13 = p16.RewardGranted

            local v77 = v13

            Info1.Text = if v77 then v1.TitleComplete else Text
            Info2.Text = if v77 then v1.SubtitleComplete else Text2
            ResetAll:Fire()
            n2 = math.min(p16.UnlockedPadlocks, v1.PadlockCount)

            for _ = 1, n2 do
                UnlockNextLock:Fire()
            end

            applyCageLocks(n2, false)

            if v1.IsComplete(p16) then
                n1 = p16.SetIndex
            else
                loadSet(p16)
            end

            v9 = false
            reconcile(p16)
        end

        local function openMenu() -- line: 359
            -- upvalues: v1 (copy), Tabs (copy), Open (copy), v7 (ref), v10 (ref), n2 (ref), v11 (ref), v12 (ref), now (copy)
            local v81 = v7
            local v82 = true

            if v81 ~= nil then
                if v1.ShouldShowEntryPoint(v81, now()) then
                    if not v10 then
                        local v83 = n2

                        if v83 ~= math.min(v81.UnlockedPadlocks, v1.PadlockCount) then
                            v12(v81)
                        end
                    end

                    v82 = false
                end
            end

            if v82 then
                return
            end

            Tabs.Deactivate({
                instant = true
            })
            v11 = true
            Open:Fire()
        end

        local function closeMenu() -- line: 379
            -- upvalues: v1 (copy), Audio (copy), Close (copy), v11 (ref)
            if not v11 then
                return
            end

            v11 = false
            Close:Fire()

            local CloseFrame = v1.Sounds.CloseFrame

            assert(CloseFrame ~= nil, "no sound slot named CloseFrame in OnboardingQuestline.Sounds")

            if CloseFrame ~= 0 then
                Audio.Play(CloseFrame, script, {})
            end
        end

        local function claim(p17) -- line: 388
            -- upvalues: v1 (copy), Remotes (copy), Audio (copy), t2 (ref)
            local v85 = t2[p17]

            if v85 ~= nil then
                task.spawn(function() -- line: 394
                    -- upvalues: v85 (copy), v1 (copy), Remotes (copy), Audio (copy)
                    local function v86() -- line: 395
                        -- upvalues: v85 (copy), Remotes (copy)
                        return Remotes.OnboardingQuestline.AskClaim:InvokeServer(v85)
                    end

                    local v87, v88, v89 = pcall(v86)

                    if not v87 then
                        warn((("[OnboardingQuestline] claim request failed: %*"):format(v88)))

                        return
                    end

                    if not v88 then
                        local Warning = v1.Sounds.Warning

                        assert(Warning ~= nil, "no sound slot named Warning in OnboardingQuestline.Sounds")

                        if Warning ~= 0 then
                            Audio.Play(Warning, script, {})
                        end

                        warn((("[OnboardingQuestline] claim rejected: %*"):format((tostring(v89)))))
                    end
                end)
            end
        end

        local function bindCagePrompt() -- line: 409
            -- upvalues: v1 (copy), Time (copy), v7 (ref), n2 (ref), v14 (ref), v15 (ref), v16 (ref), t3 (ref), now (copy), applyCageLocks (copy), Workspace (copy), AssetViewport (copy)
            local v91 = Workspace:FindFirstChild(v1.CageModelName)

            if v91 == nil then
                return
            end

            local v92 = v91:FindFirstChild("RescueDragonPrompt", true)

            assert(v92 ~= nil and v92:IsA("ProximityPrompt"), (("Workspace.%* needs a ProximityPrompt named RescueDragonPrompt"):format(v1.CageModelName)))
            v14 = v92
            v92.Enabled = false

            local v95 = v91:FindFirstChild("RescueDragonTimer", true)

            assert(v95 ~= nil and v95:IsA("BillboardGui"), (("Workspace.%* needs a BillboardGui named RescueDragonTimer"):format(v1.CageModelName)))

            local v98 = v95:FindFirstChild("Countdown", true)

            assert(v98 ~= nil and v98:IsA("TextLabel"), "RescueDragonTimer needs a TextLabel named Countdown")
            v15 = v95
            v16 = v98
            v95.Enabled = false

            local CagedDragon = v91:FindFirstChild("CagedDragon")

            assert(CagedDragon ~= nil and CagedDragon:IsA("Model"), (("Workspace.%* needs a Model named CagedDragon"):format(v1.CageModelName)))
            AssetViewport.LoopIdle(v1.RewardAssetId, CagedDragon)
            t3 = {}

            for i = 1, v1.PadlockCount do
                local v102 = v91:FindFirstChild("Lock" .. i)

                assert(v102 ~= nil and v102:IsA("BasePart"), (("Workspace.%* needs a padlock part named Lock%*"):format(v1.CageModelName, i)))

                local t9 = t3

                t9[i] = v102
            end

            applyCageLocks(n2, false)

            local v105 = v7

            if v105 == nil then
                return
            end

            local v106 = v1.ShouldShowEntryPoint(v105, now())
            local v107 = v14

            if v107 ~= nil then
                v107.Enabled = v106 and not v105.RewardGranted
            end

            local v108 = v15

            if v108 ~= nil then
                v108.Enabled = v106
            end

            local v109 = v16

            if v109 ~= nil then
                if v105.RewardGranted then
                    v109.Text = "RESCUED!"
                else
                    local v110 = v1.ExpiresAt(v105) - Workspace:GetServerTimeNow()

                    if v110 <= 0 then
                        v109.Text = "EXPIRED"
                    else
                        v109.Text = ("%* LEFT"):format((Time.Elapsed(v110)))
                    end
                end
            end
        end

        ClaimClicked.Event:Connect(claim)
        GoNowClicked.Event:Connect(function() -- line: 467
            -- upvalues: v1 (copy), Audio (copy), Close (copy), v11 (ref)
            if not v11 then
                return
            end

            v11 = false
            Close:Fire()

            local CloseFrame = v1.Sounds.CloseFrame

            assert(CloseFrame ~= nil, "no sound slot named CloseFrame in OnboardingQuestline.Sounds")

            if CloseFrame ~= 0 then
                Audio.Play(CloseFrame, script, {})
            end
        end)
        CloseClicked.Event:Connect(function() -- line: 473
            -- upvalues: v1 (copy), Audio (copy), v11 (ref)
            v11 = false

            local CloseFrame = v1.Sounds.CloseFrame

            assert(CloseFrame ~= nil, "no sound slot named CloseFrame in OnboardingQuestline.Sounds")

            if CloseFrame ~= 0 then
                Audio.Play(CloseFrame, script, {})
            end
        end)
        LockUnlocked.Event:Connect(function() -- line: 478
            -- upvalues: v1 (copy), v7 (ref), n1 (ref), v9 (ref), v10 (ref), n2 (ref), applyCageLocks (copy), loadSet (copy), reconcile (copy)
            if v9 then
                return
            end

            n2 += 1
            applyCageLocks(n2, true)
            task.wait(0.4)

            local v113 = v7

            if v113 ~= nil then
                if v1.IsComplete(v113) then
                    n1 = v113.SetIndex
                else
                    loadSet(v113)
                end
            end

            v10 = false

            if v113 ~= nil then
                reconcile(v113)
            end
        end)
        AllLocksUnlocked.Event:Connect(function() -- line: 503
            -- upvalues: v1 (copy), Remotes (copy), Audio (copy), Info1 (copy), Info2 (copy), Close (copy), v9 (ref), v11 (ref), v13 (ref), showRewardScreen (copy)
            if v9 or v13 then
                return
            end

            v13 = true
            Info1.Text = v1.TitleComplete
            Info2.Text = v1.SubtitleComplete

            if v11 then
                v11 = false
                Close:Fire()

                local CloseFrame = v1.Sounds.CloseFrame

                assert(CloseFrame ~= nil, "no sound slot named CloseFrame in OnboardingQuestline.Sounds")

                if CloseFrame ~= 0 then
                    Audio.Play(CloseFrame, script, {})
                end
            end

            showRewardScreen()

            local t10 = {
                Reward = true
            }

            task.spawn(function() -- line: 117
                -- upvalues: t10 (copy), Remotes (copy)
                local function v115() -- line: 118
                    -- upvalues: t10 (copy), Remotes (copy)
                    Remotes.OnboardingQuestline.AskAcknowledge:InvokeServer(t10)
                end

                pcall(v115)
            end)
        end)
        FTUEQuestMain.ChildAdded:Connect(function(p18) -- line: 517
            -- upvalues: v1 (copy), Audio (copy)
            if p18.Name == "FlyingKey" then
                local KeyFlight = v1.Sounds.KeyFlight

                assert(KeyFlight ~= nil, "no sound slot named KeyFlight in OnboardingQuestline.Sounds")

                if KeyFlight == 0 then
                    return
                end

                Audio.Play(KeyFlight, script, {})
            end
        end)
        FTUEQuestMain.ChildRemoved:Connect(function(p19) -- line: 525
            -- upvalues: v1 (copy), Audio (copy)
            if p19.Name == "FlyingKey" then
                local KeyTurn = v1.Sounds.KeyTurn

                assert(KeyTurn ~= nil, "no sound slot named KeyTurn in OnboardingQuestline.Sounds")

                if KeyTurn == 0 then
                    return
                end

                Audio.Play(KeyTurn, script, {})
            end
        end)

        for i = 1, v1.PadlockCount do
            local ChildAdded = FTUEQuestMain:FindFirstChild("Lock" .. i)

            assert(ChildAdded ~= nil, (("FTUEQuestMain needs a Lock%* frame"):format(i)))
            ChildAdded = ChildAdded.ChildAdded
            ChildAdded:Connect(function(p20) -- line: 534
                -- upvalues: v1 (copy), Audio (copy), t3 (ref), applyCageLocks (copy), i (copy)
                if p20.Name == "LockUnlockedAnim" then
                    local LockBreak = v1.Sounds.LockBreak

                    assert(LockBreak ~= nil, "no sound slot named LockBreak in OnboardingQuestline.Sounds")

                    if LockBreak ~= 0 then
                        Audio.Play(LockBreak, script, {})
                    end

                    local v121 = t3[i]

                    if v121 ~= nil then
                        local t11 = {
                            MaxDistance = 90
                        }
                        local LockBreak = v1.Sounds.LockBreak

                        assert(LockBreak ~= nil, "no sound slot named LockBreak in OnboardingQuestline.Sounds")

                        if LockBreak ~= 0 then
                            Audio.Play(LockBreak, v121 or script, t11 or {})
                        end
                    end

                    applyCageLocks(i, true)
                end
            end)
        end

        Tabs.Activated:Connect(function() -- line: 552
            -- upvalues: v1 (copy), Audio (copy), Close (copy), v11 (ref)
            if not v11 then
                return
            end

            v11 = false
            Close:Fire()

            local CloseFrame = v1.Sounds.CloseFrame

            assert(CloseFrame ~= nil, "no sound slot named CloseFrame in OnboardingQuestline.Sounds")

            if CloseFrame ~= 0 then
                Audio.Play(CloseFrame, script, {})
            end
        end)
        ProximityPromptService.PromptTriggered:Connect(function(p21) -- line: 556
            -- upvalues: v14 (ref), openMenu (copy)
            if p21 == v14 then
                openMenu()
            end
        end)
        OnboardingQuestlineFlags.Enabled.Changed:Connect(function(p22) -- line: 563
            -- upvalues: v1 (copy), Audio (copy), Close (copy), v7 (ref), v11 (ref), v14 (ref), v15 (ref), now (copy)
            local CloseFrame, v124

            if not p22 and v11 then
                v11 = false
                Close:Fire()
                CloseFrame = v1.Sounds.CloseFrame
                v124 = CloseFrame ~= nil
                assert(v124, "no sound slot named CloseFrame in OnboardingQuestline.Sounds")

                if CloseFrame ~= 0 then
                    Audio.Play(CloseFrame, script, {})
                end
            end

            local v125 = v7

            if v125 == nil then
                return
            end

            local v126 = v1.ShouldShowEntryPoint(v125, now())
            local v127 = v14

            if v127 ~= nil then
                v127.Enabled = v126 and not v125.RewardGranted
            end

            local v128 = v15

            if v128 ~= nil then
                v128.Enabled = v126
            end
        end)
        OnboardingQuestlineFlags.QuestTargets.Changed:Connect(function() -- line: 574
            -- upvalues: v7 (ref), v9 (ref), v10 (ref), v12 (ref)
            local v129 = v7

            if v129 ~= nil and not v9 and not v10 then
                v12(v129)
            end
        end)
        Workspace.ChildAdded:Connect(function(p23) -- line: 581
            -- upvalues: v1 (copy), bindCagePrompt (copy)
            if p23.Name == v1.CageModelName then
                task.defer(bindCagePrompt)
            end
        end)
        bindCagePrompt()
        task.spawn(function() -- line: 588
            -- upvalues: v1 (copy), Time (copy), v7 (ref), v14 (ref), v15 (ref), v16 (ref), now (copy), Workspace (copy)
            while true do
                local v130 = v7

                if v130 == nil then
                    task.wait(1)
                    continue
                end

                local v131 = v16

                if v131 ~= nil then
                    if v130.RewardGranted then
                        v131.Text = "RESCUED!"
                    else
                        local v132 = v1.ExpiresAt(v130) - Workspace:GetServerTimeNow()

                        if v132 <= 0 then
                            v131.Text = "EXPIRED"
                        else
                            v131.Text = ("%* LEFT"):format((Time.Elapsed(v132)))
                        end
                    end
                end

                local v133 = v1.ShouldShowEntryPoint(v130, now())
                local v134 = v14

                if v134 ~= nil then
                    v134.Enabled = v133 and not v130.RewardGranted
                end

                local v135 = v15

                if v135 ~= nil then
                    v135.Enabled = v133
                end

                task.wait(1)
            end
        end)

        local Event = Save.Await()

        AllLocksUnlocked = if Event then OnboardingQuestline2.Reconcile(Event[ProfileKey]) else nil

        if AllLocksUnlocked ~= nil then
            v12(AllLocksUnlocked)

            if OnboardingQuestlineFlags.AutoOpenEnabled:Get() and v1.ShouldShowEntryPoint(AllLocksUnlocked, now()) and v1.HasClaimable(AllLocksUnlocked) then
                task.delay(1.25, function() -- line: 607
                    -- upvalues: Tabs (copy), openMenu (copy)
                    if not Tabs.IsActive() then
                        openMenu()
                    end
                end)
            end
        end

        Save.WatchFields(ProfileKey, function() -- line: 615
            -- upvalues: OnboardingQuestline2 (copy), Save (copy), ProfileKey (copy), v7 (ref), v12 (ref), reconcile (copy)
            local v136 = Save.Await()
            local v137 = if v136 then OnboardingQuestline2.Reconcile(v136[ProfileKey]) else nil

            if v137 ~= nil then
                if v7 ~= nil then
                    reconcile(v137)
                else
                    v12(v137)
                end
            end
        end)
    end
}
