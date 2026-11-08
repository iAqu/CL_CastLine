-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Trove = require(script.Parent.Parent.Trove)
local Signal = require(script.Parent.Parent.Signal)
local UserInputService = game:GetService("UserInputService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 87
    -- upvalues: Trove (copy), Signal (copy), UserInputService (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self._trove = Trove.new()
    self.TouchTap = self._trove:Construct(Signal.Wrap, UserInputService.TouchTap)
    self.TouchTapInWorld = self._trove:Construct(Signal.Wrap, UserInputService.TouchTapInWorld)
    self.TouchMoved = self._trove:Construct(Signal.Wrap, UserInputService.TouchMoved)
    self.TouchLongPress = self._trove:Construct(Signal.Wrap, UserInputService.TouchLongPress)
    self.TouchPan = self._trove:Construct(Signal.Wrap, UserInputService.TouchPan)
    self.TouchPinch = self._trove:Construct(Signal.Wrap, UserInputService.TouchPinch)
    self.TouchRotate = self._trove:Construct(Signal.Wrap, UserInputService.TouchRotate)
    self.TouchSwipe = self._trove:Construct(Signal.Wrap, UserInputService.TouchSwipe)
    self.TouchStarted = self._trove:Construct(Signal.Wrap, UserInputService.TouchStarted)
    self.TouchEnded = self._trove:Construct(Signal.Wrap, UserInputService.TouchEnded)

    return self
end

function t1.IsTouchEnabled(_) -- line: 109
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled
end

function t1:Destroy() -- line: 116
    self._trove:Destroy()
end

return t1
