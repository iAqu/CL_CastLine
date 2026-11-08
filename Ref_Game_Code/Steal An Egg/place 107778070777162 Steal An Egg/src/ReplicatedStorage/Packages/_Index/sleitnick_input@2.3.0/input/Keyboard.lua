-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Trove = require(script.Parent.Parent.Trove)
local Signal = require(script.Parent.Parent.Signal)
local UserInputService = game:GetService("UserInputService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 55
    -- upvalues: Trove (copy), Signal (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self.KeyDown = self._trove:Construct(Signal)
    self.KeyUp = self._trove:Construct(Signal)
    self:_setup()

    return self
end

function t1.IsKeyDown(_, p2) -- line: 72
    -- upvalues: UserInputService (copy)
    return UserInputService:IsKeyDown(p2)
end

function t1:AreKeysDown(p4, p5) -- line: 84
    return self:IsKeyDown(p4) and self:IsKeyDown(p5)
end

function t1:AreEitherKeysDown(p7, p8) -- line: 99
    return self:IsKeyDown(p7) or self:IsKeyDown(p8)
end

function t1:_setup() -- line: 103
    -- upvalues: UserInputService (copy)
    self._trove:Connect(UserInputService.InputBegan, function(p10, p11) -- line: 104
        -- upvalues: self (copy)
        if not p11 and p10.UserInputType == Enum.UserInputType.Keyboard then
            self.KeyDown:Fire(p10.KeyCode)
        end
    end)
    self._trove:Connect(UserInputService.InputEnded, function(p12, p13) -- line: 113
        -- upvalues: self (copy)
        if not p13 and p12.UserInputType == Enum.UserInputType.Keyboard then
            self.KeyUp:Fire(p12.KeyCode)
        end
    end)
end

function t1:Destroy() -- line: 126
    self._trove:Destroy()
end

return t1
