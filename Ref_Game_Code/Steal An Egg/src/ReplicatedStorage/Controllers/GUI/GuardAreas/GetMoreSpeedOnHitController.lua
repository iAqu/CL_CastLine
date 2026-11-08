-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)

require(ReplicatedStorage.Shared.Globals.Constants)

local GUI = require(ReplicatedStorage.Client.GUI)
local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local Log = require(ReplicatedStorage.Packages.Log)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 64, 64)
local v2 = Color3.fromRGB(48, 255, 105)
local v3 = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.62, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v5 = Log.new()

return {
    Start = function() -- Start | line: 37
        -- upvalues: ReplicatedStorage (copy), TweenService (copy), ButtonFX (copy), GUI (copy), EnsureUIScale (copy), Toast (copy), Storefront (copy), Remotes (copy), Simple (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
        local v6 = GUI.GetMoreSpeedOnHit()
        local Frame = v6.Frame

        assert(Frame:IsA("Frame"), "PlayerGui.GetMoreSpeedOnHit.Frame must be a Frame")

        local Button = Frame.Button

        assert(Button:IsA("GuiButton"), "PlayerGui.GetMoreSpeedOnHit.Frame.Button must be a GuiButton")

        local Frame3 = Button.Frame

        assert(Frame3:IsA("Frame"), "PlayerGui.GetMoreSpeedOnHit.Frame.Button.Frame must be a Frame")

        local Title = Frame3.Title

        assert(Title:IsA("TextLabel"), "PlayerGui.GetMoreSpeedOnHit.Frame.Button.Frame.Title must be a TextLabel")

        local v7 = EnsureUIScale(Frame3)
        local FramePosition = Frame.Position
        local v8 = UDim2.new(FramePosition.X.Scale, FramePosition.X.Offset, -0.4, FramePosition.Y.Offset)
        local TextColor3 = Title.TextColor3
        local Scale = v7.Scale
        local tween
        local v9 = nil
        local v10 = nil
        local n1 = 0

        local function playPositionTween(p1, p2) -- line: 63
            -- upvalues: Frame (copy), tween (ref), TweenService (copy)
            if tween ~= nil then
                tween:Cancel()
            end

            local tween2 = TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, p2), {
                Position = p1
            })

            tween = tween2
            tween2:Play()

            return tween2
        end

        local function startTitlePulse() -- line: 87
            -- upvalues: Title (copy), v7 (copy), TextColor3 (copy), Scale (copy), v9 (ref), TweenService (copy), Trove (copy), v2 (copy), v3 (copy), v4 (copy)
            local v11 = v9

            if v11 ~= nil then
                v9 = nil
                v11:Destroy()
            end

            Title.TextColor3 = TextColor3
            v7.Scale = Scale

            local v12 = Trove.new()

            v9 = v12
            v12:Add(function() -- line: 94
                -- upvalues: Title (copy), v7 (copy), TextColor3 (copy), Scale (copy)
                Title.TextColor3 = TextColor3
                v7.Scale = Scale
            end)
            v12:Add(task.spawn(function() -- line: 98
                -- upvalues: v12 (copy), Title (copy), v7 (copy), TextColor3 (copy), Scale (copy), v9 (ref), TweenService (copy), v2 (copy), v3 (copy), v4 (copy)
                while true do
                    if v9 == v12 then
                        Title.TextColor3 = TextColor3
                        v7.Scale = Scale

                        local tween = TweenService:Create(Title, v3, {
                            TextColor3 = v2
                        })
                        local tween2 = TweenService:Create(v7, v3, {
                            Scale = Scale * 1.3
                        })

                        v12:Add(tween)
                        v12:Add(tween2)
                        tween:Play()
                        tween2:Play()
                        tween2.Completed:Wait()

                        if v9 == v12 then
                            local tween = TweenService:Create(Title, v4, {
                                TextColor3 = TextColor3
                            })
                            local tween2 = TweenService:Create(v7, v4, {
                                Scale = Scale
                            })

                            v12:Add(tween)
                            v12:Add(tween2)
                            tween:Play()
                            tween2:Play()
                            tween2.Completed:Wait()
                            Title.TextColor3 = TextColor3
                            v7.Scale = Scale
                            continue
                        end
                    end

                    break
                end
            end))
        end

        local function showOffer(p3, p4) -- line: 136
            -- upvalues: v6 (copy), Frame (copy), Title (copy), FramePosition (copy), v8 (copy), v9 (ref), v10 (ref), n1 (ref), playPositionTween (copy), startTitlePulse (copy), ReplicatedStorage (copy), Simple (copy)
            n1 += 1

            local v13 = n1

            v10 = p3

            local SpeedPacks = require(ReplicatedStorage.Data.SpeedPacks)
            local v14 = SpeedPacks.FindSlot(p3)
            local v15 = v14 and SpeedPacks.GetShownAmount(game.Players.LocalPlayer, v14) or p4

            Title.Text = ("+%*"):format((Simple.FormatCompact(v15, ".#")))
            Frame.Position = v8
            startTitlePulse()
            v6.Enabled = true
            playPositionTween(FramePosition, Enum.EasingDirection.Out)
            task.delay(6, function() -- line: 151
                -- upvalues: v13 (copy), v6 (copy), v8 (copy), v9 (ref), v10 (ref), n1 (ref), playPositionTween (copy)
                if v13 == n1 then
                    playPositionTween(v8, Enum.EasingDirection.In).Completed:Once(function() -- line: 156
                        -- upvalues: v13 (copy), v6 (copy), v9 (ref), v10 (ref), n1 (ref)
                        if v13 ~= n1 then
                            return
                        end

                        local v16 = v9

                        if v16 ~= nil then
                            v9 = nil
                            v16:Destroy()
                        end

                        v10 = nil
                        v6.Enabled = false
                    end)
                end
            end)
        end

        v6.Enabled = false
        Title.TextColor3 = TextColor3
        v7.Scale = Scale
        ButtonFX(Button, nil, function() -- line: 174
            -- upvalues: v10 (ref), Storefront (copy), v5 (copy)
            local v17 = v10

            if v17 ~= nil then
                Storefront.Prompt(v17, true, "GuardHit")
            else
                v5:AtWarning():Log("GetMoreSpeedOnHit button activated without an active product")
            end
        end)
        Remotes.GuardPatrol.SpeedTollWarning.OnClientEvent:Connect(function() -- line: 183
            -- upvalues: Toast (copy), v1 (copy)
            Toast.Show({
                Text = "You don't have enough speed!",
                Seconds = 2,
                Color = v1
            })
        end)
        Remotes.GuardPatrol.SpeedTollOffer.OnClientEvent:Connect(showOffer)

        local SpeedPacks = require(ReplicatedStorage.Data.SpeedPacks)

        for i = 1, #SpeedPacks.ProductIds do
            SpeedPacks.ObserveShownAmount(game.Players.LocalPlayer, i, function() -- line: 194
                -- upvalues: Title (copy), v10 (ref), SpeedPacks (copy), i (copy), Simple (copy)
                if v10 == SpeedPacks.ProductIds[i] then
                    local v19 = SpeedPacks.GetShownAmount(game.Players.LocalPlayer, i)

                    if v19 then
                        Title.Text = ("+%*"):format((Simple.FormatCompact(v19, ".#")))
                    end
                end
            end)
        end
    end
}
