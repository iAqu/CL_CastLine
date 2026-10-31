-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "abbreviate", "src").new()

v1:setSetting("suffixTable", {
    "K",
    "M",
    "B",
    "T",
    "Qd",
    "Qn",
    "Sx"
})
v1:setSetting("stripTrailingZeroes", true)
v1:setSetting("decimalPlaces", 2)

return {
    commify = function(p1) -- commify | line: 9
        -- upvalues: v1 (copy)
        return v1:commify(math.round(p1 * 100) / 100)
    end,
    abbreviate = function(p2) -- abbreviate | line: 13
        -- upvalues: v1 (copy)
        return v1:numberToString((math.floor(p2)))
    end,
    roundNumber = function(p3, p4) -- roundNumber | line: 17
        local v5 = if p4 == nil then 2 else p4

        return math.round(p3 * 10 ^ v5) / 10 ^ v5
    end,
    formatPercentage = function(p5) -- formatPercentage | line: 23
        -- upvalues: v1 (copy)
        if p5 == 0 then
            return "0%"
        end

        if p5 * 100 < 0.01 then
            local v9 = math.abs((math.floor((math.log10(p5)))))
            local v10 = p5 * 10 ^ v9

            return (("1/%*"):format((v1:numberToString((math.floor(10 ^ v9 / v10))))))
        end

        local n1 = 2
        local v14 = math.round(p5 * 100 * 10 ^ n1) / 10 ^ n1
        local n2 = 0

        while v14 == 0 do
            local v15 = p5 * 100
            local v16 = n2 + 1

            if v16 == nil then
                v16 = 2
            end

            v14 = math.round(v15 * 10 ^ v16) / 10 ^ v16
            n2 += 1
        end

        return (("%*%%"):format(v14))
    end,
    formatDuration = function(p6) -- formatDuration | line: 46
        local v18 = math.floor(p6)

        if v18 <= 0 then
            return "0s"
        end

        local v20 = math.floor(v18 / 86400)
        local v22 = math.floor(v18 % 86400 / 3600)
        local v24 = math.floor(v18 % 3600 / 60)
        local v26 = math.floor(v18 % 60)
        local t1 = {}

        if v20 > 0 then
            table.insert(t1, (("%*d"):format(v20)))
        end

        if v22 > 0 then
            table.insert(t1, (("%*h"):format(v22)))
        end

        if v24 > 0 then
            table.insert(t1, (("%*m"):format(v24)))
        end

        if v26 > 0 then
            table.insert(t1, (("%*s"):format(v26)))
        end

        return table.concat(t1, " ")
    end,
    formatCountdownClock = function(p7) -- formatCountdownClock | line: 79
        local v32 = math.max(0, (math.floor(p7)))
        local v34 = math.floor(v32 / 3600)
        local v36 = math.floor(v32 % 3600 / 60)
        local v37 = v32 % 60

        return (("%*:%*:%*"):format(string.format("%02d", v34), string.format("%02d", v36), (string.format("%02d", v37))))
    end,
    formatToRomanNumeral = function(p8) -- formatToRomanNumeral | line: 86
        if p8 == 1 then
            return "I"
        end

        if p8 == 2 then
            return "II"
        end

        if p8 == 3 then
            return "III"
        end

        if p8 == 4 then
            return "IV"
        end

        if p8 == 5 then
            return "V"
        end

        return (("%*"):format(p8))
    end,
    abbreviator = v1
}
