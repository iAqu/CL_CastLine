-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local forwardRef, useBinding, useEffect, useImperativeHandle = react.forwardRef, react.useBinding, react.useEffect, react.useImperativeHandle
local useRef = react.useRef
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default

local function computeGradient(p1) -- line: 15
    local v1 = p1 / 100
    local t1 = {
        dark = Color3.fromRGB(200, 70, 0),
        light = Color3.fromRGB(255, 160, 40)
    }
    local t2 = {
        dark = Color3.fromRGB(160, 140, 0),
        light = Color3.fromRGB(255, 230, 50)
    }
    local t3 = {
        dark = Color3.fromRGB(0, 170, 0),
        light = Color3.fromRGB(120, 255, 60)
    }
    local v2, v3

    if v1 <= 0.5 then
        local v4 = v1 / 0.5

        v2 = t1.dark:Lerp(t2.dark, v4)
        v3 = t1.light:Lerp(t2.light, v4)
    else
        local v5 = (v1 - 0.5) / 0.5

        v2 = t2.dark:Lerp(t3.dark, v5)
        v3 = t2.light:Lerp(t3.light, v5)
    end

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, v2),
        ColorSequenceKeypoint.new(0.5, v3),
        ColorSequenceKeypoint.new(1, v2)
    })
end

local t4 = {
    0.2, 0.4, 0.6, 0.8
}

return {
    default = forwardRef(function(p2, p3) -- line: 44
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), useImperativeHandle (copy), useRef (copy), RunService (copy), default (copy), useTheme (copy), default2 (copy), computeGradient (copy), t4 (copy)
        local isGamepadEnabled = p2.isGamepadEnabled

        if isGamepadEnabled == nil then
            isGamepadEnabled = false
        end

        local speedMultiplier = p2.speedMultiplier
        local v6 = speedMultiplier

        if speedMultiplier == nil then
            v6 = 1
            speedMultiplier = 1
        end

        local v7 = useTheme()
        local v8, v9 = useBinding(0)
        local v10 = useRef(nil)
        local v11 = useRef(nil)
        local v12 = useRef(0)
        local v13 = useRef(speedMultiplier)

        useEffect(function() -- line: 59
            -- upvalues: v6 (ref), v13 (copy)
            v13.current = v6
        end, { v6 })

        local v14 = useRef(false)

        useEffect(function() -- line: 63
            -- upvalues: v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), RunService (copy)
            local function startLoop() -- line: 64
                -- upvalues: v9 (copy), v10 (copy), v12 (copy), v13 (copy), v14 (copy), RunService (copy)
                local current = v10.current

                if current ~= nil then
                    current()
                end

                v14.current = false

                local n1 = 0
                local connection = RunService.Heartbeat:Connect(function(p4) -- line: 71
                    -- upvalues: n1 (ref), v9 (copy), v12 (copy), v13 (copy), v14 (copy)
                    if v14.current then
                        return nil
                    end

                    n1 += p4 * v13.current

                    local v16 = n1 % 1
                    local v17 = if v16 < 0.5 then v16 / 0.5 * 100 else (1 - v16) / 0.5 * 100

                    v12.current = v17
                    v9(v17)
                end)

                v10.current = function() -- line: 82
                    -- upvalues: connection (copy)
                    return connection:Disconnect()
                end
            end

            v11.current = startLoop
            startLoop()

            return function() -- line: 88
                -- upvalues: v10 (copy)
                local current = v10.current

                if current ~= nil then
                    current = current()
                end

                return current
            end
        end, { v9 })
        useImperativeHandle(p3, function() -- line: 96
            -- upvalues: v9 (copy), v10 (copy), v11 (copy), v12 (copy), v14 (copy)
            return {
                freeze = function(_) -- freeze | line: 98
                    -- upvalues: v9 (copy), v10 (copy), v12 (copy), v14 (copy)
                    v14.current = true

                    local current = v10.current

                    if current ~= nil then
                        current()
                    end

                    v10.current = nil
                    v9(v12.current)
                end,
                getStrength = function(_) -- getStrength | line: 107
                    -- upvalues: v12 (copy)
                    return v12.current
                end,
                reset = function(_) -- reset | line: 110
                    -- upvalues: v9 (copy), v11 (copy), v12 (copy)
                    v12.current = 0
                    v9(0)

                    local current = v11.current

                    if current ~= nil then
                        current()
                    end
                end
            }
        end)

        local v18 = v8:map(function(p8) -- line: 120
            return UDim2.fromScale(1, p8 / 100)
        end)
        local v19 = v8:map(function(p9) -- line: 123
            -- upvalues: computeGradient (copy)
            return computeGradient(p9)
        end)
        local v20 = react.createElement("frame", {
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 1),
            Size = v18
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.1, 0)
        }), react.createElement("uigradient", {
            Color = v19
        }), react.createElement("frame", {
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, 0.012)
        }, react.createElement("uigradient", {
            Color = v19
        }), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(66, 66, 66),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(1, 1)
        })))
        local v21 = table.create(#t4)

        local function v22(p10, p11) -- line: 159
            -- upvalues: react (copy)
            return react.createElement("frame", {
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Position = UDim2.fromScale(0.5, p10),
                Size = UDim2.fromScale(1, 0.017),
                key = tostring(p11)
            })
        end

        for v23, v24 in t4 do
            v21[v23] = v22(v24, v23 - 1, t4)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.405),
            Position = UDim2.fromScale(0.97, 0.5),
            Size = UDim2.fromScale(0.137, 0.424)
        }, react.createElement(default2, {
            clipsDescendants = true,
            cornerRadius = 0.1,
            isStudded = true,
            strokeThickness = 0.06,
            tileSize = 90,
            transparency = 0,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0),
            backgroundColor = Color3.fromRGB(180, 180, 180),
            position = UDim2.fromScale(0.5, 0),
            size = UDim2.fromScale(0.25, 0.809),
            strokeColor = Color3.fromRGB(20, 20, 20)
        }, v20, v21), react.createElement(default, {
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.fromRGB(255, 255, 255),
            overrideProps = {
                TextScaled = true,
                ZIndex = 10,
                Font = v7.textFont2,
                Size = UDim2.fromScale(1, 0.1)
            },
            position = UDim2.fromScale(0.5, 0.867),
            text = isGamepadEnabled and "Press R2 to cast!" or "Tap to cast!"
        })))
    end)
}
