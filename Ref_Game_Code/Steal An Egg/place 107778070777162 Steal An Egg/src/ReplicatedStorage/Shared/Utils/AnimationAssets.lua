-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AssetIds = require(ReplicatedStorage.Shared.Utils.AssetIds)
local Preload = require(ReplicatedStorage.Shared.Utils.Preload)
local t1 = {}
local t2 = {}
local t3 = {}
local v1 = false

local function schedulePreload(p1) -- line: 13
    -- upvalues: Preload (copy), t3 (ref), v1 (ref)
    table.insert(t3, p1)

    if not v1 then
        v1 = true
        task.defer(function() -- line: 20
            -- upvalues: Preload (copy), t3 (ref), v1 (ref)
            repeat
                local t5 = t3

                t3 = {}

                if #t5 > 0 then
                    Preload.WarmAssets(t5)
                end
            until #t3 == 0

            v1 = false
        end)
    end
end

function t1.Get(p2) -- line: 32
    -- upvalues: AssetIds (copy), Preload (copy), t2 (copy), t3 (ref), v1 (ref)
    local v2 = AssetIds.Parse(p2)

    assert(v2 ~= nil, (("invalid animation asset id %*"):format(p2)))

    local v5 = t2[v2]

    if v5 then
        return v5
    end

    local Animation = Instance.new("Animation")

    Animation.Name = ("Animation_%*"):format(v2)
    Animation.AnimationId = ("rbxassetid://%*"):format(v2)
    t2[v2] = Animation
    table.insert(t3, Animation)

    if not v1 then
        v1 = true
        task.defer(function() -- line: 20
            -- upvalues: Preload (copy), t3 (ref), v1 (ref)
            repeat
                local t7 = t3

                t3 = {}

                if #t7 > 0 then
                    Preload.WarmAssets(t7)
                end
            until #t3 == 0

            v1 = false
        end)
    end

    return Animation
end

return table.freeze(t1)
