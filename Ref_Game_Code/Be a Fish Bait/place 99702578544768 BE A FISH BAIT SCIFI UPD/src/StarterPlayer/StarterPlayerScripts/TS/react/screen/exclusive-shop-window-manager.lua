-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootProducer
local default = RuntimeLib.import(script, script.Parent, "exclusive-shop", "exclusive-shop-window-v2").default

return {
    default = function() -- ExclusiveShopWindowManager | line: 7
        -- upvalues: Flamework (copy), react (copy), useRootProducer (copy), default (copy)
        local v1 = useRootProducer()

        local function v2() -- line: 9
            -- upvalues: v1 (copy)
            v1.windowClosed({})
        end

        return react.createElement(default, {
            onClose = v2,
            onPreviewMount = function(p1) -- onPreviewMount | line: 15
                -- upvalues: v1 (copy), Flamework (copy)
                if not Flamework.resolveDependency("client/controllers/mount-fish-preview-controller@MountFishPreviewController"):startPreview(p1, true) then
                    return nil
                end

                v1.windowClosed({})
            end
        })
    end
}
