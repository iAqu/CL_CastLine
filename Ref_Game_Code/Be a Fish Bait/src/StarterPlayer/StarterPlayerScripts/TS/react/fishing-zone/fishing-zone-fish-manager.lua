-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useState = react.useEffect, react.useMemo, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootSelectorCreator = reflex.useRootSelector, reflex.useRootSelectorCreator
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local selectPlayerFishingState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "fishing-state.selectors").selectPlayerFishingState
local selectNibbleActiveFishId = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "slices", "nibble-active-fish.selectors").selectNibbleActiveFishId
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectInventoryFishLevel, selectInventoryFishMutations, selectPlayerInventory, selectPlayerInventoryItem = selectors.selectInventoryFishLevel, selectors.selectInventoryFishMutations, selectors.selectPlayerInventory, selectors.selectPlayerInventoryItem
local selectPlayerGamepasses, selectPlayerAquariumFishItems, selectPlayerShowcaseFish = selectors.selectPlayerGamepasses, selectors.selectPlayerAquariumFishItems, selectors.selectPlayerShowcaseFish
local default = RuntimeLib.import(script, script.Parent, "fish-billboard").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "delulu-fish-spew").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local getFishMoneyPerSecond = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "aquarium-utils").getFishMoneyPerSecond
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "exclusive-fish-utils")
local getExclusiveFishEditionLabel, getExclusiveFishMoneyPerSecondFromAquarium, showcaseFishToMpsInput = v1.getExclusiveFishEditionLabel, v1.getExclusiveFishMoneyPerSecondFromAquarium, v1.showcaseFishToMpsInput
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local v2 = tostring(Players.LocalPlayer.UserId)
local v3 = Color3.fromRGB(255, 215, 0)
local v4 = Color3.fromRGB(0, 0, 0)

local function useAdornee(p1) -- line: 40
    -- upvalues: useEffect (copy), useMemo (copy), useState (copy)
    local v5, v6 = useState(function() -- line: 45
        -- upvalues: p1 (copy)
        return p1.PrimaryPart
    end)

    useEffect(function() -- line: 48
        -- upvalues: p1 (copy), v6 (copy)
        v6(p1.PrimaryPart)

        local connection = p1:GetPropertyChangedSignal("PrimaryPart"):Connect(function() -- line: 50
            -- upvalues: p1 (copy), v6 (copy)
            return v6(p1.PrimaryPart)
        end)

        return function() -- line: 53
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { p1 })

    return useMemo(function() -- line: 57
        -- upvalues: p1 (copy), v5 (copy)
        if v5 == nil then
            return nil
        end

        local __FishMouthAnchor = p1:FindFirstChild("__FishMouthAnchor")

        return {
            adornee = __FishMouthAnchor or v5,
            mouthAnchor = __FishMouthAnchor
        }
    end, { p1, v5 })
end

local function v7(p2) -- line: 68
    -- upvalues: react (copy), createPortal (copy), useRootSelector (copy), useRootSelectorCreator (copy), fishDataByName (copy), isFishData (copy), selectInventoryFishLevel (copy), selectInventoryFishMutations (copy), selectPlayerGamepasses (copy), default (copy), default2 (copy), default3 (copy), getFishMoneyPerSecond (copy), v2 (copy), v3 (copy), v4 (copy), useAdornee (copy)
    local fishName, instance, isNaturalApexFish, itemId = p2.fishName, p2.instance, p2.isNaturalApexFish, p2.itemId
    local mutationsOverride = p2.mutationsOverride
    local v8 = useRootSelector(selectInventoryFishLevel(v2, itemId))

    if v8 == nil then
        v8 = 1
    end

    local v9 = useRootSelectorCreator(selectInventoryFishMutations, v2, itemId)
    local v10 = mutationsOverride or v9
    local v11 = useRootSelector(selectPlayerGamepasses(v2))
    local v12 = useAdornee(instance)

    if v12 == nil then
        return react.createElement(react.Fragment)
    end

    local v13 = fishDataByName[fishName]

    if v13 == nil then
        return react.createElement(react.Fragment)
    end

    local adornee = v12.adornee
    local v14 = if v12.mouthAnchor then Vector3.new(0, 3, 0) else Vector3.new(0, instance:GetExtentsSize().Y / 2 + 3, 0)
    local v16 = v10 or {}

    if isNaturalApexFish then
        return createPortal(react.createElement("billboardgui", {
            AlwaysOnTop = false,
            LightInfluence = 0,
            MaxDistance = 150,
            Size = UDim2.new(0, 160, 0, 50),
            StudsOffsetWorldSpace = v14
        }, react.createElement(default3, {
            text = "???",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                Font = Enum.Font.GothamBold,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center
            }
        })), adornee)
    end

    if not isFishData(v13) then
        return createPortal(react.createElement("billboardgui", {
            AlwaysOnTop = false,
            LightInfluence = 0,
            MaxDistance = 150,
            Size = UDim2.new(0, 160, 0, 50),
            StudsOffsetWorldSpace = v14
        }, react.createElement("textlabel", {
            BackgroundTransparency = 1,
            Text = "BONUS",
            TextScaled = true,
            TextStrokeTransparency = 0,
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromScale(1, 1),
            TextColor3 = v3,
            TextStrokeColor3 = v4,
            TextXAlignment = Enum.TextXAlignment.Center
        })), adornee)
    end

    local v17 = getFishMoneyPerSecond(v13.moneyPerSecond, v8, v16, v11)

    return react.createElement(react.Fragment, nil, react.createElement(default2, {
        model = instance,
        mutations = v16
    }), react.createElement(default, {
        adornee = adornee,
        level = v8,
        model = instance,
        moneyPerSecond = v17,
        mutations = v16,
        name = v13.displayName,
        rarity = v13.rarity
    }))
