-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent, "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local selectPlayerZoneGacha = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerZoneGacha
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "zone-token-trader")
local zoneTokenBadgeColors, zoneTokenOrder = v1.zoneTokenBadgeColors, v1.zoneTokenOrder

return {
    default = function(p1) -- ZoneTokenBalanceRows | line: 17
        -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), useRootSelector (copy), localPlayerUserId (copy), selectPlayerZoneGacha (copy), zoneTokenBadgeColors (copy), zoneTokenOrder (copy)
        local v2 = useTheme()
        local v3 = useRootSelector(selectPlayerZoneGacha(localPlayerUserId))
        local v4 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0.06, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
        local v5 = table.create(#zoneTokenOrder)

        local function v6(p2, p3) -- line: 29
            -- upvalues: p1 (copy), v2 (copy), v3 (copy), react (copy), default (copy), default2 (copy), zoneTokenBadgeColors (copy)
            local v7 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0.08, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local t1 = {
                color = Color3.new(1, 1, 1)
            }
            local t2 = {
                TextScaled = true,
                Font = v2.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Right
            }
            local zIndex = p1.zIndex

            if zIndex == nil then
                zIndex = 1
            end

            t2.ZIndex = zIndex + 1
            t1.overrideProps = t2

            local v8 = v3

            if v3 ~= nil then
                v8 = v3[p2]
            end

            if v8 == nil then
                v8 = 0
            end

            t1.text = ("%*"):format(v8)

            local v9 = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Size = UDim2.fromScale(0.55, 0.85),
                ZIndex = p1.zIndex
            }, react.createElement(default2, t1))
            local v10 = react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            })
            local t3 = {
                cornerRadius = 0.5,
                isStudded = false,
                strokeThickness = 0.06,
                transparency = 0,
                anchorPoint = Vector2.new(0.5, 0.5),
                backgroundColor = zoneTokenBadgeColors[p2],
                position = UDim2.fromScale(0.5, 0.5),
                size = UDim2.fromScale(1, 1),
                strokeColor = Color3.fromRGB(0, 0, 0)
            }
            local zIndex2 = p1.zIndex

            if zIndex2 == nil then
                zIndex2 = 1
            end

            t3.zIndex = zIndex2 + 1

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                key = p2,
                LayoutOrder = p3,
                Size = UDim2.fromScale(1, 0.28),
                ZIndex = p1.zIndex
            }, v7, v9, react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 2,
                Size = UDim2.fromScale(0.28, 0.85),
                ZIndex = p1.zIndex
            }, v10, react.createElement(default, t3)))
        end

        for v11, v12 in zoneTokenOrder do
            v5[v11] = v6(v12, v11 - 1, zoneTokenOrder)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p1.anchorPoint,
            Position = p1.position,
            Size = p1.size,
            ZIndex = p1.zIndex
        }, v4, v5)
    end
}
