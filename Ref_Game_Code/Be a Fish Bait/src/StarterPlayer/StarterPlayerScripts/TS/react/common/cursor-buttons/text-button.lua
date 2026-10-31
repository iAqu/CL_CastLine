-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local t1 = {
    small = {
        padding = 8,
        height = 32,
        fontSize = Enum.FontSize.Size12
    },
    medium = {
        padding = 12,
        height = 40,
        fontSize = Enum.FontSize.Size14
    },
    large = {
        padding = 16,
        height = 48,
        fontSize = Enum.FontSize.Size18
    }
}
local t2 = {
    primary = Color3.new(0.2, 0.4, 0.8),
    secondary = Color3.new(0.5, 0.5, 0.5),
    danger = Color3.new(0.8, 0.2, 0.2),
    success = Color3.new(0.2, 0.7, 0.3)
}

local function getBackgroundColor(p1, p2) -- line: 30
    -- upvalues: t2 (copy)
    local v1 = t2[p1]

    if p2 == "disabled" then
        return Color3.new(v1.R * 0.3, v1.G * 0.3, v1.B * 0.3)
    end

    if p2 == "active" then
        return Color3.new(math.min(v1.R * 1.2, 1), math.min(v1.G * 1.2, 1), (math.min(v1.B * 1.2, 1)))
    end

    if p2 ~= "hover" then
        return v1
    end

    return Color3.new(math.min(v1.R * 1.1, 1), math.min(v1.G * 1.1, 1), (math.min(v1.B * 1.1, 1)))
end

local function getBorderRadius(p3) -- line: 43
    if p3 == "pill" then
        return 999
    end

    if p3 == "rounded" then
        return 8
    end

    if p3 == "square" then
        return 0
    end
end

return {
    default = function(p4) -- TextButton | line: 56
        -- upvalues: react (copy), useContext (copy), ThemeContext (copy), t1 (copy), getBackgroundColor (copy)
        local v12 = useContext(ThemeContext)
        local v13 = p4.size or "medium"
        local v14 = p4.color or "primary"
        local v15 = p4.state or "default"
        local v16 = p4.shape or "rounded"
        local v17 = t1[v13]
        local v18 = getBackgroundColor(v14, v15)
        local v19 = if v16 == "pill" then 999
            elseif v16 == "rounded" then 8
            elseif v16 == "square" then 0
            else nil
        local v20 = v15 == "disabled"
        local t3 = {}
        local overrideProps = p4.overrideProps

        if overrideProps then
            for v21, v22 in overrideProps do
                t3[v21] = v22
            end
        end

        t3.Active = not v20
        t3.AutoButtonColor = v15 == "hover" or v15 == "default"
        t3.BackgroundColor3 = v18
        t3.BorderSizePixel = 0

        local overrideProps2 = p4.overrideProps

        if overrideProps2 ~= nil then
            overrideProps2 = overrideProps2.Font
        end

        t3.Font = if overrideProps2 == nil then v12.textFont else overrideProps2
        t3.FontSize = v17.fontSize

        local overrideProps3 = p4.overrideProps

        if overrideProps3 ~= nil then
            overrideProps3 = overrideProps3.Size
        end

        t3.Size = if overrideProps3 == nil then UDim2.fromOffset(120, v17.height) else overrideProps3
        t3.Text = p4.text
        t3.TextColor3 = Color3.new(1, 1, 1)

        return react.createElement("textbutton", t3, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, v19)
        }), react.createElement("uistroke", {
            Thickness = 1,
            Transparency = 0.5,
            Color = Color3.new(0, 0, 0)
        }), p4.children)
    end
}
