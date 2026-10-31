-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local t1 = {
    small = {
        fontSizeNumber = 14,
        height = 36,
        width = 100,
        fontSize = Enum.FontSize.Size14
    },
    medium = {
        fontSizeNumber = 18,
        height = 44,
        width = 120,
        fontSize = Enum.FontSize.Size18
    },
    large = {
        fontSizeNumber = 28,
        height = 52,
        width = 140,
        fontSize = Enum.FontSize.Size28
    }
}
local v1 = Color3.new(0.75, 0.75, 0.75)
local v2 = Color3.new(1, 1, 1)

local function getBorderColor(p1) -- line: 33
    return Color3.new(p1.R * 0.4, p1.G * 0.4, p1.B * 0.4)
end

local function getHighlightColor(p2) -- line: 38
    return Color3.new(math.min(p2.R * 1.3, 1), math.min(p2.G * 1.3, 1), (math.min(p2.B * 1.3, 1)))
end

return {
    default = function(p3) -- GlossyButton | line: 42
        -- upvalues: RuntimeLib (copy), react (copy), useContext (copy), useMotion (copy), ThemeContext (copy), t1 (copy), v1 (copy), v2 (copy)
        local v8 = useContext(ThemeContext)
        local v9 = p3.size or "medium"
        local v10 = (p3.state or "default") == "disabled"
        local v11 = p3.backgroundColor or v1
        local v12 = p3.textColor or v2
        local v13 = Color3.new(v11.R * 0.4, v11.G * 0.4, v11.B * 0.4)
        local v19 = Color3.new(math.min(v11.R * 1.3, 1), math.min(v11.G * 1.3, 1), (math.min(v11.B * 1.3, 1)))
        local v20 = t1[v9]
        local overrideProps = p3.overrideProps

        if overrideProps ~= nil then
            overrideProps = overrideProps.Size
        end

        if overrideProps ~= nil then
            overrideProps = overrideProps.X.Offset
        end

        if overrideProps == nil then
            overrideProps = v20.width
        end

        local overrideProps2 = p3.overrideProps

        if overrideProps2 ~= nil then
            overrideProps2 = overrideProps2.Size
        end

        if overrideProps2 ~= nil then
            overrideProps2 = overrideProps2.Y.Offset
        end

        if overrideProps2 == nil then
            overrideProps2 = v20.height
        end

        UDim2.fromOffset(overrideProps, overrideProps2)

        local v21, v22 = useMotion(1)

        local function v23() -- line: 83
            -- upvalues: p3 (copy), v22 (copy), v10 (copy), RuntimeLib (copy)
            if v10 then
                return nil
            end

            v22:spring(0.9, {
                tension = 400,
                friction = 20
            })
            RuntimeLib.Promise.delay(0.1):andThen(function() -- line: 93
                -- upvalues: v22 (copy)
                v22:spring(1, {
                    tension = 400,
                    friction = 20
                })
            end)

            local onClick = p3.onClick

            if onClick ~= nil then
                onClick()
            end
        end

        local v24 = v21:map(function(p4) -- line: 105
            -- upvalues: overrideProps (ref), overrideProps2 (ref)
            local v25 = overrideProps * p4
            local v26 = overrideProps2 * p4

            return UDim2.fromOffset(v25, v26)
        end)
        local v28 = math.min(overrideProps2 / 3, 10)
        local t2 = {}
        local overrideProps3 = p3.overrideProps

        if overrideProps3 then
            for v29, v30 in overrideProps3 do
                t2[v29] = v30
            end
        end

        t2.Active = not v10
        t2.AutoButtonColor = false
        t2.BackgroundColor3 = if v10 then Color3.new(v11.R * 0.7, v11.G * 0.7, v11.B * 0.7) else v11
        t2.BorderSizePixel = 0
        t2.Event = {
            Activated = v23
        }

        local overrideProps4 = p3.overrideProps

        if overrideProps4 ~= nil then
            overrideProps4 = overrideProps4.Font
        end

        t2.Font = if overrideProps4 == nil then v8.textFont else overrideProps4
        t2.FontSize = v20.fontSize
        t2.Size = v24
        t2.Text = ""
        t2.TextColor3 = v12

        local v31 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0, v28)
        })
        local v32 = react.createElement("uigradient", {
            Rotation = 0,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v19),
                ColorSequenceKeypoint.new(0.5, v11),
                ColorSequenceKeypoint.new(1, v11)
            })
        })
        local v33 = react.createElement("uistroke", {
            Thickness = 4,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = v13,
            Transparency = v10 and 0.5 or 0
        })
        local t4 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        }
        local overrideProps5 = p3.overrideProps

        if overrideProps5 ~= nil then
            overrideProps5 = overrideProps5.Font
        end

        t4.Font = if overrideProps5 == nil then v8.textFont else overrideProps5
        t4.FontSize = v20.fontSize
        t4.Position = UDim2.fromScale(0.5, 0.5)
        t4.RichText = true
        t4.Size = UDim2.fromScale(1, 1)
        t4.Text = ("<b>%*</b>"):format(p3.text)
        t4.TextColor3 = if v10 then Color3.new(v12.R * 0.7, v12.G * 0.7, v12.B * 0.7) else v12
        t4.TextScaled = true
        t4.TextXAlignment = Enum.TextXAlignment.Center
        t4.TextYAlignment = Enum.TextYAlignment.Center

        return react.createElement("textbutton", t2, v31, v32, v33, react.createElement("textlabel", t4, react.createElement("uistroke", {
            Thickness = 2,
            Transparency = 0,
            Color = Color3.new(0, 0, 0)
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = v20.fontSizeNumber + 8,
            MinTextSize = v20.fontSizeNumber - 4
        })), p3.children)
    end
}
