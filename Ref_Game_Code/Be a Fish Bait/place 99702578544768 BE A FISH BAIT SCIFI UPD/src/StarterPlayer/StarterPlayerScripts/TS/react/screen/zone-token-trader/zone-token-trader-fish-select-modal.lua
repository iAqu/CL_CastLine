-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback, useMemo, useState = react.useCallback, react.useMemo, react.useState
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local selectPlayerInventory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerInventory
local fish = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish")
local fishDataByName, isFishData = fish.fishDataByName, fish.isFishData
local getExclusiveFishConfigByFishName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "exclusive-fish").getExclusiveFishConfigByFishName
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "zone-token-trader")
local getTokensForFish, getTokenTypeForRarity, zoneTokenDisplayNames = v1.getTokensForFish, v1.getTokenTypeForRarity, v1.zoneTokenDisplayNames
local default5 = RuntimeLib.import(script, script.Parent, "zone-token-trader-fish-card").default
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 190, 50))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 195, 185)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 145, 135))
})

return {
    default = function(p1) -- ZoneTokenTraderFishSelectModal | line: 32
        -- upvalues: react (copy), useCallback (copy), useMemo (copy), useState (copy), HttpService (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useRootProducer (copy), useRootSelector (copy), useTheme (copy), useScreenSizeState (copy), functions (copy), localPlayerUserId (copy), selectPlayerInventory (copy), fishDataByName (copy), isFishData (copy), getExclusiveFishConfigByFishName (copy), getTokensForFish (copy), getTokenTypeForRarity (copy), zoneTokenDisplayNames (copy), default5 (copy), v2 (copy), v3 (copy)
        local v4 = useTheme()
        local v5 = useRootProducer()
        local v6 = useScreenSizeState()
        local v7 = if v6 == "sm" then 4 elseif v6 == "md" then 7 else 10
        local v8 = useRootSelector(selectPlayerInventory(localPlayerUserId))
        local v9, v10 = useState({})
        local v11 = useMemo(function() -- line: 39
            -- upvalues: p1 (copy), v8 (copy), fishDataByName (copy), isFishData (copy), getExclusiveFishConfigByFishName (copy), getTokensForFish (copy), getTokenTypeForRarity (copy)
            if not v8 then
                return {}
            end

            local t1 = {}

            for _, v12 in v8 do
                if v12.itemType == "fish" and v12.exclusiveIndex == nil and not getExclusiveFishConfigByFishName(v12.itemName) then
                    local v13 = fishDataByName[v12.itemName]

                    if v13 and isFishData(v13) and getTokenTypeForRarity(v13.rarity) == p1.tokenType then
                        table.insert(t1, {
                            imageId = v13.imageId,
                            itemId = v12.itemId,
                            mutationCount = #v12.mutations,
                            name = v13.displayName,
                            tokens = getTokensForFish(v13.rarity, #v12.mutations)
                        })
                    end
                end
            end

            return t1
        end, {
            v8,
            p1.tokenType
        })
        local v14 = useMemo(function() -- line: 70
            -- upvalues: v9 (copy), v11 (copy)
            local n1 = 0

            for _, v15 in v11 do
                local itemId = v15.itemId

                if table.find(v9, itemId) ~= nil then
                    n1 += v15.tokens
                end
            end

            return n1
        end, { v11, v9 })
        local v16 = useCallback(function(p2) -- line: 80
            -- upvalues: v10 (copy)
            v10(function(p3) -- line: 81
                -- upvalues: p2 (copy)
                local itemId = p2.itemId

                if table.find(p3, itemId) == nil then
                    local t3 = {}
                    local v17 = #t3
                    local v18 = #p3

                    table.move(p3, 1, v18, v17 + 1, t3)
                    t3[v17 + v18 + 1] = p2.itemId

                    return t3
                end

                local t4 = {}
                local n2 = 0

                for v19, v20 in p3 do
                    local _ = v19 - 1

                    if v20 ~= p2.itemId == true then
                        n2 += 1
                        t4[n2] = v20
                    end
                end

                return t4
            end)
        end, {})
        local v21 = useCallback(function() -- line: 112
            -- upvalues: p1 (copy), v5 (copy), v9 (copy), v10 (copy), HttpService (copy), functions (copy), zoneTokenDisplayNames (copy)
            if #v9 == 0 then
                return nil
            end

            functions.exchangeFishForTokens(v9, p1.tokenType):andThen(function(p4) -- line: 116
                -- upvalues: p1 (copy), v5 (copy), v10 (copy), HttpService (copy), zoneTokenDisplayNames (copy)
                if p4 == false then
                    v5.onScreenFeedbackAdded({
                        message = "Failed to exchange fish for tokens.",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })

                    return nil
                end

                v10({})
                v5.onScreenFeedbackAdded({
                    type = "success",
                    id = HttpService:GenerateGUID(false),
                    message = ("Exchanged for %* %*!"):format(p4, zoneTokenDisplayNames[p1.tokenType])
                })
            end)
        end, {
            v5,
            p1.tokenType,
            v9
        })
        local v22 = react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 53,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.06),
            Size = UDim2.fromScale(0.95, 0.06)
        }, react.createElement(default2, {
            text = "Note: Mutations give more Tokens!",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 53,
                Font = v4.textFont2,
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        }))
        local v23 = table.create(#v11)

        local function v24(p5, p6) -- line: 153
            -- upvalues: v9 (copy), v16 (copy), react (copy), default5 (copy)
            local t5 = {
                imageId = p5.imageId
            }
            local itemId = p5.itemId

            t5.isSelected = table.find(v9, itemId) ~= nil
            t5.key = p5.itemId
            t5.layoutOrder = p6
            t5.mutationCount = p5.mutationCount
            t5.name = p5.name

            t5.onClick = function() -- line: 163
                -- upvalues: p5 (copy), v16 (copy)
                return v16(p5)
            end

            t5.tokens = p5.tokens

            return react.createElement(default5, t5)
        end

        for v25, v26 in v11 do
            v23[v25] = v24(v26, v25 - 1, v11)
        end

        return react.createElement("textbutton", {
            Active = true,
            AutoButtonColor = false,
            BackgroundTransparency = 0.25,
            BorderSizePixel = 0,
            Modal = true,
            Text = "",
            ZIndex = 40,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Event = {
                Activated = function() -- Activated | line: 180
                end
            },
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            aspectRatio = 1.1,
            zIndexOffset = 50,
            bodyBg = Color3.fromRGB(18, 18, 22),
            headerBg = Color3.fromRGB(150, 140, 145),
            onClose = p1.onClose,
            size = UDim2.fromScale(0.6, 0.7),
            title = ("Select Fishes to Trade for \"%*\""):format(zoneTokenDisplayNames[p1.tokenType]),
            titleNode = react.createElement("frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1)
            }, react.createElement(default2, {
                color = Color3.new(1, 1, 1),
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 21,
                    Font = v4.textFont2,
                    Position = UDim2.fromScale(0, 0),
                    Size = UDim2.fromScale(1, 0.5),
                    TextXAlignment = Enum.TextXAlignment.Right
                },
                text = ("%* you will earn:"):format(zoneTokenDisplayNames[p1.tokenType])
            }), react.createElement(default2, {
                color = v2,
                overrideProps = {
                    TextScaled = true,
                    ZIndex = 21,
                    Font = v4.textFont2,
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.fromScale(1, 0.5),
                    TextXAlignment = Enum.TextXAlignment.Right
                },
                text = ("%*"):format(v14)
            }))
        }, v22, react.createElement(default4, {
            cellsPerRow = 5,
            listPaddingOffset = 10,
            rowsToBeVisible = 3,
            zIndex = 52,
            anchorPoint = Vector2.new(0.5, 0),
            fillDirection = Enum.FillDirection.Horizontal,
            padding = {
                all = UDim.new(0, 10)
            },
            position = UDim2.fromScale(0.5, 0.14),
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            scrollBarThickness = v7,
            size = UDim2.fromScale(0.97, 0.72)
        }, v23), react.createElement(default3, {
            isStudded = true,
            label = "EXCHANGE",
            zIndex = 53,
            anchorPoint = Vector2.new(0.5, 1),
            color = v3,
            disabled = #v9 == 0,
            font = v4.textFont2,
            frameSize = UDim2.fromScale(0.4, 0.1),
            onClick = v21,
            position = UDim2.fromScale(0.5, 0.98)
        })))
    end
}
