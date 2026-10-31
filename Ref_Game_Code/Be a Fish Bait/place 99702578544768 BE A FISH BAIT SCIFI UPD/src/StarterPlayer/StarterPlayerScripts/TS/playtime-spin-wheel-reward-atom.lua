-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local n1 = 0
local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom(nil)

return {
    showPlaytimeSpinWheelRewardReveal = function(p1) -- showPlaytimeSpinWheelRewardReveal | line: 6
        -- upvalues: n1 (ref), v1 (copy)
        local v2 = table.clone(p1)

        setmetatable(v2, nil)

        local v3 = n1

        n1 += 1
        v2.id = v3
        v1(v2)
    end,
    clearPlaytimeSpinWheelRewardReveal = function(p2) -- clearPlaytimeSpinWheelRewardReveal | line: 15
        -- upvalues: v1 (copy)
        local v4 = v1()

        if v4 ~= nil then
            v4 = v4.id
        end

        if v4 == p2 then
            v1(nil)
        end
    end,
    playtimeSpinWheelRewardRevealAtom = v1
}
