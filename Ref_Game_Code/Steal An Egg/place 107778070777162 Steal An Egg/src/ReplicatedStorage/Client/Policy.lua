-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = Log.new()
local v2
local t1 = {
    Loaded = Signal.new(),
    Get = function() -- Get | line: 42
        -- upvalues: v2 (ref)
        return v2
    end,
    IsLoaded = function() -- IsLoaded | line: 46
        -- upvalues: v2 (ref)
        return v2 ~= nil
    end
}

function t1.GetAsync() -- line: 50
    -- upvalues: v2 (ref), t1 (copy)
    local v3 = v2

    if v3 == nil then
        return t1.Loaded:Wait()
    end

    return v3
end

function t1.IsEndlessContentLoadAllowed() -- line: 59
    -- upvalues: v2 (ref)
    local v4 = v2

    return v4 ~= nil and v4.IsEndlessContentLoadAllowed ~= false
end

task.spawn(function() -- line: 71
    -- upvalues: Players (copy), PolicyService (copy), v1 (copy), v2 (ref), t1 (copy)
    local n1 = 0
    local result

    while true do
        if v2 == nil then
            local function v5() -- line: 74
                -- upvalues: Players (copy), PolicyService (copy)
                return PolicyService:GetPolicyInfoForPlayerAsync(Players.LocalPlayer)
            end

            local ok

            ok, result = pcall(v5)

            if not ok or type(result) ~= "table" then
                n1 += 1
                v1:AtWarning():Log((("Failed to fetch local player policy info (attempt %*): %*"):format(n1, result)))
                task.wait((math.min(2 ^ (n1 - 1) * 2, 30)))
                continue
            end

            break
        end

        return
    end

    local v7 = table.freeze(result)

    v2 = v7
    t1.Loaded:Fire(v7)
end)

return t1
