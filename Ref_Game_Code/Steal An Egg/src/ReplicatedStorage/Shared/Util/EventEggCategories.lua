-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t2 = {
    require(ReplicatedStorage.Data.AdminAbuseEgg),
    require(ReplicatedStorage.Data.DragonEgg)
}
local t1 = {
    IsEventEgg = function(p1) -- IsEventEgg | line: 20
        -- upvalues: t2 (copy)
        local v1 = false

        for _, v2 in t2 do
            if not v1 then
                v1 = p1 ~= nil and v2.IsEventCategory(p1)
            end
        end

        return v1
    end
}

return table.freeze(t1)
