-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local danceFloorAuraModelsAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "dance-floor-aura-models-atom").danceFloorAuraModelsAtom
local default = RuntimeLib.import(script, script.Parent, "dance-floor-aura-spew").default

return {
    default = function() -- DanceFloorAuraSpewManager | line: 10
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), danceFloorAuraModelsAtom (copy), default (copy)
        local v1, v2 = useState(danceFloorAuraModelsAtom())

        useEffect(function() -- line: 12
            -- upvalues: v2 (copy), subscribe (copy), danceFloorAuraModelsAtom (copy)
            return subscribe(danceFloorAuraModelsAtom, v2)
        end, {})

        local v3 = table.create(#v1)

        local function v4(p1) -- line: 17
            -- upvalues: react (copy), default (copy)
            return react.createElement(default, {
                key = tostring(p1),
                model = p1
            })
        end

        for v5, v6 in v1 do
            local _ = v5 - 1

            v3[v5] = react.createElement(default, {
                key = tostring(v6),
                model = v6
            })
        end

        return react.createElement(react.Fragment, nil, v3)
    end
}
