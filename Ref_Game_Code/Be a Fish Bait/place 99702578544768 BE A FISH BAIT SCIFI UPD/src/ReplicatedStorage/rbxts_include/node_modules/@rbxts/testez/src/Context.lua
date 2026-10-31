-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    new = function(p1) -- new | line: 7
        local t2 = {}
        local t1 = {}

        t1.__index = t2

        if p1 then
            for v1, v2 in pairs(getmetatable(p1).__index) do
                t2[v1] = v2
            end
        end

        function t1.__newindex(_, p3, p4) -- line: 18
            -- upvalues: t2 (copy)
            assert(t2[p3] == nil, string.format("Cannot reassign %s in context", (tostring(p3))))
            t2[p3] = p4
        end

        return (setmetatable({}, t1))
    end
}
