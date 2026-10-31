-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, HttpService, Players, Workspace = services.CollectionService, services.HttpService, services.Players, services.Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local toolbarRowPositionXScale = RuntimeLib.import(script, script.Parent.Parent, "bottom-bar", "bottom-bar").toolbarRowPositionXScale
local getToolbarMetrics = RuntimeLib.import(script, script.Parent.Parent, "toolbar", "toolbar-metrics").getToolbarMetrics
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useTeleportToCelebrationPlace = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-teleport").useTeleportToCelebrationPlace
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectPlayerMetadata = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMetadata
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 251, 248)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(81, 239, 251))
})

local function useTeleportToFomoIsland() -- line: 29
    -- upvalues: useCallback (copy), CollectionService (copy), HttpService (copy), Players (copy), Workspace (copy), useTeleportToCelebrationPlace (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerMetadata (copy), localPlayerUserId (copy)
    local v2 = useRootProducer()
    local teleportToCelebrationPlace = useTeleportToCelebrationPlace().teleportToCelebrationPlace
    local v3 = useRootSelector(selectPlayerMetadata(localPlayerUserId))

    if v3 ~= nil then
        v3 = v3.hasVisitedCelebrationIsland
    end

    local v4 = v3 == true
    local v5 = useCallback(function() -- line: 46
        -- upvalues: CollectionService (copy), Players (copy), Workspace (copy)
        local v6 = CollectionService:GetTagged("GiantRigTeleport")[1]

        if v6 ~= nil and v6:IsA("Attachment") then
            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                    local WorldPosition = v6.WorldPosition
                    local v7 = v6.WorldCFrame.LookVector * -1

                    HumanoidRootPart.CFrame = CFrame.new(WorldPosition, WorldPosition + v7)

                    local CurrentCamera = Workspace.CurrentCamera

                    if CurrentCamera ~= nil then
                        local v8 = WorldPosition - v7 * 16 + Vector3.new(0, 6, 0)

                        CurrentCamera.CFrame = CFrame.lookAt(v8, WorldPosition + v7)
                    end

                    return
                end
            end
        end

        return nil
    end, {})

    return {
        handleClick = useCallback(function() -- line: 72
            -- upvalues: v2 (copy), teleportToCelebrationPlace (copy), v5 (copy), v4 (copy), HttpService (copy)
            if not v4 then
                v5()

                return nil
            end

            teleportToCelebrationPlace():andThen(function(p1) -- line: 77
                -- upvalues: v2 (copy), HttpService (copy)
                if not p1 then
                    v2.onScreenFeedbackAdded({
                        message = "Could not teleport to FOMO Island.",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                end
            end):catch(function() -- line: 85
                -- upvalues: v2 (copy), HttpService (copy)
                v2.onScreenFeedbackAdded({
                    message = "Could not teleport to FOMO Island.",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })
            end)
        end, { v2, teleportToCelebrationPlace, v5, v4 })
    }
end

return {
    fomoIslandButtonWidthScale = 0.1,
    fomoIslandButtonHeightScale = 0.08,
    fomoIslandButtonLgPositionXScale = 0.99,
    fomoIslandButtonLgPositionYScale = 0.98,
    useTeleportToFomoIsland = useTeleportToFomoIsland,
    default = function() -- TeleportToFomoIslandButton | line: 105
        -- upvalues: react (copy), default (copy), toolbarRowPositionXScale (copy), getToolbarMetrics (copy), useScreenSizeState (copy), v1 (copy), useTeleportToFomoIsland (copy)
        local v9 = useScreenSizeState() == "lg"
        local handleClick = useTeleportToFomoIsland().handleClick
        local _ = getToolbarMetrics(not v9).toolbarHeight

        return react.createElement(default, {
            cornerRadius = 0.3,
            label = "Teleport to FOMO Island",
            zIndex = 10,
            anchorPoint = Vector2.new(1, 1),
            color = v1,
            frameSize = UDim2.fromScale(0.1, 0.08),
            onClick = handleClick,
            popoutColor = Color3.fromRGB(54, 153, 161),
            position = if v9 then UDim2.new(0.99, 0, 0.98, 0) else UDim2.new(toolbarRowPositionXScale, -8, 0.97, 0)
        })
    end
}
