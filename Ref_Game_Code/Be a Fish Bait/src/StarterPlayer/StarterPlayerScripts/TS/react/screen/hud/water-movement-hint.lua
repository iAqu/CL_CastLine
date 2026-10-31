-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local toolbarRowPositionXScale = RuntimeLib.import(script, script.Parent.Parent, "bottom-bar", "bottom-bar").toolbarRowPositionXScale
local waterMovementHintVisibleAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "water-movement-ui-atom").waterMovementHintVisibleAtom

local function HintRow(p1) -- line: 15
    -- upvalues: react (copy), default (copy), default2 (copy)
    local keyText, label = p1.keyText, p1.label

    return react.createElement(default2, {
        backgroundTransparency = 0.3,
        clipDescendants = true,
        cornerRadius = 8,
        zIndex = 31,
        backgroundColor3 = Color3.fromRGB(0, 0, 0),
        size = UDim2.new(1, 0, 0, 40)
    }, react.createElement(default2, {
        backgroundTransparency = 0,
        cornerRadius = 8,
        zIndex = 31,
        backgroundColor3 = Color3.fromRGB(54, 55, 50),
        position = UDim2.fromScale(0.17, 0.5),
        size = UDim2.new(0.34, 0, 1, 0)
    }), react.createElement("frame", {
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 31,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(54, 55, 50),
        Position = UDim2.fromScale(0.3, 0.5),
        Size = UDim2.new(0.04, 0, 1, 0)
    }), react.createElement(default, {
        shadowYScale = 0.08,
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            ZIndex = 32,
            AnchorPoint = Vector2.new(0, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.06, 0.46),
            Size = UDim2.fromScale(0.22, 0.58),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        text = label
    }), react.createElement(default, {
        shadowYScale = 0.08,
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            ZIndex = 32,
            AnchorPoint = Vector2.new(0, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.37, 0.46),
            Size = UDim2.fromScale(0.57, 0.56),
            TextXAlignment = Enum.TextXAlignment.Right
        },
        text = keyText
    }))
end

return {
    default = function(p2) -- WaterMovementHint | line: 66
        -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), UserInputService (copy), useIsUsingGamepad (copy), useScreenSizeState (copy), toolbarRowPositionXScale (copy), waterMovementHintVisibleAtom (copy), HintRow (copy)
        local forceVisible = (if p2 == nil then {} else p2).forceVisible

        if forceVisible == nil then
            forceVisible = false
        end

        local v1, v2 = useState(waterMovementHintVisibleAtom())
        local v3 = useIsUsingGamepad()
        local v4 = useScreenSizeState()
        local v5 = v4 == "sm" or v4 == "md"
        local v6 = if v5 then UDim2.new(toolbarRowPositionXScale, -8, 0.97, 0) else UDim2.new(0.99, 0, 0.98, 0)
        local v7 = UDim2.new(v6.X.Scale, v6.X.Offset, v6.Y.Scale - 0.08, v6.Y.Offset - 40)

        useEffect(function() -- line: 80
            -- upvalues: v2 (copy), subscribe (copy), waterMovementHintVisibleAtom (copy)
            return subscribe(waterMovementHintVisibleAtom, v2)
        end, {})

        if not (forceVisible or v1 and (v3 or UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled)) then
            return nil
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 30,
            AnchorPoint = Vector2.new(1, 1),
            Position = v7,
            Size = UDim2.fromOffset(v5 and 210 or 230, 88)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(HintRow, {
            key = "up",
            label = "Up",
            keyText = v3 and "R2" or "Space / E"
        }), react.createElement(HintRow, {
            key = "down",
            label = "Down",
            keyText = v3 and "R1" or "LeftShift / Q"
        }))
    end
}
