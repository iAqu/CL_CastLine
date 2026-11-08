-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AdService = game:GetService("AdService")
local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Analytics = require(ServerScriptService.UserGenerated.Analytics)
local GuardTutorialProgressionService = require(ServerScriptService.Controllers.GuardTutorialProgressionService)
local _require = require
local Parent = script.Parent
local ok, result = pcall(_require, Parent:FindFirstChild("SaveData"))
local v1 = result

if not ok or not result then
    warn("[RVBillboard] SaveData module missing — claim data will not persist.")
    v1 = {
        Load = function() -- Load | line: 14
        end,
        Unload = function() -- Unload | line: 15
        end,
        CanClaim = function() -- CanClaim | line: 16
            return true
        end,
        GetActiveClaimCount = function() -- GetActiveClaimCount | line: 19
            return 0
        end,
        GetLastClaimTime = function() -- GetLastClaimTime | line: 22
            return 0
        end,
        AddEntry = function() -- AddEntry | line: 25
            return true
        end,
        GetCache = function() -- GetCache | line: 28
            return {}
        end,
        SetClaimCount = function() -- SetClaimCount | line: 31
        end
    }
end

local _require2 = require
local Parent2 = script.Parent
local ok2, result2 = pcall(_require2, Parent2:FindFirstChild("Telemetry"))
local v2 = result2

if not ok2 or not result2 then
    warn("[RVBillboard] Telemetry module missing — analytics will not be logged.")
    v2 = {
        new = function() -- new | line: 39
            return {
                Log = function() -- Log | line: 40
                end,
                SetBucket = function() -- SetBucket | line: 40
                end
            }
        end
    }
end

local _require3 = require
local Parent3 = script.Parent
local ok3, result3 = pcall(_require3, Parent3:FindFirstChild("RewardSelector"))
local v3 = result3

if not ok3 or not result3 then
    v3 = {
        Init = function() -- Init | line: 48
            return true
        end,
        AssignPlayer = function() -- AssignPlayer | line: 51
        end,
        UnassignPlayer = function() -- UnassignPlayer | line: 52
        end,
        AcceptSync = function() -- AcceptSync | line: 53
            return false
        end,
        HasMultiReward = function() -- HasMultiReward | line: 56
            return false
        end,
        IsSynced = function() -- IsSynced | line: 59
            return false
        end,
        MarkSynced = function() -- MarkSynced | line: 62
        end,
        IsAssigned = function() -- IsAssigned | line: 63
            return true
        end,
        GetReward = function() -- GetReward | line: 66
            return nil
        end,
        GetAssignedProductId = function() -- GetAssignedProductId | line: 69
            return 0
        end,
        GetBucket = function() -- GetBucket | line: 72
            return "A"
        end
    }
end

local v4
local v5 = false
local t1 = {}
local v6, v7
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local v8 = ""
local v9 = ""

local function debugPrint(p1) -- line: 96
    -- upvalues: v5 (ref)
    if v5 then
        print(p1)
    end
end

local function getProductName(p2) -- line: 102
    -- upvalues: MarketplaceService (copy), t5 (copy)
    if t5[p2] then
        return t5[p2]
    end

    local GetProductInfo = MarketplaceService.GetProductInfo
    local Product = Enum.InfoType.Product
    local ok, result = pcall(GetProductInfo, MarketplaceService, p2, Product)
    local v10, v11

    if ok and result and result.Name then
        local Name = result.Name

        if Name then
            v10 = Name
            v11 = true
        else
            v11 = false
        end
    else
        v11 = false
    end

    if not v11 then
        v10 = ""
    end

    t5[p2] = v10

    return v10
end

local function getAdVariant(p3) -- line: 112
    -- upvalues: v3 (ref)
    if v3:IsAssigned(p3) then
        return v3:GetBucket(p3)
    end

    return ""
end

