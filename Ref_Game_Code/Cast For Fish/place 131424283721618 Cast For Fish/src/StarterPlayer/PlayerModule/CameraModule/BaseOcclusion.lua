-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1
setmetatable(t1, {
    __call = function(_, ...) -- __call | line: 11
        -- upvalues: t1 (copy)
        return t1.new(...)
    end
})

function t1.new() -- line: 16
    -- upvalues: t1 (copy)
    return (setmetatable({}, t1))
end

function t1.CharacterAdded(_, _, _) -- line: 23
end

function t1.CharacterRemoving(_, _, _) -- line: 27
end

function t1.OnCameraSubjectChanged(_, _) -- line: 29
end

function t1.GetOcclusionMode(_) -- line: 33
    warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")

    return nil
end

function t1.Enable(_, _) -- line: 39
    warn("BaseOcclusion Enable must be overridden by derived classes")
end

function t1.Update(_, _, p15, p16) -- line: 43
    warn("BaseOcclusion Update must be overridden by derived classes")

    return p15, p16
end

return t1
