-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPinataBossDamagePopups = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "pinata-boss-damage-popups.selectors").selectPinataBossDamagePopups
local default = RuntimeLib.import(script, script.Parent, "boss-damage-popup").default

return {
    default = function() -- BossDamagePopupManager | line: 7
        -- upvalues: react (copy), useRootSelector (copy), selectPinataBossDamagePopups (copy), default (copy)
        local v1 = useRootSelector(selectPinataBossDamagePopups)
        local v2 = table.create(#v1)

        local function v3(p1, p2) -- line: 11
            -- upvalues: react (copy), default (copy)
            return react.createElement(default, {
                cascadeIndex = p2,
                entry = p1,
                key = p1.id
            })
        end

        for v4, v5 in v1 do
            local v6 = v4 - 1

            v2[v4] = react.createElement(default, {
                cascadeIndex = v6,
                entry = v5,
                key = v5.id
            })
        end

        return react.createElement(react.Fragment, nil, v2)
    end
}
