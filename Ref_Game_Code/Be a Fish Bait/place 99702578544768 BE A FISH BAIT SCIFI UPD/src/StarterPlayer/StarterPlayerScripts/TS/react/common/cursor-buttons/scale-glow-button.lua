-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local t1 = {
    rainbow = {
        Color3.new(1, 0.4, 0.1),
        Color3.new(1, 1, 0),
        Color3.new(0, 1, 0.3),
        Color3.new(0, 0.6, 1),
        Color3.new(0.6, 0.2, 1)
    },
    ["orange-red"] = {
        Color3.new(1, 0.62, 0.31),
        Color3.new(1, 0.23, 0.13)
    },
    ["teal-blue"] = {
        Color3.new(0.43, 1, 1),
        Color3.new(0, 0.87, 1)
    },
    ["purple-magenta"] = {
        Color3.new(0.6, 0.2, 1),
        Color3.new(1, 0.2, 0.8)
    },
    ["lime-yellow"] = {
        Color3.new(0.6, 1, 0.2),
        Color3.new(0.8, 1, 0.3)
    },
    ["dark-grey"] = {
        Color3.new(0.6, 0.6, 0.6),
        Color3.new(0.6, 0.6, 0.6)
    }
}
local v1 = Color3.new(0.2, 0.2, 0.2)

local function getBorderColors(p1, p2) -- line: 18
    -- upvalues: t1 (copy)
    if p2 ~= nil and #p2 > 0 then
        return p2
    end

    return t1[p1 or "rainbow"]
end

return {
    default = function(p3) -- ScaleGlowButton | line: 25
        -- upvalues: RuntimeLib (copy), react (copy), useContext (copy), useMotion (copy), ThemeContext (copy), t1 (copy), v1 (copy)
        local v3 = useContext(ThemeContext)
        local v4 = (p3.state or "default") == "disabled"
        local v5 = p3.backgroundColor or v1
        local borderColorScheme, borderColors = p3.borderColorScheme, p3.borderColors

        if borderColors == nil or not (#borderColors > 0) then
            borderColors = t1[borderColorScheme or "rainbow"]
        end

        local v7 = p3.textColor or Color3.new(1, 1, 1)

        if v4 then
            v7 = Color3.new(v7.R * 0.5, v7.G * 0.5, v7.B * 0.5)
            v5 = Color3.new(v5.R * 0.5, v5.G * 0.5, v5.B * 0.5)
        end

        local Scale = p3.size.X.Scale
        local Scale2 = p3.size.Y.Scale
        local v8, v9 = useMotion(1)

        local function v10() -- line: 41
            -- upvalues: p3 (copy), v9 (copy), v4 (copy), RuntimeLib (copy)
            if v4 then
                return nil
            end

            v9:spring(0.9, {
                tension = 400,
                friction = 20
            })
            RuntimeLib.Promise.delay(0.1):andThen(function() -- line: 51
                -- upvalues: v9 (copy)
                v9:spring(1, {
                    tension = 400,
                    friction = 20
                })
            end)

            local onClick = p3.onClick

            if onClick ~= nil then
                onClick()
            end
        end

        local v11 = v8:map(function(p4) -- line: 63
            -- upvalues: Scale (copy), Scale2 (copy)
            local v12 = (Scale + 0.01) * p4
            local v13 = (Scale2 + 0.01) * p4

            return UDim2.new(v12, 0, v13, 0)
        end)
        local v14 = v8:map(function(p5) -- line: 70
            local v15 = 0.88 * p5
            local v16 = 0.88 * p5

            return UDim2.new(v15, 0, v16, 0)
        end)
        local v17 = table.create(#borderColors)

        for v18, v19 in borderColors do
            local v20 = v18 - 1
            local v21 = #borderColors - 1

            if v21 == 0 then
                v21 = 1
            end

            local v22 = v20 / v21

            v17[v18] = ColorSequenceKeypoint.new(v22, v19)
        end

        local v23 = ColorSequence.new(v17)
        local t2 = {}
        local overrideProps = p3.overrideProps

        if overrideProps then
            for v24, v25 in overrideProps do
                t2[v24] = v25
            end
        end

        t2.BackgroundColor3 = borderColors[1]
        t2.BackgroundTransparency = 0
        t2.Size = v11

        local v26 = not p3.disableUiAspectRatio and react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        local v27 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.1, 0)
        })
        local v28 = react.createElement("uigradient", {
            Rotation = 0,
            Color = v23
        })
        local v29 = react.createElement("uistroke", {
            Thickness = 0.5,
            Transparency = 0,
            Color = Color3.new(0, 0, 0)
        })
        local t3 = {
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Active = not v4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v5,
            BackgroundTransparency = p3.backgroundImage == nil and 0.3 or 1,
            Event = {
                Activated = v10
            }
        }
        local backgroundImage = p3.backgroundImage

        t3.Image = if backgroundImage == nil then "" else backgroundImage
        t3.ImageColor3 = p3.backgroundImageColor or v5
        t3.Position = UDim2.fromScale(0.496, 0.496)
        t3.ScaleType = if p3.backgroundImage == nil then Enum.ScaleType.Stretch else Enum.ScaleType.Tile
        t3.Size = v14
        t3.TileSize = p3.backgroundTileSize or UDim2.fromOffset(50, 50)

        return react.createElement("frame", t2, v26, v27, v28, v29, react.createElement("imagebutton", t3, react.createElement("uigradient", {
            Rotation = 0,
            Color = v23
        }), not p3.disableUiAspectRatio and react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement("uicorner", {
            CornerRadius = UDim.new(0.09000000000000001, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.5,
            Transparency = 0,
            Color = Color3.new(0, 0, 0)
        }), p3.backgroundImage == nil and react.createElement("uigradient", {
            Rotation = 45,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v5),
                ColorSequenceKeypoint.new(1, Color3.new(v5.R * 0.8, v5.G * 0.8, v5.B * 0.8))
            })
        }), p3.placeholderImage ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ScaleType = "Fit",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p3.placeholderImage,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 1),
            Font = v3.textFont,
            Position = UDim2.fromScale(0.5, 0.97),
            Size = UDim2.fromScale(1.3, 0.25),
            Text = ("<b>%*</b>"):format(p3.text),
            TextColor3 = v7,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }, react.createElement("uistroke", {
            Thickness = 1.5,
            Transparency = 0.3,
            Color = Color3.new(0, 0, 0)
        })), p3.children))
    end
}
