-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local toolbarRowPositionXScale = RuntimeLib.import(script, script.Parent.Parent, "bottom-bar", "bottom-bar").toolbarRowPositionXScale
local getToolbarMetrics = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "toolbar-metrics").getToolbarMetrics
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useTeleportToMainGame = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-teleport").useTeleportToMainGame
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 112, 232)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(171, 8, 194))
})

return {
    default = function() -- CelebrationTeleportButton | line: 19
        -- upvalues: react (copy), useCallback (copy), HttpService (copy), default (copy), toolbarRowPositionXScale (copy), getToolbarMetrics (copy), useScreenSizeState (copy), useTeleportToMainGame (copy), useRootProducer (copy), v1 (copy)
        local v2 = useRootProducer()
        local v3 = useScreenSizeState() == "lg"
        local teleportToMainGame = useTeleportToMainGame().teleportToMainGame
        local v4 = useCallback(function() -- line: 25
            -- upvalues: v2 (copy), teleportToMainGame (copy), HttpService (copy)
            teleportToMainGame():andThen(function(p1) -- line: 26
                -- upvalues: v2 (copy), HttpService (copy)
                if not p1 then
                    v2.onScreenFeedbackAdded({
                        message = "Could not teleport to main game.",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                end
            end):catch(function() -- line: 34
                -- upvalues: v2 (copy), HttpService (copy)
                v2.onScreenFeedbackAdded({
                    message = "Could not teleport to main game.",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
            end)
        end, { v2, teleportToMainGame })
        local _ = getToolbarMetrics(not v3).toolbarHeight

        return react.createElement(default, {
            cornerRadius = 0.3,
            label = "Teleport to Main Game",
            zIndex = 10,
            anchorPoint = Vector2.new(1, 1),
            color = v1,
            frameSize = UDim2.fromScale(0.1, 0.08),
            onClick = v4,
            popoutColor = Color3.fromRGB(84, 13, 94),
            position = if v3 then UDim2.new(0.99, 0, 0.98, 0) else UDim2.new(toolbarRowPositionXScale, -8, 0.97, 0)
        })
    end
}
