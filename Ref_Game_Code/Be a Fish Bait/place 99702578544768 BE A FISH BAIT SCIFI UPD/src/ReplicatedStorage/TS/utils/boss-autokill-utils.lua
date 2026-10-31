-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local getExclusiveFishConfigByFishName = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName

return {
    isExclusiveBossFish = function(p1) -- isExclusiveBossFish | line: 4
        -- upvalues: getExclusiveFishConfigByFishName (copy)
        local v1 = getExclusiveFishConfigByFishName(p1)

        if v1 ~= nil then
            v1 = v1.bossFight
        end

        return v1 == true
    end
}
