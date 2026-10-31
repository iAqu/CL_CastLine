-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local v1 = Color3.new(0.8, 0.1, 0.1)
local v2 = Color3.new(0.9, 0.2, 0.2)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.new(0.4, 0.02, 0.02)

return {
    default = function(p1) -- ScaleCloseButton | line: 15
        -- upvalues: RuntimeLib (copy), react (copy), useContext (copy), useMotion (copy), ThemeContext (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
        local v5 = useContext(ThemeContext)
        local v6 = (p1.state or "default") == "disabled"
        local v7 = p1.backgroundColor or v1
        local v8 = p1.borderColor or v2
        local v9 = p1.xColor or v3
        local v10 = p1.xOutlineColor or v4
        local borderThickness = p1.borderThickness

        if borderThickness == nil then
            borderThickness = 3
        end

        local xOutlineThickness = p1.xOutlineThickness

        if xOutlineThickness == nil then
            xOutlineThickness = 3
        end

        if v6 then
            v7 = Color3.new(v7.R * 0.3, v7.G * 0.3, v7.B * 0.3)
            v8 = Color3.new(v8.R * 0.3, v8.G * 0.3, v8.B * 0.3)
            v9 = Color3.new(v9.R * 0.5, v9.G * 0.5, v9.B * 0.5)
            v10 = Color3.new(v10.R * 0.5, v10.G * 0.5, v10.B * 0.5)
        end

        local Scale = p1.size.X.Scale
        local Scale2 = p1.size.Y.Scale
        local v11, v12 = useMotion(1)

        local function v13() -- line: 44
            -- upvalues: p1 (copy), v12 (copy), v6 (copy), RuntimeLib (copy)
            if v6 then
                return nil
            end

            v12:spring(0.9, {
                tension = 400,
                friction = 20
            })
            RuntimeLib.Promise.delay(0.1):andThen(function() -- line: 54
                -- upvalues: v12 (copy)
                v12:spring(1, {
                    tension = 400,
                    friction = 20
                })
            end)

            local onClick = p1.onClick

            if onClick ~= nil then
                onClick()
            end
        end

        local v14 = v11:map(function(p2) -- line: 66
            -- upvalues: Scale (copy), Scale2 (copy)
            local v15 = Scale * p2
            local v16 = Scale2 * p2

            return UDim2.new(v15, 0, v16, 0)
        end)
        local t1 = {}
        local overrideProps = p1.overrideProps

        if overrideProps then
            for v17, v18 in overrideProps do
                t1[v17] = v18
            end
        end

        t1.BackgroundColor3 = v7
        t1.BackgroundTransparency = 0
        t1.BorderSizePixel = 0
        t1.Size = v14

        local v19 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })
        local v20 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 0)
        })
        local v21 = react.createElement("uistroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = v8,
            Thickness = borderThickness,
            Transparency = v6 and 0.5 or 0
        })
        local t3 = {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Active = not v6,
            Event = {
                Activated = v13
            },
            Font = v5.textFont,
            FontSize = Enum.FontSize.Size24,
            Interactable = not v6,
            Size = UDim2.fromScale(1, 1)
        }
        local overrideProps2 = p1.overrideProps

        if overrideProps2 ~= nil then
            overrideProps2 = overrideProps2.ZIndex
        end

        t3.ZIndex = if overrideProps2 == nil then 1 else overrideProps2

        local t4 = {
            BackgroundTransparency = 1,
            RichText = true,
            Text = "<b>X</b>",
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = v5.textFont,
            Position = UDim2.fromScale(0.496, 0.496),
            Size = UDim2.fromScale(1, 1),
            TextColor3 = v9,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }
        local overrideProps3 = p1.overrideProps

        if overrideProps3 ~= nil then
            overrideProps3 = overrideProps3.ZIndex
        end

        t4.ZIndex = if overrideProps3 == nil then 1 else overrideProps3

        return react.createElement("frame", t1, v19, v20, v21, react.createElement("textbutton", t3, react.createElement("textlabel", t4, react.createElement("uistroke", {
            Transparency = 0,
            Color = v10,
            Thickness = xOutlineThickness
        }))), p1.children)
    end
}
