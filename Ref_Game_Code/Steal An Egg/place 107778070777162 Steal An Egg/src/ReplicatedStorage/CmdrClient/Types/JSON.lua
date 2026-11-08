-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")

return function(p1) -- line: 3
    -- upvalues: HttpService (copy)
    p1:RegisterType("json", {
        Validate = function(p2) -- Validate | line: 5
            -- upvalues: HttpService (copy)
            local JSONDecode = HttpService.JSONDecode

            return pcall(JSONDecode, HttpService, p2)
        end,
        Parse = function(p3) -- Parse | line: 9
            -- upvalues: HttpService (copy)
            return HttpService:JSONDecode(p3)
        end
    })
end
