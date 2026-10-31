-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent, "context", "theme-context").ThemeContext

return {
    default = function(p1) -- StyledImageButton | line: 7
        -- upvalues: react (copy), useContext (copy), ThemeContext (copy)
        local v1 = useContext(ThemeContext)
        local overrideProps = p1.overrideProps

        if overrideProps ~= nil then
            overrideProps = overrideProps.ZIndex
        end

        if overrideProps == nil then
            overrideProps = 1
        end

        local v2 = overrideProps + 1
        local t1 = {}
        local overrideProps2 = p1.overrideProps

        if overrideProps2 then
            for v3, v4 in overrideProps2 do
                t1[v3] = v4
            end
        end

        t1.Image = p1.image
        t1.ScaleType = "Crop"
        t1.Size = UDim2.fromScale(1, 1)

        local t2 = {}
        local textLabelProps = p1.textLabelProps

        if textLabelProps then
            for v5, v6 in textLabelProps do
                t2[v5] = v6
            end
        end

        t2.BackgroundTransparency = 1

        local textLabelProps2 = p1.textLabelProps

        if textLabelProps2 ~= nil then
            textLabelProps2 = textLabelProps2.Font
        end

        t2.Font = if textLabelProps2 == nil then v1.textFont else textLabelProps2
        t2.Size = UDim2.fromScale(1, 1)
        t2.Text = p1.text
        t2.TextColor3 = Color3.new(1, 1, 1)
        t2.TextScaled = true
        t2.TextXAlignment = "Center"
        t2.TextYAlignment = "Center"
        t2.ZIndex = v2

        return react.createElement("imagebutton", t1, react.createElement("textlabel", t2, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.new(0, 0, 0)
        }), react.createElement("uitextsizeconstraint", {
            MaxTextSize = 24,
            MinTextSize = 11
        })), p1.children)
    end
}
