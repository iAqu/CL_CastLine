-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local UserInputService, Workspace = services.UserInputService, services.Workspace
local v1 = RuntimeLib.import(script, script.Parent.Parent, "hook-flight-steering-atom")
local hookFlightSteeringActiveAtom, hookFlightSteeringInputAtom, hookFlightTouchControlsVisibleAtom, hookFlightTouchInputAtom = v1.hookFlightSteeringActiveAtom, v1.hookFlightSteeringInputAtom, v1.hookFlightTouchControlsVisibleAtom, v1.hookFlightTouchInputAtom
local remapFlightSteeringInput = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "flight-steering-utils").remapFlightSteeringInput
local t1 = {
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.Left] = true
}
local t2 = {
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Right] = true
}

local function isGamepad(p1) -- line: 22
    if p1 == Enum.UserInputType.Gamepad1
        or p1 == Enum.UserInputType.Gamepad2
        or p1 == Enum.UserInputType.Gamepad3
        or p1 == Enum.UserInputType.Gamepad4
        or p1 == Enum.UserInputType.Gamepad5
        or p1 == Enum.UserInputType.Gamepad6
        or p1 == Enum.UserInputType.Gamepad7 then
        return true
    end

    return p1 == Enum.UserInputType.Gamepad8
end

local function isMobileLandscape() -- line: 25
    -- upvalues: UserInputService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera = CurrentCamera.ViewportSize
    end

    return UserInputService.TouchEnabled and CurrentCamera ~= nil and CurrentCamera.X > CurrentCamera.Y
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 36
        return "HookFlightSteeringController"
    end
})

self.__index = self

function self.new(...) -- line: 41
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2) -- line: 45
    p2._leftHeld = false
    p2._rightHeld = false
    p2._gamepadInput = 0
    p2._screenTouchInputs = {}
    p2._lastResolvedInput = 0
    p2._lastTouchControlsVisible = false
    p2._wasFlightActive = false
end

function self.onInit(p3) -- line: 54
    -- upvalues: UserInputService (copy), Workspace (copy), hookFlightSteeringActiveAtom (copy), t1 (copy), t2 (copy), isGamepad (copy)
    UserInputService.InputBegan:Connect(function(p4, p5) -- line: 55
        -- upvalues: p3 (copy), Workspace (copy), hookFlightSteeringActiveAtom (copy), t1 (copy), t2 (copy)
        if p5 then
            return nil
        end

        if p4.UserInputType == Enum.UserInputType.Touch then
            if hookFlightSteeringActiveAtom() then
                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera ~= nil then
                    CurrentCamera = CurrentCamera.ViewportSize
                end

                if CurrentCamera ~= nil then
                    p3._screenTouchInputs[p4] = p4.Position.X < CurrentCamera.X * 0.5 and -1 or 1
                end
            end

            return nil
        end

        if t1[p4.KeyCode] ~= nil then
            p3._leftHeld = true
            p3._gamepadInput = 0
        end

        if t2[p4.KeyCode] ~= nil then
            p3._rightHeld = true
            p3._gamepadInput = 0
        end
    end)
    UserInputService.InputEnded:Connect(function(p6) -- line: 88
        -- upvalues: p3 (copy), t1 (copy), t2 (copy)
        if p6.UserInputType == Enum.UserInputType.Touch then
            p3._screenTouchInputs[p6] = nil

            return nil
        end

        if t1[p6.KeyCode] ~= nil then
            p3._leftHeld = false
        end

        if t2[p6.KeyCode] ~= nil then
            p3._rightHeld = false
        end
    end)
    UserInputService.InputChanged:Connect(function(p7) -- line: 104
        -- upvalues: p3 (copy), isGamepad (copy)
        if isGamepad(p7.UserInputType) and p7.KeyCode == Enum.KeyCode.Thumbstick1 then
            p3._gamepadInput = p7.Position.X
        end
    end)
    UserInputService.WindowFocusReleased:Connect(function() -- line: 109
        -- upvalues: p3 (copy)
        return p3:_resetInput()
    end)
end

function self.onRender(p8) -- line: 113
    -- upvalues: UserInputService (copy), Workspace (copy), hookFlightSteeringActiveAtom (copy), hookFlightSteeringInputAtom (copy), hookFlightTouchInputAtom (copy), remapFlightSteeringInput (copy)
    if not hookFlightSteeringActiveAtom() then
        p8:_setTouchControlsVisible(false)

        if p8._wasFlightActive then
            p8:_resetInput()
        end

        p8._wasFlightActive = false

        return nil
    end

    p8._wasFlightActive = true

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera = CurrentCamera.ViewportSize
    end

    local TouchEnabled = UserInputService.TouchEnabled and CurrentCamera ~= nil and CurrentCamera.X > CurrentCamera.Y

    p8:_setTouchControlsVisible(TouchEnabled)

    if not TouchEnabled then
        table.clear(p8._screenTouchInputs)
        hookFlightTouchInputAtom(0)
    end

    local v4 = if p8._leftHeld == p8._rightHeld then 0 elseif p8._leftHeld then -1 else 1
    local v5 = remapFlightSteeringInput(p8._gamepadInput)
    local n1 = 0

    for _, v6 in p8._screenTouchInputs do
        n1 += v6
    end

    n1 = math.clamp(n1, -1, 1)

    local v8 = remapFlightSteeringInput((math.clamp(hookFlightTouchInputAtom() + n1, -1, 1)))

    if not (math.abs(v8) > 0.001) then
        v8 = if math.abs(v5) > 0.001 then v5 else v4
    end

    if v8 ~= p8._lastResolvedInput then
        p8._lastResolvedInput = v8
        hookFlightSteeringInputAtom(v8)
    end
end

function self._resetInput(p9) -- line: 151
    -- upvalues: hookFlightSteeringInputAtom (copy), hookFlightTouchInputAtom (copy)
    p9._leftHeld = false
    p9._rightHeld = false
    p9._gamepadInput = 0
    table.clear(p9._screenTouchInputs)
    p9._lastResolvedInput = 0
    hookFlightSteeringInputAtom(0)
    hookFlightTouchInputAtom(0)
end

function self._setTouchControlsVisible(p10, p11) -- line: 160
    -- upvalues: hookFlightTouchControlsVisibleAtom (copy)
    if p11 == p10._lastTouchControlsVisible then
        return nil
    end

    p10._lastTouchControlsVisible = p11
    hookFlightTouchControlsVisibleAtom(p11)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/hook-flight-steering-controller@HookFlightSteeringController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    HookFlightSteeringController = self
}
