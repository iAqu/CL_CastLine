-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    StepId = "TreadmillIntro"
}

function t1.IsSatisfied(p1) -- line: 24
    return p1:HasFinishedTreadmillIntro()
end

function t1.Bind(p2, p3) -- line: 28
    local v2 = false

    task.delay(7, function() -- line: 30
        -- upvalues: p2 (copy), p3 (copy), v2 (ref)
        if not v2 then
            p2:MarkTreadmillIntroFinished()
            p3()
        end
    end)

    return function() -- line: 38
        -- upvalues: v2 (ref)
        v2 = true
    end
end

function t1.Present(p4, _) -- line: 41
    -- upvalues: v1 (copy)
    p4:AnnounceTyped("Use your treadmill to become faster!", v1)

    return function() -- line: 47
        -- upvalues: p4 (copy)
        p4:DropEverything()
    end
end

return t1
