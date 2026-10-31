-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useState = react.useCallback, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, ReplicatedStorage, Workspace = services.CollectionService, services.ReplicatedStorage, services.Workspace
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootSelectorCreator = reflex.useRootSelector, reflex.useRootSelectorCreator
local selectAquariumFishHoveredId = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "selectors", "aquarium-fish-hover.selectors").selectAquariumFishHoveredId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumFishItems, selectPlayerAquariumLevel, selectPlayerGamepasses, selectPlayerInventory = selectors.selectPlayerAquariumFishItems, selectors.selectPlayerAquariumLevel, selectors.selectPlayerGamepasses, selectors.selectPlayerInventory
local selectPlayerShowcaseFish = selectors.selectPlayerShowcaseFish
local getAquariumSkinModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums").getAquariumSkinModel
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-placement-utils")
local computeAquariumPivotCFrame, prepareAquariumPrefabInstance = v1.computeAquariumPivotCFrame, v1.prepareAquariumPrefabInstance
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab
local default = RuntimeLib.import(script, script.Parent.Parent, "fishing-zone", "fish-billboard").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "delulu-fish-spew").default
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, getExclusiveFishEditionLabel, showcaseFishToMpsInput = v2.getAquariumFishEffectiveMoneyPerSecond, v2.getExclusiveFishEditionLabel, v2.showcaseFishToMpsInput
local applyMutationVfx = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "mutation-vfx-utils").applyMutationVfx

local function findAquariumBounds(p1) -- line: 37
    local AquariumBounds = p1:FindFirstChild("AquariumBounds")

    if AquariumBounds and AquariumBounds:IsA("Part") then
        return AquariumBounds
    end

    local v3 = p1:FindFirstChild("AquariumBounds", true)

    return if v3 and v3:IsA("Part") then v3 else nil
end

local function fishPropsEqual(p2, p3) -- line: 48
    if p2.aquariumModel ~= p3.aquariumModel or p2.ownerUserId ~= p3.ownerUserId then
        return false
    end

    local fish = p2.fish
    local fish2 = p3.fish

    if fish.fishId ~= fish2.fishId
        or fish.fishSpecies ~= fish2.fishSpecies
        or fish.level ~= fish2.level
        or fish.exclusiveIndex ~= fish2.exclusiveIndex
        or fish.fishObtainedTimestamp ~= fish2.fishObtainedTimestamp
        or #fish.mutations ~= #fish2.mutations then
        return false
    end

    for i = 0, #fish.mutations - 1 do
        if fish.mutations[i + 1] ~= fish2.mutations[i + 1] then
            return false
        end
    end

    return true
end

local function findExclusiveFishModel(p4) -- line: 82
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), getExclusiveFishConfigByFishName (copy)
    local v4 = getExclusiveFishConfigByFishName(p4)

    if v4 then
        local Fishes = ReplicatedStorage:FindFirstChild("Fishes")

        if Fishes ~= nil then
            Fishes = Fishes:FindFirstChild("Exclusive")
        end

        local v5 = if Fishes == nil then Fishes else Fishes:FindFirstChild(v4.fishName)
        local v6

        if v5 ~= nil then
            v6 = v5
        else
            local v7 = if Fishes == nil then Fishes else Fishes:FindFirstChild(v4.displayName)

            if v7 ~= nil then
                v6 = v7
            elseif v4.modelDisplayName ~= nil then
                v6 = if Fishes ~= nil then Fishes:FindFirstChild(v4.modelDisplayName) else Fishes
            end
        end

        if if v6 == nil then v6 else v6:IsA("Model") then
            return v6
        end

        local v8 = Workspace:FindFirstChild("ExclusiveFishPodium", true)

        if v8 ~= nil then
            v8 = v8:FindFirstChild(v4.displayName)
        end

        local v9 = if v8 == nil then v8 else v8:FindFirstChild(v4.displayName)
        local v10

        if v9 ~= nil then
            v10 = v9
        else
            local v11 = if v4.modelDisplayName == nil then nil elseif v8 == nil then v8 else v8:FindFirstChild(v4.modelDisplayName)

            v10 = if v11 ~= nil then v11 elseif v8 ~= nil then v8:FindFirstChild(v4.fishName) else v8
        end

        if if v10 == nil then v10 else v10:IsA("Model") then
            return v10
        end
    end

    return nil
end

