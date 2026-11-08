-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")

require(script.Types.Interface)

local v1 = Color3.fromRGB(191, 0, 3)
local v2 = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local t1 = {}

t1.__index = t1
t1.__class = "GuardRunBackEffects"

function t1.new() -- line: 45
    -- upvalues: PlayerGui (copy), t1 (copy)
    local self = setmetatable({}, t1)
    local RunBackEffects = PlayerGui:WaitForChild("RunBackEffects")

    assert(RunBackEffects:IsA("ScreenGui"), "PlayerGui.RunBackEffects must be a ScreenGui")

    local Run = RunBackEffects:WaitForChild("Run")

    assert(Run:IsA("GuiObject"), "RunBackEffects.Run must be a GuiObject")

    local Blur = RunBackEffects:WaitForChild("Blur")

    assert(Blur:IsA("ImageLabel"), "RunBackEffects.Blur must be an ImageLabel")
    self._activeSerial = 0
    self._blurOriginalTransparency = Blur.ImageTransparency
    self._blurTween = nil
    self._running = false
    self._runOriginalColor = Run.BackgroundColor3
    self._runTween = nil
    self._widgets = {
        Blur = Blur,
        Run = Run,
        ScreenGui = RunBackEffects
    }
    self:_init()

    return self
end

function t1:_cancelTweens() -- line: 76
    local _blurTween = self._blurTween

    if _blurTween ~= nil then
        _blurTween:Cancel()
        _blurTween:Destroy()
    end

    self._blurTween = nil

    local _runTween = self._runTween

    if _runTween ~= nil then
        _runTween:Cancel()
        _runTween:Destroy()
    end

    self._runTween = nil
end

function t1:_resetVisualState() -- line: 92
    local _widgets = self._widgets

    _widgets.Blur.Visible = true
    _widgets.Blur.ImageTransparency = self._blurOriginalTransparency
    _widgets.Run.BackgroundColor3 = self._runOriginalColor
    _widgets.ScreenGui.Enabled = false
end

function t1:_playCycle(p4, p5) -- line: 100
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    if p4 ~= self._activeSerial then
        return
    end

    local _widgets = self._widgets
    local v5 = if p5 then 1 else self._blurOriginalTransparency
    local v4 = if p5 then v1 else self._runOriginalColor

    self:_cancelTweens()

    local tween = TweenService:Create(_widgets.Blur, v2, {
        ImageTransparency = v5
    })
    local tween2 = TweenService:Create(_widgets.Run, v2, {
        BackgroundColor3 = v4
    })

    tween.Completed:Once(function() -- line: 120
        -- upvalues: tween (copy)
        tween:Destroy()
    end)
    tween2.Completed:Once(function() -- line: 123
        -- upvalues: tween2 (copy)
        tween2:Destroy()
    end)
    self._blurTween = tween
    self._runTween = tween2
    tween:Play()
    tween2:Play()
    task.spawn(function() -- line: 131
        -- upvalues: self (copy), p4 (copy), p5 (copy), tween (copy)
        tween.Completed:Wait()

        if p4 == self._activeSerial then
            self:_playCycle(p4, not p5)
        end
    end)
end

function t1:Start(p7) -- line: 146
    self._activeSerial += 1
    self._running = true

    local _widgets = self._widgets

    _widgets.ScreenGui.Enabled = true
    _widgets.Blur.Visible = p7 ~= true
    _widgets.Blur.ImageTransparency = self._blurOriginalTransparency
    _widgets.Run.BackgroundColor3 = self._runOriginalColor
    self:_playCycle(self._activeSerial, true)
end

function t1:Stop() -- line: 157
    self._activeSerial += 1
    self._running = false
    self:_cancelTweens()
    self:_resetVisualState()
end

function t1:_init() -- line: 169
    local ScreenGui = self._widgets.ScreenGui

    ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 171
        -- upvalues: self (copy), ScreenGui (copy)
        if ScreenGui.Enabled and not self._running then
            ScreenGui.Enabled = false
        end
    end)
    self:Stop()
end

return t1
