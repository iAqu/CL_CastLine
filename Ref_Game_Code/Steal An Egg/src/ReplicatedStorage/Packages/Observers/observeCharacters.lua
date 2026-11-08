-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local observePlayer = require(script.Parent.observePlayer)
local observeCharacter = require(script.Parent.observeCharacter)

local function observeCharacters(p1) -- line: 22
    -- upvalues: observePlayer (copy), observeCharacter (copy)
    return observePlayer(function(p2) -- line: 23
        -- upvalues: p1 (copy), observeCharacter (copy)
        return observeCharacter(p2, p1)
    end)
end

return observeCharacters
