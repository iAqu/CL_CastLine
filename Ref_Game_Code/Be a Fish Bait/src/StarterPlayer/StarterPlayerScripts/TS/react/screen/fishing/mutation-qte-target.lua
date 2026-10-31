-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "circular-progress").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local useQteConsoleKey = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-qte-console-key").useQteConsoleKey
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local getMutationColorGradient = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").getMutationColorGradient
local haptics = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "haptics")
local cameraShakeEnabledAtom, hapticCircleClick = haptics.cameraShakeEnabledAtom, haptics.hapticCircleClick
local v1 = Color3.fromRGB(255, 255, 255)

local function sampleMutationQtePosition() -- line: 36
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera = CurrentCamera.ViewportSize
    end

    local v2 = if CurrentCamera == nil or not (CurrentCamera.X > 0) then 0 else 84 / CurrentCamera.X
    local v3 = if CurrentCamera == nil or not (CurrentCamera.Y > 0) then 0 else 84 / CurrentCamera.Y

    local function v4(p1, p2, p3) -- line: 47
        local v5 = p1 + p3
        local v6 = p2 - p3

        if v5 <= v6 then
            return v5 + math.random() * (v6 - v5)
        end

        return p1 + (p2 - p1) * 0.5
    end

    local v7

    if math.random() < 0.5 then
        local v8 = 0.1 + v2
        local v9 = 0.35 - v2

        v7 = if v8 <= v9 then v8 + math.random() * (v9 - v8) else 0.22499999999999998
    else
        local v10 = 0.6 + v2
        local v11 = 0.85 - v2

        v7 = if v10 <= v11 then v10 + math.random() * (v11 - v10) else 0.725
    end

    local v12 = 0.2 + v3
    local v13 = 0.8 - v3
    local v14 = if v12 <= v13 then v12 + math.random() * (v13 - v12) else 0.5

    return Vector2.new(v7, v14)
end

return {
    default = function(p4) -- MutationQteTarget | line: 60
        -- upvalues: Flamework (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), RunService (copy), Workspace (copy), shake (copy), default (copy), default2 (copy), useIsUsingGamepad (copy), useQteConsoleKey (copy), images (copy), getMutationColorGradient (copy), cameraShakeEnabledAtom (copy), hapticCircleClick (copy), v1 (copy), sampleMutationQtePosition (copy)
        local mutation, onMiss, onTap = p4.mutation, p4.onMiss, p4.onTap
        local v15 = useRef(os.clock())
        local v16 = useRef(false)
        local v17 = useRef(onTap)

        v17.current = onTap

        local v18 = useRef(onMiss)

        v18.current = onMiss

        local v19 = useState(sampleMutationQtePosition)
        local v20, v21 = useState(100)
        local v22 = useRef(100)
        local v23, v24 = useMotion(0)

        useEffect(function() -- line: 74
            -- upvalues: v24 (copy)
            v24:linear(-1, {
                speed = 0.6
            })

            local v25 = v24:onComplete(function() -- line: 81
                -- upvalues: v24 (copy)
                v24:immediate(0)
                v24:linear(-1, {
                    speed = 0.6
                })
            end)

            return function() -- line: 85
                -- upvalues: v25 (copy)
                return v25()
            end
        end, { v24 })
        useEffect(function() -- line: 89
            -- upvalues: v15 (copy), v16 (copy), v18 (copy), v21 (copy), v22 (copy), RunService (copy)
            local connection = RunService.Heartbeat:Connect(function() -- line: 90
                -- upvalues: v15 (copy), v16 (copy), v18 (copy), v21 (copy), v22 (copy)
                if v16.current then
                    return nil
                end

                local v27 = math.min((os.clock() - v15.current) / 2.5, 1)
                local v30 = math.round(math.max(1 - v27, 0) * 50) * 2

                if v30 ~= v22.current then
                    v22.current = v30
                    v21(v30)
                end

                if v27 >= 1 then
                    v16.current = true
                    v18.current()
                end
            end)

            return function() -- line: 106
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {})

        local function v31() -- line: 110
            -- upvalues: v16 (copy), v17 (copy), Flamework (copy), Workspace (copy), shake (copy), cameraShakeEnabledAtom (copy), hapticCircleClick (copy)
            if v16.current then
                return nil
            end

            v16.current = true

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera and cameraShakeEnabledAtom() then
                local _CFrame = CurrentCamera.CFrame
                local v32 = shake.new()

                v32.Amplitude = 0.8
                v32.Frequency = 0.07142857142857142
                v32.FadeInTime = 0
                v32.FadeOutTime = 0.25
                v32.SustainTime = 0
                v32.PositionInfluence = Vector3.new(0.1, 0.1, 0.1)
                v32.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
                v32:Start()
                v32:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p5, p6, p7) -- line: 127
                    -- upvalues: CurrentCamera (copy), _CFrame (copy)
                    if p7 then
                        CurrentCamera.CFrame = _CFrame

                        return nil
                    end

                    local _CFrame2 = CurrentCamera.CFrame
                    local v33 = CFrame.new(p5)
                    local v34 = CFrame.fromEulerAnglesXYZ(p6.X, p6.Y, p6.Z)

                    CurrentCamera.CFrame = _CFrame2 * v33 * v34
                end)
            end

            hapticCircleClick()
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):playSoundPolyphonic("PopSound", 1, 2)
            Flamework.resolveDependency("client/controllers/sound-controller@SoundController"):playSoundPolyphonic("ThockyKeyboard", 1, 5, 0.6)
            v17.current()
        end

        local v35 = useQteConsoleKey(v31)
        local v36 = useIsUsingGamepad()
        local v37 = getMutationColorGradient(mutation)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(v19.X, v19.Y),
            Size = UDim2.fromOffset(140, 140)
        }, react.createElement(default, {
            direction = "Left",
            missingPartType = "TransAndColor",
            starterPoint = "Up",
            transOfMissingPart = 1,
            transOfPercentPart = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            colorOfMissingPart = Color3.fromRGB(0, 0, 0),
            colorOfPercentPart = v1,
            position = UDim2.fromScale(0.5, 0.5),
            progress = v20,
            size = UDim2.fromScale(1, 1)
        }), react.createElement("frame", {
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 22,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(84, 84)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Thickness = 3,
            Color = Color3.fromRGB(255, 255, 255)
        }), react.createElement("uigradient", {
            Rotation = 45,
            Color = v37,
            Offset = v23:map(function(p8) -- line: 182
                return Vector2.new(p8, 0)
            end)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 23,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.pointIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(46.2, 46.2)
        })), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 25,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = v31
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(168, 168)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), v36 and react.createElement(default2, {
            radius = 70,
            size = 48,
            keyCode = v35
        }))
    end
}
