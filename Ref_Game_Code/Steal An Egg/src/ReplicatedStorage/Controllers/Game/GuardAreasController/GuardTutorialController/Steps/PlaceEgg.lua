-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Client.GuardTutorialPresentation)
require(script.Parent.Types.Interface)

local StepUtils = require(script.Parent.Parent.StepUtils)
local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    StepId = "PlaceEgg"
}

function t1.IsSatisfied(p1) -- line: 24
    return p1:HasPlacedEgg()
end

function t1.Bind(p2, p3) -- line: 26
    -- upvalues: StepUtils (copy), t1 (copy)
    return StepUtils.BindOnAdapterChanged(p2, t1.IsSatisfied, p3)
end

function t1.Present(p4, p5) -- line: 30
    -- upvalues: v1 (copy), t1 (copy)
    local function refreshPresentation() -- line: 34
        -- upvalues: p4 (copy), p5 (copy), v1 (copy), t1 (copy)
        if t1.IsSatisfied(p5) then
            p4:DropEverything()
        else
            p4:AnnounceTyped("Place your Egg!", v1)

            local EggPlacementBillboardCFrame = p5:GetEggPlacementBillboardCFrame()

            if EggPlacementBillboardCFrame ~= nil then
                p4:PinWorldClickHint(EggPlacementBillboardCFrame)
            end
        end
    end

    local connection = p5.Changed:Connect(refreshPresentation)

    if t1.IsSatisfied(p5) then
        p4:DropEverything()
    else
        p4:AnnounceTyped("Place your Egg!", v1)

        local EggPlacementBillboardCFrame = p5:GetEggPlacementBillboardCFrame()

        if EggPlacementBillboardCFrame ~= nil then
            p4:PinWorldClickHint(EggPlacementBillboardCFrame)
        end
    end

    return function() -- line: 50
        -- upvalues: p4 (copy), connection (copy)
        connection:Disconnect()
        p4:DropEverything()
    end
end

return t1
