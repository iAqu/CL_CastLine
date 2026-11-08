-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SchemaFields = require(script.Parent.SchemaFields)

return function(p1, p2) -- line: 13
    -- upvalues: SchemaFields (copy)
    if typeof(p1) ~= "table" then
        return false, "a profile update has to be a table"
    end

    local v1 = typeof(p2) ~= "table"

    for v2 in SchemaFields do
        local v3 = SchemaFields[v2]
        local v4 = p1[v2]

        if v3 ~= nil and (v1 or v4 ~= p2[v2]) then
            local v5, v6 = v3(v4)

            if not v5 then
                return false, (("profile field %* was refused: %*"):format(v2, v6 or "shape does not match"))
            end
        end
    end

    return true
end
