-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TestPlan = require(script.Parent.TestPlan)

return {
    createPlan = function(p1, p2, p3) -- createPlan | line: 26
        -- upvalues: TestPlan (copy)
        local v1 = TestPlan.new(p2, p3)

        table.sort(p1, function(p4, p5) -- line: 29
            return p4.pathStringForSorting < p5.pathStringForSorting
        end)

        for _, v2 in ipairs(p1) do
            v1:addRoot(v2.path, v2.method)
        end

        return v1
    end
}
