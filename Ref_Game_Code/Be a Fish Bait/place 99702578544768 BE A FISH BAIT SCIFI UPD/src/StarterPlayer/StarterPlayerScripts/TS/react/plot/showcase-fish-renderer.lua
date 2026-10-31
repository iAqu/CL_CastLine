-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useEffect, useRef, useState = react.useCallback, react.useEffect, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, RunService = services.CollectionService, services.RunService
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootSelectorCreator = reflex.useRootSelector, reflex.useRootSelectorCreator
local selectAquariumFishHoveredId = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "selectors", "aquarium-fish-hover.selectors").selectAquariumFishHoveredId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquariumFishItems, selectPlayerGamepasses, selectPlayerInventory, selectPlayerSelectedDisplayFishId = selectors.selectPlayerAquariumFishItems, selectors.selectPlayerGamepasses, selectors.selectPlayerInventory, selectors.selectPlayerSelectedDisplayFishId
local usePrefab = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hooks", "use-prefab").usePrefab
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getAquariumFishEffectiveMoneyPerSecond, getExclusiveFishEditionLabel = v1.getAquariumFishEffectiveMoneyPerSecond, v1.getExclusiveFishEditionLabel
local findExclusiveFishModel = RuntimeLib.import(script, script.Parent, "aquarium-fish-manager").findExclusiveFishModel
local default = RuntimeLib.import(script, script.Parent.Parent, "fishing-zone", "fish-billboard").default
local v2 = CFrame.Angles(1.5707963267948966, 0, 0)

local function centerModelAboveAttachment(p1, p2, p3, p4) -- line: 46
    local Position = p1:GetPivot().Position

    p1:PivotTo(CFrame.new(Position) * p4)

    local BoundingBox, BoundingBox2 = p1:GetBoundingBox()
    local v3 = BoundingBox2 * 0.5
    local v6 = math.abs(BoundingBox.RightVector.Y) * v3.X + math.abs(BoundingBox.UpVector.Y) * v3.Y + math.abs(BoundingBox.LookVector.Y) * v3.Z
    local v8 = Vector3.new(p2.X, p3 + 4 + v6, p2.Z) - BoundingBox.Position

    p1:PivotTo(CFrame.new(Position + v8) * p4)
end

local function getHologramSurfaceY(p5, p6) -- line: 75
    -- upvalues: CollectionService (copy)
    for _, v9 in CollectionService:GetTagged("HologramBase") do
        if v9:IsA("Model") and v9:IsDescendantOf(p5) then
            local BoundingBox, BoundingBox2 = v9:GetBoundingBox()

            return BoundingBox.Position.Y + BoundingBox2.Y / 2
        end
    end

    return p6.Y
end

