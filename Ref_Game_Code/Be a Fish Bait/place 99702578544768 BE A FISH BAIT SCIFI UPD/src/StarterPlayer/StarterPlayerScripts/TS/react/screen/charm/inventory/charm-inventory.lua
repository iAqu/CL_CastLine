-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local getCharmTierIdForVisualId, getCharmTierKey = v1.getCharmTierIdForVisualId, v1.getCharmTierKey
local charms = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charms")
local charmData, charmOrder = charms.charmData, charms.charmOrder
local default = RuntimeLib.import(script, script.Parent.Parent, "charm-card").default

return {
    default = function(p1) -- CharmInventory | line: 22
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), getCharmTierIdForVisualId (copy), getCharmTierKey (copy), charmData (copy), charmOrder (copy), default (copy)
        local v2 = useRef()
        local v3, v4 = useState(0)
        local t1 = {}

        for _, v5 in charmOrder do
            local v6 = charmData[v5]
            local v7 = v6 ~= nil

            if v7 then
                local ownedCharmIds = p1.ownedCharmIds
                local id = v6.id

                v7 = table.find(ownedCharmIds, id) ~= nil
            end

            if v7 then
                table.insert(t1, v6)
            end
        end

        local t2 = {}
        local n1 = 0

        for v8, v9 in t1 do
            local _ = v8 - 1

            if (p1.selectedRarity == "all" or v9.rarity == p1.selectedRarity) == true then
                n1 += 1
                t2[n1] = v9
            end
        end

        local v10 = if #t1 == 0 then "No Charms owned yet. Visit the Shop to get one!" else ("No %* Charms."):format(if p1.selectedRarity == "all" then "owned" else string.upper(p1.selectedRarity))
        local v11 = #t2 > 0
        local v14 = math.max(1, (math.ceil(#t2 / 2))) * 1 + 0.1
        local v15 = v3 * math.max(1, v14)
        local v16 = v3 * 1
        local v17 = v3 * 0.035
        local v18 = v3 * 0.02
        local v19 = v3 * 0.1
        local v20 = UDim2.new(0.46, 0, 0, v16)
        local v21 = UDim2.new(0.025, 0, 0, v17)

        useEffect(function() -- line: 64
            -- upvalues: v2 (copy), v4 (copy)
            local current = v2.current

            if current ~= nil then
                v4(current.AbsoluteSize.Y)
            end
        end, {})
        useEffect(function() -- line: 70
            -- upvalues: v14 (copy)
            print((("[CharmInventory] gridContentHeightScale: %*"):format(v14)))
        end, { v14 })

        local v22

        if not v11 then
            v22 = react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.22),
                Text = v10,
                TextColor3 = Color3.fromRGB(225, 233, 242)
            })

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, v22)
        end

        local v23 = react.createElement("uipadding", {
            PaddingBottom = UDim.new(0, v19),
            PaddingLeft = UDim.new(0.02, 0),
            PaddingRight = UDim.new(0.02, 0),
            PaddingTop = UDim.new(0, v18)
        })
        local v24 = react.createElement("uigridlayout", {
            FillDirectionMaxCells = 2,
            CellPadding = v21,
            CellSize = v20,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
        local v25 = table.create(#t2)

        local function v26(p2, p3) -- line: 92
            -- upvalues: p1 (copy), react (copy), getCharmTierIdForVisualId (copy), getCharmTierKey (copy), default (copy)
            local v27 = getCharmTierIdForVisualId(p2.id)
            local v28 = if v27 == nil then nil else p1.charmCoresByTier[getCharmTierKey(v27)]
            local v29 = p1.displayedCharmId == p2.id
            local v30 = p1.equippedAttributesCharmId == p2.id

            return react.createElement(default, {
                core = v28,
                data = p2,
                isAttributesEquipped = v30,
                isSkinEquipped = v29,
                key = p2.id,
                layoutOrder = p3,
                onAttributesAction = function() -- onAttributesAction | line: 112
                    -- upvalues: p2 (copy), v30 (copy), p1 (copy)
                    if v30 then
                        return (p1.onUnequipAttributes())
                    end

                    return (p1.onEquipAttributes(p2.id))
                end,
                onSkinAction = function() -- onSkinAction | line: 115
                    -- upvalues: p2 (copy), v29 (copy), p1 (copy)
                    if v29 then
                        return (p1.onUnequipSkin())
                    end

                    return (p1.onEquipSkin(p2.id))
                end
            })
        end

        for v31, v32 in t2 do
            v25[v31] = v26(v32, v31 - 1, t2)
        end

        v22 = react.createElement("scrollingframe", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ScrollBarThickness = 4,
            CanvasSize = UDim2.fromOffset(0, v15),
            Change = {
                AbsoluteSize = function(p4) -- AbsoluteSize | line: 129
                    -- upvalues: v4 (copy)
                    return v4(p4.AbsoluteSize.Y)
                end
            },
            Position = UDim2.fromScale(0, 0),
            ScrollBarImageColor3 = Color3.fromRGB(97, 211, 232),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Size = UDim2.fromScale(1, 1),
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
            ref = v2
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.new(1, 0, 0, v15)
        }, v23, v24, v25))

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v22)
    end
}
