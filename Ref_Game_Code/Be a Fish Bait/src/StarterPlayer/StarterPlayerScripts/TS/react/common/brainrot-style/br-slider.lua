-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, UserInputService = services.RunService, services.UserInputService
local default = RuntimeLib.import(script, script.Parent, "br-frame").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 250, 11)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 193, 8))
})
local current = nil

return {
    default = function(p1) -- BRSlider | line: 16
        -- upvalues: react (copy), useEffect (copy), useRef (copy), RunService (copy), UserInputService (copy), default (copy), v1 (copy), current (ref)
        local disabled, fillColor = p1.disabled, p1.fillColor

        if fillColor == nil then
            fillColor = v1
        end

        local knobSizeScale = p1.knobSizeScale

        if knobSizeScale == nil then
            knobSizeScale = 0.06
        end

        local layoutOrder, onChange, onChangeEnd, size = p1.layoutOrder, p1.onChange, p1.onChangeEnd, p1.size

        if size == nil then
            size = UDim2.fromScale(1, 1)
        end

        local steps, trackColor = p1.steps, p1.trackColor

        if trackColor == nil then
            trackColor = Color3.fromRGB(40, 40, 40)
        end

        local trackStrokeColor = p1.trackStrokeColor

        if trackStrokeColor == nil then
            trackStrokeColor = Color3.fromRGB(70, 70, 70)
        end

        local value, zIndex = p1.value, p1.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        local v2 = useRef(nil)
        local v3 = useRef(false)
        local v4 = useRef({})
        local v5 = useRef(value)

        v5.current = value

        local function snap(p2) -- line: 53
            -- upvalues: steps (copy)
            if steps == nil or steps <= 1 then
                return p2
            end

            return math.round(p2 * (steps - 1)) / (steps - 1)
        end

        local function getFractionFromMouse() -- line: 60
            -- upvalues: steps (copy), v2 (copy), v5 (copy), UserInputService (copy)
            local current = v2.current

            if not current then
                return v5.current
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local AbsolutePosition, AbsoluteSize = current.AbsolutePosition, current.AbsoluteSize
            local v8 = math.clamp((MouseLocation.X - AbsolutePosition.X) / AbsoluteSize.X, 0, 1)

            if steps == nil or steps <= 1 then
                return v8
            end

            return math.round(v8 * (steps - 1)) / (steps - 1)
        end

        local function applyDrag() -- line: 70
            -- upvalues: onChange (copy), steps (copy), v2 (copy), v5 (copy), UserInputService (copy)
            local current = v2.current
            local v10

            if current then
                local MouseLocation = UserInputService:GetMouseLocation()
                local AbsolutePosition, AbsoluteSize = current.AbsolutePosition, current.AbsoluteSize

                v10 = math.clamp((MouseLocation.X - AbsolutePosition.X) / AbsoluteSize.X, 0, 1)

                if steps ~= nil and not (steps <= 1) then
                    v10 = math.round(v10 * (steps - 1)) / (steps - 1)
                end
            else
                v10 = v5.current
            end

            onChange(v10)
        end

        useEffect(function() -- line: 88
            -- upvalues: disabled (copy), onChange (copy), onChangeEnd (copy), steps (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), RunService (copy), UserInputService (copy), current (ref)
            if disabled then
                return nil
            end

            local connection = RunService.Heartbeat:Connect(function() -- line: 96
                -- upvalues: onChange (copy), steps (copy), v2 (copy), v3 (copy), v5 (copy), UserInputService (copy)
                if not v3.current then
                    return nil
                end

                local current = v2.current
                local v13

                if current then
                    local MouseLocation = UserInputService:GetMouseLocation()
                    local AbsolutePosition, AbsoluteSize = current.AbsolutePosition, current.AbsoluteSize

                    v13 = math.clamp((MouseLocation.X - AbsolutePosition.X) / AbsoluteSize.X, 0, 1)

                    if steps ~= nil and not (steps <= 1) then
                        v13 = math.round(v13 * (steps - 1)) / (steps - 1)
                    end
                else
                    v13 = v5.current
                end

                onChange(v13)
            end)
            local connection2 = UserInputService.InputEnded:Connect(function(p3) -- line: 102
                -- upvalues: onChangeEnd (copy), v3 (copy), v4 (copy), v5 (copy), current (ref)
                if (p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch) and v3.current then
                    v3.current = false

                    if current == v4.current then
                        current = nil
                    end

                    if onChangeEnd ~= nil then
                        onChangeEnd(v5.current)
                    end
                end
            end)

            return function() -- line: 114
                -- upvalues: connection (copy), connection2 (copy), v3 (copy), v4 (copy), current (ref)
                connection:Disconnect()
                connection2:Disconnect()

                if v3.current then
                    v3.current = false

                    local current2 = current

                    if current2 == v4.current then
                        current = nil
                    end
                end
            end
        end, { disabled })

        local v16 = math.clamp(value, 0, 1)

        return react.createElement("frame", {
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                InputBegan = function(_, p5) -- InputBegan | line: 131
                    -- upvalues: disabled (copy), onChange (copy), steps (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), UserInputService (copy), current (ref)
                    if disabled then
                        return nil
                    end

                    if p5.UserInputType ~= Enum.UserInputType.MouseButton1 and p5.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    local v17 = current ~= nil

                    if v17 then
                        local current2 = current

                        v17 = current2 ~= v4.current
                    end

                    if v17 then
                        return
                    end

                    current = v4.current
                    v3.current = true

                    local current2 = v2.current
                    local v18

                    if current2 then
                        local MouseLocation = UserInputService:GetMouseLocation()
                        local AbsolutePosition, AbsoluteSize = current2.AbsolutePosition, current2.AbsoluteSize

                        v18 = math.clamp((MouseLocation.X - AbsolutePosition.X) / AbsoluteSize.X, 0, 1)

                        if steps ~= nil and not (steps <= 1) then
                            v18 = math.round(v18 * (steps - 1)) / (steps - 1)
                        end
                    else
                        v18 = v5.current
                    end

                    onChange(v18)
                end
            },
            LayoutOrder = layoutOrder,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = size,
            ZIndex = zIndex,
            ref = function(p6) -- ref | line: 144
                -- upvalues: v2 (copy)
                v2.current = p6 or nil
            end
        }, react.createElement(default, {
            cornerRadius = 0.5,
            isStudded = false,
            strokeThickness = 0.06,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = trackColor,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 0.35),
            strokeColor = trackStrokeColor,
            transparency = disabled and 0.5 or 0,
            zIndex = zIndex + 1
        }, react.createElement(default, {
            cornerRadius = 0.5,
            isStudded = false,
            anchorPoint = Vector2.new(0, 0.5),
            backgroundColor = fillColor,
            position = UDim2.fromScale(0, 0.5),
            size = UDim2.new(math.max(v16, 0.03), 0, 1, 0),
            transparency = disabled and 0.5 or 0,
            zIndex = zIndex + 2
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(v16, 0, 0.5, 0),
            Size = UDim2.new(knobSizeScale, 0, 1, 0),
            ZIndex = zIndex + 4
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default, {
            cornerRadius = 0.5,
            isStudded = false,
            strokeThickness = 0.1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(255, 255, 255),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(0, 0, 0),
            transparency = disabled and 0.5 or 0,
            zIndex = zIndex + 4
        })))
    end
}