end

local v18 = react.memo(v7)

local function v19(p3) -- line: 147
    -- upvalues: react (copy), useRootSelector (copy), useRootSelectorCreator (copy), fishDataByName (copy), isFishData (copy), selectInventoryFishLevel (copy), selectInventoryFishMutations (copy), selectPlayerInventory (copy), selectPlayerInventoryItem (copy), selectPlayerGamepasses (copy), selectPlayerAquariumFishItems (copy), selectPlayerShowcaseFish (copy), default (copy), default2 (copy), getFishMoneyPerSecond (copy), getExclusiveFishEditionLabel (copy), getExclusiveFishMoneyPerSecondFromAquarium (copy), showcaseFishToMpsInput (copy), getExclusiveFishConfigByFishName (copy), v2 (copy), useAdornee (copy)
    local fishName, instance, itemId, mutationsOverride = p3.fishName, p3.instance, p3.itemId, p3.mutationsOverride
    local v20 = useRootSelector(selectInventoryFishLevel(v2, itemId))

    if v20 == nil then
        v20 = 1
    end

    local v21 = useRootSelectorCreator(selectInventoryFishMutations, v2, itemId)
    local v22 = mutationsOverride or v21
    local v23 = useRootSelector(selectPlayerInventoryItem(v2, itemId))
    local v24 = useRootSelectorCreator(selectPlayerAquariumFishItems, v2)
    local v25 = useRootSelector(selectPlayerInventory(v2))
    local v26 = useRootSelector(selectPlayerGamepasses(v2))
    local v28 = showcaseFishToMpsInput((useRootSelector(selectPlayerShowcaseFish(v2))))
    local v29 = useAdornee(instance)

    if v29 == nil then
        return react.createElement(react.Fragment)
    end

    local v30 = fishDataByName[fishName]
    local adornee, v31, v32

    if v30 ~= nil then
        if isFishData(v30) then
            adornee = v29.adornee
            v31 = v22 or {}
            v32 = false
        else
            v32 = true
        end
    else
        v32 = true
    end

    if v32 then
        return react.createElement(react.Fragment)
    end

    local v33 = getExclusiveFishConfigByFishName(fishName)
    local v34 = if v24 == nil then 0 else getExclusiveFishMoneyPerSecondFromAquarium(fishName, v24, v26, nil, nil, 0, v25, v28)

    if not (v34 > 0) then
        v34 = getFishMoneyPerSecond(v30.moneyPerSecond, v20, v31, v26)
    end

    local v35 = react.createElement(default2, {
        model = instance,
        mutations = v31
    })
    local t2 = {
        adornee = adornee
    }

    t2.exclusiveEditionLabel = getExclusiveFishEditionLabel(fishName, if (if v23 == nil then v23 else v23.itemType) == "fish" then v23.exclusiveIndex else nil)
    t2.exclusiveMpsMultiplier = if v33 ~= nil then v33.mpsMultiplier else v33
    t2.level = if (if v23 == nil then v23 else v23.itemType) == "fish" and v23.exclusiveIndex ~= nil then nil else v20
    t2.model = instance
    t2.moneyPerSecond = v34
    t2.mutations = v31
    t2.name = v30.displayName
    t2.rarity = v30.rarity

    return react.createElement(react.Fragment, nil, v35, react.createElement(default, t2))
