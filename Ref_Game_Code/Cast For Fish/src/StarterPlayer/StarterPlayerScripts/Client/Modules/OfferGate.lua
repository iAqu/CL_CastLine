-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1
t1.QUIET_SECONDS = 180

function t1.new(p1) -- line: 6
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Started = os.clock()
    self.QuietSeconds = p1 or t1.QUIET_SECONDS
    self.TutorialActive = nil

    return self
end

function t1:Elapsed() -- line: 14
    return os.clock() - self.Started
end

function t1:Allowed() -- line: 18
    if self:Elapsed() < self.QuietSeconds then
        return false
    end

    return not (self.TutorialActive and self.TutorialActive())
end

t1.Shared = t1.new()

return t1
