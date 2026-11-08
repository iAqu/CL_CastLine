-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local t1 = {}
local t2 = {}

for v1, v2 in Mutations.All() do
    t2[v2.Label] = v1
    table.insert(t1, v2.Label)
end

table.sort(t1)

return function(p1) -- line: 13
    -- upvalues: t1 (copy), t2 (copy)
    local v3 = p1.Cmdr.Util.MakeEnumType("Mutation", t1)
    local t3 = {
        Validate = v3.Validate,
        Autocomplete = v3.Autocomplete,
        Parse = function(p2) -- Parse | line: 18
            -- upvalues: v3 (copy), t2 (copy)
            return t2[v3.Parse(p2)]
        end
    }

    p1:RegisterType("mutation", t3)
    p1:RegisterType("mutations", p1.Cmdr.Util.MakeListableType(t3))
end
