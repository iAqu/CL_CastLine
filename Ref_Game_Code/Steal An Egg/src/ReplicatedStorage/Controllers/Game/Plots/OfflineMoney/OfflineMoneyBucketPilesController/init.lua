-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ActiveAssetsController = require(script.Parent.Parent.ActiveAssetsController)
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Currency = require(ReplicatedStorage.Shared.Types.Currency)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local Reward = require(ReplicatedStorage.Client.Notifications.Reward)
local OfflineAssets = require(ReplicatedStorage.Client.Types.OfflineAssets)
local ClaimVisual = require(script.ClaimVisual)
local Player = require(ReplicatedStorage.Shared.Player)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Money = Currency.AllCurrencyTypes.Money
local LocalPlayer = Players.LocalPlayer
local v1
local n1 = 0
local v2
local t1 = {}

return {
    Start = function() -- Start | line: 50
        -- upvalues: RunService (copy), ActiveAssetsController (copy), AssetRoster (copy), Constants (copy), TryLock (copy), Reward (copy), OfflineAssets (copy), ClaimVisual (copy), Player (copy), PlotState (copy), Remotes (copy), Save (copy), Trove (copy), Money (copy), LocalPlayer (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
        local function readSummary(p1) -- line: 55
            -- upvalues: OfflineAssets (copy)
            return if OfflineAssets.OfflineClaimSummary(p1) then p1 else nil
        end

        local function readRedeemResult(p2) -- line: 63
            -- upvalues: OfflineAssets (copy)
            return if OfflineAssets.OfflineRedeemResult(p2) then p2 else nil
        end

        local function hasReadiness() -- line: 71
            -- upvalues: Save (copy)
            return Save.IsLoaded()
        end

        local function currentClaimAmount() -- line: 75
            -- upvalues: Constants (copy), v1 (ref)
            local v3 = v1
            local v4 = if v3 then math.max(v3.TotalAmount, 0) else 0

            if Constants.OFFLINE_ASSETS.MIN_CLAIM_MONEY <= v4 then
                return v4
            end

            return 0
        end

        local function clearSession(p3) -- line: 82
            -- upvalues: v2 (ref)
            local v5 = v2

            if p3 == nil or v5 == p3 then
                v2 = nil

                if v5 then
                    v5.trove:Destroy()
                end
            end
        end

        local function feetInsideSession(p4) -- line: 96
            -- upvalues: Player (copy), LocalPlayer (copy)
            local v6 = Player.FindFeetCFrame(LocalPlayer)

            return v6 ~= nil and (p4.visual:ContainsWorldPosition(v6.Position))
        end

        local function requestSummary() -- line: 102
            -- upvalues: OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy)
            n1 += 1

            local v7 = n1

            task.spawn(function() -- line: 106
                -- upvalues: v7 (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy)
                local v8 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                if not OfflineAssets.OfflineClaimSummary(v8) then
                    v8 = nil
                end

                if v7 == n1 then
                    if v8 then
                        v1 = v8
                    end

                    t1.Sync()
                end
            end)
        end

        local function showOfflineMoneyNotification(p5) -- line: 121
            -- upvalues: Reward (copy), Money (copy)
            if not (p5 <= 0) then
                Reward.Show({
                    Item = {
                        Kind = "Currency",
                        Id = Money,
                        Amount = math.round(p5)
                    }
                })
            end
        end

        local function claim(p6) -- line: 135
            -- upvalues: showOfflineMoneyNotification (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
            if not (p6.amount <= 0) then
                p6.claimLock(function() -- line: 140
                    -- upvalues: p6 (copy), showOfflineMoneyNotification (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
                    v1 = {
                        ClaimableAmount = 0,
                        ReservedAmount = 0,
                        TotalAmount = 0,
                        IsMultiplierPurchasePending = false
                    }
                    p6.visual:PlayClaim()

                    local v9, _, v10 = Remotes.AwayEarnings.AskCollect:InvokeServer({
                        Kind = "Claim"
                    })

                    if not OfflineAssets.OfflineRedeemResult(v10) then
                        v10 = nil
                    end

                    if v9 ~= true or v10 == nil then
                        n1 += 1

                        local v11 = n1

                        task.spawn(function() -- line: 106
                            -- upvalues: v11 (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy)
                            local v12 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                            if not OfflineAssets.OfflineClaimSummary(v12) then
                                v12 = nil
                            end

                            if v11 == n1 then
                                if v12 then
                                    v1 = v12
                                end

                                t1.Sync()
                            end
                        end)
                    else
                        showOfflineMoneyNotification(v10.AwardedAmount)

                        local v13 = v2

                        if p6 == nil or v13 == p6 then
                            v2 = nil

                            if v13 then
                                v13.trove:Destroy()
                            end
                        end
                    end
                end)
            end
        end

        local function updateClaimEntry(p7) -- line: 165
            -- upvalues: showOfflineMoneyNotification (copy), OfflineAssets (copy), Player (copy), Remotes (copy), LocalPlayer (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
            local v14 = Player.FindFeetCFrame(LocalPlayer)
            local v15 = v14 ~= nil and p7.visual:ContainsWorldPosition(v14.Position)
            local feetInside = p7.feetInside

            p7.feetInside = v15
            p7.visual:SetBillboardEnabled(not v15)

            if not v15 or feetInside or p7.amount <= 0 then
                return
            end

            p7.claimLock(function() -- line: 140
                -- upvalues: p7 (copy), showOfflineMoneyNotification (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
                v1 = {
                    ClaimableAmount = 0,
                    ReservedAmount = 0,
                    TotalAmount = 0,
                    IsMultiplierPurchasePending = false
                }
                p7.visual:PlayClaim()

                local v16, _, v17 = Remotes.AwayEarnings.AskCollect:InvokeServer({
                    Kind = "Claim"
                })

                if not OfflineAssets.OfflineRedeemResult(v17) then
                    v17 = nil
                end

                if v16 ~= true or v17 == nil then
                    n1 += 1

                    local v18 = n1

                    task.spawn(function() -- line: 106
                        -- upvalues: OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy), v18 (copy)
                        local v19 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                        if not OfflineAssets.OfflineClaimSummary(v19) then
                            v19 = nil
                        end

                        if v18 == n1 then
                            if v19 then
                                v1 = v19
                            end

                            t1.Sync()
                        end
                    end)
                else
                    showOfflineMoneyNotification(v17.AwardedAmount)

                    local v20 = v2

                    if p7 == nil or v20 == p7 then
                        v2 = nil

                        if v20 then
                            v20.trove:Destroy()
                        end
                    end
                end
            end)
        end

        local function sessionFor(p8, p9, p10) -- line: 177
            -- upvalues: showOfflineMoneyNotification (copy), RunService (copy), TryLock (copy), OfflineAssets (copy), ClaimVisual (copy), Player (copy), Remotes (copy), Trove (copy), LocalPlayer (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
            local v21 = Trove.new()
            local v22 = ClaimVisual.new(p8, p9, p10)
            local t3 = {
                feetInside = false,
                trove = v21,
                amount = p8,
                visual = v22,
                claimLock = TryLock()
            }

            v21:Add(function() -- line: 188
                -- upvalues: v22 (copy)
                v22:Destroy()
            end)
            v21:Add(RunService.Heartbeat:Connect(function() -- line: 192
                -- upvalues: t3 (copy), showOfflineMoneyNotification (copy), OfflineAssets (copy), Player (copy), Remotes (copy), LocalPlayer (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
                local v23 = Player.FindFeetCFrame(LocalPlayer)
                local v24 = v23 ~= nil and t3.visual:ContainsWorldPosition(v23.Position)
                local feetInside = t3.feetInside

                t3.feetInside = v24
                t3.visual:SetBillboardEnabled(not v24)

                if not v24 or feetInside or t3.amount <= 0 then
                    return
                end

                t3.claimLock(function() -- line: 140
                    -- upvalues: t3 (copy), showOfflineMoneyNotification (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
                    v1 = {
                        ClaimableAmount = 0,
                        ReservedAmount = 0,
                        TotalAmount = 0,
                        IsMultiplierPurchasePending = false
                    }
                    t3.visual:PlayClaim()

                    local v25, _, v26 = Remotes.AwayEarnings.AskCollect:InvokeServer({
                        Kind = "Claim"
                    })

                    if not OfflineAssets.OfflineRedeemResult(v26) then
                        v26 = nil
                    end

                    if v25 ~= true or v26 == nil then
                        n1 += 1

                        local v27 = n1

                        task.spawn(function() -- line: 106
                            -- upvalues: OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy), v27 (copy)
                            local v28 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                            if not OfflineAssets.OfflineClaimSummary(v28) then
                                v28 = nil
                            end

                            if v27 == n1 then
                                if v28 then
                                    v1 = v28
                                end

                                t1.Sync()
                            end
                        end)
                    else
                        showOfflineMoneyNotification(v26.AwardedAmount)

                        local v29 = v2

                        if t3 == nil or v29 == t3 then
                            v2 = nil

                            if v29 then
                                v29.trove:Destroy()
                            end
                        end
                    end
                end)
            end))

            return t3
        end

        local function tryInitialize() -- line: 199
            -- upvalues: OfflineAssets (copy), Remotes (copy), Save (copy), v1 (ref), n1 (ref), t1 (copy)
            if not Save.IsLoaded() then
                return
            end

            n1 += 1

            local v30 = n1

            task.spawn(function() -- line: 106
                -- upvalues: v30 (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy)
                local v31 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                if not OfflineAssets.OfflineClaimSummary(v31) then
                    v31 = nil
                end

                if v30 == n1 then
                    if v31 then
                        v1 = v31
                    end

                    t1.Sync()
                end
            end)
            t1.Sync()
        end

        function t1.Sync() -- line: 212
            -- upvalues: showOfflineMoneyNotification (copy), sessionFor (copy), AssetRoster (copy), Constants (copy), OfflineAssets (copy), Player (copy), PlotState (copy), Remotes (copy), Save (copy), LocalPlayer (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
            if not Save.IsLoaded() then
                return
            end

            local v32 = v1
            local v33 = if v32 then math.max(v32.TotalAmount, 0) else 0

            if not (Constants.OFFLINE_ASSETS.MIN_CLAIM_MONEY <= v33) then
                v33 = 0
            end

            if v33 <= 0 then
                local v34 = v2

                v2 = nil

                if v34 then
                    v34.trove:Destroy()
                end
            else
                local v35 = AssetRoster.FindPenArea(LocalPlayer)

                if v35 ~= nil then
                    local v37 = PlotState.ResolvePlot()
                    local v38 = if v37 then v37.PlotFolder else workspace
                    local v39 = v2

                    if v39 ~= nil then
                        v39.amount = v33
                        v39.visual:Update(v33, v35)

                        local v48 = Player.FindFeetCFrame(LocalPlayer)
                        local v49 = v48 ~= nil and v39.visual:ContainsWorldPosition(v48.Position)
                        local feetInside = v39.feetInside

                        v39.feetInside = v49
                        v39.visual:SetBillboardEnabled(not v49)

                        if v49 and not feetInside then
                            if v39.amount <= 0 then
                                return
                            end

                            v39.claimLock(function() -- line: 140
                                -- upvalues: v39 (copy), showOfflineMoneyNotification (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
                                v1 = {
                                    ClaimableAmount = 0,
                                    ReservedAmount = 0,
                                    TotalAmount = 0,
                                    IsMultiplierPurchasePending = false
                                }
                                v39.visual:PlayClaim()

                                local v50, _, v51 = Remotes.AwayEarnings.AskCollect:InvokeServer({
                                    Kind = "Claim"
                                })

                                if not OfflineAssets.OfflineRedeemResult(v51) then
                                    v51 = nil
                                end

                                if v50 ~= true or v51 == nil then
                                    n1 += 1

                                    local v52 = n1

                                    task.spawn(function() -- line: 106
                                        -- upvalues: OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy), v52 (copy)
                                        local v53 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                                        if not OfflineAssets.OfflineClaimSummary(v53) then
                                            v53 = nil
                                        end

                                        if v52 == n1 then
                                            if v53 then
                                                v1 = v53
                                            end

                                            t1.Sync()
                                        end
                                    end)
                                else
                                    showOfflineMoneyNotification(v51.AwardedAmount)

                                    local v54 = v2

                                    if v39 == nil or v54 == v39 then
                                        v2 = nil

                                        if v54 then
                                            v54.trove:Destroy()
                                        end
                                    end
                                end
                            end)
                        end
                    else
                        local v40 = sessionFor(v33, v35, v38)

                        v2 = v40

                        local v41 = Player.FindFeetCFrame(LocalPlayer)
                        local v42 = v41 ~= nil and v40.visual:ContainsWorldPosition(v41.Position)
                        local feetInside = v40.feetInside

                        v40.feetInside = v42
                        v40.visual:SetBillboardEnabled(not v42)

                        if v42 and not feetInside then
                            if v40.amount <= 0 then
                                return
                            end

                            v40.claimLock(function() -- line: 140
                                -- upvalues: v40 (copy), showOfflineMoneyNotification (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
                                v1 = {
                                    ClaimableAmount = 0,
                                    ReservedAmount = 0,
                                    TotalAmount = 0,
                                    IsMultiplierPurchasePending = false
                                }
                                v40.visual:PlayClaim()

                                local v43, _, v44 = Remotes.AwayEarnings.AskCollect:InvokeServer({
                                    Kind = "Claim"
                                })

                                if not OfflineAssets.OfflineRedeemResult(v44) then
                                    v44 = nil
                                end

                                if v43 ~= true or v44 == nil then
                                    n1 += 1

                                    local v45 = n1

                                    task.spawn(function() -- line: 106
                                        -- upvalues: OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy), v45 (copy)
                                        local v46 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                                        if not OfflineAssets.OfflineClaimSummary(v46) then
                                            v46 = nil
                                        end

                                        if v45 == n1 then
                                            if v46 then
                                                v1 = v46
                                            end

                                            t1.Sync()
                                        end
                                    end)
                                else
                                    showOfflineMoneyNotification(v44.AwardedAmount)

                                    local v47 = v2

                                    if v40 == nil or v47 == v40 then
                                        v2 = nil

                                        if v47 then
                                            v47.trove:Destroy()
                                        end
                                    end
                                end
                            end)
                        end
                    end
                else
                    local v36 = v2

                    v2 = nil

                    if v36 then
                        v36.trove:Destroy()
                    end
                end
            end
        end

        Remotes.AwayEarnings.SummaryRefreshed.OnClientEvent:Connect(function(p11) -- line: 252
            -- upvalues: OfflineAssets (copy), v1 (ref), t1 (copy)
            local v55 = if OfflineAssets.OfflineClaimSummary(p11) then p11 else nil

            if v55 then
                v1 = v55
                t1.Sync()
            end
        end)
        Remotes.AwayEarnings.Redeemed.OnClientEvent:Connect(function(p12) -- line: 261
            -- upvalues: OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), v2 (ref), t1 (copy)
            if not (OfflineAssets.OfflineRedeemResult(p12) and p12) then
                return
            end

            local v56 = v2

            v2 = nil

            if v56 then
                v56.trove:Destroy()
            end

            n1 += 1

            local v57 = n1

            task.spawn(function() -- line: 106
                -- upvalues: v57 (copy), OfflineAssets (copy), Remotes (copy), v1 (ref), n1 (ref), t1 (copy)
                local v58 = Remotes.AwayEarnings.FetchSummary:InvokeServer()

                if not OfflineAssets.OfflineClaimSummary(v58) then
                    v58 = nil
                end

                if v57 == n1 then
                    if v58 then
                        v1 = v58
                    end

                    t1.Sync()
                end
            end)
        end)
        AssetRoster.PenAreaChanged:Connect(function(p13) -- line: 268
            -- upvalues: LocalPlayer (copy), t1 (copy)
            if p13 == LocalPlayer then
                t1.Sync()
            end
        end)
        PlotState.LocalPlotChanged:Connect(t1.Sync)
        ActiveAssetsController.ItemAdded:Connect(requestSummary)
        ActiveAssetsController.ItemRemoved:Connect(requestSummary)
        ActiveAssetsController.CashCollected:Connect(requestSummary)
        ActiveAssetsController.InitialLoadCompleted:Connect(tryInitialize)
        Save.Loaded:Connect(tryInitialize)
        task.defer(tryInitialize)
    end
}
