-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local default = RuntimeLib.import(script, script.Parent, "aquarium-manager").default

return {
    default = function(p1) -- AquariumWindowManager | line: 8
        -- upvalues: react (copy), useCallback (copy), useRootProducer (copy), default (copy)
        local getInitialTab, onClearInitialTab, onOpenSourceWindow = p1.getInitialTab, p1.onClearInitialTab, p1.onOpenSourceWindow
        local v1 = useRootProducer()
        local v2 = useCallback(function() -- line: 13
            -- upvalues: v1 (copy)
            v1.windowClosed({})
        end, { v1 })

        return react.createElement(default, {
            getInitialTab = getInitialTab,
            onClearInitialTab = onClearInitialTab,
            onClose = v2,
            onOpenSourceWindow = onOpenSourceWindow
        })
    end
}
