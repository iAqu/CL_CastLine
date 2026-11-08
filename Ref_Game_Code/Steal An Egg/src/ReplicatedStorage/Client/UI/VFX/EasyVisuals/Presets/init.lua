-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Layers)

local function collectRecipes() -- line: 7
    local t1 = {}

    for _, descendant in script:GetDescendants() do
        if descendant:IsA("ModuleScript") then
            t1[descendant.Name] = require(descendant)
        end
    end

    return t1
end

return (collectRecipes())
