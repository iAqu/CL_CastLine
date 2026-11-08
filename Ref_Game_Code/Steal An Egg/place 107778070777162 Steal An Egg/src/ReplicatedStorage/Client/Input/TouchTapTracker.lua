-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}

t1.__index = t1
t1.__class = "TouchTapTracker"

local v1 = t.strict(t.optional(t.table))
local v2 = t.strict(t.optional(t.number))
local v3 = Log.new()

local function requireTouch(p1) -- line: 36
    assert(p1.UserInputType == Enum.UserInputType.Touch)
end

local function travelled(p2, p3) -- line: 40
    local origin = p2.origin

    return if origin then (p3.Position - origin).Magnitude else nil
end

function t1.new(p4) -- line: 45
    -- upvalues: t1 (copy), v1 (copy), v2 (copy), v3 (copy)
    v1(p4)

    local v5

    if p4 then
        v2(p4.MaxMovement)
        v2(p4.MaxDuration)
        v5 = p4
    else
        v5 = {}
    end

    local self = setmetatable({}, t1)

    self.slop = v5.MaxMovement or 16
    self.holdLimit = v5.MaxDuration or 0.35
    self.claimed = nil
    self.pressedAt = 0
    self.origin = nil
    self.aborted = false
    v3:AtDebug():Log("tap tracker ready")

    return self
end

function t1:Reset() -- line: 66
    self.claimed = nil
    self.pressedAt = 0
    self.origin = nil
    self.aborted = false
end

function t1:IsTrackingInput(p7) -- line: 73
    return self.claimed == p7
end

function t1:IsCancelled() -- line: 77
    return self.aborted
end

function t1:Begin(p10) -- line: 79
    assert(p10.UserInputType == Enum.UserInputType.Touch)
    self.claimed = p10
    self.pressedAt = os.clock()
    self.origin = p10.Position
    self.aborted = false
end

function t1:Update(p12) -- line: 88
    assert(p12.UserInputType == Enum.UserInputType.Touch)

    local Magnitude

    if self.claimed ~= p12 or self.aborted then
        return false
    else
        local origin = self.origin

        if origin then
            Magnitude = (p12.Position - origin).Magnitude
        end
    end

    local v10 = Magnitude == nil or self.slop < Magnitude

    self.aborted = v10

    return not v10
end

function t1:Evaluate(p14, p15) -- line: 104
    assert(p14.UserInputType == Enum.UserInputType.Touch)

    local origin = self.origin
    local Magnitude = if origin then (p14.Position - origin).Magnitude else nil
    local pressedAt = self.pressedAt
    local v12 = not p15 and self.claimed == p14 and not self.aborted and Magnitude ~= nil and pressedAt > 0 and os.clock() - pressedAt <= self.holdLimit and Magnitude <= self.slop

    self:Reset()

    return v12
end

return t1
