-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local default2 = RuntimeLib.import(script, script.Parent, "server-restart-banner").default
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer

local function Controls() -- line: 9
    -- upvalues: react (copy), Workspace (copy), useRootProducer (copy)
    local v1 = useRootProducer()

    local function v2() -- line: 11
        -- upvalues: v1 (copy), Workspace (copy)
        v1.serverRestartScheduled({
            closeReason = 3,
            message = nil,
            endTimestamp = Workspace:GetServerTimeNow() + 60
        })
    end

    local function v3() -- line: 18
        -- upvalues: v1 (copy), Workspace (copy)
        v1.serverRestartScheduled({
            closeReason = 3,
            message = "Servers will restart at the end of the round for an update",
            endTimestamp = Workspace:GetServerTimeNow() + 60
        })
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.98),
        Size = UDim2.fromOffset(320, 40)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8)
    }), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Trigger restart (60s)",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(50, 160, 80),
        Event = {
            Activated = v2
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(180, 36),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    })), react.createElement("textbutton", {
        BorderSizePixel = 0,
        Text = "Trigger w/ custom message",
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(50, 100, 180),
        Event = {
            Activated = v3
        },
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(180, 36),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.2, 0)
    })))
end

return storyForScreenGui(react.createElement(default, nil, react.createElement("frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1)
}, react.createElement(default2), react.createElement(Controls))), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
