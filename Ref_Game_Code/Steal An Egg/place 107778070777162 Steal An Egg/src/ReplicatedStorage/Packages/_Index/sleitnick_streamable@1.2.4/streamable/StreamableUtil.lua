-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Trove = require(script.Parent.Parent.Trove)

require(script.Parent.Streamable)

return {
    Compound = function(p1, p2) -- Compound | line: 47
        -- upvalues: Trove (copy)
        local v1 = Trove.new()
        local v2 = Trove.new()
        local v3 = false

        local function Check() -- line: 51
            -- upvalues: p1 (copy), p2 (copy), v2 (copy), v3 (ref)
            if v3 then
                return
            end

            for _, v4 in pairs(p1) do
                if not v4.Instance then
                    return
                end
            end

            v3 = true
            p2(p1, v2)
        end

        local function Cleanup() -- line: 63
            -- upvalues: v2 (copy), v3 (ref)
            if v3 then
                v3 = false
                v2:Clean()
            end
        end

        for _, v5 in pairs(p1) do
            v1:Add(v5:Observe(function(_, p4) -- line: 71
                -- upvalues: p1 (copy), p2 (copy), v2 (copy), v3 (ref), Cleanup (copy)
                if not v3 then
                    local v6 = false

                    for _, v7 in pairs(p1) do
                        if not v7.Instance then
                            v6 = true
                            break
                        end
                    end

                    if not v6 then
                        v3 = true
                        p2(p1, v2)
                    end
                end

                p4:Add(Cleanup)
            end))
        end

        v1:Add(Cleanup)

        return v1
    end
}
