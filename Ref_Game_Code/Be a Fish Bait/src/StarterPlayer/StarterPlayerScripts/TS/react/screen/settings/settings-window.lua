-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useState = react.useCallback, react.useEffect, react.useState
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-slider").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default

local function SettingSliderRow(p1) -- line: 14
    -- upvalues: react (copy), useCallback (copy), useEffect (copy), useState (copy), default2 (copy), default3 (copy), default4 (copy)
    local formatValue, label, layoutOrder, onCommit = p1.formatValue, p1.label, p1.layoutOrder, p1.onCommit
    local onPreview, steps, value = p1.onPreview, p1.steps, p1.value
    local v1, v2 = useState(value)

    useEffect(function() -- line: 25
        -- upvalues: value (copy), v2 (copy)
        return v2(value)
    end, { value })

    local v3 = useCallback(function(p2) -- line: 28
        -- upvalues: onPreview (copy), v2 (copy)
        v2(p2)

        if onPreview ~= nil then
            onPreview(p2)
        end
    end, { onPreview })

    return react.createElement(default2, {
        cornerRadius = 0.06,
        isStudded = true,
        strokeThickness = 0.02,
        textureTransparency = 0.6,
        tileSize = 80,
        transparency = 0.4,
        backgroundColor = Color3.fromRGB(99, 99, 99),
        layoutOrder = layoutOrder,
        size = UDim2.fromScale(1, 0.18),
        strokeColor = Color3.fromRGB(36, 36, 36)
    }, react.createElement("uipadding", {
        PaddingBottom = UDim.new(0.08, 0),
        PaddingLeft = UDim.new(0.05, 0),
        PaddingRight = UDim.new(0.05, 0),
        PaddingTop = UDim.new(0.1, 0)
    }), react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0.08, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 0.48)
    }, react.createElement(default4, {
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(0.62, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        popoutColor = Color3.fromRGB(50, 50, 50),
        strokeProps = {
            Thickness = 0.075,
            Color = Color3.fromRGB(50, 50, 50),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        },
        text = label
    }), react.createElement(default4, {
        anchorPoint = Vector2.new(1, 0),
        color = Color3.fromRGB(180, 255, 160),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(0.34, 1),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        popoutColor = Color3.fromRGB(50, 50, 50),
        position = UDim2.fromScale(1, 0),
        strokeProps = {
            Thickness = 0.075,
            Color = Color3.fromRGB(50, 50, 50),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        },
        text = formatValue(v1)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0.34)
    }, react.createElement(default3, {
        onChange = v3,
        onChangeEnd = onCommit,
        steps = steps,
        value = v1
    })))
end

local function SettingToggleRow(p3) -- line: 101
    -- upvalues: react (copy), default2 (copy), default4 (copy), default5 (copy)
    local enabled, label, layoutOrder, onToggle = p3.enabled, p3.label, p3.layoutOrder, p3.onToggle
    local v4 = if enabled then ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(41, 240, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
    }) else Color3.fromRGB(120, 120, 120)

    return react.createElement(default2, {
        cornerRadius = 0.06,
        isStudded = true,
        strokeThickness = 0.02,
        textureTransparency = 0.6,
        tileSize = 80,
        transparency = 0.4,
        backgroundColor = Color3.fromRGB(99, 99, 99),
        layoutOrder = layoutOrder,
        size = UDim2.fromScale(1, 0.18),
        strokeColor = Color3.fromRGB(36, 36, 36)
    }, react.createElement(default4, {
        shadowYScale = 0.125,
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.38),
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.fromScale(0.04, 0.25)
        },
        popoutColor = Color3.fromRGB(50, 50, 50),
        strokeProps = {
            Thickness = 0.075,
            Color = Color3.fromRGB(50, 50, 50),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        },
        text = label
    }), react.createElement(default5, {
        cornerRadius = 0.2,
        zIndex = 2,
        anchorPoint = Vector2.new(1, 0.5),
        color = v4,
        frameSize = UDim2.fromScale(0.3, 0.5),
        label = enabled and "ON" or "OFF",
        onClick = function() -- onClick | line: 141
            -- upvalues: enabled (copy), onToggle (copy)
            return onToggle(not enabled)
        end,
        popoutColor = Color3.fromRGB(23, 120, 0),
        position = UDim2.fromScale(0.96, 0.5)
    }))
