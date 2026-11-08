-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminItemCatalog = require(ReplicatedStorage.Shared.AdminItemCatalog)

return function(p1) -- line: 5
    -- upvalues: AdminItemCatalog (copy)
    local v1 = p1.Cmdr.Util.MakeEnumType("Item", AdminItemCatalog.Choices)

    p1:RegisterType("item", {
        Validate = v1.Validate,
        Autocomplete = v1.Autocomplete,
        Parse = function(p2) -- Parse | line: 11
            -- upvalues: v1 (copy), AdminItemCatalog (copy)
            return AdminItemCatalog.IdByChoice[v1.Parse(p2)]
        end
    })
end
