-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "water-movement-ui-atom")
local waterMovementTouchControlsVisibleAtom, waterMovementTouchVerticalDirectionAtom = v1.waterMovementTouchControlsVisibleAtom, v1.waterMovementTouchVerticalDirectionAtom
local v2 = Vector2.new(1, 146)
local v3 = Vector2.new(146, 146)
local v4 = Vector2.new(144, 144)

local function SwimButton(p1) -- line: 16
    -- upvalues: react (copy), useState (copy), waterMovementTouchVerticalDirectionAtom (copy), v2 (copy), v3 (copy), v4 (copy)
    local direction = p1.direction
    local v5, v6 = useState(false)

    local function v7(p2) -- line: 19
        -- upvalues: direction (copy), v6 (copy), waterMovementTouchVerticalDirectionAtom (copy)
        v6(p2)
        waterMovementTouchVerticalDirectionAtom(if p2 then direction else 0)
    end

    return react.createElement("textbutton", {
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 31,
        Size = UDim2.fromOffset(70, 70),
        Event = {
            MouseButton1Down = function() -- MouseButton1Down | line: 29
                -- upvalues: v7 (copy)
                return v7(true)
            end,
            MouseButton1Up = function() -- MouseButton1Up | line: 32
                -- upvalues: v7 (copy)
                return v7(false)
            end,
            MouseLeave = function() -- MouseLeave | line: 35
                -- upvalues: v7 (copy)
                return v7(false)
            end
        }
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png",
        ZIndex = 31,
        ImageRectOffset = if v5 then v3 else v2,
        ImageRectSize = v4,
        Rotation = direction == -1 and 180 or 0,
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromScale(1, 1)
    }))
end

return {
    default = function() -- WaterMovementTouchControls | line: 50
        -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), UserInputService (copy), waterMovementTouchControlsVisibleAtom (copy), waterMovementTouchVerticalDirectionAtom (copy), SwimButton (copy)
        local v8, v9 = useState(waterMovementTouchControlsVisibleAtom())

        useEffect(function() -- line: 52
            -- upvalues: v9 (copy), subscribe (copy), waterMovementTouchControlsVisibleAtom (copy)
            return subscribe(waterMovementTouchControlsVisibleAtom, v9)
        end, {})
        useEffect(function() -- line: 55
            -- upvalues: waterMovementTouchVerticalDirectionAtom (copy)
            return function() -- line: 56
                -- upvalues: waterMovementTouchVerticalDirectionAtom (copy)
                waterMovementTouchVerticalDirectionAtom(0)
            end
        end, {})

        if not (v8 and UserInputService.TouchEnabled) then
            return nil
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 30,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, 8, 1, -22),
            Size = UDim2.fromOffset(148, 70)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(SwimButton, {
            direction = 1
        }), react.createElement(SwimButton, {
            direction = -1
        }))
    end
}
