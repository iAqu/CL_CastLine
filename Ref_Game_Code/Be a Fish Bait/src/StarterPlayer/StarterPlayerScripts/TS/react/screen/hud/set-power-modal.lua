-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState, useRef, useEffect = react.useState, react.useRef, react.useEffect
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-slider").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local utilizedPowerFractionAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utilized-power-atom").utilizedPowerFractionAtom
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 130, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 0))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})

return {
    default = function(p1) -- SetPowerWindow | line: 18
        -- upvalues: react (copy), useState (copy), useRef (copy), useEffect (copy), subscribe (copy), useTheme (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), utilizedPowerFractionAtom (copy), abbreviate (copy), v1 (copy), v2 (copy)
        local maxPower, onClose = p1.maxPower, p1.onClose
        local v3 = useTheme()
        local v4, v5 = useState(utilizedPowerFractionAtom())

        useEffect(function() -- line: 23
            -- upvalues: v5 (copy), subscribe (copy), utilizedPowerFractionAtom (copy)
            return subscribe(utilizedPowerFractionAtom, v5)
        end, {})

        local v6 = math.max(1, maxPower)
        local v8, v9 = useState((math.floor(v4 * v6)))
        local v10 = useRef(v8)

        v10.current = v8

        local v11 = useRef(v6)

        v11.current = v6

        local v13 = math.clamp(v8 / v6, 0, 1)

        useEffect(function() -- line: 34
            -- upvalues: v10 (copy), v11 (copy), utilizedPowerFractionAtom (copy)
            return function() -- line: 35
                -- upvalues: v10 (copy), v11 (copy), utilizedPowerFractionAtom (copy)
                utilizedPowerFractionAtom((math.clamp(v10.current / v11.current, 0, 1)))
            end
        end, {})

        local function handleSliderChange(p2) -- line: 39
            -- upvalues: v9 (copy), v11 (copy)
            v9((math.floor(p2 * v11.current)))
        end

        local function applyTextInput(p3) -- line: 42
            -- upvalues: v6 (copy), v9 (copy)
            local v16 = tonumber(p3)

            if v16 == nil then
                return nil
            end

            v9((math.clamp(math.floor(v16), 0, v6)))
        end

        local function setMaxPower() -- line: 49
            -- upvalues: v6 (copy), v9 (copy)
            v9(v6)
        end

        return react.createElement(default, {
            aspectRatio = 1.55,
            title = "Set Power",
            bodyBg = Color3.fromRGB(0, 0, 0),
            headerBg = v1,
            onClose = onClose,
            size = UDim2.fromScale(0.35, 0.4)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.52),
            Size = UDim2.fromScale(0.9, 0.82)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default2, {
            cornerRadius = 0.12,
            isStudded = true,
            layoutOrder = 1,
            strokeThickness = 0.04,
            textureTransparency = 0.92,
            zIndex = 2,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(30, 30, 30),
            size = UDim2.fromScale(1, 0.32),
            strokeColor = Color3.fromRGB(80, 80, 80)
        }, react.createElement("textbox", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClearTextOnFocus = false,
            PlaceholderText = "0",
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                FocusLost = function(p4) -- FocusLost | line: 89
                    -- upvalues: applyTextInput (copy)
                    return applyTextInput(p4.Text)
                end
            },
            Font = v3.textFont2,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.92, 0.72),
            Text = abbreviate(v8),
            TextColor3 = Color3.new(1, 1, 1)
        }, react.createElement("uistroke", {
            Thickness = 3,
            Color = Color3.new(0, 0, 0)
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ZIndex = 2,
            Size = UDim2.fromScale(1, 0.25)
        }, react.createElement(default3, {
            zIndex = 2,
            fillColor = v2,
            onChange = handleSliderChange,
            value = v13
        })), react.createElement(default4, {
            isStudded = true,
            label = "Set Max",
            layoutOrder = 3,
            zIndex = 2,
            color = Color3.fromRGB(255, 180, 45),
            font = v3.textFont2,
            frameSize = UDim2.fromScale(0.58, 0.2),
            onClick = setMaxPower,
            popoutColor = Color3.fromRGB(140, 75, 0),
            strokeColor = Color3.fromRGB(70, 35, 0)
        })))
    end
}
