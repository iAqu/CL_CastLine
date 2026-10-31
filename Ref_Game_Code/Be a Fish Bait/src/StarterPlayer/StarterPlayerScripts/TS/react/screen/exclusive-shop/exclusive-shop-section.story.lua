-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "medium-shop-section").default
local default3 = RuntimeLib.import(script, script.Parent, "small-shop-section").default
local default4 = RuntimeLib.import(script, script.Parent, "long-shop-section").default
local t1 = {
    {
        kind = "medium",
        sectionType = "MediumBlueSection"
    },
    {
        kind = "medium",
        sectionType = "MediumGreenSection"
    },
    {
        kind = "medium",
        sectionType = "MediumYellowSection"
    },
    {
        kind = "small"
    },
    {
        kind = "long",
        sectionType = "LongBlueSection"
    },
    {
        kind = "long",
        sectionType = "LongYellowSection"
    }
}

local function SectionShowcase() -- line: 29
    -- upvalues: react (copy), useState (copy), default2 (copy), default3 (copy), default4 (copy), t1 (copy)
    local v1, v2 = useState(0)
    local v3 = t1[v1 + 1]

    local function v4() -- line: 32
        -- upvalues: v1 (copy), v2 (copy), t1 (copy)
        return v2((v1 - 1 + #t1) % #t1)
    end

    local function v5() -- line: 35
        -- upvalues: v1 (copy), v2 (copy), t1 (copy)
        return v2((v1 + 1) % #t1)
    end

    local function v6() -- line: 38
        -- upvalues: v3 (copy), react (copy), default2 (copy), default3 (copy), default4 (copy)
        if v3.kind == "medium" then
            return react.createElement(default2, {
                sectionType = v3.sectionType
            })
        end

        if v3.kind == "small" then
            return react.createElement(default3, {
                sectionType = "SmallYellowSection"
            })
        end

        return react.createElement(default4, {
            sectionType = v3.sectionType
        })
    end

    local v7 = if v3.kind == "small" then "SmallYellowSection" else v3.sectionType

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 0),
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.5, 0.1),
        Size = UDim2.fromScale(0.6, 0.06),
        Text = v7,
        TextColor3 = Color3.new(1, 1, 1)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.6, 0.5)
    }, v6()), react.createElement("textbutton", {
        Text = "◀",
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Event = {
            Activated = v4
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.05, 0.5),
        Size = UDim2.fromScale(0.08, 0.08),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    })), react.createElement("textbutton", {
        Text = "▶",
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Event = {
            Activated = v5
        },
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromScale(0.95, 0.5),
        Size = UDim2.fromScale(0.08, 0.08),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 10,
        AnchorPoint = Vector2.new(0.5, 1),
        Font = Enum.Font.Gotham,
        Position = UDim2.fromScale(0.5, 0.9),
        Size = UDim2.fromScale(0.2, 0.05),
        Text = `{ v1 + 1 } / {#t1}`,
        TextColor3 = Color3.fromRGB(200, 200, 200)
    }))
end

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement(SectionShowcase)))
