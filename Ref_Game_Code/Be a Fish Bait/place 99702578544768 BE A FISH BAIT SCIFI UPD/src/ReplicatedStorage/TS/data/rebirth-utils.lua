-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    2040544, 43248000, 1149280000, 20953600000, 150310400000, 2.747008E+12, 1.470976E+13, 4.67E+14,
    2203168427880512, 18481736028398136
}
local v1 = #t1

return {
    rebirthPowerMultiplier = 2,
    rebirthPowerCostFinal = 443948391496849300,
    getRebirthPowerCost = function(p1) -- getRebirthPowerCost | line: 29
        -- upvalues: t1 (copy), v1 (copy)
        if p1 < #t1 then
            return t1[p1 + 1]
        end

        if p1 == v1 then
            return 443948391496849300
        end

        return 1e999
    end,
    isMaxRebirth = function(p2) -- isMaxRebirth | line: 39
        -- upvalues: v1 (copy)
        return v1 < p2
    end,
    getRebirthEntry = function(p3) -- getRebirthEntry | line: 42
        -- upvalues: t1 (copy), v1 (copy)
        local v3 = math.min(p3, v1 + 1)

        return {
            powerCost = if p3 < #t1 then t1[p3 + 1] elseif p3 == v1 then 443948391496849300 else 1e999,
            powerMultiplier = math.pow(2, v3)
        }
    end,
    formatMultiplier = function(p4) -- formatMultiplier | line: 53
        local v5 = math.floor(p4 * 100 + 0.5) / 100
        local v6 = math.floor(v5)
        local v8 = math.floor((v5 - v6) * 100 + 0.5)

        if v8 == 0 then
            return (("x%*.0"):format(v6))
        end

        if v8 % 10 == 0 then
            return (("x%*.%*"):format(v6, v8 / 10))
        end

        return (("x%*.%*"):format(v6, v8))
    end,
    abbreviatePower = function(p5) -- abbreviatePower | line: 66
        if p5 >= 1E+06 then
            return (`{ math.floor(p5 / 1E+05) / 10 }M`)
        end

        if p5 >= 1000 then
            return (`{ math.floor(p5 / 100) / 10 }K`)
        end

        return (tostring((math.floor(p5))))
    end,
    rebirthPowerCostTable = t1,
    maxRebirthLevel = v1
}
