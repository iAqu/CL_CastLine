-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

script.Parent.Parent:WaitForChild("CommonUtils")

local v1 = Vector3.new()
local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local self = setmetatable({}, BaseCharacterController)

self.__index = self

function self.new(p1) -- line: 22
    -- upvalues: BaseCharacterController (copy), self (copy)
    local v4 = setmetatable(BaseCharacterController.new(), self)

    v4.CONTROL_ACTION_PRIORITY = p1
    v4.forwardValue = 0
    v4.backwardValue = 0
    v4.leftValue = 0
    v4.rightValue = 0
    v4.jumpEnabled = true

    return v4
end

function self.Enable(p2, p3) -- line: 37
    -- upvalues: v1 (copy)
    if p3 == p2.enabled then
        return true
    end

    p2.forwardValue = 0
    p2.backwardValue = 0
    p2.leftValue = 0
    p2.rightValue = 0
    p2.moveVector = v1
    p2.jumpRequested = false
    p2:UpdateJump()

    if p3 then
        p2:BindContextActions()
        p2:ConnectFocusEventListeners()
    else
        p2._connectionUtil:disconnectAll()
    end

    p2.enabled = p3

    return true
end

function self.UpdateMovement(p4, p5) -- line: 64
    -- upvalues: v1 (copy)
    if p5 == Enum.UserInputState.Cancel then
        p4.moveVector = v1
    else
        p4.moveVector = Vector3.new(p4.leftValue + p4.rightValue, 0, p4.forwardValue + p4.backwardValue)
    end
end

function self.UpdateJump(p6) -- line: 72
    p6.isJumping = p6.jumpRequested
end

function self.BindContextActions(p7) -- line: 76
    -- upvalues: ContextActionService (copy)
    local function v7(_, p9, _) -- line: 82
        -- upvalues: p7 (copy)
        p7.forwardValue = p9 == Enum.UserInputState.Begin and -1 or 0
        p7:UpdateMovement(p9)

        return Enum.ContextActionResult.Pass
    end

    local function v8(_, p12, _) -- line: 88
        -- upvalues: p7 (copy)
        p7.backwardValue = p12 == Enum.UserInputState.Begin and 1 or 0
        p7:UpdateMovement(p12)

        return Enum.ContextActionResult.Pass
    end

    local function v9(_, p15, _) -- line: 94
        -- upvalues: p7 (copy)
        p7.leftValue = p15 == Enum.UserInputState.Begin and -1 or 0
        p7:UpdateMovement(p15)

        return Enum.ContextActionResult.Pass
    end

    local function v10(_, p18, _) -- line: 100
        -- upvalues: p7 (copy)
        p7.rightValue = p18 == Enum.UserInputState.Begin and 1 or 0
        p7:UpdateMovement(p18)

        return Enum.ContextActionResult.Pass
    end

    local function v11(_, p21, _) -- line: 106
        -- upvalues: p7 (copy)
        p7.jumpRequested = p7.jumpEnabled and p21 == Enum.UserInputState.Begin
        p7:UpdateJump()

        return Enum.ContextActionResult.Pass
    end

    ContextActionService:BindActionAtPriority("moveForwardAction", v7, false, p7.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward)
    ContextActionService:BindActionAtPriority("moveBackwardAction", v8, false, p7.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward)
    ContextActionService:BindActionAtPriority("moveLeftAction", v9, false, p7.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft)
    ContextActionService:BindActionAtPriority("moveRightAction", v10, false, p7.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight)
    ContextActionService:BindActionAtPriority("jumpAction", v11, false, p7.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump)
    p7._connectionUtil:trackBoundFunction("moveForwardAction", function() -- line: 125
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("moveForwardAction")
    end)
    p7._connectionUtil:trackBoundFunction("moveBackwardAction", function() -- line: 126
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("moveBackwardAction")
    end)
    p7._connectionUtil:trackBoundFunction("moveLeftAction", function() -- line: 127
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("moveLeftAction")
    end)
    p7._connectionUtil:trackBoundFunction("moveRightAction", function() -- line: 128
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("moveRightAction")
    end)
    p7._connectionUtil:trackBoundFunction("jumpAction", function() -- line: 129
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("jumpAction")
    end)
end

function self.ConnectFocusEventListeners(p23) -- line: 132
    -- upvalues: UserInputService (copy), v1 (copy)
    local function onFocusReleased() -- line: 133
        -- upvalues: p23 (copy), v1 (copy)
        p23.moveVector = v1
        p23.forwardValue = 0
        p23.backwardValue = 0
        p23.leftValue = 0
        p23.rightValue = 0
        p23.jumpRequested = false
        p23:UpdateJump()
    end

    local function onTextFocusGained(_) -- line: 143
        -- upvalues: p23 (copy)
        p23.jumpRequested = false
        p23:UpdateJump()
    end

    p23._connectionUtil:trackConnection("textBoxFocusReleased", UserInputService.TextBoxFocusReleased:Connect(onFocusReleased))
    p23._connectionUtil:trackConnection("textBoxFocused", UserInputService.TextBoxFocused:Connect(onTextFocusGained))
    p23._connectionUtil:trackConnection("windowFocusReleased", UserInputService.WindowFocused:Connect(onFocusReleased))
end

return self
