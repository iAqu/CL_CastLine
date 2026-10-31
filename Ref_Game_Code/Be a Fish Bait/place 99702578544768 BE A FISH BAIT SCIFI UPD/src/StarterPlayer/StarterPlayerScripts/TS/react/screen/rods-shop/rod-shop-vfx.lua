-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "scrolling-frame").default
local default6 = RuntimeLib.import(script, script.Parent, "rod-shop-tabs").default
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 210, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 80, 210))
})
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 235, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 155, 65))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(185, 35, 30))
})
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 145, 145)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))
})
local RodShopVfxItem

local function RodShopVfx(p1) -- line: 15
    -- upvalues: react (copy), default2 (copy), default5 (copy), default6 (copy), v1 (copy), RodShopVfxItem (ref)
    local v5 = react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1.4
    })
    local vfxItems = p1.vfxItems
    local v6 = table.create(#vfxItems)

    local function v7(p2, p3) -- line: 22
        -- upvalues: p1 (copy), react (copy), RodShopVfxItem (ref)
        return react.createElement(RodShopVfxItem, {
            data = p2,
            isEquipped = p1.equippedVfxId == p2.vfxId,
            key = p2.vfxId,
            layoutOrder = p3,
            onEquip = function() -- onEquip | line: 28
                -- upvalues: p2 (copy), p1 (copy)
                return p1.onEquip(p2.vfxId)
            end,
            onUnequip = p1.onUnequip
        })
    end

    for v8, v9 in vfxItems do
        v6[v8] = v7(v9, v8 - 1, vfxItems)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.8, 0.55)
    }, v5, react.createElement(default2, {
        title = "Fish Landing VFX",
        bodyBg = Color3.fromRGB(0, 0, 0),
        headerBg = v1,
        onClose = p1.onClose,
        size = UDim2.fromScale(1, 1)
    }, react.createElement(default5, {
        cellsPerRow = 1,
        listPaddingOffset = 16,
        rowsToBeVisible = 2.5,
        scrollBarThickness = 7,
        anchorPoint = Vector2.new(0.5, 1),
        fillDirection = Enum.FillDirection.Vertical,
        padding = {
            all = UDim.new(0, 16)
        },
        position = UDim2.fromScale(0.5, 0.95),
        scrollBarColor = Color3.fromRGB(10, 10, 10),
        size = UDim2.fromScale(0.97, 0.85)
    }, v6)), react.createElement(default6, {
        activeTab = "vfx",
        onSelectTab = p1.onSelectTab
    }))
end

function RodShopVfxItem(p4) -- line: 69
    -- upvalues: react (copy), default (copy), default3 (copy), default4 (copy), v2 (copy), v3 (copy), v4 (copy)
    local data, isEquipped, layoutOrder, onEquip = p4.data, p4.isEquipped, p4.layoutOrder, p4.onEquip
    local onUnequip = p4.onUnequip

    return react.createElement(default, {
        cornerRadius = 0.01,
        isStudded = true,
        strokeThickness = 0.01,
        textureTransparency = 0.6,
        backgroundColor = Color3.fromRGB(75, 110, 150),
        layoutOrder = layoutOrder,
        strokeColor = Color3.fromRGB(35, 55, 85)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = data.imageId,
        Position = UDim2.fromScale(0.5, 0.4),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.8, 0.44)
    }), react.createElement(default3, {
        text = "Event-Only",
        color = Color3.fromRGB(255, 205, 45),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(0.42, 0.07),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        position = UDim2.fromScale(0.05, 0.02),
        strokeProps = {
            Thickness = 0.04
        }
    }), react.createElement(default3, {
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(0.86, 0.1)
        },
        position = UDim2.fromScale(0.07, 0.1),
        strokeProps = {
            Thickness = 0.04
        },
        text = data.displayName
    }), react.createElement(default3, {
        anchorPoint = Vector2.new(0.5, 0),
        color = Color3.fromRGB(220, 240, 255),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            Size = UDim2.fromScale(0.82, 0.1)
        },
        position = UDim2.fromScale(0.5, 0.64),
        strokeProps = {
            Thickness = 0.025
        },
        text = data.description
    }), react.createElement(default4, {
        anchorPoint = Vector2.new(0.5, 1),
        color = if not data.isOwned then v4 elseif isEquipped then v3 else v2,
        disabled = not data.isOwned,
        frameSize = UDim2.fromScale(0.5, 0.14),
        label = if not data.isOwned then "Unobtainable" elseif isEquipped then "Unequip" else "Equip",
        onClick = if not isEquipped then onEquip else onUnequip,
        position = UDim2.fromScale(0.5, 0.94)
    }))
end

return {
    default = RodShopVfx
}
