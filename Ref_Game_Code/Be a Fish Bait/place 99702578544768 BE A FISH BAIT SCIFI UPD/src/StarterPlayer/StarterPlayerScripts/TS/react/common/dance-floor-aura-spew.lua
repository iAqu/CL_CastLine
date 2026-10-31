-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent, "text-spew").default
local v1 = Color3.fromRGB(255, 200, 0)

local function DanceFloorAuraSpewInner(p1) -- line: 19
    -- upvalues: react (copy), useEffect (copy), useState (copy), default (copy), v1 (copy)
    local model = p1.model
    local v2, v3 = useState(0)

    useEffect(function() -- line: 22
        -- upvalues: v3 (copy)
        local v4, v5

        v5 = function() -- line: 25
            -- upvalues: v5 (ref), v4 (ref), v3 (copy)
            v4 = task.delay(5, function() -- line: 26
                -- upvalues: v5 (ref), v3 (copy)
                v3(function(p2) -- line: 27
                    return p2 + 1
                end)
                v5()
            end)
        end

        v3(function(p3) -- line: 33
            return p3 + 1
        end)
        v5()

        return function() -- line: 37
            -- upvalues: v4 (ref)
            if v4 ~= nil then
                task.cancel(v4)
            end
        end
    end, {})

    return react.createElement(default, {
        durationSec = 2,
        scaleContent = true,
        color = v1,
        model = model,
        size = UDim2.fromScale(1.875, 1.875),
        texts = { "FOMO" },
        trigger = v2
    })
end

return {
    default = react.memo(DanceFloorAuraSpewInner)
}
