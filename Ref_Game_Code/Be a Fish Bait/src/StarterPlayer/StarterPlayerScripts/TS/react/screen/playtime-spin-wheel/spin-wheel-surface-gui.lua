-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect = react.useBinding, react.useEffect
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, RunService = services.Players, services.RunService
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local usePlaytimeSpinWheelSegments = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-playtime-spin-wheel-segments").usePlaytimeSpinWheelSegments
local useSpinWheelMotion = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-spin-wheel-motion").useSpinWheelMotion
local selectPlayerAquariumMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquariumMoneyPerSecond
local default = RuntimeLib.import(script, script.Parent, "playtime-spin-wheel-face").default

return {
    default = function(p1) -- SpinWheelSurfaceGui | line: 15
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), Players (copy), RunService (copy), useRootSelectorCreator (copy), usePlaytimeSpinWheelSegments (copy), useSpinWheelMotion (copy), selectPlayerAquariumMoneyPerSecond (copy), default (copy)
        local canvasSize = p1.canvasSize

        if canvasSize == nil then
            canvasSize = 600
        end

        local idleRotationSpeed = p1.idleRotationSpeed

        if idleRotationSpeed == nil then
            idleRotationSpeed = 12
        end

        local v1 = usePlaytimeSpinWheelSegments()
        local v2 = useRootSelectorCreator(selectPlayerAquariumMoneyPerSecond, (tostring(Players.LocalPlayer.UserId)))
        local v3, v4 = useBinding(0)
        local v5 = useSpinWheelMotion(1)
        local wheelScale, pointerScale, pointerRotation = v5.wheelScale, v5.pointerScale, v5.pointerRotation

        useEffect(function() -- line: 33
            -- upvalues: idleRotationSpeed (ref), v3 (copy), v4 (copy), RunService (copy)
            local connection = RunService.Heartbeat:Connect(function(p2) -- line: 34
                -- upvalues: idleRotationSpeed (ref), v3 (copy), v4 (copy)
                v4(v3:getValue() + idleRotationSpeed * p2)
            end)

            return function() -- line: 37
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { idleRotationSpeed, v3, v4 })

        return react.createElement("surfacegui", {
            AlwaysOnTop = false,
            Brightness = 1,
            ClipsDescendants = true,
            LightInfluence = 0,
            PixelsPerStud = 40,
            ResetOnSpawn = false,
            ZOffset = 2,
            Adornee = p1.adornee,
            CanvasSize = Vector2.new(canvasSize, canvasSize),
            Face = Enum.NormalId.Left,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            isSmall = false,
            pointerRotation = pointerRotation,
            pointerScale = pointerScale,
            rotation = v3,
            segments = v1,
            size = UDim2.fromScale(1, 1),
            totalMps = v2,
            wheelScale = wheelScale
        })))
    end
}
