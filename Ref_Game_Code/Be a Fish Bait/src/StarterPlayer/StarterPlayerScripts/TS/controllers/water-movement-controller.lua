-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, UserInputService, Workspace = services.Players, services.UserInputService, services.Workspace
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local v1 = RuntimeLib.import(script, script.Parent.Parent, "water-movement-ui-atom")
local waterMovementHintVisibleAtom, waterMovementTouchControlsVisibleAtom, waterMovementTouchVerticalDirectionAtom = v1.waterMovementHintVisibleAtom, v1.waterMovementTouchControlsVisibleAtom, v1.waterMovementTouchVerticalDirectionAtom
local isPointInsideWaterSwimZone = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "water-swim-zone-utils").isPointInsideWaterSwimZone
local t1 = {
    [Enum.KeyCode.Space] = true,
    [Enum.KeyCode.E] = true,
    [Enum.KeyCode.ButtonR2] = true
}
local t2 = {
    [Enum.KeyCode.LeftShift] = true,
    [Enum.KeyCode.Q] = true,
    [Enum.KeyCode.ButtonR1] = true
}
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 38
        return "WaterMovementController"
    end
})

self.__index = self

function self.new(...) -- line: 43
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 47
    p1._characterController = p2
    p1._heldAscendKeys = {}
    p1._heldDescendKeys = {}
    p1._lastFacingDirection = Vector3.new(0, 0, -1)
    p1._currentPitchRadians = 0
    p1._lastRenderTimestamp = 0
    p1._lastSeafloorSampleTimestamp = (-1e999)
    p1._lastWaterStateSampleTimestamp = (-1e999)
    p1._seafloorRaycastParams = RaycastParams.new()
    p1._waterState = false
end

function self.onInit(p3) -- line: 59
    -- upvalues: UserInputService (copy), t1 (copy), t2 (copy)
    UserInputService.InputBegan:Connect(function(p4, p5) -- line: 60
        -- upvalues: p3 (copy), t1 (copy), t2 (copy)
        if p5 then
            return nil
        end

        if t1[p4.KeyCode] ~= nil then
            p3._heldAscendKeys[p4.KeyCode] = true
        end

        if t2[p4.KeyCode] ~= nil then
            p3._heldDescendKeys[p4.KeyCode] = true
        end
    end)
    UserInputService.InputEnded:Connect(function(p6) -- line: 77
        -- upvalues: p3 (copy)
        p3._heldAscendKeys[p6.KeyCode] = nil
        p3._heldDescendKeys[p6.KeyCode] = nil
    end)
end

function self.onRender(p7) -- line: 86
    -- upvalues: Players (copy), waterMovementTouchVerticalDirectionAtom (copy)
    local elapsed = os.clock()
    local v4 = if p7._lastRenderTimestamp > 0 then math.min(elapsed - p7._lastRenderTimestamp, 0.06666666666666667) else 0.016666666666666666

    p7._lastRenderTimestamp = elapsed

    local Character = Players.LocalPlayer.Character
    local v6 = p7._characterController.humanoid()
    local v7 = if Character == nil then Character else Character:FindFirstChild("HumanoidRootPart")

    if not (Character and v6 and v7) then
        p7:_cleanupWaterState()

        return nil
    end

    local v8 = p7:_getWaterState(v7.Position, elapsed)

    if v8 then
        p7:_ensureWaterFreefallState(v6)
    end

    local v9 = p7:_canUseNonTouchWaterMovement(v8)
    local v10 = p7:_canUseTouchWaterMovement(v8)
    local v11 = v9 or v10

    p7:_updateWaterMovementUi(v9, v10)

    if v10 then
        p7:_hideMobileJumpButton()
    end

    if not v11 then
        p7:_cleanupWaterState(not v8)

        return nil
    end

    p7:_ensureOrientationConstraint(v7, v6)

    local v12 = next(p7._heldAscendKeys) ~= nil
    local v13 = if v12 == (next(p7._heldDescendKeys) ~= nil) then 0 elseif v12 then 1 else -1
    local v14 = if v10 then waterMovementTouchVerticalDirectionAtom() else 0

    if v14 ~= 0 then
        v13 = v14
    end

    local v15 = p7:_getSeafloorDistance(Character, v7.Position, elapsed)
    local v16 = v15 ~= nil and v15 <= 10

    if not (v13 < 0) then
        v16 = false
    end

    if v16 then
        v13 = 0
    end

    local v17 = if v13 == 0 and not v16 and v15 ~= nil then math.clamp((10 - v15) * 12, 0, 18) else 0
    local AssemblyLinearVelocity = v7.AssemblyLinearVelocity

    v7.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, v13 * 18 + v17, AssemblyLinearVelocity.Z)

    local v20 = Vector3.new(v6.MoveDirection.X, 0, v6.MoveDirection.Z)
    local _lastFacingDirection = p7._lastFacingDirection

    if v20.Magnitude > 0.05 then
        _lastFacingDirection = v20.Unit
    else
        local LookVector = v7.CFrame.LookVector
        local v21 = Vector3.new(LookVector.X, 0, LookVector.Z)

        if v21.Magnitude > 0.05 then
            _lastFacingDirection = v21.Unit
        end
    end

    local v23 = math.clamp(v4 * 10, 0, 1)
    local v24 = p7._lastFacingDirection:Lerp(_lastFacingDirection, v23)

    if v24.Magnitude > 0.001 then
        p7._lastFacingDirection = v24.Unit
    end

    local v26 = math.rad(18 * v13) - p7._currentPitchRadians
    local v29 = math.min(math.abs(v26), v4 * 3.141592653589793)

    p7._currentPitchRadians += math.sign(v26) * v29

    local Unit = (CFrame.lookAt(Vector3.new(0, 0, 0), p7._lastFacingDirection) * CFrame.Angles(p7._currentPitchRadians, 0, 0)).LookVector.Unit

    p7._alignOrientation.CFrame = CFrame.lookAt(v7.Position, v7.Position + Unit)
