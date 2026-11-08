-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local StepUtils = require(script.Parent.Parent.StepUtils)
local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    StepId = "HatchEgg"
}

function t1.IsSatisfied(p1) -- line: 26
    return p1:HasHatchedEgg()
end

function t1.Bind(p2, p3) -- line: 28
    -- upvalues: StepUtils (copy), t1 (copy)
    return StepUtils.BindOnAdapterChanged(p2, t1.IsSatisfied, p3)
end

function t1.Present(p4, p5) -- line: 32
    -- upvalues: RunService (copy), v1 (copy), t1 (copy)
    local function refreshPresentation() -- line: 36
        -- upvalues: p4 (copy), p5 (copy), v1 (copy), t1 (copy)
        if t1.IsSatisfied(p5) then
            p4:DropEverything()
        elseif p5:HasHatchableEgg() then
            p4:AnnounceTyped("Hatch the Egg!", v1)

            local NearestHatchableEggTarget = p5:GetNearestHatchableEggTarget()

            if NearestHatchableEggTarget ~= nil then
                p4:RetargetBeam(NearestHatchableEggTarget)
            else
                p4:DropBeam()
            end
        else
            p4:DropEverything()
        end
    end

    local connection = p5.Changed:Connect(refreshPresentation)
    local n1 = 0
    local connection2 = RunService.Heartbeat:Connect(function(p6) -- line: 58
        -- upvalues: refreshPresentation (copy), n1 (ref)
        n1 += p6

        if not (n1 < 0.25) then
            n1 = 0
            refreshPresentation()
        end
    end)

    refreshPresentation()

    return function() -- line: 69
        -- upvalues: p4 (copy), connection (copy), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()
        p4:DropEverything()
    end
end

return t1
