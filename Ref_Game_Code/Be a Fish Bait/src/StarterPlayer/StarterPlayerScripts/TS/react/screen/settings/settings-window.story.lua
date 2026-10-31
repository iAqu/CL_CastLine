-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "window-transition").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "story-provider").default
local storyForScreenGui = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "story", "story-utils").storyForScreenGui
local default3 = RuntimeLib.import(script, script.Parent, "settings-window").default

local function SettingsShowcase() -- line: 10
    -- upvalues: react (copy), useState (copy), default (copy), default3 (copy)
    local v1, v2 = useState(true)
    local v3, v4 = useState(0.5)
    local v5, v6 = useState(0.5)
    local v7, v8 = useState(true)
    local v9, v10 = useState(true)
    local createElement = react.createElement
    local t1 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    local v11 = not v1

    v11 = v11 and react.createElement("textbutton", {
        BorderSizePixel = 0,
        Font = "Arcade",
        Text = "Open Settings",
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.7, 0.3),
        Event = {
            Activated = function() -- Activated | line: 24
                -- upvalues: v2 (copy)
                return v2(true)
            end
        },
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(200, 50),
        TextColor3 = Color3.new(1, 1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.1, 0)
    }))

    return createElement("frame", t1, v11, react.createElement(default, {
        enableCameraEffects = false,
        ["in"] = v1
    }, react.createElement(default3, {
        bossAutokillEnabled = true,
        bossAutokillOwned = true,
        cameraShakeEnabled = v9,
        hapticsEnabled = v7,
        musicVolume = v3,
        onCameraShakeToggle = v10,
        onBossAutokillToggle = v10,
        onClose = function() -- onClose | line: 47
            -- upvalues: v2 (copy)
            return v2(false)
        end,
        onHapticsToggle = v8,
        onMusicVolumeChange = v4,
        onPlayerStatsOpen = function() -- onPlayerStatsOpen | line: 52
        end,
        onSfxVolumeChange = v6,
        sfxVolume = v5
    })))
end

return storyForScreenGui(react.createElement(default2, {
    initialState = {}
}, react.createElement(SettingsShowcase)))
