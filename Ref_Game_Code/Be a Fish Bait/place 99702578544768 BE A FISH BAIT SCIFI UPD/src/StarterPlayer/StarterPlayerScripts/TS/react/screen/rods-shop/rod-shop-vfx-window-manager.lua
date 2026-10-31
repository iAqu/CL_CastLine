-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = react.useCallback
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local fishReelbackVfxData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish-reelback-vfx").fishReelbackVfxData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local selectPlayerFishReelbackVfx = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerFishReelbackVfx
local default = RuntimeLib.import(script, script.Parent, "rod-shop-vfx").default

return {
    default = function() -- RodShopVfxWindowManager | line: 15
        -- upvalues: react (copy), useCallback (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), localPlayerUserId (copy), fishReelbackVfxData (copy), images (copy), selectPlayerFishReelbackVfx (copy), default (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerFishReelbackVfx(localPlayerUserId))
        local t1 = {}

        for v3, v4 in fishReelbackVfxData do
            local t2 = {
                description = v4.description,
                displayName = v4.displayName,
                imageId = images.reelbackVfxIcon
            }
            local v5 = if v2 == nil then v2 else table.find(v2.ownedVfxIds, v3) ~= nil

            t2.isOwned = v5 ~= nil and v5
            t2.vfxId = v3
            table.insert(t1, t2)
        end

        local v6 = useCallback(function() -- line: 38
            -- upvalues: v1 (copy)
            return v1.windowClosed({})
        end, { v1 })
        local v7 = useCallback(function(p1) -- line: 41
            -- upvalues: v1 (copy)
            v1.windowOpened({
                currentWindow = if p1 == "rods" then "rodsShop" elseif p1 == "skin" then "rodSkins" else "rodShopVfx"
            })
        end, { v1 })
        local v8 = useCallback(function(p2) -- line: 46
            -- upvalues: functions (copy)
            functions.setFishReelbackVfx(p2):andThen(function(p3) -- line: 47
                -- upvalues: p2 (copy)
                if not p3 then
                    warn("[src/client/react/screen/rods-shop/rod-shop-vfx-window-manager.tsx:41]", (("Fish Reelback VFX equip request rejected for \"%*\"."):format(p2)))
                end
            end):catch(function(p4) -- line: 51
                return warn("[src/client/react/screen/rods-shop/rod-shop-vfx-window-manager.tsx:43]", (("Fish Reelback VFX equip request failed: %*"):format(p4)))
            end)
        end, {})
        local v9 = useCallback(function() -- line: 55
            -- upvalues: functions (copy)
            functions.setFishReelbackVfx(nil):andThen(function(p5) -- line: 56
                if not p5 then
                    warn("[src/client/react/screen/rods-shop/rod-shop-vfx-window-manager.tsx:49]", "Fish Reelback VFX unequip request was rejected.")
                end
            end):catch(function(p6) -- line: 60
                return warn("[src/client/react/screen/rods-shop/rod-shop-vfx-window-manager.tsx:51]", (("Fish Reelback VFX unequip request failed: %*"):format(p6)))
            end)
        end, {})

        if v2 ~= nil then
            v2 = v2.equippedVfxId
        end

        local t4 = {
            equippedVfxId = v2,
            onClose = v6,
            onEquip = v8,
            onSelectTab = v7,
            onUnequip = v9,
            vfxItems = t1
        }

        return react.createElement(default, t4)
    end
}
