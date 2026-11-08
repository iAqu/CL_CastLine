-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    {
        name = "Massless",
        value = true
    },
    {
        name = "CanTouch",
        value = false
    },
    {
        name = "CanCollide",
        value = false
    }
}
local t2 = {}

local function eachPart(p1, p2) -- line: 17
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            p2(descendant)
        end
    end
end

function t2.SetAnchored(p3, p4) -- line: 25
    -- upvalues: t (copy), eachPart (copy)
    t.strict(t.instanceIsA("Model"))(p3)
    t.strict(t.boolean)(p4)
    eachPart(p3, function(p5) -- line: 29
        -- upvalues: p4 (copy)
        p5.Anchored = p4
    end)
end

function t2.DisableAllPhysics(p6, p7) -- line: 34
    -- upvalues: t (copy), t1 (copy), eachPart (copy)
    t.strict(t.Instance)(p6)
    t.strict(t.optional(t.boolean))(p7)

    local v1 = p7 == true

    eachPart(p6, function(p8) -- line: 39
        -- upvalues: v1 (copy), t1 (copy)
        for _, v2 in t1 do
            p8[v2.name] = v2.value
        end

        p8.CanQuery = v1
    end)
end

function t2.SetCollisionGroup(p9, p10) -- line: 47
    -- upvalues: t (copy), eachPart (copy)
    t.strict(t.instanceIsA("Model"))(p9)
    t.strict(t.string)(p10)
    eachPart(p9, function(p11) -- line: 51
        -- upvalues: p10 (copy)
        p11.CollisionGroup = p10
    end)
end

return table.freeze(t2)
