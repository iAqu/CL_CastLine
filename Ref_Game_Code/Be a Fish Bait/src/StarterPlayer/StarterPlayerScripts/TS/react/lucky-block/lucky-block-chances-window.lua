-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootProducer
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local default3 = RuntimeLib.import(script, script.Parent, "lucky-block-drop-chance-list").default
local v1 = Color3.fromRGB(36, 30, 10)
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 232, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(42, 151, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 81, 228))
})

return {
    default = function() -- LuckyBlockChancesWindow | line: 13
        -- upvalues: react (copy), default (copy), default2 (copy), useRootProducer (copy), useScreenSizeState (copy), useTheme (copy), default3 (copy), v1 (copy), v2 (copy)
        local v3 = useRootProducer()
        local v4 = useTheme()
        local v5 = useScreenSizeState() == "sm"

        return react.createElement(default, {
            aspectRatio = 1.35,
            title = "Lucky Block Chances",
            bodyBg = v1,
            headerBg = v4.colorSequences.yellowGradient,
            onClose = function() -- onClose | line: 22
                -- upvalues: v3 (copy)
                return v3.windowClosed({})
            end,
            size = if v5 then UDim2.fromScale(0.9, 0.6) else UDim2.fromScale(0.62, 0.6)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.92, 0.62)
        }, react.createElement(default3)), react.createElement(default2, {
            isShiny = true,
            isStudded = true,
            label = "SHARDS EXCHANGE",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = v2,
            font = v4.textFont2,
            frameSize = UDim2.fromScale(0.56, 0.13),
            onClick = function() -- onClick | line: 40
                -- upvalues: v3 (copy)
                return v3.windowOpened({
                    aquariumShopSection = "shards",
                    currentWindow = "aquariumShop"
                })
            end,
            popoutColor = Color3.fromRGB(18, 66, 151),
            position = UDim2.fromScale(0.5, 0.89),
            size = UDim2.fromScale(0.86, 0.6),
            strokeColor = Color3.fromRGB(5, 21, 58)
        }))
    end
}
