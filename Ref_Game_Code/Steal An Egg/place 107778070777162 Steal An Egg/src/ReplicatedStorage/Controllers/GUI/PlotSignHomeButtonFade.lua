-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1

local v1 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function t1.new(p1) -- line: 36
    -- upvalues: Trove (copy), t1 (copy)
    local Home = p1:FindFirstChild("Home")

    assert(Home ~= nil, "YourBase.Home must exist")
    assert(Home:IsA("ImageButton"), "YourBase.Home must be an ImageButton")

    local self = setmetatable({}, t1)

    self._activeTween = nil
    self._home = Home
    self._revision = 0
    self._trove = Trove.new()
    self._visible = nil
    self._yourBase = p1

    return self
end

function t1:SetVisible(p3) -- line: 56
    -- upvalues: TweenService (copy), v1 (copy)
    if self._visible == p3 then
        return
    end

    self._visible = p3
    self._revision += 1

    local _revision = self._revision

    self._trove:Clean()

    if p3 then
        self._yourBase.Enabled = true
    end

    local tween = TweenService:Create(self._home, v1, {
        ImageTransparency = p3 and 0 or 1
    })

    self._activeTween = tween
    self._trove:Add(function() -- line: 74
        -- upvalues: self (copy), tween (copy)
        if self._activeTween == tween then
            tween:Cancel()
            self._activeTween = nil
        end
    end)
    self._trove:Add(tween.Completed:Connect(function(p4) -- line: 80
        -- upvalues: self (copy), p3 (copy), _revision (copy), tween (copy)
        if self._revision ~= _revision or self._activeTween ~= tween then
            return
        end

        self._activeTween = nil

        if p4 == Enum.PlaybackState.Completed and not p3 then
            self._yourBase.Enabled = false
        end
    end))
    tween:Play()
end

function t1:Destroy() -- line: 93
    self._revision += 1
    self._trove:Destroy()
end

return t1