return {
    default = function(p7) -- ShowcaseFishRenderer | line: 84
        -- upvalues: react (copy), useCallback (copy), useEffect (copy), useRef (copy), useState (copy), CollectionService (copy), RunService (copy), useRootSelector (copy), useRootSelectorCreator (copy), selectAquariumFishHoveredId (copy), selectPlayerAquariumFishItems (copy), selectPlayerGamepasses (copy), selectPlayerInventory (copy), selectPlayerSelectedDisplayFishId (copy), usePrefab (copy), fishDataByName (copy), isFishData (copy), getExclusiveFishConfigByFishName (copy), getAquariumFishEffectiveMoneyPerSecond (copy), getExclusiveFishEditionLabel (copy), findExclusiveFishModel (copy), default (copy), v2 (copy), centerModelAboveAttachment (copy), getHologramSurfaceY (copy)
        local ownerUserId, plotInstance = p7.ownerUserId, p7.plotInstance
        local v10 = tostring(ownerUserId)
        local v11 = useRootSelectorCreator(selectPlayerAquariumFishItems, v10)
        local v12 = useRootSelectorCreator(selectPlayerSelectedDisplayFishId, v10)
        local v13 = useRootSelectorCreator(selectPlayerGamepasses, v10)
        local v14 = useRootSelectorCreator(selectPlayerInventory, v10)
        local v15 = useRootSelector(selectAquariumFishHoveredId)
        local v16 = if v12 == nil then nil elseif v11 == nil then v11 else v11[v12]
        local v17 = if v12 == nil then nil elseif v14 == nil then v14 else v14[v12]

        if v16 == nil then
            if (if v17 == nil then v17 else v17.itemType) == "fish" then
                v16 = {
                    exclusiveIndex = v17.exclusiveIndex,
                    fishId = v17.itemId,
                    fishSpecies = v17.itemName,
                    level = v17.level,
                    mutations = v17.mutations
                }
            else
                v16 = nil
            end
        end

        local v18, v19 = useState(nil)
        local v20 = useRef(0)

        usePrefab({
            getPrefabInstance = useCallback(function() -- line: 134
                -- upvalues: v16 (ref), fishDataByName (copy), findExclusiveFishModel (copy)
                local v22 = v16

                if v16 ~= nil then
                    v22 = v16.fishSpecies
                end

                if v22 == nil then
                    return nil
                end

                local v23 = fishDataByName[v22]

                if not v23 then
                    warn("[src/client/react/plot/showcase-fish-renderer.tsx:131]", (("[ShowcaseFishRenderer] no fishData for species=\"%*\""):format(v22)))
                end

                local v24 = findExclusiveFishModel(v22)

                if v24 ~= nil then
                    return v24
                end

                if v23 == nil then
                    return v23
                end

                return v23.model
            end, { if v16 == nil then v16 else v16.fishSpecies }),
            onPrefabInstantiated = useCallback(function(p8) -- line: 163
                -- upvalues: ownerUserId (copy), plotInstance (copy), v10 (copy), v19 (copy), v20 (copy), CollectionService (copy), v2 (copy), centerModelAboveAttachment (copy), getHologramSurfaceY (copy)
                p8:SetAttribute("ownerUserId", (tostring(ownerUserId)))
                p8.Name = v10
                CollectionService:AddTag(p8, "ShowcaseFish")

                for _, descendant in p8:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true
                        descendant.CanCollide = false
                        descendant.CanQuery = true
                        CollectionService:AddTag(descendant, "ShowcaseFishPart")
                    end
                end

                v20.current = 0

                local WorldCFramePosition = plotInstance.FishHologramPos.WorldCFrame.Position

                centerModelAboveAttachment(p8, WorldCFramePosition, getHologramSurfaceY(plotInstance, WorldCFramePosition), v2)
                v19(p8)
            end, { ownerUserId, v10, plotInstance }),
            parent = if v16 == nil then nil else plotInstance,
            name = v12
        })
        useEffect(function() -- line: 187
            -- upvalues: plotInstance (copy), v18 (copy), v20 (copy), RunService (copy), v2 (copy), centerModelAboveAttachment (copy), getHologramSurfaceY (copy)
            if v18 == nil then
                return nil
            end

            local connection = RunService.Heartbeat:Connect(function(p9) -- line: 191
                -- upvalues: plotInstance (copy), v18 (copy), v20 (copy), v2 (copy), centerModelAboveAttachment (copy), getHologramSurfaceY (copy)
                v20.current = (v20.current + 1.0471975511965976 * p9) % 6.283185307179586

                local v27 = CFrame.Angles(0, v20.current, 0) * v2
                local WorldCFramePosition = plotInstance.FishHologramPos.WorldCFrame.Position

                centerModelAboveAttachment(v18, WorldCFramePosition, getHologramSurfaceY(plotInstance, WorldCFramePosition), v27)
            end)

            return function() -- line: 198
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v18, plotInstance })

        if v16 == nil or v18 == nil then
            return react.createElement(react.Fragment)
        end

        local v29 = fishDataByName[v16.fishSpecies]

        if v29 == nil or not isFishData(v29) then
            return react.createElement(react.Fragment)
        end

        local PrimaryPart = v18.PrimaryPart
        local v30 = v18:FindFirstChild("__FishMouthAnchor", true) or PrimaryPart

        if v30 == nil then
            return react.createElement(react.Fragment)
        end

        local v31 = getAquariumFishEffectiveMoneyPerSecond(v16, v11 or {}, v13, nil, 0, v14)
        local v32 = getExclusiveFishConfigByFishName(v16.fishSpecies)
        local t2 = {
            adornee = v30,
            exclusiveEditionLabel = getExclusiveFishEditionLabel(v16.fishSpecies, v16.exclusiveIndex)
        }

        t2.exclusiveMpsMultiplier = if v32 ~= nil then v32.mpsMultiplier else v32
        t2.isVisible = v15 == v10
        t2.level = if v16.exclusiveIndex == nil then v16.level else nil
        t2.model = v18
        t2.moneyPerSecond = v31
        t2.mutations = v16.mutations
        t2.name = v29.displayName
        t2.rarity = v29.rarity

        return react.createElement(default, t2)
    end
}
