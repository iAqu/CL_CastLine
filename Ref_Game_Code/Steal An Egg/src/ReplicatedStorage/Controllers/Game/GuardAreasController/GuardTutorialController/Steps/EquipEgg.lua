-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local StepUtils = require(script.Parent.Parent.StepUtils)
local t1 = {
    StepId = "EquipEgg"
}

function t1.IsSatisfied(p1) -- line: 21
    return p1:HasEquippedEgg()
end

function t1.Bind(p2, p3) -- line: 23
    -- upvalues: StepUtils (copy), t1 (copy)
    return StepUtils.BindOnAdapterChanged(p2, t1.IsSatisfied, p3)
end

function t1.Present(p4, p5) -- line: 27
    -- upvalues: t1 (copy)
    local v1 = false

    local function refreshPresentation() -- line: 32
        -- upvalues: p4 (copy), p5 (copy), v1 (ref), t1 (copy)
        if t1.IsSatisfied(p5) then
            p4:DropEverything()
        else
            if not v1 then
                v1 = true

                if p5:ForceBestEggIntoHotbar() == nil then
                    v1 = false
                end
            end

            local EggHotbarTarget = p5:GetEggHotbarTarget()

            if EggHotbarTarget ~= nil then
                p4:RingButton(EggHotbarTarget)
            else
                p4:DropRing()
            end
        end
    end

    local connection = p5.Changed:Connect(refreshPresentation)

    refreshPresentation()

    return function() -- line: 55
        -- upvalues: p4 (copy), connection (copy)
        connection:Disconnect()
        p4:DropEverything()
    end
end

return t1