end

return {
    default = function(p4) -- SettingsWindow | line: 149
        -- upvalues: react (copy), default (copy), default5 (copy), default6 (copy), SettingSliderRow (copy), SettingToggleRow (copy)
        local bossAutokillEnabled, bossAutokillOwned, cameraShakeEnabled, hapticsEnabled = p4.bossAutokillEnabled, p4.bossAutokillOwned, p4.cameraShakeEnabled, p4.hapticsEnabled
        local musicVolume, onCameraShakeToggle, onBossAutokillToggle, onClose = p4.musicVolume, p4.onCameraShakeToggle, p4.onBossAutokillToggle, p4.onClose
        local onHapticsToggle, onMusicVolumeChange, onMusicVolumePreview, onPlayerStatsOpen = p4.onHapticsToggle, p4.onMusicVolumeChange, p4.onMusicVolumePreview, p4.onPlayerStatsOpen
        local onSfxVolumeChange, onSfxVolumePreview, sfxVolume = p4.onSfxVolumeChange, p4.onSfxVolumePreview, p4.sfxVolume

        return react.createElement(default, {
            aspectRatio = 0.78,
            title = "Settings",
            bodyBg = Color3.fromRGB(60, 60, 60),
            closeButtonPosition = UDim2.fromScale(0.95, 0.5),
            headerBg = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(177, 177, 177)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(152, 152, 152)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(121, 121, 121))
            }),
            onClose = onClose,
            size = UDim2.fromScale(0.35, 0.6)
        }, react.createElement(default6, {
            itemPaddingScale = 0.025,
            anchorPoint = Vector2.new(0.5, 0.5),
            canvasHeightScale = bossAutokillOwned and 1.2 or 1,
            position = UDim2.fromScale(0.5, 0.56),
            scrollBarThickness = bossAutokillOwned and 4 or 0,
            size = UDim2.fromScale(0.9, 0.85)
        }, react.createElement(default5, {
            cornerRadius = 0.08,
            isStudded = true,
            label = "Player Stats",
            layoutOrder = 1,
            color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(71, 199, 238)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 109, 181))
            }),
            frameSize = UDim2.fromScale(1, 0.14),
            onClick = onPlayerStatsOpen,
            strokeColor = Color3.fromRGB(18, 57, 82)
        }), react.createElement(SettingSliderRow, {
            label = "Music",
            layoutOrder = 2,
            formatValue = function(p5) -- formatValue | line: 191
                return (("%*%%"):format((math.floor(p5 * 100))))
            end,
            onCommit = onMusicVolumeChange,
            onPreview = onMusicVolumePreview,
            value = musicVolume
        }), react.createElement(SettingSliderRow, {
            label = "Sound Effects",
            layoutOrder = 3,
            formatValue = function(p6) -- formatValue | line: 200
                return (("%*%%"):format((math.floor(p6 * 100))))
            end,
            onCommit = onSfxVolumeChange,
            onPreview = onSfxVolumePreview,
            value = sfxVolume
        }), react.createElement(SettingToggleRow, {
            label = "Haptics",
            layoutOrder = 4,
            enabled = hapticsEnabled,
            onToggle = onHapticsToggle
        }), react.createElement(SettingToggleRow, {
            label = "Camera Shake",
            layoutOrder = 5,
            enabled = cameraShakeEnabled,
            onToggle = onCameraShakeToggle
        }), bossAutokillOwned and react.createElement(SettingToggleRow, {
            label = "Auto-Kill Boss",
            layoutOrder = 6,
            enabled = bossAutokillEnabled,
            onToggle = onBossAutokillToggle
        })))
    end
}
