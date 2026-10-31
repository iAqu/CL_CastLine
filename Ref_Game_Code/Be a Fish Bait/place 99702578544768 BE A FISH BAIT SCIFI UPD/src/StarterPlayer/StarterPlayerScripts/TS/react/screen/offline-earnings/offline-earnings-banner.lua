-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local memo, useEffect = react.memo, react.useEffect
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPlayerAquariumMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquariumMoneyPerSecond
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local offlineEarningsConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "offline-earnings-utils").offlineEarningsConfig
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme

return {
    VISIBLE_Y = 0.135,
    VISIBLE_Y_TRAINING = 0.25,
    HIDDEN_Y = 0.09,
    default = memo(function(p1) -- OfflineEarningsBanner | line: 19
        -- upvalues: react (copy), useEffect (copy), useMotion (copy), useRootSelector (copy), selectPlayerAquariumMoneyPerSecond (copy), localPlayerUserId (copy), abbreviate (copy), offlineEarningsConfig (copy), default (copy), useTheme (copy)
        local isTraining, visible = p1.isTraining, p1.visible
        local v1 = useTheme()
        local v2 = useRootSelector(selectPlayerAquariumMoneyPerSecond(localPlayerUserId))
        local v3 = visible and v2 > 0
        local v4, v5 = useMotion(0.09)
        local v6, v7 = useMotion(0)

        useEffect(function() -- line: 27
            -- upvalues: isTraining (copy), v5 (copy), v7 (copy), v3 (copy)
            if not v3 then
                v5:tween(0.09, {
                    time = 0.25,
                    style = Enum.EasingStyle.Quad,
                    direction = Enum.EasingDirection.In
                })
                v7:tween(0, {
                    time = 0.2
                })

                return
            end

            v5:tween(isTraining and 0.25 or 0.135, {
                time = 0.35,
                style = Enum.EasingStyle.Back,
                direction = Enum.EasingDirection.Out
            })
            v7:tween(1, {
                time = 0.2
            })
        end, { v3, isTraining })

        if v2 <= 0 then
            return nil
        end

        local v10 = abbreviate(v2 * 86400 * offlineEarningsConfig.offlineFactor)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = v4:map(function(p2) -- line: 57
                return UDim2.fromScale(0.5, p2)
            end),
            Size = UDim2.fromScale(0.6, 0.055)
        }, react.createElement(default, {
            shadowYScale = 0,
            color = Color3.new(1, 1, 1),
            overrideProps = {
                RichText = true,
                TextScaled = true,
                Font = v1.textFont,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.07,
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            },
            text = ("Your fishes earn <font color=\"rgb(78,254,86)\">$%*</font>/Day offline! 🤑"):format(v10),
            textTransparency = v6:map(function(p3) -- line: 76
                return 1 - p3
            end)
        }))
    end)
}
