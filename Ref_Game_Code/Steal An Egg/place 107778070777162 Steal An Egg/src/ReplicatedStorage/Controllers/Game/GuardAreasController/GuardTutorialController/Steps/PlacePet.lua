-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local StepUtils = require(script.Parent.Parent.StepUtils)
local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    StepId = "PlacePet"
}

function t1.IsSatisfied(p1) -- line: 24
    return p1:HasPlacedPet()
end

function t1.Bind(p2, p3) -- line: 26
    -- upvalues: StepUtils (copy), t1 (copy)
    return StepUtils.BindOnAdapterChanged(p2, t1.IsSatisfied, p3)
end

function t1.Present(p4, p5) -- line: 30
    -- upvalues: v1 (copy), t1 (copy)
    local function refreshPresentation() -- line: 34
        -- upvalues: p4 (copy), p5 (copy), v1 (copy), t1 (copy)
        if t1.IsSatisfied(p5) or not p5:HasPetInInventory() then
            p4:DropEverything()
        else
            p4:AnnounceTyped("Place your Pet!", v1)
            p4:SetScreenClickHint(p5:HasPetToolEquipped())
        end
    end

    local connection = p5.Changed:Connect(refreshPresentation)

    refreshPresentation()

    return function() -- line: 47
        -- upvalues: p4 (copy), connection (copy)
        connection:Disconnect()
        p4:DropEverything()
    end
end

return t1
