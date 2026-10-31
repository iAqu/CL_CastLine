-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo = react.useMemo
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local useHookArc = RuntimeLib.import(script, script.Parent, "use-hook-arc").useHookArc

return {
    OtherPlayerHookCast = function(p1) -- OtherPlayerHookCast | line: 8
        -- upvalues: react (copy), useMemo (copy), Workspace (copy), useHookArc (copy)
        local castParams, castTimestamp = p1.castParams, p1.castTimestamp

        useHookArc(castParams, (useMemo(function() -- line: 11
            -- upvalues: castTimestamp (copy), Workspace (copy)
            return tick() - (Workspace:GetServerTimeNow() - castTimestamp)
        end, {})))

        return react.createElement(react.Fragment)
    end
}
