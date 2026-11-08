-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local t1 = {
    Validate = function(p1) -- Validate | line: 4
        if p1:match("^https?://.+$") then
            return true
        end

        return false, "URLs must begin with http:// or https://"
    end,
    Parse = function(p2) -- Parse | line: 12
        return p2
    end
}

return function(p3) -- line: 17
    -- upvalues: Util (copy), t1 (copy)
    p3:RegisterType("url", t1)
    p3:RegisterType("urls", Util.MakeListableType(t1))
end
