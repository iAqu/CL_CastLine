-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local t1 = {
    small = {
        fontSizeNumber = 18,
        height = 80,
        width = 80,
        fontSize = Enum.FontSize.Size18
    },
    medium = {
        fontSizeNumber = 24,
        height = 100,
        width = 100,
        fontSize = Enum.FontSize.Size24
    },
    large = {
        fontSizeNumber = 36,
        height = 120,
        width = 120,
        fontSize = Enum.FontSize.Size36
    }
}
local t2 = {
    rainbow = {
        Color3.new(1, 0.4, 0.1),
        Color3.new(1, 1, 0),
        Color3.new(0, 1, 0.3),
        Color3.new(0, 0.6, 1),
        Color3.new(0.6, 0.2, 1)
    },
    ["orange-red"] = {
        Color3.new(1, 0.5, 0.1),
        Color3.new(1, 0.2, 0.1)
    },
    ["teal-blue"] = {
        Color3.new(0, 0.8, 0.8),
        Color3.new(0.3, 0.9, 1)
    },
    ["purple-magenta"] = {
        Color3.new(0.6, 0.2, 1),
        Color3.new(1, 0.2, 0.8)
    },
    ["lime-yellow"] = {
        Color3.new(0.6, 1, 0.2),
        Color3.new(0.8, 1, 0.3)
    }
}
local v1 = Color3.new(0.1, 0.1, 0.1)

local function getBorderColors(p1, p2) -- line: 37
    -- upvalues: t2 (copy)
    if p2 ~= nil and #p2 > 0 then
        return p2
    end

    return t2[p1 or "rainbow"]
end

local function getBorderRadius(p3) -- line: 44
    if p3 == "pill" then
        return 999
    end

    if p3 == "rounded" then
        return 16
    end

    if p3 == "square" then
        return 0
    end
end

