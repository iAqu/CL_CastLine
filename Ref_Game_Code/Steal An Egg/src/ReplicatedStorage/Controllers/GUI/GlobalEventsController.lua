-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local BossMastery = require(ReplicatedStorage.Data.BossMastery)
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local FallenPowerUp = require(ReplicatedStorage.Data.FallenPowerUp)
local Elapsed = require(ReplicatedStorage.Shared.Utils.Time).Elapsed
local GUI = require(ReplicatedStorage.Client.GUI)
local HoverCard = require(ReplicatedStorage.Client.HoverCard)
local LightVsDarknessEventFlags = require(ReplicatedStorage.Shared.Flags.LightVsDarknessEventFlags)
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local MonsterParasite2 = require(ReplicatedStorage.Shared.Types.MonsterParasite)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local PlayerEarningsBoost = require(ReplicatedStorage.Shared.Util.PlayerEarningsBoost)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local SakuraBloomPolicy = require(ReplicatedStorage.Client.Modules.SakuraBloomPolicy)
local Save = require(ReplicatedStorage.Shared.Save)
local ServerLuck = require(ReplicatedStorage.Shared.Types.ServerLuck)
local t1 = {
    "RecoveryEvent"
}

return {
    Start = function() -- Start | line: 43
        -- upvalues: Players (copy), Workspace (copy), BossMastery (copy), BossMasteryFlags (copy), EggRecords (copy), FallenPowerUp (copy), Elapsed (copy), GUI (copy), HoverCard (copy), LightVsDarknessEventFlags (copy), MonsterParasite (copy), MonsterParasite2 (copy), PlatformController (copy), PlayerEarningsBoost (copy), Remotes (copy), Sakura (copy), SakuraBloomPolicy (copy), Save (copy), ServerLuck (copy), t1 (copy)
        local v1 = GUI.BottomUI()
        local BottomFrame = v1.BottomFrame
        local Holder = BottomFrame.Holder
        local List = Holder.List
        local Luck = List.Luck
        local Button = Luck.Button
        local TextLabel = Button.Content.Value.TextLabel
        local x2Luck = List.x2Luck
        local Timer = x2Luck.Timer
        local x2Growth = List.x2Growth
        local Timer2 = x2Growth.Timer
        local PlayerEarningsBoost2 = List.PlayerEarningsBoost
        local Timer3, Value = PlayerEarningsBoost2.Timer, PlayerEarningsBoost2.Value
        local clone = PlayerEarningsBoost2:Clone()
        local v2 = assert(BossMastery.GetShopProduct("SpeedBoost"))

        clone.Name = "BossSpeedBoost"
        clone.Icon.Image = v2.Icon
        clone.LayoutOrder = PlayerEarningsBoost2.LayoutOrder + 1
        clone.Visible = false
        clone.Parent = List

        local PlayerSpeedBoost = List:FindFirstChild("PlayerSpeedBoost")
        local v3 = MonsterParasite.BoostMultiplier(MonsterParasite2.BoostKinds.Speed)
        local PlayerEggGrowthBoost = List:FindFirstChild("PlayerEggGrowthBoost")
        local v4 = MonsterParasite.BoostMultiplier(MonsterParasite2.BoostKinds.EggGrowth)
        local AdBoostx2Growth = List:FindFirstChild("AdBoostx2Growth")
        local LocalPlayer = Players.LocalPlayer
        local t3 = {
            Magnet = {
                Frame = List:FindFirstChild("PowerUpMagnet"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "RING MAGNET"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Nearby rings fly straight to you!"
                    }
                }
            },
            x2Rings = {
                Frame = List:FindFirstChild("PowerUpx2Rings"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "2X RINGS"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Every ring you collect counts double!"
                    }
                }
            },
            Fusion = {
                Frame = List:FindFirstChild("PowerUpFusion"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "FUSION"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Charged with fusion energy!"
                    }
                }
            }
        }
        local t4 = {
            Countdown = {
                Frame = List:FindFirstChild("Countdown")
            },
            DemonicEvent = {
                Frame = List:FindFirstChild("DemonicEvent"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "A DEMONIC EGG HAS SPAWNED"
                    }
                }
            },
            DragonEggEvent = {
                HideTimer = true,
                Frame = List:FindFirstChild("DragonEggEvent"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "A DRAGON HAS DESCENDED"
                    }
                }
            },
            GreatBloom = {
                Frame = List:FindFirstChild("GreatBloom"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "🌸 THE GREAT BLOOM 🌸"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Bat Crystal Sakura Trees for Sakura Crystals!"
                    }
                }
            },
            EggLuckBoost = {
                ShowMultiplier = true,
                Frame = List:FindFirstChild("EggLuckBoost"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "EGG LUCK BOOST"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Rarer eggs are spawning on the map!"
                    }
                }
            },
            EggSizeBoost = {
                ShowMultiplier = true,
                Frame = List:FindFirstChild("EggSizeBoost"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "EGG SIZE BOOST"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Bigger eggs are spawning on the map!"
                    }
                }
            },
            EarningsBoost = {
                ShowMultiplier = true,
                Frame = List:FindFirstChild("EarningsBoost"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "EARNINGS BOOST"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Your pets earn more cash!"
                    }
                }
            },
            SpeedBoost = {
                ShowMultiplier = true,
                Frame = List:FindFirstChild("SpeedBoost"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "SPEED BOOST"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Everyone runs faster!"
                    }
                }
            },
            MutationBoost = {
                ShowMultiplier = true,
                Frame = List:FindFirstChild("MutationBoost"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "MUTATION BOOST"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Mutated eggs are more common!"
                    }
                }
            },
            AdminTreadmill = {
                ShowMultiplier = true,
                Frame = List:FindFirstChild("AdminTreadmill"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "ADMIN TREADMILL"
                    },
                    {
                        kind = "rule"
                    },
                    {
                        kind = "heading",
                        text = "Run on the Admin Treadmill in the base for multiplied speed gains!"
                    }
                }
            },
            MonsterEvent = {
                Frame = List:FindFirstChild("MonsterEvent"),
                Tooltip = {
                    {
                        kind = "heading",
                        text = "A MONSTER HAS SPAWNED"
                    }
                }
            }
        }
        local AnchorPoint, BottomFramePosition = BottomFrame.AnchorPoint, BottomFrame.Position
        local AnchorPoint2, HolderPosition = Holder.AnchorPoint, Holder.Position
        local AnchorPoint3, ListPosition, Size = List.AnchorPoint, List.Position, List.Size
        local v5 = {
            Multiplier = 1
        }
        local v6 = {}
        local v7 = {}

        local function isBloomUnlocked() -- line: 241
            -- upvalues: SakuraBloomPolicy (copy), Save (copy)
            local v8 = Save.IsLoaded()
            local v9 = if v8 then Save.Peek() else nil

            return SakuraBloomPolicy.HasBloomUnlocked(v8, v9)
        end

        local function escapeRichText(p1) -- line: 247
            return p1:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        end

        local function getMultiplierText() -- line: 251
            -- upvalues: v5 (ref)
            return (("x%*"):format((math.max(1, (math.floor(v5.Multiplier))))))
        end

        local function getBoosterText() -- line: 255
            -- upvalues: v5 (ref)
            local BoostedByDisplayName = v5.BoostedByDisplayName

            if BoostedByDisplayName == nil or BoostedByDisplayName == "" then
                return "<font color=\"#38E839\">@Server</font>"
            end

            return (("<font color=\"#38E839\">@%*</font>"):format((BoostedByDisplayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))))
        end

        local function getOverlayBlocks() -- line: 264
            -- upvalues: v5 (ref)
            local t6 = {
                kind = "heading",
                text = ("<font color=\"#38E839\">%*</font> Server Luck!"):format((("x%*"):format((math.max(1, (math.floor(v5.Multiplier)))))))
            }
            local t7 = {
                kind = "rule"
            }
            local t8 = {
                kind = "heading"
            }
            local BoostedByDisplayName = v5.BoostedByDisplayName

            t8.text = ("Boosted by %*!"):format(if BoostedByDisplayName == nil or BoostedByDisplayName == "" then "<font color=\"#38E839\">@Server</font>" else ("<font color=\"#38E839\">@%*</font>"):format((BoostedByDisplayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))))

            return {
                t6,
                t7,
                t8
            }
        end

        local function formatMultiplier(p2) -- line: 275
            return (`x{ math.floor(p2 * 100 + 0.5) / 100 }`)
        end

        local function getEventMultiplierText(p3) -- line: 280
            -- upvalues: v7 (ref)
            local v13 = v7[p3]
            local Multiplier = if type(v13) == "table" then v13.Multiplier else nil

            if type(Multiplier) ~= "number" then
                return ""
            end

            return (`x{ math.floor(Multiplier * 100 + 0.5) / 100 }`)
        end

        local function getRemainingSeconds(p4, p5) -- line: 291
            -- upvalues: v6 (ref)
            local v15 = v6[p4]

            if v15 == nil then
                return 0
            end

            return (math.max(0, (math.ceil(v15 - p5))))
        end

        local function getBuffRemainingSeconds(p6) -- line: 303
            -- upvalues: v6 (ref), t1 (copy)
            local n1 = 0

            for _, v18 in t1 do
                local v19 = v6[v18]

                n1 = math.max(n1, if v19 == nil then 0 else math.max(0, (math.ceil(v19 - p6))))
            end

            return n1
        end

        local function getMonsterBoostSeconds(p7, p8, p9) -- line: 316
            -- upvalues: MonsterParasite2 (copy)
            if p7 == nil then
                return 0
            end

            return MonsterParasite2.BoostRemainingSeconds(p7.MonsterParasite, p8, p9)
        end

        local function render(p10) -- line: 332
            -- upvalues: v1 (copy), List (copy), Luck (copy), TextLabel (copy), x2Luck (copy), Timer (copy), x2Growth (copy), Timer2 (copy), PlayerEarningsBoost2 (copy), Timer3 (copy), Value (copy), clone (copy), PlayerSpeedBoost (copy), v3 (copy), PlayerEggGrowthBoost (copy), v4 (copy), AdBoostx2Growth (copy), LocalPlayer (copy), t3 (copy), t4 (copy), v5 (ref), v6 (ref), v7 (ref), Workspace (copy), BossMasteryFlags (copy), EggRecords (copy), FallenPowerUp (copy), Elapsed (copy), LightVsDarknessEventFlags (copy), MonsterParasite2 (copy), PlayerEarningsBoost (copy), Sakura (copy), SakuraBloomPolicy (copy), Save (copy), t1 (copy)
            p10 = p10 or Workspace:GetServerTimeNow()

            local v24 = v5.Multiplier > 1
            local n2 = 0

            for _, v25 in t1 do
                local v26 = v6[v25]

                n2 = math.max(n2, if v26 == nil then 0 else math.max(0, (math.ceil(v26 - p10))))
            end

            local v30 = n2 > 0
            local v31 = Elapsed(n2)

            Luck.Visible = v24
            TextLabel.Text = ("x%*"):format((math.max(1, (math.floor(v5.Multiplier)))))

            local Timer4 = Luck:FindFirstChild("Timer")

            if Timer4 then
                local v33 = if v5.ExpiresAt then v5.ExpiresAt - p10 else 0

                Timer4.Visible = v33 > 0

                if v33 > 0 then
                    Timer4.Text = Elapsed((math.ceil(v33)))
                else
                    Timer4.Text = ""
                end
            end

            x2Luck.Visible = v30
            Timer.Text = v31
            x2Growth.Visible = v30
            Timer2.Text = v31

            local v34 = EggRecords.ServerGrowthBoostMultiplier() or 0
            local GrowthBoost = List:FindFirstChild("GrowthBoost")

            if v34 > 0 then
                local Timer = GrowthBoost:FindFirstChild("Timer")
                local Value = GrowthBoost:FindFirstChild("Value")
                local v35 = EggRecords.ServerGrowthBoostEndsAt() - p10

                Timer.Visible = v35 > 0

                if v35 > 0 then
                    Timer.Text = Elapsed((math.ceil(v35)))
                else
                    Timer.Text = ""
                end

                GrowthBoost.Visible = true
                Value.Text = `x{ v34 + 1 }`
            else
                GrowthBoost.Visible = false
            end

            local v36, v37 = PlayerEarningsBoost.GetActive(LocalPlayer, p10)
            local v38 = v37 > 0

            PlayerEarningsBoost2.Visible = v38
            Timer3.Text = Elapsed((math.ceil(v37)))
            Value.Text = ("x%*"):format(v36)

            local v39 = Save.Peek()
            local Speed = MonsterParasite2.BoostKinds.Speed
            local v40 = if v39 == nil then 0 else MonsterParasite2.BoostRemainingSeconds(v39.MonsterParasite, Speed, p10)
            local EggGrowth = MonsterParasite2.BoostKinds.EggGrowth
            local v41 = if v39 == nil then 0 else MonsterParasite2.BoostRemainingSeconds(v39.MonsterParasite, EggGrowth, p10)
            local v42 = v40 > 0
            local v43 = v41 > 0
            local v44 = if v39 == nil then 0 else math.max(0, (v39.BossMastery.SpeedBoostExpiresAt or 0) - p10)
            local v46 = v44 > 0

            clone.Visible = v46
            clone.Timer.Text = Elapsed((math.ceil(v44)))
            clone.Value.Text = `x{ math.floor(BossMasteryFlags.SpeedBoostMultiplier:Get() * 100 + 0.5) / 100 }`

            if PlayerSpeedBoost then
                PlayerSpeedBoost.Visible = v42
                PlayerSpeedBoost.Timer.Text = Elapsed((math.ceil(v40)))
                PlayerSpeedBoost.Value.Text = `x{ math.floor(v3 * 100 + 0.5) / 100 }`
            end

            if PlayerEggGrowthBoost then
                PlayerEggGrowthBoost.Visible = v43
                PlayerEggGrowthBoost.Timer.Text = Elapsed((math.ceil(v41)))
                PlayerEggGrowthBoost.Value.Text = `x{ math.floor(v4 * 100 + 0.5) / 100 }`
            end

            local AdEggBoostExpiresAt = LocalPlayer:GetAttribute("AdEggBoostExpiresAt")
            local v50 = if typeof(AdEggBoostExpiresAt) == "number" then math.max(0, AdEggBoostExpiresAt - p10) else 0
            local v52 = v50 > 0

            if AdBoostx2Growth then
                AdBoostx2Growth.Visible = v52

                if v52 then
                    AdBoostx2Growth.Timer.Text = Elapsed((math.ceil(v50)))
                end
            end

            if not v24 then
                v24 = v30
                    or v34 > 0
                    or v38
                    or v46
                    or v42
                    or v43
                    or v52
            end

            for v53, v54 in t3 do
                local Frame = v54.Frame

                if Frame then
                    local v55 = FallenPowerUp.ActiveUntil(LocalPlayer, v53) - p10

                    if v55 > 0 then
                        Frame.Timer.Text = Elapsed((math.ceil(v55)))

                        local Value = Frame.Value

                        if v54.ShowValue then
                            Value.Text = ("x%*"):format((LightVsDarknessEventFlags.PowerUpRingMultiplier:Get()))
                        else
                            Value.Text = ""
                        end

                        v24 = true
                        Frame.Visible = true
                    else
                        Frame.Visible = false
                    end
                end
            end

            for v56, v57 in t4 do
                if v57.Frame then
                    local v58 = v6[v56]
                    local v59 = if v58 == nil then 0 else math.max(0, (math.ceil(v58 - p10)))
                    local v62 = true

                    if v56 == Sakura.EventName then
                        local v63 = Save.IsLoaded()
                        local v64 = if v63 then Save.Peek() else nil

                        v62 = SakuraBloomPolicy.HasBloomUnlocked(v63, v64)
                    end

                    if v59 > 0 and v62 then
                        v57.Frame.Timer.Text = Elapsed(v59)
                        v57.Frame.Timer.Visible = v57.HideTimer ~= true

                        if v57.ShowMultiplier then
                            local Value = v57.Frame:FindFirstChild("Value")

                            if Value then
                                local v65 = v7[v56]
                                local Multiplier = if type(v65) == "table" then v65.Multiplier else nil

                                if type(Multiplier) == "number" then
                                    Value.Text = `x{ math.floor(Multiplier * 100 + 0.5) / 100 }`
                                else
                                    Value.Text = ""
                                end
                            end
                        end

                        v24 = true
                        v57.Frame.Visible = true
                    else
                        v57.Frame.Visible = false
                    end
                end
            end

            v1.Enabled = v24
        end

        local function renderPlatform(_) -- line: 499
            -- upvalues: BottomFrame (copy), Holder (copy), List (copy), AnchorPoint (copy), BottomFramePosition (copy), AnchorPoint2 (copy), HolderPosition (copy), AnchorPoint3 (copy), ListPosition (copy), Size (copy), PlatformController (copy)
            if PlatformController.IsMobile() then
                BottomFrame.AnchorPoint = Vector2.new(1, 0)
                BottomFrame.Position = UDim2.fromScale(0.98, 0.07)
                Holder.AnchorPoint = Vector2.new(1, 0)
                Holder.Position = UDim2.fromScale(1, 0)
                List.AnchorPoint = Vector2.new(0.5, 0)
                List.Position = UDim2.fromScale(0.5, 0)
                List.Size = UDim2.fromScale(0.975, 0.5)
            else
                BottomFrame.AnchorPoint = AnchorPoint
                BottomFrame.Position = BottomFramePosition
                Holder.AnchorPoint = AnchorPoint2
                Holder.Position = HolderPosition
                List.AnchorPoint = AnchorPoint3
                List.Position = ListPosition
                List.Size = Size
            end
        end

        local function applyState(p12) -- line: 520
            -- upvalues: v5 (ref), render (copy)
            v5 = p12
            render()
        end

        local function getEarningsOverlayBlocks() -- line: 525
            -- upvalues: LocalPlayer (copy), PlayerEarningsBoost (copy)
            local v67 = PlayerEarningsBoost.GetActive(LocalPlayer)

            return {
                {
                    kind = "heading",
                    text = ("X%* EARNINGS"):format(v67)
                },
                {
                    kind = "rule"
                },
                {
                    kind = "heading",
                    text = ("Your pets earn %*x cash!"):format(v67)
                }
            }
        end

        HoverCard.Attach(Button, getOverlayBlocks)
        HoverCard.Attach(x2Luck.Icon, {
            {
                kind = "heading",
                text = "X2 LUCK"
            }
        })
        HoverCard.Attach(x2Growth.Icon, {
            {
                kind = "heading",
                text = "X2 EGG GROWTH SPEED"
            }
        })
        HoverCard.Attach(List:FindFirstChild("GrowthBoost"), {
            {
                kind = "heading",
                text = "GROWTH BOOSTED!"
            }
        })
        HoverCard.Attach(PlayerEarningsBoost2.Icon, getEarningsOverlayBlocks)
        HoverCard.Attach(clone.Icon, {
            {
                kind = "heading",
                text = ("X%* SPEED"):format((BossMasteryFlags.SpeedBoostMultiplier:Get()))
            },
            {
                kind = "rule"
            },
            {
                kind = "heading",
                text = "You run faster!"
            }
        })
        PlayerEarningsBoost.GetChangedSignal(LocalPlayer):Connect(function() -- line: 554
            -- upvalues: render (copy)
            render()
        end)
        LocalPlayer:GetAttributeChangedSignal(PlayerEarningsBoost.BONUS_EXPIRES_AT_ATTRIBUTE):Connect(render)
        BossMasteryFlags.CashBoosterMultiplier.Changed:Connect(render)
        BossMasteryFlags.SpeedBoostMultiplier.Changed:Connect(render)

        if PlayerSpeedBoost then
            HoverCard.Attach(PlayerSpeedBoost.Icon, {
                {
                    kind = "heading",
                    text = ("X%* SPEED"):format(v3)
                },
                {
                    kind = "rule"
                },
                {
                    kind = "heading",
                    text = "You run faster!"
                }
            })
        end

        if PlayerEggGrowthBoost then
            HoverCard.Attach(PlayerEggGrowthBoost.Icon, {
                {
                    kind = "heading",
                    text = ("X%* EGG GROWTH"):format(v4)
                },
                {
                    kind = "rule"
                },
                {
                    kind = "heading",
                    text = "Your eggs grow faster!"
                }
            })
        end

        if AdBoostx2Growth then
            HoverCard.Attach(AdBoostx2Growth.Icon, {
                {
                    kind = "heading",
                    text = "X2 EGG GROWTH"
                },
                {
                    kind = "rule"
                },
                {
                    kind = "heading",
                    text = "Watch ads to grow eggs faster!"
                }
            })
        end

        LocalPlayer:GetAttributeChangedSignal("AdEggBoostExpiresAt"):Connect(render)

        for _, v68 in t4 do
            if v68.Frame and v68.Tooltip then
                HoverCard.Attach(v68.Frame.Icon, v68.Tooltip)
            end
        end

        for v69, v70 in t3 do
            if v70.Frame then
                local ModelView = v70.Frame.Icon:FindFirstChild("ModelView")

                if ModelView then
                    ModelView:Destroy()
                end

                v70.Frame.Icon.Image = FallenPowerUp.IconFor(v69)
                HoverCard.Attach(v70.Frame.Icon, v70.Tooltip)
                LocalPlayer:GetAttributeChangedSignal(FallenPowerUp.AttributeFor(v69)):Connect(function() -- line: 602
                    -- upvalues: render (copy)
                    render()
                end)
            end
        end

        render()
        PlatformController.Observe(renderPlatform)
        Remotes.LuckWindow.StateRefreshed.OnClientEvent:Connect(function(p13) -- line: 610
            -- upvalues: v5 (ref), render (copy), ServerLuck (copy)
            if ServerLuck.State(p13) then
                v5 = p13
                render()
            end
        end)

        local v71 = Remotes.LuckWindow.FetchState:InvokeServer()

        if ServerLuck.State(v71) then
            v5 = v71
            render()
        end

        Remotes.LiveEvents.Began.OnClientEvent:Connect(function(p14, p15, p16) -- line: 622
            -- upvalues: v6 (ref), v7 (ref), render (copy), Workspace (copy)
            v6[p14] = Workspace:GetServerTimeNow() + p15
            v7[p14] = p16
            render()
        end)
        Remotes.LiveEvents.Ended.OnClientEvent:Connect(function(p17) -- line: 629
            -- upvalues: v6 (ref), v7 (ref), render (copy)
            v6[p17] = nil
            v7[p17] = nil
            render()
        end)
        Save.WatchFields("Sakura", function() -- line: 635
            -- upvalues: render (copy)
            render()
        end)
        Save.WatchFields("MonsterParasite", function() -- line: 638
            -- upvalues: render (copy)
            render()
        end)
        Save.WatchFields("BossMastery", function() -- line: 641
            -- upvalues: render (copy)
            render()
        end)

        local v76, v77 = Remotes.LiveEvents.FetchRunning:InvokeServer()

        v6 = v76
        v7 = v77 or {}
        render()
        task.spawn(function() -- line: 651
            -- upvalues: render (copy)
            while true do
                task.wait(1)
                render()
            end
        end)
    end
}
