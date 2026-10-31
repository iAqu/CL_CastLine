-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local teaserRigSpewPhrases = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "teaser-rig").teaserRigSpewPhrases
local default = RuntimeLib.import(script, script.Parent, "text-spew").default

local function TeaserRigSpewInner(p1) -- line: 19
    -- upvalues: react (copy), useEffect (copy), useState (copy), teaserRigSpewPhrases (copy), default (copy)
    local instance = p1.instance
    local v1, v2 = useState(0)
    local v3, v4 = useState(0)

    useEffect(function() -- line: 23
        -- upvalues: v2 (copy), v4 (copy), teaserRigSpewPhrases (copy)
        local v5, v6

        v6 = function() -- line: 26
            -- upvalues: v6 (ref), v5 (ref), v2 (copy), v4 (copy), teaserRigSpewPhrases (copy)
            v5 = task.delay(20, function() -- line: 27
                -- upvalues: v6 (ref), v2 (copy), v4 (copy), teaserRigSpewPhrases (copy)
                v4(function(p2) -- line: 28
                    -- upvalues: teaserRigSpewPhrases (copy)
                    return (p2 + 1) % #teaserRigSpewPhrases
                end)
                v2(function(p3) -- line: 31
                    return p3 + 1
                end)
                v6()
            end)
        end

        v2(function(p4) -- line: 37
            return p4 + 1
        end)
        v6()

        return function() -- line: 41
            -- upvalues: v5 (ref)
            if v5 ~= nil then
                task.cancel(v5)
            end
        end
    end, {})

    return react.createElement(default, {
        durationSec = 10,
        adornee = instance,
        color = Color3.new(1, 1, 1),
        texts = { teaserRigSpewPhrases[v3 + 1] },
        trigger = v1
    })
end

return {
    default = react.memo(TeaserRigSpewInner)
}
