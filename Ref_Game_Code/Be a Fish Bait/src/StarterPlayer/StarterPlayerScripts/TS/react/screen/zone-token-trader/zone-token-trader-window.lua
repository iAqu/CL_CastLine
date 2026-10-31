-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "zone-token-balance-rows").default
local default3 = RuntimeLib.import(script, script.Parent, "zone-token-trader-row").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "zone-token-trader")
local zoneTokenBadgeColors, zoneTokenDisplayNames, zoneTokenOrder = v1.zoneTokenBadgeColors, v1.zoneTokenDisplayNames, v1.zoneTokenOrder
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 140, 145)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 100, 105))
})

return {
    default = function(p1) -- ZoneTokenTraderWindow | line: 12
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), zoneTokenBadgeColors (copy), zoneTokenDisplayNames (copy), zoneTokenOrder (copy), v2 (copy)
        local v3 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
        local v4 = table.create(#zoneTokenOrder)

        local function v5(p2, p3) -- line: 22
            -- upvalues: p1 (copy), react (copy), default3 (copy), zoneTokenBadgeColors (copy), zoneTokenDisplayNames (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 2,
                key = p2,
                LayoutOrder = p3,
                Size = UDim2.fromScale(1, 0.3)
            }, react.createElement(default3, {
                onSelectToken = function() -- onSelectToken | line: 31
                    -- upvalues: p2 (copy), p1 (copy)
                    return p1.onSelectToken(p2)
                end,
                tokenBadgeColor = zoneTokenBadgeColors[p2],
                tokenLabel = zoneTokenDisplayNames[p2]
            }))
        end

        for v6, v7 in zoneTokenOrder do
            v4[v6] = v5(v7, v6 - 1, zoneTokenOrder)
        end

        return react.createElement(default, {
            aspectRatio = 1.5,
            title = "Zone Token Trader",
            bodyBg = Color3.fromRGB(20, 20, 24),
            headerBg = v2,
            onClose = p1.onClose,
            size = UDim2.fromScale(0.75, 0.6)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.4),
            Size = UDim2.fromScale(0.95, 0.6)
        }, v3, v4), react.createElement(default2, {
            zIndex = 2,
            anchorPoint = Vector2.new(1, 1),
            position = UDim2.fromScale(0.97, 0.97),
            size = UDim2.fromScale(0.35, 0.2)
        }))
    end
}
