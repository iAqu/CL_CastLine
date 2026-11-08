-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local DataStoreService = game:GetService("DataStoreService")
local t1 = {}
local t2 = {}
local t3 = {}
local RewardedAdData
local v1 = true
local GetDataStore = DataStoreService.GetDataStore
local RewardedAdData2, RewardedAdData3 = pcall(GetDataStore, DataStoreService, "RewardedAdData")

if RewardedAdData2 then
    RewardedAdData = RewardedAdData3
else
    v1 = false
end

local v2 = false

local function utcWindowStart(p1) -- line: 22
    local v3 = math.clamp(p1, 1E-08, 365) * 86400

    return math.floor(os.time() / v3) * v3
end

local function warnLocalOnly() -- line: 27
    -- upvalues: v2 (ref)
    if not v2 then
        v2 = true
        warn("[RVBillboard/SaveData] DataStore is unavailable — claim data will only persist for this server session.")
    end
end

local function retry(p2, ...) -- line: 35
    local t4 = { ... }

    for i = 1, 3 do
        local unpack = table.unpack
        local ok, result = pcall(p2, unpack(t4))

        if ok then
            return true, result
        end

        if i < 3 then
            task.wait(i * 2)
        end
    end

    return false, nil
end

function t1.Load(_, p4) -- line: 49
    -- upvalues: t2 (copy), RewardedAdData (ref), v1 (ref), v2 (ref), retry (copy)
    if t2[p4] then
        return
    end

    if not v1 then
        t2[p4] = {}

        return
    end

    local v5, v6 = retry(RewardedAdData.GetAsync, RewardedAdData, (tostring(p4)))

    if v5 then
        t2[p4] = v6 or {}
    else
        v1 = false

        if not v2 then
            v2 = true
            warn("[RVBillboard/SaveData] DataStore is unavailable — claim data will only persist for this server session.")
        end

        t2[p4] = {}
    end
end

function t1.GetActiveClaimCount(_, p6, p7, p8, p9) -- line: 67
    -- upvalues: t2 (copy)
    local v7 = t2[p6]

    if not v7 then
        return 0
    end

    local v8 = v7[p7]

    if not v8 then
        return 0
    end

    local v9 = math.clamp(p9, 1E-08, 365) * 86400
    local v11 = math.floor(os.time() / v9) * v9
    local n1 = 0

    for _, v12 in v8 do
        if not (v12.timestamp < v11) then
            local placementId = v12.placementId

            if placementId == nil or placementId == 0 or p8 == nil or placementId == p8 then
                n1 += 1
            end
        end
    end

    return n1
end

function t1.GetLastClaimTime(_, p11, p12, p13) -- line: 95
    -- upvalues: t2 (copy)
    local v13 = t2[p11]

    if not v13 then
        return 0
    end

    local v14 = v13[p12]

    if not v14 then
        return 0
    end

    local n2 = 0

    for _, v15 in v14 do
        local placementId = v15.placementId

        if (placementId == nil or placementId == 0 or p13 == nil or placementId == p13) and n2 < v15.timestamp then
            n2 = v15.timestamp
        end
    end

    return n2
end

function t1.CanClaim(p14, p15, p16, p17, p18, p19) -- line: 116
    if p18 == 0 then
        return true
    end

    return p14:GetActiveClaimCount(p15, p16, p17, p19) < p18
end

function t1.AddEntry(_, p21, p22, p23, p24, _) -- line: 129
    -- upvalues: t2 (copy), t3 (copy), RewardedAdData (ref), v1 (ref), retry (copy)
    local v16 = t2[p21]

    if not v16 then
        t2[p21] = {}
        v16 = t2[p21]
    end

    if not v16[p22] then
        v16[p22] = {}
    end

    local t5 = {
        timestamp = os.time(),
        placementId = p23,
        productName = p24,
        devProductId = tonumber(p22)
    }

    table.insert(v16[p22], t5)
    t3[p21] = true

    local v18 = os.time() - 2592000
    local t6 = {}

    for _, v19 in v16[p22] do
        if v18 <= v19.timestamp then
            table.insert(t6, v19)
        end
    end

    v16[p22] = t6

    if not v1 or retry(function() -- line: 163
        -- upvalues: p21 (copy), p22 (copy), t5 (copy), v18 (copy), RewardedAdData (ref)
        RewardedAdData:UpdateAsync(tostring(p21), function(p26) -- line: 164
            -- upvalues: p22 (copy), t5 (copy), v18 (copy)
            p26 = p26 or {}

            if not p26[p22] then
                p26[p22] = {}
            end

            table.insert(p26[p22], t5)

            local t7 = {}

            for _, v23 in p26[p22] do
                if v23.timestamp >= v18 then
                    table.insert(t7, v23)
                end
            end

            p26[p22] = t7

            return p26
        end)
    end) then
        return true
    end

    warn(("[RVBillboard/SaveData] Failed to persist entry for UserId %d, DevProductId %s"):format(p21, p22))

    return false
end

function t1.SetClaimCount(p27, p28, p29, p30, p31, p32) -- line: 193
    -- upvalues: t2 (copy)
    local v24 = t2[p28]

    if not v24 then
        t2[p28] = {}
        v24 = t2[p28]
    end

    if not v24[p29] then
        v24[p29] = {}
    end

    local ActiveClaimCount = p27:GetActiveClaimCount(p28, p29, p30, p32)

    if ActiveClaimCount < p31 then
        for _ = 1, p31 - ActiveClaimCount do
            table.insert(v24[p29], {
                productName = "",
                timestamp = os.time(),
                placementId = p30,
                devProductId = tonumber(p29)
            })
        end
    end
end

function t1.GetCache(_) -- line: 221
    -- upvalues: t2 (copy)
    return t2
end

function t1.Unload(_, p35) -- line: 225
    -- upvalues: t2 (copy), t3 (copy), RewardedAdData (ref), v1 (ref), retry (copy)
    local v26 = t2[p35]

    if v26 then
        t2[p35] = nil

        if t3[p35] then
            t3[p35] = nil

            if v1 then
                retry(function() -- line: 238
                    -- upvalues: p35 (copy), v26 (copy), RewardedAdData (ref)
                    RewardedAdData:UpdateAsync(tostring(p35), function(p36) -- line: 239
                        -- upvalues: v26 (copy)
                        p36 = p36 or {}

                        for v28, v29 in v26 do
                            if not p36[v28] then
                                p36[v28] = {}
                            end

                            for _, v30 in v29 do
                                local v31 = false

                                for _, v32 in p36[v28] do
                                    if v32.timestamp == v30.timestamp and v32.devProductId == v30.devProductId then
                                        v31 = true
                                        break
                                    end
                                end

                                if not v31 then
                                    table.insert(p36[v28], v30)
                                end
                            end
                        end

                        return p36
                    end)
                end)
            end
        end
    end
end

return t1
