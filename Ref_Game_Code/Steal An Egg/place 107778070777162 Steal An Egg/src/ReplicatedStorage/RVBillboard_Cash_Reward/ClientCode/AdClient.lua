-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AdService = game:GetService("AdService")
local t1 = {
    Audio = require(script.Parent:WaitForChild("Audio")),
    Remotes = nil
}
local AdAvailabilityResult = nil
local n1 = 0
local v1 = false

t1.onAdCompletedCallbacks = {}
t1.onAdFailedCallbacks = {}

local function pollAvailability() -- line: 16
    -- upvalues: AdService (copy), AdAvailabilityResult (ref), n1 (ref), v1 (ref), pollAvailability (copy)
    local GetAdAvailabilityNowAsync = AdService.GetAdAvailabilityNowAsync
    local RewardedVideo = Enum.AdFormat.RewardedVideo
    local ok, result = pcall(GetAdAvailabilityNowAsync, AdService, RewardedVideo)

    if ok then
        AdAvailabilityResult = result.AdAvailabilityResult

        local AdAvailabilityResult2 = AdAvailabilityResult

        if AdAvailabilityResult2 == Enum.AdAvailabilityResult.IsAvailable then
            n1 = 0
        else
            local AdAvailabilityResult2 = AdAvailabilityResult

            if AdAvailabilityResult2 == Enum.AdAvailabilityResult.NoFill and n1 < 2 and not v1 then
                n1 += 1
                v1 = true
                task.delay(30, function() -- line: 29
                    -- upvalues: AdAvailabilityResult (ref), v1 (ref), pollAvailability (copy)
                    v1 = false

                    if AdAvailabilityResult == Enum.AdAvailabilityResult.NoFill then
                        pollAvailability()
                    end
                end)
            end
        end
    else
        warn(("[RVBillboard] GetAdAvailabilityNowAsync error: %s"):format((tostring(result))))
        AdAvailabilityResult = nil
    end
end

function t1.IsAvailable() -- line: 38
    -- upvalues: AdAvailabilityResult (ref), pollAvailability (copy)
    if AdAvailabilityResult == nil then
        pollAvailability()
    end

    return AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable
end

function t1.ShowAd() -- line: 45
    -- upvalues: t1 (copy), AdAvailabilityResult (ref)
    if not t1.IsAvailable() then
        return false
    end

    local Remotes = t1.Remotes

    if not Remotes then
        return false
    end

    Remotes.ShowAd:FireServer()
    AdAvailabilityResult = nil

    return true
end

function t1.OnAdCompleted(p1) -- line: 58
    -- upvalues: t1 (copy)
    table.insert(t1.onAdCompletedCallbacks, p1)

    return function() -- line: 60
        -- upvalues: p1 (copy), t1 (copy)
        for v2, v3 in t1.onAdCompletedCallbacks do
            if v3 == p1 then
                table.remove(t1.onAdCompletedCallbacks, v2)

                return
            end
        end
    end
end

function t1.OnAdFailed(p2) -- line: 70
    -- upvalues: t1 (copy)
    table.insert(t1.onAdFailedCallbacks, p2)

    return function() -- line: 72
        -- upvalues: p2 (copy), t1 (copy)
        for v4, v5 in t1.onAdFailedCallbacks do
            if v5 == p2 then
                table.remove(t1.onAdFailedCallbacks, v4)

                return
            end
        end
    end
end

function t1.Init(p3) -- line: 82
    -- upvalues: t1 (copy), AdAvailabilityResult (ref), pollAvailability (copy)
    t1.Remotes = p3
    p3.AdResult.OnClientEvent:Connect(function(p4) -- line: 85
        -- upvalues: t1 (copy), AdAvailabilityResult (ref), pollAvailability (copy)
        AdAvailabilityResult = nil

        local v6 = if p4.completed then t1.onAdCompletedCallbacks else t1.onAdFailedCallbacks

        for _, v7 in v6 do
            task.spawn(v7, p4)
        end

        task.delay(2, pollAvailability)
    end)
end

return t1
