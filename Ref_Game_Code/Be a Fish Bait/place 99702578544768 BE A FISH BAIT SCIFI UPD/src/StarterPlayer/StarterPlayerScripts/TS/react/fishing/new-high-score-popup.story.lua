-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent, "utils", "story-provider").default
local hookCastDistanceAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "fishing-phase-atom").hookCastDistanceAtom
local default2 = RuntimeLib.import(script, script.Parent, "new-high-score-popup").default

local function Story() -- line: 8
    -- upvalues: react (copy), default (copy), hookCastDistanceAtom (copy), default2 (copy)
    local function v1() -- line: 9
        -- upvalues: hookCastDistanceAtom (copy)
        local n1 = 0
        local connection

        connection = game:GetService("RunService").Heartbeat:Connect(function(p1) -- line: 12
            -- upvalues: n1 (ref), connection (ref), hookCastDistanceAtom (copy)
            n1 += p1 * 60
            hookCastDistanceAtom(n1)

            if n1 >= 200 then
                connection:Disconnect()
            end
        end)
    end

    local function v3() -- line: 20
        -- upvalues: hookCastDistanceAtom (copy)
        return hookCastDistanceAtom(0)
    end

    return react.createElement(default, nil, react.createElement(default2, {
        storyHighScoreDistance = 80
    }), react.createElement("frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Position = UDim2.fromScale(0.5, 0.95),
        Size = UDim2.fromOffset(200, 40)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textbutton", {
        LayoutOrder = 0,
        Text = "Simulate Cast",
        BackgroundColor3 = Color3.fromRGB(60, 180, 60),
        Event = {
            MouseButton1Click = v1
        },
        Size = UDim2.fromOffset(88, 32)
    }), react.createElement("textbutton", {
        LayoutOrder = 1,
        Text = "Reset",
        BackgroundColor3 = Color3.fromRGB(180, 60, 60),
        Event = {
            MouseButton1Click = v3
        },
        Size = UDim2.fromOffset(88, 32)
    })))
end

return storyForScreenGui(react.createElement(Story))
