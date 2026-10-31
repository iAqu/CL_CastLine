-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local default = RuntimeLib.import(script, script.Parent, "rods-shop").default

return {
    default = function() -- RodsShopWindowManager | line: 8
        -- upvalues: react (copy), useCallback (copy), useRootProducer (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useCallback(function() -- line: 10
            -- upvalues: v1 (copy)
            v1.windowClosed({})
        end, { v1 })
        local v3 = useCallback(function(p1) -- line: 13
            -- upvalues: v1 (copy)
            v1.windowOpened({
                currentWindow = if p1 == "rods" then "rodsShop" elseif p1 == "skin" then "rodSkins" else "rodShopVfx"
            })
        end, { v1 })

        return react.createElement(default, {
            onClose = v2,
            onSelectTab = v3
        })
    end
}
