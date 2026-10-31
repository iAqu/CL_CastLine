-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local default = RuntimeLib.import(script, script.Parent, "side-confetti").default
local highScoreConfettiTriggerAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "high-score-confetti-atom").highScoreConfettiTriggerAtom

return {
    default = function() -- NewHighScoreConfetti | line: 11
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), default (copy), highScoreConfettiTriggerAtom (copy)
        local v1, v2 = useState(false)

        useEffect(function() -- line: 13
            -- upvalues: v2 (copy), subscribe (copy), highScoreConfettiTriggerAtom (copy)
            local v3
            local v4 = subscribe(highScoreConfettiTriggerAtom, function(p1) -- line: 15
                -- upvalues: v3 (ref), v2 (copy)
                if p1 == 0 then
                    return nil
                end

                if v3 ~= nil then
                    task.cancel(v3)
                end

                v2(true)
                v3 = task.delay(2.35, function() -- line: 23
                    -- upvalues: v3 (ref), v2 (copy)
                    v2(false)
                    v3 = nil
                end)
            end)

            return function() -- line: 28
                -- upvalues: v3 (ref), v4 (copy)
                if v3 ~= nil then
                    task.cancel(v3)
                end

                v4()
            end
        end, {})

        return react.createElement(default, {
            active = v1
        })
    end
}
