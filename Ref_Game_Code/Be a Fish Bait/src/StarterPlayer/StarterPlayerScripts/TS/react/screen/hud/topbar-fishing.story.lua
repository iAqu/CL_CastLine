-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "topbar-fishing").default
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps

local function Story() -- line: 10
    -- upvalues: react (copy), useState (copy), default (copy), default2 (copy), tutorialSteps (copy)
    local v1, v2 = useState(false)
    local t1 = if v1 then {
        tutorial = {
            step = tutorialSteps.addFishToAquarium
        },
        fishingArea = {
            isInFishingArea = true,
            fishingAreaCenter = nil
        },
        nearBaseUi = {
            isNearBase = false
        }
    } else nil

    return react.createElement(default, {
        initialState = t1,
        key = tostring(v1)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        onBaseClick = function() -- onBaseClick | line: 31
            return print("Base clicked")
        end,
        onBuyClick = function() -- onBuyClick | line: 34
            return print("Buy clicked")
        end
    }), react.createElement("frame", {
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        Position = UDim2.fromScale(0.5, 0.95),
        Size = UDim2.fromOffset(260, 50)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }), react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        TextScaled = true,
        BackgroundColor3 = if v1 then Color3.new(0.2, 0.5, 0.8) else Color3.new(0.2, 0.2, 0.2),
        Event = {
            Activated = function() -- Activated | line: 56
                -- upvalues: v1 (copy), v2 (copy)
                return v2(not v1)
            end
        },
        Font = Enum.Font.Gotham,
        Size = UDim2.fromOffset(240, 36),
        Text = v1 and "Add Fish to Aquarium: ON" or "Add Fish to Aquarium: OFF",
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 4)
    })))))
end

return storyForScreenGui(react.createElement(Story))