end

function self._canUseNonTouchWaterMovement(_, p9) -- line: 157
    -- upvalues: UserInputService (copy), fishingMovementLockedAtom (copy)
    local v30, v31

    if p9 then
        if UserInputService.KeyboardEnabled then
            v31 = false
        else
            local GamepadEnabled = UserInputService.GamepadEnabled

            if GamepadEnabled then
                v31 = false
            else
                v30 = GamepadEnabled
                v31 = true
            end
        end
    else
        v30 = p9
        v31 = true
    end

    if not v31 then
        v30 = not fishingMovementLockedAtom()
    end

    return v30
end

function self._canUseTouchWaterMovement(_, p11) -- line: 160
    -- upvalues: UserInputService (copy), fishingMovementLockedAtom (copy)
    return p11 and UserInputService.TouchEnabled and not fishingMovementLockedAtom()
end

function self._isCharacterInsideWater(_, p13) -- line: 163
    -- upvalues: isPointInsideWaterSwimZone (copy)
    return isPointInsideWaterSwimZone(p13)
end

function self._getWaterState(p14, p15, p16) -- line: 166
    if p16 - p14._lastWaterStateSampleTimestamp >= 0.1 then
        p14._waterState = p14:_isCharacterInsideWater(p15)
        p14._lastWaterStateSampleTimestamp = p16
    end

    return p14._waterState
end

function self._getSeafloorDistance(p17, p18, p19, p20) -- line: 173
    -- upvalues: Workspace (copy)
    if p20 - p17._lastSeafloorSampleTimestamp < 0.1 then
        return p17._seafloorDistance
    end

    p17._seafloorRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
    p17._seafloorRaycastParams.FilterDescendantsInstances = { p18 }
    p17._seafloorRaycastParams.RespectCanCollide = true

    local v32 = Workspace:Raycast(p19, Vector3.new(0, -12, 0), p17._seafloorRaycastParams)

    p17._lastSeafloorSampleTimestamp = p20
    p17._seafloorDistance = if v32 ~= nil then v32.Distance else v32

    return p17._seafloorDistance
end

function self._updateWaterMovementUi(p21, p22, p23) -- line: 189
    -- upvalues: waterMovementHintVisibleAtom (copy), waterMovementTouchControlsVisibleAtom (copy)
    if p21._lastKeyboardWaterMovementEnabled ~= p22 then
        waterMovementHintVisibleAtom(p22)
        p21._lastKeyboardWaterMovementEnabled = p22
    end

    if p21._lastTouchWaterMovementEnabled ~= p23 then
        waterMovementTouchControlsVisibleAtom(p23)
        p21._lastTouchWaterMovementEnabled = p23
    end
end

function self._hideMobileJumpButton(p24) -- line: 199
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        PlayerGui = PlayerGui:FindFirstChild("TouchGui")
    end

    if PlayerGui ~= nil then
        PlayerGui = PlayerGui:FindFirstChild("JumpButton", true)
    end

    if not (PlayerGui and PlayerGui:IsA("GuiObject")) or p24._hiddenJumpButton == PlayerGui then
        return nil
    end

    p24:_restoreMobileJumpButton()
    p24._hiddenJumpButton = PlayerGui
    p24._jumpButtonVisibleBeforeWater = PlayerGui.Visible
    PlayerGui.Visible = false
    p24._jumpButtonVisibilityConnection = PlayerGui:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 221
        -- upvalues: p24 (copy), PlayerGui (ref)
        if p24._hiddenJumpButton == PlayerGui and PlayerGui.Visible then
            PlayerGui.Visible = false
        end
    end)
end

function self._restoreMobileJumpButton(p25) -- line: 228
    local _jumpButtonVisibilityConnection = p25._jumpButtonVisibilityConnection

    if _jumpButtonVisibilityConnection ~= nil then
        _jumpButtonVisibilityConnection:Disconnect()
    end

    p25._jumpButtonVisibilityConnection = nil

    if p25._hiddenJumpButton ~= nil and p25._jumpButtonVisibleBeforeWater ~= nil then
        p25._hiddenJumpButton.Visible = p25._jumpButtonVisibleBeforeWater
    end

    p25._hiddenJumpButton = nil
    p25._jumpButtonVisibleBeforeWater = nil
