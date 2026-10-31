-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local v1 = Color3.new(0.75, 0.75, 0.75)
local v2 = Color3.new(1, 1, 1)

local function getBorderColor(p1) -- line: 13
    return Color3.new(p1.R * 0.4, p1.G * 0.4, p1.B * 0.4)
end

local function getHighlightColor(p2) -- line: 18
    return Color3.new(math.min(p2.R * 1.3, 1), math.min(p2.G * 1.3, 1), (math.min(p2.B * 1.3, 1)))
end

return {
    default = function(p3) -- ScaleGlossyButton | line: 22
        -- upvalues: RuntimeLib (copy), react (copy), useContext (copy), useMotion (copy), ThemeContext (copy), v1 (copy), v2 (copy)
        local v8 = useContext(ThemeContext)
        local v9 = (p3.state or "default") == "disabled"
        local v10 = p3.backgroundColor or v1
        local v11 = p3.textColor or v2
        local v12 = Color3.new(v10.R * 0.4, v10.G * 0.4, v10.B * 0.4)
        local v18 = Color3.new(math.min(v10.R * 1.3, 1), math.min(v10.G * 1.3, 1), (math.min(v10.B * 1.3, 1)))
        local Scale = p3.size.X.Scale
        local Scale2 = p3.size.Y.Scale
        local v19, v20 = useMotion(1)

        local function v21() -- line: 37
            -- upvalues: p3 (copy), v20 (copy), v9 (copy), RuntimeLib (copy)
            if v9 then
                return nil
            end

            v20:spring(0.9, {
                tension = 400,
                friction = 20
            })
            RuntimeLib.Promise.delay(0.1):andThen(function() -- line: 47
                -- upvalues: v20 (copy)
                v20:spring(1, {
                    tension = 400,
                    friction = 20
                })
            end)

            local onClick = p3.onClick

            if onClick ~= nil then
                onClick()
            end
        end

        local v22 = v19:map(function(p4) -- line: 59
            -- upvalues: Scale (copy), Scale2 (copy)
            local v23 = Scale * p4
            local v24 = Scale2 * p4

            return UDim2.new(v23, 0, v24, 0)
        end)
        local t1 = {}
        local overrideProps = p3.overrideProps

        if overrideProps then
            for v25, v26 in overrideProps do
                t1[v25] = v26
            end
        end

        t1.Active = not v9
        t1.AutoButtonColor = false
        t1.BackgroundColor3 = if v9 then Color3.new(v10.R * 0.7, v10.G * 0.7, v10.B * 0.7) else v10
        t1.BorderSizePixel = 0
        t1.Event = {
            Activated = v21
        }

        local overrideProps2 = p3.overrideProps

        if overrideProps2 ~= nil then
            overrideProps2 = overrideProps2.Font
        end

        t1.Font = if overrideProps2 == nil then v8.textFont else overrideProps2
        t1.FontSize = Enum.FontSize.Size18
        t1.Size = v22
        t1.Text = ""
        t1.TextColor3 = v11

        local padding = p3.padding

        if padding ~= nil then
            padding = padding.bottom
        end

        if padding == nil then
            padding = UDim.new(0.1, 0)
        end

        local t2 = {}

        t2.PaddingBottom = padding

        local padding2 = p3.padding

        if padding2 ~= nil then
            padding2 = padding2.left
        end

        t2.PaddingLeft = if padding2 == nil then UDim.new(0.05, 0) else padding2

        local padding3 = p3.padding

        if padding3 ~= nil then
            padding3 = padding3.right
        end

        t2.PaddingRight = if padding3 == nil then UDim.new(0.05, 0) else padding3

        local padding4 = p3.padding

        if padding4 ~= nil then
            padding4 = padding4.top
        end

        t2.PaddingTop = if padding4 == nil then UDim.new(0.1, 0) else padding4

        local v27 = react.createElement("uipadding", t2)
        local v28 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })
        local v29 = react.createElement("uigradient", {
            Rotation = 0,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, v18),
                ColorSequenceKeypoint.new(0.5, v10),
                ColorSequenceKeypoint.new(1, v10)
            })
        })
        local v30 = react.createElement("uistroke", {
            Thickness = 4,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = v12,
            Transparency = v9 and 0.5 or 0
        })
        local t4 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        }
        local overrideProps3 = p3.overrideProps

        if overrideProps3 ~= nil then
            overrideProps3 = overrideProps3.Font
        end

        t4.Font = if overrideProps3 == nil then v8.textFont else overrideProps3
        t4.FontSize = Enum.FontSize.Size18
        t4.Position = UDim2.fromScale(0.5, 0.5)
        t4.RichText = true
        t4.Size = UDim2.fromScale(1, 1)
        t4.Text = ("<b>%*</b>"):format(p3.text)
        t4.TextColor3 = if v9 then Color3.new(v11.R * 0.7, v11.G * 0.7, v11.B * 0.7) else v11
        t4.TextScaled = true
        t4.TextXAlignment = Enum.TextXAlignment.Center
        t4.TextYAlignment = Enum.TextYAlignment.Center

        return react.createElement("textbutton", t1, v27, v28, v29, v30, react.createElement("textlabel", t4, react.createElement("uistroke", {
            Thickness = 2,
            Transparency = 0,
            Color = Color3.new(0, 0, 0)
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = 24,
            MinTextSize = 14
        })), p3.children)
    end
}
