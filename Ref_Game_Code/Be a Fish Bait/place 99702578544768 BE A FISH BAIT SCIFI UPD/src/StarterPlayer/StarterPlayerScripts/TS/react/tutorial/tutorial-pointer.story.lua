-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForBillboardGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForBillboardGui
local default = RuntimeLib.import(script, script.Parent, "tutorial-pointer").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default

local function TutorialPointerShowcase(p1) -- line: 7
    -- upvalues: react (copy), default (copy), default2 (copy)
    local part = p1.part
    local down, down2 = react.useState("down")
    local t1 = {
        "up",
        "down",
        "left",
        "right"
    }
    local v1 = react.createElement(default, {
        adornee = part,
        direction = down
    })
    local v2 = react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    })
    local v3 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v4 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Text = "Direction:",
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(80, 40),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local v5 = table.create(#t1)

    local function v6(p2) -- line: 38
        -- upvalues: down (copy), down2 (copy), t1 (copy), react (copy)
        local t2 = {
            BorderSizePixel = 0,
            BackgroundColor3 = if down == p2 then Color3.new(0.2, 0.5, 0.8) else Color3.new(0.2, 0.2, 0.2),
            Event = {
                Activated = function() -- Activated | line: 43
                    -- upvalues: p2 (copy), down2 (copy)
                    return down2(p2)
                end
            },
            Font = Enum.Font.Gotham
        }

        t2.LayoutOrder = (table.find(t1, p2) or 0) - 1 + 1
        t2.Size = UDim2.fromOffset(70, 40)
        t2.Text = string.upper(p2)
        t2.TextColor3 = Color3.new(1, 1, 1)
        t2.TextSize = 14
        t2.key = p2

        return react.createElement("textbutton", t2, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 4)
        }))
    end

    for v7, v8 in t1 do
        v5[v7] = v6(v8, v7 - 1, t1)
    end

    return react.createElement(default2, {
        initialState = {
            tutorial = {
                step = 1
            }
        }
    }, v1, react.createElement("screengui", nil, react.createElement("frame", {
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        Position = UDim2.fromScale(0.5, 0.05),
        Size = UDim2.fromOffset(400, 60)
    }, v2, v3, v4, v5)))
end

return storyForBillboardGui(function(p3) -- line: 79
    -- upvalues: react (copy), TutorialPointerShowcase (copy)
    return react.createElement(TutorialPointerShowcase, {
        part = p3
    })
end)
