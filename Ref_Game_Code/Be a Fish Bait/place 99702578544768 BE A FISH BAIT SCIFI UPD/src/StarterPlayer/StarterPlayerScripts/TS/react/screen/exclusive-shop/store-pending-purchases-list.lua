-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "list-scrolling-frame").default
local getBorderThickness = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getBorderThickness
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectPlayerPurchaseHistory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerPurchaseHistory
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-utils")
local getProductConfigurationByProductId, isPendingPurchaseConfirmedFailed = v1.getProductConfigurationByProductId, v1.isPendingPurchaseConfirmedFailed
local getStoreProductDisplayInfo = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "store-display-utils").getStoreProductDisplayInfo

return {
    default = function(p1) -- StorePendingPurchasesList | line: 17
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), getBorderThickness (copy), useScreenSizeState (copy), useRootSelector (copy), selectPlayerPurchaseHistory (copy), localPlayerUserId (copy), getProductConfigurationByProductId (copy), isPendingPurchaseConfirmedFailed (copy), getStoreProductDisplayInfo (copy)
        local md = getBorderThickness(useScreenSizeState(), "md")
        local v3 = useRootSelector(selectPlayerPurchaseHistory(localPlayerUserId))
        local v4 = useRootSelector(function(p2) -- line: 21
            return p2.storePurchase.inFlightRetryProductIds
        end)
        local v5 = v3 or {}
        local t1 = {}
        local n1 = 0

        for v6, v7 in v5 do
            local _ = v6 - 1

            if (v4[v7.productId] == nil or isPendingPurchaseConfirmedFailed(v7.timeBought)) == true then
                n1 += 1
                t1[n1] = v7
            end
        end

        local v8 = react.createElement(default2, {
            hasStroke = true,
            text = "Pending Purchases",
            overrideProps = {
                ZIndex = 101,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.04),
                Size = UDim2.fromScale(0.9, 0.1)
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        })
        local v9

        if #t1 == 0 then
            v9 = react.createElement(default2, {
                hasStroke = true,
                text = "No pending purchases.",
                overrideProps = {
                    TextWrapped = true,
                    ZIndex = 101,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.45),
                    Size = UDim2.fromScale(0.85, 0.2)
                },
                textColor3 = Color3.fromRGB(220, 220, 220)
            })
        else
            local v10 = table.create(#t1)

            local function v11(p3) -- line: 76
                -- upvalues: p1 (copy), md (copy), react (copy), default (copy), default2 (copy), default3 (copy), getProductConfigurationByProductId (copy), getStoreProductDisplayInfo (copy)
                local v12 = getProductConfigurationByProductId(p3.productId)

                if v12.kind == "error" then
                    warn("[src/client/react/screen/exclusive-shop/store-pending-purchases-list.tsx:91]", (("[StorePendingPurchasesList DEBUG] productId %* (purchaseId %*, timeBought %*) has no storeProducts entry."):format(p3.productId, p3.purchaseId, p3.timeBought)))
                end

                local v13 = if v12.kind == "success" then getStoreProductDisplayInfo({
                    storeProductConfiguration = v12.data
                }).title else "Unknown Item"

                return react.createElement(default3, {
                    cornerRadius = 12,
                    borderThickness = md,
                    key = p3.purchaseId,
                    onClick = function() -- onClick | line: 90
                        -- upvalues: p3 (copy), p1 (copy)
                        return p1.onRetry(p3.productId)
                    end,
                    size = UDim2.fromScale(1, 0.28)
                }, react.createElement(default, {
                    cornerRadius = 12,
                    anchorPoint = Vector2.new(0.5, 0.5),
                    backgroundColor3 = Color3.fromRGB(60, 60, 80),
                    borderColor3 = Color3.fromRGB(0, 0, 0),
                    borderThickness = md,
                    position = UDim2.fromScale(0.5, 0.5),
                    size = UDim2.fromScale(1, 1)
                }, react.createElement(default2, {
                    hasStroke = true,
                    overrideProps = {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromScale(0.9, 0.6)
                    },
                    text = ("Retry: %*"):format(v13),
                    textColor3 = Color3.fromRGB(255, 255, 255)
                })))
            end

            for v14, v15 in t1 do
                v10[v14] = v11(v15, v14 - 1, t1)
            end

            v9 = react.createElement(default4, {
                itemPaddingScale = 0.03,
                zIndex = 101,
                anchorPoint = Vector2.new(0.5, 0),
                canvasHeightScale = math.max(1, #t1 * 0.32),
                position = UDim2.fromScale(0.5, 0.16),
                size = UDim2.fromScale(0.9, 0.64)
            }, v10)
        end

        return react.createElement(default, {
            backgroundTransparency = 0.05,
            cornerRadius = 20,
            zIndex = 100,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(20, 20, 30),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = md,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.36, 0.46)
        }, v8, v9, react.createElement(default3, {
            cornerRadius = 15,
            zIndex = 101,
            anchorPoint = Vector2.new(0.5, 1),
            borderThickness = md,
            onClick = p1.onClose,
            position = UDim2.fromScale(0.5, 0.95),
            size = UDim2.fromScale(0.45, 0.12)
        }, react.createElement(default, {
            cornerRadius = 15,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(255, 80, 120),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = md,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            hasStroke = true,
            text = "Close",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.85, 0.6)
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        }))))
    end
}
