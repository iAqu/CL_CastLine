-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Areas = require(ReplicatedStorage.Data.Areas)
local GuardChasePolicy = require(script.Parent.GuardChasePolicy)
local GuardEscape = require(ReplicatedStorage.Shared.Utils.GuardEscape)
local GuardEscapePrediction = require(script.Parent.GuardEscapePrediction)
local Guards = require(ReplicatedStorage.Data.Guards)
local t = require(ReplicatedStorage.Packages.t)

require(script.Parent.Types.Interface)

local t1 = {
    SIGN_SPEEDS_ATTRIBUTE = "GuardEscapeSpeeds"
}

function t1.BuildPathParameters(p1, p2, p3, p4) -- line: 21
    -- upvalues: Areas (copy), GuardChasePolicy (copy), GuardEscapePrediction (copy), Guards (copy), t (copy)
    t.strict(t.instanceIsA("Model"))(p1)
    t.strict(t.Vector3)(p2)
    t.strict(t.instanceIsA("BasePart"))(p3)

    local v1 = Areas.Directory[p1.Name]

    p4 = p4 or Guards.Directory[v1.GuardId]

    local Bounds = p1:FindFirstChild("Bounds")
    local ClosestExitPoint = p1:FindFirstChild("ClosestExitPoint")

    assert(Bounds ~= nil, (("%*.Bounds is required"):format((p1:GetFullName()))))
    assert(ClosestExitPoint ~= nil, (("%*.ClosestExitPoint is required"):format((p1:GetFullName()))))
    assert(Bounds:IsA("BasePart"), (("%*.Bounds must be a BasePart"):format((p1:GetFullName()))))
    assert(ClosestExitPoint:IsA("BasePart"), (("%*.ClosestExitPoint must be a BasePart"):format((p1:GetFullName()))))

    local v9 = -p3.CFrame.LookVector

    return {
        BaseGuardWalkSpeed = p4.WalkSpeed,
        ExitDirection = v9,
        ExitDistance = GuardEscapePrediction.ResolveExitDistance(Bounds.CFrame, Bounds.Size, ClosestExitPoint.Position, v9),
        FlatRadius = p4.FlatRadius,
        GuardStartPosition = p2,
        HitDistance = GuardChasePolicy.ResolveHitDistance(p4.HitDistance),
        PlayerStartPosition = ClosestExitPoint.Position
    }
end

function t1.ResolveSpeedPower(p5, p6, p7) -- line: 69
    -- upvalues: GuardEscape (copy), t1 (copy)
    return GuardEscape.RequiredSpeedPower(t1.BuildPathParameters(p5, p6, p7))
end

function t1.PublishSign(p8, p9, p10, p11) -- line: 84
    -- upvalues: GuardEscape (copy), GuardEscapePrediction (copy), t1 (copy)
    local v10 = p11

    if p11 == nil then
        local Guard = p8:FindFirstChild("Guard")
        local HumanoidRootPart = if Guard == nil then nil else Guard:FindFirstChild("HumanoidRootPart")

        assert(HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart"), (("%*.Guard requires a root"):format((p8:GetFullName()))))
        v10 = HumanoidRootPart.Position
    end

    local v13 = t1.BuildPathParameters(p8, v10, p9, p10)

    p8:SetAttribute(t1.SIGN_SPEEDS_ATTRIBUTE, Vector2.new(GuardEscape.RequiredSpeedPower(v13), GuardEscapePrediction.ResolvePlayerWalkSpeedRequirement(v13, 1)))
end

return table.freeze(t1)