local function v12(p5) -- line: 163
    -- upvalues: react (copy), useCallback (copy), useState (copy), CollectionService (copy), useRootSelector (copy), selectAquariumFishHoveredId (copy), fishDataByName (copy), isFishData (copy), usePrefab (copy), default (copy), default2 (copy), getExclusiveFishConfigByFishName (copy), getExclusiveFishEditionLabel (copy), applyMutationVfx (copy), findExclusiveFishModel (copy)
    local aquariumModel, fish, moneyPerSecond, ownerUserId = p5.aquariumModel, p5.fish, p5.moneyPerSecond, p5.ownerUserId
    local v13 = useRootSelector(selectAquariumFishHoveredId)
    local v14, v15 = useState(nil)

    usePrefab({
        getPrefabInstance = useCallback(function() -- line: 170
            -- upvalues: fish (copy), fishDataByName (copy), findExclusiveFishModel (copy)
            local v17 = fishDataByName[fish.fishSpecies]

            if not v17 then
                warn("[src/client/react/plot/aquarium-fish-manager.tsx:107]", (("[AquariumFishRenderer] no fishData for species=\"%*\""):format(fish.fishSpecies)))
            end

            local v18 = findExclusiveFishModel(fish.fishSpecies)

            if v18 ~= nil then
                return v18
            end

            if v17 == nil then
                return v17
            end

            return v17.model
        end, { fish.fishSpecies }),
        onPrefabInstantiated = useCallback(function(p6) -- line: 187
            -- upvalues: aquariumModel (copy), fish (copy), ownerUserId (copy), v15 (copy), CollectionService (copy), applyMutationVfx (copy)
            if p6.PrimaryPart == nil then
                local v20 = p6:FindFirstChildWhichIsA("BasePart", true)

                if v20 then
                    p6.PrimaryPart = v20
                end
            end

            for _, descendant in p6:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = false
                    descendant.CanCollide = false
                    descendant.CanQuery = true
                    descendant.CanTouch = false
                    descendant.CastShadow = false
                    CollectionService:AddTag(descendant, "AquariumFishPart")
                end
            end

            local AquariumBounds = aquariumModel:FindFirstChild("AquariumBounds")

            if not (AquariumBounds and AquariumBounds:IsA("Part")) then
                AquariumBounds = aquariumModel:FindFirstChild("AquariumBounds", true)

                if not (AquariumBounds and AquariumBounds:IsA("Part")) then
                    AquariumBounds = nil
                end
            end

            local v21

            if AquariumBounds then
                local Size = AquariumBounds.Size
                local CFramePosition = AquariumBounds.CFrame.Position

                v21 = Vector3.new(CFramePosition.X + (math.random() - 0.5) * Size.X * 0.8, CFramePosition.Y + (math.random() - 0.5) * Size.Y * 0.8, CFramePosition.Z + (math.random() - 0.5) * Size.Z * 0.8)
            else
                local BoundingBox, BoundingBox2 = aquariumModel:GetBoundingBox()

                v21 = Vector3.new(BoundingBox.Position.X + (math.random() - 0.5) * BoundingBox2.X * 0.6, BoundingBox.Position.Y + (math.random() - 0.5) * BoundingBox2.Y * 0.3, BoundingBox.Position.Z + (math.random() - 0.5) * BoundingBox2.Z * 0.6)
            end

            p6:PivotTo(CFrame.new(v21))
            applyMutationVfx(p6, fish.mutations)
            p6.Name = fish.fishId
            p6:SetAttribute("ownerUserId", (tostring(ownerUserId)))
            CollectionService:AddTag(p6, "AquariumFish")
            v15(p6)
        end, {
            fish.fishId,
            fish.mutations,
            aquariumModel,
            ownerUserId
        }),
        parent = aquariumModel,
        name = fish.fishSpecies
    })

    local v28 = fishDataByName[fish.fishSpecies]
    local v29 = if v14 == nil then v14 else v14.PrimaryPart
    local v30 = (if v14 == nil then v14 else v14:FindFirstChild("__FishMouthAnchor", true)) or v29
    local v31 = v14 ~= nil and react.createElement(default2, {
        model = v14,
        mutations = fish.mutations
    })
    local v32 = v14 ~= nil and v30 ~= nil and v28 ~= nil and isFishData(v28)

    if v32 then
        local t1 = {
            adornee = v30,
            exclusiveEditionLabel = getExclusiveFishEditionLabel(fish.fishSpecies, fish.exclusiveIndex)
        }
        local v33 = getExclusiveFishConfigByFishName(fish.fishSpecies)

        t1.exclusiveMpsMultiplier = if v33 ~= nil then v33.mpsMultiplier else v33
        t1.isVisible = v13 == fish.fishId
        t1.level = if fish.exclusiveIndex == nil then fish.level else nil
        t1.model = v14
        t1.moneyPerSecond = moneyPerSecond
        t1.mutations = fish.mutations
        t1.name = v28.displayName
        t1.rarity = v28.rarity
        v32 = react.createElement(default, t1)
    end

    return react.createElement(react.Fragment, nil, v31, v32)
