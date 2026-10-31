-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "tutorial-text").default
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootProducer = reflex.useRootSelector, reflex.useRootProducer
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps

local function TutorialTextShowcase() -- line: 12
    -- upvalues: react (copy), default2 (copy), useRootSelector (copy), useRootProducer (copy), selectTutorialStep (copy), tutorialSteps (copy)
    local v1 = useRootProducer()
    local v2 = useRootSelector(selectTutorialStep)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default2), react.createElement("frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        Position = UDim2.fromScale(0.5, 0.8),
        Size = UDim2.fromOffset(300, 200)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Font = "GothamBold",
        Text = "Tutorial Step Control",
        TextScaled = true,
        Size = UDim2.fromScale(1, 0.3),
        TextColor3 = Color3.new(1, 1, 1)
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Font = "Gotham",
        TextScaled = true,
        Size = UDim2.fromScale(1, 0.2),
        Text = ("Current Step: %*"):format(v2),
        TextColor3 = Color3.new(1, 1, 1)
    }), react.createElement("textbutton", {
        Font = "Gotham",
        Text = "Next Step",
        TextScaled = true,
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 45
                -- upvalues: v1 (copy), v2 (copy), tutorialSteps (copy)
                local v7 = if v2 + 1 >= tutorialSteps.completed then tutorialSteps.none else v2 + 1

                v1.tutorialStepUpdated({
                    step = v7
                })
            end
        },
        Size = UDim2.fromScale(0.8, 0.15),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    })), react.createElement("textbutton", {
        Font = "Gotham",
        Text = "Reset",
        TextScaled = true,
        BackgroundColor3 = Color3.new(0.7, 0.2, 0.2),
        Event = {
            Activated = function() -- Activated | line: 62
                -- upvalues: v1 (copy), tutorialSteps (copy)
                v1.tutorialStepUpdated({
                    step = tutorialSteps.none
                })
            end
        },
        Size = UDim2.fromScale(0.8, 0.15),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0, 8)
    }))))
end

return storyForScreenGui(react.createElement(default, {
    initialState = {
        tutorial = {
            step = tutorialSteps.walkToDock
        }
    }
}, react.createElement(TutorialTextShowcase)))
