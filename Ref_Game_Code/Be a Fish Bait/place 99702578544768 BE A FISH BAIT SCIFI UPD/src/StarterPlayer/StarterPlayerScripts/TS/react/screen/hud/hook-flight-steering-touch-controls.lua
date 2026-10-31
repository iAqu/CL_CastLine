-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local UserInputService, Workspace = services.UserInputService, services.Workspace
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hook-flight-steering-atom")
local hookFlightSteeringActiveAtom, hookFlightSteeringInputAtom, hookFlightTouchControlsVisibleAtom, hookFlightTouchInputAtom = v1.hookFlightSteeringActiveAtom, v1.hookFlightSteeringInputAtom, v1.hookFlightTouchControlsVisibleAtom, v1.hookFlightTouchInputAtom
local v2 = Vector2.new(1, 146)
local v3 = Vector2.new(146, 146)
local v4 = Vector2.new(144, 144)

local function SteeringZone(p1) -- line: 20
    -- upvalues: react (copy), useState (copy), hookFlightSteeringInputAtom (copy), hookFlightTouchInputAtom (copy), v2 (copy), v3 (copy), v4 (copy)
    local direction = p1.direction
    local v5, v6 = useState(false)

    local function v7(p2) -- line: 23
        -- upvalues: direction (copy), v6 (copy), hookFlightSteeringInputAtom (copy), hookFlightTouchInputAtom (copy)
        v6(p2)
        hookFlightTouchInputAtom(if p2 then direction else 0)

        if not p2 then
            hookFlightSteeringInputAtom(0)
        end
    end

    return react.createElement("textbutton", {
        BackgroundTransparency = 1,
        Text = "",
        AnchorPoint = Vector2.new(direction == -1 and 0 or 1, 0.5),
        Position = UDim2.new(direction == -1 and 0.03 or 0.97, 0, 0.82, 0),
        Size = UDim2.fromScale(0.26, 0.26),
        Event = {
            MouseButton1Down = function() -- MouseButton1Down | line: 37
                -- upvalues: v7 (copy)
                return v7(true)
            end,
            MouseButton1Up = function() -- MouseButton1Up | line: 40
                -- upvalues: v7 (copy)
                return v7(false)
            end,
            MouseLeave = function() -- MouseLeave | line: 43
                -- upvalues: v7 (copy)
                return v7(false)
            end
        }
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png",
        AnchorPoint = Vector2.new(0.5, 0.5),
        ImageRectOffset = if v5 then v3 else v2,
        ImageRectSize = v4,
        Position = UDim2.fromScale(0.5, 0.5),
        Rotation = direction == -1 and -90 or 90,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })))
end

local function isMobileLandscape() -- line: 60
    -- upvalues: UserInputService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera = CurrentCamera.ViewportSize
    end

    return UserInputService.TouchEnabled and CurrentCamera ~= nil and CurrentCamera.X > CurrentCamera.Y
end

return {
    default = function() -- HookFlightSteeringTouchControls | line: 68
        -- upvalues: subscribe (copy), react (copy), useEffect (copy), useState (copy), UserInputService (copy), Workspace (copy), hookFlightSteeringActiveAtom (copy), hookFlightSteeringInputAtom (copy), hookFlightTouchControlsVisibleAtom (copy), hookFlightTouchInputAtom (copy), SteeringZone (copy)
        local v8, v9 = useState(hookFlightTouchControlsVisibleAtom())

        useEffect(function() -- line: 70
            -- upvalues: v9 (copy), subscribe (copy), hookFlightTouchControlsVisibleAtom (copy)
            return subscribe(hookFlightTouchControlsVisibleAtom, v9)
        end, {})
        useEffect(function() -- line: 73
            -- upvalues: hookFlightSteeringInputAtom (copy), hookFlightTouchInputAtom (copy)
            return function() -- line: 74
                -- upvalues: hookFlightSteeringInputAtom (copy), hookFlightTouchInputAtom (copy)
                hookFlightTouchInputAtom(0)
                hookFlightSteeringInputAtom(0)
            end
        end, {})

        if v8 then
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera ~= nil then
                CurrentCamera = CurrentCamera.ViewportSize
            end

            local TouchEnabled = UserInputService.TouchEnabled and CurrentCamera ~= nil and CurrentCamera.X > CurrentCamera.Y

            if TouchEnabled and hookFlightSteeringActiveAtom() then
                return react.createElement("frame", {
                    BackgroundTransparency = 1,
                    ZIndex = 40,
                    Size = UDim2.fromScale(1, 1)
                }, react.createElement(SteeringZone, {
                    direction = -1
                }), react.createElement(SteeringZone, {
                    direction = 1
                }))
            end
        end

        return nil
    end
}
