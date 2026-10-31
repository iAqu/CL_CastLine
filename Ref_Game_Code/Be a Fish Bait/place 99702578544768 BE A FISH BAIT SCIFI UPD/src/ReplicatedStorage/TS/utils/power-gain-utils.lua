-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils")
local powerTrainingGamepassName, powerTrainingMultiplier = v1.powerTrainingGamepassName, v1.powerTrainingMultiplier
local calculatePowerTrainingGamepassMultiplier

local function calculateTrainingPowerGain(p1, p2, p3, p4, p5) -- line: 16
    -- upvalues: calculatePowerTrainingGamepassMultiplier (ref)
    local v2 = if p5 == nil then 0 else p5
    local v3 = calculatePowerTrainingGamepassMultiplier(p3)
    local v4 = if p4 == nil then 0 else p4

    return p1 * p2 * (1 + v4 + v2) * v3
end

function calculatePowerTrainingGamepassMultiplier(p6) -- line: 33
    -- upvalues: powerTrainingGamepassName (copy), powerTrainingMultiplier (copy)
    if not p6 or #p6 == 0 then
        return 1
    end

    local function v5(p7) -- line: 39
        -- upvalues: powerTrainingGamepassName (copy)
        return p7.gamepassName == powerTrainingGamepassName
    end

    local v6 = false

    for v7, v8 in p6 do
        local _ = v7 - 1

        if v8.gamepassName == powerTrainingGamepassName then
            v6 = true
            break
        end
    end

    if v6 then
        return powerTrainingMultiplier
    end

    return 1
end

return {
    calculateTrainingPowerGain = calculateTrainingPowerGain,
    calculatePowerTrainingGamepassMultiplier = calculatePowerTrainingGamepassMultiplier
}