function t1.ShowAd(p4) -- line: 119
    -- upvalues: v1 (ref), v3 (ref), AdService (copy), MarketplaceService (copy), Analytics (copy), v4 (ref), v5 (ref), v6 (ref), v7 (ref), t2 (copy), t3 (copy), t5 (copy), v8 (ref), v9 (ref)
    if t3[p4] then
        return
    end

    local ActiveClaimCount = v1:GetActiveClaimCount(p4.UserId, v8, v6.PlacementId, v6.ResetInDays)
    local v12 = ("[Board %s] SHOW_AD — %s: %d/%d active before attempt"):format(v9, p4.Name, ActiveClaimCount, v6.ClaimLimit)

    if v5 then
        print(v12)
    end

    if v1:CanClaim(p4.UserId, v8, v6.PlacementId, v6.ClaimLimit, v6.ResetInDays) then
        if not (v6.Cooldown > 0 and math.ceil(v1:GetLastClaimTime(p4.UserId, v8, v6.PlacementId) + v6.Cooldown * 60 - os.time()) > 0) then
            t3[p4] = true

            local v16 = v4
            local v17 = v3

            v16:SetBucket(v17:GetBucket(p4))
            v4:SetRawConfigValue(v17:GetRawConfigValue(p4))
            v4:SetDevProductId(v17:GetAssignedProductId(p4))
            v4:Log(p4, "AdStarted")

            local Reward = v3:GetReward(p4)
            local ShowRewardedVideoAdAsync = AdService.ShowRewardedVideoAdAsync
            local PlacementId = v6.PlacementId
            local ok, result = pcall(ShowRewardedVideoAdAsync, AdService, p4, Reward, PlacementId)

            t3[p4] = nil

            if ok then
                if result == Enum.ShowAdResult.ShowCompleted then
                    local v20 = os.time()
                    local v21 = if v6.Cooldown > 0 then v20 + v6.Cooldown * 60 else nil
                    local v22 = v1:GetActiveClaimCount(p4.UserId, v8, v6.PlacementId, v6.ResetInDays) + 1
                    local ClaimLimit = v6.ClaimLimit
                    local v23 = v6.ResetInDays * 86400
                    local v25 = math.floor(v20 / v23) * v23 + v23

                    v7.AdResult:FireClient(p4, {
                        completed = true,
                        claimed = true,
                        devProductId = v6.DevProductId,
                        placementId = v6.PlacementId,
                        result = result,
                        cooldownEndsAt = v21,
                        claimsUsed = v22,
                        claimsMax = ClaimLimit,
                        windowResetsAt = v25
                    })

                    local v26 = ("[Board %s] CLAIM_SUCCESS — %s: now %d/%d"):format(v9, p4.Name, v22, ClaimLimit)

                    if v5 then
                        print(v26)
                    end

                    for _, v27 in t2 do
                        local Remotes = v27:FindFirstChild("Remotes")
                        local SyncSignal = Remotes and Remotes:FindFirstChild("SyncSignal")

                        if SyncSignal then
                            local v28 = ("[Board %s] SYNC_OUT — firing count=%d to other board"):format(v9, v22)

                            if v5 then
                                print(v28)
                            end

                            SyncSignal:Fire(p4, v6.DevProductId, v22, nil, v6.PlacementId)
                        end
                    end

                    v4:Log(p4, "AdComplete")
                    Analytics:IncrementPlayerAttribute(p4, "TotalAdsWatched", 1)
                    Analytics:LogPlayerEvent(p4, "PlayerAdWatched", {
                        Feature = "Ads",
                        Variant = if v3:IsAssigned(p4) then v3:GetBucket(p4) else "",
                        PlacementId = tostring(v6.PlacementId),
                        DevProductId = tostring(v3:GetAssignedProductId(p4)),
                        Multiplier = v3:GetMultiplier(p4)
                    })

                    local DevProductId = v6.DevProductId
                    local v30

                    if t5[DevProductId] then
                        v30 = t5[DevProductId]
                    else
                        local GetProductInfo = MarketplaceService.GetProductInfo
                        local Product = Enum.InfoType.Product
                        local ok, result = pcall(GetProductInfo, MarketplaceService, DevProductId, Product)

                        v30 = ok and result and result.Name and result.Name or ""
                        t5[DevProductId] = v30
                    end

                    local v31 = v1

                    v31:AddEntry(p4.UserId, v8, v6.PlacementId, v30, v6.ResetInDays)
                else
                    v4:Log(p4, "AdIncomplete")
                    v7.AdResult:FireClient(p4, {
                        completed = false,
                        claimed = false,
                        devProductId = v6.DevProductId,
                        placementId = v6.PlacementId,
                        result = result
                    })
                end
            else
                warn(("[RVBillboard] ShowRewardedVideoAdAsync error for %s — %s"):format(p4.Name, (tostring(result))))
                v4:Log(p4, "AdIncomplete")
                v7.AdResult:FireClient(p4, {
                    completed = false,
                    claimed = false,
                    result = nil,
                    devProductId = v6.DevProductId,
                    placementId = v6.PlacementId
                })
            end
        else
            v7.AdResult:FireClient(p4, {
                completed = false,
                claimed = false,
                reason = "Cooldown",
                devProductId = v6.DevProductId,
                placementId = v6.PlacementId
            })
        end
    else
        local ActiveClaimCount = v1:GetActiveClaimCount(p4.UserId, v8, v6.PlacementId, v6.ResetInDays)
        local v33 = v6.ResetInDays * 86400
        local v35 = math.floor(os.time() / v33) * v33 + v33

        v7.AdResult:FireClient(p4, {
            completed = false,
            claimed = false,
            reason = "ClaimLimitReached",
            devProductId = v6.DevProductId,
            placementId = v6.PlacementId,
            claimsUsed = ActiveClaimCount,
            claimsMax = v6.ClaimLimit,
            windowResetsAt = v35
        })
    end
