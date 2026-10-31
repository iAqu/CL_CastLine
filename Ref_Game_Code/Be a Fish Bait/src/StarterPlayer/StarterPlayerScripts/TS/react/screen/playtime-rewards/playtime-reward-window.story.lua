-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local default2 = RuntimeLib.import(script, script.Parent, "playtime-reward-window").default
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local t1 = {
    ["playtime-1"] = true,
    ["playtime-2"] = true
}

return storyForScreenGui(react.createElement(default, {
    initialState = {}
}, react.createElement("frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1)
}, react.createElement(default2, {
    savedTimeForPlaytimeReward = 0,
    timeLastSaved = 0,
    claimedRewards = t1,
    onClose = function() -- onClose | line: 20
        return print("Close clicked!")
    end,
    playTimeRewardStartTime = Workspace:GetServerTimeNow() - 900
}))))
