-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useCallback = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useCallback
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig

return {
    useTeleportToHome = function() -- useTeleportToHome | line: 6
        -- upvalues: useConfig (copy)
        return {
            teleportToHome = useConfig().teleportToHome
        }
    end,
    useTeleportToMainGame = function() -- useTeleportToMainGame | line: 18
        -- upvalues: useCallback (copy), functions (copy)
        return {
            teleportToMainGame = useCallback(function() -- line: 19
                -- upvalues: functions (copy)
                return functions.teleportToMainGame()
            end, {})
        }
    end,
    useTeleportToCelebrationPlace = function() -- useTeleportToCelebrationPlace | line: 30
        -- upvalues: useCallback (copy), functions (copy)
        return {
            teleportToCelebrationPlace = useCallback(function() -- line: 31
                -- upvalues: functions (copy)
                return functions.teleportToCelebrationPlace()
            end, {})
        }
    end
}
