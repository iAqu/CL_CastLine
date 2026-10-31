-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default2 = RuntimeLib.import(script, script.Parent, "weather-hud-banner").default

return storyForScreenGui(react.createElement(default, {
    initialState = {
        currentWeathers = {
            ["Unc's Calling"] = {
                weather = "Unc's Calling",
                endTimestamp = os.time() + 600,
                startTimestamp = os.time()
            }
        }
    }
}, react.createElement("frame", {
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(75, 130, 165),
    Size = UDim2.fromScale(1, 1)
}, react.createElement("uigradient", {
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 80, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 195, 205))
    })
}), react.createElement(default2))), {
    zIndexBehavior = Enum.ZIndexBehavior.Sibling
})
