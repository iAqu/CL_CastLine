-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local t1 = {
    green = {
        left = Color3.new(0.22, 0.97, 0.4),
        right = Color3.new(0.26, 0.91, 0.39),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.05, 0.86, 0.29)
    },
    blue = {
        left = Color3.new(0.1, 0.3, 0.6),
        right = Color3.new(0.2, 0.5, 0.8),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.02, 0.15, 0.4)
    },
    purple = {
        left = Color3.new(0.4, 0.1, 0.6),
        right = Color3.new(0.6, 0.2, 0.8),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.25, 0.02, 0.4)
    },
    red = {
        left = Color3.new(0.6, 0.1, 0.1),
        right = Color3.new(0.8, 0.2, 0.2),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.4, 0.02, 0.02)
    },
    orange = {
        left = Color3.new(0.6, 0.3, 0.1),
        right = Color3.new(0.8, 0.5, 0.2),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.4, 0.15, 0.02)
    },
    black = {
        left = Color3.new(0.05, 0.05, 0.05),
        right = Color3.new(0.21, 0.21, 0.21),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.1, 0.1, 0.1)
    },
    shopOrange = {
        left = Color3.new(1, 0.78, 0.1),
        right = Color3.new(1, 0.76, 0.1),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.7, 0.5, 0.1)
    }
}

local function getBorderRadius(p1) -- line: 52
    if p1 == "pill" then
        return 999
    end

    if p1 == "rounded" then
        return 8
    end

    if p1 == "square" then
        return 0
    end
end

local function getGradientColors(p2, p3, p4) -- line: 65
    -- upvalues: t1 (copy)
    if p3 ~= nil and p4 ~= nil then
        return {
            left = p3,
            right = p4
        }
    end

    local v2 = t1[p2 or "green"]

    return {
        left = v2.left,
        right = v2.right
    }
end

local function getTextColor(_, p6) -- line: 79
    if p6 == nil then
        return Color3.new(1, 1, 1)
    end

    return p6
end

local function getBorderColor(p7, p8) -- line: 86
    -- upvalues: t1 (copy)
    if p8 ~= nil then
        return p8
    end

    return t1[p7 or "green"].border
end

return {
    default = function(p9) -- ScaleGradientButton | line: 93
        -- upvalues: RuntimeLib (copy), react (copy), useContext (copy), useMotion (copy), ThemeContext (copy), t1 (copy), getGradientColors (copy)
        local v4 = useContext(ThemeContext)
        local v5 = (p9.state or "default") == "disabled"
        local shape = p9.shape
        local v6 = if shape == "pill" then 999
            elseif shape == "rounded" then 8
            elseif shape == "square" then 0
            else nil
        local Scale = p9.size.X.Scale
        local Scale2 = p9.size.Y.Scale
        local v7 = getGradientColors(p9.gradientScheme, p9.gradientLeft, p9.gradientRight)
        local _, textColor = p9.gradientScheme, p9.textColor

        if textColor == nil then
            textColor = Color3.new(1, 1, 1)
        end

        local gradientScheme, borderColor = p9.gradientScheme, p9.borderColor

        if borderColor == nil then
            borderColor = t1[gradientScheme or "green"].border
        end

        local borderThickness = p9.borderThickness

        if borderThickness == nil then
            borderThickness = 3
        end

        local v9, v10

        if v5 then
            v9 = Color3.new(v7.left.R * 0.3, v7.left.G * 0.3, v7.left.B * 0.3)
            v10 = Color3.new(v7.right.R * 0.3, v7.right.G * 0.3, v7.right.B * 0.3)
            textColor = Color3.new(textColor.R * 0.5, textColor.G * 0.5, textColor.B * 0.5)
        else
            v9 = v7.left
            v10 = v7.right
        end

        local v11, v12 = useMotion(1)

        local function v13() -- line: 116
            -- upvalues: p9 (copy), v12 (copy), v5 (copy), RuntimeLib (copy)
            if v5 then
                return nil
            end

            v12:spring(0.9, {
                tension = 400,
                friction = 20
            })
            RuntimeLib.Promise.delay(0.1):andThen(function() -- line: 126
                -- upvalues: v12 (copy)
                v12:spring(1, {
                    tension = 400,
                    friction = 20
                })
            end)

            local onClick = p9.onClick

            if onClick ~= nil then
                onClick()
            end
        end

        local v14 = v11:map(function(p10) -- line: 138
            -- upvalues: Scale (copy), Scale2 (copy)
            local v15 = Scale * p10
            local v16 = Scale2 * p10

            return UDim2.new(v15, 0, v16, 0)
        end)
        local t2 = {}
        local overrideProps = p9.overrideProps

        if overrideProps then
            for v17, v18 in overrideProps do
                t2[v17] = v18
            end
        end

        t2.BackgroundColor3 = v9
        t2.BackgroundTransparency = 0
        t2.BorderSizePixel = 0
        t2.Size = v14

        local v19 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0, v6)
        })
        local v20 = react.createElement("uigradient", {
            Rotation = 0,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v9),
                ColorSequenceKeypoint.new(1, v10)
            })
        })
        local v21 = react.createElement("uistroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = borderColor,
            Thickness = borderThickness,
            Transparency = v5 and 0.5 or 0
        })
        local t4 = {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Active = not v5,
            Event = {
                MouseButton1Click = v13
            },
            Font = v4.textFont,
            FontSize = Enum.FontSize.Size24,
            Interactable = not v5,
            Size = UDim2.fromScale(1, 1),
            TextColor3 = textColor
        }
        local overrideProps2 = p9.overrideProps

        if overrideProps2 ~= nil then
            overrideProps2 = overrideProps2.ZIndex
        end

        t4.ZIndex = if overrideProps2 == nil then 1 else overrideProps2

        local v22 = react.createElement("uipadding", {
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0.05, 0),
            PaddingRight = UDim.new(0.05, 0),
            PaddingTop = UDim.new(0, 4)
        })
        local t5 = {
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            Font = v4.textFont,
            Size = UDim2.fromScale(1, 1),
            Text = ("<b>%*</b>"):format(p9.text),
            TextColor3 = textColor,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }
        local overrideProps3 = p9.overrideProps

        if overrideProps3 ~= nil then
            overrideProps3 = overrideProps3.ZIndex
        end

        t5.ZIndex = if overrideProps3 == nil then 1 else overrideProps3

        return react.createElement("frame", t2, v19, v20, v21, react.createElement("textbutton", t4, v22, react.createElement("textlabel", t5, react.createElement("uistroke", {
            Thickness = 2,
            Transparency = 0.2,
            Color = Color3.new(0, 0, 0)
        }))), p9.children)
    end
}
