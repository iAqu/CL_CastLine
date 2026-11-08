-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gears = require(ReplicatedStorage.Data.Gears)
local t1 = {}

for _, v1 in pairs(Gears.Directory) do
    if v1.ToolController == "Gun" then
        t1[#t1 + 1] = v1._id
    end
end

table.freeze(t1)

return {
    ListGearNames = function() -- ListGearNames | line: 19
        -- upvalues: t1 (copy)
        return table.clone(t1)
    end
}
