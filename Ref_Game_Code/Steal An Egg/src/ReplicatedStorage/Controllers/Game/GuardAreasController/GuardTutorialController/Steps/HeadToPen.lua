-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    StepId = "HeadToPen"
}

function t1.IsSatisfied(p1) -- line: 25
    return p1:HasReturnedToPen()
end

function t1.Bind(p2, p3) -- line: 27
    -- upvalues: RunService (copy), t1 (copy)
    local n1 = 0
    local v2 = false

    local function refresh() -- line: 31
        -- upvalues: p2 (copy), p3 (copy), v2 (ref), t1 (copy)
        if not v2 and t1.IsSatisfied(p2) then
            v2 = true
            p3()
        end
    end

    local connection = p2.Changed:Connect(refresh)
    local connection2 = RunService.Heartbeat:Connect(function(p4) -- line: 41
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

    return function() -- line: 52
        -- upvalues: connection (copy), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()
    end
end

function t1.Present(p5, p6) -- line: 58
    -- upvalues: v1 (copy), t1 (copy)
    local function refreshPresentation() -- line: 62
        -- upvalues: p5 (copy), p6 (copy), v1 (copy), t1 (copy)
        if t1.IsSatisfied(p6) then
            p5:DropEverything()
        else
            local PlotSpawnTarget = p6:GetPlotSpawnTarget()

            p5:AnnounceTyped("Go to your Pen!", v1)

            if PlotSpawnTarget ~= nil then
                p5:RetargetBeam(PlotSpawnTarget)
            else
                p5:DropBeam()
            end
        end
    end

    local connection = p6.Changed:Connect(refreshPresentation)

    refreshPresentation()

    return function() -- line: 80
        -- upvalues: p5 (copy), connection (copy)
        connection:Disconnect()
        p5:DropEverything()
    end
end

return t1