return {
    default = function(p4) -- GlowButton | line: 57
        -- upvalues: RuntimeLib (copy), react (copy), useContext (copy), useMotion (copy), ThemeContext (copy), t1 (copy), t2 (copy), v1 (copy)
        local v3 = useContext(ThemeContext)
        local v4 = p4.size or "medium"
        local v5 = p4.state or "default"
        local v6 = p4.shape or "rounded"
        local v7 = t1[v4]
        local v8 = if v6 == "pill" then 999
            elseif v6 == "rounded" then 16
            elseif v6 == "square" then 0
            else nil
        local v9 = v5 == "disabled"
        local v10 = p4.backgroundColor or v1
        local borderColorScheme, borderColors = p4.borderColorScheme, p4.borderColors

        if borderColors == nil or not (#borderColors > 0) then
            borderColors = t2[borderColorScheme or "rainbow"]
        end

        local v12 = p4.textColor or Color3.new(1, 1, 1)

        if v9 then
            v12 = Color3.new(v12.R * 0.5, v12.G * 0.5, v12.B * 0.5)
            v10 = Color3.new(v10.R * 0.5, v10.G * 0.5, v10.B * 0.5)
        end

        local v13 = UDim2.fromOffset(v7.width, v7.height)

        local function v14(p5, p6) -- line: 77
            -- upvalues: v7 (copy)
            if p5 ~= nil then
                local Offset = if p6 then p5.X.Offset else p5.Y.Offset
                local Scale = if p6 then p5.X.Scale else p5.Y.Scale

                if Offset == 0 and Scale ~= 0 then
                    local v15 = if p6 then v7.width else v7.height

                    return v15 * Scale
                end

                if Offset ~= 0 then
                    return Offset
                end
            end

            if p6 then
                return v7.width
            end

            return v7.height
        end

        local overrideProps = p4.overrideProps

        if overrideProps ~= nil then
            overrideProps = overrideProps.Size
        end

        local v16, v17, v18

        if overrideProps ~= nil then
            if typeof(overrideProps) == "UDim2" then
                v16 = v14(overrideProps, true)
                v17 = v16
                v18 = v14(overrideProps, false)
            else
                v16 = v7.width
                v17 = v16
                v18 = v7.height
            end
        else
            v16 = v14(v13, true)
            v17 = v16
            v18 = v14(v13, false)
        end

        local v19 = v16 + 8
        local v20 = v18 + 8
        local v21, v22 = useMotion(1)

        local function v23() -- line: 120
            -- upvalues: p4 (copy), v22 (copy), v9 (copy), RuntimeLib (copy)
            if v9 then
                return nil
            end

            v22:spring(0.9, {
                tension = 400,
                friction = 20
            })
            RuntimeLib.Promise.delay(0.1):andThen(function() -- line: 130
                -- upvalues: v22 (copy)
                v22:spring(1, {
                    tension = 400,
                    friction = 20
                })
            end)

            local onClick = p4.onClick

            if onClick ~= nil then
                onClick()
            end
        end

        local v24 = v21:map(function(p7) -- line: 143
            -- upvalues: v19 (copy), v20 (copy)
            local v25 = v19 * p7
            local v26 = v20 * p7

            return UDim2.fromOffset(v25, v26)
        end)
        local v27 = v21:map(function(p8) -- line: 148
            -- upvalues: overrideProps (ref), v17 (ref), v18 (ref)
            local overrideProps2, v28

            if overrideProps ~= nil and typeof(overrideProps) == "UDim2" then
                overrideProps2 = overrideProps
                v28 = if overrideProps.X.Offset == 0 then v17 else overrideProps.X.Offset

                local v29 = v28 * p8
                local v30 = (if overrideProps2.Y.Offset == 0 then v18 else overrideProps2.Y.Offset) * p8
                local v31 = if overrideProps2.X.Scale == 0 then 0 else overrideProps2.X.Scale
                local v32 = if overrideProps2.Y.Scale == 0 then 0 else overrideProps2.Y.Scale

                return UDim2.new(v31, v29, v32, v30)
            end

            local v33 = v17 * p8
            local v34 = v18 * p8

            return UDim2.fromOffset(v33, v34)
        end)
        local v35 = table.create(#borderColors)

        for v36, v37 in borderColors do
            local v38 = v36 - 1
            local v39 = #borderColors - 1
            local v40 = v38 / (v39 ~= 0 and v39 == v39 and v39 or 1)

            v35[v36] = ColorSequenceKeypoint.new(v40, v37)
        end

        local v41 = ColorSequence.new(v35)
        local t3 = {}
        local overrideProps2 = p4.overrideProps

        if overrideProps2 then
            for v42, v43 in overrideProps2 do
                t3[v42] = v43
            end
        end

        t3.BackgroundColor3 = borderColors[1]
        t3.BackgroundTransparency = 0
        t3.BorderSizePixel = 0
        t3.Size = v24

        return react.createElement("frame", t3, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, v8 + 4)
        }), react.createElement("uigradient", {
            Rotation = 0,
            Color = v41
        }), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            BackgroundColor3 = v10,
            Position = v21:map(function(p9) -- line: 200
                local v46 = 4 * p9

                return UDim2.fromOffset(v46, v46)
            end),
            Size = v27
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, v8)
        }), react.createElement("uigradient", {
            Rotation = 45,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v10),
                ColorSequenceKeypoint.new(1, Color3.new(v10.R * 0.8, v10.G * 0.8, v10.B * 0.8))
            })
        }), p4.placeholderImage ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p4.placeholderImage,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.6, 0.6)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 1),
            Font = v3.textFont,
            FontSize = v7.fontSize,
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromScale(0.9, 0.3),
            Text = ("<b>%*</b>"):format(p4.text),
            TextColor3 = v12,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }, react.createElement("uistroke", {
            Thickness = 2,
            Transparency = 0.3,
            Color = Color3.new(0, 0, 0)
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = v7.fontSizeNumber,
            MinTextSize = v7.fontSizeNumber - 6
        })), react.createElement("textbutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Active = not v9,
            Event = {
                Activated = v23
            },
            Size = UDim2.fromScale(1, 1)
        }), p4.children))
    end
}
