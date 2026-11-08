-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Signal = require(script.Parent.Parent.Signal)
local Trove = require(script.Parent.Parent.Trove)
local UserInputService = game:GetService("UserInputService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 81
    -- upvalues: Signal (copy), Trove (copy), UserInputService (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self.LeftDown = self._trove:Construct(Signal)
    self.LeftUp = self._trove:Construct(Signal)
    self.RightDown = self._trove:Construct(Signal)
    self.RightUp = self._trove:Construct(Signal)
    self.MiddleDown = self._trove:Construct(Signal)
    self.MiddleUp = self._trove:Construct(Signal)
    self.Scrolled = self._trove:Construct(Signal)
    self.Moved = self._trove:Construct(Signal)
    self._trove:Connect(UserInputService.InputBegan, function(p1, p2) -- line: 95
        -- upvalues: self (copy)
        if not p2 then
            if p1.UserInputType == Enum.UserInputType.MouseButton1 then
                self.LeftDown:Fire()
            elseif p1.UserInputType == Enum.UserInputType.MouseButton2 then
                self.RightDown:Fire()
            elseif p1.UserInputType == Enum.UserInputType.MouseButton3 then
                self.MiddleDown:Fire()
            end
        end
    end)
    self._trove:Connect(UserInputService.InputEnded, function(p3, p4) -- line: 108
        -- upvalues: self (copy)
        if not p4 then
            if p3.UserInputType == Enum.UserInputType.MouseButton1 then
                self.LeftUp:Fire()
            elseif p3.UserInputType == Enum.UserInputType.MouseButton2 then
                self.RightUp:Fire()
            elseif p3.UserInputType == Enum.UserInputType.MouseButton3 then
                self.MiddleUp:Fire()
            end
        end
    end)
    self._trove:Connect(UserInputService.InputChanged, function(p5, p6) -- line: 121
        -- upvalues: self (copy)
        if not p6 then
            if p5.UserInputType == Enum.UserInputType.MouseMovement then
                local Position = p5.Position

                self.Moved:Fire(Vector2.new(Position.X, Position.Y))
            elseif p5.UserInputType == Enum.UserInputType.MouseWheel then
                self.Scrolled:Fire(p5.Position.Z)
            end
        end
    end)

    return self
end

function t1.IsLeftDown(_) -- line: 139
    -- upvalues: UserInputService (copy)
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end

function t1.IsRightDown(_) -- line: 146
    -- upvalues: UserInputService (copy)
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end

function t1.IsMiddleDown(_) -- line: 153
    -- upvalues: UserInputService (copy)
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
end

function t1.GetPosition(_) -- line: 160
    -- upvalues: UserInputService (copy)
    return UserInputService:GetMouseLocation()
end

function t1.GetDelta(_) -- line: 174
    -- upvalues: UserInputService (copy)
    return UserInputService:GetMouseDelta()
end

function t1.GetRay(_, p13) -- line: 182
    -- upvalues: UserInputService (copy)
    p13 = p13 or UserInputService:GetMouseLocation()

    return (workspace.CurrentCamera:ViewportPointToRay(p13.X, p13.Y))
end

function t1:Raycast(p15, p16, p17) -- line: 209
    local Ray = self:GetRay(p17)

    return (workspace:Raycast(Ray.Origin, Ray.Direction * (p16 or 1000), p15))
end

function t1:Project(p19, p20) -- line: 241
    local Ray = self:GetRay(p20)

    return Ray.Origin + Ray.Direction.Unit * (p19 or 1000)
end

function t1.Lock(_) -- line: 255
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
end

function t1.LockCenter(_) -- line: 266
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end

function t1.Unlock(_) -- line: 273
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function t1:Destroy() -- line: 280
    self._trove:Destroy()
end

return t1
