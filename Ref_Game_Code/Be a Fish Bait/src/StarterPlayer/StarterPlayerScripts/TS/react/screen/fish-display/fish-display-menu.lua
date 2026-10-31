-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useState = react.useEffect, react.useMemo, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local default6 = RuntimeLib.import(script, script.Parent, "fish-display-menu-item").default
local default7 = RuntimeLib.import(script, script.Parent, "hologram-skin-menu-item").default

local function TabButton(p1) -- line: 16
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default4 (copy)
    local isActive, label, onClick = p1.isActive, p1.label, p1.onClick
    local v2, v3 = useMotion(if isActive then 1.05 else 1)

    useEffect(function() -- line: 21
        -- upvalues: isActive (copy), v3 (copy)
        v3:tween(isActive and 1.05 or 1, {
            time = 0.2,
            style = Enum.EasingStyle.Quad,
            direction = Enum.EasingDirection.Out
        })
    end, { isActive, v3 })

    local v5 = UDim2.fromScale(0.35, 1)
    local v6 = v2:map(function(p2) -- line: 29
        -- upvalues: v5 (copy)
        return UDim2.new(v5.X.Scale * p2, 0, v5.Y.Scale * p2, 0)
    end)
    local v7 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 224, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 99, 227))
    })
    local v8 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
    })
    local v9 = label == "STANDS"
    local v10

    if v9 then
        v10 = Color3.fromRGB(90, 10, 10)
    else
        v8 = v7
        v10 = Color3.fromRGB(30, 35, 55)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 20,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = v6
    }, react.createElement(default4, {
        zIndex = 20,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v8,
        frameSize = UDim2.fromScale(1, 1),
        label = label,
        onClick = onClick,
        popoutColor = v10,
        position = UDim2.fromScale(0.5, 0.5),
        strokeColor = if v9 then Color3.new(1, 1, 1) else nil
    }))
end

