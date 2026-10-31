-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig
local useCallback = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useCallback

return {
    useSound = function(p1, p2, p3) -- useSound | line: 5
        -- upvalues: useConfig (copy), useCallback (copy)
        local getSound = useConfig().getSound

        return {
            playSound = useCallback(function() -- line: 8
                -- upvalues: p1 (copy), p2 (copy), p3 (copy), getSound (copy)
                local v1 = getSound(p1)

                if p2 ~= nil then
                    v1.PlaybackSpeed = p2
                end

                if p3 ~= nil then
                    v1.TimePosition = p3
                end

                v1:Play()
            end, { getSound, p1, p2, p3 })
        }
    end
}
