-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local SurfaceButtons = require(ReplicatedStorage.Client.UI.SurfaceButtons)
local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    StepId = "ExpandPen"
}

local function shouldPresent(p1) -- line: 31
    return p1:CanAffordFirstBaseExpansion() and not p1:IsLocalPlayerInGameplay()
end

function t1.IsSatisfied(p2) -- line: 39
    return p2:HasFinishedFirstBaseExpansion()
end

function t1.Bind(p3, p4) -- line: 43
    -- upvalues: RunService (copy), t1 (copy)
    local n1 = 0
    local v2 = false

    local function refresh() -- line: 47
        -- upvalues: p3 (copy), p4 (copy), v2 (ref), t1 (copy)
        if not v2 and t1.IsSatisfied(p3) then
            v2 = true
            p4()
        end
    end

    local connection = p3.Changed:Connect(refresh)
    local connection2 = RunService.Heartbeat:Connect(function(p5) -- line: 56
        -- upvalues: p3 (copy), p4 (copy), n1 (ref), v2 (ref), t1 (copy)
        n1 += p5

        if n1 >= 0.1 then
            n1 = 0

            if not v2 then
                if not t1.IsSatisfied(p3) then
                    return
                end

                v2 = true
                p4()
            end
        end
    end)

    task.defer(refresh)

    return function() -- line: 65
        -- upvalues: connection (copy), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()
    end
end

function t1.Present(p6, p7) -- line: 71
    -- upvalues: RunService (copy), SurfaceButtons (copy), v1 (copy), t1 (copy)
    local n2 = 0
    local v4 = false
    local v5 = false
    local PlotUpgradeSignTarget

    local function clear() -- line: 80
        -- upvalues: p6 (copy), v4 (ref), v5 (ref), PlotUpgradeSignTarget (ref)
        if not v4 then
            return
        end

        v4 = false
        v5 = false
        PlotUpgradeSignTarget = nil
        p6:DropEverything()
    end

    local function refresh() -- line: 90
        -- upvalues: p6 (copy), p7 (copy), v4 (ref), v5 (ref), PlotUpgradeSignTarget (ref), SurfaceButtons (copy), v1 (copy), t1 (copy)
        if not t1.IsSatisfied(p7) and p7:CanAffordFirstBaseExpansion() and not p7:IsLocalPlayerInGameplay() then
            local PlotUpgradeSignTarget2 = p7:GetPlotUpgradeSignTarget()

            if PlotUpgradeSignTarget2 ~= nil then
                if v4 and PlotUpgradeSignTarget == PlotUpgradeSignTarget2 then
                    if not v5 then
                        local FirstUpgrade = SurfaceButtons.Find(PlotUpgradeSignTarget2, "FirstUpgrade")

                        if FirstUpgrade ~= nil then
                            p6:MarkTapTarget(FirstUpgrade, true)
                            v5 = true
                        end
                    end
                else
                    v4 = true
                    PlotUpgradeSignTarget = PlotUpgradeSignTarget2
                    p6:AnnounceTyped("Upgrade your Pen!", v1)
                    p6:PointBeamAt(PlotUpgradeSignTarget2.Position + Vector3.new(0, -1, 0))

                    local FirstUpgrade = SurfaceButtons.Find(PlotUpgradeSignTarget2, "FirstUpgrade")

                    if FirstUpgrade ~= nil then
                        p6:MarkTapTarget(FirstUpgrade, true)
                        v5 = true
                    end
                end
            elseif v4 then
                v4 = false
                v5 = false
                PlotUpgradeSignTarget = nil
                p6:DropEverything()
            end
        else
            if not v4 then
                return
            end

            v4 = false
            v5 = false
            PlotUpgradeSignTarget = nil
            p6:DropEverything()
        end
    end

    local connection = p7.Changed:Connect(refresh)
    local connection2 = RunService.Heartbeat:Connect(function(p8) -- line: 124
        -- upvalues: n2 (ref), refresh (copy)
        n2 += p8

        if n2 >= 0.1 then
            n2 = 0
            refresh()
        end
    end)

    refresh()

    return function() -- line: 133
        -- upvalues: p6 (copy), v4 (ref), v5 (ref), PlotUpgradeSignTarget (ref), connection (copy), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()

        if not v4 then
            return
        end

        v4 = false
        v5 = false
        PlotUpgradeSignTarget = nil
        p6:DropEverything()
    end
end

return t1
