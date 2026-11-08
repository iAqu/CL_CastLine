-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Artifacts = t.strictInterface({
        Collar = t.boolean,
        Bone = t.boolean,
        Toy = t.boolean,
        Photo = t.boolean
    })
}

t1.State = t.strictInterface({
    Stage = t.intersection(t.integer, t.numberConstrained(0, 4)),
    Artifacts = t1.Artifacts,
    Ticket = t.boolean
})

function t1.BlankArtifacts() -- line: 39
    return {
        Collar = false,
        Bone = false,
        Toy = false,
        Photo = false
    }
end

function t1.Blank() -- line: 43
    -- upvalues: t1 (copy)
    return {
        Stage = 0,
        Ticket = false,
        Artifacts = t1.BlankArtifacts()
    }
end

function t1.Copy(p1) -- line: 51
    return {
        Stage = p1.Stage,
        Artifacts = table.clone(p1.Artifacts),
        Ticket = p1.Ticket
    }
end

function t1.CountFound(p2) -- line: 59
    local n1 = 0

    for _, v1 in p2.Artifacts do
        if v1 then
            n1 += 1
        end
    end

    return n1
end

return table.freeze(t1)
