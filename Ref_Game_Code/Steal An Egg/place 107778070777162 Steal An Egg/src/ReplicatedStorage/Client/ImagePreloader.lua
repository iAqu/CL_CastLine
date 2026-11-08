-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.string)
local v2 = t.strict(t.table)
local t1 = {}
local t2 = {}
local v3 = Log.new()
local t3 = {}

local function preload(p1) -- line: 33
    -- upvalues: ContentProvider (copy), t1 (copy), t2 (copy), v3 (copy)
    local v4 = "Unknown failure"

    for i = 1, 3 do
        local v5 = nil

        local function v6() -- line: 37
            -- upvalues: p1 (copy), v5 (ref), ContentProvider (copy)
            ContentProvider:PreloadAsync({
                p1
            }, function(_, p3) -- line: 40
                -- upvalues: v5 (ref)
                v5 = p3
            end)
        end

        local ok, result = pcall(v6)

        if ok then
            v5 = v5 or ContentProvider:GetAssetFetchStatus(p1)

            local Success = Enum.AssetFetchStatus.Success

            if v5 == Success then
                t1[p1] = true
                t2[p1] = nil

                return
            end

            v4 = tostring(v5)

            local TimedOut = Enum.AssetFetchStatus.TimedOut

            if v5 ~= TimedOut then
                break
            end
        else
            v4 = tostring(result)
        end

        if i < 3 then
            task.wait(i * 0.5)
        end
    end

    t2[p1] = nil
    v3:AtWarning():Log((("Failed to preload image %*: %*"):format(p1, v4)))
end

function t3.Request(p4) -- line: 76
    -- upvalues: ContentProvider (copy), v1 (copy), t1 (copy), t2 (copy), preload (copy)
    v1(p4)

    if p4 == "" or t1[p4] or t2[p4] then
        return false
    end

    if ContentProvider:GetAssetFetchStatus(p4) == Enum.AssetFetchStatus.Success then
        t1[p4] = true

        return false
    end

    t2[p4] = true
    task.spawn(preload, p4)

    return true
end

function t3.RequestAll(p5) -- line: 92
    -- upvalues: v2 (copy), t3 (copy)
    v2(p5)

    local n1 = 0

    for _, v8 in p5 do
        if t3.Request(v8) then
            n1 += 1
        end
    end

    return n1
end

return table.freeze(t3)