end

function t1.Init(_, p6, p7, p8, p9) -- line: 262
    -- upvalues: v1 (ref), v2 (ref), v3 (ref), CollectionService (copy), Players (copy), Analytics (copy), GuardTutorialProgressionService (copy), v4 (ref), v5 (ref), t1 (copy), v6 (ref), v7 (ref), t2 (copy), t3 (copy), t4 (copy), v8 (ref), v9 (ref), getAdVariant (copy)
    v5 = p9 or false
    v6 = p7
    v7 = p8
    v8 = tostring(p7.DevProductId)

    if not v3:Init(p7) then
        warn("[RVBillboard] RewardSelector failed — no valid rewards. Board disabled on " .. p6:GetFullName())

        return
    end

    v4 = v2.new({
        Bucket = "A",
        DevProductId = p7.DevProductId,
        PlacementId = p7.PlacementId or 0
    })
    p8.LogTelemetry.OnServerEvent:Connect(function(p10, p11) -- line: 279
        -- upvalues: v3 (ref), v4 (ref)
        if type(p11) ~= "string" then
            return
        end

        local v36 = v4
        local v37 = v3

        v36:SetBucket(v37:GetBucket(p10))
        v4:SetRawConfigValue(v37:GetRawConfigValue(p10))
        v4:SetDevProductId(v37:GetAssignedProductId(p10))
        v4:Log(p10, p11)
    end)

    local function loadAndAssignPlayer(p12) -- line: 289
        -- upvalues: p6 (copy), p7 (copy), v1 (ref), v3 (ref), Analytics (copy), GuardTutorialProgressionService (copy), v5 (ref), v7 (ref), t2 (copy), v8 (ref), v9 (ref), getAdVariant (copy)
        v1:Load(p12.UserId)

        if v3:HasMultiReward() and p7.PlacementId and p7.PlacementId ~= 0 then
            local Magnitude = p6:GetPivot().Position.Magnitude
            local v41 = Magnitude / 50
            local v42 = ("[RVBillboard/Sync] Board %s | distance=%.1f studs | waiting %.3fs"):format(v9, Magnitude, v41)

            if v5 then
                print(v42)
            end

            task.wait(v41)

            local v43 = v3:IsSynced(p12)
            local v44 = ("[RVBillboard/Sync] Board %s | wait complete | synced=%s"):format(v9, (tostring(v43)))

            if v5 then
                print(v44)
            end

            if not v43 then
                local v45 = math.random() * 0.01
                local v46 = ("[RVBillboard/Sync] Board %s | jitter=%.4fs"):format(v9, v45)

                if v5 then
                    print(v46)
                end

                task.wait(v45)
            end

            if v3:IsSynced(p12) then
                local v47 = ("[RVBillboard/Sync] Board %s FOLLOWER — synced to product=%d"):format(v9, v3:GetAssignedProductId(p12))

                if v5 then
                    print(v47)
                end
            else
                v3:AssignPlayer(p12)

                local v48 = ("[RVBillboard/Sync] Board %s LEADER — picked product=%d, firing to %d boards"):format(v9, v3:GetAssignedProductId(p12), #t2)

                if v5 then
                    print(v48)
                end

                for _, v49 in t2 do
                    local Remotes = v49:FindFirstChild("Remotes")
                    local SyncSignal = Remotes and Remotes:FindFirstChild("SyncSignal")

                    if SyncSignal then
                        SyncSignal:Fire(p12, p7.DevProductId, nil, {
                            placementId = p7.PlacementId,
                            assignedProductId = v3:GetAssignedProductId(p12)
                        })
                    end
                end

                local v50 = ("[RVBillboard/Sync] Board %s LEADER — sync fired"):format(v9)

                if v5 then
                    print(v50)
                end
            end
        else
            v3:AssignPlayer(p12)
        end

        local v51 = GuardTutorialProgressionService.HasPlayerCompletedTutorial(p12)

        print(("[RVB4.0] %s | bucket=%s|%s | product=%d | multiplier=%.1f | tutorial_complete=%s"):format(p12.Name, v3:GetBucket(p12), v3:GetRawConfigValue(p12), v3:GetAssignedProductId(p12), v3:GetMultiplier(p12), (tostring(v51))))
        Analytics:SetPlayerAttribute(p12, "Shared.AdVariant", getAdVariant(p12))

        if v3:GetBucket(p12) == "A" then
            print(("[RVB4.0] %s | CONTROL GROUP — board will be moved to ReplicatedStorage"):format(p12.Name))
            v7.AdResult:FireClient(p12, {
                completed = false,
                claimed = false,
                reason = "ControlGroup",
                gated = true,
                devProductId = p7.DevProductId,
                placementId = p7.PlacementId
            })
        else
            print(("[RVB4.0] %s | bucket=%s|%s | ACTIVE — board will load with product=%d, multiplier=%.1f"):format(p12.Name, v3:GetBucket(p12), v3:GetRawConfigValue(p12), v3:GetAssignedProductId(p12), v3:GetMultiplier(p12)))
            v7.AdResult:FireClient(p12, {
                completed = false,
                claimed = false,
                reason = "RewardAssigned",
                devProductId = p7.DevProductId,
                placementId = p7.PlacementId,
                assignedProductId = v3:GetAssignedProductId(p12),
                multiplier = v3:GetMultiplier(p12),
                rewardDuration = v3:GetRewardDuration()
            })

            local ActiveClaimCount = v1:GetActiveClaimCount(p12.UserId, v8, p7.PlacementId, p7.ResetInDays)
            local v52 = v1:GetCache()[p12.UserId]
            local v53 = if v52 and v52[v8] then #v52[v8] else 0
            local v54 = ("[Board %s] LOAD — %s: %d/%d active (raw#=%d) bucket=%s"):format(v9, p12.Name, ActiveClaimCount, p7.ClaimLimit, v53, v3:GetBucket(p12))

            if v5 then
                print(v54)
            end
        end
    end

    for _, player in Players:GetPlayers() do
        task.spawn(loadAndAssignPlayer, player)
    end

    Players.PlayerAdded:Connect(function(p13) -- line: 407
        -- upvalues: loadAndAssignPlayer (copy)
        loadAndAssignPlayer(p13)
    end)
    Players.PlayerRemoving:Connect(function(p14) -- line: 410
        -- upvalues: v1 (ref), v3 (ref), t3 (copy), t4 (copy)
        v3:UnassignPlayer(p14)
        t3[p14] = nil
        t4[p14] = nil
        v1:Unload(p14.UserId)
    end)

    p8.GetPlacementInfo.OnServerInvoke = function(p15) -- line: 417
        -- upvalues: p7 (copy), v1 (ref), v3 (ref), v8 (ref)
        if not v3:IsAssigned(p15) then
            return {
                pending = true
            }
        end

        if v3:IsAssigned(p15) and v3:GetBucket(p15) == "A" then
            return {
                controlGroup = true
            }
        end

        local UserId = p15.UserId
        local v56 = os.time()
        local ActiveClaimCount = v1:GetActiveClaimCount(UserId, v8, p7.PlacementId, p7.ResetInDays)
        local v57 = v1:GetLastClaimTime(UserId, v8, p7.PlacementId) + p7.Cooldown * 60
        local v59 = math.max(0, v57 - v56)
        local v60 = p7.ResetInDays * 86400
        local v62 = math.floor(v56 / v60) * v60

        return {
            eligible = (p7.ClaimLimit == 0 or ActiveClaimCount < p7.ClaimLimit) and v59 == 0,
            cooldownEndsAt = v57,
            secondsLeft = v59,
            claimsUsed = ActiveClaimCount,
            claimsMax = p7.ClaimLimit,
            windowResetsAt = v62 + v60,
            devProductId = p7.DevProductId,
            placementId = p7.PlacementId,
            assignedProductId = v3:GetAssignedProductId(p15),
            multiplier = v3:GetMultiplier(p15),
            rewardDuration = v3:GetRewardDuration()
        }
    end

    p8.ShowAd.OnServerEvent:Connect(function(p16) -- line: 448
        -- upvalues: p7 (copy), p8 (copy), t1 (copy), t4 (copy)
        local v63 = os.time()

        if v63 - (t4[p16] or 0) < 5 then
            p8.AdResult:FireClient(p16, {
                completed = false,
                claimed = false,
                reason = "RateLimited",
                devProductId = p7.DevProductId,
                placementId = p7.PlacementId
            })
        else
            t4[p16] = v63
            t1.ShowAd(p16)
        end
    end)

    for _, v64 in CollectionService:GetTagged("RVBillboard") do
        if v64 ~= p6 then
            table.insert(t2, v64)
        end
    end

    v9 = tostring(#t2 + 1)
    CollectionService:GetInstanceAddedSignal("RVBillboard"):Connect(function(p17) -- line: 470
        -- upvalues: p6 (copy), p7 (copy), v1 (ref), v3 (ref), Players (copy), v5 (ref), t2 (copy), v8 (ref), v9 (ref)
        if p17 == p6 then
            return
        end

        table.insert(t2, p17)

        local Remotes = p17:FindFirstChild("Remotes")
        local SyncSignal = Remotes and Remotes:FindFirstChild("SyncSignal")

        if SyncSignal then
            for v66, v67 in v1:GetCache() do
                if v67[v8] then
                    local PlayerByUserId = Players:GetPlayerByUserId(v66)

                    if PlayerByUserId then
                        local ActiveClaimCount = v1:GetActiveClaimCount(v66, v8, p7.PlacementId, p7.ResetInDays)

                        if ActiveClaimCount > 0 then
                            SyncSignal:Fire(PlayerByUserId, p7.DevProductId, ActiveClaimCount, nil, p7.PlacementId)
                        end

                        if v3:IsSynced(PlayerByUserId) and p7.PlacementId and p7.PlacementId ~= 0 then
                            local v68 = ("[RVBillboard/Sync] Board %s redistributing verified sync to new board — product=%d"):format(v9, v3:GetAssignedProductId(PlayerByUserId))

                            if v5 then
                                print(v68)
                            end

                            SyncSignal:Fire(PlayerByUserId, p7.DevProductId, nil, {
                                placementId = p7.PlacementId,
                                assignedProductId = v3:GetAssignedProductId(PlayerByUserId)
                            })
                        end
                    end
                end
            end
        end
    end)
    CollectionService:GetInstanceRemovedSignal("RVBillboard"):Connect(function(p18) -- line: 508
        -- upvalues: t2 (copy)
        for v69, v70 in t2 do
            if v70 == p18 then
                table.remove(t2, v69)

                return
            end
        end
    end)
    p8.SyncSignal.Event:Connect(function(p19, p20, p21, p22, p23) -- line: 518
        -- upvalues: p7 (copy), p8 (copy), v1 (ref), v3 (ref), v5 (ref), v7 (ref), v8 (ref), v9 (ref)
        if p20 ~= p7.DevProductId then
            return
        end

        if p22 then
            local PlacementId = p7.PlacementId
            local placementId = p22.placementId

            if PlacementId and PlacementId ~= 0 and placementId and placementId ~= 0 and PlacementId == placementId and v3:AcceptSync(p19, p22.assignedProductId) then
                v7.AdResult:FireClient(p19, {
                    completed = false,
                    claimed = false,
                    reason = "RewardAssigned",
                    devProductId = p7.DevProductId,
                    placementId = p7.PlacementId,
                    assignedProductId = p22.assignedProductId,
                    multiplier = v3:GetMultiplier(p19),
                    rewardDuration = v3:GetRewardDuration()
                })
            end
        elseif p21 then
            local PlacementId = p7.PlacementId

            if not p23 or p23 == 0 then
                if PlacementId and PlacementId ~= 0 then
                    return
                end
            elseif not PlacementId or PlacementId == 0 or PlacementId ~= p23 then
                return
            end

            local ActiveClaimCount = v1:GetActiveClaimCount(p19.UserId, v8, p7.PlacementId, p7.ResetInDays)
            local v71 = v1:GetCache()[p19.UserId]
            local v72 = if v71 and v71[v8] then #v71[v8] else 0
            local v73 = ("[Board %s] SYNC_IN — received count=%d for %s (before: active=%d, raw#=%d)"):format(v9, p21, p19.Name, ActiveClaimCount, v72)

            if v5 then
                print(v73)
            end

            local v74 = v1

            v74:SetClaimCount(p19.UserId, v8, p7.PlacementId, p21, p7.ResetInDays)

            local ActiveClaimCount2 = v1:GetActiveClaimCount(p19.UserId, v8, p7.PlacementId, p7.ResetInDays)
            local v76 = ("[Board %s] SYNC_IN — after SetClaimCount: active=%d/%d"):format(v9, ActiveClaimCount2, p7.ClaimLimit)

            if v5 then
                print(v76)
            end

            local UserId2 = p19.UserId
            local v77 = v1:GetLastClaimTime(UserId2, v8, p7.PlacementId) + p7.Cooldown * 60
            local v79 = math.max(0, v77 - os.time())
            local v80 = p7.ResetInDays * 86400
            local v82 = math.floor(os.time() / v80) * v80

            p8.AdResult:FireClient(p19, {
                completed = false,
                claimed = false,
                reason = "SyncUpdate",
                devProductId = p7.DevProductId,
                placementId = p7.PlacementId,
                cooldownEndsAt = v77,
                secondsLeft = v79,
                claimsUsed = p21,
                claimsMax = p7.ClaimLimit,
                windowResetsAt = v82 + v80
            })
        end
    end)
end

return t1
