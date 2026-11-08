-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function readPalettes() -- line: 11
    local t1 = {}

    for _, descendant in script:GetDescendants() do
        if descendant:IsA("ModuleScript") then
            t1[descendant.Name] = require(descendant)
        end
    end

    return t1
end

return (readPalettes())
