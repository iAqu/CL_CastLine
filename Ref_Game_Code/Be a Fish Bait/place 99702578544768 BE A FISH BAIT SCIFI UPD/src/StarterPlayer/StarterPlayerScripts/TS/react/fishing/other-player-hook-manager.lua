-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local selectOtherPlayerCasts = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "selectors", "other-player-casts.selectors").selectOtherPlayerCasts
local OtherPlayerHookCast = RuntimeLib.import(script, script.Parent, "other-player-hook-cast").OtherPlayerHookCast

return {
    OtherPlayerHookManager = function() -- OtherPlayerHookManager | line: 7
        -- upvalues: react (copy), useRootSelector (copy), selectOtherPlayerCasts (copy), OtherPlayerHookCast (copy)
        local v1 = useRootSelector(selectOtherPlayerCasts)
        local t1 = {}

        for v2, v3 in v1 do
            local castParams, castTimestamp = v3.castParams, v3.castTimestamp

            table.insert(t1, (react.createElement(OtherPlayerHookCast, {
                castParams = castParams,
                castTimestamp = castTimestamp,
                key = v2
            })))
        end

        return react.createElement(react.Fragment, nil, t1)
    end
}
