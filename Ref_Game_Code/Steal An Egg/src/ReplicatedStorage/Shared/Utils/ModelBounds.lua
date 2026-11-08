-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PartBounds = require(ReplicatedStorage.Shared.Utils.PartBounds)

local function isBoxSubject(p1) -- line: 13
    if typeof(p1) == "Instance" then
        return p1:IsA("Model") or p1:IsA("Tool")
    end

    return false
end

local function opaqueParts(p2) -- line: 17
    local t1 = {}

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            table.insert(t1, descendant)
        end
    end

    return t1
end

return function(p3) -- line: 29
    -- upvalues: PartBounds (copy), opaqueParts (copy)
    assert(typeof(p3) == "Instance" and (p3:IsA("Model") or p3:IsA("Tool")), "ModelBounds needs a Model or a Tool")

    local v2 = p3:FindFirstChild("CustomBoundingBox", true)

    if v2 ~= nil and v2:IsA("BasePart") then
        return v2.CFrame, v2.Size
    end

    local Pivot = p3:GetPivot()
    local v3 = opaqueParts(p3)

    if #v3 == 0 then
        return Pivot, (Vector3.new(0, 0, 0))
    end

    return PartBounds(v3, Pivot.Rotation)
end
