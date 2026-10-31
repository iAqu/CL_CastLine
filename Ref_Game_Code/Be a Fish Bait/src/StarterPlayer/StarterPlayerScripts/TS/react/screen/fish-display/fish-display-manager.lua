-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Players = services.HttpService, services.Players
local default = RuntimeLib.import(script, script.Parent, "fish-display-menu").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerEquippedHologramSkin, selectPlayerAquariumFishItems, selectPlayerGamepasses, selectPlayerInventory = selectors.selectPlayerEquippedHologramSkin, selectors.selectPlayerAquariumFishItems, selectors.selectPlayerGamepasses, selectors.selectPlayerInventory
local selectPlayerOwnedHologramSkins, selectPlayerSelectedDisplayFishId = selectors.selectPlayerOwnedHologramSkins, selectors.selectPlayerSelectedDisplayFishId
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local getHologramSkinData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "hologram-skins").getHologramSkinData
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, getExclusiveFishEditionLabel = v1.getAquariumFishEffectiveMoneyPerSecond, v1.getExclusiveFishEditionLabel
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local offlineEarningsConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "offline-earnings-utils").offlineEarningsConfig
local getMutationColor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-roll-utils").getMutationColor
local getFishMutationDisplayName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations").getFishMutationDisplayName
local v2 = tostring(Players.LocalPlayer.UserId)

local function color3ToHex(p1) -- line: 31
    local v4 = math.round(p1.R * 255)
    local v6 = math.round(p1.G * 255)
    local v8 = math.round(p1.B * 255)

    return string.format("#%02X%02X%02X", v4, v6, v8)
end

local function mutationsToRichText(p2) -- line: 37
    -- upvalues: getMutationColor (copy), getFishMutationDisplayName (copy)
    if #p2 == 0 then
        return "<font color=\"#AAAAAA\">No Mutation</font>"
    end

    local v9 = table.create(#p2)

    local function v10(p3) -- line: 43
        -- upvalues: getMutationColor (copy), getFishMutationDisplayName (copy)
        local v11 = getMutationColor(p3)
        local v13 = math.round(v11.R * 255)
        local v15 = math.round(v11.G * 255)
        local v17 = math.round(v11.B * 255)

        return (("<font color=\"%*\">%*</font>"):format(string.format("#%02X%02X%02X", v13, v15, v17), (getFishMutationDisplayName(p3))))
    end

    for v18, v19 in p2 do
        local _ = v18 - 1
        local v20 = getMutationColor(v19)
        local v22 = math.round(v20.R * 255)
        local v24 = math.round(v20.G * 255)
        local v26 = math.round(v20.B * 255)

        v9[v18] = ("<font color=\"%*\">%*</font>"):format(string.format("#%02X%02X%02X", v22, v24, v26), (getFishMutationDisplayName(v19)))
    end

    return table.concat(v9, ", ")
end

local function ownedFishToDisplayData(p4, p5, p6, p7, p8, p9, p10, p11) -- line: 53
    -- upvalues: fishDataByName (copy), isFishData (copy), getAquariumFishEffectiveMoneyPerSecond (copy), getExclusiveFishEditionLabel (copy), getExclusiveFishConfigByFishName (copy), offlineEarningsConfig (copy), mutationsToRichText (copy)
    local v27 = fishDataByName[p5]
    local v28, v29

    if v27 ~= nil then
        if isFishData(v27) then
            v28 = getExclusiveFishConfigByFishName(p5) ~= nil
            v29 = false
        else
            v29 = true
        end
    else
        v29 = true
    end

    if v29 then
        return nil
    end

    local v30 = getAquariumFishEffectiveMoneyPerSecond({
        fishId = p4,
        fishSpecies = p5,
        level = p6,
        mutations = p7
    }, p10, p9, nil, 0, p11)
    local v31 = getExclusiveFishEditionLabel(p5, p8)

    return {
        fishId = p4,
        fishName = if v31 == nil then v27.displayName else ("%* (%*)"):format(v27.displayName, v31),
        imageId = v27.imageId,
        level = if v28 then nil else p6,
        moneyPerSecond = v30,
        mutation = mutationsToRichText(p7),
        offlineEarningPerSec = math.floor(v30 * offlineEarningsConfig.offlineFactor),
        rarity = v27.rarity
    }
end

return {
    default = function(p12) -- FishDisplayManager | line: 78
        -- upvalues: react (copy), HttpService (copy), default (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerEquippedHologramSkin (copy), selectPlayerAquariumFishItems (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerOwnedHologramSkins (copy), selectPlayerSelectedDisplayFishId (copy), getHologramSkinData (copy), functions (copy), v2 (copy), ownedFishToDisplayData (copy)
        local onClose = p12.onClose
        local v33 = useRootProducer()
        local v34 = useRootSelector(selectPlayerInventory(v2))
        local v35 = useRootSelector(selectPlayerAquariumFishItems(v2))
        local v36 = useRootSelector(selectPlayerGamepasses(v2))
        local v37 = useRootSelector(selectPlayerSelectedDisplayFishId(v2))
        local v38 = useRootSelector(selectPlayerOwnedHologramSkins(v2))
        local v39 = useRootSelector(selectPlayerEquippedHologramSkin(v2))
        local t2 = {}

        if v35 then
            for v40, v41 in v35 do
                local v42 = ownedFishToDisplayData(v40, v41.fishSpecies, v41.level, v41.mutations, v41.exclusiveIndex, v36, v35, v34)

                if v42 then
                    table.insert(t2, v42)
                end
            end
        end

        if v34 then
            for v43, v44 in v34 do
                if v44.itemType == "fish" then
                    local v45 = ownedFishToDisplayData(v43, v44.itemName, v44.level, v44.mutations, v44.exclusiveIndex, v36, v35 or {}, v34)

                    if v45 then
                        table.insert(t2, v45)
                    end
                end
            end
        end

        table.sort(t2, function(p13, p14) -- line: 108
            return p13.moneyPerSecond > p14.moneyPerSecond
        end)

        local function v46(p15) -- line: 111
            -- upvalues: v33 (copy), HttpService (copy), functions (copy)
            functions.selectDisplayFish(p15):andThen(function(p16) -- line: 112
                -- upvalues: v33 (copy), HttpService (copy)
                if not p16 then
                    v33.onScreenFeedbackAdded({
                        message = "Could not update showcase fish",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                end
            end)
        end

        local t3 = {}

        for _, v47 in v38 do
            local v48 = getHologramSkinData(v47)

            if v48 ~= nil then
                local t4 = {
                    displayName = v48.displayName,
                    imageId = v48.imageId
                }

                t4.isActive = v47 == (if v39 == nil then "Default" else v39)
                t4.rarity = v48.rarity
                t4.skinName = v47
                table.insert(t3, t4)
            end
        end

        local function v49(p17) -- line: 142
            -- upvalues: v33 (copy), HttpService (copy), functions (copy)
            functions.equipHologramSkin(p17):andThen(function(p18) -- line: 143
                -- upvalues: v33 (copy), HttpService (copy)
                if not p18 then
                    v33.onScreenFeedbackAdded({
                        message = "Could not equip hologram skin",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                end
            end)
        end

        return react.createElement(default, {
            fish = t2,
            hologramSkins = t3,
            onClose = onClose,
            onEquipHologramSkin = v49,
            onSelectFish = v46,
            selectedFishId = v37
        })
    end
}
