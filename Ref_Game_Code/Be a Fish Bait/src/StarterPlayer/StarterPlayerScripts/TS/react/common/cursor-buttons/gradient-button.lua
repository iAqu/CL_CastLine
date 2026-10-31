-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local t1 = {
    small = {
        fontSizeNumber = 18,
        padding = 8,
        height = 36,
        fontSize = Enum.FontSize.Size18
    },
    medium = {
        fontSizeNumber = 24,
        padding = 12,
        height = 44,
        fontSize = Enum.FontSize.Size24
    },
    large = {
        fontSizeNumber = 36,
        padding = 16,
        height = 56,
        fontSize = Enum.FontSize.Size36
    }
}
local t2 = {
    green = {
        left = Color3.new(0.1, 0.5, 0.2),
        right = Color3.new(0.2, 0.7, 0.3),
        text = Color3.new(1, 1, 1),
        border = Color3.new(0.02, 0.3, 0.1)
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
    }
}

local function getGradientColors(p1, p2, p3) -- line: 59
    -- upvalues: t2 (copy)
    if p2 ~= nil and p3 ~= nil then
        return {
            left = p2,
            right = p3
        }
    end

    local v2 = t2[p1 or "green"]

    return {
        left = v2.left,
        right = v2.right
    }
end

local function getTextColor(_, p5) -- line: 73
    if p5 == nil then
        return Color3.new(1, 1, 1)
    end

    return p5
end

local function getBorderColor(p6, p7) -- line: 80
    -- upvalues: t2 (copy)
    if p7 ~= nil then
        return p7
    end

    return t2[p6 or "green"].border
end

local function getBorderRadius(p8) -- line: 87
    if p8 == "pill" then
        return 999
    end

    if p8 == "rounded" then
        return 8
    end

    if p8 == "square" then
        return 0
    end
end

return {
    default = function(p9) -- GradientButton | line: 100
        -- upvalues: react (copy), useContext (copy), ThemeContext (copy), t1 (copy), t2 (copy), getGradientColors (copy)
        local v4 = useContext(ThemeContext)
        local v5 = p9.size or "medium"
        local v6 = p9.state or "default"
        local v7 = p9.shape or "pill"
        local v8 = t1[v5]
        local v9 = if v7 == "pill" then 999
            elseif v7 == "rounded" then 8
            elseif v7 == "square" then 0
            else nil
        local v10 = v6 == "disabled"
        local v11 = getGradientColors(p9.gradientScheme, p9.gradientLeft, p9.gradientRight)
        local v12 = p9.textColor or Color3.new(1, 1, 1)
        local gradientScheme, borderColor = p9.gradientScheme, p9.borderColor

        if borderColor == nil then
            borderColor = t2[gradientScheme or "green"].border
        end

        local borderThickness = p9.borderThickness

        if borderThickness == nil then
            borderThickness = 3
        end

        local v14, v15

        if v10 then
            v14 = Color3.new(v11.left.R * 0.3, v11.left.G * 0.3, v11.left.B * 0.3)
            v15 = Color3.new(v11.right.R * 0.3, v11.right.G * 0.3, v11.right.B * 0.3)
            v12 = Color3.new(v12.R * 0.5, v12.G * 0.5, v12.B * 0.5)
        else
            v14 = v11.left
            v15 = v11.right
        end

        local t3 = {}
        local overrideProps = p9.overrideProps

        if overrideProps then
            for v16, v17 in overrideProps do
                t3[v16] = v17
            end
        end

        t3.BackgroundColor3 = v14
        t3.BackgroundTransparency = 0
        t3.BorderSizePixel = 0

        local overrideProps2 = p9.overrideProps

        if overrideProps2 ~= nil then
            overrideProps2 = overrideProps2.Size
        end

        t3.Size = if overrideProps2 == nil then UDim2.fromOffset(150, v8.height) else overrideProps2

        return react.createElement("frame", t3, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, v9)
        }), react.createElement("uigradient", {
            Rotation = 0,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v14),
                ColorSequenceKeypoint.new(1, v15)
            })
        }), react.createElement("uistroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = borderColor,
            Thickness = borderThickness,
            Transparency = v10 and 0.5 or 0
        }), react.createElement("textbutton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Active = not v10,
            Font = v4.textFont,
            FontSize = v8.fontSize,
            Size = UDim2.fromScale(1, 1),
            TextColor3 = v12
        }, react.createElement("uipadding", {
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, v8.padding),
            PaddingRight = UDim.new(0, v8.padding),
            PaddingTop = UDim.new(0, 4)
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = v4.textFont,
            FontSize = v8.fontSize,
            Size = UDim2.fromScale(1, 1),
            Text = p9.text,
            TextColor3 = v12,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }, react.createElement("uistroke", {
            Thickness = 2,
            Transparency = 0.2,
            Color = Color3.new(0, 0, 0)
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = v8.fontSizeNumber + 4,
            MinTextSize = v8.fontSizeNumber - 4
        }))), p9.children)
    end
}
