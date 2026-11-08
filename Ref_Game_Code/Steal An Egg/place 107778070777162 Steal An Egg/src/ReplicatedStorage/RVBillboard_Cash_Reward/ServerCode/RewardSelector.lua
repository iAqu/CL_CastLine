-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AdService = game:GetService("AdService")
local ConfigService = game:GetService("ConfigService")
local ServerScriptService = game:GetService("ServerScriptService")
local AdLobbyTest = require(ServerScriptService.Library.Modules.AdLobbyTest)
local t1 = {}
local n1 = 0
local result
local n2 = 1
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}

local function dbg(_) -- line: 26
end

local t6 = {
    "A",
    "B",
    "C"
}

local function getBucketForProduct(p2) -- line: 39
    -- upvalues: t3 (copy), t6 (copy)
    for v1, v2 in t3 do
        if v2.devProductId == p2 then
            return t6[v1] or "A"
        end
    end

    return "A"
end

local function parseMultiRewardList(p3) -- line: 48
    if not p3 or p3 == "" then
        return {}
    end

    local t7 = {}

    for match in string.gmatch(p3, "[^,]+") do
        local v3 = tonumber(string.match(match, "%d+"))

        if v3 and v3 ~= 0 then
            table.insert(t7, v3)
        end
    end

    return t7
end

local function getConfigTier(p4) -- line: 64
    -- upvalues: ConfigService (copy), AdLobbyTest (copy), t2 (copy), t5 (copy)
    local v4 = AdLobbyTest.GetOverride(p4)

    if v4 == nil then
        local function v5() -- line: 71
            -- upvalues: p4 (copy), ConfigService (copy), t2 (copy)
            local ConfigForPlayerAsync = ConfigService:GetConfigForPlayerAsync(p4)

            if ConfigForPlayerAsync then
                local RV_Multi_Experiment = ConfigForPlayerAsync:GetValue("RV_Multi_Experiment")

                t2[p4] = RV_Multi_Experiment;
                ("[RewardSelector] ConfigService RV_Multi_Experiment = %s (type: %s)"):format(tostring(RV_Multi_Experiment), (typeof(RV_Multi_Experiment)))

                if type(RV_Multi_Experiment) == "number" and (RV_Multi_Experiment == 2 or RV_Multi_Experiment == 4) then
                    return 2
                end
            end

            return 1
        end

        local ok, result = pcall(v5)

        if not ok then
            result = 1
        end

        for _, v6 in t5 do
            if p4.UserId == v6 then
                print(("[RVB] Bypass: %s (UserId %d) original tier=%d, overridden to tier 2 (bucket B)"):format(p4.Name, p4.UserId, result))

                return 2
            end
        end

        return result
    end

    t2[p4] = v4

    if v4 == 2 or v4 == 4 then
        return 2
    end

    return 1
end

function t1.Init(_, p6) -- line: 103
    -- upvalues: AdService (copy), n1 (ref), result (ref), n2 (ref)
    n1 = p6.DevProductId;
    ("[RewardSelector] INIT — mainDevProductId=%d"):format(n1)

    local CreateAdRewardFromDevProductId = AdService.CreateAdRewardFromDevProductId
    local v7 = n1
    local ok, result2 = pcall(CreateAdRewardFromDevProductId, AdService, v7)

    if ok then
        result = result2
        n2 = p6.Multiplier_Tier_1 or 2

        return true
    end

    warn(("[RVBillboard/RewardSelector] Main reward creation failed for %d"):format(n1))

    return false
end

function t1.AssignPlayer(_, p8) -- line: 119
    -- upvalues: n1 (ref), result (ref), t4 (copy), getConfigTier (copy)
    if not result then
        return
    end

    local v8 = getConfigTier(p8);

    ("[RewardSelector] ASSIGN %s — config tier=%d"):format(p8.Name, v8)

    if v8 == 1 then
        t4[p8] = {
            bucket = "A",
            synced = false,
            devProductId = n1,
            reward = result
        }
    else
        t4[p8] = {
            bucket = "B",
            synced = false,
            devProductId = n1,
            reward = result
        };
        ("[RewardSelector] ASSIGN %s — bucket B, product=%d"):format(p8.Name, n1)
    end
end

function t1.HasMultiReward(_) -- line: 146
    return false
end

function t1.UnassignPlayer(_, p11) -- line: 150
    -- upvalues: t2 (copy), t4 (copy)
    t4[p11] = nil
    t2[p11] = nil
end

function t1.GetRawConfigValue(_, p13) -- line: 155
    -- upvalues: t2 (copy)
    return (tostring(t2[p13] or 0))
end

function t1.IsSynced(_, p15) -- line: 159
    -- upvalues: t4 (copy)
    local v10 = t4[p15]

    return v10 ~= nil and v10.synced
end

function t1.MarkSynced(_, p17) -- line: 164
    -- upvalues: t4 (copy)
    local v11 = t4[p17]

    if v11 then
        v11.synced = true
    end
end

function t1.IsAssigned(_, p19) -- line: 171
    -- upvalues: t4 (copy)
    return t4[p19] ~= nil
end

function t1.GetReward(_, p21) -- line: 175
    -- upvalues: result (ref), t4 (copy)
    local v12 = t4[p21]

    if v12 then
        return v12.reward
    end

    return result
end

function t1.GetAssignedProductId(_, p23) -- line: 183
    -- upvalues: n1 (ref), t4 (copy)
    local v13 = t4[p23]

    if v13 then
        return v13.devProductId
    end

    return n1
end

function t1.GetBucket(_, p25) -- line: 191
    -- upvalues: t4 (copy)
    local v14 = t4[p25]

    if v14 then
        return v14.bucket
    end

    return "A"
end

function t1.GetMultiplier(_, _) -- line: 199
    -- upvalues: n2 (ref)
    return n2
end

function t1.GetMultiplierForProduct(_, _) -- line: 203
    -- upvalues: n2 (ref)
    return n2
end

function t1.CalculateReward(p30, p31, p32) -- line: 207
    return p31 * p30:GetMultiplierForProduct(p32) * 30
end

function t1.GetRewardDuration(_) -- line: 212
    return 30
end

return t1
