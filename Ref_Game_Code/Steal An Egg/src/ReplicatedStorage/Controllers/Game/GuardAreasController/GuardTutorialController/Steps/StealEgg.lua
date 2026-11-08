-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    StepId = "StealEgg"
}

function t1.IsSatisfied(p1) -- line: 25
    return p1:HasStolenFirstEgg() and not p1:IsLocalPlayerInGameplay()
end

function t1.Bind(p2, p3) -- line: 29
    -- upvalues: RunService (copy), t1 (copy)
    local n1 = 0
    local v2 = false

    local function refresh() -- line: 33
        -- upvalues: p2 (copy), p3 (copy), v2 (ref), t1 (copy)
        if not v2 and t1.IsSatisfied(p2) then
            v2 = true
            p3()
        end
    end

    local connection = p2.Changed:Connect(refresh)
    local connection2 = RunService.Heartbeat:Connect(function(p4) -- line: 43
        -- upvalues: p2 (copy), p3 (copy), n1 (ref), v2 (ref), t1 (copy)
        n1 += p4

        if not (n1 < 0.1) then
            n1 = 0

            if not v2 then
                if not t1.IsSatisfied(p2) then
                    return
                end

                v2 = true
                p3()
            end
        end
    end)

    task.defer(refresh)

    return function() -- line: 54
        -- upvalues: connection (copy), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()
    end
end

function t1.Present(p5, p6) -- line: 60
    -- upvalues: RunService (copy), v1 (copy), t1 (copy)
    local function refreshPresentation() -- line: 64
        -- upvalues: p5 (copy), p6 (copy), v1 (copy), t1 (copy)
        if t1.IsSatisfied(p6) then
            p5:DropEverything()
        elseif p6:IsCarryingAreaEgg() or p6:HasStolenFirstEgg() then
            p5:DropAnnounce()
            p5:RetargetBeam(p6:GetGameplayExitTarget())
        else
            local ClosestAreaEggTarget = p6:GetClosestAreaEggTarget()

            if ClosestAreaEggTarget ~= nil then
                p5:AnnounceTyped("Steal an Egg!", v1)
                p5:RetargetBeam(ClosestAreaEggTarget)
            else
                p5:DropBeam()
                p5:AnnounceTyped("Steal an Egg!", v1)
            end
        end
    end

    local function refreshMovingExitTarget() -- line: 87
        -- upvalues: p5 (copy), p6 (copy), t1 (copy)
        if t1.IsSatisfied(p6) then
            p5:DropEverything()
        elseif p6:IsCarryingAreaEgg() or p6:HasStolenFirstEgg() then
            p5:DropAnnounce()
            p5:RetargetBeam(p6:GetGameplayExitTarget())
        end
    end

    local connection = p6.Changed:Connect(refreshPresentation)
    local n2 = 0
    local connection2 = RunService.Heartbeat:Connect(function(p7) -- line: 103
        -- upvalues: refreshMovingExitTarget (copy), n2 (ref)
        n2 += p7

        if not (n2 < 0.1) then
            n2 = 0
            refreshMovingExitTarget()
        end
    end)

    refreshPresentation()

    return function() -- line: 114
        -- upvalues: p5 (copy), connection (copy), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()
        p5:DropEverything()
    end
end

return t1
