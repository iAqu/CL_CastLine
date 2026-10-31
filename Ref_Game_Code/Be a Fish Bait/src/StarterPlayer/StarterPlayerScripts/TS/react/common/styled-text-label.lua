-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent, "context", "theme-context").ThemeContext
local shallowEqual = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").shallowEqual

local function v1(p1) -- line: 8
    -- upvalues: react (copy), useContext (copy), ThemeContext (copy)
    local v2 = useContext(ThemeContext)
    local v3 = p1.color ~= nil

    v3 = v3 and typeof(p1.color) == "ColorSequence"

    local color = if v3 then Color3.new(1, 1, 1) else p1.color or p1.textColor3 or Color3.new(1, 1, 1)
    local t1 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = color,
        Font = v2.textFont,
        Text = p1.text
    }
    local overrideProps = p1.overrideProps

    if overrideProps then
        for v4, v5 in overrideProps do
            t1[v4] = v5
        end
    end

    local t2 = {
        Thickness = 0.04,
        Color = Color3.new(0, 0, 0),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }
    local strokeProps = p1.strokeProps

    if strokeProps then
        for v6, v7 in strokeProps do
            t2[v6] = v7
        end
    end

    local textTransparency = p1.textTransparency

    if textTransparency == nil then
        textTransparency = t1.TextTransparency

        if textTransparency == nil then
            textTransparency = 0
        end
    end

    local v8 = table.clone(t1)

    setmetatable(v8, nil)
    v8.TextTransparency = textTransparency

    local hasStroke = p1.hasStroke
    local v9

    if hasStroke == nil or hasStroke then
        local v10 = table.clone(t2)

        setmetatable(v10, nil)
        v10.Transparency = textTransparency
        v9 = react.createElement("uistroke", v10)
    end

    if v3 then
        local t3 = {
            Color = p1.color
        }
        local gradientRotation = p1.gradientRotation

        t3.Rotation = if gradientRotation == nil then 90 else gradientRotation
        v3 = react.createElement("uigradient", t3)
    end

    return react.createElement("textlabel", v8, v9, v3, p1.children)
end

return {
    default = react.memo(v1, function(p2, p3) -- line: 82
        -- upvalues: shallowEqual (copy)
        local overrideProps, strokeProps = p2.overrideProps, p2.strokeProps
        local overrideProps2, strokeProps2 = p3.overrideProps, p3.strokeProps
        local v11 = table.clone(p2)

        setmetatable(v11, nil)
        v11.overrideProps = nil
        v11.strokeProps = nil

        local v12 = table.clone(p3)

        setmetatable(v12, nil)
        v12.overrideProps = nil
        v12.strokeProps = nil

        return shallowEqual(overrideProps, overrideProps2) and shallowEqual(strokeProps, strokeProps2) and shallowEqual(v11, v12)
    end)
}
