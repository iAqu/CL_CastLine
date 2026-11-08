-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HalloweenPets = require(ReplicatedStorage.Data.HalloweenPets)
local LimitedEgg = require(ReplicatedStorage.Data.LimitedEgg)
local v1 = table.freeze({})
local t1 = {
    Category = "HalloweenPart1",
    DisplayName = "Halloween Part 1",
    BackgroundImage = "rbxassetid://91240205245018",
    Entries = v1,
    HasEntries = function() -- HasEntries | line: 32
        -- upvalues: v1 (copy)
        return #v1 > 0
    end,
    IsComplete = function(p1) -- IsComplete | line: 37
        -- upvalues: v1 (copy)
        if #v1 == 0 or p1 == nil then
            return false
        end

        for _, v2 in v1 do
            if not p1[v2.AssetId] then
                return false
            end
        end

        return true
    end,
    GetSections = function() -- GetSections | line: 51
        -- upvalues: HalloweenPets (copy), LimitedEgg (copy)
        local t2 = {}

        for _, v3 in LimitedEgg.Halloween.Entries do
            table.insert(t2, {
                AssetId = v3.AssetId,
                Weight = v3.Weight
            })
        end

        local MechaReroll = LimitedEgg.Halloween.MechaReroll

        if MechaReroll then
            for _, v4 in MechaReroll.Entries do
                table.insert(t2, {
                    AssetId = v4.AssetId,
                    Weight = v4.Weight
                })
            end
        end

        local t5 = {}

        for v5, v6 in HalloweenPets.Specs do
            if v6.Group == "World" then
                table.insert(t5, {
                    AssetId = v5,
                    Weight = v6.Weight
                })
            end
        end

        for _, v7 in {
                {
                    AssetId = "Candy Corn",
                    Weight = 51
                },
                {
                    AssetId = "Hollow Bat",
                    Weight = 24
                },
                {
                    AssetId = "Scarecrow",
                    Weight = 18
                },
                {
                    AssetId = "Pumpkin Golem",
                    Weight = 6.5
                },
                {
                    AssetId = "Soul Phantom",
                    Weight = 0.5
                }
            } do
            table.insert(t5, v7)
        end

        return {
            {
                Category = "HalloweenPaidEggs",
                DisplayName = "Halloween Robux Eggs",
                BackgroundImage = "rbxassetid://125651352019259",
                Entries = t2
            },
            {
                Category = "HalloweenWorldEggs",
                DisplayName = "Halloween World & Event Eggs",
                BackgroundImage = "rbxassetid://91240205245018",
                Entries = t5
            }
        }
    end
}

return table.freeze(t1)
