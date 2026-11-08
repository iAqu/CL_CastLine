-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Util = require(script.Parent.Parent.Shared.Util)
local t1 = { "^%a[%w_]*$", "^%$%a[%w_]*$", "^%.%a[%w_]*$", "^%$%.%a[%w_]*$" }

return function(p1) -- line: 10
    -- upvalues: Util (copy), t1 (copy)
    local t2 = {
        Autocomplete = function(p2) -- Autocomplete | line: 12
            -- upvalues: p1 (copy)
            return p1.Cmdr.Util.MakeFuzzyFinder(p1.Cmdr.Util.DictionaryKeys(p1:GetStore("vars_used") or {}))(p2)
        end,
        Validate = function(p3) -- Validate | line: 18
            -- upvalues: t1 (copy)
            for _, v1 in ipairs(t1) do
                if p3:match(v1) then
                    return true
                end
            end

            return false, "Key names must start with an optional modifier: . $ or $. and must begin with a letter."
        end,
        Parse = function(p4) -- Parse | line: 28
            return p4
        end
    }

    p1:RegisterType("storedKey", t2)
    p1:RegisterType("storedKeys", Util.MakeListableType(t2))
end