return {
    default = function(p3) -- FishDisplayMenu | line: 55
        -- upvalues: react (copy), useMemo (copy), useState (copy), default (copy), default2 (copy), default3 (copy), default5 (copy), default6 (copy), default7 (copy), TabButton (copy)
        local fish, hologramSkins, onClose, onEquipHologramSkin = p3.fish, p3.hologramSkins, p3.onClose, p3.onEquipHologramSkin
        local onSelectFish, selectedFishId = p3.onSelectFish, p3.selectedFishId
        local fishes, fishes2 = useState("fishes")
        local v11 = fishes == "fishes"
        local v12

        for v13, v14 in fish do
            local _ = v13 - 1

            if v14.fishId == selectedFishId == true then
                v12 = v14
                break
            end

            v12 = nil
        end

        if v12 ~= nil then
            v12 = v12.fishName
        end

        if v12 == nil then
            v12 = "None"
        end

        local v15 = useState(function() -- line: 88
            -- upvalues: fish (copy), selectedFishId (copy)
            local v16 = table.create(#fish)

            local function v17(p4) -- line: 91
                return p4.fishId
            end

            for v18, v19 in fish do
                local _ = v18 - 1

                v16[v18] = v19.fishId
            end

            if selectedFishId == nil or table.find(v16, selectedFishId) == nil then
                return v16
            end

            local t3 = {
                selectedFishId
            }
            local v20 = #t3
            local t4 = {}
            local n1 = 0

            for v21, v22 in v16 do
                local _ = v21 - 1

                if v22 ~= selectedFishId == true then
                    n1 += 1
                    t4[n1] = v22
                end
            end

            table.move(t4, 1, #t4, v20 + 1, t3)

            return t3
        end)
        local v23 = useMemo(function() -- line: 123
            -- upvalues: fish (copy)
            local t5 = {}

            for v24, v25 in fish do
                local _ = v24 - 1

                t5[v25.fishId] = v25
            end

            return t5
        end, { fish })
        local v26 = useMemo(function() -- line: 138
            -- upvalues: fish (copy), v15 (copy), v23 (copy)
            local t6 = {}
            local t7 = {}

            for v27, v28 in v15 do
                local _ = v27 - 1
                local v29 = v23[v28]

                if v29 ~= nil then
                    table.insert(t6, v29)
                    t7[v28] = true
                end
            end

            for v30, v31 in fish do
                local _ = v30 - 1

                if t7[v31.fishId] == nil then
                    table.insert(t6, v31)
                end
            end

            return t6
        end, { fish, v23, v15 })
        local v32 = table.create(#v26)

        local function v33(p5, p6) -- line: 171
            -- upvalues: onSelectFish (copy), selectedFishId (copy), react (copy), default6 (copy)
            return react.createElement(default6, {
                fishId = p5.fishId,
                fishName = p5.fishName,
                imageId = p5.imageId,
                isActive = p5.fishId == selectedFishId,
                key = p5.fishId,
                layoutOrder = p6,
                level = p5.level,
                moneyPerSecond = p5.moneyPerSecond,
                mutation = p5.mutation,
                offlineEarningPerSec = p5.offlineEarningPerSec,
                onClick = function() -- onClick | line: 183
                    -- upvalues: p5 (copy), onSelectFish (copy)
                    return onSelectFish(p5.fishId)
                end,
                rarity = p5.rarity
            })
        end

        for v34, v35 in v26 do
            v32[v34] = v33(v35, v34 - 1, v26)
        end

        local v36 = table.create(#hologramSkins)

        local function v37(p7, p8) -- line: 196
            -- upvalues: onEquipHologramSkin (copy), react (copy), default7 (copy)
            return react.createElement(default7, {
                displayName = p7.displayName,
                imageId = p7.imageId,
                isActive = p7.isActive,
                key = p7.skinName,
                layoutOrder = p8,
                onClick = function() -- onClick | line: 203
                    -- upvalues: p7 (copy), onEquipHologramSkin (copy)
                    warn("[src/client/react/screen/fish-display/fish-display-menu.tsx:146]", "equipClicked", p7.skinName)
                    onEquipHologramSkin(p7.skinName)
                end,
                rarity = p7.rarity,
                skinName = p7.skinName
            })
        end

        for v38, v39 in hologramSkins do
            v36[v38] = v37(v39, v38 - 1, hologramSkins)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.841, 0.55),
            Size = UDim2.fromScale(0.275, 0.75)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 0.65,
            DominantAxis = Enum.DominantAxis.Width
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 20,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0, -0.025),
            Size = UDim2.fromScale(1, 0.06)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.04, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        }), react.createElement(TabButton, {
            label = "FISHES",
            isActive = v11,
            onClick = function() -- onClick | line: 241
                -- upvalues: fishes2 (copy)
                return fishes2("fishes")
            end
        }), react.createElement(TabButton, {
            label = "STANDS",
            isActive = not v11,
            onClick = function() -- onClick | line: 247
                -- upvalues: fishes2 (copy)
                return fishes2("stands")
            end
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        }), react.createElement(default, {
            cornerRadius = 0.025,
            isStudded = true,
            strokeThickness = 0.005,
            textureTransparency = 0.9,
            transparency = 0.5,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor = Color3.fromRGB(55, 65, 90),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(80, 95, 130)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.015),
            Size = UDim2.fromScale(0.94, 0.13)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(0.82, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default3, {
            text = "FISH DISPLAY",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                LayoutOrder = 0,
                TextScaled = true,
                ZIndex = 6,
                Font = Enum.Font.GothamBlack,
                Size = UDim2.fromScale(1, 0.52),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        }), v11 and react.createElement("textlabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            TextScaled = true,
            ZIndex = 6,
            Font = Enum.Font.GothamBold,
            Size = UDim2.fromScale(0.9, 0.32),
            Text = ("Displayed: %*"):format(v12),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left
        }, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.fromRGB(0, 0, 0)
        }))), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 6,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromScale(0.12, 0.85)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement(default2, {
            cornerRadius = 0.15,
            zIndex = 7,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 43, 43),
            onClick = onClose,
            popoutColor = Color3.fromRGB(122, 31, 31),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(255, 179, 179)
        }, react.createElement(default3, {
            shadowYScale = 0.08,
            text = "X",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 9,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBlack,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.7, 0.7)
            }
        })))), if v11 then react.createElement(default5, {
            cellsPerRow = 1,
            clipsDescendants = true,
            listPaddingOffset = 6,
            rowsToBeVisible = 4.5,
            scrollBarThickness = 4,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 0),
            fillDirection = Enum.FillDirection.Horizontal,
            position = UDim2.fromScale(0.5, 0.165),
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            size = UDim2.fromScale(0.94, 0.8),
            verticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        }, v32) else react.createElement(default5, {
            cellsPerRow = 1,
            clipsDescendants = true,
            listPaddingOffset = 6,
            rowsToBeVisible = 4.5,
            scrollBarThickness = 4,
            zIndex = 5,
            anchorPoint = Vector2.new(0.5, 0),
            fillDirection = Enum.FillDirection.Horizontal,
            position = UDim2.fromScale(0.5, 0.165),
            scrollBarColor = Color3.fromRGB(10, 10, 10),
            size = UDim2.fromScale(0.94, 0.8),
            verticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        }, v36))), react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 15,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        }), react.createElement("uistroke", {
            Thickness = 0.005,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(59, 59, 59),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })))
    end
}
