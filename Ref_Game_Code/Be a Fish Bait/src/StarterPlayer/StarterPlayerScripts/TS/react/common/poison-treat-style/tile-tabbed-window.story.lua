-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent, "tile-tabbed-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local default3 = RuntimeLib.import(script, script.Parent.Parent, "styled-text-label").default

local function TileTabbedWindowStory() -- line: 15
    -- upvalues: react (copy), useContext (copy), default (copy), ThemeContext (copy), default3 (copy)
    local v1 = useContext(ThemeContext)
    local t1 = {
        {
            imageId = "rbxassetid://79768616414670",
            index = 0,
            title = "TREATS",
            backgroundColor = v1.colorSequences.lightBlue,
            borderColor = Color3.fromRGB(102, 153, 204)
        },
        {
            imageId = "rbxassetid://105242383493707",
            index = 1,
            title = "CHAIRS",
            backgroundColor = v1.colorSequences.orangeGradient,
            borderColor = Color3.fromRGB(201, 130, 6)
        },
        {
            imageId = "rbxassetid://97387744787334",
            index = 2,
            title = "DEATHS",
            backgroundColor = v1.colorSequences.greenGradient,
            borderColor = Color3.fromRGB(30, 120, 30)
        }
    }
    local t2 = {
        [0] = react.createElement(default3, {
            key = "treats-content",
            text = "TREATS Content Here",
            overrideProps = {
                BackgroundTransparency = 1,
                Text = "TREATS Content Here",
                TextScaled = true,
                TextStrokeTransparency = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.3)
            },
            strokeProps = {
                Thickness = 3
            }
        }, react.createElement("uitextsizeconstraint", {
            MaxTextSize = 36
        })),
        [1] = react.createElement(default3, {
            key = "chairs-content",
            text = "CHAIRS Content Here",
            overrideProps = {
                BackgroundTransparency = 1,
                Text = "CHAIRS Content Here",
                TextScaled = true,
                TextStrokeTransparency = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.3)
            },
            strokeProps = {
                Thickness = 3
            }
        }, react.createElement("uitextsizeconstraint", {
            MaxTextSize = 36
        })),
        [2] = react.createElement(default3, {
            key = "deaths-content",
            text = "DEATHS Content Here",
            overrideProps = {
                BackgroundTransparency = 1,
                Text = "DEATHS Content Here",
                TextScaled = true,
                TextStrokeTransparency = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.3)
            },
            strokeProps = {
                Thickness = 3
            }
        }, react.createElement("uitextsizeconstraint", {
            MaxTextSize = 36
        }))
    }

    return react.createElement(default, {
        defaultPage = 2,
        title = "DEATHS",
        bodyColorSequence = v1.colorSequences.white,
        navItems = t1,
        onClose = function() -- onClose | line: 96
        end,
        pageContent = t2,
        size = UDim2.fromScale(0.6, 0.7)
    })
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(TileTabbedWindowStory)))