end

local v34 = react.memo(v12, fishPropsEqual)

local function AquariumModelRenderer(p7) -- line: 269
    -- upvalues: react (copy), useCallback (copy), useState (copy), Workspace (copy), useRootSelectorCreator (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerShowcaseFish (copy), getAquariumSkinModel (copy), computeAquariumPivotCFrame (copy), prepareAquariumPrefabInstance (copy), fishDataByName (copy), usePrefab (copy), getAquariumFishEffectiveMoneyPerSecond (copy), showcaseFishToMpsInput (copy), findExclusiveFishModel (copy), v34 (copy)
    local aquariumLevel, fishItems, ownerUserId, plotInstance = p7.aquariumLevel, p7.fishItems, p7.ownerUserId, p7.plotInstance
    local skinName = p7.skinName
    local v35 = tostring(ownerUserId)
    local v36 = useRootSelectorCreator(selectPlayerGamepasses, v35)
    local v37 = useRootSelectorCreator(selectPlayerInventory, v35)
    local v39 = showcaseFishToMpsInput((useRootSelectorCreator(selectPlayerShowcaseFish, v35)))
    local v40, v41 = useState(nil)

    usePrefab({
        getPrefabInstance = useCallback(function() -- line: 281
            -- upvalues: aquariumLevel (copy), skinName (copy), getAquariumSkinModel (copy)
            return getAquariumSkinModel(aquariumLevel, skinName)
        end, { aquariumLevel, skinName }),
        onPrefabInstantiated = useCallback(function(p8) -- line: 284
            -- upvalues: aquariumLevel (copy), plotInstance (copy), skinName (copy), v41 (copy), Workspace (copy), computeAquariumPivotCFrame (copy), prepareAquariumPrefabInstance (copy)
            prepareAquariumPrefabInstance(p8)
            p8.Parent = Workspace
            p8:PivotTo(computeAquariumPivotCFrame(p8, plotInstance.AquariumPos.WorldCFrame, aquariumLevel, skinName))
            v41(p8)
        end, { plotInstance, aquariumLevel, skinName }),
        parent = plotInstance
    })

    if v40 == nil then
        return react.createElement(react.Fragment)
    end

    local t2 = {}

    for _, v44 in fishItems do
        table.insert(t2, v44)
    end

    local v45 = table.create(#t2)

    local function v46(p9) -- line: 307
        -- upvalues: fishItems (copy), ownerUserId (copy), v36 (copy), v37 (copy), v39 (copy), v40 (copy), react (copy), fishDataByName (copy), getAquariumFishEffectiveMoneyPerSecond (copy), findExclusiveFishModel (copy), v34 (copy)
        local v47 = fishDataByName[p9.fishSpecies]

        if v47 ~= nil then
            v47 = v47.model
        end

        if v47 == nil and findExclusiveFishModel(p9.fishSpecies) == nil then
            return nil
        end

        return react.createElement(v34, {
            aquariumModel = v40,
            fish = p9,
            key = p9.fishId,
            moneyPerSecond = getAquariumFishEffectiveMoneyPerSecond(p9, fishItems, v36, nil, 0, v37, v39),
            ownerUserId = ownerUserId
        })
    end

    for v48, v49 in t2 do
        v45[v48] = v46(v49, v48 - 1, t2)
    end

    return react.createElement(react.Fragment, nil, v45)
end

return {
    findExclusiveFishModel = findExclusiveFishModel,
    default = function(p10) -- AquariumFishManager | line: 334
        -- upvalues: react (copy), useRootSelector (copy), useRootSelectorCreator (copy), selectPlayerAquariumFishItems (copy), selectPlayerAquariumLevel (copy), AquariumModelRenderer (copy)
        local ownerUserId, plotInstance = p10.ownerUserId, p10.plotInstance
        local v50 = tostring(ownerUserId)
        local v51 = useRootSelectorCreator(selectPlayerAquariumLevel, v50)
        local v52 = useRootSelectorCreator(selectPlayerAquariumFishItems, v50)
        local v53 = useRootSelector(function(p11) -- line: 340
            -- upvalues: v50 (copy)
            local v54 = p11.aquariumSkins[v50]

            if v54 == nil then
                v54 = "Default"
            end

            return v54
        end)

        if v52 == nil then
            return react.createElement(react.Fragment)
        end

        return react.createElement(AquariumModelRenderer, {
            aquariumLevel = v51,
            fishItems = v52,
            ownerUserId = ownerUserId,
            plotInstance = plotInstance,
            skinName = v53
        })
    end
}
