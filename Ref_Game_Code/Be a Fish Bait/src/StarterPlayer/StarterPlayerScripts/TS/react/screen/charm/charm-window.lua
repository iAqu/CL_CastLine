-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent, "inventory", "charm-inventory").default
local default3 = RuntimeLib.import(script, script.Parent, "inventory", "charm-rarity-nav").default

return {
    default = function(p1) -- CharmWindow | line: 9
        -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), default3 (copy)
        local all, all2 = useState("all")
        local v1 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.28
        })
        local v2 = table.clone(p1.inventoryProps)

        setmetatable(v2, nil)
        v2.selectedRarity = all

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.64, 0.68)
        }, v1, react.createElement(default, {
            title = "Charm",
            bodyBg = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 64, 86)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 30, 46))
            }),
            headerBg = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 231, 244)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(41, 151, 218)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(183, 42, 72))
            }),
            onClose = p1.onClose,
            size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.97),
            Size = UDim2.fromScale(0.94, 0.82)
        }, react.createElement(default2, v2))), react.createElement(default3, {
            onSelectedRarityChanged = all2,
            selectedRarity = all
        }))
    end
}
