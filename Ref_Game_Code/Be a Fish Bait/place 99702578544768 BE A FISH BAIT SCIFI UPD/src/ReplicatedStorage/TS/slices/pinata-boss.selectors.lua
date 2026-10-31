-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local createSelector = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createSelector

local function selectPinataBossState(p1) -- line: 4
    return p1.pinataBoss
end

return {
    selectPinataBossState = selectPinataBossState,
    selectPinataBossHp = createSelector({
        selectPinataBossState
    }, function(p2) -- line: 7
        return {
            hp = p2.hp,
            isActive = p2.isActive,
            maxHp = p2.maxHp
        }
    end),
    selectPinataBossHudState = createSelector({
        selectPinataBossState
    }, function(p3) -- line: 14
        return {
            damageContributions = p3.damageContributions,
            despawnTimestamp = p3.despawnTimestamp,
            hp = p3.hp,
            isActive = p3.isActive,
            maxHp = p3.maxHp
        }
    end)
}