end

function self._ensureOrientationConstraint(p26, p27, p28) -- line: 240
    -- upvalues: Workspace (copy)
    local _alignOrientation = p26._alignOrientation

    if _alignOrientation ~= nil then
        _alignOrientation = _alignOrientation.Parent
    end

    local v33 = _alignOrientation == p27
    local v34

    if v33 then
        local _alignmentAttachment = p26._alignmentAttachment

        if _alignmentAttachment ~= nil then
            _alignmentAttachment = _alignmentAttachment.Parent
        end

        local v35 = _alignmentAttachment == p27

        if v35 then
            local _antiGravityForce = p26._antiGravityForce

            if _antiGravityForce ~= nil then
                _antiGravityForce = _antiGravityForce.Parent
            end

            v34 = _antiGravityForce == p27
        else
            v34 = v35
        end
    else
        v34 = v33
    end

    if v34 then
        return nil
    end

    p26:_cleanupAlignmentInstances()

    if p26._autoRotateBeforeWater == nil then
        p26._autoRotateBeforeWater = p28.AutoRotate
    end

    p28.AutoRotate = false

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "WaterMovementAttachment"
    Attachment.Parent = p27
    p26._alignmentAttachment = Attachment

    local AlignOrientation = Instance.new("AlignOrientation")

    AlignOrientation.Name = "WaterMovementAlignOrientation"
    AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AlignOrientation.Attachment0 = Attachment
    AlignOrientation.RigidityEnabled = false
    AlignOrientation.MaxAngularVelocity = 3.141592653589793
    AlignOrientation.MaxTorque = 1e999
    AlignOrientation.Responsiveness = 8
    AlignOrientation.Parent = p27
    p26._alignOrientation = AlignOrientation

    local VectorForce = Instance.new("VectorForce")

    VectorForce.Name = "WaterMovementAntiGravity"
    VectorForce.Attachment0 = Attachment
    VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
    VectorForce.ApplyAtCenterOfMass = true
    VectorForce.Force = Vector3.new(0, p27.AssemblyMass * Workspace.Gravity, 0)
    VectorForce.Parent = p27
    p26._antiGravityForce = VectorForce
end

function self._ensureWaterFreefallState(p29, p30) -- line: 291
    if p29._humanoidBeforeWater ~= p30 then
        p29._humanoidBeforeWater = p30
        p29._runningStateEnabledBeforeWater = p30:GetStateEnabled(Enum.HumanoidStateType.Running)
        p29._landedStateEnabledBeforeWater = p30:GetStateEnabled(Enum.HumanoidStateType.Landed)
        p30:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        p30:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    end

    if p30:GetState() ~= Enum.HumanoidStateType.Freefall then
        p30:ChangeState(Enum.HumanoidStateType.Freefall)
    end
end

function self._cleanupWaterState(p31, p32) -- line: 303
    -- upvalues: waterMovementTouchVerticalDirectionAtom (copy)
    local v37 = p32 == nil or p32

    p31:_updateWaterMovementUi(false, false)
    waterMovementTouchVerticalDirectionAtom(0)
    p31:_restoreMobileJumpButton()

    local v38 = p31._characterController.humanoid()

    if v38 and p31._autoRotateBeforeWater ~= nil then
        v38.AutoRotate = p31._autoRotateBeforeWater
    end

    p31._autoRotateBeforeWater = nil

    if v37 then
        if p31._humanoidBeforeWater ~= nil then
            if p31._runningStateEnabledBeforeWater ~= nil then
                p31._humanoidBeforeWater:SetStateEnabled(Enum.HumanoidStateType.Running, p31._runningStateEnabledBeforeWater)
            end

            if p31._landedStateEnabledBeforeWater ~= nil then
                p31._humanoidBeforeWater:SetStateEnabled(Enum.HumanoidStateType.Landed, p31._landedStateEnabledBeforeWater)
            end
        end

        p31._humanoidBeforeWater = nil
        p31._runningStateEnabledBeforeWater = nil
        p31._landedStateEnabledBeforeWater = nil
    end

    p31._currentPitchRadians = 0
    p31._lastRenderTimestamp = 0
    p31:_cleanupAlignmentInstances()
end

function self._cleanupAlignmentInstances(p33) -- line: 332
    local _antiGravityForce = p33._antiGravityForce

    if _antiGravityForce ~= nil then
        _antiGravityForce:Destroy()
    end

    local _alignOrientation = p33._alignOrientation

    if _alignOrientation ~= nil then
        _alignOrientation:Destroy()
    end

    local _alignmentAttachment = p33._alignmentAttachment

    if _alignmentAttachment ~= nil then
        _alignmentAttachment:Destroy()
    end

    p33._antiGravityForce = nil
    p33._alignOrientation = nil
    p33._alignmentAttachment = nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/water-movement-controller@WaterMovementController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    WaterMovementController = self
}
