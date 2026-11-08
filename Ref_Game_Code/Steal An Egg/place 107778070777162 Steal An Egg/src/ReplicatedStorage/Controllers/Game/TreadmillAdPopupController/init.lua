-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Start = function() -- Start | line: 6
        print("[TreadmillAdPopup] Booted")

        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local AdEggBoostClient = require(script.AdEggBoostClient)
        local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
        local GUI = require(ReplicatedStorage.Client.GUI)

        require(ReplicatedStorage.Shared.Audio)

        local AdEggBoostRemotes = ReplicatedStorage:WaitForChild("AdEggBoostRemotes")
        local Remotes = require(ReplicatedStorage.Shared.Remotes)
        local Sparkles = require(ReplicatedStorage.Client.UI.VFX.Sparkles)
        local TweenService = game:GetService("TweenService")

        local function dbg(p1) -- line: 47
            print("[TreadmillAdPopup]", p1)
        end

        local LocalPlayer = Players.LocalPlayer
        local v1 = false
        local v2 = false
        local v3 = false
        local v4 = false
        local v5 = false
        local n1 = 0
        local AdEggBoostPopupUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AdEggBoostPopupUI")
        local Container = AdEggBoostPopupUI:WaitForChild("Container")
        local UIScale = Container:WaitForChild("UIScale")
        local Close = Container:WaitForChild("Close")
        local Claim = Container:WaitForChild("Claim")
        local Select = Container:WaitForChild("Select")
        local Shine = Select:WaitForChild("Shine")
        local Audio = AdEggBoostPopupUI:WaitForChild("Audio")
        local OnHover = Audio:WaitForChild("OnHover")
        local OnOpen = Audio:WaitForChild("OnOpen")
        local OnClick = Audio:WaitForChild("OnClick")

        AdEggBoostPopupUI.ResetOnSpawn = false
        Select.Visible = false
        Shine.Offset = Vector2.new(1, 0)
        AdEggBoostPopupUI:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 81
            -- upvalues: v3 (ref), AdEggBoostPopupUI (copy)
            if AdEggBoostPopupUI.Enabled and not v3 then
                AdEggBoostPopupUI.Enabled = false
            end
        end)

        local connection
        local n2 = 0

        local function startPulse() -- line: 92
            -- upvalues: RunService (copy), v3 (ref), n1 (ref), UIScale (copy), connection (ref), n2 (ref)
            if not connection then
                n2 = 0
                connection = RunService.RenderStepped:Connect(function(p2) -- line: 97
                    -- upvalues: v3 (ref), n1 (ref), UIScale (copy), n2 (ref)
                    if not v3 then
                        return
                    end

                    n2 += p2
                    UIScale.Scale = math.sin(n2 * 2.0943951023931953) * 0.02 + 1 + n1
                end)
            end
        end

        local function stopPulse() -- line: 107
            -- upvalues: n1 (ref), UIScale (copy), connection (ref)
            if connection then
                connection:Disconnect()
                connection = nil
            end

            n1 = 0
            UIScale.Scale = 1
        end

        local EggImage = Container:WaitForChild("Design"):WaitForChild("EggImage")
        local v8
        local v9 = false

        local function rattleEgg() -- line: 122
            -- upvalues: RunService (copy), EggImage (copy), v9 (ref)
            if not v9 then
                v9 = true

                local n3 = 0

                while n3 < 2 do
                    n3 += RunService.RenderStepped:Wait()

                    local v10 = 1 - n3 / 2

                    EggImage.Rotation = math.sin(n3 * 9.42477796076938) * 10 * v10
                end

                EggImage.Rotation = 0
                v9 = false
            end
        end

        local function runRattleLoop() -- line: 140
            -- upvalues: v3 (ref), rattleEgg (copy)
            while v3 do
                local v12 = 5 + math.random() * 5

                task.wait(v12)

                if v3 then
                    rattleEgg()
                end
            end
        end

        local function startRattle() -- line: 150
            -- upvalues: v8 (ref), runRattleLoop (copy)
            v8 = v8 or task.spawn(runRattleLoop)
        end

        local function stopRattle() -- line: 157
            -- upvalues: EggImage (copy), v8 (ref), v9 (ref)
            if v8 then
                task.cancel(v8)
                v8 = nil
            end

            EggImage.Rotation = 0
            v9 = false
        end

        local v13, v14

        local function startSparkles() -- line: 170
            -- upvalues: Sparkles (copy), Container (copy), EggImage (copy), v13 (ref), v14 (ref)
            v13 = v13 or Sparkles(EggImage, {
                Size = 0.6,
                Pace = 2,
                Lanes = 7
            })
            v14 = v14 or Sparkles(Container, {
                Size = 0.3,
                Pace = 1,
                Lanes = 1
            })
        end

        local function clearSparkles() -- line: 179
            -- upvalues: v13 (ref), v14 (ref)
            if v13 then
                v13()
                v13 = nil
            end

            if v14 then
                v14()
                v14 = nil
            end
        end

        local function showPopup() -- line: 191
            -- upvalues: RunService (copy), AdEggBoostRemotes (copy), TweenService (copy), v3 (ref), n1 (ref), AdEggBoostPopupUI (copy), UIScale (copy), OnOpen (copy), connection (ref), n2 (ref), v8 (ref), rattleEgg (copy), runRattleLoop (copy), startSparkles (copy)
            if v3 then
                print("[TreadmillAdPopup]", "showPopup skipped - already visible")
            else
                print("[TreadmillAdPopup]", "showPopup")
                v3 = true
                AdEggBoostRemotes.LogTelemetry:FireServer("RegisterOpportunity")
                AdEggBoostPopupUI.Enabled = true
                UIScale.Scale = 1.35
                TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
                OnOpen:Play()

                if not connection then
                    n2 = 0
                    connection = RunService.RenderStepped:Connect(function(p3) -- line: 97
                        -- upvalues: v3 (ref), n1 (ref), UIScale (copy), n2 (ref)
                        if not v3 then
                            return
                        end

                        n2 += p3
                        UIScale.Scale = math.sin(n2 * 2.0943951023931953) * 0.02 + 1 + n1
                    end)
                end

                startSparkles()
                task.spawn(rattleEgg)
                v8 = v8 or task.spawn(runRattleLoop)
            end
        end

        local function hidePopup() -- line: 209
            -- upvalues: TweenService (copy), v3 (ref), n1 (ref), AdEggBoostPopupUI (copy), UIScale (copy), Select (copy), connection (ref), EggImage (copy), v8 (ref), v9 (ref), v13 (ref), v14 (ref)
            if v3 then
                print("[TreadmillAdPopup]", "hidePopup")
                v3 = false

                if connection then
                    connection:Disconnect()
                    connection = nil
                end

                n1 = 0
                UIScale.Scale = 1

                if v13 then
                    v13()
                    v13 = nil
                end

                if v14 then
                    v14()
                    v14 = nil
                end

                if v8 then
                    task.cancel(v8)
                    v8 = nil
                end

                EggImage.Rotation = 0
                v9 = false
                Select.Visible = false
                TweenService:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Scale = 0
                }):Play()
                task.delay(0.2, function() -- line: 220
                    -- upvalues: v3 (ref), AdEggBoostPopupUI (copy), UIScale (copy)
                    if not v3 then
                        AdEggBoostPopupUI.Enabled = false
                        UIScale.Scale = 1
                    end
                end)
            end
        end

        local function tryShowPrompt() -- line: 229
            -- upvalues: AdEggBoostClient (copy), v1 (ref), v2 (ref), v4 (ref), showPopup (copy)
            local v22 = "tryShowPrompt: silenced=" .. tostring(v2) .. " onTreadmill=" .. tostring(v1) .. " adPending=" .. tostring(v4)

            print("[TreadmillAdPopup]", v22)

            if not v2 and v1 and not v4 and not AdEggBoostClient.IsGated() then
                task.spawn(function() -- line: 235
                    -- upvalues: AdEggBoostClient (copy), v1 (ref), v2 (ref), showPopup (copy)
                    print("[TreadmillAdPopup]", "tryShowPrompt - checking ad availability")

                    local v23 = AdEggBoostClient.CheckAdAvailable()
                    local v28 = "tryShowPrompt - available=" .. tostring(v23) .. " onTreadmill=" .. tostring(v1) .. " silenced=" .. tostring(v2)

                    print("[TreadmillAdPopup]", v28)

                    if v23 and v1 and not v2 then
                        showPopup()
                    end
                end)
            else
                print("[TreadmillAdPopup]", "tryShowPrompt - blocked")
            end
        end

        local v29

        local function easeLinear(p4) -- line: 248
            return p4
        end

        local function easeBackOut(p5) -- line: 252
            local v30 = p5 - 1

            return v30 * v30 * (v30 * 2.70158 + 1.70158) + 1
        end

        local function sweepOffset(p6, p7, p8) -- line: 258
            -- upvalues: RunService (copy), Shine (copy)
            local v31 = p7 - p6
            local n4 = 0

            while n4 < 0.2 do
                n4 += RunService.RenderStepped:Wait()

                local v33 = math.clamp(n4 / 0.2, 0, 1)

                Shine.Offset = Vector2.new(p6 + v31 * p8(v33), 0)
            end

            Shine.Offset = Vector2.new(p7, 0)
        end

        local function runShine() -- line: 270
            -- upvalues: Shine (copy), v29 (ref), easeLinear (copy), easeBackOut (copy), sweepOffset (copy)
            local X = Shine.Offset.X

            if X < 1 then
                sweepOffset(X, 1, easeLinear)
            end

            Shine.Offset = Vector2.new(-1, 0)
            sweepOffset(-1, 0, easeBackOut)
            v29 = nil
        end

        local function startShine() -- line: 287
            -- upvalues: Shine (copy), v29 (ref), easeBackOut (copy), sweepOffset (copy), runShine (copy)
            if v29 then
                task.cancel(v29)
                v29 = nil
            end

            local X = Shine.Offset.X

            if X < 0 then
                v29 = task.spawn(function() -- line: 297
                    -- upvalues: X (copy), v29 (ref), easeBackOut (copy), sweepOffset (copy)
                    sweepOffset(X, 0, easeBackOut)
                    v29 = nil
                end)
            else
                v29 = task.spawn(runShine)
            end
        end

        local function stopShine() -- line: 306
            -- upvalues: v29 (ref)
            if v29 then
                task.cancel(v29)
                v29 = nil
            end
        end

        Claim.MouseEnter:Connect(function() -- line: 314
            -- upvalues: v5 (ref), n1 (ref), Select (copy), OnHover (copy), rattleEgg (copy), startShine (copy)
            v5 = true
            Select.Visible = true
            n1 = 0.08
            startShine()
            task.spawn(rattleEgg)
            OnHover:Play()
        end)
        Claim.MouseLeave:Connect(function() -- line: 323
            -- upvalues: v5 (ref), n1 (ref), Select (copy)
            v5 = false
            Select.Visible = false
            n1 = 0
        end)

        local function onClaimClicked() -- line: 330
            -- upvalues: AdEggBoostClient (copy), v4 (ref), n1 (ref), Select (copy), OnClick (copy), hidePopup (copy)
            print("[TreadmillAdPopup]", "onClaimClicked")

            if v4 then
                print("[TreadmillAdPopup]", "onClaimClicked - blocked, ad pending")
            else
                OnClick:Play()
                n1 = -0.08
                Select.Visible = true
                task.delay(0.1, function() -- line: 341
                    -- upvalues: n1 (ref), Select (copy)
                    Select.Visible = false
                    n1 = 0
                end)
                v4 = true
                hidePopup()
                AdEggBoostClient.RequestAd()
            end
        end

        local function onCloseClicked() -- line: 352
            -- upvalues: AdEggBoostRemotes (copy), v2 (ref), hidePopup (copy)
            local v34 = "onCloseClicked - silencing for " .. 120 .. "s"

            print("[TreadmillAdPopup]", v34)
            AdEggBoostRemotes.LogTelemetry:FireServer("PopupDismissed")
            hidePopup()
            v2 = true
            task.delay(120, function() -- line: 357
                -- upvalues: v2 (ref)
                v2 = false
            end)
        end

        AdEggBoostClient.AdCompleted:Connect(function(_) -- line: 363
            -- upvalues: v1 (ref), v4 (ref), tryShowPrompt (copy)
            v4 = false

            if v1 then
                task.delay(30, tryShowPrompt)
            end
        end)
        Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p10) -- line: 373
            -- upvalues: v1 (ref), hidePopup (copy), tryShowPrompt (copy)
            v1 = p10 ~= nil

            local v37 = "AssignedBeltShifted: treadmillId=" .. tostring(p10) .. " onTreadmill=" .. tostring(v1)

            print("[TreadmillAdPopup]", v37)

            if not v1 then
                print("[TreadmillAdPopup]", "Dismounted - hiding popup")
                hidePopup()

                return
            end

            local v38 = "Mounted - waiting " .. 1 .. "s before tryShowPrompt"

            print("[TreadmillAdPopup]", v38)
            task.delay(1, tryShowPrompt)
        end)

        local t1 = {}

        for _, descendant in Container:GetDescendants() do
            if descendant.Name == "Rays" and descendant:IsA("GuiObject") then
                table.insert(t1, descendant)
            end
        end

        RunService.RenderStepped:Connect(function(p11) -- line: 393
            -- upvalues: v3 (ref), t1 (copy)
            if not v3 then
                return
            end

            for _, v39 in t1 do
                v39.Rotation = (v39.Rotation + p11 * 22.5) % 360
            end
        end)
        GUI.OnActivated(Claim, onClaimClicked)
        ButtonFX(Claim, 1.08)
        GUI.OnActivated(Close, onCloseClicked)
    end
}