end

local v36 = react.memo(v19)

local function v37(p4) -- line: 213
    -- upvalues: react (copy), getExclusiveFishConfigByFishName (copy), v18 (copy), v36 (copy)
    if getExclusiveFishConfigByFishName(p4.fishName) ~= nil then
        local v38 = table.clone(p4)

        setmetatable(v38, nil)

        return (react.createElement(v36, v38))
    end

    local v39 = table.clone(p4)

    setmetatable(v39, nil)

    return (react.createElement(v18, v39))
end

local function areFishBillboardRendererPropsEqual(p5, p6) -- line: 227
    if p5.fishName ~= p6.fishName or p5.instance ~= p6.instance or p5.isNaturalApexFish ~= p6.isNaturalApexFish or p5.itemId ~= p6.itemId then
        return false
    end

    local mutationsOverride = p5.mutationsOverride
    local mutationsOverride2 = p6.mutationsOverride

    if mutationsOverride ~= mutationsOverride2 then
        if mutationsOverride == nil or mutationsOverride2 == nil or #mutationsOverride ~= #mutationsOverride2 then
            return false
        end

        for v40, v41 in mutationsOverride do
            if v41 ~= mutationsOverride2[v40 - 1 + 1] then
                return false
            end
        end
    end

    return true
end

local v42 = react.memo(v37, areFishBillboardRendererPropsEqual)

return {
    default = function() -- FishingZoneFishManager | line: 257
        -- upvalues: react (copy), createPortal (copy), useFlameworkComponents (copy), useRootSelector (copy), useRootSelectorCreator (copy), selectPlayerFishingState (copy), selectNibbleActiveFishId (copy), v2 (copy), v42 (copy)
        local v43 = useFlameworkComponents(function() -- line: 258
            return true
        end, "client/components/fishing-zone-fish-component@FishingZoneFishComponent")
        local v44 = useFlameworkComponents(function() -- line: 261
            return true
        end, "client/components/toolbar-fish-component@ToolbarFishComponent")
        local v45 = useRootSelectorCreator(selectPlayerFishingState, v2)
        local v46 = (if v45 == nil then v45 else v45.fishingState) == "nibbling"

        if not v46 then
            v46 = (if v45 == nil then v45 else v45.fishingState) == "reeling"
        end

        local v47 = useRootSelector(selectNibbleActiveFishId)
        local v48 = not v46

        if v48 then
            v48 = table.create(#v43)

            local function v49(p7) -- line: 283
                -- upvalues: react (copy), v42 (copy)
                return react.createElement(v42, {
                    fishName = p7.attributes.fishName,
                    instance = p7.instance,
                    isNaturalApexFish = p7.attributes.isNaturalApexFish,
                    itemId = p7.instance.Name,
                    key = p7.instance:GetFullName()
                })
            end

            for v50, v51 in v43 do
                v48[v50] = v49(v51, v50 - 1, v43)
            end
        end

        local v52 = table.create(#v44)

        local function v53(p8) -- line: 300
            -- upvalues: react (copy), v42 (copy)
            return react.createElement(v42, {
                fishName = p8.attributes.fishName,
                instance = p8.instance,
                itemId = p8.attributes.itemId,
                key = p8.instance:GetFullName(),
                mutationsOverride = if p8.attributes.mutations == nil or p8.attributes.mutations == "" then {} else string.split(p8.attributes.mutations, ",")
            })
        end

        for v54, v55 in v44 do
            v52[v54] = v53(v55, v54 - 1, v44)
        end

        local v56 = v47 ~= nil

        if v56 then
            local t4 = {}
            local n1 = 0

            for v57, v58 in v43 do
                local _ = v57 - 1

                if v58.instance.Name == v47 == true then
                    n1 += 1
                    t4[n1] = v58
                end
            end

            v56 = table.create(#t4)

            local function v59(p9) -- line: 330
                -- upvalues: react (copy), createPortal (copy)
                return createPortal(react.createElement("highlight", {
                    FillTransparency = 0.5,
                    OutlineTransparency = 0,
                    FillColor = Color3.new(1, 1, 1),
                    OutlineColor = Color3.new(1, 1, 1)
                }), p9.instance)
            end

            for v60, v61 in t4 do
                v56[v60] = v59(v61, v60 - 1, t4)
            end
        end

        return react.createElement(react.Fragment, nil, v48, v52, v56)
    end
}
