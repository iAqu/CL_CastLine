-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useRootSelector = RuntimeLib.import(script, script.Parent, "reflex").useRootSelector
local useOwnsGamepass = RuntimeLib.import(script, script.Parent, "use-owns-gamepass").useOwnsGamepass
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerAquarium, selectPlayerBundlePurchaseHistory, selectPlayerOwnedMountNames = selectors.selectPlayerAquarium, selectors.selectPlayerBundlePurchaseHistory, selectors.selectPlayerOwnedMountNames
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId

return {
    useIsGiftMode = function() -- useIsGiftMode | line: 11
        -- upvalues: useRootSelector (copy)
        return useRootSelector(function(p1) -- line: 12
            return p1.storeGiftUi.recipientUserId
        end) ~= nil
    end,
    useGiftableOwnsGamepass = function(p2) -- useGiftableOwnsGamepass | line: 22
        -- upvalues: useRootSelector (copy), useOwnsGamepass (copy)
        local v1 = useRootSelector(function(p3) -- line: 12
            return p3.storeGiftUi.recipientUserId
        end) ~= nil
        local v2 = useRootSelector(function(p4) -- line: 24
            return p4.storeGiftUi.recipientOwnership
        end)
        local v3 = useOwnsGamepass(p2)

        if not v1 then
            return v3
        end

        if v2 ~= nil then
            local ownedGamepassNames = v2.ownedGamepassNames

            v2 = table.find(ownedGamepassNames, p2) ~= nil
        end

        if v2 == nil then
            v2 = false
        end

        return v2
    end,
    useGiftableOwnsBundle = function(p5) -- useGiftableOwnsBundle | line: 43
        -- upvalues: useRootSelector (copy), selectPlayerBundlePurchaseHistory (copy), localPlayerUserId (copy)
        local v4 = useRootSelector(function(p6) -- line: 12
            return p6.storeGiftUi.recipientUserId
        end) ~= nil
        local v5 = useRootSelector(function(p7) -- line: 45
            return p7.storeGiftUi.recipientOwnership
        end)
        local v6 = useRootSelector(selectPlayerBundlePurchaseHistory(localPlayerUserId))

        if v4 then
            if v5 ~= nil then
                local ownedBundleNames = v5.ownedBundleNames

                v5 = table.find(ownedBundleNames, p5) ~= nil
            end

            if v5 == nil then
                v5 = false
            end

            return v5
        end

        if v6 ~= nil then
            local v7 = false

            for v8, v9 in v6 do
                local _ = v8 - 1

                if v9.bundleName == p5 then
                    v7 = true
                    break
                end
            end

            v6 = v7
        end

        if v6 == nil then
            v6 = false
        end

        return v6
    end,
    useGiftableOwnsAquariumSkin = function(p8) -- useGiftableOwnsAquariumSkin | line: 84
        -- upvalues: useRootSelector (copy), selectPlayerAquarium (copy), localPlayerUserId (copy)
        local v10 = useRootSelector(function(p9) -- line: 12
            return p9.storeGiftUi.recipientUserId
        end) ~= nil
        local v11 = useRootSelector(function(p10) -- line: 86
            return p10.storeGiftUi.recipientOwnership
        end)
        local v12 = useRootSelector(selectPlayerAquarium(localPlayerUserId))

        if v10 then
            if v11 ~= nil then
                local ownedAquariumSkins = v11.ownedAquariumSkins

                v11 = table.find(ownedAquariumSkins, p8) ~= nil
            end

            if v11 == nil then
                v11 = false
            end

            return v11
        end

        if v12 ~= nil then
            local ownedSkins = v12.ownedSkins

            v12 = table.find(ownedSkins, p8) ~= nil
        end

        if v12 == nil then
            v12 = false
        end

        return v12
    end,
    useGiftableOwnsMountFish = function(p11) -- useGiftableOwnsMountFish | line: 115
        -- upvalues: useRootSelector (copy), selectPlayerOwnedMountNames (copy), localPlayerUserId (copy)
        local v13 = useRootSelector(function(p12) -- line: 12
            return p12.storeGiftUi.recipientUserId
        end) ~= nil
        local v14 = useRootSelector(function(p13) -- line: 117
            return p13.storeGiftUi.recipientOwnership
        end)
        local v15 = useRootSelector(selectPlayerOwnedMountNames(localPlayerUserId))

        if not v13 then
            return table.find(v15, p11) ~= nil
        end

        if v14 ~= nil then
            local ownedMountNames = v14.ownedMountNames

            v14 = table.find(ownedMountNames, p11) ~= nil
        end

        if v14 == nil then
            v14 = false
        end

        return v14
    end
}
