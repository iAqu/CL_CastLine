-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PartBounds = require(ReplicatedStorage.Shared.Utils.PartBounds)

local function isBoxSubject(p1) -- line: 10
    if typeof(p1) == "Instance" then
        return p1:IsA("Model") or p1:IsA("Tool")
    end

    return false
end

local function opaqueParts(p2) -- line: 14
    local t1 = {}

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            table.insert(t1, descendant)
        end
    end

    return t1
end

return function(p3) -- line: 25
    -- upvalues: PartBounds (copy), opaqueParts (copy)
    assert(typeof(p3) == "Instance" and (p3:IsA("Model") or p3:IsA("Tool")), "VisibleBounds needs a Model or a Tool")

    local v2 = opaqueParts(p3)

    if #v2 == 0 then
        return p3:GetPivot(), (Vector3.new(0, 0, 0))
    end

    return PartBounds(v2)
end
