-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AdService = game:GetService("AdService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)

local function dbg(p1) -- line: 10
    print("[AdEggBoostClient]", p1)
end

local v1 = ReplicatedStorage:WaitForChild("AdEggBoostRemotes", 30)

assert(v1 ~= nil, "AdEggBoostRemotes folder not found — is AdEggBoostServer running?")

local AskAdGrowthBoost = v1:WaitForChild("AskAdGrowthBoost")
local AdGrowthBoostResult = v1:WaitForChild("AdGrowthBoostResult")
local AdEggBoostConfigResult = v1:WaitForChild("AdEggBoostConfigResult")
local t1 = {
    AdCompleted = Signal.new()
}
local v3 = false

AdEggBoostConfigResult.OnClientEvent:Connect(function(p2) -- line: 29
    -- upvalues: v3 (ref)
    if p2 and p2.gated then
        v3 = true
    end
end)

function t1.IsGated() -- line: 35
    -- upvalues: v3 (ref)
    return v3
end

function t1.CheckAdAvailable() -- line: 39
    -- upvalues: AdService (copy)
    print("[AdEggBoostClient]", "CheckAdAvailable called")

    local function v4() -- line: 41
        -- upvalues: AdService (copy)
        return AdService:GetAdAvailabilityNowAsync(Enum.AdFormat.RewardedVideo)
    end

    local ok, result = pcall(v4)

    if ok then
        local v5 = result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable
        local v6 = "CheckAdAvailable result: " .. tostring(result.AdAvailabilityResult) .. " -> " .. tostring(v5)

        print("[AdEggBoostClient]", v6)

        return v5
    end

    local v7 = "CheckAdAvailable pcall failed: " .. tostring(result)

    print("[AdEggBoostClient]", v7)

    return false
end

function t1.RequestAd() -- line: 53
    -- upvalues: AskAdGrowthBoost (copy)
    print("[AdEggBoostClient]", "RequestAd called — invoking server")

    local v8, v9 = AskAdGrowthBoost:InvokeServer()
    local v10 = "RequestAd server returned: ok=" .. tostring(v8) .. ", err=" .. tostring(v9)

    print("[AdEggBoostClient]", v10)
end

AdGrowthBoostResult.OnClientEvent:Connect(function(p3) -- line: 60
    -- upvalues: t1 (copy)
    local v11 = "AdGrowthBoostResult received: completed=" .. tostring(p3.completed)

    print("[AdEggBoostClient]", v11)
    t1.AdCompleted:Fire(p3.completed == true)
end)

return t1
