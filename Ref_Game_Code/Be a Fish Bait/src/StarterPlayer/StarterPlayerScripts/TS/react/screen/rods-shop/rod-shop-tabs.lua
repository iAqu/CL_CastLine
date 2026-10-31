-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local t1 = {
    {
        label = "Rods",
        tab = "rods",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 70)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 35, 25))
        }),
        popoutColor = Color3.fromRGB(85, 20, 15)
    },
    {
        label = "Skin",
        tab = "skin",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 225, 65)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 125, 0))
        }),
        popoutColor = Color3.fromRGB(80, 48, 5)
    },
    {
        label = "VFX",
        tab = "vfx",
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 210, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 80, 210))
        }),
        popoutColor = Color3.fromRGB(20, 45, 100)
    }
}

return {
    default = function(p1) -- RodShopTabs | line: 21
        -- upvalues: react (copy), default (copy), t1 (copy)
        local v1 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v2 = table.create(#t1)

        local function v3(p2, p3) -- line: 31
            -- upvalues: p1 (copy), react (copy), default (copy)
            local v4 = p1.activeTab == p2.tab

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = p3,
                Size = UDim2.fromScale(1, 0.28),
                ZIndex = 31 + p3,
                key = p2.tab
            }, react.createElement(default, {
                color = p2.color,
                cornerRadius = v4 and 0.075 or 0.055,
                frameSize = UDim2.fromScale(v4 and 1.04 or 0.98, v4 and 1 or 0.92),
                label = p2.label,
                onClick = function() -- onClick | line: 45
                    -- upvalues: p2 (copy), p1 (copy)
                    return p1.onSelectTab(p2.tab)
                end,
                popoutColor = if v4 then Color3.fromRGB(18, 18, 18) else p2.popoutColor,
                position = UDim2.fromScale(0.5, 0.5),
                zIndex = 32 + p3
            }))
        end

        for v5, v6 in t1 do
            v2[v5] = v3(v6, v5 - 1, t1)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 30,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(0, -20, 0.3, 0),
            Size = UDim2.fromScale(0.18, 0.43)
        }, v1, v2)
    end
}
