-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local v1 = Vector3.new()
local t1 = {}

t1.__index = t1

function t1.new() -- line: 33
    -- upvalues: ConnectionUtil (copy), v1 (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.enabled = false
    self.moveVector = v1
    self.moveVectorIsCameraRelative = true
    self.isJumping = false
    self._connectionUtil = ConnectionUtil.new()

    return self
end

function t1:GetMoveVector() -- line: 45
    return self.moveVector
end

function t1:IsMoveVectorCameraRelative() -- line: 49
    return self.moveVectorIsCameraRelative
end

function t1:GetIsJumping() -- line: 53
    return self.isJumping
end

function t1.Enable(_, _) -- line: 59
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")

    return false
end

return t1
