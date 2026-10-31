-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default = RuntimeLib.import(script, script.Parent, "topbar-item").default
local useTeleportToHome = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-teleport").useTeleportToHome
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectShouldAutoPromptDailyReward = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectShouldAutoPromptDailyReward
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId

return {
    default = function(_) -- Topbar | line: 12
        -- upvalues: react (copy), useCallback (copy), images (copy), default (copy), useTeleportToHome (copy), useRootSelectorCreator (copy), selectShouldAutoPromptDailyReward (copy), localPlayerUserId (copy)
        local teleportToHome = useTeleportToHome().teleportToHome

        useRootSelectorCreator(selectShouldAutoPromptDailyReward, localPlayerUserId)

        local v1 = useCallback(function() -- line: 16
            -- upvalues: teleportToHome (copy)
            teleportToHome()
        end, { teleportToHome })

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.025),
            Size = UDim2.fromScale(1, 0.075)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.7, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 30)
        }), react.createElement(default, {
            imageXScale = 0.55,
            radialSizeScale = 1.5,
            radialXScale = 0.525,
            sunBurstSizeScale = 0,
            title = "Home",
            imageId = images.houseIcon,
            onClick = v1,
            size = UDim2.fromScale(1, 1)
        })))
    end
}
